---
type: article
date: 2013-04-17
url: /intro-to-celluloid/
title: Intro to Celluloid
summary: A framework used for concurrent object oriented programming in Ruby.
---

I’ve been using the wonderful [Sidekiq](http://sidekiq.org/) project for
a while now, and I thought it would be a good time to take a closer look at
[Celluloid](http://celluloid.io/).

## What is it?

> Celluloid is a concurrent object oriented programming framework for Ruby
> which lets you build multithreaded programs out of concurrent objects
> just as easily as you build sequential programs out of regular objects

In other words, Celluloid is the concurrency framework that allows Sidekiq
to do its magic. The *(not so)* secret sauce, if you will.

## Installation

We just need to install the gem:

```bash
$ gem install celluloid
```

*There is an issue when using [JRuby](http://jruby.org/) **1.7.3**,
so you are better off with **1.7.2** or MRI **1.9.3**/**2.0.0***

## So how does it work then?

The most popular library for concurrency in Ruby is
*(or used to be at least)*
[EventMachine](https://github.com/eventmachine/eventmachine) which is designed
according to the [Reactor pattern](http://en.wikipedia.org/wiki/Reactor_pattern),
much like [Node.js](http://nodejs.org/) and [Twisted](http://twistedmatrix.com/).

Celluloid on the other hand is built on the
[Actor model](http://en.wikipedia.org/wiki/Actor_model) as seen in
[Erlang](http://www.erlang.org/) and [Akka](http://akka.io/) (on the JVM).
The choosen design allows for some pretty nice features:

### No deadlocks

Each actor is running in its own thread, and each method call is wrapped
in a fiber that can be paused when calling out to other actors and than
started again when the response becomes available.

### Have you tried turning it off and on again?

Celluloid takes care of restarting parts of your application if/when they crash.
Each actor will be rebooted to a clean state. There is Erlang-esque support for
[linking](https://github.com/celluloid/celluloid/wiki/Linking),
[supervisors](https://github.com/celluloid/celluloid/wiki/Supervisors), and
[supervision groups](https://github.com/celluloid/celluloid/wiki/Supervision-Groups).

### Futures

You’ll find it trivial to call methods on actors “in the background” and
then retrieve the results at a later time. It is also possible to send the
computation of any block to the background:

```ruby
require 'celluloid'

future = Celluloid::Future.new {
  (sleep 5) * 2
}

# Do something else for a while…

puts future.value
```

**Note:** The call to `future.value` will block until those initial 5 seconds are up.

## Supporting cast

You need to `require 'celluloid/autostart'` in order to automatically start
support actors and configure the at_exit handler to automatically
terminate all actors when halting the program.

**Note:** This is quite important since actors won’t be garbage collected
unless you call `actor.terminate` *(Generally not needed for test scripts
though, since they tend to be short lived anyway)*
You can also automate this with
[Linking](https://github.com/celluloid/celluloid/wiki/Linking).

## The ecosystem

Celluloid also has a number of subprojects that solve a few *(specific)* problems:

 * ### [Celluloid::IO](https://github.com/celluloid/celluloid-io)
   Evented I/O for Celluloid actors.
   *(It tries to give you the best of two worlds)*

 * ### [DCell](https://github.com/celluloid/dcell)
   Distributed systems with Celluloid that talk over the
   [0MQ](http://zeromq.org/) protocol.

 * ### [Reel](https://github.com/celluloid/reel)
   Reel is a fast, non-blocking evented web server.

## Learn more about Celluloid

The project has a very good
[README](https://github.com/celluloid/celluloid/blob/master/README.md)
and a [Wiki](https://github.com/celluloid/celluloid/wiki) where you will
find the answer to most of your questions.
There is also #celluloid on [freenode](http://freenode.net/) if you want
to talk to other developers using Celluloid.
