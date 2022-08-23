# Flutter核心技术与实战

## Dart

### 类

```dart
Point(this.x): y = 0;
```

其中`Point(this.x)`意思就是`x = x`，而`:`后往往进行一些变量初始化和校验

```dart
o
  ..x = 1
  ..y = 2; // 等同于 o.x = 1; o.y = 2;
```

- `extends`：子类复用父类的方法和属性
- `implements`：子类复用父类的方法名和参数，但不复用方法和属性
- `with`：mixin混入，当混入的类中有同名方法，则取`with`最后混入的类的实现

### 可选参数

```dart
void func1(int x, [int y, int z = 0]);
void func2(int x, {int y, int z = 0});
```

- `[]`表示可选参数
- `{}`表示可选命名参数，调用时需要指点参数名
- 参数都可以有默认值


- `?.`：当对象不为null时调用后续方法
- `?==`：当被赋值对象为null是进行赋值
- `??`：当前面为null则取后面的值，类似三元运算符






