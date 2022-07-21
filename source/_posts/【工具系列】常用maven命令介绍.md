---
title: 【工具系列】常用maven命令介绍
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3490035493
tags:
  - Maven
categories:
  - 工具
date: 2022-01-05 15:03:58
img:
coverImg:
password:
summary:
---

## 前言：

一般情况下是用不到这些命令的，因为 `idea` 集成 `maven` 后，可以直接在 `idea` 进行 `maven` 的操作，只是最近不是换了 `mvnd` 了嘛，所以需要使用到 `maven` 命令，发现很多都忘记了，在这里重新记录下。

## 语法格式

~~~bash
# maven 命令格式
$ mvn [plugin-name]:[gloal-name]
~~~

> 可接受的常用参数有以下内容

~~~bash
-D 指定参数，如 -Dmaven.test.skip=true 跳过单元测试；

-P 指定 Profile 配置，可以用于区分环境；

-e 显示maven运行出错的信息；

-o 离线执行命令,即不去远程仓库更新包；

-X 显示maven允许的debug信息；

-U 强制去远程更新snapshot的插件或依赖，默认每天只更新一次。
~~~

## 更多参数

~~~bash
$ mvn -help
usage: mvn [options] [<goal(s)>] [<phase(s)>]

Options:
 -am,--also-make                        If project list is specified, also
                                        build projects required by the
                                        list
 -amd,--also-make-dependents            If project list is specified, also
                                        build projects that depend on
                                        projects on the list
 -B,--batch-mode                        Run in non-interactive (batch)
                                        mode (disables output color)
 -b,--builder <arg>                     The id of the build strategy to
                                        use
 -C,--strict-checksums                  Fail the build if checksums don't
                                        match
 -c,--lax-checksums                     Warn if checksums don't match
    --color <arg>                       Defines the color mode of the
                                        output. Supported are 'auto',
                                        'always', 'never'.
 -cpu,--check-plugin-updates            Ineffective, only kept for
                                        backward compatibility
 -D,--define <arg>                      Define a system property
 -e,--errors                            Produce execution error messages
 -emp,--encrypt-master-password <arg>   Encrypt master security password
 -ep,--encrypt-password <arg>           Encrypt server password
 -f,--file <arg>                        Force the use of an alternate POM
                                        file (or directory with pom.xml)
 -fae,--fail-at-end                     Only fail the build afterwards;
                                        allow all non-impacted builds to
                                        continue
 -ff,--fail-fast                        Stop at first failure in
                                        reactorized builds
 -fn,--fail-never                       NEVER fail the build, regardless
                                        of project result
 -gs,--global-settings <arg>            Alternate path for the global
                                        settings file
 -gt,--global-toolchains <arg>          Alternate path for the global
                                        toolchains file
 -h,--help                              Display help information
 -l,--log-file <arg>                    Log file where all build output
                                        will go (disables output color)
 -llr,--legacy-local-repository         Use Maven 2 Legacy Local
                                        Repository behaviour, ie no use of
                                        _remote.repositories. Can also be
                                        activated by using
                                        -Dmaven.legacyLocalRepo=true
 -N,--non-recursive                     Do not recurse into sub-projects
 -npr,--no-plugin-registry              Ineffective, only kept for
                                        backward compatibility
 -npu,--no-plugin-updates               Ineffective, only kept for
                                        backward compatibility
 -nsu,--no-snapshot-updates             Suppress SNAPSHOT updates
 -ntp,--no-transfer-progress            Do not display transfer progress
                                        when downloading or uploading
 -o,--offline                           Work offline
 -P,--activate-profiles <arg>           Comma-delimited list of profiles
                                        to activate
 -pl,--projects <arg>                   Comma-delimited list of specified
                                        reactor projects to build instead
                                        of all projects. A project can be
                                        specified by [groupId]:artifactId
                                        or by its relative path
 -q,--quiet                             Quiet output - only show errors
 -rf,--resume-from <arg>                Resume reactor from specified
                                        project
 -s,--settings <arg>                    Alternate path for the user
                                        settings file
 -t,--toolchains <arg>                  Alternate path for the user
                                        toolchains file
 -T,--threads <arg>                     Thread count, for instance 2.0C
                                        where C is core multiplied
 -U,--update-snapshots                  Forces a check for missing
                                        releases and updated snapshots on
                                        remote repositories
 -up,--update-plugins                   Ineffective, only kept for
                                        backward compatibility
 -v,--version                           Display version information
 -V,--show-version                      Display version information
                                        WITHOUT stopping build
 -X,--debug                             Produce execution debug output
~~~

## 常用命令

* 指定端口

~~~bash
-Dmaven.tomcat.port=9090
~~~

* 指定 `group`

~~~bash
-DgroupId=packageName
~~~

* 指定 artifact：

~~~bash
-DartifactId=projectName
~~~

* 创建web项目

