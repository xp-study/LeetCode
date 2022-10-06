#!/bin/bash

# 进入工作目录
cd /opt/xp-study/

# 删除gitlab文件
rm backup/.git

rm backup/.drone.yml

rm backup/sync.sh

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

