---
title:  【工具系列】Lombok
author: 框架师|墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - Lombok
categories:
  - 后端
abbrlink: 529462236
date: 2020-10-20 21:28:07
img:
coverImg:
password:
summary:
---

### Lombok概述

* [官网地址](https://projectlombok.org/)
* [官网API文档传送门](https://projectlombok.org/features/all)
* 以下是官方简介

~~~tcl
Project Lombok is a java library that automatically plugs into your editor and build tools, spicing up your java.
Never write another getter or equals method again, with one annotation your class has a fully featured builder, Automate your logging variables, and much more.
######################################################################################
百度翻译:Project Lombok是一个java库，它自动插入到编辑器和构建工具中，增强java的性能。
不要再编写另一个getter或equals方法，使用一个注释，您的类有一个功能齐全的生成器，自动记录变量，等等。
~~~

>大概的意思：Lombok是一个Java库，能自动插入编辑器并构建工具，简化Java开发。通过添加注解的方式，不需要为类编写getter或eques方法，同时可以自动化日志变量。

### 到底该不该用 Lombok

> 这个问题一直有争议，爱它的人爱的要死，恨它的人恨地要死。

| 正方观点                         | 反方观点                                                     |
| :------------------------------- | :----------------------------------------------------------- |
| 代码干净整洁，工作量大大降低     | 强侵入性，强 X 队友，一人用都得用，否则编译通不过            |
| 代码可读性增强，保持代码风格一致 | 失去了封装意义，因为有些属性不一定想提供公共的getter/setter方法 |
| Bean修改后，不需要修改模板化代码 | IDE和JDK升级存在破裂的风险                                   |

### 安装

* 引入maven依赖

~~~xml
    <dependencies>
        <!--Lombok依赖-->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.12</version>
        </dependency>
    </dependencies>
~~~

* `IDEA`下载插件

定位到`file/setings/plugins/markeptlace`搜索`Lombok`

![](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200606105546.png)

### 常用注解

>可以使用@Getter 或 @Setter标注任何字段，lombok 可以帮助你自动生成默认的get、set方法。
>默认的get、set方法是public的，除非你额外设置AccessLevel(访问权限)

* @Getter/@Setter

![](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200606110301.gif)

* 使用Lombok方式：

~~~java
@Getter
@Setter
public class Person {
    private String name;
    private Integer age;
}

/**
* @Getter @Setter private int age = 10; //其他写法
* @Setter(AccessLevel.PROTECTED) private String name;
*/
~~~

### @ToString

> 任何类的定义上都可以被`@ToString`标注，`lombok`可以生成一个`toString()`的实现方法。
> 默认打印类名以及每个字段并且用逗号分隔。可以使用`exclude`排除多个字段，`of`必须包含哪些字段。

* 使用Lombok方式：

~~~java
@Getter
@Setter
@ToString
// @ToString(exclude = {"字段1","字段2"} ,of = {"",""})
public class Person {
    private String name;
    private Integer age;
}
~~~

### @Data

> @Data 注解在类上面，自动生成`setter/getter、equals、canEqual、hashCode、toString`方法，如某个属性为final，则不会为该属性生成setter方法。

* 使用Lombok方式

~~~java
@Data
public class Person {
    private String name;
    private Integer age;
}
~~~

### @NonNull使用

>可以在方法或构造器的参数上使用 `@NonNull,lombok`会为你生成一个空值检查的声明。
>相当于

```java
if (param == null) {
        throw new NullPointerException("param is marked @NonNull but is null");
}
```

* 使用lombok方式：

~~~java
@Data
public class Person {
    /**
    * 可以加在成员变量前，也可以加在方法参数前。用来指定某个字段不能为空
    **/
    @NonNull
    private String name;
    private Integer age;

    public Person(@NonNull String person) {
        this.name = person;
    }
}
~~~

### @Cleanup使用

>您可以使用@Cleanup来确保在代码执行路径退出当前作用域之前自动清除给定的资源。
>其实就是关闭注解标注的当前资源。【简单了解一下就行，一般也用不上】

* 使用lombok方式：

```java
public static void main(String[] args) throws Exception {
    @Cleanup InputStream in = new FileInputStream(args[0]);
    @Cleanup OutputStream out = new FileOutputStream(args[1]);
    byte[] b = new byte[1024];
    while (true) {
        int r = in.read();
        if (r == -1) break;
        out.write(b, 0, r);
    }
}
```

### @EqualsAndHashCode

>任何类的定义上都可以被`@EqualsAndHashCode`标注，lombok可以生成一个`equals(Object other)`和hashCode()的实现方法。它将使用所有非静态，非瞬态字段，但是可以通过使用`@ EqualsAndHashCode.Include`或`@EqualsAndHashCode`标记类型成员来修改使用的字段。

* 官网代码(没看明白)：

~~~java
import lombok.EqualsAndHashCode;
/**
* 生成equals方法、canEqual（判断是否属于Car类）、hashCode方法。也可以进行相等比较的排除，指定。
**/
@EqualsAndHashCode
// @EqualsAndHashCode(exclude = {"字段1","字段2"})
public class EqualsAndHashCodeExample {
  private transient int transientVar = 10;
  private String name;
  private double score;
  @EqualsAndHashCode.Exclude private Shape shape = new Square(5, 10);
  private String[] tags;
  @EqualsAndHashCode.Exclude private int id;
  
  public String getName() {
    return this.name;
  }
  
  @EqualsAndHashCode(callSuper=true)
  public static class Square extends Shape {
    private final int width, height;
    
    public Square(int width, int height) {
      this.width = width;
      this.height = height;
    }
  }
}
~~~

### @NoArgsConstructor

> * @NoArgsConstructor
>
> * @RequiredArgsConstructor
>
> * @AllArgsConstructor
>
>   >这组3个注释会生成一个构造函数，该构造函数将为某些字段接受1个参数，并将该参数简单地分配给该字段。
>   >
>   >* @NoArgsConstructor 将生成没有参数的构造器；
>   >* @RequiredArgsConstructor 为需要特殊处理的每个字段生成一个带有1个参数的构造函数；
>   >* @AllArgsConstructor 为类中的每个字段生成一个带有1个参数的构造函数。

* 使用Lombok方式：

~~~java
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.NonNull;

@RequiredArgsConstructor(staticName = "of")
@AllArgsConstructor(access = AccessLevel.PROTECTED)
public class ConstructorExample<T> {
  private int x, y;
  @NonNull private T description;
  
  @NoArgsConstructor
  public static class NoArgsExample {
    @NonNull private String field;
  }
}
~~~

### @Value使用

> @Value是@Data的不可变形式； 默认情况下，所有字段都设为私有和final的字段，并且不会生成setter。

* 使用Lombok方式：

~~~java
import lombok.AccessLevel;
import lombok.experimental.NonFinal;
import lombok.experimental.Value;
import lombok.experimental.Wither;
import lombok.ToString;

@Value public class ValueExample {
  String name;
  @Wither(AccessLevel.PACKAGE) @NonFinal int age;
  double score;
  protected String[] tags;
  
  @ToString(includeFieldNames=true)
  @Value(staticConstructor="of")
  public static class Exercise<T> {
    String name;
    T value;
  }
}
~~~

### @Builder使用

> * @Builder注解会为您的类生成复杂的构建器API。
> * @Builder可自动生成使你的类可被实例化的代码。

* 使用Lombok方式：

```java
import lombok.Builder;
import lombok.Singular;
import java.util.Set;

@Builder
public class BuilderExample {
  @Builder.Default private long created = System.currentTimeMillis();
  private String name;
  private int age;
  @Singular private Set<String> occupations;
}
```

* 使用此注解进行对象的构建，函数式编程/链式编程，省去逐行字段set。

~~~java
Person.builder()
.name("Adam Savage")
.city("San Francisco")
.job("Mythbusters")
.job("Unchained Reaction")
.build();
~~~

### @SneakyThrows

> @SneakyThrows可用于偷偷地抛出已检查的异常，而无需在方法的throws子句中实际声明。

* 使用Lombok方式：

```java
import lombok.SneakyThrows;

public class SneakyThrowsExample implements Runnable {
  @SneakyThrows(UnsupportedEncodingException.class)
  public String utf8ToString(byte[] bytes) {
    return new String(bytes, "UTF-8");
  }
  
  @SneakyThrows
  public void run() {
    throw new Throwable();
  }
}
```

### @Synchronized使用

>@Synchronized是同步方法修饰符的更安全的变体。
>与同步一样，注释只能在静态和实例方法上使用。 它的操作类似于synchronized关键字，但是它锁定在不同的对象上    

* 使用lombok方式：

```java
import lombok.Synchronized;

public class SynchronizedExample {
  private final Object readLock = new Object();
  
  @Synchronized
  public static void hello() {
    System.out.println("world");
  }
  
  @Synchronized
  public int answerToLife() {
    return 42;
  }
  
  @Synchronized("readLock")
  public void foo() {
    System.out.println("bar");
  }
}
```

### @With 使用

>The next best alternative to a setter for an immutable property is to construct a clone of the object, but with a new value for this one field. A method to generate this clone is precisely what @With generates: a withFieldName(newValue) method which produces a clone except for the new value for the associated field.
>
>说实话没看明白这段话是什么意思，个人理解为：在类的字段上标注 @With 注解之后，将会自动生成一个 withFieldName(newValue) 的方法，该方法会基于 newValue 调用相应构造函数，创建一个当前类对应的实例。

* 使用lombok方式：

```js
import lombok.AccessLevel;
import lombok.NonNull;
import lombok.With;

public class WithExample {
  @With(AccessLevel.PROTECTED) @NonNull private final String name;
  @With private final int age;
  
  public WithExample(String name, int age) {
    if (name == null) throw new NullPointerException();
    this.name = name;
    this.age = age;
  }
}
```

### @Getter(lazy=true)

> ​	@Getter 注解支持一个 lazy 属性，该属性默认为 false。当设置为 true 时，会启用延迟初始化，即当首次调用 getter 方法时才进行初始化。

* 使用lombok方式：

~~~java
import lombok.Getter;

public class GetterLazyExample {
  @Getter(lazy=true) private final double[] cached = expensive();
  
  private double[] expensive() {
    double[] result = new double[1000000];
    for (int i = 0; i < result.length; i++) {
      result[i] = Math.asin(i);
    }
    return result;
  }
}
~~~

### @Log

支持Log4j、Slf4j，日志功能

~~~java
public static void main(String[] args) {
    CarLombok build = CarLombok.builder().id(1).type("string").price(88.8).level('a').build();
    System.out.println(build.toString());
    build.logTest("input");
    }
public void logTest(String test){
    log.info("test function");
    System.out.println(test);
    }
~~~

### @Accessors使用

>@Accessors注释用于配置lombok如何生成和查找getter和setter。
>默认情况下，lombok遵循针对getter和setter的bean规范：例如，名为Pepper的字段的getter是getPepper。 但是，有些人可能希望打破bean规范，以得到更好看的API。 @Accessors提供3种方式:
>fluent--》 一个布尔值。如果为真，pepper的getter就是 pepper()，setter方法就是pepper(T newValue)。并且，除非特别说明，chain默认为真。
>chain--》  一个布尔值。如果为真，产生的setter返回的this而不是void。默认是假。如果fluent=true，那么chain默认为真。 
>prefix--》 一系列string类型。如果显示，属性必须加上某些定义的前缀。

* 使用lombok方式：

```js
import lombok.experimental.Accessors;
import lombok.Getter;
import lombok.Setter;

@Accessors(fluent = true)
public class AccessorsExample {
  @Getter @Setter
  private int age = 10;
}

class PrefixExample {
  @Accessors(prefix = "f") @Getter
  private String fName = "Hello, World!";
}
```

### Lombok工作原理

Java编译过程大致可以分为3个过程:

1. 解析与填充符号表过程。
2. 插入式注解处理器的注解处理过程。
3. 分析与字节码生成过程。

Lombok本质上就是一个实现了“[JSR 269 API](https://www.ithome.com.tw/voice/128002)”的程序。在javac的过程中，Lombok会在上述第2个步骤根据Lombok注解，修改语法树（[AST](https://blog.csdn.net/peng425/article/details/102814754）)，从而给class增加新的节点（代码块）。

> **学习链接**
>
> [传送门一](https://cloud.tencent.com/developer/article/1639349)
>
> [传送门二](http://www.imooc.com/article/301356)