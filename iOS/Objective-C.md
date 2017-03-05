# Objective-C

> [NSString特性分析学习](https://blog.cnbluebox.com/blog/2014/04/16/nsstringte-xing-fen-xi-xue-xi/)

> [Runtime系列1--从一个崩溃谈起](http://gold.xitu.io/post/57a9516e7db2a2005aba4809)

> [Runtime系列2--Method Swizzling](http://gold.xitu.io/post/57aae1658ac247005f4da511)

## Foundation

### Runtime

- objc_msgSend

![metaclass](../IMG/runtime_metaclass.png)

- Method Swizzling

当使用`Method Swizzling`时，如下代码中调用`[self swizzed_method]`相当于调用替换之前的`[self method]`

```
- (void)swizzed_method {
  [self swizzed_method];
}
```

Objective-C中集合类簇实际对应的对象类型。

类                   |      对应的类簇
:------------------ | :-------------:
NSArray             |   `__NSArrayI`
NSMutableArray      |   `__NSArrayM`
NSDictionary        | `__NSDictionaryI`
NSMutableDictionary | `__NSDictionaryM`

### Equality

一个`isEqual`的判断示例:

```objectivec
- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[NSArray class]]) {
    return NO;
  }
  return [self isEqualToArray:(NSArray *)object];
}
```

- `isEqual`的判定结果与`hash`无关;

- 对于`NSArray`对象，只要其子项满足`isEqualToString`，`isEqualToDictionary`等值比较，`isEqual`返回YES;同时`NSArray`的`containsObject:(id)object`判断的结果由与object`isEqual`的返回值决定；

- 对于`NSMutableArray`对象，调用`removeObject:(id)object`，一旦子项中的对象与object`isEqual`返回YES，该子项将被移除。

由于`字符串驻留`优化技术， **所有静态定义的不可变字符串对象** ，如果字符串表意相同，那么这些对象都指向同一个驻留字符串值，其类型为`__NSCFConstantString`。

```objectivec
// 静态定义
NSString *a = @"Hello";
NSString *b = @"Hello";
BOOL wtf = (a == b); // YES
// 非静态定义
NSString *c = [NSString stringWithFormat:@"Hello"];
BOOL ass = (a == c); // NO
```

### 泛型

#### 定义

泛型可用于制定容器中对象的类型：

```objectivec
NSArray<NSString *> *strings = @[@"sun", @"yuan"];
NSDictionary<NSString *, NSNumber *> *mapping = @{@"a": @1, @"b": @2};
```

#### 协变性和逆变性（似乎只能在自定义泛型中使用）

不指定类型的容器可以喝任意泛型类型转化，但指定泛型类型之后，两个不同类型之间不能强转，需要通过`__covariant`,`__contravariant`修饰；

- `__covariant` - 协变性，子类型可以强转到父类型（里氏替换原则）eg: `NSArray <NSString *>` 类型的对象赋值给 `NSArray`

- `__contravariant` - 逆变性，父类型可以强转到子类型（WTF?）eg:将一个`NSArray` 的对象赋值给`NSArray<NSNumber > *` 对象

### 类型检查

`__kindof`相对于`id`更加具体的制定了对象的类型：

```objectivec
@property (nonatomic, readonly, copy) NSArray<__kindof UIView *> *subviews;
```

在调用时也不需要强转类型，同时也不会有编译警告：

```objectivec
UIButton *button = [view.subviews lastObject];
```

### isKindOfClass && isMemberOfClass

- isMemberOfClass 判断是否是某个类的成员;

- isKindOfClass 判断是否是某个类或其子类的成员;

## API Reference

### Navigation Bar

#### 修改UIStatusBarStyle

IOS 7 OR LATER

- info.plist 设置`UIViewControllerBasedStatusBarAppearance`为YES；

- 在UIViewController中重写`preferredStatusBarStyle`,并在需要改变`UIStatusBarStyle`时调用`[self setNeedsStatusBarAppearanceUpdate];`

- 在UINavigationController重写`preferredStatusBarStyle`方法，返回topViewController的UIStatusBarStyle。

```objectivec
(UIStatusBarStyle)preferredStatusBarStyle {

  UIViewController *viewController = self.topViewController;

  return [viewController preferredStatusBarStyle];

}
```

- info.plist 设置`UIViewControllerBasedStatusBarAppearance`为NO；

- 直接调用`[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault`修改statusBarStyle。

#### UINavigationBar属性

- `edgesForExtendedLayout`设置ViewController延伸的枚举，默认`UIRectEdgeAll`，ViewController视图会延伸到`UINavigationBar`和`UITabBar`，`UIRectEdgeNone`则不会延伸。

- `automaticallyAdjustsScrollViewInsets`默认YES,视图初始状态从`UINavigationBar`下面开始，从`UITabBar`顶部结束，当`edgesForExtendedLayout`属性设置为`UIRectEdgeAll`时，视图可以穿透`UINavigationBar`和`UITabBar`，作用相当于自动设置了contentInsets。

- `extendedLayoutIncludesOpaqueBars`属性是对`edgesForExtendedLayout`的补充，当 **NavigationBar、TabBar、TooBar 不透明** 时 ，设置为YES，视图任将扩展到不透明区域，设置为NO，则不会扩展到不透明区域。

- `modalPresentationCapturesStatusBarAppearance`控制在present一个viewController时，是否由被present的viewController控制statusBarStyle，默认为NO。

#### 自定义UINavigationBar样式

- 设置阴影线条image

  ```objectivec
  // 隐藏阴影黑线
  [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
  // 显示阴影黑线
  [self.navigationController.navigationBar setShadowImage:nil];
  ```

- 设置背景图片

  ```objectivec
  [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
  ```

## Tips

### 宏与静态常量

#### 定义常量

```objectivec
.h //
extern NSString * const kConstExternFoo;
.m //
NSString * const kConstExternFoo = @"ConstExternFoo";
```

#### static全局变量 & static局部变量

- 局部变量:static修饰的局部变量延长了该变量的生命周期,任然只能局部访问，但当再次调用该局部区域（函数）时，该变量存储的是上次调用该局部区域的值，相当于只能"局部访问"的全局变量；

- 全局变量:static修饰的全局变量限制了该变量只能在该文件中访问。
