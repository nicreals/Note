# Debug

> [iOS 崩溃Crash解析](http://devma.cn/blog/2016/11/10/ios-beng-kui-crash-jie-xi/)

> [Chisel调试技巧](http://devma.cn/blog/2016/08/05/chisel-lldb-ming-ling-cha-jian-rang-diao-shi-geng-easy/)

## Zombie Object

### 使用

当出现`EXC_BAD_ACCESS`错误时，一般是由于访问了已被释放的对象，通过`Product` -> `Scheme` -> `Edit Scheme` -> `Diagnostics` 勾选`Zombie Object`开快速定位问题。

### 原理

开启`Zombie Object`后，当对象`retainCount`为0即将被释放时，编译器会用一个内置的僵尸对象来替代该对象，对该对象发送消息时会出发异常，同时可以快速定位问题。

**当问题解决后记得关闭`Zombie Object`选项**

## Address sanitizer

当程序创建变量分配一段内存时，将此内存后面的一段内存也冻结住，标识为中毒内存。当程序访问到中毒内存时（越界访问），就会抛出异常，并打印出相应log信息。

## Chisel

[Chisel](https://github.com/facebook/chisel)常用命令:

| 命令 | 效果 |
| - | - |
| pviews | 打印指定view的层级 |
| pvc | 打印viewController的结构 |
| show & hide | 显示/隐藏视图 |
| border/unborder | 给指定view添加边框标记 |
