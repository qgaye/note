# CSS选择器

## CSS选择器语法

### 基础选择器

- `*{}` 通用元素选择器，匹配任何元素
- `E{}` 标签选择器，匹配所有使用E标签的元素
- `.info{}` 类选择器，匹配所有class属性中包含info的元素
- `#info{}` id选择器，匹配所有id属性等于info的元素

### 组合选择器

- `E,F` 多元素选择器，同时匹配所有E元素或F元素，E和F之间用逗号分隔
- `E F` 后代元素选择器，匹配所有属于E元素后代的F元素，E和F之间用空格分隔
- `E > F` 子元素选择器，匹配所有E元素的子元素F
- `E + F` 毗邻元素选择器，匹配所有紧随E元素之后的同级元素F

### 属性选择器

- `E[attr]` 匹配所有具有attr属性的E元素，不考虑它的值
- `E[attr=val]` 匹配所有attr属性等于val的E元素
- `E[attr~=val]` 匹配所有attr属性具有多个空格分隔的值、其中一个值等于val的E元素
- `E[attr|=val]` 匹配所有attr属性具有多个连字号分隔（-）的值、其中一个值以"val"开头的E元素
- `E[attr^=val]` 匹配所有attr属性值以val开头的E元素
- `E[attr$=val]` 匹配所有attr属性值以val结尾的E元素
- `E[attr*=val]` 匹配所有attr属性值包含val的E元素

### 伪属性选择器

- `E::before` 在E元素之前插入生成的内容
- `E::after` 在E元素之后插入生成的内容
- `E::first-line` 匹配E元素的第一行
- `E::first-letter` 匹配E元素的第一个字母

### 伪类选择器

- `E:first-child` 匹配E元素的第一个子元素
- `E:link` 匹配E元素所有未被点击的链接
- `E:visited` 匹配E元素所有已被点击的链接
- `E:active` 匹配鼠标已经其上按下、还没有释放的E元素
- `E:hover` 匹配鼠标悬停其上的E元素
- `E:focus` 匹配鼠标悬停其上的E元素
- `E:enabled` 匹配表单中激活的元素
- `E:disabled` 匹配表单中禁用的元素
- `E:checked` 匹配表单中被选中的radio（单选框）或checkbox（复选框）元素
- `E:selection` 匹配用户当前选中的元素

### 否定伪类选择器

- `:not(E)` 匹配不是E元素的所有元素

### 结构性伪类选择器

- `E:root` 匹配文档的根元素，对于HTML文档，就是HTML元素
- `E:nth-child(n)` 匹配其父元素的第n个子元素，第一个编号为1
- `E:nth-last-child(n)` 匹配其父元素的倒数第n个子元素，第一个编号为1
- `E:nth-of-type` 与`:nth-child()`作用类似，但是仅匹配使用同种标签的元素
- `E:nth-last-of-type` 与`:nth-last-child()`作用类似，但是仅匹配使用同种标签的元素
- `E:last-child` 匹配父元素的最后一个子元素，等同于`:nth-last-child(1)`
- `E:first-of-type` 匹配父元素下使用同种标签的第一个子元素，等同于`:nth-of-type(1)`
- `E:last-of-type` 匹配父元素下使用同种标签的最后一个子元素，等同于`:nth-last-of-type(1)`
- `E:only-child` 匹配父元素下仅有的一个子元素，等同于`:first-child:last-child`或 `:nth-child(1):nth-last-child(1)`
- `E:only-of-type` 匹配父元素下使用同种标签的唯一一个子元素，等同于`:first-of-type:last-of-type`或`:nth-of-type(1):nth-last-of-type(1)`
- `E:empty` 匹配一个不包含任何子元素的元素，注意，文本节点也被看作子元素

## CSS选择器优先级

CSS选择器优先级按一下四个规则依次比较优先级

### 规则一

`!important` 优先级最高

### 规则二

优先级高低(编号越小优先级越高) ：

1. 内联样式 `<div style=""></div>`
2. 内部样式 `<style type="text/css"></style>`
3. 外部样式 `<link type="text/css" />`
4. 浏览器默认样式

### 规则三

选择器权重(编号越小权重越高)：

1. ID选择器 `(1, 0, 0)`
2. 类/属性/伪类选择器 `(0, 1, 0)`
3. 元素/伪元素选择器 `(0, 0, 1)`
4. 其他选择器 `(0, 0, 0)`

**不进位比较法：**`(x, y, z)`首先比较`x`的值，若`x`值相同比较`y`，若`y`值相同比较`z` 

```css
/* 权重为(1, 0, 0) 优先级第二 */
#info {}
/* 权重为(1, 1, 0) 优先级第一 */
#info .message{}
/* 权重为(0, 11, 0) 优先级第三 */
.c1 .c2 .c3 .c4 .c5 .c6 .c7 .c8 .c9 .c10 .c11{}
```

### 规则四

权重相同，后写的生效

## CSS选择器性能

### 浏览器如何让找到你的选择器？

浏览器读取你的选择器，遵循的原则是从选择器的右边到左边读取

对于`div#divBox p span.red`的查找顺序：

1. 查找页面中所有`class=red`的`span`元素
2. 查找结果1中的父元素中是否有`p`元素
3. 查找结果2中的父元素中是否有`id=divBox`的`div`元素

如果以上3步都能找到相应的结果，那么则会给匹配的最终结果应用相关的css样式

### CSS选择器的效率

越具体的关键选择器，其性能越高

1. id选择器 `#header`
2. 类选择器 `.main`
3. 类型选择器 `div`
4. 兄弟选择器 `div + p`
5. 子元素选择器 `div > p`
6. 包含选择器 `div span`
7. 通配选择器 `div *`
8. 属性选择器 `input[type="text"]`
9. 伪类选择器 `a:hover,ul:nth-child(2n)`

