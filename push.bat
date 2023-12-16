@echo off
echo ===============================现在时间是:%time%================================
title= Git自动拉取上传脚本
color 3
echo "-------Begin-------"
git config --global https.proxy http://127.0.0.1:10809
git config --global https.proxy https://127.0.0.1:10809
echo -------正在查看当前目录-------
echo 当前目录是：%cd%
echo -------正在从远程拉取代码-------
git pull
echo -------拉取成功-------
git add .
git status
set  /p  msg=请输入提交注释:
echo -------正在从本地上传代码-------
git commit -m ":sparkles: %msg% %date% %time%"
git push origin main
echo 推送成功：【%msg%】
git config --global --unset http.proxy
git config --global --unset https.proxy
echo -------End！-------
pause 摁任意键退出
exit