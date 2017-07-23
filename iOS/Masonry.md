# Masonry

> [Masonry快速入门](http://adad184.com/2014/09/28/use-masonry-to-quick-solve-autolayout/)

## 基础

- view只有拥有`superView`之后才能使用`Masonry`设置约束;
- `mas_equalTo`和`equalTo`的区别在于`mas_equalTo`是个宏，`equalTo`在对`height`,`width`做约束时只能使用`NSNumber`类型;
- `mas_updateConstraints`会在原有约束上添加约束，而`mas_remakeConstraints`是完全重新设置约束；

## UIScrollView

对于scrollView，scrollView本身的大小(frame)由scrollView本身对其他view的约束决定，而其内容的大小(contentSize)由其他View对scrollView的约束决定。

```objectivec
// scrollView本身的大小约束
[scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.bottom.top.equalTo(weakSelf);
 }];

// scrollView内容大小约束
[view1 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(scrollView);
}];

[view1 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(scrollView);
}];

[view1 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(scrollView);
}];

[view1 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(scrollView);
}];
```

如果scrollView的大小使用frame设置，而contentSize由masonry设置，那么scrollView的实际大小可能会与设置的frame大小不一致；

## 更新单个约束

虽然利用`mas_updateConstraints`可以更新约束，但在实际使用中该方法会经常抽风，可以利用一个变量记录某个约束，然后更改该变量即可更新约束:

```objectivec
MASConstraint *_labelLeftContraint;

[label mas_makeConstraints:^(MASConstraintMaker *make) {
   _labelLeftContraint = make.left(self);
    make.bottom.equalTo(self).offset(-10);
    make.height.equalTo(@(150));
}];

_labelLeftContraint.offset = 15.f; // 更改约束
[_labelLeftContraint unInstall];   // 删除约束
```

## 优先级

每个约束的默认优先级为priorityHigh(),一个view一个属性有两个约束，会优先对优先级高的那个进行约束；

```objectivec
[view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(label).offset(-2);
      make.left.equalTo(anotherLabel).priorityLow();
}];
```

CompressionResistancePriority为阻止自身内容被挤压的优先级，优先级越低，越容易被挤压；

```objectivec
[view setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
```
ContentHuggingPriority为阻止view被拉伸的优先级，优先级越高，越不容易被拉伸；

```objectivec
[_nameLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
```

## NSArray Category

使用NSArray的MASAdditions扩展可迅速对array里的view在指定方向上等比约束，使用该方法必须保证array的view数量不少于2个。

```objectivec
[array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
```

## Baseline

baseline即基线的意思，对应于Autolayout里面的NSLayoutFormatAlignAllBaseline,默认情况下是view的center。
```
make.baseline.equalTo(view);
```
改变一个view的baseline需要重写UIView的viewForBaselineLayout，返回的subView的baseline将作为view的baseline。

## Tips

* 在创建UIScrollView及其子View的实例对象时为其设置frame，避免约束时警告；

* 对于UIImageView的实例，当其left，right(或top，bottom)均对其他View有约束，应该对UIImageView实例的width(height)做约束，避免造成图片拉伸的情况；
