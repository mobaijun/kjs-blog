---
title: 【WEB系列】阿里云短信服务实战
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 短信服务
categories:
  - SpringBoot
abbrlink: 22837162
date: 2020-08-02 23:40:40
img:
coverImg:
password:
summary:
---

## 了解阿里云用户权限操作

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/0.png)

## 开通阿里云的短信服务

* [阿里云官网地址](https://www.aliyun.com/)

> 进入阿里云控制台页面[传送门](https://homenew.console.aliyun.com/),如果没有阿里云账号就注册一个

* 点击个人头像`AccessKey 管理`

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/1.png)

* 进来以后就会弹出一个安全提示,选择`开始使用子用户AccessKey`即可

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/2.png)

> 提示信息云账号AccessKey是您访问阿里云API的密钥，具有该账户完全的权限，请您务必妥善保管！不要通过任何方式(eg, Github)将AccessKey公开到外部渠道，以避免被他人利用而造成 [安全威胁](https://help.aliyun.com/knowledge_detail/54059.html) 。强烈建议您遵循 [阿里云安全最佳实践](https://help.aliyun.com/document_detail/102600.htm) ，使用RAM子用户AccessKey来进行API调用。

* 创建用户组和用户

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/3.png)

* 创建用户组

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/4.png)

> * 创建完成接收验证码
> * 输入验证码点击确认即可
> * 右侧页面弹出`用户组新建成功`

* 添加用户权限

> 点击用户组账号,选择添加权限,搜索SMS,添加短信权限,点击确认完成即可

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/5.png)

* 创建用户

> 点击创建用户,填写登录名称和显示名称,将`编程访问`打✔,点击确认即可

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/6.png)

> 一定要打开编程访问,因为我们需要使用阿里云提供的`AccessKey ID`和`AccessKey Secret`进行访问短信服务

* 保存`AccessKey ID`和`AccessKey Secret`

> 点击用户进入账号页面,新建`AccessKey`

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/7.png)

* 将用户添加到用户组内

>将用户添加到用户组内,点击确认即可

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/8.png)

* 操作步骤小结
  * 登录阿里云
  * 开启子用户
  * 创建一个用户组
  * 开启组短信权限(SMS)
  * 新建一个用户
  * 添加`AccessKey`,保存(ID,密码)

## 添加短信模板

* 开通阿里云短信服务

> * 回到控制台主面板
>
> * 搜索短信服务

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/9.png)

> 进来以后会弹出一个短信服务开通,点击开通即可

* 查看帮助文档

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/10.png)

* 查看标记的相关文档和页面

> 因为我们是做测试,所有选择国内消息即可,可以详细查看一下阿里云短信业务计费规则
>
> * 短信字数<=70个字数，按照70个字数一条短信计算
> * 短信字数>70个字数，即为长短信，按照67个字数记为一条短信计算

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/11.png)

* 充值短信业务(看情况自己选择,1,10元就够了)

* 新建`国内消息`模板

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/12.png)

**常见的模板内容**

| 模版类型(验证码) | 模版内容                                                     |
| ---------------- | ------------------------------------------------------------ |
| 验证码           | 您正在申请手机注册，验证码为：${code}，5分钟内有效！         |
| 验证码           | 尊敬的用户，您的注册会员动态密码为：${code}，请勿泄漏于他人！ |
| 验证码           | 您的动态码为：${code}，您正在进行密码重置操作，如非本人操作，请忽略本短信！ |
| 验证码           | 您的验证码${code}，该验证码5分钟内有效，请勿泄漏于他人！     |
| 验证码           | 您的验证码：${code}，您正进行身份验证，打死不告诉别人！      |
| 验证码           | 您的注册码：${code}，如非本人操作，请忽略本短信！            |
| 验证码           | 您的校验码：${code}，您正在注册成为会员，感谢您的支持！      |
| 验证码           | 验证码为：${code}，您正在登录，若非本人操作，请勿泄露。      |
| 验证码           | 验证码为：${code}，您正在尝试变更重要信息，请妥善保管账户信息。 |
| 验证码           | 验证码为：${code}，您正在注册成为平台会员，感谢您的支持！    |

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/13.png)

* 等待审核完成即可,一般情况下`1-2个小时内`就审核完成了

## 添加签名

* 点击国内消息,添加签名

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/14.png)

* 签名的构成

> 一般签名为公司名称或者网站名称等等,申请说明记得好好写,瞎写可能会不通过!!

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/15.png)

* 短信服务开通小结
  * 进入控制台,搜索短信服务
  * 找到帮助文档
  * 添加短信模板
    * 具体的短信内容
    * 等待审核通过
  * 添加签名
    * 添加公司/网站名称
    * 等待审核通过

