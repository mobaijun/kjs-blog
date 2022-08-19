---
title: 【工具系列】Chrome骚操作-暗黑模式
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 暗黑模式
categories:
  - 工具
abbrlink: 362853901
date: 2020-05-13 14:18:26
img:
coverImg:
password:
summary:
---

* 下午的时候好困呀,困得不行,又不能睡觉,之能划划水写写博客这样子,突然想起来家里的电脑浏览器是暗黑模式的,但是公司的电脑却不是的,忘记怎么设置了,百度一番,给大家提供两种设置Chrome浏览器暗黑模式的方法

* > 参考博文:
  >
  > > https://liulanmi.com/zt/13379.html
  > >
  > > https://blog.csdn.net/qq_43188045/article/details/101439249

### 一:修改目标路径(局部暗黑模式)

* 什么是局部暗黑模式呢?

  > 比如你打开一个网站,浏览器显示为暗黑模式,网站还是正常的颜色

  ![局部暗黑](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-9/9.jpg)

* 点击桌面Google Chrome,鼠标右键打开属性,目标位置添加以下内容,`注意添加空格`,复制我的即可

~~~xml
 --force-dark-mode
~~~

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-9/8.jpg)

* 添加完毕以后,点击高级,已管理员身份运行

### 二:全局暗黑模式

* 全局暗黑模式:在Chrome浏览器上所有的网页全部强制适配暗黑模式

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-9/10.jpg)

* 设置方法:[chrome://flags/](chrome://flags/)点击这个网址,进入Chorme实验室,输入`Force Dark Mode for Web Contents`,将默认`Default`改为`Enabled`,重启浏览器搞定
* 各种设置如下：
  - Enabled （启用）
  - Enabled with simple HSL-based inversion （使用简单的基于 HSL 的反转）
  - Enabled with simple CIELAB-based inversion （使用简单的基于 CIELAB 的反转）
  - Enabled with selective image inversion （选择性图像反转）
  - Enabled with selective inversion of non-image elements （非图像元素的选择性反转）
  - Enabled with selective inversion of everything （选择性反转一切）
  - HSL 和 CIELAB 设置使用不同的算法来显示颜色，这在某些网站上的测试效果看起来并不太好，颜色略显糟糕。测试结果显示：选择性反转非图像元素的效果看起来最好。

