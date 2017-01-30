---
type: article
date: 2017-01-30
url: /switching-to-vim-plug/
title: Switching to vim-plug
summary: I’ve switched to vim-plug, a minimalist Vim plugin manager.
---

Recently I decided to switch my vim package manager once again,
and this time the choice fell on [vim-plug](https://github.com/junegunn/vim-plug).
_(A couple of years ago I switched from [Janus](https://github.com/carlhuda/janus) to
[Vundle](https://github.com/VundleVim/Vundle.vim))_

The main part of this article consist of information found in the vim-plug [README](https://github.com/junegunn/vim-plug/blob/master/README.md)

## Features

- Single file. No boilerplate code required.
- Concise, intuitive syntax
- [Super-fast](https://cdn.rawgit.com/junegunn/i/master/vim-plug/40-in-4.gif) parallel installation/update
  _(with any of `+job`, `+python`, `+python3`, `+ruby`, or [Neovim](http://neovim.org/))_
- Creates shallow clones to minimize disk space usage and download time
- On-demand loading for [faster startup time](https://github.com/junegunn/vim-startuptime-benchmark#result)
- Can review and rollback updates
- Branch/tag/commit support
- Post-update hooks
- Support for externally managed plugins

## Installation

[Download plug.vim](https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim)
and put it in the "autoload" directory.

#### Vim

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

#### Neovim

```sh
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## Commands

These are some of the [commands](https://github.com/junegunn/vim-plug#commands) that vim-plug provide.

#### PlugUpdate

Install or update plugins

![PlugUpdate](/assets/switching-to-vim-plug/vim-plug-updated-plugins.png)

#### PlugDiff

Examine changes from the previous update and the pending changes

![PlugDiff](/assets/switching-to-vim-plug/vim-plug-PlugDiff.png)

#### PlugClean[!]

Remove unused directories (bang version will clean without prompt)

![PlugClean](/assets/switching-to-vim-plug/vim-plug-PlugClean.png)

## On-demand loading of plugins

On of the main reasons for using vim-plug is its support for on-demand loading of plugins.

```vim
" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Multiple commands
Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity'] }

" Loaded when clojure file is opened
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Multiple file types
Plug 'kovisoft/paredit', { 'for': ['clojure', 'scheme'] }

" On-demand loading on both conditions
Plug 'junegunn/vader.vim',  { 'on': 'Vader', 'for': 'vader' }

" Code to execute when the plugin is lazily loaded on demand
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
autocmd! User goyo.vim echom 'Goyo is now loaded!'
```

## Configuration examples

A small [sensible](https://github.com/tpope/vim-sensible) Vim configuration

```vim
call plug#begin()
Plug 'tpope/vim-sensible'
call plug#end()
```

Minimal version of my Go development configuration

```vim
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'SirVer/ultisnips'
Plug 'ervandew/supertab'
Plug 'honza/vim-snippets'
Plug 'peterhellberg/snippets'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'fatih/vim-go'
Plug 'nanotech/jellybeans.vim'

call plug#end()

let mapleader=','

color jellybeans

set completeopt-=preview
set modelines=3
set nobackup
set noshowmode
set noswapfile
set nowrap
set nowritebackup
set number
set shiftwidth=2
set tabstop=2
set termguicolors
set virtualedit=block

" Open new buffers
nmap <leader>s<left>   :leftabove  vnew<cr>
nmap <leader>s<right>  :rightbelow vnew<cr>
nmap <leader>s<up>     :leftabove  new<cr>
nmap <leader>s<down>   :rightbelow new<cr>

" Tab between buffers
noremap <tab> <c-w>w
noremap <S-tab> <c-w>W

" Switch between last two buffers
nnoremap <leader><leader> <C-^>

" NERDTree
nmap <leader>n :NERDTreeToggle<CR>

" SuperTab
let g:SuperTabDefaultCompletionType = "context"

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"

" Go programming
au BufRead,BufNewFile *.go setl filetype=go nolist noexpandtab syntax=go

au FileType go nmap <Leader>d <Plug>(go-def-vertical)
au FileType go nmap <Leader>do <Plug>(go-doc-vertical)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <leader>c <Plug>(go-callers)

let g:go_disable_autoinstall = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods   = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs   = 1
let g:go_fmt_command = "goimports"

augroup go
  autocmd!
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
augroup END
```

My full [.vimrc](https://github.com/peterhellberg/dotfiles/blob/master/.vimrc) is available in my [dotfiles](https://github.com/peterhellberg/dotfiles) repository.

