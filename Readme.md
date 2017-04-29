# Vim-ucf: User Completion Functions for Vim

This plugin includes a collection of user-completion functions for Vim. It can
be used by itself or in synergy with
[µcomplete](https://github.com/lifepillar/vim-mucomplete) or other plugins.


## Stand-alone usage

Set `completefunc` to one of the `...completefunc()` functions in
`autoload/ucf`. For example:

```vim
set completefunc=ucf#aggregate#completefunc
```

Alternatively, define a mapping like the following:

```vim
imap <expr> <c-j> "\<c-r>=ucf#aggregate#complete()\<cr>"
```


## How to use with µcomplete

Define one or more completion methods in your `vimrc`, e.g.:

```vim
let g:mucomplete#user_mappings = {
  \ 'aggr': "\<c-r>=ucf#aggregate#complete()\<cr>"
  \ }
```

Then put the user-defined completion methods in your completion chains,
e.g.:

```vim
let g:mucomplete#chains = { 'default': ['path', 'aggr'] }
```
