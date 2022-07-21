---
title: '【Java基础】Java-[transient关键字复习]'
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - JavaSE
categories:
  - 后端
abbrlink: 3876088395
date: 2020-05-06 15:10:16
img:
coverImg:
password:
summary:
---

# transient

java语言的关键字，变量修饰符，如果用transient声明一个[实例变量](http://baike.baidu.com/view/2320299.htm)，当对象存储时，它的值不需要维持。

~~~java
private transient BaseCalendar.Date cdate;
~~~

* 我们知道，当一个对象实现了Serilizable接口，这个对象就可以被序列化，我们不关心其内在的原理，只需要了解这个类实现了Serilizable接口，这个类的所有属性和方法都会自动序列化。而在开发过程中，我们可能要求：当对象被序列化时（写入字节序列到目标文件）时，有些属性需要序列化，而其他属性不需要被序列化，打个比方，如果一个用户有一些敏感信息（如密码，银行卡号等），为了安全起见，不希望在网络操作（主要涉及到序列化操作，本地序列化缓存也适用）中被传输，这些信息对应的变量就可以加上transient关键字。
* 换句话说，这个字段的生命周期仅存于调用者的内存中而不会写到磁盘里持久化。
  所以，transient的用途在于：阻止实例中那些用此关键字声明的变量持久化；当对象被反序列化时（从源文件读取字节序列进行重构），这样的实例变量值不会被持久化和恢复。例如，当反序列化对象——数据流（例如，文件）可能不存在时，原因是你的对象中存在类型为java.io.InputStream的变量，序列化时这些变量引用的输入流无法被打开。
  2，使用方法

* 序列化的时候，将不需要序列化的属性前添加关键字transient即可。