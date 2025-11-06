# ~/.zshrc
#
#     ██╗      █████╗ ██╗  ██╗███████╗██╗  ██╗███╗   ███╗██╗██╗  ██╗ █████╗ ███╗   ██╗████████╗ █████╗
#     ██║     ██╔══██╗██║ ██╔╝██╔════╝██║  ██║████╗ ████║██║██║ ██╔╝██╔══██╗████╗  ██║╚══██╔══╝██╔══██╗
#     ██║     ███████║█████╔╝ ███████╗███████║██╔████╔██║██║█████╔╝ ███████║██╔██╗ ██║   ██║   ███████║
#     ██║     ██╔══██║██╔═██╗ ╚════██║██╔══██║██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╗██║   ██║   ██╔══██║
#     ███████╗██║  ██║██║  ██╗███████║██║  ██║██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚████║   ██║   ██║  ██║
#     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝
#

# -----------------------------------------------------------------------------
#                              ZSH-SPECIFIC SETTINGS
# -----------------------------------------------------------------------------

# Locale for terminal (LC_ALL and LC_CTYPE are Zsh-specific)
export LANG="en_IN.UTF-8"
export LC_ALL="en_IN.UTF-8"
export LC_CTYPE="en_IN.UTF-8"

# SUDO_EDITOR and sudoedit alias (specific to Zshrc)
export SUDO_EDITOR="nvim"
alias "sudoedit"='function _sudoedit(){sudo -e "$1";};_sudoedit'

##############################################################################
# History Configuration
##############################################################################
HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
#HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed
setopt    completealiases   # Allow tab completion for aliases

# -----------------------------------------------------------------------------
#                             LOAD CORE CONFIG
# -----------------------------------------------------------------------------

# Source the common .bashrc file to load EXPORTS, PATHS, ALIASES, and FUNCTIONS.
# This keeps the Zshrc minimal.
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# -----------------------------------------------------------------------------
#                               ZSH OVERRIDES
# -----------------------------------------------------------------------------

# Zsh-specific PATH additions (Bun and MANPATH for NPM)
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

# FNM Path setup (The `eval` commands need to run *after* the core PATHs are set from .bashrc)
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# Custom Terminal Title setting for Zsh (using preexec hook instead of PROMPT_COMMAND)
if [ -z "$PROMPT_COMMAND" ]; then # Only apply if it wasn't sourced from .bashrc (less likely)
  function set_terminal_title {
      case ${TERM} in
          xterm*|rxvt*|Eterm*|aterm|kterm|kitty|gnome*|alacritty|st|konsole*)
              echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"
              ;;
          screen*)
              echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"
              ;;
      esac
  }
  # Zsh's way of executing a command before the prompt
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd set_terminal_title
fi


# -----------------------------------------------------------------------------
#                                 PLUGINS
# -----------------------------------------------------------------------------

####  Source plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
# Note: You were sourcing two syntax highlighting files, one is likely the plugin manager helper.
# I've kept both as you had them, but typically you only need one or a plugin manager.
source ~/.zsh/zsh-syntax-highlighting.sh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source ~/.zsh/git-flow-completion-master/git-flow-completion.zsh

####### Keybindings
source ~/.zsh/zsh-keybinding

# -----------------------------------------------------------------------------
#                                 STARTUP
# -----------------------------------------------------------------------------

# Fastfetch and Starship (Styling)
# fastfetch
eval "$(starship init zsh)"