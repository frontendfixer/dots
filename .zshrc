#
#     ██╗      █████╗ ██╗  ██╗███████╗██╗  ██╗███╗   ███╗██╗██╗  ██╗ █████╗ ███╗   ██╗████████╗ █████╗
#     ██║     ██╔══██╗██║ ██╔╝██╔════╝██║  ██║████╗ ████║██║██║ ██╔╝██╔══██╗████╗  ██║╚══██╔══╝██╔══██╗
#     ██║     ███████║█████╔╝ ███████╗███████║██╔████╔██║██║█████╔╝ ███████║██╔██╗ ██║   ██║   ███████║
#     ██║     ██╔══██║██╔═██╗ ╚════██║██╔══██║██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╗██║   ██║   ██╔══██║
#     ███████╗██║  ██║██║  ██╗███████║██║  ██║██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚████║   ██║   ██║  ██║
#     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝
#

#Locale for terminal
export LANG="en_IN.UTF-8"
export LC_ALL="en_IN.UTF-8"
export LC_CTYPE="en_IN.UTF-8"

###EXPORT
export TERM="xterm-256color"
export EDITOR="nvim"
export VISUAL="nvim"

export SUDO_EDITOR="nvim"
alias "sudoedit"='function _sudoedit(){sudo -e "$1";};_sudoedit'

######### PATH
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export PATH="$PATH:$HOME/.local/bin/"

############# CHANGE TITLE OF TERMINALS
case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|alacritty|st|konsole*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
    screen*)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
        ;;
esac
############################
####  Source plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
source ~/.zsh/zsh-syntax-highlighting.sh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source ~/.zsh/git-flow-completion-master/git-flow-completion.zsh

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

########################################################################
###############                 FUNCTION                 ###############
########################################################################

############# Function extract for common file formats ###
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

function extract {
    if [ -z "$1" ]; then
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    else
        for n in "$@"
        do
            if [ -f "$n" ] ; then
                case "${n%,}" in
                    *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                        tar xvf "$n"       ;;
                    *.lzma)      unlzma ./"$n"      ;;
                    *.bz2)       bunzip2 ./"$n"     ;;
                    *.cbr|*.rar)       unrar x -ad ./"$n" ;;
                    *.gz)        gunzip ./"$n"      ;;
                    *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
                    *.z)         uncompress ./"$n"  ;;
                    *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                        7z x ./"$n"        ;;
                    *.xz)        unxz ./"$n"        ;;
                    *.exe)       cabextract ./"$n"  ;;
                    *.cpio)      cpio -id < ./"$n"  ;;
                    *.cba|*.ace)      unace x ./"$n"      ;;
                    *)
                        echo "extract: '$n' - unknown archive method"
                        return 1
                        ;;
                esac
            else
                echo "'$n' - file does not exist"
                return 1
            fi
        done
    fi
}

IFS=$SAVEIFS

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

####### Keybindings
source ~/.zsh/zsh-keybinding

######## Sourcing aliases
source ~/.aliases

############### Styling
# neofetch --ascii ~/.config/neofetch/images/mx-linux.txt

#starship startup scripts
eval "$(starship init zsh)"
