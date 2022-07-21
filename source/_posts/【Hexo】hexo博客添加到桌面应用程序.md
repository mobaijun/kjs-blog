---
title: 【Hexo】hexo博客添加到桌面应用程序
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - PWD
categories:
  - Hexo
abbrlink: 1630447354
date: 2020-05-21 15:38:06
img:
coverImg:
password:
summary:
---

### PWA是什么?

* PWA（Progressive web apps，渐进式 Web 应用）运用现代的 Web API 以及传统的渐进式增强策略来创建跨平台 Web 应用程序。这些应用无处不在、功能丰富，使其具有与原生应用相同的用户体验优势。 这组文档和指南告诉您有关 PWA 的所有信息。

### PWA 的优势

PWA 是可被发现、易安装、可链接、独立于网络、渐进式、可重用、响应性和安全的。关于这些含义的细节，请参阅 [PWA的优势](https://developer.mozilla.org/zh-CN/docs/Web/Apps/Progressive/Advantages)。简单概括为以下几点

* 可以支持离线观看
* 可被识别成一个应用程序
* 响应式 适合任何形式的设备

### 安装PWA插件

> * 安装PWA前提是全站支持[HTTPS协议](https://baike.baidu.com/item/HTTPS)
> * 需要自行去域名服务商申请[SSL](https://baike.baidu.com/item/ssl)证书
> * [HEXO](https://hexo.io/zh-cn/)版本为`4.1.1`以下,如版本在`4.1.1`以上,请输入以下命令安装指定版本

**实际操作**

* 安装PWA
  * 查询hexo版本

~~~bash
hexo --version
~~~

* 安装hexo指定版本

~~~bash
npm i hexo@4.1.1 --save
~~~

* 安装`PWA`插件

~~~bash
npm i hexo-pwa --save
~~~

* 修改博客根目录下配置文件(`非主题配置文件`)

> manifest 生成地址： [Web App清单生成器](https://app-manifest.firebaseapp.com/),如无法打开直接复制我的即可

~~~yaml
# hexo添加PWA
pwa:
  manifest:
    path: /manifest.json
    body:
      name: 框架师
      short_name: 框架师
      theme_color: white
      background_color: white
      display: standalone
      orientation: portrait
      scope: /
      start_url: /
      icons:
        - src: /medias/icon/logo_128.png
          type: image/png
          sizes: 128x128
        - src: /medias/icon/logo_512.png
          type: image/png
          sizes: 512x512
  serviceWorker:
    path: /sw.js
    preload:
      urls:
        - /
      posts: 12
    opts:
      networkTimeoutSeconds: 30
    routes:
      - pattern: !!js/regexp /hm.baidu.com/
        strategy: networkOnly
      - pattern: !!js/regexp /www.google-analytics.com/
        strategy: networkOnly
      - pattern: !!js/regexp /.*\.(js|css|jpg|jpeg|png|gif)$/
        strategy: cacheFirst
      - pattern: !!js/regexp /\//
        strategy: networkFirst
  priority: 5
~~~

> 详细配置请参考[GitHub官方库](https://github.com/lavas-project/hexo-pwa),我这里不做介绍

* 在博客`\blog\source\manifest.json`目录下添加`manifest.json`,键入以下内容

~~~json
{
  "name": "框架师",
  "short_name": "框架师",
  "theme_color": "white",
  "background_color": "white",
  "display": "standalone",
  "scope": "/",
  "start_url": "/",
  "icons": [
    {
      "src": "/medias/icon/logo_128.png",
      "sizes": "128x128",
      "type": "image/png"
    },
    {
      "src": "/medias/icon/logo_512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
~~~

* name: {string} 应用名称，用于安装横幅、启动画面显示
* short_name: {string} 应用短名称，用于主屏幕显示
* theme_color: {Color} css色值theme_color 属性可以指定 PWA 的主题颜色。可以通过该属性来控制浏览器 UI 的颜色。比如 PWA 启动画面上状态栏、内容页中状态栏、地址栏的颜色，会被 theme_color 所影响。
* background_color: {Color} css色值 可以指定启动画面的背景颜色。
* display: {string} 显示类型
  - fullscreen 应用的显示界面将占满整个屏幕
  - standalone 浏览器相关UI（如导航栏、工具栏等）将会被隐藏
  - minimal-ui 显示形式与standalone类似，浏览器相关UI会最小化为一个按钮，不同浏览器在实现上略有不同
  - browser 浏览器模式，与普通网页在浏览器中打开的显示一致
* scope: {string} 作用域
  - scope 应遵循如下规则：
  - 如果没有在 manifest 中设置 scope，则默认的作用域为 manifest.json 所在文件夹；
  - scope 可以设置为 ../ 或者更高层级的路径来扩大PWA的作用域；
  - start_url 必须在作用域范围内；
  - 如果 start_url 为相对地址，其根路径受 scope 所影响；
  - 如果 start_url 为绝对地址（以 / 开头），则该地址将永远以 / 作为根地址；
* start_url: {string} 应用启动地址
* icons: {Array.} 应用图标列表
  - src: {string} 图标 url
  - sizes {string} 图标尺寸，格式为widthxheight，宽高数值以 css 的 px 为单位。如果需要填写多个尺寸，则使用空格进行间隔，如”48x48 96x96 128x128”
  - type {string} 图标的 mime 类型，非必填项，该字段可让浏览器快速忽略掉不支持的图标类型

* 在博客`\blog\source\sw.js`目录下添加`sw.js`,键入以下内容

~~~js
importScripts('https://g.alicdn.com/kg/workbox/3.3.0/workbox-sw.js');

if (workbox) {
    workbox.setConfig({ modulePathPrefix: 'https://g.alicdn.com/kg/workbox/3.3.0/' });

    workbox.precaching.precache(['/', '/index.html']);

    workbox.routing.registerRoute(new RegExp('^https?://www.mobaijun.com/?$'), workbox.strategies.networkFirst());

    workbox.routing.registerRoute(new RegExp('.*.html'), workbox.strategies.networkFirst());

    workbox.routing.registerRoute(new RegExp('.*.(?:js|css|jpg|png|gif)'), workbox.strategies.staleWhileRevalidate());

}
~~~

> 修改主页域名 `^https?://www.mobaijun.com/?$` 的正则表达式路径，将这个的值修改成你的网站的 `host`

### 准备 Logo 图片

> 为了确保你的 PWA 图标支持所有设备，请务必使用 `48x48`、`96x96`、`128x128`、`144x144`、`180x180`、`192x192`、`512x512` 分辨率的 Logo 图片各一张,我觉得麻烦,所有只添加了512px/128px,如你想要添加所有的格式,按照以上格式复制即可

将上述图片放到对应的目录下，并修改 `_config.yml` 和 `manifest.json` 与之对应

推荐图片大小转换网站：[iloveimg](https://www.iloveimg.com/resize-image)

* 最后输入以下内容即可

~~~bash
# 清理缓存/生成静态页面/本地预览
$ hexo clean && hexo g && hexo s
~~~

> 更多详细内容请参考[sitoi](https://sitoi.cn/posts/49115.html)写的文章[基于 Hexo GitHub 从零开始搭建个人博客（四）：让你的博客完美支持 PWA](https://sitoi.cn/posts/49115.html),我只是简化了一些繁琐的步骤,搞定以后,浏览器地址栏会出现一个`+`号,点击添加,即可在桌面看到你的应用程序啦!