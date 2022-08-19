---
title: 【WEB系列】SpirngBoot整合Swagger
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - Swagger
categories:
  - SpringBoot
abbrlink: 1981059771
date: 2020-12-24 17:26:08
img:
coverImg:
password:
summary:
---

## 背景

由于Spring Boot能够快速开发、便捷部署等特性，相信有很大一部分Spring Boot的用户会用来构建RESTful API。而我们构建RESTful API的目的通常都是由于多终端的原因，这些终端会共用很多底层业务逻辑，因此我们会抽象出这样一层来同时服务于多个移动端或者Web前端。

​    这样一来，我们的RESTful API就有可能要面对多个开发人员或多个开发团队：IOS开发、Android开发或是Web开发等。为了减少与其他团队平时开发期间的频繁沟通成本，传统做法我们会创建一份RESTful API文档来记录所有接口细节，然而这样的做法有以下几个问题：

* 由于接口众多，并且细节复杂（需要考虑不同的HTTP请求类型、HTTP头部信息、HTTP请求内容等），高质量地创建这份文档本身就是件非常吃力的事，下游的抱怨声不绝于耳。
* 随着时间推移，不断修改接口实现的时候都必须同步修改接口文档，而文档与代码又处于两个不同的媒介，除非有严格的管理机制，不然很容易导致不一致现象。

​    为了解决上面这样的问题，本文将介绍RESTful API的重磅好伙伴Swagger2，它可以轻松的整合到Spring Boot中，并与Spring MVC程序配合组织出强大RESTful API文档。它既可以减少我们创建文档的工作量，同时说明内容又整合入实现代码中，让维护文档和修改代码整合为一体，可以让我们在修改代码逻辑的同时方便的修改文档说明。另外Swagger2也提供了强大的页面测试功能来调试每个RESTful API。

## 前后端分离缺陷

> 了解Swagger之前,需要先知道什么是前后端分离
>
> * 现在的时代
>   * SpringBoot + VUE
> * 以前的时代
>   * SSM + JSP模板引擎====>后端程序员
> * 前后端分离时代
>   * 后端:后端控制层 + 服务层 + 数据访问层
>   * 前端:前端控制层 + 视图层
>     * 伪造后端交互数据,json数据已经存在,不需要后端传入json数据了,前端工程已经可以运行
>   * 前后端如何交互?
>     * 通过相关的API接口进行交互
>     * 前后端相对独立,松耦合
>     * 前后端可以分别部署在不同的服务器上
> * 但这样会产生新问题
>   * 前后端集成联调,前端和后端开发人员无法做到`及时协商,尽早解决问题`,就会导致项目延期
> * 解决方案:
>   * 首先指定schema[计划大纲],团队实时更新最新的API,可以降低集成的风险;
>   * 早些年:指定world计划文档
>   * 前后端分离:
>     * 前端测试后端:postMan
>     * 后端提供接口,需要实时更新最新的消息和改动

## Swagger简介

