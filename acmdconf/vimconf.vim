" --------------------------------------------------
" [autocommand相关配置] {{{
" --------------------------------------------------
" 设置加载模式
let g:acmd_loaded=0
" 设置调试模式
let g:acmd_debug=1
" 调用快捷键
let g:acmd_call_key='<A-s>'
" 针对文件类型
let g:acmd_filetype_list=['haml', 'sass', 'scss', 'less', 'coffee', 'jade', 'ls']
" 执行前置函数默认为保存
fu! Autocommand_before(fullFileName)
	let shortFileName=expand('%:t')
	let isUnderLine=match(shortFileName,'_')
	if isUnderLine==0
		sil up
		retu 0
	el
		retu 1
	en
endf
" 自定义命令
fu! Autocommand_usercmd(fileType)
	if a:fileType=="jade"
		let ret="jade #{$fileName}.jade -Po ./"
	elsei a:fileType=="ls"
		let ret="lsc -bc #{$fileName}"
	el
		let ret=""
	en
	retu l:ret
endf
" }}}
