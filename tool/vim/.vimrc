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

" nord
Plug 'arcticicestudio/nord-vim'

" git信息
Plug 'tpope/vim-fugitive'

" 底部状态栏
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

" 顶部tab栏
Plug 'bagrat/vim-buffet'

" 缩进
Plug 'Yggdroot/indentLine'
let g:indentLine_char = '|'
autocmd Filetype json let g:indentLine_setConceal = 0

" 展示文件每行git状态
Plug 'airblade/vim-gitgutter'

" 彩虹括号
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

" comment
Plug 'scrooloose/nerdcommenter'

" iterm2中光标正确显示
Plug 'sjl/vitality.vim'

" vim初始化界面
Plug 'mhinz/vim-startify'

call plug#end()

" 设置nord配色
colorscheme nord

" 模式切换时的延迟
set ttimeout
set ttimeoutlen=10
