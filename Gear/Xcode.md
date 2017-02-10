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

在工程更目录新建`.gitattributes`文件并添加如下内容:

[Automatically resolving git merge conflicts in Xcode's project.pbxproj file](http://roadfiresoftware.com/2015/09/automatically-resolving-git-merge-conflicts-in-xcodes-project-pbxproj/)

```
*.pbxproj text -crlf -diff -merge=union
```
