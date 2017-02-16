# Animation

> [position,anchorPoint区别](http://kittenyang.com/anchorpoint/)

## Position & anchorPoint

- `anchorPoint`描述layer旋转变换的支点，就像一张纸上被订上一颗图钉，这张纸的旋转变换都会围绕这个点，并且`anchorPoint`的坐标表示是相对的，iOS坐标系里中心点、左下角和右上角的anchorPoint为(0.5,0.5), (0,1), (1,0)；

- `position`表示`anchorPoint`在superLayer中的位置

*iOS中坐标远点为左上角，而Mac OS中的坐标远点在左下角*

## CALayer

### content属性

[关于contents属性的详细介绍](http://wiki.jikexueyuan.com/project/ios-core-animation/boarding-figure.html)

```
// Objective-C
layer.contents = (__bridge id)image.CGImage;

// Swift
layer.contents = image?.CGImage
```
