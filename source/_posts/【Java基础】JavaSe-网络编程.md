---
title: 【Java基础】JavaSe-网络编程
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1483848703
tags:
  - TCP/UDP
categories:
  - 后端
date: 2021-04-26 16:00:35
img:
coverImg:
password:
summary:
---

### 网络编程概述

![](https://tencent.cos.mobaijun.com/article_with_pictures/a7wKTXMHBxPCfv9.png)

* 计算机网络：

计算机网络是指将地理位置不同的具有独立功能的多台计算机及其外部设备，通过通信线路连接起来，在网络操作系统，网络管理软件及网络通信协议的管理和协调下，实现资源共享和信息传递的计算机系统。

* 网络编程的目的：

无线电台。。。。。。，传播交流信息，数据交换。通信

* 想要达到这个效果需要什么？

1. 如何准确的定位网络上的一台主机：192.168.16.124：端口，定位到这个计算机上的某个资源
2. 找到了这个主机，可以通过UDP，HTTP ,TCP传输数据

### 网络通信的要素

* 如何实现网络的通信？

  * 通信双方的地址
    * IP地址
    * 端口号
    * 113.105.155.200:8008

* 规则：网络通信的协议

  文章链接：[OSI七层模型与TCP/IP五层模型](https://www.cnblogs.com/qishui/p/5428938.html)

TCP/IP参考模型

![](https://tencent.cos.mobaijun.com/article_with_pictures/bSHRxEj9287q6oK.png)

1. 网络编程中有两个主要问题
   * 如何准确的定位到网络上的一台主机或多台主机
     * 通过IP和端口
   * 找到主机后如何进行通信
     * 通过TCP、UDP协议
2. 网络编程中的要素
   * IP 和端口号
   * 网络通信协议
3. Java万物皆对象

### IP

IP类 ：InetAddress

* IP是唯一定位一台网络上的计算机

* 特殊域名：127.0.0.1：本机|local host

* IP地址的分类

  * IPV4 / IPV6

    * IPV4：127.0.0.1，4个字节组成，0-255，42亿个，30亿在北美，亚洲4亿。2011年用尽。


  ~~~bash
  fe80::85a6:7470:2f32:ee3%20
  ~~~

  * 公网（互联网）、私网（局域网）

    * ABCD 类地址
    * 192.168.xxx.xxx ，专门给组织内部使用

  * 域名：映射IP地址

    * 域名：www.mobaijun.com

* 示例代码

~~~java
public class IPOne {
    public static void main(String[] args) throws UnknownHostException {
        InetAddress byName1 = InetAddress.getByName("www.mobaijun.com");
        InetAddress byName2 = InetAddress.getLocalHost();
        InetAddress byName3 = InetAddress.getByName("127.0.0.1");
        InetAddress byName4 = InetAddress.getByName("localhost");
        System.out.println("byName1 = " + byName1);
        System.out.println("byName2 = " + byName2);
        System.out.println("byName3 = " + byName3);
        System.out.println("byName4 = " + byName4);

        // ============================== 常用方法 ============================== //
        // 获取一个字节数组
        System.out.println("byName1.getAddress() = " + byName1.getAddress());
        // 获取IP地址
        System.out.println("byName1.getHostAddress() = " + byName1.getHostAddress());
        // 获取域名，或自己电脑的名称
        System.out.println("byName1.getHostName() = " + byName1.getHostName());
        // 获取规范名称
        System.out.println("byName1.getCanonicalHostName() = " + byName1.getCanonicalHostName());
    }
}
~~~

### 端口

端口表示计算机上的一个程序的进程：

* 不同的进程有不同的端口号！用来区分软件【如同一栋楼，楼表示IP，住户表示端口号】

* 一台电脑上端口号被规定1~~665535之间，其中1～1024是被RFC 3232规定好了的，被称作“众所周知的端口”(Well Known Ports)；

* 并被分为TCP，UDP：65535 * 2，单个协议下，端口号不能冲突

* 端口分类

  * 公有端口 0 ~ 1023
    * 21端口：FTP 文件传输服务
    * 22端口：SSH 远程连接服务
    * 23端口：TELNET 终端仿真服务
    * 25端口：SMTP 简单邮件传输服务
    * 53端口：DNS 域名解析服务
    * 80端口：HTTP 超文本传输服务
    * 443端口：HTTPS 加密的超文本传输服务
  * 程序注册端口 1024 ~ 49151
    * 3306端口：MYSQL数据库端口
    * 5432端口：postgresql数据库端口
    * 6379端口：Redis数据库端口
    * 8080端口：TCP服务端默认端口
    * 9200端口：Elasticsearch服务器端口
    * 27017端口：mongoDB数据库默认端口
    * 22122端口：fastdfs服务器默认端口
    * 8086端口：influxDB数据库端口
  * 动态端口，私有端口：49152 ~ 65535

  ~~~bash
  # 查看所有端口 Windows
  $ netstat -ano
  # Linux管道流查看指定的端口
  $ netstat -ano|findstr '5900' 
  # 查看指定端口的进程
  $ tasklist|findstr "14768"
  ~~~

  * 示例代码

  ~~~java
  public class PortSocketOne {
      public static void main(String[] args) {
          InetSocketAddress inetSocketAddress1 = new InetSocketAddress("127.0.0.1", 8080);
          InetSocketAddress inetSocketAddress2 = new InetSocketAddress("localhost", 8080);
          // 输出端口号
          System.out.println("inetSocketAddress1 = " + inetSocketAddress1);
          System.out.println("inetSocketAddress2 = " + inetSocketAddress2);
          // ============================== 常用方法 ============================== //
          System.out.println("inetSocketAddress1.getAddress() = " + inetSocketAddress1.getAddress());
          System.out.println("inetSocketAddress1.getHostName() = " + inetSocketAddress1.getHostName());
          System.out.println("inetSocketAddress1.getPort() = " + inetSocketAddress1.getPort());
          System.out.println("inetSocketAddress1.getHostString() = " + inetSocketAddress1.getHostString());
      }
  }
  ~~~

  ### 通信协议

  协议：约定，就好比我国的官方语言是普通话。

  网络通信协议：速率，传输码率，代码结构，传输控制。。。。。。。

  问题：非常的复杂！
  大事化小：分层

  TCP/IP协议：

  * TCP：用户传输协议
  * UDP：用户数据报协议

  出名的协议：

  * TCP
  * IP：网络互联协议

TCP和UDP对比

* TCP

  * 连接，稳定
  * 三次握手，四次挥手

  ~~~bash
  # 连接
  最少需要三次，才能保证稳定连接！
  A：你愁啥？
  B：瞅你咋地？
  A：干一场！
  # 分开
  A：我要断开我们的连接了
  B：我知道你要断开了？
  B：你真的要断开了嘛？
  A：我真的要断开连接了！
  ~~~

  * 客户端，服务的
  * 传输完成，释放连接，效率低

* 三次握手建立连接

![](https://tencent.cos.mobaijun.com/article_with_pictures/KBw7JlDhr9fxAGR.png)

* 四次握手关闭连接

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20210425094232014.png)

* UDP
  * 发短信
  * 直播
  * 不需要连接，不稳定
  * 客户端，服务端：没有明确的界限
  * DDOS：洪水攻击！
  * 导弹攻击，（饱和攻击）

![](https://tencent.cos.mobaijun.com/article_with_pictures/add.gif)

### TCP实现聊天

客户端：

* 连接服务器Socket
* 发送消息
* 关闭流

~~~java
public class TcpClient {
    public static void main(String[] args) throws Exception {
        // 1.要知道服务器的地址
        InetAddress byName = InetAddress.getByName("127.0.0.1");
        int port = 9999;
        // 2.创建连接
        Socket socket = new Socket(byName, port);
        // 3.发送消息 IO 流/输出流
        OutputStream os = socket.getOutputStream();
        os.write("你好，我是TCP客户端".getBytes());
        // 关闭资源
        if (os != null) {
            os.close();
        } else if (socket != null) {
            socket.close();
        }
    }
}
~~~

服务端：

*  建立服务器，端口ServerSocket
*  等待用户的连接 accept
*  接收客户端消息

~~~java
public class TcpServer {
    public static void main(String[] args) throws IOException {
        // 1.我需要有一个响应地址
        ServerSocket serverSocket = new ServerSocket(9999);
        // 2.等待客户端连接过来,侦听
        while (true) {
            Socket accept = serverSocket.accept();
            // 3.读取客户端消息
            InputStream is = accept.getInputStream();
        /*
        byte[] buffer = new byte[1024];
        int length;
        while ((length = is.read(buffer)) != -1) {
            String msg = new String(buffer, 0, length);
            System.out.println("msg = " + msg);
        }
        */
            // 管道流
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            int length;
            while ((length = is.read(buffer)) != -1) {
                baos.write(buffer, 0, length);
            }
            System.out.println("baos = " + baos.toString());
            // 关闭流
            if (baos != null) {
                baos.close();
            } else if (is != null) {
                is.close();
            } else if (accept != null) {
                accept.close();
            } else if (serverSocket != null) {
                serverSocket.close();
            }
        }
    }
}
~~~

#### TCP 文件上传

服务器代码

~~~java
/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 10:58
 * ClassName:TcpServerFile
 * 类描述： TCP文件上传服务端
 */
public class TcpServerFile {
    public static void main(String[] args) throws Exception {
        // 1.创建一个服务
        ServerSocket serverSocket = new ServerSocket(8090);
        // 2.监听客户端的连接
        Socket accept = serverSocket.accept(); // 阻塞式监听，会一直等待客户端的连接
        // 3.获取输入流
        InputStream is = accept.getInputStream();
        // 4.文件输出
        FileOutputStream receive = new FileOutputStream(new File("src/main/resources/receive.jpg"));
        byte[] buffer = new byte[1024];
        int length;
        while ((length = is.read(buffer)) != -1) {
            receive.write(buffer, 0, length);
        }
        // 6.通知客户端接收完毕
        OutputStream os = accept.getOutputStream();
        os.write("我已接收完毕,你可以断开连接了".getBytes());

        // 5.关闭资源
        if (os != null) {
            /**
             * 如果不关闭资源。就会出现 java.net.SocketException: Connection reset
             * https://www.cnblogs.com/panchanggui/p/9667587.html
             */
            os.close();
        } else if (receive != null) {
            receive.close();
        } else if (is != null) {
            is.close();
        } else if (accept != null) {
            accept.close();
        } else if (serverSocket != null) {
            serverSocket.close();
        }
    }
}
~~~

客户端代码

~~~java
/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 10:48
 * ClassName:TcpClientFile
 * 类描述： TCP文件上传
 */
public class TcpClientFile {
    public static void main(String[] args) throws Exception {
        // 1.创建一个Socket连接
        Socket socket = new Socket(InetAddress.getLocalHost(), 8090);
        // 2.创建一个输出流
        OutputStream os = socket.getOutputStream();
        // 3.读取文件
        FileInputStream fis = new FileInputStream(new File("src/main/resources/0.jpg"));
        // 4.写出文件
        byte[] buffer = new byte[1024];
        int length;
        while ((length = fis.read(buffer)) != -1) {
            os.write(buffer, 0, length);
        }

        // 7.通知服务器，我已经结束了
        socket.shutdownOutput(); // 我已经传输完毕

        // 6. 确定服务器接收完毕，然后断开连接
        InputStream is = socket.getInputStream();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer2 = new byte[2014];
        int length2;
        while ((length2 = is.read(buffer2)) != -1) {
            baos.write(buffer2, 0, length2);
        }
        System.out.println("baos = " + baos.toString());

        // 5.关闭流
        if (baos != null) {
            baos.close();
        } else if (is != null) {
            is.close();
        } else if (os != null) {
            baos.close();
        } else if (fis != null) {
            fis.close();
        } else if (socket != null) {
            socket.close();
        }
    }
}
~~~

### UDP

发短信：不需要连接，但是需要接收方的地址

> Internet 的传输层有两个主要协议，互为补充。无连接的是 UDP，它除了给应用程序发送数据包功能并允许它们在所需的层次上架构自己的协议之外，几乎没有做什么特别的事情。面向连接的是 [TCP](https://baike.baidu.com/item/TCP/33012)，该协议几乎做了所有的事情。

![udp传输概念图](https://tencent.cos.mobaijun.com/article_with_pictures/image-20210425140225667.png)

* 发送消息

~~~java
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.nio.charset.StandardCharsets;

/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 11:52
 * ClassName:UdpClient
 * 类描述： UDP发送方
 */
public class UdpClient {
    public static void main(String[] args) throws Exception {
        // 1.建立一个Socket
        DatagramSocket socket = new DatagramSocket();
        String msg = "Hello,你好呀，接收方";
        // 2.建立数据包
        DatagramPacket packet = new DatagramPacket(msg.getBytes(StandardCharsets.UTF_8), 0, msg.getBytes(StandardCharsets.UTF_8).length, InetAddress.getLocalHost(), 9090);
        // 3.发送包
        socket.send(packet);
        // 4.关闭流
        socket.close();
    }
}
~~~

* 接收端

~~~java
import java.net.DatagramPacket;
import java.net.DatagramSocket;

/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 11:52
 * ClassName:UdpServer
 * 类描述： UDP接收方
 */
public class UdpServer {
    public static void main(String[] args) throws Exception {
        // 1.开放端口
        DatagramSocket socket = new DatagramSocket(9090);
        // 2.接收数据包
        byte[] buffer = new byte[1024];
        DatagramPacket packet = new DatagramPacket(buffer, 0, buffer.length);
        // 3.阻塞接收
        socket.receive(packet);
        // 5.输出
        System.out.println(packet.getAddress().getHostAddress() + ":" + packet.getPort()); // 192.168.1.123:59572
        System.out.println(new String(packet.getData(), 0, packet.getLength())); // Hello,你好呀，接收方
        // 4.关闭流
        if (socket != null) {
            socket.close();
        }
    }
}
~~~

#### UDP实现网页单向发送消息

循环发送消息方

~~~java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;

/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 14:04
 * ClassName:UdpChatClient
 * 类描述： UDP实现聊天发送端
 */
public class UdpChatClient {
    public static void main(String[] args) throws Exception {
        // 1.创建连接
        DatagramSocket socket = new DatagramSocket(8888);
        // 2.准备数据，从控制台读取数据
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        while (true) {
            String msg = reader.readLine();
            byte[] data = msg.getBytes(StandardCharsets.UTF_8);
            // 3.创建消息
            DatagramPacket packet = new DatagramPacket(data, 0, data.length, new InetSocketAddress(InetAddress.getLocalHost(), 6666));
            // 4.发送消息
            socket.send(packet);

            if (msg.contains("bye")) {
                break;
            }
        }
        // 5.关闭流
        if (reader != null) {
            reader.close();
        } else if (socket != null) {
            socket.close();
        }
    }
}
~~~

循环接收消息方

~~~java
import java.net.DatagramPacket;
import java.net.DatagramSocket;

/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 14:05
 * ClassName:UdpChatServer
 * 类描述： UDP实现聊天接收端、发送端
 */
public class UdpChatServer {
    public static void main(String[] args) throws Exception {
        // 创建连接
        DatagramSocket socket = new DatagramSocket(6666);
        while (true) {
            byte[] container = new byte[1024];
            DatagramPacket packet = new DatagramPacket(container, 0, container.length);
            // 接收数据包、阻塞式接收
            socket.receive(packet);

            byte[] data = packet.getData();
            String receiveData = new String(data, 0, data.length);
            System.out.println("receiveData = " + receiveData);
            // 当对方发送bye，就停止
            if (receiveData.contains("bye")) {
                break;
            }
        }
        if (socket != null) {
            socket.close();
        }
    }
}
~~~

#### 多线程对话

> 两个人都可以是发送方，也可以是接收方

* 多线程发送

~~~java
package com.mobai.learningcode.net.thread;

import lombok.SneakyThrows;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;

/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 15:04
 * ClassName:TalkReceive
 * 类描述： 多线程发送
 */
public class TalkReceive implements Runnable {
    // 我的端口
    private Integer port;
    // 发送方
    private String msgFrom;

    DatagramSocket socket = null;
    DatagramPacket packet = null;

    /**
     * 构造方法
     *
     * @param port 我的端口
     */
    public TalkReceive(Integer port, String msgFrom) {
        this.port = port;
        this.msgFrom = msgFrom;
        try {
            socket = new DatagramSocket(port);
        } catch (SocketException e) {
            e.printStackTrace();
        }
    }

    @SneakyThrows
    @Override
    public void run() {
        // 创建连接
        while (true) {
            byte[] container = new byte[1024];
            packet = new DatagramPacket(container, 0, container.length);
            // 接收数据包、阻塞式接收
            socket.receive(packet);

            byte[] data = packet.getData();
            String receiveData = new String(data, 0, data.length);
            System.out.println(msgFrom + ":" + receiveData);
            // 当对方发送bye，就停止
            if (receiveData.contains("bye")) {
                break;
            }
        }
        if (socket != null) {
            socket.close();
        }
    }
}
~~~

* 多线程接收

~~~java
package com.mobai.learningcode.net.thread;

import lombok.SneakyThrows;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;

/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 15:04
 * ClassName:TalkReceive
 * 类描述： 多线程接收
 */
public class TalkReceive implements Runnable {
    // 我的端口
    private Integer port;
    // 发送方
    private String msgFrom;

    DatagramSocket socket = null;
    DatagramPacket packet = null;

    /**
     * 构造方法
     *
     * @param port 我的端口
     */
    public TalkReceive(Integer port, String msgFrom) {
        this.port = port;
        this.msgFrom = msgFrom;
        try {
            socket = new DatagramSocket(port);
        } catch (SocketException e) {
            e.printStackTrace();
        }
    }

    @SneakyThrows
    @Override
    public void run() {
        // 创建连接
        while (true) {
            byte[] container = new byte[1024];
            packet = new DatagramPacket(container, 0, container.length);
            // 接收数据包、阻塞式接收
            socket.receive(packet);

            byte[] data = packet.getData();
            String receiveData = new String(data, 0, data.length);
            System.out.println(msgFrom + ":" + receiveData);
            // 当对方发送bye，就停止
            if (receiveData.contains("bye")) {
                break;
            }
        }
        if (socket != null) {
            socket.close();
        }
    }
}
~~~

* 开启学生线程

~~~java
/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 15:14
 * ClassName:TalkShutdown
 * 类描述： 学生线程开启
 */
public class TalkStudent {
    public static void main(String[] args) throws Exception {
        // 开启两个线程
        new Thread(new TalkSend(7777, "localhost", 9999)).start();
        new Thread(new TalkReceive(8888, "老师")).start();
    }
}
~~~

* 老师线程

~~~java
/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 15:19
 * ClassName:TalkTeacher
 * 类描述： 学生线程
 */
public class TalkTeacher {
    public static void main(String[] args) throws Exception {
        new Thread(new TalkSend(5555, "localhost", 8888)).start();
        new Thread(new TalkReceive(9999, "学生")).start();
    }
}
~~~

### URL

* 常用方法

~~~java
import java.net.URL;

/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 16:09
 * ClassName:UrlDemo
 * 类描述：URL类
 */
public class UrlDemo {
    public static void main(String[] args) throws Exception {
        URL url = new URL("http://localhost:8080/manager/index.jsp");
        System.out.println("url.getPath() = " + url.getPath());
        System.out.println("url.getFile() = " + url.getFile());
        System.out.println("url.getHost() = " + url.getHost());
        System.out.println("url.getPort() = " + url.getPort());
        System.out.println("url.getProtocol() = " + url.getProtocol());
        System.out.println("url.getContent() = " + url.getContent());
        System.out.println("url.getUserInfo() = " + url.getUserInfo());
    }
}
~~~

* 下载网络上的资源

~~~java
import javax.net.ssl.HttpsURLConnection;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

/**
 * Software：IntelliJ IDEA 2020.3.2
 * Author: MoBaiJun
 * Date: 2021/4/25 16:27
 * ClassName:UrlDown
 * 类描述： URL下载网络上的资源
 */
public class UrlDown {
    public static void main(String[] args) throws IOException {
        // 1.下载地址
        URL url = new URL("https://cdn.jsdelivr.net/gh/mobaijun/blog_css_js/image/avatar.jpg");
        // 2.连接到这个资源https、HttpsURLConnection/http
        HttpsURLConnection urlConnection = (HttpsURLConnection) url.openConnection();
        InputStream is = urlConnection.getInputStream();
        FileOutputStream fop = new FileOutputStream("avatar.jpg");
        byte[] buffer = new byte[1024];
        int length;
        while ((length = is.read(buffer)) != -1) {
            // 写数据
            fop.write(buffer, 0, length);
        }
        if (fop != null) {
            fop.close();
        } else if (is != null) {
            is.close();
        }
        // 关闭连接
        urlConnection.disconnect();
    }
}
~~~

