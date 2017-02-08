# AppCode

## vmoptions

AppCode默认.vmoptions文件在~/Application/AppCode/bin/AppCode.vmoptions,更改该文件会改变AppCode的文件签名，应当使用`Help-Edit Custom VM Options`来更改配置：

```
# custom AppCode VM options
-Xss2m
-Xms256m
-Xmx4096m
-XX:NewSize=128m
-XX:MaxNewSize=256m
-XX:ReservedCodeCacheSize=192m
-XX:+UseCompressedOops
```

# Xcode

## Xcode 警告

### 开启可信度较高的警告

Build Setting -> other c flags -> `-Wall`

### 开启大部分警告

Build Setting -> other c flags -> `-Wextra`

### 屏蔽第三方SDK`was built for newer iOS version`警告

Target -> Build Setting -> Other Linker Flag -> `-w`

## 环境变量

Edit Scheme -> Arguments -> Environment Variables

## 解决project.pbxproj合并冲突

在工程更目录新建`.gitattributes`文件并添加如下内容:

[Automatically resolving git merge conflicts in Xcode's project.pbxproj file](http://roadfiresoftware.com/2015/09/automatically-resolving-git-merge-conflicts-in-xcodes-project-pbxproj/)

```
*.pbxproj text -crlf -diff -merge=union
```
