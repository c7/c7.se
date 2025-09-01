---
type: article
date: 2015-08-26
url: /go-and-ruby-ffi/
title: Go and Ruby-FFI
summary: How to write a shared library in Go that can be loaded by Ruby-FFI.
---

With the release of [Go 1.5](https://golang.org/doc/go1.5) we got access to a
new **buildmode** called `c-shared`, which allows you to build shared libraries that
[Ruby-FFI](https://github.com/ffi/ffi) can load. _(Also, anything else that can load shared libraries)_

## Inspiration

[Filippo Valsorda](https://twitter.com/filosottile) has already written a very nice article on
[Building Python modules with Go 1.5](https://blog.filippo.io/building-python-modules-with-go-1-5/)
but I naturally wanted to use Ruby instead of Python.

## Requirements

You will need to have [Go](http://golang.org/) and [Ruby](https://www.ruby-lang.org/) installed.
_(I am using Go 1.5 and Ruby 2.2.3 in this article)_

## Getting started

Our library is going to perform the complicated task of adding up two integers, and then returning the resulting sum.

Break out your [trusty editor](http://neovim.org/) and type in the following code:

### libsum.go
```go
package main

import "C"

//export add
func add(a, b int) int {
	return a + b
}

func main() {}
```

> **Note:** The only callable symbols will be those functions exported using a cgo `//export` comment.
> Non-main packages are ignored.

## Building the shared library

We are now ready to use the `c-shared` buildmode in order to build the shared library:

```console
go build -buildmode=c-shared -o libsum.so libsum.go
```

## Using Ruby-FFI to load libsum.so

So what is this Ruby-FFI thing you keep talking about?

> **Info:** Ruby-FFI is a ruby extension for programmatically loading dynamic libraries, binding functions within them, and calling those functions from Ruby code.

Ok, cool.

Install the `ffi` gem:

```console
$ gem install ffi
Fetching: ffi-1.9.10.gem (100%)
Building native extensions.  This could take a while...
Successfully installed ffi-1.9.10
1 gem installed
```

Now you are ready to interface with libsum.so

```ruby
require 'ffi'

module Sum
  extend FFI::Library
  ffi_lib './libsum.so'
  attach_function :add, [:int, :int], :int
end

puts Sum.add(15, 27) #=> 42
```

Well, look at that!

## Wait, what about memory management?

There is a section on [memory management](https://github.com/ffi/ffi/wiki/Core-Concepts#memory-management) in the FFI wiki.

You probably also want to read [C? Go? Cgo!](https://blog.golang.org/c-go-cgo)

## Bonus rounds

### Binding directly from [Crystal](http://crystal-lang.org/) (No need for FFI)

```ruby
@[Link(ldflags: "-L. -lsum")]
lib Sum
  fun add(a : Int32, b : Int32) : Int32
end

puts Sum.add(15,27) #=> 42
```

### Linking from [Zig](https://ziglang.org/) 0.16.0-dev (Also no need for FFI)

```zig
const std = @import("std");

extern fn add(a: i32, b: i32) i32;

pub fn main() void {
    std.debug.print("{d}\n", .{
        add(15, 27),
    });
}
```

Which can then be built via `zig build-exe sum.zig -L. -lc -lsum`

But you would most likely want to have a `build.zig` instead, something like;

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "sum",
        .root_module = b.createModule(.{
            .root_source_file = b.path("sum.zig"),
            .target = b.standardTargetOptions(.{}),
            .optimize = b.standardOptimizeOption(.{}),
        }),
    });

    const mod = exe.root_module;

    mod.link_libc = true;
    mod.addLibraryPath(b.path("."));
    mod.linkSystemLibrary("sum", .{});

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());
}
```
