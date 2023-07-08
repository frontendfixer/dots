local M = {}

M.treesitter = {
  ensure_installed = {
    "bash",
    "c",
    "css",
    "html",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "scss",
    "typescript",
    "vim",
  },
  indent = {
    enable = true,
  },
  highlight = {
    enable = true
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- c/cpp stuff
    "clangd",
    "clang-format",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
    ignore = false,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
