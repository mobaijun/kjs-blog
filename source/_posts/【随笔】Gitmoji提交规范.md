---
title: 【随笔】Gitmoji提交规范
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - GitEmoji
categories:
  - 工具
abbrlink: 724837924
date: 2020-06-10 21:38:08
img:
coverImg:
password:
summary:
---

### Emoji简介

日语 : `絵文字/えもじ emoji`,是日本在无线通信中所使用的视觉情感符号,绘指图画,文字指的则是字符,可用来代表多种表情,如笑脸表示笑、蛋糕表示食物等. emoji 频繁地出现在我们的聊天记录、朋友圈、甚至很多时候我们都会用 emoji 代替文字来聊天,既而来传达自己想要表达的一切,作为一名程序员,常用的代码托管平台 GitHub 中也是可以使用 emoji 表情的~ 😜
 

### 规范

执行`git commit`时使用 emoji 为本次提交打上一个标签, 使得此次 commit 的主要工作得以凸现,也能够使得其在整个提交历史中易于区分与查找,添加了 emoji 表情的提交记录真的能包含很多有用信息,阅读体验非常棒. 但是,emoji 表情在提交代码的时候也不能乱用,否则容易造成误解. 因此开源项目 [gitmoji](https://gitmoji.carloscuesta.me/) 专门规定了在 GitHub 提交代码时应当遵循的 emoji 规范~ 更多信息请参考 :[传送门]( https://github.com/carloscuesta/gitmoji/)


|               emoji               |           emoji代码           |         commit描述         |
| :-------------------------------: | :---------------------------: | :------------------------: |
|            🎨 (调色板)             |            `:art:`            |   改进代码结构/代码格式    |
|              ⚡️(闪电)              |            `:zap:`            |          提高性能          |
|             🔥 (火焰)              |           `:fire:`            |       移除代码或文件       |
|              🐛 (bug)              |            `:bug:`            |          修复 bug          |
|            🚑 (急救车)             |         `:ambulance:`         |        关键修补程序        |
|             ✨ (火花)              |         `:sparkles:`          |         引入新功能         |
|            📝 (备忘录)             |           `:memo:`            |          撰写文档          |
|             🚀 (火箭)              |          `:rocket:`           |          部署功能          |
|             💄 (口红)              |         `:lipstick:`          |     更新 UI 和样式文件     |
|             🎉 (庆祝)              |           `:tada:`            |          初次提交          |
|          ✅ (白色复选框)           |     `:white_check_mark:`      |          更新测试          |
|              🔒 (锁)               |           `:lock:`            |        解决安全问题        |
|            🍎 (红苹果)             |           `:apple:`           |    修复 macOS 下的问题     |
|             🍏(青苹果)             |        `:green_apple:`        |     修复 iOS 下的问题      |
|             🐧 (企鹅)              |          `:penguin:`          |    修复 Linux 下的问题     |
|             🏁 (旗帜)              |      `:checkered_flag:`       |   修复 Windows 下的问题    |
|             🤖(机器人)             |           `:robot:`           |    修复 androd 下的问题    |
|             🔖 (书签)              |         `:bookmark:`          |       发行/版本标签        |
|            🚨 (警车灯)             |      `:rotating_light:`       |      移除 linter 警告      |
|             🚧 (施工)              |       `:construction:`        |         工作进行中         |
|             💚 (绿心)              |        `:green_heart:`        |      修复 CI 构建问题      |
|           ⬇️ (下降箭头)            |        `:arrow_down:`         |          降级依赖          |
|           ⬆️ (上升箭头)            |         `:arrow_up:`          |          升级依赖          |
|             👷 (工人)              |    `:construction_worker:`    |      添加 CI 构建系统      |
|          📈 (上升趋势图)           | `:chart_with_upwards_trend:`  |     添加分析或跟踪代码     |
|             🔨 (锤子)              |          `:hammer:`           |          重大重构          |
|             ➖ (减号)              |     `:heavy_minus_sign:`      |        减少一个依赖        |
|             🐳 (鲸鱼)              |           `:whale:`           |      Docker 相关工作       |
|             ➕ (加号)              |      `:heavy_plus_sign:`      |        增加一个依赖        |
|             🔧 (扳手)              |          `:wrench:`           |        修改配置文件        |
|             🌐 (地球)              |   `:globe_with_meridians:`    |       国际化与本地化       |
|             ✏️ (铅笔)              |          `:pencil2:`          |         修复错别字         |
|            👌 (OK手势)             |          `:ok_hand:`          | 由于代码审查更改而更新代码 |
|        :see_no_evil:(捂脸)        |        `:see_no_evil:`        |  添加或更新.gitignore文件  |
|         :seedling:(种子)          |         `:seedling:`          |     添加或更新种子文件     |
|        :wastebasket:(垃圾)        |        `:wastebasket:`        | 不赞成使用的代码需要清理。 |
|           :dizzy:(信心)           |           `:dizzy:`           |    添加或更新动画和过渡    |
|         :goal_net:(警车)          |         `:goal_net:`          |          捕捉错误          |
|           :mag:(放大镜)           |            `:mag:`            |          改善SEO           |
|          :alembic:(洗澡)          |          `:alembic:`          |         尝试新事物         |
|       :camera_flash:(相机)        |       `:camera_flash:`        |       添加或更新快照       |
|     :children_crossing:(规则)     |     `:children_crossing:`     |   改善用户体验/可用性。    |
|    :busts_in_silhouette:(黑鬼)    |    `:busts_in_silhouette:`    |     添加或更新贡献者。     |
|           :mute:(禁用)            |           `:mute:`            |         删除日志。         |
|        :loud_sound:(扩音)         |        `:loud_sound:`         |      添加或更新日志。      |
|      :card_file_box:(文件夹)      |       `:card_file_box:`       |   执行数据库相关的更改。   |
|      :speech_balloon:(消息)       |      `:speech_balloon:`       |      更新文本和文字。      |
|           :beers:(啤酒)           |           `:beers:`           |      醉酒地编写代码。      |
|         :bulb:(灵光一闪)          |           `:bulb:`            |        记录源代码。        |
|           :truck:(移动)           |           `:truck:`           |     移动或重命名文件。     |
|     :page_facing_up:(许可证)      |      `:page_facing_up:`       |     添加或更新许可证。     |
|          :package:(纸箱)          |          `:package:`          |  更新编译的文件或软件包。  |
|           :boom:(爆炸)            |           `:boom:`            |       引入重大变化。       |
|           :bento:(资产)           |           `:bento:`           |      添加或更新资产。      |
|        :wheelchair:(轮椅)         |        `:wheelchair:`         |       改善可访问性。       |
| :twisted_rightwards_arrows:(分支) | `:twisted_rightwards_arrows:` |       合并分支机构。       |
|          :rewind:(回退)           |          `:rewind:`           |         还原更改。         |
|            :poop:(翔)             |           `:poop:`            |  编写需要改进的错误代码。  |
|          :pencil2:(铅笔)          |          `:pencil2:`          |        修正错别字。        |
|  :globe_with_meridians:(互联网)   |   `:globe_with_meridians:`    |      国际化和本地化。      |
|          :wrench:(扳手)           |          `:wrench:`           |       更改配置文件。       |
|     :heavy_minus_sign:(减号)      |     `:heavy_minus_sign:`      |        删除依赖项。        |
|      :heavy_plus_sign:(加号)      |      `:heavy_plus_sign:`      |        添加依赖项。        |
|           :whale:(海豚)           |           `:whale:`           |     关于Docker的工作。     |
|          :recycle:(病毒)          |          `:recycle:`          |         重构代码。         |
| :chart_with_upwards_trend:(趋势)  | `:chart_with_upwards_trend:`  | 添加或更新分析或跟踪代码。 |
|    :construction_worker:(工人)    |    `:construction_worker:`    |   添加或更新CI构建系统。   |
|          :pushpin:(书钉)          |          `:pushpin:`          |  将依赖项固定到特定版本。  |
|         :arrow_up:(提升)          |         `:arrow_up:`          |       升级依赖关系。       |
|        :arrow_down:(降低)         |        `:arrow_down:`         |        降级依赖性。        |
|      :green_heart:(绿色爱心)      |        `:green_heart:`        |        修复CI构建。        |
|      :rotating_light:(警灯)       |      `:rotating_light:`       |       删除棉绒警告。       |
|         :bookmark:(标签)          |         `:bookmark:`          |      发布/版本标签。       |