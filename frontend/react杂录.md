# React杂录

## JSX

JSX中自定义的标签必须大写

JSX必须被包裹在一个标签中，即最外层不能包含多个标签

如果不希望在最外层展示仅仅用来包裹的标签，那么可以使用React中的Fragment代替在最外层包裹的div标签

## return中的JSX

若在return后需要返回多行的JSX，则需要在return后加上括号，在括号内就可以进行多行返回了

## 组件书写方式

### 函数

```js
function Welcome(props) {
  return <h1>Hello, { props.name }</h1>;
}
```

### class

```js
class Welcome extends React.Component {
  render() {
    return <h1>Hello, { this.props.name }</h1>;
  }
}
```

## class中自定义数据

在该class中添加参数为props的构造函数，并在其中调用父类构造函数

自定义数据定义在`state`中

```js
constructor(props) {
    super(props);
    this.state = {
        // key: value
    }
}
```

## 在JSX中调用函数

在JSX中调用类的函数，由于不是由该类的实例对象调用，因此在执行时this为undefined

因此需要显式为该方法绑定this对象 `method.bind(object)`

建议将所有this绑定都放在构造函数内`constructor(props)`中

## 为自定义数据赋值

不能直接使用等号赋值，必须使用`this.setState()`方法

```js
this.setState({
    // key: value
})
```

在React16中推荐使用`this.setState(() => {})`传递函数的形式来赋值

```js
this.setState(() => {
    return {
        foo: 'Hello'
    };
})
```

当然在ES6中可以使用括号来代替return关键词

```js
this.setState(() => ({
        foo: 'Hello'
    })
)
```

## JSX中书写注释

```js
{ /* 这里
    写注释 */ }
```

```js
{
    // 这里写
    // 注释
}
```

## JSX解析html标签

解析变量中的html标签(默认不解析)

设置标签的`dangerouslySetInnerHTML`属性，花括号中的花括号表示是一个js对象

```js
<li 
    dangerouslySetInnerHTML={{__html: 变量名}}>
</li>
```

## 父组件向子组件传值

父组件

```js
<ChildComponent content={ variable } />
```

子组件

```js
{this.props.content}
```

以上content是自己命名的，只要父组件在调用子组件时在标签中添加了自命名的属性，在子组件中可以通过`this.props.父组件命名的属性名`来获取

当然也可以通过属性传递函数给子组件，但注意在父组件传递时，使用`.bind(this)`绑定上，否则子组件调用时，this是找不到该函数的

## props的类型校验和默认值

导入PropTypes

```js
import PropTypes from 'prop-types'
```

