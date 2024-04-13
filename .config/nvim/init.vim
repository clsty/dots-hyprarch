filetype plugin indent on
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set scrolloff=5

set incsearch
set smartcase
set autoread

set wrap
set ruler
set relativenumber
set cursorline


" Important!!
if has('termguicolors')
  set termguicolors
endif
set background=dark
" Set contrast.
" This configuration option should be placed before `colorscheme sonokai`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:sonokai_background = 'soft'
" For better performance
let g:sonokai_better_performance = 1
let g:sonokai_transparent_background=1
colorscheme sonokai
