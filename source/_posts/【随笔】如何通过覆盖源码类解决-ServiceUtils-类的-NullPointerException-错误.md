---
title: 【随笔】如何通过覆盖源码类解决 ServiceUtils 类的 NullPointerException 错误
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 474240225
tags:
  - knife4j
categories:
  - 随笔
date: 2024-08-05 17:59:08
img:
coverImg:
password:
summary:
---

> 在日常的开发过程中，我们经常会遇到一些第三方库中的 `bug` 或者无法满足业务需求的情况。最近，我在使用 `Knife4j` 和 `Spring Cloud Gateway` 进行服务路由转换时，遇到了一个 `NullPointerException` 错误。经过排查和修改，我成功解决了这个问题。本文将详细介绍我的解决过程和解决方案，希望能对大家有所帮助。

## 问题描述

~~~cmd
2024-08-05 18:07:55.167 [boundedElastic-13] ERROR reactor.core.publisher.Operators - Operator called default onErrorDropped
reactor.core.Exceptions$ErrorCallbackNotImplemented: java.lang.NullPointerException
Caused by: java.lang.NullPointerException: null
	at java.base/java.util.Objects.requireNonNull(Objects.java:208)
	Suppressed: reactor.core.publisher.FluxOnAssembly$OnAssemblyException: 
Assembly trace from producer [reactor.core.publisher.FluxFilterFuseable] :
	reactor.core.publisher.Flux.filter(Flux.java:5368)
	com.github.xiaoymin.knife4j.spring.gateway.discover.router.DiscoverClientRouteServiceConvert.process(DiscoverClientRouteServiceConvert.java:56)
Error has been observed at the following site(s):
	*__Flux.filter ⇢ at com.github.xiaoymin.knife4j.spring.gateway.discover.router.DiscoverClientRouteServiceConvert.process(DiscoverClientRouteServiceConvert.java:56)
