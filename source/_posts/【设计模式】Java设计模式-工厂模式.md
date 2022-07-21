---
title: 【设计模式】Java设计模式-工厂模式
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - Factory
categories:
  - 后端
abbrlink: 973523555
date: 2020-05-29 13:21:45
img:
coverImg:
password:
summary:
---

### 工厂模式

>工厂模式（Factory Pattern）是 Java 中最常用的设计模式之一。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。
>
>在工厂模式中，我们在创建对象时不会对客户端暴露创建逻辑，并且是通过使用一个共同的接口来指向新创建的对象。

### 介绍

**意图：**定义一个创建对象的接口，让其子类自己决定实例化哪一个工厂类，工厂模式使其创建过程延迟到子类进行。

**主要解决：**主要解决接口选择的问题。

**何时使用：**我们明确地计划不同条件下创建不同实例时。

**如何解决：**让其子类实现工厂接口，返回的也是一个抽象的产品。

**关键代码：**创建过程在其子类执行。

**应用实例：** 1、您需要一辆汽车，可以直接从工厂里面提货，而不用去管这辆汽车是怎么做出来的，以及这个汽车里面的具体实现。 2、Hibernate 换数据库只需换方言和驱动就可以。

**优点：** 1、一个调用者想创建一个对象，只要知道其名称就可以了。 2、扩展性高，如果想增加一个产品，只要扩展一个工厂类就可以。 3、屏蔽产品的具体实现，调用者只关心产品的接口。

**缺点：**每次增加一个产品时，都需要增加一个具体类和对象实现工厂，使得系统中类的个数成倍增加，在一定程度上增加了系统的复杂度，同时也增加了系统具体类的依赖。这并不是什么好事。

**使用场景：** 1、日志记录器：记录可能记录到本地硬盘、系统事件、远程服务器等，用户可以选择记录日志到什么地方。 2、数据库访问，当用户不知道最后系统采用哪一类数据库，以及数据库可能有变化时。 3、设计一个连接服务器的框架，需要三个协议，"POP3"、"IMAP"、"HTTP"，可以把这三个作为产品类，共同实现一个接口。

**注意事项：**作为一种创建类模式，在任何需要生成复杂对象的地方，都可以使用工厂方法模式。有一点需要注意的地方就是复杂对象适合使用工厂模式，而简单对象，特别是只需要通过 new 就可以完成创建的对象，无需使用工厂模式。如果使用工厂模式，就需要引入一个工厂类，会增加系统的复杂度。

### 示范代码

由于客户的数据库环境经常变化，希望更换数据库时候，只需要修改dao的代码，不需要修改service。

* 设计dao

~~~java
public interface UserDao {
    public void save();
}
~~~

* 设计daoimpl实现

~~~java
/**
基于MySQL存储实现类
*/
public class UserDaoMysqlImpl implements UserDao {
    @Override
    public void save() {
        System.out.println("数据已经保存到MySQL数据库中了");
    }
}
~~~

* 设计service接口

~~~java
public interface UserService {
    public void save();
}
~~~

* 设计serviceimpl实现

~~~java
public class UserServiceImpl implements UserService {
    // 注入Dao
    private UserDao userDao = new UserDaoMysqlImpl();


    /**
     * @Author: Auser·杰
     * Development: IntelliJ IDEA 2018.2.4 x64
     * MethodName: save
     * Param: []
     * Return: void
     * 方法说明: 调用dao方法
     */
    @Override
    public void save() {
        userDao.save();
    }
}
~~~

* 测试类

```java
public class UserTest {
    @Test
    public void testSave() {
        // New一个实现方法
        UserService userService = new UserServiceImpl();
        userService.save();
    }
}
```

> * 开闭原则
>
> 在一个项目中,如果需要添加功能,最好是遵守开闭原则
>
> * 对修改关闭(不能修改代码)
> * 对扩展开放
>
> 比如在一个项目中,如果你需要添加功能,最好是在项目已有的基础上进行添加模块(添加类,接口,方法),简单说就是尽量少改代码,而是扩展代码

#### 优化代码

