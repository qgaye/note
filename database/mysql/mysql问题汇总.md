# MySQL问题汇总

## 如何修改`auto_increment`的值?

### 查看当前表的`auto_increment`的值

```sql
SELECT auto_increment FROM information_schema.tables WHERE table_schema='DATABASE_NAME' AND table_name='TABLE_NAME';
```

### 修改当前表的`auto_increment`的值

```sql
ALTER TABLE [TABLE_NAME] auto_increment = 1;
```

## sql中循环的实现

```sql
DELIMITER $$   // 自定义结束符为$$

DROP PROCEDURE IF EXISTS wk;
CREATE PROCEDURE wk()
  BEGIN
    DECLARE i INT;
    SET i = 1;
    WHILE i < 10 DO
      // SQL
      SET i = i + 1;
    END WHILE;
  END $$

DELIMITER ;   // 将结束符定义回;
CALL wk();
```

## 查看和修改表的注释

### 查看表注释

```sql
SHOW CREATE TABLE [TABLE_NAME]; 
```

### 修改表注释

```sql
ALTER TABLE [TABLE_NAME] COMMENT 'NEW_COMMENT';
```

## 在WorkBench中生成ERR图

在`WorkBench`中选择`Database -> Reverse Engineer`，选择待生成的数据库，生成ERR图

## 修改mysql数据存储路径

修改Mysql根目录下自定义的`my.ini`，保存时必须使用`ASCII`格式保存，将其中的`datadir`设置为自定义的路径

```mysql
[mysqld]
datadir=%PATH%
```

最后重启并使用`mysqld --initialize`初始化数据库文件

## 隔离级别

```sql
-- 设置隔离级别
set [GLOBAL | SESSION] transaction [READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE]
```

MySQL中默认隔离级别为REPEATABLE READ

```sql
-- 查看全局隔离级别
select @@global.transaction_isolation;
-- 查看会话隔离级别
select @@transaction_isolation;
```

在MySQL5.7中使用`tx_isolation`作为`transaction_isolation`的别名，但在8.0中已被弃用