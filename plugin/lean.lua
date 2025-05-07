vim.opt.signcolumn = "yes:1"

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
