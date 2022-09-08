if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
call plug#begin('~/.config/nvim/autoload/plugged')
Plug 'nathom/filetype.nvim'
"Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
"Plug 'folke/lsp-colors.nvim'
Plug 'dstein64/vim-startuptime'
Plug 'mattn/emmet-vim', {'for': 'html'}
Plug 'tpope/vim-surround'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'master'}
Plug 'tpope/vim-repeat'
"Plug 'ahmedkhalf/project.nvim'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'navarasu/onedark.nvim'
Plug 'svermeulen/vim-subversive'
Plug 'svermeulen/vim-cutlass'
"Plug 'tpope/vim-unimpaired'
Plug 'nelstrom/vim-visual-star-search'
Plug 'kyazdani42/nvim-web-devicons'
"Plug 'akinsho/nvim-bufferline.lua'
Plug 'folke/which-key.nvim'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'qxxxb/vim-searchhi'
Plug 'norcalli/nvim-colorizer.lua', 
"'for': ['html', 'css']}
Plug 'lervag/vimtex', {'for': ['markdown']}

Plug 'habamax/vim-godot'
"For completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'ray-x/lsp_signature.nvim'

"for lsp
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'j-hui/fidget.nvim'
Plug 'folke/trouble.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
"Plug 'nvim-neorg/neorg' | Plug 'nvim-lua/plenary.nvim'

"colorscheme
Plug 'sainnhe/everforest'

"better UI for lsp
"Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
Plug 'kosayoda/nvim-lightbulb'

"for rust
Plug 'simrat39/rust-tools.nvim'
Plug 'junegunn/goyo.vim'
"for function name
Plug 'SmiteshP/nvim-navic'
"illuminate
Plug 'RRethy/vim-illuminate'
Plug 'goerz/jupytext.vim'
Plug 'junegunn/limelight.vim'

Plug 'phaazon/mind.nvim'

Plug 'alvarosevilla95/luatab.nvim'
Plug 'tyru/open-browser.vim'

Plug 'p00f/clangd_extensions.nvim'
call plug#end()
