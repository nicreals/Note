#MultiThread

> [OS X 和 iOS 中的多线程技术](http://www.infoq.com/cn/articles/os-x-ios-multithread-technology)
>
> [iOS多线程编程——GCD与NSOperation总结](https://bestswifter.com/multithreadconclusion/)
>
> [选择 GCD 还是 NSTimer ？](http://www.jianshu.com/p/0c050af6c5ee)
>
> [iOS 程序员 6 级考试](http://blog.sunnyxx.com/2014/03/06/ios_exam_0_key/)
>
> [iOS-多线程详解](http://www.jianshu.com/p/f28a50f72bb1)

## Before Everything

### 同步与异步，串行与并行

|      | 同步执行        | 异步执行        |
| ---- | ----------- | ----------- |
| 串行队列 | 当前线程，一个一个执行 | 其他线程，一个一个执行 |
| 并行队列 | 当前线程，一个一个执行 | 多个线程，一起执行   |

### NSThread,NSOperation,GCD比较

| 方式          | 优点         | 缺点                         |
| ----------- | ---------- | -------------------------- |
| NSThread    | 轻量级，相对简单   | 手动管理所有的线程活动，如生命周期、线程同步、睡眠等 |
| NSOperation | 自带线程周期管理   | 面向对象，实际使用中代码逻辑很容易被分割       |
| GCD         | 最高效，避开并发陷阱 | 基于C实现，可复用性弱                |

### 线程安全

线程安全的代码能在多线程或并发任务中被安全的调用，而不会导致任何问题（数据损坏，崩溃，等）。线程不安全的代码在某个时刻只能在一个上下文中运行。一个线程安全代码的例子是 `NSDictionary` 。你可以在同一时间在多个线程中使用它而不会有问题。另一方面，`NSMutableDictionary` 就不是线程安全的，应该保证一次只能有一个线程访问它。

## NSThread

NSThread 是 OS X 和 iOS 都提供的一个线程对象，它是线程的一个轻量级实现。在执行一些轻量级的简单任务时，NSThread 很有用，但用户仍然需要自己管理线程生命周期，进行线程间同步。比如，线程状态，依赖性，线程间同步等线程相关的主题 NSThread 都没有涉及。比如，涉及到线程间同步仍然需要配合使用 NSLock，NSCondition 或者 @synchronized。所以，遇到复杂任务时，轻量级的 NSThread 可能并不合适。

1. 动态实例化

```
NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImageSource:) object:imgUrl];
thread.threadPriority = 1;// 设置线程的优先级(0.0 - 1.0，1.0最高级)
[thread start];
```

2. 静态实例化

```
[NSThread detachNewThreadSelector:@selector(loadImageSource:) toTarget:self withObject:imgUrl];
```

3. 隐式实例化

```
[self performSelectorInBackground:@selector(loadImageSource:) withObject:imgUrl];
```

4. 获取当前线程    

```
NSThread *current = [NSThread currentThread];
```

5. 获取主线程  

```
NSThread *main = [NSThread mainThread];
```

6. 暂停当前线程  

```
[NSThread sleepForTimeInterval:2];
```

7. 线程之间通信  

```
//在指定线程上执行操作
[self performSelector:@selector(run) onThread:thread withObject:nil waitUntilDone:YES]; 
//在主线程上执行操作
[self performSelectorOnMainThread:@selector(run) withObject:nil waitUntilDone:YES]; 
//在当前线程执行操作
[self performSelector:@selector(run) withObject:nil];
```

## NSOperation

```
NSInvocationOperation *geroge = [[NSInvocationOperation alloc]initWithTarget:self  
 selector:@selector(run)  object:@"asshole"];
geroge.queuePriority = NSOperationQueuePriorityHigh;

NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [self run];
    }];


NSOperationQueue *queue = [[NSOperationQueue alloc] init];
[queue setMaxConcurrentOperationCount:2];
[queue addOperation:geroge];
[queue addOperation:totty];
```

NSOperation 提供以下任务优先级，以这些优先级设置变量 queuePriority 即可加快或者推迟操作的执行：

- NSOperationQueuePriorityVeryHigh
- NSOperationQueuePriorityHigh
- NSOperationQueuePriorityNormal
- NSOperationQueuePriorityLow
- NSOperationQueuePriorityVeryLow

NSOperation 使用状态机模型来表示状态。通常，你可以使用 KVO（Key-Value Observing）观察任务的执行状态。这是其他多线程工具所不具备的功能。NSOperation 提供以下状态：

- isReady
- isExecuting
- isFinished

NSOperation 对象之间的依赖性可以用如下代码表示：

```
[refreshUIOperation addDependency:requestDataOperation];
[operationQueue addOperation:requestDataOperation];
[operationQueue addOperation:refreshUIOperation];
```

除非 requestDataOperation 的状态 isFinished 返回 YES，不然 refreshUIOperation 这个操作不会开始。

NSOperation 还有一个非常有用功能，就是“取消”。这是其他多线程工具（包括后面要讲到的 GCD）都没有的。调用 NSOperation 的 cancel: 方法即可取消该任务。当你知道这个任务没有必要再执行下去时，尽早安全地取消它将有利于节省系统资源。

## GCD

### dispatch_queue_create

#### 串行队列

```
dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
```

`DISPATCH_QUEUE_SERIAL`或者`NULL`都表示该队列是串行队列。

可通过`dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)`获取当前队列label。

#### 并行队列

```
dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
```

### Main Dispatch Queue

主队列，用于刷新UI操作。

```
dispatch_queue_t mainQueue = dispatch_get_main_queue(); // 获取主队列
```

### Global Dispatch Queue

此队列就是整个系统都可以使用的**全局并行队列**，由于所有的应用程序都可以使用该并行队列，没必要自已创建并行队列，只需要获取该队列即可。

该队列有4个执行优先级，分别是高(High)、默认（Default）、低（Low）、后台(Background)。我们可以根据自已的需要把不同的任务追加到各个等级的队列当中。

```
/**
 *  获取高优先级队列
 */
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
/**
 *  获取默认优先级队列
 */
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
/**
 *  获取低优先级队列
 */
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
/**
 *  获取后台优先级队列
 */
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
```

### dispatch_set_target_queue

dispatch_set_target的作用是设置一个队列的优先级，我们手动创建的队列，无论是串行队列还是并发队列，都跟默认优先级的全局并发队列具有相同的优先级。如果我们需要改变队列优先级，则可以使用dispatch_set_tartget方法。

```
dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("MySerialDispatchQueue", NULL);
dispatch_queue_t globalDispatchQueueBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
dispatch_set_target_queue(mySerialDispatchQueue, globalDispatchQueueBackground);
```

上面的代码，`dispatch_set_target`方法的第一个参数是要设置优先级的队列，第二队参数是则是参考的的队列，使第一个参数与第二个参数具有相同的优先级。

### dispatch_after

**在x秒后把任务追加到队列中，并不是在x秒后执行**。

```
dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC);
dispatch_after(time, dispatch_get_main_queue(), ^{
    NSLog(@"waited at least three seconds.");
});
```

### dispatch_group

#### dispatch_group_notify

向group添加任务队列，当所有的任务都完成后，异步通知任务执行结束。

```
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);  //获取全局并发队列

dispatch_group_t group = dispatch_group_create(); //创建dispatch_group
dispatch_group_async(group, queue, ^{ NSLog(@"block 1"));}); //把任务追加到队列中
dispatch_group_async(group, queue, ^{NSLog(@"block 2");});
dispatch_group_async(group, queue, ^{ NSLog(@"block 3");});
dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    NSLog(@"结束");
});
NSLog(@"不阻塞");
```

上面的代码，执行结果为:

```
不阻塞
block 3
block 2
block 1
结束
```

很明显，这种方式是不阻塞的。由于我们是异步把任务添加到队列中，所以任务执行的顺序是不一定的。但是dispatch_group_notify里面的block肯定是最后执行。

#### dispatch_group_wait

向group追加任务队列，如果所有的任务都执行或者超时，返回一个long类型的值。

```
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);  //获取全局并发队列
dispatch_group_t group = dispatch_group_create(); //创建dispatch_group
dispatch_group_async(group, queue, ^{ NSLog(@"block 1"));}); //把任务追加到队列中
dispatch_group_async(group, queue, ^{NSLog(@"block 2");});
dispatch_group_async(group, queue, ^{ 
       [NSThread sleepForTimeInterval:5];
    NSLog(@"block 3");
});    

long result = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
if (result == 0) {
    NSLog(@"结束");
}
NSLog(@"阻塞");
```

执行结果是

```
block 1
block 2    
block 3
结束
阻塞
```

`dispatch_group_wait`第一个参数为需要等待的目标调度组，第二个参数则是等待的时间（超时），`DISPATCH_TIME_FOREVER`，表示永远等待。

`dispatch_group_wait`函数返回值为0，表示里面的所有任务都已经执行（若不为0则表示等待超时）。如果把等待时间改为4秒（dispatch_time(DISPATCH_TIME_NOW, 4ull * NSEC_PER_SEC)），那么因为最后添的那个block，至少需要5秒的时候，才可以执行完毕。那么result返回值则不为0。执行结果为

```
block 1
block 2    
阻塞
block 3
```

#### dispatch_barrier_async

`dispatch_barrier_async`就如同它的名字一样，在队列执行的任务中增加“栅栏”，在增加“栅栏”之前已经开始执行的block将会继续执行，当dispatch_barrier_async开始执行的时候其他的block处于等待状态，dispatch_barrier_async的任务执行完后，其后的block才会执行。

### dispatch_apply

如果你需要重复执行同一个任务，`dispatch_apply`是你最好的选择。

```
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
NSArray *array = @[@"one",@"two",@"three"];
dispatch_apply(3, queue, ^(size_t index) {
    [NSThread sleepForTimeInterval:index];
    NSLog(@"%@",array[index]);
});
NSLog(@"阻塞");
```

上面的代码执行结果是

```
2015-09-08 22:01:12.354 Thread Learn[40330:1678876] one
2015-09-08 22:01:12.354 Thread Learn[40330:1678948] two
2015-09-08 22:01:12.355 Thread Learn[40330:1678965] three
2015-09-08 22:01:14.357 Thread Learn[40330:1678876] 阻塞
```

可见`dispatch_apply`是以同步的方式把任务追加到队列当中，所以一般会在`dispatch_async`函数中异步执行该函数

```
//异步执行
dispatch_async(queue, ^{
    dispatch_apply(3, queue, ^(size_t index) {
        //Do somthing
    });
});
```

### dispatch_suspend & dispatch_resume

`dispatch_suspend`挂起指定的队列

```
dispatch_supend(queue);
```

`dispatch_resume`恢复指定队列

```
dispatch_resume(queue);
```

线程挂起对已执行的任务没有影响，挂起后，还未执行的任务停止执行，待恢复后，这些任务继续执行

### dispatch_once

可能大家使用dispatch_one生成单例，而很多人都会这样子写

```
+(MAMapView *)shareMAMapView{
    static MAMapView *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
            instance = [[MAMapView alloc]init];
    });
    return instance;
}
```

但这样写会有问题的，要复写`alloWithZone:`方法

```
static MAMapView *instance = nil;
//重写allocWithZone保证分配内存alloc相同
+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+(MAMapView *)shareMAMapView{
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        instance = [[MAMapView alloc]init];
    });
    return instance;
}
//保证copy相同
-(id)copyWithZone:(NSZone *)zone{
    return instance;
}
```

### Dispatch Semaphore

在GCD中有三个函数是semaphore的操作，分别是：

| Method                    | Bref                     |
| :------------------------ | ------------------------ |
| dispatch_semaphore_create | 创建一个semaphore            |
| dispatch_semaphore_signal | 发送一个信号，信号量加1             |
| dispatch_semaphore_wait   | 等待信号，<0时一直等待,否则正常执行，并且-1 |

可以通过信号量来创建一个并发控制来同步任务和有限资源访问控制。

```
dispatch_group_t group = dispatch_group_create();   
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);   
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);   
    for (int i = 0; i < 100; i++)   
    {   
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);   
        dispatch_group_async(group, queue, ^{   
            NSLog(@"%i",i);   
            sleep(2);   
            dispatch_semaphore_signal(semaphore);   
        });   
    }   
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);   
```

运行结果：每2秒执行10此。

### GCD Timer

使用NSTimer，RunLoop实现timer有如下弊端：

1. 必须保证有一个活跃的RunLoop，若将逻辑放在子线程执行，子线程RunLoop默认关闭，必须手动激活才能是`performSelecto`r和`scheduledTimerWithTimeInterva`l的调用生效；
2. NSTimer的创建，撤销必须在同一线程操作，performSelector的创建与撤销必须在同一个线程操作；
3. 容易出现内存泄露，当一个timer被schedule的时候，timer会持有target对象，NSRunLoop对象会持有timer，除了调用invalidate以外没有任何方法可以让NSRunLoop对象会释放对timer的持有，timer会释放对target的持有。

一个简单的GCD Timer实现：

```
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"cancel");
        dispatch_release(timer);
    });
    //启动timer
    dispatch_resume(timer);
    // 取消timer
    dispatch_source_cancel(timer);
```

