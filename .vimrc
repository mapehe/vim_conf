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
Plug 'hashivim/vim-terraform'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'airblade/vim-gitgutter'
Plug 'markonm/traces.vim'
Plug 'Julian/lean.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
call plug#end()

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

let g:LanguageClient_serverCommands = {
  \ 'cpp': ['clangd', '-j=5', '-completion-style=detailed', '-background-index', '-all-scopes-completion', '--suggest-missing-includes'],
  \ 'c': ['clangd', '-j=5',  '-completion-style=detailed', '-background-index', '-all-scopes-completion', '--suggest-missing-includes'],
  \ 'python': ['pyls'],
  \ 'rust': ['rls'],
  \ 'julia': ['julia', '--startup-file=no', '--history-file=no', '-e', '
  \       using LanguageServer;
  \       using Pkg;
  \       import StaticLint;
  \       import SymbolServer;
  \       env_path = dirname(Pkg.Types.Context().env.project_file);
  \       server = LanguageServer.LanguageServerInstance(stdin, stdout, env_path, "");
  \       server.runlinter = true;
  \       run(server);
  \   ']
  \ }
let g:LanguageClient_diagnosticsList = 'Disabled'

:function Language_client_keymaps()
:  nmap <silent> gd :call LanguageClient#textDocument_definition()<cr>
:  nmap <silent> gh :call LanguageClient#textDocument_hover()<cr>
:  nmap <silent> gr :call LanguageClient#textDocument_references()<cr>
:  nmap <silent> gm :call LanguageClient_contextMenu()<CR>
:  nmap <silent> gn :call LanguageClient#textDocument_rename()<CR>
:  nmap <silent> dn :call LanguageClient#diagnosticsNext()<CR>
:  nmap <silent> dN :call LanguageClient#diagnosticsPrevious()<CR>
:  nmap <silent> df :call LanguageClient#textDocument_codeAction()<CR>
:endfunction

:function Coc_keymaps()
:  nmap <silent> gd <Plug>(coc-definition)
:  nmap <silent> gy <Plug>(coc-type-definition)
:  nmap <silent> gi <Plug>(coc-implementation)
:  nmap <silent> gr <Plug>(coc-references)
:  nmap <silent> gn <Plug>(coc-rename)
:  nmap <silent> df <Plug>(coc-codeaction-cursor)
:  nmap <silent> dn :call CocAction('diagnosticNext')<CR>
:  nmap <silent> dN :call CocAction('diagnosticPrevious')<CR>
:  nmap <silent> gh :call CocAction('doHover')<CR>
:endfunction

let g:default_julia_version = '1.0'

map <F12> :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR>
map F :NERDTreeFind<cr>

:function JsInit()
  :call Coc_keymaps()
: endfunction

autocmd BufEnter *.{js,jsx,ts,tsx} :call JsInit()
autocmd BufEnter *.{c,cpp,cc,s,h,jl} :call Language_client_keymaps()

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
nmap gs :Rg<cr>

nmap <up> :tabnew<cr>
nmap <down> :tabclose<cr>
nmap <right> :tabnext<cr>
nmap <left> :tabprevious<cr>

nmap J <Plug>(GitGutterNextHunk)
nmap K <Plug>(GitGutterPrevHunk)

autocmd FileType c,h,cpp ClangFormatAutoEnable
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

:highlight DiffAdd ctermfg=Green ctermbg=NONE guifg=#00ff37 guibg=#00ff37
:highlight DiffDelete ctermfg=9 ctermbg=NONE guifg=#00ff37 guibg=#00ff37
let g:gitgutter_enabled=1
set updatetime=100

highlight CocErrorFloat ctermfg=Red guifg=#ff0000
highlight CocInfoFloat ctermfg=White guifg=#ffffff

