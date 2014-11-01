scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim
"-=-=-=-=-=-=-=-=-=-"
let s:alpha = [
\	['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'],
\	['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
\]

"" Rot n(Caesar)の計算 ""
let s:ALPHA_NUM = 26
function! arot13#calc_encode(shiftN, str) "{{{
	let rot = ""
	" 文字列中の文字比較ループ
	let escFlag = 0
	for i in range(0, strlen(a:str)-1)

		" 改行を認識
		if escFlag
			let char = a:str[i]
			if char == 'n'
				let rot .= '\n'
				let escFlag = 0
				continue
			else
				let rot .= '\'
				let escFlag = 0
			endif
		endif
		if a:str[i] == '\'
			let escFlag = 1
			continue
		endif

		let addedFlag = 0
		" アルファベット(小大)と比較ループ
		for cap in range(0, 1)
			for a in range(0, len(s:alpha[cap])-1)
				" Rot nを適用
				if a:str[i] == s:alpha[cap][a]
					if a+13 > len(s:alpha[cap][a])-1
						let rot .= s:alpha[cap][a - (s:ALPHA_NUM - a:shiftN)]
					else
						let rot .= s:alpha[cap][a + (s:ALPHA_NUM - a:shiftN)]
					endif
					let addedFlag = 1
				endif
			endfor
		endfor

		" どれにも合致しなかったときに文字をそのまま追加
		if !addedFlag
			let rot .= a:str[i]
		endif

	endfor

	return rot
endfunction "}}}

"" 実際の操作 ""
" 受け渡された文字列をecho {{{

function! arot13#encode_echo(n, str)
	echo arot13#calc_encode(a:n, a:str)
endfunction

"}}}
" 受け渡された文字列をput {{{

function! arot13#encode_put(n, str)
	let result = arot13#calc_encode(a:n, a:str)
	let bakpos = getpos('.')
	execute 'normal! i' . result
	call setpos('.', bakpos)
endfunction

"}}}
" 範囲指定されたラインをRot n化  {{{

function! arot13#encode_line(n) range
	let str = ""
	for i in range(a:firstline, a:lastline)
		let str .= getline(i) . '\n'
	endfor

	execute a:firstline.",".a:lastline."delete"
	execute 'normal! i' . substitute(arot13#calc_encode(a:n, str), '\\n', '\n', 'g')
endfunction

"}}}
" 範囲指定されたラインをRot13化して"レジスタにヤンク  {{{

function! arot13#yank_line(n) range
	let str = ""
	for i in range(a:firstline, a:lastline)
		let str .= getline(i).'\n'
	endfor

	let @" = substitute(arot13#calc_encode(a:n, str), '\\n', '\n', 'g')
endfunction

"}}}

"-=-=-=-=-=-=-=-=-=-"
let &cpo = s:save_cpo
unlet s:save_cpo
