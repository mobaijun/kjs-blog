---
title: 【Linux系列】CentOS-7下GitLab安装部署教程
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 4047318542
tags:
  - gitlab
categories:
  - Linux
date: 2021-11-14 01:27:22
img:
coverImg:
password:
summary:
---

## 一、前言

最近在学习 `Jenkins`，需要使用到 `gitlab`，所以记录下`gitlab`安装过程。

### 1、本文主要内容

- `GitLab `社区版部署
- `GitLab `配置禁用创建组权限
- `GitLab`配置邮件(`SMTP`)
- `GitLab `常用命令说明

### 2、GitLab介绍

`GitLab`一个开源的`git`仓库管理平台，方便团队协作开发、管理。在`GitLab`上可以实现完整的`CI`（持续集成）、`CD`（持续发布）流程。而且还提供了免费使用的`Plan`，以及免费的可以独立部署的社区版本 ，[地址](https://gitlab.com/gitlab-org/gitlab-ce )。

* 官网：[传送门](https://about.gitlab.com/)
* 镜像地址：[传送门](https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/)

### 3、本篇环境信息

- 服务器信息
  * 服务器名称： `GitLab`
  * 操作系统：`Centos 7`
  * 硬件配置： `4C8G`
  * IP：`192.168.0.10  `
  * 说明：部署`GitLab`社区版

- 软件
  * 工具/环境：`GitLab  `
  * 版本： 社区版 `14.4.2`

## 二、准备工作

### 1、配置清华大学镜像仓库

* 新建仓库配置文件

使用 `vim /etc/yum.repos.d/gitlab-ce.repo` 命令，输入以下内容

~~~yaml
[gitlab-ce]
name=Gitlab CE Repository
baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el$releasever/
gpgcheck=0
enabled=1
~~~

* 更新 `yum `缓存

~~~bash
# 重新yum编译仓库缓存
$ sudo yum makecache

# 建立元数据缓存
$ sudo yum install gitlab-ce
~~~

### 2、安装基础依赖

```bash
# 安装基础依赖
$ sudo yum -y install policycoreutils openssh-server openssh-clients postfix

# 启动ssh服务&设置为开机启动
$ sudo systemctl enable sshd & sudo systemctl start sshd
```

### 3、安装Postfix

`Postfix` 是一个邮件服务器，`GitLab` 发送邮件需要用到

```bash
# 安装 postfix
$ sudo yum install -y postfix

# 启动 postfix 并设置为开机启动
$ sudo systemctl enable postfix & sudo systemctl start postfix
```

### 4、开放`ssh`以及`http`服务（80端口）

```bash
# 开放ssh、http服务
$ sudo firewall-cmd --add-service=ssh --permanent & sudo firewall-cmd --add-service=http --permanent

# 重载防火墙规则
$ sudo firewall-cmd --reload
```

## 三、部署过程

本次我们部署的是社区版: `gitlab-ce` ，如果要部署商业版可以把关键字替换为：`gitlab-ee`

### 1、`Yum`安装`GitLab`

- 下载指定版本的 `gitlab `，可以在清华大学镜像站去选择：[地址](https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/)

```bash
$ wget http://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-14.4.2-ce.0.el7.x86_64.rpm
```

- 安装GitLab社区版

```bash
$ rpm -i gitlab-ce-14.4.2-ce.0.el7.x86_64.rpm
```

安装成功后会看到`gitlab-ce`打印了以下图形

![image-20211114020918874](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/image-20211114020918874.png)

### 2、配置 `GitLab `站点 `Url `和端口号

`GitLab`默认的配置文件路径是 `/etc/gitlab/gitlab.rb`

默认的站点`Url`配置项是：`external_url 'http://gitlab.example.com`

这里我将`GitLab`站点Url修改为 `http://127.0.0.1:8000` 也可以用域名代替 `IP`，这里根据自己需求来即可

```bash
# 修改配置文件
$ sudo vi /etc/gitlab/gitlab.rb

# 配置首页地址（大约在第15行）
$ external_url 'http://127.0.0.1:8000'

# 开放端口号
$ firewall-cmd --zone=public --add-port=8000/tcp --permanent
# 重启防火墙
$ systemctl restart firewalld
# 查看是否成功
$ firewall-cmd --zone=public --query-port=8000/tcp
```

### 3、启动并访问`GitLab`

- 启动`GitLab`

```bash
# 重新配置并启动
$ sudo gitlab-ctl reconfigure

# 完成后将会看到如下输出
Running handlers:
Running handlers complete
Chef Infra Client finished, 10/776 resources updated in 45 seconds
gitlab Reconfigured!
# 启动 gitlab
$ gitlab-ctl restart
# 查看启动详细信息
$ systemctl status gitlab-runsvdir.service
```

- 访问 `GitLab`

`将设置的域名DNS解析到服务器IP，或者修改本地host将域名指向服务器IP。`访问：[http://192.168.0.10:8000/users/sign_in](http://192.168.0.10:8000/users/sign_in)

![image-20211114023705951](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/image-20211114023705951.png)

进入首页，随后进行登录，管理员账号默认用户名是`root`。

初始化密码可以在 `GitLab `初始化文件查看

~~~bash
$ cat /etc/gitlab/initial_root_password
# 复制Password后面的内容即可
Password: E+EA7WZie9zJbMQ2gwISeVN/We9DBZmYsMFpbjzhYcc=
~~~

登录进来进入首页：

![image-20211114024044448](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/image-20211114024044448.png)

## 四、GitLab常用配置

### 1、邮件配置

配置邮箱可以让`GitLab`在发生相应事件的时候进行邮件通知

比如：找回密码、添加邮箱等

```bash
# 修改配置文件
$ sudo vi /etc/gitlab/gitlab.rb

# 邮件配置
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = 'smtp.163.com'
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = 'yourmail@163.com'
gitlab_rails['smtp_password'] = 'yourpasswd'
gitlab_rails['smtp_domain'] = 'smtp.163.com'
gitlab_rails['smtp_authentication'] = 'login'
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
gitlab_rails['gitlab_email_enabled'] = true
gitlab_rails['gitlab_email_from'] = 'yourmail@163.com'
gitlab_rails['gitlab_email_display_name'] = 'Gitlab'

# 保存后，重新配置并启动GitLab
$ sudo gitlab-ctl reconfigure
```

### 2、禁用创建组权限

`GitLab`默认所有的注册用户都可以创建组。但对于团队来说，通常只会给`Leader`相关权限。

虽然可以在用户管理界面取消权限，但毕竟不方便。我们可以通过配置`GitLab`默认禁用创建组权限。

```bash
# 修改配置文件
$ sudo vi /etc/gitlab/gitlab.rb

# 开启gitlab_rails['gitlab_default_can_create_group'] 选项，并将值设置为false
### GitLab user privileges
$ gitlab_rails['gitlab_default_can_create_group'] = false

# 保存后，重新配置并启动GitLab
$ sudo gitlab-ctl reconfigure
```

### 3、gitlab-ctl常用命令介绍

| 命令            | 说明                                                     |
| --------------- | -------------------------------------------------------- |
| check-config    | 检查在gitlab中是否有任何配置。在指定版本中删除的rb       |
| deploy-page     | 安装部署页面                                             |
| diff-config     | 将用户配置与包可用配置进行比较                           |
| remove-accounts | 删除所有用户和组                                         |
| upgrade         | 升级                                                     |
| service-list    | 查看所有服务                                             |
| once            | 如果GitLab服务停止了就启动服务，如果已启动就不做任何操作 |
| restart         | 重启GitLab服务                                           |
| start           | 如果GitLab服务停止了就启动服务，如果已启动就重启服务     |
| stop            | 停止GitLab服务                                           |
| status          | 查看GitLab服务状态                                       |
| reconfigure     | reconfigure重新配置GitLab并启动                          |

## 五、备注

- 本篇参考
- [CentOS 7 下 GitLab安装部署教程 - Ken的杂谈](https://ken.io/note/centos7-gitlab-install-tutorial)
- [Download and install GitLab | GitLab](https://about.gitlab.com/install/#centos-7)
- [gitlab-ce | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/gitlab-ce/)

