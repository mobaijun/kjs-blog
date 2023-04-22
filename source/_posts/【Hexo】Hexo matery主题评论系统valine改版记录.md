---
title: 【Hexo】Hexo matery主题评论系统valine改版记录
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - valine
categories:
  - Hexo
abbrlink: 4026840102
date: 2020-12-12 12:37:53
img:
coverImg:
password:
summary:
---

* 记一次Valine修改记录，效果如下

![](https://tencent.cos.mobaijun.com/img/blog/【Hexo】Hexo matery主题评论系统valine改版记录/0.png)

* 本主题为matery主题，修改适配matery

### 下载魔改版本

~~~http
// 魔改版 Valine.min.js
https://cdn.jsdelivr.net/gh/HCLonely/Valine@latest/dist/Valine.min.js
~~~

替换掉`source/libs/valine/Valine.min.js`原生 `js` 文件

* 修改`昵称，网址，邮箱不适配异常`

> 全文查找，搜索`vheader`,修改宽度为 `32`

~~~css
.vwrap .vheader .vinput{width:32%;border-bottom:1px dashed #dedede}
~~~

> 修改`Valine`样式，定位到`themes/matery/layout/_partial/valine.ejs`，添加如下代码

### 添加卡片样式背景

~~~css
/*卡片式背景*/
#vcomments .vcards .vcard {
    padding: 15px 20px 0 20px;
    border-radius: 10px;
    margin-bottom: 15px;
    box-shadow: 0 0 4px 1px rgba(0, 0, 0, .12);
    transition: all .3s
}
#vcomments .vcards .vcard:hover {
    box-shadow: 0 0 8px 3px rgba(0, 0, 0, .12)
}
#vcomments .vcards .vcard .vh .vcard {
    border: none;
    box-shadow: none;
}
~~~

### 添加鼠标放置头像旋转

~~~css
/*鼠标放置头像旋转*/
img.vimg {
    /* 旋转时间为 1s */
    transition: all 1s
}
img.vimg:hover {
    transform: rotate(360deg);
    -webkit-transform: rotate(360deg);
    -moz-transform: rotate(360deg);
    -o-transform: rotate(360deg);
    -ms-transform: rotate(360deg);
}
~~~

### 添加背景图片输入消失判断

> 设置当鼠标聚焦于输入框时，背景图消失，输入框失去焦点时，背景图重新显示。

~~~css
/*===========背景图输入判断=========*/
#veditor:focus {
    background-position-y: 200px;
    transition: all 0.2s ease-in-out 0s;
}
~~~

### 修改评论框样式和内容高度

~~~css
/*==========修改评论框样式===========start====*/
.v .vwrap {
    padding: 0 0 20px;
}
/*内容框高度*/
.v .veditor {
    min-height: 7rem;
    resize: none;
}
/*==========修改评论框样式===========end======*/
~~~

* 修改头部空白栏高度

~~~css
/*头部空白栏高度*/
.valine-card .card-content {
    padding: 20px 20px 5px 20px;
}
~~~

### 调整`Valine`背景图

~~~css
/* valine 评论框增加背景图片 */
#vcomments textarea {
    /*背景图贴边*/
    margin-top: -30px;
    box-sizing: border-box;
    background: url("<%- url_for(theme.valine.background) %>") 100% 100% no-repeat;
}
~~~

### 点击回复在当前评论下方直接回复

~~~javascript
// 点击回复直接评论
$(document).ready(function () {
    $('.vemoji-btn').text('😀');
    $("#vcomments").on('click', 'span.vat', function () {
        $(this).parent('div.vmeta').next("div.vcontent").after($("div.vwrap"));
        $('textarea#veditor').focus();
    })
});
~~~

### 定义邮箱验证审核规则

