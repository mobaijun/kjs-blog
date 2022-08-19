---
title: 【后端】MapStruct使用详解
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 239252401
tags:
  - MapStruct
categories:
  - 后端
date: 2022-04-20 17:43:20
img:
coverImg:
password:
summary:
---

## 前言:

> 使用 MapStruct 前置知识:
>
> * Entity: 最常用的实体类，基本和数据表一一对应，一个实体一张表。
> * Bo(Business object): 代表业务对象的意思。
> * Vo(Value Object): 返回视图层的对象。
> * Po(Persistant Object): 代表持久层对象的意思。
> * Dto(Data Transfer Object): 代表数据传输对象的意思。
>
> > 常见场景:
> >
> > 比如一个 insert 方法,在前端传输数据的时候,为了隐藏后端表结构,我们会选择构建一个 Dto 来接收数据,再将 Dto 的值传递给 Entity , 这样省不了大量的 getter/setter 调用,当一个项目中存在大量的赋值操作,代码会非常冗余.
>
> 这时候如果有一个非常方便的属性映射框架,可以大大提高我们的效率.下面进入正题,来聊聊 MapStruct.

## MapStruct 说明

mapstruct 是专门用来处理上面常见实体类与属性类的属性映射的,我们只需定义 mapper 接口，mapstruct 在编译的时候就会自动的帮我们实现这个映射接口，避免了麻烦复杂的映射实现。

### 项目官网和示例

> - Github地址：https://github.com/mapstruct/mapstruct/
> - 使用例子：https://github.com/mapstruct/mapstruct-examples

## 项目引入 MapStruect

~~~xml
<!-- mapstruct -->
<dependency>
 	<groupId>org.mapstruct</groupId>
 	<artifactId>mapstruct</artifactId>
 	<version>${mapstruct.version}</version>
</dependency>
<dependency>
 	<groupId>org.mapstruct</groupId>
 	<artifactId>mapstruct-processor</artifactId>
 	<version>${mapstruct.version}</version>
</dependency>

<!- 最新版本 1.5.2 -->
<mapstruct.version>1.5.2.Final</mapstruct.version>
~~~

## 示例程序

1. 创建 entyty 实体类

~~~java
@Data
public class RuleEntity {
    private Long id;
    private String name;
    private Integer age;
    private Integer sex;
    private Date createTime;
}
~~~

1. 创建 Dto 参数实体

~~~java
@Data
public class RuleDto {
    private String name;
    private Integer age;
    private Integer sex;
}
~~~

1. 创建 Vo 视图层视图

~~~java
@Data
public class RuleVo {
    private String name;
    private Integer age;
    private Integer sex;
    private Date createTime;
}
~~~

1. 定义 mapstruct 接口

~~~java
import org.mapstruct.Mapper;
import org.mapstruct.Mappings;
import org.mapstruct.factory.Mappers;

@Mapper
public interface RuleMapper {

    RuleMapper INSTANCE = Mappers.getMapper(RuleMapper.class);

    /**
     * dto 转 entity
     *
     * @param ruleDto 参数对象
     * @return Rule 对象
     */
    @Mappings({})
    Rule toDto(RuleDto ruleDto);
    
    /**
     * entity 转 vo
     *
     * @param rule 实体对象
     * @return RuleVo 视图对象
     */
    @Mappings({})
    RuleVo toDto(Rule rule);
}
~~~

1. 使用转换器

~~~java
// 调用转换器方法，将要转换的参数对象传递进去即可,
Rule rule = RuleMapper.INSTANCE.toDto(ruleDto);
// entity 转 vo
RuleVo ruleVo = RuleMapper.INSTANCE.toVo(rule);
~~~

1. 查看编译结果

> 待编译完成后，mapstruct 会自动帮我们生成一个实现类，RuleMapperImpl，查看这个实现类，mapstruct 会自动帮我们生成一个实现类。



多参数转换，如果遇到多参数转换，在实际业务场景中，我们会经常遇到json转换的字符串存入某个属性中，或者好几个类的组合成一个新的类返回。

需要了解 @mapping 注解

里面有两个常用参数

* target ： 表示转换后的字段
* source ： 表示转换前的源字段

* 示例代码

~~~java
/**
 * 转换器
 *
 * @param alertMessage  alertMessage
 * @param devicesConfig devicesConfig
 * @param data          alertMessage
 * @param measurement   measurement
 * @return BaseDeviceData
 */
@Mappings({
        @Mapping(target = "projectId", source = "alertMessage.projectId"),
        @Mapping(target = "alarmType", source = "alertMessage.msgType"),
        @Mapping(target = "alarmId", source = "devicesConfig.hxzId")
})
BaseDeviceAlarmData toBase(LbAlertMessage alertMessage, LbDevicesConfig devicesConfig, String data, String measurement);
~~~

* 参数传递

~~~java
BaseDataConverterMapper.INSTANCE.toBase(lbAlertMessage,devicesConfig,JSON.toJSONString(lbAlertMessage),DeviceName.DEVICE_ALARM_DATA.getAlias())
~~~

> 非常方便

* 实现类

~~~java
public class BaseDataConverterMapperImpl implements BaseDataConverterMapper {

    @Override
    public BaseDeviceAlarmData toBase(LbAlertMessage alertMessage, LbDevicesConfig devicesConfig, String data, String measurement) {
        if ( alertMessage == null && devicesConfig == null && data == null && measurement == null ) {
            return null;
        }

        BaseDeviceAlarmData baseDeviceAlarmData = new BaseDeviceAlarmData();

        if ( alertMessage != null ) {
            baseDeviceAlarmData.setProjectId( alertMessage.getProjectId() );
            baseDeviceAlarmData.setAlarmType( alertMessage.getMsgType() );
        }
        if ( devicesConfig != null ) {
            if ( devicesConfig.getHxzId() != null ) {
                baseDeviceAlarmData.setAlarmId( Long.parseLong( devicesConfig.getHxzId() ) );
            }
            baseDeviceAlarmData.setEnterpriseId( devicesConfig.getEnterpriseId() );
            baseDeviceAlarmData.setType( devicesConfig.getType() );
        }
        if ( data != null ) {
            baseDeviceAlarmData.setData( data );
        }
        if ( measurement != null ) {
            baseDeviceAlarmData.setMeasurement( measurement );
        }

        return baseDeviceAlarmData;
    }
}
~~~

> 使用 mapstruct 可以大大提高效率，优化冗余代码，快快用起来吧！
