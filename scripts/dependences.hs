#!/bin/bash
#author: Nic
#
# 安装依赖环境
#

# 当前目录
CURRENT_DIR=${PWD}

hash gitbook || ( npm install -g gitbook-cli )
hash greed-summary || ( gem install greed-summary )
# npm install
gitbook install

cd ${CURRENT_DIR}
