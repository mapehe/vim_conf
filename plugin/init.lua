vim.g.maplocalleader = '  '

local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

      -- For `mini.snippets` users:
      -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
      -- insert({ body = args.body }) -- Insert at cursor
      -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
      -- require("cmp.config").set_onetime({ sources = {} })
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
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
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

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function on_attach(_, bufnr)
    vim.keymap.set('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
    vim.keymap.set('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
    vim.keymap.set('n','gh','<cmd>lua vim.lsp.buf.hover()<CR>')
    vim.keymap.set('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
    vim.keymap.set('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
    vim.keymap.set('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
    vim.keymap.set('n','ga','<cmd>lua vim.lsp.buf.code_action()<CR>')
    vim.keymap.set('n','gn','<cmd>lua vim.diagnostic.goto_next()<CR>')
    vim.keymap.set('n','gN','<cmd>lua vim.diagnostic.goto_prev()<CR>')
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

local lspconfig = require("lspconfig")
local null_ls = require('null-ls')

lspconfig.ts_ls.setup {
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
  capabilities = capabilities
}

lspconfig.eslint.setup {}

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
    },
})




