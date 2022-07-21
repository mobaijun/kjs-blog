---
title: '【Java基础】Java-[Object,Date,Calendar]复习'
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - JavaSE
categories:
  - 后端
abbrlink: 3746716574
date: 2020-05-04 09:45:04
img:
coverImg:
password:
summary:
---

# Object

> `java.lang.Object `类是`Java`语言中的根类，即所有类的父类。它中描述的所有方法子类都可以使用。在对象实例 化的时候，终找的父类就是`Object`。

如果一个类没有特别指定父类， 那么默认则继承自`Object`类。例如：

~~~Java
public class MyClass /*extends Object*/ {    
    // ...    
}
~~~

> 根据`JDK`源代码及`Object`类的`API`文档，Object类当中包含的方法有11个。今天主要复习`toString`和	`equals`方法：

* `public String toString() `：返回该对象的字符串表示。 
* `public boolean equals(Object obj) `：指示其他某个对象是否与此对象“相等”。 

## ToString

* `public String toString() `：返回该对象的字符串表示。

`toString`方法返回该对象的字符串表示，其实该字符串内容就是对象的类型`+@+内存地址值`。 由于`toString`方法返回的结果是内存地址，而在开发中，经常需要按照对象的属性得到相应的字符串表现形式，因此也需要重写它。 

### 覆盖重写

如果不希望使用`toString`方法的默认行为，则可以对它进行覆盖重写。例如自定义的`Person`类：

~~~java
public class Persion {
	private String name;
	private int age;

	// 省略getter/setter方法
	@Override
	public String toString() {
		return "Persion{" +
				"name='" + name + '\'' +
				", age=" + age +
				'}';
	}
}
~~~

> 在`IntelliJ IDEA`中，可以点击 `Code` 菜单中的 `Generate...` ，也可以使用快捷键 `alt+insert `，点击 `toString()` 选 项。

## Equals

* `public boolean equals(Object obj) `：指示其他某个对象是否与此对象“相等”。

> 调用成员方法`equals`并指定参数为另一个对象，则可以判断这两个对象是否是相同的。这里的“相同”有默认和自定义两种方式。 

### 默认地址比较 

如果没有覆盖重写`equals`方法，那么`Object`类中默认进行 == 运算符的对象地址比较，只要不是同一个对象，结果必然为`false`。 

~~~java
public static void main(String[] args) {
	// 创建两个对象进行比较
	Teacher t1 = new Teacher("墨白", 21);
	Teacher t2 = new Teacher("墨白", 21);

	System.out.println("equals: " + t1.equals(t1)); // equals: true
	System.out.println("equals: " + t1.equals(t2)); // equals: true
	System.out.println("equals: " + t1.equals(new Dog())); // equals: false
}
~~~

### 对象内容比较 

如果希望进行对象的内容比较，即所有或指定的部分成员变量相同就判定两个对象相同，则可以覆盖重写`equals`方 法。例如：

~~~java
public class Persion {
	private String name;
	private int age;
    
	@Override
	public boolean equals(Object o) {
		// 如果对象地址一样,则认为相同
		if (this == o)
			return true;
		// 如果参数为空,或者类型不一样,则返回false
		if (o == null || getClass() != o.getClass())
			return false;
		// 转换为当前类型
		Persion persion = (Persion) o;
		// 要求基本类型相同,并且将引用类型交给java.util.Objects类的equals静态方法取用结果
		return age == persion.age && Objects.equals(name, persion.name);
	}
}
~~~

> 这段代码充分考虑了对象为空、类型一致等问题，但方法内容并不唯一。大多数`IDE`都可以自动生成`equals`方法的代码内容。在`IntelliJ IDEA`中，可以使用 `Code `菜单中的` Generate… `选项，也可以使用快捷键 `alt+insert `，并选 择` equals() and hashCode() `进行自动代码生成

# Objects

在`JDK1.7`添加了一个`Objects`工具类，它提供了一些方法来操作对象，它由一些静态的实用方法组成，这些方法是 `null-save`（空指针安全的）或`null-tolerant`（容忍空指针的），用于计算对象的`hashcode`、返回对象的字符串表 示形式、比较两个对象。

