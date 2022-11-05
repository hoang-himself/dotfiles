vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.wildoptions = 'pum'
vim.opt.pumblend = 5
vim.opt.background = 'dark'

vim.opt.cursorline = true
vim.opt.colorcolumn = { 72, 79 }
vim.api.nvim_set_hl(0, 'ColorColumn', { ctermbg=1, bg='#1488DB' })

local init_lua_augroup = 'init_lua_augroup'
local function on_ft(ft, cb)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = ft,
    callback = cb,
  })
end

vim.api.nvim_create_augroup(init_lua_augroup, { clear = true })

on_ft({'yaml', 'yml', 'python'}, function()
  vim.opt.cursorcolumn = true
end)

on_ft('gitcommit', function()
  vim.opt.colorcolumn = { 50, 72 }
end)
