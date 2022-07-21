---
title: 【Java基础】Java8新特性学习笔记
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2185063439
tags:
  - Stream
  - Lambda
categories:
  - 后端
date: 2022-02-15 11:40:58
img:
coverImg:
password:
summary:
---

## Java函数式编程

### 学习目的

* 为了看懂技术大牛写的代码
* 大数据量下处理集合效率高
* 代码可读性提高
* 减少嵌套

~~~java
public static void main(String[] args) {
    /**
     * 查询未成年作家评分在70分以上的书籍，由于流的影响所以作家和书籍可能会重复出现，所以要去重
     */
    List<Book> bookList = new ArrayList<>();
    List<Author> authorList = new ArrayList<>();
    Set<Book> uniqueBookValues = new HashSet<>();
    Set<Author> uniqueAuthorValues = new HashSet<>();
    for (Author author : authorList) {
        // 这里如果重复就不会添加成功
        if (uniqueAuthorValues.add(author)) {
            if (author.getAge() < 18) {
                List<Book> books = author.getBookList();
                for (Book book : books) {
                    if (book.getScore() > 70D) {
                        // 如果之前有这本书就不会再次添加
                        if (uniqueBookValues.add(book)) {
                            bookList.add(book);
                        }
                    }
                }
            }
        }
    }
    bookList.forEach(System.out::println);
    // 函数式写法
    List<Book> collect = authorList.stream()
            .distinct()
            .filter(author -> author.getAge() < 18)
            .map(author -> author.getBookList())
            .flatMap(Collection::stream)
            .filter(book -> book.getScore() > 70)
            .distinct()
            .collect(Collectors.toList());
    collect.forEach(System.out::println);
}
~~~

#### 函数式编程思想

概念：

### 概念

1. 面向对象思想主要是关注对象能完成什么事情，函数式编程思想就像函数式，主要是针对数据操作。

1. 代码简洁容易理解，方便于并发编程，不需要过分关注线程安全问题。
