return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- theme
  -- use {'morhetz/gruvbox', config = function() vim.cmd.colorscheme("gruvbox") end }
  use {'luisiacc/gruvbox-baby', config = function() vim.cmd.colorscheme("gruvbox-baby") end }
  -- use 'drewtempelmeyer/palenight.vim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

  use 'scrooloose/nerdcommenter'
  use 'sbdchd/neoformat'

  use {
      'stevearc/oil.nvim',
      requires = 'nvim-tree/nvim-web-devicons',
      config = function() require('oil').setup() end
  }

  -- fuzzy file finder
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install'](0) end }
  use 'junegunn/fzf.vim'

  -- -- On-demand loading for languages
  use 'rust-lang/rust.vim'
  -- use 'cespare/vim-toml
  -- use 'keith/swift.vim'
  -- use 'neovimhaskell/haskell-vim'

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  
  -- LSP plugins
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  -- snippet engine
  use 'hrsh7th/vim-vsnip'

  use 'tpope/vim-fugitive'
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
end)
