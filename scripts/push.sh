#!/bin/bash
#author: Nic
#
# 推送markdown文件到master分支
#

greed-summary -t 'Note' -i ['IMG'，'_book','scripts'] -S gitbook -a

cp SUMMARY.md README.md

CURRENT_DIR=${PWD}

echo CURRENT_DIR

git add ./

git commit -a -m"update"

git push origin master
