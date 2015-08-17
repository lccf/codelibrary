# acmd配置
[autocommand](https://github.com/thinkjs/autocommand)配置文件，autocommand是一款vim插件（依赖python），用来执行自动命令。配置文件为json格式。示例：

```javascript
{
  "sass/": {
    "path": "~",
    "sass": {
      "command": [
        "sass --sourcemap=none --style compact sass/#{$fileName}.sass | sed '/^@charset/d' > ../html/css/#{$fileName}.css"
         /* , "cp -fp ../css/#{$fileName}.css ../../public/css" */
      ]
    },
    "scss": {
      "command": [
        "sass --sourcemap=none --style compact sass/#{$fileName}.scss | sed '/^@charset/d' > ../html/css/#{$fileName}.css"
         /* , "cp -fp ../css/#{$fileName}.css ../../public/css" */
      ]
    }
  }
} 
```

说明：

- sass/ 表示一个子目录
- path 表示执行命令的路径，~表示在配置文件所在的目录执行
- sass 表示文件后缀为sass格式的
- command 表示执行的命令，可以是数组返回多个命令，会依次执行
- | sed '^@charset/d' 表示用通道将内容输出并使用sed命令删除以 @charset开头的行