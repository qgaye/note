# Kafka核心技术与实战

- Broker：负责接受和处理客户端的请求，多个broker组成一个Kafka集群，虽然多个broker可以部署在一台机器上，但更多的是将broker部署在不同的机器上
- Topic（主题）：承载消息的逻辑容器，可以用来区分不同业务
- Partition（分区）：一个有序不变的消息队列，每个topic下有多个partition
- Offset（消息位移）：表示消息在partition中所在的位置，是个单调递增且不变的值
- Replica（副本）：每条消息会被拷贝到多个地方以提供数据冗余，副本分为领导者副本（leader replica）和追随者副本（follower replica），领导者副本向外提供服务，而追随者副本仅仅追随领导者副本，进行数据复制
- Producer（生产者）：向topic发送消息
- Consumer（消费者）：从topic中消费消息
- Consumer Offset（消费者位移）：表示consumer的消费进度，每个consumer都有自己的consumer offset
- Consumer Group（消费组）：多个consumer组成一个consumer group，consumer group下的各个consumer负责消费不同的partition以实现高吞吐
- Rebalance（重平衡）：consumer group中某个consumer挂了后，其他consumer会自动重新分配消费该topic下的partition

为什么Kafak不像MySQL一样允许副本（从库）对外提供读服务：
- 天然支持负载均衡：kafka本身已经将数据分散到多个partition上，partition又是分散在不同的broker上的，即本身就已经做到了负载均衡，而不是像MySQL压力都在主库上
- 场景不匹配：Kafka有频繁的消息写入，不同于MySQL，并不是典型的读多写少的场景，不适合读写分离

尽量保证服务端版本和客户端版本一致，否则会损失很多Kafka提供的性能优化的收益，因为版本差异会导致消息格式需要转换，格式转化会导致丧失Zero Copy

## Kafka集群

- 操作系统：Linux支持epoll和zero copy
- 磁盘：都是顺序写入，使用普通磁盘即可，RAID按需使用（RAID会有一定的性能损耗）
- 磁盘容量：根据消息数、留存时间、消息大小、备份数、是否开启压缩预估磁盘容量，实际使用中预留20%~30%的磁盘空间
- 带宽：按带宽的70%计算，避免大流量下的丢包，此外还要预留一些带宽服务于follower节点拉取数据用

Kafka通常情况下不太占用CPU，除了下述特殊情况：
- server和client使用了不同的压缩算法
- server和client版本不一致导致消息格式转化
- broker端解压缩校验

Broker参数：
- `log.dirs`：指定Broker使用的文件目录路径，配置多个路径的好处在于可以提升读写性能，并且可以实现故障转移即failover（旧版本kafka broker使用的任何一块磁盘挂了，整个broker都会停止，在1.1开，挂了的磁盘上的数据会自动转移到正常的磁盘上，这也就是为什么kafka不太需要RAID的原因）
- `zookeeper.connect`：用于指定kafka使用的zookeeper集群
- `listeners`：表示外部通过什么协议、主机名、端口号访问kafka服务，格式为`<协议名，主机名，端口号>`，协议比如PLAINTEXT表示明文传输，SSL表示SSL/TLS加密传输

Topic参数：
- `auto.create.topics.enable`：是否允许自动创建topic，当设置为true如果发消息的topic不存在就会自动创建，建议设置为false
- `unclean.leader.election.enable`：是否关闭unclean leader选举，当设置为true如果leader挂了，并且那些同步数据比较多的副本也都挂了，那么就会允许从落后很多的副本中选出leader，建议设置为true
- `auto.leader.rebalance.enable`：是否允许kafka定期对一些topic的partition进行leader重选举，换一次leader的成本很高，所有客户端都要改向新的leader发送请求，而且这种换leader本质上没有任何性能收益，因此建议设置为false
- `log.retention.{hours|minutes|ms}`：控制一条消息数据被保存多长时间
- `log.retention.bytes`：指定broker用于保存消息的最大磁盘容量
- `message.max.bytes`：broker能接收到的最大消息大小

相关操作系统参数：
- 文件描述符限制：文件描述符资源并不像我们想象中的昂贵，但如果设置的过小会导致too many open files报错，所以将他设置成一个超大的值是个较为合适的做法
- 文件系统类型：XFS性能好于ext4
- swap调优：不建议设置为0，因为一旦设置为0后当物理内存耗尽就会触发OOM，然后操作系统会随机kill调一个进程，根本不给用户任何的预警，建议设置成一个较小的值，当开始使用swap时可以观察到broker的性能开始急剧下降，进而留出进一步调优和处理的时间
- fsync时间：kafka并不是等到数据真正落盘才认为操作成功，而是只要写入page cache即可，随后操作系统会定期根据lru算法定期将page cache上脏页刷盘，定期的默认时间为5s，一般情况下认为这个时间间隔过于频繁，可以适当增加时间间隔来降低磁盘压力，因为kafka在软件层面提供了多副本冗余机制，所以这里不需要像MySQL、Redis那样在意fsync时间间隔
- JVM堆内存：默认1GB太小，建议6GB，因为kafka和客户端交互时会创建大量ByteBuffer，堆内存不能太小，此外堆内存也不宜过大，不然一次full gc就要花更长时间

