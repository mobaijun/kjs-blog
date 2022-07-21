---
title: 【Linux系列】Docker启动Nginx配置动静分离
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 649017238
tags:
  - 动静分离
categories:
  - Linux
date: 2021-12-23 09:27:55
img:
coverImg:
password:
summary:
---

## 前言

最近接了个小需求，将服务和前端资源实现分离，很早之前就使用过 `nginx` 做动静分离，不同的是，这一次使用的是在 `docker` 环境下,配置方面没有多大区别，主要是启动 `nginx` 和 `nginx` 的挂载目录需要注意下，下面就开始吧！



## 动静分离

动静分离简单来说就是把动态跟静态请求分开，不能理解成只是单纯的把动态页面和 静态页面物理分离。严格意义上说应该是动态请求跟静态请求分开，可以理解成使用 `Nginx` 处理静态页面，`Tomcat` 处理动态页面。动静分离从目前实现角度来讲大致分为两种：

- 第一种：是纯粹把静态文件独立成单独的域名，放在独立的服务器上，也是目前主流推崇的方案；
- 第二种：方法就是动态跟静态文件混合在一起发布，通过`nginx`来分开。

以上内容搬的以前 `nginx` 的文章，感兴趣的小伙伴可以去看下这篇笔记[动静分离简介](https://www.mobaijun.com/posts/1706463495.html#toc-heading-29)

![动静分离](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200613213818.png)

> 通过 `location`指定不同的后缀名实现不同的请求转发。通过 `expires`参数设置，可以使浏 览器缓存过期时间，减少与服务器之前的请求和流量。具体 `Expires`定义：是给一个资源 设定一个过期时间，也就是说无需去服务端验证，直接通过浏览器自身确认是否过期即可， 所以不会产生额外的流量。此种方法非常适合不经常变动的资源。（如果经常更新的文件， 不建议使用 Expires 来缓存），我这里设置`3d`，表示在这 3 天之内访问这个`URL`，发送一 个请求，比对服务器该文件最后更新时间没有变化，则不会从服务器抓取，返回状态码`304`， 如果有修改，则直接从服务器重新下载，返回状态码 `200`。



## 准备环境

* 保证系统有 `Docker` 环境，有无网络均可。
* 有网络的情况下使用`docker pull`拉取镜像，无网络的情况下使用`docker load < [images_name]`导入镜像

~~~bash
# 搜索镜像
$ docker search nginx
# 拉取镜像
$ docker pull nginx|latest
# 创建工作目录
$ mkdir -p /nginx/{conf,conf.d,logs,data}
# 在data目录下添加html文件夹和image文件夹
$ docker run -dit nginx
# conf 里放 nginx.conf 配置文件, 这个文件的内容要从镜像里的复制出来，前面是容器的路径 后面是宿主机的路径
$ docker cp 容器id:/etc/nginx/conf.d/default.conf /nginx/conf.d/default.conf
$ docker cp 容器id:/etc/nginx/nginx.conf /nginx/conf/nginx.conf
# 删除容器
$ docker rm $(docker stop 容器id)
# 查看nginx启动日志
$ tail -f /nginx/logs/error.log
~~~

* 启动 nginx

~~~bash
$ docker run -dit --restart=always --name=nginx -p 8005:80 -v /nginx/data/image:/data/image -v /nginx/data/html:/usr/share/nginx/html -v /nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /nginx/logs:/var/log/nginx -v /nginx/conf.d:/etc/nginx/conf.d nginx:latest
#######################################################
* --restart=always: 异常关闭后重新尝试启动
* -v /nginx/data/image:/data/image：挂载宿主机的image文件
* -v /nginx/data/html:/usr/share/nginx/html： 挂载宿主机的html文件
* -v /nginx/conf/nginx.conf:/etc/nginx/nginx.conf： nginx配置文件
* -v /nginx/logs:/var/log/nginx： 日志文件
* -v /nginx/conf.d:/etc/nginx/conf.d： 默认配置文件
~~~

* 配置动静分离,修改`/nginx/conf.d/default.conf`配置文件

~~~nginx
server {
    # 监听端口
    listen       80;
    listen  [::]:80;
    # 对应域名，单个网站域名网站也可写localhost
    server_name  ip;
    #access_log  /var/log/nginx/host.access.log  main;
    # 可以配置多个location
    # 配置html访问路径 https://ip:port/index.html
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
     # 配置图片访问路径 https://ip:port/*.jpg
    location ~ .*\.(gif|jpg|pdf|jpeg|png)$ {
        expires    8h;
        root   /data/image/;
    }
    # 拦截后台请求，正则匹配 api 路径
    location ~* ^/(code|auth|admin|gen|dcmp|transport) {
       # 配置代理地址
       proxy_pass http://ip:port;
       #proxy_set_header Host $http_host;
       proxy_connect_timeout 15s;
       proxy_send_timeout 15s;
       proxy_read_timeout 15s;
       proxy_set_header X-Forwarded-Proto http;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    #error_page  404              /404.html;
    # redirect server error pages to the static page /50x.html
    error_page   500 502 503 504  /50x.html;
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
~~~

![image-20211223154204510](https://s2.loli.net/2021/12/23/vzo9igPfqdhjbUY.png)

> PS: 中间有一段踩坑经历：在备份 `default.conf` 的时候名字前缀不要为 `default-*.conf`,最好也不要放在同级目录下，不然会导致配置覆盖，无法生效，不注意就排查很久无法找到原因，同时修改配置后建议重启容器。`docker restart [容器ID]`；
