return {
  -- Code formatting and linting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
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
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "php",
        "go",
        "scss",
        "json",
        "bash",
        "markdown",
        "tsx",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Codeium for AI autocompletion
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup {}
    end,
  },

  -- nvim-cmp for autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      require "configs.cmp"
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
