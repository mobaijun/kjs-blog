---
title: 【WEB系列】SpringBootStarter-组件化开发
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1232000011
tags:
  - 组件化开发
categories:
  - SpringBoot
date: 2022-04-28 18:19:16
img:
coverImg:
password:
summary:
---

## 简介

> `starter` 是一种服务（或者叫插件）
>
> 1. 使得使用某个功能的开发者不需要关注各种依赖库的处理，不需要具体的配置信息，由 `Spring Boot` 自动通过`classpath `路径下的类发现需要的 `Bean`，并织入 `bean`。
> 2. 简而言之：**组件化开发思维，提高代码复用性，避免重复造轮子！！**

## 知识点

> - 项目命名方式为 `[name]-spring-boot-starter` (官方命名方式 `spring-boot-starter-[name]`)
> - 在 `pom.xml` 中添加 `starter` 所需要的依赖
> - 创建 `starter` 相关类（至少有一个自动配置类）
> - 在 `resource` 文件夹下创建 `META-INF` 文件夹 (`srping.factories`)

## 实战

建立一个 `swagger-spring-boot-starter` ,用来简化搭建项目的时候配置 `swagger` 的流程

### 总目录结构

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBootStarter-组件化开发/0.png)

总架构

> `swagger-spring-boot-starter` 的命名方式符合，也说明此项目不属于 `springboot` 官方项目

### 配置pom.xml

> 添加 `spring` 核心开发包和 `swagger` 依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.4.13</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>

    <groupId>com.mobaijun</groupId>
    <artifactId>swagger-spring-boot-starter</artifactId>
    <version>2.4.13</version>

    <name>swagger-spring-boot-starter</name>
    <inceptionYear>2022</inceptionYear>
    <description>swagger-spring-boot-starter</description>
    <url>https://github.com/mobaijun/swagger-spring-boot-starter</url>

    <!-- 版本信息 -->
    <properties>
        <java.version>1.8</java.version>
        <swagger-ui.version>3.0.3</swagger-ui.version>
        <swagger.version>3.0.0</swagger.version>
        <nexus-staging-maven-plugin.version>1.6.8</nexus-staging-maven-plugin.version>
        <maven-release-plugin.version>3.0.0-M1</maven-release-plugin.version>
        <maven-gpg-plugin.version>1.6</maven-gpg-plugin.version>
        <maven-source-plugin.version>3.1.0</maven-source-plugin.version>
        <maven-javadoc-plugin.version>3.1.1</maven-javadoc-plugin.version>
    </properties>

    <!--  许可证  -->
    <licenses>
        <license>
            <name>Apache License, Version 2.0</name>
            <url>https://www.apache.org/licenses/LICENSE-2.0.txt</url>
            <distribution>repo</distribution>
            <comments>A business-friendly OSS license</comments>
        </license>
    </licenses>


    <!--  GitHub issues -->
    <issueManagement>
        <system>GitHub Issues</system>
        <url>https://github.com/mobaijun/swagger-spring-boot-starter/issues</url>
    </issueManagement>

    <scm>
        <url>https://github.com/mobaijun/swagger-spring-boot-starter</url>
        <connection>https://github.com/mobaijun/swagger-spring-boot-starter.git</connection>
        <developerConnection>https://github.com/mobaijun</developerConnection>
    </scm>

    <!--  个人信息  -->
    <developers>
        <developer>
            <name>mobaijun</name>
            <email>wljmobai@gmail.com</email>
            <url>https://www.mobaijun.com</url>
        </developer>
    </developers>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-configuration-processor</artifactId>
            <optional>true</optional>
        </dependency>
        <!-- swagger 3.0 核心依赖包 -->
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-boot-starter</artifactId>
            <version>${swagger.version}</version>
        </dependency>

        <!-- swagger-ui -->
        <dependency>
            <groupId>com.github.xiaoymin</groupId>
            <artifactId>knife4j-spring-boot-starter</artifactId>
            <!--在引用时请在maven中央仓库搜索2.X最新版本号-->
            <version>${swagger-ui.version}</version>
        </dependency>
        <dependency>
    		<!-- 核心依赖包 -->
    		<groupId>org.springframework.boot</groupId>
    		<artifactId>spring-boot-autoconfigure</artifactId>
		</dependency>
    </dependencies>
