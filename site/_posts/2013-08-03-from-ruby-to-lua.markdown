---
layout: article
title: From Ruby to Lua
summary: Getting to know Lua, a powerful, fast, lightweight, scripting language.
--- 

I’ve been meaning to take a closer look at [Lua](http://lua.org/) for quite
some time now. It is described as a proven, robust programming language that is
also considered to be **fast**, **portable**, **embeddable**, **powerful**
(but simple), **small** and **free**.

_Sounds good to me._

## Installation

If you are using **OS X** and have [Homebrew](http://mxcl.github.io/homebrew/) 
installed, then you can install Lua like this:

{% highlight bash %}
$ brew install lua
{% endhighlight %}

Ubuntu users should install the 
[lua5.1](http://packages.ubuntu.com/raring/lua5.1) package.

Stuck on Windows? Then you’ll probably want to install
[Lua for Windows](https://code.google.com/p/luaforwindows/).

### Package manager

The package manager for Lua is called [Luarocks](http://luarocks.org/).

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
 - Functions may return multiple results
 - Function calls require parentheses `()`
 - There is a length operator `#`
 - No interpolation of variables inside strings…
   but you are welcome to [fix that](http://lua-users.org/wiki/StringInterpolation)
 - Variables are global by default, unless they are declared as `local`
 - Lua array indices [count from one](http://lua-users.org/wiki/CountingFromOne)
 - No implicit returns :(

## Syntax

As it is customary, let’s start with a
[Hello World program](http://en.wikipedia.org/wiki/Hello_world_program).

{% highlight lua %}
print("hello world")
{% endhighlight %}

Ok, how about some examples of Lua syntax?

### Function definition

{% highlight lua %}
function f(para1, para2)
  -- code
end
{% endhighlight %}

### Anonymous function

{% highlight lua %}
var = function(param)
  -- code
end
{% endhighlight %}

### The type function gives the datatype name of a given value

{% highlight lua %}
print(type("dragonfruit")) -- returns "string"
print(type(3.5))           -- returns "number"
{% endhighlight %}

## A few projects based on Lua

### [MoonScript](http://moonscript.org/)

A dynamic scripting language that compiles into Lua. 
It gives you the power of one of the fastest scripting 
languages combined with a rich set of features.

### [Codea](http://twolivesleft.com/Codea/)

A pretty cool development environment for the iPad, built on top of Lua.

### [Redis](http://redis.io)

Yes, that is right… you can [EVAL](http://redis.io/commands/eval) 
Lua code in Redis since version 2.6.0.
You might want to read the article [Lua: A Guide for Redis Users](http://www.redisgreen.net/blog/2013/03/18/intro-to-lua-for-redis-programmers/)

There is also a lot of games using Lua for 
[scripting](http://en.wikipedia.org/wiki/Category:Lua-scripted_video_games)

## Learn more

 - [Lua Unofficial FAQ (uFAQ)](http://www.luafaq.org/)
 - [Lua-Users Wiki](http://lua-users.org/wiki/)
 - [Lua Programming](http://en.wikibooks.org/wiki/Category:Lua_Programming)
