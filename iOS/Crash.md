# Crash

iOS坑真多

## iOS9 自定义键盘BAD_ACCESS问题

> https://forums.developer.apple.com/thread/30796

** 现象: **

iOS9上如果使用了自定义view设置为inputView,在页面销毁时调用`resignFirstResponder`,有可能造成BAD_ACCESS.

** 解决办法: **

在调用`resignFirstResponder`之前需要进行如下操作:

```objectivec
    [self.textField.inputView removeFromSuperview];
    [self.textField.inputAccessoryView removeFromSuperview];
    self.textField.inputView = nil;
    self.textField.inputAccessoryView = nil;
```

## UIScrollView在销毁时BAD_ACCESS问题

** 现象: **

界面销毁时scrollView任然在回调,但是delegate已被销毁;

** 解决办法: **

在delloc是将delegate和DataSource置空:

```objectivec
_scrollView.delegate = nil;

```
