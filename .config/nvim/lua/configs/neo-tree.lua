return {
  close_if_last_window = false,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
  sort_case_insensitive = false,
  default_component_configs = {
    indent = {
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
    },
  },
  window = {
    position = "left",
    width = 30,
    mappings = {
      ["<space>"] = "none",
    },
  },
  filesystem = {
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
      hide_by_name = {
        "node_modules",
        ".git",
      },
      never_show = {
        ".DS_Store",
        "thumbs.db",
      },
    },
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    group_empty_dirs = false,
    hijack_netrw_behavior = "open_default",
    use_libuv_file_watcher = true,
  },
  commands = {},
}
