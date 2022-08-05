local nmap = require("ale.keymap").nmap
local imap = require("ale.keymap").imap
local handlers = require "ale.lsp.handlers"
-- local signs = require "ale.lsp.signs"
local status = require "ale.lsp.status"
local nvim_status = require "lsp-status"
status.activate()

opts = { 
      shorten_path = true,
      layout_strategy = "flex",

      layout_config = {
        width = 0.9,
        height = 0.9,

        horizontal = {
          width = { padding = 0.15 },
        },
        vertical = {
          preview_height = 0.75,
        },
      },
}

local filetype_attach = setmetatable({
  go = function(client)
    vim.cmd [[
      augroup lsp_buf_format
        au! BufWritePre <buffer>
        autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()
      augroup END
    ]]
  end,

  rust = function()
    vim.cmd [[
      augroup lsp_buf_format
        au! BufWritePre <buffer>
        autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()
      augroup END
    ]]
  end,
}, {
  __index = function()
    return function() end
  end,
})

local custom_attach = function(client)
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  nvim_status.on_attach(client)

nmap { 'ca',
  function()
    vim.lsp.buf.code_action()
  end,
  { silent = true }
}

  -- nmap { "ha", "<cmd>lua vim.lsp.buf.hover()<CR>" }
  nmap { "<space>gi", 
        function()
          require("telescope.builtin").lsp_implementations(opts)
        end,
      }
  nmap { "gT", 
        function()
          require("telescope.builtin").lsp_type_definitions(opts)
        end,
      }
  nmap { "gr", 
        function()
          require("telescope.builtin").lsp_references(opts)  
        end,
  }
  nmap { "gW",
        function()
          require("telescope.builtin").lsp_workspace_symbols(opts)
        end,
  }
  nmap { "gd", 
        function()
          require("telescope.builtin").lsp_definitions(opts)
        end,
  }


  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  if client.resolved_capabilities.document_highlight then
    vim.cmd [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end

  if client.resolved_capabilities.code_lens then
    vim.cmd [[
      augroup lsp_document_codelens
        au! * <buffer>
        autocmd BufEnter ++once         <buffer> lua require"vim.lsp.codelens".refresh()
        autocmd BufWritePost,CursorHold <buffer> lua require"vim.lsp.codelens".refresh()
      augroup END
    ]]
  end

  filetype_attach[filetype](client)
end

local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities = vim.tbl_deep_extend("keep", updated_capabilities, nvim_status.capabilities)
updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }
updated_capabilities = require("cmp_nvim_lsp").update_capabilities(updated_capabilities)

updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

return {
  on_attach = custom_attach,
  on_init = custom_init,
  capabilities = updated_capabilities,
}
