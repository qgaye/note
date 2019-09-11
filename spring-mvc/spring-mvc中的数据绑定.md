# SpringMVC中的数据绑定

## 基本数据类型的绑定

由于`int`是基本数据类型，不可接受`null`数据，因此只能传递数字

### 合法url

- `http://localhost:8080/test?myAge=1`

### `@RequestParam`的作用

使用`@RequestParam`为参数`age`重命名，在url中使用`myAge`代替`age`

```java
public String test(@RequestParam('myAge') int age) {...}
```

## 封装数据类型的绑定

由于`Integer`是封装数据类型，可接受`null`数据

### 合法url

- `http://localhost:8080/test`
- `http://localhost:8080/test?age=1`

```java
public String test(Integer age) {...}
```

## 数组的绑定

不传参数是不合法的，数组的长度必须大于0

### 合法url

- `http://localhost:8080/test?name=tom&name=kitty&name=jaz`

```java
public String test(String[] name) {...}
```

## 类的绑定

url中使用类中的变量名传递

可不传参数，默认为`null`

### 合法url

- `http://localhost:8080/test?name=tom&age=18&address.area=Shanghai`
- `http://localhost:8080/test`

```java
public class User {
    private String name;
    private Integer age;
    private Address address;
}
public class Address {
    private String area;
}
public String test(User user) {...}
```

### 当传递的类中还有类

使用`xxx.yyy`的形式传递，启动`xxx`为第一个类中的变量名，`yyy`为类中类的变量名

### 当同时传递两个类有相同名称的变量

假如两个类都有`name`变量，若此时`name = tom`，则会同时给两个类的`name`赋值相同的`tom`

使用`WebDataBinder`绑定属性，`@InitBinder`中填入的是需绑定发方法中的变量名，`setFieldDefaultPrefix`表示为该变量设定前缀，此时可以使用`http://localhost:8080/test?user.name=tom&admin.name=jack`分别为两个类设定同名变量`name`

```java
// User类和Admin类中都有同名name变量
public String test(User user, Admin admin) {...}
@InitBinder("user")
public void initUser(WebDataBinder binder) {
    binder.setFieldDefaultPrefix("user.");
}
@InitBinder("admin")
public void initAdmin(WebDataBinder binder) {
    binder.setFieldDefaultPrefix("admin.");
}
```

## List的绑定

SpringMVC中不能直接传List，必须对List进行包装

### 合法url

- 注意：`[]`在url中可能需要进行编码，否则可能无法识别
- `http://localhost:8080/test?users[0].name=tom&user[1].name=jack`
- `http://localhost:8080/test?users[0].name=tom&user[20].name=jack` => 会生成20个，未赋值的为`null`
- `http://localhost:8080/test` => 空List

```java
public UserListForm {
    private List<User> users;
}
public String test(UserListForm userListForm) {...}
```

## Set的绑定

SpringMVC中不能直接传Set，必须对Set进行包装

在Set的包装类中必须对Set进行初始化，否则Set的size为0，会报异常。在传参时，如果index大于了初始化的size，则报错

### 合法url

- `http://localhost:8080/test?users[0].name=tom&user[1].name=jack`
- `http://localhost:8080/test` => 返回已初始化个数的Set，变量值都为`null`

```java
public UserSetForm {
    private Set<User> users;
    // 初始化users，设定initialCapacity后size还是0，必须使用add
    public UserSetFor() {
        users = new HashSet<>();
        users.add(new User());
    }
}
public String test(UserSetForm userSetForm) {...}
```

> 需重写`equal()`和`hashCode()`方可使特定实例相同，只接受一个

## Map的绑定

SpringMVC中不能直接传Map，必须对Map进行包装

Map类型中若key相同，则会存储在同一个实例中

### 合法url

- `http://localhost:8080/map?users[X].name=tom&users[Y].name=jack`
- `http://localhost:8080/map?users[X].name=tom&users[X].name=jack` => 只有一个key为X的map，其中name为tom,jack
- `http://localhost:8080/test` => 空Map

```java
public UserMapForm {
    private Map<String, User> users;
}
public String test(UserMapForm userMapForm) {...}
```

## Json的绑定

- 请求方式为POST

- 方法中的参数需加上`@RequestBody`注解

- 在Body传json，将Context-Type设为application/json

- 在SpringMVC中使用Json需要`jackson-databind`和`jackson-mapper-asl`两个包的依赖

```java
@PostMaping("/json")
public String test(@RequestBody User user) {...}
```

## Xml的绑定

- 请求方式为POST

- 方法中的参数需加上`@RequestBody`注解

- 在Body传xml，将Context-Type设为application/xml

- 在SpringMVC中使用Xml需要`spring-oxm`包的依赖

```java
@PostMaping("/xml")
public String test(@RequestBody User user) {...}
```
