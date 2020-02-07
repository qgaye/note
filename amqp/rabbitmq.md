# RabbitMQ笔记

## 安装

[RabbitMQ官网](https://www.rabbitmq.com/)

MacOS可以通过`brew install rabbitmq`安装

Docker中使用`rabbitmq:3-management`镜像，自带web管理界面

- RabbitMQ默认端口：`5672`
- RbbitMQ默认Web界面端口：`15672`

## 四种

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