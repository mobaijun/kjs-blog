---
title: 【Hexo】Hexo进行SEO那些坑
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - SEO
categories:
  - Hexo
abbrlink: 3179156814
date: 2020-04-23 10:24:58
img:
coverImg:
password:
summary:
---

# 百度SEO

#### 域名更换

之前搭建好了博客以后基本上没管过SEO,昨天在腾讯云申请了一个安全域名[https://www.mobaijun.com](htttps://www.mobaijun.com),百度命令

~~~http
site:www.mobaijun.com
~~~

查看收录情况的时候发现连接都失效了,不得已只能重新提交百度,让百度进行收录连接,最简单方法是在百度定位到**`用户中心\站点管理\网站改版\添加改版规则`**可以高效快速的搞定域名更换,当然,不只是域名更换,你`博客文章的连接`出现改版也可以在这里进行提交,需要注意一个点就是必须将未改版之前的连接设为默认连接

![网站改版](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/6.jpg)

![设置默认站点](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/5.jpg)

* **百度网站改版说明**需要注意的点
* 当一个站点的域名或者目录发生变化时，如果想让百度快速收录变化之后的新链接、用以替换之前的旧链接，那么您就需要使用百度搜索资源平台的网站改版工具来提交您的改版关系，加速百度对已收录链接的新旧替换
* 改版规则中的新旧链接一定要使用301的方式进行跳转
*  建议您尽量使用站点改版和规则改版，会有比较短的处理周期，也缩短后续您反馈问题的追查用时间
* 百度搜索资源平台对改版规则的校验时间范围为0.5——2小时，改版生效时间范围为12——48小时，整体来看，您从提交改版规则到线上生效，最短12.5小时，最长50小时
*  您提交的三类改版形式，不能有交叉或者包含关系，即不能有一条链接同时属于多个改版形式

#### 没有提交过自己的网站

##### 查看是否被收录域名

![查看](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/14.jpg)

#### 验证网站所有权

登录百度站长搜索资源平台：[http://zhanzhang.baidu.com](http://zhanzhang.baidu.com%2C/) ，登录成功之后在站点管理中点击[添加网站](http://zhanzhang.baidu.com/site/siteadd)然后输入你的站点地址。

![输入网址](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/15.jpg)

> 注意，这里需要输入我们自己购买的域名,不能使用`xxx.github.io`之类域名.因为`github`是不允许百度的`spider`（蜘蛛）爬取`github`上的内容的，所以如果想让你的站点被百度收录，只能使用自己购买的域名

定位`用户中心\站点管理\添加网站`提交你的域名,在填完网址选择完网站的类型之后需要验证网站的所有权，验证网站所有权的方式有三种：

- 文件验证。
- `html`标签验证
- `CNAME`解析验证（**推荐使用**）

其实使用哪一种方式都可以，都是比较简单的。我这边使用的是CNAME解析,在域名服务商登录,`以腾讯云为例:登录\进入控制台\域名管理\域名解析\`,添加一条解析即可

![解析](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/16.jpg)

#### 设置主动推送

需要安装百度插件

~~~bash
npm install hexo-baidu-url-submit --save
~~~

然后再根目录的配置文件中新增字段

~~~yaml
baidu_url_submit:
  count: 80             # 提交最新的一个链接
  host: www.mobaijun.com # 在百度站长平台中注册的域名
  token: xxxxxxxxxxxxxx # 请注意这是您的秘钥， 所以请不要把博客源代码发布在公众仓库里!
  path: baidu_urls.txt  # 文本文档的地址， 新链接会保存在此文本文档里
~~~

再加入新的`deploy`：

~~~yaml
deploy:
- type: baidu_url_submitter
~~~

密钥的获取位置在网页抓取中的链接提交这一块,如下所示:

![查看密钥](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/17.jpg)

* 复制token=后面的密钥即可

~~~xml
token=*************
~~~

这样执行`hexo deploy`的时候，新的链接就会被推送了。

推送成功时,会有如下终端提示,你们可能比我整齐一些,我这我也不知道目前怎么回事............乱糟糟的

![推送成功](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/18.jpg)

#### 设置自动推送

在主题配置文件下设置,将`baidu_push`设置为`true`:

~~~yaml
# Enable baidu push so that the blog will push the url to baidu automatically which is very helpful for SEO
baidu_push: true
~~~

然后主题文件目录加入下面代码，一般在目录`/themes/matery/layout/_partial`中的`head.ejs`中加入下面`JS`代码（有可能你的目录不是这样，原理类似），这样全站都有了：

~~~javascript
<%# 加入百度自动推送JS代码，全站激活 %>
    <% if (theme.baidu_push) { %>
        <script>
            (function () {
                var bp = document.createElement('script');
                var curProtocol = window.location.protocol.split(':')[0];
                if (curProtocol === 'https') {
                    bp.src = 'https://zz.bdstatic.com/linksubmit/push.js';
                } else {
                    bp.src = 'http://push.zhanzhang.baidu.com/push.js';
                }
                var s = document.getElementsByTagName("script")[0];
                s.parentNode.insertBefore(bp, s);
            })();
        </script>
    <% } %>
~~~

这样每次访问博客中的页面就会自动向百度提交`sitemap`

# GoogleSEO

查看收录情况,因为我`www.mobaijun.com`这个域名已经在Google进行验证了,所以这篇文章使用的还是之前的老域名进行图解[mobaijun.com](https://mobaijun.com)

~~~http
site:www.mobaijun.com
~~~

![没有被Google收录](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/7.jpg)

登录你的Google账号,进入**[这个地址:https://search.google.com/](https://search.google.com/)**

* 我选择的是第二个,使用网址前缀我成功很快,使用网域我这边一直失败,你们可以按需求自己琢磨一下`(必须输入域名全名,例如:https://www.mobaijun.com)`

![选择网址前缀](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/8.jpg)

* 验证网站所有权:就是你需要证明这个网站是你的

![验证网站所有权](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/9.jpg)

* 下载`googled397af6fed08c43a.html`

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/10.jpg)

* 在本地文件夹打开,将这个文件放在`blog\sources`目录下,当然,这样还没完,`如果直接放在sources目录就执行编译`,你`编译后`只会得到一个这样的经过编译后的文件,`Google会报错`,如下图

![文件编译](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/11.jpg)

* 所以需要改动一下`googled397af6fed08c43a.html`

~~~html
layout: false
---
google-site-verification: googled397af6fed08c43a.html
~~~

改成这样子就是告诉hexo,这个`html`文件不需要编译

* 点击验证,基本上是没什么问题的,如下图

![成功](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/12.jpg)

* 成功以后大概`1-2`天会收到消息,你可以过一段时间在查看

![等待](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-18/13.jpg)