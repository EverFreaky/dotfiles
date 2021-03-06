-- Startify
vim.g.startify_commands = {
	{ pi = { 'Install Plugins', ':PlugInstall' } },
	{ pu = { 'Update Plugins', ':PlugUpdate' } },
	{ pc = { 'Clean Plugins', ':PlugClean' } },
	{ pv = { 'Update vim-plug', ':PlugUpgrade' } }
}
vim.g.startify_bookmarks = {
	{ ww = '~/Dropbox/VimWiki/index.md' },
	{ df = '~/dotfiles' }
}
vim.g.startify_lists = { 
	{ type = 'dir', header = { 'Recently edited files in '..vim.fn.getcwd()..':' } }, 
	{ type = 'files', header = { 'Files' } },
	{ type = 'commands', header = { 'Commands' } },
	{ type = 'bookmarks', header = { 'Bookmarks' } } 
}
-- custom header
vim.g.startify_custom_header = {
	'	*----------------------------------------------------*',
	'	|  "I have not failed.                               |',
	'	|   I have just found 10,000 ways that won\'t work."  |',
	'	|                              -- Thomas A. Edison   |',
	'	*----------------------------------------------------*'
}
-- NERD Tree
-- Exit Vim if NERDTree is the only window remaining in the only tab.
vim.cmd("autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif")

-- Close the tab if NERDTree is the only window remaining in it.
vim.cmd("autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif")

-- If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
vim.cmd('autocmd BufEnter * if bufname("#") =~ "NERD_tree_d+" && bufname("%") !~ "NERD_tree_d+" && winnr("$") > 1 | let buf=bufnr() | buffer# | execute "normal! <C-W>w" | execute "buffer".buf | endif')

-- Remove status Line
vim.g.NERDTreeStatusline = '%#NonText#'

-- Delete buffer if file is deleted
vim.g.NERDTreeAutoDeleteBuffer = true
-- Make it prettier
vim.g.NERDTreeMinimalUI = true
-- Show hidden files
vim.g.NERDTreeShowHidden = true

-- Andrew's NERDTree
vim.g.andrews_nerdtree_buffer_fs_menu = true
vim.g.andrews_nerdtree_git_filter = true
vim.g.andrews_nerdtree_interactive_edit = true

-- NERD Commenter
vim.g.NERDCreateDefaultMappings = false
vim.g.NERDSpaceDelims = true
vim.g.NERDCompactSexyComs = true
vim.g.NERDCommentEmptyLines = true
vim.g.NERDTrimTailingWhitespace = true

-- LaTex
vim.g.neotex_enable = 2

-- LSP
-- Cmp
local cmp = require'cmp'

cmp.setup({
	mapping = {
	  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
	  ['<C-f>'] = cmp.mapping.scroll_docs(4),
	  ['<C-Space>'] = cmp.mapping.complete(),
	  ['<C-e>'] = cmp.mapping.close(),
	  ['<CR>'] = cmp.mapping.confirm({ select = true }),
	  ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
	  ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })
	},
	sources = {
	  { name = 'nvim_lsp' },
	  { name = 'buffer' },
	}
})

local lsp = require 'lspconfig'
local protocol = require 'vim.lsp.protocol'
local on_attach = function(client, buffer)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- Mappings
	local opts = { noremap = true, silent = true }

	-- Format on save
	if client.resolved_capabilities.document_formatting then
		vim.api.nvim_command [[augroup Format]]
		vim.api.nvim_command [[autocmd! * <buffer>]]
		vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
		vim.api.nvim_command [[augroup END]]
	end
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    -- This sets the spacing and the prefix
    virtual_text = {
      spacing = 2,
      prefix = '???'
    }
  }
)

lsp.diagnosticls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { 'javascript', 'javascriptreact', 'json', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'markdown', 'pandoc' },
  init_options = {
    linters = {
      eslint = {
        command = 'eslint',
        rootPatterns = { '.git' },
        debounce = 100,
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        sourceName = 'eslint',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {
          [2] = 'error',
          [1] = 'warning'
        }
      },
    },
    filetypes = {
      javascript = 'eslint',
      javascriptreact = 'eslint',
      typescript = 'eslint',
      typescriptreact = 'eslint',
    },
    formatters = {
      prettier = {
        command = 'prettier',
        args = { '--stdin-filepath', '%filename' }
      }
    },
    formatFiletypes = {
      css = 'prettier',
      javascript = 'prettier',
      javascriptreact = 'prettier',
      json = 'prettier',
      scss = 'prettier',
      less = 'prettier',
      typescript = 'prettier',
      typescriptreact = 'prettier',
      json = 'prettier',
      markdown = 'prettier',
    }
  }
}
lsp.ccls.setup {
	on_attach = on_attach,
	capabilities = capabilities
}
lsp.tsserver.setup {
	on_attach = on_attach,
	capabilities = capabilities
}
lsp.jsonls.setup {
	on_attach = on_attach,
	capabilities = capabilities
}
lsp.hls.setup{}
lsp.texlab.setup {
	on_attach = on_attach,
	capabilities = capabilities
}
lsp.pyright.setup{}
lsp.rust_analyzer.setup{
	on_attach = on_attach,
	capabilities = capabilities
}

-- VimWiki
vim.g.vimwiki_list = {
	{
		path = '~/vimwiki', 
		syntax = 'markdown', 
		ext = '.md'
	}
}
vim.g.vimwiki_markdown_link_ext = 1
vim.g.taskwiki_markup_syntax = 'markdown'
vim.g.markdown_folding = 1
