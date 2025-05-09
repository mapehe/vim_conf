vim.g.maplocalleader = '  '

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

require("lspconfig").ts_ls.setup {
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
  end
}

lspconfig.eslint.setup({
  allow_incremental_sync = false,
  debounce_text_changes = 1000,
})

local null_ls = require('null-ls')

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
          command = "./node_modules/.bin/prettier", -- prioritize local prettier
          filetypes = {
                "javascript", "typescript", "javascriptreact", "typescriptreact", -- React
                "css", "scss", "html",
                "json", "yaml", "markdown"
            },

      }),
    },
})


