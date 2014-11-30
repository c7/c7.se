---
type: article
date: 2013-08-03
url: /from-ruby-to-lua/
title: From Ruby to Lua
summary: Getting to know Lua, a powerful, fast, lightweight, scripting language.
---

I’ve been meaning to take a closer look at [Lua](http://lua.org/) for quite
some time now. It has been described as a proven, robust programming language
that is considered to be **fast**, **portable**, **embeddable**,
**powerful** (but simple), **small** and **free**.

_Sounds good to me._

## Similarities with Ruby

Let’s start off by listing some of the
characteristics shared between Ruby and Lua:

 - Dynamic type system
 - Closures
 - Non-significant whitespace
 - The use of **nil** to represent null values
 - All values are **true**, except **nil** and **false**
 - Created in 1993

## How is it different from Ruby?

A lot of things differ between the two languages, here are a few of them:

 - Out of the box, Lua does not have a class system…
   but you are welcome to [write one](http://lua-users.org/wiki/SimpleLuaClasses)
 - Comments begin with `--` instead of `#` (Like in Ada, Eiffel, Haskell and SQL)
 - Concatenation is done with `..` instead of `+`
 - Functions may return multiple return values
   (Like in [Go](http://golang.org/doc/effective_go.html#multiple-returns))
 - Function calls require parentheses `()`<br>
   *(Unless the function takes a single argument that is either a string or a table)*
 - There is a length operator `#`
 - No interpolation of variables inside strings…
 - The existing string libraries assume single-byte characters :(
   but you can [fix that](http://lua-users.org/wiki/StringInterpolation), sort of
 - Variables are global by default, unless they are declared as `local`
 - Lua array indices [count from one](http://lua-users.org/wiki/CountingFromOne)
 - [Proper Tail Calls](http://www.lua.org/pil/6.3.html) are supported.
 - No implicit returns :(

**NOTE:**
<br>
MRI supports Tail Call Optimization if you change **:tailcall_optimization** to **true**
in the compile options for **RubyVM::InstructionSequence**.
This is unfortunately not part of the Ruby spec.

## Installing Lua

If you are using **OS X** and have [Homebrew](http://brew.sh/)
installed, then you can install Lua like this:

```bash
$ brew install lua
```

Ubuntu users should install the
[lua5.1](http://packages.ubuntu.com/raring/lua5.1) package.
<br>
_(5.2 is the latest version, but it seems like there
are compatibility issues with it and LuaRocks, YMMV)_

Stuck on Windows? Then you’ll probably want to install
[Lua for Windows](https://code.google.com/p/luaforwindows/).

### Package manager

In Ruby land we have the wonderful [RubyGems](http://rubygems.org/).
The Lua counterpart is called [LuaRocks](http://luarocks.org/)
and it seems pretty neat.

## Syntax

As is customary, let’s start with a
[Hello World program](http://en.wikipedia.org/wiki/Hello_world_program):

```lua
print("Hello World")
```

Nothing too surprising really. _(You don’t strictly need the
parentheses in this contrived example)_

### Variables and Blocks

Variables in Lua are global by default, but you can make them local to the current scope by prepending `local` like this:

```lua
do
  local answer = 42
  print("The answer to everything is: " .. answer)
end

print(type(answer)) -- nil
```

> Unlike global variables, [local variables](http://www.lua.org/pil/4.2.html)
have their scope limited to the block where they are declared.

A block in Lua creates a new scope.

### Function definition

Defining a function in Lua is pretty straight forward,
just as long as you remember to write `function` instead of `def` :)

```lua
function f(para1, para2)
  -- code
end
```

### Anonymous functions

Unfortunately, anonymous functions in Lua is a bit unwieldy,
I’d really like something similar to the lambda literal
([stabby lambda](http://railspikes.com/2008/9/8/lambda-in-ruby-1-9)) in Ruby.

```lua
var = function(param)
  -- code
end
```

### Conditional expressions

C-style conditional expressions are not supported, but you can
use `and/or` to emulate this.

```lua
function example(check)
  print(check and 'foo' or 'bar')
end

example(true) -- "foo" since check is truthy
example()     -- "bar" since check is nil
```

### Built in functions

Lua has some built in functions that are available from the top level scope, a few of them are:

#### The type function gives the datatype name of a given value

```lua
print(type("dragonfruit")) -- "string"
print(type(3.5))           -- "number"
```

#### \# gives you the size of a string, list, etc.

```lua
print(#{1,2,3}) -- 3
print(#"a str") -- 5
```

### The loadstring function allows you to evaluate a string
I’m not sure if you ever want to do this.

```lua
loadstring('print("result: " .. 1+1)')() -- "result: 2"
```

## Let’s write a small script using the [Penlight Lua Libraries](https://github.com/stevedonovan/Penlight)

First we need to install Penlight:

```bash
$ luarocks install penlight
```

Now we are ready to write our little example script.
<br>
_(Based on the uFAQ section [2.2 How to Parse command-Line arguments?](http://www.luafaq.org/#T2.2))_

**scale.lua**
```lua
#!/usr/bin/env lua

require 'luarocks.loader'

-- require is now aware of LuaRocks
require 'pl'

-- configure the Lapp Framework options parser
local args = lapp [[
Does some calculations
  -o,--offset (default 0.0)  Offset to add to scaled number
  -s,--scale  (number)  Scaling factor
   <number> (number )  Number to be scaled
]]

print(args.offset + args.scale * args.number)
```

The script requires the LuaRocks loader, loads the Penlight rock,
configures the [Lapp](http://lua-users.org/wiki/LappFramework)
options parser, and finally it prints the result of the
calculation `offset + scale * number`

```bash
$ lua scale.lua -o 5 --scale=10 20
205
```

## A few projects based on Lua

### [MoonScript](http://moonscript.org/)

A dynamic scripting language that compiles into Lua.
It gives you the power of one of the fastest scripting
languages combined with a rich set of features.

### [LuaJIT](http://luajit.org/luajit.html)

LuaJIT is a Just-In-Time Compiler (**JIT**) for the Lua programming language.

### [Busted](http://olivinelabs.com/busted/)

Busted is a unit testing framework with a focus on being easy to use.
Busted works with **Lua** >= 5.1, **MoonScript**, and **LuaJIT** >= 2.0.0

### [Codea](http://twolivesleft.com/Codea/)

A pretty cool development environment for the iPad, built on top of Lua.

### [Redis](http://redis.io)

Yes, that is right… you can [EVAL](http://redis.io/commands/eval)
Lua code in Redis since version 2.6.0.
You might want to read the article [Lua: A Guide for Redis Users](http://www.redisgreen.net/blog/2013/03/18/intro-to-lua-for-redis-programmers/)

### [Try Lua](http://trylua.org/)

An online [REPL](http://en.wikipedia.org/wiki/REPL) for Lua.

### Games

There is also a lot of games using Lua for
[scripting](http://en.wikipedia.org/wiki/Category:Lua-scripted_video_games)

## Learn more about Lua

 - [Lua Unofficial FAQ (uFAQ)](http://www.luafaq.org/)
 - [Lua-Users Wiki](http://lua-users.org/wiki/)
 - [Lua Programming](http://en.wikibooks.org/wiki/Category:Lua_Programming)
 - [Lua 5.1 Reference Manual](http://www.lua.org/manual/5.1/manual.html)
 - [Syntax across languages per language: Lua](http://rigaux.org/language-study/syntax-across-languages-per-language/Lua.html)
 - [Learn Lua in 15 Minutes](http://tylerneylon.com/a/learn-lua/) (more or less)