~~~javascript
// 自定义邮箱审核规则
document.body.addEventListener('click', function (e) {
    if (e.target.classList.contains('vsubmit')) {
        const email = document.querySelector('input[type=email]');
        const nick = document.querySelector('input[name=nick]');
        const reg = /^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
        if (!email.value || !nick.value || !reg.test(email.value)) {
            const str = `<div class="valert text-center"><div class="vtext">请填写正确的昵称和邮箱！</div></div>`;
            const vmark = document.querySelector('.vmark');
            vmark.innerHTML = str;
            vmark.style.display = 'block';
            setTimeout(function () {
                vmark.style.display = 'none';
                vmark.innerHTML = '';
            }, 2500);
        }
    }
})
~~~

### 增加博主、小伙伴标识以及浏览器图标

* 修改主题配置文件为下

~~~yaml
valine:
  enable: true
  appId: *******************************
  appKey: *******************************
  master: 'MD5加密后的值'
  enableQQ: true # 默认值false/true
  notify: false
  verify: false
  visitor: false
  avatar: monsterid
  pageSize: 10
  placeholder: ヾﾉ≧∀≦)o来啊！,快活啊!
  background: https://cdn.jsdelivr.net/gh/drew233/cdn/20200409110727.webp
~~~

与原生的相比，魔改版`Valine`多了以下功能：

1. 添加博主，小伙伴，访客标签
2. 添加浏览器和操作系统图标，需引入 `fontawesome v5.0+` 的 CSS 样式
3. 邮箱检测更严格
4. 增加 QQ 邮箱识别（原版只能通过昵称栏输入 QQ 号识别）
5. meta placeholder 可自定义

使用方法与原生的类似，不同的是可以多设置几个参数：

| 参数            | 类型         | 说明                               | 默认                     | 示例                                         |
| --------------- | ------------ | ---------------------------------- | ------------------------ | -------------------------------------------- |
| tagMeta         | Array        | 标签要显示的文字                   | [“博主”,“小伙伴”,“访客”] | ["博主","小伙伴","访客"]                     |
| master          | Array/String | md5 加密后的博主邮箱               | []                       | ["fe01ce2a7fbac8fafaed7c982a04e229"]         |
| friends         | Array        | md5 加密后的小伙伴邮箱             | []                       | ["fe01ce2a7fbac8fafaed7c982a04e229"]         |
| metaPlaceholder | Object       | meta placeholder 内容              | {}                       | {“nick”:“昵称 / QQ 号”,“mail”:“邮箱 (必填)”} |
| verify          | Boolean      | 评论时是否需要验证，需 jQuery 支持 | false                    | true                                         |

举个例子，我们可以在 Valine 的配置 js 中增加字段如下：

```js
new Valine({
    el: '#vcomments',
    appId: '<%- theme.valine.appId %>',
    appKey: '<%- theme.valine.appKey %>',
    tagMeta: ["博主","小伙伴","访客"],
    master: '<%- theme.valine.master %>',
    enableQQ: '<%- theme.valine.enableQQ %>' === false,
    notify: '<%- theme.valine.notify %>' === 'true',
    verify: '<%- theme.valine.verify %>' === 'true',
    visitor: '<%- theme.valine.visitor %>' === 'true',
    avatar: '<%- theme.valine.avatar %>',
    pageSize: '<%- theme.valine.pageSize %>',
    lang: '<% if (config.language == "zh-CN") { %>zh-cn<% } else { %>en<% } %>',
    placeholder: '<%= theme.valine.placeholder %>'
});
```

