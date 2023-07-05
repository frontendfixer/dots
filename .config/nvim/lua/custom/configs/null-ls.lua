local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {
  -- bash
  b.formatting.beautysh,

  -- webdev stuff
  b.formatting.deno_fmt.with({
    filetypes = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescriptreact" },
  }),
  b.formatting.prettier.with { filetypes = {
    "css", "scss", "less", "html", "yaml", "markdown", "markdown.mdx", "graphql", "handlebars" } },
  b.formatting.eslint_d,

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,

  --diagnostics
  b.diagnostics.cspell,
  b.diagnostics.deno_lint,

  --Code Actions
  b.code_actions.cspell
}

null_ls.setup {
  debug = true,
  sources = sources,
}
