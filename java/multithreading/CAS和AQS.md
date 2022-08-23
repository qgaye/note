# CAS和AQS

## CAS

CAS全称CompareAndSwap，是一条 CPU 并发原语，意思就是比较然后替换，并且这个过程是原子的。在整个过程中有三个值，内存值，预期值，要修改的值，首先比较预期值和内存值是否相同，如果相同就表示没有别的线程来修改过值，那么就能放心更新，而如果不同，那就表示有其他线程来修改过了，就放弃更新操作，最后都统一返回更新前的内存值

CAS应用场景：
- 乐观锁
- 并发容器
- 原子类

在Java中使用Unsafe工具(JVM中提供硬件级别的原子操作)来直接获取到要修改的变量的内存地址，通过Atomic::cmpxchg方法实现不同平台上的原子比较和替换操作

CAS的缺点：
- ABA问题：虽然在比较时内存值和预期值相同，但其实内存值可能经历过了修改，只是最后又修改回了原先的值，因此过程中不能准确判断是否一定没有别的线程进行过操作(类似数据库中的幻读)
- 自旋时间过长：如果CAS失败，会一直尝试，如果CAS长时间不成功，会给CPU带来很大的开销
- CAS只能用来保证单个共享变量的原子操作，对于多个共享变量操作，CAS无法保证，需要使用锁

## AQS

AQS是AbstractQueuedSynchronizer这个抽象类的缩写，其本身一系列对线程是否阻塞是否唤醒的方法，另外还有一些待重写的可以自定义实现的方法

(因为AbstractQueuedSynchronizer中分为共享模式和独占模式，因此其不知道使用者要实现的是哪种模式，无法都设置为abstract方法)

ReentrantLock、CountDownLatch、Semaphore、ThreadPoolExecutor等都是用到了AQS，在它们中都有一个Sync的类实现了AbstractQueuedSynchronizer抽象类，又在Sync中重写了对应的方法来满足不同的需求

AQS三大核心：
1. state：不同的类中state代表的含义不同，ReentrantLock中代表重入数，CountDownLatch中代表倒数数，Semaphore中代表信号量
2. 控制线程抢锁和配合的FIFO队列：AQS维护的等待中的线程队列，并在合适的时机唤醒它们，这个队列中每个Node就是个Thread
3. 需要自定义实现的获取/释放(acquire/release)方法：AQS中调用了自定义实现的方法来达到不同的效果

AQS和CAS不是独立的两个实现，在AQS中的赋值操作也用到了CAS来保证并发安全
