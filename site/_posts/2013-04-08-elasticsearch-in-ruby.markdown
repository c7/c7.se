---
layout: article
title: Elasticsearch in Ruby
summary: A tiny project using the search engine elasticsearch in Ruby.
---

I’m going to write about getting started with elasticsearch by doing a
small project in Ruby. But what **is** this elasticsearch you say?

> elasticsearch is a flexible and powerful open source, 
> distributed real-time search and analytics engine for the cloud.

That pretty much sums it up. There is also a really good overview of the 
project on [elasticsearch.org/overview](http://www.elasticsearch.org/overview/)

## Installing elasticsearch

Elasticsearch is available from [Homebrew](http://mxcl.github.io/homebrew/)

{% highlight bash %}
$ brew install elasticsearch
{% endhighlight %}

The current version of elasticsearch is `0.20.6` as of this writing.

### [elasticsearch-head](http://mobz.github.io/elasticsearch-head/)

A nice little HTML5 front end for elasticsearch. Lets install it!

(Not using Homebrew? Replace the string in backticks with the path to the elasticsearch plugin binary)

{% highlight bash %}
`brew list elasticsearch|grep -m1 plugin` \
        -install mobz/elasticsearch-head
{% endhighlight %}

## Ruby and libraries for elasticsearch

I’m going to use Ruby 2.0.0 but 1.9.3 should also work (with some minor
changes).

### [Stretcher](https://github.com/PoseBiz/stretcher)

The most popular RubyGems for talking to elasticsearch seems to be 
[Tire](https://rubygems.org/gems/tire) and 
[RubberBand](https://rubygems.org/gems/rubberband), but
I’m going to use [Stretcher](https://rubygems.org/gems/stretcher)
just for the fun of it.

Stretcher is designed to reflect the actual elastic search API as closely 
as possible, so you’ll be fine by looking directly at the elasticsearch 
[query-dsl](http://www.elasticsearch.org/guide/reference/query-dsl/).

{% highlight bash %}
$ gem install stretcher
{% endhighlight %}

Now we’ll start elasticsearch (in the foreground)

{% highlight bash %}
$ elasticsearch -f
{% endhighlight %}

## Dataset

We obviously need some data to search through. I’m going to use a dump 
of my tweets, retrieved from _Your Twitter archive_ on the
Twitter [settings page](https://twitter.com/settings/).

## Importing the data using Ruby

You would probably want to use something like the the 
[CSV River Plugin](https://github.com/xxBedy/elasticsearch-river-csv) in
production.

I’ll just write a short import script using Ruby and the stretcher gem:

### tweet_importer.rb
{% highlight ruby %}
#!/usr/bin/env ruby
require 'csv'
require 'stretcher'

# Make sure we have piped some data to the script
if STDIN.tty?
  puts 'unzip -p tweets.zip tweets.csv | ./tweet_importer.rb'
  exit
end

# Connect to elasticsearch
es = Stretcher::Server.new('http://localhost:9200')

# Delete the tweets index if it exists
es.index(:tweets).delete if es.index(:tweets).exists?

# Bulk index the tweet documents
es.index(:tweets).bulk_index [].tap { |docs|
  # Parse the CSV data from STDIN
  CSV.parse(STDIN.read, headers: true) do |row|
    docs << row.to_hash.merge({
      '_type' => 'tweet',
      '_id'   => row['tweet_id']
    })
  end
} 
{% endhighlight %}

Now lets import the tweets:

{% highlight bash %}
$ unzip -p tweets.zip tweets.csv | ./tweet_importer.rb
{% endhighlight %}

If everything went well, then you should be able to query the index
using elasticsearch-head over at <http://localhost:9200/_plugin/head/>

## Ok, what now?

Lets write a small web application that lets you find tweets matching a
certain word. We’ll use the template language [Slim](http://slim-lang.com/) 
and the web framework [Sinatra](http://www.sinatrarb.com/).

Lets start by installing them:

{% highlight bash %}
$ gem install sinatra slim
{% endhighlight %}

Now we are ready to write our little app.

### tweet_search.rb
{% highlight ruby %}
require 'slim'
require 'sinatra'
require 'stretcher'

configure do
  ES = Stretcher::Server.new('http://localhost:9200')
end

class Tweets
  def self.match(text: 'elasticsearch', size: 1000)
    ES.index(:tweets).search size: size, query: {
      match: { text: text }
    }
  end
end

get "/" do
  redirect "/elasticsearch"
end

get "/:word" do
  slim :index, locals: {
    tweets: Tweets.match(text: params[:word])
  }
end

__END__
@@ layout
doctype html
html
  body== yield

@@ index
h1= "#{tweets.total} tweets matching “#{params[:word]}”"
ul
  - tweets.results.each do |tweet|
    li= tweet.text
{% endhighlight %}

Now you just need to start the app:

{% highlight bash %}
$ ruby tweet_search.rb
== Sinatra/1.4.2 has taken the stage on 4567
for development with backup from Thin
>> Thin web server (v1.5.0 codename Knife)
>> Maximum connections set to 1024
>> Listening on localhost:4567, CTRL+C to stop
{% endhighlight %}

Open your browser and go to <http://localhost:4567/>
