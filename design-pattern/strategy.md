# Strategy (策略模式)

策略模式可以让使用者自行创建策略，并能够动态设置需要使用的策略而无需修改原有代码结构，但是其要求使用者必须知晓其需要使用的策略

```txt
    Context (持有策略的实例)  ------>  Strategy(策略接口)
                                    /        \
                     ConcreateStrategyA     ConcreateStartegyB ... (具体策略实现)
```

```java
// Startegy策略接口
public interface Startegy {
    int calculate(int a, int b);
}
// 具体策略实现
public class AddStartegy implements Startegy {
    @Override
    public void calculate(int a, int b) {
        return a + b;
    } 
}
// 具体策略实现
public class SubtractStartegy implements Startegy {
    @Override
    public void calculate(int a, int b) {
        return a - b;
    } 
}
// 持有策略的实例
public class Context {
    private Startegy startegy;
    public Context(Startegy startegy) {
        this.startegy = startegy;
    } 
    // 动态替换策略
    public void changeStartegy(Startegy startegy) {
        this.startegy = startegy;
    }
    public int calculate(int a, int b) {
        return startegy.calculate(a, b);
    }
}
```

在JDK中的线程池的创建中，`ThreadPoolExecutor`中的拒绝策略`RejectedExecutionHandler handle`参数即使用了策略模式，使用者可以使用其自带的四种拒绝策略，也可以自己实现`RejectedExecutionHandler`接口来创建自己的拒绝策略

总结：

策略模式相当于提供了一种算法(具体方法的实现)的热插拔功能，让具体算法与调用环境分开
