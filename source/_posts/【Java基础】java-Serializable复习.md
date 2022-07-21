---
title: '【Java基础】java-[Serializable复习]'
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - JavaSE
categories:
  - 后端
abbrlink: 98857262
date: 2020-05-06 15:16:36
img:
coverImg:
password:
summary:
---

# Serializable序列化的简要说明([原文地址](https://www.cnblogs.com/huhx/p/serializable.html#friend_link))

## 一、 持久化的简单介绍：

　　“持久化”意味着对象的“生存时间”并不取决于程序是否正在执行——它存在或“生存”于程序的每一次调用之间。通过序列化一个对象，将其写入磁盘，以后在程序再次调用时重新恢复那个对象，就能圆满实现一种“持久”效果。

## 二、 语言里增加了对象序列化的概念后，可提供对两种主要特性的支持：

- 远程方法调用（`RMI`）使本来存在于其他机器的对象可以表现出好象就在本地机器上的行为。将消息发给远程对象时，需要通过对象序列化来传输参数和返回值。
- 使用一个`Java Bean `时，它的状态信息通常在设计期间配置好。程序启动以后，这种状态信息必须保存下来，以便程序启动以后恢复；具体工作由对象序列化完成。

## 三、 Serializable的一些说明：

- 对象的序列化处理非常简单，只需对象实现了`Serializable `接口即可（该接口仅是一个标记，没有方法）
- 序列化的对象包括基本数据类型，所有集合类以及其他许多东西，还有`Class `对象
- 对象序列化不仅保存了对象的“全景图”，而且能追踪对象内包含的所有句柄并保存那些对象；接着又能对每个对象内包含的句柄进行追踪
- 使用`transient`关键字修饰的的变量，在序列化对象的过程中，该属性不会被序列化。

## 四、 序列化的步骤：

- 首先要创建某些`OutputStream`对象：

~~~java
OutputStream outputStream = new FileOutputStream("output.txt")
~~~

- 将其封装到`ObjectOutputStream`对象内：

~~~java
ObjectOutputStream objectOutputStream = new ObjectOutputStream(outputStream);
~~~

- 此后只需调用`writeObject()`即可完成对象的序列化，并将其发送给

~~~java
OutputStream：objectOutputStream.writeObject(Object);
~~~

- 最后不要忘记关闭资源：

~~~java
objectOutputStream.close(), outputStream .close();
~~~

## 五、 反序列化的步骤：

- 首先要创建某些`OutputStream`对象：

~~~java
InputStream inputStream= new FileInputStream("output.txt")
~~~

- 将其封装到ObjectInputStream对象内：

~~~java
ObjectInputStream objectInputStream= new ObjectInputStream(inputStream);
~~~

- 此后只需调用readObject()即可完成对象的反序列化：

~~~java
objectInputStream.readObject();
~~~

- 最后不要忘记关闭资源：

~~~java
objectInputStream.close()，inputStream.close();
~~~

## Serializable的一些说明

- 对象的序列化处理非常简单，只需对象实现了Serializable 接口即可（该接口仅是一个标记，没有方法）
- 序列化的对象包括基本数据类型，所有集合类以及其他许多东西，还有`Class `对象
- 对象序列化不仅保存了对象的“全景图”，而且能追踪对象内包含的所有句柄并保存那些对象；接着又能对每个对象内包含的句柄进行追踪
- 使用`transient`关键字修饰的的变量，在序列化对象的过程中，该属性不会被序列化。

# Serializable序列化的代码实例

一、 首先我们建立一个Man类，实现了Serializable接口，用于Person类的测试：

~~~java
public class Man implements Serializable {

	private static final long serialVersionUID = 1L;

	private String username;

	private String passworld;

	public Man(String username, String passworld) {
		this.username = username;
		this.passworld = passworld;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassworld() {
		return passworld;
	}

	public void setPassworld(String passworld) {
		this.passworld = passworld;
	}
}
~~~

二、 我们再建立一个Person类，用于序列化：

~~~java
public class Person implements Serializable {
	private static final long serialVersionUID = 1L;
	private Man man;
	private String username;
	private transient int age;

	public Person() {
		System.out.println("person constru");
	}

	public Person(Man man, String username, int age) {
		this.man = man;
		this.username = username;
		this.age = age;
	}

	public Man getMan() {
		return man;
	}

	public void setMan(Man man) {
		this.man = man;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}
}
~~~

三、 编写一个包含main方法的测试类：MainTest，它的writeSerializableObject用于序列化对象：

~~~java
public static void writeSerializableObject() {
		try {
			Man man = new Man("root", "123456");
			Persion persion = new Persion(man, "墨白", 21);
			OutputStream out;
			ObjectOutputStream o = new ObjectOutputStream(new FileOutputStream("output.txt"));
			o.writeObject("String");
			o.writeObject(persion);
			o.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
~~~

四、  测试类`MainTest`，它的`readSerializableObject`用于反序列化对象：

~~~java
// Serializable：反序列化对象
	public static void readSerializableObject() {
		try {
			ObjectInputStream objectInputStream = new ObjectInputStream(new FileInputStream("output.txt"));
			String string = (String) objectInputStream.readObject();
			Persion person = (Persion) objectInputStream.readObject();
			objectInputStream.close();
			System.out.println(string + ", age: " + person.getAge() + ", man username: " + person.getMan().getUsername());
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
~~~

五、 在`Main`方法添加以上两个方法的运行，结果如下：

```java
String, age: 0, man username: root
```

-  在`Person`类中包含`Man`的引用，当`Person`被序列化的时候，从结果可以知道`Man`也被序列化了
- `writeObject`方法可以传入`String`，是因为`String`首先是一个类，其次它也是实现了`Serializable`接口的
- `Person`类中的`age`字段是`transient`，从打印结果可以看到，序列化`Person person = new Person(man, "刘力", 21)`对象时，`age`没有进行序列化。如果`transient`修饰的`Object`类型的，那么打印的结果将会是`null`

## 相关注意事项

* 序列化时，只对对象的状态进行保存，而不管对象的方法；

* 当一个父类实现序列化，子类自动实现序列化，不需要显式实现`Serializable`接口；

* 当一个对象的实例变量引用其他对象，序列化该对象时也把引用对象进行序列化；

* 并非所有的对象都可以序列化，,至于为什么不可以，有很多原因了,比如：

  > * 安全方面的原因，比如一个对象拥有private，public等field，对于一个要传输的对象，比如写到文件，或者进行rmi传输 等等，在序列化进行传输的过程中，这个对象的private等域是不受保护的。
  > * 资源分配方面的原因，比如socket，thread类，如果可以序列化，进行传输或者保存，也无法对他们进行重新的资源分 配，而且，也是没有必要这样实现。