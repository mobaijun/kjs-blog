---
title: 【Hexo】hexo博客valine评论优化
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - valine
categories:
  - Hexo
abbrlink: 3474678254
date: 2020-05-07 13:41:45
img:
coverImg:
password:
summary:
---

> 今天测试博客回复功能的时候发现,博客在回复别人评论的时候会自动跳转到最上面的回复框,那样如果第一次没看清主题回复还要滑下去,这多麻烦

定位到`\themes\matery\layout\_partial\valine.ejs`,添加如下代码

```js
<script>
    new Valine({
        el: '#vcomments',
        appId: '<%- theme.valine.appId %>',
        appKey: '<%- theme.valine.appKey %>',
        notify: '<%- theme.valine.notify %>' === 'true',
        verify: '<%- theme.valine.verify %>' === 'true',
        visitor: '<%- theme.valine.visitor %>' === 'true',
        avatar: '<%- theme.valine.avatar %>',
        pageSize: '<%- theme.valine.pageSize %>',
        lang: '<% if (config.language == "zh-CN") { %>zh-cn<% } else { %>en<% } %>',
        placeholder: '<%= theme.valine.placeholder %>',
    });
    // 点击回复直接评论
    $(document).ready(function () {
        $('.vemoji-btn').text('😀');
        $("#vcomments").on('click', 'span.vat', function () {
            $(this).parent('div.vmeta').next("div.vcontent").after($("div.vwrap"));
            $('textarea#veditor').focus();
        })
    });
</script>
```

实现后的效果:

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20220819143140166.png)