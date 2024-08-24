-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "tsserver", "emmet_ls", "gopls", "jsonls", "prismals", "tailwindcss",
  "typos_lsp" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configure eslint
lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

-- ######## install lspconfig servers #########
-- npm install -g emmet-ls vscode-langservers-extracted typescript typescript-language-server svelte-language-server @tailwindcss/language-server stylelint-lsp @prisma/language-server
