
filetype plugin indent on

call plug#begin()
Plug 'preservim/NERDTree'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Julian/lean.nvim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'lewis6991/gitsigns.nvim'
call plug#end()

set number

let g:coc_global_extensions = ['coc-tsserver']

let $FZF_DEFAULT_COMMAND='find . \( -name node_modules -o -name .git -o -name .next -o -name .husky -o -name .swc \) -prune -o -print'

autocmd VimEnter * if !argc() | NERDTree | endif
autocmd VimEnter * wincmd w

:set wrap!
:set shiftwidth=2
:set autoindent
:set smartindent
:set expandtab
:set tabstop=2

map <F12> :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR>
map F :NERDTreeFind<cr>

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
nmap gs :Rg<cr>

nmap <up> :tabnew<cr>
nmap <down> :tabclose<cr>
nmap <right> :tabnext<cr>
nmap <left> :tabprevious<cr>
nmap <silent> ¨ :Gedit<cr>

nmap J <Plug>(GitGutterNextHunk)
nmap K <Plug>(GitGutterPrevHunk)

:highlight DiffAdd ctermfg=Green ctermbg=NONE guifg=#00ff37 guibg=#00ff37
:highlight DiffDelete ctermfg=9 ctermbg=NONE guifg=#00ff37 guibg=#00ff37
let g:gitgutter_enabled=1
set updatetime=100

colorscheme catppuccin-macchiato

function! GoToPreciseDiffLocation()
  " Step 1: Find file name from diff header
  let lnum_fname = search('^+++ b/', 'bnW')
  if lnum_fname == 0
    echo "No file header found"
    return
  endif
  let filename_line = getline(lnum_fname)
  let filename = substitute(filename_line, '^+++ b/', '', '')

  " Step 2: Find the nearest hunk header above the cursor
  let lnum_hunk = search('^@@', 'bnW')
  if lnum_hunk == 0
    echo "No hunk header found"
    return
  endif
  let hunk_line = getline(lnum_hunk)

  " Step 3: Parse the new-file start line from hunk header
  let m = matchlist(hunk_line, '^@@ -\d\+\%(,\d\+\)\? +\(\d\+\)')
  if len(m) < 2
    echo "Could not parse hunk header"
    return
  endif
  let new_start = str2nr(m[1])

  " Step 4: Calculate cursor's offset from hunk header, skipping '-' lines
  let cur_line = line('.')
  let offset = 0
  for i in range(lnum_hunk + 1, cur_line)
    let line_text = getline(i)
    if line_text =~ '^+' || line_text =~ '^ '
      let offset += 1
    endif
  endfor

  let target_line = new_start + offset

  " Step 5: Open the file and jump to the corresponding line
  execute 'edit ' . filename
  execute target_line
endfunction

command! GotoDiffChange call GoToPreciseDiffLocation()

:  nmap <silent> ga :call GoToPreciseDiffLocation()<CR>

function! FoldPatch()
  " Enable manual folding
  setlocal foldmethod=expr
  setlocal foldexpr=FoldPatchExpr(v:lnum)

  " Optional: Start with all folds closed
  setlocal foldlevel=0
endfunction

function! FoldPatchExpr(lnum)
  " Get the current line
  let line = getline(a:lnum)

  " If it's a hunk header, start a fold
  if line =~ '^@@ .* @@'
    return '>1'
  endif

  " If it's part of a diff or context, keep it in the fold
  if line =~ '^[-+ ]'
    return '1'
  endif

  " Everything else is not folded
  return '0'
endfunction