以上在 Valine 的配置中加入参数就可以实现了，并且不影响原生的其它参数。MD5 加密可以推荐一个[在线生成网站](https://md5jiami.51240.com/)，不过 MD5 前端单次加密本身不安全，但是安不安全是相对的，只有邮箱信息本身价值不大。如果对博客安全要求比较高，希望留言的小伙伴邮箱不被泄露（这当然无法完全避免），那么还是不建议使用这个。

### 贴完整代码

```css
<style>
    .valine-card {
        margin: 1.5rem auto;
    }

    /*卡片式背景*/
    #vcomments .vcards .vcard {
        padding: 15px 20px 0 20px;
        border-radius: 10px;
        margin-bottom: 15px;
        box-shadow: 0 0 4px 1px rgba(0, 0, 0, .12);
        transition: all .3s
    }

    #vcomments .vcards .vcard:hover {
        box-shadow: 0 0 8px 3px rgba(0, 0, 0, .12)
    }

    #vcomments .vcards .vcard .vh .vcard {
        border: none;
        box-shadow: none;
    }

    /*鼠标放置头像旋转*/
    img.vimg {
        transition: all 1s /* 旋转时间为 1s */
    }

    img.vimg:hover {
        transform: rotate(360deg);
        -webkit-transform: rotate(360deg);
        -moz-transform: rotate(360deg);
        -o-transform: rotate(360deg);
        -ms-transform: rotate(360deg);
    }


    /*===========背景图输入判断=========*/
    #veditor:focus {
        background-position-y: 200px;
        transition: all 0.2s ease-in-out 0s;
    }

    /*==========修改评论框样式===========start====*/
    .v .vwrap {
        padding: 0 0 20px;
    }

    /*内容框高度*/
    .v .veditor {
        min-height: 7rem;
        resize: none;
    }

    /*==========修改评论框样式===========end======*/

    /*头部空白栏高度*/
    .valine-card .card-content {
        padding: 20px 20px 5px 20px;
    }

    /* valine 评论框增加背景图片 */
    #vcomments textarea {
        /*背景图贴边*/
        margin-top: -30px;
        box-sizing: border-box;
        background: url("<%- url_for(theme.valine.background) %>") 100% 100% no-repeat;
    }

    #vcomments p {
        margin: 2px 2px 10px;
        font-size: 1.05rem;
        line-height: 1.78rem;
    }

    #vcomments blockquote p {
        text-indent: 0.2rem;
    }

    /*回复颜色*/
    #vcomments a {
        padding: 0 2px;
        color: #4cbf30;
        font-weight: 500;
        text-decoration: none;
    }

    #vcomments img {
        max-width: 100%;
        height: auto;
        cursor: pointer;
    }

    #vcomments ol li {
        list-style-type: decimal;
    }

    #vcomments ol,
    ul {
        display: block;
        padding-left: 2em;
        word-spacing: 0.05rem;
    }

    #vcomments ul li,
    ol li {
        display: list-item;
        line-height: 1.8rem;
        font-size: 1rem;
    }

    #vcomments ul li {
        list-style-type: disc;
    }

    #vcomments ul ul li {
        list-style-type: circle;
    }

    #vcomments table, th, td {
        padding: 12px 13px;
        border: 1px solid #dfe2e5;
    }

    #vcomments table, th, td {
        border: 0;
    }

    table tr:nth-child(2n), thead {
        background-color: #fafafa;
    }

    #vcomments table th {
        background-color: #f2f2f2;
        min-width: 80px;
    }

    #vcomments table td {
        min-width: 80px;
    }

    #vcomments h1 {
        font-size: 1.85rem;
        font-weight: bold;
        line-height: 2.2rem;
    }

    #vcomments h2 {
        font-size: 1.65rem;
        font-weight: bold;
        line-height: 1.9rem;
    }

    #vcomments h3 {
        font-size: 1.45rem;
        font-weight: bold;
        line-height: 1.7rem;
    }

    #vcomments h4 {
        font-size: 1.25rem;
        font-weight: bold;
        line-height: 1.5rem;
    }

    #vcomments h5 {
        font-size: 1.1rem;
        font-weight: bold;
        line-height: 1.4rem;
    }

    #vcomments h6 {
        font-size: 1rem;
        line-height: 1.3rem;
    }

    #vcomments p {
        font-size: 1rem;
        line-height: 1.5rem;
    }

    #vcomments hr {
        margin: 12px 0;
        border: 0;
        border-top: 1px solid #ccc;
    }

    #vcomments blockquote {
        margin: 15px 0;
        border-left: 5px solid #42b983;
        padding: 1rem 0.8rem 0.3rem 0.8rem;
        color: #666;
        background-color: rgba(66, 185, 131, .1);
    }

    #vcomments pre {
        font-family: monospace, monospace;
        padding: 1.2em;
        margin: .5em 0;
        background: #272822;
        overflow: auto;
        border-radius: 0.3em;
        tab-size: 4;
    }

    #vcomments code {
        font-family: monospace, monospace;
        padding: 1px 3px;
        font-size: 0.92rem;
        color: #e96900;
        background-color: #f8f8f8;
        border-radius: 2px;
    }

    #vcomments pre code {
        font-family: monospace, monospace;
        padding: 0;
        color: #e8eaf6;
        background-color: #272822;
    }

    #vcomments pre[class*="language-"] {
        padding: 1.2em;
        margin: .5em 0;
    }

    #vcomments code[class*="language-"],
    pre[class*="language-"] {
        color: #e8eaf6;
    }

    #vcomments [type="checkbox"]:not(:checked), [type="checkbox"]:checked {
        position: inherit;
        margin-left: -1.3rem;
        margin-right: 0.4rem;
        margin-top: -1px;
        vertical-align: middle;
        left: unset;
        visibility: visible;
    }

    #vcomments b,
    strong {
        font-weight: bold;
    }

    #vcomments dfn {
        font-style: italic;
    }

    #vcomments small {
        font-size: 85%;
    }

    #vcomments cite {
        font-style: normal;
    }

    #vcomments mark {
        background-color: #fcf8e3;
        padding: .2em;
    }

    #vcomments table, th, td {
        padding: 12px 13px;
        border: 1px solid #dfe2e5;
    }

    table tr:nth-child(2n), thead {
        background-color: #fafafa;
    }

    #vcomments table th {
        background-color: #f2f2f2;
        min-width: 80px;
    }

    #vcomments table td {
        min-width: 80px;
    }

    #vcomments [type="checkbox"]:not(:checked), [type="checkbox"]:checked {
        position: inherit;
        margin-left: -1.3rem;
        margin-right: 0.4rem;
        margin-top: -1px;
        vertical-align: middle;
        left: unset;
        visibility: visible;
    }
</style>

<div class="card valine-card" data-aos="fade-up">
    <div id="vcomments" class="card-content" style="display: grid"></div>
</div>

<script src="<%- theme.jsDelivr.url %><%- url_for('/libs/valine/av-min.js') %>"></script>
<script src="<%- theme.jsDelivr.url %><%- url_for(theme.libs.js.valine) %>"></script>
<script>
    new Valine({
        el: '#vcomments',
        appId: '<%- theme.valine.appId %>',
        appKey: '<%- theme.valine.appKey %>',
        tagMeta: ["博主","小伙伴","访客"],
        master: '<%- theme.valine.master %>',
        enableQQ: '<%- theme.valine.enableQQ %>' === false,
        notify: '<%- theme.valine.notify %>' === 'true',
        verify: '<%- theme.valine.verify %>' === 'true',
        visitor: '<%- theme.valine.visitor %>' === 'true',
        avatar: '<%- theme.valine.avatar %>',
        pageSize: '<%- theme.valine.pageSize %>',
        lang: '<% if (config.language == "zh-CN") { %>zh-cn<% } else { %>en<% } %>',
        placeholder: '<%= theme.valine.placeholder %>'
    });
    // 点击回复直接评论
    $(document).ready(function () {
        $('.vemoji-btn').text('😀');
        $("#vcomments").on('click', 'span.vat', function () {
            $(this).parent('div.vmeta').next("div.vcontent").after($("div.vwrap"));
            $('textarea#veditor').focus();
        })
    });
    // 自定义邮箱审核规则
    document.body.addEventListener('click', function (e) {
        if (e.target.classList.contains('vsubmit')) {
            const email = document.querySelector('input[type=email]');
            const nick = document.querySelector('input[name=nick]');
            const reg = /^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
            if (!email.value || !nick.value || !reg.test(email.value)) {
                const str = `<div class="valert text-center"><div class="vtext">请填写正确的昵称和邮箱！</div></div>`;
                const vmark = document.querySelector('.vmark');
                vmark.innerHTML = str;
                vmark.style.display = 'block';
                setTimeout(function () {
                    vmark.style.display = 'none';
                    vmark.innerHTML = '';
                }, 2500);
            }
        }
    })
</script>
```

> 参考博文：[博客Valine评论样式美化](https://bestzuo.cn/posts/763113948.html)
