
if exists('g:loaded_arot13')
	finish
endif
let g:loaded_arot13 = 1
"-=-=-=-=-=-=-=-=-=-"

let s:save_cpo = &cpo
set cpo&vi

command! -narg=1 Rot13Echo call arot13#encode_echo(<q-args>)

command! -narg=1 Rot13Put call arot13#encode_put(<q-args>)

command! -range=% Rot13ReadLine :<line1>, <line2> call arot13#encode_line()

command! -range=% Rot13YankLine :<line1>, <line2> call arot13#yank_line()

let &cpo = s:save_cpo
unlet s:save_cpo
