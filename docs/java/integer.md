# Integer

## Integer源码

`Integer`类是基本数据类型`int`的包装类，是抽象类`Number`的子类，且实现了`Compareable`接口，即可比较大小

`Integer`中使用`int`类型来存储数据，且是被`final`修饰的，即不可被修改的

`MAX_VALUE`表示`int`能表示的最大值，为`2^31 - 1`

`MIN_VALUE`表示`int`能表示的最小值，为`-2^31`

```java
public final class Integer extends Number implements Comparable<Integer> {
    @Native public static final int MIN_VALUE = 0x80000000;
    @Native public static final int MAX_VALUE = 0x7fffffff;
    private final int value;
}
```

## Integer三种创建方式

### 1. `Integer n = new Integer(1)`

调用`Integer`构造方法，分配内存空间，将数值赋值给`value`

```java
public Integer(int value) {
    this.value = value
}
```

由于每次`new`都是调用构造方法在内存中分配新的空间，因此`new Integer(1) == new Integer(1)`结果为false

### 2. `Integer n = Integer.valueOf(1)`

在调用了`valueOf()`方法后，会先判断`i`是否在[缓存](#Integer缓存)范围内(默认是-128～127)，如果在，则返回缓存中的对象，若不在，则再`new Integer(i)`并返回

```java
public static Integer valueOf(int i) {
    if (i >= IntegerCache.low && i <= IntegerCache.high)
        return IntegerCache.cache[i + (-IntegerCache.low)];
    return new Integer(i);
}
```

- `Integer.valueOf(1) == Integer.valueOf(1)`为true，因为1是在缓存范围内的，所以两次`valueOf()`返回的都是缓存中的同一个对象
- `Integer.valueOf(128) == Integer.valueOf(128)`为false，因为128已经超出了缓存默认范围，因此两次分别调用了`new Integer(128)`
- `Integer.valueOf(1) == new Integer(1)`为false，因为`valueOf()`返回的是缓存中的对象，而`new`是再堆中新开辟的空间

### 3. `Integer n = 1`

当为`Integer`直接赋值时，JVM会自动进行装箱，即调用`valueOf()`方法，因此当对直接赋值的变量进行比较时，直接以`valueOf()`方式进行判断

```java
Integer n1 = 1;
Integer n2 = 1
Integer n3 = 128;
Integer n4 = 128;
n1 == n2  // true
n3 == n4  // false
n1 == Integer.valueOf(1)  // true
n3 == Integer.valueOf(128)  // false
```

## Integer缓存

`Integer`缓存是由`Integer`中的私有类`IntegerCache`实现的，当`Integer`类第一次被加载时，`IntegerCache`类会初始化缓存范围内的整型到`cache`数组中，在自动装箱的时候，可以使用缓存中的对象，从而节省内存，提高效率

`IntegerCache`默认缓存范围是-128~127，但是在jdk1.5后，用户可以在编译时添加`-D java.lang.Integer.IntegerCache.high=999`来改变缓存范围到最大值

```java
private static class IntegerCache {
    static final int low = -128;
    static final int high;
    static final Integer cache[];
    static {
        // high value may be configured by property
        int h = 127;
        String integerCacheHighPropValue =
            sun.misc.VM.getSavedProperty("java.lang.Integer.IntegerCache.high");
        if (integerCacheHighPropValue != null) {
            try {
                int i = parseInt(integerCacheHighPropValue);
                i = Math.max(i, 127);
                // Maximum array size is Integer.MAX_VALUE
                h = Math.min(i, Integer.MAX_VALUE - (-low) -1);
            } catch( NumberFormatException nfe) {
                // If the property cannot be parsed into an int, ignore it.
            }
        }
        high = h;

        cache = new Integer[(high - low) + 1];
        int j = low;
        for(int k = 0; k < cache.length; k++)
            cache[k] = new Integer(j++);

        // range [-128, 127] must be interned (JLS7 5.1.7)
        assert IntegerCache.high >= 127;
    }
    private IntegerCache() {}
}
```

### 其他包装类的缓存

所有整数类型的类都有类似的缓存机制
- `ByteCache` 用于缓存`Byte`对象
- `ShortCache` 用于缓存`Short`对象
- `LongCache` 用于缓存`Long`对象
- `CharacterCache` 用于缓存`Character`对象

`Byte`，`Short`，`Long`固定范围为 -128 ～ 127

`Character`固定范围为 0 ～ 127

并且只有`Integer`能修改缓存范围的最大值，其他类型的缓存范围都是不可修改的

## int与Integer

- `int`是基本类型，变量名和值都存在栈中，默认值为0
- `Integer`是引用类型，变量名存在栈中，值存在堆中，默认值为null

### 自动装箱

将`int`赋值给`Integer`，即`Integer i = 1`，其中`int`类型的1被自动装箱（使用`valueOf()`）

### 自动拆箱

将`Integer`赋值给`int`，即`int i = new Integer(1)`，其中包装类型`Integer(1)`会自动拆箱为`int`的1

### 判断相等

- 在`int`中使用`==`判断两者值是否相同
- 在`Integer`中使用`==`判断两个`Integer`是否为同一个对象，使用`equal()`方法判断两者的值是否相同

由于`n1`是基本类型，没有引用对象可以判断，因此此处`n2`会自动拆箱为数值1，所以`n1 == n2`为true

```java
int n1 = 1;
Integer n2 = new String(1);
n1 == n2  //  true
```
