# Rust杂录

## rustup

将当前项目使用的rust版本设置为nightly `rustup override set nightly`

## 格式化打印

```rust
println!("{}", x)    // x impl Display
println!("{:?}", x)  // x impl Debug
println!("{:p}", x)  // 指针
println!("{:b}", x)  // 二进制
println!("{:o}", x)  // 八进制
println!("{:x}", x)  // 十六进制
```

## Trait和Struct同名方法调用

```rust
struct S;
impl S {
    fn print(&self) { println!("print in S"); }
}
trait P {
    fn print(&self);
}
impl P for S {
    fn print(&self) { println!("print in P"); }
}
fn main() {
    let s = S {};
    s.print();   // print in S
    P::print(&s);   // print in P
}
```

```rust
struct S;
impl S {
    fn print() { println!("print in S"); }
}
trait P {
    fn print();
}
impl P for S {
    fn print() { println!("print in P"); }
}
fn main() {
    S::print();   // print in S
    <S as P>::print();   // print in P
}
```

## self和Self

Self表示调用者的类型
self表示调用该方法的对象，类似this的作用，self作为参数时无需标注类型，因为self本质是语法糖

```rust
// 以下两两等价
fn f(self)
fn f(self: Self)

fn f(&self)
fn f(self: &Self)

fn f(&mut self)
fn f(self: &mut Self)
```

