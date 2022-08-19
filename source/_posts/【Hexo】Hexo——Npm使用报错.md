---
title: 【Hexo】Hexo——Npm使用报错
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - Npm
categories:
  - Hexo
abbrlink: 776701796
date: 2020-04-18 14:44:30
img:
coverImg:
password:
summary:
---



>  今天需要用到npm下载一个依赖，突然发现npm无法使用，出现冲突
>
> ~~~bash
>npm ERR! Cannot read property 'match' of undefined
> 
> npm ERR! A complete log of this run can be found in:
> npm ERR!     C:\Users\Administrator\AppData\Roaming\npm-cache\_logs\2020-04-18T06_38_41_399Z-debug.log
> ~~~
> 
> 查看报错位置日志发现日志全部是`silly saveTree | |   +-- has-ansi@2.0.0`这种类型的
>
> ~~~bash
>0 info it worked if it ends with ok
> 1 verbose cli [
> 1 verbose cli   'C:\\Program Files\\nodejs\\node.exe',
> 1 verbose cli   'C:\\Program Files\\nodejs\\node_modules\\npm\\bin\\npm-cli.js',
> 1 verbose cli   'i'
> 1 verbose cli ]
> 2 info using npm@6.14.4
> 3 info using node@v12.16.2
> 4 verbose npm-session d699d05f8d8b58a0
> 5 silly install runPreinstallTopLevelLifecycles
> 6 silly preinstall hexo-site@0.0.0
> 7 info lifecycle hexo-site@0.0.0~preinstall: hexo-site@0.0.0
> 8 silly install loadCurrentTree
> 9 silly install readLocalPackageData
> 10 timing stage:loadCurrentTree Completed in 29ms
> 17 silly saveTree |     | +-- esutils@2.0.3
> 17 silly saveTree |     | `-- to-fast-properties@2.0.0
> 17 silly saveTree |     `-- esutils@2.0.3
> 17 silly saveTree +-- @babel/runtime@7.7.7
> 17 silly saveTree | `-- regenerator-runtime@0.13.3
> 17 silly saveTree +-- babel-core@6.26.3
> 17 silly saveTree | +-- babel-code-frame@6.26.0
> 17 silly saveTree | | `-- chalk@1.1.3
> 17 silly saveTree | |   +-- ansi-styles@2.2.1
> 17 silly saveTree | |   +-- escape-string-regexp@1.0.5
> 17 silly saveTree | |   +-- has-ansi@2.0.0
> 17 silly saveTree | |   | `-- ansi-regex@2.1.1
> 17 silly saveTree | |   +-- strip-ansi@3.0.1
> 17 silly saveTree | |   `-- supports-color@2.0.0
> ~~~
> 
> 可能是即将下载的依赖和现有的包内依赖出现版本冲突，知道了原因就好解决了

## 解决

* 在hexo博客内，根目录下会出现一个下载的所有依赖包版本文件`package-lock.json`，删掉这个文件即可

~~~json
{
"name": "hexo-site",
"version": "0.0.0",
"lockfileVersion": 1,
"requires": true,
"dependencies": {
 "@babel/code-frame": {
   "version": "7.8.3",
   "resolved": "https://registry.npm.taobao.org/@babel/code-frame/download/@babel/code-frame-7.8.3.tgz?cache=0&sync_timestamp=1578953126105&other_urls=https%3A%2F%2Fregistry.npm.taobao.org%2F%40babel%2Fcode-frame%2Fdownload%2F%40babel%2Fcode-frame-7.8.3.tgz",
   "integrity": "sha1-M+JZA9dIEYFTThLsCiXxa2/PQZ4=",
   "requires": {
     "@babel/highlight": "^7.8.3"
   }
 }
~~~

* 重新`npm  i`就好了
