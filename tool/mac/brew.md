# HomeBrew使用

## 通过brew安装openjdk

[AdoptOpenJDK GitHub](https://github.com/AdoptOpenJDK/homebrew-openjdk)

```bash
# 直接安装最新版本的openjdk
brew cask install adoptopenjdk
# 安装指定版本的openjdk
brew tap AdoptOpenJDK/openjdk
brew cask install [adoptopenjdk8 | adoptopenjdk9 | ...]
```

## 删除formula和其依赖

[homebrew-rmtree](https://github.com/beeftornado/homebrew-rmtree)

通过`brew tap beeftornado/rmtree`安装完成后就可以使用`brew rmtree [formula]`删除该formula及其未被其他formula依赖的依赖包
