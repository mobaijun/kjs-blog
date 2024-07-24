---
title: 【随笔】浏览器中的 preview 和 response 的值不一致
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 461257689
tags:
  - 随笔
categories:
  - 随笔
date: 2024-07-24 17:39:36
img:
coverImg:
password:
summary:
---

## 前言

> 今天遇到一个问题，数据库数据无误，接口请求数据无误，但在浏览器发起请求后，接口数据在浏览器的 `preview` 和 `response` 中显示不一致。数据库中的数据类型是 `bigint`，实体类对应的数据类型是 `Long`。问题表现如下：

![c04eef552e0f26aaa286c15c90f3564](https://tencent.cos.mobaijun.com/xxbj_img/202407241747120.png)

## 原因

`JavaScript` 的 `Number` 类型不能完全表示 `Java` 的 `Long` 类型数字。当 `Long` 类型的长度超过 `17` 位时，会出现精度丢失的问题。浏览器在解析超过 `17` 位的数字时，超出的部分会被转换为 0，导致显示不一致。具体原因如下：

- **JavaScript Number 精度限制**：`JavaScript` 中的 `Number` 类型是双精度浮点数，可以安全地表示的整数范围是 `-9007199254740991` 到 `9007199254740991`（即 `15` 位数字）。当数字长度超过 `15` 位时，会发生精度丢失，超过 `17` 位的部分则会直接变成 `0`。
- **精度丢失示例**：例如，`Java` 的 `Long` 类型值为 `1816022064764096513`，但在 `JavaScript` 中，超过 `17` 位的部分可能会变成 `1816022064764096000`。

## 解决方案

为了避免精度丢失，可以在后台将 `Long` 型数据转换为 `String` 类型。这确保了在传输过程中数字不会丢失精度，并且前端可以正确地显示这些数据。

### 修改实体

~~~java
@Getter
@Setter
@ToString
@Schema(title = "[字典类型表参数对象]")
public class SysDictTypeDTO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Schema(title = "字典主键")
    private String dictId; // 将 Long 修改为 String
}
~~~

通过这种方式，可以确保 `Long` 类型的数据在传输过程中不会丢失精度，前端可以正确显示大整数值。
