# Masonry

## UIScrollView

对于scrollView，scrollView本身的大小(frame)由scrollView本身对其他view的约束决定，而其内容的大小(content size)由其他View对scrollView的约束决定。

```
[scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.bottom.top.equalTo(weakSelf);
 }];

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

## 优先级

每个约束的默认优先级为priorityHigh(),一个view一个属性有两个约束，会有限对优先级高的那个进行约束；

```
[view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(label);
      make.left.equalTo(label).priorityLow();
}];
```

CompressionResistancePriority为阻止自身内容被挤压的优先级，优先级越低，越容易被挤压；

```
[view setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
```
ContentHuggingPriority为阻止view被拉伸的优先级，优先级越高，越不容易被拉伸；

```
[_nameLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
```

## NSArray Category

使用NSArray的MASAdditions扩展可迅速对array里的view在指定方向上等比约束，使用该方法必须保证array的view数量不少于2个。

```
[array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
```

## Baseline

baseline即基线的意思，对应于Autolayout里面的NSLayoutFormatAlignAllBaseline。
```
make.baseline.equalTo(view);
```
改变一个view的baseline需要重写UIView的viewForBaselineLayout，返回的subView的baseline将作为view的baseline。

## Tips

* 在创建UIScrollView及其子View的实例对象时为其设置frame，避免约束时警告；

* 对于UIImageView的实例，当其left，right(或top，bottom)均对其他View有约束，应该对UIImageView实例的width(height)做约束，避免造成图片拉伸的情况；
