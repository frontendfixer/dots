local mason_tools = {
  "lua-language-server",
  "stylua",
  "html-lsp",
  "css-lsp",
  "prettier",
  "typescript-language-server",
  "eslint-lsp",
  "phpactor",
  "gopls",
  "json-lsp",
  "emmet-ls",
  "tailwindcss-language-server",
  "prisma-language-server",
  "svelte-language-server",
  "vue-language-server",
  "yaml-language-server",
}

local treesitter_parsers = {
  "vim",
  "lua",
  "vimdoc",
  "html",
  "css",
  "scss",
  "javascript",
  "typescript",
  "tsx",
  "json",
  "bash",
  "markdown",
  "yaml",
  "php",
  "go",
  "svelte",
  "vue",
  "prisma",
  "graphql",
  "dockerfile",
  "toml",
}

return {
  -- Disable NvChad's nvim-tree in favor of neo-tree
  { "nvim-tree/nvim-tree.lua", enabled = false },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neotree",
    keys = {
      { "<C-n>", "<cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
      { "<leader>e", "<cmd>Neotree focus<CR>", desc = "Focus file tree" },
    },
    opts = require "configs.neo-tree",
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = mason_tools,
      auto_update = true,
      run_on_start = true,
      start_delay = 3000,
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = treesitter_parsers,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup {}
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, 1, { name = "codeium" })
      return opts
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    opts = {
      user_default_options = { names = false },
      filetypes = { "*", "!lazy" },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)

      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },
}
