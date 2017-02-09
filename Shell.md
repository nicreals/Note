# Shell

## 常用命令

```
chmod + x ass.file //设置文件权限
mv ass.file filename //更改文件名
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

## Git

```
git config --global user.name "聂锐"

git config --global user.email nic.reals@outlook.com

sudo spctl --master-disable //关闭gatekeeper

git config --global http.proxy 'socks5://127.0.0.1:1080'  //配置git使用shadowsocks的sock5代理
git config --global https.proxy 'socks5://127.0.0.1:1080'
git config --global --get http.proxy
git config --global --unset http.proxy
git config --global --unset https.proxy
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
