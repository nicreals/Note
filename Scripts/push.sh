#!/bin/bash
#author: Nic
#
# 推送markdown文件到master分支
#

greed-summary -t "Nic's notes" -i ['IMG'，'_book','Scripts','node_modules'] -S gitbook -a

cp SUMMARY.md README.md

echo ""

git add ./

git commit -a -m "update"

git push origin master
