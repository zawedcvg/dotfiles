if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
call plug#begin('~/.config/nvim/autoload/plugged')
Plug 'MunifTanjim/nui.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'folke/noice.nvim'
Plug 'nathom/filetype.nvim'
Plug 'dstein64/vim-startuptime'
Plug 'tpope/vim-surround'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'master'}
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim', {'on': 'Gitsigns toggle_signs'}
Plug 'navarasu/onedark.nvim'
Plug 'svermeulen/vim-subversive'
Plug 'svermeulen/vim-cutlass'
Plug 'nelstrom/vim-visual-star-search'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/which-key.nvim'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'qxxxb/vim-searchhi'
Plug 'lervag/vimtex', {'for': ['markdown']}
Plug 'hedyhli/outline.nvim'
"For completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'

"for lsp
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'j-hui/fidget.nvim'
Plug 'folke/trouble.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'

"colorscheme
Plug 'sainnhe/everforest'

"better UI for lsp
"Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }

"Plug 'kosayoda/nvim-lightbulb'

Plug 'simrat39/rust-tools.nvim' "for rust
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}

Plug 'SmiteshP/nvim-navic' "for function name
"illuminate
Plug 'RRethy/vim-illuminate'
"Plug 'goerz/jupytext.vim'
"Plug 'junegunn/limelight.vim', {'on': 'Limelight'}

Plug 'catppuccin/nvim'
Plug 'alvarosevilla95/luatab.nvim'
Plug 'tyru/open-browser.vim'

Plug 'p00f/clangd_extensions.nvim'
Plug 'lewis6991/impatient.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'zawedcvg/distant.nvim'
Plug 'b0o/incline.nvim'
Plug 'nvim-neorg/neorg', {'tag': 'v7.0.0'}
Plug 'dnlhc/glance.nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'epwalsh/obsidian.nvim',
Plug 'AlexvZyl/nordic.nvim', { 'branch': 'main' }
Plug 'sho-87/kanagawa-paper.nvim',

Plug 'stevearc/oil.nvim'
Plug 'danymat/neogen'

Plug 'OXY2DEV/markview.nvim'
call plug#end()
