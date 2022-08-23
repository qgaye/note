# Spring杂录

## Mac上启动SpringBoot很慢

启动服务很慢，第一行显示日志`InetAddress.getLocalHost().getHostName() took 5004 milliseconds to respond. Please verify your network configuration (macOS machines may need to add entries to /etc/hosts).`

首先`hostname`命令查看本机hostname，然后修改`/private/etc/hosts`

```txt
127.0.0.1                localhost  ->  修改为本机hostname
255.255.255.255     　　　broadcasthost
::1                      localhost  ->  修改为本机hostname
```
