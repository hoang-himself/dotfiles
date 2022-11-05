require('base')
require('plugin')
require('remap')
require('highlight')

local has = vim.fn.has
local is_win = has 'win32'

if is_win then
  require('windows')
end