* 这时，需要从mysql切换到Oracle数据，根据开闭原则，扩展了Dao实现

~~~java
public class UserDaoOracleImpl implements UserDao {
    @Override
    public void save() {
        System.out.println("数据已经保存到Oracle数据库中了");
    }
}
~~~

* 切换dao实现类

~~~java
public class UserServiceImpl implements UserService {
    // 注入Dao
    // private UserDao userDao = new UserDaoMysqlImpl();

    // 切换Dao实现类
    private UserDao userDao = new UserDaoOracleImpl();

    /**
     * 方法说明: 调用dao方法
     */
    @Override
    public void save() {
        userDao.save();
    }
}
~~~

> 这样每次都需要修改代码,Service和Dao的耦合性太高
>
> 可以使用工厂模式(Factory)解决问题

* 可以设计一个对象工厂

~~~java
/**
	创建对象(UserDao实现类对象)
*/
public class BeanFactory {
    public static UserDao getBean() {
        return new UserDaoMysqlImpl();
    }
} 
~~~

* 业务层就可以从工厂获取对象

~~~java
public class UserServiceImpl implements UserService {
    // 注入Dao
    // private UserDao userDao = new UserDaoMysqlImpl();

    // 切换Dao实现类
    // private UserDao userDao = new UserDaoOracleImpl();

    // 从工厂获取对象
    private UserDao userDao = BeanFactory.getBean();

    /**
     * 方法说明: 调用dao方法
     */
    @Override
    public void save() {
        userDao.save();
    }
}
~~~

> 这个时候如果我们需要更换需求(切换数据库),可以直接修改工厂类里面的代码

~~~java
/**
创建对象(UserDao实现类对象)
*/
public class BeanFactory {
    public static UserDao getBean() {
        return new UserDaoOracleImpl();
    }
} 
~~~

> 但是这个工厂不好,功能太少,我们需要构建一个可以创建任何对象的工厂

* 在resources下面创建一个`bean.properties`

~~~properties
userDao=com.mobaijun.dao.impl.UserDaoMysqlImpl
userService=com.mobaijun.service.impl.UserServiceImpl
~~~

* 优化工厂

~~~java
// 实例化一个bundle
    private static ResourceBundle bundle;

    // 通过读取bean.properties创建相应的对象
    public static Object getBean(String key) {
        // 读取bean.properties
        if (bundle == null) {
            bundle = ResourceBundle.getBundle("bean");
        }
        // 通过key获取value
        String className = bundle.getString(key);

        // 通过反射创建对象
        try {
            return Class.forName(className).newInstance();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
~~~

* 修改service

~~~java
public class UserServiceImpl implements UserService {
    // 注入Dao
    // private UserDao userDao = new UserDaoMysqlImpl();

    // 切换Dao实现类
    // private UserDao userDao = new UserDaoOracleImpl();

    // 从工厂获取对象
    private UserDao userDao = (UserDao) BeanFactory.getBean("userDao");

    /**
     * 方法说明: 调用dao方法
     */
    @Override
    public void save() {
        userDao.save();
    }
}
~~~

* 修改测试

~~~Java
public class UserTest {
    @Test
    public void testSave() {
        // New一个实现方法
        UserService userService = (UserService) BeanFactory.getBean("userService");
        userService.save();
    }
}
~~~

> 这个时候所有的依赖关系全部转移到了配置文件`bean.properties`,需要更换数据库需求时,直接修改配置文件即可,这个时候代码的耦合度就降低了(service/dao解耦),但是耦合没有消失,只是转移到配置文件了
>
> * 使用工厂模式,可以让service和Dao的耦合降低

* 修改配置文件

~~~properties
# userDao=com.mobaijun.dao.impl.UserDaoMysqlImpl
userDao=com.mobaijun.dao.impl.UserDaoOracleImpl
userService=com.mobaijun.service.impl.UserServiceImpl
~~~

> 可以称IOC容器为Bean工厂,提供解耦,(工厂就是IOC容器)
>
> 未经授权,禁止转载;
>
> > 本文页头内容参考菜鸟教程:[传送门](https://www.runoob.com/design-pattern/factory-pattern.html)