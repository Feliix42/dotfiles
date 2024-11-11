return require('lazy').setup({
  -- theme
  -- use {'morhetz/gruvbox', config = function() vim.cmd.colorscheme("gruvbox") end }
  {'luisiacc/gruvbox-baby', config = function()
      vim.g.gruvbox_baby_transparent_mode = 1
      vim.cmd.colorscheme("gruvbox-baby")
  end },
  -- use 'drewtempelmeyer/palenight.vim'
  { 'stevedylandev/flexoki-nvim', as = 'flexoki', config = function() vim.cmd.colorscheme("flexoki") end, enabled = false },

  -- utility plugins
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },

  -- UI
  {
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons'
  },
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },

  -- commenting and text formatting
  'scrooloose/nerdcommenter',
  'sbdchd/neoformat',

  -- directory editing
  {
      'stevearc/oil.nvim',
      dependencies = 'nvim-tree/nvim-web-devicons',
      config = function() require('oil').setup() end
  },

  -- fuzzy file finder
  { 'junegunn/fzf', build = function() vim.fn['fzf#install'](0) end },
  'junegunn/fzf.vim',

  -- On-demand loading for languages
  { 'rust-lang/rust.vim', ft = "rust" },
  { 'cespare/vim-toml', ft = "toml" },
  -- use 'keith/swift.vim'
  -- use 'neovimhaskell/haskell-vim'
  { 'Civitasv/cmake-tools.nvim', dependencies = "nvim-lua/plenary.nvim" },
  { 'anekos/hledger-vim' },

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  
  -- LSP plugins
  'neovim/nvim-lspconfig',
  'p00f/clangd_extensions.nvim',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  -- snippet engine
  'hrsh7th/vim-vsnip',

  'tpope/vim-fugitive',
  'lervag/vimtex',
  'editorconfig/editorconfig-vim',
  'LnL7/vim-nix'

  -- 'xevz/vim-squirrel'
})
