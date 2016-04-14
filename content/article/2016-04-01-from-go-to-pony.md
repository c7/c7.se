---
type: article
date: 2016-04-01
url: /from-go-to-pony/
title: From Go to Pony
summary: Getting to know Pony, an open-source, object-oriented, actor-model, capabilities-secure, high performance programming language.
---

At QCon London 2016 I saw a presentation on [Pony](http://www.ponylang.org/)
and my interest was peaked enough to take a closer look at the language.
In this article I will try to contrast Pony against my current favorite language, [Go](https://golang.org/).
_(I will leave it to others to compare Pony with Erlang or Elixir)_

## Similarities with Go

Let’s start off by listing some of the
characteristics shared between Go and Pony:

  - Ahead-of-time (AOT) compiled
  - Composition over inheritance
  - Garbage collected
  - Hard to Google
  - Inherent build system
  - Open Source
  - Statically typed
  - Structurally typed interfaces

## How is it different from Go?

  - Actor based concurrency (Mailboxes!)
  - Algebraic type expressions (Union types!)
  - Classes (composed of fields, constructors, and functions)
  - Default argument values
  - Erlang style Pattern Matching
  - Expressions with more than one infix operator must use parentheses to remove the ambiguity
  - Fully concurrent GC with no stop-the-world or sweep phase (Go GC is [concurrent since 1.5](https://golang.org/doc/go1.5#gc))
  - Generics
  - Implicit return values (last expression)
  - `let` in addition to `var`
  - No `null` (but it has a `None` type)
  - No deadlocks (since there are no locks at all)
  - No global variables (Go has package global variables)
  - Not possible to have data-races (ensured by the compiler)
  - User defined primitive types (like a class, but has no fields and there is only one instance)
  - Statements _are_ expressions
  - Syntactically significant indentation
  - Three kinds of type expressions: tuples, unions, and intersections
  - Trait system (similar to Java 8 interfaces that can have default implementations)
  - Type annotations to indicate capabilities (Rcaps)
  - Type aliases (enumerations, complex types)
  - ~zero overhead when calling out to C

## Installing Pony

If you are using **OS X** and have [Homebrew](http://brew.sh/)
installed, then you can install Pony like this:

```bash
$ brew install ponyc
```

The current version of `ponyc` as of this writing is **0.2.1**.

Make sure you also get the [pony-vim-syntax](https://github.com/dleonard0/pony-vim-syntax).

## Hello, World!

The entry point of a Pony binary is the `Main` actor. The binary is named after the directory, just like how it works in Go.

**ponyhello/main.pony**
```ruby
actor Main
  new create(env: Env) =>
    env.out.print("Hello, World!")
```

And as you probably know, the Go entry point is the `main` func.

**gohello/main.go**
```go
package main

import "fmt"

func main() {
	fmt.Println("Hello, World!")
}
```

## Actors

The concurrency in Pony is based on [Actors](https://en.wikipedia.org/wiki/Actor_model), just like in [Erlang](http://www.erlang.org/).
Actors in Pony can, unlike classes, have **behaviours** _(asynchronous methods)_

Behaviours are asynchronous, but actors themselves are sequential. Actors will only execute a single behaviour at the same time.

## Classes

A class in Pony can have multiple named constructors.
Every constructor has to set every field in an object.

The underscore (`_`) is used to make something private in Pony.
_(Exported identifiers in Go start with a upper case letter)_

**mascot/main.pony**
```ruby
actor Main
  let mascot: Mascot

  new create(env: Env) =>
    mascot = Mascot("Go gopher")

    env.out.print(mascot.message())

class Mascot
  let _name: String

  new create(name: String) =>
    _name = name

  fun message(): String =>
    "The " + _name + " is the best mascot!"
```

## Learn more about Pony

  - [Pony Language](http://www.ponylang.org/)
  - [Pony Tutorial](http://tutorial.ponylang.org/)
  - [Pony Compiler](https://github.com/ponylang/ponyc)
  - [Deny Capabilities for Safe, Fast Actors](http://blog.acolyer.org/2016/02/17/deny-capabilities/)
  - [My Little Pony - Codemesh 2015](https://cdn.rawgit.com/darach/my_little_pony/master/my-little-pony.html#/0/1)

## Bonus: Linking to the shared library from the article [Go and Ruby-FFI](/go-and-ruby-ffi/)

Pony includes a really nice C FFI library and this is an example of how you can use it:

```ruby
use "path:."
use "lib:sum"

use @add[I64](a: I64, b: I64)

actor Main
  new create(env: Env) =>
    env.out.print("4+8 = " + @add(4,8).string())
```

Then you just need to compile your binary by calling `ponyc`