Kafka限流：会在user(租户) + client id纬度上进行限流，可以在带宽和CPU上进行限制
- 限制follower副本拉取leader副本消息的速率
- 限制producer的生产速率
- 限制consumer的消费速率
当Kafak检测出需要进行限流时，broker不会直接返回错误，而是直接对需要限流的client进行强制sleep，这种限流方式对client完全透明，并且client也无需实现任何特殊的侧策略来应对，但要注意这样在broker端强制sleep的限流方式会导致client端的请求超时，故在使用时要适当调大请求的超时时间，防止client因为请求超时而不停重试，这反而会加剧问题

## 分区策略

- 轮询策略：即第一条消息发给分区0，第二条发给分区1，以此类推，轮询策略有着非常优秀的负载均衡的表现，总能保证消息最大限度被平均分配到所有分区上，避免数据倾斜，这也是kafka的默认分区策略
- 随机策略：将消息随机发送到一个分区上，其负载均衡表现不如轮询
- 按消息键Hash策略：kafka允许为每条消息定义消息key，然后根据key的hash值发送到指定分区，通过指定消息key可以保证消息被发送到指定分区，而同分区上的消息处理是保证先后顺序的，从而保证消息的顺序消费（因为kafka不同的分区之间是不保证顺序的），
- 地理位置策略：当kafka集群跨地域时，可以让国内的消费国内的partition，国外的消费国外的partition

注：
1. kafka的消息重试仅仅只是将消息重新发送到之前的分区，也就是消息重试不会改变分区
2. 当消费者出现rebalance时，即使选择了按消息键hash的策略，也无法保证同key消息发送到同分区上，即无法保证消息的顺序性了，此时只能选择单分区的方式来保证顺序性

## 压缩算法

Kafka中压缩和解压缩：producer端压缩，broker端保持，consumer解压缩

大部分情况下broker接收到producer的消息后仅仅是原封不动的保存而不会进行任何任何修改，除非：
1. broker和producer指定了不同的压缩算法，此时当broker收到消息后就不得不先解压缩，再用broker端的压缩算法压缩后保存
2. broker和consumer消息格式不同，为了兼容老版本的格式，broker会对新版本的消息进行转换，这里的转换不但需要解压缩，还使得kafka丧失了zero copy的能力，对性能有很大影响（producer到broker阶段不会使用到zero copy）

在producer到broker后，broker会对压缩过的消息集合进行解压缩操作，目的是进行验证，但毫无以为会对broker端性能造成影响，尤其是CPU

kafka中消息格式分为V1和V2版本，在V1中会对每条信息进行CRC校验，而在V2中则是对消息集合这一层进行CRC校验，性能更佳，此外V1是针对每条消息进行压缩然后保存到消息集合中，而V2则是直接对整个消息集合进行压缩，V2的压缩效果更佳

消息：V1中叫message，V2中叫record
消息集合：V1中叫message set，V2中叫record batch
kafka中读写都是以批(patch)为单位的

吞吐量：LZ4最佳
压缩比：zstd最佳

## 防止消息丢失最佳实践

- 不要使用`producer.send(msg)`，要使用带有回调方法的`producer.send(msg, callback)`，因为kafka的send是异步的，也就是调用完send就立即返回了，但此时不能判断消息是否成功发送
- 设置`ack = all`，表示必须所有副本都接收到该消息，该消息才算是已提交
- 设置retries一个较大值，当网络抖动时消息发送失败，配置了retries的producer会自动重试发送消息（和callback不冲突，callback代表回调结果，而重试是自动的）
- 设置`unclean.leader.election.enable = false`，避免一个落后leader太多的follower可以成为新leader，因为其成为新leader必然会造成消息丢失
- 设置`replication.factor >= 3`，即将消息多保存几份副本，防止消息丢失的最好方法就是冗余
- 设置`min.insync.replicas > 1`，控制消息至少要被写入到多少个副本才算已提交，实际环境避免使用默认值1
- 确保`replication.factor > min.insync.replicas`，如果两者相等，那么只要有一个副本挂了整个partition都无法正常工作
- 确保消息消费完再提交，关闭`enable.auto.commit`自动提交，采用手动提交的方式

## TCP连接

何时创建TCP连接：
1. 在创建KafkaProducer实例后，会在后台创建一个Sender线程，和`bootstrap.servers`参数中配置的broker进行连接
2. 当producer给一个不存在的topic发消息时，broker会告诉producer该topic不存在，此时producer会发送METADATA请求给broker去获取最新的元数据
3. producer会定期去更新元数据信息，间隔时间通过`metadata.max.age.ms`控制，默认值3000，即5分钟

注：producer在所有获取到元数据需要和元数据中所有broker进行连接，但往往一个producer只会和固定几个broker进行数据请求，那么在一定时间后大部分连接又会被关闭，这无疑是非常浪费连接池资源的

何时关闭TCP连接：
1. 调用producer.close()关闭或`kill -9`暴力关闭
2. kafka自动关闭，当这个连接在一定时间内没有任何请求，那么就会被自动关闭，这个时间由`connection.max.idles.ms`控制，默认9分钟

## 


