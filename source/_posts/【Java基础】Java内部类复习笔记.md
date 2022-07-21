---
title: 【Java基础】Java内部类复习笔记
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 内部类
categories:
  - 后端
abbrlink: 664001238
date: 2020-04-30 16:32:09
img:
coverImg:
password:
summary:
---



## 什么是Java内部类?

> 在类内部可定义成员变量和方法，且在类内部也可以定义另一个类。如果在类 Outer 的内部再定义一个类 Inner，此时类 Inner 就称为内部类（或称为嵌套类），而类 Outer 则称为外部类（或称为宿主类）。内部类也是Java类的五大成份之一;
>
> **Java类的五大成份**
>
> * 成员变量
> * 构造方法
> * 成员方法
> * 代码块
> * 内部类

## 内部类优点

1. 内部类仍然是一个独立的类，在编译之后内部类会被编译成独立的`.class`文件，但是前面冠以外部类的类名和`$`符号。
2. 内部类不能用普通的方式访问。内部类是外部类的一个成员，因此内部类可以自由地访问外部类的成员变量，无论是否为 private 的。
3. 内部类声明成静态的，就不能随便访问外部类的成员变量，仍然是只能访问外部类的静态成员变量。
4. 内部类可以很好地实现隐藏，一般的非内部类是不允许有 private 与 protected 权限的，但内部类可以。内部类拥有外部类的所有元素的访问权限。

**详细说明**

- 外部类只有两种访问级别：public 和默认；内部类则有 4 种访问级别：public、protected、 private 和默认。
- 在外部类中可以直接通过内部类的类名访问内部类。

~~~java
InnerClass ic = new InnerClass();    // InnerClass为内部类的类名
~~~

- 在外部类以外的其他类中则需要通过内部类的完整类名访问内部类。

```Java
Test.InnerClass ti = newTest().new InnerClass();    // Test.innerClass是内部类的完整类名
```

- 内部类与外部类不能重名。

> 提示：内部类的很多访问规则可以参考变量和方法。另外使用内部类可以使程序结构变得紧凑，但是却在一定程度上破坏了Java面向对象的思想。

## 内部类的使用场景

> `如一个事务内部还有一个独立的事务,内部的事务脱离外部的事务无法独立使用`

* 一个人必须有一个心脏
* 汽车里面有一个发动机
* 实现更好的封装性

## 内部类的分类

如果按照定义的位置来分类,那么内部类分为以下四种

* **静态内部类:**`类定义在了成员位置 (类中方法外称为成员位置，有static修饰的内部类)`
* **实例内部类:**`类定义在了成员位置 (类中方法外称为成员位置，无static修饰的内部类)`
* **局部内部类:** 类定义在方法内
* **匿名内部类:**一般定义在方法中，或者可执行代码中。

## 静态内部类

**特点:**

* 有`static`关键字修饰的内部类,属于外部类本身的
* 静态内部类可以直接访问外部类的静态成员，如果要访问外部类的实例成员，则需要通过外部类的实例去访问。
* 静态内部类与其他类的用法完全一样,只是访问格式需要加上`外部类.内部类`	

**案例代码**

~~~java
// 外部类
class Outer {

	// 静态成员变量
	private static String sc_name = "墨白科技有限公司";

	// 内部类
	public static class Inner {
		//成员变量
		private String name;

        // 构造器
		public Inner(String name) {
			this.name = name;
		}

		public void showName() {
			System.out.println(this.name);
			// 静态内部类可以直接访问外部类静态成员变量
			System.out.println(sc_name);
		}
	}
}

// Test方法
public class Demo3 {
	public static void main(String[] args) {
		// 创建内部类对象| 外部类.内部类 变量 = new 外部类.内部类构造器();
		Outer.Inner inner = new Outer.Inner("墨白");
		inner.showName();
	}
}
~~~

## 实例内部类

**实例内部类特点**

* 没有`static`修饰的内部类,属于外部类对象的
* 宿主:外部类对象
* 实例内部类不可以定义静态成员
* 实例内部类可以访问外部类的私有和静态成员

**案例代码**

~~~java
// 外部类
class Outer2 {

	// 实例内部类,属于外部类对象的
	public class Inner2 {

		// 成员变量
		private String name;

		// 实例内部类不能定义静态成员
		// private static String sc_name = "墨白科技有限公司"; // 报错

		public Inner2(String name) {
			this.name = name;
		}
		public void showName() {
			System.out.println(this.name);
		}
	}
}

// Test方法
public class Demo4 {
	public static void main(String[] args) {
		// 宿主:外部类对象
		Outer2.Inner2 inner2 = new Outer2().new Inner2("墨白");
		inner2.showName();
	}
}
~~~

## 局部内部类

**特点:**

