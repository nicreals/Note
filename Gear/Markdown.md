# Markdown

> [Markdown完整语法手册](http://blog.leanote.com/post/freewalk/Markdown-%E8%AF%AD%E6%B3%95%E6%89%8B%E5%86%8C)
> [Markdown 公式指导手册](https://www.zybuluo.com/codeep/note/163962)

## 常用标记

| 效果 | 标记 | 示例 | 备注 |
|:--------:|:--------:|:--------:| :--------:|
| 斜体 | `*`或`_` | *斜体* | `*`与文字之间不能有空格 |
| 粗体 | `**`或`__` | **粗体** | `**`与文字之间不能有空格 |
| 无序列表 | `.`或`*`或`+` | - 无序列表 | `.`前面添加有序数字变为有序列表 |
| 转义 | `\` | \# 一级标题 | - |


## 表格

- 原生表格:

|学号|姓名|分数|
|-|-|-|
|小明|男|75|
|小红|女|79|
|小陆|男|92|

- 对齐：

在表头下方的分隔线标记中加入`:`，即可指定表格的对齐方式：

- `:---` 代表左对齐
- `:--:` 代表居中对齐
- `---:` 代表右对齐

## 代码块

在第一个代码块标记右边设置代码语言可以开启代码高亮功能；

例如Objective-C的代码标记为:

\```objectivec
\```

```objectivec
NSArray *array = @[@"a",@"b",@"c"];
NSLog@("%@",array.allValues);
```

## 解释
第一行写定义，另起一行天际`:`标记，后面添加一个缩进(tab)写解释内容

- 代码：

```
Markdown
:   一种标记语言
```
- 效果：

Markdown
:   一种标记语言

## 嵌套HTML代码

Markdown支持直接嵌套HTML语法，可以设置一些额外排版效果：

 展示效果 | <center>代码<center>
:----------- |:-----------
<center> 居中 </center> | `<center> 居中 </center>`
 <p align="right">靠右</p> | `<p align="right">靠右</p>`
 靠左 | <center> 靠左 </center>

## 数学公式

一个简单的示例：`$$\frac{\sqrt{X^2 + Y^2}}{Z}$$`

$$\frac{\sqrt{X^2 + Y^2}}{Z}$$

详细语法：[Markdown 公式指导手册](https://www.zybuluo.com/codeep/note/163962)
