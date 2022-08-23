# Facade (门面模式)

门面模式提供一个高层次的接口，使得子系统更易使用，即外部于子系统内部通信必须通过统一的对象进行，这个对象就是门面

```txt
                 Facade
                /      \ 
 Subsystem Class A     Subsystem Class B ...
```

```java
class SubSystemA {
    public void doA() { System.out.println("A") }
}
class SubSystemB {
    public void doB() { System.out.println("B") }
}
class SubSystemC {
    public void doA() { System.out.println("C") }
}
class Facade {
    private SubSystemA a = new SubSystemA();
    private SubSystemB b = new SubSystemB();
    private SubSystemC c = new SubSystemC();
    public void doAB() {
        a.doA();
        b.doB();
    }
    public void doBC() {
        b.doB();
        c.doC();
    }
}
```

门面模式优点：
- 子系统中的修改对外部调用者是无感的，低耦合
- 调用者无需关系子系统中的具体实现，只需要和Facade交互即可
- 通过Facade对子系统的包装使得有效管理子系统中具体方法是否允许访问(比如Tomcat中`doGet()`参数为`HttpServletRequest`和`HttpServletResponse`的接口类型，运行中真正传入的是`RequestFacade`和`ResponseFacade`类型即门面模式下对request和response的包装，其原因就是request和response中一些方法如`setRequestedSessionId()`是需要设置为public从而被其他内部组件调用的，但这些方法不能对用户开放，因此就通过Facade包装一下来对用户屏蔽掉这些方法)

缺点：
- 子系统中进行了扩展后需要告知门面并要求门面也进行改动，破坏了开闭原则(当然如果只是对子系统中方法逻辑进行修改则是不影响门面的)

