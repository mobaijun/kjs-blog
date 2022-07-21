---
title: 【Hexo】Hexo博客新建文章后自动打开编辑器
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 工具
categories:
  - Hexo
abbrlink: 2964207350
date: 2020-05-19 14:08:16
img:
coverImg:
password:
summary:
---

### 原因

> 每次新建一篇文章`hexo new post ‘title’`,都需要去`\source\_posts\`目录下一个个寻找新建的文章,每次花费两三分钟的时间,文章越来越多以后,效率越来越低

### 解决方案

在参阅了部分博客和官方提供的方案以后,实现两大平台解决方法

传送门:

* [官方:](https://github.com/hexojs/hexo/issues?page=5&q=is%3Aissue+is%3Aopen)
* [博客](https://www.jianshu.com/p/5fbb62791f9b)

### Windows

* 在`Hexo`目录下的`scripts`目录中创建一个`JavaScript`脚本文件。

* 如果没有这个`scripts`目录，则新建一个。

  * 新建目录

  ~~~bash
  mkdir scripts
  ~~~

*  `scripts`目录新建的` js `脚本文件可以任意取名,建议`auto_open.js`。

* ` windows`平台的`Hexo`用户操作如下：

~~~javascript
var spawn = require('child_process').exec;
// Hexo 2.x 用户复制这段
//hexo.on('new', function(path){
//  spawn('start  "typora编辑器绝对路径.exe" ' + path);
//});
//C:\Program Files\Typora\bin\typora.exe是typora编辑器在我本地的路径！
// Hexo 3 用户复制这段
hexo.on('new', function(data){
  spawn('start  "C:\Program Files\Typora\bin\typora.exe" ' + data.path);
});
~~~

### Mac平台Hexo用户操作如下（未测试）：

```jsx
var exec = require('child_process').exec;
// Hexo 2.x 用户复制这段
// hexo.on('new', function(path){
//    exec('open -a "Typora编辑器绝对路径.app" ' + path);
//});
// Hexo 3 用户复制这段
hexo.on('new', function(data){
    exec('open -a "Typora编辑器绝对路径.app" ' + data.path);
});
```

然后再创建文件输入命令之后就会自动打开Typora编辑器来编辑你新建的文章了。

```bash
hexo new "auto open editor test"
```