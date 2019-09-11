# 修改Mysql数据存储路径

## 修改Mysql根目录下自定义的`my.ini`，保存时必须使用`ASCII`格式保存

将其中的`datadir`设置为自定义的路径

```mysql
[mysqld]
datadir=%PATH%
```

## 重启Mysql服务

- 在Service中重启Mysql服务
- 使用命令`net restart MySQL`重启服务

## 初始化数据库文件

```mysql
mysqld --initialize
```

## 可能出现`TIMESTAMP`的报错

在`my.ini`关闭警告

```mysql
explicit_defaults_for_timestamp=true
```
