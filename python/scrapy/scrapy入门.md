# Scrapy入门

## 项目结构

- `scrapy.cfg` : 项目配置文件
- `PROJECT_NAME` : 该项目的python模块
- `PROJECT_NAME/items.py` : 项目中的item文件
- `PROJECT_NAME/pipelines.py` : 项目中的pipeline文件
- `PROJECT_NAME/settings.py` : 项目设置文件
- `PROJECT_NAME/spiders/` : 放置所有spider的目录

## 配置`settings.py`文件

### 关闭robot协议检查

将`ROBOTSTXT_OBEY`设为`False`

### 设置`User-Agent`

#### 方法一：修改`settings.py`中的`USER_AGENT`为要求值

#### 方法二：修改`settings.py`中的`DEFAULT_REQUEST_HEADERS`

```python
DEFAULT_REQUEST_HEADERS = {
  'User-Agent':'Mozilla/5.0'
}
```

#### 方法三：在spider中的`start_requests()`添加`header`

```python
def start_requests(self):
    header={'User-Agent':'Mozilla/5.0'}
    yield scrapy.Request(headers=header)
```

#### 方法四：每次Request时使用不同的`User_Agent`（以上三种方式只能在启动Scrapy时设定固定的`User_agent`）

在`settings.py`中的`MY_USER_AGENT`中，以list形式配置所有带使用的user-agent

```python
import scrapy
from scrapy import signals
from scrapy.downloadermiddlewares.useragent import UserAgentMiddleware
import random

class MyUserAgentMiddleware(UserAgentMiddleware):
    def __init__(self, user_agent):
        self.user_agent = user_agent

    @classmethod  
    def from_crawler(cls, crawler):
        return cls( user_agent=crawler.settings.get('MY_USER_AGENT') )

    def process_request(self, request, spider):
        agent = random.choice(self.user_agent)
        request.headers['User-Agent'] = agent
```

在`settings.py`中将自己定义的`Middleware`配置进去

```python
DOWNLOADER_MIDDLEWARES = {
    'ArticleSpider.middlewares.MyUserAgentMiddleware': 400  
}
```

## `items.py`

`items.py`是保存爬取到的数据的容器 (通过selector提取需要数据)

```python
import scrapy
class ArticlespiderItem(scrapy.Item):
    title = scrapy.Field()
    time = scrapy.Field()
```

## 编写一个爬虫`Spider`

所有编写的spider都位于`PROJECT_NAME/spider/`目录下

可使用`scrapy genspider SPIDER_NAME URL`命令创建，也可自行编写，继承`scrapy.Spider`

- `name` : 用于区别Spider，该名字必须是唯一的，不可以为不同的Spider设定相同的名字
- `allowed_domains` : 可爬取的域名列表
- `start_urls` : 包含了Spider在启动时进行爬取的url列表，第一个被获取到的页面将是其中之一，后续的URL则从初始的URL获取到的数据中提取
- `parse()` : 是spider的一个方法。 被调用时，每个初始URL完成下载后生成的 `Response` 对象将会作为唯一的参数传递给该函数。 该方法负责解析返回的数据(response data)，提取数据(生成item)以及生成需要进一步处理的URL的 `Request` 对象。

### 爬取`Response`返回值中的url

使用`Request`，`url`表示待爬取网址，`callback`表示回调函数（函数不加括号），`meta`表示通过字典形式将参数传入回调函数中，返回值与`parse()`中的`response`相同

```python
import scrapy
from scrapy.http import Request
class JobboleSpider(scrapy.Spider):
    name = 'jobbole'
    allowed_domains = ['jobbole.com']
    start_urls = ['http://web.jobbole.com/all-posts/']

    def parse(self, response):
        post_nodes = response.css('.post.floated-thumb .post-thumb a')
        for post_node in post_nodes:
            post_url = post_node.css('::attr(href)').extract_first()
            image_url = post_node.css('img::attr(src)').extract_first()
            yield Request(url=post_url, meta={'image_url': image_url}, callback=self.parse_detail)

    def parse_detail(self, response):
        item = ArticlespiderItem()
        item['title'] = response.css('.entry-header h1::text').extract_first()
        item['image'] = [response.meta.get('image_url')]
        yield item
```

## `pipelines.py`

`pipelines.py`是接受`item`的管道，并进行相应处理

### 配置使用的`pipeline`

打开`settings.py`，配置需要使用的`pipeline`

最后的数字表明该`pipeline`的优先级，数字越小，优先级越高

```python
ITEM_PIPELINES = {
   'ArticleSpider.pipelines.ArticlespiderPipeline': 1
}
```

### 使用Scrapy自带的`pipeline`，自行下载图片

在`items.py`中定义一个字段存放待下载的图片url

编辑`settings.py`，配置`ImagesPipeline`类

```python
ITEM_PIPELINES = {
   'scrapy.pipelines.images.ImagesPipeline': 1
}
# items中的字段名
IMAGES_URLS_FIELD = 'image'
# 图片保存路径
IMAGES_STORE = './images'
```

#### 注意

- 需安装`Pillow`包 => `pip install pillow`
- `IMAGE_URLS_FIELD`中的字段储存的必须是list

### 自定义`pipeline`

在自定义的`pipeline`中务必要在最后`return item`，否则其他的`pipeline`将无法再获取到`item`

需在`settings.py`中的 `ITEM_PIPELINES`中的list添加自定义的`pipeline`

Scrapy会自动调用函数名为`process_item()`的函数，函数名改变后无法被调用

### 使用`pipeline`将数据持久化

#### 同步存储

```python
import pymysql
class MysqlPipeline(object):
    conn = pymysql.connect(host=...)
    cursor = conn.cursor()
    cursor.execute('SQL', (ARGS))
    conn.commit()
```

#### 异步存储

```python
import pymysql
import pymysql.cursors
from twisted.enterprise import adbapi
class MysqlTwistedPipeline(object):
    def __init__(self, dbpool):
        self.dbpool = dbpool

    @classmethod
    def from_settings(cls, settings):
        dbparms = dict(
            host=settings['MYSQL_HOST'],
            ...,
            cursorclass=pymysql.cursors.DictCursor
        )
        pymysql.install_as_MySQLdb()
        dbpool = adbapi.ConnectionPool('MySQLdb', **dbparms)
        return cls(dbpool)

    def process_item(self, item, spider):
        self.dbpool.runInteraction(self.do_insert, item)

    def do_insert(self, cursor, item):
        insert_sql = '''
            INSERT INTO article (title, time)
            VALUE (%s, %s)
        '''
        cursor.execute(insert_sql, (item['title'], item['time']))
```

## 从`settings.py`中获取属性值

Scrapy会自动执行`from_settings()`函数，通过字典的方式获取属性值

```python
@classmethod
def from_settings(cls, settings):
    settings['SETTING_NAME']
```

## 在IDE中调试项目

当调试项目时，使用一个py文件代替项目启动命令

```python
from scrapy.cmdline import execute
# 将该项目添加到系统路径
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
# 启动爬虫，三个参数中最后一个参数为需要启动的spider名称
execute(['scrapy', 'crawl', 'jobbole'])
```

## 在Shell中尝试Selector选择器

在命令行中调试返回的`response`的值

在终端运行Scrapy时，一定记得给url地址加上引号，否则包含参数的url(例如 `&` 字符)会导致Scrapy运行失败

```python
# URL为待爬取的网址
scrapy shell URL
```
