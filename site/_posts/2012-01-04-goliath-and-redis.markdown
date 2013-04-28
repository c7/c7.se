---
layout: article
title: Goliath and Redis
summary: Getting started with the non-blocking Ruby web server framework
         Goliath in combination with the advanced key-value store Redis.
---
I’ve been looking into using non-blocking web frameworks lately, and I started
out with the poster-child for this movement; [Node.js](http://nodejs.org/).
While Node is very nice (especially when combined with
[CoffeeScript](http://coffeescript.org/)), it has some *rough* edges.

I currently prefer to use [Ruby](http://ruby-lang.org/) on the server side,
and to keep my CoffeeScripts more towards the front end. (For example
with [Backbone.js](http://documentcloud.github.com/backbone/))

## Background

There are quite a few non-blocking Ruby web frameworks out there.
I’ve looked at three of them;
[Sinatra::Synchrony](http://kyledrake.net/sinatra-synchrony/),
[Goliath](http://goliath.io/) and [Cramp](http://cramp.in/).

I *REALLY* like the idea behind Sinatra::Synchrony, but it doesn’t seem
to be as “battle hardened” as Goliath. It also has some issues
with Ruby 1.9.3.

I’ve been thinking about using Goliath ever since I saw the presentation
[0-60 with Goliath: Building High Performance Ruby Web-Services
](http://www.slideshare.net/igrigorik/060-with-goliath-high-performance-web-services)
([video](http://confreaks.net/videos/653)) at Øredev 2011.

## Dependencies

Goliath, obviously.

Version 1.0 has been released, and I have taken the time 
to update this article with the relevant changes. One of the 
more notable changes are the removal of the built in router.
I think that was a good decision. Gone are the days when 
you needed to clone Goliath from 
[GitHub](https://github.com/postrank-labs/goliath) 
just to get a sane version.

I am also going to use the Ruby client library for 
[Redis](http://redis.io/), which has built in support for
[EM-Synchrony](https://github.com/igrigorik/em-synchrony).

### Gemfile

{% highlight ruby %}
source :rubygems

gem "goliath", "~> 1.0"
gem "hiredis", "~> 0.4"
gem "redis",   "~> 3.0",
    :require => ["redis/connection/synchrony", "redis"]

group :test do
  gem "em-http-request", "~> 1.0"
  gem "mock_redis", "~> 0.4"
end
{% endhighlight %}

## Testing

You didn’t think I would skip on the testing, right?

My personal favorite among the myriad of Ruby test frameworks is
[minitest](https://github.com/seattlerb/minitest)
*(The default test framework in Ruby 1.9)* and that is
what I’m going to use in this article.

### spec/spec_helper.rb

{% highlight ruby %}
require 'bundler'
Bundler.require

require 'minitest/spec'
require 'minitest/pride'
require 'minitest/autorun'
require 'goliath/test_helper'
require 'mock_redis'

$redis = MockRedis.new

class Goliath::Server
  def load_config(file = nil)
    config['redis'] = $redis
  end
end
{% endhighlight %}

### spec/api_spec.rb

I hope that writing specs for Goliath will become less verbose in the
future, currently it seems like I need to wrap each request in a
`with_api` block.

{% highlight ruby %}
require_relative 'spec_helper'
require_relative '../api'

describe Api do
  include Goliath::TestHelper

  it "responds to heartbeat" do
    with_api Api do
      get_request path: '/' do |api|
        api.response.must_equal 'OK'
      end
    end
  end

  it "can set and retrieve data" do
    with_api Api do
      get_request path: '/bar' do |api|
        api.response.must_equal ''
      end
    end

    with_api Api do
      put_request path: '/bar?value=foo' do |api|
        api.response.must_equal 'OK'
      end
    end

    with_api Api do
      get_request path: '/bar' do |api|
        api.response.must_equal 'foo'
      end
    end
  end
end
{% endhighlight %}

## The application

This is a _very_ simple API, it can only do three things:

 1. Respond with “OK” and status code 200 `GET /`
 2. Add new data `PUT /foo?value=bar`
 3. Retrieve a value `GET /foo`

### api.rb

{% highlight ruby %}
class Api < Goliath::API
  use Goliath::Rack::Params
  use Goliath::Rack::Heartbeat, path: '/'

  def response(env)
    key = "example_api:#{env['REQUEST_PATH']}"
    val = params['value'].to_a

    res = case env['REQUEST_METHOD']
      when 'GET' then redis.get key
      when 'PUT' then redis.set key, val
    end

    [200, {}, res]
  end
end
{% endhighlight %} 

## Starting the application

First you need to have a Redis server running.

The final two pieces of the puzzle is a `config.rb` that contains the connection to Redis via a
EM::Synchrony::ConnectionPool and a Goliath::Runner that takes care of running the application.

### config.rb

{% highlight ruby %}
config['redis'] = EM::Synchrony::ConnectionPool.new size: 2 do
  Redis.new
end
{% endhighlight %} 

### runner.rb

{% highlight ruby %}
require "bundler"
Bundler.require

require 'goliath/runner'
require_relative 'api'

runner = Goliath::Runner.new(ARGV, nil)
runner.api = Api.new
runner.app = Goliath::Rack::Builder.build(Api, runner.api)
runner.run
{% endhighlight %}


Run `ruby runner.rb -s -e prod -c config.rb` and a server should spin up in production mode on port 9000.

## Using the application

I like to use [cURL](http://curl.haxx.se/) when manually testing API's:

### Adding a new key/value pair

{% highlight ruby %}
curl -X PUT http://0.0.0.0:9000/foo -d "value=bar"
{% endhighlight %}

### Retrieve a stored value

{% highlight ruby %}
curl -X GET http://0.0.0.0:9000/foo
{% endhighlight %}
