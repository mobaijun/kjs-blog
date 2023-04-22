---
title: 【WEB系列】SpringBoot跨域及后端解决方案
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2298002216
tags:
  - cros
date: 2021-07-07 09:46:36
img:
coverImg:
password:
summary:
categories:
 - SpringBoot
---

## 什么是跨域？

- <font color="#dc143c">一个网页向另一个不同域名/不同协议/不同端口的网页请求资源，这就是跨域。</font>
- <font color="#dc143c">跨域原因产生：在当前域名请求网站中，默认不允许通过ajax请求发送其他域名。</font>

## CROS常见header

Access-Control-Allow-Origin:[http://somehost.com](http://somehost.com/) 表示允许[http://somehost.com发起跨域请求](http://somehost.xn--com-yw3ek9pyt9ann0czrcc3a/)。

Access-Control-Max-Age:86400 表示在86400秒内不需要再发送预校验请求。

Access-Control-Allow-Methods: GET,POST,PUT,DELETE 表示允许跨域请求的方法。

Access-Control-Allow-Headers: content-type 表示允许跨域请求包含content-type

## 模拟跨域

### 后台代码

新建一个*SpringBoot*项目，添加如下依赖，版本随意，我自己是*2.5.2*版本

* pom.xml 文件

~~~xml
<!-- springboot版本，2.5.2 -->
<parent>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-parent</artifactId>
   <version>2.5.2</version>
   <relativePath/> <!-- lookup parent from repository -->
</parent>
<!-- 添加 web -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<!-- 添加 lombok 简化实体类 -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
</dependency>
~~~

* 创建一个实体类

~~~java
/**
 * Software：IntelliJ IDEA 2021.1.1 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/7/6 16:16
 * ClassName:GoodsDo
 * 类描述： 商品实体类
 */
@Data
public class GoodsDo {
    /**
     * 商品id
     */
    private Long id;
    /**
     * 商品名称
     */
    private String name;
    /**
     * 商品价格
     */
    private String price;
    /**
     * 商品图片
     */
    private String pic;
}
~~~

* 服务层接口

~~~java
import com.mobai.pojo.GoodsDo;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * Software：IntelliJ IDEA 2021.1.1 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/7/6 16:17
 * ClassName:GoodsService
 * 类描述：商品实现类
 */
@Service
public class GoodsService {
    /**
     * 获取商品列表
     */
    public List<GoodsDo> getGoodsList() {
        // 模拟从数据库查询出的结果返回
        List<GoodsDo> goodsList = new ArrayList<GoodsDo>();
        GoodsDo goods = new GoodsDo();
        goods.setId(1L);
        goods.setName("苹果");
        goods.setPic("apple.jpg");
        goods.setPrice("3.5");
        goodsList.add(goods);
        return goodsList;
    }
}
~~~

* 控制器接口

~~~java
import com.mobai.pojo.GoodsDo;
import com.mobai.service.GoodsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Software：IntelliJ IDEA 2021.1.1 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/7/6 16:17
 * ClassName:GoodsController
 * 类描述：
 */
@RestController
public class GoodsController {

    @Autowired
    private GoodsService goodsService;

    /**
     * 遵循Restful规范的接口
     * 请求地址：http://127.0.0.1:8080/goods
     */
    @GetMapping("/goods")
    public List<GoodsDo> getList() {
        return goodsService.getGoodsList();
    }
}
~~~

* 启动 *SpringBootCorsApplication*，默认端口为*8080*，访问地址：*http://localhost:8080/goods*

### 前端代码

新建一个文件夹，创建*goods.html*文件，编写如下请求代码：

~~~js
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品请求测试</title>
    <!-- Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
</head>
<body>
<script>
    //初始化方法
    $(function () {
        var row = "";
        $.ajax({
            type: "GET",
            // 后端接口地址
            url: "http://127.0.0.1:8080/goods",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (res) {
                $.each(res, function (i, v) {
                    row = "<tr>";
                    row += "<td>" + v.id + "</td>";
                    row += "<td>" + v.name + "</td>";
                    row += "<td>" + v.price + "</td>";
                    row += "<td>" + v.pic + "</td>";
                    row += "</tr>";
                    $("#goodsTable").append(row);
                });
            },
            error: function (err) {
                console.log(err);
            }
        });
    });
</script>
</body>
</html>
~~~

如果在*idea 或者 webStorm*中可以直接点击右上角浏览器运行，会自动生成一个服务器和端口，打开浏览器控制台页面，查看请求信息：

![模拟跨域](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBoot跨域及后端解决方案/0.png)

看 `has been blocked by CORS policy` ，意味着被 CORS 策略阻塞了。我们的前端页面请求被 CORS 阻塞了，所以没成功获取到后端接口返回的数据。

## CORS 跨域介绍

跨域实际上源自浏览器的同源策略，所谓同源，指的是协议、域名、端口都相同的源 (域)。浏览器会阻止一个域的 JavaScript 脚本向另一个不同的域发出的请求，这也是为了保护浏览器的安全。

在上面的例子中，发起请求的网页与请求资源的 URL 协议、域名、端口均不同，所以该请求就被浏览器阻止了。

CORS 的意思就是`跨域资源共享`，是一种允许跨域 HTTP 请求的机制，在这种情况下我们就要想办法实现 CORS 跨域了。

## SpringBoot的Cors跨域设置

- SpringBoot可以基于Cors解决跨域问题，Cors是一种机制，告诉我们的后台，哪边（origin ）来的请求可以访问服务器的数据。
- 全局配置类
- 配置实例如下：

~~~java
package com.mobai.config;

import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Software：IntelliJ IDEA 2021.1.1 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/7/7 10:55
 * ClassName:CorsConfig
 * 类描述： cors配置类
 */
// @Configuration
public class CorsConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            // 重写父类提供的跨域请求处理的接口
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                // 添加映射路径
                registry.addMapping("/**")
                        // 放行哪些原始域
                        .allowedOriginPatterns("*")
                        // 是否发送Cookie信息
                        .allowCredentials(true)
                        // 放行哪些原始域(请求方式)
                        .allowedMethods("GET", "HEAD", "POST", "PUT", "DELETE", "OPTIONS", "PATCH")
                        // 放行哪些原始域(头部信息)
                        .allowedHeaders("*")
                        // 暴露哪些头部信息（因为跨域访问默认不能获取全部头部信息）
                        .exposedHeaders("Header1", "Header2")
                        // 预请求的结果有效期，默认1800分钟,3600是一小时
                        .maxAge(3600);
            }
        };
    }
}
~~~

