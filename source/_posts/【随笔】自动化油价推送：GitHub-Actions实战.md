---
title: 【随笔】自动化油价推送：GitHub Actions实战
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2512902170
tags:
  - Github Actions
categories:
  - 随笔
date: 2023-12-05 11:30:45
img:
coverImg:
password:
summary:
---

## 前言

> 今年自五月份以来发生了许多事情，其中一个显著的变化是我购买了一辆车。刚开始觉得购车挺便捷的，然而提车的第一个月油费竟然直逼 `1300` 元，让我对这部分开支感到有些心疼。因此，我决定开发一个油价推送小程序，以便获取当前所在城市油价的实时变化情况。通过这个小程序，我可以方便地了解油价的走势，从而更好地掌握预算。为了使这个小程序更加实用，我将项目上传到了 `GitHub`，并且利用 `Actions` 定时在每天下午 `4` 点半自动推送油价变化。以下是我实现这一想法的具体思路。

## 获取源数据

在网上找到一个油价网站，`http://www.qiyoujiage.com` ,定位到自己所在的具体地址，例如：`http://www.qiyoujiage.com/hubei/xxx.shtml` ，通过 `jsoup` 抓取关键数据，如 `92#-0#` 汽油价格等其他自己需要的数据。

## 项目开始

创建一个普通 maven 项目，依赖如下：

~~~xml
<properties>
    <maven.compiler.source>21</maven.compiler.source>
    <maven.compiler.target>21</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <hutool-all.version>5.8.23</hutool-all.version>
    <jsoup.version>1.16.1</jsoup.version>
    <thymeleaf.version>3.1.2.RELEASE</thymeleaf.version>
    <javax.mail-api.version>1.6.2</javax.mail-api.version>
</properties>

<dependencies>
    <!-- 工具类 -->
    <dependency>
        <groupId>cn.hutool</groupId>
        <artifactId>hutool-all</artifactId>
        <version>${hutool-all.version}</version>
    </dependency>
    <!-- 爬虫框架 -->
    <dependency>
        <groupId>org.jsoup</groupId>
        <artifactId>jsoup</artifactId>
        <version>${jsoup.version}</version>
    </dependency>
    <!-- 邮件模板 -->
    <dependency>
        <groupId>org.thymeleaf</groupId>
        <artifactId>thymeleaf</artifactId>
        <version>${thymeleaf.version}</version>
    </dependency>
    <dependency>
        <groupId>javax.mail</groupId>
        <artifactId>javax.mail-api</artifactId>
        <version>${javax.mail-api.version}</version>
    </dependency>
    <!-- Java Mail -->
    <dependency>
        <groupId>com.sun.mail</groupId>
        <artifactId>javax.mail</artifactId>
        <version>${javax.mail-api.version}</version>
    </dependency>
</dependencies>
~~~

> JDK 版本尽量保持一致，毕竟 SpringBoot 3.0 所要求的 JDK 版本最低都是 Java17 了，抱着 Java8养老都不够用了。

## 具体的功能实现

~~~java
package com.mobaijun.oil;

import cn.hutool.core.io.IoUtil;
import cn.hutool.core.io.resource.ClassPathResource;
import cn.hutool.extra.mail.MailAccount;
import cn.hutool.extra.mail.MailUtil;
import cn.hutool.log.Log;
import cn.hutool.log.LogFactory;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Description: [油价解析]
 * Author: [mobaijun]
 * Date: [2023/12/2 19:09]
 * IntelliJ IDEA Version: [IntelliJ IDEA 2023.1.4]
 */
public class OilParse {

    /**
     * 日志打印
     */
    private static final Log log = LogFactory.get(OilParse.class);

    /**
     * 爬取地址
     */
    private static final String START_URL = "http://www.qiyoujiage.com/hubei/shiyan.shtml";

    /**
     * 汽油说明
     */
    private static final String DE_SCRIPT_GASOLINE_MODEL = """
            92汽油的平均密度为0.725kg/L，一升92号汽油为0.725千克;
            95号汽油的密度为0.737g/ml，一升95号汽油为0.737千克;
            0号柴油的密度在0.8400--0.8600g/cm⒊之间，一升0#柴油大约是0.84千克;""";

    /**
     * 邮件发送
     *
     * @param args 参数
     */
    public static void main(String[] args) {
        String oilPriceEmail = generateOilPriceEmail(parseOilData());
        MailAccount account = createMailAccount();
        sendMail(account, oilPriceEmail);
    }

    private static Map<String, String> parseOilData() {
        Map<String, String> oilMap = new LinkedHashMap<>();
        try {
            Document document = Jsoup.connect(OilParse.START_URL).timeout(3000).get();
            String you = Objects.requireNonNull(document.getElementById("youjia")).text();
            oilMap.putAll(splitData(you));
        } catch (IOException e) {
            log.error("HTML parsing failed, please try again! error message:{}", e.getMessage());
        }
        return oilMap;
    }

    private static Map<String, String> splitData(String inputData) {
        Map<String, String> keyValuePairs = new LinkedHashMap<>();
        Pattern pattern = Pattern.compile("(\\S+)\\s(\\S+)");
        Matcher matcher = pattern.matcher(inputData);
        while (matcher.find()) {
            String key = matcher.group(1);
            String value = matcher.group(2);
            keyValuePairs.put(key, value);
        }
        return keyValuePairs;
    }

