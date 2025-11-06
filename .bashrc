# ~/.bashrc

#     ██╗      █████╗ ██╗  ██╗███████╗██╗  ██╗███╗   ███╗██╗██╗  ██╗ █████╗ ███╗   ██╗████████╗ █████╗
#     ██║     ██╔══██╗██║ ██╔╝██╔════╝██║  ██║████╗ ████║██║██║ ██╔╝██╔══██╗████╗  ██║╚══██╔══╝██╔══██╗
#     ██║     ███████║█████╔╝ ███████╗███████║██╔████╔██║██║█████╔╝ ███████║██╔██╗ ██║   ██║   ███████║
#     ██║     ██╔══██║██╔═██╗ ╚════██║██╔══██║██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╗██║   ██║   ██╔══██║
#     ███████╗██║  ██║██║  ██╗███████║██║  ██║██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚████║   ██║   ██║  ██║
#     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# -----------------------------------------------------------------------------
#                                  EXPORTS
# -----------------------------------------------------------------------------

# Locale for terminal
LANG="en_IN.utf8"
export LANG
export TERM="xterm-256color"             # getting proper colors
export EDITOR="nvim"                     # $EDITOR use NeoVim in terminal
export VISUAL="nvim"                     # $VISUAL use NeoVim in GUI mode

### SET MANPAGER
# "bat" as manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# -----------------------------------------------------------------------------
#                                 PATHS
# -----------------------------------------------------------------------------

# Add sbin directories to PATH.
echo $PATH | grep -Eq "(^|:)/sbin(:|)"     || PATH=$PATH:/sbin
echo $PATH | grep -Eq "(^|:)/usr/sbin(:|)" || PATH=$PATH:/usr/sbin

##### SET LOCAL BIN (Kept here as it's common) ######
export PATH="$PATH:$HOME/.local/bin/"

##### Deno PATH (Kept here) #####
DENO_INSTALL_PATH="$HOME/.deno"
if [ -d "$DENO_INSTALL_PATH" ]; then
    export PATH="$DENO_INSTALL_PATH/bin:$PATH"
fi

###### NPM Global Config (Kept here) ######
NPM_PACKAGES="$HOME/.npm-packages"
if [ -d "$NPM_PACKAGES" ]; then
    # Add bin to PATH
    case ":$PATH:" in
      *":$NPM_PACKAGES/bin:"*) ;;
      *) export PATH="$NPM_PACKAGES/bin:$PATH" ;;
    esac
fi

# pnpm (Standard Bash check)
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

##### NVM (Simplified to one common check) #####
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# Bash completion is optional, kept here for bash users
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# -----------------------------------------------------------------------------
#                                 ALIASES
# -----------------------------------------------------------------------------

######### Alias definitions.
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# -----------------------------------------------------------------------------
#                                 FUNCTIONS
# -----------------------------------------------------------------------------

### ARCHIVE EXTRACTION (Simplified to the original .bashrc version for simplicity)
# usage: extract <file>
extract ()
{
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1 ;;
            *.7z)        7z x $1      ;;
            *.deb)       ar x $1      ;;
            *.tar.xz)    tar xf $1    ;;
            *.tar.zst)   unzstd $1    ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

############# navigation
up () {
    local d=""
    local limit="$1"

    # Default to limit of 1
    if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
        limit=1
    fi

    for ((i=1;i<=limit;i++)); do
        d="../$d"
    done

    # perform cd. Show error if cd fails
    if ! cd "$d"; then
        echo "Couldn't go up $limit dirs.";
    fi
}

# -----------------------------------------------------------------------------
#                                 BASH-SPECIFIC
# -----------------------------------------------------------------------------

### PROMPT (Bash prompt variable - Zsh will use Starship or Oh-My-Zsh theme)
# Only set PS1 if it's Bash AND not already set by Zsh sourcing this file.
if [ -n "$BASH_VERSION" ] && [ -z "$ZSH_VERSION" ]; then
  PS1='\[\e[0;1;38;5;203m\]\h\[\e[0;1;97m\]@\[\e[0;1;38;5;49m\]\u\[\e[0;1;2;38;5;226m\]:\[\e[0;1;2;38;5;226m\]:\[\e[0;2;3;38;5;227m\]\w\n \[\e[0;38;5;43m\]➜ \[\e[0m\]'

  ### CHANGE TITLE OF TERMINALS (Using BASH PROMPT_COMMAND)
  case ${TERM} in
      xterm*|rxvt*|Eterm*|aterm|kterm|kitty|gnome*|alacritty|st|konsole*)
          PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
          ;;
      screen*)
          PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
          ;;
      xterm-color) color_prompt=yes ;;
  esac

  #ignore upper and lowercase when TAB completion
  bind "set completion-ignore-case on"
fi

# -----------------------------------------------------------------------------
#                              SHELL-SPECIFIC (Bash)
# -----------------------------------------------------------------------------

# Fastfetch and zsh execution are removed as they are Zsh startup tasks.
# fastfetch
# exec zsh