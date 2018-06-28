" ---------------------------------------------------------------------------
"	Noel Colon <ncolon20@gmail.com>
" ---------------------------------------------------------------------------
source $VIMRUNTIME/defaults.vim

set encoding=utf8
set nu "number"
set rnu "relativenumber"
set nowrap
set tabstop=4
set shiftwidth=4
set novisualbell
set belloff=all
set title
" set hlsearch
set backup
set undofile
set noswapfile

" Directory for session files
set directory=$HOME/.vim/tmp/
set backupdir=$HOME/.vim/tmp/
set undodir=$HOME/.vim/tmp/


let mapleader = "-"
let maplocalleader= "\\"

" Faster splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Resize vertical splits
nnoremap <localleader>] <ESC> :vertical resize +2 <CR>
nnoremap <localleader>[ <ESC> :vertical resize -2 <CR>

" Edit and refresh .vimrc
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :so $MYVIMRC<CR>

" nnoremap <Space> :noh<CR>

" Begin/end of line
nnoremap B ^
nnoremap E $

nnoremap <silent><leader>q :q<CR>

" Copy to System Clipboard
" Mac
nnoremap <silent><leader>ypwd :call system('pbcopy', expand('%'))<CR>
vnoremap <silent><leader>y y<ESC>:call system('pbcopy', @")<CR>
 
" Buffers
nnoremap <silent><leader>m :buffers<CR>
nnoremap <silent><leader>bn :bn<CR>
nnoremap <silent><leader>bp :bp<CR>
nnoremap <silent><leader>bd :bd<CR>

nnoremap <silent><Tab>h :tabprevious<CR>
nnoremap <silent><Tab>l :tabnext<CR>
nnoremap <silent><Tab>j :tabfirst<CR>
nnoremap <silent><Tab>k :tablast<CR>
nnoremap <silent><Tab><Tab> :tabnew<CR>
nnoremap <silent><Tab>q :tabclose<CR>

nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pc :PlugClean<CR>
nnoremap <leader>ps :PlugStatus<CR>

" Filetype snippets --- {{{
" CSS snippets
augroup css_snippets
    autocmd!
    autocmd FileType css nnoremap <buffer> <localleader>c I/* <ESC>A */<ESC>
    autocmd FileType css vnoremap <buffer> <localleader>c oI/* <ESC>gvo$A<Right> */<ESC>
augroup END

" JS snippets
augroup js_snippets
    autocmd!
    autocmd FileType javascript iabbrev af () => {}<Left>
    autocmd FileType javascript iabbrev ff () {}<Left>
    autocmd FileType javascript nnoremap <buffer> <localleader>c I// <ESC>
    autocmd FileType javascript vnoremap <buffer> <localleader>c :s!^!//!<CR>
    autocmd FileType javascript nnoremap <buffer> <localleader>de ggO /* eslint-disable */<ESC>
augroup END

" Python snippets
augroup py_snippets
    autocmd!
    autocmd FileType python nnoremap <buffer> <localleader>c I# <ESC>
augroup END

" Bash snippets
augroup sh_snippets
    autocmd!
    autocmd FileType sh nnoremap <buffer> <localleader>c I# <ESC>
augroup END
" }}}

" Vimscript file settings --- {{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim nnoremap <buffer> <localleader>c I" <ESC>
augroup END
" }}}

"  Plugins --- {{{
call plug#begin('~/.vim/plugged')
Plug 'skielbasa/vim-material-monokai'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'scrooloose/nerdtree'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'jparise/vim-graphql'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"Plug 'ternjs/tern_for_vim'
"Plug 'marijnh/tern_for_vim'
Plug 'jiangmiao/auto-pairs'
"Plug 'severin-lemaignan/vim-minimap'
Plug 'yangmillstheory/vim-snipe'
Plug 'szw/vim-tags'
Plug 'junegunn/vim-easy-align'
Plug 'editorconfig/editorconfig-vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'w0rp/ale'
call plug#end()
"  }}}
"
"  Plugin settings --- {{{
" VimSnipe
map <leader><leader>f <Plug>(snipe-f)
map <leader><leader>ge <Plug>(snipe-ge)
nmap <leader><leader>] <Plug>(snipe-f-xp)
nmap <leader><leader>[ <Plug>(snipe-F-xp)
nmap <leader><leader>x <Plug>(snipe-f-x)
nmap <leader><leader>X <Plug>(snipe-F-x)
nmap <leader><leader>r <Plug>(snipe-f-r)
nmap <leader><leader>R <Plug>(snipe-F-r)

" FZF
nnoremap <silent><Space> :Ag<CR>
nnoremap <silent><C-P> :call fzf#run({ 'down': '40%', 'sink': 'vertical botright split' })<CR>
nnoremap <silent><leader>n :FZFNeigh<CR>

" search neighboring files of cwd
function! s:fzf_neighbouring_files()
   let current_file =expand("%")
   let cwd = fnamemodify(current_file, ':p:h')
   let command = 'ag -g "" -f ' . cwd . ' --depth 0'

   call fzf#run({
        \ 'source': command,
        \ 'sink':   'e',
        \ 'options': '-m -x +s',
        \ 'window':  'enew'
	\})
endfunction
command! FZFNeigh call s:fzf_neighbouring_files()
" VimTags
let g:vim_tags_cache_dir = expand("$HOME/.vim/tmp")
let g:vim_tags_ignore_files = [
		\'.gitignore',
		\'.svnignore', 
		\'.cvsignore', 
		\'node_modules',
		\'automated_tests',
	\]

" NERDTree
let NERDTreeShowHidden = 1
noremap <silent><leader>t :NERDTreeFocus<CR>
noremap <silent><leader>f :NERDTreeFind<CR>
" EasyAlign
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" ALE
let b:ale_fixers = {'javascript': ['eslint']}
let g:ale_fix_on_save = 1
let g:ale_sign_error = '>>'

" Prettier
nnoremap <silent><leader>p :Prettier<CR>
"  }}}

" Theming
let g:airline_powerline_fonts = 1
" let g:molokai_original = 1
" let g:rehash256 = 1
let g:airline_theme='materialmonokai'

" syntax enable
set termguicolors
colorscheme material-monokai

"if exists("g:loaded_webdevicons")
"  call webdevicons#refresh()
"endif
