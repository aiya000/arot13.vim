scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim
"-=-=-=-=-=-=-=-=-=-"
let s:alpha = [
\	['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'],
\	['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
\	['!', '"', '#', '$', '%', '&', '''', '(', ')', '-', '=', '^', '~', '|', '@', '`', '[', '{', ':', '*', ']', '}', '<', '>', '/', '?', '_', '.', ',', ' ', '	']
\]

"" Rot13自体の計算 ""
function! arot13#calc_encode(str) "{{{
	let rot = ""
	" 文字列中の文字比較ループ
	let escFlag = 0
	for i in range(0, strlen(a:str)-1)
		" エスケープシーケンスに対応
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

		let eqFlag = 0
		" アルファベット(小大)と比較ループ
		for cap in range(0, 1)
			for a in range(0, len(s:alpha[cap])-1)
				" Rot13を適用
				if a:str[i] == s:alpha[cap][a]
					if a+13 > len(s:alpha[cap][a])-1
						let rot .= s:alpha[cap][a-13]
						let eqFlag = 1
					else
						let rot .= s:alpha[cap][a+13]
						let eqFlag = 1
					endif
				endif
			endfor
		endfor

		" 比較対象が記号だった場合
		for sig in range(0, len(s:alpha[2])-1)
			if a:str[i] == s:alpha[2][sig]
				let rot .= s:alpha[2][sig]
				let eqFlag = 1
			endif
		endfor

		" どれにも合致しなかったときに?を追加
		if !eqFlag
			let rot .= "?"
		endif

	endfor

	return rot
endfunction "}}}

"" フロントエンド ""
function! arot13#encode_echo(str) "{{{
	echo arot13#calc_encode(a:str)
endfunction "}}}
function! arot13#encode_put(str) "{{{
	let result = arot13#calc_encode(a:str)
	let bakpos = getpos('.')
	execute ":normal a" . result
	call setpos('.', bakpos)
endfunction "}}}

"" 範囲指定での受け渡し ""
function! arot13#encode_line() range "{{{
	let str = ""
	for i in range(a:firstline, a:lastline)
		let str .= getline(i).'\n'
		VimConsoleLog str
	endfor

	let tmp = @a
	let @a = substitute(arot13#calc_encode(str), '\\n', '\n', 'g')
	execute a:firstline.",".a:lastline."delete"
	execute 'normal "aP'
	let @a = tmp
endfunction "}}}

"-=-=-=-=-=-=-=-=-=-"
let &cpo = s:save_cpo
unlet s:save_cpo
