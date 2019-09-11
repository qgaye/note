# Java小知识点

## 1. `switch`中的`String`

在jdk1.7之后`switch`中也支持`String`、`Enum`和整型的包装类类型，此前支持整型的基本类型(`int`、`short`、`byte`、`char`)

其实`switch`只支持一种类型，就是整形，所有其他适用的类型都是化为整型后进行(`char`实际上比较的是`ASCII`码)

### 实现代码

`switch`实际比较的是`hashCode`(整型)，然后由于会发生哈希冲突，所以还要进行`equals()`判断

```java
String key = "first";
String s;
switch((s = key).hashCode()) {
    case 19298384742:
        if (s.equals("first")) {
            // 匹配成功
        }
        break;
    case 34123564363:
        if (s.equals("second")) {
            // 匹配成功
        }
        break;
    default:
        break;
}
```

## 2. IEEE754
