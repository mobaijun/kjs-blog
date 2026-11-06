# KJS Blog - 基于Hexo的博客系统

这是一个基于Hexo框架和matery主题的博客系统，支持多种功能模块。

## 项目概述

本项目是一个功能完整的博客系统，包含以下主要特性：
- 文章管理
- 分类和标签系统
- 评论系统
- 搜索功能
- 目录导航(TOC)
- **广告内容框** (新增功能)

## 新增功能：广告内容框

### 功能描述
广告内容框是一个类似TOC目录的功能模块，可以在文章页面右侧（或左侧）显示自定义的广告内容。该功能具有以下特点：

- **灵活配置**：可以在主题配置文件中自定义广告内容
- **位置可选**：支持左侧或右侧显示
- **响应式设计**：在移动设备上自动隐藏
- **悬浮按钮**：支持展开/收缩控制
- **固定滚动**：滚动时保持固定位置
- **与TOC兼容**：可以同时启用TOC和广告框

### 配置方法

#### 1. 主题配置文件设置
在 `themes/matery/_config.yml` 文件中添加以下配置：

```yaml
# 广告框配置
adBox:
  enable: true                    # 是否启用广告框功能
  title: 广告位招租               # 广告框标题
  icon: fas fa-ad                 # 标题图标（Font Awesome）
  content: |                      # 广告内容（支持HTML）
    <div style="text-align: center; padding: 20px;">
      <h5 style="color: #42b983; margin-bottom: 15px;">广告位招租</h5>
      <p style="color: #666; margin-bottom: 15px;">欢迎投放广告，请联系我们</p>
      <a href="mailto:ad@example.com" class="btn waves-effect waves-light" style="background-color: #42b983;">
        <i class="fas fa-envelope"></i> 联系我们
      </a>
    </div>
  showToggleBtn: true             # 是否显示切换按钮
  position: right                 # 位置：left（左侧）或 right（右侧）
```

#### 2. 文章级别控制
在文章的Front-matter中添加以下配置来控制单篇文章的广告框显示：

```yaml
---
title: 文章标题
date: 2024-01-01
categories: 
  - 技术
tags:
  - 编程
adBox: false  # 关闭当前文章的广告框
---
```

### 使用场景

#### 1. 广告投放
```yaml
adBox:
  enable: true
  title: 推荐产品
  icon: fas fa-shopping-cart
  content: |
    <div style="text-align: center; padding: 15px;">
      <img src="product-image.jpg" style="width: 100%; max-width: 200px; margin-bottom: 10px;">
      <h6 style="color: #42b983;">产品名称</h6>
      <p style="color: #666; font-size: 14px;">产品描述信息</p>
      <a href="product-link" class="btn waves-effect waves-light" style="background-color: #42b983;">
        立即购买
      </a>
    </div>
```

#### 2. 联系方式展示
```yaml
adBox:
  enable: true
  title: 联系我们
  icon: fas fa-phone
  content: |
    <div style="padding: 15px;">
      <div style="margin-bottom: 15px;">
        <i class="fas fa-envelope"></i> Email: contact@example.com
      </div>
      <div style="margin-bottom: 15px;">
        <i class="fab fa-weixin"></i> 微信: wechat_id
      </div>
      <div style="margin-bottom: 15px;">
        <i class="fab fa-qq"></i> QQ: 123456789
      </div>
    </div>
```

#### 3. 相关推荐
```yaml
adBox:
  enable: true
  title: 相关推荐
  icon: fas fa-thumbs-up
  content: |
    <div style="padding: 15px;">
      <div style="margin-bottom: 10px;">
        <a href="/post1" style="color: #42b983;">推荐文章1</a>
      </div>
      <div style="margin-bottom: 10px;">
        <a href="/post2" style="color: #42b983;">推荐文章2</a>
      </div>
      <div style="margin-bottom: 10px;">
        <a href="/post3" style="color: #42b983;">推荐文章3</a>
      </div>
    </div>
```

### 技术特性

#### 1. 响应式布局
- 桌面端：显示在文章右侧或左侧
- 移动端：自动隐藏，不影响阅读体验

#### 2. 交互功能
- 悬浮按钮：点击可展开/收缩广告框
- 固定滚动：页面滚动时广告框保持固定位置
- 平滑动画：展开/收缩过程有平滑的动画效果

#### 3. 样式定制
- 支持自定义CSS样式
- 可调整颜色、字体、间距等
- 支持Font Awesome图标

#### 4. 兼容性
- 与现有TOC功能完全兼容
- 可同时启用TOC和广告框
- 不影响其他主题功能

### 文件结构

新增的文件：
- `themes/matery/layout/_partial/post-detail-adbox.ejs` - 单独广告框模板
- `themes/matery/layout/_partial/post-detail-toc-adbox.ejs` - TOC+广告框组合模板

修改的文件：
- `themes/matery/_config.yml` - 添加广告框配置
- `themes/matery/layout/post.ejs` - 修改文章布局逻辑

### 注意事项

1. **内容安全**：广告内容支持HTML，请注意XSS安全
2. **性能考虑**：避免在广告内容中加载过多图片或脚本
3. **用户体验**：建议广告内容简洁明了，不影响阅读体验
4. **移动端**：广告框在移动端会自动隐藏，确保移动端阅读体验

## 其他功能

### 现有功能
- [SpringBoot异步任务记录 | 框架师](https://www.mobaijun.com/posts/4255110274.html)
- [框架师](https://www.mobaijun.com/)
- [SpringBoot数据库（URL）参数记录 | 框架师](https://www.mobaijun.com/posts/2403615121.html)
- [SpringBoot跨域及后端解决方案 | 框架师](https://www.mobaijun.com/posts/2298002216.html)
- [Linux-MySQL数据备份和定时清理 | 框架师](https://www.mobaijun.com/posts/619134598.html)
- [SpringBoot项目安装SSL协议 | 框架师](https://www.mobaijun.com/posts/1643000683.html)
- [TaiShan 200ECS服务器安装Docker、influxdb、JDK | 框架师](https://www.mobaijun.com/posts/313051912.html)
- [Centos7安装并配置多网口 | 框架师](https://www.mobaijun.com/posts/1316700149.html)
- [Linux之cat命令高级版ccat安装使用 | 框架师](https://www.mobaijun.com/posts/2794786039.html)

## 更新日志

### v1.1.0 (2024-01-01)
- ✨ 新增广告内容框功能
- 🎨 支持自定义广告内容和样式
- 📱 优化移动端响应式体验
- 🔧 与TOC功能完美兼容

## 技术支持

如有问题或建议，请联系：
- 邮箱：mobaijun8@163.com
- 网站：https://www.mobaijun.com