</project>
```

* 依赖关系图

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBootStarter-组件化开发/1.png)

* 核心开发包

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBootStarter-组件化开发/2.png)

> 核心的 `autoconfiguration`



解释:

> `auto-configuration`，`spring-boot` 有一个 `@EnableAutoConfiguration` 注解，他通过读取`spring.factories` 文件里面的 `EnableAutoConfiguration` 下面指定的类，来初始化指定类下面的所有加了`@bean `的方法，并初始化这个 `bean`.

### 属性配置类

```java
package com.mobaijun.swagger.prop;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

/**
 * Software：IntelliJ IDEA 2021.3.2
 * ClassName: SwaggerProperties
 * 类描述： Swagger配置读取类
 *
 * @author MoBaiJun 2022/3/12 17:24 ---- https://www.mobaijun.com
 */
@ConfigurationProperties(SwaggerProperties.PREFIX)
@EnableConfigurationProperties(SwaggerProperties.class)
public class SwaggerProperties {

    /**
     * 标识
     */
    public static final String PREFIX = "swagger";
}
```

**代码说明：**

> 使用 `@ConfigurationProperties` 注解来设置前缀，在 `application.yml` 中通过 `swagger.XXX=` 来设置。

属性配置类

~~~java
package com.mobaijun.swagger.config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;

/**
 * Software：IntelliJ IDEA 2021.3.2
 * ClassName: SwaggerConfiguration
 * 类描述：
 *
 * @author MoBaiJun 2022/4/26 14:57
 */
@Configuration
@ConditionalOnProperty(name = "swagger.enable", matchIfMissing = true)
public class SwaggerConfiguration {
}
~~~

自动配置类

~~~java
package com.mobaijun.swagger.config;

import com.google.common.collect.Lists;
import com.mobaijun.swagger.prop.SwaggerProperties;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.ApiKey;
import springfox.documentation.service.AuthorizationScope;
import springfox.documentation.service.Contact;
import springfox.documentation.service.SecurityReference;
import springfox.documentation.service.SecurityScheme;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spi.service.contexts.SecurityContext;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger.web.ApiKeyVehicle;

import java.util.Collections;
import java.util.List;

/**
 * Software：IntelliJ IDEA 2021.3.2
 * ClassName: SwaggerConfig
 * 类描述： swagger配置类
 *
 * @author MoBaiJun 2022/4/26 9:09
 */
@Configuration
@Import({SwaggerConfiguration.class})
public class SwaggerAutoConfiguration {

    private final Logger log = LoggerFactory.getLogger(SwaggerAutoConfiguration.class);

    @Bean
    @ConditionalOnMissingBean
    public SwaggerProperties swaggerProperties() {
        return new SwaggerProperties();
    }

    /**
     * # 常用注解说明
     * 1、@Api：用在controller类，描述API接口
     * 2、@ApiOperation：描述接口方法
     * 3、@ApiModel：描述对象
     * 4、@ApiModelProperty：描述对象属性
     * 5、@ApiImplicitParams：描述接口参数
     * 6、@ApiResponses：描述接口响应
     * 7、@ApiIgnore：忽略接口方法
     * 8、访问地址：http://localhost:8003/swagger-ui/index.html#/
     * 9、doc文档访问地址: http://localhost:8003/doc.html
     */
    @Bean
    public Docket createRestApi(SwaggerProperties swaggerProperties) {
        log.info("============================ Swagger Api 构建成功 ============================");
        return new Docket(DocumentationType.SWAGGER_2)
                // 是否启用swagger / 生产环境关闭
                .enable(swaggerProperties.getEnable())
                // 服务器地址
                .host(swaggerProperties.getHost())
                // 设置该 docket 的名字,可以实现多个Docket,实现分组
                .apiInfo(apiInfo(swaggerProperties))
                .select()
                // withMethodAnnotation 扫描所有包含(@ApiOperation)的API,用这种方式更加灵活
                .apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))
                // 正则匹配请求路径，并分配至当前分组，当前所有接口
                .paths(PathSelectors.any())
                .build()
                // 分组名称
                .groupName(swaggerProperties.getGroupName())
                // 授权信息全局应用
                .securityContexts(securityContexts())
                // 授权信息设置，必要的header token等认证信息
                .securitySchemes(apiKeys());
    }

    /**
     * API 页面上半部分展示信息
     */
    private ApiInfo apiInfo(SwaggerProperties sp) {
        return new ApiInfoBuilder()
                // 标题
                .title(sp.getTitle())
                // 说明
                .description(sp.getDescription())
                // 官网
                .termsOfServiceUrl(sp.getTermsOfServiceUrl())
                // 许可证
                .license(sp.getLicense())
                // 许可证地址
                .licenseUrl(sp.getLicenseUrl())
                // 作者信息
                .contact(new Contact(
                        // 作者
                        sp.getContact().getAuthor(),
                        // 博客地址
                        sp.getContact().getUrl(),
                        // 邮箱
                        sp.getContact().getEmail()))
                // 版本
                .version(sp.getVersion())
                .build();
    }

    /**
     * 设置授权信息
     */
    private List<SecurityScheme> apiKeys() {
        return Lists.newArrayList(new ApiKey(swaggerProperties().getAuthorization().getHeader(),
                swaggerProperties().getAuthorization().getToken(), ApiKeyVehicle.HEADER.getValue()));
    }

    /**
     * 授权信息全局应用
     */
    private List<SecurityContext> securityContexts() {
        return Lists.newArrayList(SecurityContext.builder()
                .securityReferences(defaultAuth())
                .forPaths(PathSelectors.regex(swaggerProperties().getAuthorization().getAuthRegex()))
                .build());
    }

    /**
     * 配置默认的全局鉴权策略；其中返回的 SecurityReference 中，reference 即为ApiKey对象里面的name，保持一致才能开启全局鉴权
     */
    private List<SecurityReference> defaultAuth() {
        AuthorizationScope authorizationScope = new AuthorizationScope("global", "accessEverything");
        AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
        authorizationScopes[0] = authorizationScope;
        return Collections.singletonList(SecurityReference.builder()
                .reference(swaggerProperties().getAuthorization().getHeader())
                .scopes(authorizationScopes).build());
    }
}
~~~

扩展注解

~~~java
package com.mobaijun.swagger.annotation;

import com.github.xiaoymin.knife4j.spring.annotations.EnableKnife4j;
import com.mobaijun.swagger.config.SwaggerAutoConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import springfox.bean.validators.configuration.BeanValidatorPluginsConfiguration;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @author MoBaiJun 2022/4/26 9:26
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Configuration
@EnableSwagger2
@EnableKnife4j
@Import({BeanValidatorPluginsConfiguration.class, SwaggerAutoConfiguration.class})
public @interface EnableSwagger {
}
~~~

> 源码地址：[mobaijun/swagger-spring-boot-starter (github.com)](https://github.com/mobaijun/swagger-spring-boot-starter)

### 注册配置

在 `src/main/resource` 下新建 `META-INFO/spring.factories` 文件。
设置如下即可：

```properties
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
com.mobaijun.swagger.config.SwaggerConfiguration
```

如果有多个，逗号分隔即可，如下：

```properties
# 例子
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
org.springframework.boot.autoconfigure.admin.SpringApplicationAdminJmxAutoConfiguration,\
org.springframework.boot.autoconfigure.aop.AopAutoConfiguration,\
org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration
```

### 打包发布

```bash
$ mvn clean install
```

## 快速开始

因为已经将 `starter` 上传到 `maven` 中央仓库，所以直接复制依赖到你的项目中即可直接使用

~~~xml
<dependency>
    <groupId>com.mobaijun</groupId>
    <artifactId>swagger-spring-boot-starter</artifactId>
    <version>2.4.13</version>
</dependency>
~~~



配置说明

~~~yaml
server:
  port: 8002

swagger:
  # 开启swagger
  enable: true
  # 标题
  title: spring-boot-swagger-demo
  # 服务地址
  host: localhost:${server.port}
  # 版本
  version: 1.0.0
  # 组名称
  group-name: 研发部
  # 描述
  description: 这是一个demo
  # 程序地址
  terms-of-service-url: https://localhost:${server.port}/index.html
  # 作者信息配置
  contact:
    # 作者信息
    author: mobaijun
    # 博客地址或官网地址
    url: https://www.mobaijun.com
    # 配置邮箱
    email: mobaijun8@163.com
~~~

> 具体可参考项目源码 `Readme.md` 文档说明

![](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBootStarter-组件化开发/3.png)

## 总结

> 不论项目是什么架构，我们都应该追求代码的复用性，尤其是一些可以复用的功能，如日志，缓存，result api，数据库等操作，都可以抽离出来做成组件，后续开发新项目的时候，直接引入依赖，使得开发人员更加专注于业务开发，推荐大家开发适合自己业务的 `starter` 作为公司的基础架构，毕竟重复的造轮子毫无意义，引用私包维护起来也是恐怖！！！
