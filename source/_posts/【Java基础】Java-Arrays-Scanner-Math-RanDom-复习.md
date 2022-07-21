---
title: '【Java基础】Java-[Arrays,Scanner,Math,RanDom]复习'
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - JavaSE
categories:
  - 后端
abbrlink: 3116814990
date: 2020-05-03 15:15:35
img:
coverImg:
password:
summary:
---

# Arrays

## 概述

> `java.util.Arrays`  此类包含用来操作数组的各种方法，比如排序和搜索等。其所有方法均为静态方法，调用起来非常简单。

## 常用方法

* `public static String toString(int[] a) ` ：返回指定数组内容的字符串表示形式。

### 代码示例

~~~java
public static void main(String[] args) {
	// 定义int数组
	int[] arr = {2, 34, 35, 4, 657, 8, 69, 9};
	// 打印数组,输出数组地址
	System.out.println("arr = " + arr);// arr = [I@1b6d3586
	// 数组内容转换为字符串
	String s = Arrays.toString(arr);
	// 打印字符串,输出内容
	System.out.println("s = " + s); // s = [2, 34, 35, 4, 657, 8, 69, 9]
}
~~~

* `public static void sort(int[] a)` ：对指定的 int 型数组按数字升序进行排序。

### 代码示例

~~~java
public static void main(String[] args) {
	// 定义int数组
	int[] arr = {24, 7, 5, 48, 4, 46, 35, 11, 6, 2};
    // 24, 7, 5, 48, 4, 46, 35, 11, 6, 2
	System.out.println("排序前 = " + Arrays.toString(arr)); 

	// 升序排序
	Arrays.sort(arr);
    // 2, 4, 5, 6, 7, 11, 24, 35, 46, 48
	System.out.println(" 排序后 =  " + Arrays.toString(arr));
}
~~~

* `public static <T> void sort(T[] a, Comparator<? super T> c)`:对指定的 int 型数组按数字降序进行排序。

~~~java
public static void main(String[] args) {
	// 定义int数组
	int[] arr = {24, 7, 5, 48, 4, 46, 35, 11, 6, 2};
    // 24, 7, 5, 48, 4, 46, 35, 11, 6, 2		
	System.out.println("排序前 = " + Arrays.toString(arr)); 
	// 降序排序
	Arrays.sort(new int[][]{arr}, Collections.reverseOrder());
	// 24, 7, 5, 48, 4, 46, 35, 11, 6, 2
	System.out.println(" 排序后 = " + Arrays.toString(arr));
}   
~~~

### 练习

> 需求:将一个随机字符串中的所有字符升序排列，并倒序打印。

~~~java
public class ArraysDemo3 {
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		System.out.println("请输入一个随机字符串:");
		String s = scanner.nextLine();
		// 转换为字符数组
		char[] chars = s.toCharArray();
		// 升序排序
		Arrays.sort(chars);
		// 反向遍历打印
		for (int i = chars.length - 1; i >= 0; i--) {
			System.out.print(chars[i] + " ");
		}
	}
}
~~~

# Scanner

## 什么是Scanner类?

> 一个可以解析基本数据类型和字符串的简单文本扫描器;

## 调用方法

接下来需要明确方法的功能，如果方法是实例方法，需要创建对象来访问，如果方法是静态方法可以直接用类名来调用。

例如：Scanner类方法如下：

```java
public int nextInt() ：将输入信息的下一个标记扫描为一个 int 值。
```

该方法为实例方法需要创建对象来调用，查看构造器如下：

~~~java
public Scanner(InputStream source) : 
// 构造一个新的 Scanner ，它生成的值是从指定的输入流扫描的。查看成员方法
~~~

使用Scanner类，完成接收键盘录入数据的操作，代码如下：

~~~java
public class ScannerDemo {
    public static void main(String[] args) {
        //1. 创建键盘录入数据的对象
        Scanner sc = new Scanner(System.in);
        //2. 接收数据
        System.out.println("请录入一个整数：");
        int i = sc.nextInt();
        //3. 输出数据
        System.out.println("用户输入的数值 = :" + i);
    }
}
~~~

## 练习

~~~java
package com.mobaijun.day05;

import java.util.Scanner;

/**
 * @Author: Auser·杰
 * Development: IntelliJ IDEA 2018.2.4 x64
 * ClassName: ScannerDemo2
 * ClassCreateDate: 2020/5/2 17:41
 * 类简介: 接收键盘录入三个随机数并获取最大值
 */
public class ScannerDemo2 {
    public static void main(String[] args) {
        // 1.创建scanner对象
        Scanner sc = new Scanner(System.in);
        // 提示用户输入
        System.out.println("请输入三个随机数:");
        // 2.接收用户键盘录入
        // 接收第一个数值
        System.out.println("请输入第一个随机数");
        int i1 = sc.nextInt();
        System.out.println("第一个随机数是+" + i1);
        // 接收第二个数值
        System.out.println("请输入第二个随机数");
        int i2 = sc.nextInt();
        System.out.println("第二个随机数是+" + i2);
        // 接收第三个数值
        System.out.println("请输入第三个随机数");
        int i3 = sc.nextInt();
        System.out.println("第三个随机数是+" + i3);
        // 使用三元运算符获取最大值
        int max = i1 > i2 ? i1 : i2;
        max = max > i3 ? max : i3;
        System.out.println("最大值是 = " + max);
    }
}
~~~