校验类型 [官网说明](https://reactjs.org/docs/typechecking-with-proptypes.html)

```js
Item.propTypes = {  // Item是组件class
    foo: PropTypes.string,  // 类型是字符串
    bar: PropTypes.func.isRequired,  // 类型是函数，且必选
    key: PropTypes.oneOfType([PropTypes.string, PropTypes.number])  // 既可以是字符串也可以是数字
    key: PropTypes.arrayOf(PropTypes.string, PropTypes.number)  // 类型是数组，数组中既可以是字符串也可以是数字
}
```

默认值 [官网说明](https://reactjs.org/docs/typechecking-with-proptypes.html#default-prop-values)

```js
Item.defaultProps = {
    foo: 'foo'  // 该属性默认值
}
```

## state，props，render三者关系

当组件的state或props(父组件给子组件传递时)发生改变时，render函数就会被重新执行

当父组件的render函数执行一次，所有子组件的render函数都会重新执行一次

## 虚拟DOM

虚拟DOM本质上就是个js对象，该对象用来描述真实的DOM

1. state数据
2. JSX模版
3. 生成虚拟DOM `['div', {}, 'hello']` (损耗了性能)
4. 通过虚拟DOM生成真实的DOM显示 `<div>hello</div>`
5. state发生变化
6. 数据 + 模版生成了新的虚拟DOM `['div', {}, 'bye']` (极大提升了性能)
7. 比较原始虚拟DOM和新的虚拟DOM的区别，找到是div中内容发生了变化 (极大提升了性能)
8. 直接操作DOM树，修改div内容

在整个步骤中，虽然生成虚拟DOM树损失了一定性能，但用虚拟DOM做比较比真实DOM做比较性能强很多(等于是js对象比较)，且虚拟DOM生成性能也更好(等于生成个新js对象)，因此React通过虚拟DOM极大的提升了渲染性能

## 虚拟DOM的diff

`this.setState()`异步的原因：

如果多次`setState()`间隔很近，那么就可以合并成一次再做diff，提高性能

虚拟DOM中diff算法：

同层比较，从根节点开始新旧虚拟DOM树同层做比较，只要比较到某一层发现值不同，就将该层及其子节点一起重新渲染

虚拟DOM的for中需要key的原因：

因为如果同层中节点很多(比如for循环生成了很多)，那么比较时新旧虚拟DOM树不知道哪个节点对应的哪个节点，就不得不一一比较，损耗性能，但如果给它们都设定一个独一的key，那么新旧虚拟DOM比较时就清楚哪个节点该和哪个节点比较了，提高了性能

for中的key不应该使用index的原因：

因为此时节点的key和index做了绑定，但是index值依赖于数组，而数组无疑是会变的，那么在做新旧虚拟DOM比较时，key=3的节点还是比较新的key=3节点，而新虚拟DOM树的数组很有可能发生变化，index=3的元素变成了别的元素，那么新虚拟DOM树中key=3也变了，此时比较肯定是不同的，那么就会去做重新渲染，将没有改变的节点做重新渲染，毫无疑问是浪费性能的

## ref获取DOM节点

ref参数填写的是一个匿名函数，该匿名函数接受一个参数，该参数即该节点

将该div节点绑定到`this.div`上，匿名函数的div参数即表示该div节点，接着在匿名函数内部将个div绑定到`this.div`上

```js
<div ref = { (div) => { this.div = div } }>
```

ref与setState的使用

由于`this.setState()`函数是异步的，因此虚拟DOM的生成是不及时的，因此如果希望在setState后使用ref的节点，那么就必须在setState的回调函数中使用(setState的第二个参数即接受一个回调函数)，不然会存在数据延迟的问题

## 生命周期函数

生命周期函数：在某一时刻组件会自动执行的函数

[React生命周期函数图](http://projects.wojtekmaj.pl/react-lifecycle-methods-diagram/)

![React16.4生命周期图](./pics/react_lifecycle.png)

## AJAX

使用第三方axios包，通过`yarn add axios`添加到当前项目

```js
import axios from 'axios';
axios.get('url')
    .then(() => { 
        // success 
    }).catch(() => { 
        // failed 
    })
```

在React中建议将AJAX请求都放在`componentDidMount()`该生命周期函数中

## Mockjs

在开发中使用Mockjs来mock请求返回的数据，通过`yarn add mockjs`导入依赖

[Mock示例](http://mockjs.com/examples.html)

```js
import Mock, { Random } from 'mockjs';
Mock.mock('url', {
    // mock的内容
})
```

最后在React中import该文件即可

## Chrome调试插件

[React调试工具插件](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi)

图标为红色就表示该网站是开发阶段，启用了该插件，在F12中能找到Component界面

Component界面中`Highlight updates when components render`开启表示每个组件渲染时会高亮




## UI组件/容器组件/无状态组件

UI组件：只负责渲染的组件

容器组件：负责业务上的数据处理

无状态组件：整个组件只有一个render函数，此时可以写成一个接受props参数的箭头函数

无状态组件相对于其他组件来说，没有了其他的生命周期函数，因此性能更好

```js
const ComponmentName = props => {
    return (
        // jsx
    )
}
export default ComponentName;
```

## 设置body和html的css

需求将body大小默认为页面大小，此时需要将html和body的width和height都设置为100%

在最外层组件中的`componentWillMount`方法中设置

```js
componentWillMount() {
  document.documentElement.style.height = '100%';
  document.documentElement.style.width = '100%';
  document.body.style.height = '100%';
  document.body.style.width = '100%';
}
```


