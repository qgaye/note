# zsh安装与配置

1. 安装zsh(Mac自带)，`chsh -s /bin/zsh`切换到zsh
2. 安装[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/)
3. 配置oh-my-zsh主题，在`~/.zshrc`中配置`ZSH_THEME=wezm+`，[更多主题](https://github.com/robbyrussell/oh-my-zsh/wiki/themes)
4. oh-my-zsh插件，`zsh-syntax-highlighting`和`zsh-syntax-highlighting`，并在`~/.zshrc`中配置`plugins=()`

```bash
// zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
// zsh-syntax-highlighting
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

5. `source ~/.zshrc`加载配置文件
6. 解决zsh目录权限问题

```bash
chmod 755 /usr/local/share/zsh
chmod 755 /usr/local/share/zsh/site-functions
```
