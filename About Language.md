# Objective- C

## Foundation

### ARC

* 只要一个对象被任意strong指针指向，那么他将不会被摧毁，如果对象没有strong指针指向，那没就会被摧毁；
* 若一个对象没有指向它的strong指针，所有指向该对象的weak指针将被置为nil，避免EXC_BAD_ACCESS;

### weakSelf && strongSelf

```
[UIView animateWithDuration:0.2 animations:^{
    self.myView.alpha = 1.0;
}];
```
block执行期间self 不会被摧毁，不需要使用weakSelf，strongSelf；

```
__weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [weakSelf doSomething];
    [weakSelf doOtherThing];
});
```
block执行结束期间self是否被销毁为知，使用weakSelf可避免self，block循环引用，造成内存泄露，使用strongSelf可保证在block内部，self不会为nil；

### isKindOfClass && isMemberOfClass

* isMemberOfClass 判断是否是某个类的成员;
* isKindOfClass 判断是否是某个类或其子类的成员;

## API Reference

### Navigation Bar

#### 修改UIStatusBarStyle

IOS 7 OR LATER

* info.plist 设置`UIViewControllerBasedStatusBarAppearance`为YES；

* 在UIViewController中重写`preferredStatusBarStyle`,并在需要改变`UIStatusBarStyle`时调用`[self setNeedsStatusBarAppearanceUpdate];`

* 在UINavigationController重写`preferredStatusBarStyle`方法，返回topViewController的UIStatusBarStyle。

    ```
    - (UIStatusBarStyle)preferredStatusBarStyle {
        UIViewController *viewController = self.topViewController;
        return [viewController preferredStatusBarStyle];
    }
    ```

BEFORE IOS7

* info.plist 设置`UIViewControllerBasedStatusBarAppearance`为NO；

* 直接调用`[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault`修改statusBarStyle。

#### UINavigationBar属性

* `edgesForExtendedLayout`设置ViewController延伸的枚举，默认`UIRectEdgeAll`，ViewController视图会延伸到`UINavigationBar`和`UITabBar`，`UIRectEdgeNone`则不会延伸。

* `automaticallyAdjustsScrollViewInsets`默认YES,视图初始状态从`UINavigationBar`下面开始，从`UITabBar`顶部结束，当`edgesForExtendedLayout`属性设置为`UIRectEdgeAll`时，视图可以穿透`UINavigationBar`和`UITabBar`，作用相当于自动设置了contentInsets。

* `extendedLayoutIncludesOpaqueBars`属性是对`edgesForExtendedLayout`的补充，当** NavigationBar、TabBar、TooBar 不透明** 时 ，设置为YES，视图任将扩展到不透明区域，设置为NO，则不会扩展到不透明区域。

* `modalPresentationCapturesStatusBarAppearance`控制在present一个viewController时，是否由被present的viewController控制statusBarStyle，默认为NO。

#### 自定义UINavigationBar样式

* 设置阴影线条image

    ```
  // 隐藏阴影黑线
  [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
  // 显示阴影黑线
  [self.navigationController.navigationBar setShadowImage:nil];
    ```

* 设置背景图片

    ```
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    ```


## Tips

### 宏与静态常量
