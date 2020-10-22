# javascript

## `__proto__`和`prototype`

`__proto__`属性用于实现原型链，比如当对象访问一个变量或方法时，如果该对象中没有时就通过`__proto__`到上层对象中寻找，如果还找不到再到`__proto__.__proto__`中寻找，以此类推直到`__proto__`中指向的为null为止

js对象通过原型链的模式实现了继承，但是是单继承，每个对象的`__proto__`最上级都是`Object.prototype`，而`Object.prototype`的`__proto__`为null，表示到头了

js中class是一种语法糖，创建一个对象并其中添加变量和方法就相当于创建了个class实例，但这样存在着一个问题，即class中的方法函数需要在每个对象中都冗余存储一份，于是就利用到`__proto__`原型链属性，每个function都有个`prototype`属性，其中就存放在构造器constructor以及class中共享的方法，每个创建出来的对象的`__proto__`属性指向的都是该function的`prototype`对象，于是在调用对象class中方法时对象中不存在，但能在`__proto__`中找到已实现方法共享

```js
// class Person
function Person(name) {
    this.name = name;
    this.print = function() {
        console.log(this.name);
    }
}
// function Person 相当于下面的写法
function Person(name) {
    this.name = name;
}
Person.prototype.print = function() {
    console.log(this.name);
}
// new 语法糖创建对象
var p = new Person("Alice");
// new 实际执行
var p = new Object();
p.__proto__ = Person.prototype;
Person.call(p);   // 更改内部this指向为新构造的对象
```

![prototype和__proto__关系](./pics/js_prototype_proto.png)

## Undefined/Null

Undefined类型表示未定义，它的类型只有一个值，就是undefined

任何变量在未赋值之前都是Undefined类型，值是undefined(名为undefined的全局变量)，早期是可以修改undefined变量值从而造成所有Undefined类型变量值发生变化，于是在一些编程规范中就要求使用void 0来获取undefined值，因为void是关键词，不会被修改

Null类型表示定义了但值为空，其也只有一个值，就是null，但不同于undefined，null是js中的关键词所以也就不会出现undefined中的问题
