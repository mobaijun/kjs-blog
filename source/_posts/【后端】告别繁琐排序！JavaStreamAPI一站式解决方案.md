---
title: 【后端】告别繁琐排序！Java Stream API一站式解决方案
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2973796368
date: 2025-02-27 10:13:41
img:
coverImg:
password:
summary:
tags:
  - Stream
categories:
  - 后端
---

> 随着 Java 的持续迭代，Stream API的排序能力越发成熟。本文将带你用 Stream
> 流操作征服各种数据结构的排序需求，包含数组、集合、Map、字符串和自定义对象，解锁函数式编程的优雅姿势。

## 一、数组排序（基本类型 vs 对象类型）

### 1.1 整型数组排序

```java
int[] numbers = {5, 2, 8, 1, 9};

// 自然排序（升序）
int[] ascOrder = Arrays.stream(numbers)
                      .sorted()
                      .toArray(); // [1, 2, 5, 8, 9]

// 倒序需要装箱处理
int[] descOrder = Arrays.stream(numbers)
                       .boxed()
                       .sorted(Comparator.reverseOrder())
                       .mapToInt(Integer::intValue)
                       .toArray(); // [9, 8, 5, 2, 1]
```

### 1.2 字符串数组排序

```java
String[] languages = {"Java", "Python", "C++", "Kotlin"};

// 按字母顺序
String[] alphabetical = Arrays.stream(languages)
                             .sorted()
                             .toArray(String[]::new); 

// 按字符串长度排序
String[] byLength = Arrays.stream(languages)
                         .sorted(Comparator.comparingInt(String::length))
                         .toArray(String[]::new);
```

## 二、集合排序（List/Set）

### 2.1 List自然排序

```java
List<Integer> nums = new ArrayList<>(List.of(3, 1, 4, 1, 5));

List<Integer> sortedList = nums.stream()
                              .sorted()
                              .collect(Collectors.toList());
```

### 2.2 自定义对象排序

```java
record Product(String name, double price) {}

List<Product> products = List.of(
    new Product("Mouse", 25.99),
    new Product("Keyboard", 45.50)
);

// 按价格排序
List<Product> byPrice = products.stream()
                               .sorted(Comparator.comparing(Product::price))
                               .toList();

// 多条件排序（价格降序，名称升序）
List<Product> complexSort = products.stream()
                                   .sorted(Comparator
                                       .comparing(Product::price).reversed()
                                       .thenComparing(Product::name))
                                   .toList();
```

## 三、Map排序黑科技

### 3.1 按键排序

```java
Map<String, Integer> scores = Map.of(
    "Bob", 88,
    "Alice", 95,
    "Charlie", 82
);

Map<String, Integer> sortedByKey = scores.entrySet().stream()
        .sorted(Map.Entry.comparingByKey())
        .collect(Collectors.toMap(
            Map.Entry::getKey,
            Map.Entry::getValue,
            (oldVal, newVal) -> oldVal,
            LinkedHashMap::new));
```

### 3.2 按值排序（倒序）

```java
Map<String, Integer> sortedByValue = scores.entrySet().stream()
        .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
        .collect(Collectors.toMap(
            Map.Entry::getKey,
            Map.Entry::getValue,
            (v1, v2) -> v1,
            LinkedHashMap::new));
```

## 四、字符串字符排序

### 4.1 字符拆分排序

```java
String text = "java21";

// 按ASCII排序
String asciiSorted = text.chars()
                        .sorted()
                        .collect(StringBuilder::new,
                               StringBuilder::appendCodePoint,
                               StringBuilder::append)
                        .toString(); // "12aajv"

// 字母忽略大小写排序
String caseInsensitive = Arrays.stream(text.split(""))
                             .sorted(String.CASE_INSENSITIVE_ORDER)
                             .collect(Collectors.joining());
```

## 五、并行流排序技巧

```java
List<Integer> bigData = // 百万级数据...

// 并行排序（注意线程安全）
List<Integer> parallelSorted = bigData.parallelStream()
                                     .sorted()
                                     .toList();
```

> **🚨 注意事项**：
> 1. 使用`parallelStream()`前评估数据量
> 2. 对象需要实现Comparable接口
> 3. 排序后收集到LinkedHashMap保持顺序
> 4. 注意装箱/拆箱的性能消耗

## 六、性能优化建议

1. **预排序过滤**：先filter再sorted减少处理量
2. **避免重复排序**：缓存排序结果多次使用
3. **选择合适的比较器**：方法引用比lambda效率更高
4. **警惕空值**：使用Comparator.nullsFirst/nullsLast

---

**📚 延伸思考**：  
当排序遇到大数据量时，可以考虑：

- 使用数据库索引预排序
- 采用分治策略（MapReduce思想）
- 对无法装入内存的数据使用外部排序

掌握这些Stream排序技巧后，你会发现处理各种排序需求就像搭积木一样简单有趣！🎯