~~~bash
-DarchetypeArtifactId=maven-archetype-webapp
~~~

* 忽略测试失败

~~~bash
-Dmaven.test.failure.ignore=true
~~~

* 创建 maven 项目

~~~bash
$ mvn archetype:create
~~~

* 反向生成 maven 项目的骨架

~~~bash
$ mvn archetype:generate
~~~

* 只打包不测试

~~~bash
$ mvn -Dtest package
~~~

* 显示详细错误信息

~~~bash
$ mvn -e
~~~

* 验证项目是否正确

~~~bash
$ mvn validate
~~~

* maven 打包

~~~bash
$ mvn package
~~~

* 只打jar包

~~~bash
$ mvn jar:jar
~~~

* 生成源码jar包

~~~bash
$ mvn source:jar
~~~

* 产生应用需要的任何额外的源代码

~~~bash
$ mvn generate-sources
~~~

* 编译源代码

~~~bash
$ mvn compile
~~~

* 编译测试代码

~~~bash
$ mvn test-compile
~~~

* 运行测试

~~~bash
$ mvn test
~~~

* 运行检查

~~~bash
$ mvn verify
~~~

* 清理maven项目

~~~bash
$ mvn clean
~~~

* 生成eclipse项目

~~~bash
$ mvn eclipse:eclipse
~~~

* 清理eclipse配置

~~~bash
$ mvn eclipse:clean
~~~

* 生成idea项目

~~~bash
$ mvn idea:idea
~~~

* 安装项目到本地仓库

~~~bash
$ mvn install
~~~

* 发布项目到远程仓库

~~~bash
$ mvn:deploy
~~~

* 在集成测试可以运行的环境中处理和发布包：

~~~bash
$ mvn integration-test
~~~

* 显示maven依赖树

~~~bash
$ mvn dependency:tree
~~~

* 显示maven依赖列表

~~~bash
$ mvn dependency:list
~~~

* 下载依赖包的源码

~~~bash
$ mvn dependency:sources
~~~

* 安装本地jar到本地仓库：

~~~bash
$ mvn install:install-file 
-DgroupId=packageName 
-DartifactId=projectName 
-Dversion=version 
-Dpackaging=jar 
-Dfile=path
~~~

## Web 相关命令

* 启动tomcat：

~~~bash
$ mvn tomcat:run
~~~

* 启动jetty

~~~bash
$ mvn jetty:run
~~~

* 运行打包部署

~~~bash
$ mvn tomcat:deploy
~~~

* 撤销部署

~~~bash
$ mvn tomcat:undeploy
~~~

* 启动web应用

~~~bash
$ mvn tomcat:start
~~~

* 停止web应用

~~~bash
$ mvn tomcat:stop
~~~

* 重新部署

~~~bash
$ mvn tomcat:redeploy
~~~

* 部署展开的war文件

~~~bash
$ mvn war:exploded tomcat:exploded
~~~

## 常用 Maven 镜像源

* Maven 官网

~~~http
https://maven.apache.org/
~~~

* 阿里云

~~~http
http://maven.aliyun.com/nexus/content/groups/public/
~~~

* 阿里云

~~~http
http://maven.aliyun.com/nexus/content/groups/public/
~~~

* Spring

~~~http
http://repo.spring.io/libs-milestone-local
~~~

* spring.io

~~~http
https://repo.spring.io/libs-release-local
~~~

* 华为

~~~http
https://mirrors.huaweicloud.com/repository/maven/
~~~

* 网易

~~~http
http://mirrors.163.com/maven/repository/maven-public/
~~~

* 腾讯

~~~http
http://mirrors.cloud.tencent.com/nexus/repository/maven-public/
~~~

* 开源中国

~~~http
http://maven.oschina.net/content/groups/public/
~~~

## maven 依赖查询

* 官网

~~~http
https://mvnrepository.com/
~~~

## 打包命令

* 清理之前项目生成结果并构建然后将依赖包安装到本地仓库跳过测试

~~~bash
$ mvn clean  install package -Dmaven.test.skip=true
~~~

* 构建并将依赖放入私有仓库

~~~bash
$ mvn clean deploy package  -Dmaven.test.skip=true
~~~

* 指定maven配置文件构建

~~~bash
$ mvn --settings /data/settings.xml clean package -Dmaven.test.skip=true
~~~

## 打包配置 `pom.xml`

* 配置打包的 `jar` 包名称，在 `build` 下配置

~~~xml
<finalName>jarname</finalName>
~~~

* 指定打包的`jar`存放位置

~~~xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <!-- 指定生成Jar包的路径 -->
        <outputDirectory>./../deployment/lib</outputDirectory>
    </configuration>
    <executions>
        <execution>
            <goals>
                <!--可以把依赖的包都打包到生成的Jar包中-->
                <goal>repackage</goal>
            </goals>
        </execution>
    </executions>
</plugin>
~~~

