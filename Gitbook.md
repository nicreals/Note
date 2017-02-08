# Gitbook

## 安装cli工具

```
npm install gitbook -g
npm install gitbook-cli -g
```

## 自动生成SUMMARY

### gitbook-summary
```
npm install gitbook-summary -g
book sm
```

### greed-summary

```
npm install greed-summary -g
greed-summary
```

## 使用
1. 在[Gitbook](https://www.gitbook.com/)关联GitHub仓库；
2. 在笔记所在目录`gitbook init`会自动生成`SUMMARY.md`目录描述文件
3. 编写Markdown笔记并使用`greed-summary`更新目录文件；
4. 将代码提交到GitHub仓库即可更新Gitbook。
