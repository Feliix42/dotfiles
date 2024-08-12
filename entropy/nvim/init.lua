local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- comma as leader
vim.g.mapleader = ","

require('plugins')

-- load legacy options
vim.cmd([[
	" so ~/.config/nvim/legacy.vim
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
    let g:tex_flavor='latex'
    let g:vimtex_view_method = 'zathura'
    let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
    let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
    let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
    let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
    let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
    let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
    let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

    autocmd FileType hledger setlocal omnifunc=hledger#complete#omnifunc
]])

require('completion')
require('lsp-setup')

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "c", "lua", "vim", "query", "mlir",
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

-- editor theme
--vim.cmd.colorscheme("flexoki")

-- lualine theme
require('lualine').setup {
    options = {
        theme = 'gruvbox-baby',
        -- no separators between lualine elements
        --section_separators = '',
        --component_separators = ''
    }
}

-- to disable the default netrw file browser
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
require("bufferline").setup{}

-- settings for neovide
if vim.g.neovide then
    vim.o.guifont = "Iosevka Medium:h9"
end

vim.opt.backspace = "indent,eol,start"

-- fix auto-completion
vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.wildignore = "*.o,*~,*.pyc,*.aux,*.bbl,*.blg,*-blx.bib,*.log,*.out,*.run.xml,*.toc,*.nav,*.snm"

-- BUFFER HANDLING ---------------------------------
-- automatically reload files changed on disk but not in buffer
vim.opt.autoread = true
-- hide buffers on switch
vim.opt.hidden = true

-- OPTICS & NUMBERING BEHAVIOUR --------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- keep 5 lines of context above/below the cursor (if possible)
vim.opt.scrolloff = 5


-- SEARCH ------------------------------------------
-- highlight all search results
vim.opt.hlsearch = true
-- enable smart-case search
vim.opt.smartcase = true
-- always case-insensitive
vim.opt.ignorecase = true
-- searches for strings incrementally
vim.opt.incsearch = true

-- key bindings
-- empty mode string matches n, v, o
vim.keymap.set("", "<leader>h", ":tabp<Enter>", { desc = "Select previous tab" })
vim.keymap.set("", "<leader>l", ":tabn<Enter>", { desc = "Select next tab" })
vim.keymap.set("", "<C-H>", ":bprevious<Enter>", { desc = "Select previous buffer" })
vim.keymap.set("", "<C-L>", ":bnext<Enter>", { desc = "Select next buffer" })

vim.keymap.set("", "<leader>f", ":Files<Enter>", { desc = "Open FZF file finder" })
vim.keymap.set("", "<leader>bl", ":Buffers<Enter>", { desc = "Open FZF buffer list" })

vim.keymap.set("n", "<space>1", "1<C-w>w", { noremap = true })
vim.keymap.set("n", "<space>2", "2<C-w>w", { noremap = true })
vim.keymap.set("n", "<space>3", "3<C-w>w", { noremap = true })
vim.keymap.set("n", "<space>4", "4<C-w>w", { noremap = true })
vim.keymap.set("n", "<space>5", "5<C-w>w", { noremap = true })
vim.keymap.set("n", "<space>6", "6<C-w>w", { noremap = true })
vim.keymap.set("n", "<space>7", "7<C-w>w", { noremap = true })
vim.keymap.set("n", "<space>8", "8<C-w>w", { noremap = true })
vim.keymap.set("n", "<space>9", "9<C-w>w", { noremap = true })
vim.keymap.set("n", "<space>0", "10<C-w>w", { noremap = true })


-- TODO:
-- window number on editor buffer
-- hledger file type omnifunc like: autocmd FileType hledger setlocal omnifunc=hledger#complete#omnifunc
