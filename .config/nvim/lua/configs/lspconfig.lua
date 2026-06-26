local nvlsp = require "nvchad.configs.lspconfig"

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "emmet_ls",
  "gopls",
  "jsonls",
  "prismals",
  "tailwindcss",
  "eslint",
  "svelte",
  "vue_ls",
  "phpactor",
  "yamlls",
}

local lsp_defaults = {
  capabilities = nvlsp.capabilities,
  on_init = nvlsp.on_init,
}

for _, name in ipairs(servers) do
  vim.lsp.config(name, lsp_defaults)
end

vim.lsp.config("ts_ls", {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
})

vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = {
      includeLanguages = {
        typescript = "javascript",
        typescriptreact = "javascript",
      },
      experimental = {
        classRegex = {
          { "cva%(([^)]*)%)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx%(([^)]*)%)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
        },
      },
    },
  },
})

local base_eslint_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config("eslint", {
  on_attach = function(client, bufnr)
    if base_eslint_on_attach then
      base_eslint_on_attach(client, bufnr)
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
})

vim.lsp.enable(servers)
