# Xcode

## Xcode 警告

- 开启可信度较高的警告

Build Setting -> other c flags -> `-Wall`

- 开启大部分警告

Build Setting -> other c flags -> `-Wextra`

- 屏蔽第三方SDK`was built for newer iOS version`警告

Target -> Build Setting -> Other Linker Flag -> `-w`

## 环境变量

Edit Scheme -> Arguments -> Environment Variables

## 解决project.pbxproj合并冲突

- [使用xUnique解决xcproject文件冲突](http://www.swiftcafe.io/2016/10/12/xunique/)

1. 安装pip: [pip官方文档](https://pip.pypa.io/en/stable/installing/)

2. 安装xUnique：
 ```
 // 一定要加sudo
sudo pip install xUnique
 ```
3. 去掉`.git/hook/pre-commit.sample`的后缀名`.sample`

4. 将如下内容添加到`pre-commit`:
```
xunique path/project.xcodeproj

// 如果用了cocopods，还需要加入Pods.xcodeproj
xunique path/Pods.xcodeproj
```
完成以上操作后，每次commit之前都会通过xUnique将`.xcproject`文件重新编码，避免合并时的冲突。
