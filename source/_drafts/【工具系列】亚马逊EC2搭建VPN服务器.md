---
title: 【工具系列】亚马逊EC2搭建VPN服务器
author: 墨白
top: false
cover: false
toc: true
mathjax: false
date: 2022-08-05 22:22:17
img:
coverImg:
abbrlink:
password:
summary:
tags:
categories:
---

1. 用root账户登陆服务器

2. 安装PPTPD

   ```
   apt-get install pptpd
   ```

3. 编辑pptpd.conf文件

   ```
   vi /etc/pptpd.conf
   ```

   取消注释下面内容

   ```
   localip 192.168.0.1
   remoteip 192.168.0.234-238,192.168.0.245
   ```

   这几句的意思是：当外部计算机通过pptp联接到vpn后所能拿到的ip地址范围和服务器的ip地址设置。
