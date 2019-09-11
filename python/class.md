# python中类的使用

## 类的定义

函数名`__init__`类似java中的构造器

`__init__`函数不是类中必须的，只有在需要传参时，才需要定义`__init__`函数

python类中的类定义变量必须加上`self.`使用

```python
class Student(Object):
    def __init__(self, name):
        self.name = name
```

## 重写默认的getter和setter

**作用：** 重写默认getter和setter可以添加参数校验等功能

在python中默认的getter为 : `s.name`

在python中默认的setter为 : `s.name = xxx`

使用`@property`把一个getter变成属性，**当使用了`@property`后，会自动创建另一个修饰器`@name.setter`，若重写后者，则属性变为只读的(因为没有setter)**

使用`@name.setter`把一个setter变成属性，其中`name`为类中的属性名，**不可只写`@name.setter`,`@property`和`@name.setter`必须同时存在**

```python
@property
def name(self):
    return self.__name + 'test'
@name.setter
def name(self, name):
    self.__name = name
```

## 类定义变量访问权限

在类定义变量前加上`__`双下划线以表示私有变量

```python
class Student(Object):
    def __init__(self, name):
        self.__name = name
    def get_name():
        return self.__name
    def set_name(name):
        self.__name = name
```

此时使用`student.name`无法获取name变量的值

自定义getter和setter方法以修改和获取私有变量

### 1. 私有变量在python的具体实现

私有变量在python中会自动被解释成另一个变量

内部的`__name`已被python解释器改成了`_Student__name`，使用`student._Student__name`是可以获取到变量值的，**但不推荐使用，违背了私有变量设计的初衷**

### 2. 外部设置`student.__name`能成功吗

能成功，但是外部设置的`__name`和类定义的私有变量`__name`不是一个变量，**内部的私有变量会被自动修改成别的变量名**

## 类的继承

将要继承的类写在类的括号内

当类继承于`Object`时，Object可不写

python中的一个类可同时继承多个类

```python
# Dog类继承于Animal类
class Dog(Animal):
    pass
```

### 1. 多态

传入Animal的子类，由于Animal有run()方法，即会自动调用run()方法

```python
def do_run(animal):
    animal.run()
```

### 2. 动态语言 vs 静态语言

#### 动态语言

上方的函数中`animal`指的是变量名，所以可传任何类型变量

只要变量`animal`中有run()方法，无需考虑是否继承自`Animal`类，即可自动调用run()方法

#### 静态语言

由于变量必须指定变量类型，所以只用`animal`类和其子类才合法

## 获取对象信息

### 1. 判断对象类型

```pyton
# 查看object的类型
type(object)
# 判断object类型是否为int
type(object) == int
# 判断object是否为函数(需要import types)
type(object) == types.FunctionType
# 判断object是否为内建函数
type(object) == type.BuiltinFunctionType
# 判断object是否为lambda表达式
type(object) == types.LambdaType
```

### 2. 判断类是否继承了某一个类

```python
# 判断Dog是否为Annimal类型(Dog是否继承了Animal)
isinstance(Dog, Animal)
# 判断object是否为某些类型中的一种
isinstance(object, (Dog, Cat))
```

### 3. 获取对象所有属性和方法

```python
dir(object)
```

**类似`__xxx__`的函数在python中有特殊用途，比如在调用`len()`时本质调用了`__len__`**

我们自己可以重写类似`__xxx__`的函数

```python
# obj有x属性吗
hasattr(obj, 'x')
# 为obj设置一个属性y，复制为18
setattr(obj, 'y', 18)
# 获取属性'z'的值
getattr(obj, 'z')
# 获取属性'z'的值，若不存在，返回默认值404
getattr(obj, 'z', 404)
```

## 实例属性 vs 类属性

由于python是动态语言，可为每个对象实例附加实例属性

当势力属性和类属性重名时，实例属性会覆盖类属性，此时只有`del 实例属性`方可访问到类属性

## 为实例和类绑定一个方法

实例的方法绑定只对该实例有效，对其他实例无效

```python
def meth():
    pass
import types
# 为实例s绑定一个方法meth
s.meth = MethodType(meth, s)
```

类的方法绑定对其所有实例皆有效

```python
Student.meth = meth
```

## 限定实例可绑定的属性

在类中使用`__slots__`来规定属性，所有实例附加的属性必须在其中的tuple中，否则会抛出`AttributeError`异常

```python
class Student():
    __slots__ = ('name', 'age')
```

## 枚举类

枚举类有默认的`name`和`value`属性

当未给`value`赋值时，默认从1开始计数 (使用`Weekday = Enum('Weekday', ('Sun', 'Mon'))`方式建立不赋值的枚举类)

```python
from enum import Enum
class Weekday(Enum):
    Sun = 0
    Mon = 1
# 获取变量
> Weekday.Sun.name/.value
```
