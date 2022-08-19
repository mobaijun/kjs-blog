---
title: 【WEB系列】高版本SpringBoot整合Swagger启动异常问题
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3051425539
tags:
- BUG
categories:
- SpringBoot
date: 2022-05-13 11:32:18
img:
coverImg:
password:
summary:
---

## 前言：

> Spring Boot 2.6.x 版本引入依赖 springfox-boot-starter (Swagger 3.0) 后，启动项目会报错：
>
> Failed to start bean ‘ documentationPluginsBootstrapper ‘ ; nested exception…
>
> > 异常信息：
> >
> > `Error starting ApplicationContext. To display the conditions report re-run your application with 'debug' enabled.
> > 2022-05-13 11:34:35.770 [main] ERROR org.springframework.boot.SpringApplication - Application run failed
> > org.springframework.context.ApplicationContextException: Failed to start bean 'documentationPluginsBootstrapper'; nested exception is java.lang.NullPointerException`

![](https://tencent.cos.mobaijun.com/article_with_pictures/I7MFqR1d9JPOVsf.png)

## 原因：

> Springfox 假设 Spring MVC 的路径匹配策略是 `ant-path-matcher`，而 Spring Boot 2.6.x版本的默认匹配策略是 `path-pattern-matcher`，这就造成了上面的报错。

## 解决方案

1. 第一种，添加配置类

> 继承 WebMvcConfigurationSupport 重写 addResourceHandlers 方法。

* 编写配置类

~~~java
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;

/**
 * software：IntelliJ IDEA 2022.1
 * class name: WebMvcConfig
 * class description： web 配置类
 *
 * @author MoBaiJun 2022/5/13 11:25
 */
@Configuration
public class WebMvcConfig extends WebMvcConfigurationSupport {

    /**
     * 解决 org.springframework.context.ApplicationContextException: Failed to start bean <br>
     * 'documentationPluginsBootstrapper'; nested exception is java.lang.NullPointerException
     * 发现如果继承了 WebMvcConfigurationSupport，则在yml中配置的相关内容会失效。 需要重新指定静态资源
     *
     * @param registry ResourceHandlerRegistry
     * @see <a href="https://www.mobaijun.com/posts/3051425539.html"></a>
     */
    @Override
    protected void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
        registry.addResourceHandler("swagger-ui.html", "doc.html")
                .addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");
        super.addResourceHandlers(registry);
    }
}
~~~

> PS Time 2022:05:20 : 使用上面这种引发了一个新问题，那就是 swagger-ui/index.html 无法访问了 , 以下为解决方案

~~~java
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;

/**
 * software：IntelliJ IDEA 2022.1
 * class name: WebMvcConfig
 * class description： web 配置类
 *
 * @author MoBaiJun 2022/5/13 11:25
 */
@Configuration
public class WebMvcConfig extends WebMvcConfigurationSupport {

    /**
     * 解决 org.springframework.context.ApplicationContextException: Failed to start bean <br>
     * 'documentationPluginsBootstrapper'; nested exception is java.lang.NullPointerException
     * <a href="http://localhost:8891/swagger-ui/index.html#/">...</a>
     *
     * @param registry ResourceHandlerRegistry
     * @see <a href="https://www.mobaijun.com/posts/3051425539.html"></a>
     */
    @Override
    protected void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
        // 解决 swagger 无法访问
        registry.addResourceHandler("swagger-ui/**", "doc.html")
                // 解决 doc.html 无法访问
                .addResourceLocations("classpath:/META-INF/resources/**",
                        // 解决 swagger 无法访问
                        "classpath:/META-INF/resources/webjars/springfox-swagger-ui/")
                .resourceChain(false);
        // 解决 swagger js 无法访问
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");
        super.addResourceHandlers(registry);
    }
}
~~~

2. 第二种，修改配置文件（我没有尝试过）

~~~yaml
spring:
  mvc:
    pathmatch:
      matching-strategy: ant_path_matcher
~~~

> 需要注意的是：这种方法无法彻底解决问题，只有在不使用 Spring Boot 的执行器时，此功能才起作用。
>
> 无论配置的匹配策略如何，执行器将始终使用基于路径模式的解析 ( 也就是默认策略 ) 。
>
>
>
> 如果你想在 Spring Boot 2.6 及更高版本中将其与执行器一起使用，则需要对 Springfox 进行更改。
>
> 这个办法是我在 github 上找到的，一个大佬提了一个解决方案是将 Springfox 的某 .java 文件复制到自己项目里进行修改，另一个大佬提了一个更好的解决方案，我觉得针不戳，在这里分享一下：
>
> 在你的项目里添加这个 bean ：（加在配置类里就可）[Spring Boot 2.6.x整合Swagger启动失败报错问题解决（治标还治本）_toollong的博客-CSDN博客](https://blog.csdn.net/weixin_49523761/article/details/122305980?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-122305980-blog-122100139.pc_relevant_antiscanv2&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-122305980-blog-122100139.pc_relevant_antiscanv2&utm_relevant_index=1)

~~~java
@Bean
public static BeanPostProcessor springfoxHandlerProviderBeanPostProcessor() {
    return new BeanPostProcessor() {

        @Override
        public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
            if (bean instanceof WebMvcRequestHandlerProvider || bean instanceof WebFluxRequestHandlerProvider) {
                customizeSpringfoxHandlerMappings(getHandlerMappings(bean));
            }
            return bean;
        }

        private <T extends RequestMappingInfoHandlerMapping> void customizeSpringfoxHandlerMappings(List<T> mappings) {
            List<T> copy = mappings.stream()
                    .filter(mapping -> mapping.getPatternParser() == null)
                    .collect(Collectors.toList());
            mappings.clear();
            mappings.addAll(copy);
        }

        @SuppressWarnings("unchecked")
        private List<RequestMappingInfoHandlerMapping> getHandlerMappings(Object bean) {
            try {
                Field field = ReflectionUtils.findField(bean.getClass(), "handlerMappings");
                field.setAccessible(true);
                return (List<RequestMappingInfoHandlerMapping>) field.get(bean);
            } catch (IllegalArgumentException | IllegalAccessException e) {
                throw new IllegalStateException(e);
            }
        }
    };
}
~~~

> 参考文章：
>
> [java - Failed to start bean 'documentationPluginsBootstrapper' in spring data rest - Stack Overflow](https://stackoverflow.com/questions/40241843/failed-to-start-bean-documentationpluginsbootstrapper-in-spring-data-rest)
>
> [Spring Boot 2.6.x整合Swagger启动失败报错问题解决（治标还治本）_toollong的博客-CSDN博客](https://blog.csdn.net/weixin_49523761/article/details/122305980?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-122305980-blog-122100139.pc_relevant_antiscanv2&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-122305980-blog-122100139.pc_relevant_antiscanv2&utm_relevant_index=1)
