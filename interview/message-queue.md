# 消息队列 RabbitMQ/Kafka

## Kafka

### Kafka架构

broker：一个kafka节点(服务器)就是一个broker，一个或多个broker可以组成一个kafka集群
topic：kafka根据topic对消息进行归类，发布到kafka集群的每条消息都需要指定一个topic
partition：topic的分区，一个topic可以有多个分区，topic中不同partition中数据是不重复的，且partition内部数据是有序的，但partition间数据顺序不保证

topic和partition：每个topic被分为多个partition，任何发布到该partition上的消息都会追加到log的尾部，因此写入都是顺序写入，速度很快。每个消息在文件中的位置称为offset，offset是一个long类型的数字

partition和segment：partition在物理上表现为一个文件夹，而在每个partition文件夹下又会分成多个segment，每个segment也分别是个文件夹，segment文件夹中包括.log，.index和.timeindex三个文件，其中.log是实际存储message的地方(也就是追加写入的地方)，.index和.timeindex都是索引文件，其中.index表示的是基于offset的索引，并且是个稀疏索引，而.timeindex表示的是基于timestamp的索引
每个segment中的.log文件大小是相同的，但是存储的message数量是不一定相等的(因为每个message大小是不一定相等的)，segment中的.log，.index和.timeindex三个文件都是以该segment中最小的offset来命名的

```txt
partition0
├── segment0
│  ├── 00000000.index
│  ├── 00000000.log
│  └── 00000000.timeindex
└── segment1
   ├── 00000000.index
   ├── 00000000.log
   └── 00000000.timeindex
```

segment和其中三种文件的作用：将partition拆分为多个segment后，在查询时可以先通过二分查找法找到该offset对应的segment，接着在segment中的.index文件中也通过二分查找法找到最接近的稀疏索引的值(也就是.log文件中的物理偏移位置)，通过物理偏移位置在O(1)直接定位到.log文件中位置，接着顺序扫描到查询的的offset处的message。其次，每个segment对应个物理文件夹也使得在清除旧数据时直接删除该文件夹就行了，避免了对文件的随机读取和删除(注意：清除旧数据并不能加快查询速度，因为无论如何都是通过物理偏移量来定位message的，因此永远是O(1))

partition的意义：
- 方便扩展：一个topic对应多个partition，从而可以通过增加机器来扩展和应对增长的数据量
- 提高并发：consumer消费时以partition为单位，因此一个consumer group中最多可以有partition数量的consumer同时消费
  - producer在发送消息时可以指定写入的partition，如果指定了，就会写入指定的partition
  - 如果没有指定partition，但设置了数据的key，则会根据key的值hash出一个partition写入，因此如果需要将消息发送到同一个partition中，将key都设为相同即可
  - 如果即没有指定partition也没有指定key，那就会轮询找出一个partition写入
- 高可用：partition的设计模式使得副本的最小单位是partition，而不用像rabbitmq那样必须全部数据统一创建副本

message结构：.log文件也就是message存储的地方，一个message主要有三个信息
- offset：offest是一个8byte的有序id，其可以唯一确定一条message在partition中的位置
- message大小：message大小占4byte，用于描述message体大小
- message体：存放实际的message内容数据(被压缩过)，不同的message占用的空间大小也不同

consumer group和consumer：客户端消费消息时以consumer group为最单位，一个consumer group可以消费topic下所有消息，并且不同consumer group间不会互相影响，即不会发生一个consumer group消费掉的消息另一个consumer group就消费不到的问题。consumer group中包含多个consumer，其中consumer会和partition进行一对一或者一对多的消费关系，即当consumer group中consumer数量等于partition时，每个consumer负责消费一个partition，当consumer group中consumer数量小于partition数量时，每个consumer可能消费一个或多个partition，当consumer group中consumer数量大于partition数量时，部分(partition数量的)consumer消费一个partition，剩下大于partition数量的consumer不会消费任何partition，因此不建议consumer group中consumer数量设置大于parition数量
总结：每个partition至少保证被该consumer group下一个consumer消费，也保证只会被该consumer group下一个consumer消费，从而保证整个consumer group会消费该topic下所有消息但又不会重复消费

partition副本(replication)：为了提高消息可靠性，可以通过复制因子配置每个partition有多少个副本，这些partition副本会分布在不同的broker上。当消息提交到leader上时，可以通过参数配置要求必须等待所有follower来拉取消息并写入自己的磁盘上后，这条消息才被leader确认返回，此时就可以保证leader宕机后其他follower可以来顶替继续服务

