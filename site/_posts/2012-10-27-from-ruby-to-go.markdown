---
layout: article
title: From Ruby to Go
summary: Getting to know Go, a fun little language from Google.
---
I’m not planning on leaving the lovely 
[Ruby](http://www.ruby-lang.org/en/) ecosystem anytime soon, 
but it is always nice to peek over the fence to other languages 
once in a while.

I’ve decided to spend a weekend playing with [Go](http://golang.org/).

## Background

Go is a compiled, garbage-collected, concurrent programming 
language developed by [Google](https://google.com/).

## Getting started

You don’t even have to install Go to start experimenting with it.

The web site has a neat interactive [Tour of Go](http://tour.golang.org/) 
and there is also the [Go Playground](http://play.golang.org/), a web 
service that receives a Go program, compiles, links, and runs 
the program inside a sandbox, then returns the output.
(A little bit like [Try Ruby](http://tryruby.org/))

## Install

Go is available from [Homebrew](http://mxcl.github.com/homebrew/) with a
quick `brew install go`

You can also install Go manually by downloading the package for your OS from
the [official downloads page](http://code.google.com/p/go/downloads/list).

### Vim configuration

A vim syntax file is included in the Go distribution under misc/vim/

To use all the Vim plugins, add these lines to your vimrc:

    set rtp+=$GOROOT/misc/vim
    filetype plugin indent on
    syntax on

I installed Go using Homebrew so my `$GOROOT` is `/usr/local/Cellar/go/1.0.3`

## Hello World

Let’s write the canonical getting started program, Hello world, in the
file `hello_world.go`

```go
package main
    
import "fmt"

func main() {
    fmt.Println("hej världen!")
}
```

You can run this with `go run`:

```bash
$ go run hello_world.go
hej världen!
```

You can also run `go get` to compile the program 
into a stand alone binary.

```bash
$ go get
$ ./hello_world
hej världen!
```

## A simple Web application

Time for something a bit more interesting. Go was originally designed
with networking in mind, and that means that writing web applications
is fairly straight forward.

I was looking around for something similar to 
[Sinatra](http://www.sinatrarb.com/) and found 
[pat](https://github.com/bmizerany/pat) 
by [Blake Mizerany](https://twitter.com/bmizerany)
(The original author of Sinatra)

> Pat is a Sinatra style pattern muxer for Go's net/http library.

```go
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
```

## Go on Heroku

It is possible to deploy Go applications on [Heroku](http://www.heroku.com/) 
thanks to the [Go Buildpack](https://github.com/kr/heroku-buildpack-go).

I’m not going to go into details about this since 
[Mark McGranaghan](https://twitter.com/mmcgrana) has written a 
[very good blog post](http://mmcgrana.github.com/2012/09/getting-started-with-go-on-heroku.html)
about this.

## Learn more about Go

 - [Go package documentation](http://golang.org/pkg/)
 - [Go talks](http://talks.golang.org/) (Check out the one from SPLASH 2012)
 - [Go Language Community Wiki](http://code.google.com/p/go-wiki/w/list)
 - [Go by Example](https://gobyexample.com/), a hands-on 
   introduction to Go using annotated example programs.

### Screencasts
 
 - [A video tour of Go](http://www.youtube.com/watch?v=ytEkHepK08c)
 - [Writing, building, installing, and testing Go code](http://www.youtube.com/watch?v=XCsL89YtqCs)
