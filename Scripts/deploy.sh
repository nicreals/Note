#!/bin/bash
#author: Nic
#
# 推送html代码到gh-pages分支
#
# 当前目录
CURRENT_DIR=${PWD}

# 脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)

## blog 目录
BLOG_DIRECTORY=${SCRIPT_DIR}/..

GITHUB_REF=github.com/nicreals/nicreals.github.io.git

if ! [ -n "${GITHUB_API_KEY}" ]; then
  echo "no valid GITHUB_API_KEY"
  exit 1
fi

# deploy the gh-pages
echo Deploy to GitHub Pages
cd ${BLOG_DIRECTORY}/_book
git init
git config user.email "nic.reals@outlook.com"
git config user.name "nic_reals"
git remote add origin https://nicreals:${GITHUB_API_KEY}@${GITHUB_REF}
git fetch origin
git reset origin/master
git add . --all
git commit -m "Deploy to GitHub Pages by travis"
git push -q origin HEAD:master

cd ${CURRENT_DIR}
