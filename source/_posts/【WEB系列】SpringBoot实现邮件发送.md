---
title: 【WEB系列】SpringBoot实现邮件发送
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 邮件
categories:
  - SpringBoot
abbrlink: 265470177
date: 2021-01-13 18:22:53
img:
coverImg:
password:
summary:
---

## 概述

> * 邮件的使用场景
> * 邮件发送原理
> * 邮件发送历史
> * SpringBoot介绍
> * 前置知识
> * 发送文本邮件
> * 发送html邮件
> * 发送附件邮件
> * 发送带图片的邮件
> * 邮件模板
> * 邮件系统
>

## 邮件的使用场景

* 注册验证

> 注册网站的邮件验证

* 网站营销

> 发送网站活动,链接等......

* 安全的最后一道防线

> 根据邮件地址重置账号密码等....

* 提醒,邮件告警

> 实时监控系统,发送邮件告警....

* 触发机制

> 定时发送.......

## 邮件发送原理

> * 邮件传输协议
>
>   * SMTP协议:
>
>   > SMTP全称为Simple Mail Transfer Protocol（简单邮件传输协议），它是一组用于从源地址到目的地址传输邮件的规范，通过它来控制邮件的中转方式。SMTP认证要求必须提供账号和密码才能登陆服务器，其设计目的在于避免用户受到垃圾邮件的侵扰。
>
>   * POP3协议:
>
>   > POP3全称为Post Office Protocol 3（邮局协议），POP3支持客户端远程管理服务器端的邮件。POP3常用于“离线”邮件处理，即允许客户端下载服务器邮件，然后服务器上的邮件将会被删除。目前很多POP3的邮件服务器只提供下载邮件功能，服务器本身并不删除邮件，这种属于改进版的POP3协议。
>
> * 内容不断发展,增加了IMAP协议和Mime协议
>
>   * IMAP协议
>
>   > IMAP全称为Internet Message Access Protocol（互联网邮件访问协议），IMAP允许从邮件服务器上获取邮件的信息、下载邮件等。IMAP与POP类似，都是一种邮件获取协议。
>
>   * Mime协议:
>
>   > MIME,全称为“MultipurposeInternetMailExtensions”,比较确切的中文名称为“多用途互联网邮件扩展”。它是当前广泛应用的一种电子邮件技术规范，基本内容定义于RFC2045-2049（注意RFC1521和RFC1522是它的过时版本）。MIME试图在不改变SMTP协议和RFC822（邮件格式标准）的基础上，使得邮件可以传送任意二进制文件。

