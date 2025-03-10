---
type: article
date: 2024-09-17
updated: 2025-03-10
url: /webassembly-plugins-for-typst-in-zig/
title: WebAssembly plugins for Typst, in Zig
summary:
    While I was revisiting the typesetting system Typst,
    I noticed that it is capable of interfacing with
    plugins compiled to WebAssembly.
---

## 1. Preparation

The [plugin](https://typst.app/docs/reference/foundations/plugin/)
support was a pleasant surprise, and I naturally wanted to use
[Zig](https://ziglang.org/) ⚡ for this purpose.

> **Note:**
> You will want to have both [`zig`](https://ziglang.org/download/) and
> [`typst`](https://github.com/typst/typst?tab=readme-ov-file#installation)
> installed if you are following along.
>
> _(Precompiled binaries are available for both)_
>

I've made a small module (called [typ](https://github.com/peterhellberg/typ))
that hopefully will be useful when writing plugins for [Typst](https://typst.app/).

## 2. Dependency

The `typ` module can be fetched and saved into your `build.zig.zon` like this;

```sh
zig fetch --save https://github.com/peterhellberg/typ/archive/refs/tags/v0.1.0.tar.gz
```

Then you will add the dependency in `build.zig` _(under the call to `b.addExecutable`)_

### build.zig
```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .wasm32,
        .os_tag = .freestanding,
    });

    const exe = b.addExecutable(.{
        .name = "hello",
        .root_source_file = b.path("hello.zig"),
        .strip = true,
        .target = target,
        .optimize = .ReleaseSmall,
    });

    const typ = b.dependency("typ", .{}).module("typ");

    exe.root_module.addImport("typ", typ);
    exe.entry = .disabled;
    exe.rdynamic = true;

    b.installArtifact(exe);
}
```

We are now ready to write a little [Typst](https://typst.app/) plugin in [Zig](https://ziglang.org/).

## 3. Plugin

Now we should be able to use the `typ` module to write a plugin.

### hello.zig
```zig
const typ = @import("typ");

export fn hello() i32 {
    const msg = "*Hello* from `hello.wasm` written in Zig!";

    return typ.str(msg);
}

export fn echo(n: usize) i32 {
    const data = typ.alloc(u8, n) catch
        return typ.err("alloc failed");
    defer typ.free(data);

    typ.write(data.ptr);

    return typ.ok(data);
}
```

Two functions are exported from this plugin;
 - The `hello` function, which does not take any arguments and it can not fail.
 - The `echo` function on the other hand takes a single
    _(Typst [`bytes`](https://typst.app/docs/reference/foundations/bytes/) value)_
    argument as input and echoes it back to the host,
    this function can fail on allocation _(unlikely to happen for this example)_

Build the `zig-out/bin/hello.wasm` by calling `zig build` and
then we can proceed with writing a `hello.typ` using
the plugin we just compiled.

### hello.typ
```typ
#set page(width: 35cm, height: 22cm)
#set text(font: "Inter", size: 40pt)

#let wasm = plugin("zig-out/bin/hello.wasm")
#let gy = gradient.linear(green, yellow)

== A WebAssembly plugin for Typst

#line(length: 100%, stroke: gy + 4pt)

#emph[
  Typst is capable of interfacing
  with plugins compiled to WebAssembly.
]

#line(length: 100%, stroke: gy + 4pt)

#eval(str(wasm.hello()), mode: "markup")

#let imgdata = read("wave.png", encoding: none)

#image(wasm.echo(imgdata), width: 100pt)
```

> **Important:**
> The [Typst CLI](https://github.com/typst/typst) is all you need!
> _(No requirement on using the [collaborative online editor](https://typst.app/))_

Running `typst compile hello.typ hello.svg` should, if all goes well, result
in a [SVG](https://en.wikipedia.org/wiki/SVG) file that looks something like this;

![A WebAssembly plugin for Typst](/assets/webassembly-plugins-for-typst-in-zig/hello.svg)

