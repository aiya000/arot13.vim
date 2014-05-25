
if exists('g:loaded_arot13')
	finish
endif
let g:loaded_arot13 = 1
"-=-=-=-=-=-=-=-=-=-"

let s:save_cpo = &cpo
set cpo&vi

command! -narg=1 Rot13Echo call arot13#encode_echo(13, <q-args>)
command! -narg=+ RotNEcho  call arot13#encode_echo(<f-args>)

command! -narg=1 Rot13Put  call arot13#encode_put(13, <q-args>)
command! -narg=+ RotNPut   call arot13#encode_put(<f-args>)

command! -narg=* -range=% Rot13ReadLine :<line1>, <line2> call arot13#encode_line(13, <f-args>)

command! -narg=* -range=% Rot13YankLine :<line1>, <line2> call arot13#yank_line(13, <f-args>)



let &cpo = s:save_cpo
unlet s:save_cpo
