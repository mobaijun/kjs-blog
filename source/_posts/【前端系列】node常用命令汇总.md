---
title: 【前端系列】node常用命令汇总
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - Node
categories:
  - 前端
abbrlink: 3052872972
date: 2020-05-26 14:35:27
img:
coverImg:
password:
summary:
---

> 本篇文章汇集了一些个人常用命令,希望对你有所帮助

### 命令

* 查看版本信息

~~~bash
$ node -v
$ npm -v
~~~

* 查看node所有安装版本信息

~~~bash
# 1.查看指定版本信息/或全部版本
$ npm list [查看指定版本信息]
# 2.简写
$ npm ls
~~~

* 安装指定版本

~~~bash
$ npm install [包名/版本号]
~~~

* 更换淘宝镜像源

~~~bash
# 1.安装淘宝源
$ npm install -g cnpm --registry=https://registry.npm.taobao.org
# 2.查看版本
$ cnpm -v
# 3.单次使用淘宝镜像源
$ npm install --registry=https://registry.npm.taobao.org
~~~

* 全局更新

~~~bash
$ npm update [包名/版本号]
~~~

* 卸载包

~~~bash
$ npm uninstall [包名] --save-dev
~~~

* 查看配置信息/显示所有配置信息

~~~bash
$ npm config ls
~~~

* 检查模块是否已经过时

~~~bash
# 此命令会列出所有已经过时的包，可以及时进行包的更新
$ npm outdated [[<@scope>/]<pkg> ...]
~~~

* 调用帮助,会跳转到浏览器

~~~bash
$ npm help [指定命令]
~~~

* **npm root** 查看包的安装路径

~~~bash
$ npm root [-g]
~~~

* npm cache 管理模块的缓存

~~~bash
$ npm cache add <tarball file>
$ npm cache add <folder>
$ npm cache add <tarball url>
$ npm cache add <name>@<version>

$ npm cache ls [<path>]

$ npm cache clean [<path>]
# 最常用命令清除npm本地缓存
$ npm cache clean
~~~

*  npm start 启动模块

~~~bash
$ npm start [-- <args>]
~~~

* pm stop 停止模块

基础语法

```bash
$ npm stop [-- <args>]
```

* npm restart 重新启动模块

基础语法

```bash
$ npm restart [-- <args>]
```

* npm test 测试模块

基础语法

```bash
$ npm test [-- <args>]
$ npm tst [-- <args>]
```

该命令写在package.json文件scripts的test字段中，可以自定义该命令来执行一些操作，如

```bash
"scripts": {
    "test": "gulp release"
},
```

此时在cmd中输入npm test命令相当于执行gulpfile.js文件自定义的release命令。

### node异常

* 下载插件的时候报错

~~~bash
$ npm install --save-dev gulp-imagemin
npm ERR! code ENOTFOUND
npm ERR! errno ENOTFOUND
npm ERR! network request to https://registry.npmjs.org/gulp-imagemin failed, reason: getaddrinfo ENOTFOUND registry.npmjs.org
npm ERR! network This is a problem related to network connectivity.
npm ERR! network In most cases you are behind a proxy or have bad network settings.
npm ERR! network
npm ERR! network If you are behind a proxy, please make sure that the
npm ERR! network 'proxy' config is set properly.  See: 'npm help config'

npm ERR! A complete log of this run can be found in:
~~~

* 解决

  > 一般这个问题都是镜像源有异常,建议换成国内的Taobao源

~~~bash
# 1.先查看npm配置,以下为正常配置
$ npm config ls
; cli configs
metrics-registry = "http://registry.cnpmjs.org/"
scope = ""
user-agent = "npm/6.14.5 node/v12.16.2 win32 x64"

; userconfig C:\Users\Administrator\.npmrc
registry = "http://registry.cnpmjs.org/"

; builtin config undefined
prefix = "C:\\Users\\Administrator\\AppData\\Roaming\\npm"

; node bin location = C:\Program Files\nodejs\node.exe
; cwd = W:\MoBai_Blog\blog
; HOME = C:\Users\Administrator
; "npm config ls -l" to show all defaults.
# 2.查看代理,必须要两个的返回值都为null才行
$ npm config get proxy
$ npm config get https-proxy
# 3.如果不为null,请添加null
$ npm config set proxy null
$ npm config set https-proxy null
# 4.换淘宝镜像
npm config set registry http://registry.cnpmjs.org/
# 5.安装cnpm
npm install -g cnpm --registry=https://registry.npm.taobao.org 
# 6.重新下载npm包即可,一般到这一步基本上就搞定了
~~~

> 然后重新下载npm包即可

* git推送异常

~~~bash
![rejected]  master->master(fetch first)  
error:failed to push some refs to 'https://github.com/xxx/xxx.git'
~~~

* 一般出现这个原因都是远程库和本地库``README.md`不一致,所以使用pull命令更新,然后在提交

~~~bash
# 第一步执行git pull
$ git pull
# 第二步重新git push
$ git push origin master
# 如果以上步骤都不行,可以使用强制推送,但是本地所有log会清空
$ git push -f origin master
~~~

