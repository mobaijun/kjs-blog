---
title: '【Java基础】Java基础复习[System,StringBuider,装箱,拆箱]'
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - JavaSE
categories:
  - 后端
abbrlink: 161197765
date: 2020-05-06 10:13:50
img:
coverImg:
password:
summary:
---

# System类

> `java.lang.System` 类中提供了大量的静态方法，可以获取与系统相关的信息或系统级操作，在`System`类的`API`文 档中，常用的方法有：

* `public static long currentTimeMillis() `：返回以毫秒为单位的当前时间。 
* `public static void arraycopy(Object src, int srcPos, Object dest, int destPos, int length)` ：将 数组中指定的数据拷贝到另一个数组中。 

## currentTimeMillis()方法

> 实际上，currentTimeMillis方法就是 获取当前系统时间与1970年01月01日00:00点之间的毫秒差值

### 代码示例

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/6 10:19
 * ClassName:SystemDemo1
 * 类描述：获取当前时间毫秒值
 */
public class SystemDemo1 {
	public static void main(String[] args) {
		// 获取当前时间的毫秒值
		System.out.println(System.currentTimeMillis());
		// 计算程序运行时间
		long start = System.currentTimeMillis();
		for (int i = 0; i < 10000; i++) {
			System.out.println("i = " + i);
		}
		long end = System.currentTimeMillis();
		// 根据电脑配置以及其他因素我这里运行1000次循环i时间为: 446毫秒值
		System.out.println("本程序运行时间为: " + (end - start));
	}
}
~~~

## arraycopy(***)方法

> public static void arraycopy(Object src, int srcPos, Object dest, int destPos, int length) ：将 数组中指定的数据拷贝到另一个数组中。

数组的拷贝动作是系统级的，性能很高。System.arraycopy方法具有5个参数，含义分别为

| 参数序号 | 参数名称 | 参数类型 |       参数含义       |
| :------: | :------: | :------: | :------------------: |
|    1     |   src    |  Object  |        源数组        |
|    2     |  srcPos  |   int    |    源数组起始位置    |
|    3     |   dest   |  Object  |       目标数组       |
|    4     | destPos  |   int    | 目标数组索引起始位置 |
|    5     |  length  |   int    |     复制元素个数     |

### 代码参考

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/6 10:30
 * ClassName:SystemDemo2
 * 类描述：复制数组的内容到新数组中
 */
public class SystemDemo2 {
	public static void main(String[] args) {
		// 创建两个数组,标记索引
		//             0  1   3   4   5
		int[] arr1 = {11, 22, 33, 44, 55};
		//            0  1  2  3  4  5  6  7  8  9
		int[] arr2 = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
		/*
		  static void arraycopy​(Object src, int srcPos, Object dest, int destPos, int length) 复制数组的内容到新数组中
      Object src: 源数组,要被复制的数组
      int srcPos: 从源数组哪个位置开始
      Object dest: 目标数组
      int destPos: 目标数组的哪个位置
      int length: 复制的元素的个数
		*/
		System.arraycopy(arr1, 4, arr2, 4, 1);
		// 调用Arrays.toString()打印数组
		// 复制后的数组:[0, 0, 0, 0, 55, 0, 0, 0, 0, 0]
		System.out.println("复制后的数组:" + Arrays.toString(arr2));
	}
}
~~~

### 练习

> 需求:获取复制一个数组需要消耗的时间

~~~java
public class SystemDemo3 {
	public static void main(String[] args) {
		// 开始时间
		long start = System.currentTimeMillis();
		//                     0  1   3   4   5
		int[] arr1 = new int[]{11, 22, 33, 44, 55};
		//                     0  1  2  3  4  5  6  7  8  9
		int[] arr2 = new int[]{0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
		// 复制数组
		System.arraycopy(arr1, 3, arr2, 7, 2);
		// 调用Arrays.toString()打印数组
		// 运行结果:[0, 0, 0, 0, 0, 0, 0, 44, 55, 0]
		System.out.println(Arrays.toString(arr2));
		// 结束时间
		long end = System.currentTimeMillis();
		// 获取程序执行时间 {程序运行消耗时间为:1}
		System.out.println("程序运行消耗时间为:" + (end - start));
	}
}
~~~

# StringBuilder类

`String`存在一些问题,由于`String`类的对象内容不可改变，所以每当进行字符串拼接时，总是会在内存中创建一个新的对象。例如：

~~~java
public class StringBuilderDemo1 {
    public static void main(String[] args) {
        //      test01();
        StringBuilder sb = new StringBuilder("hello");

        // 对象.方法名();
        sb.append("ab").append("好").append(true).append(66);

        System.out.println("sb = " + sb.toString());

        long start = System.currentTimeMillis(); // 23
        StringBuilder sb2 = new StringBuilder();
        for (int i = 0; i < 100000; i++) {
            sb2.append("a");
        }

        long end = System.currentTimeMillis();
        System.out.println("消耗时间: " + (end - start));
    }

