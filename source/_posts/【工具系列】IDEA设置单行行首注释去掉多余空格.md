---
title: 【工具系列】IDEA设置单行行首注释去掉多余空格
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - IDEA技巧
categories:
  - 工具
abbrlink: 385939477
date: 2020-04-30 09:48:26
img:
coverImg:
password:
summary:
---

> IDEA中Java代码使用快捷键"ctrl+/"添加行注释时，发现出现多余空格：

~~~java
public class Demo1 {
	public static void main(String[] args) {
//          整型
		int i = 20;
		System.out.println("i = " + i);
        // 整型
		int i1 = 20;
		System.out.println("i1 = " + i1);
	}
}
~~~

这和我理想的注释风格差距太大了,对于我这个有轻微强迫症的人来说是不能忍的,解决方案如下

打开`idea：file>settings>Editor>code style>java>勾选use tab character`表示tab缩进不使用空格而使用制表符，如果使用空格就会出现上述多余空格问题。

设置完这个地方还需要再设置一个地方

![设置](https://mobaijun.gitee.io/mobai_images.gitee.io/img/zatu/1.jpg)

在`Code Generation`标签卡中取消勾选`Line comment at first column`和`Block comment at first column`，然后勾选`Add a space at comment start`就好了。 最后在“Scheme”中设置项目“Project”。然后重新使用快捷键注释即可达到效果

~~~java
public class Demo1 {
	public static void main(String[] args) {		
		// 小数
		double l = 100.0;
		System.out.println(l);
	}
~~~

