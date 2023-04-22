---
title: 【Git系列】Git 仓库体积过大，缩减记录
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2432586935
tags:
  - Git体积缩减
categories:
  - 工具
date: 2021-10-11 10:05:48
img:
coverImg:
password:
summary:
---

## 一、前言

> 写这篇博客主要是因为存储博客图片和一些文件占用GitHub仓库过大，导致仓库体积变大，所以找了一些方案，记录一下

![原仓库大小](https://tencent.cos.mobaijun.com/img/blog/【Git系列】Git 仓库体积过大，缩减记录/0.png)

上图可以看到原仓库已经很大了，所以必须要清除一些仓库中没用的大文件了，每次下载仓库那个时间简直是太长了，github拉取时间太久，受不了了。

## 二、具体操作

首先，git仓库中删除历史大文件分为以下步骤：

> 查找大文件id→根据id查找大文件所在的路径→删除文件→删除文件的历史记录→提交→清除本地缓存
>
> （我按照我的理解总结的，不知道是不是对的，如果有错误的话，麻烦大家在下面评论区纠正一下，谢谢！）

具体的命令如下：【ps：后面有更简单的代码，如果想要直接用的话可以直接看本文后面】

### 1. 显示10个最大的文件id列表

~~~bash
$ git verify-pack -v .git/objects/pack/pack-*.idx | sort -k 3 -g | tail -20
~~~

结果类似下图（`从左往右依次是文件ID、文件类型、文件字节数、size-in-packfil、offset-in-packfile`），列表越往下，文件越大

![文件列表](https://tencent.cos.mobaijun.com/img/blog/【Git系列】Git 仓库体积过大，缩减记录/1.png)

> 其实，往专业点来说，文件ID其实是SHA1，不过不知道这是啥也没关系。

### 2. 根据文件id查询文件路径

```bash
$ git rev-list --objects --all | grep 【大文件id】
```

> 【大文件id】填上面步骤1中的id，例如上图最后一个id为：273c3734ffbe8df3092e8409f41f895b190612ee

则命令为：

~~~bash
$ git rev-list --objects --all | grep 273c3734ffbe8df3092e8409f41f895b190612ee
~~~

* 结果如下：

![执行结果](https://tencent.cos.mobaijun.com/img/blog/【Git系列】Git 仓库体积过大，缩减记录/2.png)

复制`image/blog_images090816290568_01.png`文件地址留下来备用

### 3. 移除文件

```bash
$ git log --pretty=oneline --branches -- 【your_file】
```

> 【your_file】那里填上一步得到的路径，类似于下面这样：

~~~bash
$ git log --pretty=oneline --branches -- image/blog_images090816290568_01.png
~~~

![执行结果](https://tencent.cos.mobaijun.com/img/blog/【Git系列】Git 仓库体积过大，缩减记录/3.png)

上图显示了提交记录，然后继续下一步。

### 4. 删除文件的历史记录

```bash
$ git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch --ignore-unmatch 【your_file】' --prune-empty --tag-name-filter cat -- --all
```

> 【your_file】那里还是填第2步得到的路径，类似于下面这样：

~~~bash
$ git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch --ignore-unmatch image/blog_images090816290568_01.png' --prune-empty --tag-name-filter cat -- --all
~~~

接下来就要稍等一下了，如下图，提交的记录越多，需要等待的时间越长。

![](https://tencent.cos.mobaijun.com/img/blog/【Git系列】Git 仓库体积过大，缩减记录/4.png)

#### 3、4步需要注意的地方

> 【注意】如果文件名有空格，则需要用双引号引起来，例如：

~~~bash
# 第三步
$ git log --pretty=oneline --branches -- "a a/b b/c c/img.png"
# 第四步
$ git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch --ignore-unmatch "a a/b b/c c/img.png"' --prune-empty --tag-name-filter cat -- --all
~~~

### 5. 提交

```bash
$ git push --force --all
```

> 【注意】这一步需要输入GitHub的账号和密码

另外，如果出现提示`remote: GitLab: You are not allowed to force push code to a protected branch on this project.`

> 需要在`GitHub`里面取消分支`protected`.

### 6. 清除本地缓存

```bash
$ rm -Rf .git/refs/original
$ rm -Rf .git/logs/
$ git gc
$ git prune
```

* 做完这一步查看仓库大小

![清理后的仓库体积](https://tencent.cos.mobaijun.com/img/blog/【Git系列】Git 仓库体积过大，缩减记录/5.png)

## Gitee清理仓库体积

Gitee的官方文档[仓库体积过大，如何减小？](https://gitee.com/help/articles/4232)

首先，查看存储库中的大文件：

### 1. 查看存储库中的大文件

```bash
$ git rev-list --objects --all | grep -E `git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -10 | awk '{print$1}' | sed ':a;N;$!ba;s/\n/|/g'`
# 或
$ git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -15 | awk '{print$1}')"
```

### 2. 改写历史，去除大文件

注意：命令中的 ` path/to/large/files` 是大文件所在的路径，千万不要弄错！

```bash
$ git filter-branch --tree-filter 'rm -f path/to/large/files' --tag-name-filter cat -- --all
$ git push origin --tags --force
$ git push origin --all --force
```

> 如果在 git filter-branch 操作过程中遇到如下提示，需要在 git filter-branch 后面加上参数 -f

~~~bash
Cannot create a new backup.
A previous backup already exists in refs/original/
Force overwriting the backup with -f
~~~

并告知所有组员，push 代码前需要 pull rebase，而不是 merge，否则会从该组员的本地仓库再次引入到远程库中，导致仓库在此被 Gitee 系统屏蔽。

### 3. 执行存储库GC

按照下图操作即可。

![进入gc](https://tencent.cos.mobaijun.com/img/blog/【Git系列】Git 仓库体积过大，缩减记录/6.png)

![gc确认](https://tencent.cos.mobaijun.com/img/blog/【Git系列】Git 仓库体积过大，缩减记录/7.png)

![正在清理中](https://tencent.cos.mobaijun.com/img/blog/【Git系列】Git 仓库体积过大，缩减记录/8.png)

然后，去仓库数据统计刷新一下仓库大小即可，大功告成！

![查看大小](https://tencent.cos.mobaijun.com/img/blog/【Git系列】Git 仓库体积过大，缩减记录/9.png)

