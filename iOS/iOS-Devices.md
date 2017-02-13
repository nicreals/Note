# iOS Devices

> [The Ultimate Guide To iPhone Resolutions](https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions)

## PPI计算

对角线像素数量除以设备尺寸：
$$\frac{\sqrt{X^2 + Y^2}}{Z}$$
(X：长度像素数；Y：宽度像素数；Z：屏幕尺寸)

## 设备尺寸

| 机型 | 缩放 | 逻辑像素点(point) | 分辨率(pixels) | 屏幕尺寸 |
|:--------:| -------- |:--------:| :--------:| :--------:|
| iPhone 2G,3G,3GS | 1x | 320 x 480  |320 x 480  | 3.5
| iPhone4、4s | 2x | 320 x 480  | 640 x 960 | 3.5
| iPhone5、5s | 2x  | 320 x 568 | 640 x 1136 | 4.0
| iPhone6| 2x | 375 x 667 | 750 x 1334 | 4.7
| iPhone6+ | 3x | 414 x 736 | 1242 x 2208 | 5.5

*其中plus设备总计有`1242 x 2208`个像素点，实际设备物理像素点为`1080 x 1920`,图片和字体会被缩小`1.15`(1242/1080)倍，在实际变成中为统一视觉效果效果，可以为plus设备fontSize放大`1.15`倍*

![device_size](../IMG/device_size.png)