通过上面的配置类，实现了允许所有对该 Spring Boot 的请求跨域。此时再次打开网页，被跨域策略阻塞的提示消失，界面显示如下：

![成功界面](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBoot跨域及后端解决方案/1.png)

## 小插曲

如果你的*springboot*版本较低，在*2.2以下*，具体那个版本我没有试过，跨域配置需要将 *.allowedOriginPatterns* 替换成 *.allowedOrigins*，<font color="#dc143c">因为在新版本*SpringBoot*中</font>，跨域配置将 *.allowedOrigins* 替换成 *.allowedOriginPatterns*了

> 参考文章：
>
> 1. [(5条消息) When allowCredentials is true, allowedOrigins cannot contain the special value “*“ since that cannot_想望着太阳的博客-CSDN博客](https://blog.csdn.net/weixin_44540722/article/details/114021228)
> 2. [浅谈SpringBoot的Cors跨域设置 - 云扬四海](https://yunlongn.github.io/2019/06/12/%E6%B5%85%E8%B0%88SpringBoot%E7%9A%84Cors%E8%B7%A8%E5%9F%9F%E8%AE%BE%E7%BD%AE/)
> 3. [Spring Boot 跨域与前后端分离丨慕课网教程](http://www.imooc.com/wiki/springbootlesson/cors.html)
