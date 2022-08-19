---
title: '【工具系列】让你的IDEA一次设置,多处使用'
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - IDEA小技巧
categories:
  - 工具
abbrlink: 798437723
date: 2020-06-29 01:00:41
img:
coverImg:
password:
summary:
---

> 引言:
>
> IDEA是被认为Java开发最好的IDE,相信不少小伙伴都遇到过在多台电脑重复设置IDEA的情况,今天墨白给大家带来一个将IDEA设置存放到远程仓库,换电脑只需要拉取即可完成设置的方法,大大简化你的操做!

## 一 :

打开你的浏览器,进入GitHub官网,如果没有账号就自行注册一个,有的话直接登录点击`new repository`新建一个仓库,按照如下操做即可;

![img](https://tencent.cos.mobaijun.com/article_with_pictures/20200629011342.jpg)

## 二 :

在GitHub新建一个token,相当于个人令牌,按照以下步骤操做,点击个人头像最下方Settings,然后点击Developer settings

![img](https://tencent.cos.mobaijun.com/article_with_pictures/20200629011339.jpg)

设置token相关权限

![img](https://tencent.cos.mobaijun.com/article_with_pictures/20200629011337.jpg)

拉到最下方点击确认即可,会显示一串数字,

> 一定要记得保存这个token,
>
> 一定要记得保存这个token,
>
> 一定要记得保存这个token,

重要的事情说三遍,存放到你的本地txt文件里面或者微信传输助手都可以

![img](https://tencent.cos.mobaijun.com/article_with_pictures/20200629011334.jpg)



## 三 :

将你的配置推送到远程仓库,第一次推送需要你填入token,具体操做看下图

![img](https://tencent.cos.mobaijun.com/article_with_pictures/20200629011330.jpg)

填入仓库链接

![img](https://tencent.cos.mobaijun.com/article_with_pictures/20200629011328.jpg)

后面会弹出一个窗口,输入你复制的token即可,将其推送到远程仓库,效果图

![img](https://tencent.cos.mobaijun.com/article_with_pictures/20200629011323.jpg)

> 按钮解释:
>
> * Merge: 比较合并,如果有更新就合并更新
> * Overwirte Local: 覆盖本地,换电脑就可以使用这个
> * Overwirte Remote:覆盖远程仓库,第一此上传就使用这个