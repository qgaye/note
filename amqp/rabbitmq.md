# RabbitMQ笔记

## 安装

[RabbitMQ官网](https://www.rabbitmq.com/)

MacOS可以通过`brew install rabbitmq`安装

Docker中使用`rabbitmq:3-management`镜像，自带web管理界面

- RabbitMQ默认端口：`5672`
- RbbitMQ默认Web界面端口：`15672`

## 集群

测试时是通过Docker模拟的集群环境

注意点
- `docker-compose.yml`中的`version`为3.5而不是3(如果不为network设定名称，则皆可)
- 多个rabbitmq共用一个network
- 多个rabbitmq的`RABBITMQ_ERLANG_COOKIE`必须设置为相同值
- 为作为集群的节点添加`link`以在该容器中能通过指定名称host连接

```text
version: '3.5'
services:
  rabbitmq1:
    image: "rabbitmq:3-management"
    hostname: "rabbit1"
    container_name: "rabbitmq1"
    environment:
      RABBITMQ_ERLANG_COOKIE: "SWQOKODSQALRPCLNMEQG"
      RABBITMQ_DEFAULT_USER: "qgaye"
      RABBITMQ_DEFAULT_PASS: "0601"
      RABBITMQ_DEFAULT_VHOST: "/"
    ports:
      - "15672:15672"
      - "5672:5672"
    networks:
      - rabbit_cluster_net

  rabbitmq2:
    image: "rabbitmq:3-management"
    hostname: "rabbit2"
    container_name: "rabbitmq2"
    environment:
      RABBITMQ_ERLANG_COOKIE: "SWQOKODSQALRPCLNMEQG"
      RABBITMQ_DEFAULT_USER: "qgaye"
      RABBITMQ_DEFAULT_PASS: "0601"
      RABBITMQ_DEFAULT_VHOST: "/"
    ports:
      - "15673:15672"
      - "5673:5672"
    links:
      - "rabbitmq1:rabbit1"
    networks:
      - rabbit_cluster_net

  rabbitmq3:
    image: "rabbitmq:3-management"
    hostname: "rabbit3"
    container_name: "rabbitmq3"
    environment:
      RABBITMQ_ERLANG_COOKIE: "SWQOKODSQALRPCLNMEQG"
      RABBITMQ_DEFAULT_USER: "qgaye"
      RABBITMQ_DEFAULT_PASS: "0601"
      RABBITMQ_DEFAULT_VHOST: "/"
    ports:
      - "15674:15672"
      - "5674:5672"
    links:
      - "rabbitmq1:rabbit1"
    networks:
      - rabbit_cluster_net

networks:
  rabbit_cluster_net:
    name: rabbit_cluster_net
```

## 消息队列中的特性

持久化：

可以分别为消息，队列，交换机设定是否持久化，从而保证在重启或异常的情况下消息不被丢失

消息确认机制：

自动确认：消费端自动发送个确认消息给服务端
显式确认：需要消费端显式ACK，即在消费处理完后调用方法

拒绝消息：

单条拒绝：设定拒绝后RabbitMQ是重发还是直接删除，一次只能拒绝一条(与DeliveryTag相同的那条)
批量拒绝：会拒绝在DeliveryTag之前的所有消息

预取消息数量：

消息队列会给消费者发送预取消息数量的消息，但在消费者发送ACK确认前，就不会再发送别的消息了

## 四种模式

1. 一队列对一消费者

生产者使用default exchange，生产者首先创建个队列，接着在publish的时候将exchange传空字符串，表示使用default exchange

default exchange是个direct exchange，它把队列名作为路由键route(当然需要你手动传进去)，在消费者处直接通过队列名获取消息(队列名必须和生产者中的队列相同)

2. 一队列对多消费者

当消息被一个消费者消费过后就不会再被别的消费者消费了

3. 发布-订阅

通过fanout类型的exchange来实现发布-订阅的模式，其本质就是为每个订阅者都设定了一个队列，而队列里面的都是相同的

生产者只需要创建一个fanout的exchange，然后把消息发到这个exchange上，路由键传空字符串，表示会分发给所有队列，队列由消费者绑定

消费者创建随机的队列/自定义名字的队列，绑定到和生产者同名的exchange上，既可以实现生产者发送一个消息，所有消费者都能拿到

4. 直连交换机和路由

在fanout的exchange中会将生产者的消息发送给所有队列中，如果希望指定队列接收到指定的消息，那么就可以通过direct exchange + route的方式

在生产端建立direct exchange，然后在发送消息时指定路由键route

在消费端建立队列和指定路由键route的绑定(即一个队列可以接受多个route的消息，也可以只接受一个route的消息)

5. Topic交换机

基本原理与direct exchange + route相同，只是这里exchange为topic，且路由键支持模糊

6. RPC

RPC模式相较于其他模式多了个回复的功能，A通过消息队列发送到了B，B处理完后会将结果放入消息队列中A指定的队列

B在将结果返回给A时，需要知道A的队列(route)，因此需要A在发消息时在reply_to设定回调的队列名(当然route也可以，但这里通过default exchange + 队列名实现路由)，然后A不断轮询/异步消费回调队列中的消息，实现RPC

总结：

在RabbitMQ中队列是和消费者绑定的，消费者只消费自己队列里的消息，且自己队列中的消息全部需要被自己消费

而生产者则管理着exchange的类型和路由键route，通过设定exchange和route，RabbitMQ会将消息发送到对应的队列中给消费者消费

## 保证消息可靠传输

1. 消费者确认

可以在basicConsume中将autoAck置为true，启动自动确认，但建议手动确认(basicAck)，以保证这个消息的业务是真正执行完成后再发送确认信息

2. RabbitMQ持久化

可以再队列，交换机，消息三个方面设定是否持久化

3. 生产者确认

事务机制：

事务机制是AMQP协议层面实现的，主要三个方法txSelect(), txCommit(), txRollback()

整个事务机制依赖了四个步骤：

- client发送txSelect给RabbitMQ
- RabbitMQ回答确认txSelect-OK给client
- 接着client开始正常的publish操作
- client发送tcCommit给RabbitMQ
- RabbitMQ回答确认txCommit-OK给client

整个过程中多了四个请求，毫无疑问是耗费了很多性能

Confirm模式：

生产者将信道设置为confirm模式，此时所有在该信道上传输的消息都会被指派一个唯一ID，当RabbitMQ成功接受到并投递到了对应队列后(如果设置了持久化会在持久化完成后)，会返回一个ACK确认消息

通过confirmSelect将信道设为confirm模式，它会先要求RabbitMQ返回一个Select-OK的确认消息

同步：即publish后阻塞住，直到waitForConfirm返回结果

同步批量：即publish的时候是一批一起发送给RabbitMQ的，只要返回ACK中ID之前的都确认成功送达，但是存在一旦一批中一条失败就会导致整批都需要重新发送

异步：为Confirm设置一个回调函数，处理批量和单条的情况，维护一个并发安全的未确认的DeliveryTag的Set，回调函数中发送成功就从Set中删掉DeliveryTag，失败就重试

## 顺序性

RabbitMQ中队列中的消息是一定能保证顺序的，但是如果一个队列被多个Consumer消费，那会存在消息处理的顺序性问题

此时可以为消息做一次hash后分配到不同的队列中(保证依赖顺序的消息一定在同一个队列中)，然后每个队列只有一个消费者，从而保证顺序性

## 分布式

1. Cluster集群

多个节点间借助Erlang的消息传输，因此要求集群中所有节点必须有相同的Erlang Cookie

多个节点间共享虚拟主机，交换机，队列，用户信息等。队列可能位于某个节点上或被镜像到了多个节点上。连接到任意节点的客户端能看到所有队列，即使这个队列不在该节点上

集群中必须有一个磁盘节点，而可以有任意多个内存节点

但所有节点必须在同一个局域网内

2. Federation集群

从上流流向下游，上游不需要配置federation插件，只有下游需要配置

下游可以从一个上游拉取数据，也可以从多个上游拉取数据

对于上游来说下游就是一个Consumer，可以故意将上游设置为不消费，所有消息分发到下游

节点可以分布在不同网络中

3. Shovel


