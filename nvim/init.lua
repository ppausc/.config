-- NOTE: BASIC SETTINGS
-- See `:help vim.opt`
-- Make line numbers default
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.inccommand = 'split'
vim.opt.scrolloff = 10
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.wrap = false

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- NOTE: KEYMAPS
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Abbreviations for habitual commands
vim.cmd 'cnoreabbrev W! w!'
vim.cmd 'cnoreabbrev X! x!'
vim.cmd 'cnoreabbrev Q! q!'
vim.cmd 'cnoreabbrev Wq wq'
vim.cmd 'cnoreabbrev Wa wa'
vim.cmd 'cnoreabbrev WA wa'
vim.cmd 'cnoreabbrev wQ wq'
vim.cmd 'cnoreabbrev WQ wq'
vim.cmd 'cnoreabbrev W w'
vim.cmd 'cnoreabbrev X x'
vim.cmd 'cnoreabbrev Q q'

-- Move lines up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move visually selected lines down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move visually selected lines up' })

-- Tab and untab
vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Tabulate visual selection' })
vim.keymap.set('v', '<S-Tab>', '<gv', { desc = 'Tabulate visual selection' })

-- Change buffers left and right
vim.keymap.set('n', 'H', ':bp<CR>', { desc = 'Move to the previous buffer' })
vim.keymap.set('n', '<leader><TAB>', ':bp<CR>', { desc = 'Move to the previous buffer' })
vim.keymap.set('n', 'L', ':bn<CR>', { desc = 'Move to the next buffer' })
vim.keymap.set('n', '<leader><leader>', ':bn<CR>', { desc = 'Move to the next buffer' })
vim.keymap.set('n', '<leader>d', ':bp<CR>:bd #<CR>', { desc = 'Deletes current buffer from list' })

-- Don't even press capital q
vim.keymap.set('n', 'Q', '<nop>', { desc = 'Dont even press q' })
vim.keymap.set('n', 'q', '<nop>', { desc = 'Dont even press q' })

-- LSP and Mason keymaps
vim.keymap.set('n', '<leader>li', ':Mason<CR>', { desc = 'Launch Mason' })
vim.keymap.set('n', '<leader>ls', ':LspInfo<CR>', { desc = 'Launch LSP Info' })

-- InspectTree keypam
vim.keymap.set('n', '<leader>ii', ':InspectTree<CR>', { desc = 'Launches inspect tree (old treesitter playground)' })

-- InspectTree keypam
vim.keymap.set('n', '<leader>wr', ':set wrap!<CR>', { desc = 'Enables and disables word wrap' })

