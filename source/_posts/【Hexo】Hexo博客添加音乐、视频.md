---
title: 【Hexo】Hexo博客添加音乐、视频
author: 墨白
img: 
coverImg: 
top: false
cover: false
toc: true
mathjax: false
tags:
  - 插件
categories:
  - Hexo
abbrlink: 2187918275
date: 2019-12-31 09:41:36
password:
summary:
---


### 插入音乐

打开网页版网易云,选择一首你喜欢的音乐,点击生成外链播放器,复制代码贴上,效果如上

![生成外链播放器]( https://mobaijun.gitee.io/mobai_images.gitee.io/img/hexocoding/1.jpg)

![复制代码]( https://mobaijun.gitee.io/mobai_images.gitee.io/img/hexocoding/2.jpg)

### 插入视频

复制一段视频链接,博客插入以下代码

~~~xml
<iframe 
	height=498 width=100% 
	src="https://mobaijun.gitee.io/mobai_blog.gitee.io/highway-loop.mp4" 
	frameborder=0 allowfullscreen>
</iframe>
~~~

效果如下:

<iframe 
	height=498  width=100% 
	src="https://vdept.bdstatic.com/4a484a68435372716246517350793337/5741623876377664/fd8749c51659039722091ad007cbdc54ef95c5e3c75a926044cfd47c549c3a1a3b7e39ed4ea9a346b0024a27d0d3b22f1c7110f923cfc3b0cb4c421f18d6ae2d.mp4?auth_key=1586862322-0-0-906e32de43b9c5d7a5ca02d09f965ef8" 
	frameborder=0 allowfullscreen>
</iframe>