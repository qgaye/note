# plantuml

## [时序图（sequence-diagram）](https://plantuml.com/zh/sequence-diagram)

参与者：actor，database，collections，participant等，通过as重命名，`participant Bob as user`即声明展示为Bob的participant，可以用user作为别名在代码中使用

箭头：`->`实线，`-->`虚线

箭头颜色：`-[#red]>`

发消息：`Alice -> Bob : say something`，冒号后面代表箭头上展示的文字，可以通过`\n`进行换行，也可以自己给自己发`Alice -> Alice`

文本对齐：让响应信息展示在箭头下方：`skinparam responseMessageBelowArrow true`

标题：`title`关键字，`title This is Title`

消息分组：`group` + `else` + `end`关键词

```plantuml
group 自定义标签1 [自定义标签2]
    Alice -> Bob : success
    group 自定义标签1 [自定义标签2]
        Alice -> Tom : hello
    end
else 自定义标签
    Alice -> Bob : fail
end
```

注释：`note left: something`或`note right: something`在左边或右边添加注释，也可以通过`note left/right` + `end note`添加多行注释

节点注释：`note over Alice, Bob: something`创建Alice和Bob节点上的注释

流程分隔：`== 分隔符 ==`

延迟：`...`

空间：`|||`或`||n||`指定数字n来增加箭头间的间距

生命线：`activate A`和`deactivate A`的方式激活和结束生命线，还可以通过`activate A #red`指定颜色；`return`可以生成一个消息并结束生命线，即简化消息和`deactivate`

生命线快捷语法：`++`激活、`--`结束、`**`创建目标，例`A -> B ++ : something`，`return`可以代替`--`

创建参与者：`create A`放在A第一次接受到消息前，强调本次消息在于创建了A

进入和发出消息：`[ -> A : something`和`A -> ] : something`表示从外部进入或发出消息到外部

参与者分组：`box`关键词

```plantuml
box 自定义分组 #red
participant Alice
participant Bob
end box
```

移除参与者脚注：`hide footbox`

## [活动图（activity-diagram）](https://plantuml.com/zh/activity-diagram-beta)

活动标签：`: something;`冒号 + 分号创建一个活动标签

箭头：`-[#red,hidden]-> something;`设置箭头样式和文字

开始结束：`start`开始，`end/stop`结束

条件：`if` + `then` + `elseif` + `else` + `endif`或`switch` + `case` + `endswitch`

```plantuml
if (自定义条件) then (自定义)
    :Text 1;
elseif (自定义条件) then (自定义)
    :Text 2;
else (自定义)
    :Text 3;
endif
```

```plantuml
switch (自定义条件)
case (自定义)
    :Text 1;
case (自定义)
    :Text 2;
endswitch
```

循环：`while` + `endwhile` + `is`

```plantuml
while (自定义条件) is (自定义)
    :Do Repeat;
endwhile (自定义)
    :Do Other;
```

并行：`fork` + `fork again` + `end fork`

```plantuml
fork 
    :Do 1;
fork again
    :Do 2;
end fork
```

分隔：`split` + `split again` + `end split`

```plantuml
split
    :A;
split again
    :B;
end split
```

分组：`partition 自定义分组 {}`

```plantuml
partition 自定义分组 {
    :A;
    :B;
}
```

泳道：`|#red|自定义泳道名|`

```plantuml
|泳道1|
:A;
|泳道2|
:B;
|泳道1|
:C;
```

移除箭头：在活动标签后加上`detach`即移除了箭头