Original Stack Trace:
		at java.base/java.util.Objects.requireNonNull(Objects.java:208)
		at com.github.xiaoymin.knife4j.spring.gateway.utils.ServiceUtils.includeService(ServiceUtils.java:93)
		at com.github.xiaoymin.knife4j.spring.gateway.discover.router.DiscoverClientRouteServiceConvert.lambda$process$1(DiscoverClientRouteServiceConvert.java:56)
		at reactor.core.publisher.FluxFilterFuseable$FilterFuseableSubscriber.onNext(FluxFilterFuseable.java:104)
		at reactor.core.publisher.FluxFilterFuseable$FilterFuseableConditionalSubscriber.onNext(FluxFilterFuseable.java:337)
		at reactor.core.publisher.FluxMapFuseable$MapFuseableConditionalSubscriber.onNext(FluxMapFuseable.java:299)
		at reactor.core.publisher.MonoFlatMapMany$FlatMapManyInner.onNext(MonoFlatMapMany.java:251)
		at reactor.core.publisher.FluxIterable$IterableSubscription.fastPath(FluxIterable.java:402)
		at reactor.core.publisher.FluxIterable$IterableSubscription.request(FluxIterable.java:291)
		at reactor.core.publisher.MonoFlatMapMany$FlatMapManyMain.onSubscribeInner(MonoFlatMapMany.java:150)
		at reactor.core.publisher.MonoFlatMapMany$FlatMapManyInner.onSubscribe(MonoFlatMapMany.java:246)
		at reactor.core.publisher.FluxIterable.subscribe(FluxIterable.java:201)
		at reactor.core.publisher.FluxIterable.subscribe(FluxIterable.java:83)
		at reactor.core.publisher.Flux.subscribe(Flux.java:8840)
		at reactor.core.publisher.MonoFlatMapMany$FlatMapManyMain.onNext(MonoFlatMapMany.java:196)
		at reactor.core.publisher.Operators$BaseFluxToMonoOperator.completePossiblyEmpty(Operators.java:2097)
		at reactor.core.publisher.MonoCollect$CollectSubscriber.onComplete(MonoCollect.java:145)
		at reactor.core.publisher.FluxFilterFuseable$FilterFuseableSubscriber.onComplete(FluxFilterFuseable.java:171)
		at reactor.core.publisher.FluxFlatMap$FlatMapMain.checkTerminated(FluxFlatMap.java:850)
		at reactor.core.publisher.FluxFlatMap$FlatMapMain.drainLoop(FluxFlatMap.java:612)
		at reactor.core.publisher.FluxFlatMap$FlatMapMain.drain(FluxFlatMap.java:592)
		at reactor.core.publisher.FluxFlatMap$FlatMapMain.onComplete(FluxFlatMap.java:469)
		at reactor.core.publisher.FluxFilterFuseable$FilterFuseableSubscriber.onComplete(FluxFilterFuseable.java:171)
		at reactor.core.publisher.FluxFlatMap$FlatMapMain.checkTerminated(FluxFlatMap.java:850)
		at reactor.core.publisher.FluxFlatMap$FlatMapMain.drainLoop(FluxFlatMap.java:612)
		at reactor.core.publisher.FluxFlatMap$FlatMapMain.innerComplete(FluxFlatMap.java:898)
		at reactor.core.publisher.FluxFlatMap$FlatMapInner.onComplete(FluxFlatMap.java:1001)
		at reactor.core.publisher.Operators$BaseFluxToMonoOperator.completePossiblyEmpty(Operators.java:2098)
		at reactor.core.publisher.MonoCollectList$MonoCollectListSubscriber.onComplete(MonoCollectList.java:118)
		at org.springframework.cloud.commons.publisher.FluxFirstNonEmptyEmitting$FirstNonEmptyEmittingSubscriber.onComplete(FluxFirstNonEmptyEmitting.java:325)
		at reactor.core.publisher.FluxSubscribeOn$SubscribeOnSubscriber.onComplete(FluxSubscribeOn.java:166)
		at reactor.core.publisher.FluxIterable$IterableSubscription.fastPath(FluxIterable.java:424)
		at reactor.core.publisher.FluxIterable$IterableSubscription.request(FluxIterable.java:291)
		at reactor.core.publisher.FluxSubscribeOn$SubscribeOnSubscriber.requestUpstream(FluxSubscribeOn.java:131)
		at reactor.core.publisher.FluxSubscribeOn$SubscribeOnSubscriber.onSubscribe(FluxSubscribeOn.java:124)
		at reactor.core.publisher.FluxIterable.subscribe(FluxIterable.java:201)
		at reactor.core.publisher.FluxIterable.subscribe(FluxIterable.java:83)
		at reactor.core.publisher.Flux.subscribe(Flux.java:8840)
		at reactor.core.publisher.FluxFlatMap.trySubscribeScalarMap(FluxFlatMap.java:202)
		at reactor.core.publisher.MonoFlatMapMany.subscribeOrReturn(MonoFlatMapMany.java:49)
		at reactor.core.publisher.Flux.subscribe(Flux.java:8825)
		at reactor.core.publisher.FluxFlatMap.trySubscribeScalarMap(FluxFlatMap.java:202)
		at reactor.core.publisher.MonoFlatMapMany.subscribeOrReturn(MonoFlatMapMany.java:49)
		at reactor.core.publisher.InternalFluxOperator.subscribe(InternalFluxOperator.java:55)
		at reactor.core.publisher.FluxSubscribeOn$SubscribeOnSubscriber.run(FluxSubscribeOn.java:194)
		at reactor.core.scheduler.WorkerTask.call(WorkerTask.java:84)
		at reactor.core.scheduler.WorkerTask.call(WorkerTask.java:37)
		at java.base/java.util.concurrent.FutureTask.run$$$capture(FutureTask.java:264)
		at java.base/java.util.concurrent.FutureTask.run(FutureTask.java)
		at java.base/java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.run(ScheduledThreadPoolExecutor.java:304)
		at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1136)
		at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:635)
		at java.base/java.lang.Thread.run(Thread.java:833)
~~~

## 问题排查

根据错误日志，我们可以看到问题出现在 `DiscoverClientRouteServiceConvert` 类的 `process` 方法中，具体是在 `ServiceUtils.includeService()` 操作时抛出了 `NullPointerException`。为了更好地了解问题，我们首先查看了 `DiscoverClientRouteServiceConvert` 类的源码。

