" User Completion Functions
" Maintainer: Lifepillar <lifepillar@lifepillar.me>
" License: This file is placed in the public domain

let s:save_cpo = &cpo
set cpo&vim

if exists('*matchstrpos')
  fun! s:getword()
    return matchstrpos(getline('.'), '\w\+\%'.col('.').'c')
  endf
else
  fun! s:getword()
    return [matchstr(getline('.'), '\w\+\%'.col('.').'c'), match(getline('.'), '\w\+\%'.col('.').'c'), 0]
  endf
endif

fun! s:findstart()
  let l:col = match(getline('.'), '\S\+\%'.col('.').'c')
  return l:col > -1 ? l:col : -2
endf

fun! ucf#spel#collect(word)
  return spellsuggest(
        \  get(g:, 'ucf#spel#good_words', 0)
        \  ? a:word
        \  : spellbadword(a:word)[0]
        \  , get(g:, 'ucf#spel#max', 25))
endf

fun! ucf#spel#complete_add(word)
  for l:s in ucf#spel#collect(a:word)
    call complete_add(l:s)
  endfor
  return []
endf

fun! s:complete(word, col)
  let l:suggestions = ucf#spel#collect(a:word)
  if !empty(l:suggestions)
    call complete(1 + a:col, l:suggestions)
  endif
  return ''
endf

fun! ucf#spel#complete()
  let [l:word, l:col, l:_] = s:getword()
  return s:complete(l:word, l:col)
endf


fun! ucf#spel#completefunc(findstart, base) abort
  return a:findstart ? s:findstart() : ucf#spel#complete_add(a:base)
endf

let &cpo = s:save_cpo
unlet s:save_cpo
