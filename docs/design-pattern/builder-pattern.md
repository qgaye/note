# Builder（建造者模式）

## 简化Builder模式

当一个`Computer`类存在`cpu`和`ram`两个必选参数和`keyboard`和`display`两个可选参数

```java
public class Computer {
    // 必选
    private String cpu;
    private String ram;
    // 可选
    private String keyboard;
    private String display;
}
```

当尝试构造这个`Computer`类时往往有两种方法

### 方法一：折叠构造函数模式

- 当属性非常多时，需要重载多个构造器，代码灵活性较差
- 由于构造器中参数较多，顺序复杂，容易在调用时出现错误

```java
public class Computer {

    public Computer(String cpu, String ram) {
        this(cpu, ram, "", "");
    }

    public Computer(String cpu, String ram, String keyboard) {
        this(cpu, ram, keyboard, "");
    }

    public Computer(String cpu, String ram, String keyboard, String display) {
        this.cpu = cpu;
        this.ram = ram;
        this.keyboard = keyboard;
        this.display = display;
    }
}
```

### 方法二：JavaBean模式

- 为属性赋值需要多行代码
- 在为属性赋值时，构造中 JavaBean 可能处于不一致的状态

```java
public class Computer {
    public void setCpu(String cpu) {
        this.cpu = cpu;
    }

    public void setRam(String ram) {
        this.ram = ram;
    }

    public void setKeyboard(String keyboard) {
        this.keyboard = keyboard;
    }

    public void setDisplay(String display) {
        this.display = display;
    }
}
```

### 方法三：Builder模式

- 在`Computer`类中新建静态`Builder`类，所有属性赋值都在`Builder`类中，解决不一致性问题
- `Builder`中的`set`方法会返回`this`，因此可以使用链式赋值，并且赋值时不再需要考虑顺序

```java
public class Computer {
    // 必选
    private String cpu;
    private String ram;
    // 可选
    private String keyboard;
    private String display;

    public Computer(Builder builder) {
        this.cpu = builder.cpu;
        this.ram = builder.ram;
        this.keyboard = builder.keyboard;
        this.display = builder.display;
    }

    public static class Builder {

        private String cpu;
        private String ram;
        private String keyboard;
        private String display;

        public Builder(String cpu, String ram) {
            this.cpu = cpu;
            this.ram = ram;
        }

        public Builder setKeyboard(String keyboard) {
            this.keyboard = keyboard;
            return this;
        }

        public Builder setDisplay(String display) {
            this.display = display;
            return this;
        }

        public Computer build() {
            return new Computer(this);
        }
    }
}
```

可以随意传递参数，并链式创建对象

```java
Computer computer = new Computer.Builder("Inter", "Samsumg")
        .setKeyboard("Logitech")
        .setDisplay("Lenovo")
        .build();
```

## 经典Builder模式

### 定义

将一个复杂的构建过程与其对象的具体构造分离，使得同样的构建过程可以创建不同的对象

在建造者模式下建造者不再负责一切，而是又监工定义整个复杂的建造过程，再由不同的建造者分别实现构建过程中的每个建造步骤，由此以达到同样的构建过程可以创建不同的对象

- 建造者（`ComputerBuilder`）：定义生成实例所需要的所有方法，即电脑中可选配的部件
- 具体的建造者（`MacComputerBuilder`, `LenovoComputerBuilder`）：实现生成实例所需要的所有方法，并且定义获取最终生成实例的方法，即为每种电脑装配上其选配的部件
- 监工（`ComputerDirector`）：定义使用建造者角色中的方法来生成实例的方法，即监工负责让建造者去建造复杂的对象

#### 目标对象：Computer

```java
public class Computer {
    // 必选
    private String cpu;
    private String ram;
    // 可选
    private String keyboard;
    private String display;

    public Computer(String cpu, String ram) {
        this.cpu = cpu;
        this.ram = ram;
    }

    public void setCpu(String cpu) {
        this.cpu = cpu;
    }

    public void setRam(String ram) {
        this.ram = ram;
    }

    public void setKeyboard(String keyboard) {
        this.keyboard = keyboard;
    }

    public void setDisplay(String display) {
        this.display = display;
    }
}
```

#### 抽象建造者：ComputerBuilder

```java
public abstract class ComputerBuilder {
    public abstract void setKeyboard();
    public abstract void setDisplay();
    public abstract Computer getComputer();
}
```

#### 苹果电脑建造者：MacComputerBuilder

```java
public class MacComputerBuilder extends ComputerBuilder {

    private Computer computer;

    public MacComputerBuilder(String cpu, String ram) {
        computer = new Computer(cpu, ram);
    }

    @Override
    public void setKeyboard() {
        computer.setKeyboard("Mac");
    }

    @Override
    public void setDisplay() {
        computer.setDisplay("Samsumg");
    }

    @Override
    public Computer getComputer() {
        return computer;
    }
}
```

#### 联想电脑建造者：LenovoComputerBuilder

```java
public class LenovoComputerBuilder extends ComputerBuilder {

    private Computer computer;

    public LenovoComputerBuilder(String cpu, String ram) {
        computer = new Computer(cpu, ram);
    }

    @Override
    public void setKeyboard() {
        computer.setKeyboard("Lenovo");
    }

    @Override
    public void setDisplay() {
        computer.setDisplay("Lenovo");
    }

    @Override
    public Computer getComputer() {
        return computer;
    }
}
```

#### 监工，负责定义建造者完成建造：ComputerDirector

```java
public class ComputerDirector {
    public void produceComputer(ComputerBuilder builder) {
        builder.setKeyboard();
        builder.setDisplay();
    }
}
```