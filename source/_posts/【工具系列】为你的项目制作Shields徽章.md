---
title: 【工具系列】为你的项目制作Shields徽章
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1801508789
date: 2022-11-24 09:33:33
img:
coverImg:
password:
summary:
tags:
- shields
categories:
- 工具
---

## 前言

在 GitHub 许多开源项目都有很漂亮的徽章，它们可以用来显示项目的进度，访问人数，版本信息以及GitHub stars 数量等等，比如 [kjs-common](https://github.com/mobaijun/kjs-common) 这个项目

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】为你的项目制作Shields徽章/0.png)

## 自定义徽章

> shields 徽章可用来说明项目状态或者版本等信息，可以访问官网 https://www.shields.io/ 制作徽章，

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】为你的项目制作Shields徽章/1.png)



找到Your BADGE 自定义定制徽章，输入标签和信息，点击生成：

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】为你的项目制作Shields徽章/2.png)



效果

![](https://img.shields.io/badge/%E6%A1%86%E6%9E%B6%E5%B8%88-%E5%A2%A8%E7%99%BD-green)



在 markdown 可以使用 html 语法显示图标

```html
<a href="https://tencent.cos.mobaijun.com/img/icon/avatar.jpg"><img src="https://img.shields.io/badge/%E6%A1%86%E6%9E%B6%E5%B8%88-%E5%A2%A8%E7%99%BD-green" alt="博客"></a>
```

也可以直接编辑 URL：

```http
https://img.shields.io/badge/<LABEL>-<MESSAGE>-<COLOR>.svg
# 或者
https://img.shields.io/static/v1?label=<LABEL>&message=<MESSAGE>&color=<COLOR>
```

## 参数设置

有以下几种颜色可以选择：

> brightgreen、green、yellow、green、yellow、orange、red、blue、lightgrey、success、important、critical、informational、inactive、blueviolet、ff69b4、9cf

----

还可以配置style和logo参数

```http
https://img.shields.io/badge/%E6%A1%86%E6%9E%B6%E5%B8%88-%E5%A2%A8%E7%99%BD-green?style=social&logo=github
```

![](https://img.shields.io/badge/%E6%A1%86%E6%9E%B6%E5%B8%88-%E5%A2%A8%E7%99%BD-green?style=social&logo=github)





> style 样式默认为 flat，还可以设置为 plastic、flat-square、for-the-badge和social。
>
> logo 可以选择 Simple Icons：[https://simpleicons.org](https://simpleicons.org) 上提供的图标，比如微信的图标：

~~~css
logo=WeChat
~~~

## 其他

更多玩法可到 [https://shields.io/](https://shields.io/) 查阅。

* 设置链接

> 可以给徽章设置一个链接

~~~markdown
[![](https://img.shields.io/badge/%E6%A1%86%E6%9E%B6%E5%B8%88-%E5%A2%A8%E7%99%BD-green?style=social&logo=github)](https://www.mobaijun.com)
~~~



[![](https://img.shields.io/badge/%E6%A1%86%E6%9E%B6%E5%B8%88-%E5%A2%A8%E7%99%BD-green?style=social&logo=github)](https://www.mobaijun.com)



或者使用HTML语法：

~~~html
<p align="center">
<a href="https://www.mobaijun.com"><img src="https://img.shields.io/badge/%E6%A1%86%E6%9E%B6%E5%B8%88-%E5%A2%A8%E7%99%BD-green?style=social&logo=github" alt=""></a>
</p>
~~~

<p align="center">
<a href="https://www.mobaijun.com"><img src="https://img.shields.io/badge/%E6%A1%86%E6%9E%B6%E5%B8%88-%E5%A2%A8%E7%99%BD-green?style=social&logo=github" alt=""></a>
</p>
