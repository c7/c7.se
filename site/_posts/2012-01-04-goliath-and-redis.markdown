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

Goliath is a young project, and it seems like most people use it straight
from the master branch on GitHub, and so will I. *(NOTE: My workaround 
for MiniTest does not work with Goliath 0.9.4)*

I am also going to use the Ruby client library for [Redis](http://redis.io/),
which has built in support for
[EM-Synchrony](https://github.com/igrigorik/em-synchrony).

### Gemfile

{% highlight ruby %}
source :rubygems

gem "goliath",
    :git => "https://github.com/postrank-labs/goliath.git",
    :require => ["goliath/api", "log4r"]

gem "hiredis", "~> 0.3.1"
gem "redis",   "~> 2.2.2",
    :require => ["redis/connection/synchrony", "redis"]

group :test do
  gem "em-http-request", "~> 1.0.1"
  gem "mock_redis", "~> 0.3.0"
end
{% endhighlight %}

## Testing

You didn’t think I would skip on the testing, right?

My personal favorite among the myriad of Ruby test frameworks is
[minitest](https://github.com/seattlerb/minitest)
*(The default test framework in Ruby 1.9)* and that is
what I’m going to use in this article.

I have managed to cobble together a `spec/spec_helper.rb` that makes it
possible to test Goliath using minitest/spec.
*(The tests for Goliath applications I’ve seen so far all use RSpec)*

### spec/spec_helper.rb

{% highlight ruby %}
require 'bundler'

Bundler.setup
Bundler.require

require 'goliath/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'mock_redis'

$redis = MockRedis.new

class Goliath::Server
  def load_config(file = nil)
    config['redis'] = $redis
  end
end

module Goliath
  module TestHelper
    def test_request(request_data = nil)
      return if request_data.nil?
      path = request_data.delete(:path) || ''
      EM::HttpRequest.new("http://localhost:#{@test_server_port}#{path}")
    end
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
    with_api Api, { log_stdout: false } do
      get_request path: '/' do |api|
        api.response.must_equal 'OK'
      end
    end
  end

  it "can set and retrieve data" do
    with_api Api, { log_stdout: false } do
      get_request path: '/foo' do |api|
        api.response.must_equal ''
      end
    end

    with_api Api, { log_stdout: false } do
      put_request path: '/foo?value=bar' do |api|
        api.response.must_equal 'OK'
      end
    end

    with_api Api, { log_stdout: false } do
      get_request path: '/foo' do |api|
        api.response.must_equal 'bar'
      end
    end
  end
end
{% endhighlight %}

## The application

This is a _very_ simple API, it can only do three things:

 1. Respond with “OK” and status code 200 `GET /`
 2. Add new data `PUT /foo?value=bar`
 3. Retrieve a value `GET /bar`

### api.rb

{% highlight ruby %}
require 'goliath/api'

class GetData < Goliath::API
  def response(env)
    [200, {}, redis.get('example_api:' + params[:key])]
  end
end

class SetData < Goliath::API
  use Goliath::Rack::Validation::RequiredParam, key: 'value'

  def response(env)
    [200, {}, redis.set('example_api:' + params[:key], params['value'])]
  end
end

class Api < Goliath::API
  use Goliath::Rack::Heartbeat, path: '/'
  put '/:key', SetData
  get '/:key', GetData
end
{% endhighlight %} 

## Starting the application

First you need to have a Redis server running.

The final two pieces of the puzzle is a Goliath::Runner that takes care of running the application and a `config.rb` that contains the connection to Redis via a EM::Synchrony::ConnectionPool.

### runner.rb

{% highlight ruby %}
require "bundler"

Bundler.setup
Bundler.require

require 'goliath/runner'
require_relative 'api'

runner = Goliath::Runner.new(ARGV, nil)
runner.api = Api.new
runner.app = Goliath::Rack::Builder.build(Api, runner.api)
runner.run
{% endhighlight %}

### config.rb

{% highlight ruby %}
config['redis'] = EM::Synchrony::ConnectionPool.new(size: 2) do
  Redis.new
end
{% endhighlight %} 

#### Run `ruby runner.rb -s -e prod -c config.rb` and a server should spin up in production mode on port 9000.

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
