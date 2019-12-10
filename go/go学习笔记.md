# go学习笔记

## 变量定义

- `var a string = "hello"` 使用`var`关键词，类型写在变量名后，go有类型推导，在初始化的情况下可以省略类型
- `a := "hello` 使用`:=`定义并初始化变量，但只能在函数内使用

## 常量定义

使用关键词`const`定义，且常量的变量名不需要全部大写

go语言没有`enum`关键词来定义枚举，因此使用`const`来定义

```go
// 使用iota来定义自增的数值，其中java = 0，python = 1，golang = 2
const (
    java = iota
    python
    golang
)
```

## 内建变量类型

- `bool`, `string`

- `(u)int`, `(u)int8~64`, `uintptr` 指针

- `byte`, `rune` 4字节的char

- `float32`, `float64`, `complex64`, `complex128`

- **go语言中没有隐式的类型转换，所有都是强制类型转换**

- **go语言中所有类型如果不初始化，都会有zero value**

## if

go语言中`if`不需要在条件中添加括号，例如`if a == 1`即可

在`if`的条件中也可以进行赋值，条件里赋值的变量作用域就在这个if语句里

```go
if contents, err := ioutil.ReadFile(filename); err != nil {}
```

## switch

`switch`关键词后不一定需要跟着表达式，例如`switch {}`也是可行的

**`switch`中所有的`case`都默认添加了`break`，即进入了一个`case`就会跳出`switch`**

## for

`for`的条件也不需要添加括号，例如`for i:= 1; i < 10; i++ {}`

`for`只添加初始条件时相当于`while`(go语言中没有`while`),`for`不添加条件时会成为死循环

## 函数

定义函数时，先写参数名，再写参数类型，返回值类型写在最后面，且可以为返回值设定变量名，但对于函数调用无任何实际影响

### go语言中函数支持多返回值

```go
func hello(a, b, c string) (string, string, string) {
    return a, b, c
}
```

多返回值函数必须接受所有返回值，但如果不需要某个返回值时，可以使用`_`来代替

### 函数可以作为参数和返回值

### 使用匿名函数

```go
return func () {
    fmt.Println("")
}
```

### 不定长参数

在类型前加上`...`表示为不定长参数

```go
func hello(nums ...int) {}
```

将切片作为不定长参数传入函数时，使用`slice...`形式将切片打散传入

```
nums := []int{1, 2, 3}
hello(nums...)
```

## 指针

go语言是值传递类型的语言

