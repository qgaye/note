# Rust杂录

## rustup

将当前项目使用的rust版本设置为nightly `rustup override set nightly`

## 格式化打印

```rust
println!("{}", x)    // x implement Display
println!("{:?}", x)  // x implement Debug
println!("{:p}", x)  // 指针
println!("{:b}", x)  // 二进制
println!("{:o}", x)  // 八进制
println!("{:x}", x)  // 十六进制
```

