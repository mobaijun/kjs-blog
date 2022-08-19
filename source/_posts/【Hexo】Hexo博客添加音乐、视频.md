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

<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=330 height=86 src="//music.163.com/outchain/player?type=2&id=1394601255&auto=1&height=66"></iframe>

复制代码

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20220819143518449.png)

### 插入视频

复制一段视频链接,博客插入以下代码

~~~xml
<iframe 
	height=498 width=100% 
	src="https://tencent.cos.mobaijun.com/video/1.mp4" 
	frameborder=0 allowfullscreen>
</iframe>
~~~

效果如下:

<iframe 
	height=600  width=100% src="https://tencent.cos.mobaijun.com/video/1.mp4" frameborder=0 allowfullscreen>
</iframe>
## 插入 PDF

~~~xml
<embed id="pdfPlayer" src="https://cdn.mobaijun.com/pdf/JavaDevelopmentManual%28HuangshanEdition%29.pdf" type="application/pdf" width="100%" height="800" >
~~~

<embed id="pdfPlayer" src="https://cdn.mobaijun.com/pdf/JavaDevelopmentManual%28HuangshanEdition%29.pdf" type="application/pdf" width="100%" height="800" >