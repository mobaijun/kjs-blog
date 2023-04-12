---
title: 【随笔】Markdown代码块折叠与收起
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1282194883
tags:
  - markdown
categories:
  - 随笔
date: 2023-04-12 15:57:44
img:
coverImg:
password:
summary:
---

## 前言

> 很多时候，文章里面需要的代码块太长，导致文章显得很是臃肿，在 markdown 写的博客内，可以采用 html 语法扩展代码折叠功能！

## 代码折叠

html 标签： <datails>

~~~html
<datails>
    <summary>显示的标题</summary>
    <p>
        ------------------测试折叠---------------------
    </p>
    <pre><code>title,value,callBack 可以缺省</code></pre>
</datails>
~~~

1. `details`：折叠语法标签
2. `summary`：折叠语法展示的摘要
3. `pre`：以原有格式显示元素内的文字是已经格式化的文本
4. `code`：指定代码范例
5. `blockcode`：表示程序的代码块

## 代码块折叠

~~~html
<details>
  <summary>点击时的区域标题</summary>
  ```json
   {
    "name": "hexo-site",
    "version": "0.0.0",
    "private": true,
    "scripts": {
      "build": "hexo generate",
      "clean": "hexo clean",
      "deploy": "hexo deploy",
      "server": "hexo server"
   }
  ```
</details>
~~~

## 效果展示

<datails>
    <summary>显示的标题</summary>
    <p>
        ------------------测试折叠---------------------
    </p>
    <pre><code>title,value,callBack 可以缺省</code></pre>
</datails>
<details>
  <summary>点击时的区域标题</summary>
  ```json
   {
    "name": "hexo-site",
    "version": "0.0.0",
    "private": true,
    "scripts": {
      "build": "hexo generate",
      "clean": "hexo clean",
      "deploy": "hexo deploy",
      "server": "hexo server"
   }
  ```
</details>





。。。。。。。。。。。。。。。。。。。。。hexo matery 主题不支持第一种方式
