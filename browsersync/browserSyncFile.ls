path        = require \path
exec        = require \child_process .exec
browserSync = require \browser-sync .create!
notifier    = require \node-notifier
fs          = require \fs

# config {{{
baseDir = '.'

outputDir = './html'
cssOutputDir = "./html/css"
jsOutputDir = "./html/js"

reloadWatchFile = ''
  # "#outputDir/*.html"
  # "#jsOutputDir/*.js"
  # "HZ.WapApp.UI/Content/img/*.*"

compileWatchFile =
  "_source/jade/*.jade"
  "_source/live/*.ls"
  "_source/sass/*.sass"
  "_source/riot/*.html"
  "_source/template/*.html"

autoCompileFile = false
#autoCompileFile = true
# }}}
# showMessage {{{
showMessage = (title, message) ->
  console.log message

  notifier.notify do
    title   : title
    message : message
    sound   : true
# }}}
# getTimeToken {{{
getTimeToken = ->
  currDate = new Date()
  hours = currDate.getHours()
  minutes = currDate.getMinutes()
  seconds = currDate.getSeconds()
  if hours < 10
    hours = "0#hours"
  if minutes < 10
    minutes = "0#minutes"
  if seconds < 10
    seconds = "0#seconds"
  "#hours:#minutes:#seconds"
# }}}
# compileTask {{{
getCompileCmdAndFileName = (file, ext) ->
  filename = path.basename file, ext
  relativePath = path.relative baseDir, path.dirname(file)
  if path.sep isnt \/
    relativePath = relativePath.split path.sep .join \/
    file = file.split path.sep .join \/

  switch ext
  case '.jade' then
    compileFileName = "#outputDir/#{filename}.html"
    cmd = "jade -Po #outputDir #file"
  case '.sass' then
    compileFileName = "#cssOutputDir/#{filename}.css"
    cmd = "sass --sourcemap=none --style compact #file|sed '/^@charset/d'>#compileFileName"
  case '.coffee' then
    compileFileName = "#jsOutputDir/#{filename}.js"
    cmd = "coffee --no-header -bco #jsOutputDir #file"
  case '.html' then
    if relativePath is '_source/riot'
      compileFileName = "#jsOutputDir/riot/#{filename}.js"
      cmd = "riot --ext html --expr #file #compileFileName"
    else if relativePath is '_source/template'
      # 计算模板引用名称
      templateName = filename
      # 生成coffee模板
      templateHtml = fs.readFileSync file
      coffeeCode = "#{templateName} = \"\"\"\n#{templateHtml}\n\"\"\"\n"
      coffeeCode += "ndoo.service('template').set('#{templateName}', #{templateName})"
      fs.writeFileSync "#relativePath/#filename.coffee", coffeeCode
      # 生成文件名及模板
      compileFileName = "#relativePath/#filename.js"
      cmd = ["coffee --no-header -co #jsOutputDir/template #relativePath/#filename.coffee", "rm -f #relativePath/#filename.coffee"]
  case '.ls' then
    compileFileName = "#jsOutputDir/#{filename}.js"
    cmd = "lsc --no-header -co #jsOutputDir #file"
  default
    compileFileName = cmd = ''
  [cmd, compileFileName]

compileTask = (file, ext, reload) !->
  cmdIndex = -1
  try
    [cmd, filename] = getCompileCmdAndFileName file, ext

  if not cmd or not filename
    showMessage 'Get Command Error', "cmd not define. file: #file ext: #ext"

  # exec callback
  execCallback = (err, stdo, stde) !->
    if err is null and not stde
      if cmdIndex is -1
        console.log "[#{getTimeToken!}] compiled #filename"
        reload filename if reload
      else
        execCmd()
    else
      showMessage "Compile Error", err || stde

  # execute command
  do execCmd = !->
    if Array.isArray cmd
      currCmd = cmd[++cmdIndex]
      if cmd.length <= cmdIndex+1
        ``cmdIndex = -1;``
    else
      currCmd = cmd

    if currCmd
      exec currCmd, execCallback

compileCallback = (file) !->
  ext = path.extname file
  filename = path.basename file

  # ignore partial file
  if filename.charAt(0) is '_'
    return undefined

  switch ext
  case '.jade', '.coffee', '.ls', '.sass', '.html'
    compileTask file, ext, browserSync.reload
  default
    showMessage "File Type Error", 'unknown file type.'
# }}}
# browserSync {{{
browserSync.init do
  server:
    baseDir: outputDir
    index: \index.html
  open: false

if reloadWatchFile and reloadWatchFile.length
  browserSync.watch reloadWatchFile
  .on \change, browserSync.reload

wacher = browserSync.watch compileWatchFile
.on \change, compileCallback

# auto compile file
if autoCompileFile
  wacher.on \add, compileCallback
# }}}

# vim: set sw=2 ts=2 sts=2 et fdm=marker:
