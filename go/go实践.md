# Go实践

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

