" User Completion Functions
" Maintainer: Lifepillar <lifepillar@lifepillar.me>
" License: This file is placed in the public domain

let s:save_cpo = &cpo
set cpo&vim

let g:ucf#aggregate#functions = ['ulti', 'omni']

fun! s:functions()
  return get(b:, 'ucf_aggregate_functions', get(g:, 'ucf#aggregate#functions', []))
endf

fun! s:findstart()
  let l:col = match(getline('.'), '\S\+\%'.col('.').'c')
  return l:col > -1 ? l:col : -2
endf

fun! ucf#aggregate#collect(word)
  let l:suggestions = []
  for l:f in s:functions()
    execute 'call extend(l:suggestions,' 'ucf#'.l:f.'#collect(a:word))'
  endfor
  return l:suggestions
endf

fun! ucf#aggregate#complete_add(word)
  for l:f in s:functions()
    execute 'call' 'ucf#'.l:f.'#complete_add(a:word)'
  endfor
  return []
endf

fun! s:complete(word, col)
  let l:wv = winsaveview()
  let l:suggestions = ucf#aggregate#collect(a:word)
  call winrestview(l:wv)
  if !empty(l:suggestions)
    call complete(col('.') - len(a:word), l:suggestions)
  endif
  return ''
endf

fun! ucf#aggregate#complete()
  let l:word = matchstr(getline('.'), '\S\+\%'.col('.').'c')
  return s:complete(l:word, col('.') - len(l:word))
endf


fun! ucf#aggregate#completefunc(findstart, base) abort
  return a:findstart ? s:findstart() : ucf#aggregate#complete_add(a:base)
endf

let &cpo = s:save_cpo
unlet s:save_cpo

