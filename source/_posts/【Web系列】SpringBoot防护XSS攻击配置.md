---
title: 【Web系列】SpringBoot防护XSS攻击配置
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 407876058
tags:
  - XSS
categories:
  - SpringBoot
date: 2022-01-06 13:57:34
img:
coverImg:
password:
summary:
---

## 前言

源于最近接到的一个小需求，解决平台扫描出现的漏洞，如下图

![](https://tencent.cos.mobaijun.com/article_with_pictures/Yb9qKvgIMVnkdpZ.png)

后端解决这个其实很简单的，有句名言，不要相信前端传过来的任何参数，简单来说，`XSS` 在后端处理的时候对所有用户提交的数据进行校验和转义，比如`把< 转换为 &lt; 把 > 转换为 &rt`；

> 如果想要具体了解什么是XSS攻击，可以看下这两篇博客，个人感觉描述非常详细，可供参考。
>
> [给你讲清楚什么是XSS攻击 - 程序员自由之路 - 博客园](https://www.cnblogs.com/54chensongxia/p/11643787.html)
>
> [前端安全系列（一）：如何防止XSS攻击？ - 美团技术团队](https://tech.meituan.com/2018/09/27/fe-security.html)

我这里就不做赘述，毕竟网上一找一大把，下面看下在后端如何快速处理`xss`防护。

## 环境准备

> 新建 `SpringBoot` 项目，需要添加两个依赖，这个框架来自国产如梦团队，文档非常详细。
>
> 具体可以查看官网：[mica-xss 使用文档 | 如梦技术](https://www.dreamlu.net/components/mica-xss.html)

`mica-xss`组件说明：

- 对表单绑定的字符串类型进行 xss 处理。
- 对 json 字符串数据进行 xss 处理。
- 提供路由和控制器方法级别的放行规则。

~~~xml
<dependency>
    <groupId>net.dreamlu</groupId>
    <artifactId>mica-xss</artifactId>
    <version>2.6.0</version>
</dependency>
<dependency>
    <groupId>net.dreamlu</groupId>
    <artifactId>mica-core</artifactId>
    <version>2.6.0</version>
</dependency>
~~~

> 添加`Maven`依赖后，便已经完成了`XSS`过滤配置。

* 版本号参考

| 最新版本 | mica 版本        | spring boot 版本 | spring cloud 版本 |
| -------- | ---------------- | ---------------- | ----------------- |
| 2.6.0    | mica 2.6.x       | 2.6.x            | 2021              |
| 2.5.8    | mica 2.5.x       | 2.5.x            | 2020              |
| 2.4.11   | mica 2.4.x       | 2.4.x            | 2020              |
| 2.1.1-GA | mica 2.0.x~2.1.x | 2.2.x ~ 2.3.x    | Hoxton            |

## mica-xss 配置

| 配置项                         | 默认值 | 说明                                          |
| :----------------------------- | :----- | :-------------------------------------------- |
| mica.xss.enabled               | true   | 开启xss                                       |
| mica.xss.trim-text             | true   | 【全局】是否去除文本首尾空格                  |
| mica.xss.mode                  | clear  | 模式：clear 清理（默认），escape 转义         |
| mica.xss.pretty-print          | false  | `clear 专用` prettyPrint，默认关闭： 保留换行 |
| mica.xss.enable-escape         | false  | `clear 专用` 转义，默认关闭                   |
| mica.xss.path-patterns         | `/**`  | 拦截的路由，例如: `/api/order/**`             |
| mica.xss.path-exclude-patterns |        | 放行的路由，默认为空                          |

* 配置参考

~~~yaml
# https://gitee.com/596392912/mica
mica:
  xss:
    enabled: true
    path-patterns: /**
    path-exclude-patterns:
~~~

## 模拟测试

* 创建一个 `XssController`

~~~java
@Slf4j
@RestController
@RequestMapping("/")
// 设置该注解 用于跳过配置的Xss 防护
@XssCleanIgnore
public class XssController {

    /**
     * 模拟参数：<script>alert("xss");</script>
     */
    @GetMapping("/xss")
    public String xss(String data) {
        log.info(data);
        return data;
    }
}
~~~

* 启动项目，访问：

~~~http
localhost:8080/xss?data=<script>alert("xss");</script>
~~~

![](https://tencent.cos.mobaijun.com/article_with_pictures/7KS1fpmcdh5WqQ6.png)

* 说明

  注意上方 `controller` 添加了忽略`xss`注解，所以注入成功。

  当我们把`@XssCleanIgnore`注解去掉，设置`xss`防护

  ![](https://tencent.cos.mobaijun.com/article_with_pictures/L7q8lk53vwCbZoG.png)

返回内容为空，表示防护成功，是不是很简单😁😁😁。模拟 `demo` 源码：[spring-boot-xss · 墨白/spring-boot-wikis - 码云 - 开源中国](https://gitee.com/mobaijun/spring-boot-wikis/tree/devople/spring-boot-xss)

想要了解更多内容，可以查看官方文档。

