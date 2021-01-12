# Template (模版模式)

模版模式可以在抽象类定义一个操作的框架，将操作的具体细节在子类中各自实现从而在不改变操作的框架的前提下实现特定的实现

```txt
           AbstractTemplate (抽象模版)
           /              \
ConcreteTemplateA       ConcreteTemplateB ... (模版实现)
```

模版模式下抽象模版类中的模版方法设置为`final`以防子类对其修改，而子类中只需要实现抽象方法即可

```java
public abstract class PhoneFactory {
    public final void product() {
        makeScreen();
        makeCamera();
    }
    protected abstract void makeScreen();
    protected abstract void makeCamera();
}
public class AppleFactory extends PhoneFactory {
    @Override
    protected void makeScreen() {
        System.out.println("Apple Screen")
    }
    @Override
    protected void makeCamera() {
        System.out.println("Apple Camera")
    }
}
public class HuaweiFactory extends PhoneFactory {
    @Override
    protected void makeScreen() {
        System.out.println("Huawei Screen")
    }
    @Override
    protected void makeCamera() {
        System.out.println("Huawei Camera")
    }
}
// 在main函数中使用
public static void main(String[] args) {
    PhoneFactory appleFactory = new AppleFactory();
    PhoneFactory huaweiFactory = new HuaweiFactory();
    appleFactory.product();
    huaweiFactory.product();
}
```
