---
title: 【随笔】Nacos 2.5 版本更新后，配置文件保存报错异常
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2663618628
tags:
  - nacos
categories:
  - 后端
date: 2025-01-24 10:13:09
img:
coverImg:
password:
summary:
---

Nacos 2.5 报错详情

~~~tex
org.springframework.jdbc.BadSqlGrammarException: PreparedStatementCallback; bad SQL grammar [INSERT INTO his_config_info(id, data_id, group_id, tenant_id, app_name, content, md5, src_ip, src_user, gmt_modified, op_type, publish_type, gray_name, ext_info, encrypted_data_key) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)]; nested exception is java.sql.SQLSyntaxErrorException: Unknown column 'publish_type' in 'field list'
	at org.springframework.jdbc.support.SQLErrorCodeSQLExceptionTranslator.doTranslate(SQLErrorCodeSQLExceptionTranslator.java:236)
	at org.springframework.jdbc.support.AbstractFallbackSQLExceptionTranslator.translate(AbstractFallbackSQLExceptionTranslator.java:73)
~~~

> 如果你使用最稳定版 Nacos 2.5 版本，并且使用 MySQL 数据库，nacos 可能存在无法启动或者保存配置文件报错的情况，这是因为最新版在
> nacos 表 `his_config_info` 新增一下字段，在 nacos 数据库执行以下 sql 即可

~~~sql
ALTER TABLE `his_config_info`
    ADD COLUMN `encrypted_data_key` varchar(1024) NOT NULL DEFAULT '' COMMENT '密钥';

ALTER TABLE `his_config_info`
    ADD COLUMN `publish_type` varchar(50) DEFAULT 'formal' COMMENT 'publish type gray or formal';

ALTER TABLE `his_config_info`
    ADD COLUMN `gray_name` varchar(50) DEFAULT NULL COMMENT 'gray name';

ALTER TABLE `his_config_info`
    ADD COLUMN `ext_info` longtext DEFAULT NULL COMMENT 'ext info';
~~~

