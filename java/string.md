# String

## `String` 源码

`String`类是`final`的，表示是不可被继承的

字符串在`String`中使用`char[]`存储，且`char[]`是`private`和`final`的，表示该`char[]`是不可修改的

因此每一个`String`对象都是不可被修改的，所以是线程安全的，每当对一个`String`变量进行赋值或修改时，都将返回一个新引用

```java
public final class String implements java.io.Serializable, Comparable<String>, CharSequence {
    private final char value[];
    private int hash;
}
```

## `String` 中的常量池

java中常量池的概念主要有三个：全局字符串常量池，class文件常量池，运行时常量池

`String`中使用的便是全局字符串常量池，其作用为：**在堆中创建了对象后其引用插入到字符串常量池中（jdk1.7后），可以全局使用，遇到相同内容的字面量，就不需要再次创建**

在jdk1.8后具体的字符串时存储在堆区中的（防止以`Hashtable`存储在方法区后巨大开销），字符串常量池中存储的是堆中字符串的引用

> 在 HotSpot VM 里实现的 string pool 功能的是一个 StringTable 类，它是一个哈希表，里面存的是驻留字符串(也就是我们常说的用双引号括起来的)的引用（而不是驻留字符串实例本身）

## `String` 两种创建方式

### 1. `String s1 = "Hello World"`

**直接赋值** ： 先检查字符串常量值中是否已有`Hello World`字符串的引用，如果该字符串引用已经存在,那么就直接指向, 如果没有，则在堆区中实例化`Hello World`字符串对象并将该对象的引用添加进常量池并且指向常量池中的引用

变量`s1`储存的是指向常量池中的引用

### 2. `String s2 = new String("Hello World")`

**通过关键词`new`创建** : 会向堆申请内存，来存储`Hello Word`字符串对象，指向的是堆中的字符串对象

通过`new`操作符创建的字符串后会检查常量池，若常量池中未能找到引用指向相同的字符串，即该字符串从未被添加进常量池中过，则将堆区中新建的对象引用添加入常量池中

变量`s2`存储的是指向堆内存中的引用

### 因此`s1 == s2`的结果为`false`

`s1`为常量池内的引用，`s2`为堆中的引用，故两个引用必不相同

当比较`String`内字符串内容时，使用`.equal()`方法

### `new String("Hello")`会创建几个对象？

JVM首先会在常量池中寻找`"Hello"`字符串，若找到，则不做任何事，若没找到，则会创建一个`String`对象，并将该对象的引用加入常量池中

又由于有关键词`new`，因此会在内存中创建`String`对象，并将该引用返回（不是常量池中的引用），赋值给变量

**总结：**`new String("Hello")`创建了两个对象，但是其中一个`new`是用户的行为，而常量池中的则是JVM自主完成的

## `String` 中的字符串拼接

### 1. `String s1 = "Hello" + "World"`

**当字符串是确定值时** : 在编译时会自动将字符串合并 -> `String s1 = "Hello World"`

因此`String a1 = "Hello World"` 和 `String a2 = "Hello" + "World"`，比较`a1 == a2`，结果为`true`

### 2. `String s2 = s1 + "Good"`

**当字符串内容时不确定的时** : 在编译后会使用`StringBuilder`来新建字符串 -> `String s2 = new StringBuilder().append(s1).append("Good")`

因此当需要多次对某个字符串进行修改时，`String`类型每次都需要`new StringBuilder`，开销较大，应直接使用`StringBuilder`

### 3. `final`关键词的优化

JAVA编译器对string + 基本类型/常量 是当成常量表达式直接求值来优化的

```java
final String s1 = "s1";
final String s2 = "s2";
String s3 = "s1s2";
String s12 = s1 + s2;  // str1与str2为常量变量，编译期会被优化
s12 == s3     // true
```

## `String` 中的 `intern()`方法

`String`的`intern()`方法用于扩展常量池

当一个`String`实例`str`调用`intern()`方法时，如果运行时常量池中已经包含一个等于此String对象内容的字符串，则返回常量池中该字符串的引用；如果没有的处理方式是在常量池中创建与此String内容相同的字符串，并返回常量池中创建的字符串的引用

```java
String s1 = "hello";
String s2 = new String("hello");
s1 == s2;   // false
s1 == s2.intern();   // true
```

## 函数参数传递中的`String`

Java中的参数传递是`值传递`，当变量被当作参数时，会先复制一份该变量的值然后传递到函数内

```java
public static void main(String[] args) {
    String s1 = "word";
    change(s1);
    System.out.println(s1);  // 输出word
}

private static void change(String s2) {
    s2 = "word changed";
    System.out.println(s2);  // 输出word changed
}
```

虽然在`main`函数中将`s1`的引用传递给了`change()`函数，但在执行`s2 = "word changed"`时会在常量池中新创建该字符串新的对象，并将`"word change"`所在常量池的引用赋给`s2`，而`s1`仍为`word`所在常量池的引用，即`change()`函数中未将`s1`所在引用存储的字符串进行修改

## `String`中的`hashCode()`

### 源码实现

计算公式：`s[0]*31^(n-1) + s[1]*31^(n-2) + ... + s[n-1]`

在一次`hashCode()`后，会将哈希值存储到其中的`hash`变量中，进行缓存

> `String`中的`hash`变量默认值是0，只有`hash`变量为0才计算`hashCode`，也因此不会缓存哈希值为0的哈希值

```java
public int hashCode() {
    int h = hash;
    if (h == 0 && value.length > 0) {
        char val[] = value;

        for (int i = 0; i < value.length; i++) {
            h = 31 * h + val[i];
        }
        hash = h;
    }
    return h;
}
```

### 为什么选用数字31作为乘子?

1. 31是个不大不小的奇质数
2. 31可以被JVM优化为`31 * i = (i << 5) - i`

### 为什么使用形参`h`？

虽然`String`类是线程安全的，但只是`char[]`数组不可修改保证的，`hash`值在`for`中存在线程不安全的情况

线程1和线程2在计算哈希值时，都发现`hash`为0，进行计算，但如果在`for`中每次都在`hash`变量上进行累加时，会存在重复累加的问题，造成线程不安全的情况，因此使用形参`h`以解决线程安全问题