在比较两个对象的时候，`Object`的`equals`方法容易抛出空指针异常，而`Objects`类中的`equals`方法就优化了这个问 题。方法如下：

* `public static boolean equals(Object a, Object b) `:判断两个对象是否相等。

### Objects类的作用是

> Objects类是对象的工具类,他里面的方法用来操作对象

### Objects类常用方法

* `equals(Object a, Object b)`: 较两个对象是否相等,如果相等返回true
* `isNull(Object obj)` 判断对象是null,如果是null返回true
* `nonNull(Object obj) `判断对象不是null,如果不是null返回true

**代码案例:**

~~~Java
public static void main(String[] args) {
	Teacher t1 = new Teacher("墨白", 21);
	Teacher t2 = new Teacher("墨白", 21);

	// 将对象1设置为null
	t1 = null;
	if (t1 != null) {
		System.out.println("t1 = " + t1.equals(t2));// null不能调用方法
	}

	// Objects类中的static boolean equals​(Object a, Object b) 比较两个对象是否相等,如果相等返回true,否则返回false
	// Objects类中的equals​更加安全,建议使用这个
	System.out.println("Objects.equals:" + Objects.equals(t1, t2)); // Objects.equals:false

	// static boolean isNull​(Object obj) 判断对象是否为null,如果是null返回true
	System.out.println(Objects.isNull(t1)); // true
	System.out.println(Objects.isNull(t2)); // false

	// static boolean nonNull​(Object obj) 判断对象不是null,如果不是null返回true
	System.out.println(Objects.nonNull(t1)); // false
	System.out.println(Objects.nonNull(t2)); // true
}
~~~

# Date

> `java.util.Date` 类表示特定的瞬间，精确到毫秒。 查阅`Date`类的描述，发现Date拥有多个构造函数，只是部分已经过时，但是其中有未过时的构造函数可以把毫秒值转成日期对象。

* `public Date() `：分配Date对象并初始化此对象，以表示分配它的时间（精确到毫秒）。

*  `public Date(long date) `：分配Date对象并初始化此对象，以表示自从标准基准时间（称为“历元 （epoch）”，即1970年1月1日00:00:00 GMT）以来的指定毫秒数。 

> tips: 由于中国处于东八区（GMT+08:00）是比世界协调时间/格林尼治时间（GMT）快8小时的时区，当格 林尼治标准时间为0:00时，东八区的标准时间为08:00。

### 常用方法

简单来说：使用无参构造，可以自动设置当前系统时间的毫秒时刻；指定long类型的构造参数，可以自定义毫秒时刻。

~~~java
public static void main(String[] args) {
    // (常用)Date​() 创建一个Date对象,当前时间(执行这行代码的时间)
	Date now = new Date();
	//  Mon May 04 10:30:39 CST 2020
	System.out.println("now = " + now);

	// 2.Date​(long date) 创建一个Date对象,在1970年1月1日00:00:00 基础上增加的指定毫秒数
	Date d2 = new Date(1000); // 加1秒
	System.out.println("d2 = " + d2); // Thu Jan 01 08:00:01 CST 1970

	// (常用)long getTime​() 返回自1970年1月1日以来，由Date对象表示的的毫秒数。
	System.out.println("getTime: " + now.getTime()); // 1588559439285

	// void setTime​(long time) 将此Date对象设置为在1970年1月1日00:00:00 基础上增加的指定毫秒数
	now.setTime(2000);
	System.out.println("now = " + now); // now = Thu Jan 01 08:00:02 CST 1970
}
~~~

* Date类的作用

`Date类代表了一个特定的时间，以毫秒的精度。`

* Date()构造方法的作用?

`创建一个当前时间的Date对象`

* Date类的getTime()方法的作用?

`获取date对象距1970年1月1日的毫秒值`

> tips:在使用println方法时，会自动调用Date类中的toString方法。Date类对Object类中的toString方法进行了覆盖重写，所以结果为指定格式的字符串。 

# DateFormat

### 概述

