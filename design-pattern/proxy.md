# Proxy （代理模式）

通过代理对象来访问目标对象，这样可以在目标对象的原有功能的基础上增强功能，比如记日志，开启事务

```txt
                          PlayerInterface
                        /                \
            PlayerImpl (委托类)          PlayerProxy (代理类)
```

静态代理：

```java
// 委托类和代理类共同实现的接口
public interface PlayerInterface {
    void play();
}
// 委托类，委托给PlayerProxy
public class PlayerImpl implements PlayerInterface {
    @Override
    public void play() {
        System.out.println("运动员比赛");
    }
}
public class PlayerProxy implements PlayerInterface {
    private PlayerInterface realPalyer;
    publiv PlayerProxy(PlayerInterface player) {
        realPlayer = player;
    }
    @Override
    public void play() {
        System.out.println("裁判员就位");
        realPlayer.play();
        System.out.println("全体退场");
    }
}
```

静态代理需要为每个类都编写一个代理类，代码冗余，因此就需要动态代理

动态代理：
- 静态代理在编译时就已经实现，编译完成后代理类是一个实际的class文件
- 动态代理是在运行时动态生成的，即编译完成后没有实际的class文件，而是在运行时动态生成类字节码，并加载到JVM中

动态代理的目标对象必须实现对应接口，否则无法使用，原因是动态代理生成的类已经继承了Proxy，Java是单继承的，因此无法再继承其他类，只能实现接口

JDK动态代理核心为`InvocationHandler`接口和`Proxy`类，其中实现`InvocationHandler::invoke`方法即自定义的代理逻辑，在其中调用`method.invoke`执行被代理对象的方法，`Proxy::newProxyInstance`完成代理对象的创建

```java
// 委托类和代理类共同实现的接口
public interface PlayerInterface {
    void play();
    void rest();
}
// 委托类，委托给PlayerProxy
public class PlayerImpl implements PlayerInterface {
    @Override
    public void play() {
        System.out.println("运动员比赛");
    }
    @Override
    public void rest() {
        System.out.println("运动员休息");
    }
}
public class ProxyFactory {
    public static <T> T getProxyInstance(T target) {
        return (T) Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(),
                // 实现InvocationHandler接口，即具体的代理逻辑
                (proxy, method, args) -> {
                    // 选择需要代理的方法，这里只代理play方法
                    if (method.getName().equals("play")) {
                        System.out.println("裁判员就位");
                        // 执行目标对象方法
                        Object returnValue = method.invoke(target, args);
                        System.out.println("全体退场");
                        return returnValue;
                    } else return method.invoke(target, args);
                });
    }
}
// 在main方法中使用
public static void main() {
    PlayerInterface player = ProxyFactory.getProxyInstance(new PlayerImpl());
    player.play();)
}
```

cglib代理：

cglib代理核心为`MethodInterceptor`和`Enhancer`，其中实现`MethodInterceptor::intercept`方法即自定义的代理逻辑，`Enhance::create`用于创建代理对象，此外`Enhance`核心要设置`setSuperClass`和`setCallback`，`MethodInterceptor`继承了`Callback`接口，因此`MethodInterceptor`可以作为`Callback`传入

```java
class Player {
    public void play() {
        System.out.println("运动员比赛");
    }
}
class ProxyFactory {
    @SuppressWarnings("unchecked")
    public static <T> T getProxyInstance(T target) {
        Enhancer enhancer = new Enhancer();
        enhancer.setSuperclass(target.getClass());
        enhancer.setCallback((MethodInterceptor) (obj, method, args, proxy) -> {
            System.out.println("裁判员就位");
            Object result = proxy.invokeSuper(obj, args);
            System.out.println("全体退场");
            return result;
        });
        return (T) enhancer.create();
    }
}
// 在main方法中使用
public static void main(String[] args) {
    Player player = ProxyFactory.getProxyInstance(new Player());
    player.play();
}
```

JDK动态代理有限制，被代理对象必须实现一个接口，而cglib代理则没有这种限制

cglib采用了字节码的技术为代理类创建了子类，Spring AOP中如果Bean实现了接口则使用JDK动态代理，否则使用cglib

cglib会继承目标对象并生成子类，需要重写目标对象中的方法，因此需要代理的类或方法不得为final

JDK动态代理和cglib代理区别：

- JDK动态代理只能代理接口，而cglib可以代理类和接口
- cglib在创建代理对象时比JDK动态代理更耗时，如果无需频繁创建代理对象，比如单例时，cglib更合适

## 总结

代理模式注重的是对共同接口中的方法的功能增强，而装饰者模式注重的是对对象新增功能或方法

## 参考

- [Java三种代理模式：静态代理、动态代理和cglib代理](https://segmentfault.com/a/1190000011291179)
- [Java 动态代理详解](https://juejin.im/post/5c1ca8df6fb9a049b347f55c)