~~~java
/*
 * Copyright © 2017-2023 Knife4j(xiaoymin@foxmail.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


package com.github.xiaoymin.knife4j.spring.gateway.discover.router;

import com.github.xiaoymin.knife4j.spring.gateway.Knife4jGatewayProperties;
import com.github.xiaoymin.knife4j.spring.gateway.discover.ServiceRouterHolder;
import com.github.xiaoymin.knife4j.spring.gateway.enums.GatewayRouterStrategy;
import com.github.xiaoymin.knife4j.spring.gateway.utils.ServiceUtils;
import com.github.xiaoymin.knife4j.spring.gateway.utils.StrUtil;
import io.netty.util.internal.StringUtil;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.cloud.gateway.discovery.DiscoveryClientRouteDefinitionLocator;
import java.util.Map;

/**
 * 服务发现discover模式下，开发者在网关成的路由转发模式默认通过{@link DiscoveryClient}的默认方式转发路由，规则是pattern:/service-id/** <p />
 * 值得注意的点：
 * <ul>
 *     <li>1.设置<code>spring.cloud.gateway.discovery.locator.enabled=true</code>启用<code>DiscoveryClient</code></li>
 *     <li>2.设置<code>spring.cloud.discovery.reactive.enabled=true</code>,保证{@link DiscoveryClientRouteDefinitionLocator}对象实例注入Spring容器中</li>
 * </ul>
 * 更多详细内容参考<a href="https://docs.spring.io/spring-cloud-gateway/docs/3.1.8/reference/html/#the-discoveryclient-route-definition-locator">Spring Cloud Gateway官方文档#The DiscoveryClient Route Definition Locator</a>
 * @author <a href="xiaoymin@foxmail.com">xiaoymin@foxmail.com</a>
 * 2023/8/3 16:02
 * @since knife4j v4.3.0
 */
@AllArgsConstructor
@Slf4j
public class DiscoverClientRouteServiceConvert extends AbstactServiceRouterConvert {
    
    final DiscoveryClientRouteDefinitionLocator discoveryClientRouteDefinitionLocator;
    final Knife4jGatewayProperties knife4jGatewayProperties;
    @Override
    public void process(ServiceRouterHolder holder) {
        log.debug("Spring Cloud Gateway DiscoverClient process.");
        // 取默认子服务的路径规则
        discoveryClientRouteDefinitionLocator.getRouteDefinitions()
                .filter(routeDefinition -> ServiceUtils.startLoadBalance(routeDefinition.getUri()))
                .filter(routeDefinition -> ServiceUtils.includeService(routeDefinition.getUri(), holder.getService(), holder.getExcludeService()))
                .subscribe(routeDefinition -> parseRouteDefinition(holder, routeDefinition.getPredicates(), routeDefinition.getUri().getHost(),
                        routeDefinition.getUri().getHost()));
    }
    
    @Override
    String convertPathPrefix(Map<String, String> predicateArgs) {
        String value = predicateArgs.get(GatewayRouterStrategy.REACTIVE.getRule());
        if (StrUtil.isNotBlank(value)) {
            return value.replace("**", StringUtil.EMPTY_STRING);
        }
        return StringUtil.EMPTY_STRING;
    }
    
    @Override
    public int order() {
        return GatewayRouterStrategy.REACTIVE.getOrder();
    }
    
    @Override
    Knife4jGatewayProperties.Discover getDiscover() {
        return this.knife4jGatewayProperties.getDiscover();
    }
}
~~~

然后进入到 `ServiceUtils` 方法,发现是 `serviceName` 在非 `http` 服务的情况下无法获取到 `host` 参数导致为空,进而报错，那么只需要解决这个 `serviceName` 为空时的校验即可。

~~~java
/*
 * Copyright © 2017-2023 Knife4j(xiaoymin@foxmail.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


package com.github.xiaoymin.knife4j.spring.gateway.utils;

import com.github.xiaoymin.knife4j.spring.gateway.Knife4jGatewayProperties;
import com.github.xiaoymin.knife4j.spring.gateway.conf.GlobalConstants;
import com.github.xiaoymin.knife4j.spring.gateway.enums.GatewayRouterStrategy;
import com.github.xiaoymin.knife4j.spring.gateway.enums.OpenApiVersion;
import com.github.xiaoymin.knife4j.spring.gateway.spec.v2.OpenAPI2Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.CollectionUtils;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.regex.Pattern;

/**
 * 在服务发现(Discover)场景下的聚合辅助工具类
 * @author <a href="xiaoymin@foxmail.com">xiaoymin@foxmail.com</a>
 * 2023/7/31 15:05
 * @since knife4j v4.2.0
 */
