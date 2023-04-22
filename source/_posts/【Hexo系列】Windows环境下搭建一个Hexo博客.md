---
title: 【Hexo系列】Windows环境下搭建一个Hexo博客
author: 墨白
top: true
cover: false
toc: true
mathjax: false
tags:
  - 博客搭建
categories:
  - Hexo
abbrlink: 3211381432
date: 2019-12-25 17:25:26
img:
coverImg:
password:
summary:
---

<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=100% height=86 src="//music.163.com/outchain/player?type=2&id=433103084&auto=0&height=66"></iframe>

## 最近将博客开源到码云和Coding了,[码云传送门]( https://gitee.com/mobaijun/mobai_hexoBlog ),[GitHub传送门]( https://github.com/mobaijun8/hexo_blog_matery)

一直说要出一篇从零搭建博客的教程,但是最近真的很忙,一直没有时间,尽量抽出时间将博客教程写出来了,如下,阅读本文需要你有以下技术储备:

| Git        | 熟练 |
| ---------- | ---- |
| JavaScript | 熟练 |
| node.js    | 熟练 |
| CV大法     | 精通 |

如果你遇到了不明白或者无法解决的异常,请你在以下几个联系方式找到我

* 邮箱: mobaijun@163.com

* 微信交流群:请在关于我找到入群方法

下面就直接开始搭建属于我们自己的博客吧,搭建博客之前需要你的本地电脑环境包含git和node.js

