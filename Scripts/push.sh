#!/bin/bash
#author: Nic
#
# 推送markdown文件到master分支
#

echo "====== making summary ======"

greed-summary -t 'Note' -i ['IMG'，'_book','Scripts'] -S gitbook -a

cp SUMMARY.md README.md

echo ""

echo "====== pushing commit ======"

echo ""

git add ./

git commit -a -m "update"

git push origin master

echo "====== done ======"
