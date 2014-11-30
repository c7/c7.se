---
type: article
date: 2013-04-27
url: /switching-to-vundle/
title: Switching to Vundle
summary: I’ve decided to use Vundle the Vim package manager.
---

I’ve been using [Vim](http://www.vim.org/) on and off for close
to 10 years now and It became my primary editor when I switched from
[TextMate](http://macromates.com/) to
[MacVim](https://code.google.com/p/macvim/) a few years ago.
*(Along with a lot of other people in the Ruby community)*

I started using the [Janus](https://github.com/carlhuda/janus)
distribution and never had any major issues with it.

There have been a few **minor** performance issues though, issues
that mostly stem from the large number of plugins and
customizations that Janus brings to the table.

I have decided to start over, this time being slightly
more restrictive with my configuration. I’ve also decided to use
[Vundle](https://github.com/gmarik/vundle) for plugin management…

> Vundle is short for *Vim bundle* and is a Vim plugin manager.

## Starting position

There is no point in making any changes until you have figured
out what the current state is. You can see what Vim does when
it starts up by calling the **startuptime** flag.

In my case that would be:

```bash
mvim -v --startuptime /dev/stdout +qall
```

Which prints **171** lines of log output for Vi-mode and **189**
for the GUI-mode.

> You might want to take a look at
> [Improving Vim’s Startup Time](http://usevim.com/2012/04/18/startuptime/)
> over at Usevim.

### Extra plugins

I’ve also installed a few extra plugins that doesn't come with the Janus distribution.
I have the following directories under `.janus`:

```bash
BusyBee/
vim-arduino/
vim-markdown-preview/
vim-nginx/
vim-powerline/
vim-ruby-xmpfilter/
vim-slim/
vim-textobj-rubyblock/
vim-textobj-user/
```

### Disabled plugins

I had disabled a few plugins that came with Janus:

```bash
call janus#disable_plugin('tagbar')
call janus#disable_plugin('narrowregion')
call janus#disable_plugin('easymotion')
call janus#disable_plugin('vimwiki')
call janus#disable_plugin('vroom')
call janus#disable_plugin('buffergator')
```

## A clean slate

My dotfiles live in a Git repo so it is quite trivial to
create a new branch where I can make the required changes:

```bash
$ git checkout -b switching-to-vundle
```

I just need to remove all traces of Janus by unlinking
all the symlinks and removing all other related files.

The resulting **startuptime** log is **41** lines long, *quite an improvement*.

It is quite possible to use Vim on its own like this. I’ve come to
love a few plugins and I’m happy to let the i7 in my Air work a
bit in order to let me use them.

## [Vundle](https://github.com/gmarik/vundle)

I’m going to use Vundle for my plugins from now on, so I’ll need to install it:

```bash
$ mkdir ~/.vim/bundle
$ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
```

Vundle makes it **very** easy to manage Vim plugins. You just need
to specify a few rows along the lines of `Bundle "user/plugin"`
in your `.vimrc` and then issue `:BundleInstall` to start the installation.

You can also run `:BundleUpdate` and `:BundleClean`

## New .vimrc

Both `NERDTree` and `Syntastic` are quite slow.
I could probably manage without them but what would be the fun in that?

```vim
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle
Bundle 'gmarik/vundle'

" My Bundles
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-rake'
Bundle 'nanotech/jellybeans.vim'
Bundle 'Lokaltog/vim-powerline'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'rking/ag.vim'
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'slim-template/vim-slim'

filetype plugin indent on

let mapleader=","

color jellybeans

set cursorline
set expandtab
set modelines=0
set shiftwidth=2
set clipboard=unnamed
set synmaxcol=128
set ttyscroll=10
set encoding=utf-8
set tabstop=2
set nowrap
set number
set expandtab
set nowritebackup
set noswapfile
set nobackup
set hlsearch
set ignorecase
set smartcase

" Automatic formatting
autocmd BufWritePre *.rb :%s/\s\+$//e
autocmd BufWritePre *.go :%s/\s\+$//e
autocmd BufWritePre *.haml :%s/\s\+$//e
autocmd BufWritePre *.html :%s/\s\+$//e
autocmd BufWritePre *.scss :%s/\s\+$//e
autocmd BufWritePre *.slim :%s/\s\+$//e

au BufNewFile * set noeol
au BufRead,BufNewFile *.go set filetype=go

" No show command
autocmd VimEnter * set nosc

" Quick ESC
imap jj <ESC>

" Jump to the next row on long lines
map <Down> gj
map <Up>   gk
nnoremap j gj
nnoremap k gk

" format the entire file
nmap <leader>fef ggVG=

" Open new buffers
nmap <leader>s<left>   :leftabove  vnew<cr>
nmap <leader>s<right>  :rightbelow vnew<cr>
nmap <leader>s<up>     :leftabove  new<cr>
nmap <leader>s<down>   :rightbelow new<cr>

" Tab between buffers
noremap <tab> <c-w><c-w>

" Switch between last two buffers
nnoremap <leader><leader> <C-^>

" Resize buffers
if bufwinnr(1)
  nmap Ä <C-W><<C-W><
  nmap Ö <C-W>><C-W>>
  nmap ö <C-W>-<C-W>-
  nmap ä <C-W>+<C-W>+
endif

" NERDTree
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg']

" Syntastic
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_ruby_exec = '~/.rvm/rubies/ruby-2.0.0-p0/bin/ruby'

" CtrlP
nnoremap <silent> t :CtrlP<cr>
let g:ctrlp_working_path_mode = 2
let g:ctrlp_by_filename = 1
let g:ctrlp_max_files = 600
let g:ctrlp_max_depth = 5

" Go programming
set rtp+=/usr/local/Cellar/go/1.0.3/misc/vim

" Quit with :Q
command -nargs=0 Quit :qa!
```

### And a small .gvimrc

I like to keep the main part of the config
in `.vimrc` in order to have as few differences
between the GUI and CLI versions of MacVim.

```vim
" MacVim GUI mode
if has("gui_macvim")
  set guifont=Monaco:h13
  set guioptions=aAce
  set fuoptions=maxvert,maxhorz
  set noballooneval

  " resize current buffer by +/- 5
  nnoremap <M-Right> :vertical resize +5<CR>
  nnoremap <M-Left>  :vertical resize -5<CR>
  nnoremap <M-Up>    :resize -5<CR>
  nnoremap <M-Down>  :resize +5<CR>

  " Command+Option+Right for next
  map <D-M-Right> :tabn<CR>
  " Command+Option+Left for previous
  map <D-M-Left> :tabp<CR>

  " Automatically resize splits
  " when resizing MacVim window
  autocmd VimResized * wincmd =
endif
```
