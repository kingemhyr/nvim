local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	'iibe/gruvbox-high-contrast',
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.3',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		config = true
	},
	'nvim-treesitter/nvim-treesitter',
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 250
		end,
		opts = {
		}
	},
	'neovim/nvim-lspconfig'
})

vim.g.mapleader = ' '

vim.o.updatetime = 50
vim.o.colorcolumn = '80,120'
vim.o.termguicolors = true
vim.cmd [[colorscheme gruvbox-high-contrast]]

-- Files
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true

-- Lines
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 6
vim.o.wrap = false

-- Scrolling
vim.o.scrolloff = 8
vim.o.signcolumn = 'yes'

-- Searching
vim.o.incsearch = true
vim.o.hlsearch = false

-- Indentation
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = false
vim.o.smartindent = true

vim.o.guifont = 'Fira Code:h14'

-- Neovide
vim.g.neovide_cursor_animation_length = 0.0
vim.g.neovide_cursor_trail_size = 0
 
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('HighlightYank', {}),
	pattern = '*',
	callback = function()
		vim.highlight.on_yank({
			higroup = 'IncSearch',
			timeout = 100
		})
	end
})

vim.keymap.set('n', '<F11>', function()
	if vim.g.neovide_fullscreen == true then
		vim.g.neovide_fullscreen = false
	else
		vim.g.neovide_fullscreen = true
	end
end)

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'F', builtin.find_files, {})
vim.keymap.set('n', '<leader>/', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})

--require('ibl').setup({})

-- Terminal
require('toggleterm').setup({
	open_mapping = [[<c-\>]],
	shell = 'fish'
})

-- Treesitter
require('nvim-treesitter.configs').setup({
	ensure_installed = {
	    'c',
	    'lua',
	    'cpp',
	    'rust',
	    'markdown',
		'odin'
	}
})

-- Copy and paste from system clipboard
vim.keymap.set('i', '<c-v>', '<esc>"+pi')
vim.keymap.set('v', '<c-c>', '<esc>"*y')

-- LSP
local lsp = require('lspconfig')
lsp.clangd.setup({})
lsp.rust_analyzer.setup({})
lsp.ols.setup({})
lsp.zls.setup({})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keya
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
