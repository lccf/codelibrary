" --------------------------------------------------
" [寻找下一个缩进] {{{
" --------------------------------------------------
fu! FindNextIndent()
	let currLine=line('.')
	let currIndent=match(getline(currLine), '[^ \t]')
	let maxLine=line('$')
	wh currLine < maxLine
		let currLine+=1
		let lineContent=getline(currLine)
		if lineContent == '' | con | en
		let lineIndent = match(lineContent, '[^ \t]')
		if lineIndent <= currIndent
			"ec 'currLine:'.currLine
			"ec 'currIndent:'.currIndent
			cal cursor(currLine-1, currIndent+1)
			brea
		en
	endw
endf
" }}}
