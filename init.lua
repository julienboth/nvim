local vim_plug_install_path = vim.fn['stdpath']('config') .. '/autoload/plug.vim'

local f = io.open(vim_plug_install_path, 'r')
if f == nil then
    os.execute(('curl -fLo %s --create-dirs %s'):format(
		vim_plug_install_path,
		'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	))
    vim.api.nvim_command('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
else
	f:close()
end
------------------------
--Helper functions Keybindings
local api = vim.api
local cmd = api.nvim_command

local U = {}

-- Key mapping
function U.map(mode, key, result, opts)
    opts =
        vim.tbl_extend(
        "keep",
        opts or {},
        {
            noremap = true,
            silent = true,
            expr = false
        }
    )

    api.nvim_set_keymap(mode, key, result, opts)
end

-------------
-- Options --
-------------

local global_opts = {
    encoding      = 'utf-8',
    termguicolors = true,

    smarttab      = true,

    ignorecase    = true,
    smartcase     = true,

    splitbelow    = true,
    splitright    = true,

    showmode      = true,

    history       = 5000,
    autowrite     = true,
    undofile      = true,

    updatetime    = 300,
    ttimeoutlen   = 10,
    timeoutlen    = 500,

    title         = true,

    wildmenu      = true,
    wildmode      = 'full',
    hidden        = true,

    hlsearch      = true,
    incsearch     = true,

    -- virtualedit   = 'block',
    backspace     = 'indent,eol,start',

   -- shortmess     = 'filnxtToOIc',

    completeopt   = 'menuone,noselect',

    formatoptions = 'jcroql',  -- see `help fo-table` for meaning


}

local win_opts = {
    cursorline = true,
    number     = true,
    foldmethod = 'expr',
    foldexpr   = 'nvim_treesitter#foldexpr()',
    foldenable = true,
}

local buf_opts = {
    autoindent  = true,
    smartindent = true,

    infercase   = true,

    expandtab   = true,

    shiftwidth  = 4,
    softtabstop = 4,
    tabstop     = 4,

    textwidth   = 80,
}

for k, v in pairs(global_opts) do
	vim.o[k] = v
    -- vim.api.nvim_set_option(k, v)
end

for k, v in pairs(buf_opts) do
	vim.o[k] = v
	vim.bo[k] = v
    -- vim.api.nvim_set_option(k, v)
    -- vim.api.nvim_buf_set_option(0, k, v)
end

for k, v in pairs(win_opts) do
	vim.o[k] = v
	vim.wo[k] = v
    -- vim.api.nvim_set_option(k, v)
    -- vim.api.nvim_win_set_option(0, k, v)
end
-------------
-- Plugins --
-------------

local plugins = {
    'folke/which-key.nvim',
    -- git plugin (which key modifiers)

    'airblade/vim-gitgutter',

    -- git plugin (commiting, blame, diff, etc.)
	'tpope/vim-fugitive',

    -- colorschemes
	'morhetz/gruvbox',
    'joshdick/onedark.vim',

    -- syntax checker for various programming languages
    -- 'scrooloose/syntastic'
	'benekastah/neomake',

    -- indenting python properly
	'hynek/vim-python-pep8-indent',

    -- proper folding for python
	'tmhedberg/SimpylFold',

    -- text objects for indented languages (python)
	'tweekmonster/braceless.vim',

    -- Motions for CamelCase and snake_case
	'bkad/CamelCaseMotion',

    -- easy commenting out of code
	'scrooloose/nerdcommenter',

    -- prettier status line
	'vim-airline/vim-airline',
	'vim-airline/vim-airline-themes',

    -- lightweight LaTeX plugin
	--'LaTeX-Box-Team/LaTeX-Box',

    -- display marks
	'kshenoy/vim-signature',

    -- Nerdtree
	'scrooloose/nerdtree',
	'Xuyuanp/nerdtree-git-plugin',

    -- rst support Python doku 
	'Rykka/riv.vim',
	'Rykka/InstantRst',

    -- Table Mode
	'dhruvasagar/vim-table-mode',

    -- die Kuh
	'mhinz/vim-startify',
    
    -- nerd fonts
   'ryanoasis/vim-devicons',
    'kyazdani42/nvim-web-devicons',

    -- Make the yanked region apparent!
	'machakann/vim-highlightedyank',

	'vimwiki/vimwiki', --{ 'branch': 'dev' }

    -- telescope is a fuzzy finder for filenames, their contents and more
	'nvim-telescope/telescope.nvim',
	'nvim-lua/plenary.nvim',  -- dependency of telescope
	'nvim-lua/popup.nvim',  -- dependency of telescope

	'oberblastmeister/neuron.nvim',

	'majutsushi/tagbar',

	'gennaro-tedesco/nvim-peekup',

    -- Move current selection up (down) with A-k (A-j)
	'matze/vim-move',

    -- change/add/delete `sourroundings`
	'tpope/vim-surround',


    -- semantic highlighter for python code
    --	'numirias/semshi', {'do': ':UpdateRemotePlugins'},

	'tell-k/vim-autopep8',

	--'junegunn/fzf.vim',
	--'BurntSushi/ripgrep',

	--'ihsanturk/neuron.vim',

    -- Better spell checking Rechtschreibtesten TODO: Config if necessary
	'vigoux/LanguageTool.nvim',

    -- NeoVim LSP config
    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-compe',
}


local path = vim.fn['stdpath']('data') .. '/plugged'
vim.fn['plug#begin'](path)

for _,p in pairs(plugins) do
    if type(p) == 'table' then
        vim.fn['plug#'](unpack(p))
    else
        vim.fn['plug#'](p)
    end
end

vim.fn['plug#end']()

---------
-- Colors
---------

vim.api.nvim_command('colorscheme ' .. 'onedark')

---------------
-- Autocommands
---------------

-- Save cursor position, folds etc on leaving a buffer
vim.cmd('autocmd BufWinLeave * silent! mkview')
-- and reload on entering it
vim.cmd('autocmd BufWinEnter * silent! loadview')

-----------
-- Mappings
-----------

U.map('n', 'Q', 'gq}')  -- don't use ex mode, use Q for formatting 
U.map('n', 'w!!', '%!sudo tee > /dev/null %')
U.map('n', 'Y', 'y$')  -- make Y work as C or D,
-- make ctrl-l remove highlights and re-apply syntax highlighting
U.map('n', '<C-l>', ':nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>')
-- switch to next/previous buffer with Tab/shift+Tab
U.map('n', '<Tab>', ':bnext<CR>')
U.map('n', '<S-Tab>', ':bprevious<CR>')

------------
-- Telescope
------------

local finders = require "telescope.builtin"
local actions = require "telescope.actions"
local sorters = require "telescope.sorters"

require("telescope").setup(
    {
        defaults = {
            prompt_prefix = " ??? ",
            sorting_strategy = "ascending",
            mappings = {
                i = {
                    ["<ESC>"] = actions.close,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-o>"] = function()
                        return
                    end,
                    ["<TAB>"] = function()
                        return
                    end
                }
            },
            file_sorter = sorters.get_fzy_sorter,
            generic_sorter = sorters.get_fzy_sorter
        }
    }
)


function TelescopeOpen(fn)
    finders[fn]()
end

-- Ctrl-p = fuzzy finder
U.map("n", "<C-P>", "<CMD>lua require('telescope.builtin').find_files()<CR>")
U.map("n", "<C-F>", "<CMD>lua require('telescope.builtin').find_files()<CR>")
U.map("n", "<leader>fg", "<CMD>lua require('telescope.builtin').live_grep()<CR>")
U.map("n", "<leader>fb", "<CMD>lua require('telescope.builtin').buffers()<CR>")
U.map("n", "<leader>fh", "<CMD>lua require('telescope.builtin').help_tags()<CR>")

--------------------------
-- gruvbox (color scheme)
--------------------------
local g = vim.g
g.gruxbox_italic = 1
g.gruvbox_contrast = 'medium'

------------------------
-- airline (status bar)
------------------------
g.airline_powerline_fonts = 1
g["airline#extensions#tabline#enabled"] = 1
g["airline#extensions#tabline#fnamemod"] = ':t'
g.airline_theme = 'onedark'


------------
-- lspconfig
------------
require'lspconfig'.pyright.setup{}
local nvim_lsp = require('lspconfig')

require'lspconfig'.sqlls.setup{
  cmd = {"/opt/homebrew/bin/sql-language-server", "up", "--method", "stdio"};
}


local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts) -- springt zur Funktions definition
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts) -- hover over und gibt textbox wieder
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts) --spring zu den n??chsten fehlern
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end


--------
-- compe
--------
require'compe'.setup {
  enabled = true;
  autocomplete = false;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = false;
    ultisnips = false;
  };
}

local function keymap(k,m) vim.api.nvim_set_keymap('i', k, m, {noremap=true, silent=true, expr=true}) end
keymap('<C-Space>', 'compe#complete()')


-------------
-- Which key
-------------
require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
}
