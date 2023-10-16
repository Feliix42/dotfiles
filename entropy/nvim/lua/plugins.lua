return require('lazy').setup({
  -- theme
  -- use {'morhetz/gruvbox', config = function() vim.cmd.colorscheme("gruvbox") end }
  { 'luisiacc/gruvbox-baby', config = function() vim.cmd.colorscheme("gruvbox-baby") end },
  -- use 'drewtempelmeyer/palenight.vim'
  { 'stevedylandev/flexoki-nvim', name = 'flexoki', enabled = false, lazy = true},
  
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },

  'scrooloose/nerdcommenter',
  'sbdchd/neoformat',

  { 'stevearc/oil.nvim', dependencies = 'nvim-tree/nvim-web-devicons', config = function() require('oil').setup() end },

  -- fuzzy file finder
  { 'junegunn/fzf', build = function() vim.fn['fzf#install'](0) end },
  'junegunn/fzf.vim',

  -- utils for other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- On-demand loading for languages
  { 'rust-lang/rust.vim', ft = "rust" },
  { 'cespare/vim-toml', ft = "toml" },
  { 'neovimhaskell/haskell-vim', ft = "haskell" },
  { 'jalvesaq/Nvim-R', branch = "stable", ft = "r" },
  'rhysd/vim-llvm',
  { 'Civitasv/cmake-tools.nvim', dependencies = "nvim-lua/plenary.nvim" },
  { 'lf-lang/lingua-franca.vim' },
  -- TODO: Setup omnifunc for autocomplete!
  { 'anekos/hledger-vim' },
  -- use 'keith/swift.vim'

  -- Post-install/update hook with neovim command
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


  -- 'jasonccox/vim-wayland-clipboard'
  -- use 'vim-syntastic/syntastic'
  -- use 'vim-airline/vim-airline'
  -- use 'airblade/vim-gitgutter'
  -- use 'justinmk/vim-sneak'
  -- use 'lervag/vimtex'
  -- use 'editorconfig/editorconfig-vim'
  -- use 'LnL7/vim-nix'
  -- use 'xevz/vim-squirrel'
  -- use 'preservim/nerdtree'
  -- 
  -- -- ale language server client
  -- use 'dense-analysis/ale'
})
