---
title: '【随笔】关于GitHub Actions Error: Process completed with exit code 128. 的解决方案'
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1959112193
tags:

- Github Actions
  categories:
- 随笔
  date: 2023-03-04 10:23:59
  img:
  coverImg:
  password:
  summary:

---

> Error: Process completed with exit code 128.

## 出现的场景

如果你正在运行 GitHub Actions scraper,可能会收到如下错误信息

![](https://tencent.cos.mobaijun.com//xxbj_img/image-20230304102934958.png)

~~~bash
Run git config --local user.email "mobaijun8@163.com"
Already up to date.
[main 339a9f6] :sparkles: Add generated repo.md file
 1 file changed, 32 insertions(+)
 create mode 100644 Repo.md
remote: Permission to mobaijun/github-star-list.git denied to github-actions[bot].
fatal: unable to access 'https://github.com/mobaijun/github-star-list.git/': The requested URL returned error: 403
Error: Process completed with exit code 128.
~~~

就算使用之前同样的配置，现在也未必行得通！

> 出现这种情况是因为 GitHub Actions 试图将修改的操作提交到仓库，但是被拒绝！！！！

## 解决方案！

为你的工作流配置文件添加一个启用写入的权限配置，示例如下：

~~~yaml
permissions:
  contents: write
~~~

完整的工作流文件如下。

```yaml
name: Java Action
on:
  schedule:
    - cron: '0 0 * * *'
  push:
    branches:
      - main

# 解决方案
permissions:
  contents: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up JDK 17
        uses: actions/setup-java@v1
        with:
          java-version: 17
          distribution: 'adopt'
      - name: Build with Maven
        run: mvn -B package --file pom.xml
      - name: Run Java Application
        run: java -jar target/github-star-list-jar-with-dependencies.jar
      - name: Commit generated repo.md file
        run: |
          git config --local user.email "mobaijun8@163.com"
          git config --local user.name "mobaijun"
          git pull
          git add .
          git commit -m ":sparkles: Add generated repo.md file"
          git remote set-url origin https://github.com/mobaijun/github-star-list.git
          git push origin main
      - name: Push changes
        uses: ad-m/github-push-action@master
        with:
          github_token: ${{ secrets.GIT_TOKEN }}
          branch: main
```

修改完毕后重新执行工作流，正常情况下就成功了！
