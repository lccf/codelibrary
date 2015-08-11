# browserSync预编译脚本
使用browserSync来自动编译jade/sass/coffeescript/livescript等前端预处理器语言。使用browserSync的watch功能侦测文件改动，根据文件类型找到对应的编译命令并调用nodejs的child_process模块执行编译命令，编译完成后调用browserSync的livereload功能触发浏览器自动刷新。本脚本使用livescript编译，用到browserSync和nodejs的path、child_process模块，如有使用疑问可至相应官网查找资料。

## 使用
```bash
# 安装依赖
gem install sass
npm install browser-sync jade coffee-script livescript -g
# 使用
lsc browserSyncFile.ls
# 执行命令后结果应显示如下结果：
[BS] Access URLs:
 ---------------------------------------
       Local: http://localhost:3000
    External: http://192.168.1.123:3000
 ---------------------------------------
          UI: http://localhost:3001
 UI External: http://192.168.1.123:3001
 ---------------------------------------
```
使用浏览器打开Local的地址(我这里是localhost:3000)，可访问生成的web页面。
鉴于墙内的网络问题，建议大家访问[http://ruby.taobao.org](http://ruby.taobao.org)和[http://npm.taobao.org](http://npm.taobao.org)设置国内镜像以加速安装。

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
compileCallback函数接受watch事件传入的文件名并分解文件后缀。默认会处理后缀为.jade、.coffee、.ls、.sass的文件，以_打头的文件被认为是局部文件，自动忽略。可以在这里添加一种文件类型(如.less)或一种忽略规则，添加文件类型后需要针对该类型定义编译命令。
### 自定义编译命令
getCompileCmdAndFileName函数中处理传入的文件、扩展名并返回对应的执行命令。可以使用数组返回多条命令，会依次执行。relativePath表示文件相对于baseDir的路径，用来处理子目录编译到不同路径的差异化需求。

## browserSync配置
browserSync配置见官网说，[http://www.browsersync.io/docs/options/](http://www.browsersync.io/docs/options/)，这里只对用到的进行说明。

```javascript
browserSync.init({
  // 服务器配置
  server: {
    // web服务器根目录
    baseDir: outputDir,
    // 索引页
    index: 'index.html'
  },
  // 是否自动打开浏览器
  open: false
});
```