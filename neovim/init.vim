" Source to run ~/.config/nvim/init.vim

" Basics:
	set number relativenumber		" turn hybrid line numbers on
	set nu rnu		       			" put line numbers
	syntax on						" basic highligh for different languages
	set noerrorbells		        " no sound effects activated
	set tabstop=4 softtabstop=4		" tab is only four characters long
	set shiftwidth=4		        " arrow key + over only four spaces
	set expandtab			        " convert from tab character to spaces
	set smartindent			        " do the best job to indent
	set smartcase			        " effectively case-sensitive searching until put a capital letter
	set incsearch			        " while you shearch you get results until you press ENTER
	set encoding=utf-8		        " required for YouCompleteMe
	set wildmode=longest,list,full		" enable autocompletion
	set splitbelow splitright		" split open at the bottom and right

" Key mappings:
	inoremap <C-H> <C-\><C-O>b		" move to the left in insert mode
	inoremap <C-L> <C-\><C-O>w		" move to the right in insert mode

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h				" move to the left split window
	map <C-j> <C-w>j				" move to the bottom split window
	map <C-k> <C-w>k				" move to the top split window
	map <C-l> <C-w>l				" move to the right split window

" Automatically deletes all trailing whitespace on save:
 	autocmd BufWritePre * %s/\s\+$//e