- 类型指针，**仅可对此指针类型的数据进行修改，不允许进行偏移和运算**
- [切片](#切片)

```go
func swap(a, b *int) {
    *a, *b = *b, *a
}
func main() {
    a, b := 1, 2
    swap(&a, &b)
}
```

## 数组

### 数组定义

先定义数组长度，再定义数据类型，使用`[...]`来省略具体数组长度

`[10]int`和`[20]int`是两种不同的类型

```go
array := [3]int{1, 2, 3}
array := [...]int{1, 2, 3}
```

### 数组遍历

使用`range`遍历

```go
// i表示索引，v表示数值
for i, v := range array {}
// _表示不关心索引，v表示数值
for _, v := range array {}
```

### 数组传递

函数把数组作为参数时，必须在类型前加上数组长度

**数组是值传递的**，因此当数组作为参数传递到其他函数中时，是将该数组复制了一份，并对其进行操作，因此对复制的数组进行修改是不会影响到原先的数组的

```go
func arr_change(arr [3]int) {}
```

## 切片(Slice)

由于数组是值传递的，因此当我们希望在函数内修改数组值时，除了使用指针外，切片是更好的选择

**切片本身没有数据，是对底层数组的一个view**，且可以对切片在进行切片

```go
arr := [...]int{1, 2, 3, 4, 5}
s1 := arr[:3]  // {1, 2, 3}
s2 := arr[1:3]  // {2, 3}
```

切片对象非常小，是只有三个字段的数据结构：一个指向底层数组的指针，一个是切片的长度(len)，还有一个是切片的容量(cap)

切片作为函数参数时，不能在`[]`内添加数字，否则就是数组类型了

切片在函数间也是值传递的，只是由于切片持有的是指向底层数组的指针，因此复制一份指针后，对底层数组修改还是有效的

```go
//  创建一个len为5，cap为10的切片
slice := make([]int, 5, 10)
// 
slice := []int{1, 2, 3}
```

### 切片的扩展

- 切片可以向后扩展，不可向前扩展
- 切片的索引可以超过len，但不能超过cap

```go
arr := [...]int{0, 1, 2, 3, 4, 5, 6, 7}
s1 := arr[2:6]  // {2, 3, 4, 5}
s2 := s1[3:5]  // {5, 6}
```

## 向切片添加元素

- 添加元素时如果超过cap，系统会重新分配更大的底层数组
- 由于值传递的关系，必须接受append的返回值

```go
// 删除某个元素
s := append(arr[:3], arr[3:])
```

## map

使用`map[key]value`跟着key类型和value类型

当通过key获取元素值时，如果不存在该key时，会返回该类型的默认值

```go
// 创建数组
m := map[string]int {
    "a": 1,
    "b": 2,
}
// 获取元素，value为元素值，ok为元素是否存在的bool值
value, ok := m["a"]
// 遍历获取key和value
for k, v := range m {}
```

### map中的key

go语言中的map由哈希表实现，因此key必须要能够比较相等

- 除了`slice`,`map`,`func`的其余内建类型都可以作为key
- 在`struct`中不包含上述字段也可以作为key

## 结构体

使用`type NAME struct`构建结构体

```go
type node struct {
    value int
    next *node
}
```

### 初始化

- 不设置任何参数，所有参数都会是该类型的默认值 `node {}`
- 填入所有参数 `node {1, nil}`
- 设置参数名，选填参数 `node {value : 1}`
- 使用`new`关键词，该返回的是地址 `new(node)`

**go语言中可以返回局部变量的地址**

在下面的函数中变量`n`是局部变量，但是go语言中允许返回其地址

```go
func create(v int) *Node {
    n := node {value : v}
    return &n;
}
```

> go语言中的局部变量是存在栈还是堆中内？ 事实上go语言会帮你管理你的局部变量，如果该局部变量仅在函数中使用，则放在栈中，使用完后清空，而如果该局部变量被一直使用，则会存储在堆中，由gc管理

### 获取结构体内变量

go语言中获取结构体内变量，无论是地址还是变量皆用`.`

```go
n := node {value : 1}
np := &n
// 以下都能获取到value值1
n.value np.value
```

### 为结构体扩展方法

在方法名前添加接受者，使得接受者类型变量可以以面向对象的形式调用方法 `n.print()`

```go
func (n node) print() {
    fmt.Println(n)
}
```

上面的方法是值接受者类型，**值接受者**顾名思义在函数内对其的修改是无法影响到外部的，因此还有**指针接受者**，使用指针接受者可以改变内容

- 要改变内容必须使用指针接受者
- 结构过大也考虑使用指针接受者，避免复制值的性能消耗
- 一致性：如果有指针接受者，最好全都是指针接受者

注意：**两个函数分别是值接受者和指针接受者但是名字相同，但也是不允许的**

由上面的注意可以发现你可以把地址传入值接受者函数，也可以把值传入指针接受者函数，go编译器会明白函数要的是值还是指针并自动作出转换，**但其内容是否改变只和其接受者模式相关**

## 封装

- 名字一般使用CamelCase
- 首字母大写：public
- 首字母小写：private

## 包

- 每个目录一个包
- main包包含可执行入口
- 为结构体定义的方法必须放在同一包内，但可以是不同文件

## 接口

go语言是面向接口编程，且支持duck type: 长得像鸭子的就是鸭子

在go语言中，任何实现了接口的函数的类型，都可以看作是接口的一个实现。类型在实现某个接口的时候，不需要显式关联该接口的信息。接口的实现和接口的定义完全分离

**任何类型都可以实现接口**，结构体、函数等都能实现接口

```go
// 定义一个接口
type runnable interface {
    run()
}
// 定义一个类型
type person struct {
    name string
}
// 实现一个接受者方法
func (p person) run() {
    fmt.Println("running")
}
// 以上就可以认为person实现了runnable接口
```

### 空接口

空接口就是不包含任何方法的接口，正因为如此，**所有的类型都实现了空接口**

可以定义空接口`interface {}`来存放任何类型数值

### 类型断言

使用`x.(T)`的方式判断该变量类型是否是该接口

由于`x.(T)`只能是接口类型判断，所以传参时候，传入的是接口类型

```go
func check(m interface{}) {
    value, ok := m.(Runnable)
}
```

使用`switch`判断`value`来断言变量类型，`.(type)`前的变量必须为接口

```go
switch value := person.(type) {
case int:
    ...
}
```

### 接口组合

```go
type person interface {
    runnable  // 接口
    sleepable  // 接口
    get()  // 其他方法
}
```

## 闭包

go语言原生支持闭包

闭包在js中的理解是可以为变量延伸作用域链，函数中的变量本来是不可以被外部访问的，但是通过返回匿名函数，由于返回的匿名函数中引用了局部变量，因此局部变量的作用域被演延长，外部可以通过返回的匿名函数访问到内部局部变量，go语言也类似，局部变量可被外部访问也可以理解为运行环境的保留

```go
func adder() func(int) int {
    sum := 0
    return func(i int) int {
        sum += i
        return sum
    }
}
```

当使用`a := adder()`接受了返回的函数时，也返回了这个函数的环境，即`sum`这个变量会一直跟随着函数

## panic

`panic`类似于`exception`，但我们应该尽可能处理`panic`

- 停止当前函数执行
- 一直向上返回，执行每一层`defer`
- 没有遇到`recover`，程序退出

可预料到的使用`error`，运行时的使用`panic`

使用`defer + recover + panic`处理错误，并使用`Type Assertion`对错误进行分别处理

## defer

- `defer`修饰的语句调用时机是在外层函数设置返回值之后, 并且在即将返回之
- 参数在`defer`语句时计算
- `defer`列表是个栈，先进后出 (越靠近`return`的`defer`语句越先执行)

```go
func hello() (r int) {
    return 0
}
// return语句可以拆分为如此两句
// defer语句会在r=0之后，return之前执行
func hello() (r int) {
    r = 0
    return r
}
```

## recover

- 必须在`defer`调用中使用
- 获取`panic`的值
- 如果无法处理，可再次`panic`

```go
defer func() {
    if r := recover(); r != nil {
        ...
    }
}()
```

在`defer`中用匿名函数来使用`recover`，注意，一定要在最后加上括号调用它

## Test

- 包含单元测试的go文件名必须以`_test`结尾
- 单元测试文件与测试的函数所在文件处在同一包中
- 单元测试的函数名必须以`Test`开头，并是可导出的公开函数
- 单元测试的函数必须接收一个testing.T类型的指针，并且没有返回值

`go test [path]` 运行单元测试
`go test [path] -v` 运行单元测试，显示详细信息
`go test -coverprofile=c.out` 生成单元测试代码覆盖率，使用`go tool cover -html=c.out`在浏览器中查看

## 注释

`go doc [func/file]` 查看文件/函数/变量的文档
`godoc -http=localhost:6060` 打开本地服务查看文档(`$GOROOT/src/pkg`和`$GOPATH`下的源代码)

为文档添加Example:
- 必须放在单元测试文件内，即文件必须以`_test`结尾
- 方法必须以`Example`开头，且不接受任何参数
- 使用注释`// output:`来标记期望结果，go会自动将函数输出结果与`// output:`后的做比较

```go
func ExampleMyAdd() {
    fmt.Println(MyAdd(1, 2))
    // output:
    // 3
}
```

## import

go代码初始化流程：先加载import包，然后依次`const -> var -> init()`顺序初始化

- `import myfmt "fmt"`表示给fmt包启用了别名myfmt，使用myfmt代替fmt作为包名来调用函数
- `import . "fmt"`表示fmt包下的函数变量可以直接使用，无需使用fmt包名
- `import _ "fmt"`表示会默认执行fmt包中的所有init函数，但无法调用fmt包中的函数