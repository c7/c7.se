---
type: article
date: 2015-01-16
url: /from-go-to-ooc/
title: From Go to ooc
summary: Getting to know ooc, a small programming language that compiles to C99.
---

## Similarities with Go

Let’s start off by listing some of the
characteristics shared between Go and ooc:

 - Assignment using the declare-assign operator `:=`
 - Multiple return values from functions (via [Tuples](http://ooc-lang.org/docs/lang/tuples/) in ooc)
 - Support for writing platform-specific code ([Build Constraints](http://golang.org/pkg/go/build/#hdr-Build_Constraints) in Go, [Version blocks](http://ooc-lang.org/docs/lang/preprocessor/#version-blocks) in ooc)
 - Garbage collection (Disable with `GOGC=off` in Go and `--gc=off` in [rock](http://ooc-lang.org/docs/tools/rock/gc/))

## How is it different from Go?

  - [Member access](http://ooc-lang.org/docs/lang/operators/#member-access) is performed with a space instead of a dot `"foo" println()`
  - Chars instead of Runes
  - Inline [string interpolation](http://ooc-lang.org/docs/lang/values/#string-interpolation) inspired by Ruby
  - It has a [Ternary operator](http://ooc-lang.org/docs/lang/operators/#ternary)
  - [Operator overloading](http://ooc-lang.org/docs/lang/operators/#operator-overloading) is possible
  - [Classes](http://ooc-lang.org/docs/lang/classes/) (With inheritance)
  - Implicit returns
  - Configurable entry point (You can use something else than main)
  - Inferred argument types when creating closures
  - [while](http://ooc-lang.org/docs/lang/control-structures/#while) loops
  - [Exceptions](http://ooc-lang.org/docs/lang/exceptions/)
  - [Generics](http://ooc-lang.org/docs/lang/generics/)!

## Getting started

> I initially installed rock using Homebrew, but then had some issues when compiling sam.

To install the [rock](https://github.com/fasterthanlime/rock) compiler, simply clone the git repo and run make rescue:

```bash
mkdir -p ~/Work/ooc
cd ~/Work/ooc
git clone https://github.com/fasterthanlime/rock.git
cd rock
make rescue
```

Now you need to set some environment variables in your `.bashrc`

```bash
# ooc programming language
export OOC_LIBS=$HOME/Work/ooc
export PATH=$PATH:$OOC_LIBS/sam:$OOC_LIBS/rock/bin
```

If everything is set up properly, then you should be able to run rock like this:

```bash
rock -V
rock 0.9.10-head codename sapphire, built on Fri Jan 16 04:12:40 2015
```

We also want to install the [sam](http://ooc-lang.org/docs/tools/sam/) package manager:

```bash
cd ~/Work/ooc
git clone https://github.com/fasterthanlime/sam.git
cd sam
rock -v
```

You should now be able to update sam by just by typing:

```bash
sam update
Pulling repository /Users/peter/Work/ooc/sam
> Current branch master is up to date.
Recompiling sam
> Cleaning up outpath and .libs
> [ OK ]
```

To get syntax highlighting in Vim using [Vundle](https://github.com/gmarik/Vundle.vim) just add `Plugin 'fasterthanlime/ooc.vim'`

## Example

A simple wget like tool written in ooc

```bash
sam clone curl
cd $OOC_LIBS
mkdir wget
cd wget
vim wget.ooc
```

**wget.ooc**
```go
use curl

import curl/Curl
import io/FileWriter, structs/ArrayList

writecb: func(buffer: Pointer, size: SizeT, nmemb: SizeT, fw: FileWriter) {
    fw write(buffer as CString, nmemb)
}

main: func(args: ArrayList<String>) {
    if(args size <= 1) {
        "Usage: %s URL\n" printfln(args[0])
        exit(0)
    }

    url := args get(1)

    fName := "tmp.html"

    fw := FileWriter new(fName)

    handle := Curl new()
    handle setOpt(CurlOpt url, url toCString())
    handle setOpt(CurlOpt writeData, fw)
    handle setOpt(CurlOpt writeFunction, writecb)
    handle perform()
    handle cleanup()

    fw close()
}
```

Compile it

```bash
rock -v -pr -O3 --gc=off wget.ooc
```

And run it

```
./wget http://c7.se/ test.html
```

## Learn more about ooc

  - [The ooc programming language](http://ooc-lang.org/)
  - [Programming with ooc](https://en.wikibooks.org/wiki/Programming_with_ooc)
