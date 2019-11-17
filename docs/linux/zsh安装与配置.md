# zsh安装与配置

## 安装zsh

`Debian` -> `sudo apt-get install zsh`

`Redhat` -> `sudo yum install zsh`

`Mac` -> 系统自带

## 安装oh-my-zsh

[oh-my-zsh的GitHub主页](https://github.com/robbyrussell/oh-my-zsh/)

自动安装 :

```bash
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
```

手动安装 :

```bash
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

## 配置zsh主题

在[zsh主题](https://github.com/robbyrussell/oh-my-zsh/wiki/themes)中找到自己中意的一款，在`~/.zshrc`中将`ZSH_THEME`设置为主题名

使用`source ~/.zshrc`来更新配置

> 在`ZSH_THEME`的`=`右边一定不要有空格，否则会报错找不到此主题

```bash
ZSH_THEME="wezm"
```

## zsh插件配置

在[zsh插件](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins)中找到自己中意的插件，在`~/.zshrc`中将插件名配置入`plugins=()`中即可

使用`source ~/.zshrc`来更新配置

> 在`plugins=()`的括号中配置多个插件，直接用回车隔开即可

### zsh-syntax-highlighting

高亮可用命令，会用不同颜色显示命令是否可执行

`oh-my-zsh`用户：

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### zsh-autosuggestions

记录曾使用的命令，并自动提示

```bash
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

### autojump

快速跳转到指定目录

```bash
brew install autojump
# 在.zshrc中新增一行
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
```

### last-working-dir

记录上一次退出命令行时候的所在路径

并且在下一次启动命令行的时候自动恢复到上一次所在的路径

### sudo

连续按两次`Esc`添加或删除`sudo`

### extract

使用一个解压命令`x`解决所有解压问题

### pip

自动匹配包名
