-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', ',e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', 'ge', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gE', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', ',q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- define LSP attach handler to map specific actions to keys I prefer more than the gr-prefixed defaults
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        -- Enable completion triggered by <c-x><c-o>
        -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.api.nvim_buf_set_keymap(args.buf, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'n', 's', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'i', ',s', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'n', ',wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'n', ',wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'n', ',wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'n', ',D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'n', ',rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'n', ',m', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts) -- was: ,qf
        vim.api.nvim_buf_set_keymap(args.buf, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(args.buf, 'n', ',F', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)
    end,
})

-- enable the following servers
local servers = { 'clangd', 'rust_analyzer', 'nil_ls' }
for _, lsp in pairs(servers) do
  vim.lsp.enable(lsp)
end

vim.lsp.config('clangd', {
  cmd = {
    "clangd",
    "--background-index",
    "--pch-storage=memory",
    "--clang-tidy",
    "--suggest-missing-includes",
    "--all-scopes-completion",
    "--pretty",
    "--header-insertion=never",
    "-j=4",
    "--inlay-hints",
    "--header-insertion-decorators",
  },
  filetypes = {"c", "cpp", "objc", "objcpp"},
  -- root_dir = utils.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
  init_option = { fallbackFlags = {  "-std=c++2a"  } }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('pyright', {
  capabilities = capabilities
})

