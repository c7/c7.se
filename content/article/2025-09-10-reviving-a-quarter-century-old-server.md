---
type: article
date: 2025-09-10
url: /reviving-a-quarter-century-old-server/
title: Reviving a Quarter Century-Old Server
summary:
    I recently brought down one of my old servers from the attic, 
    where it had been stored for almost two decades.
---

{{< gallery class="side" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/Dwarf-Back-Left.jpg" alt="Dwarf; Back left" style="--ar: 16/9;" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/Dwarf-Back-Right.jpg" alt="Dwarf; Back right" style="--ar: 16/9;" >}}
{{< /gallery >}}

> ⚠️ **Don't worry**… I am <u>**NOT**</u> exposing this machine directly to the Internet.
>
{type="warning with-top-margin"} 

{{< gallery class="side" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/Dwarf-Back.jpg" alt="" >}}
{{< /gallery >}}

## But, first things first...

This trip down memory lane is **mostly** for my own curiosity, and nostalgia.

The machine in question is a [Dell OptiPlex NX1 300+](https://theretroweb.com/motherboards/s/dell-optiplex-gx1,-optiplex-nx1,-optiplex-g) "Net PC"
which served as my web- and shell server for several years. Its hostname is `dwarf`, a nod to its compact size.

- CPU [Pentium® II Processor - 300 Mhz](https://en.wikipedia.org/wiki/Pentium_II)
- GPU [ATI Technologies Inc 3D Rage Pro AGP 1X/2X](https://en.wikipedia.org/wiki/ATI_Rage)
- HDD [Seagate Medalist 6531 - Model ST36531A](https://theretroweb.com/storage/documentation/baliigb-656741bc2b89b892830399.pdf)

```
Pentium® II Processor - 300 Mhz
LEVEL 2 Cache: Size Unknown
System Memory: 96 MB SDRAM
Video Memory:   4 MB SGRAM
```

{{< img src="/assets/reviving-a-quarter-century-old-server/Powered-by-dwarf.png" alt="Powered by dwarf" style="max-width: 100px; float:right;" >}}

## How old is it actually?

There are a few markings on the chassis, such as `ASSY 85179 22NOV97 85189` and `P/N 82898 14NOV97`, 
making it roughly **28 years old** as I write this.

{{< gallery class="side" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/ASSY-85179-22NOV97-PN-85189.jpg" alt="ASSY 85179 22NOV97 P/N 85189" style="--ar: 16/9;" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/PN-82898-14NOV97.jpg" alt="P/N 82898 14NOV97" style="--ar: 16/9;" >}}
{{< /gallery >}}

{{< gallery class="side" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/Intel-Pentium-II-300Mhz-Deschutes.jpg" alt="Intel Pentium II 300Mhz Deschutes CPU" style="--ar: 16/9;" >}}
{{< /gallery >}}

{{< gallery class="side" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/Seagate-Medalist-6531-Model-ST36531A.jpg" alt="Seagate Medalist 6531 Model ST36531A" style="--ar: 16/9;" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/Seagate-Medalist-6531-Drive-Parameters.jpg" alt="Seagate Medalist 6531 Drive Parameters" style="--ar: 1/1;" >}}
{{< /gallery >}}

## Does it even boot?

<u>**Yes!**</u> Fortunately the power supply still worked. 

The machine <u>appeared</u> to <abbr>POST</abbr> 
_([Power-On Self Test](https://en.wikipedia.org/wiki/Power-on_self-test))_; 
however, because its only video output is [VGA](https://en.wikipedia.org/wiki/VGA_connector) 
over [D-SUB](https://en.wikipedia.org/wiki/D-subminiature#DE-15_connectors), 
I first had to track down an appropriate cable before I could actually <u>see</u> what was happening.

> ♻️ As it turns out, I’ve been **surprisingly** good at getting rid of cables I no longer need.
{type="tip"}

I then thought; Maybe I could log into the machine directly using an ethernet cable, 
or even via the local network.

### So, did it show up on the network?

<u>**No!**</u> And I was _pretty_ sure that the machine had a static IP set, and that it 
wouldn't rely on [DHCP](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol)
to assign its IP. The machine didn't show up on the network, at all. 

<u>Even with a direct Ethernet connection, I couldn’t reach it.</u>

### Local I/O to the rescue!

Pretty soon after that my friend **Matti** came over with a VGA cable, somewhat surprisingly labeled 
  as being an `AWM E101344 STYLE 2919 80°C 30V SPACE SHUTTLE VW-1 LOW VOLTAGE COMPUTER CABLE`

{{< gallery class="side" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/VGA-CONNECTOR-14-PINS.jpg" alt="VGA CONNECTOR 14 PINS" style="--ar: 3/4;" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/AWM-E101344-STYLE-2919-80C-30V-SPACE-SHUTTLE-VW-1-LOW-VOLTAGE-COMPUTER-CABLE.jpg" alt="AWM E101344 STYLE 2919 80°C 30V SPACE SHUTTLE VW-1 LOW VOLTAGE COMPUTER CABLE" style="--ar: 16/9;" >}}
{{< /gallery >}}

<small>As seen above there are only **14** pins.</small>

#### Monitor

My TV is showing its age in the best way possible—it has a VGA input. ✨ Thanks to that, 
I could finally see the server’s first message in decades:

```console
Alert! Cover was previously removed.

To continue press F1 key
To change setup option press F2 key
```

Not surprised about the alert though, since I’ve never actually had a cover for this machine.

> **Note:** The reason for this alert was that the CMOS battery had gone flat, 
> wiping out the BIOS settings.
{type="note"}

#### Keyboard

This surfaced the next problem: to get past the alert, I had to press a key on the keyboard. 

_(Plugging in a USB keyboard did nothing)_ 

That meant another trip up to the attic to dig out one of those green **PS/2-to-USB** adapters 
that had once been everywhere, and then suddenly vanished.

{{< gallery class="side" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/PS2-TO-USB-ADAPTER-HC-501215-0005-SH.jpg" alt="PS/2 TO USB ADAPTER HC 501215 0005 SH" style="--ar: 4/5;" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/BIOS-Version-A00-OptiPlex-NX1-300-plus.jpg" alt="" style="--ar: 16/9;" >}}
{{< /gallery >}}

#### Battery

I popped in a fresh [`CR2032`](https://en.wikipedia.org/wiki/Button_cell), 
and now with both the keyboard and monitor connected, I was able to;

- Set the BIOS clock 
- Disable the Chassis Intrusion alarm
- Continue booting the machine

{{< gallery class="side" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/Dwarf-Login-Incorrect.jpg" alt="Welcome to Linux 2.6.8.1 (tty) dwarf login: root Password: Login incorrect" style="--ar: 16/9;" >}}
{{< /gallery >}}

## Welcome to Linux 2.6.8.1 (tty1) 

At last—one step closer to bringing this old machine to life.

### Did I remember the **root** password?

<u>**No!**</u> Since it had been quite a while since I last powered up the server, 
I had no idea <u>what</u> **root** password I’d left on it. 

> **Note:** Resetting the password wasn’t much of an issue, since the drive **wasn’t encrypted**.
{type="note"}

### How to reset the root password?

You can replace the `init` process at boot—for example, with a shell of your choice—and you can 
also request that the file system be mounted as read-write. **Convenient!**

> So I typed `2.6.8.1 init=/bin/bash rw` at the [LILO](https://www.joonet.de/lilo/) 
> boot prompt, then ran `passwd root`.
{type="important"} 

Success! I was now able to log in as both **root** and my personal user **zil**.

### Convincing modern SSH clients to talk to Dwarf

These days your SSH client will refuse to connect to a server with **wildly** 
out of date algorithms for <u>key exchange</u>, <u>authentication</u> and <u>encryption</u>.

So you need to reconfigure your client to allow this.

In this specific case I added a `Host` section to my `~/.ssh/config` with the following content;
```
Host dwarf 
  User zil 
  KexAlgorithms=+diffie-hellman-group-exchange-sha1
  HostKeyAlgorithms=+ssh-rsa
  PubkeyAcceptedAlgorithms=+ssh-rsa
```

This allows me to `ssh dwarf` from my other machines, without having to specify the username, or those old algorithms each time I'm connecting.

```console
tiny ~ 
$ ssh dwarf
         @@@@@@@  @@@@@@@@    @@@@@@   @@@@@@@@
        @@@@@@@@  @@@@@@@@   @@@@@@@   @@@@@@@@      
        !@@            @@!   !@@       @@!           
        !@!           !@!    !@!       !@!          
        !@!          @!!     !!@@!!    @!!!:!        
        !!!         !!!       !!@!!!   !!!!!:        
        :!!        !!:            !:!  !!:           
        :!:       :!:   :!:      !:!   :!:           
         ::: :::   ::   :::  :::: ::    :: ::::      
         :: :: :  : :   :::  :: : :    : :: ::       
		 
 +---------------------------------------------------+
 |       Welcome to dwarf, a small Dell NetPC        |
 |---------------------------------------------------|
 |        This machine is my local webserver         |
 +-------------------------+-------------------------+
 |  - 300 Mhz  Deschutes   |  - No bots              |
 |  - 96  Mb   PC133       |  - No leeching          |
 |  - 6.5 Gb   5400rpm     |  - One screen           |
 |                         |  - Be nice              |
 +-------------------------+-------------------------+
 |         Admin: ziL (#nudel @ chatsociety)         |
 +---------------------------------------------------+
 
Last login: Wed Sep 10 04:39:07 2025 from tiny
Linux 2.6.8.1.

There is no future in time travel.


If you just try long enough and hard enough, you can always manage to
boot yourself in the posterior.
		-- A.J. Liebling

[zil@dwarf] █ 
```

## Software

Now that I’m able to log into the machine, it’s time to take inventory of 
the hardware and software installed on it. I mainly ran 
[Slackware](http://www.slackware.com/) on my machines back then, 
but also some [DragonflyBSD](https://www.dragonflybsd.org/).

- Slackware [`10.2.0`](http://www.slackware.com/announce/10.2.php)
- Kernel [`Linux 2.6.8.1`](https://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.8.1)
- Shell [`Bash 3.00.16`](https://mirror.accum.se/mirror/gnu.org/gnu/bash/bash-3.0-patches/bash30-016)
- C Compiler [`gcc-3.3.6`](https://gcc.gnu.org/gcc-3.3/changes.html#3.3.6)
- C Library [`glibc-2.3.5`](https://sourceware.org/legacy-ml/libc-announce/2005/msg00001.html)

### Vim 6.3

{{< gallery class="side" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/Dwarf-Vim63.png" alt="Vim 6.3 on Dwarf" style="--ar: 1963/608;" >}}
{{< /gallery >}}

I naturally wrote a new [.vimrc](https://github.com/peterhellberg/dotfiles/blob/master/.dwarf.vimrc) 
for this ancient version of [Vim](https://www.vim.org/)

```console
[zil@dwarf] vim --version
VIM - Vi IMproved 6.3 (2004 June 7, compiled Sep 10 2005 15:22:09)
Included patches: 1-86
Compiled by root@midas
Big version without GUI.  Features included (+) or not (-):
+arabic +autocmd -balloon_eval -browse ++builtin_terms +byte_offset +cindent 
-clientserver -clipboard +cmdline_compl +cmdline_hist +cmdline_info +comments 
+cryptv +cscope +dialog_con +diff +digraphs -dnd -ebcdic +emacs_tags +eval 
+ex_extra +extra_search +farsi +file_in_path +find_in_path +folding -footer 
+fork() +gettext -hangul_input +iconv +insert_expand +jumplist +keymap +langmap
 +libcall +linebreak +lispindent +listcmds +localmap +menu +mksession 
+modify_fname +mouse -mouseshape +mouse_dec +mouse_gpm -mouse_jsbterm 
+mouse_netterm +mouse_xterm +multi_byte +multi_lang -netbeans_intg -osfiletype 
+path_extra -perl +postscript +printer -python +quickfix +rightleft -ruby 
+scrollbind +signs +smartindent -sniff +statusline -sun_workshop +syntax 
+tag_binary +tag_old_static -tag_any_white -tcl +terminfo +termresponse 
+textobjects +title -toolbar +user_commands +vertsplit +virtualedit +visual 
+visualextra +viminfo +vreplace +wildignore +wildmenu +windows +writebackup 
-X11 -xfontset -xim -xsmp -xterm_clipboard -xterm_save 
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
      user exrc file: "$HOME/.exrc"
  fall-back for $VIM: "/usr/share/vim"
Compilation: gcc -c -I. -Iproto -DHAVE_CONFIG_H     -O2       
Linking: gcc   -L/usr/local/lib -o vim       -lncurses -lgpm -ldl       
```

### Retrofetch

I made a [small script](/assets/reviving-a-quarter-century-old-server/scripts/retrofetch.sh) 
akin to Neofetch but compatible with the old version of Bash on the machine.

```console
[zil@dwarf] ./retrofetch.sh 
                      
      .--.            User:   zil@dwarf
     |o_o |           OS:     Slackware 10.2.0
     |:_/ |           Linux:  2.6.8.1 #1 Sat Oct 16 12:53:05 CEST 2004 i686
    //   \ \          Uptime: 10:40
   (|     | )         Shell:  GNU bash, version 3.00.16(2)-release
  /'\_   _/'\         CPU:    Pentium II (Deschutes)
  \___)=(___/         Memory: 92 MB
                      Disk:   /      2.3G/2.7G (88%)
                              /home  2.4G/2.7G (93%)
```


{{< gallery class="side" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/Dell.jpg" alt="Dell OptiPlex NX/N" style="--ar: 347/427;" >}}
  {{< img src="/assets/reviving-a-quarter-century-old-server/Dwarf-Eterm.png" alt="" style="--ar: 960/663;" >}}
{{< /gallery >}}

## Hardware

```console
[zil@dwarf] lspci
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 02)
00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 02)
00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
00:0e.0 Ethernet controller: Accton Technology Corporation SMC2-1211TX (rev 10)
00:11.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone] (rev 24)
01:00.0 VGA compatible controller: ATI Technologies Inc 3D Rage Pro AGP 1X/2X (rev 5c)
```

> **Note:** The eagle eyed might have spotted that extra Ethernet interface. 
> I pulled that from a machine with a dead PSU when bringing **dwarf** down from the attic. 
> So it was not installed back in the day.
{type="note"}

```console
[zil@dwarf] cat /proc/cpuinfo 
processor     : 0
vendor_id     : GenuineIntel
cpu family    : 6
model         : 5
model name    : Pentium II (Deschutes)
stepping      : 0
cpu MHz       : 297.831
cache size    : 512 KB
fdiv_bug      : no
hlt_bug	      : no
f00f_bug      : no
coma_bug      : no
fpu	          : yes
fpu_exception : yes
cpuid level	  : 2
wp            : yes
flags         : fpu vme de pse tsc msr pae mce cx8 
                sep mtrr pge mca cmov pat pse36 mmx fxsr
bogomips      : 585.72
```

```
[zil@dwarf] cat /proc/meminfo
MemTotal:        94516 kB
MemFree:          1912 kB
Buffers:         24512 kB
Cached:           4100 kB
SwapCached:          0 kB
Active:          15920 kB
Inactive:        17532 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:        94516 kB
LowFree:          1912 kB
SwapTotal:      481940 kB
SwapFree:       481940 kB
Dirty:               0 kB
Writeback:           0 kB
Mapped:           7560 kB
Slab:            58096 kB
Committed_AS:    17324 kB
PageTables:        320 kB
VmallocTotal:   942040 kB
VmallocUsed:       328 kB
VmallocChunk:   941712 kB
```
