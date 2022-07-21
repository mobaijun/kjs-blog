---
title: 【Java基础】Date类练习
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 基础复习
categories:
  - 后端
abbrlink: 8099667
date: 2020-05-05 09:58:58
img:
coverImg:
password:
summary:
---

### 控制台打印当前时间

```java
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/5 10:30
 * ClassName:DateDemoTest03
 * 类描述：打印当前时间("yyyy年MM月dd日 HH时mm分ss秒")
 */
public class DateDemoTest03 {
 public static void main(String[] args) {
  // 创建当前时间对象
  Date nowTime = new Date();
  // 创建SimpleDateFormat对象指定格式
  SimpleDateFormat sim = new SimpleDateFormat("yyyy年MM月dd日 HH时mm分ss秒");
  // 转换成指定格式
  String string = sim.format(nowTime);
  System.out.println(" 当前时间是: " + string);
 }
}
```

### 判断控制台是否输入为时间格式

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/5 9:33
 * ClassName:DateDemo1
 * 类描述： 判断控制台输入是否为时间格式
 */
public class DateDemoTest {
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		System.out.println(" 请输入出生日期(yyyy-MM-dd) :");
		String time = scanner.next();
		String string = "time";
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		try {
			Date date = format.parse(time);
			System.out.println(" 格式正确 ");
		} catch (Exception e) {
			System.out.println("格式错误");
		}
	}
}
~~~

### 控制台输入指定格式的日期,输出当月的日历

~~~java
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Scanner;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/5 10:03
 * ClassName:DateCalendarDemo
 * 类描述：
 */
public class DateCalendarDemo {
	public static void main(String[] args) throws ParseException {
		Scanner sc = new Scanner(System.in);
		System.out.println(" 请按照2020-05-05的形式输入日期: ");
		String str = sc.next();
		Rl(str);
	}

	public static void Rl(String str) throws ParseException {
		SimpleDateFormat sim = new SimpleDateFormat("yyyy-MM-dd");
		Date d = sim.parse(str);//将指定格式的字符串解析成Date时间对象
		Calendar ca = Calendar.getInstance();
		ca.setTime(d);//将Date时间对象转成Calendar对象.
		System.out.println(ca.get(Calendar.MONTH));
		int num = ca.getActualMaximum(Calendar.DAY_OF_MONTH);
		int num1 = ca.get(Calendar.DAY_OF_MONTH);
		//System.out.println(num1);//本月第几天
		ca.add(Calendar.DATE, -(num1 - 1));//将时间设置到本月第一天
		int week = ca.get(Calendar.DAY_OF_WEEK);//本周第几天
		//System.out.println(week);//本周第几天
		System.out.println("日" + "\t" + "一" + "\t" + "二" + "\t " + "三" + "\t" + "四" + "\t" + "五" + "\t" + "六");
		int k = 0;
		for (int i = 1; i < week; i++) {
			System.out.print("\t");
			k++;
		}
		for (int i = 1; i <= num; i++) {
			if (k % 7 == 0)
				System.out.println();
			if (i == num1) {
				System.out.print("*" + i + "\t");
				k++;
				continue;
			}
			System.out.print(i + "\t");
			k++;
		}
	}
}
~~~

### 计算你出生了多少天

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/5 10:17
 * ClassName:DateDemo02
 * 类描述：计算你出生了多少天?
 */
public class DateDemo02 {
	public static void main(String[] args) throws ParseException {
		// 1.创建一个当前时间的Date对象
		Date now = new Date();
		// 2.定义一个出生日期字符串: "1999-01-06"
		String birthdayStr = "1999-01-06";

		// 3.创建SimpleDateFormat对象
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		// 4.将出生日期字符串转成Date对象
		Date date = sdf.parse(birthdayStr);

		// 5.活着的毫秒值 = 当前时间的Date.毫秒值 - 出生Date的毫秒值
		long liveTime = now.getTime() - date.getTime();
		// 6.将毫秒值转成天
		long day = liveTime / 1000 / 60 / 60 / 24;
		System.out.println("活着的天数: " + day);
	}
}
~~~

