# Factory (工厂模式)

工厂模式可以在不指定具体对象类型情况下完成对象创建，并无需关心构造对象的细节和过程

## 简单工厂模式

简单工厂模式不属于23种设计模式，更多的是一种编程习惯

定义一个工厂类，其根据传入参数的不同返回不同的实例

```java
public interface Phone {}
public class ApplePhone {}
public class HuaweiPhone {}

public class PhoneFactory {
    public static Phone makePhone(String type) {
        Phone phone = null;
        switch(type) {
            case "Apple":
                phone =  new ApplePhone();
            case "Huawei":
                phone = new HuaweiPhone();
        }
        return phone;
    }
}
```

## 工厂方法模式 (Factory Method)

工厂方法模式将具体对象的创建分发给具体的对象工厂完成创建

```txt
            AbstractFactory (抽象工厂类)
            /             \
  ConcreateFactoryA      ConcreateFactoryB ... (具体的创建对象的工厂)
```

```java
public interface Phone {}
public class ApplePhone {}
public class HuaweiPhone {}

public interface AbstartFactory {
    Phone makePhone();
}
public class AppleFactory implements AbstartFactory {
    @Override
    public Phone makePhone() {
        return new ApplePhone();
    }
}
public class HuaweiFactory implements AbstartFactory {
    @Override
    public Phone makePhone() {
        return new HuaweiPhone();
    }
}
// 使用
AbstractFactory appleFactory = new AppleFactory();
AbstractFactory huaweiFactory = new HuaweiFactory();
appleFactory.makePhone();
huaweiFactory.makePhone();
```

## 抽象工厂模式 (Abstract Fctory)

抽象工厂模式相较于工厂方法模式不再局限于一类的对象，可以对多种对象进行统一管理创建

```java
public interface Phone {}
public class ApplePhone {}
public class HuaweiPhone {}

public interface PC {}
public class MacBook {}
public class MateBook {}

public interface AbstartFactory {
    Phone makePhone();
    PC makePC();
}
public class AppleFactory implements AbstartFactory {
    @Override
    public Phone makePhone() {
        return new ApplePhone();
    }
    @Override
    public PC makePC() {
        return new MacBook();
    }
}
public class HuaweiFactory implements AbstartFactory {
    @Override
    public Phone makePhone() {
        return new HuaweiPhone();
    }
    @Override
    public PC makePC() {
        return new MateBook();
    }
}
// 使用
AbstractFactory appleFactory = new AppleFactory();
AbstractFactory huaweiFactory = new HuaweiFactory();
appleFactory.makePhone();
appleFactory.makePC();
huaweiFactory.makePhone();
huaweiFactory.makePC();
```
