# Xcode

> [Xcode配置编译前脚本](http://liujinlongxa.com/2016/11/27/Xcode%E5%A6%82%E4%BD%95%E8%AE%BE%E7%BD%AE%E5%9C%A8%E7%BC%96%E8%AF%91%E5%89%8D%E8%87%AA%E5%8A%A8%E8%BF%90%E8%A1%8C%E8%84%9A%E6%9C%AC/)

> [脚本动态添加Xcode文件](http://draveness.me/bei-xcodeproj-keng-de-zhe-ji-tian.html)

> [PlistBuddy使用](http://www.jianshu.com/p/2167f755c47e)

## xcode-install

安装多个版本Xcode:
```
gem install xcode-install
xcversion list
xcversion install 7
```

切换Xcode：
```
// 查看当前 Xcode 路径
xcode-select -p

// 切换
sudo xcode-select -s /Applications/Xcode-8.2.1.app/Contents/Developer/
```

## Warning

### 警告等级

- 开启可信度较高的警告

Build Setting -> other c flags -> `-Wall`

- 开启大部分警告

Build Setting -> other c flags -> `-Wextra`

- 屏蔽第三方SDK`was built for newer iOS version`警告

Target -> Build Setting -> Other Linker Flag -> `-w`

### 警告屏蔽

对于编译警告，右键`Reveal in Log`，找到类似`[-Wprotocol]`的警告类型，然后在`Build Setting` -> `Other Warning Flags` 中添加`[-Wno-protocol]`

## 环境变量

`Edit Scheme` -> `Arguments` -> `Environment Variables`
例如添加`DYLD_PRINT_STATISTICS = 1`，app在启动时会在console中打印详细的启动耗时

## XCodeConfig



## pbxproj合并冲突

### mergepbx

1. 安装`mergepbx`

```shell
brew install mergepbx
```

2. 在`~/.gitconfig`文件中配置`mergepbx`

```
[merge "mergepbx"]
        name = XCode project files merger
        driver = mergepbx %O %A %B
```

3. 在工程目录下创建`. gitattributes`文件并设置用mergepbx处理`pbxproj`文件合并

```
*.pbxproj merge=mergepbx
*.pbxproj binary merge=union
```

### xUnique (弃用)

[使用xUnique解决xcproject文件冲突](http://www.swiftcafe.io/2016/10/12/xunique/)

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
