# 项目口嗨

## 怡海数据中心

email发送/数据传输任务使用了消息队列来达到异步的作用(削峰)

难点：

- DbContext的线程不安全问题 报错 -> SaveAsyncChanges -> 同一个线程中两次调用 -> DbContext需要Transient -> 发现middleware里所有bll是相同的 -> middleware中注入方式不对，middleware本身是Singleton -> 修复 -> 直接用了消息队列来处理日志信息
- Code First 在EF Core上抽象了一层，直接完成了RESTful风格的基础Controller + Service

消息队列：

email/传输任务 使用消息队列来达到异步的作用
日志 使用消息队列异步，提高响应速度(原先在方法上就写了TODO用异步)

- 生产者的确认
- 发送方的确认
- 重复传递和幂等

数据库：

主从主要用来迁移数据：新的表change master to旧项目的表，且使用基于GTID的模式，这样自动传输数据

基于Position是由备库选择从哪个位置开始备份，而GTID则是由主库决定

难点：

- DbContext的线程安全问题，在高并发(第一次访问页面的时候)会造成SaveAsyncChange
- 项目设计上本来用了T4模版，现在直接用抽象类+接口的方式
- 有趣的bug：单例 = / =>


## 鑫鑫校园

使用消息队列模拟了顺序定时任务(TTL+死信队列，达到在30分钟后自动关闭订单)

数据库读写分离：

通过ThreadLocal设置是从库还是主库，然后通过AOP将所有更新，删除，新增操作设置为主库，其他默认走从库

自定义RoutingDataSource

半同步复制(semi-sync)来解决备库不能及时收到主库的数据

