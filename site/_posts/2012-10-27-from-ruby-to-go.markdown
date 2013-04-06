---
layout: article
title: From Ruby to Go
summary: Getting to know Go, a fun little language from Google.
---
I’m not planning on leaving the lovely 
[Ruby](http://www.ruby-lang.org/en/) ecosystem anytime soon, 
but it is always nice to peek over the fence to other 
programming languages once in a while.

I’ve now decided to take a closer look at [Go](http://golang.org/).

## How is it different from Ruby?

Go is *VERY* different from Ruby, but these are some of the
highlights:

 - Go is a statically typed, compiled language.
 - Go has Pascal/Modula-style syntax: name before type.
 - Go does not have classes or subtype inheritance.
 - Go does not support default function arguments.
 - Go has no try-catch control structures for exceptions.
 - Enforced (automatic) code formatting via the [gofmt](http://golang.org/cmd/gofmt/) tool.
 - Functions in Go can return multiple values.
 - Export syntax (upper case initial letter for public method names)
 - Concurrency via [CSP](http://en.wikipedia.org/wiki/Communicating_sequential_processes)

## Background

Go is a compiled, garbage-collected, concurrent programming 
language developed by Google. The initial design of Go was started in September 2007 by Robert Griesemer, Rob Pike, 
and Ken Thompson.

## Getting started

*You don’t even have to install Go to start experimenting with it.*

The web site has a neat interactive [Tour of Go](http://tour.golang.org/) 
and there is also the [Go Playground](http://play.golang.org/), a web 
service that receives a Go program, compiles, links, and runs 
the program inside a sandbox, then returns the output.
(A little bit like [Try Ruby](http://tryruby.org/))

## Installing Go

Go is available from [Homebrew](http://mxcl.github.com/homebrew/)

{% highlight bash %}
$ brew install go
{% endhighlight %}

You can also install Go by downloading it from 
the [official downloads page](http://code.google.com/p/go/downloads/list).

### Vim configuration

A vim syntax file is included in the Go distribution under `misc/vim/`

To use all the Vim plugins, add these lines to your vimrc:

{% highlight vim %}
set rtp+=$GOROOT/misc/vim
filetype plugin indent on
syntax on
{% endhighlight %}

I installed Go using Homebrew so my `$GOROOT` is `/usr/local/Cellar/go/1.0.3`

## Examples

### Hello World

Let’s write the canonical getting started program, Hello world!

#### hello_world.go

{% highlight go %}
package main
    
import "fmt"

func main() {
    fmt.Println("hej världen!")
}
{% endhighlight %}

You use `go run` to run the program:

{% highlight bash %}
$ go run hello_world.go
hej världen!
{% endhighlight %}

You can also use `go get` to compile the 
program into a stand alone excecutable:

{% highlight bash %}
$ go get
$ ./hello_world
hej världen!
{% endhighlight %}

(This requires your code to be located in its own directory)

### A simple Web application

Time for something a bit more interesting. The language 
was originally designed with networking in mind, that 
means it is fairly straight forward to write web applications in Go.

I was looking around for something similar to 
[Sinatra](http://www.sinatrarb.com/) and found 
[pat](https://github.com/bmizerany/pat) 
by [Blake Mizerany](https://twitter.com/bmizerany)
(The original author of Sinatra)

> Pat is a Sinatra style pattern muxer for Go's net/http library.

#### hello_pat.go 
{% highlight go %}
package main

import (
  "io"
  "net/http"
  "github.com/bmizerany/pat"
)

func HelloServer(w http.ResponseWriter, req *http.Request) {
  io.WriteString(w, "hej, "+req.URL.Query().Get(":name")+"!\n")
}

func main() {
  m := pat.New()
  m.Get("/hello/:name", http.HandlerFunc(HelloServer))

  http.Handle("/", m)
  http.ListenAndServe(":12345", nil)
}
{% endhighlight %}

## Deploying Go on Heroku

You can deploy Go applications on [Heroku](http://www.heroku.com/) 
thanks to the [Go
Buildpack](https://github.com/kr/heroku-buildpack-go), but I’m not going to go into details about this since 
Mark McGranaghan wrote a 
[very good blog post](http://mmcgrana.github.com/2012/09/getting-started-with-go-on-heroku.html)
on this very subject.

## Learn more about Go

 - [Go package documentation](http://golang.org/pkg/)
 - [Go talks](http://talks.golang.org/) (Check out the one from SPLASH 2012)
 - [Go Language Community Wiki](http://code.google.com/p/go-wiki/w/list)
 - [Go by Example](https://gobyexample.com/), a hands-on 
   introduction using annotated examples.
 - [A video tour of Go](http://www.youtube.com/watch?v=ytEkHepK08c)
 - [Writing, building, installing, and testing Go code](http://www.youtube.com/watch?v=XCsL89YtqCs)
