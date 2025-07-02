-- Mason auto-installs: pyright, ruff, prettier
-- Free AI completion: Codeium (Tab to accept, Option+] for next suggestion)
-- Optional: Install Rust (cargo) for faster completion fuzzy matching
-- Commands: :Mason, :ConformInfo, :LspInfo, :Codeium Auth, :CodeiumToggle, :Codeium Chat
-- Quick keys: <leader>f (files), <leader>g (grep), <leader>b (buffers), = (format), gw (jump)

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Essential settings
vim.o.ignorecase = true     -- Case insensitive search
vim.o.smartcase = true      -- Unless uppercase is used
vim.o.hlsearch = true       -- Highlight search results
vim.o.incsearch = true      -- Incremental search
vim.o.expandtab = true      -- Spaces instead of tabs
vim.o.shiftwidth = 4        -- Indent width
vim.o.tabstop = 8           -- Tab display width
vim.o.scrolloff = 5         -- Lines to keep visible when scrolling
vim.o.number = true         -- Line numbers
vim.o.ruler = true          -- Cursor position in statusline
vim.o.updatecount = 0       -- Disable swap files
vim.o.wildmenu = true       -- Command line completion menu
vim.o.backspace = 'indent,eol,start'
vim.o.completeopt = 'menuone,noselect'
vim.o.background = 'light'
-- Also yank to system clipboard
vim.opt.clipboard:append("unnamedplus")

-- Disable text wrapping
vim.o.textwidth = 0
vim.o.wrapmargin = 0

-- Key mappings
vim.keymap.set('n', '<C-f>', function()
  local path = vim.fn.expand('%:p')
  local size = vim.fn.getfsize(path)
  local size_str = size < 0 and 'N/A' or string.format('%.1f KB', size / 1024)
  vim.notify(string.format('%s [%s]', path, size_str), vim.log.levels.INFO)
end, { desc = 'Show full path' })

vim.keymap.set('n', ',', vim.cmd.nohlsearch, { desc = 'Clear search highlights' })

vim.keymap.set('n', 'yp', function()
  vim.fn.setreg('+', vim.fn.expand('%'))
  vim.notify('Copied: ' .. vim.fn.expand('%'))
end, { desc = 'Yank path to clipboard' })

