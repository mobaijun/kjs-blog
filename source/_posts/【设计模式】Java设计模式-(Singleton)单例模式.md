---
title: 【设计模式】Java设计模式-(Singleton)单例模式
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - Singleton
categories:
  - 后端
abbrlink: 1469544396
date: 2020-05-12 09:20:12
img:
coverImg:
password:
summary:
---

### 单例模式

单例模式（Singleton Pattern）是 Java 中最简单的设计模式之一。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。

这种模式涉及到一个单一的类，该类负责创建自己的对象，同时确保只有单个对象被创建。这个类提供了一种访问其唯一的对象的方式，可以直接访问，不需要实例化该类的对象。

> 简单来说就是保证在内存种只有一个实例!!!

#### 应用场景

* Windows时多进程多线程的,在操作一个文件的时候,就不可避免地出现多个进程或线程同时操作一个文件的现象，所以所有文件的处理必须通过唯一的实例来进行。

**优点:**

* 在内存里只有一个实例，减少了内存的开销，尤其是频繁的创建和销毁实例
* 避免对资源的多重占用（比如写文件操作）。

**缺点:**

* 没有接口,不能继承,与单一职责原则冲突，一个类应该只关心内部逻辑，而不关心外面怎么样来实例化。
* **使用场景：**
  - 要求生产唯一序列号。
  - WEB 中的计数器，不用每次刷新都在数据库里加一次，用单例先缓存起来。
  - 创建的一个对象需要消耗的资源过多，比如 I/O 与数据库的连接等。

### 单例模式的几种实现

#### **第一种:**

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/12 9:28
 * ClassName:Mgr01
 * 类描述：饿汉式
 * 类加载到内存后,就实例化一个单例,JVM保证线程安全
 * 优点:简单实用,推荐使用
 * 缺点:不管用不用,类加载时都会完成实例化
 */
public class Mgr01 {

    // 创建一个Mgr01的对象
	private static final Mgr01 INSTANCE = new Mgr01();

    // 私有化构造方法,不让该类实例化
	private Mgr01() {

	}

    // 获取INSTANCE对象
	public static Mgr01 getInstance() {
		return INSTANCE;
	}

	public void m() {
		System.out.println("m");
	}

	// 主方法
	public static void main(String[] args) {
      //不合法的构造函数
      //编译时错误：构造函数 Mgr01() 是不可见的
      //Mgr01 m1 = new Mgr01();
		Mgr01 m1 = Mgr01.getInstance();
		Mgr01 m2 = Mgr01.getInstance();
		System.out.println(m1.equals(m2));
	}
}
~~~

**结果:**

~~~java
true
~~~

#### **第二种:**

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/12 9:42
 * ClassName:Mgr02
 * 类描述：饿汉式
 * 使用静态代码块初始化
 */
public class Mgr02 {
    
	private static final Mgr02 INSTANCE;

    // 使用静态代码块初始化
	static {
		INSTANCE = new Mgr02();
	}

	private Mgr02() {

	}

	public static Mgr02 getInstance() {
		return INSTANCE;
	}

	public void m() {
		System.out.println("m");
	}

	public static void main(String[] args) {
		Mgr02 m1 = Mgr02.getInstance();
		Mgr02 m2 = Mgr02.getInstance();
		System.out.println(m1.equals(m2));
	}
}
~~~

结果:

~~~java
true
~~~

> 这种其实和第一种实现方式是一样的,区别在于使用了静态代码块初始化

#### **第三种:**

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/12 9:46
 * ClassName:Mgr03
 * 类描述：懒汉式
 * 优点: 可以按需调用
 * 缺点: 线程不安全
 */
public class Mgr03 {
    // 创建时不进行初始化
	private static Mgr03 INSTANCE;

    // 私有构造方法,不进行实例化
	private Mgr03() {
	}

    // 进行判断,调用getInstance方法为null就初始化
	public static Mgr03 getInstance() {
        // INSTANCE等于null就进行初始化
		if (INSTANCE == null) {
			try {
				Thread.sleep(1);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
            // 判断INSTANCE不等于null就不进行初始化
			INSTANCE = new Mgr03();
		}
		return INSTANCE;
	}

	public void m() {
		System.out.println("m");
	}

	public static void main(String[] args) {
		for (int i = 0; i < 100; i++) {
            // JDK1.8新增的lambd
			new Thread(() ->
			// com.mobaijun.singleton.Mgr03@8ae2e7e
			// com.mobaijun.singleton.Mgr03@5372fc23
			// 调用getInstance()方法.打印内存地址,判断结果是否一样
            System.out.println(Mgr03.getInstance().hashCode())
			).start();
		}
	}
}
~~~

结果:

~~~java
145632894
145632894
145632894
145632894
145632894
1400044579
1400044579
~~~

#### **第四种:**

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/12 9:46
 * ClassName:Mgr03
 * 类描述：懒汉式
 * 优点: 可以按需调用
 * 缺点: 线程不安全
 * 解决方案: 添加synchronized
 * 新缺点: 添加synchronized后线程效率会降低
 */
public class Mgr04 {

