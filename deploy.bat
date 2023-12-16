@echo off
echo ===============================现在时间是:%time%================================
title= Git自动拉取上传脚本
color 3
echo "-------配置代理中-------"
git config --global https.proxy 127.0.0.1:10809
git config --global https.proxy 127.0.0.1:10809
echo -------正在查看当前目录-------
echo 当前目录是：%cd%
echo -------正在执行部署-------
hexo g -d
echo -------正在取消代理-------
git config --global --unset http.proxy
git config --global --unset https.proxy
echo -------End！-------
pause 摁任意键退出
exit