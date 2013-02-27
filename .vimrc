" cronos's cool little vimrc
" adapted for go development (other languages are usable too, ofc)
"
" in order to make tagbar work you need to install exuberant-ctags
"
" have fun!

" Initialize pathogen
execute pathogen#infect()

"{{{Auto Commands

" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
   au!
   autocmd BufReadPost *
            \ if expand("<afile>:p:h") !=? $TEMP |
            \   if line("'\"") > 1 && line("'\"") <= line("$") |
            \     let JumpCursorOnEdit_foo = line("'\"") |
            \     let b:doopenfold = 1 |
            \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
            \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
            \        let b:doopenfold = 2 |
            \     endif |
            \     exe JumpCursorOnEdit_foo |
            \   endif |
            \ endif
   " Need to postpone using "zv" until after reading the modelines.
   autocmd BufWinEnter *
            \ if exists("b:doopenfold") |
            \   exe "normal zv" |
            \   if(b:doopenfold > 1) |
            \       exe  "+".1 |
            \   endif |
            \   unlet b:doopenfold |
            \ endif
augroup END

"}}}

"{{{Misc Settings
" Necessary  for lots of cool vim things
set nocompatible

" don't need those nasty swap files ;(
set noswapfile

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Automatically re-read file
set autoread

" This shows what you are typing as a command.
set showcmd

" Folding Stuffs
set foldmethod=marker

" Needed for Syntax Highlighting and stuff
filetype plugin indent on
syntax enable

" Who doesn't like auto-indent?
set autoindent

" Spaces are better than a tab character
"set expandtab
set smarttab
" 4-space tab looks nicer to me
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse=a

" Got backspace?
set backspace=2

" Line Numbers
set number

" Stuff for sweet searching
set ignorecase
set smartcase
set incsearch
set hlsearch
set gdefault

" Since I use Linux, I want this
let g:clipbrdDefaultReg = '+'

" When I close a tab, remove the buffer
set nohidden

" Set off the other parent
highlight MatchParen ctermbg=4

" I don't know what this is o.o
let g:rct_completion_use_fri = 1
let g:Tex_ViewRule_pdf = "kpdf"
set grepprg=grep\ -nH\ $*

" Misc stuff
set encoding=utf-8
set cursorline

" Testing
set completeopt=longest,menuone,preview

" neocomplcache stuff
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_prefetch = 1
let g:neocomplcache_enable_quick_match = 1
let g:neocomplcache_enable_auto_delimiter = 1
let g:neocomplcache_enable_auto_select = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 3
" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {'default' : ''}

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
	let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType go setlocal omnifunc=gocomplete#Complete

" autoformat go code on save
autocmd FileType go autocmd BufWritePre <buffer> Fmt

if !exists('g:neocomplcache_omni_patterns')
	let g:neocomplcache_omni_patterns = {}
endif

let g:Powerline_symbols = 'unicode'

" enable tagbar for go
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : '~/.vim/bundle/tagbar/gotags/gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

" }}}

"{{{Look and Feel

" Favorite Color Scheme
" set t_Co=256
colorscheme wombat256
if has("gui_running")
   " Remove Toolbar
   set guioptions-=T
   set guifont=Terminus\ 9
endif

"Status line gnarliness
set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]

" }}}

"{{{ Functions

"{{{ Open URL in browser

function! Browser ()
   let line = getline (".")
   let line = matchstr (line, "http[^   ]*")
   exec "!iceweasel ".line
endfunction

"}}}

"}}}

"{{{ Mappings

" Set Leader key
let mapleader = ","

" Open Url on this line with the browser \w
map <Leader>w :call Browser ()<CR>

" Mapping for NerdTree
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :TagbarToggle<CR>

" Manage Tabs
nnoremap <silent> <C-Tab> :tabnext<CR>
nnoremap <silent> <C-t> :tabnew<CR>

" Up and down are more logical with g..
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

" Space will toggle folds!
nnoremap <space> za

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

" Swap ; and :  Convenient.
nnoremap ; :
nnoremap : ;

" Misc
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap / /\v
vnoremap / /\v
nnoremap <leader><space> :noh<cr>

" fix arrow keys in terminal
if &term =~ 'xterm' || &term =~ 'rxvt' || &term =~ 'screen' || &term =~ 'linux' || &term =~ 'gnome'
	imap <silent> <Esc>OA <Up>
	imap <silent> <Esc>OB <Down>
	imap <silent> <Esc>OC <Right>
	imap <silent> <Esc>OD <Left>
	imap <silent> <Esc>OH <Home>
	imap <silent> <Esc>OF <End>
	imap <silent> <Esc>[5~ <PageUp>
	imap <silent> <Esc>[6~ <PageDown>
endif

" neocomplcache mappings
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()

"}}}

