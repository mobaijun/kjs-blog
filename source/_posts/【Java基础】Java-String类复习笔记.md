---
title: 【Java基础】Java-String类复习笔记
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - JavaSE
categories:
  - 后端
abbrlink: 230577513
date: 2020-05-03 14:16:44
img:
coverImg:
password:
summary:
---

# String类复习笔记

## String类概述

> `java.lang.String` 类代表字符串。Java程序中所有的字符串文字（例如`"abc"` ）都可以被看作是实现此类的实例。类 `String` 中包括用于检查各个字符串的方法，比如用于**比较**字符串，**搜索**字符串，**提取**子字符串以及创建具有翻译为**大写**或**小写**的所有字符的字符串的副本。 

## 常用构造方法

- `String() `创建一个空的字符串对象
- `String(String original)` 根据字符串来创建一个字符串对象
- `String(char[] value)` 通过字符数组来创建字符串对象
- `String(byte[] bytes)` 通过字节数组来构造新的字符串对象
- `String(byte[] bytes, int offset, int length) `通过字节数组一部分来构造新的字符串对象

#### 代码示例

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/3 14:19
 * ClassName:Demo4
 * 类描述：String类入门
 */
public class Demo4 {
	public static void main(String[] args) {
		// String() 创建一个空的字符串对象
		String str1 = new String();
		System.out.println("str1 = " + str1);// str1 =

		// String(String original) 根据字符串来创建一个字符串对象
		String str2 = new String("HelloWorld");
		System.out.println("str2 = " + str2);// str2 = HelloWorld

		// String(char[] value) 通过字符数组来创建字符串对象
		char[] chars = {'a', 'b', 'c', 'd', 'e'};
		String str3 = new String(chars);
		System.out.println("str3 = " + str3); // str3 = abcde

		// String(byte[] bytes) 通过字节数组来构造新的字符串对象
		byte[] bytes = {97, 98, 99, 100, 101};
		String str4 = new String(bytes);
		System.out.println("str4 = " + str4); // str4 = abcde
        
		// String(byte[] bytes, int offset, int length)通过字节数组一部分来构造新的字符串对象
		byte[] bytes2 = {97, 98, 99, 100, 101};
		String str5 = new String(bytes, 1, 2);
		System.out.println("str5 = " + str5); // str5 = bc
	}
}
~~~

## String特点

* 字符串不变:字符串的值在创建后不能被更改

~~~java
public static void main(String[] args) {
	String s1 = "abc";
	s1 += "d";
	// 内存中有"abc"，"abcd"两个对象，s1从指向"abc"，改变指向，指向了"abcd"。
	System.out.println("s1 = " + s1); // s1 = abcd
}
~~~

* 因为String对象是不可变的,所以它们可以被共享

~~~java
String s1 = "abc";
String s2 = "abc";
// 内存中只有一个"abc"对象被创建，同时被s1和s2共享。
System.out.println("输出结果等于: " + s1.equals(s2)); // 输出结果等于: true
~~~

## 常用方法

###  判断功能的方法

- `public boolean equals (Object anObject) ` ：将此字符串与指定对象进行比较。

- ` public boolean equalsIgnoreCase (String anotherString) ` ：将此字符串与指定对象进行比较，忽略大小写。

#### 代码案例

~~~java
public static void main(String[] args) {
	// 创建字符串对象
	String s1 = "hello";
	String s2 = "hello";
	String s3 = "HELLO";
	//  public boolean equals (Object anObject)：将此字符串与指定对象进行比较。
	System.out.println(" 结果等于: " + s1.equals(s2)); //  结果等于: true
	System.out.println(" 结果等于: " + s2.equals(s3)); //   结果等于: false
	// public boolean equalsIgnoreCase (String anotherString) ：将此字符串与指定对象进行比较，忽略大小写。
	System.out.println(" 结果等于: " + s1.equalsIgnoreCase(s2)); //  结果等于: true
	System.out.println(" 结果等于: " + s2.equalsIgnoreCase(s3)); //	 结果等于: true
}
~~~

### 获取功能的方法

- `public int length () ` ：返回此字符串的长度。
- `public String concat (String str)` ：将指定的字符串连接到该字符串的末尾。
- ` public char charAt (int index) ` ：返回指定索引处的 char值。
- `public int indexOf (String str) ` ：返回指定子字符串第一次出现在该字符串内的索引。
- ` public String substring (int beginIndex) ` ：返回一个子字符串，从beginIndex开始截取字符串到字符串结尾。
- ` public String substring (int beginIndex, int endIndex) ` ：返回一个子字符串，从beginIndex到endIndex截取字符串。含beginIndex，不含endIndex。

