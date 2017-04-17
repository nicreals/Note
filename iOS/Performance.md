# Performance Optimize

* [iOS性能优化](http://www.samirchen.com/ios-performance-optimization/)
* [iOS 保持界面流畅的技巧](http://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/)

## 对象的创建和销毁

### 利用`Autorelease Pool`创建临时对象

当要创建大量临时对象时，可以显示创建`Autorelease Pool`即时销毁对象，而不用等待系统自带的`Autorelease Pool`执行时销毁;

```objectivec
@autoreleasepool {
  for (int i = 0;i < 10000; i ++) {
    TestObject *test = [[TestObject alloc] init];
    [test doSomething];
  }
}
```

### 异步销毁对象

当数据源非常大的时候，销毁对象累计起来也非常耗费资源,可以异步销毁对象：

```objectivec
TestModel *model = [[TestModel alloc] init];
model.title = @"ass";
model.name = @"hole";
TestModel *temp = model;
model = nil;
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [temp class];
});
```

当给`model`赋值nil时，由于`model`所指向内存中的实际对象被`temp`强引用，所以该对象不会被销毁，`[temp class]`在后台线程调用，`temp`作为临时变量block执行结束后便被销毁，所指向的对象会在后台线程销毁，于是便达到了使`model`所指对象在后台线程销毁的目的,同时可以避免编译器警告。

## 图像的加载与绘制

### 加载图片

`[UIImage imageNamed:]`和`[UIImage imageWithContentsOfFile:]`两种加载图片方式的不同在于后者只会简单的加载文件而不会对图片进行缓存，所以在`UITableView`中大量使用`[UIImage imageNamed:]`对内存的消耗是非常感人的，除非是对于重复使用的图片使用`[UIImage imageNamed:]`，可以减少文件IO操作；

但是`[UIImage imageWithContentsOfFile:]`有一个缺点是不能自动选择加载`@2x`/`@3x`的图片，所以可以定义如下宏定义来解决:

```objectivec
#define UPUncachedPNGImage(imageName)
tableViewCell.imageView.image = UPUncachedPNGImage(@"image");
```

### 绘制图片

由于`CoreGraphic`是线程安全的，所以可以异步手动绘制,可以同时减少CPU和GPU的消耗，常用语`UITableViewCell`中图片的绘制:

```objectivec
- (void)displayImage {
    dispatch_async(backgroundQueue, ^{
        CGContextRef ctx = CGBitmapContextCreate(...);
        // draw in context...
        CGImageRef img = CGBitmapContextCreateImage(ctx);
        CFRelease(ctx);
        dispatch_async(mainQueue, ^{
            layer.contents = img;
        });
    });
}
```

同理利用`CoreText`异步绘制文字。

## 离屏渲染

## TableView相关优化

### 基础优化

* 最大程度利用重用机制(差异性属性放在初始化之外，并且条件判断尽量覆盖所有情况,复用view和某些开销大的对象);
* cell使用轻量级对像，`CALayer`的创建比`UIView`节省CPU资源，避免使用Xib创建cell;
* 当view不透明时，尽量将`opaque`设置为`YES`,可以减少GPU混合绘制消耗;
* **性能敏感** 的tableView使用手动计算cell高度，避免使用`AutoLayout`;

### `UITableView`在快速滑动时的异步线程处理

通常在加载`UITableViewCell`内容时会发送异步请求数据，然后回到UI线程加载内容，如果`UITableView`在快速滑动时创建大量异步请求(如加载网络图片)，当异步任务完成时大量`UITableViewCell`其实已经不在显示区域内而被销毁了，所以这些异步请求是没有意义的，虽然是异步请求，但过多的异步线程同样也会造成卡顿；
可做如下优化：
```objectivec
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
          [self asyncRequest]; // 当tableView滑动停止时，就当cell 在可是区域内才发送异步请求
        }
}

```
