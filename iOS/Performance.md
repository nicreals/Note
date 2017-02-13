# Performance Optimize

后台线程销毁对象

```
TestModel *model = [[TestModel alloc] init];
model.title = @"ass";
model.name = @"hole";
TestModel *temp = model;
model = nil;
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [temp class];
});
```

当给`model`赋值nil时，由于`model`所指向内存中的实际对象被`test`强引用，所以该对象不会被销毁，`[temp class]`在后台线程调用，`temp`作为临时变量block执行结束后便被销毁，所指向的对象会在后台线程销毁，于是便达到了使`model`所指对象在后台线程销毁的目的。