> `java.text.DateFormat `是日期/时间格式化子类的抽象类，我们通过这个类可以帮我们完成日期和文本之间的转 换,也就是可以在`Date`对象与`String`对象之间进行来回转换。

* 格式化：按照指定的格式，从`Date`对象转换为`String`对象。 

* 解析：按照指定的格式，从`String`对象转换为`Date`对象。 

### 构造方法

由于`DateFormat`为抽象类，不能直接使用，所以需要常用的子类` java.text.SimpleDateFormat` 。这个类需要一个 模式（格式）来指定格式化或解析的标准。构造方法为：

* `public SimpleDateFormat(String pattern) `：用给定的模式和默认语言环境的日期格式符号构造 `SimpleDateFormat`。 参数pattern是一个字符串，代表日期时间的自定义格式。 

### 格式规则 

常用的格式规则为：

| 标识字母 | 含义 |
| :------: | :--: |
|    Y     |  年  |
|    M     |  月  |
|    d     |  日  |
|    H     |  时  |
|    m     |  分  |
|    s     |  秒  |

> 备注：更详细的格式规则，可以参考SimpleDateFormat类的API文档。 

### 常用方法

DateFormat类的常用方法有： 

* `public String format(Date date) `：将Date对象格式化为字符串。 

* `public Date parse(String source) `：将字符串解析为Date对象。

### 代码示例

~~~java
public static void main(String[] args) throws ParseException {
	// 4.需求:将 当前时间的Date对象 转成 "2018年9月15日 19时18分19秒"
	// 1.创建当前时间的Date对象
	Date now = new Date();
	// 2.创建SimpleDateFormat对象
	// 2.1指定时间格式
	// 2.1.1 明确目标格式:"2018年9月15日 19时18分19秒"
	// 2.1.2 不会变的不理会
	// 2.1.3 会变化的使用特殊字母代替 "yyyy年MM月dd日 HH时mm分ss秒"
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 HH时mm分ss秒");
	// 3.调用方法将Date格式化成文本
	// String format​(Date date) 将日期格式化成日期/时间字符串。
	String str = sdf.format(now);
	// 2019年04月29日 10时14分34秒
	System.out.println("str = " + str);

	// 6.需求:将字符串 "2007-12-26 10:13:31" 转成 Date对象
	// 1.定义时间字符串
	String str2 = "2020-5-4 10:55:31";
	// 2.创建SimpleDateFormat对象
	SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	// 3.将字符串解析为Date对象:Date parse​(String source) 将字符串解析成Date对象
	Date d = sdf2.parse(str2); // alt + 回车 -> Add exception ...
	System.out.println("d = " + d); // Mon May 04 10:55:31 CST 2020
}
~~~

# Calendar

### 概述

> `java.util.Calendar `是日历类，在`Date`后出现，替换掉了许多`Date`的方法。该类将所有可能用到的时间信息封装为静态成员变量，方便获取。日历类就是方便获取各个时间属性的。 

`Calendar`为抽象类，不能直接创建对象，而是通过静态方法创建，返回子类对象，如下： 

`Calendar`静态方法

* `public static Calendar getInstance() `：使用默认时区和语言环境获得一个日历

~~~java
 Calendar cal = Calendar.getInstance(); 
~~~

### 常用方法

> 根据Calendar类的API文档，常用方法有：

* `public int get(int field) `：返回给定日历字段的值。

* ` public void set(int field, int value) `：将给定的日历字段设置为给定值。 

* `public abstract void add(int field, int amount) `：根据日历的规则，为给定的日历字段添加或减去指 定的时间量。 

* `public Date getTime()` ：返回一个表示此Calendar时间值（从历元到现在的毫秒偏移量）的Date对象。 Calendar类中提供很多成员常量，代表给定的日历字段：

|    字段值    |                 含义                  |
| :----------: | :-----------------------------------: |
|     YEAR     |                  年                   |
|    MONTH     |       月（从0开始，可以+1使用）       |
| DAY_OF_MONTH |            月中的天（几号)            |
|     HOUR     |            时（12小时制）             |
| HOUR_OF_DAY  |            时（24小时制）             |
|    MINUTE    |                  分                   |
|    SECOND    |                  秒                   |
| DAY_OF_WEEK  | 周中的天（周几，周日为1，可以-1使用） |

