# Decorator (装饰者模式)

动态的将责任增加到对象上，装饰者模式相比于生成子类更为灵活

Component（抽象构件）：可以是个接口或抽象类，是具体构件和抽象装饰类的共同父类，具体由子类实现，给予调用者透明操作

ConcreteComponent（具体构件）：是抽象构件类的子类，实现抽象构件中的方法来生成具体的构件对象，装饰器可以为它增加额外责任

Decorator（抽象装饰类）：是抽象构件类的子类，用于给具体构件增加职责，其子类实现具体方法来达到装饰额外责任的作用(这层可以省略)

ConcreteDecorator（具体装饰类）；是抽象装饰类的子类，用于给待装饰对象添加具体的额外责任，以达到扩充对象功能的目的

```txt
                                       Component ______________________
                                     /          \                       \      
                            Decorator             ConcreteComponent1      ConcreteComponent2
                            /       \
            ConcreteDecorator1      ConcreteDecorator2
```


面向对象的设计原则；**类应该对扩展开放，对修改关闭**

```java
// Component（抽象构件） 
interface Event {
    void doSomething();
}
// ConcreteComponent（具体构件） 
class UploadEvent implements Event {
    @Override
    public void doSomething() {
        // 进行上传操作
    }
}
// ConcreteComponent（具体构件）
class DownloadEvent implements Event {
    @Override
    public void doSomething() {
        // 进行下载操作
    }
}
// ConcreteDecorator（具体装饰类）这里省略了抽象装饰类
class RecordEvent implements Event {
    private Event event;
    public RecordEvent(Event event) {
        this.event = event;
    }
    @Override
    public void doSomething {
        // 装饰者进行一些额外操作，比如记录日志啥的
        event.doSomething();
    }
}
// 使用
public static void main() {
    new RecordEvent(new UploadEvent()).doSomething();
    new RecordEvent(new DownloadEvent()).doSomething();
}
```
