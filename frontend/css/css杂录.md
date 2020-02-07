# CSS杂录

## CSS3动画

```css
transition: all 1s ease-in
```

`@keyframes`通过定义关键帧样式来控制动画

```css
@keyframes show-item{
    0% {
        /* something */
    }
    50% {
        /* something */
    }
    10% {
        /* something */
    }
}
```

`animation`来使用指定动画，`forwards`表示该动画的最后样式将被保留

```css
animation: show-item 1s ease-in forwards
```