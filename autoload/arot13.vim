scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim
"-=-=-=-=-=-=-=-=-=-"
let s:alpha = [
\	['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'],
\	['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
\]

"" Rot13の計算 ""
function! arot13#calc_encode(str) "{{{
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
				" Rot13を適用
				if a:str[i] == s:alpha[cap][a]
					if a+13 > len(s:alpha[cap][a])-1
						let rot .= s:alpha[cap][a-13]
					else
						let rot .= s:alpha[cap][a+13]
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
function! arot13#encode_echo(str)
	echo arot13#calc_encode(a:str)
endfunction
"}}}
" 受け渡された文字列をput {{{
function! arot13#encode_put(str)
	let result = arot13#calc_encode(a:str)
	let bakpos = getpos('.')
	execute ":normal a" . result
	call setpos('.', bakpos)
endfunction
"}}}
" 範囲指定されたラインをRot13化  {{{
function! arot13#encode_line() range
	let str = ""
	for i in range(a:firstline, a:lastline)
		let str .= getline(i).'\n'
	endfor

	let tmp = @a
	let @a = substitute(arot13#calc_encode(str), '\\n', '\n', 'g')
	execute a:firstline.",".a:lastline."delete"
	execute 'normal "aP'
	let @a = tmp
endfunction
"}}}
" 範囲指定されたラインをRot13化して0レジスタにヤンク  {{{
function! arot13#yank_line() range
	let str = ""
	for i in range(a:firstline, a:lastline)
		let str .= getline(i).'\n'
	endfor

	let @0 = substitute(arot13#calc_encode(str), '\\n', '\n', 'g')
endfunction
"}}}

"-=-=-=-=-=-=-=-=-=-"
let &cpo = s:save_cpo
unlet s:save_cpo
