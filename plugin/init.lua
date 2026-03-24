vim.g.maplocalleader = '  '

local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, 
  }, {
    { name = 'buffer' },
  })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})
require("cmp_git").setup() ]]-- 

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function on_attach(_, bufnr)
    vim.keymap.set('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
    vim.keymap.set('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
    vim.keymap.set('n','gh','<cmd>lua vim.lsp.buf.hover()<CR>')
    vim.keymap.set('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
    vim.keymap.set('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
    vim.keymap.set('n','ga','<cmd>lua vim.lsp.buf.code_action()<CR>')
    vim.keymap.set('n','gn','<cmd>lua vim.diagnostic.goto_next()<CR>')
    vim.keymap.set('n','gN','<cmd>lua vim.diagnostic.goto_prev()<CR>')
    vim.keymap.set('n', 'dn', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    vim.keymap.set('n', 'dN', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
end

require('lean').setup{
    lsp = { on_attach = on_attach },
    mappings = true,
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = { spacing = 4 },
    update_in_insert = true,
  }
)

local null_ls = require('null-ls')

vim.lsp.config('pyright', {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "pyright-langserver", "--stdio" },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
        },
    },
})
vim.lsp.enable('pyright')

vim.lsp.config('ts_ls', {
  on_attach = function(_, bufnr)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    vim.keymap.set('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    vim.keymap.set('n', 'df', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    vim.keymap.set('n', 'dn', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    vim.keymap.set('n', 'dN', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    vim.keymap.set('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>')
  end,
  capabilities = capabilities,
  cmd = { "typescript-language-server", "--stdio" },
})
vim.lsp.enable('ts_ls')

vim.lsp.config('eslint', {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  settings = {
    eslint = {
      run = "onSave",
      codeActionOnSave = {
        enable = false,
        mode = "all"
      },
      experimental = {
        useFlatConfig = false
      },
    },
    workingDirectory = { mode = "auto" },
  },
})
vim.lsp.enable('eslint')

vim.diagnostic.config({
  update_in_insert = false,
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        bufnr = bufnr,
                        timeout_ms = 1000,
                        filter = function(c)
                            return c.name == "null-ls"
                        end
                    })
                end,
            })

        end
    end,
    sources = {
      null_ls.builtins.formatting.prettier.with({
          command = "./node_modules/.bin/prettier",
          filetypes = {
                "javascript", "typescript", "javascriptreact", "typescriptreact", 
                "css", "scss", "html",
                "json", "yaml", "markdown"
            },
      }),
      null_ls.builtins.diagnostics.mypy.with({
      extra_args = { "--ignore-missing-imports" }, -- Common flag to avoid noise
    }),
    },
})

require('csvview').setup({
  view = {
    display_mode = "border",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv", "tsv" }, -- This ensures it works for both
  group = csv_group,
  callback = function()
    -- This sets the toggle to <leader>n ONLY in the current CSV buffer
    vim.keymap.set("n", "<leader>n", "<cmd>CsvViewToggle<CR>", { 
        buffer = true, 
        desc = "Toggle CSV View" 
    })
  end,
})

vim.lsp.config('clangd', {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--fallback-style=llvm",
    },
    init_options = {
        fallbackFlags = { "-std=c++2c" },
    },
})
vim.lsp.enable('clangd')

require("snacks").setup({
  terminal = { enabled = true } -- Ensures Claude can open in a terminal
})

-- 2. Setup Claude Code
require("claudecode").setup({
  -- If 'claude' isn't in your PATH, uncomment and set the path below:
  -- terminal_cmd = "claude", 
})

vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  callback = function()
    if vim.fn.mode() ~= 'c' then vim.cmd("checktime") end
  end,
})

-- 3. Keybindings
-- Using vim.keymap.set to match your current coding style
vim.keymap.set('n', '<leader>ac', '<cmd>ClaudeCode<cr>', { desc = "Toggle Claude" })
vim.keymap.set('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = "Focus Claude" })

-- Optional: Send visual selection to Claude
vim.keymap.set('v', '<leader>as', ':ClaudeCodeSend<cr>', { desc = "Send Selection to Claude" })