@Slf4j
public class ServiceUtils {
    
    private final static String LB = "lb://";
    
    /**
     * 根据OpenAPI规范及分组名称不同获取不同的默认地址
     * @param discover 服务发现配置
     * @param contextPath contextPath
     * @param groupName 分组名称
     * @return openapi地址
     * @since v4.3.0
     */
    public static String getOpenAPIURL(Knife4jGatewayProperties.Discover discover, String contextPath, String groupName) {
        OpenApiVersion apiVersion = discover.getVersion();
        StringBuilder urlBuilder = new StringBuilder();
        String _defaultPath = PathUtils.processContextPath(contextPath);
        // String _groupName = StrUtil.defaultTo(groupName, GlobalConstants.DEFAULT_GROUP_NAME);
        String _groupName = "";
        String groupUrl = "";
        if (apiVersion == OpenApiVersion.Swagger2) {
            groupUrl = GlobalConstants.DEFAULT_OPEN_API_V2_PATH + _groupName;
        } else if (apiVersion == OpenApiVersion.OpenAPI3) {
            groupUrl = PathUtils.append(GlobalConstants.DEFAULT_OPEN_API_V3_PATH, _groupName);
        }
        urlBuilder.append(PathUtils.append(_defaultPath, groupUrl));
        return urlBuilder.toString();
    }
    
    /**
     * 判断服务路由是否负载配置
     * @param uri 路由
     * @return True-是，False-非lb
     */
    public static boolean startLoadBalance(URI uri) {
        if (uri == null) {
            return false;
        }
        String path = uri.toString();
        if (path == null || path.isEmpty()) {
            return false;
        }
        return path.startsWith(LB);
    }
    
    /**
     * 判断是否包含服务
     * @param uri 路由服务
     * @param service 服务列表
     * @param excludeService 已排除服务列表
     * @return  True-是，False-非
     */
    public static boolean includeService(URI uri, Collection<String> service, Collection<String> excludeService) {
        // serviceName在非http服务的情况下无法获取到host参数导致为空
        String serviceName = uri.getHost();
        return service.stream().anyMatch(serviceName::equalsIgnoreCase) && !excludeServices(serviceName, excludeService);
    }
    
    /**
     * 判断当前服务是否在排除服务列表中
     * @param serviceName 服务名称
     * @param excludeService 排除服务规则列表，支持正则表达式(4.3.0版本)
     * @return True-在排除服务列表中，False-不满足规则
     * @since v4.3.0
     */
    public static boolean excludeServices(String serviceName, Collection<String> excludeService) {
        if (CollectionUtils.isEmpty(excludeService)) {
            return false;
        }
        for (String es : excludeService) {
            // 首先根据服务名称直接判断一次
            if (es.equalsIgnoreCase(serviceName)) {
                return true;
            }
            // 增加正则表达式判断
            if (Pattern.compile(es, Pattern.CASE_INSENSITIVE).matcher(serviceName).matches()) {
                return true;
            }
        }
        return false;
    }
}
~~~

## 解决方案

1. 为了确保 `serviceName` 为空还能继续往下走，代码改为如下即可

~~~java
/**
 * 判断是否包含服务
 *
 * @param uri            路由服务
 * @param service        服务列表
 * @param excludeService 已排除服务列表
 * @return True-是，False-非
 */
public static boolean includeService(URI uri, Collection<String> service, Collection<String> excludeService) {
    String serviceName = uri.getHost();
    return service.stream().anyMatch(s -> s.equalsIgnoreCase(serviceName)) && !excludeServices(serviceName, excludeService);
}
~~~

2. **覆盖 `ServiceUtils` 类**：

 由于无法直接修改第三方库的源码，我们可以通过创建一个新的 `ServiceUtils` 类来覆盖原有的实现。通过将自定义的 `ServiceUtils` 类标记为 `@Primary`，Spring 会优先使用我们定义的类。

3. **实现步骤**：

