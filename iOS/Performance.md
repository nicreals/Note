# Performance Optimize

* [iOS性能优化](http://www.samirchen.com/ios-performance-optimization/)
* [iOS 保持界面流畅的技巧](http://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/)

## TableView相关优化

### 后台线程销毁对象

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

当给`model`赋值nil时，由于`model`所指向内存中的实际对象被`temp`强引用，所以该对象不会被销毁，`[temp class]`在后台线程调用，`temp`作为临时变量block执行结束后便被销毁，所指向的对象会在后台线程销毁，于是便达到了使`model`所指对象在后台线程销毁的目的。

### 滑动优化

* [禁用不现实cell的异步任务](http://m.blog.csdn.net/article/details?id=49926759)

* [预判滑动位置，按需加载内容](http://longxdragon.github.io/2015/05/26/UITableView%E4%BC%98%E5%8C%96%E6%8A%80%E5%B7%A7/)
