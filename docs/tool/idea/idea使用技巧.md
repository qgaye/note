# IDEA使用小技巧

## 自动补全返回值

### 方法一：快捷键`Ctrl + Alt + V`

在`new`或函数返回一个对象后，使用快捷键`Ctrl + Alt + V`自动填充变量

### 方法二：(推荐)使用`Postfix Completion`中的`.var`

```java
new String().var
```

还可使用`Shift + Tab`来选择生成变量的类

### 去除`Declare final`选中问题

当自动补全返回值时，可能出现`Declare final`被自动勾选的情况，此时生成的变量自动被`final`修饰

使用`Alt + F`即可去除勾选，并且以后生成的变量也不会被`final`修饰

![declare final被勾选](../pics/declare_final.png)

## 遍历list

使用`Postfix Completion`中的`.for`

```java
list.for
```

## 取反值

使用`Postfix Completion`中的`.not`

```java
list.isEmpty().not
```
