vim.opt_local.formatoptions:remove "o"
local nmap = require("ale.keymap").nmap
nmap {"rr", ":RustRunnables<CR>", { silent = true }}
nmap {"ha", ":RustHoverActions<CR>", { silent = true }}
