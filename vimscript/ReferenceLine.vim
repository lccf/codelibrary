" --------------------------------------------------
" [参考线切换] {{{
" --------------------------------------------------
fu! ReferenceLine(t)
	if exists('w:ccnum')
		let ccnum=w:ccnum
	elsei exists('b:ccnum')
		let ccnum=b:ccnum
	else
		let ccnum=0
	en
	let oldcc=ccnum
	" let ccc=&cc
	" ec oldcc
	let ccc=','.&cc.','
	" add/sub
	if a:t=='add' || a:t=='sub'
		" check old cc
		if match(ccc, ','.oldcc.',')<0
			let oldcc=0
			let ccnum=0
		en
		" step
		let csw=&sw
		if a:t=='add'
			let ccnum=ccnum + csw
		elsei a:t=='sub'
			let ccnum=ccnum - csw
			if ccnum < 0 | let ccnum=0 | en
		en
		if oldcc > 0 | let ccc=substitute(ccc, ','.oldcc.',', ',', '') | en
		let ccc=ccc.ccnum
		" ec ccc
		" ec ccnum
		let ccc=substitute(ccc, '^0,\|,0,\|,0$', ',', 'g')
		let ccc=substitute(ccc, '^,\+\|,\+$', '', 'g')
		" ec ccc
		let w:ccnum=ccnum
		let b:ccnum=ccnum
		exec "setl cc=".ccc
	" del
	elsei a:t=='del'
		let ccc=substitute(ccc, ','.oldcc.',', ',', '')
		let ccc=substitute(ccc, '^,\+\|,\+$', '', 'g')
		" ec ccc
		let w:ccnum=0
		let b:ccnum=0
		exec "setl cc=".ccc
	en
endf
nn <silent> <A-u> :call ReferenceLine('sub')<CR>
nn <silent> <A-o> :call ReferenceLine('add')<CR>
" }}}
