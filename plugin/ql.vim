if exists('g:loaded_ql')
  finish
endif
let g:loaded_ql = 1

let s:path = fnamemodify(fnamemodify(resolve(expand('<sfile>:p')), ':h'), ':h')
let s:cmd = exepath(s:path . '/bin/ql')

if exists('g:ql_command')
  let s:cmd = g:ql_command
elseif !empty(s:cmd)
  let s:cmd = s:cmd . ' --title "$TITLE"'
elseif executable('ql')
  let s:cmd = exepath('ql') . ' --title "$TITLE"'
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
  let argc = a:0

  if argc > 0
    let path = a:1
    let name = fnamemodify(path, ':t')
  else
    let name = expand('%:t')
    let path = tempname() . '.' . name
    silent execute 'write ' . fnameescape(path)
  endif

  if !filereadable(path)
    throw 'File not found: ' . path
  endif

  if argc > 1
    let title = a:2
  else
    let title = name
  endif

  let l:cmd = 'export TITLE=' . shellescape(title) . ' && ' . s:cmd
  call s:exec(l:cmd . ' ' . shellescape(path))
endfunction

function! ql#view(...) abort
  return call('s:view', a:000)
endfunction

nnoremap <silent> <Plug>QuickLookCompile :call <SID>compile()<CR>
nnoremap <silent> <Plug>QuickLook :call <SID>view()<CR>

command! QuickLookCompile call s:compile()
command! -nargs=? -complete=file QuickLook call s:view(<f-args>)
