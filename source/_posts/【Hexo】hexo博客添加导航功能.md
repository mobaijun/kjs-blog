---
title: 【Hexo】hexo博客添加导航功能
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 导航
categories:
  - Hexo
abbrlink: 2328089344
date: 2020-05-04 15:08:24
img:
coverImg:
password:
summary:
---

## hexo博客添加导航功能

**效果图如下**:[传送门](https://www.mobaijun.com/navigate/)

![](https://tencent.cos.mobaijun.com/img/blog/【Hexo】hexo博客添加导航功能/0.png)

如果你需要新建一个页面,前提是你需要有一个博客,我用的是matery主题,参考了[洪卫的博客搭建教程](https://sunhwee.com/navi),和[闪烁之狐]([https://blinkfox.github.io](https://blinkfox.github.io/))的搭建教程,如果没有博客也可以参考我写的[教程搭建一个自己的博客](https://www.mobaijun.com/posts/3211381432.html),话不多说,下面开始操作

## 新建导航页面

~~~bash
hexo new page 'navigate'
~~~

这时候我们发现`sources/navigate/`多了一个目录和`index.md`文件,这个时候就不用管了,下面开始编写导航相关代码

## 添加导航栏页面

进入`\themes\matery\_config.yml`

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
  About:
    url: /about
    icon: fas fa-user-circle
  Contact:
    url: /contact
    icon: fas fa-comments
  Friends:
    url: /friends
    icon: fas fa-address-book
    # 添加导航栏页面
  Navigate:
    url: /navigate
    icon: fas fa-location-arrow
~~~

图标请在[https://fontawesome.com](https://fontawesome.com/)这个网站获取,因为这是`matery`主题源码指定的图标库,修改起来很麻烦,搜索需要使用对应的英文,中文无法获取搜索结果;

## 添加`navigate.ejs`

定位到`\themes\matery\layout\`新建`navigate.ejs`文件,复制以下代码

```javascript
<div class="navi-height bg-cover pd-header ">
    <div class=" link-box container">
        <!-- 搜索框 -->
        <div class="baidu baidu-2 large-screen">
            <form name="f" action="https://www.baidu.com/" target="_blank">
                <div id="Select-2">
                    <div class="Select-box-2" id="baidu">
                        <ul style="height: 46px;">
                            <li class="this_s">百 · 度</li>
                            <li class="bing_s">必 · 应</li>
                            <li class="google_s">谷 · 歌</li>
                            <li class="baidu_s">百 · 度</li>
                        </ul>
                    </div>
                    <input name="wd" id="kw-2" maxlength="100" autocomplete="off" type="text">
                </div>
                <div class="qingkong" id="qingkong" title="清 · 空" style="display: none;">x</div>
                <input value="搜 · 索" id="su-2" type="submit">
                <ul class="keylist"></ul>
            </form>
        </div>

        <!-- 链接 -->
        <div class="row tags-posts ">
            <div class="col s12 m6 l4 friend-div" data-aos="zoom-in-up">
                <div class="card">
                    <div class="jj-list-tit">娱乐 · 影视</div>
                    <ul class="jj-list-con">
                        <li><a href="https://www.jd.com/" class="link-3" target="_blank">京东</a>
                        <li><a href="https://www.taobao.com/" class="link-3" target="_blank">淘宝</a></li>
                        <li><a href="https://www.tmall.com/" class="link-3" target="_blank">天猫</a></li>
                        </li>
                        <li><a href="https://v.qq.com/" class="link-3" target="_blank">腾讯视频</a></li>
                        <li><a href="http://www.iqiyi.com/" class="link-3" target="_blank">爱奇艺</a></li>
                        <li><a href="https://www.bilibili.com/" class="link-3" target="_blank">哔哩哔哩</a>
                        </li>
                        <li><a href="https://music.163.com/" class="link-3" target="_blank">网易云音乐</a></li>
                        <li><a href="https://y.qq.com/" class="link-3" target="_blank">QQ音乐</a></li>
                        <li><a href="http://www.kugou.com/" class="link-3" target="_blank">酷狗音乐</a></li>
                    </ul>
                </div>
            </div>

            <div class="col s12 m6 l4 friend-div" data-aos="zoom-in-up">
                <div class="card">
                    <div class="jj-list-tit">社区 · Code</div>
                    <ul class="jj-list-con">
                        <li><a href="https://www.mobaijun.com/contact/" class="link-3" target="_blank">留言</a></li>
                        <li><a href="https://github.com/" class="link-3" target="_blank">GitHub</a></li>
                        <li><a href="https://coding.net/" class="link-3" target="_blank">Coding</a></li>
                        <li><a href="https://juejin.im/" class="link-3" target="_blank">掘金</a></li>
                        <li><a href="https://gitee.com/" class="link-3" target="_blank">码云</a></li>
                        <li><a href="https://www.csdn.net/" class="link-3" target="_blank">CSDN</a></li>
                        <li><a href="https://www.jianshu.com/" class="link-3" target="_blank">简书</a></li>
                        <li><a href="https://segmentfault.com/" class="link-3" target="_blank">思否</a></li>
                        <li><a href="https://cloud.tencent.com/developer/" class="link-3" target="_blank">云+社区</a></li>
                    </ul>
                </div>
            </div>

            <div class="col s12 m6 l4 friend-div" data-aos="zoom-in-up">
                <div class="card">
                    <div class="jj-list-tit">实用 · 工具</div>
                    <ul class="jj-list-con">
                        <li><a href="https://mdnice.com/" class="link-3" target="_blank">Nice编辑器</a></li>
                        <li><a href="https://translate.google.cn/" class="link-3" target="_blank">谷歌翻译</a></li>
                        <li><a href="https://www.uupoop.com/" class="link-3" target="_blank">在线PS</a></li>
                        <li><a href="https://www.processon.com/" class="link-3" target="_blank">思维导图</a></li>
                        <li><a href="https://wallhaven.cc/" class="link-3" target="_blank">超清壁纸</a></li>
                        <li><a href="https://cli.im/" class="link-3" target="_blank">二维码</a></li>
                        <li><a href="http://www.yinfans.me/" class="link-3" target="_blank">音范思</a></li>
                        <li><a href="https://www.52pojie.cn/" class="link-3" target="_blank">吾爱破解</a></li>
                        <li><a href="https://my.openwrite.cn/" class="link-3" target="_blank">OW分发</a></li>
                    </ul>
                </div>
            </div>

            <div class="col s12 m6 l4 friend-div" data-aos="zoom-in-up">
                <div class="card">
                    <div class="jj-list-tit">编程 · 学习</div>
                    <ul class="jj-list-con">
                        <li><a href="https://www.oschina.net/" class="link-3" target="_blank">开源中国</a></li>
                        <li><a href="https://htmldog.com/" class="link-3" target="_blank">HTML狗</a></li>
                        <li><a href="https://www.icourse163.org/" class="link-3" target="_blank">中国大学慕课</a></li>
                        <li><a href="https://www.imooc.com/" class="link-3" target="_blank">慕课网</a></li>
                        <li><a href="http://www.wxapp-union.com/" class="link-3" target="_blank">小程序</a></li>
                        <li><a href="https://www.runoob.com/" class="link-3" target="_blank">菜鸟教程</a></li>
                        <li><a href="https://blog.51cto.com/" class="link-3" target="_blank">51CTO</a></li>
                        <li><a href="https://www.shiyanlou.com/library/" class="link-3" target="_blank">实验楼</a></li>
                        <li><a href="https://spring.io/" class="link-3" target="_blank">Spring</a></li>
                    </ul>
                </div>
            </div>

            <div class="col s12 m6 l4 friend-div" data-aos="zoom-in-up">
                <div class="card">

                    <div class="jj-list-tit">资讯 · 趋势</div>
                    <ul class="jj-list-con">
                        <li><a href="https://www.huxiu.com/" class="link-3" target="_blank">虎嗅</a></li>
                        <li><a href="https://insights.stackoverflow.com/" class="link-3" target="_blank">技术调查</a></li>
                        <li><a href="http://www.asciiworld.com/" class="link-3" target="_blank">摸鱼</a></li>
                        <li><a href="https://sspai.com/" class="link-3" target="_blank">少数派</a></li>
                        <li><a href="https://zh.wikihow.com/" class="link-3" target="_blank">WikeHom</a></li>
                        <li><a href="https://www.awesomes.cn/rank?sort=hot" class="link-3" target="_blank">前端趋势</a></li>
                        <li><a href="https://github-trending.com/" class="link-3" target="_blank">GitHub趋势</a></li>
                        <li><a href="https://www.tiobe.com/" class="link-3" target="_blank">编程趋势</a></li>
                        <li><a href="https://trends.google.com/" class="link-3" target="_blank">Google趋势</a></li>

                    </ul>
                </div>
            </div>

            <div class="col s12 m6 l4 friend-div" data-aos="zoom-in-up">
                <div class="card">
                    <div class="jj-list-tit">搜索 · 其他</div>
                    <ul class="jj-list-con">
                        <li><a href="https://ac.scmor.com/" class="link-3" target="_blank">谷歌镜像</a></li>
                        <li><a href="http://www.pansoso.com/" class="link-3" target="_blank">网盘搜索</a></li>
                        <li><a href="http://tool.mkblog.cn/music/" class="link-3" target="_blank">音乐搜索</a></li>
                        <li><a href="https://www.dytt8.net/" class="link-3" target="_blank">电影天堂</a></li>
                        <li><a href="https://carbon.now.sh/" class="link-3" target="_blank">代码图片</a></li>
                        <li><a href="https://www.zhipin.com/" class="link-3" target="_blank">Boos</a></li>
                        <li><a href="https://fontawesome.com/" class="link-3" target="_blank">图标库</a></li>
                        <li><a href="https://www.qvdv.com/tools/qvdv-guid.html" class="link-3" target="_blank">在线工具</a>
                        </li>
                        <li><a href="http://zhongguose.com/" class="link-3" target="_blank">中国色</a></li>
                    </ul>
                </div>
            </div>

        </div>
        <script>
            /*选择搜索引擎*/
            $('.Select-box ul').hover(function () {
                $(this).css('height', 'auto')
            }, function () {
                $(this).css('height', '40px')
            });
            $('.Select-box-2 ul').hover(function () {
                $(this).css('height', 'auto')
            }, function () {
                $(this).css('height', '46px')
            });
            $('.Select-box li').click(function () {
                var _tihs = $(this).attr('class');
                var _html = $(this).html();
                if (_tihs == 'baidu_s') {
                    _tihs = 'https://www.baidu.com/s';
                    _name = 'wd';
                }
                if (_tihs == 'google_s') {
                    _tihs = 'https://www.google.com/search';
                    _name = 'q';
                }
                if (_tihs == 'bing_s') {
                    _tihs = 'https://www.bing.com/search';
                    _name = 'q';
                }
                $('.baidu form').attr('action', _tihs);
                $('.this_s').html(_html);
                $('#kw').attr('name', _name);
                $('.Select-box ul').css('height', '40px')
            });
            $('.Select-box-2 li').click(function () {
                var _tihs = $(this).attr('class');
                var _html = $(this).html();
                if (_tihs == 'baidu_s') {
                    _tihs = 'https://www.baidu.com/s';
                    _name = 'wd';
                }
                if (_tihs == 'google_s') {
                    _tihs = 'https://www.google.com/search';
                    _name = 'q';
                }
                if (_tihs == 'bing_s') {
                    _tihs = 'https://www.bing.com/search';
                    _name = 'q';
                }
                $('.baidu form').attr('action', _tihs);
                $('.this_s').html(_html);
                $('#kw-2').attr('name', _name);
                $('.Select-box-2 ul').css('height', '48px')
            });
            //清空输入框内容
            $('.qingkong').click(function () {
                cls();
                $(this).css('display', 'none')
            });

            function cls() {
                var sum = 0;
                var t = document.getElementsByTagName("INPUT");
                for (var i = 0; i < t.length; i++) {
                    if (t[i].type == 'text') {
                        ++sum;
                        t[i].value = "";//清空
                    }
                }
            }

            //清空输入框按钮的显示和隐藏
            function if_btn() {
                var btn_obj = document.getElementById("kw") || document.getElementById("kw-2");
                var cls_btn = document.getElementById("qingkong");
                var btn_obj_val;
                var times;
                //当元素获得焦点时
                if (btn_obj == '' || btn_obj == null) {
                    return false;  //如果没有找到这个元素，则将函数返回，不继续执行
                }
                btn_obj.onfocus = function () {
                    times = setInterval(function () {
                        btn_obj_val = btn_obj.value;
                        if (btn_obj_val != 0) {
                            cls_btn.style.display = "block";
                        } else {
                            cls_btn.style.display = "none";
                        }
                    }, 200);
                }
                //元素失去焦点时
                btn_obj.onblur = function () {
                    clearInterval(times);
                }
            }
        </script>
    </div>
</div>
<style>
    * {
        margin: 0;
        padding: 0;
        font-family: "微软雅黑"
    }

    ul,
    li,
    h1,
    h2,
    h3,
    h4,
    h5,
    h6,
    p,
    form,
    dl,
    dt,
    dd {
        margin: 0px;
        padding: 0px;
        font-size: 14px;
        font-weight: normal;
    }

    img {
        border-style: none;
    }

    li {
        list-style: none;
        float: left
    }

    a {
        text-decoration: none
    }

    .card {
        background-color: rgba(25, 240, 229, 0);
        width: 96%;
        margin-left: 2%
    }

    .baidu {
        float: left;
        margin-left: 100px;
    }

    .baidu form {
        position: relative
    }

    .Select-box ul {
        height: 40px;
        position: absolute;
        left: -1px;
        top: 0px;
        z-index: 9999;
        background: #FFF;
        border: 1px solid #ccc;
        border-top: none;
        overflow: hidden
    }

    .Select-box li {
        width: 60px;
        line-height: 40px;
        font-size: 14px;
        color: #484848;
        border: 0;
        cursor: pointer;
    }

    .Select-box li:hover {
        background: #3385ff;
        color: #FFF;
    }

    .Select-box .this_s {
        color: #317ef3;
    }

    .Select-box .this_s:hover {
        background: #FFF;
        color: #317ef3;
    }

    .qingkong {
        position: absolute;
        right: 120px;
        top: 12px;
        width: 18px;
        height: 18px;
        background: rgba(0, 0, 0, 0.1);
        border-radius: 18px;
        line-height: 16px;
        color: #666666;
        cursor: pointer;
        text-align: center;
        font-size: 14px;
        display: none;
    }

    .qingkong:hover {
        background: rgba(0, 0, 0, 0.2);
    }

    .qingkong:active {
        background: rgba(0, 0, 0, 0.3);
    }


    .baidu-2 {
        width: 100%;
        height: 110px;
        margin: 0 auto;
        background: none;
        padding-top: 50px;
    }

    .baidu-2 form {
        width: 520px;
        margin: 0 auto;
    }

    .baidu-2 input {
        padding: 13px 8px;
        opacity: 0.9;
        font-size: 15px;
    }

    #Select-2 {
        float: left;
    }

    .Select-box-2 {
        text-align: center;
        float: left;
        position: relative;
    }

    .Select-box-2 ul {
        height: 46px;
        position: absolute;
        left: 0px;
        top: 1px;
        z-index: 9999;
        background: rgba(255, 255, 255, 0.9);
        border: 1px solid #ccc;
        border-top: none;
        overflow: hidden
    }

    .Select-box-2 li {
        width: 60px;
        line-height: 46px;
        font-size: 15px;
        color: #484848;
        border: 0;
        cursor: pointer;
    }

    .Select-box-2 li:hover {
        background: #3385ff;
        color: #FFF;
    }

    .Select-box-2 .this_s {
        color: #317ef3;
    }

    .Select-box-2 .this_s:hover {
        background: none;
        color: #317ef3;
    }

    #kw-2 {
        width: 335px;
        outline: 0;
        border: 1px solid #ccc;
        background: rgba(255, 255, 255, 0.2);
        color: #000000;
        padding-left: 70px;
        font-weight: bold;
    }

    /*修改搜索框样式*/
    #su-2 {
        width: 90px;
        background: blue;
        border: none;
        border-top: #3385ff 1px solid;
        border-bottom: 1px solid #2d78f4;
        color: #FFF;
        cursor: pointer;
        /*去轮廓阴影*/
        outline: none;

    }

    /*光标移动到搜索框颜色*/
    #su-2:hover {
        background: blue;
        border-bottom: 1px solid blue;
    }

    #su-2:active {
        background: blue;
        box-shadow: inset 1px 1px 3px blue;
        -webkit-box-shadow: inset 1px 1px 3px blue;
    }

    .jj-list-tit {
        font-size: 16px;
        line-height: 25px;
        color: #ffffff;
        width: 100%;
        padding-left: 38.5%;
    }

    .jj-list-con {
        overflow: hidden;
        margin: 0 auto
    }

    /*控制网站列表间距*/
    .jj-list-con li {
        width: 31.333%;
        margin: 1%;
    }

    .link-3 {
        display: block;
        background: rgba(0, 0, 0, .35);
        color: #FFF;
        font-size: 13px;
        text-align: center;
        line-height: 35px;
        padding: 4px 0;
        border-radius: 2px;
        transition: all 0.2s
    }

    .link-3:hover {
        background: rgba(0, 0, 0, .45);
        font-size: 15px;
        font-weight: bold
    }

    /*1栏 小于584*/
    @media only screen and (max-width: 584px) {
        .navi-height {
            height: 1300px;
        }

        .link-box {
            margin-top: 5%;
        }

        .large-screen {
            display: none;
        }

    }

    /* 2栏 大于584  小于993px */
    @media only screen and (min-width: 584px) and (max-width: 993px) {
        .navi-height {
            height: 800px;
        }

        .link-box {
            margin-top: 5%;
        }

        .large-screen {
            display: none;
        }

    }

    /*3栏 大于993px*/
    @media only screen and (min-width: 993px) {

        .navi-height {
            position: absolute;
            width: 100%;
            height: 100%;

        }
    }

    /* 隐藏footer */
    .page-footer {
        display: none;
    }
