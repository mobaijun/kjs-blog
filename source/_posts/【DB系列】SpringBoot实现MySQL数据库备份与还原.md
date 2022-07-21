---
title: 【DB系列】SpringBoot实现MySQL数据库备份与还原
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2334558877
tags:
  - MySQL数据备份
categories:
  - SpringBoot
date: 2021-10-12 15:19:34
img:
coverImg:
password:
summary:
---

## 前言：

这篇文章已经构思很久了，之前说过的，可以看下这篇文章[MySQL数据库备份与恢复-使用MySQLDump记录 | 框架师](https://www.mobaijun.com/posts/2902111757.html)，是一个`可视化备份MySQL的需求`，我们平台是`BS`的架构，有一个`WEB` 页面，客户需求是在页面上对所有的平台数据执行备份和恢复操作，那么就需要使用代码去调用`MySQL`备份和恢复的指令，下面是具体实现步骤；

## MySQL备份表设计

具体`SQL`:

~~~sql
CREATE TABLE IF NOT EXISTS `mysql_backups` (
    `id` INT ( 11 ) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `mysql_ip` VARCHAR ( 15 ) DEFAULT NULL COMMENT '数据库IP',
    `mysql_port` VARCHAR ( 5 ) DEFAULT NULL COMMENT '数据库端口',
    `mysql_cmd` VARCHAR ( 230 ) DEFAULT NULL COMMENT '备份命令',
    `mysql_back_cmd` VARCHAR ( 230 ) DEFAULT NULL COMMENT '恢复命令',
    `database_name` VARCHAR ( 20 ) DEFAULT NULL COMMENT '数据库名称',
    `backups_path` VARCHAR ( 50 ) DEFAULT NULL COMMENT '备份数据地址',
    `backups_name` VARCHAR ( 50 ) DEFAULT NULL COMMENT '备份文件名称',
    `operation` INT ( 11 ) DEFAULT NULL COMMENT '操作次数',
    `status` INT ( 1 ) DEFAULT NULL COMMENT '数据状态（1正常，-1删除）',
    `recovery_time` DATETIME DEFAULT NULL COMMENT '恢复时间',
    `create_time` DATETIME DEFAULT NULL COMMENT '备份时间',
    PRIMARY KEY ( `id` ),
INDEX baskups_index ( mysql_ip, mysql_port, backups_path, database_name,backups_name) USING BTREE COMMENT '索引'
) ENGINE = INNODB AUTO_INCREMENT = 1 CHARSET = UTF8 ROW_FORMAT = COMPACT COMMENT = 'MySQL数据备份表';
~~~

数据状态这个字段可加可不加，我的视角是这个备份属于永久存储，不可删除的，所以前端界面上不能有删除按钮，但是后台可能会对一些数据做操作，就加了`status`这个字段。

## 实体类设计

~~~java
import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.enums.IdType;
import lombok.Data;

import java.util.Date;

/**
 * Software：IntelliJ IDEA 2021.2 x64
 * Date: 2021/9/16 14:47
 * ClassName:SystemMysqlBackups
 * 类描述： MySQL备份实体
 */
@Data
@TableName("mysql_backups")
public class SystemMysqlBackups {

    /**
     * 主键id
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * MySQL服务器IP地址
     */
    @TableField("mysql_ip")
    private String mysqlIp;

    /**
     * MySQL服务器端口号
     */
    @TableField("mysql_port")
    private String mysqlPort;

    /**
     * MySQL服务器端口号
     */
    @TableField("database_name")
    private String databaseName;

    /**
     * MySQL备份指令
     */
    @TableField("mysql_cmd")
    private String mysqlCmd;

    /**
     * MySQL恢复指令
     */
    @TableField("mysql_back_cmd")
    private String mysqlBackCmd;

    /**
     * MySQL备份存储地址
     */
    @TableField("backups_path")
    private String backupsPath;

    /**
     * MySQL备份文件名称
     */
    @TableField("backups_name")
    private String backupsName;

    /**
     * 操作次数
     */
    @TableField("operation")
    private Integer operation;

    /**
     * 数据状态
     */
    @TableField("status")
    private Integer status;

    /**
     * 恢复时间
     */
    @TableField("recovery_time")
    private Date recoveryTime;

    /**
     * 备份时间
     */
    @TableField("create_time")
    private Date createTime;

}
~~~

注解说明：

* @Data：`Lombok`简化实体类注解，不了解的小伙伴可以查看我之前写过的[Lombok | 框架师](https://www.mobaijun.com/posts/529462236.html)一文
* @TableName：`MybatisPlus`的注解，标识表名
* @TableId：标识主键，设置主键增长类型
* @TableField：标识表字段

## mapper和映射文件

* `mapper` 接口代码:

~~~java
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.zj.module.repository.model.system.backups.SystemMysqlBackups;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Software：IntelliJ IDEA 2021.2 x64
 * Date: 2021/9/16 15:01
 * InterfaceName:SystemMysqlBackupsMapper
 * 接口描述： MySQL备份接口
 */
public interface SystemMysqlBackupsMapper extends BaseMapper<SystemMysqlBackups> {

    /**
     * 查询所有备份数据
     */
    List<SystemMysqlBackups> selectBackupsList();

    /**
     * 根据ID查询
     */
    SystemMysqlBackups selectListId(@Param("id") Long id);
}
~~~

以上两个方法可以不写，但是我们公司使用的 `MybatisPlus` 版本明明都配置好了逻辑删除，无法使用就邪门💢，所以只能写这些重复的轮子。对了，我们公司使用的`MybatisPlus`版本是`1.0.5`。有知道的小伙伴可以在下方评论告诉我一下。

* 映射文件代码：

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.mobaijun.module.dao.system.backups.SystemMysqlBackupsMapper">
    <resultMap id="Base_Result_Map" type="com.mobaijun.module.model.system.backups.SystemMysqlBackups">
        <id column="id" property="id"/>
        <result column="mysql_ip" property="mysqlIp"/>
        <result column="mysql_port" property="mysqlPort"/>
        <result column="mysql_cmd" property="mysqlCmd"/>
        <result column="mysql_back_cmd" property="mysqlBackCmd"/>
        <result column="database_name" property="databaseName"/>
        <result column="backups_path" property="backupsPath"/>
        <result column="backups_name" property="backupsName"/>
        <result column="operation" property="operation"/>
        <result column="status" property="status"/>
        <result column="recovery_time" property="recoveryTime"/>
        <result column="create_time" property="createTime"/>
    </resultMap>

    <sql id="Base_Column_List">
        id
        as id,
        `mysql_ip` as mysqlIp,
        `mysql_port` as mysqlPort,
        `mysql_cmd` as mysqlCmd,
        `mysql_back_cmd` as mysqlBackCmd,
        `database_name` as databaseName,
        `backups_path` as backupsPath,
        `backups_name` as backupsName,
        `operation` as operation,
        `status` as status,
        `recovery_time` as recoveryTime,
        `create_time` as createTime
    </sql>

    <select id="selectListId" resultMap="Base_Result_Map">
        SELECT *
        FROM `mysql_backups`
        WHERE `status` != 0
          AND id = #{id}
    </select>

    <select id="selectBackupsList" resultMap="Base_Result_Map">
        SELECT *
        FROM `mysql_backups`
        WHERE `status` != 0
        ORDER BY create_time DESC
    </select>
</mapper>
~~~

## Service 接口和实现类

* `service` 接口

~~~java
import com.baomidou.mybatisplus.service.IService;
import com.mobaijun.module.model.system.backups.SystemMysqlBackups;

import java.util.List;

/**
 * Software：IntelliJ IDEA 2021.2 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/9/16 15:19
 * ClassName:SystemMysqlBackupsservice
 * 类描述： MySQL备份接口
 */
public interface SystemMysqlBackupsService extends IService<SystemMysqlBackups> {

    /**
     * 查询所有备份数据
     */
    List<SystemMysqlBackups> selectBackupsList();

    /**
     * mysql备份接口
     */
    Object mysqlBackups(String filePath, String url, String userName, String password);

    /**
     * 根据ID查询
     */
    SystemMysqlBackups selectListId(Long id);

    /**
     * 恢复数据库
     *
     * @param smb      恢复对象
     * @param userName 数据库用户名
     * @param password 数据库密码
     * @return
     */
    Object rollback(SystemMysqlBackups smb, String userName, String password);
}
~~~

以上代码都有注释，这块呼吁大家向我学习，我们公司有同事写代码从来不加注释💢，看他代码很💥

* 实现类：

~~~java
import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.io.FileUtil;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.mobaijun.module.core.constant.common.Constants;
import com.mobaijun.module.core.tips.ErrorTip;
import com.mobaijun.module.dao.system.backups.SystemMysqlBackupsMapper;
import com.mobaijun.module.model.system.backups.SystemMysqlBackups;
import com.mobaijun.module.service.system.backups.SystemMysqlBackupsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * Software：IntelliJ IDEA 2021.2 x64
 * Date: 2021/9/16 15:19
 * ClassName:SystemMysqlBackupsService
 * 类描述： MySQL备份实现
 */
@Slf4j
@Service
public class SystemMysqlBackupsServiceImpl extends ServiceImpl<SystemMysqlBackupsMapper, SystemMysqlBackups> implements SystemMysqlBackupsService {

    @Resource
    private SystemMysqlBackupsMapper systemMysqlBackupsMapper;

    @Override
    public List<SystemMysqlBackups> selectBackupsList() {
        return systemMysqlBackupsMapper.selectBackupsList();
    }

    @Override
    public Object mysqlBackups(String filePath, String url, String userName, String password) {
        // 获取ip
        final String ip = url.substring(13, 22);
        // 获取端口号
        final String port = url.substring(23, 27);
        // 获取数据库名称
        final String database_name = url.substring(28, 42);
        // 数据库文件名称
        StringBuilder mysqlFileName = new StringBuilder()
                .append(Constants.DATA_BASE_NAME)
                .append("_")
                .append(DateUtil.format(new Date(), "yyyy-MM-dd-HH-mm-ss"))
                .append(Constants.FILE_SUFFIX);
        // 备份命令
        StringBuilder cmd = new StringBuilder()
                .append("mysqldump ")
                .append("--no-tablespaces ")
                .append("-h")
                .append(ip)
                .append(" -u")
                .append(userName)
                .append(" -p")
                .append(password)
                // 排除MySQL备份表
                .append(" --ignore-table ")
                .append(database_name)
                .append(".mysql_backups ")
                .append(database_name)
                .append(" > ")
                .append(filePath)
                .append(mysqlFileName);
        // 判断文件是否保存成功
        if (!FileUtil.exist(filePath)) {
            FileUtil.mkdir(filePath);
            return new ErrorTip(HttpStatus.REQUEST_HEADER_FIELDS_TOO_LARGE.value(), "备份失败，文件保存异常，请查看文件内容后重新尝试！");
        }
        // 获取操作系统名称
        String osName = System.getProperty("os.name").toLowerCase();
        String[] command = new String[0];
        if (Constants.isSystem(osName)) {
            // Windows
            command = new String[]{"cmd", "/c", String.valueOf(cmd)};
        } else {
            // Linux
            command = new String[]{"/bin/sh", "-c", String.valueOf(cmd)};
        }
        SystemMysqlBackups smb = new SystemMysqlBackups();
        // 备份信息存放到数据库
        smb.setMysqlIp(ip);
        smb.setMysqlPort(port);
        smb.setBackupsName(String.valueOf(mysqlFileName));
        smb.setDatabaseName(database_name);
        smb.setMysqlCmd(String.valueOf(cmd));
        smb.setBackupsPath(filePath);
        smb.setCreateTime(DateTime.now());
        smb.setStatus(1);
        smb.setOperation(0);
        systemMysqlBackupsMapper.insert(smb);
        log.error("数据库备份命令为：{}", cmd);
        // 获取Runtime实例
        Process process = null;
        try {
            process = Runtime.getRuntime().exec(command);
            if (process.waitFor() == 0) {
                log.info("Mysql 数据库备份成功,备份文件名：{}", mysqlFileName);
            } else {
                return new ErrorTip(HttpStatus.INTERNAL_SERVER_ERROR.value(), "网络异常，数据库备份失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ErrorTip(HttpStatus.INTERNAL_SERVER_ERROR.value(), "网络异常，数据库备份失败");
        }
        return smb;
    }

    @Override
    public SystemMysqlBackups selectListId(Long id) {
        return systemMysqlBackupsMapper.selectListId(id);
    }

    @Override
    public Object rollback(SystemMysqlBackups smb, String userName, String password) {
        // 备份路径和文件名
        StringBuilder realFilePath = new StringBuilder().append(smb.getBackupsPath()).append(smb.getBackupsName());
        if (!FileUtil.exist(String.valueOf(realFilePath))) {
            return new ErrorTip(HttpStatus.NOT_FOUND.value(), "文件不存在，恢复失败，请查看目录内文件是否存在后重新尝试！");
        }
        StringBuilder cmd = new StringBuilder()
                .append("mysql -h")
                .append(smb.getMysqlIp())
                .append(" -u")
                .append(userName)
                .append(" -p")
                .append(password)
                .append(" ")
                .append(smb.getDatabaseName())
                .append(" < ")
                .append(realFilePath);
        String[] command = new String[0];
        log.error("数据库恢复命令为：{}", cmd);
        // 获取操作系统名称
        String osName = System.getProperty("os.name").toLowerCase();
        if (Constants.isSystem(osName)) {
            // Windows
            command = new String[]{"cmd", "/c", String.valueOf(cmd)};
        } else {
            // Linux
            command = new String[]{"/bin/sh", "-c", String.valueOf(cmd)};
        }
        // 恢复指令写入到数据库
        smb.setMysqlBackCmd(String.valueOf(cmd));
        // 更新操作次数
        smb.setRecoveryTime(DateTime.now());
        smb.setOperation(smb.getOperation() + 1);
        // 获取Runtime实例
        Process process = null;
        try {
            process = Runtime.getRuntime().exec(command);
            if (process.waitFor() == 0) {
                log.error("Mysql 数据库恢复成功,恢复文件名：{}", realFilePath);
            } else {
                return new ErrorTip(HttpStatus.GATEWAY_TIMEOUT.value(), "网络异常，恢复失败，请稍后重新尝试！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ErrorTip(HttpStatus.GATEWAY_TIMEOUT.value(), "网络异常，恢复失败，请稍后重新尝试！");
        }
        return smb;
    }
}
~~~

写的工具类方法如下：

~~~java
/**
 * 文件后缀
 */
public static final String FILE_SUFFIX = ".sql";

/**
 * 判断操作系统类型、Linux|Windows
*/
public static boolean isSystem(String osName) {
	Boolean flag = null;
	if (osName.startsWith("windows")) {
		flag = true;
	} else if (osName.startsWith("linux")) {
		flag = false;
	}
	 return flag;
}
~~~

## 控制器

代码如下：

~~~java
import com.mobaijun.module.core.constant.common.Constants;
import com.mobaijun.module.core.tips.ErrorTip;
import com.mobaijun.module.core.tips.SuccessTip;
import com.mobaijun.module.model.system.backups.SystemMysqlBackups;
import com.mobaijun.module.service.system.backups.SystemMysqlBackupsService;
import com.mobaijun.module.web.annotion.ApiJsonObject;
import com.mobaijun.module.web.annotion.ApiJsonProperty;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * Software：IntelliJ IDEA 2021.2 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/9/16 14:45
 * ClassName:SystemMysqlBackupsController
 * 类描述： MySQL数据备份接口
 */
@RestController
@Api(description = "MySQL数据备份")
@RequestMapping(value = "/api/system/baskups")
public class SystemMysqlBackupsController {

    /**
     * 数据库用户名
     */
    @Value("${spring.datasource.username}")
    private String userName;

    /**
     * 数据库密码
     */
    @Value("${spring.datasource.password}")
    private String password;

    /**
     * 数据库url
     */
    @Value("${spring.datasource.url}")
    private String url;

    /**
     * Windows数据库备份地址
     */
    @Value("${spring.datasource.win-path}")
    private String windowsPath;

    /**
     * Linux数据库备份地址
     */
    @Value("${spring.datasource.linux-path}")
    private String linuxPath;


    @Autowired
    private SystemMysqlBackupsService systemMysqlBackupsService;

    @ApiOperation(value = "获取所有备份数据列表")
    @GetMapping("/backupsList")
    public Object backupsList() {
        List<SystemMysqlBackups> systemMysqlBackups = systemMysqlBackupsService.selectBackupsList();
        return new SuccessTip(systemMysqlBackups);
    }
    

    @ApiOperation(value = "MySQL备份")
    @PostMapping("/mysqlBackups")
    public Object mysqlBackups() {
        String path = null;
        // 获取操作系统名称
        String osName = System.getProperty("os.name").toLowerCase();
        if (Constants.isSystem(osName)) {
            // Windows
            path = this.windowsPath;
        } else {
            // Linux
            path = this.linuxPath;
        }
        // 数据库用户名
        String userName = this.userName;
        // 数据库密码
        String password = this.password;
        // 数据库地址
        String url = this.url;
        // 调用备份
        Object systemMysqlBackups = systemMysqlBackupsService.mysqlBackups(path, url, userName, password);
        return new SuccessTip(systemMysqlBackups);
    }


    @ApiOperation(value = "恢复数据库")
    @PutMapping("/rollback")
    public Object rollback(@ApiJsonObject(name = "恢复数据库", value = {
            @ApiJsonProperty(name = "id", example = "1", value = "数据id", dataType = "long", required = true)})
                           @ApiParam(value = "恢复数据库") @RequestBody Map<String, Object> map) {
        Long id = Long.valueOf(map.get("id").toString());
        if (id == null) {
            return new ErrorTip(HttpStatus.INTERNAL_SERVER_ERROR.value(), "id不能为null，请重新尝试！");
        }
        // 数据库用户名
        String userName = this.userName;
        // 数据库密码
        String password = this.password;
        // 根据id查询查询已有的信息
        SystemMysqlBackups smb = systemMysqlBackupsService.selectListId(id);
        // 恢复数据库
        Object rollback = systemMysqlBackupsService.rollback(smb, userName, password);
        // 更新操作次数
        systemMysqlBackupsService.updateById(smb);
        return new SuccessTip(rollback);
    }
}
~~~

最终效果：

![备份效果](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/image-20211012161827028.png)

> 以上就是这篇文章分享的内容，如果你有更好的意见，或代码优化相关，请在下方留言区留言，欢迎一起探讨学习。

## 源码地址

[传送门](https://github.com/mobaijun/mysql-backups)
