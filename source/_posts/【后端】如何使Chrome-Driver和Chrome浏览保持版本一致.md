---
title: 【后端】如何使Chrome Driver和Chrome浏览器保持版本一致
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2959232490
tags:
  - chromedriver
categories:
  - 后端
date: 2023-08-29 19:25:33
img:
coverImg:
password:
summary:
---

## 前言

近期，我开发了一款能够自动发布文章到微信公众号的程序。在该程序中，我使用了自动化框架 `selenium`，同时需要使用到驱动程序 `chromedriver`。然而，其中一个问题是随着 `Chrome` 浏览器的自动更新，`chromedriver` 驱动程序的版本可能无法与之保持一致。为了解决这个问题，我花了一些时间编写了下面的小程序，以确保 `Chrome` 浏览器和 `chromedriver` 驱动程序始终保持版本同步。

## 开发参考

* [chromedriver驱动官网](https://chromedriver.chromium.org/downloads/version-selection)
* [chromedriver最新驱动版本地址，含开发版和预览版](https://googlechromelabs.github.io/chrome-for-testing/#stable)
* [chromedriver驱动最新版本api地址](https://github.com/GoogleChromeLabs/chrome-for-testing#json-api-endpoints)

### 示例代码

~~~java
package com.mobaijun.actual;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.lang.Console;
import cn.hutool.core.util.ZipUtil;
import cn.hutool.http.HttpUtil;
import com.mobaijun.constant.Constant;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * software：IntelliJ IDEA 2023.1.1<br>
 * class name: UpdateChromeDriverActual<br>
 * class description: 自动更新chromedriver驱动和Google浏览器保持一致
 *
 * @author MoBaiJun 2023/7/16 20:50
 */
public class UpdateChromeDriverActual {

    /**
     * 根据目录获取Google浏览器版本
     *
     * @param directoryPath 目录地址
     * @return 浏览器版本号
     */
    public static String getInstalledChromeVersion(String directoryPath) {
        List<String> subdirectories = new ArrayList<>();
        try {
            Files.list(Path.of(directoryPath))
                    .filter(Files::isDirectory)
                    .forEach(path -> subdirectories.add(path.getFileName().toString()));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return subdirectories.get(0);
    }

    private static void downloadAndInstallChromeDriver(String chromeVersion) {
        try {
            // 构建ChromeDriver的版本URL
            String latestReleaseUrl = "https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_" + chromeVersion.split("\\.")[0];
            // 获取最新版本号
            String latestVersion = HttpUtil.get(latestReleaseUrl).trim();
            // 构建ChromeDriver下载URL
            String downloadUrl = "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/" + latestVersion + "/win64/chromedriver-win64.zip";

            // 设置下载的压缩文件路径
            String zipFilePath = Constant.RESOURCES_PATH + File.separator + "chromedriver.zip";
            // 设置解压后的目录路径
            String unzipDirectory = Constant.RESOURCES_PATH + File.separator + "chromedriver";

            // 使用 Hutool 下载文件
            HttpUtil.downloadFile(downloadUrl, zipFilePath);

            // 使用 Hutool 解压缩文件到目标目录
            ZipUtil.unzip(zipFilePath, unzipDirectory);

            // 删除下载的压缩文件
            FileUtil.del(zipFilePath);

            // 将解压后的ChromeDriver移动到Google目录
            FileUtil.move(new File(unzipDirectory), new File(Constant.CHROME_DRIVER_UPDATE_PATH), true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        String chromeVersion = getInstalledChromeVersion(Constant.CHROME_VERSION);
        if (chromeVersion != null) {
            downloadAndInstallChromeDriver(chromeVersion);
            Console.log("Google Chrome driver updated successfully!");
        } else {
            Console.error("Unable to get Chrome browser version number. Make sure Chrome is installed and able to connect to the internet.");
        }
    }
}
~~~

> 需要注意的是，`getInstalledChromeVersion` 方法用于获取 Windows 系统上已安装的 Chrome 浏览器的最新版本号。该方法基于默认的安装路径，如果安装路径不同，需要相应地进行修改。`downloadAndInstallChromeDriver` 方法主要用于比对获取到的 Chrome 浏览器版本与最新的 `chromedriver` API 版本是否一致，如果不一致，则进行更新。随后，它会下载并将 `chromedriver` 安装到指定的路径中。在代码中，我使用了 Hutool 这个第三方库来进行文件下载和解压操作。经过多次测试，代码正常运行。
