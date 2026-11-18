#import "@preview/fletcher:0.6.0" as fletcher: diagram, node, edge
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Bitter", size: 12pt)

#let boxnode(pos, body, ..args) = node(pos, body, shape: "rect", corner-radius: 3pt, ..args)

#diagram(
  node-stroke: 0.6pt, node-fill: none, node-inset: 8pt,
  edge-stroke: (paint: rgb(0, 0, 0, 150), thickness: 0.8pt),

  boxnode((0, 0), text(weight: 500)[leaf modules: dia, isa, rom], name: <shared>),
  boxnode((3, 0), text(weight: 500)[vm (compiler only)], name: <vmnode>),

  boxnode((0, 1), text(weight: 600)[asm_mod / assembler.zig], name: <asm>),
  boxnode((2, 1), text(weight: 600)[com_mod / compiler.zig], name: <com>),

  boxnode((0, 2), [4a CLI], name: <a4>),
  boxnode((1, 2), [asm_lib], name: <alib>),
  boxnode((2, 2), [4c CLI], name: <c4>),
  boxnode((3, 2), [com_lib], name: <clib>),
  boxnode((4, 2), [vm_lib], name: <vlib>),

  boxnode((2, 3), text(weight: 600)[4b box: 4b.c + raylib], name: <box>),

  edge(<shared>, <asm>), edge(<shared>, <com>), edge(<vmnode>, <com>),
  edge(<asm>, <a4>), edge(<asm>, <alib>), edge(<com>, <c4>), edge(<com>, <clib>),
  edge(<vmnode>, <vlib>), edge(<alib>, <box>), edge(<clib>, <box>), edge(<vlib>, <box>),
)
