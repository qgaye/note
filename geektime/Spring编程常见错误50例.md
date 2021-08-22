# Spring编程常见错误50例

## Bean

### 隐式扫描不到Bean

`@SpringBootApplication`中包含了`@ComponentScan`，当没有显式配置`@ComponentScan`中的basePackages时该值为`@SpringBootApplication`所在类所在的包路径，即会扫描启动类同级及其子包中的所有类

因此如果有类定义在非默认basePackages路径下，就必须显式定义`@ComponentScan`的basePackages

basePackages可以定义多个值`@ComponentScan(basePackages = {"package1", "package2"})`

### Bean缺少隐式依赖

当为Bean自定义构造函数时，要保证构造函数中的所有参数都是Bean

当为Bean定义了多个构造函数时，Spring不知道该怎么选择最后就会选择默认无参构造函数，如果没有无参构造函数那么创建这个Bean就会失败

### 原型Bean被固定

当一个单例的Bean中，使用`@Autowired`注解标记的属性，会在该Bean创建时就固定下来

如果需要保证每次获取到的都是新的属性，就不能使用`@Autowired`方式

方法1：通过`@Autowired`注入`ApplicationContext`，然后再通过`applicationContext.getBean(XXX.class)`的方式每次去获取Bean
方法2：直接定义个返回值为需要注入的类的方法，并标记`@Lookup`，这个方法的实现不重要，因为最后会通过代理的方式通过BeanFactory获取到Bean



