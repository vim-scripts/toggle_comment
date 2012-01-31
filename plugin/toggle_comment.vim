
" Le mapping des touches
map <silent> q       mZ:call ToggleComment_toggle()<CR>`Z
map <silent> <S-q>   mZ:call ToggleComment_comment()<CR>`Z
"map <silent> <C-q>   mZ:call ToggleComment_uncomment()<CR>`Z
map <silent> <A-q>   mZ:call ToggleComment_uncomment()<CR>`Z

command! -range Ct <line1>,<line2>call ToggleComment_toggle()
command! -range Cc <line1>,<line2>call ToggleComment_comment()
command! -range Cu <line1>,<line2>call ToggleComment_uncomment()


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
let s:sep1 = ','
let s:sep2 = ':'
let s:sep3 = ';'


function! ToggleComment_GetSeparator(cs)
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


function ToggleComment_init()
  if !exists("b:current_syntax")
    echohl ErrorMsg
    echo 'comment plugin : "b:current_syntax" is not defined'
    return [0,'','']
  endif
  let cs=get(s:comment_symbol,b:current_syntax)
  if cs=='0'
    echohl ErrorMsg
    echo 'comment plugin : '.b:current_syntax.' not supported yet'
    return [0,'','']
  endif
  let sep=ToggleComment_GetSeparator(cs)
  if sep==''
    echohl ErrorMsg
    echo 'comment plugin : cannot find correct separator'
    return [0,'','']
  endif
  return [1,cs,sep]
endfunction


function! ToggleComment_toggle()
  let out=ToggleComment_init()
  if out[0]==0
    return
  endif
  let cs=out[1]
  let sep=out[2]

  if get(s:comment_in_place,b:current_syntax)
    execute 's'.sep.'^\s'.sep.'\0'.cs.sep.'e'
    execute 's'.sep.'^\S'.sep.cs.' '.sep.'e'
    execute 's'.sep.'^.'.sep.sep.'e'
    return
  endif
  let dummy_cs=substitute(cs,".","X","g")
  let dot_ncs=substitute(cs,".","\.","g")
  execute 's'.sep.'\(^\s\+\)\('.cs.'\)'.sep.'\2\1'.sep.'e'
  execute 's'.sep.'^\('.cs.'\)\@!.\+'.sep.dummy_cs.cs.'\0'.sep.'e'
  execute 's'.sep.'^'.dot_ncs.sep.sep.'e'
endfunction


function! ToggleComment_comment()
  let out=ToggleComment_init()
  if out[0]==0
    return
  endif
  let cs=out[1]
  let sep=out[2]

  let dot_ncs=substitute(cs,".","\.","g")
  if get(s:comment_in_place,b:current_syntax)
    execute 's'.sep.'^'.dot_ncs.sep.cs.sep.'e'
    return
  endif
  execute 's'.sep.'^\(\s*'.cs.'\)\@!.\+'.sep.cs.'\0'.sep.'e'
endfunction


function! ToggleComment_uncomment()
  let out=ToggleComment_init()
  if out[0]==0
    return
  endif
  let cs=out[1]
  let sep=out[2]

  if get(s:comment_in_place,b:current_syntax)
    let space_ncs=substitute(cs,"."," ","g")
    execute 's'.sep.'^'.cs.sep.space_ncs.sep.'e'
    return
  endif
  execute 's'.sep.'\(^\s\+\)\('.cs.'\)'.sep.'\2\1'.sep.'e'
  execute 's'.sep.'^'.cs.sep.sep.'e'
endfunction

