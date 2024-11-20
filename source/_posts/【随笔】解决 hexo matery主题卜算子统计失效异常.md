---
title: 【随笔】解决 hexo matery主题卜算子统计失效异常
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2629378943
tags:
  - 卜算子
categories:
  - 随笔
date: 2024-11-11 11:02:58
img:
coverImg:
password:
summary:
---

> 发布文章的时候发现博客底部的卜算子请求失败了！通过 F12 发现是卜算子请求地址报错，去卜算子官网查看，修改下配置即可

卜算子官网：https://busuanzi.ibruce.info/

修改主题配置文件 `themes/matery/_config.yml` 的卜算子 `js` 文件地址为最新版本:

~~~yaml
  js:
    busuanzi: https://busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js
~~~

改完发现访问人数还是不显示，排查后发现卜算子新版 `api` 更改返回的 `key` 值了,修改
`themes/matery/layout/_partial/footer.ejs` 文件卜算子配置为如下内容即可。

~~~ejs
<% if (theme.busuanziStatistics && theme.busuanziStatistics.totalTraffic) { %>
    <span id="busuanzi_container_site_pv">
    &nbsp;|&nbsp;<i class="far fa-eye"></i>&nbsp;<%- __('siteTotalVisits') %>:&nbsp;
        <span id="busuanzi_value_site_pv" class="white-color"></span>
</span>
<% } %>
<% if (theme.busuanziStatistics && theme.busuanziStatistics.totalNumberOfvisitors) { %>
    <span id="busuanzi_container_site_pv">
    &nbsp;|&nbsp;<i class="fas fa-users"></i>&nbsp;<%- __('siteTotalVisitors') %>:&nbsp;
        <span id="busuanzi_value_site_uv" class="white-color"></span>
</span>
<% } %>
~~~
