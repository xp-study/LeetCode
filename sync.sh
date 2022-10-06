#!/bin/bash

# 进入工作目录
cd /opt/xp-study/

# 删除被拷贝工程的git文件
rm backup/.git

rm backup/.drone.yml

rm backup/sync.sh

# 删除LeeteCode下面除git外的所有文件
cd ./LeeteCode/

rm  -rf  !(.git)

# 重新回到工作目录
cd /opt/xp-study/

# 同步文件到github仓库
cp ./backup/* ./LeeteCode/

# 进入git仓库
cd ./LeeteCode/

# 添加提交
git add .

# 提交
git commit -m "同步文档"

# 推送
git push

# 重新回到工作目录
cd /opt/xp-study/

rm -rf /opt/xp-study/backup/*

