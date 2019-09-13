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
" 设置编码utf-8
set encoding=utf-8
" 启用256色
set t_Co=256
" 自动缩进
set autoindent
" Tab键为4空格
set tabstop=4
" 缩进格式为4空格
set shiftwidth=4
" 自动将Tab转为4空格
set expandtab
set softtabstop=4
" 关闭自动折行
set nowrap

" 显示状态栏
set laststatus=2
" 在状态栏中显示光标所在位置
set ruler

" 高亮搜索结果
set hlsearch
" 自动跳转到第一个匹配的结果
set incsearch
" 搜索时只小写字母忽略大小写，有大写字母则大小写敏感
set ignorecase
set smartcase

" 不创建备份文件 文件名后缀为~
set nobackup
" 不创建交互交换文件 .swp
set noswapfile

" 出错时不响铃
set noerrorbells

" 文件监视
set autoread

" vim命令自动补全
set wildmenu
set wildmode=longest:list,full

" 设置刷新时间
set updatetime=100

call plug#begin('~/.vim/plugged')

" ===== Nord配色 =====
Plug 'arcticicestudio/nord-vim'

" ===== 状态栏 =====
Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" ===== 顶部tab栏 =====
Plug 'bagrat/vim-buffet'

" ===== 缩进线 ======
Plug 'Yggdroot/indentLine'
let g:indentLine_char = '|'

" ===== git集成命令 Gdiff =====
Plug 'tpope/vim-fugitive'

" ===== git状态显示 =====
Plug 'airblade/vim-gitgutter'

" ===== git lg =====
Plug 'junegunn/gv.vim'

" ===== 彩虹括号 =====
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

" ===== 代码高亮 =====
Plug 'justinmk/vim-syntax-extra'

" ===== 树状文件夹 =====
Plug 'scrooloose/nerdtree'
" 修改树的显示图标
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeAutoCenter=1
" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1
" 显示隐藏文件
let g:NERDTreeHidden=1
" 快捷键F2
map <F2> :NERDTreeToggle<CR>

" ===== 文件树git支持 =====
Plug 'Xuyuanp/nerdtree-git-plugin'
" NERDTree-git提示
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

" ===== NERDTree高亮 =====
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" ===== NERDTree图标 =====
Plug 'ryanoasis/vim-devicons'

" ===== 代码结构显示 =====
Plug 'majutsushi/tagbar'
" 快捷键F8
nmap <F8> :TagbarToggle<CR>
let g:tagbar_width=40
let g:tagbar_autofocus=1
let g:tagbar_left = 0

" ===== 括号补全 =====
Plug 'jiangmiao/auto-pairs'

" ===== 注释 =====
" <leader>cc 注释单行
" <leader>cs 美化注释
" <leader>cu 取消注释
Plug 'scrooloose/nerdcommenter'

" ===== 在iterm2中正确显示光标样式 =====
Plug 'sjl/vitality.vim'

" ===== vim启动界面 ===== 
Plug 'mhinz/vim-startify'

" ===== 智能提示 =====
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" 在开启500ms后启动
let g:coc_start_at_startup=0
function! CocTimerStart(timer)
    exec "CocStart"
endfunction
call timer_start(500,'CocTimerStart',{'repeat':1})
" 大于0.5M文件禁用coc补全
let g:trigger_size = 0.5 * 1048576

augroup hugefile
  autocmd!
  autocmd BufReadPre *
        \ let size = getfsize(expand('<afile>')) |
        \ if (size > g:trigger_size) || (size == -2) |
        \   echohl WarningMsg | echomsg 'WARNING: altering options for this huge file!' | echohl None |
        \   exec 'CocDisable' |
        \ else |
        \   exec 'CocEnable' |
        \ endif |
        \ unlet size
augroup END

" ===== 模糊搜索 =====
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" ===== Emoji补全 =====
Plug 'rhysd/github-complete.vim'

call plug#end()

" 设置Format命令
command! -nargs=0 Format :CocCommand prettier.formatFile

" 设置配色
colorscheme nord

" 模式切换时的延迟
set ttimeout
set ttimeoutlen=10
