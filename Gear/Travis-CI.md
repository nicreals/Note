# Travis CI

## GitHub生成access token

`GitHub`->`Setting`->`Personal access tokens`->`Generate new token`

## 添加环境变量

- 方法一
`Travis CI`->`Setting`添加GITHUB_API_KEY=<token>, `Display value in build log` 设置为 `Off`.

- 方法二
进入仓库根目录下运行 `travis encrypt -a GITHUB_API_KEY <token> GITHUB_API_KEY`会自动加到`.travis.yml`

## 设置系统/语言/IDE版本

具体Xcode版本与Mac OS版本细节参考[官方文档](https://docs.travis-ci.com/user/osx-ci-environment/)

```
language: objective-c
osx_image: xcode8.2
```

## 设置邮件通知

```
notifications:
  slack:
    on_success: always
    on_failure: never/change
    ```