* 排除测试类对打包的干扰

~~~xml
<plugin>
    <!-- 排除测试类对打包的干扰 -->
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
        <testFailureIgnore>true</testFailureIgnore>
    </configuration>
</plugin>
~~~

* lib 和 应用程序 class 打包分离

> 使用 SpringBoot 的过程中，发布到生产环境的网速受限，如果每次将80,100M甚至更大的jar包上传，速度太慢了，采取jar包和配置文件分离的方式可以极大的压缩jar包大小，至于依赖的jar包则只需要上传一次，后期增加了jar包则将jar包加入到jar包文件夹内就可以了。配置文件也是一样，每次修改了才需要修改服务器文件，如果只是单纯的代码更新，我们直接打包上传源码jar包就可以了。直接上maven pom.xml build配置。

~~~xml
<build>
    <resources>
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>**/**/**/**/mapper/*.xml</include>
            </includes>
        </resource>
    </resources>
    <plugins>
        <!--打包jar start 分开依赖jar，和配置文件-->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <configuration>
                <!--不打包资源文件-->
                <excludes>
                    <exclude>*.**</exclude>
                    <exclude>*/*.xml</exclude>
                </excludes>
                <archive>
                    <manifest>
                        <!--添加这一项配置 ，即可解决-->
                        <addDefaultImplementationEntries>true</addDefaultImplementationEntries>
                        <!--添加这一项配置 ，即可解决  end-->
                        <addClasspath>true</addClasspath>
                        <!--MANIFEST.MF 中 Class-Path 加入前缀-->
                        <classpathPrefix>lib/</classpathPrefix>
                        <!--jar包不包含唯一版本标识-->
                        <useUniqueVersions>false</useUniqueVersions>
                        <!--指定入口类-->
                        <mainClass>com.mobaijun.kjs_generator.KjsGeneratorApplication</mainClass>
                    </manifest>
                    <manifestEntries>
                        <!--MANIFEST.MF 中 Class-Path 加入资源文件目录-->
                        <Class-Path>./resources/</Class-Path>
                    </manifestEntries>
                </archive>
                <outputDirectory>${project.build.directory}</outputDirectory>
            </configuration>
        </plugin>
        <!--拷贝依赖 copy-dependencies-->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-dependency-plugin</artifactId>
            <executions>
                <execution>
                    <id>copy-dependencies</id>
                    <phase>package</phase>
                    <goals>
                        <goal>copy-dependencies</goal>
                    </goals>
                    <configuration>
                        <outputDirectory>${project.build.directory}/lib/</outputDirectory>
                    </configuration>
                </execution>
            </executions>
        </plugin>
        <!--拷贝资源文件 copy-resources-->
        <plugin>
            <artifactId>maven-resources-plugin</artifactId>
            <executions>
                <execution>
                    <id>copy-resources</id>
                    <phase>package</phase>
                    <goals>
                        <goal>copy-resources</goal>
                    </goals>
                    <configuration>
                        <resources>
                            <resource>
                                <directory>src/main/resources</directory>
                            </resource>
                        </resources>
                        <outputDirectory>${project.build.directory}/resources</outputDirectory>
                    </configuration>
                </execution>
            </executions>
        </plugin>
        <!--spring boot repackage，依赖 maven-jar-plugin 打包的jar包 重新打包成 spring boot 的jar包-->
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <!--重写包含依赖，包含不存在的依赖，jar里没有pom里的依赖-->
                <includes>
                    <include>
                        <groupId>null</groupId>
                        <artifactId>null</artifactId>
                    </include>
                </includes>
                <layout>ZIP</layout>
                <!--使用外部配置文件，jar包里没有资源文件-->
                <addResources>true</addResources>
                <outputDirectory>${project.build.directory}</outputDirectory>
            </configuration>
            <executions>
                <execution>
                    <goals>
                        <goal>repackage</goal>
                    </goals>
                    <configuration>
                        <!--配置jar包特殊标识 配置后，保留原文件，生成新文件 *-run.jar -->
                        <!--配置jar包特殊标识 不配置，原文件命名为 *.jar.original，生成新文件 *.jar -->
                        <classifier>run</classifier>
                    </configuration>
                </execution>
            </executions>
        </plugin>
        <!--打包jar end-->
    </plugins>
</build>
~~~

* 将打包目录下的 `resources` 文件夹和`lib` 文件夹,以及打包的 jar 放在同一路径后，使用如下命令启动jar包即可运行

* 启动命令需要携带`lib`路径参数

~~~bash
$ java -Dloader.path=D:\lib -jar *.jar
~~~

## 参考文章：

[Spring Boot 打包，分离依赖jar，配置文件 · 76号地精](https://76peter.work/archives/springboot)

[这 30 个常用的 Maven 命令你必须熟悉！ - Java技术栈 - 博客园](https://www.cnblogs.com/javastack/p/12982472.html)