    private static MailAccount createMailAccount() {
        MailAccount account = new MailAccount();
        account.setHost("smtp.163.com");
        account.setPort(465);
        account.setUser("mobaijun8@163.com");
        account.setPass("你的邮箱授权密码-具体可Google");
        account.setFrom("mobaijun8@163.com");
        account.setCharset(StandardCharsets.UTF_8);
        account.setStarttlsEnable(false);
        account.setSslEnable(true);
        return account;
    }

    private static void sendMail(MailAccount account, String oilPriceEmail) {
        try {
            MailUtil.send(account, "mobaijun8@163.com", "湖北今日油价", oilPriceEmail, true);
            log.info("邮件发送成功！");
        } catch (Exception e) {
            log.error("邮件发送失败：" + e.getMessage());
        }
    }

    private static String generateOilPriceEmail(Map<String, String> oilData) {
        // 读取 Thymeleaf 模板
        String template = readTemplate();
        // 使用 Thymeleaf 引擎进行数据填充
        TemplateEngine templateEngine = new TemplateEngine();
        Context context = new Context();
        context.setVariable("title", "湖北今日油价");
        context.setVariable("subTitle", "每日即时更新 单位:元/升");
        context.setVariable("oilData", oilData);
        context.setVariable("oilDeScript", DE_SCRIPT_GASOLINE_MODEL);
        return templateEngine.process(template, context);
    }

    /**
     * 读取 Template
     *
     * @return 内容
     */
    private static String readTemplate() {
        try (InputStream inputStream = new ClassPathResource("oil_price_template.html").getStream()) {
            return IoUtil.read(inputStream, StandardCharsets.UTF_8);
        } catch (IOException e) {
            log.error("模板文件读取失败：{}" + e.getMessage());
            return "";
        }
    }
}
~~~

## 新建邮件模板

~~~html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <style>
        body {
            background-image: url('https://tencent.cos.mobaijun.com/img/icon/background.jpg');
            background-size: cover;
            /* 使用深色背景 */
            background-color: #333;
            /* 将文字颜色改为黑色 */
            color: #000; /* 黑色 */
            font-family: Arial, sans-serif;
        }

        h1 {
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        th, td {
            border: 1px solid #54d1d5;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #70a0a4;
            color: #030303;
        }

        p {
            margin: 20px 0;
            color: #000; /* 黑色 */
        }

        h3 {
            text-align: center;
            color: #000; /* 黑色 */
        }

        blockquote {
            text-align: center;
            color: #000; /* 黑色 */
        }
    </style>
    <title></title>
</head>
<body>
<h1 th:text="${title}">湖北今日油价</h1>
<p style="text-align: center;"
   th:text="|当日更新时间: ${#temporals.format(#temporals.createNow().plusHours(8), 'yyyy-MM-dd HH:mm:ss')} 单位:元/升|"></p>
<table>
    <thead>
    <tr style="background-color: rgba(112, 160, 164, 0.5);">
        <th>汽油型号</th>
        <th>油价</th>
    </tr>
    </thead>
    <tbody>
    <tr th:each="entry : ${oilData}">
        <td th:text="${entry.key}">Type</td>
        <td th:text="${entry.value}">Price</td>
    </tr>
    </tbody>
</table>
<!--型号描述-->
<h3 style="text-align: center; accent-color: #030303;">汽油型号说明</h3>
<blockquote style="text-align: center;" th:utext="${#vars.oilDeScript.replaceAll(';', '</br></br>')}">汽油型号简介
</blockquote>
</body>
</html>
~~~

## 创建 ci.yml 文件

~~~yaml
name: Run Java Main Method

on:
  workflow_dispatch:
  schedule:
    - cron: '30 8 * * *'

jobs:
  run-java-main:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Java
        uses: actions/setup-java@v2
        with:
          distribution: 'adopt'
          java-version: '21'
      - name: Add execute permission to mvnw
        run: chmod +x mvnw

      - name: Build with Maven
        run: |
          ./mvnw -B package --file ./pom.xml

      - name: Run Java Main Method
        run: |
          java -jar target/oil-price-push-jar-with-dependencies.jar
~~~



## 配置 maven 插件

~~~xml
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <source>21</source>
                    <target>21</target>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>3.3.0</version>
                <configuration>
                    <archive>
                        <manifest>
                            <mainClass>com.mobaijun.oil.OilParse</mainClass>
                        </manifest>
                    </archive>
                    <descriptorRefs>
                        <!-- 这个jar-with-dependencies是assembly预先写好的一个，组装描述引用 -->
                        <descriptorRef>jar-with-dependencies</descriptorRef>
                    </descriptorRefs>
                    <!-- 工程名 -->
                    <finalName>${project.name}</finalName>
                </configuration>
                <executions>
                    <execution>
                        <id>make-assembly</id>
                        <phase>package</phase>
                        <goals>
                            <goal>single</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
~~~

## 最终效果

![](https://tencent.cos.mobaijun.com//img/newimg/202312150903378.png)

> 通过以上步骤就完成了一个简单的油价推送小程序，如有什么问题，欢迎在评论区留言，讨论！
