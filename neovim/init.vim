" Source to run C:\Users\hr-aw\AppData\Local\nvim\init.vim

" let mapleader = " "     			" leader key is spacebar
set showcmd                         " the leader appear in the bottom right corner

call plug#begin('C:\Users\hr-aw\AppData\Local\nvim\plugged')

Plug 'tpope/vim-fugitive'				                " premier plugin for Git
Plug 'tpope/vim-surround'				                " quoting/parenthesizing made simple
Plug 'justinmk/vim-sneak'                               " jump to any location specified by two characters :help sneak
Plug 'easymotion/vim-easymotion'                        " a much simpler way to use some motions :help easymotion.txt
Plug 'scrooloose/nerdtree'				                " file system explorer
Plug 'mbbill/undotree'					                " visualizes undo history and branches
Plug 'itchyny/lightline.vim'			                " light and configurable statusline/tabline
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }	" code-completion engine
Plug 'mattn/emmet-vim'					                " improves HTML & CSS workflow
Plug 'leafgarland/typescript-vim'	                    " color and indenting better in TypeScript
Plug 'ryanoasis/vim-devicons'			                " adds file type icons to plugins

call plug#end()


" Clipboard WSL/win32yank
let s:win32yank = 'C:\Users\hr-aw\scoop\apps\win32yank\current\win32yank.exe'
let g:clipboard = {
            \  'name' : 'wsl',
            \  'copy' : {
            \    '+' : s:win32yank..' -i --crlf',
            \    '*' : s:win32yank..' -i --crlf',
            \  },
            \  'paste' : {
            \    '+' : s:win32yank..' -o --lf',
            \    '*' : s:win32yank..' -o --lf',
            \  },
            \}
unlet s:win32yank

" Enable color scheme
    autocmd vimenter * ++nested colorscheme slate
    let g:slate_terminal_italics=0
    " :colorscheme + Ctrl d " show available schemes
    " to solve white highlight from 'slate' colorscheme
    " delete from 'slate.vim' in the 'guibg=white' line, the ':hi PreProci'

" Path to run Python for YouCompleteMe
	let g:python3_host_prog = 'C:\Users\hr-aw\AppData\Local\Programs\Python\Python310\python.exe'


" Lightline colorscheme configuration
	let g:lightline = {
	      \ 'colorscheme': 'wombat',
	      \ }

" Basics:
	set number relativenumber 	    " turn hybrid line numbers on
	set nu rnu		        	    " put line numbers
	syntax on      		            " basic highligh for different languages
	set noerrorbells		        " no sound effects activated
	set tabstop=4 softtabstop=4	    " tab is only four characters long
	set shiftwidth=4		        " arrow key + over only four spaces
	set expandtab			        " convert from tab character to spaces
	set smartindent			        " do the best job to indent
	set smartcase			        " effectively case-sensitive searching until put a capital letter
	set incsearch			        " while you shearch you get results until you press ENTER
	set encoding=utf-8		        " required for YouCompleteMe
	set wildmode=longest,list,full	" enable autocompletion
	set splitbelow splitright	    " split open at the bottom and right

" Key mappings:
	inoremap <C-H> <C-\><C-O>b	    " move to the left in insert mode
	inoremap <C-L> <C-\><C-O>w	    " move to the right in insert mode

" Escape switching to normal mode
"    nnoremap <Leader>jk

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h                " move to the left split window
	map <C-j> <C-w>j                " move to the bottom split window
	map <C-k> <C-w>k                " move to the top split window
	map <C-l> <C-w>l                " move to the right split window

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck %<CR>

" Automatically deletes all trailing whitespace on save:
 	autocmd BufWritePre * %s/\s\+$//e

" YCM best part:
	nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR> 	" Go to definition/location of the command
	nnoremap <silent> <Leader>gf :YcmCompleter FixIt<CR>	" Fix (to review)
