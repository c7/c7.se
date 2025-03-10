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