	private static Mgr04 INSTANCE;

	private Mgr04() {
	}

    // 添加synchronized关键字
	public static synchronized Mgr04 getInstance() {
		if (INSTANCE == null) {
			try {
				Thread.sleep(1);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			INSTANCE = new Mgr04();
		}
		return INSTANCE;
	}

	public void m() {
		System.out.println("m");
	}

	public static void main(String[] args) {
		for (int i = 0; i < 100; i++) {
			new Thread(() ->
					System.out.println(Mgr04.getInstance().hashCode())
			).start();
		}
	}
}
~~~

结果:

~~~java
1645804334
1645804334
1645804334
1645804334
1645804334
1645804334
1645804334
1645804334
1645804334
1645804334
1645804334
1645804334
~~~

#### **第五种:**

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/12 9:46
 * ClassName:Mgr03
 * 类描述：懒汉式
 * 优点: 可以按需调用
 * 缺点: 线程不安全
 * 解决方案: 添加synchronized
 * 新缺点: 添加synchronized后线程效率会降低
 */
public class Mgr05 {

	private static Mgr05 INSTANCE;

	private Mgr05() {
	}

	public static synchronized Mgr05 getInstance() {
		if (INSTANCE == null) {
			// 试图通过添加synchronized减小同步代码块的方式提高效率,然后不可行
			synchronized (Mgr05.class) {
				try {
					Thread.sleep(1);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				INSTANCE = new Mgr05();
			}
		}
		return INSTANCE;
	}

	public void m() {
		System.out.println("m");
	}

	public static void main(String[] args) {
		for (int i = 0; i < 100; i++) {
			new Thread(() ->
					System.out.println(Mgr05.getInstance().hashCode())
			).start();
		}
	}
}
~~~

结果

~~~java
145632894
145632894
145632894
145632894
145632894
145632894
~~~

#### **第六种:**

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/12 9:46
 * ClassName:Mgr03
 * 类描述：懒汉式
 * 优点: 可以按需调用
 * 缺点: 线程不安全
 * 解决方案: 添加synchronized
 * 新缺点: 添加synchronized后线程效率会降低
 */
public class Mgr06 {

	// volatile解决指令重排的问题
	private static volatile Mgr06 INSTANCE;

	private Mgr06() {
	}

	public static Mgr06 getInstance() {
        // 1.首先判断是否为null
		if (INSTANCE == null) {
            // 2.如果为null即不执行
            // 双重检查
			synchronized (Mgr06.class) {
				if (INSTANCE == null) {
					try {
						Thread.sleep(1);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
					INSTANCE = new Mgr06();
				}
			}
		}
		return INSTANCE;
	}

	public void m() {
		System.out.println("m");
	}

	public static void main(String[] args) {
		for (int i = 0; i < 100; i++) {
			new Thread(() ->
					System.out.println(Mgr06.getInstance().hashCode())
			).start();
		}
	}
}
~~~

结果:

~~~java
145632894
145632894
145632894
145632894
145632894
145632894
~~~

#### **第七种:**

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/12 9:46
 * ClassName:Mgr03
 * 类描述：懒汉式
 * 最完美的写法
 * 使用静态内部类方式,JVM保证单例
 * 加载外部类时不会加载内部类,可以实现懒加载
 */
// 外部类
public class Mgr07 {


	// 私有构造方法
	private Mgr07() {
	}

	// 内部类
	private static class Mgr07Holder {
		private final static Mgr07 INSTANCE = new Mgr07();
	}

	// 调用Mgr07Holder.INSTANCE
	public static Mgr07 getInstance() {
		return Mgr07Holder.INSTANCE;
	}

	public void m() {
		System.out.println("m");
	}

	public static void main(String[] args) {
		for (int i = 0; i < 100; i++) {
			new Thread(() ->
					System.out.println(Mgr07.getInstance().hashCode())
			).start();
		}
	}
}
~~~

结果:

~~~java
1052444169
1052444169
1052444169
1052444169
1052444169
1052444169
1052444169
1052444169
1052444169
~~~

> 这种方式在之前的单例模式写法种是被认为最完美的,

#### **第八种:**

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/5/12 10:21
 * EnumName:Mgr08
 * 枚举类描述：单例
 * 不仅可以解决线程同步,还可以防止反序列化
 */
public enum Mgr08 {

    // 只设置一个值
	INSTANCE;

	public void m() {

	}

	public static void main(String[] args) {
		for (int i = 0; i < 100; i++) {
			new Thread(() ->
					System.out.println(Mgr08.INSTANCE.hashCode())
			).start();
		}
	}
}
~~~

结果:

~~~java
145632894
145632894
145632894
145632894
145632894
145632894
145632894
145632894
~~~

> 据说枚举单例是Java某一个创始人设计的,堪称最完美,最简单的单例啦,当然,使用单例的场景很多,我们还是需要根据现实开发的场景去确定使用哪种方式实现单例模式;