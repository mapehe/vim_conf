syntax on
filetype plugin indent on

call plug#begin()
Plug 'joe-skb7/cscope-maps'
Plug 'vivien/vim-linux-coding-style'
Plug 'preservim/NERDTree'
Plug 'vim-airline/vim-airline'
Plug 'preservim/tagbar'
Plug 'bogado/file-line'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'tpope/vim-fugitive'

Plug 'tomasiser/vim-code-dark'
Plug 'HerringtonDarkholme/yats.vim'

Plug 'bfrg/vim-cpp-modern'

Plug 'rhysd/vim-clang-format'
call plug#end()

" 80 characters line
set colorcolumn=81
execute "set colorcolumn=" . join(range(81,335), ',')
highlight ColorColumn ctermbg=Black ctermfg=DarkRed

let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++11"}

set number

let g:coc_global_extensions = ['coc-tsserver']

let $FZF_DEFAULT_COMMAND='find . \( -name node_modules -o -name .git -o -name .next -o -name .husky -o -name .swc \) -prune -o -print'

autocmd VimEnter * if !argc() | NERDTree | endif
autocmd VimEnter * wincmd w

colorscheme codedark

:set wrap!

:set shiftwidth=2
:set autoindent
:set smartindent
:set expandtab
:set tabstop=2

" Highlight trailing spaces
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()


let g:LanguageClient_serverCommands = {
  \ 'cpp': ['clangd', '-j=5', '-completion-style=detailed', '-background-index', '-all-scopes-completion', '--suggest-missing-includes'],
  \ 'c': ['clangd', '-j=5',  '-completion-style=detailed', '-background-index', '-all-scopes-completion', '--suggest-missing-includes'],
  \ 'python': ['pyls'],
  \ 'rust': ['rls'],
  \ }
let g:LanguageClient_diagnosticsList = 'Disabled'

:function Language_client_keymaps()
:  nmap <silent> gd :call LanguageClient#textDocument_definition()<cr>
:  nmap <silent> gh :call LanguageClient#textDocument_hover()<cr>
:  nmap <silent> gr :call LanguageClient#textDocument_references()<cr>
:  nmap <silent> gm :call LanguageClient_contextMenu()<CR>
:  nmap <silent> gn :call LanguageClient#textDocument_rename()<CR>
:endfunction

:function Coc_keymaps()
:  nmap <silent> gd <Plug>(coc-definition)
:  nmap <silent> gy <Plug>(coc-type-definition)
:  nmap <silent> gi <Plug>(coc-implementation)
:  nmap <silent> gr <Plug>(coc-references)
:  nmap <silent> gn <Plug>(coc-rename)
:  nmap <silent> dn :call CocAction('diagnosticNext')<CR>
:  nmap <silent> dN :call CocAction('diagnosticPrevious')<CR>
:  nmap <silent> df :CocFix<CR>
:  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
:  nmap <silent> gh :call CocAction('doHover')<CR>
:endfunction

map <F12> :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR>
map F :NERDTreeFind<cr>

autocmd BufEnter *.{js,jsx,ts,tsx} :call Coc_keymaps()
autocmd BufEnter *.{c,cpp,s,h} :call Language_client_keymaps()

nmap gs :Rg<cr>

nmap <up> :tabnew<cr>
nmap <down> :tabclose<cr>
nmap <right> :tabnext<cr>
nmap <left> :tabprevious<cr>

