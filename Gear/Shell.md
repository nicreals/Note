# Shell

> [Shell常用快捷键](https://github.com/hokein/Wiki/wiki/Bash-Shell%E5%B8%B8%E7%94%A8%E5%BF%AB%E6%8D%B7%E9%94%AE)

## 常用快捷键

Descriptions |    ShortCut
:----------- | :-------------:
删除光标左边所有 | ctrl-U
删除光标右边所有 | ctrl-K
移动光标到行首 | ctrl-A
移动光标到行尾 | ctrl-E

## 常用命令

```
chmod + x ass.file //设置文件权限
mv ass.file filename //更改文件名
```

## 关闭gatekeeper

关闭`gatekeeper`可以允许Mac安装任何来源的APP

```
sudo spctl --master-disable
```

## bash 设置socks5代理

在`~/.bashrc`文件中加入如下function:

```
function setproxy() {
    # export {HTTP,HTTPS,FTP}_PROXY="http://127.0.0.1:3128"
    export ALL_PROXY=socks5://127.0.0.1:1080
}

function unsetproxy() {
    # unset {HTTP,HTTPS,FTP}_PROXY
    unset ALL_PROXY
}
```

## Fish Shell

- 安装OMF

```
curl -L github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish
omf help
omf install pure
omf theme pure
```

- fish中安装rvm

```
omf install rvm
rvm install x.x
rvm use x.x
```

## 在shell当前session中设置代理

- 在`~/.config/fish/functions`创建`setproxy.fish`文件并设置如下function:

```
function setproxy
  export http_proxy=http://127.0.0.1:1087;export https_proxy=http://127.0.0.1:1087;
  echo "====== current socks proxy:"$https_proxy"======"
end
```

- 在`~/.config/fish/functions`创建`unsetproxy.fish`文件并设置如下function:

```
function unsetproxy
  set -e http_proxy
  set -e https_proxy
  echo '====== current shell session proxy is erased ======'
end
```

- 测试更改是否生效

```
curl -i http://ip.cn
```

## curl

1. 设置socks5代理

```
curl -x 127.0.0.1:1086 {url}
```
