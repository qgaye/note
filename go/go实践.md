# Go实践

## 切片

## range是拷贝而不是引用

```go
arr := [...]int{1, 2, 3}
for k, v := range arr {
    fmt.Println(k, v)
}
```

这里range会把arr拷贝一份，因此此时range遍历的是个副本，arr此时是数组，因此拷贝的就是一整份数组对象，如果arr是切片，那么拷贝的就是切片对象(len，cap这些)

如果是数组需要将所有数据做一次拷贝，因此是很浪费性能的，此时可以通过`range &arr`指针或`range arr[:]`切片(切片结构体很小，拷贝很快)来减少数据量的拷贝

## 拷贝切片

```go
sClone := make([]int, len(arr))
clone(sClone, arr)
```

```go
sClone := append(arr[:0:0], arr...)
```

第二种性能更好且第一种当arr为nil情况下拷贝出来的sClone不是nil，而第二种可以保证还是nil

## 初始值

```go
int/int8/int32/int64         0
float32/float64              0
uint/byte                    0x0
rune                         0
bool                         false
string                       ""
[1]int                       [0]
[]int                        nil
map/interface/chan/func/指针  nil
```

## rune/byte/string

Unicode 字符集
UTF-8 编码规则

Unicode中标记了世界上所有字符和一个唯一数字的映射，它对字节数量没有限制，没有要求说Unicode必须占有两或三个字节(只是很多编码规则只实现了两字节的Unicode，即65536个字符，这些字符中不包括emoji)，Unicode被编码成二进制是使用UTF(Unicode Transformation Formats)定义的，Unicode仅仅指定了字符对应的数字
UTF-8是Unicode的一种编码方式，其使用一种变长的编码方式，0～127还是使用一字节表示，兼容了ASCII编码，只有在128号的字符开始才会使用2/3/4个字节来表示
UTF-16也是Unicode的一种编码方式，其也是变长的编码方式，但最少两字节，因此两字节能表示的符号和Unicode中一致，超出两字节的Unicode部分就需要四字节编码，并且因为最少需要两字节，其不能兼容ASCII编码

- [Unicode和UTF-8区别](https://www.zhihu.com/question/23374078/answer/69732605)
- [Unicode的流言终结者和编码大揭秘](https://www.freebuf.com/articles/others-articles/25623.html)

byte uint8的别名 表示一个字节
rune int32的别名 用四个字节表示一个Unicode的字符

string底层是一个byte的切片，而Go文件都是以UTF-8编码存储的，UTF-8是变长编码的，比如中文就是三个byte，因此如果将string转为[]byte，遍历很可能会乱码

因此要对string遍历得到每个字符的话，就需要转为[]rune，而range string默认就是转为[]rune，因此string在直接range下能正确输出每个字符

直接对string取len取到的是底层byte的len，即UTF-8的字节数，如果需要取到string的字符数，那么就可以len([]rune(str))转为rune取长度

## iota

iota表示其在const组内的位置，从0开始，空行/注释行不算一行，但`_`算一行，每个const组之间互相不影响

const组内如果一个变量未指定赋值语句，则默认使用上一行的赋值语句，即变量`b = iota, c = iota`，而且任何类型的变量都适用，而不是非iota不可

```go
const (
    a = iota // 0
    b        // 1
    _
    c        // 2
)
```

