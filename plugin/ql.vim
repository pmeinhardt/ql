if exists('g:loaded_ql')
  finish
endif
let g:loaded_ql = 1

let s:path = fnamemodify(fnamemodify(resolve(expand('<sfile>:p')), ':h'), ':h')
let s:cmd = exepath(s:path . '/bin/ql')

if exists('g:ql_command')
  let s:cmd = g:ql_command
elseif s:cmd != ''
  let s:cmd = s:cmd
elseif executable('ql')
  let s:cmd = exepath('ql')
elseif executable('qlmanage')
  let s:cmd = 'qlmanage -p'
elseif executable('open')
  let s:cmd = 'open'
endif

 function! s:exec(cmd, ...)
   if a:0 > 0
     let output = system(a:cmd, a:1)
   else
     let output = system(a:cmd)
   endif

   if v:shell_error != 0
     throw output
   endif
 endfunction

function! s:compile() abort
  call s:exec('cd ' . s:path . ' && make')
endfunction

function! s:view(...) abort
  if a:0 == 0
    let path = tempname() . '.' . expand('%:t')
    execute 'write ' . (fnameescape(path))
  else
    let path = a:1
  endif

  if !filereadable(path)
    throw 'File not found: ' . path
  endif

  call s:exec(s:cmd . ' ' . shellescape(path))
endfunction

nnoremap <silent> <Plug>QuickLookCompile :call <SID>compile()<CR>
nnoremap <silent> <Plug>QuickLook :call <SID>view()<CR>

command! QuickLookCompile call s:compile()
command! -nargs=? -complete=file QuickLook call s:view(<f-args>)