#### 代码示例

~~~java
public static void main(String[] args) {
	// 创建字符串对象
	String string = "HelloWorld";
	// public int length ()  ：返回此字符串的长度。
	System.out.println("字符串长度是 = " + string.length()); // 字符串长度是 = 10
	// public String concat (String str) ：将指定的字符串连接到该字符串的末尾。
	System.out.println("string = " + string.concat("+ MoBai")); // string = HelloWorld+ MoBai
	//  public char charAt (int index)：返回指定索引处的 char值。
	System.out.println("指定索引 = " + string.charAt(5)); // 指定索引 = W
	// public int indexOf (String str) ：返回指定子字符串第一次出现在该字符串内的索引,没有返回-1
	System.out.println("第一次出现的索引位置在 = " + string.indexOf("W")); // 第一次出现的索引位置在 = 5
	System.out.println("第一次出现的索引位置在 = " + string.indexOf("Ak")); // 第一次出现的索引位置在 = -1
	//  public String substring (int beginIndex, int endIndex) ：返回一个子字符串，从beginIndex到endIndex截取字符串。含beginIndex，不含endIndex。
	System.out.println("截取后的字符串为:" + string.substring(0, string.length())); // 截取后的字符串为:HelloWorld
	System.out.println("截取后的字符串为:" + string.substring(3, 8)); // 截取后的字符串为:loWor
}
~~~

### 转换功能的方法

- `public char[] toCharArray () ` ：将此字符串转换为新的字符数组。 
- ` public byte[] getBytes ()` ：使用平台的默认字符集将该 String编码转换为新的字节数组。
- `public String toLowerCase()` ：使用默认语言环境的规则将此 String所有字符转换为小写。
- `public String toUpperCase()` ：将此 String所有字符转换为大写，使用默认语言环境的规则。
- `public String replace (CharSequence target, CharSequence replacement) ` ：将与target匹配的字符串使用replacement字符串替换。

#### 代码示例

~~~java
public static void main(String[] args) {
       //创建字符串对象
       String s = "abcde";

       // char[] toCharArray():把字符串转换为字符数组
       char[] chs = s.toCharArray();
       for(int x = 0; x < chs.length; x++) {
          System.out.println(chs[x]);
       }
       System.out.println("-----------");

       // byte[] getBytes ():把字符串转换为字节数组
       byte[] bytes = s.getBytes();
       for(int x = 0; x < bytes.length; x++) {
          System.out.println(bytes[x]);
       }
       System.out.println("-----------");

       // 替换字母it为大写IT
       String str = "itcast itheima";
       String replace = str.replace("it", "IT");
       System.out.println(replace); // ITcast ITheima
       System.out.println("-----------");
}
~~~

> CharSequence 是一个接口，也是一种引用类型。作为参数类型，可以把String对象传递到方法中。

### 分割功能的方法

* `public String[] split(String regex)` ：将此字符串按照给定的regex（规则）拆分为字符串数组。

#### 代码示例

~~~java
public static void main(String[] args) {
      //创建字符串对象
      String s = "aa,bb,cc";
      String[] strArray = s.split(","); // ["aa","bb","cc"]
      for(int x = 0; x < strArray.length; x++) {
         System.out.println(strArray[x]); // aa bb cc
    }
}
~~~

### String类练习

> 需求:键盘录入一个字符，统计字符串中大小写字母及数字字符个数

~~~java
public class StringDemoTest {
	public static void main(String[] args) {

		// 创建scanner类接收键盘录入
		Scanner scanner = new Scanner(System.in);
		System.out.println("请输入一个字符串数据:");
		String s = scanner.nextLine();

		// 定义三个统计变量,初始化'0'
		int bigCount = 0;
		int smallCount = 0;
		int numberCount = 0;

		//遍历字符串，得到每一个字符
		for (int x = 0; x < s.length(); x++) {
			char ch = s.charAt(x);
			//拿字符进行判断
			if (ch >= 'A' && ch <= 'Z') {
				bigCount++;
			} else if (ch >= 'a' && ch <= 'z') {
				smallCount++;
			} else if (ch >= '0' && ch <= '9') {
				numberCount++;
			} else {
				System.out.println("该字符" + ch + "非法");
			}
		}

		//输出结果
		System.out.println("大写字符：" + bigCount + "个");
		System.out.println("小写字符：" + smallCount + "个");
		System.out.println("数字字符：" + numberCount + "个");
	}
}
~~~