-- NOTE: AUTOCOMMANDS
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- NOTE: PLUGINS
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)
require('lazy').setup {
  -- WARNING: Tpope
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'tpope/vim-repeat', -- Allows repeating more actions

  -- WARNING: Comments
  { 'numToStr/Comment.nvim', opts = {} },

  { -- WARNING: Nvim tree
    'kyazdani42/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { desc = 'Opens and closes nvim tree' })
      require('nvim-tree').setup {
        diagnostics = {
          enable = true,
        },
        update_focused_file = {
          enable = true,
        },
        filters = {
          dotfiles = true,
        },
        tab = {
          sync = {
            open = false,
          },
        },
      }
      vim.api.nvim_create_autocmd('BufEnter', {
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and require('nvim-tree.utils').is_nvim_tree_buf() then
            vim.cmd 'quit'
          end
        end,
      })
    end,
  },

  { -- WARNING: Undotree
    'mbbill/undotree',
    lazy = false,
    config = function()
      vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { desc = 'Toggles on and off undotree' })
    end,
  },

  { -- WARNING: Gitsigns
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

  { --WARNING: Whick-key. Allows to see pending keys
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()
      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
      }
    end,
  },

  { -- WARNING: Telescope
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter', -- Binded to an event
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[B] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Shortcut for searching your neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  { -- WARNING: LSP settings and plugins
    'neovim/nvim-lspconfig',
    version = 'v0.1.7',
    dependencies = {
      { 'williamboman/mason.nvim', version = 'v1.10.0' },
      { 'williamboman/mason-lspconfig.nvim', version = 'v1.26.0' },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'towolf/vim-helm', -- Adds helm file type and detection
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Highlight word under cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        terraformls = {},
        bashls = {},
        dockerls = {},
        docker_compose_language_service = {},
        checkmake = {},
        -- gopls = {},
        rust_analyzer = {},
        helm_ls = {
          settings = {
            ['helm-ls'] = {
              yamlls = {
                enabled = false,
              },
            },
          },
        },
        yamlls = {
          filetypes = { 'yaml' },
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = { -- Tels lua_ls to find all your nvim config files
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
              },
              completion = {
                callSnippet = 'Replace',
              },
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require('mason').setup()
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- WARNING: AutoFormatting.
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        terraform = { 'terraform_fmt' },
      },
    },
  },

  { -- WARNING: Autocomplete
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'onsails/lspkind-nvim',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'

      luasnip.config.setup {}

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        view = {
          entries = 'custom',
        },

        mapping = cmp.mapping.preset.insert {
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' },
        },

        formatting = {
          format = lspkind.cmp_format {
            mode = 'symbol_text',
            menu = {
              nvim_lsp = '[LSP]',
              nvim_lsp_signature_help = '[SIG_HELP]',
              treesitter = '[Treesitter]',
              vsnip = '[VSNIP]',
              buffer = '[Buff]',
              nvim_lua = '[Lua]',
            },
          },
        },

        experimental = {
          ghost_text = true,
        },
      }
    end,
  },

  { -- WARNING: Trouble nvim lsp diagnostics quickfix
    'folke/trouble.nvim',
    lazy = false,
    config = function()
      vim.keymap.set('n', '<leader>cx', ':TroubleToggle<CR>', { desc = '[C]ode lsp diagnostics trouble [x]' })
    end,
  },

  { -- WARNING: Highlight todos, comments, warnings, etc
    -- FIX:
    -- TODO:
    -- PERF:
    -- NOTE:
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  { -- WARNING: Mini nvim
    'echasnovski/mini.nvim',
    config = function()
      require('mini.statusline').setup() -- bottom line
      require('mini.tabline').setup() -- top line
      require('mini.pairs').setup() -- autopairs
      require('mini.ai').setup { n_lines = 500 } -- Better Around/Inside textobjects. Around/inside next (
      require('mini.statusline').setup()
      require('mini.tabline').setup() -- top line
      require('mini.surround').setup {
        mappings = {
          add = 'sa', -- Add surrounding in Normal and Visual modes
          delete = 'sd', -- Delete surrounding
          highlight = '', -- Highlight surrounding
          replace = 'sc', -- Replace surrounding
        },
      }
    end,
  },

  { -- WARNING: Treesitter
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'terraform', 'python' },
        auto_install = true, -- Auto-install languages
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },

  { -- WARNING: LazyGit
    'kdheepak/lazygit.nvim',
    lazy = false,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Launches lazygit' })
    end,
  },

  { -- WARNING: Venv selector, for python
    'linux-cultist/venv-selector.nvim',
    opts = {
      parents = 1,
      name = { 'venv', '.venv' },
      poetry_path = '~/.cache/pypoetry/virtualenvs',
      pdm_path = nil,
      pipenv_path = nil,
      pyenv_path = nil,
      hatch_path = nil,
      venvwrapper_path = nil,
      anaconda_envs_path = nil,
    },
  },

  { -- WARNING: Diagnostics show up on the top right
    'dgagn/diagflow.nvim',
    opts = {
      show_borders = true,
      scope = 'line',
      format = function(diagnostic)
        return '[LSP] ' .. diagnostic.message
      end,
    },
  },

  { -- WARNING: Manages CSV files
    'emmanueltouzery/decisive.nvim',
    config = function()
      vim.keymap.set('n', '<leader>cca', ":lua require('decisive').align_csv({})<cr>", { desc = 'align CSV', silent = true })
      vim.keymap.set('n', '<leader>ccA', ":lua require('decisive').align_csv_clear({})<cr>", { desc = 'align CSV clear', silent = true })
      vim.keymap.set('n', '[c', ":lua require('decisive').align_csv_prev_col()<cr>", { desc = 'align CSV prev col', silent = true })
      vim.keymap.set('n', ']c', ":lua require('decisive').align_csv_next_col()<cr>", { desc = 'align CSV next col', silent = true })
    end,
  },

  { -- WARNING: COLORSCHEMES
    -- 'catppuccin/nvim',
    -- 'wuelnerdotexe/vim-enfocado',
    -- 'Yazeed1s/oh-lucy.nvim',
    -- 'morhetz/gruvbox',
    -- 'Shatur/neovim-ayu',
    'folke/tokyonight.nvim',
    -- 'rebelot/kanagawa.nvim'
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- vim.cmd.colorscheme 'PaperColor'
      -- vim.cmd.colorscheme 'base16-default-dark'
      -- vim.cmd.colorscheme 'catppuccin-mocha'
      -- vim.cmd.colorscheme 'enfocado'
      -- vim.cmd.colorscheme 'gruvbox'
      -- vim.cmd.colorscheme 'ayu-dark'
      -- vim.cmd.colorscheme 'kanagawa'
      -- vim.cmd.colorscheme 'kanagawa-wave'
      -- vim.cmd.colorscheme 'oh-lucy-evening'
      vim.cmd.colorscheme 'tokyonight-night'
      vim.cmd.hi 'Comment gui=none' -- You can configure highlights by doing something like
      vim.cmd.hi 'Normal ctermbg=NONE'
      vim.g.catppuccin_flavour = 'mocha'
      vim.g.enfocado_style = 'nature'
    end,
  },

  -- NOTE: You can add custom plugins in files like this
  --
  require 'debug.debug',
  -- require 'kickstart.plugins.indent_line',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}
