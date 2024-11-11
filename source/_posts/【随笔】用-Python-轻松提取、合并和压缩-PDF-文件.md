---
title: 【随笔】用 Python 轻松提取、合并和压缩 PDF 文件
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 778845342
tags:
  - 自动化
  - Python
categories:
  - 随笔
date: 2024-11-11 09:40:48
img:
coverImg:
password:
summary:
---

> 在日常的工作或项目中，`PDF` 文件处理往往是非常常见的任务。例如，你可能需要从一个大的 `PDF` 文件中提取特定的页面、根据内容合并页面，或者将这些文件压缩以减小存储空间。今天，我将介绍一个利用 `Python` 实现的自动化脚本，它不仅能够提取 `PDF` 内容，还能合并相同内容的页面，并在完成后压缩生成的文件。

在这篇博客中，我将展示如何通过以下步骤实现 `PDF` 文件的批量处理：

- 提取每一页的第二行内容。
- 根据内容将相同页面合并为一个 `PDF`。
- 压缩最终生成的 `PDF` 文件。

## 所需工具

在实现这个任务之前，我们需要安装一些 `Python` 库：

- `pdfplumber`：用于从 `PDF` 中提取文本内容。
- `PyPDF2`：用于操作 `PDF` 文件（如合并、拆分等）。
- `PyMuPDF`（也称为 `fitz`）：用于压缩 `PDF` 文件，减少文件大小。

可以通过以下命令安装所需的库：

~~~bash
$ pip install pdfplumber PyPDF2 pymupdf
~~~

## 脚本概述

在我们的示例中，首先读取指定的 `PDF` 文件并提取每一页的第二行内容。根据第二行的内容（以空格分隔的第一个词），我们将相同内容的页面合并为一个新的 `PDF` 文件。最后，生成的 `PDF` 文件会被压缩，以减少文件的大小。

~~~python
import os
import pdfplumber
import fitz  # PyMuPDF
from PyPDF2 import PdfReader, PdfWriter

def extract_and_merge_pages(pdf_path):
    print("开始处理 PDF 文件，请稍等...")

    # 设置主输出文件夹
    output_dir = f"{os.path.splitext(os.path.basename(pdf_path))[0]}_merged_pages"
    os.makedirs(output_dir, exist_ok=True)

    # 字典存储内容标识与页面编号的映射
    content_page_map = {}

    # 第一步：提取每一页的第二行内容并分组
    with pdfplumber.open(pdf_path) as pdf:
        for page_num, page in enumerate(pdf.pages):
            text = page.extract_text()
            if text:
                lines = text.split('\n')
                # 确保有第二行内容
                if len(lines) > 1:
                    second_line = lines[1]

                    # 提取空格前的部分
                    content_key = second_line.split()[0]
                    # 将页码按内容标识分组
                    if content_key not in content_page_map:
                        content_page_map[content_key] = []
                    content_page_map[content_key].append(page_num)

    # 第二步：根据内容标识合并相应页面并保存为单个 PDF
    reader = PdfReader(pdf_path)
    for content_key, pages in content_page_map.items():
        writer = PdfWriter()
        for page_num in pages:
            writer.add_page(reader.pages[page_num])

        # 设置临时 PDF 文件路径
        temp_pdf_path = os.path.join(output_dir, f"{content_key}_temp.pdf")
        with open(temp_pdf_path, "wb") as temp_pdf_file:
            writer.write(temp_pdf_file)

        # 压缩 PDF 文件
        compressed_pdf_path = os.path.join(output_dir, f"{content_key}.pdf")
        compress_pdf(temp_pdf_path, compressed_pdf_path)

        # 删除临时未压缩的 PDF 文件
        os.remove(temp_pdf_path)
        print(f"已保存并压缩合并文件: {compressed_pdf_path}")

    print("处理完成，所有文件已保存至：", output_dir)

def compress_pdf(input_path, output_path):
    # 使用 PyMuPDF 读取和压缩 PDF
    doc = fitz.open(input_path)
    doc.save(output_path, garbage=4, deflate=True)
    doc.close()

# 示例使用
print("请输入PDF文件的路径，注意使用斜杠 (/) 作为路径分隔符。例如：C:/path/to/file.pdf")
pdf_path = input("路径：")
extract_and_merge_pages(pdf_path)
~~~

## 代码解析

### 1. 提取 PDF 内容

我们使用 `pdfplumber` 来提取 `PDF` 中的文本内容。通过遍历每一页，提取每一页的第二行文本，并将第二行中第一个空格之前的内容作为页面的标识符。

~~~python
with pdfplumber.open(pdf_path) as pdf:
    for page_num, page in enumerate(pdf.pages):
        text = page.extract_text()
        if text:
            lines = text.split('\n')
            if len(lines) > 1:
                second_line = lines[1]
                content_key = second_line.split()[0]
~~~

### 2. 根据内容合并页面

通过 `content_key`（即提取的第二行内容的第一个单词），我们将相同内容的页面编号进行分组。接下来，使用 `PyPDF2` 的 `PdfWriter` 将这些页面合并成一个新的 `PDF` 文件。

~~~python
reader = PdfReader(pdf_path)
for content_key, pages in content_page_map.items():
    writer = PdfWriter()
    for page_num in pages:
        writer.add_page(reader.pages[page_num])
~~~

### 3. 压缩 PDF 文件

压缩过程通过 `PyMuPDF`（`fitz`）实现。我们打开每个生成的临时 `PDF` 文件，并使用 `garbage=4` 清理冗余数据，`deflate=True` 启用压缩算法。

~~~python
doc = fitz.open(input_path)
doc.save(output_path, garbage=4, deflate=True)
doc.close()
~~~

## 使用说明

1. **路径输入**：用户需要输入 `PDF` 文件的完整路径，确保路径分隔符使用斜杠（`/`）或双反斜杠（`\\`）。
2. **自动化处理**：脚本会自动根据内容合并相同的页面，并生成压缩后的 `PDF` 文件，保存到指定目录。
3. **输出**：所有合并和压缩后的文件会保存在一个总文件夹中，文件名为内容的标识符。

### 总结

通过这篇文章，你已经学会了如何使用 `Python` 脚本自动化处理 `PDF` 文件：提取特定页面内容、合并相同内容的页面并压缩最终文件。这个方法在处理大批量 `PDF` 文件时非常有用，可以帮助你提高工作效率并节省存储空间。

> 希望这篇博客对你有所帮助！如果你有任何问题或建议，欢迎在评论区留言。
