---
title: 【工具系列】使用码云 + PicGO + Typora搭建一个自动化图床
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - PicGo
categories:
  - 工具
abbrlink: 1619271054
date: 2020-05-25 11:12:01
img:
coverImg:
password:
summary:
---

### 前言

> 之前一直使用的是由码云`gitee pages`搭建的图床,最近用的越来越烦啦,每次都要,git add,git commit .........然后还要更新gitee pages,我都想不通我之前为什么要这么干,太闲了嘛,既然觉得麻烦,那么就要解决麻烦,查了一下发现一个好东西,PicGo,这是一个开源免费的上传图片到远程仓库的工具,利用这个工具可以搭建一个全自动化的图床

### 相关工具

|     工具名称     |     版本     |
| :--------------: | :----------: |
|      Typora      | 0.9.86(beta) |
|      PicGo       |    2.2.2     |
| Snipaste(狙击手) |    2.4.0     |
|     Node.js      |   12.16.2    |
|       码云       |     盲区     |

* 需要下载[Typora + PicGo](https://mobaijun.lanzous.com/b015h9adg) **密码:8gzm**
* [Snipaste](https://docs.snipaste.com/zh-cn/):这个作为开发者应该不陌生,毫不夸张的说这个全世界最牛批的截图工具

### 码云:

没有账号的注册一个账号,国人自己的平台,支持下,还是挺良心的,[码云传送门](https://gitee.com/),注册完毕新建仓库,都是中文,不做概述,看图操作即可

* 新建仓库

![image-20200525113231129](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200525113237.png)

* 获取Token

定位到码云[/设置/私人令牌/生成新令牌](https://gitee.com/profile/personal_access_tokens/new),一定记得`点击提交之后记得复制Token`,不然还要重新生成一个

![image-20200525113618619](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200525113640.png)

### 设置PicGo

* 安装PicGo

下载完毕直接安装即可,前提条件,需要安装一个`node`,咱一直点击`next`就完事了

> 需要注意的是PicGo不可以安装在`C:\Program Files`目录下,最好就不要安装在C盘下

* 下载插件

![image-20200525114109400](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200525114111.png)

* 配置图床相关设置

![image-20200525114351948](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200525114353.png)

* 其他一些设置(参考我的就好)

![image-20200525115105123](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200525115106.png)

### 配置Typora

定位到`/文件/偏好设置/图像/`

![image-20200525114656323](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200525114658.png)

正常情况下是没有问题的了,下面配置狙击手

### Snipaste

下载地址上面已经贴了,这里只说配置

`/状态栏/首选项/控制/`需要的话就按照我的配置即可

![image-20200525114902015](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200525114903.png)

### 最后的效果

![image-20200525114932759](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200525114934.png)

### 结语

> 懒人改变世界,哦不对,代码改变世界!!!

