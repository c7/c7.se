---
layout: article
title: From Ruby to Lisp
summary: My first steps as a Ruby developer towards learning Lisp.
---
For more than a decade now, I have been paid to do what I love, write code.
During all this time I’ve been using quite a few different languages 
and web frameworks.

[Ruby](http://ruby-lang.org/) has been my favorite language for many years now, 
and before that my two main programming languages were [PHP](http://php.net/)
and [Perl](http://perl.org/).

Also, due to me being a web developer, I use JavaScript all the time.
(I ❤ [CoffeeScript](http://coffeescript.org/))

I’ve been thinking about learning a functional programming language for 
quite some time now and I started out with [Erlang](http://www.erlang.org/) 
but I could never wrap my head around the syntax.

And then, out of the blue, a friend of mine told me about the book 
“[Land of Lisp](http://landoflisp.com/)” and how it would change my life…
*OK, slight exaggeration.*

## Background

The name Lisp derives from “LISt Processing”.
Linked lists are one of Lisp languages' major data structures, 
and Lisp source code is itself made up of lists.

The first version of Lisp was released in 1958, some **35 years** before
the initial release of Ruby. It was introduced in the era of FORTRAN
and COBOL.

Since then, a myriad of Lisp dialects have surfaced.
The most popular general purpose Lisp dialects seems to be; 
[Common Lisp](http://common-lisp.net/),
[Scheme](http://schemers.org/) and
[Clojure](http://clojure.org/).

## Land of Lisp

With its eye-catching subtitle *Learn to Program in Lisp, One Game at a Time!*
you immediately get the feeling that this isn’t your normal, run-of-the-mill 
programming book. And it turns out to be something completely different.

*(Hint: It’s a comic book in the same vein as 
[Why’s (Poignant) Guide to Ruby](http://mislav.uniqpath.com/poignant-guide/book/))*

I have a [repo](https://github.com/peterhellberg/land_of_lisp) on GitHub 
where I will push notes and code while I read the book.

Instead of writing a long winded book review, I’ll opt for linking to a 
few that I think do the book justice:
 [Slashdot](http://books.slashdot.org/story/10/11/03/1238213/land-of-lisp),
 [I do robots](http://idorobots.org/2011/09/25/land-of-lisp/),
 [Jorge Tavares](http://jorgetavares.com/2010/12/26/the-lisp-alien-arrived-a-land-of-lisp-reviewopinion/) and 
 the [Ruby Rogues](http://rubyrogues.com/043-rr-book-club-land-of-list-with-conrad-barski/).

## newLISP

All of the examples in Land of Lisp are written in Common Lisp, but 
I actually started out by playing with one of the younger Lisp dialects, 
[newLISP](http://www.newlisp.org/).

> newLISP is a scripting Lisp for people who are fascinated by 
> Lisp's beauty and power of expression, but who need it 
> stripped down to easy-to-learn essentials.

If you are using **OS X** and have [Homebrew](http://mxcl.github.com/homebrew/) 
installed then you can install newLISP by typing `brew install newlisp`
into your terminal.

### Examples

Lisp is using prefix notation, also known as
[Polish notation](http://en.wikipedia.org/wiki/Polish_notation).

Most programming languages are limited to two operands per 
operator but Lisp can have any number of operands per operator.

#### Compute the sum of 4,2,1

{% highlight cl %}
; newLISP
(+ 4 2 1)
{% endhighlight %}

{% highlight ruby %}
# Ruby
[4,2,1].inject(:+)
{% endhighlight %}

#### Check if 4 is greater than 3, and 3 is greater than 2

{% highlight cl %}
; newLISP
(if (> 4 3 2) (println "4 is greater than 3, and 3 is greater than 2"))
{% endhighlight %}

{% highlight ruby %}
# Ruby
puts "4 is greater than 3, and 3 is greater than 2" if 4 > 3 && 3 > 2
{% endhighlight %}

### Learn more about newLISP

You should definitely take a look at the 
[Introduction to newLISP](http://en.wikibooks.org/wiki/Introduction_to_newLISP)
after you have read the 
[newLISP User Manual](http://www.newlisp.org/downloads/newlisp_manual.html).

[OSNews: A Look at newLISP](http://www.osnews.com/story/20728/A_Look_at_newLISP/)

A collection of modules for a variety of things are available over at
[GitHub](https://github.com/LifeZero/artful-newlisp) (Including the
dependency-managing library QWERTY).

## Common Lisp

> Common Lisp, commonly abbreviated CL, is a dialect of the Lisp programming 
> language, published in ANSI standard document ANSI INCITS 226-1994 (R2004)

There are a lot of Common Lisp 
[implementations](http://en.wikipedia.org/wiki/Common_Lisp#List_of_implementations) 
available, both commercial and freely redistributable. 

I’m using the very portable [CLISP](http://www.clisp.org/), also available through Homebrew, 
just like newLISP: `brew install clisp`

### Examples

You will find a lot of examples in the article 
[Features of Common Lisp](http://random-state.net/features-of-common-lisp.html).

#### Rational numbers

{% highlight cl %}
; CLISP
(/ 1 2)
; => 1/2
{% endhighlight %}

{% highlight ruby %}
# Ruby
(1.0/2).to_r
# => (1/2)
{% endhighlight %}

#### Multiple return values

{% highlight cl %}
; CLISP
(floor pi)
; 3 ;
; 0.14159265358979323851L0
{% endhighlight %}

Conveniently, functions that return multiple values are treated,
by default, as though only the first value was returned:

{% highlight cl %}
; CLISP
(+ (floor pi) 2)
; => 5
{% endhighlight %}

To achieve something similar in Ruby (slightly contrived example):

{% highlight ruby %}
# Ruby
class MultiValue < BasicObject
  attr_reader :secondary

  def initialize(obj, *secondary)
    @obj, @secondary = obj, secondary
  end

  def method_missing(sym, *args, &block)
    @obj.__send__(sym, *args, &block)
  end
end

class Array
  def to_mv
    MultiValue.new(*self) unless empty?
  end
end

class Numeric
  def floor_with_remainder
    [floor, remainder(floor)].to_mv
  end
end
{% endhighlight %}

This allows us to do the following:

{% highlight ruby %}
# Ruby
Math::PI.floor_with_remainder + 2
# => 5

mv = Math::PI.floor_with_remainder
mv.secondary.inject(mv, :+)
# => 3.141592653589793
{% endhighlight %}

If you want to learn more about writing Lispy Ruby, then 
you should take a look at Chapter 8 in the book 
[Practical Ruby Projects: Ideas for the Eclectic Programmer](http://www.apress.com/9781590599112)
by Topher Cyll.

### Learn more about Common Lisp

 - [Common Lisp on Wikipedia](http://en.wikipedia.org/wiki/Common_Lisp)
 - [Practical Common Lisp](http://www.gigamonkeys.com/book/)
 - [Common-Lisp.net](http://common-lisp.net/)