* 定义在方法中的类
* 局部内部类与局部变量一样，不能使用访问控制修饰符（public、private 和 protected）和 static 修饰符修饰。
* 局部内部类只在当前方法中有效。
* 局部内部类中不能定义 static 成员。
* 局部内部类中还可以包含内部类，但是这些内部类也不能使用访问控制修饰符（public、private 和 protected）和 static 修饰符修饰。
* 在局部内部类中可以访问外部类的所有成员。
* 在局部内部类中只可以访问当前方法中 final 类型的参数与变量。如果方法中的成员与外部类中的成员同名，则可以使用 <OuterClassName>.this.<MemberName> 的形式访问外部类中的成员。

**案例代码**

~~~java
public class Test {
    int a = 0;
    int d = 0;
    public void method() {
        int b = 0;
        final int c = 0;
        final int d = 10;
        // 局部内部类
        class Inner {
            a2 = a;    // 访问外部类中的成员
            // int b2 = b;    // 编译出错
            int c2 = c;    // 访问方法中的成员
            int d2 = d;    // 访问方法中的成员
            int d3 = Test.this.d;    //访问外部类中的成员
        }
        Inner i = new Inner();
        System.out.println(i.d2);    // 输出10
        System.out.printIn(i.d3);    // 输出0
    }
    public static void main(String[] args) {
        Test t = new Test();
        t.method();
    }
}
~~~

## 匿名内部类

### **简介:** 

> **匿名内部类** ：是内部类的简化写法。匿名类是指没有类名的内部类，必须在创建时使用 new 语句来声明类,它的本质是一个`带具体实现的` `父类或者父接口的` `匿名的` **子类对象**。实际开发中，最常用到的内部类就是匿名内部类了。

### **特点**

- 匿名类中允许使用非静态代码块进行成员初始化操作。
- 匿名类和局部内部类一样，可以访问外部类的所有成员。如果匿名类位于一个方法中，则匿名类只能访问方法中 final 类型的局部变量和参数。
- 匿名类的非静态代码块会在父类的构造方法之后被执行。
- 匿名内部类的本质作用是为了**简化代码**。 

### **案例说明:**

在没有学习匿名内部类之前,我们需要使用接口时,需要进行以下步骤:

* 定义子类
* 重写接口中的方法
* 创建子类对象
* 调用重写后的方法

~~~java
// 定义一个接口
interface Swim {
	// 抽象方法
	public void swimming();
}

// 1.定义接口的实现类
class Student implements Swim {

	// 2.重写抽象方法
	@Override
	public void swimming() {
		System.out.println("蛙泳");
	}
}

public class Demo5 {
	public static void main(String[] args) {
		// 3.创建实现类对象
		Student student = new Student();
		// 4.使用对象调用方法
		student.swimming();
	}
}
~~~

> 可以看到实现的过程很麻烦,而我最终的目的不过是想调用`swimming`方法而已,所以下面可以使用匿名内部类来简化开发

### 匿名内部类前提和格式

* 匿名内部类必须**继承一个父类**或者**实现一个父接口**。

**匿名内部类格式**

~~~java
new 父类名或者接口名(){
    // 方法重写
    @Override 
    public void method() {
        // 执行语句
    }
};
~~~

### 使用方式

~~~java
interface Swim {
    public abstract void swimming();
}

public class Demo07 {
    public static void main(String[] args) {
        // 使用匿名内部类
		new Swim() {
			@Override
			public void swimming() {
				System.out.println("自由泳...");
			}
		}.swimming();

        // 接口 变量 = new 实现类(); // 多态,走子类的重写方法
        Swim s2 = new Swim() {
            @Override
            public void swimming() {
                System.out.println("蛙泳...");
            }
        };

        s2.swimming();
        s2.swimming();
    }
}
~~~

### 匿名内部类的使用场景

> 通常在方法的形式参数是接口或者抽象类时，也可以将匿名内部类作为参数传递。代码如下：

~~~java
interface Swim {
    public abstract void swimming();
}

public class Demo07 {
    public static void main(String[] args) {
        // 普通方式传入对象
        // 创建实现类对象
        Student s = new Student();
        
        goSwimming(s);
        // 匿名内部类使用场景:作为方法参数传递
        Swim s3 = new Swim() {
            @Override
            public void swimming() {
                System.out.println("蝶泳...");
            }
        };
        // 传入匿名内部类
        goSwimming(s3);

        // 完美方案: 一步到位
        goSwimming(new Swim() {
            public void swimming() {
                System.out.println("大学生, 蛙泳...");
            }
        });

        goSwimming(new Swim() {
            public void swimming() {
                System.out.println("小学生, 自由泳...");
            }
        });
    }

    // 定义一个方法,模拟请一些人去游泳
    public static void goSwimming(Swim s) {
        s.swimming();
    }
}
~~~

