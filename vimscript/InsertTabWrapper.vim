" --------------------------------------------------
" [自动完成函数] {{{
" --------------------------------------------------
" 自动完成
fu! InsertTabWrapper()
	let col=col('.')-1
	return (!col || getline('.')[col-1] !~ '\k') ? "\<TAB>" : "\<C-P>"
endf
" 映射键
ino <TAB> <C-R>=InsertTabWrapper()<CR>
" 强制TAB键
ino <S-TAB> <C-R>="\<TAB>"<CR>
" }}}
