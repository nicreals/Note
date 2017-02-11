# Memory Management

> [内存管理基本概念](https://hit-alibaba.github.io/interview/basic/arch/Memory-Management.html)

> [iOS内存管理面试](https://hit-alibaba.github.io/interview/iOS/ObjC-Basic/MM.html)

> [深入理解循环引用，weakSelf，strongSelf](http://ios.jobbole.com/88708/)

## ARC & MRC

### MRC

MRC对象操作及`retainCount`变化：

对象操作 | OC中对应的方法 | retainCount 变化
:----------- | :------------- | : -------------:
生成并持有对象 | alloc/new/copy/mutableCopy等 |	+1
持有对象 |	retain |	+1
释放对象 |	release	| -1
废弃对象 |	dealloc |	-

四个对象操作法则:

- 自己生成的对象，自己持有。
- 非自己生成的对象，自己也能持有。
- 不在需要自己持有对象的时候，释放。
- 非自己持有的对象无需释放。

MRC下`autorelease`使得对象在超出生命周期后能正确的被释放(通过调用release方法)。在调用 `release` 后，对象会被立即释放，而调用 `autorelease` 后，对象不会被立即释放，而是注册到 `autoreleasepool` 中，经过一段时间后 pool结束，此时调用`release`方法，对象被释放。

### ARC

ARC是一种自动内存管理机制，会根据引用计数自动监视对象的生存周期，通过在代码编译器自动插入内存管理代码以及一些`Runtime`优化实现自动引用计数。

## 属性标识

- `assign`表示调用getter时只是一个简单的赋值，一般用于基本数据类型；
- `strong`表示属性定义了一个拥有关系，当调用setter赋值时，会将新值retain一次，旧值release，然后进行赋值；
- `weak`表示属性定义了一个非拥有关系，类似与`assign`的简单赋值，但是当属性所指向的对象被销毁时，该属性会被置为nil；
- `copy`与`strong`类似，不过在赋值时会进行`copy`操作而非`retain`,通常在需要保留某个不可变对象（NSString最常见），并且防止它被意外改变时使用;
- `unsafe_unretain`和`assign`类似表明非拥有关系，当所指向对象销毁时不会置为nil。

## 循环引用

### 一个循环引用的栗子
```
typedef void(^Study)();
@interface Student : NSObject
@property (copy , nonatomic) NSString *name;
@property (copy , nonatomic) Study study;
@end
```
```
#import "ViewController.h"
#import "Student.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Student *student = [[Student alloc]init];
    student.name = @"Hello World";

    student.study = ^{
        NSLog(@"my name is = %@",student.name);
    };
}
```

其中`student`拥有`study`这个block，而`study`有拥有`student`,形成了循环引用。

### weakSelf避免循环引用

```
    __weak typeof(student) weakSelf = student;
    student.study = ^{
        NSLog(@"my name is = %@",weakSelf.name);
    };
```
`__weak`定义了一种非拥有关系，当`weakSelf`指向的对象`student`销毁时，`weakSelf`会被置为nil，不会造成循环引用；

### strongSelf避免提前释放

```
#import "ViewController.h"
#import "Student.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Student *student = [[Student alloc]init];

    student.name = @"Hello World";
    __weak typeof(student) weakSelf = student;

    student.study = ^{
        __strong typeof(student) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"my name is = %@",strongSelf.name);
        });

    };

    student.study();
}
```
此时由于`dispatch_after`2秒的异步延迟，`student.study()`会先于NSLog调用，`student.study()`执行完后，`student`会被销毁，由于`weakSelf`实用`__weak`定义了非拥有关系，`weakSelf`会被置为nil，所以输出为：
```
my name is = (null)
```
使用`__strong`可以避免在block生命周期内，`strongSelf`被置为nil：
```
__weak typeof(student) weakSelf = student;
   student.study = ^{
       __strong typeof(student) strongSelf = weakSelf;
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           NSLog(@"my name is = %@",strongSelf.name);
       });

   };
```
当`student.study()`执行，由于`__strong`定义了拥有关系，`strongSelf`指向`student`对象的内存地址，并且保留了对`student`的引用，此时`strongSelf`不会被销毁，当block调用完，`strongSelf`作为临时变量被销毁，没有指针指向`student`对象，`student`也被销毁，所以也不会造成循环引用。
