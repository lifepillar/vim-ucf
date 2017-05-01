" User Completion Functions
" Maintainer: Lifepillar <lifepillar@lifepillar.me>
" License: This file is placed in the public domain

let s:save_cpo = &cpo
set cpo&vim

fun! s:findstart()
  let l:col = match(getline('.'), '\S\+\%'.col('.').'c')
  return l:col > -1 ? l:col : -2
endf

fun! ucf#omni#collect(word)
  let l:wv = winsaveview()
  execute 'call' &l:omnifunc.'(1,"")'
  execute 'let l:suggestions='.&l:omnifunc.'(0,a:word)'
  call winrestview(l:wv)
  return l:suggestions
endf

fun! ucf#omni#complete_add(word)
  for l:s in ucf#omni#collect(a:word)
    call complete_add(l:s)
  endfor
  return []
endf

fun! s:complete(word, col)
  let l:suggestions = ucf#omni#collect(a:word)
  if !empty(l:suggestions)
    call complete(col('.') - len(a:word), l:suggestions)
  endif
  return ''
endf

fun! ucf#omni#complete()
  let l:word = matchstr(getline('.'), '\S\+\%'.col('.').'c')
  return s:complete(l:word, col('.') - len(l:word))
endf


fun! ucf#omni#completefunc(findstart, base) abort
  return a:findstart ? s:findstart() : ucf#omni#complete_add(a:base)
endf

let &cpo = s:save_cpo
unlet s:save_cpo
