set nocompatible "关闭vi兼容模式

"语法高亮
syntax enable
syntax on

set showmode
set showcmd

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set t_Co=256

"文件类型侦测
filetype on
filetype plugin on
filetype indent on

set autoread "自动更新外部改动

"使用鼠标
set mouse=a
set selection=exclusive
set selectmode=mouse,key

"set autoindent "自动缩进

"设置tab为4个空格
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

"开启行号和当前行高亮
set number
set cursorline

set showmatch "高亮显示匹配的括号

"搜索字符高亮
set hlsearch
"不区分大小写
set ignorecase
set smartcase

set nobackup
set nowritebackup
set noswapfile

set history=128

"命令补全
set wildmenu

"显示光标当前位置
set ruler

"总是显示状态栏
set laststatus=2