* 新建 `com.github.xiaoymin.knife4j.spring.gateway.utils`,从源码复制 `ServiceUtils` 类，修改 `includeService` 方法。
* 标记为 `@Primary`。
* 在 Spring 配置中，确保新的 `ServiceUtils` 类被正确加载。

4. 完整代码如下：

~~~java
/*
 * Copyright © 2017-2023 Knife4j(xiaoymin@foxmail.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


package com.github.xiaoymin.knife4j.spring.gateway.utils;

import com.github.xiaoymin.knife4j.spring.gateway.Knife4jGatewayProperties;
import com.github.xiaoymin.knife4j.spring.gateway.conf.GlobalConstants;
import com.github.xiaoymin.knife4j.spring.gateway.enums.OpenApiVersion;
import java.net.URI;
import java.util.Collection;
import java.util.regex.Pattern;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Primary;
import org.springframework.util.CollectionUtils;

/**
 * 在服务发现(Discover)场景下的聚合辅助工具类
 *
 * @author <a href="xiaoymin@foxmail.com">xiaoymin@foxmail.com</a>
 * 2023/7/31 15:05
 * @since knife4j v4.2.0
 */
@Slf4j
@Primary
public class ServiceUtils {

    private final static String LB = "lb://";

    /**
     * 根据OpenAPI规范及分组名称不同获取不同的默认地址
     *
     * @param discover    服务发现配置
     * @param contextPath contextPath
     * @param groupName   分组名称
     * @return openapi地址
     * @since v4.3.0
     */
    public static String getOpenAPIURL(Knife4jGatewayProperties.Discover discover, String contextPath, String groupName) {
        OpenApiVersion apiVersion = discover.getVersion();
        StringBuilder urlBuilder = new StringBuilder();
        String _defaultPath = PathUtils.processContextPath(contextPath);
        // String _groupName = StrUtil.defaultTo(groupName, GlobalConstants.DEFAULT_GROUP_NAME);
        String _groupName = "";
        String groupUrl = "";
        if (apiVersion == OpenApiVersion.Swagger2) {
            groupUrl = GlobalConstants.DEFAULT_OPEN_API_V2_PATH + _groupName;
        } else if (apiVersion == OpenApiVersion.OpenAPI3) {
            groupUrl = PathUtils.append(GlobalConstants.DEFAULT_OPEN_API_V3_PATH, _groupName);
        }
        urlBuilder.append(PathUtils.append(_defaultPath, groupUrl));
        return urlBuilder.toString();
    }

    /**
     * 判断服务路由是否负载配置
     *
     * @param uri 路由
     * @return True-是，False-非lb
     */
    public static boolean startLoadBalance(URI uri) {
        if (uri == null) {
            return false;
        }
        String path = uri.toString();
        if (path == null || path.isEmpty()) {
            return false;
        }
        return path.startsWith(LB);
    }

    /**
     * 判断是否包含服务
     *
     * @param uri            路由服务
     * @param service        服务列表
     * @param excludeService 已排除服务列表
     * @return True-是，False-非
     */
    public static boolean includeService(URI uri, Collection<String> service, Collection<String> excludeService) {
        String serviceName = uri.getHost();
        return service.stream().anyMatch(s -> s.equalsIgnoreCase(serviceName)) && !excludeServices(serviceName, excludeService);
    }

    /**
     * 判断当前服务是否在排除服务列表中
     *
     * @param serviceName    服务名称
     * @param excludeService 排除服务规则列表，支持正则表达式(4.3.0版本)
     * @return True-在排除服务列表中，False-不满足规则
     * @since v4.3.0
     */
    public static boolean excludeServices(String serviceName, Collection<String> excludeService) {
        if (CollectionUtils.isEmpty(excludeService)) {
            return false;
        }
        for (String es : excludeService) {
            // 首先根据服务名称直接判断一次
            if (es.equalsIgnoreCase(serviceName)) {
                return true;
            }
            // 增加正则表达式判断
            if (Pattern.compile(es, Pattern.CASE_INSENSITIVE).matcher(serviceName).matches()) {
                return true;
            }
        }
        return false;
    }
}
~~~

## 总结

通过以上修改，成功解决了 `NullPointerException` 错误，并确保在处理服务名称为空的情况下，方法依然能够正常工作。这种方法可以帮助我们在遇到类似的第三方库问题时，快速找到解决方案。