## 编写测试代码

* 找到帮助文档[传送门](https://help.aliyun.com/document_detail/66496.html?spm=a2c4g.11186623.6.542.3b3a2c44hnNEVR)
* 创建SpringBoot项目,引入maven依赖

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.3.0.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.mobai</groupId>
    <artifactId>aliyun</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>aliyun</name>
    <description>Demo project for Spring Boot</description>

    <properties>
        <java.version>1.8</java.version>
    </properties>

    <dependencies>
        <!--核心短信包-->
        <dependency>
            <groupId>com.aliyun</groupId>
            <artifactId>aliyun-java-sdk-core</artifactId>
            <version>4.1.0</version>
        </dependency>
        <!--使用FastJson解析字符串-->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>1.2.67</version>
        </dependency>
        <!--引入Redis依赖-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-redis</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
            <exclusions>
                <exclusion>
                    <groupId>org.junit.vintage</groupId>
                    <artifactId>junit-vintage-engine</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
~~~

* 编写测试Demo

~~~java
package com.mobai.aliyun;

import com.alibaba.fastjson.JSONObject;
import com.aliyuncs.CommonRequest;
import com.aliyuncs.CommonResponse;
import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.exceptions.ServerException;
import com.aliyuncs.http.MethodType;
import com.aliyuncs.profile.DefaultProfile;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.HashMap;


@SpringBootTest
public class AliYunApplicationTests {

    /**
     * 阿里云短信测试
     */
    @Test
    void contextLoads() {
        /**
         * 连接阿里云
         * 参数说明:
         * String regionId: 默认参数地域ID,可以不用改变
         * String accessKeyId: 用户获取的AccessKey ID<RAM账号的AccessKey ID>
         * String secret: 用户获取的AccessKey Secret<RAM账号AccessKey Secret>
         */
        DefaultProfile profile = DefaultProfile.getProfile("cn-hangzhou",
                "*****************************",
                "*****************************");
        // 构建客户端
        IAcsClient client = new DefaultAcsClient(profile);
        // 构建请求,发送阿里云
        CommonRequest request = new CommonRequest();
        // 不用改
        request.setMethod(MethodType.POST);
        // 不用更改
        request.setDomain("dysmsapi.aliyuncs.com");
        // 不用改
        request.setVersion("2017-05-25");
        // 自定义事件名称,可改可不改
        request.setAction("SendSms");
        // 自定义的参数(手机号,验证码,签名,模板)
        request.putQueryParameter("PhoneNumbers", "***********");
        request.putQueryParameter("SignName", "框架师博客");
        request.putQueryParameter("TemplateCode", "SMS_***********");
        // 构建一个短信的验证码,暂时写死,测试
        HashMap<String, Object> map = new HashMap<>();
        // 测试验证码
        map.put("code", 1024);
        // 改参数,使用toJSONString解析
        request.putQueryParameter("TemplateParam",
                JSONObject.toJSONString(map));
        try {
            CommonResponse response = client.getCommonResponse(request);
            System.out.println(response.getData());
        } catch (ServerException e) {
            e.printStackTrace();
        } catch (ClientException e) {
            e.printStackTrace();
        }
    }
}
~~~

* 可能出现的异常

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/16.png)

> 出现这种异常已经提示的很明白了,查看签名是否有误,修改签名参数即可

* 成功页面如下图

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/17.png)

## 微服务短信实战

* 编写一个短信接口,描述相关参数

~~~java
package com.mobai.aliyun.service;

import java.util.Map;

/**
 * Software：IntelliJ IDEA 2020.1 x64
 * Author: MoBai·杰
 * Date: 2020/6/11 10:21
 * InterfaceName:SendSms
 * 接口描述： 短信相关参数
 */
public interface SendSms {
    /**
     * @param phoneName [手机号]
     * @param templateCode [短信变量]
     * @param map
     * @return
     */
    boolean send(String phoneName, String templateCode, Map<String, Object> map);
}
~~~

* 编写实现类

~~~java
package com.mobai.aliyun.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.aliyuncs.CommonRequest;
import com.aliyuncs.CommonResponse;
import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.exceptions.ServerException;
import com.aliyuncs.http.MethodType;
import com.aliyuncs.profile.DefaultProfile;
import com.mobai.aliyun.service.SendSms;

import java.util.Map;

/**
 * Software：IntelliJ IDEA 2020.1 x64
 * Author: MoBai·杰
 * Date: 2020/6/11 10:24
 * ClassName:SendSmsImpl
 * 类描述：
 */