> [Swagger官网](https://swagger.io/tools/swagger-ui/)
>
> * 号称世界上最流行的API框架
> * RestFul API文档在线生成工具--->>>==API文档与API同步更新==
> * 可以直接运行,可以在线测试API接口
> * 支持多种语言:(Java,PHP)

![官网界面](https://tencent.cos.mobaijun.com/article_with_pictures/20200611131036.png)

Swagger 是一款RESTFUL接口的文档在线自动生成+功能测试功能软件。本文简单介绍了在项目中集成swagger的方法和一些常见问题。

Swagger 是一个规范和完整的框架，用于生成、描述、调用和可视化 RESTful 风格的 Web 服务。总体目标是使客户端和文件系统作为服务器以同样的速度来更新。文件的方法，参数和模型紧密集成到服务器端的代码，允许API来始终保持同步。Swagger 让部署管理和使用功能强大的API从未如此简单。

## 使用SpringBoot集成Swagger

* 创建`SpringBoot-Web`项目,导入相关依赖

> **注意事项:**
>
> * 在项目中使用Swagger需要SpringBox
> * swagger2
> * swaggerui

~~~xml
<!-- https://mvnrepository.com/artifact/io.springfox/springfox-swagger2 -->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.9.2</version>
</dependency>
<!-- https://mvnrepository.com/artifact/io.springfox/springfox-swagger-ui -->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.9.2</version>
</dependency>
~~~

* 创建hello程序

> 扩展,一个hello程序有两个请求,一个是`SpringBoot`项目默认的`/error`

![](https://tencent.cos.mobaijun.com/article_with_pictures/20200611133104.png)

~~~java
@RestController
public class HelloController {
    /**
     * 测试Controller
     *
     * @return
     */
    @GetMapping("/hello")
    public String hello() {
        return "你好呀!!!Swagger";
    }
}
~~~

* 配置`Swagger`,新建`SwaggerConfig`

~~~java
@Configuration // 标识配置类
@EnableSwagger2 // 开启Swagger
public class SwaggerConfig {
    
}
~~~

* 测试运行

> 唯一地址:`http://localhost:8080/swagger-ui.html`

![首页信息](https://tencent.cos.mobaijun.com/article_with_pictures/20200611133910.png)

## 配置Swagger信息

* 修改`SwaagerConfig`

~~~java
package com.mobai.swagger.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import java.util.ArrayList;

/**
 * Software：IntelliJ IDEA 2020.1 x64
 * Author: MoBai·杰
 * Date: 2020/6/11 13:33
 * ClassName:SwaggerConfig
 * 类描述： Swagger配置类
 */
@Configuration // 标识配置类
@EnableSwagger2 // 开启Swagger
public class SwaggerConfig {

    /**
     * 配置了Swagger的Docket的Bean实例
     *
     * @return
     */
    @Bean
    public Docket docket() {
        return new Docket(DocumentationType.SWAGGER_2).apiInfo(apiInfo());
    }

    /**
     * 配置Swagger信息
     *
     * @return
     */
    private ApiInfo apiInfo() {
        // 配置作者信息
        Contact contact = new Contact("墨白",
                "https://www.mobaijun.com",
                "mobaijun8@163.com");
        // 配置API文档标题
        return new ApiInfo("框架师Api",
                // API文档描述
                "Api Documentation",
                // API版本号
                "1.0",
                // 配置URL(公司官网/blog地址)
                "https://www.mobaijun.com",
                // 作者信息
                contact,
                // 以下内容默认即可
                "Apache 2.0",
                "http://www.apache.org/licenses/LICENSE-2.0",
                new ArrayList());
    }

}
~~~

## Swagger配置扫描接口

> Docket.select();

* 在`SawggerConfig`配置类完善配置扫描接口的参数

~~~java
 /**
  * 配置了Swagger的Docket的Bean实例
  *
  * @return
  */
 @Bean
 public Docket docket() {
     return new Docket(DocumentationType.SWAGGER_2)
             .apiInfo(apiInfo())
             // 配置扫描接口
             .select()
             /*
              *RequestHandlerSelectors,配置要扫描接口的方式
              * 参数说明:
              * basePackage:基于包扫描
              * class:基于类扫描
              * any():扫描全部
              * none():全部都不扫描
              * withMethodAnnotation:通过方法的注解扫描
              * // withMethodAnnotation(GetMapping.class))
              * withClassAnnotation:通过类的注解扫描
              */
           .apis(RequestHandlerSelectors.basePackage("com.mobai.swagger.controller"))
             // .paths()过滤,不扫描哪些接口
             .paths(PathSelectors.any())
             .build();
 }
~~~

* 配置`Swagger`启动

~~~java
/**
 * 配置了Swagger的Docket的Bean实例
 *
 * @return
 */
@Bean
public Docket docket() {
    return new Docket(DocumentationType.SWAGGER_2)
            .apiInfo(apiInfo())
            // 配置Swagger是否启动,默认:true
            .enable(false)
            // 配置扫描接口
            .select()
            .apis(RequestHandlerSelectors.basePackage("com.mobai.swagger.controller"))
            .paths(PathSelectors.any())
            .build();
}
~~~

> 小测试:如果有一个需求,需要你判断在生成环境中使用,在发布的时候不使用
>
> * 开发思路
>   * 先判断.enable()是不是等于`false`
>   * 注入Enable(flag)

* 实现,添加`application-dev.properties生产环境配置和application-pro.properties发布环境配置`

* 默认`application.properties`环境配置添加

~~~properties
# 开启profiles.active监听,dev测试环境,pro发布环境
spring.profiles.active=dev
~~~

* 生产环境修改端口号

~~~properties
server.port=8081
~~~

* 发布环境修改端口号

~~~properties
server.port=8082
~~~

* `SwaggerConfig`配置类判断当前环境

~~~java
/**
 * 配置了Swagger的Docket的Bean实例
 *
 * @return
 */
@Bean
public Docket docket(Environment environment) {
    // 设置要显示的Swagger环境
    Profiles profiles = Profiles.of("dev", "test");
    // 通过environment.acceptsProfiles();判断自己是否在自己设定换的环境当中
    boolean flag = environment.acceptsProfiles(profiles);

    return new Docket(DocumentationType.SWAGGER_2)
            .apiInfo(apiInfo())
            // 监听自己设置的环境
            .enable(flag)
            // 配置扫描接口
            .select()
            .apis(RequestHandlerSelectors.basePackage("com.mobai.swagger.controller"))
            .paths(PathSelectors.any())
            .build();
}
~~~

## 配置API文档的分组

* 配置多个组,添加`.groupName()`

~~~java
   /**
     * 配置了Swagger的Docket的Bean实例
     *
     * @return
     */
    @Bean
    public Docket docket(Environment environment) {
        // 设置要显示的Swagger环境
        Profiles profiles = Profiles.of("dev", "test");
        // 通过environment.acceptsProfiles();判断自己是否在自己设定换的环境当中
        boolean flag = environment.acceptsProfiles(profiles);

        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                // 配置分组
                .groupName("墨白小组")
                // 监听自己设置的环境
                .enable(flag)
                // 配置扫描接口
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.mobai.swagger.controller"))
                .paths(PathSelectors.any())
                .build();
}
~~~

* 效果

![](https://tencent.cos.mobaijun.com/article_with_pictures/20200611145707.png)

* 配置多个组

~~~java
@Configuration // 标识配置类
@EnableSwagger2 // 开启Swagger
public class SwaggerConfig {

    /**
     * 添加A组
     * 每个组各司其职
     *
     * @return
     */
    @Bean
    public Docket docket1() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("A");
    }

    /**
     * 添加B组
     *
     * @return
     */
    @Bean
    public Docket docket2() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("B");
    }

    /**
     * 添加C组
     *
     * @return
     */
    @Bean
    public Docket docket3() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("C");
    }

    /**
     * 配置了Swagger的Docket的Bean实例
     *
     * @return
     */
    @Bean
    public Docket docket(Environment environment) {
        // 设置要显示的Swagger环境
        Profiles profiles = Profiles.of("dev", "test");
        // 通过environment.acceptsProfiles();判断自己是否在自己设定换的环境当中
        boolean flag = environment.acceptsProfiles(profiles);

        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                // 配置分组
                .groupName("墨白小组")
                // 监听自己设置的环境
                .enable(flag)
                // 配置扫描接口
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.mobai.swagger.controller"))
                .paths(PathSelectors.any())
                .build();
    }
~~~

* 效果

![](https://tencent.cos.mobaijun.com/article_with_pictures/20200611150303.png)

* 实体类配置

~~~java
@ApiModel("用户实体类") // 添加注释
public class User {
    // 添加注释
    @ApiModelProperty("年龄")
    private Integer age;

    @ApiModelProperty("姓名")
    private String name;

    @ApiModelProperty("账号")
    private String username;

    @ApiModelProperty("密码")
    private String password;

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
~~~

* 效果

![效果图](https://tencent.cos.mobaijun.com/article_with_pictures/20200611151246.png)

* Swagger常用注解
  * `@ApiModel("注释")`:实体类添加注释 
  * `@ApiModelProperty("注释")`:给实体类属性添加注释
  * `@ApiOperation("注释")`给接口(Controller)方法添加注释,放在方法上
  * `@ApiParam("")`给方法的参数添加注释
  * `@Api("")`给类添加注释

* controller

~~~java
package com.mobai.swagger.controller;


import com.mobai.swagger.pojo.User;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Software：IntelliJ IDEA 2020.1 x64
 * Author: MoBai·杰
 * Date: 2020/6/11 13:25
 * ClassName:HelloController
 * 类描述： 测试类
 */
@ApiOperation("")
@RestController
public class HelloController {
    /**
     * 测试Controller
     *
     * @return
     */
    @GetMapping("/hello")
    public String hello() {
        return "不喜欢你啦你好呀!!!Swagger";
    }

    /**
     * 只要我们的接口中,返回值存在实体类,Swagger就会扫描到
     *
     * @return
     */
    @PostMapping("/user")
    public User user() {
        return new User();
    }

    @ApiOperation("Post测试类")
    @PostMapping(value = "/post")
    public User post(@ApiParam("用户对象") User user) {
        return user;
    }
}
~~~

## Springboot 项目集成 Swagger2

### 1、Maven 引入 Swagger2 依赖

新建 Maven 项目，往其 pom.xml 中引入 Springboot 及 Swagger 相关 Jar。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.mobai</groupId>
    <artifactId>swagger-example-service</artifactId>
    <version>1.0.0</version>
    <name>swagger-example-service</name>
    <description>springboot swagger api example service</description>

    <properties>
        <java.version>1.8</java.version>
    </properties>

    <dependencies>
        <!-- SpringBoot Web -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>2.1.5.RELEASE</version>
        </dependency>
        <!-- 引入Lombok，方便开发 -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.8</version>
            <scope>provided</scope>
        </dependency>
        <!-- 引入Swagger相关依赖 -->
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger2</artifactId>
            <version>2.9.2</version>
        </dependency>
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger-ui</artifactId>
            <version>2.9.2</version>
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
```

### 2、创建 Swagger 配置类

创建 Swagger 配置类，设置 Swagger 文档信息,在 Swagger 配置类上加上 @EnableSwagger2 注解以开启 Swagger2。

> 注意：配置中不要设置 “groupName” 参数，否则可能无法文档聚合。也可以使用更加优雅的注解读取方式来配置相关参数!

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

@EnableSwagger2  // 开启Swagger
@Configuration
public class SwaggerConfig {

    @Value("${swagger.enable}")
    private boolean swaggerEnable;  // 读取配置文件中 swagger 开关参数的值

    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .enable(swaggerEnable)                  // 是否启用 Swagger
                .apiInfo(apiInfo())
                //.groupName("swagger-example-service") // 项目组名
                .select()                               // 选择那些路径和api会生成document
                .apis(RequestHandlerSelectors.any())    // 对所有api进行监控
                .paths(PathSelectors.any())             // 对所有路径进行监控
                .paths(Predicates.not(PathSelectors.regex("/error.*")))//错误路径不监控
                .paths(Predicates.not(PathSelectors.regex("/actuator.*")))//actuator路径跳过
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("swagger-example-service")           // 文档标题
                .description("This is a swagger project.")  // 文档描述
                .version("1.0.0")                           // 文档版本
                .build();
    }

}
```

### 3、配置文件中添加 swagger 开关参数

配置文件 application.yml 中添加 `swagger.enable` 配置参数，方便控制是否开启 `swagger`，一般在生产环境中我们会设置这个值为 `false`。

```yaml
spring:
  application:
    name: swagger-example-service

### Swagger开关配置参数
swagger:
  enable: true
```

### 4、创建 user 实体类

为了方便测试，这里创建一个 User 实体类，并且利用 Swagger 的 @ApiModelProperty 注解对实体类某个属性描述，方便Swagger文档中描述实体类中信息。

```java
import io.swagger.annotations.ApiModelProperty;
import java.util.Date;

public class User {
    // @ApiModelProperty：用于描述字段信息
    @ApiModelProperty(value = "姓名", required = true)
    private String name;
    @ApiModelProperty(value = "性别", required = true)
    private String sex;
    @ApiModelProperty(value = "岁数", required = true)
    private Integer age;
    @ApiModelProperty(value = "生日")
    private Date birthday;
}
```

### 5、创建示例 Controller 接口

创建一个 Controller 类，且运用 Swagger 注解，将接口信息详细描述。

这里用了几个 Swagger 注解，分别为：

* @Api：对整个 Controller 接口信息的描述
* @ApiOperation：对某个接口信息进行描述
* @ApiResponses：对某个反馈信息状态码进行描述
* @ApiParam：对某个接口参数进行描述

```java
import io.swagger.annotations.*;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MimeTypeUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@Api(tags = "Example Controller Document")
public class ExampleController {

    @GetMapping(value = "/example")
    @ApiOperation(value = "获取示例信息", notes = "用 Get 请求发送，获取示例设置的字符串信息。")
    @ApiResponses({
            @ApiResponse(code = 200, message = "成功处理请求"),
            @ApiResponse(code = 401, message = "没有权限访问该服务"),
            @ApiResponse(code = 403, message = "权限不足无法访问该服务"),
            @ApiResponse(code = 404, message = "未发现该微服务"),
            @ApiResponse(code = 500, message = "服务器内部错误")
    })
    public String getExample(
            @ApiParam(value = "输入一个 Key") @RequestParam(value = "key") String key,
            @ApiParam(value = "输入一个 Value", required = true) @RequestParam(value = "value") String value) {
        return "The value you enter is:" + key + "：" + value;
    }

    @PostMapping(value = "/example")
    @ApiOperation(value = "发送示例信息", notes = "Post方法，发送示例信息")
    @ApiResponses({
            @ApiResponse(code = 200, message = "成功处理请求"),
            @ApiResponse(code = 401, message = "没有权限访问该服务"),
            @ApiResponse(code = 403, message = "权限不足无法访问该服务"),
            @ApiResponse(code = 404, message = "未发现该微服务"),
            @ApiResponse(code = 500, message = "服务器内部错误")
    })
    public ResponseEntity<User> postExample(@ApiParam(value = "用户信息") @RequestBody User user) {
        // 设置状态码，且设置默认值为200
        HttpStatus httpStatus = HttpStatus.OK;
        return new ResponseEntity<User>(user,httpStatus);
    }

    @PutMapping(value = "/example")
    @ApiResponses({
            @ApiResponse(code = 200, message = "成功处理请求"),
            @ApiResponse(code = 201, message = "被创建"),
            @ApiResponse(code = 401, message = "没有权限访问该服务"),
            @ApiResponse(code = 403, message = "权限不足无法访问该服务"),
            @ApiResponse(code = 404, message = "未发现该微服务"),
            @ApiResponse(code = 500, message = "服务器内部错误")
    })
    @ApiOperation(value = "修改示例信息", notes = "Put方法，修改示例信息")
    public ResponseEntity<User> putExample(@ApiParam(value = "用户信息") @RequestBody User user) {
        // 设置状态码，且设置默认值为200
        HttpStatus httpStatus = HttpStatus.OK;
        // 设置 Headers
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add(HttpHeaders.CONTENT_TYPE, MimeTypeUtils.APPLICATION_JSON_VALUE);
        // 错误就发送 500 错误
        if (user == null) {
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
        }
        return new ResponseEntity<User>(user, httpHeaders, httpStatus);
    }

    @DeleteMapping(value = "/example/{key}")
    @ApiOperation(value = "删除示例信息", notes = "Delete方法，删除示例信息。")
    @ApiResponses({
            @ApiResponse(code = 200, message = "成功处理请求"),
            @ApiResponse(code = 204, message = "成功处理请求，服务器无返回内容"),
            @ApiResponse(code = 401, message = "没有权限访问该服务"),
            @ApiResponse(code = 403, message = "权限不足无法访问该服务"),
            @ApiResponse(code = 404, message = "未发现该微服务"),
            @ApiResponse(code = 500, message = "服务器内部错误")
    })
    public void deleteExample(@ApiParam(value = "输入一个 Key") @PathVariable(value = "key") String key) {
        System.out.println("delete info " + key);
    }

}
```

### 6、启动类

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

}
```

### 7、访问 Swagger API

项目创建完成后，本地启动然后输入地址 http://localhost:8080/v2/api-docs，可以看见 Swagger API 接口返回的 JSON 信息。

```json
{
    "swagger": "2.0",
    "info": {
        "description": "This is a swagger project.",
        "version": "1.0.0",
        "title": "swagger-example-service"
    },
    "host": "localhost:8080",
    "basePath": "/",
    "tags": [
        {
            "name": "Example Controller Doc",
            "description": "Example Controller"
        },
        {
            "name": "basic-error-controller",
            "description": "Basic Error Controller"
        }
    ],
    "paths": {
        "/error": {
            "get": {
                "tags": [
                    "basic-error-controller"
                ],
                "summary": "error",
                "operationId": "errorUsingGET",
                "produces": [
                    "*/*"
                ],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "type": "object",
                            "additionalProperties": {
                                "type": "object"
                            }
                        }
                    },
                    "401": {
                        "description": "Unauthorized"
                    },
                    "403": {
                        "description": "Forbidden"
                    },
                    "404": {
                        "description": "Not Found"
                    }
                }
```

### 8、访问 Swagger UI

Swagger 除了有 Json 形式的数据外，也有对 Json 数据页面化展示的 Swagger UI，在开始的时候 pom.xml 就已经引入该 Swagger UI 相关 Jar，所以这里我们将项目启动后，输入地址 http://localhost:8080/swagger-ui.html 就能访问到 Swagger 接口信息。

![测试](https://tencent.cos.mobaijun.com/article_with_pictures/20210115170229.png)

* 总结
  * 创建SpringBoot项目,导入`Swagger`依赖
    * `Swagger2`
    * `Swagger-ui`
  * 创建`Swagger`配置类
    * 添加`@Configuration`注解,标识配置类
    * 添加`@EnableSwagger2`注解开启Swagger
  * 配置`Swagger`的`Docket`的`Bean`实例
  * 配置`Swagger`信息
* 我们可以通过Swagger给一些比较难理解的属性或者接口,增加注释信息
* 接口文档实时更新
* 可以在线测试
* Swagger是一个优秀的工具,几乎所有的大公司都在用
* 需要注意 :正式发布的时候,关闭swagger!!!出于安全考虑,而且节省运行内存!