* [ Git安装地址 ]( https://git-scm.com/ )

* [node.js安装地址]( https://nodejs.org/en/ )

安装过程不在赘述,官网有详细介绍,下面跟着我的步骤一起来搭建博客

## 配置国内镜像源

任意位置打开你的`git bash` ,输入以下命令

~~~bash
$ npm config set registry https://registry.npm.taobao.org
~~~

## 安装Hexo

命令如下

~~~bash
$ npm install -g hexo-cli
~~~

安装完后输入`hexo -v`验证是否安装成功。

至此`hexo`就安装完了。

接下来初始化一下`hexo`,即初始化我们的网站，输入`hexo init`初始化文件夹

~~~bash
$ hexo init "BlogName"

$ cd "BlogName"      //进入这个"BlogName"文件夹

$ npm install
~~~

 新建完成后，指定文件夹`BlogName`目录下有： 

* `node_modules:` 依赖包
* `public：`存放生成的页面
* `scaffolds：`生成文章的一些模板
* `source：`用来存放你的文章
* `themes：`主题
* `_config.yml:` 博客的配置文件

 这样本地的网站配置也弄好啦，输入`hexo g`生成静态网页，然后输入`hexo s`打开本地服务器 

~~~bash
$ hexo g
$ hexo server(或者简写:hexo s）)
~~~

 然后浏览器打开`http://localhost:4000/`，就可以看到我们的博客啦，效果如下： 

![](https://tencent.cos.mobaijun.com/img/blog/【Hexo系列】Windows环境下搭建一个Hexo博客/0.png)

## 安装主题

我使用的是`matery`主题,传送地址[传送门]( https://github.com/blinkfox/hexo-theme-matery ),进入这个地址直接`clone`到你博客目录的`themes`下即可,这个主题看着比较漂亮，并且响应式比较友好，点起来很舒服，功能也比较很多。 如果不喜欢这个主题可以去官网自行查找,[传送门]( https://hexo.io/themes/ )

> 特性： 

- 简单漂亮，文章内容美观易读
- [Material Design](https://material.io/) 设计
- 响应式设计，博客在桌面端、平板、手机等设备上均能很好的展现
- 首页轮播文章及每天动态切换 `Banner` 图片
- 瀑布流式的博客文章列表（文章无特色图片时会有 `24` 张漂亮的图片代替）
- 时间轴式的归档页
- **词云**的标签页和**雷达图**的分类页
- 丰富的关于我页面（包括关于我、文章统计图、我的项目、我的技能、相册等）
- 可自定义的数据的友情链接页面
- 支持文章置顶和文章打赏
- 支持 `MathJax`
- `TOC` 目录
- 可设置复制文章内容时追加版权信息
- 可设置阅读文章时做密码验证
- [Gitalk](https://gitalk.github.io/)、[Gitment](https://imsun.github.io/gitment/)、[Valine](https://valine.js.org/) 和 [Disqus](https://disqus.com/) 评论模块（推荐使用 `Gitalk`）
- 集成了[不蒜子统计](http://busuanzi.ibruce.info/)、谷歌分析（`Google Analytics`）和文章字数统计等功能
- 支持在首页的音乐播放和视频播放功能
- 支持`emoji`表情，用`markdown emoji`语法书写直接生成对应的能**跳跃**的表情。
- 支持 [DaoVoice](http://www.daovoice.io/)、[Tidio](https://www.tidio.com/) 在线聊天功能。

 他的介绍文档写得非常的详细，还有中英文两个版本。效果图如下： 

![]( https://mobaijun.gitee.io/mobai_images.gitee.io/img/hexo/1.png )

首先先按照文档教程安装一遍主题，然后是可以正常打开的，如果你是一般使用的话，基本没啥问题了。不过有些地方可以根据你自己的习惯和喜好修改一下， 下面记录一下我这个博客修改了的一些地方。

##  新建文章模板修改

 首先为了新建文章方便，我们可以修改一下文章模板，建议将`/scaffolds/post.md`修改为如下代码： 

~~~yaml
title: {{ title }}
date: {{ date }}
author: 墨白
img: /medias/featureimages/.jpg
coverImg: /medias/featureimages/.jpg
top: false
cover: false
abbrlink: 
toc: true
mathjax: false
password: 
summary: 
tags: 
	- 
	- 
	- 
	- 
	- 
categories: 
	- 
~~~

这样新建文章后 一些`Front-matter`参数不用你自己补充了，修改对应信息就可以了。

## 个性化配置

### 添加404页面

 原来的主题没有`404`页面，我们加一个。首先在`/source/`目录下新建一个`404.md`，内容如下： 

~~~yaml
title: 404
date: 2019-08-5 16:41:10
type: "404"
layout: "404"
description: "Oops～，我崩溃了！找不到你想要的页面 :("
~~~

 然后在`/themes/matery/layout/`目录下新建一个`404.ejs`文件，内容如下： 

~~~javascript
<style type="text/css">
    /* don't remove. */
    .about-cover {
        height: 75vh;
    }
</style>

<div class="bg-cover pd-header about-cover">
    <div class="container">
        <div class="row">
            <div class="col s10 offset-s1 m8 offset-m2 l8 offset-l2">
                <div class="brand">
                    <div class="title center-align">
                        404
                    </div>
                    <div class="description center-align">
                        <%= page.description %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 每天切换 banner 图.  Switch banner image every day.
    $('.bg-cover').css('background-image', 'url(/medias/banner/' + new Date().getDay() + '.jpg)');
</script>
~~~

### “关于”页面增加简介

 修改`/themes/matery/layout/about.ejs`，找到``标签，然后找到它对应的``标签，接在后面新增一个`card`，语句如下： 

~~~javascript
<div class="card">
    <div class="card-content">
        <div class="card-content article-card-content">
                <div class="title center-align" data-aos="zoom-in-up">
                    <i class="fa fa-address-book"></i>&nbsp;&nbsp;<%- __('myCV') %>
                </div>
                <div id="articleContent" data-aos="fade-up">
                    <%- page.content %>
                </div>
        </div>
    </div>
</div>
~~~

### 修改文章分页以后依然加载头部音乐,视频,格言等模块

找到你的目录`\themes\matery\layout\index.ejs`,删除以下代码

~~~javascript
<main class="content">

    <% if (page.current === 1
            && (theme.dream.enable || (theme.music.enable && !theme.music.fixed))
                    || theme.video.enable || theme.recommend.enable) { %>
    <div id="indexCard" class="index-card">
        <div class="container ">
            <div class="card">
                <div class="card-content">
                    <% if (theme.dream.enable) { %>
                        <%- partial('_widget/dream') %>
                    <% } %>

                    <% if (theme.music.enable && site.data && site.data.musics && !theme.music.fixed) { %>
                        <%- partial('_widget/music') %>
                    <% } %>

                    <% if (theme.video.enable) { %>
                        <%- partial('_widget/video') %>
                    <% } %>

                    <% if (theme.recommend.enable) { %>
                    <div id="recommend-sections" class="recommend">
                        <%- partial('_widget/recommend') %>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
~~~

修改后的代码

~~~javascript
<main class="content">
    <% if (page.current === 1 ) { %>
        <div id="indexCard" class="index-card">
            <div class="container ">
                <div class="card">
                    <div class="card-content">
                        <% if (theme.dream.enable) { %>
                            <%- partial('_widget/dream') %>
                        <% } %>

                        <% if (theme.music.enable && site.data && site.data.musics && !theme.music.fixed) { %>
                            <%- partial('_widget/music') %>
                        <% } %>

                        <% if (theme.video.enable) { %>
                            <%- partial('_widget/video') %>
                        <% } %>

                        <% if (theme.recommend.enable) { %>
                            <div id="recommend-sections" class="recommend">
                                <%- partial('_widget/recommend') %>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    <% } %>
~~~

### 添加图片懒加载功能

安装插件

~~~bash
$ npm install hexo-lazyload-image --save
~~~

然后在你的` Hexo` 目录的配置文件 `_config.yml` 中添加配置:

```yaml
# 懒加载
lazyload:
  enable: true
  onlypost: false
  loadingImg: https://cdn.jsdelivr.net/gh/shw2018/cdn@1.0/sakura/img/loader/orange.progress-bar-stripe-loader.svg
```

**onlypost**
是否仅文章中的图片做懒加载, 如果为 `false`, 则主题中的其他图片, 也会做懒加载, 如头像, `logo` 等任何图片.

**loadingImg - 图片未加载时的代替图**

* 不填写使用默认加载图片, 如果需要自定义，添填入 `loading` 图片地址，如果是本地图片，不要忘记把图片添加到你的主题目录下。 `Next` 主题需将图片放到 `\themes\next\source\images` 目录下, 然后引用时: `loadingImg: /images/图片文件名`

### 优化友情链接

> 2019-12-27 16:13😀😀

这里中间出现了一个白色框框,看着很不舒服,尤其是有强迫症的人 ,定位到`themes\matery\layout\friends.ejs`这个文件

大概在229行代码左右,注释掉多余的代码

~~~javascript
<div class="card">
    <div class="card-content">
        <%- page.content %>
    </div>
</div>
~~~

### 给代码块添加行号

> 2019-12-30 19:31:14😁😁😁

打开博客根目录下的`.yml`配置文件,修改为如下代码

~~~yaml
# 开启行号
prism_plugin:
  mode: 'preprocess'    # realtime/preprocess
  theme: 'tomorrow'
  line_number: true    # default false
  custom_css:
~~~

找到`themes\matery\source\css\matery.css`文件,定位到`pre`,修改为如下代码;

~~~css
pre {
    padding: 1.5rem 1.5rem 1.5rem 3.3rem !important;
    margin: 1rem 0 !important;
    background: #272822;
    overflow: auto;
    border-radius: 0.35rem;
    tab-size: 4;
}
~~~

往下滑一下,定位到`code`,修改为如下代码:

~~~css
code {
    padding: 1px 5px;
    top: 13px !important;
    font-family: Inconsolata, Monaco, Consolas, 'Courier New', Courier, monospace;
    /*font-size: 0.91rem;*/
    color: #e96900;
    background-color: #f8f8f8;
    border-radius: 2px;
}
~~~

### 添加鼠标点击烟花爆炸效果

> 2019-12-28 11:38:14😀😀

在主题`\themes\matery\source\js\fireworks.js`新建文件,添加如下代码

<a id="download" href="http://49.235.106.229/js/fireworks.js" target="_blank" rel="noopener"><i class="fa fa-download"></i><span> Download Now</span><br></a>

 然后在` /themes/matery/layout/layout.ejs `中添加如下代码： 

~~~javascript
<% if (theme.fireworks.enable) { %>
<canvas class="fireworks" style="position: fixed; left: 0; top: 0; z-index: 1; pointer-events: none;" ></canvas>
<script type="text/javascript" src="//cdn.bootcss.com/animejs/2.2.0/anime.min.js"></script>
<script type="text/javascript" src="/js/fireworks.js"></script>
<% } %>
~~~

 在主题配置文件 `.yml`中配置: 

~~~yaml
# 鼠标点击烟花爆炸动效
fireworks:
  enable: true
~~~

### 添加雪花飘落特效

> 2019-12-28 13:00:55😀😀

在主题`\themes\matery\source\js\xuehuapiaoluo.js`新建文件,添加如下代码

[ Download Now](http://49.235.106.229/js/xuehuapiaoluo.js)

然后在 `/themes/matery/layout/layout.ejs` 中添加如下代码：

~~~javascript
<!-- 背景雪花飘落特效-->
<% if (theme.xuehuapiaoluo.enable) { %>
    <script type="text/javascript">
        //只在桌面版网页启用特效
        var windowWidth = $(window).width();
        if (windowWidth > 768) {
            document.write('<script type="text/javascript" src="/js/xuehuapiaoluo.js"><\/script>');
        } </script>
<% } %>
~~~

在主题配置文件 `.yml`中配置: 

~~~yaml
# 背景雪花飘落特效
xuehuapiaoluo:
  enable: true
~~~

### 添加樱花飘落特效

> 2019-12-28 13:00:55😀😀

在主题`\themes\matery\source\js\sakura.js`新建文件,添加如下代码

[ Download Now](http://49.235.106.229/js/sakura.js)

然后在 `/themes/matery/layout/layout.ejs` 中添加如下代码：

~~~javascript
<!-- 背景樱花飘落特效-->
<% if (theme.sakura.enable) { %>
    <script type="text/javascript">
        //只在桌面版网页启用特效
        var windowWidth = $(window).width();
        if (windowWidth > 768) {
            document.write('<script type="text/javascript" src="/js/sakura.js"><\/script>');
        } </script>
<% } %>
~~~

在主题配置文件 `.yml`中配置: 

~~~yaml
# 背景樱花飘落特效
sakura:
  enable: true
~~~

### 添加鼠标点击文字特效

> 2019-12-28 13:15:22😀😀

在主题`\themes\matery\source\js\wenzi.js`新建文件,添加如下代码

~~~js
/* 鼠标点击文字特效 */
var a_idx = 0;
jQuery(document).ready(function($) {
    $("body").click(function(e) {
        var a = new Array("❤富强❤","❤民主❤","❤文明❤","❤和谐❤","❤自由❤","❤平等❤","❤公正❤","❤法治❤","❤爱国❤","❤敬业❤","❤诚信❤","❤友善❤");
        // var a = new Array("富强","民主","文明","和谐","自由","平等","公正","法治","爱国","敬业","诚信","友善");
        var $i = $("<span></span>").text(a[a_idx]);
        a_idx = (a_idx + 1) % a.length;
        var x = e.pageX,
        y = e.pageY;
        $i.css({
            "z-index": 999999999999999999999999999999999999999999999999999999999999999999999,
            "top": y - 20,
            "left": x,
            "position": "absolute",
            "font-weight": "bold",
            "color": "rgb("+~~(255*Math.random())+","+~~(255*Math.random())+","+~~(255*Math.random())+")"
        });
        $("body").append($i);
        $i.animate({
            "top": y - 180,
            "opacity": 0
        },
        1500,
        function() {
            $i.remove();
        });
    });
});
~~~

然后在 `/themes/matery/layout/layout.ejs` 中添加如下代码：

~~~javascript
<!-- 鼠标点击文字特效-->
<% if (theme.wenzi.enable) { %>
    <script src="/js/wenzi.js" type="text/javascript"></script>
<% } %>
~~~

在主题配置文件 `.yml`中配置: 

~~~yaml
# 鼠标点击文字特效
fireworks:
  enable: true
~~~

### 优化Hexo文章短链接

安装插件

~~~bash
$ npm install hexo-abbrlink --save
~~~

 然后在 Hexo 的**根目录**的配置文件`_config.yml` 中修改： 

~~~yaml
# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: https://mobaijun.com
root: /
# permalink: :year/:month/:day/:title/
permalink: posts/:abbrlink.html
#abbrlink配置
abbrlink:
  alg: crc32  # 算法：crc16(default) and crc32
  rep: dec    # 进制：dec(default) and hex
permalink_defaults:
  lang: en
~~~

 之后再`scaffolds\post.md`文件开头中加入以下信息 

~~~yaml
title: {{ title }}
date: {{ date }}
author: 墨白
img: /medias/featureimages/.jpg
coverImg: /medias/featureimages/.jpg
top: false
cover: false
# 添加了abbrlink
abbrlink: 
toc: true
mathjax: false
password: 
summary: 
tags: 
	- 
	- 
	- 
	- 
	- 
categories: 
	- 
~~~

> 如果文章中未指定 `abbrlink: xxx`，将会根据算法随机生成数字

这样就确保了博文链接的唯一化，只要不修改` md` 文件的 `abbrlink` 的值，`url `就永久不会改变。如此 `md` 文件名和文件内容也可以随便改了。这样也有利于 `SEO` 优化。

### 添加电影模块

新建电影页面

~~~sh
$ hexo new page movies
~~~

在主题的配置文件添加导航栏,如果需要二级菜单,就参考`matery`主题里面的配置

~~~yaml
menu:
  Index:
    url: /
    icon: fas fa-home
  Tags:
    url: /tags
    icon: fas fa-tags
  Categories:
    url: /categories
    icon: fas fa-bookmark
  Archives:
    url: /archives
    icon: fas fa-archive
  电影:
    url: /movies
    icon: fas fa-film
  About:
    url: /about
    icon: fas fa-user-circle
  留言板:
    url: /contact
    icon: fas fa-comments
  友情链接:
    url: /friends
    icon: fas fa-address-book
~~~

安装插件

```bash
$ npm install hexo-douban --save
```

 将下面的配置写入`hexo`根目录配置文件 `_config.yml` 里(不是主题的配置文件). 

~~~yaml
douban:
  user: mythsman
  builtin: false
  book:
    title: 'This is my book title'
    quote: 'This is my book quote'
  movie:
    title: 'This is my movie title'
    quote: 'This is my movie quote'
  game:
    title: 'This is my game title'
    quote: 'This is my game quote'
  timeout: 10000 
~~~

user: 你的豆瓣ID.打开豆瓣，登入账户，然后在右上角点击 “个人主页” ，这时候地址栏的URL大概是这样：”https://www.douban.com/people/xxxxxx/" ，其中的”xxxxxx”就是你的个人ID了。
`builtin:` 是否将生成页面的功能嵌入`hexo s`和`hexo g`中，默认是`false`,另一可选项为`true`(1.x.x版本新增配置项)。
`title`: 该页面的标题.
`quote`: 写在页面开头的一段话,支持html语法.
`timeout`: 爬取数据的超时时间，默认是 `10000ms` ,如果在使用时发现报了超时的错(ETIMEOUT)可以把这个数据设置的大一点。
如果只想显示某一个页面(比如`movie`)，那就把其他的配置项注释掉即可。

菜单参考，一定要有图标，不然不显示

~~~yaml
menu:
  豆瓣:
    url: /
    icon: fa-heart 
    children:
      - 
        name: 书单
        url: /books     # 这是链接到books页面
        icon: fa-book
      - 
        name: 电影
        url: /movies     # 这是链接到books页面
        icon: fa-film
      - 
        name: 游戏
        url: /games     # 这是链接到books页面
        icon: fa-gamepad
~~~

升级(可选操作)

```bash
$ npm install hexo-douban --update --save
```

### Gitalk评论功能

[点击]( https://github.com/settings/applications/new )注册，注意`Authorization callback URL`填自己的网站`url`, 比如我的 https://mobaijun.com/

你会得到一个 `client ID` 和一个 `client secret`, 在主题文件下的`_config.yml`中配置,找到`Gitalk`进行配置

~~~yaml
# the Gitalk config，default disabled
# Gitalk 评论模块的配置，默认为不激活
gitalk:
  enable: true
  owner: mobaijun8
  repo: 仓库地址
  oauth:
    clientId: 照着填
    clientSecret: 照着填
  admin:
    - mobaijun8
~~~

### 去除valine版权信息

`valine`评论框里的版权信息，不是那么美观，而且占用网页空间。不如把他去掉吧。
找到`valine`的`js`文件存放地址`\themes\matery\source\libs\valine`，这个文件夹下有两个文件。

* `av-min.js`

* `Valine.min.js`

  打开`Valine.min.js`文件。查找`Powered`关键词，定位到版权信息的位置。将以下内容替换为单引号`'`

```javascript
<div class="info"><div class="power txt-right">Powered By<ahref="https://valine.js.org" target="_blank">Valine</a><br>v'+o+"</div></div>"
```

### 给博客增加动态标签

实现方式:

打开博客路径`themes/matery/layout/layout.ejs`找个合适的位置添加如下代码

~~~javascript
<!-- 博客标签动态提示 -->
<script type="text/javascript">
    var OriginTitile = document.title,
        st;
    document.addEventListener("visibilitychange", function () {
        document.hidden ? (document.title = "看不见我🙈~看不见我🙈~", clearTimeout(st)) : (document.title =
            "(๑•̀ㅂ•́) ✧被发现了～", st = setTimeout(function () {
            document.title = OriginTitile
        }, 3e3))
    })
</script>
~~~

## 添加博客引流到公众号

> 2020-12-19 12:53

注意: 前往 [OpenWrite](https://openwrite.cn/) 后台申请开通 `readmore` 功能后,**一定要替换成自己的相关配置**!

> 其中,配置参数含义如下:
>
> * `blogId` : [必选]OpenWrite 后台申请的博客唯一标识,例如:15702-1569305559839-744
> * `name` : [必选]OpenWrite 后台申请的博客名称,例如:雪之梦技术驿站
> * `qrcode` : [必选]OpenWrite 后台申请的微信公众号二维码,例如:https://cdn.jsdelivr.net/gh/mobaijun/blog_css_js/image/about.png
> * `keyword` : [必选]OpenWrite 后台申请的微信公众号后台回复关键字,例如:vip

定位到博客根目录，下载插件

~~~bash
$ npm install hexo-plugin-readmore --save
~~~

修改博客根目录配置文件，添加如下配置

~~~yaml
# 博客引流插件
plugins:
  readmore:
    blogId: 申请的博客id
    name: 框架师
    qrcode: https://cdn.jsdelivr.net/gh/mobaijun/blog_css_js/image/about.png
    keyword: 阅读
~~~

> 安装完以上插件会导致文章目录toc无法跳转，慎用

### 友链头像旋转

> 2020-12-19 11:48

定位到`themes/matery/source/css/matery.css`，末尾添加如下代码

~~~css
/*设置头像旋转*/
.frind-ship .title img {
    object-fit: contain;
    transition: all 1s;
}

.friend-div:hover .title img {
    transform: rotate(360deg);
    -ms-transform: rotate(360deg);
    -moz-transform: rotate(360deg);
    -webkit-transform: rotate(360deg);
    -o-transform: rotate(360deg);
}
~~~

### 添加动态格言

定位到`themes/matery/layout/_widget/dream.ejs`

~~~javascript
<div class="row">
        <div class="col l8 offset-l2 m10 offset-m1 s10 offset-s1 center-align text">
            <!-- 原数据<%- theme.dream.text %> -->
            <!-- 设置格言自动更新 -->
            <span id="hitokoto"><%- theme.dream.text %></span>
            <script src="https://v1.hitokoto.cn/?encode=js&select=%23hitokoto" defer></script>
</div>
~~~

### 添加每日诗词

定位到`themes/matery/layout/_partial/bg-cover-content.ejs`修改为如下代码

~~~javascript
<!-- <span id="subtitle"></span>-->
                    <!--<script src="https://cdn.jsdelivr.net/npm/typed.js@2.0.11"></script>-->
                    <!--<script>-->
                    <!-- var typed = new Typed("#subtitle", {-->
                    <!-- strings: ['<%= theme.subtitle.sub1 %>', '<%= theme.subtitle.sub2 %>'],-->
                    <!-- startDelay: <%= theme.subtitle.startDelay %>,-->
                    <!-- typeSpeed: <%= theme.subtitle.typeSpeed %>,-->
                    <!-- loop: <%= theme.subtitle.loop %>,-->
                    <!-- backSpeed: <%= theme.subtitle.backSpeed %>,-->
                    <!-- showCursor: <%= theme.subtitle.showCursor %>-->
                    <!--});-->
                    <!--</script>-->
                    <!--  添加每日诗词 -->
                    <span id="jinrishici-sentence"><%= config.description %></span>
                    <script src="https://sdk.jinrishici.com/v2/browser/jinrishici.js" charset="utf-8"></script>
                <% } else { %>
                    <%= config.description %>
                <% } %>
~~~

###  **屏蔽网页源码（单纯的屏蔽鼠标右键和键盘事件）**

 在 `themes/matery/layout/layout.ejs` 添加如下代码 

找个合适的位置添加如下代码

~~~javascript
/*屏蔽网页源码*/
<script type="text/javascript">
        window.onload = function(){
            //屏蔽键盘事件
            document.onkeydown = function (){
                var e = window.event || arguments[0];
                //F12
                if(e.keyCode == 123){
                    return false;
                //Ctrl+Shift+I
                }else if((e.ctrlKey) && (e.shiftKey) && (e.keyCode == 73)){
                    return false;
                //Shift+F10
                }else if((e.shiftKey) && (e.keyCode == 121)){
                    return false;
                //Ctrl+U
                }else if((e.ctrlKey) && (e.keyCode == 85)){
                    return false;
                }
            };
            //屏蔽鼠标右键
            document.oncontextmenu = function (){
                return false;
            }
        }
</script>
~~~

### Gulp实现代码压缩

#### 安装gulp

```bash
$ npm install gulp -g
# 查看版本
$ gulp -v
```

#### 安装gulp插件

```bash
$ npm install gulp --save
$ npm install gulp-minify-css --save
$ npm install gulp-uglify --save
$ npm install gulp-htmlmin --save
$ npm install gulp-htmlclean --save
$ npm install gulp-imagemin --save
# 解决【Gulp打包问题】 GulpUglifyError: unable to minify JavaScript
# 解决 gulp-uglify 压缩JavaScript 不兼容 es5 语法的问题
$ npm install babel-core@6.26.3 --save
$ npm install gulp-babel@7.0.1 --save
$ npm install babel-preset-es2015@6.24.1 --save
# gulp-babel 取消严格模式方法("use strict")
$ npm install babel-plugin-transform-remove-strict-mode --save
```

>  问题：如果安装`gulp-imagemin`错误请执行以下语句
> `sudo npm i gulp-imagemin --unsafe-perms` 

 在 Hexo 站点下新建`gulpfile.js`文件，文件内容如下： 

~~~js
var gulp = require("gulp");
var debug = require("gulp-debug");
var cleancss = require("gulp-clean-css"); //css压缩组件
var uglify = require("gulp-uglify"); //js压缩组件
var htmlmin = require("gulp-htmlmin"); //html压缩组件
var htmlclean = require("gulp-htmlclean"); //html清理组件
var imagemin = require("gulp-imagemin"); //图片压缩组件
var changed = require("gulp-changed"); //文件更改校验组件
var gulpif = require("gulp-if"); //任务 帮助调用组件
var plumber = require("gulp-plumber"); //容错组件（发生错误不跳出任务，并报出错误内容）
var isScriptAll = true; //是否处理所有文件，(true|处理所有文件)(false|只处理有更改的文件)
var isDebug = true; //是否调试显示 编译通过的文件
var gulpBabel = require("gulp-babel");
var es2015Preset = require("babel-preset-es2015");
var del = require("del");
var Hexo = require("hexo");
var hexo = new Hexo(process.cwd(), {}); // 初始化一个hexo对象

// 清除public文件夹
gulp.task("clean", function () {
    return del(["public/**/*"]);
});

// 下面几个跟hexo有关的操作，主要通过hexo.call()去执行，注意return
// 创建静态页面 （等同 hexo generate）
gulp.task("generate", function () {
    return hexo.init().then(function () {
        return hexo
            .call("generate", {
                watch: false
            })
            .then(function () {
                return hexo.exit();
            })
            .catch(function (err) {
                return hexo.exit(err);
            });
    });
});

// 启动Hexo服务器
gulp.task("server", function () {
    return hexo
        .init()
        .then(function () {
            return hexo.call("server", {});
        })
        .catch(function (err) {
            console.log(err);
        });
});

// 部署到服务器
gulp.task("deploy", function () {
    return hexo.init().then(function () {
        return hexo
            .call("deploy", {
                watch: false
            })
            .then(function () {
                return hexo.exit();
            })
            .catch(function (err) {
                return hexo.exit(err);
            });
    });
});

// 压缩public目录下的js文件
gulp.task("compressJs", function () {
    return gulp
        .src(["./public/**/*.js", "!./public/libs/**"]) //排除的js
        .pipe(gulpif(!isScriptAll, changed("./public")))
        .pipe(gulpif(isDebug, debug({title: "Compress JS:"})))
        .pipe(plumber())
        .pipe(
            gulpBabel({
                presets: [es2015Preset] // es5检查机制
            })
        )
        .pipe(uglify()) //调用压缩组件方法uglify(),对合并的文件进行压缩
        .pipe(gulp.dest("./public")); //输出到目标目录
});

// 压缩public目录下的css文件
gulp.task("compressCss", function () {
    var option = {
        rebase: false,
        //advanced: true,               //类型：Boolean 默认：true [是否开启高级优化（合并选择器等）]
        compatibility: "ie7" //保留ie7及以下兼容写法 类型：String 默认：''or'*' [启用兼容模式； 'ie7'：IE7兼容模式，'ie8'：IE8兼容模式，'*'：IE9+兼容模式]
        //keepBreaks: true,             //类型：Boolean 默认：false [是否保留换行]
        //keepSpecialComments: '*'      //保留所有特殊前缀 当你用autoprefixer生成的浏览器前缀，如果不加这个参数，有可能将会删除你的部分前缀
    };
    return gulp
        .src(["./public/**/*.css", "!./public/**/*.min.css"]) //排除的css
        .pipe(gulpif(!isScriptAll, changed("./public")))
        .pipe(gulpif(isDebug, debug({title: "Compress CSS:"})))
        .pipe(plumber())
        .pipe(cleancss(option))
        .pipe(gulp.dest("./public"));
});

// 压缩public目录下的html文件
gulp.task("compressHtml", function () {
    var cleanOptions = {
        protect: /<\!--%fooTemplate\b.*?%-->/g, //忽略处理
        unprotect: /<script [^>]*\btype="text\/x-handlebars-template"[\s\S]+?<\/script>/gi //特殊处理
    };
    var minOption = {
        collapseWhitespace: true, //压缩HTML
        collapseBooleanAttributes: true, //省略布尔属性的值  <input checked="true"/> ==> <input />
        removeEmptyAttributes: true, //删除所有空格作属性值    <input id="" /> ==> <input />
        removeScriptTypeAttributes: true, //删除<script>的type="text/javascript"
        removeStyleLinkTypeAttributes: true, //删除<style>和<link>的type="text/css"
        removeComments: true, //清除HTML注释
        minifyJS: true, //压缩页面JS
        minifyCSS: true, //压缩页面CSS
        minifyURLs: true //替换页面URL
    };
    return gulp
        .src("./public/**/*.html")
        .pipe(gulpif(isDebug, debug({title: "Compress HTML:"})))
        .pipe(plumber())
        .pipe(htmlclean(cleanOptions))
        .pipe(htmlmin(minOption))
        .pipe(gulp.dest("./public"));
});

// 压缩 public/uploads 目录内图片
gulp.task("compressImage", function () {
    var option = {
        optimizationLevel: 5, //类型：Number  默认：3  取值范围：0-7（优化等级）
        progressive: true, //类型：Boolean 默认：false 无损压缩jpg图片
        interlaced: false, //类型：Boolean 默认：false 隔行扫描gif进行渲染
        multipass: false //类型：Boolean 默认：false 多次优化svg直到完全优化
    };
    return gulp
        .src("./public/medias/**/*.*")
        .pipe(gulpif(!isScriptAll, changed("./public/medias")))
        .pipe(gulpif(isDebug, debug({title: "Compress Images:"})))
        .pipe(plumber())
        .pipe(imagemin(option))
        .pipe(gulp.dest("./public"));
});
// 执行顺序： 清除public目录 -> 产生原始博客内容 -> 执行压缩混淆 -> 部署到服务器
gulp.task(
    "build",
    gulp.series(
        "clean",
        "generate",
        "compressHtml",
        "compressCss",
        "compressJs",
        "compressImage",
        gulp.parallel("deploy")
    )
);

// 默认任务
gulp.task(
    "default",
    gulp.series(
        "clean",
        "generate",
        gulp.parallel("compressHtml", "compressCss", "compressImage", "compressJs")
    )
);
//Gulp4最大的一个改变就是gulp.task函数现在只支持两个参数，分别是任务名和运行任务的函数
~~~

 只需要每次在执行 `generate` 命令后执行 `gulp` 就可以实现对静态资源的压缩，压缩完成后执行 `deploy` 命令同步到服务器： 

~~~bash
$ hexo g
$ gulp
$ hexo d
~~~

## 文章头部添加作者

在这个`themes\matery\layout\_partial`位置打开`post-detail.ejs`,在如下位置添加代码

~~~javascript
 <% if (theme.postInfo.update) { %>
     <div class="post-date info-break-policy">
         <i class="far fa-calendar-check fa-fw"></i><%- __('updateDate') %>:&nbsp;&nbsp;
         <%- date(page.updated, 'YYYY-MM-DD') %>
     </div>
 <% } %>
<!--添加作者信息-->
  <div class="info-break-policy">
    <% if (page.author && page.author.length > 0) { %>
        <i class="fa fa-pencil"></i> 作者: <%- page.author %>
    <% } else { %>
        <i class="fa fa-pencil"></i> 作者: <%- config.author %>
    <% } %>
</div>
~~~

## 使用淘宝镜像优化

> 2020:1.3 11:26

* npm的默认仓库地址是 `https://registry.npmjs.org/`
* 可以使用以下命令查看当前npm的仓库地址

```bash
$ npm config get registry
```

如果你之前按照我的配置配置了第一条,就无需下面的配置了;

* 可以使用以下命令来改变默认下载地址，从而达到不安装`cnpm`就能采用淘宝镜像的目的，然后使用上面的get命令查看是否设置成功。 

```bash
$ npm config set registry https://registry.npm.taobao.org
```

### 安装CNPM

*  安装cnpm，命令： 

~~~bash
$ npm install -g cnpm --registry=https://registry.npm.taobao.org
~~~

*  安装后，使用以下命令测试是否安装成功： 

```bash
$ cnpm -v
```

* 成功后，以后都使用 `cnpm` 代替以前 `npm` 来执行命令！ 

### 添加CNZZ统计

1.进入[友盟](https://workbench.umeng.com)官网注册账户

2.进入你的控制台

3.有三种选项供你选择,网站选择WEB端即可

4.添加你的网站相关信息

5.挑选代码,[图标样式和文字统计]

6.文字统计需要开启统计图标“带数据显示”

7.将代码复制粘贴到`\themes\matery\layout\_partial\footer.ejs`（任选一种样式就可以)

### hexo-neat插件实现代码压缩

可能以上方法比较复杂，来介绍个简单的，[hexo-neat](https://github.com/rozbo/hexo-neat)插件也是用来压缩代码的，底层也是通过gulp来实现的。

但是这个插件是有Bug的：

* 压缩 `md `文件会使 `markdown `语法的代码块消失
* 会删除全角空格

Hexo根目录执行安装代码：

```bash
$ npm install hexo-neat --save
```

在Hexo配置文件`_config.yml` 末尾加入以下配置：

```yml
neat_enable: true
neat_html:
  enable: true
  exclude:
neat_css:
  enable: true
  exclude:
    - '*.min.css'
neat_js:
  enable: true
  mangle: true
  output:
  compress:
  exclude:
    - '*.min.js'
```

* 然后直接 `hexo cl&&hexo g` 就可以了，会自动压缩文件 。

**补充**：为了解决以上Bug，**对于matery主题**（其他主题自行解决）需要将以上默认配置修改为：

```yml
#hexo-neat 优化提速插件（去掉HTML、css、js的blank字符）
neat_enable: true
neat_html:
  enable: true
  exclude:
    - '**/*.md'
neat_css:
  enable: true
  exclude:
    - '**/*.min.css'
neat_js:
  enable: true
  mangle: true
  output:
  compress:
  exclude:
    - '**/*.min.js'
    - '**/**/instantpage.js'
    - '**/matery.js'
```

*  然后直接 `hexo cl&&hexo g` 就可以了，会自动压缩文件 。 

### 写草稿

 `draft`是草稿的意思，也就是你如果想写文章，又不希望被看到，那么可以 

~~~bash
$ hexo new draft newdraft
~~~

 这样会在`source/_draft`中新建一个`newdraft.md`文件，如果你的草稿文件写的过程中，想要预览一下，那么可以使用 

~~~bash
$ hexo server --draft
~~~

在本地端口中开启服务预览。

如果你的草稿文件写完了，想要发表到`post`中，

~~~bash
$ hexo publish draft newdraft
~~~

就会自动把`newdraft.md`发送到`post`中。

### 设置全局变灰

>  一般在清明节，全国哀悼日，大地震的日子，以及一些影响力很大的伟人逝世或纪念日的时候，身为站长的我们都会让自己的网站的全部网页变成灰色（黑白色），以表示我们对逝者的悼念。那么今天就说说，通过几行简单的代码，来实现这个功能。 

#### 第一种:改变CSS全局样式

使用matery主题的可以在`\themes\matery\source\css\matery.css`添加以下代码完成全站变灰

~~~CSS
/*深切哀悼抗疫英雄,整个网站变灰*/
html {
    filter: progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);
    -webkit-filter: grayscale(100%);
}
~~~

#### 第二种：在网页的<head>标签内加入以下代码

如果你不想改动CSS文件，你可以通过在网页头部中的<head>标签内部加入内联CSS代码的形式实现网站网页变灰

~~~javascript
<style type="text/css">
html {
filter: progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);
-webkit-filter: grayscale(100%);}
</style>
~~~



### 博客部署到Coding

推荐这篇文章,传送门[博客部署到coding并绑定域名]( [https://www.ifueen.com/share/hexo%E5%8D%9A%E5%AE%A2%E9%83%A8%E7%BD%B2%E5%88%B0coding%E5%B9%B6%E7%BB%91%E5%AE%9A%E5%9F%9F%E5%90%8D.html](https://www.ifueen.com/share/hexo博客部署到coding并绑定域名.html) )

推送Hexo的时候必须要下载安装这个插件

~~~bash
$ npm install hexo-deployer-git --save
~~~

使用以下命令推送到远程仓库,必须是全命令,因为前面我们已经使用了douban电影功能,两个开头都是hexo d重复的,会有冲突

在博客的根目录配置文件配置如下代码,再去你的域名服务商添加解析即可

~~~yaml
deploy:
- type: git
  repo:
#    github: 仓库地址
    coding: 仓库地址
  brach: master
~~~

 把本地生成 SSH 公匙添加到 Coding ,然后 hexo clean &&　hexo g && hexo d 部署上去就是了． 

~~~bash
$ hexo clean
$ hexo generate
$ hexo deploy
~~~

### 备份博客

有时候我们想换一台电脑继续写博客，最简单的方法就是把博客整个目录拷贝过去，就是这么暴力。不过，这种方法有个问题就是要是那天电脑崩了，本地源文件丢失了，比较麻烦，所以这时候就可以将博客目录下的所有源文件都上传到`github`上面。

首先在`github`博客仓库下新建一个分支`hexo`，然后`git clone`到本地，把`.git`文件夹拿出来，放在博客根目录下。

然后`git branch -b hexo`切换到`hexo`分支，然后`git add .`，然后`git commit -m "xxx"`，最后`git push origin hexo`提交就行了。

利用Hexo搭建号博客以后我们需要知道常用的几条命令

## hexo常用命令

#### 新建一篇客

~~~bash
$ hexo new [layout] [Article name]
~~~

*  这样会在`source/_post`中新建一个`Article name.md`文件,你就可以在打开这个`.md`文件进行写文章了😁

> `layout` 可选参数，用以指定文章类型，若无指定则默认由博客根目录下的.yml配置文件中的 default_layout 选项决定

> `title` 必填参数，用以指定文章标题，如果参数值中含有空格，则需要使用双引号包围

#### 新建一篇草稿

* 如果你不想这篇博客上传到线上,你可以新建一篇草稿

~~~bash
$ hexo new draft "Article name"
~~~

*  这样会在`source/_draft`中新建一个`Article name.md`文件，如果你的草稿文件在写的过程中，想要预览一下，那么可以使用 

~~~bash
$ hexo server --draft
~~~

* 如果你的草稿文件写完了，想要发表到`post`中，

~~~bash
$ hexo publish draft "Article name"
~~~

*  博客就会自动把`Article name.md`,移动到`post`中。 

#### 初始化博客

*  初始化本地文件夹为网站的根目录 

~~~bash
$ hexo init [folder]
~~~

* `folder` 可选参数，用以指定初始化目录的路径，若无指定则默认为当前目录

#### hexo clean

* `hexo clean` 命令用于清理缓存文件，是一个比较常用的命令

```bash
$ hexo clean
```

#### Option

##### （1）hexo --safe

`hexo --safe` 表示安全模式，用于禁用加载插件和脚本

```bash
$ hexo --safe
```

**安装新插件时遇到问题可尝试此操作**

##### （2）hexo --debug

`hexo --debug` 表示调试模式，用于将消息详细记录到终端和 `debug.log` 文件

```bash
$ hexo --debug
```

##### （3）hexo --silent

`hexo --silent` 表示静默模式，用于静默输出到终端

```bash
$ hexo --silent
```

#### 生成博客静态文件

hexo generate` 命令用于生成静态文件，一般可以简写为 `hexo g

```bash
$ hexo generate
```

* `-d` 选项，指定生成后部署，与 `hexo d -g` 等价

#### 本地服务器预览

hexo server` 命令用于启动本地服务器，一般可以简写为 `hexo s

```bash
$ hexo server
```

* `-p` 选项，指定服务器端口，默认为 4000
* `-i` 选项，指定服务器 IP 地址，默认为 0.0.0.0
* `-s` 选项，静态模式 ，仅提供 public 文件夹中的文件并禁用文件监视

**说明** ：运行服务器前需要安装 hexo-server 插件

```bash
$ npm install hexo-server --save
```

#### 上传到远程仓库

hexo deploy` 命令用于部署网站，一般可以简写为 `hexo d

```bash
$ hexo deploy
```

* `-g` 选项，指定生成后部署，与 `hexo g -d` 等价

**说明** ：部署前需要修改 _config.yml 配置文件，下面以 git 为例进行说明

```yaml
deploy:
    type: git
    repo: <repository url>
    branch: master
    message: 自定义提交消息，默认为Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}
```

#### 显示hexo版本

~~~bash
$ hexo version
~~~

 显示 Hexo 版本。 

>  持续更新中...，如果遇到问题欢迎联系我，在文章最后评论区【留言和讨论】
