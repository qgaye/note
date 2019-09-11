# 新建Scrapy项目

## 环境搭建

### 1. `pip`安装`virtualenv`

```python
pip install virtualenv
```

### 2. 新建虚拟环境

- 使用`--no-site-packages`参数使Python环境中所有第三方包都不会被复制进虚拟环境
- 使用`-p`参数指定虚拟环境所使用的Python版本

```python
# VENV_NAME为自定义的虚拟环境名称
virtualenv VENV_NAME  
```

### 3. 进入虚拟环境

进入`VENV_NAME/Scripts`目录，使用`activate`启动虚拟环境，使用`deactivate`退出虚拟环境

通过`pip`命令安装所需包，此时所有的包都被安装在虚拟环境中

### 4. 在windows下安装scrapy包出错问题

下载安装`visual cpp build tools full`即可

## 新建Scrapy文件

```python
# PROJECT_NAME为自定义项目名称
scrapy startproject PROJECT_NAME  
```

## 新建爬虫文件

进入`PROJECT_NAME/PROJECT_NAME/spiders`目录下

```python
# SPIDER_NAME 新建爬虫的文件名
# URL 该爬虫爬取的网址
scrapy genspider SPIDER_NAME URL
```

## 启动Scrapy爬虫

```python
scrapy crawl SPIDER_NAME
```

### 在windwos下可能遇到的问题

报错`No module named 'win32api'` -> 安装`pypiwin32`

```python
pip install pypiwin32
```
