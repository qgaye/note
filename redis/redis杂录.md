# Redis杂录

## 字符串

Redis中不是直接使用c语言的字符串，而是创建了SDS(Simple Dynamic String)的抽象类型

SDS定义：

```c
struct sdshdr {
    int len;  // buf数组中已使用的字节数量，即SDS中字符串的长度
    int free;  // buf数组中空闲的字节数量
    char buf[];  // 存放字符串
}
```

SDS优势：

- c语言字符串不记录自身长度，每次必须遍历整个字符串才能获得其长度，而SDS中记录了字符串长度，将计算长度从O(n)降为O(1)
- 杜绝了缓冲区溢出，比如strcat连接字符串时，如果首个字符串预留的长度不足时，会溢出占用到其内存位置后的空间，而SDS中有free字段记录了剩余空间，并且其连接字符串方法会自动将空间不足的字符串进行扩大空间
- SDS的空间预分配策略/惰性空间释放策略来减少修改字符串带来的内存重分配次数，空间预分配策略就是在修改SDS字符串时在分配需要的内存前提下再预先多分配同等大小的空间free(大于1M时预分配1M)；惰性空间释放策略则是在删除字符串字符时不立即释放掉多余内存空间，而只是修改len和free字段
- 二进制安全的，使得SDS可以保存任意的二进制数据

## 链表

- 双端：每个链表节点都有pre和next指针
- 无环：头节点的pre和尾节点的next都是NULL，对链表的访问以NULL结尾
- 链表带头head和尾tail指针，获取头节点和尾节点都是O(1)
- 链表带有长度计数器，获取链表长度为O(1)

## 字典

字典使用hash表作为底层实现

```c
struct dictht {
    dictEntry **table;  // hash表数组
    unsigned long size;  // hash表大小
    unsigned long sizemask;  // size - 1，计算索引时取模用的
    unsigned long used;  // 该hash表已有节点数
}
```

Redis中的hash表采用链地址法解决键冲突问题



