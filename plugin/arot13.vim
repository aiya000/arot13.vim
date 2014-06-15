
if exists('g:loaded_arot13')
	finish
endif
let g:loaded_arot13 = 1
"-=-=-=-=-=-=-=-=-=-"

let s:save_cpo = &cpo
set cpo&vi

command! -narg=1 ArotRot13Echo call arot13#encode_echo(13, <q-args>)
command! -narg=+ ArotRotNEcho  call arot13#encode_echo(<f-args>)

command! -narg=1 ArotRot13Put  call arot13#encode_put(13, <q-args>)
command! -narg=+ ArotRotNPut   call arot13#encode_put(<f-args>)

command! -narg=* -range=% ArotRot13ReadLine :<line1>, <line2> call arot13#encode_line(13, <f-args>)
command! -narg=+ -range=% ArotCaesarReadLine :<line1>, <line2> call arot13#encode_line(<f-args>)

command! -narg=* -range=% ArotRot13YankLine :<line1>, <line2> call arot13#yank_line(13, <f-args>)
command! -narg=* -range=% ArotCaesarYankLine :<line1>, <line2> call arot13#yank_line(<f-args>)


"-=-=-=-=-=-=-=-=-=-"
let &cpo = s:save_cpo
unlet s:save_cpo
