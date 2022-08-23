# Decorator (装饰者模式)

动态的将责任增加到对象上，或者说给对象增加新的功能/方法，装饰者模式相比于生成子类更为灵活

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


面向对象的设计原则：**类应该对扩展开放，对修改关闭**

```java
// Component（抽象构件） 
interface Event {
    void doSomething();
}
// ConcreteComponent（具体构件） 
class UploadEvent implements Event {
    @Override
    public void doSomething() {
        System.out.Println("do something");
    }
}
// ConcreteDecorator（具体装饰类）这里省略了抽象装饰类
class RecordEvent implements Event {
    private Event event;
    public RecordEvent(Event event) {
        this.event = event;
    }
    public void prepareSomething() {
        System.out.Println("prepare something");
    }
    @Override
    public void doSomething {
        event.doSomething();
    }
}
// 使用
public static void main() {
    Event e = new RecordEvent(new UploadEvent());
    e.prepareSomething();
    e.doSomething();
}
```

总结：

装饰者模式相当于给该类扩展了别的功能，比如例子中在不继承，不破坏原有类的前提下新增了新的方法

而代理模式则是相当于为原有的方法进行类增强，比如在方法前后记录了日志等，又或者控制对象的访问，比如被代理对象不愿意暴露给外部

装饰模式是“新增行为”，而代理模式是“控制访问”
