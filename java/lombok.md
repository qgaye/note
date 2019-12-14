# Lombok                                                               

[Lombok](https://projectlombok.org/)会自动生成生成代码以简化重复的coding

在JSR269后在Javac的编译期利用注解来动态修改AST，以达到新增代码的的效果

相比于通过runtime反射获取注解的方式，这样不但效率更高，还能在编译器基于检查

## IDEA支持

在IDEA中虽然直接编译是不会报错的，但由于IDEA无法找到自动生成的代码的源代码，因此还是会被认为是错误

在IDEA -> Plugins中安装[Lombok插件](https://github.com/mplushnikov/lombok-intellij-plugin)即可

## @Builder

在类上添加`@Builder`注解，通过建造者模式达到链式构造的方法

```java
Person.builder().name("Name").age(11).build()
```

## @Accessor

`@Accessor`需搭配`@Data`使用，提供链式getter和setter方法

- `@Accessor(chain = true)`表示可以链式使用getter和setter方法
- `@Accessor(fluent = true)`表示在`chain = true`的基础上方法不再需要get和set前缀，可以直接调用变量名方法
