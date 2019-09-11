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

#### 1. [snow](https://github.com/nightsense/snow) 配色

在`~/.vimrc`中配置为该配色（在插件配置之后）`colorscheme nord`

#### 2. [lightline](https://github.com/itchyny/lightline.vim) 状态栏

若要在状态栏中显示分支，需安装[fugitive](https://github.com/tpope/vim-fugitive)插件

#### 3. [rainbow](https://github.com/luochen1990/rainbow) 彩虹括号

使用`let g:rainbow_active = 1`自启动

#### 4. [vim-syntax-extra](https://github.com/justinmk/vim-syntax-extra) 代码高亮

#### 5. [nerdtre](https://github.com/scrooloose/nerdtre) 文件夹树状结构显示

使用`:NERDTreeToggle`打开

#### 6. [tagba](https://github.com/majutsushi/tagba) 代码结构展示

使用`:TagbarToggle`打开

#### 7. [auto-pairs](https://github.com/jiangmiao/auto-pairs) 括号自动生成匹配

#### 8. [fugitive](https://github.com/tpope/vim-fugitive) 在vim中使用git

#### 9. [nerdcommenter](https://github.com/scrooloose/nerdcommenter) 代码注释插件

- `<leader>cc` 注释单行
- `<leader>cs` 美化注释
- `<leader>cu` 取消注释

#### 10. [vitality.vim](https://github.com/sjl/vitality.vim) 在iterm2中优化光标展示

#### 11. [vim-startify](https://github.com/mhinz/vim-startify) 优化vim启动界面

#### 12. [vim-buffet](https://github.com/bagrat/vim-buffet) 在顶栏显示tab标签

#### 13. [indentLine](https://github.com/Yggdroot/indentLine) 显示缩进线

#### 14. [airblade/vim-gitgutter](https://github.com/airblade/vim-gitgutter) 在文本边栏显示git状态

#### 15. [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim) 模糊搜索文件

#### 16. [neoclide/coc.nvim](https://github.com/neoclide/coc.nvim) vim自动补全

- `coc-json`
- `coc-html`
- `coc-css`
- `coc-yaml`
- `coc-python`
- `coc-prettier`

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
