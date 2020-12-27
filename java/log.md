# Java日志

jcl(commons-logging.jar)和slf4j(slf4j-api.jar)都是日志系统中的门面框架(Facade)，它们都只是提供log的接口，在运行时可以通过配置动态搭配真正的日志实现类

```txt 
                              /  log4j (org.apache.log4j)
jcl (Jakarta Commons Logging) 
                              \  jul (java.util.logging)

                                        /  logback-classic  ->  logback
slf4j (Simple Logging Facade for Java)  -  log4j-slf4j-impl ->  log4j2
                                        \  slf4j-log4j12    ->  log4j
```

jcl默认配置：能找到log4j就使用log4j，如果没找到则使用jul，再没有就使用jcl内部提供的SimpleLog

jcl会在ClassLoader中查找log具体实现类，因此效率低，于是log4j作者就写了个新的门面接口slf4j

slf4j相较于jcl支持占位符，因此无需像jcl中频繁使用`isDebugEnabled()`来减少字符串拼接次数和生成的字符串对象次数(jcl中通过str+str的方式拼接，slf4j通过{}占位符来填充)，避免内存溢出

slf4j兼容大多的日志实现，而具体的日志实现又互不相同，因此slf4j中需要通过桥接器来链接具体的日志实现类，slf4j会根据classpath中的桥接器类型和日志实现类型判断log具体通过那个日志框架输出

logback略有不同，其不是桥接器，它是完全按照slf4j设计的日志实现类，因此在使用logback时直接引入`logback-classic`即可，其中包含了`slf4j-api`因此无需单独引入

当项目中已经存在使用jcl/jul时，如果希望已存在的也使用slf4j配置的日志logback实现，则可以通过适配器jcl-over-slf4j.jar/jul-to-slf4j.jar将已存在的jcl/jul路由到slf4j上通过logback输出

jcl-over-slf4j.jar的实现其实就是完全实现了遍log4j.jar的接口，因此log4j-over-slf4j.jar可以直接替换掉log4j.jar而程序还可以正常运行，而log4j-over-slf4j.jar实现底层就是链接到slf4j上去(因此引入log4j-over-slf4j.jar就可以移除log4j.jar，但是也可以不移除，只要保证log4j-over-slf4j.jar先于log4j.jar被导入即可(pom中先于log4j.jar))

slf4j绑定日志实现框架流程：`LoggerFactory.getLogger(clazz)` -> `getILoggerFactory()` -> `performInitialization()` -> `bind()` -> `findPossibleStaticLoggerBinderPathSet()`

`getILoggerFactory()`中实例化`StaticLoggerBinder`单例，而`StaticLoggerBinder`在`bind()`中完成绑定日志实现框架，`bind()`方法调用`findPossibleStaticLoggerBinderPathSet()`，该方法中从`classpath:org/slf4j/impl`位置加载所有的`StaticLoggerBinder.class`到Set中，如果没能在该位置下加载到则会报`Failed to load class "org.slf4j.impl.StaticLoggerBinder"`的错误，如果加载到多个(即引入多个桥接器)，则会通过控制台发出警告但不会报错崩溃，最后回到`bind()`方法中通过`StaticLoggerBinder.getSingleton()`完成`StaticLoggerBinder`的绑定

- [架构师必备，带你弄清混乱的JAVA日志体系！](https://www.cnblogs.com/rjzheng/p/10042911.html)
- [日志SLF4J解惑](https://juejin.cn/post/6844903591132528648)
- [Java日志框架：slf4j作用及其实现原理](https://www.cnblogs.com/xrq730/p/8619156.html)
