# Enum

```java
enum Week {
    Monday,
    Tuesday
}
```

通过[cfr](https://github.com/leibnitz27/cfr)对Week.class进行反编译(cfr相较于javap会将class文件反编译成更易读懂的形式)

cfr是个jar包，可以通过`java -jar cfr.jar --help`的方式可以查看cfr支持的反编译选项，注意因为cfr支持Java8+，因此对enum反编译时注意加上`--sugarenums false`以关闭enum语法糖的支持

```java
// Decompiled with CFR 0.150.
final class Week extends Enum<Week> {
    public static final /* enum */ Week Monday = new Week("Monday", 0);
    public static final /* enum */ Week Tuesday = new Week("Tuesday", 1);
    private static final /* synthetic */ Week[] $VALUES;
    public static Week[] values() {
        return (Week[])$VALUES.clone();
    }
    public static Week valueOf(String name) {
        return Enum.valueOf(Week.class, name);
    }
    private Week(String string, int n) {
        super(string, n);
    }
    static {
        $VALUES = new Week[]{Monday, Tuesday};
    }
}
```

可以看到enum实质上还是个class，其继承了`Enum`类，其中enum中的Monday和Tuesday被分别编译成了`static`的`Week`类型的变量，并调用了`Week`的构造函数传入该变量(或者说在枚举中)的名称和所在数组中的位置顺序，`Week`的构造函数调用了`super(string, int)`，即`Enum`中的构造函数，其签名为`protected Enum(String name, int ordinal)`

此外还有一个`Week`类型的数组`$VALUES`用于存放枚举类中所有的成员，在static代码块中按照定义的顺序放入初始化的`Week`数组

`values()`方法将`$VALUES`数组拷贝一份并返回，`valueOf(String name)`则根据传入的枚举名称返回对应的枚举对象，该方法调用`Enum.valueOf()`，`Enum`中的`valueOf()`则是获取到该enum的class中的`enumConstantDirectory`，这个Map中存放了枚举名称和枚举实例的映射关系，最后通过`get()`拿到对应的枚举实例

Enum在序列化时仅仅将该枚举对象的name写入(`ObjectOutputStream.writeEnum()`中写入的是`enum.name()`)，在反序列化时则通过name值查找到对应的枚举对象以返回(`ObjectInputStream.readEnum()`中首先读取出枚举所对应的clazz和name，然后通过`Enum.valueOf(clazz, name)`获取对应的枚举对象)，同时编译器不允许对枚举的序列化和反序列化进行自定义，因此在Enum类中将`private void readObject(ObjectInputStream in)`和`private void readObjectNoData()`设为private以保护默认的反序列化实现
