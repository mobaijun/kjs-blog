---
title: 【WEB系列】SpringBoot项目安装SSL协议
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - SSL
categories:
  - SpringBoot
abbrlink: 1643000683
date: 2021-06-021 09:25:49
img:
coverImg:
password:
summary:
---

### 概述

> 这个需求是我目前做的项目被网安评测的时候，一个漏洞的解决方案。使用*SpringBoot*内置*Tomcat*启动应用程序为http协议访问，应网安需求修改为*https://*协议访问项目，网络搜索出了两种解决方案，一种为使用*JDK*本地程序生成*SSL*证书，部署到*SpringBoot*项目上，一种使用云服务商提供的*SSL*证书，但是云服务器商提供证书需要域名校验，无法应用在*localhost*项目上面，故而选择第一种使用*JDK*本地生成*SSL*证书，如果浏览器弹框显示不安全就将证书部署在浏览器上面
>
> * 开发环境
> * IDEA：*IntelliJ IDEA 2020.2.3 x64*
> * JDK：*1.8*
> * SpringBoot * 2.2.0.RELEASE*

### 创建SSL证书

* 打开CMD命令行，键入以下内容

~~~bash
keytool -genkey -alias tomcat -storetype PKCS12 -keyalg RSA -keysize 2048 -keystore zijingkeji.p12 -validity 3650
~~~

> 关键字解释
>
> * alias：密钥别名
> * keytool.exe：程序名称
> * storetype：指定密钥仓库类型
> * keyalg：生证书的算法名称，RSA是一种非对称加密算法
> * keysize：密钥长度
> * keystore：生成的证书文件的存储路径
> * validity：证书的有效期

* 生成SSL证书注意事项

> 在输入证书生成命令之后，会提示输入：
>
> * 密钥库口令：证书密码，在后面的项目中配置证书时用到
> * 姓氏：一般没什么用，在浏览器中查看证书时会显示，用于正式场合的证书还是需要填写标准。
> * 组织单位：证书使用单位信息，一般没什么用，在浏览器中查看证书时会显示，用于正式场合的证书还是需要填写标准。
> * 组织单位名称：证书使用单位名称，一般没什么用，在浏览器中查看证书时会显示，用于正式场合的证书还是需要填写标准。
> * 所在的城市或区域名称：浏览器中查看证书信息时会显示。
> * 所在的省/市/自治区名称：浏览器中查看证书信息时会显示。
> * 单位的双字母国家/地区代码：国家或地区编码，浏览器中查看证书信息时会显示。

![如图](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBoot项目安装SSL协议/0.png)

* 生成的文件位置

![文件位置](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBoot项目安装SSL协议/1.png)

* 将生成的密钥证书拷贝到项目中的resource中（也可以不拷贝到项目中，后面配置路径时配置密钥证书的绝对路径即可）。

![文件路径](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBoot项目安装SSL协议/2.png)

* 修改项目配置文件application-dev.yml，增加如下配置项：

~~~yml
#服务器端口
server:
  servlet:
    context-path: /
  port: 8003
  # SSL证书配置
  ssl:
    enabled: true
    key-store: classpath:zijingkeji.p12 # （密钥文件路径，也可以配置绝对路径）
    key-store-password: zjkj123 # （密钥生成时输入的密钥库口令）
    key-store-type: PKCS12 #（密钥类型，与密钥生成命令一致）
    key-alias: tomcat #（密钥别名，与密钥生成命令一致）
~~~

* 启动项目，直接访问项目即可：

![访问项目](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBoot项目安装SSL协议/3.png)

### http链接自动跳转https链接访问

* 修改 maven 打包配置【在plugins标签下配置如下内容】，不然会出现如下异常

> DerInputStream.getLength(): lengthTag=111, too big.

~~~xml
 <plugin>
     <groupId>org.apache.maven.plugins</groupId>
     <artifactId>maven-resources-plugin</artifactId>
     <configuration>
         <encoding>UTF-8</encoding>
         <nonFilteredFileExtensions>
             <!-- 避免 https 证书文件被修改 -->
             <nonFilteredFileExtension>p12</nonFilteredFileExtension>
             <nonFilteredFileExtension>pkcs12</nonFilteredFileExtension>
         </nonFilteredFileExtensions>
     </configuration>
 </plugin>
~~~

* 启动测试

> 启动后访问浏览器 127.0.0.1:8080 会提示 Bad Request，为什么呢？
>
> * 问：为什么要访问 8080 端口，不是配置端口为 8002了吗？
> * 答：使用 SSL 证书后，配置的端口已经是 HTTPS 的访问端口了。
>   * 这里没有加协议头，默认使用 HTTP 访问，如`HTTPS://localhost:80003`。
>   * 再想想，当我们的项目不配置运行端口时，默认的是不是 8080 呢？
>   * 所以这里也一样，默认的 HTTP 端口就是 8080。
> * 因为默认浏览器使用 http 协议发起请求，但是服务器配置 SSL 证书后就只接受 HTTPS 的请求了。
> * 再次测试，浏览器访问：https://127.0.0.1 ，访问成功，HTTPS 默认使用 8002 端口，所以不用加端口号。
> * 这就有问题了，我们输域名地址时，谁会故意加上 HTTPS？所以就有了第三步，重定向

* 编写SSL配置类

~~~java
package com.zj.service.portal.config;

import org.apache.catalina.Context;
import org.apache.catalina.connector.Connector;

import org.apache.tomcat.util.descriptor.web.SecurityCollection;
import org.apache.tomcat.util.descriptor.web.SecurityConstraint;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Software：IntelliJ IDEA 2020.2.3 x64
 * Author: MoBai·杰
 * Date: 2020/11/19 9:05
 * ClassName:SSLConfig
 * ClassDescribe： SSL配置类
 */
@Configuration
public class SslConfig {

    @Bean
    public Connector connector() {
        Connector connector = new Connector("org.apache.coyote.http11.Http11NioProtocol");
        // Connector监听的http的端口号
        connector.setScheme("http");
        connector.setPort(8002);
        connector.setSecure(false);
        // 监听到http的端口号后转向到的https的端口号
        connector.setRedirectPort(8003);
        return connector;
    }

    @Bean
    public TomcatServletWebServerFactory servletContainer() {
        // 对http请求添加安全性约束，将其转换为https请求
        TomcatServletWebServerFactory tomcat = new TomcatServletWebServerFactory() {
            @Override
            protected void postProcessContext(Context context) {
                SecurityConstraint securityConstraint = new SecurityConstraint();
                securityConstraint.setUserConstraint("CONFIDENTIAL");
                SecurityCollection collection = new SecurityCollection();
                collection.addPattern("/*");
                securityConstraint.addCollection(collection);
                context.addConstraint(securityConstraint);
            }
        };
        tomcat.addAdditionalTomcatConnectors(connector());
        return tomcat;
    }
}
~~~

> 启动后，浏览器访问 http://127.0.0.1:8002 会发现会自动重定向到 https://127.0.0.1:8003

### SSL证书安装到浏览器

* 打开浏览器，搜索管理证书

![浏览器](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBoot项目安装SSL协议/4.png)

* 按步骤操作即可

![操作](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBoot项目安装SSL协议/5.png)