![邮件收发流程](https://tencent.cos.mobaijun.com/article_with_pictures/20200710052550.png)

## 邮件发送历史

* 1969年10月,世界上的第一封电子邮件诞生

* 1987年9月14日中国的第一封电子邮件诞生

* 30年发展历程

  > * Java发送邮件
  > * Spring发送邮件
  > * SpringBoot发送邮件

## 开发流程

* 基础配置
* 集成依赖包
* 发送html邮件
* 发送附件邮件
* 发送图片邮件
* 发送模板邮件
* 异常处理
* 邮件系统

### 常见邮箱服务器地址

```properties
QQ邮箱（mail.qq.com）
POP3服务器地址：pop.qq.com（端口：110）
SMTP服务器地址：smtp.qq.com（端口：25）
SMTP服务器需要身份验证。

网易邮箱（163.com）:
POP3服务器地址:pop.163.com（端口：110）
SMTP服务器地址:smtp.163.com（端口：25）

谷歌邮箱(google.com)：
POP3服务器地址:pop.gmail.com（SSL启用端口：995）
SMTP服务器地址:smtp.gmail.com（SSL启用端口：587）

阿里云邮箱（mail.aliyun.com）:
POP3服务器地址:pop3.aliyun.com（SSL加密端口：995；非加密端口：110）
SMTP服务器地址:smtp.aliyun.com（SSL加密端口：465；非加密端口：25）
IMAP服务器地址：imap.aliyun.com（SSL加密端口：993；非加密端口：143）

新浪邮箱（sina.com）:
POP3服务器地址:pop3.sina.com.cn（端口：110）
SMTP服务器地址:smtp.sina.com.cn（端口：25）
```

## 邮件发送

### 基础配置

* 创建SpringBoot项目,导入相关依赖

> * spring-boot-starter-test
> * spring-boot-devtools
> * spring-boot-starter-web
> * spring-boot-starter-thymeleaf

~~~xml
 <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-thymeleaf</artifactId>
 </dependency>
 <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-web</artifactId>
 </dependency>
 <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-mail</artifactId>
 </dependency>
 <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-devtools</artifactId>
     <scope>runtime</scope>
     <optional>true</optional>
 </dependency>
~~~

* 启动引导类测试

~~~java
@SpringBootApplication
public class MailApplication {
    public static void main(String[] args) {
        SpringApplication.run(MailApplication.class, args);
    }
}
~~~

* 创建HelloService接口

```java
/**
 * Software：IntelliJ IDEA 2020.1 x64
 * Author: MoBai·杰
 * ClassName:SayService
 * 类描述： 测试类
 */
@Service
public class MailService {
    /**
     * 注入用户名
     */
    @Value("${spring.mail.username}")
    private String from;

    public void sayHello() {
        System.out.println("Hello SpringBoot");
    }
}
```

* 测试类测试接口

```java
@SpringBootTest
public class HelloWorldApplicationTests {
    @Resource
    private MailService mailService;

    @Test
    void contextLoads() {
        mailService.sayHello();
    }
}
```

### 实现简单文本邮件

* 引入核心依赖包

> 官网地址: [传送门](https://javaee.github.io/javamail/FAQ)

~~~xml
<dependency>
  <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-mail</artifactId>
</dependency>
~~~

* 配置邮箱参数

~~~properties
# 邮箱配置
spring:
  mail:
    # 发送邮件服务器
    host: smtp.163.com
    # 用户名
    username: mobaijun8@163.com
    # 授权码
    password: *********************
    # 编码
    default-encoding: UTF-8
~~~

* 封装SimlpleMailMessage

~~~java
/**
 * Software：IntelliJ IDEA 2020.1 x64
 * Author: MoBai·杰
 * ClassName:SayService
 * 类描述： 测试类
 */
@Service
public class MailService {
    /**
     * 注入用户名
     */
    @Value("${spring.mail.username}")
    private String from;

    public void sayHello() {
        System.out.println("Hello SpringBoot");
    }

    /**
     * to: 发送给谁,邮件接收者
     * subject: 邮件主题
     * content: 邮件内容
     *
     * @param to
     * @param subject
     * @param content
     */
    public void sendSimpleMail(String to, String subject, String content) {
        // 1.创建邮件发送对象
        SimpleMailMessage message = new SimpleMailMessage();
        // 2.邮件接收者
        message.setTo(to);
        // 3.邮件主题
        message.setSubject(subject);
        // 4.邮件内容
        message.setText(content);
        // 5.邮件发送者
        message.setFrom(from);
    }
}
~~~

* 使用JavaMailSender进行发送

```java
@Service
public class MailService {

    /**
     * 注入用户名
     */
    @Value("${spring.mail.username}")
    private String from;

    @Autowired
    private JavaMailSender mailSender;

    public void sayHello() {
        System.out.println("Hello SpringBoot");
    }

    /**
     * to: 发送给谁,邮件接收者
     * subject: 邮件主题
     * content: 邮件内容
     *
     * @param to
     * @param subject
     * @param content
     */
    public void sendSimpleMail(String to, String subject, String content) {
        // 1.创建邮件发送对象
        SimpleMailMessage message = new SimpleMailMessage();
        // 2.邮件接收者
        message.setTo(to);
        // 3.邮件主题
        message.setSubject(subject);
        // 4.邮件内容
        message.setText(content);
        // 5.邮件发送者
        message.setFrom(from);
        // 6.传入message
        mailSender.send(message);
    }
}
```

* 使用junit测试

~~~java
@SpringBootTest
class HelloworldApplicationTests {
    @Resource
    private MailService mailService;

    @Test
    void contextLoads() {
        mailService.sayHello();
    }
    /**
     * 测试邮件发送
     */
    @Test
    public void sendSimpleMail() {
        mailService.sendSimpleMail("mobaijun8@163.com","第一封测试邮件","墨白君你好,我是第一封测试邮件");
    }
}
~~~

* 效果

![测试效果](https://tencent.cos.mobaijun.com/article_with_pictures/20200710062203.png)

### 发送Html邮件

* service添加方法sendHtmlMail

~~~java
/**
 * 发送html邮件
 * to: 发送给谁,邮件接收者
 * subject: 邮件主题
 * content: 邮件内容
 */
public void sendHtmlMail(String to, String subject, String content) throws MessagingException {
    // 1.创建:MimeMessage
    MimeMessage mimeMessage = mailSender.createMimeMessage();
    // 2.创建MimeMessageHelper,封装mimeMessage
    MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);
    // 3.邮件接收者
    helper.setTo(to);
    // 4.邮件主题
    helper.setSubject(subject);
    // 5.邮件内容:String text, boolean html
    helper.setText(content, true);
    // 6.邮件发送者
    helper.setFrom(from);
    // 7.传入message
    mailSender.send(mimeMessage);
}
~~~

* jinit测试

~~~java
 /**
  * 测试Html邮件
  */
 @Test
 public void sendHtmlMail() throws MessagingException {
     // 封装content参数
     String content = "<html>\n" +
             "<body>\n" +
             "<h1> hello world,这是一封html邮件!" +
             "</h1>\n" +
             "</body>\n" +
             "</html>";
     // 调用service方法测试
     mailService.sendHtmlMail("mobaijun8@163.com", "第一封测试邮件", content);
 }
~~~

* 效果

![html效果](https://tencent.cos.mobaijun.com/article_with_pictures/20200710063758.png)

### 发送附件邮件

* service添加方法sendAttachmentsMail

~~~java
/**
 * 发送附件邮件
 * to: 发送给谁,邮件接收者
 * subject: 邮件主题
 * content: 邮件内容
 */
public void sendAttachmentsMail(String to, String subject, String content, String filePath) throws MessagingException {
    // 1.创建:MimeMessage
    MimeMessage mimeMessage = mailSender.createMimeMessage();
    // 2.创建MimeMessageHelper,封装mimeMessage
    MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);
    // 3.邮件接收者
    helper.setTo(to);
    // 4.邮件主题
    helper.setSubject(subject);
    // 5.邮件内容:String text, boolean html
    helper.setText(content, true);
    // 6.邮件发送者
    helper.setFrom(from);
    // 7.读取附件
    FileSystemResource file = new FileSystemResource(new File(filePath));
    // 8.获取文件名称
    String fileName = file.getFilename();
    // 9.传入文件名称和路径
    helper.addAttachment(fileName, file);
    // 10.发送
    mailSender.send(mimeMessage);
}
~~~

* junit测试类

~~~java
 /**
  * 发送附件邮件
  */
 @Test
 public void sendAttachmentsMail() throws MessagingException {
     // 1.创建附件路径
     String filePath = "G:\\IdeaProject\\springboot-email\\HELP.md";
     // 2.调用service发送
     mailService.sendAttachmentsMail("mobaijun8@163.com", "第一封附件邮件", "墨白君你好,我是第一封附件邮件", filePath);
 }
~~~

* 效果

![附件邮件](https://tencent.cos.mobaijun.com/article_with_pictures/20200710065829.png)

### 发送图片邮件

* service添加sendInlineResourceMail方法

~~~java
 /**
  * 发送图片邮件
  */
 public void sendInlineResourceMail(String to, String subject, String content, String rscPath, String rscId) throws MessagingException {
     // 1.创建:MimeMessage
     MimeMessage mimeMessage = mailSender.createMimeMessage();
     // 2.创建MimeMessageHelper,封装mimeMessage
     MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);
     // 3.邮件接收者
     helper.setTo(to);
     // 4.邮件主题
     helper.setSubject(subject);
     // 5.邮件内容:String text, boolean html
     helper.setText(content, true);
     // 6.邮件发送者
     helper.setFrom(from);
     // 7.读取附件
     FileSystemResource file = new FileSystemResource(new File(rscPath));
     helper.addInline(rscId, file);
     // 8.发送
     mailSender.send(mimeMessage);
 }
~~~

* junit测试方法

```java
/**
 * 发送图片邮件
 */
@Test
public void sendInlineResourceMail() throws MessagingException {
    // 1.创建图片路径
    String imagePath = "F:\\Users\\Administrator\\Pictures\\1.jpg";
    // 2.构建图片ID
    String rscId = "01";
    // 3.构建正文主体
    String content = "<html><body>这是有图片的邮件:<img src=\'cid:" + rscId + "\'> </img></body></html>";
    // 4.调用service发送
    mailService.sendInlineResourceMail("mobaijun8@163.com", "第一封图片邮件", content, imagePath, rscId);
}
```

* 效果

![图片邮件](https://tencent.cos.mobaijun.com/article_with_pictures/20200710202502.png)

### 发送模板邮件

* 新建`mailIndex.html`页面

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>框架师入职邀请邮件</title>
</head>
<body>
<p>hello 欢迎加入[框架师]大家庭，您的入职信息如下：</p>
<table border="1">
    <tr>
        <td>姓名</td>
        <td th:text="${username}"></td>
    </tr>
    <tr>
        <td>工号</td>
        <td th:text="${num}"></td>
    </tr>
    <tr>
        <td>薪水</td>
        <td th:text="${salary}"></td>
    </tr>
</table>
<!--/*@thymesVar id="id" type="ch"*/-->
<a href="#" th:href="@{https://www.mobaijun.com/{id}(id=${id})}">验证链接</a>
<div style="color: #ff1a0e">让我们一起努力创造辉煌</div>
</body>
</html>
```

* 添加TemplateEngine,注入

~~~java
@Resource
private TemplateEngine templateEngine;
~~~

* 测试方法

```java
/**
 * 发送模板邮件
 */
@Test
public void sendThymeleafMail() throws MessagingException {
    // 1.构建import org.thymeleaf.context.Context;模板
    Context context = new Context();
    context.setVariable("username", "MoBai");
    context.setVariable("id", "1");
    context.setVariable("num", "001");
    context.setVariable("salary", "3800");
    // 2.使用templateEngine.process方法注入构建的参数
    String mailIndex = templateEngine.process("mailIndex", context);
    // 3.调用service测试
    mailService.sendHtmlMail("mobaijun8@163.com", "第一封测试邮件", mailIndex);
}
```

* 效果

![模板邮件](https://tencent.cos.mobaijun.com/article_with_pictures/20200710205848.png)

### 邮件异常处理

* 定义唯一日志变量

~~~java
// 设置唯一日志变量
private final Logger logger = LoggerFactory.getLogger(this.getClass());
~~~

* 改造发送图片邮件

```java
/**
 * 发送图片邮件
 */
public void sendInlineResourceMail(String to, String subject, String content, String rscPath, String rscId) {
    // 9.添加日志
    logger.info("发送静态邮件开始:{},{},{},{},{}", to, subject, content, rscPath, rscId);
    // 1.创建:MimeMessage
    MimeMessage mimeMessage = mailSender.createMimeMessage();
    try {
        // 2.创建MimeMessageHelper,封装mimeMessage
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);
        // 3.邮件接收者
        helper.setTo(to);
        // 4.邮件主题
        helper.setSubject(subject);
        // 5.邮件内容:String text, boolean html
        helper.setText(content, true);
        // 6.邮件发送者
        helper.setFrom(from);
        // 7.读取附件
        FileSystemResource file = new FileSystemResource(new File(rscPath));
        helper.addInline(rscId, file);
        // 8.发送
        mailSender.send(mimeMessage);
        // 11.成功提示
        logger.info("发送静态邮件成功!!!");
    } catch (MessagingException e) {
        // 10.失败提示
        logger.error("发送静态邮件失败:" + e);
    }
}
```

* junit测试

```java
/**
 * 发送图片邮件
 */
@Test
public void sendInlineResourceMail() {
    // 1.创建图片路径
    String imagePath = "F:\\Users\\Administrator\\Pictures\\1.jpg";
    // 2.构建图片ID
    String rscId = "01";
    // 3.构建正文主体
    String content = "<html><body>这是有图片的邮件:<img src=\'cid:" + rscId + "\'> </img></body></html>";
    // 4.调用service发送
    mailService.sendInlineResourceMail("mobaijun8@163.com", "第一封图片邮件", content, imagePath, rscId);
}
```

* 查看方法日志

![日志内容](https://tencent.cos.mobaijun.com/article_with_pictures/20200710211837.png)

* 邮件效果

![图片邮件](https://tencent.cos.mobaijun.com/article_with_pictures/20200710202502.png)

> 常见邮件程序错误:
>
> * 421:HL:ICC 该IP同时并发连接数过大
> * 451:Requested mail action not taken: too muck fail...登录失败次数过多,被临时禁止登录
> * 553: authentication is required 认证失败

* 完整邮件系统

> * 使用独立微服务
> * 邮件异常处理
> * 发送失败定时重试邮件
> * 使用异步发送