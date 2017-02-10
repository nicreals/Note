# RunLoop

> [UIScrollView滚动时NSTimer停止问题](http://www.cnblogs.com/6duxz/p/4633741.html)

> [RunLoop简介](https://hit-alibaba.github.io/interview/iOS/ObjC-Basic/Runloop.html)

## 基本概念

一种事件循环，是`Source`和`Observer`的集合，循环监听`Input Source`和`Timer Source`中的消息事件，然后在线程中处理这些事件。

## Runloop 与线程

Runloop 和线程是绑定在一起的。每个线程（包括主线程）都有一个对应的 Runloop 对象。我们并不能自己创建 Runloop 对象，但是可以获取到系统提供的 Runloop 对象。

主线程的 Runloop 会在应用启动的时候完成启动，其他线程的 Runloop 默认并不会启动，需要我们手动启动。

## Input Source 和 Timer Source

这两个都是 Runloop 事件的来源，其中 Input Source 又可以分为三类

- Port-Based Sources，系统底层的 Port 事件，例如 CFSocketRef ，在应用层基本用不到
- Custom Input Sources，用户手动创建的 Source
- Cocoa Perform Selector Sources， Cocoa 提供的 performSelector 系列方法，也是一种事件源

Timer Source 顾名思义就是指定时器事件了。

## Runloop工作特点：

- 当有事件发生时，Runloop会根据具体的事件类型通知应用程序作出响应；

- 当没有事件发生时，Runloop会进入休眠状态，从而达到省电的目的；

- 当事件再次发生时，Runloop会被重新唤醒，处理事件。

## ScrollView滚动时NSTimer停止问题

当UIScrollView滚动时，`MainRunLoop`处于`UITrackingRunLoopMode`模式下，此时不会处理`NSDefaultRunLoopMode`的消息，创建NSTimer时将其加入到`forMode:NSRunLoopCommonModes`即可
