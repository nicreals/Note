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

### 托管在`gitbooks.io`方式

1. 在[Gitbook](https://www.gitbook.com/)关联GitHub仓库；
2. 在笔记所在目录`gitbook init`会自动生成`SUMMARY.md`目录描述文件
3. 编写Markdown笔记并使用`greed-summary`更新目录文件；
4. 将代码提交到GitHub仓库即可更新Gitbook。

### 托管在`GitHub Pages`方式

- 在工程目录下使用`gitbook build`命令生成html文件，使用`gitbook serve`预览效果；

- 将自动生成的`_book`目录下的内容push到远程的`gh-pages`分支(只有分支名为`gh-pages`才有效)；

- 访问`https://{username}github.io/{repo_name}`即可查看效果

## 集成Travis CI

### 集成Travis CI

配置Travis CI参考:[Travis CI](./Travis CI.md)

在项目根目录新建`.travis.yml`:

```
before_install:
- "./scripts/dependences.sh" // 配置gitbook环境
script:
- "travis_wait 30 sh ./scripts/build.sh" //编译生成html文件
after_success:
- "./scripts/deploy.sh" // 将_book中的内容push到'gh-pages'分支
```

脚本参考:
- [dependences.sh](https://github.com/nicreals/Note/blob/master/scripts/dependences.sh)
- [build.sh](https://github.com/nicreals/Note/blob/master/scripts/build.sh)
- [deploy.sh](https://github.com/nicreals/Note/blob/master/scripts/deploy.sh)
