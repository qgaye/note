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
     private Singleton (){
     }
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
      private Singleton (){
      }
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
      private Singleton (){
      }
      private static Singleton instance;  
      public static synchronized Singleton getInstance() {  
          if (instance == null) {  
              instance = new Singleton();  
          }  
          return instance;  
      }  
 }  
```

### 双重检查模式 (DCL)

在`getInstance`方法中对`instance`进行两次判空，避免了上一种情况中不必要的同步

对`instance`加上`volatile`关键词，使得其在多线程是可见的，当一个线程第一次初始化了唯一实例后，其他线程中能发现，从而不再创建新实例

```java
public class Singleton {   
      private Singleton (){
      }   
      private volatile static Singleton instance; 
      public static Singleton getInstance() {  
      if (instance== null) {  
          synchronized (Singleton.class) {  
          if (instance== null) {  
              instance= new Singleton();  
          }  
         }  
     }  
     return instance;  
     }  
 }
```

### 静态内部类单例模式 (推荐使用)

在类加载时不会初始化`instance`，在第一次调用时，加载内部类从而初始化`instance`

这样不仅能保证线程安全也能保证`Singleton`的唯一性

```java
public class Singleton { 
    private Singleton(){
    }
    public static Singleton getInstance(){  
        return SingletonHolder.sInstance;  
    }  
    private static class SingletonHolder {  
        private static final Singleton sInstance = new Singleton();  
    }  
}
```

