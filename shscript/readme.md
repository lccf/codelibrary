# shell script

### backrun.sh
后台运行脚本
```bash
DIR      #配置程序目录
PROGNAME #配置输出显示程序名称
# run()  方法中配置执行的命令
```

### bashrc_docker.sh
docker 脚本
```bash
docker-ip    #查看docker容器ip
docker-pid   #查看docker pid
docker-enter #通过nsenter进行指定的docker容器
```

### git_ps1.sh
git分支状态高亮

### iterm2-zmodem
iTerm2 zmodem脚本，iterm2-recv-zmodem.sh接收，iterm2-recv-zmodem.sh发送。

### compileCoffee.Makefile
按目录批量编译coffee到js

### pathmuge.sh
PATH环境变量合并，来自centos系统的/etc/profile。

示例：

```bash
pathmunge /usr/sbin
```
