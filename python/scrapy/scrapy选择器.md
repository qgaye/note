# Scrapy选择器

## `Selector`基本方法

**`Selector`选择器支持嵌套查询**

- `xpath()` : 传入xpath表达式，返回该表达式所对应的所有节点的selector list列表
- `css()` : 传入CSS表达式，返回该表达式所对应的所有节点的selector list列表
- `extract()` : 序列化该节点为unicode字符串并返回list
- `extract_first()` : 返回`extract()`中的第一个值(str)
- `re()` : 根据传入的正则表达式对数据进行提取，返回unicode字符串list列表

## 获取标签中的指定属性值

```html
<a title="hello" href="http://google.com">test</a>
```

- 获取`title`值：`response.css('a::attr(title)')` => `hello`
- 获取`href`值：`response.css('a::attr(href)')` => `http://google.com`
- 获取标签内的值：`response.css('a::text')` => `test`
