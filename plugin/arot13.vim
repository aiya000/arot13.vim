
if exists('g:loaded_arot13')
	finish
endif
let g:loaded_arot13 = 1
"-=-=-=-=-=-=-=-=-=-"

let s:save_cpo = &cpo
set cpo&vi

command! -narg=1 Arot13 call arot13#encode_echo(<q-args>)

command! -narg=1 Arot13P call arot13#encode_put(<q-args>)

command! -range=% Arot13L :<line1>, <line2> call arot13#encode_line()

let &cpo = s:save_cpo
unlet s:save_cpo
