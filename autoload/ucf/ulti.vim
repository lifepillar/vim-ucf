" User Completion Functions
" Maintainer: Lifepillar <lifepillar@lifepillar.me>
" License: This file is placed in the public domain

let s:save_cpo = &cpo
set cpo&vim

let s:cmp = 'stridx(v:val, a:word)' . (get(g:, 'ucf#ulti#match_at_start', 1) ? '==0' : '>=0')

fun! s:findstart()
  let l:col = match(getline('.'), '\S\+\%'.col('.').'c')
  return l:col > -1 ? l:col : -2
endf

fun! ucf#ulti#collect(word)
  if empty(UltiSnips#SnippetsInCurrentScope(1))
    return []
  endif
  return map(filter(keys(g:current_ulti_dict_info), s:cmp),
        \  '{
        \      "word": v:val,
        \      "menu": "[snip] ". get(g:current_ulti_dict_info[v:val], "description", ""),
        \      "dup" : 1
        \   }')
endf

fun! ucf#ulti#complete_add(word)
  for l:s in ucf#ulti#collect(a:word)
    call complete_add(l:s)
  endfor
  return []
endf

fun! s:complete(word, col)
  let l:suggestions = ucf#ulti#collect(a:word)
  if !empty(l:suggestions)
    call complete(col('.') - len(a:word), l:suggestions)
  endif
  return ''
endf

fun! ucf#ulti#complete()
  let l:word = matchstr(getline('.'), '\S\+\%'.col('.').'c')
  return s:complete(l:word, col('.') - len(l:word))
endf


fun! ucf#ulti#completefunc(findstart, base) abort
  return a:findstart ? s:findstart() : ucf#ulti#complete_add(a:base)
endf

let &cpo = s:save_cpo
unlet s:save_cpo
