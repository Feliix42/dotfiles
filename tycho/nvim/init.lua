require('plugins')

-- comma as leader
vim.g.mapleader = ","

-- load legacy options
vim.cmd([[
	so ~/.config/nvim/legacy.vim
]])

require('completion')
require('lsp-setup')

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "c", "lua", "vim", "help", "query",
        "gitattributes", "gitcommit", "gitignore",
        "json", "markdown", "yaml", "toml",
        "make", "nix", "bash",
        "php", "html", "css",
        "python", "rust", 
    },
    highlight = {
        enable = true,
    },
}

-- lualine theme
require('lualine').setup {
    options = {
        theme = 'gruvbox',
        -- no separators between lualine elements
        section_separators = '',
        component_separators = ''
    }
}

vim.opt.termguicolors = true
require("bufferline").setup{}

-- settings for neovide
if vim.g.neovide then
    vim.o.guifont = "Iosevka Term Medium:h12"
end
