# Mysql中的小问题

## 1. 如何修改`auto_increment`的值?

### 查看当前表的`auto_increment`的值

```sql
SELECT auto_increment FROM information_schema.tables WHERE table_schema='DATABASE_NAME' AND table_name='TABLE_NAME';
```

### 修改当前表的`auto_increment`的值

```sql
ALTER TABLE [TABLE_NAME] auto_increment = 1;
```

## 2. sql中循环的实现

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

## 3. 查看和修改表的注释

### 查看表注释

```sql
SHOW CREATE TABLE [TABLE_NAME]; 
```

### 修改表注释

```sql
ALTER TABLE [TABLE_NAME] COMMENT 'NEW_COMMENT';
```

## 4. 在WorkBench中生成ERR图

在`WorkBench`中选择`Database -> Reverse Engineer`，选择待生成的数据库，生成ERR图