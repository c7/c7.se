---
draft: false
type: article
date: 2024-10-14
url: /webassembly-fantasy-consoles/
title: WebAssembly Fantasy Consoles
summary: There are various serious use cases of WebAssembly out there.
---

 - Edge Computing in a content delivery network [^cdn] such as [Fastly](https://www.fastly.com/products/edge-compute) and [Cloudflare](https://workers.cloudflare.com/).
 - Plugins, such as in [sqlc](https://docs.sqlc.dev/en/stable/guides/plugins.html), [Typst](https://typst.app/docs/reference/foundations/plugin/) and [Extism](https://extism.org/docs/concepts/plug-in).
 - Browser based applications, for example [Figma](https://www.figma.com/), [Adobe Photoshop](https://photoshop.adobe.com/) and [AutoCAD Web](https://web.autocad.com/).

That is all well and good, _for your day job_.

> A _somewhat_ <ins>less</ins> serious, but arguably more ✨ **fun**✨ use case of
> WebAssembly [^webassembly] is to rely on it when developing games
> _(or other art for that matter)_ targeting a Fantasy Console. [^fantasy console]

## Fantasy consoles

Three such consoles _(fantasy machines with access to a WebAssembly runtime)_
are [WASM-4](#wasm-4), [MicroW8](#microw8) and [TIC-80](#tic-80).
Over the last couple of years I have experimented with all three of them.

### Tips💡

Being able to write some code, compile it into a `.wasm` and have it automatically reloaded in the
fantasy console is great. _(I often use a file system watcher to trigger the recompilation)_

You'll be limited to a number of colors _(in a palette)_, you are however
free to replace the palette with one of your own, or maybe _(more likely)_ one of the
most popular ones from the [Lospec Palette list](https://lospec.com/palette-list) 🎨

You can also rely on tricks such as palette shifting [^palette shifting] and dither [^dither]

> I have published a `*-init` CLI for each of these consoles. _(Linked in respective section below)_

---------

### WASM-4

WASM-4 [^wasm4] is currently my favorite fantasy console, it is severely limited.

#### Specs

- **Resolution:** 160x160
- **Colors:** 4
- **Memory:** 64 KB _(A single WebAssembly memory page)_
- **Input:** 4 gamepads with D-Pad + 2 Buttons, Mouse
- **Audio:** 2 pulse wave channels, 1 triangle wave channel, 1 noise channel
- **Storage:** 1024 bytes

#### Links

[Website](https://wasm4.org/) |
[GitHub](https://github.com/aduros/wasm4) |
[w4-init](https://github.com/peterhellberg/w4-init) ⚡

#### Example of a WASM-4 cart I've written

<script>window.addEventListener('touchstart', {});</script>
<iframe src="https://assets.c7.se/games/w4-balls/" width="100%" allow="fullscreen; gamepad; autoplay" style="max-height: 100dvh; aspect-ratio: 1/1.7;" frameborder="0"></iframe>

---------

### MicroW8

MicroW8 [^microw8] is less limited than WASM-4.
However, I have found its web runtime to be less convenient for development.

> The initial motivation behind MicroW8 was to explore whether there was a way to make WebAssembly viable for size-coding. [^sizecoding]

#### Specs

- **Resolution:** 320x240
- **Colors:** 256
- **Memory:** 256KB (4 WebAssembly memory pages)
- **Input:** (D-Pad + 4 Buttons)
- **Audio:** 4 channels with individual volume control. _(rect, saw, tri, noise wave forms selectable per channel. 32 bytes of sound registers_)

#### Links

[Website](https://exoticorn.github.io/microw8/) |
[GitHub](https://github.com/exoticorn/microw8) |
[uw8-init](https://github.com/peterhellberg/uw8-init) ⚡

---------

### TIC-80

TIC-80 [^tic80] is a console with an IDE [^ide], not for the code resulting in a `.wasm` though.

> You will need the **PRO** version of [TIC-80](https://nesbox.itch.io/tic80) in order to load cartridges in text format (such as `.wasmp`)

#### Specs

- **Resolution:** 240x136
- **Colors:** 16
- **Memory:** 256KB addressable memory [^tic80 memory]
- **Sprites:** 256 8x8 tiles and 256 8x8 sprites
- **Map:** 240x136 cells, 1920x1088 pixels
- **Input:** 4 gamepads with 8 buttons / mouse / keyboard
- **Audio:** 4 channels with configurable waveforms

#### Links

[Website](https://tic80.com/) |
[GitHub](https://github.com/nesbox/TIC-80) |
[tic-init](https://github.com/peterhellberg/tic-init) ⚡

[^cdn]: A [content delivery network](https://en.wikipedia.org/wiki/Content_delivery_network) (CDN) is a geographically distributed network of proxy servers.
[^webassembly]: [WebAssembly](https://webassembly.org/) is a binary instruction format for a [stack-based virtual machine](https://en.wikipedia.org/wiki/Stack_machine).
[^fantasy console]: A [fantasy console](https://en.wikipedia.org/wiki/Fantasy_console) is an emulator for a fictitious video game console.
[^palette shifting]: [Palette shifting](https://en.wikipedia.org/wiki/Palette_shifting) is a technique used in computer graphics in which colors are changed in order to give the impression of animation.
[^dither]: [Dither](https://en.wikipedia.org/wiki/Dither) is an intentionally applied form of noise used to randomize quantization error, preventing large-scale patterns such as color banding in images.
[^wasm4]: [WASM-4](https://wasm4.org/) is a low-level fantasy game console for building small games with WebAssembly.
[^microw8]: The [MicroW8 repo](https://github.com/exoticorn/microw8) hasn't had much activity lately.
[^sizecoding]: [Size coding](http://www.sizecoding.org/wiki/Main_Page) being the art of creating tiny _(often <= 256 bytes)_ graphical effects and games.
[^tic80]: [TIC-80](https://tic80.com/) is pretty similar to the more popular [PICO-8](https://www.lexaloffle.com/pico-8.php) _(Unfortunately PICO-8 does not support WebAssembly based games)_
[^ide]: An [integrated development environment](https://en.wikipedia.org/wiki/Integrated_development_environment) (IDE) is a software application that provides comprehensive facilities for software development.
[^tic80 memory]: [TIC-80 WASM "hardware" limits](https://github.com/nesbox/TIC-80/wiki/wasm#wasm-hardware-limits); 112KB base RAM for memory mapped I/O, SFX, VRAM, etc. 160KB of RAM free for cartridge use.
