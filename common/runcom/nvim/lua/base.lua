vim.g.editorconfig = true

vim.g.mapleader = ' '
vim.opt.timeoutlen = 1000

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.scrolloff = 4

vim.opt.title = true
vim.opt.backspace = { 'start', 'eol', 'indent' }

vim.opt.wrap = true
vim.opt.textwidth = 79
--vim.opt.formatoptions:prepend("")
--vim.opt.formatoptions:append("")
--vim.opt.formatoptions:remove("")

vim.opt.ignorecase = true -- unless searched with /C or capital
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.inccommand = 'split'

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true

vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2

vim.opt.backup = false
vim.opt.undofile = true

vim.opt.path:append { '**' } -- also search files in subdirs
vim.opt.wildignore:append { '*/.git/*', '*/node_modules/*' }
