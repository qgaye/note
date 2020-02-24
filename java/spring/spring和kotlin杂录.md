# spring和kotlin杂录

## Bean自动装配

模式注解(Stereotype Annotation)：
- `@Component` 通用组件
- `@Repository` 数据仓库
- `@Service` 服务
- `@Controller` Web控制器
- `@Configuration` 配置类

以上都*派生*(Java注解中没有派生这个概念)"自`@Component`，因此以上五个模式注解都可以被component-scan扫描到

有以下两种装配方式

```xml
<!-- 激活注解驱动特性 -->
<context:annotation-config />
<context:component-scan base-package="package path" />
```

```kotlin
@ComponentScan(basePackages = ["package path"])
```

## 自定义模式注解

正如模式注解中说到的，只要*派生*自`@Component`，就都可以被component-scan扫描到

派生指的是主要定义的该注解的父注解(包括递归上去的所有父注解)中有`@Component`即可

当然这里还有一点要注意，自定义的模式注解一定要包括一个**字段名为value的字段**，且不可以是别的名字，这里是因为在Java中模式注解需要`String value() default "";`该字段

```kotlin
@Target(AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@Component
annotation class MyComponent(val value: String = "")
```


