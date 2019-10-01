# MySQL基础

## SQL何执行流程

![mysql基本架构示意图](../pics/mysql_sql_execute.png)

- Server层：包括连接器、查询缓存、分析器、优化器、执行器等，所有内置函数、存储过程、触发器、视图等也在该层
- 存储引擎层：负责数据存储和提起，其架构是插件式的，支持InnoDB、MyISAM、Memory等存储引擎

### 连接器

当建立连接时，连接器会到权限表中查出你拥有的所有权限，之后的该连接中的所有权限判断都依赖于刚刚读取到的权限，因此当更新权限后需要建立新的连接才能起效

建立连接的过程通常比较复杂，所以减少连接动作，尽量使用长连接(连接成功后，如果客户端持续有请求，则一直使用同一连接)

### 查询缓存

查询缓存指之前执行过的语句及其结果可能会以key-value对的形式，被直接缓存在内存中。key是查询的语句，value是查询的结果。如果你的查询能够直接在这个缓存中找到key，那么这个value就会被直接返回给客户端

**但大多数情况下不建议使用查询缓存**，因为查询缓存失效特别频繁，只要对表进行了更新，该表的所有查询缓存都会被删除，可能前面好不容易存下来的查询缓存还没用就被删除了，反而更浪费性能

在MySQL 8.0版本直接将查询缓存的整块功能删掉了

### 分析器

先做词法分析，例如`SELECT`等关键词，还有表名和列名

再做语法分析，判断输入的语句是否满足语法

### 优化器

在正式执行之前，MySQL会就索引的选择(当存在多个索引时)，表的连接顺序(多表做join时)等做出选择，从众多的选择中选择一个

### 执行器

在执行前要先判断一下对这张表是否有操作权限(由于某些触发器会在执行时才知晓具体的表，因此无法在优化器前做权限检查)

执行器就会根据表的引擎定义，去使用这个引擎提供的接口，例如调取InnoDB引擎接口获取这个表的第一行

## bin log和redo log日志模块

### redo log

redo log是InnoDB的，其记录了该行所在页做了什么改动，其作用是由于日志先被写入，使得写入磁盘的动作可以延迟(这就是MySQL中常说的WAL技术(Write-Ahead Logging))

InnoDB的redo log大小是固定的，循环写入。write pos是当前记录的位置，checkpoint是当前要擦除的位置，两者之间的空间是可用的，当write pos追上了checkpoint，就让checkpoint向后推进擦除一部分数据

有了redo log，InnoDB就可以保证即使数据库发生异常重启，之前提交的记录都不会丢失，这个能力称为crash-safe

### bin log

MySQL整体来看有两层，引擎层中InnoDB引擎负责管理redo log，而在Server层也有自己的日志，称为bin log(归档日志)

起初MySQL自带的引擎是MyISAM，但MyISAM是不具备crash-safe的能力的，bin log只提供归档功能，InnoDB发现只依靠bin log无法提供crash-safe功能，因此引入了redo log来实现crash-safe功能

### 两个日志模块差异

- redo log是InnoDB引擎特有的；bin log是MySQL的Server层实现的，所有引擎都可以使用
- redo log是物理日志，记录的是在某个数据页上做了什么修改；bin log是逻辑日志，记录的是这个语句的原始逻辑，比如给ID=2这一行的c字段加1
- redo log是循环写的，空间固定会用完；bin log是可以追加写入的。追加写是指bin log文件写到一定大小后会切换到下一个，并不会覆盖以前的日志

### 两个记录模块记录流程

首先来看一下update操作时bin log和redo log的记录流程，浅色表示在InnoDB中执行，深色表示在执行器中执行

![binlog和redolog记录流程](../pics/mysql_update_execute.png)

可以发现在最后三步中将redo log拆分为了prepare和commit两个阶段，其实本质就是将redo log包装成事务，确保redo log和bin log同时写入，防止使用bin log恢复数据库的状态和现有数据库状态不一致

- 先写redo log后写bin log：redo log写入后即使数据库奔溃，数据也能正常恢复进数据库，但是当通过bin log恢复数据库时，由于bin log未被写入，因此恢复出来的数据库会比现有数据库状态少上那一条
- 先写bin log后写redo log：当通过bin log恢复数据库时，未被持久化到数据库的数据也会被恢复(redo log没写入，因此数据库没有这条数据)
