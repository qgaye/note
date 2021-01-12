# SingletonPattern (单例模式)

## 作用

对于运行期间只需要一个实例的类，保证这个类仅有一个实例，减少系统开销

## 5种实现

- 将构造方法私有化，从而使得外部无法自行`new`出实例
- 确保该类中只存在一个实例对象

### 饿汉模式

在类加载时就完成了初始化，所以类加载较慢，但获取对象的速度快，并且能保证线程安全

```java
public class Singleton {
     private Singleton() {}
     private static Singleton instance = new Singleton();
     public static Singleton getInstance() {  
         return instance;  
     }
 }  
```

### 懒汉模式

在类加载中仅申明了一个静态对象，在用户第一次调用时再初始化，虽然加快了类加载速度，但获取对象时会较慢，**并且不能保证线程安全**

```java
public class Singleton {  
      private Singleton() {}
      private static Singleton instance;  
      public static Singleton getInstance() {  
          if (instance == null) {  
              instance = new Singleton();  
          }  
          return instance;  
      }  
 }  
```

### 懒汉模式（线程安全）

在原始的懒汉模式上使用`synchronized`以保证在第一次初始化时线程安全，但会造成不必要的同步，造成额外开销

```java
public class Singleton {  
      private Singleton() {}
      private static Singleton instance;  
      public static synchronized Singleton getInstance() {  
          if (instance == null) {  
              instance = new Singleton();  
          }  
          return instance;  
      }  
 }  
```

### 双重检查模式 (面试时使用)

在`getInstance`方法中对`instance`进行两次判空，避免了上一种情况中不必要的同步

```java
public class Singleton {   
    private Singleton() {}
    private volatile static Singleton instance;
    public static Singleton getInstance() {
        if (instance == null) {
            synchronized (Singleton.class) {
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
 }
```

#### 为什么instance变量此处要加上volatile关键字

首先明确一点，volatile在此处提供的不是可见性，因为synchronized已经提供了可见性(后面synchronzied的代码块是一定能看到前面synchronized代码块中的操作)来保证第二个`instance == null`中一定能够看到其他线程中new出的新Instance

此处volatile提供的是禁止指令重排序，因为`new Singleton()`这个new操作本身不是原子操作，其中包括分配内存地址，进行具体的构造过程，将内存地址赋值给变量，而这几个操作是会被指令重排序的，因此很可能发生在new的过程中，真正构造过程还没执行完，已经将一块空内存赋值给了变量，此时其他线程在第一处`instance == null`时发现确实不为null，但其实instance本身还未完全初始化完成。因此此处需要禁止指令重排序来保证初始化动作完成后再赋值给变量。

### 静态内部类单例模式 (可用)

在类加载时不会初始化`instance`，在第一次调用时，加载内部类从而初始化`instance`

这样不仅能保证线程安全也能保证`Singleton`的唯一性

```java
public class Singleton { 
    private Singleton() {}
    public static Singleton getInstance(){  
        return SingletonHolder.sInstance;  
    }  
    private static class SingletonHolder {  
        private static final Singleton sInstance = new Singleton();  
    }  
}
```

## 枚举类 (生产中使用)

通过枚举类的写法最简单，且能保证线程安全，此外它还能防止反序列化或反射创建新的对象，这点是其他实现方式都不具备的

```java
public enum Singleton {
    INSTANCE;
    // 通过Singleton.INSTANCE.getInstance()方式调用
    public Singleton getInstance() {
        return INSTANCE;
    }
}
```

`enum Singleton`被编译为class后继承`Enum`类，其只有一个调用父类`Enum`的构造函数，签名为`Enum(String name, int ordinal)`，通过反射获取到该有参构造函数后使用`newInstance()`是无法创建对象的，因为`Constructor.newInstance()`中对被创建的类进行校验，如果是ENUM修饰的则会抛出异常，反射创建失败，从而保证了无法通过反射调用构造函数创建出不同的对象

此外因为enum的序列化和反序列化是不通过反射实现的，序列化通过写入枚举对象的name，反序列化通过name查找到对应的枚举对象，并且序列化和反序列化是无法被自定义的，从而保证了无法通过反序列化创建出不同的对象

```java
public class Container {
    private Container() {}
    private enum Singleton {
        INSTANCE;
        private final Container container;
        Singleton() {
            container = new Container();
        }
    }
    public Container getInstance() {
        return Singleton.INSTANCE.container;
    }
}
```

`Container`中的`private enum Singleton`会被编译成静态内部类，因此即使反射创建了`Container`对象调用`getInstance()`也能保证单例的要求