### 计算指定年份2月有多少天

~~~java
import java.util.Calendar;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/5 10:24
 * ClassName:DateDemoTest01
 * 类描述：计算指定年份2月有多少天
 */
public class DateDemoTest01 {
	public static void main(String[] args) {
		int year = 1999;
		// 1.创建Calendar对象
		Calendar cal = Calendar.getInstance();
		// 2.调整到指定的年
		cal.set(year, 2, 1);

		// 4.再往前一天
		cal.add(Calendar.DAY_OF_MONTH, -1);
		// 5.获取天数
		int day = cal.get(Calendar.DAY_OF_MONTH);

		System.out.println(year + "年2月有" + day + "天");
	}
}
~~~

### 使用SimpleDateFormat类把2020-05-05转换为2020年05月05日

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/5 10:42
 * ClassName:DateDemoTest02
 * 类描述：使用SimpleDateFormat类把2016-12-18转换为2016年12月18日
 */
public class DateDemoTest02 {
	public static void main(String[] args) throws ParseException {
		// a)创建SimpleDateFormat对象 df,指定日期模式为yyyy-MM-dd
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		// b)调用df的parse(String str) 方法传入2020-05-05,得到对应日期类型
		Date date = df.parse("2020-05-05");
		// c)修改df的日期模式为yyyy年MM月dd日
		df.applyPattern("yyyy年MM月dd日");
		// d)调用df的format(Date date) 传入刚才转换为日期
		String newStr = df.format(date);
		// e)打印转换后的字符串
		System.out.println(newStr);
	}
}
~~~

### projectDate类

~~~java

import org.springframework.stereotype.Component;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;

/**
 * Author: Auser·杰
 * Development: IntelliJ IDEA 2018.2.4 x64
 * ClassName: Date
 * ClassCreateDate: 2019/12/17 15:20
 * 类简介: 基于JDK1.8日期工具类
 */
@Component
public class DateUtils {

    public static String YYYY_MM_DD = "YYYY-MM-DD";

    public static String YYYYMMDD = "YYYYMMDD";

    public static String YYYYMMDDHHmmSS = "YYYYMMDDHHmmss";

    public static String YYYY_MM_DD_HH_mm_SS = "YYYY_MM_DD HH:mm:ss";


    /**
     * Author: Auser·杰
     * MethodName: getTime
     * MethodCreateDate: 2019/12/17 15:22
     * Return: java.lang.String
     * Param: [date, pattern]
     * 方法说明: 获取时间
     */
    public static String getTime(Date date, String pattern) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
        return formatter.format(dateToDateTime(date));
    }

    /**
     * Author: Auser·杰
     * MethodName: getDate
     * MethodCreateDate: 2019/12/17 15:23
     * Return: java.util.Date
     * Param: [time, pattern]
     * 方法说明: 获取date
     */
    public static Date getDate(String time, String pattern) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
        return dateTimeToDate(LocalDateTime.parse(time, formatter));
    }


    /**
     * Author: Auser·杰
     * MethodName: dateToDateTime
     * MethodCreateDate: 2019/12/17 15:23
     * Return: java.time.LocalDateTime
     * Param: [date]
     * 方法说明: date转dateTime
     */
    private static LocalDateTime dateToDateTime(Date date) {
        Instant instant = date.toInstant();
        return LocalDateTime.ofInstant(instant, ZoneId.systemDefault());
    }

    /**
     * Author: Auser·杰
     * MethodName: dateTimeToDate
     * MethodCreateDate: 2019/12/17 15:23
     * Return: java.util.Date
     * Param: [localDateTime]
     * 方法说明: dateTime转Date
     */
    private static Date dateTimeToDate(LocalDateTime localDateTime) {
        Date date = Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
        return date;
    }
}
~~~