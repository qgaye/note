# vim基础配置

## 基础配置

```text
" 显示行号
set number
" 代码高亮
syntax on
" 文件类型检查
filetype indent on
" 在底部显示当前模式
set showmode
" 在底部显示当前指令
set showcmd
" 突出显示当前行和当前列
set cursorline
set cursorcolumn
```

## 使用`Vim-Plug`管理插件

### 安装`Vim-Plug`

[Vim-Plug的GitHub](https://github.com/junegunn/vim-plug)

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### 在`~/.vimrc`配置所需插件

若插件是托管于GitHub的，只需要`Plug + '用户名 + 仓库名'`的形式即可

```bash
call plug#begin('~/.vim/plugged')

'' 配置自己需要的插件
Plug '[GitHub用户名 + 仓库名]'

call plug#end()
```

### 插件推荐

- [snow](https://github.com/nightsense/snow) 配色
- [lightline](https://github.com/itchyny/lightline.vim) 状态栏
- [rainbow](https://github.com/luochen1990/rainbow) 彩虹括号
- [vim-syntax-extra](https://github.com/justinmk/vim-syntax-extra) 代码高亮
- [nerdtree](https://github.com/scrooloose/nerdtre) 文件夹树状结构显示
- [nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin) NERDTree中git提示
- [vim-nerdtree-syntax-highlight](https://github.com/tiagofumo/vim-nerdtree-syntax-highlight) NERDTree高亮
- [vim-devicons](https://github.com/ryanoasis/vim-devicons) NERDTree图标
- [tagbar](https://github.com/majutsushi/tagba) 代码结构展示
- [auto-pairs](https://github.com/jiangmiao/auto-pairs) 括号自动生成匹配
- [fugitive](https://github.com/tpope/vim-fugitive) 在vim中使用git
- [vim-gitgutter](https://github.com/airblade/vim-gitgutter) 在文本边栏显示git状态
- [gv.vim](httpsL//github.com/junegunn/gv.vim) git log展示
- [nerdcommenter](https://github.com/scrooloose/nerdcommenter) 代码注释插件
- [vitality.vim](https://github.com/sjl/vitality.vim) 在iterm2中优化光标展示
- [vim-startify](https://github.com/mhinz/vim-startify) 优化vim启动界面
- [vim-buffet](https://github.com/bagrat/vim-buffet) 在顶栏显示tab标签
- [indentLine](https://github.com/Yggdroot/indentLine) 显示缩进线
- [fzf.vim](https://github.com/junegunn/fzf.vim) 模糊搜索文件
- [coc.nvim](https://github.com/neoclide/coc.nvim) vim自动补全
- [github-complete.vim](https://github.com/rhysd/github-complete.vim) emoji补全

### `Vim-Plug`管理插件命令

- `:PlugInstall` 安装插件
- `:PlugUpdate` 更新插件
- `:PlugClean` 清理被抛弃的插件

## 在终端模拟器中使用`Esc`会有延迟

在使用终端模拟器，如iterm2等在从`Insert`模式退回`Normal`模式时会有延迟，具体原因详见[awesome-vim](https://github.com/wsdjeg/vim-galore-zh_cn#%E5%9C%A8%E7%BB%88%E7%AB%AF%E4%B8%AD%E6%8C%89-esc-%E5%90%8E%E6%9C%89%E5%BB%B6%E6%97%B6)

解决方法：将转义时间设定的更短

```text
set ttimeout
set ttimeoutlen=10
```
