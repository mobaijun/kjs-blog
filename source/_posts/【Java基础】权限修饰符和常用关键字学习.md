---
title: 【Java基础】权限修饰符和常用关键字学习
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - Java基础
categories:
  - 后端
abbrlink: 1663206604
date: 2020-04-15 13:19:21
img:
coverImg:
password:
summary:
---

## 权限修饰符和常用关键字学习

### Public(公共权限)

* public:(公共权限)

> * 可以修饰类,成员变量,成员方法,构造方法
> * 被public修饰的成员,可以在任何一个类中被调用,不管同包或不同包,是权限最大的一个修饰符

~~~java
public class Demo{
  
}
~~~



### Private(私有权限)

* private:(私有权限)

> * 可以修饰成员变量,构造方法,成员方法,不能修饰类(外部类,内部类不考虑)
>
> * 被private修饰的成员,只能在定义它们的类中使用,在其他类中不能调用。

~~~java
public class Demo {
    // 可以使用private修饰成员变量
    // 名称
    private String name;
    // 年龄
    private int age;

    // 可以修饰构造方法
    private Demo(){

    }
    // 可以修饰成员方法
    private void getTest(){

    }
}
~~~



### Default(默认权限)

* default(默认权限)

> * 类,成员变量,成员方法,构造方法都能使用默认权限,即不写任何关键字
> * 默认权限即同包权限,同包权限的元素只能在定义它们的类中使用,以及同包的类中被调用

~~~java
class Demo {
    
}
~~~



### Protected(受保护权限)

* protected:(受保护权限)

> * 可以修饰成员变量,成员方法,构造方法,不能修饰类(外部类,内部类不考虑)
> * 被private修饰的成员,只能在定义它们的类中使用,在其他类中不能调用。
> * 如果有不同包的类想调用它们,那么这个类必须是定义它们的类的子类。

~~~java
class A{
    protected int num = 1 ;
}
public class B extends A{
        public void fun(){
            new A().num;//不可以访问
    }
}
~~~



### **注意**

* 并不是每个修饰符都可以修饰类(指外部类),只有public和default可以。
* 所有修饰符都可以修饰数据成员,方法成员,构造方法。
* 为了代码安全起见,修饰符不要尽量使用权限大的,而是适用即可。比如,成员变量,如果没有特殊需要,尽可能用 private 
*  修饰符修饰的是”被访问”的权限 

|  修饰符   | 同类中 | 同一个包中(子类和无关类) | 不同包(子类) | 不同包(无关类) |
| :-------: | :----: | :----------------------: | :----------: | :------------: |
|  public   |   Y    |            Y             |      Y       |       Y        |
| protected |   Y    |            Y             |      Y       |       N        |
|   缺省    |   Y    |            Y             |      N       |       N        |
|  private  |   Y    |            N             |      N       |       N        |

### 状态修饰符

* static

> * 静态的意思,可以修饰成员变量,成员方法,不能修饰类(普通类)和构造方法
> * 被修饰的变量和方法可以通过类名调用

~~~java
    // 将用户相关变量修饰为静态常量
		private static final String DRIVER_CLASS = "com.mysql.jdbc.Driver";
		private static final String URL = "jdbc:mysql:///test";
		private static final String USER = "root";
		private static final String PASSWORD = "root";

		// 可以修饰成员方法
    public static Connection getConnection() throws Exception {
        InputStream is = JDBCUtils.class.getResourceAsStream("/jdbc.properties");
        Properties pp = new Properties();
        pp.load(is);

        Connection conn = DriverManager.getConnection(URL, pp);
        return conn;
    }
~~~

* final

> * 最终的意思,可以修饰类,成员变量,成员方法,不能修饰构造方法
> * 修饰的类不能被继承,被修饰的变量是常量不可变参数,被修饰的方法不能被继承

~~~java
// 1.将固定字符串定义为常量
private static final String DRIVER_CLASS = "com.mysql.jdbc.Driver";
private static final String URL = "jdbc:mysql:///test";
private static final String USER = "root";
private static final String PASSWORD = "root";
~~~

### 抽象关键字

* abstract

> * 抽象的意思,不能修饰构造方法,不能修饰成员变量,可以修饰类和成员方法
> * 被修饰的类不能被实例化,只能被继承,被修饰的成员方法在子类中必须被重写

~~~java
// 可以修饰类
public abstract class Demo1 {
    // 可以修饰成员方法
    public abstract void getTest();
}
~~~

### 关键字

* Super

> * 子类的每个构造方法中均有默认的super()，调用父类的空参构造。手动调用父类构造会覆盖默认的super().
>
> * super() 和 this() 都必须是在构造方法的第一行，所以不能同时出现。
>
> * super(..)是根据参数去确定调用父类哪个构造器的。

* This

> * this代表所在类的当前对象的引用（地址值），即代表当前对象。
> * this可以出现在实例方法或者构造器中
>
> * this出现在实例方法中，谁调用这个方法（哪个对象调用这个方法），this就代表谁（this就代表哪个对象）。
> * this出现在构造器中，代表构造器正在初始化的那个对象。

### 一个完美的JavaBean

~~~ java
public class Demo{
  // 成员变量
  // 无参构造器【必须】
  // 满参构造器
  // getter方法
  // setter方法
  // toString方法
}
~~~

