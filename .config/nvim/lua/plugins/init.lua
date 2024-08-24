return {
  -- Code formatting and linting
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre',
    opts = require "configs.conform",
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  -- Mason for managing external tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "tsserver",                    -- TypeScript server for Next.js
        "eslint_d",                    -- ESLint for linting JavaScript/TypeScript
        "phpactor",                    -- PHP Language Server
        "gopls",                       -- Go Language Server
        "json-lsp",                    -- JSON Language Server
        "emmet-ls",                    -- Emmet for faster HTML and CSS writing
        "tailwindcss-language-server", -- Tailwind CSS IntelliSense
        "prisma-language-server",      -- Prisma for Next.js
        "svelte-language-server",      -- Svelte for SvelteKit
        "codespell",                   -- Spell checker
      },
    },
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript", "typescript",
        "php", "go", "scss", "json", "bash", "markdown",
        "tsx", "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Codeium for AI autocompletion
  {
    "Exafunction/codeium.nvim",
    event = 'BufEnter',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({})
    end
  },

  -- nvim-cmp for autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "f3fora/cmp-spell",
      },
    },
    config = function()
      local cmp = require 'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- Use LuaSnip for snippet expansion
          end,
        },
        mapping = {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- Use LuaSnip for snippets
          { name = 'codeium' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
          { name = 'spell' },
        })
      })
    end,
  },


  -- Additional recommended plugins
  {
    "lewis6991/gitsigns.nvim", -- Git integration
    event = "User FilePost",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
  },

  {
    "nvim-telescope/telescope.nvim", -- Fuzzy finder and picker
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      -- Load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
    "NvChad/nvim-colorizer.lua", -- Color highlighter for hex/rgb colors
    event = "User FilePost",
    opts = {
      user_default_options = { names = false },
      filetypes = { "*", "!lazy" },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- Attach to the buffer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },
}
