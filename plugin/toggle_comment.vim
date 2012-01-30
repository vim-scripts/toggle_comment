
" Le mapping des touches
map <silent> q       mZ:call ToggleComment()<CR>`Z
map <silent> <S-q>   mZ:call ForceComment()<CR>`Z
map <silent> <C-q>   mZ:call ForceUnComment()<CR>`Z


" Correspondance 'syntax' / 'comment symbol'
let s:comment_symbol = {
  \  'python'	:  '#',
  \  'fortran'	:  'C',
  \  'vim'	:  '"',
  \  'c'	:  '//',
  \ }

" Indique les 'syntax' où la ligne doit rester inchangée 
let s:comment_in_place = {
  \  'fortran'	:  1,
  \ }

" Un séparateur pour le mode commande.
" Il doit être différent de tous les 'comment symbol'
let s:sep = ','
let s:sep1 = ','
let s:sep2 = ':'
let s:sep3 = ';'


function! GetSeparator(cs)
  if match(a:cs,s:sep1)==-1
    return s:sep1
  endif
  if match(a:cs,s:sep2)==-1
    return s:sep2
  endif
  if match(a:cs,s:sep3)==-1
    return s:sep3
  endif
  return ''
endfunction

function! ToggleComment()
  if !exists("b:current_syntax")
    echohl ErrorMsg
    echo 'comment plugin : "b:current_syntax" is not defined'
    return
  endif
  let cs=get(s:comment_symbol,b:current_syntax)
  if cs=='0'
    echohl ErrorMsg
    echo 'comment plugin : '.b:current_syntax.' not supported yet'
    return
  endif
  let sep=GetSeparator(cs)
  if sep==''
    echohl ErrorMsg
    echo 'comment plugin : cannot find correct separator'
    return
  endif
  if get(s:comment_in_place,b:current_syntax)
    execute 's'.s:sep.'^\s'.s:sep.'\0'.cs.s:sep.'e'
    execute 's'.s:sep.'^\S'.s:sep.cs.' '.s:sep.'e'
    execute 's'.s:sep.'^.'.s:sep.s:sep.'e'
    return
  endif
  let dummy_cs=substitute(cs,".","X","g")
  let dot_ncs=substitute(cs,".","\.","g")
  execute 's'.s:sep.'\(^\s\+\)\('.cs.'\)'.s:sep.'\2\1'.s:sep.'e'
  execute 'silent .g!'.s:sep.'^'.cs.s:sep.'s'.s:sep.dot_ncs.s:sep.dummy_cs.cs.'\0'.s:sep.'e'
  execute 's'.s:sep.'^'.dot_ncs.s:sep.s:sep.'e'
endfunction


function! ForceComment()
  if !exists("b:current_syntax")
    echohl ErrorMsg
    echo 'comment plugin : "b:current_syntax" is not defined'
    return
  endif
  let cs=get(s:comment_symbol,b:current_syntax)
  if cs=='0'
    echohl ErrorMsg
    echo 'comment plugin : '.b:current_syntax.' not supported yet'
    return
  endif
  let sep=GetSeparator(cs)
  if sep==''
    echohl ErrorMsg
    echo 'comment plugin : cannot find correct separator'
    return
  endif
  let dot_ncs=substitute(cs,".","\.","g")
  if get(s:comment_in_place,b:current_syntax)
    execute 's'.s:sep.'^'.dot_ncs.s:sep.cs.s:sep.'e'
    return
  endif
  execute 'silent .g!'.s:sep.'^\s*'.cs.s:sep.'s'.s:sep.dot_ncs.s:sep.cs.'\0'.s:sep.'e'
endfunction


function! ForceUnComment()
  if !exists("b:current_syntax")
    echohl ErrorMsg
    echo 'comment plugin : "b:current_syntax" is not defined'
    return
  endif
  let cs=get(s:comment_symbol,b:current_syntax)
  if cs=='0'
    echohl ErrorMsg
    echo 'comment plugin : '.b:current_syntax.' not supported yet'
    return
  endif
  let sep=GetSeparator(cs)
  if sep==''
    echohl ErrorMsg
    echo 'comment plugin : cannot find correct separator'
    return
  endif
  if get(s:comment_in_place,b:current_syntax)
    let space_ncs=substitute(cs,"."," ","g")
    execute 's'.s:sep.'^'.cs.s:sep.space_ncs.s:sep.'e'
    return
  endif
  execute 's'.s:sep.'\(^\s\+\)\('.cs.'\)'.s:sep.'\2\1'.s:sep.'e'
  execute 's'.s:sep.'^'.cs.s:sep.s:sep.'e'
endfunction