-- Install lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require('lazy').setup({
  -- One Light color scheme
  -- {
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     require('onedark').setup({
  --       style = 'light',
  --       colors = {
  --         bg0 = '#ffffff', -- Pure white background
  --       },
  --       transparent = false,
  --       term_colors = true,
  --     })
  --     require('onedark').load()
  --   end,
  -- },
  
  -- VS Code light
  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    config = function()
      require('vscode').setup({
        style = 'light',
        transparent = false,
        terminal_colors = true,
      })
      require('vscode').load()
    end,
  },

  -- Mason for managing LSP servers and tools
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    config = function()
      require('mason').setup({
        ui = {
          border = 'rounded',
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
          }
        }
      })
    end,
  },

  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = {
          'pyright',
          'ruff',      -- LSP + formatting
          'prettier',  -- For markdown/js/ts formatting
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },

  -- Detect tabstop and shiftwidth automatically
  {
    'NMAC427/guess-indent.nvim',
    opts = {},
  },

  -- git signs in gutter
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true,
    },
  },

  -- LSP Support
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'saghen/blink.cmp',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      -- Setup mason-lspconfig
      require('mason-lspconfig').setup()

      local lspconfig = require('lspconfig')
      
      -- Manual setup for each server (more explicit and reliable)
      lspconfig.pyright.setup({
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off",  -- Let Ruff handle this
            },
          },
        },
      })
      
      lspconfig.ruff.setup({})  -- New ruff server

      -- Add more language servers here:
      -- lspconfig.ts_ls.setup({})
      -- lspconfig.jdtls.setup({})

      -- Diagnostic display
      vim.diagnostic.config({
        virtual_text = {
          severity = vim.diagnostic.severity.ERROR,  -- Only show errors, not warnings
          prefix = "●",  -- Shorter prefix
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local opts = { buffer = event.buf }
          
          vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, opts)
          vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
	  vim.keymap.set('n', '=', function()
            require('conform').format({ 
              async = true, 
              lsp_fallback = true,
              timeout_ms = 2000,
            }, function(err)
              if err then
                vim.notify('Format failed: ' .. err, vim.log.levels.ERROR)
              end
            end)
          end, opts)
        end,
      })
    end,
  },

  -- Minimal autocompletion
  {
    'saghen/blink.cmp',
    version = '1.*',
    event = 'InsertEnter',
    build = 'cargo build --release',  -- Requires Rust (cargo) installed
    dependencies = {
      'L3MON4D3/LuaSnip',
    },
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      sources = {
        default = { 'lsp', 'path' },
      },
      -- Will automatically use Rust implementation if build succeeds
    },
  },

  -- Codeium (free AI code completion)
  {
    'Exafunction/codeium.vim',
    event = 'BufEnter',
    config = function()
      -- Disable default bindings to set our own
      vim.g.codeium_disable_bindings = 1
      
      -- Keybindings similar to Copilot
      vim.keymap.set('i', '<Tab>', function() return vim.fn['codeium#Accept']() end, { expr = true, desc = 'Accept suggestion' })
      vim.keymap.set('i', '<M-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, desc = 'Next suggestion' })
      vim.keymap.set('i', '<M-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, desc = 'Previous suggestion' })
      vim.keymap.set('i', '<M-\\>', function() return vim.fn['codeium#Complete']() end, { expr = true, desc = 'Trigger suggestion' })
      -- Escape will clear suggestions if visible, then exit insert mode as normal
      vim.keymap.set('i', '<Esc>', '<Cmd>call codeium#Clear()<CR><Esc>', { desc = 'Clear suggestion and exit' })
      -- Note: Codeium doesn't support partial accept (word/line) like Copilot
      
      -- Toggle Codeium on/off
      vim.keymap.set('n', '<leader>ct', vim.cmd.CodeiumToggle, { desc = 'Toggle Codeium' })
      -- Chat functionality (opens in browser)
      vim.keymap.set('n', '<leader>cc', function() vim.cmd('Codeium Chat') end, { desc = 'Open Codeium Chat' })
    end,
  },

  -- Telescope fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      
      telescope.setup({
        defaults = {
          layout_strategy = 'horizontal',
          sorting_strategy = 'ascending',
          layout_config = {
            horizontal = {
              preview_width = 0.55,
              prompt_position = 'top',
            },
          },
          mappings = {
            i = {
              -- Disable Ctrl-u/d from clearing prompt in insert mode
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              -- Add Ctrl-j/k navigation in insert mode
              ['<C-j>'] = 'move_selection_next',
              ['<C-k>'] = 'move_selection_previous',
              -- Single Esc to close
              ['<esc>'] = 'close',
            },
          },
        },
      })
      
      telescope.load_extension('fzf')
      
      -- Keymaps
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Help' })
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Search in buffer' })
      vim.keymap.set('n', '<leader>d', builtin.diagnostics, { desc = 'Diagnostics' })
      -- MRU buffers, similar to bufexplorer
      vim.keymap.set('n', '<leader>b', function()
        builtin.buffers({
          sort_mru = true,
          initial_mode = 'normal', -- Start in normal mode, for j/k navigation
        })
      end, { desc = 'Buffers (MRU)' })
    end,
  },

  -- Better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'python', 'lua', 'vim', 'vimdoc', 'markdown', 'java', 'typescript', 'javascript', 'groovy' },
        auto_install = true,
        highlight = {
          enable = true,
          disable = { "groovy" },
        },
      })
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = {
          --theme = 'onelight',
          theme = 'vscode',
          component_separators = '|',
          section_separators = '',
          icons_enabled = false,
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { 'diagnostics', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
      })
    end,
  },

  -- Auto-formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          markdown = { 'prettier' },
          python = { 'ruff_format' },
          -- Add more formatters as needed:
          -- javascript = { 'prettier' },
          -- typescript = { 'prettier' },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- Quick jump to any word (like Helix's gw)
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      modes = {
        char = {
          enabled = false,  -- Don't override f/F/t/T
        },
      },
    },
    keys = {
      { 'gw', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash jump' },
      { 'gW', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    },
  },
}, {
  ui = {
    border = 'rounded',
  },
})