@Service
public class SendSmsImpl implements SendSms {
    /**
     * 实现短信接口
     *
     * @param phoneName    [手机号]
     * @param templateCode [短信变量]
     * @param code
     * @return
     */
    @Override
    public boolean send(String phoneName, String templateCode, Map<String, Object> code) {
        /**
         * 连接阿里云
         * 参数说明:
         * String regionId: 默认参数地域ID,可以不用改变
         * String accessKeyId: 用户获取的AccessKey ID<RAM账号的AccessKey ID>
         * String secret: 用户获取的AccessKey Secret<RAM账号AccessKey Secret>
         */
        DefaultProfile profile = DefaultProfile.getProfile("cn-hangzhou",
                "*************************",
                "*************************");
        // 构建客户端
        IAcsClient client = new DefaultAcsClient(profile);
        // 构建请求,发送阿里云
        CommonRequest request = new CommonRequest();
        // 不用改
        request.setMethod(MethodType.POST);
        // 不用更改
        request.setDomain("dysmsapi.aliyuncs.com");
        // 不用改
        request.setVersion("2017-05-25");
        // 自定义事件名称,可改可不改
        request.setAction("SendSms");
        // 自定义的参数(手机号,验证码,签名,模板)
        request.putQueryParameter("PhoneNumbers", phoneName);
        request.putQueryParameter("SignName", "框架师博客");
        request.putQueryParameter("TemplateCode", templateCode);
        // 改参数,使用toJSONString解析
        request.putQueryParameter("TemplateParam",
                JSONObject.toJSONString(code));
        try {
            CommonResponse response = client.getCommonResponse(request);
            System.out.println(response.getData());
            // 判断是否返回成功
            return response.getHttpResponse().isSuccess();
        } catch (ServerException e) {
            e.printStackTrace();
        } catch (ClientException e) {
            e.printStackTrace();
        }
        return false;
    }
}
~~~

* 配置`application.yml`文件

~~~yaml
# tomcat端口
server:
  port: 8080
# redis配置
spring:
  redis:
    host: localhost
    port: 6379
~~~

* 编写`Controller`

~~~java
package com.mobai.aliyun.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.aliyuncs.CommonRequest;
import com.aliyuncs.CommonResponse;
import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.exceptions.ServerException;
import com.aliyuncs.http.MethodType;
import com.aliyuncs.profile.DefaultProfile;
import com.mobai.aliyun.service.SendSms;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * Software：IntelliJ IDEA 2020.1 x64
 * Author: MoBai·杰
 * Date: 2020/6/11 10:24
 * ClassName:SendSmsImpl
 * 类描述：
 */
@Service
public class SendSmsImpl implements SendSms {
    /**
     * 实现短信接口
     *
     * @param phoneName    [手机号]
     * @param templateCode [短信变量]
     * @param code
     * @return
     */
    @Override
    public boolean send(String phoneName, String templateCode, Map<String, Object> code) {
        /**
         * 连接阿里云
         * 参数说明:
         * String regionId: 默认参数地域ID,可以不用改变
         * String accessKeyId: 用户获取的AccessKey ID<RAM账号的AccessKey ID>
         * String secret: 用户获取的AccessKey Secret<RAM账号AccessKey Secret>
         */
        DefaultProfile profile = DefaultProfile.getProfile("cn-hangzhou",
                "*************************",
                "*****************************");
        // 构建客户端
        IAcsClient client = new DefaultAcsClient(profile);
        // 构建请求,发送阿里云
        CommonRequest request = new CommonRequest();
        // 不用改
        request.setMethod(MethodType.POST);
        // 不用更改
        request.setDomain("dysmsapi.aliyuncs.com");
        // 不用改
        request.setVersion("2017-05-25");
        // 自定义事件名称,可改可不改
        request.setAction("SendSms");
        // 自定义的参数(手机号,验证码,签名,模板)
        request.putQueryParameter("PhoneNumbers", phoneName);
        request.putQueryParameter("SignName", "框架师博客");
        request.putQueryParameter("TemplateCode", templateCode);
        // 改参数,使用toJSONString解析
        request.putQueryParameter("TemplateParam",
                JSONObject.toJSONString(code));
        try {
            CommonResponse response = client.getCommonResponse(request);
            System.out.println(response.getData());
            // 判断是否返回成功
            return response.getHttpResponse().isSuccess();
        } catch (ServerException e) {
            e.printStackTrace();
        } catch (ClientException e) {
            e.printStackTrace();
        }
        return false;
    }
}
~~~

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】阿里云短信服务实战/18.png)

> 代码仓库:[传送门](https://github.com/mobaijun/aliyun)
