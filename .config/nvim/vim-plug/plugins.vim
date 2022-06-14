if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

"Plug 'neoclide/coc.nvim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'raimondi/delimitmate'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'machakann/vim-highlightedyank'
Plug 'sainnhe/sonokai'
Plug 'antoinemadec/FixCursorHold.nvim'
"Plug 'folke/tokyonight.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'tanvirtin/monokai.nvim'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'master'}
Plug 'tpope/vim-repeat'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-fugitive'
Plug 'navarasu/onedark.nvim'
Plug 'svermeulen/vim-subversive'
Plug 'svermeulen/vim-cutlass'
Plug 'tpope/vim-unimpaired'
Plug 'nelstrom/vim-visual-star-search'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'folke/which-key.nvim'
Plug 'mbbill/undotree', {'on': 'UndoTreeToggle'}
Plug 'marko-cerovac/material.nvim'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
"Plug 'fannheyward/telescope-coc.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'bluz71/vim-moonfly-colors'
Plug 'rktjmp/lush.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'qxxxb/vim-searchhi'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'lervag/vimtex'

"For completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'

"for lsp
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

"for rust
Plug 'simrat39/rust-tools.nvim'
call plug#end()
