# Git

## 初始化设置

```bash
git config --global user.name "聂锐"

git config --global user.email nic.reals@outlook.com

git config --global http.proxy 'socks5://127.0.0.1:1080'  //配置git使用shadowsocks的sock5代理 同理设置https代理
git config --global --get http.proxy //获取当前http代理地址
git config --global --unset http.proxy // 撤销http代理设置

```

## 常规用法

- 删除远程分支
```shell
git push origin --delete {branch} // 注意冒号的书写位置
```

- 初始化Git仓库
```
git init
git remote add origin {remote url}
git push -u origin master // 只有"push -u" 到远程仓库之后才能创建分支
git checkout -b {new branch name}
git branch --list
```