# Math

> `java.lang.Math` 类包含用于执行基本数学运算的方法，如初等指数、对数、平方根和三角函数。类似这样的工具类，其所有方法均为静态方法，并且不会创建对象，调用起来非常简单。

## 基本运算的方法

* `public static double abs(double a) ` ：返回 double 值的绝对值。 

~~~java
public static void main(String[] args) {
	double d1 = Math.abs(-5);
	System.out.println("d1 = " + d1); // d1 = 5.0
	double d2 = Math.abs(5);
	System.out.println("d2 = " + d2); // d2 = 5.0
}
~~~

* `public static double ceil(double a)` ：返回大于等于参数的最小的整数。

~~~java
System.out.println("d3 = " + d3); // d3 = 4.0
double d4 = Math.ceil(-3.3);
System.out.println("d4 = " + d4); // d4 = -3.0
double d5 = Math.ceil(5.1);
System.out.println("d5 = " + d5); //d 5 = 6.0
~~~

* `public static double floor(double a) ` ：返回小于等于参数最大的整数。

~~~java
double d6 = Math.floor(3.3);
System.out.println("d6 = " + d6); // d7 = -4.0
double d7 = Math.floor(-3.3);
System.out.println("d7 = " + d7);// d7 = -4.0
double d8 = Math.floor(5.1);
System.out.println("d8 = " + d8); // d8 = 5.0
~~~

* `public static long round(double a)` ：返回最接近参数的 long。(相当于四舍五入方法)  

~~~java
long d1 = Math.round(5.5);
System.out.println("d1 = " + d1); // d1 = 6
long d2 = Math.round(5.4);
System.out.println("d2 = " + d2); // d2 = 5
~~~

### 练习

> 请使用`Math` 类，计算在 `-10.8`  到`5.9`  之间，绝对值大于`6`  或者小于`2.1` 的整数有多少个？

# Random

> 此类的实例用于生成伪随机数，在实际开发中，通常用于在程序中生产一个随机数。

### Random使用案例

#### 一:

> 需求:**使用Random类，完成生成3个10以内的随机整数的操作**
>
> 备注:创建一个 Random 对象，每次调用 nextInt() 方法，都会生成一个随机数。调用 nextInt(int n) 方法，会生成一个0-n(不包含n)的随机数。

~~~java
public static void main(String[] args) {
		// 创建一个随机数对象
		Random random = new Random();

		// 循环遍历随机数
		for (int j = 0; j < 3; j++) {
			// 调用nextInt()方法得到一个10以内的随机整数
			int i = random.nextInt(10);
			// 打印随机数
			System.out.print(" " + i);
		}
	}
~~~

#### 二:

> 需求:**获取1-n之间的随机数，包含n**

~~~java
public static void main(String[] args) {
		// 定义最大值变量
		int num = 10;
		// 生成随机数对象
		Random random = new Random();
		// 循环遍历随机数
		for (int i = 0; i < 3; i++) {
			// 随机数+1
			int n = random.nextInt(num) + 1;
			// 打印随机数
			System.out.print(" " + n);
		}
	}
~~~

#### 三:

> 需求:**猜数字小游戏**
> 游戏开始时，会随机生成一个1-10之间的整数 number 。玩家猜测一个数字 guessNumber ，会与 number 作比较，系统提示大了或者小了，直到玩家猜中，游戏结束。
> 小贴士：先运行程序代码，理解此题需求，经过分析后，再编写代码。

~~~java
import java.util.Random;
import java.util.Scanner;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/3 16:17
 * ClassName:RanDomDemo4
 * 类描述：
 * (1） 游戏开始
 * （2） 随机生成一个1-100之间的整数 number 。
 *  (3) 玩家必须反复的猜测，直到猜中为主。
 */
public class RanDomDemo4 {
	public static void main(String[] args) {
		// 创建scanner对象接收用户键盘录入
		Scanner scanner = new Scanner(System.in);
		System.out.println("游戏开始:");
		// 随机生成一个1-100之间的整数 number 。
		Random random = new Random();
		// 调用它的nextInt(边界参数)得到随机数（1-100）
		int number = random.nextInt(100) + 1;
		while (true) {
			System.out.println(" 请输入您要猜测的随机数:");
			int getGussNumber = scanner.nextInt();
			// 判断用户的猜测数字情况
			if (getGussNumber > number) {
				System.out.println("您猜测的数字过大");
			} else if (getGussNumber < number) {
				System.out.println("您猜测的数字过小");
			} else {
				System.out.println("恭喜您，您很棒哦，猜对了！");
				System.out.println("号码就是：" + number);
				break;
			}
		}
	}
}
~~~