AR/ISR：AR表示的是partition所有副本，而ISR表示的是副本同步队列，ISR由leader管理，ISR是AR的一个子集。当副本的partition中消息记录对于leader超出延迟时间或超出延迟消息条数时，就会被移出ISR，此外可以通过参数配置要求一条消息发送成功必须ISR中有多少副本，从而保证有多少副本成功复制了该消息
在新版本的kafka中移出了基于超出延时消息条数的配置，只会基于超出延时时间，因为当producer一下子发来大量消息，消息数量大于配置的延时消息条数时，就会导致所有副本被移出ISR，然后等消息复制完后再移入，浪费性能

WH：高水位，在.log文件中由HW和LEO两个概念，HW表示高水位，此处前的所有消息都是可以被消费的，LEO表示日志文件的末尾，也就是写入的日志位置。HW处的消息表示所有ISR的副本都已经保存了该消息，因此即使leader宕机，也能保证消息能从新选举出来的leader中获取到
此外，当leader宕机后再重新加入集群时，为了保证消息的一致性，会要求旧leader将消息截取到HW处，再和新leader进行同步

### Kafka为什么快

- 顺序写磁盘：kafka中每个partition中的数据都是以追加的形式追加到该partition末尾上的
- 充分利用page cache：page cache目的是缓存了磁盘上的部分数据，当请求的数据刚好在page cache上就是最新的，那就可以立即返回从而减少次IO查询，更多page cache好处：
  - IO Scheduler会将一些写操作进行排序后执行，从而减少磁头的移动时间
  - 充分利用系统内存，因为JVM内存大小是有限制的，并且JVM上有GC负担
  - 如果进程重启，JVM内的cache会失效，而page cache依然有效
  - 如果kafka的producer和consumer生产和消费速度相差不大，那么几乎只需要对page cache就能完成生产-消费的过程
  - 但是，如果写数据时只将数据写入page cache，并不能保证数据一定会落盘，当机器宕机时如果page cache中的数据没有刷入磁盘，那就会造成数据丢失，但这些都可以通过partition的replication去解决，而强制每次写入message都做一次page cache刷盘会大幅降低性能，因此不建议
- 零拷贝，kafka中.log文件采用的sendfile的零拷贝方式，而索引文件采用mmap + write的零拷贝方式

### Kafka索引

kafka使用的是稀疏索引，从而能够在有限的内存中保存更多的索引

kafka中有三种索引，`.index`表示offset索引，保存了offset和对应的磁盘物理位置，`.timeindex`表示时间索引，保存了时间戳和对应的offset值，`.txnindex`表示已中止事务索引(当kafka开启事务之后才会出现)

kafka索引的写入使用的是mmap + write的零拷贝，通过内存映射文件的方式，首先减少了次读缓冲区到用户缓冲区的CPU拷贝的操作，其次对于索引这种比较小的文件通过内存映射的方式访问速度远远快于read/write操作

offset索引中每个索引项占8byte，其中物理地址占4byte，offset占4byte，那就存在个问题，在kafka中offset是以long存储的，即占8byte，那么是怎么用4byte存储的呢。此处的offset存储的是相对offset，即`真实offset - 该segment的base offset`的值，因为segment大小由整型(4byte)配置，因此差值一定在4byte内

同理，时间索引中每个索引项占12byte，其中时间戳占8byte，相对offset占4byte

kafka中稀疏索引在查询时使用的是二分查找法，但二分查找法存在一个问题，当索引文件需要写到新的一页上时，此时二分查找所遍历到的页很可能都是冷页，即需要IO操作从磁盘中取出，因此是很耗时的(二分查找中start+end/2的页一定在缓存中，但当写入新的页时start+end/2的页就可能全部更改，那么缓存中的页都无法命中了)。此外kafka中消息的消费也往往是消费最新的(也就是最后面的)页，因此往往也没有必要缓存所有二分查找中会遍历到的页。因此kafka将索引也分为热区和冷区，热区固定大小为末尾前的8192byte(为什么是8192byte，因为通常cpu缓存页大小为4096byte，因此热区也就是2页，而在普通的二分查找时最后确定页一定通过其左右两页确定的(比如确定2，是通过1和3确定的)，因此能保证8192byte一定在缓存中，也就是热区)
- 首先基于索引文件末尾位置计算出前8192byte位置，该范围表示是热区
- 判断查询的索引项是否在热区中(如果查询的索引项比热区最小值还小，就说明不在热区)，如果在就在热区中查找(`binarysearch(热区最前端，索引文件末端)`)
- 如果不在热区，则在冷区中查找(`bianrysearch(0，热区最前端)`)