</style>
<% if (theme.banner.enable) { %>
    <script>
        // 每天切换 banner 图.  Switch banner image every day.
        $('.bg-cover').css('background-image', 'url(/medias/banner/' + new Date().getDay() + '.jpg)');
    </script>
<% } else { %>
    <script>
        $('.bg-cover').css('background-image', 'url(/medias/banner/0.jpg)');
    </script>
<% } %>
```

## 添加翻译

定位到`\themes\matery\languages\`目录,下方存在两个翻译文件,一个`default.yml`是默认英文,`zh-CN.yml`是中文,可以在博客根目录配置文件`_config.yml`修改默认语言

~~~yaml
# Site
title: 框架师
subtitle: 墨白
description: 中南财经大学 | 金融管理 | 计算机应用
keywords: Java Python 编程语言 墨白 框架师 计算机应用 视频资料 免费
author: 墨白
language: zh-CN
timezone:
~~~

打开`default.yml`文件,定位到`friends: Friends`,在下面添加一行`navigate: Navigate`即可,打开`zh-CN.yml`,定位到`friends: 友链`,在下面添加一行`navigate: 导航`;到这里基本上是没问题了,如果你发现导航栏还是英文,定位到`\themes\matery\layout\_partial\mobile-nav.ejs`添加以下代码,还有`navigation.ejs`同上修改

```js
   <%
   var menuMap = new Map();
   menuMap.set("Index", "首页");
   menuMap.set("Tags", "标签");
   menuMap.set("Categories", "分类");
   menuMap.set("Archives", "归档");
   menuMap.set("About", "关于");
   menuMap.set("Contact", "留言");
   menuMap.set("Friends", "友链");
   menuMap.set("Navigate", "导航");
   %>
```

在`git bash`输入以下命令预览,记得清理一下`浏览器缓存`

~~~bash
$ hexo clean && hexo g && hexo s
~~~

如果以上很顺利没什么问题,可以直接将博客部署上线即可,输入以下命令

~~~bash
$ hexo clean && hexo g && hexo d
~~~

