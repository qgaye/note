# Cloneable接口--浅拷贝与深拷贝

## `Object`中的`clone()`方法

若要实现使用`clone()`方法，必须实现`Cloneable`接口，否则会抛出`CloneNotSupportedException`异常，并且将方法权限从`protected`改为`public`

`Object`中的`clone()`方法都是浅拷贝，即只拷贝8大基本数据类型和`String`类型（`String`类型由于`final`和常量池的特性，可以保证深度拷贝），若要实现深拷贝，需要重写`clone()`方法，并且在方法内部调用持有对象的`clone()`方法

`clone()`是一个`native`方法，运行效率比较高，因此不会使用`new`一个对象再拷贝所有属性值的方法来实现`clone()`方法

### `clone()`方法源码

```java
protected native Object clone() throws CloneNotSupportedException;
```

### `clone()`的约定（并非强求）

- `x.clone() != x` 是true
- `x.clone().getClass()` == `x.getClass()` 是true
- `x.clone().equals(x)` 是true

### 所有数组类都默认实现了`clone()`方法

所有数组类型都有一个`public`的`clone`方法，而不是`protected`，且都是浅拷贝

> `ArrayList`中`clone`的注释 -> `Returns a shallow copy of this <tt>ArrayList</tt> instance. `

### 为什么`clone()`是`protected`的

> protected访问权限：
> - 当父类与子类实例处在同一包中，子类与其实例是可以访问到`protected`的成员的(实例能访问到是因为`protect`有`default`权限)
> - 当父类与子类实例不在同一包中，子类中是可以访问到`protected`成员的，但是子类实例则是访问不到的

由于`Object`子类实例都不会在`java.lang`包下，因此子类实例对象与父类`Object`不在一个包下，因此子类是无法访问到`clone()`方法的

将修饰权限设为`protected`是为了保证安全，子类调用父类的`clone()`往往没有任何意义，比如使用`Person`的复制方式去拷贝一个子类`Student`，不但得不到希望的结果，还没有任何意义

但在实现了`clone()`方法后，需将`protected`权限改为`public`

## `Cloneable`接口

Java源码中`Cloneable`接口没有定义任何方法签名，但是若要实现`Object`中的`clone()`方法就必须继承`Cloneable`接口，否则会抛出`CloneNotSupportedException`

`Cloneable`就是一个标记接口，运行时JVM会检查要`clone`的对象有没有被打上这个标记，有就让拷贝，没有就抛异常

### `Cloneable`源码

```java
public interface Cloneable {}
```

## 浅拷贝与浅拷贝

浅拷贝：如果字段是基本数据类型，则会复制字段的值到一个新的变量中，而字段是引用类型，则仅会将引用值复制给新对象中的相应字段中，也就是说，两个字段指向了同一个对象实例
深拷贝：将被复制引用所指向的对象实例的各个属性复制到新的内存空间中，然后将新的引用指向这块块内存（也就是一个新的实例）

### 以`School`类举例

```java
public class School {
    private String name;
    private int phone;
    private Student student;
    private Teacher teacher;
}
```

### 浅拷贝

在浅拷贝模式下，`name`和`String`都是新的值，与被拷贝类不再关联，但是`student`和`teacher`两个变量由于是引用类型，所以浅拷贝下，仅仅拷贝了引用对象的引用值，所以拷贝与被拷贝对象持有的都是同一个`student`和`teacher`

```java
@Override
public School clone() throws CloneNotSupportedException {
    return (School) super.clone();
}
```

### 深拷贝

在深拷贝模式下，引用类型变量需要独立进行`clone()`，以保证两者持有的`student`和`teacher`不再是同一个对象，若`student`或`teacher`中还存在引用类型变量，还需要独立进行`clone()`（在`Student`和`Teacher`类中实现深拷贝），否则实现依旧是浅拷贝，因此，对于引用类型变量，其复制过程是递归的，直到其中不再存在引用类型变量才可

```java
@Override
public School clone() throws CloneNotSupportedException {
    School school = (School) super.clone();
    school.student = student.clone();
    school.teacher = teacher.clone();
    return school;
}
```