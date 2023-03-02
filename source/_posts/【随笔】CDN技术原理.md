---
title: 【随笔】CDN技术原理
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - CDN
categories:
  - 网络
abbrlink: 4065328982
date: 2020-11-30 16:52:19
img:
coverImg:
password:
summary:
---

## CDN的由来

> CDN的全称是Content Delivery Network,即内容分发网络。使用户可就近取得所需内容，解决Internet网络拥挤的状况，提高用户访问网站的响应速度。

![](https://tencent.cos.mobaijun.com/article_with_pictures/20200612153546.png)

- N0.1 最小规模阶段：1台服务器，面向所有用户
- N0.2 规模扩大阶段：2台服务器，面向不同地区的用户
- NO.n 规模再次扩大阶段：n+台服务器，面向不同地区的用户

### 用户能够就近访问服务器

![](https://tencent.cos.mobaijun.com/article_with_pictures/20200612153629.png)

- 提高用户的访问速度
- 减轻服务器的压力
- 提升网站的稳定性和安全性

## CDN的分类

### 网页加速

![](https://tencent.cos.mobaijun.com/article_with_pictures/20200612153819.png)

### 流媒体加速

![](https://tencent.cos.mobaijun.com/article_with_pictures/20200612153846.png)

### 大文件加速

![大文件加速](https://tencent.cos.mobaijun.com/article_with_pictures/20200612153915.png)

### 应用协议加速

![应用协议加速](https://tencent.cos.mobaijun.com/article_with_pictures/20200612153958.png)

##  路由转发技术

![路由转发技术](https://tencent.cos.mobaijun.com/article_with_pictures/20200612140508.png)

> * 当用户访问`http://www.test.com/1.html`这个域名时
> * 会首先发送请求到本地DNS服务器,对`http://www.test.com/1.html`这个域名进行解析
> * 然后本地DNS向智能DNS发送请求,进行递归查询
> * 智能DNS会返回一个最佳接入节点
> * 用户就会访问这个最佳接入节点

### 负载均衡

![负载均衡](https://tencent.cos.mobaijun.com/article_with_pictures/20200612141123.png)

> * 路由转发的技术也是在负载均衡的基础上发展来的,也可以解释为路由转发是负载均衡的其中一种

### 什么是负载均衡?

> * 负载均衡是在现有的网络上提供了一种廉价有效透明的方法,可以扩展网络设备和服务器的带宽,增加吞吐量,加强网络数据处理能力,提高网络的灵活性和可用性
>
>   >`通俗的说就是把原来的单台服务器完成的工作交给多台服务器完成,以此来减轻单个服务器的压力,提高服务器数据处理能力的效果`

### 负载均衡分类

#### 本地负载均衡

![本地负载均衡](https://tencent.cos.mobaijun.com/article_with_pictures/20200612142022.png)

> * 本地负载均衡是指对本地的服务器进行负载均衡
> * 这些服务器通常都在一个机房内,没有地理位置的差异
> * 上图中通常有一个对外服务的智能交换设备
> * 这个设备相当于CDN里面的智能DNS,它会对用户的请求进行转发,使得用户的请求到达启动的某一个节点,从而达到最优效果

###### 主动探测

![主动探测](https://tencent.cos.mobaijun.com/article_with_pictures/20200612142713.png)

> * 智能交换设备通过`ping www.mobaijun.com`方法进行探测
> * 判断目标服务器是否健康

###### 协议交互

![协议交互](https://tencent.cos.mobaijun.com/article_with_pictures/20200612142710.png)

> * 这个协议目前是没有固定的标准和格式,一般都是由各大厂商自行规定
>
>   **协议内容:**
>
>   * 主机名称
>   * CPU运行状态
>   * 内存运行状态
>   * 网络运行状态
>   * 耗电状态等一系列

**小结:**

> * 主动探测:
>   * 主动探测获取的信息比较简单粗暴
> * 协议交互
>   * 协议交互获取的信息更加具体全面

#### 全局负载均衡

![全局负载均衡](https://tencent.cos.mobaijun.com/article_with_pictures/20200612143241.png)

> * 全局负载均衡和本地负载均衡结构基本一样,但是由于其地理位置差异巨大,有时几十公里,有时几百公里,因此在实现的技术方面也有很大差异,并且也有自己不同的优缺点
> * **全局负载均衡实现方式**
>   * 方式一:根据IP地址库投票匹配
>
> ![IP地址库投票匹配](https://tencent.cos.mobaijun.com/article_with_pictures/20200612143750.png)
>
> * * 方式二:CDN主动探测目标最近距离
>
> ![CDN主动探测目标最近距离](https://tencent.cos.mobaijun.com/article_with_pictures/20200612144011.png)
>
> > 用户发送一个请求,智能DNS会向所有的节点发送一个探测指令,节点收到探测指令以后会主动判断自己和目标之间的距离,然后将探测的结果反馈给智能DNS,由智能DNS进行判断,最后返回综合评分最高的节点地址

**小结:**

> * 全局负载均衡
>   * 优点
>     * 安全性和稳定性更高
>     * 可以有效避免单个机房电力或者网络故障导致的服务中断
>     * 可以避免ISP专线故障引起的单点失效
>     * 可以解决网络拥堵
>     * 可以提供就近访问,提高用户体验
> * 本地负载均衡
>   * 优点
>     * 建设成本低,管理成本低
>     * 可以解决热备的问题

### **小结:**

> `CDN就是负载均衡中的全局负载均衡`

## 内容分发技术

![内容分发技术](https://tencent.cos.mobaijun.com/article_with_pictures/20200612140459.png)

> * 当源站需要分发内容的时候,可以将分发内容分发到CDN中间源
> * 再由CDN中间源转发内容到各个CDN节点
> * 如果CDN节点需要请求某个URL内容请求时,会将请求先发送到CDN中间源
> * 再由CDN中间源主动向源站发送请求内容,最后将获取到的数据存储到中间源和内容节点上,从而达到节点加速的效果

#### 主动推送(push)

![主动推送](https://tencent.cos.mobaijun.com/article_with_pictures/20200612144939.png)

> * 主动推送就是服务器源站将内容分发到内容节点
> * 用户访问时就可以直接访问到节点上的副本

#### 被动推送()

![被动推送](https://tencent.cos.mobaijun.com/article_with_pictures/20200612145052.png)

> 被动访问就是在用户访问时,向镜像服务器发送请求,如果镜像服务器上有内容,就直接返回给用户,如果没有,就到服务器源站获取后在返回给用户

#### CDN边缘节点上的内容是实时更新的嘛?

![CDN边缘节点上的内容是实时更新的嘛](https://tencent.cos.mobaijun.com/article_with_pictures/20200612145312.png)

#### 一个源站给那么多节点推送数据压力会不会很大?

![推送数据鸭梨大](https://tencent.cos.mobaijun.com/article_with_pictures/20200612145453.png)

![内容下发](https://tencent.cos.mobaijun.com/article_with_pictures/20200612145511.png)

![主动请求](https://tencent.cos.mobaijun.com/article_with_pictures/20200612145528.png)

#### 应该怎么做才能最大程度的加速网站内容?

![加速网站](https://tencent.cos.mobaijun.com/article_with_pictures/20200612145634.png)

#### CDN怎么处理文件的Cache-Control设置?

![文件缓存](https://tencent.cos.mobaijun.com/article_with_pictures/20200612145802.png)

#### CDN对跨域的处理?

##### 什么是跨域?

![跨域](https://tencent.cos.mobaijun.com/article_with_pictures/20200612145933.png)

##### 解决方案

![解决方案](https://tencent.cos.mobaijun.com/article_with_pictures/20200612150101.png)

## 内容存储技术

![内容存储技术](https://tencent.cos.mobaijun.com/article_with_pictures/20200612140949.png)

### 内容存储介质

> 目前市面上主流有两种

![内容存储介质](https://tencent.cos.mobaijun.com/article_with_pictures/20200612150239.png)

### 存储结构

> * 直连式存储: (DAS: Direct Attached Storage)
> * 存储区域网络: (SAN: Stirage Area Network)
> * 网络接入存储: (NAS: Network Attached Storage)
>
> > NAS是目前被CDN厂商使用最多的存储结构

### NAS(Network Attached Storage)(网络附属存储)

![网络附属存储](https://tencent.cos.mobaijun.com/article_with_pictures/20200612151005.png)

### NAS内部实现架构

![内部实现架构](https://tencent.cos.mobaijun.com/article_with_pictures/20200612151034.png)

### NAS外部实现架构

![外部实现架构](https://tencent.cos.mobaijun.com/article_with_pictures/20200612151137.png)

### NAS的优点

* 部署方便
* 管理简单
* 便于拓展
* 价格便宜

### 云存储

> 云存储是在云计算(Cloud Computing)概念上延伸和发展出来的一个新的概念,是一种新兴的网络存储技术,是指通过`集群应用`,`网络技术`或`分布式文件系统`等功能,将网络中大量各种不同类型的存储设备通过应用软件集合起来协同工作,共同对外提供数据存储和业务访问功能的系统.
>
> > 云存储和CDN是密不可分的,缺一不可

### CDN使用云存储的可行性

### 拓扑结构相似

![拓扑结构](https://tencent.cos.mobaijun.com/article_with_pictures/20200612151748.png)

### 管理成本低

![管理成本低](https://tencent.cos.mobaijun.com/article_with_pictures/20200612151859.png)

### 弹性化结构

![弹性化结构](https://tencent.cos.mobaijun.com/article_with_pictures/20200612151952.png)

### 性能更加好

> * 云计算运算能力更强
> * 并发操作提高传输速率(Data Transfer Rate)
> * 网络集群(Softeare Defined Network)提高IO和Qos

### 安全性更高

> * 数据多副本容错
> * 数据加密
> * 身份验证
> * 访问隔离
> * 分布式存储

## 内容管理技术

![内容管理技术](https://tencent.cos.mobaijun.com/article_with_pictures/20200612141040.png)

> 内容管理技术主要是软件层的应用

![管理系统](https://tencent.cos.mobaijun.com/article_with_pictures/20200612152817.png)

### 资源管理系统

- GSLB(全局负载均衡系统)负责资源的调度方案
- 资源管理系统负责资源的统筹和管理

### 安全管理系统

- 内容安全管理系统
- 防护安全管理系统

### 访问控制：

- referrer防盗链:根据HTTP/HTTPS Header中的referrer值进行访问控制
- token 防盗链:利用时间戳、私钥计算Token ,按指定格式拼接,进行访问鉴权
- IP黑白名单:根据请求源IP进行访问控制
- UA黑白名单:根据HTTP/HTTPS Header中的User- Agent值进行访问控制
- IP 访问限频:单节点单IP访问限频控制,有效抵御CC攻击
- HTTP Header配置:支持跨域访问配置

### HTTPS：

- 将已有证书.上传至全网CDN节点,实现用户> >节点>> 源站全访问安全传输
- 与亚洲诚信合作,提供免费证书申请,颁发后支持一键部署至CDN

### 配置管理系统

- 系统配置管理配置
- 域名配置管理系统
- 定制化配置管理系统

### 立体化监控系统

- 单机节点健康监控
- CDN平台多维度监控
- 联动测试运营系统

我的博客即将同步至腾讯云+社区，邀请大家一同入驻：https://cloud.tencent.com/developer/support-plan?invite_code=1jqg38atybkf4