### 代码演示

~~~java
public class CalendarDemo1 {
	public static void main(String[] args) {
		// test01();
		// test02();
		// test03();
		test04();
	}

	public static void test04() {
		Calendar cal = Calendar.getInstance();
		// Date getTime​() 将Calendar转成Date
		Date date = cal.getTime();
		System.out.println("date = " + date); // Mon May 04 11:22:52 CST 2020
	}

	/**
	 * CreateTime: 2020/5/4 11:22
	 * Return:void
	 * MethodName:[test03] && Param:[[]]
	 * 方法说明: void add​(int field, int amount) 根据日历的规则，在当前时间上加上或减去指定的时间
	 */
	public static void test03() {
		Calendar calendar = Calendar.getInstance();
		// 10年之前:-数表示之前,正数表示之后
		calendar.add(Calendar.YEAR, -10);
		// 10年之后
		calendar.add(Calendar.YEAR, +10);
		// 1000天以前
		calendar.add(Calendar.DAY_OF_MONTH, -1000);
		// calendar = java.util.GregorianCalendar[time=1502162454543,areFieldsSet=true,areAllFieldsSet=true,lenient=true,zone=sun.util.calendar.ZoneInfo[id="Asia/Shanghai",offset=28800000,dstSavings=0,useDaylight=false,transitions=29,lastRule=null],firstDayOfWeek=1,minimalDaysInFirstWeek=1,ERA=1,YEAR=2017,MONTH=7,WEEK_OF_YEAR=32,WEEK_OF_MONTH=2,DAY_OF_MONTH=8,DAY_OF_YEAR=220,DAY_OF_WEEK=3,DAY_OF_WEEK_IN_MONTH=2,AM_PM=0,HOUR=11,HOUR_OF_DAY=11,MINUTE=20,SECOND=54,MILLISECOND=543,ZONE_OFFSET=28800000,DST_OFFSET=0]
		System.out.println("calendar = " + calendar);
	}

	/**
	 * CreateTime: 2020/5/4 11:15
	 * Return:void
	 * MethodName:[test02] && Param:[[]]
	 * 方法说明: void set​(int field, int value) 将给定的日历字段设置为给定的值
	 */
	public static void test02() {
		Calendar calendar = Calendar.getInstance();
		System.out.println("calendar = " + calendar);
		// 修改年
		calendar.set(Calendar.YEAR, 9012);
		// 修改月
		calendar.set(Calendar.MONTH, 13);
		// 修改日
		calendar.set(Calendar.DAY_OF_MONTH, 6);
		System.out.println("calendar = " + calendar);
	}

	/**
	 * CreateTime: 2020/5/4 11:12
	 * Return:void
	 * MethodName:[test01] && Param:[[]]
	 * 方法说明: int get​(int field) 返回指定时间单位的时间
	 */
	public static void test01() {
		// 创建Calendar对象
		Calendar calendar = Calendar.getInstance();
		// 获取年
		int year = calendar.get(Calendar.YEAR);
		System.out.println("year = " + year);
		// 获取月 [calendar.get(Calendar.MONTH) + 1;方法是从0开始获取当前月份的,所以需要+1]
		int month = calendar.get(Calendar.MONTH) + 1;
		System.out.println("month = " + month);
		// 获取日
		int day = calendar.get(Calendar.DAY_OF_MONTH);
		System.out.println("day = " + day);
		// 获取时
		int hour = calendar.get(Calendar.HOUR);
		System.out.println("hour = " + hour);
		// 获取分
		int minute = calendar.get(Calendar.MINUTE);
		System.out.println("minute = " + minute);
		// 获取秒
		int second = calendar.get(Calendar.SECOND);
		System.out.println("second = " + second);
	}
}
~~~

> * 西方星期的开始为周日，中国为周一。
> * 在Calendar类中，月份的表示是以0-11代表1-12月。
> *  日期是有大小关系的，时间靠后，时间越大。 