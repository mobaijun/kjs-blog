---
title: 【Nginx系列】Nginx
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1706463495
tags:
  - Nginx
categories:
  - 后端
date: 2021-04-14 15:08:13
img:
coverImg:
password:
summary:
---



![nginx](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/0.png)

## Nginx基本概念

#### Nginx是什么,可以做什么事情?

>Nginx ("engine x") 是一个高性能的 HTTP 和反向代理服务器,特点是占有内存少，并发能力强，事实上 nginx 的并发能力确实在同类型的网页服务器中表现较好，中国大陆使用nginx网站用户有：百度、京东、新浪、网易、腾讯、淘宝等
>
>Nginx 是高性能的HTTP和反向代理的服务器，处理高并发能力是十分强大的，能经受高负载的考验,有报告表明能支持高达 50,000 个并发连接数。

#### Nginx作为web服务器

>Nginx可以作为静态页面的web服务器，同时还支持 CGI 协议的动态语言，比如 perl、php 等。但是不支持 java。Java 程序只能通过与 tomcat 配合完成。Nginx 专为性能优化而开发， 性能是其最重要的考量,实现上非常注重效率 ，能经受高负载的考验,有报告表明能支持高 达 50,000 个并发连接数。

#### 基本特性

[参考文章传送门](https://lnmp.org/nginx.html)

> * 处理静态文件，索引文件以及自动索引；打开文件描述符缓冲
> * 无缓存的反向代理加速，简单的负载均衡和容错．
> * FastCGI，简单的负载均衡和容错．
> * 模块化的结构。包括gzipping, byte ranges, chunked responses,以及 SSI-filter等filter。如果由FastCGI或其它代理服务器处理单页中存在的多个SSI，则这项处理可以并行运行，而不需要相互等待。
> * 支持SSL 和 TLSSNI．
>
> > Nginx专为性能优化而开发，性能是其最重要的考量,实现上非常注重效率 。它支持内核Poll模型，能经受高负载的考验,有报告表明能支持高达 50,000个并发连接数。

### 正向代理

> Nginx 不仅可以做反向代理，实现负载均衡。还能用作正向代理来进行上网等功能。 正向代理：如果把局域网外的 Internet 想象成一个巨大的资源库，则局域网中的客户端要访 问 Internet，则需要通过代理服务器来访问，这种代理服务就称为正向代理。

![正向代理](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/1.png)

> 在客户端浏览器中配置代理服务器指定网站访问

### 反向代理

> 反向代理，其实客户端对代理是无感知的，因为客户端不需要任何配置就可以访问，我们只需要将请求发送到反向代理服务器，由反向代理服务器去选择目标服务器获取数据后，在返 回给客户端，此时反向代理服务器和目标服务器对外就是一个服务器，暴露的是代理服务器地址，隐藏了真实服务器IP地址。

![反向代理](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/2.png)

### 负载均衡

* 单一服务器对应大量访问的弊端

> 客户端发送多个请求到服务器，服务器处理请求，有一些可能要与数据库进行交互，服务器处理完毕后，再将结果返回给客户端。

![单一架构](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/3.png)

* 负载均衡解决方案

> 单个服务器解决不了，我们增加服务器的数量，然后将请求分发到各个服务器上，将原先请求集中到单个服务器上的情况改为将请求分发到多个服务器上，将负载分发到不同的服务器，也就是我们所说的`负载均衡`

![负载均衡](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/4.png)

> 概述:将大量请求通过反向代理服务器进行均衡分发到各个源服务器,从而实现三高(高性能、高并发、高可用);

### 动静分离

> 为了加快网站的解析速度，可以把动态页面和静态页面由不同的服务器来解析，加快解析速度。降低原来单个服务器的压力。

![动静分离](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/5.png)

### 动静分离实现

![动静分离](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/6.png)

## 安装Nginx

* 使用远程工具Xshell链接系统(Linux)

官网地址:[传送门](http://nginx.org/)

![版本选择](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/7.png)

* 查看nginx全部版本

~~~bash
$ yum list | grep nginx
~~~

* 解压安装

~~~bash
$ yum install nginx
~~~

* 查看版本

~~~bash
$ nginx -v
~~~

* 查看安装位置

~~~bash
$ rpm -ql nginx
~~~

* 推荐本地安装

~~~bash
# 安装nginx依赖,上传pcre-8.37到local目录,解压文件
$ yum -y install gcc pcre-devel zlib-devel openssl openssl-devel
# 解压
# $ tar -zxvf pcre-8.37.tar.gz
# 删除压缩包
$ rm -f pcre-8.37.tar.gz
# 进入安装目录
$ cd pcre-8.37/
# 执行
$ ./configure --prefix=/usr/local/nginx-1.18.0/
# 查看pcre版本
$ pcre-config --version
# 上传文件到/usr/local目录下并解压
$ tar -zxvf nginx-1.18.0.tar.gz
# 删除未解压的压缩包
$ rm -f nginx-1.18.0.tar.gz
# 修改名称
$ mv nginx-1.18.0/ nginx
# 进入nginx目录,执行./configure
$ ./configure
# 编译并安装
$ make && make install
# 进入目录 /usr/local/nginx/sbin/nginx启动服务
$ cd /usr/local/nginx/sbin/
# 启动
$ ./nginx
# 查看进程
$ ps -ef | grep nginx
# 访问,通过查看配置发现默认端口号是80
$ cd /usr/local/nginx/conf/
# 查看默认端口号
$ cat nginx.conf
============================================================
    server {
        listen       80;
        server_name  localhost;
============================================================
# 查看IP地址,外部浏览器访问IP地址+端口号测试访问
$ ifconfig
# 浏览器访问服务器公网IP
http://39.108.96.122//80  # 无法访问此网站,因为没有开放80端口
# 设置开放的端口号
$ firewall-cmd --zone=public --add-port=80/tcp --permanent
# 重启防火墙
$ systemctl restart firewalld
# 查看已开放端口号
$ firewall-cmd --list-all
~~~

**效果:**

![最终效果](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/8.png)

## Nginx常用操作命令

* 启动命令

~~~bash
# 使用nginx命令必须要在nginx目录下操作
$ cd /usr/local/nginx/sbin
# 启动nginx
$ ./nginx
~~~

* 关闭nginx

~~~bash
# 查看进程
$ ps -ef | grep nginx
# 关闭nginx
$ ./nginx -s stop
~~~

* 查看nginx版本号

~~~bash
# 查看版本
$ ./nginx -v
~~~

* 通过端口判断nginx是否启动

~~~bash
$ netstat -anp | grep :80
~~~

* 重新加载

~~~bash
# 修改配置以后需要使用此命令
$ nginx -s reload
~~~

* 关闭nginx服务器

~~~bash
# 关闭Nginx服务器
$ pkill -9 nginx 
~~~

> 重新加载出现的异常:
>
> > 异常信息:nginx: [error] open() "/usr/local/nginx/logs/nginx.pid" failed (2: No such file or directory)
>
> 问题描述,使用nginx重新加载配置的时候出现的环境问题
>
> ~~~bash
> # 使用nginx -c的参数指定nginx.conf文件的位置
> $ /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
> # 查看日志
> $ cd logs/
> # 打印列表
> $ ll
> -rw-r--r-- 1 root root 6575 Jun 13 13:18 access.log
> -rw-r--r-- 1 root root 7060 Jun 13 13:18 error.log
> -rw-r--r-- 1 root root    5 Jun 13 13:17 nginx.pid # 问题原因
> ~~~

## Nginx配置文件

### 配置文件位置

* nginx配置文件的位置

~~~bash
# 进入nginx目录
$ cd /usr/local/nginx
# 进入配置目录
$ cd conf/
# 查看文件
$ ll
~~~

![nginx配置文件目录](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/9.png)

### Nginx配置文件组成

~~~nginx
# ========================第一部分================================
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

# ========================第二部分================================
events {
    worker_connections  1024;
}

# ========================第三部分================================
http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
}
~~~

* Nginx配置文件由三部分组成

  * 全局块

    `从配置文件开始到events块之间的内容,主要是设置一些影响nginx服务器整体运行的配置指令`

    > * `worker_processes  1;`
    >
    >   > * 处理并发数的配置,`worker_processes`的值越大,

  * events块

    `events块涉及的指令主要是影响nginx服务器与用户的网络链接`

    > * `worker_connections  1024;`
    >
    >   > * `worker_connections  1024`,设置网络连接数最大数为1024个

  * http块(`配置最频繁的部分`)

    `http包含两部分模块,`http全局块`和`server块`,这算是Nginx服务器配置中最频繁的部分，代理、缓存和日志定义等绝大多数功能和第三方模块的配置都在这里。`

    > > *  http
    > >
    > >    > * 配置的指令包括文件引入、MIME-TYPE 定义、日志自定义、连接超时时间、单链接请求数上限等。
    > >
    > > * **server块**
    > >
    > >   > * 这块和虚拟主机有密切关系，虚拟主机从用户角度看，和一台独立的硬件主机是完全一样的，该技术的产生是为了节省互联网服务器硬件成本。
    > >   >
    > >   >   * 每个 http 块可以包括多个 server 块，而每个 server 块就相当于一个虚拟主机。
    > >   >   * 而每个 server 块也分为全局 server 块，以及可以同时包含多个 locaton 块。
    > >   >
    > >   > * 全局`server `块
    > >   >
    > >   >   * 最常见的配置是本虚拟机主机的监听配置和本虚拟主机的名称或 IP 配置。
    > >   >
    > >   > * `location`块
    > >   >
    > >   >   * 一个`server`块可以配置多个`location`块。
    > >   >
    > >   >   这块的主要作用是基于 Nginx 服务器接收到的请求字符串（例如 server_name/uri-string），对虚拟主机名称
    > >   >
    > >   >   （也可以是 IP 别名）之外的字符串（例如 前面的 /uri-string）进行匹配，对特定的请求进行处理。地址定向、数据缓存和应答控制等功能，还有许多第三方模块的配置也在这里进行。

## Nginx配置实例-反向代理(1)

### 准备工作

> 实现效果:在浏览器地址栏输入以下地址`www.mobai.com`跳转到Linux系统中`	Tomcat`主页面中

* 安装`nginx`

* 安装`JDK`/(如果忘记了就看Linux学习笔记)

* 安装`tomcat`,使用默认端口号:`8080`

* > 安装`Tomcat`/(如果忘记了就看Linux学习笔记)

* 阿里云服务器默认未开启除(22/3389/1)以外其他端口,添加了服务需要去控制台安全组手动添加服务端口

![安全组规则配置](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/10.png)

* 浏览器输入`公网IP`,访问`tomcat`

![](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/11.png)

### 访问过程分析

![访问过程分析](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/12.png)

### 具体实现

> 在Windows系统路径`C:\Windows\System32\drivers\etc\hosts`打开hosts文件,进行域名和IP对应关系的配置,如下图

![hosts文件映射](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/13.png)

* 设置Windows的hosts文件域名映射以后的效果

![www.mobai.com:8080](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/14.png)

### 在Nginx进行请求转发设置(反向代理)

* 具体实现

~~~nginx
# 进入nginx配置文件
$ cd /usr/local/nginx/conf/
# 编辑配置文件
$ vim nginx.conf
# 在nginx进行请求转发的配置（反向代理配置）
=======================反向代理配置============================
listen       80;
server_name  39.108.96.122;
#charset koi8-r;
#access_log  logs/host.access.log  main;
location / {
    root   html;
    proxy_pass http://127.0.0.1:8080;
    index  index.html index.htm;
}
~~~

![请求转发](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/15.png)

* 测试

~~~bash
# 进入nginx工作目录,启动nginx
cd /usr/local/nginx/sbin
# 启动nginx
$ ./nginx
~~~

* 效果

![反向代理效果](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/16.png)

## Nginx配置实例-反向代理(2)

> 需求:使用Nginx反向代理,根据访问的路径跳转到不同端口的服务中,nginx监听端口未9001;
>
> ~~~http
> http://127.0.0.1:9001/edu/  		 直接跳转到127.0.0.1:8080
> http://127.0.0.1:9001/vod/   	   直接跳转到127.0.0.1:8081
> ~~~

### 准备工作

* usr目录下新建`test~tomcat/8081文件夹`两个文件夹
* 存入两个`Tomcat`,端口分别为`8081`,`8080`;

~~~bash
# 进入工作目录,创建tomcat8081文件夹
$ cd /usr/local
# 创建文件夹
$ mkdir tomcat8081
# 解压一个tomcat到这个文件夹
$ tar -zxvf apache-tomcat-8.5.55.tar.gz
# 开放8081端口号
$ firewall-cmd --zone=public --add-port=8081/tcp --permanent
# 重启防火墙
$ systemctl restart firewalld
# 查看已开放端口号
$ firewall-cmd --list-all
# 配置服务器8081端口号
# 启动tomcat8081
$ cd /usr/local/tomcat8081/apache-tomcat-8.5.55/bin
# 启动
$ ./startup.sh
# 停止tomcat
$ ./shutdown.sh
# 修改端口号
$ cd conf/
# 编辑
$ vim server.xml
======================修改两个部分========================
<Server port="8015" shutdown="SHUTDOWN">
=======================================
<Connector port="8081" protocol="HTTP/1.1"
# 保存退出即可
esc :wq!
# 分别启动两个tomcat/并在浏览器分别访问两个端口`8081~~8080`
~~~

> 准备`a.html`文件,分别修改内容为`8081~~8080`,然后放在`webapps`目录下

### 修改配置

* 找到nginx配置文件,分别进行反向代理的配置

~~~nginx
# 编辑配置文件,实现nginx反向代理，根据访问的路径跳转到不同端口的服务中
$ vim nginx.conf
==========================================================
server {
    listen       9001;
    server_name  39.108.96.122;

    location ~ /edu/ {
       proxy_pass http://127.0.0.1:8080;
     }
     location ~ /vod/ {
       proxy_pass http://127.0.0.1:8081;
     }
}
# 设置开放的端口号
$ firewall-cmd --zone=public --add-port=9001/tcp --permanent
# 重启防火墙
$ systemctl restart firewalld
# 查看已开放端口号
$ firewall-cmd --list-all
# 重启nginx
$ ./nginx -s stop
# 启动
$ ./nginx
~~~

![修改的文件](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/17.png)

### 测试

![完整效果](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/18.png)

### location的匹配符

> * `=`: 用于不含正则表达式的`uri`前,要求请求字符串与`uri`严格匹配,如果匹配成功,就停止继续向下搜索并立即处理该请求。
> * `~`: 用于表示`uri`包含正则表达式,并且区分大小写
> * `~*`: 用于表示`uri`包含正则表达式,并且不区分大小写。
> * `^~`: 用于不含正则表达式的`uri`前,要求`Nginx`服务器找到标识`uri`和请求字符串匹配度最高的`1 cation`后,立即使用此`1ocation`处理请求,而不再使用`location`块中的正则`uri`和请求字符串做匹配。
>
> > 注意:如果`uri`包含正则表达式,则必须要有`~`或者`^*`识

## Nginx配置实例-负载均衡

### 准备工作

> 需求：
>
> 实现效果，在浏览器地址栏输入：`http://39.108.96.122/edu/a.html`,实现负载均衡效果，平均分担到`8081`和`8080`端口号中
>
> * 准备工作
>   * 准备两台`tomcat`服务器，一台端口号为`8080`,一台端口号为`8081`
>   * 在两台`tomcat`的`webapps`目录内,创建`edu`目录，分别放入`a.html`文件，用来测试
>   * 在`nginx`的配置文件中，进行负载均衡的配置

~~~nginx
# 进入配置目录
$ vim nginx.conf
=========================修改配置文件========================
    #gzip  on;
    upstream myserver{
        server 39.108.96.122:8080;
        server 39.108.96.122:8081;
        }
    server {
        listen       80;
        server_name  39.108.96.122;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
                root   html;
                proxy_pass http://myserver;
                index  index.html index.htm;
        }
~~~

![设置图](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/19.png)

### 效果

~~~bash
# 进入nginx目录
$ cd sbin/
# 关闭nginx
$ ./nginx -s stop
# 启动nginx
$ ./nginx
~~~

![效果图](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/20.png)

> nginx会将请求分发到不同的服务器中，来达到服务器的压力均衡

### Nginx负载均衡的几种策略

> 随着互联网信息的爆炸性增长，负载均衡（load balance）已经不再是一个很陌生的话题， 顾名思义，负载均衡即是将负载分摊到不同的服务单元，既保证服务的可用性，又保证响应足够快，给用户很好的体验。快速增长的访问量和数据流量催生了各式各样的负载均衡产品， 很多专业的负载均衡硬件提供了很好的功能，但却价格不菲，这使得负载均衡软件大受欢迎， `nginx `就是其中的一个，在 `linux `下有 `Nginx`、`LVS`、`Haproxy `等等服务可以提供负载均衡服 务，而且`Nginx `提供了几种分配方式(策略)：
>
> * `轮询（默认）`
>
> > 每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器 down 掉，能自动剔除。
>
> * `weight`
>
> > * weight代表权,重默认为1,权重越高被分配的客户端越多
> >
> > * 指定轮询几率，weight 和访问比率成正比，用于后端服务器性能不均的情况。 例如：
>
> ~~~nginx
> upstream server_pool{
> 	server 192.168.5.21 weight=5; // weight权重值/权重越高被分配的客户端越多
> 	server 192.168.5.22 weight=10;
> }
> ~~~
>
> * `ip_hash`
>
> > 每个请求按访问 ip 的 hash 结果分配，这样每个访客固定访问一个后端服务器，可以解决 session 的问题。 例如：
>
> ~~~nginx
> upstream server_pool{
> 	ip_hash;
> 	server 192.168.5.21;
> 	server 192.168.5.22;
> }
> ~~~
>
> >  通俗说就是，如果一个客户第一次访问的端口为`8080`,那么只要不更换IP，未来只会访问`8080`服务器
>
> * `fair（第三方）`
>
> > 按后端服务器的响应时间来分配请求，响应时间短的优先分配。
>
> ~~~nginx
> upstream server_pool{
> 	server 192.168.5.21;
> 	server 192.168.5.22;
> 	fair # 设置根据响应时间来分配服务器
> }
> ~~~

## Nginx配置实例-动静分离

### 动静分离简介

> * 什么是动静分离？
>
> > Nginx 动静分离简单来说就是把动态跟静态请求分开，不能理解成只是单纯的把动态页面和 静态页面物理分离。严格意义上说应该是动态请求跟静态请求分开，可以理解成使用 Nginx 处理静态页面，Tomcat 处理动态页面。动静分离从目前实现角度来讲大致分为两种：
> >
> > *  第一种：是纯粹把静态文件独立成单独的域名，放在独立的服务器上，也是目前主流推崇的方案； 
> > *  第二种：方法就是动态跟静态文件混合在一起发布，通过nginx来分开。

![动静分离](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/21.png)

> 通过 `location `指定不同的后缀名实现不同的请求转发。通过 `expires `参数设置，可以使浏 览器缓存过期时间，减少与服务器之前的请求和流量。具体 `Expires `定义：是给一个资源 设定一个过期时间，也就是说无需去服务端验证，直接通过浏览器自身确认是否过期即可， 所以不会产生额外的流量。此种方法非常适合不经常变动的资源。（如果经常更新的文件， 不建议使用 Expires 来缓存），我这里设置`3d`，表示在这 3 天之内访问这个`URL`，发送一 个请求，比对服务器该文件最后更新时间没有变化，则不会从服务器抓取，返回状态码`304`， 如果有修改，则直接从服务器重新下载，返回状态码 `200`。

### 准备工作

* Linux系统中根目录创建`data`文件夹

~~~bash
# 进入根目录
$ cd /
# 创建data文件夹
$ mkdir data
# 进入data目录创建image目录存放静态文件，创建www文件夹存放html文件
$ mkdir www
$ mkdir image
======================在www目录下放入a.html文件========================
<h1>测试动静分离</h1>
======================在image目录下放入一张图片文件========================
~~~

### 配置`Nginx`

* 进入`nginx`配置目录，修改配置文件

~~~nginx
$ cd /usr/local/nginx/conf/
$ vim nginx.conf
# 配置nginx动静分离
===========================配置nginx动静分离==========================
    server {
        listen       80;
        server_name  39.108.96.122;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
                root   html;
                proxy_pass http://myserver;
                index  index.html index.htm;
        }
        # www
        location /www/ {
                root   /data/;
                index  index.html index.htm;
        }
        # image
        location /image {
                root   /data/;
                autoindex on;
        }
=================重启nginx=====================
# 关闭
$ ./nginx -s stop
# 启动
$ ./nginx
~~~

![image-20200613220126822](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/22.png)

> 动静分离:
>
> * 通过tomcat访问动态资源
> * 通过nginx配置访问静态资源

### 最终测试

~~~http
http://39.108.96.122/image/logo.png # 访问image文件
http://39.108.96.122/www/a.html # 访问html文件
~~~

![测试效果](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/23.png)

> `autoindex on;`可以列出文件目录

## Nginx 配置高可用的集群

### Nginx宕机

> Nginx可能会宕机导致无法用户无法访问到服务器资源

![问题](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/24.png)



### 解决方案(高可用主从配置)

![主从配置](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/25.png)

> 如果主服务器`nginx`挂掉了,那么需要保证系统依然可以正常运行,这就是高可用,需要配置`keepalived`在`主从服务器中进行判断nginx的状态,如果正常运行就不切换`nginx`服务器,如果宕机,就切换`备份`nginx`服务器,并且对外提供一个不存在的`虚拟IP`

### 准备工作

> * 需要安装两台`Nginx`服务器
> * 需要安装`keepalived`
> * 需要配置`虚拟IP`
>
> 高可用准备环境工作
>
> * 准备两台服务器`192.168.121.131`和`192.168.121.127`
> * 分别安装两台nginx服务器
> * 分别在两台nginx服务器中安装两个`keepalived`

~~~nginx
# 使用yum命令安装keepalived
$ yum install keepalived -y
# 查看是否安装成功
$ rpm -q -a keepalived
# 进入keepalived安装目录
$ cd /etc/keepalived
# ll查看keepalived配置文件并编辑
$ vim keepalived.conf
========================keepalived.conf配置文件==========================
global_defs {
   notification_email {
     acassen@firewall.loc
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc
   smtp_server 192.168.200.1
   smtp_connect_timeout 30
   router_id LVS_DEVEL
   vrrp_skip_check_adv_addr
   vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.200.16
        192.168.200.17
        192.168.200.18
    }
}

virtual_server 192.168.200.100 443 {
    delay_loop 6
    lb_algo rr
    lb_kind NAT
    persistence_timeout 50
    protocol TCP

    real_server 192.168.201.100 443 {
        weight 1
        SSL_GET {
            url {
              path /
              digest ff20ad2481f97b1754ef3e12ecd3a9cc
            }
            url {
              path /mrtg/
              digest 9b3a0c85a887a256d6939da88aabd8cd
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }
}

virtual_server 10.10.10.2 1358 {
    delay_loop 6
    lb_algo rr
    lb_kind NAT
    persistence_timeout 50
    protocol TCP

    sorry_server 192.168.200.200 1358

    real_server 192.168.200.2 1358 {
        weight 1
        HTTP_GET {
            url {
              path /testurl/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl2/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl3/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }

    real_server 192.168.200.3 1358 {
        weight 1
        HTTP_GET {
            url {
              path /testurl/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334c
            }
            url {
              path /testurl2/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334c
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }
}

virtual_server 10.10.10.3 1358 {
    delay_loop 3
    lb_algo rr
    lb_kind NAT
    persistence_timeout 50
    protocol TCP

    real_server 192.168.200.4 1358 {
        weight 1
        HTTP_GET {
            url {
              path /testurl/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl2/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl3/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }

    real_server 192.168.200.5 1358 {
        weight 1
        HTTP_GET {
            url {
              path /testurl/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl2/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl3/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }
}
~~~

### 完成主从配置并测试

* 查看keepalived.conf,修改为如下文件

~~~nginx
global_defs {
    notification_email {
    acassen@firewall.loc
    failover@firewall.loc
    sysadmin@firewall.loc
 }
    notification_email_from Alexandre.Cassen@firewall.loc
    smtp_server 192.168.17.129
    smtp_connect_timeout 30
    router_id LVS_DEVEL
 }
vrrp_script chk_http_port {
    script "/usr/local/src/nginx_check.sh"
    interval 2 #（检测脚本执行的间隔）
    weight 2
 }
vrrp_instance VI_1 {
    state BACKUP # 备份服务器上将 MASTER 改为 BACKUP
    interface ens33 //网卡
    virtual_router_id 51 # 主、备机的 virtual_router_id 必须相同
    priority 90 # 主、备机取不同的优先级，主机值较大，备份机值较小
    advert_int 1
 }
 authentication {
    auth_type PASS
    auth_pass 1111
  }
 virtual_ipaddress {
    192.168.17.50 // VRRP H 虚拟地址
  }
}
~~~

* 在`/usr/local/src `添加检测脚本

~~~nginx
#!/bin/bash
A=`ps -C nginx –no-header |wc -l`
if [ $A -eq 0 ];then
 /usr/local/nginx/sbin/nginx
 sleep 2
 if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then
 killall keepalived
 fi
fi
~~~

* 启动`nginx`服务器和`keepalived`

~~~bash
# 启动keepalived
$ systemctl start keepalivrd.service
# 关闭keepalivrd
$ systemctl stop keepalivrd.service
# 查看进程是否已经启动
$ ps -ef | grep keepalivrd
~~~

* 测试

> 在浏览器地址栏输入配置的虚拟IP地址
>
> > 扩展:`ip a`…>>>>>查看ip地址信息的命令,类似`ifconfig`
>
> 将`主nginx服务器`关闭,测试`从nginx服务器`依然可以运行,达到效果,因为不想设置两台虚拟机,太麻烦了,用的阿里云远程服务器,所有知道流程和怎么操做即可!!!

## 高可用配置文件详解

### keepalived配置文件

> 查看主机名称
>
> ~~~bash
> # 进入Linux的hosts文件中查看,没有就自己配置一个
> 127.0.0.1 LVS_DEVEL
> ~~~

~~~nginx
# global_defs全局配置
global_defs {
    notification_email {
    acassen@firewall.loc
    failover@firewall.loc
    sysadmin@firewall.loc
}
    notification_email_from Alexandre.Cassen@firewall.loc
    smtp_server 192.168.17.129
    smtp_connect_timeout 30
	router_id LVS_DEVEL # 访问到的主机名称
 }
# 脚本配置vrrp_script chk_http_port
vrrp_script chk_http_port {
    script "/usr/local/src/nginx_check.sh"
    interval 2 #（检测脚本执行的间隔）
    weight 2	# 权重,如果当前脚本的条件成立,权重就增加或减少相关参数
 }
vrrp_instance VI_1 {
    state BACKUP # 备份服务器上将 MASTER 改为 BACKUP
    interface ens33 //网卡
    virtual_router_id 51 # 主、备机的 virtual_router_id 必须相同
    priority 90 # 主、备机取不同的优先级，主机值较大，备份机值较小
    advert_int 1 # 时间间隔,每隔多少时间检测一次(默认每隔一秒)
	authentication { # 权限校验方式
    auth_type PASS
    auth_pass 1111 # 密码是1111
  }
 # 虚拟IP配置
 virtual_ipaddress {
    # 表示虚拟IP是什么,可以绑定多个虚拟IP
    192.168.17.50 // VRRP H 虚拟地址
  }
}
~~~

### 脚本检测文件介绍

~~~nginx
#!/bin/bash
A=`ps -C nginx –no-header |wc -l`
if [ $A -eq 0 ];then
 # 脚本检测位置
 /usr/local/nginx/sbin/nginx
    # 检测间隔时间
 sleep 2
    # 判断服务器状态
 if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then
        # 如果nginx服务器宕机就杀掉全部进程
 killall keepalived
 fi
fi
~~~

## Nginx原理分析

### Master工作方式

![master工作方式](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/26.png)

### Worker工作方式

![worker工作方式](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/27.png)

> 一个` master` 和多个`woker `有那些好处
>
> > 首先，对于每个`worker`进程来说，独立的进程，不需要加锁，所以省掉了锁带来的开销， 同时在编程以及问题查找时，也会方便很多。其次，采用独立的进程，可以让互相之间不会影响，一个进程退出后，其它进程还在工作，服务不会中断，`master`进程则很快启动新的`worker`进程。当然，`worker`进程的异常退出，肯定是程序有`bug`了，异常退出，会导致当前`worker`上的所有请求失败，不过不会影响到所有请求，所以降低了风险。
>
> * 可以使用`nginx –s reload`热部署，利用`nginx `进行热部署操作
> * 每个`woker `是独立的进程，如果有其中的一个`woker `出现问题，其他`woker `独立的， 继续进行争抢，实现请求过程，不会造成服务中断

### 设置多少个`woker `合适

> worker 数和服务器的 cpu 数相等是最为适宜的
>
> > `Nginx`同`redis`类似都采用了`i `多路复用机制，每个`worker`都是一个独立的进程，但每个进程里只有一个主线程，通过异步非阻塞的方式来处理请求， 即使是千上万个请求也不在话 下。每个`worker`的线程可以把一个`cpu`的性能发挥到极致。所以`worker`数和服务器的`cpu`数相等是最为适宜的。设少了会浪费`cpu`，设多了会造成`cpu`频繁切换上下文带来的损耗。

### 连接数 worker_connection

> * 第一个：发送请求，占用了`woker`的几个连接数？ 答案：`2或者4个 `
>
> * 第二个：`nginx`有一个`master`，有四个`woker`，每个`woker`支持最大的连接数1024，支持的最大并发数是多少？
>
>   > 计算公式如下:
>
>   * 普通的静态访问最大并发数是： `worker_connections * worker_processes /2`
>   * 而如果是`HTTP`作为反向代理来说，最大并发数量应该是`worker_connections * worker_processes/4`。
>
> > 这个值是表示每个`worker`进程所能建立连接的最大值，所以，一个`nginx`能建立的最大连接数，应该是`worker_connections * worker_processes`。当然，这里说的是最大连接数，对于`HTTP`请求本地资源来说 ，能够支持的最大并发数量是`worker_connections * worker_processes`，如果是支持`http1.1`的浏览器每次访问要占两个连接，所以普通的静态访问最大并发数是： `worker_connections * worker_processes /2`，而如果是`HTTP`作为反向代理来说，最大并发数量应该是`worker_connections * worker_processes/4`。因为作为反向代理服务器，每个并发会建立与客户端的连接和与后端服务的连接，会占用两个连接。

## 卸载Nginx

* 首先输入命令 ps -ef | grep nginx检查一下nginx服务是否在运行。

~~~bash
$ ps -ef | grep nginx
~~~

* 停止Nginx服务

~~~bash
$ /usr/sbin/nginx -s stop
$ netstat -lntp
~~~

* 查找

~~~bash
# 查看Nginx相关文件：whereis nginx
$ whereis nginx
~~~

* find查找相关文件

~~~bash
# 查找相关文件
$ find / -name nginx
# 依次删除find查找到的所有目录
$ rm -rf /usr/local/nginx
~~~

* 使用yum清理

~~~bash
$ yum remove nginx
~~~

> nginx卸载完成

## 恢复nginx.conf为默认的配置环境

> nginx.conf是Nginx默认的配置文件，如果把这个文件误删了或是不注意损坏了再或者是想直接用nginx的原始配置文件重新进行环境的配置，其时nginx在默认配置目录下面存在一个原始的nginx.conf备份文件，名字：nginx.conf.default，我们可以复制这个文件并重命名为nginx.conf，如果这个文件让你误删掉了，那也可以复制下面的内容来新建立个nginx.conf，最后重启nginx生效；

## Windows环境下配置Nginx服务器

* Nginx下载

> 官网地址：[下载地址](http://nginx.org/en/download.html)

* 解压缩以后配置环境变量

![系统变量](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/28.png)

* `PATH` 引入 `NGINX_HOME`

![path](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/29.png)

* 启动Nginx

> 进入 `nginx` 解压目录，地址栏输入 `CMD` 键入以下命令
>
> * 如果开启了Windows防火墙，记得允许访问网络。
> * 如果启动失败，可能是IIS占用了80端口。去掉IIS监听的80端口即可。

~~~bash
# 启动Nginx
start nginx
~~~

* 任务管理器查看是否有 `nginx` 进程

![](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/30.png)

* 打开浏览器，输入`localhost:80`

![](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/31.png)

> 安装成功

* Nginx常用命令说明

| 命令            | 说明                                          |
| --------------- | --------------------------------------------- |
| nginx -h        | 查看帮助信息                                  |
| nginx -v        | 查看Nginx版本                                 |
| nginx -s stop   | 停用Nginx                                     |
| nginx -s quit   | 优雅的停用Nginx（处理完正在进行中请求后停用） |
| nginx -s reload | 重新加载配置，并优雅的重启进程                |
| nginx -s reopen | 重启日志文件                                  |

## 将Windows版本Nginx添加到服务

* 查看Winsw笔记,以下是Winsw配置

> 把下载的`winsw`文件放在`Nginx`安装目录`(C:\Program Files\Nginx)`，并修改名称为`NginxService.exe`，然后修改`NginxService.xml`文件,把这两个文件放在Nginx安装目录下。

* `NginxService.xml`内容如下（根据实际情况对路径进行调整）：

~~~xml
<service>
    <!-- 安装成windows服务后的服务名-->
	<id>nginx</id>
    <!-- 显示的服务名称 -->
	<name>nginx</name>
    <!-- 对服务的描述 -->
	<description>Welcome to NGINX Wiki! | NGINX</description>
    <!-- 日志 -->
	<logpath>C:\userapp\nginx-1.19.5\logs\</logpath>
	<logmode>roll</logmode>
	<depend></depend>
    <!-- 可执行程序。这里写Nginx的路径（如果配置了环境变量，直接写“nginx就行了”）-->
	<executable>C:\userapp\nginx-1.19.5\nginx.exe</executable>
    <!--参数-->
	<stopexecutable>C:\userapp\nginx-1.19.5\nginx.exe -s stop</stopexecutable>
</service>
~~~

* 当前目录下已管理员身份运行命令行，添加到服务中，并启动服务

![服务](https://tencent.cos.mobaijun.com/img/blog/【Nginx系列】Nginx/32.png)

* 常用指令

~~~bash
# 安装nginx服务
$ NginxService.exe install
# 删除nginx服务 
$ sc delete 服务名
# 启动Nginx服务
$ net start nginx
# 停止服务
$ net stop nginx
~~~