    // String拼接效率低 2235
    public static void test01() {
        String str = "a" + "b" + "c" + "d";
        System.out.println("str = " + str);

        long start = System.currentTimeMillis();
        String s = "a";
        for (int i = 0; i < 100000; i++) {
            s += "a";
        }
        long end = System.currentTimeMillis();
        System.out.println("消耗时间: " + (end - start));
    }
}
~~~

> 在`API`中对`String`类有这样的描述：字符串是常量，它们的值在创建后不能被更改。

根据这句话分析我们的代码，其实总共产生了三个字符串，即 "Hello" 、 "World" 和 "HelloWorld" 。引用变量s 首先指向 Hello 对象，终指向拼接出来的新字符串对象，即 HelloWord 。

![String](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-29/5.jpg)

> 由此可知，如果对字符串进行拼接操作，每次拼接，都会构建一个新的`String`对象，既耗时，又浪费空间。为了解 决这一问题，可以使用` java.lang.StringBuilder` 类。 

### StringBuilder概述

查阅` java.lang.StringBuilder `的API，`StringBuilder`又称为可变字符序列，它是一个类似于 `String` 的字符串缓冲 区，通过某些方法调用可以改变该序列的长度和内容。

原来`StringBuilder`是个字符串的缓冲区，即它是一个容器，容器中可以装很多字符串。并且能够对其中的字符串进 行各种操作。

它的内部拥有一个数组用来存放字符串内容，进行字符串拼接时，直接在数组中加入新内容。`StringBuilder`会自动 维护数组的扩容。原理如下图所示：(默认16字符空间，超过自动扩充),简单来说就是:

> StringBuilder类的作用是一个可变的字符串,拼接效率高

![StringBuilder](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-4-29/6.jpg)

### 构造方法

根据`StringBuilder`的API文档，常用构造方法有2个：

* `public StringBuilder()` ：构造一个空的`StringBuilder`容器。 
* `public StringBuilder(String str) `：构造一个`StringBuilder`容器，并将字符串添加进去 

### 常用方法

`StringBuilder`常用的方法有2个：

* `public StringBuilder append(...) `：添加任意类型数据的字符串形式，并返回当前对象自身。 
* `public String toString() `：将当前`StringBuilder`对象转换为`String`对象。

~~~java
public class StringBuilderDemo2 {
	public static void main(String[] args) {
		// 创建对象
		StringBuilder  sb = new StringBuilder();
		// append(;可以添加任意类型,参数是Object
		sb.append("Hello");
		sb.append(true);
		sb.append(1999);
		sb.append('A');
		// 将StringBuilder转换为String类型
		String s = sb.toString();
		// 结果是拼接字符串:s = Hellotrue1999A
		System.out.println("s = " + s);
		// 链式编程
		String s1 = sb.append("hello")
									.append('a')
									.append(999.0)
									.append(1000)
									.toString();
		System.out.println("s1 = " + s1);
	}
}
~~~

> 备注：StringBuilder已经覆盖重写了Object当中的toString方法。 

# 包装类

### 概述

> Java提供了两个类型系统，`基本类型`与`引用类型`，使用基本类型在于效率，然而很多情况，会创建对象使用，因为对象可以做更多的功能，如果想要我们的基本类型像对象一样操作，就可以使用基本类型对应的包装类，如下：

~~~java
public static void main(String[] args) {
        // int类型转换为String
        String s = 10 + ""; // +和字符串在一起表示连接,会将其他内容连接到字符串中
        System.out.println(s);

        // String转换成int类型(字符串中要是数字才能转换)
        // Integer类:static int parseInt​(String s)
        int i = Integer.parseInt("20");
        System.out.println("i = " + i);

        // "2.66"
        double v = Double.parseDouble("2.66");
        System.out.println("v = " + v);
}
~~~

| 基本类型 | 对应的包装类  |
| :------: | :-----------: |
|   byte   |     Byte      |
|   int    |  **Integer**  |
|  short   |     Short     |
|   long   |     Long      |
|  double  |    Double     |
|   char   | **Character** |
| boolean  |    Boolean    |
|   ﬂoat   |     Float     |

### 装箱与拆箱 

> 基本类型与对应的包装类对象之间，来回转换的过程称为”装箱“与”拆箱“：

* 装箱：从基本类型转换为对应的包装类对象。 
* 拆箱：从包装类对象转换为对应的基本类型。
  `用Integer与 int为例：``
* ``基本数值---->包装对象`

~~~java
Integer i1 = new Integer(4);
Integer i2 = Integer.valueOf(4);
~~~

* 包装对象---->基本数值

~~~java
int num = i.intValue();
~~~

### 自动装箱与拆箱

> 由于我们经常要做基本类型与包装类之间的转换，从Java 5（JDK 1.5）开始，基本类型与包装类的装箱、拆箱动作 可以自动完成。例如：

~~~java
public static void main(String[] args) {
        // int -> Integer
        // Integer​(int value)
        // static Integer valueOf​(int i)
        Integer i1 = new Integer(30);
        System.out.println("i1 = " + i1);

        Integer i2 = Integer.valueOf(50);
        System.out.println("i2 = " + i2);

        // 自动装箱:将基本数据类型转成对应的包装类
        Integer i3 = 60;

        // Integer -> int
        // int intValue​(): 返回Integer中的int值
        Integer i4 = new Integer(70);
        int num = i4.intValue();

        // 自动拆箱: 将包装类转成基本数据类型
        int num2 = new Integer(80);
    }
~~~

### 反编译

> [反编译工具](https://mobaijun.lanzous.com/icb77if)

~~~java
public static void main(String[] args) {
        Integer i1 = 10; // 自动装箱:底层使用Integer.valueOf()
        int i2 = i1; // 自动拆箱: i1.intValue()

        // .java(源代码) -> 编译 -> .class文件
        // .class文件 -> 反编译 -> .java(源代码)

        Integer i3 = 20; // Integer i3 = Integer.valueOf(20)
        i3 += 10;
        // i3 = i3 + 10;
        // i3 + 10; -> i3.intValue() + 10; -> int
        // i3 = Integer.valueOf(i3.intValue() + 10);
    }
~~~

