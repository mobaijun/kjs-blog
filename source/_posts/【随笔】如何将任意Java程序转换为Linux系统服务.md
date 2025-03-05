---
title: 【随笔】如何将任意 Java 程序转换为 Linux 系统服务
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 761234883
tags:
  - Linux Service
categories:
  - Linux
date: 2025-03-05 16:52:43
img:
coverImg:
password:
summary:
---

### ✨ 前言

> 最近接收了一个老项目,项目使用 SpringBoot 1.5 版本,Java 8 开发环境,需要部署在 Ubuntu 服务器,接手之前还在使用原始的
> nohup 方式启动应用,那么简单改造一下吧!

---

### 🚀 脚本内容

写一个 `install.sh` 脚本，内容如下：

```bash
#!/bin/bash

# 获取用户输入的 jar 包路径
read -p "请输入你的 Java 程序的 jar 包路径: " JAR_PATH

# 检查 jar 包是否存在
if [ ! -f "$JAR_PATH" ]; then
    echo "错误: 指定的 jar 包不存在！"
    exit 1
fi

# 获取 jar 包名称作为服务名
SERVICE_NAME=$(basename "$JAR_PATH" .jar)

# 查找 JDK 安装目录
JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")

# 检查是否找到 JDK
if [ -z "$JAVA_HOME" ]; then
    echo "错误: 未找到 Java 环境，请确保已安装 JDK！"
    exit 1
fi

# 创建 systemd 服务配置
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

sudo bash -c "cat > $SERVICE_FILE << EOL
[Unit]
Description=$SERVICE_NAME Java Service
After=network.target

[Service]
User=root
WorkingDirectory=$(dirname "$JAR_PATH")
ExecStart=$JAVA_HOME/bin/java -jar $JAR_PATH
SuccessExitStatus=143
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL"

# 重新加载 systemd 并启用服务
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

# 显示服务状态
sudo systemctl status $SERVICE_NAME

echo "$SERVICE_NAME 服务已成功创建并启动！"
# 提示用户常用命令
echo "\n服务已配置完毕！以下是常用命令："
echo "启动服务: sudo systemctl start $SERVICE_NAME"
echo "停止服务: sudo systemctl stop $SERVICE_NAME"
echo "重启服务: sudo systemctl restart $SERVICE_NAME"
echo "查看日志: sudo journalctl -u $SERVICE_NAME"
echo "开机自启: sudo systemctl enable $SERVICE_NAME"
echo "取消开机自启: sudo systemctl disable $SERVICE_NAME"
echo "查看服务状态: sudo systemctl status $SERVICE_NAME"
```

---

### 🎯 脚本功能概述

这个脚本的功能是：

1. **自动检测 JDK 版本和安装路径**。
2. **生成 Systemd 服务单元文件**。
3. **启用、启动、重启、停止 Java 服务**。
4. **方便开发者通过 jar 包路径配置服务**。

---

### ⚙️ 使用方法

1. **复制脚本到你的 Linux 服务器**。
2. **赋予执行权限**：
   ```bash
   sudo chmod +x install.sh
   ```
3. **执行脚本**：
   ```bash
   sudo ./install.sh
   ```
4. **输入 jar 包路径**，例如：
   ```
   请输入你的 Java 程序的 jar 包路径: /home/user/demo.jar
   ```

脚本会自动生成一个以 jar 包名命名的 systemd 服务，并启动它！

---

### 🏎️ 常用命令

脚本生成的服务之后，你就可以使用这些命令管理 Java 服务：

- **启动服务**：
  ```bash
  sudo systemctl start 服务名
  ```
- **停止服务**：
  ```bash
  sudo systemctl stop 服务名
  ```
- **重启服务**：
  ```bash
  sudo systemctl restart 服务名
  ```
- **查看状态**：
  ```bash
  sudo systemctl status 服务名
  ```
- **开机自启**：
  ```bash
  sudo systemctl enable 服务名
  ```
- **取消自启**：
  ```bash
  sudo systemctl disable 服务名
  ```

---

### 🐧 卸载服务

~~~shell
#!/bin/bash

# 获取用户输入的 jar 包路径
read -p "请输入你的 Java 程序的 jar 包路径: " JAR_PATH

# 检查 jar 包是否存在
if [ ! -f "$JAR_PATH" ]; then
    echo "错误: 指定的 jar 包不存在！"
    exit 1
fi

# 获取 jar 包名称作为服务名
SERVICE_NAME=$(basename "$JAR_PATH" .jar)

# 检查 systemd 服务文件是否存在
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
if [ ! -f "$SERVICE_FILE" ]; then
    echo "错误: 未找到 $SERVICE_NAME 的 systemd 服务配置文件！"
    exit 1
fi

# 停止服务
sudo systemctl stop $SERVICE_NAME

# 禁用服务
sudo systemctl disable $SERVICE_NAME

# 删除 systemd 服务配置
sudo rm -f "$SERVICE_FILE"

# 重新加载 systemd 配置
sudo systemctl daemon-reload

# 提示用户操作完成
echo "$SERVICE_NAME 服务已成功卸载！"

# 提示用户常用命令
echo "\n如需确认服务是否已移除，请使用以下命令："
echo "查看服务状态: sudo systemctl status $SERVICE_NAME"
echo "检查是否仍在开机启动列表: sudo systemctl list-unit-files | grep $SERVICE_NAME"
~~~

---

期待你的评论和反馈！😊
