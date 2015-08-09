# browserSync预编译脚本
使用browserSync来自动编译jade/sass/coffeescript/livescript等前端预处理器语言。使用browserSync的watch功能侦测文件改动，根据文件类型找到对应的编译命令并调用nodejs的child_process模块执行编译命令，编译完成后调用browserSync的livereload功能触发浏览器自动刷新。本脚本使用livescript编译，用到browserSync和nodejs的path、child_process模块，如有使用疑问可至相应官网查找对应资料。

## 使用
```bash
# 安装依赖
gem install sass
npm install browser-sync jade coffee-script livescript -g
# 使用
lsc browserSyncFile.ls
```
鉴于墙了的网络问题，建议大家访问[http://ruby.taobao.org](http://ruby.taobao.org)和[http://npm.taobao.org](http://npm.taobao.org)设置国内镜像以加速安装。

## 配置
```javascript
//browser http server基础路径
baseDir
// 默认jade编译输出目录
outputDir
// 默认css编译输出目录
cssOutputDir
// 默认js编译输出目录
jsOutputDir
// 检测此配置项中的文件改动，发生变更时触发livereload。
// 默认留空，因为compile动作会自动触发livereload。
reloadWatchFile
// 检测此配置项中的文件改动，发生变更时触发编译动作
compileWatchFile
// 自动编译，为true时。启动本脚本自动将compileWatchFile中的所有文件编译一遍。
autoCompileFile
```

## 自定义
### 自定义文件类型
compileCallback函数接受watch事件传入的文件名，并分解出文件后缀和需要跳过的文件。默认会处理后缀为.jade、.coffee、.ls、.sass的文件，以_打头的文件被认为是局部文件，自动忽略。可以在这里添加一种文件类型(如.less)，添加文件后需要针对该文件类型定义编译命令。
### 自定义编译命令
getCompileCmdAndFileName函数中处理传入的文件、扩展名并返回对应的执行命令。可以使用数组返回多条命令，会依次执行。relativePath为文件相对于baseDir的路径，用来处理子目录编译到不同路径的差异化需求。
