#!/usr/bin/env bash
# shell=bash
# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

export OSH='/home/quitto/.oh-my-bash'
export OSH_CUSTOM="$HOME/.bash"

export PATH="$HOME/.cargo/bin:/usr/local/bin:$PATH"
export PATH="$PATH:/run/media/quitto/DATA/Projects/Python/ProjectSetup-3.0"
export PATH="$PATH:/home/quitto/.spicetify"
export PATH="$PATH:/home/quitto/.local/bin"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

export HISTFILE="$HOME/.bash/.bash_history"
export HISTSIZE=100000
export HISTFILESIZE=200000

export EDITOR="code --wait"
export VISUAL="$EDITOR"

export LESS='-R'

# Commands

alias spotify="flatpak run com.spotify.Client"
alias update="sudo dnf -y update --refresh && sudo dnf -y upgrade &&  flatpak update --appstream && flatpak update -y && pip install --upgrade pip"
alias steam="flatpak run com.valvesoftware.Steam"
alias gwindows='read -p "Reiniciar agora? (y/N): " c && [[ $c == y ]] && sudo reboot'
alias ps3='(cd /usr/bin/ProjectSetup-3.0 && ./ps3.sh)'
alias cls="clear"
alias explorer="fd --type f | fzf"
alias bashrc="code $HOME/.bash/.bashrc"

# Start cmd
command -v fastfetch &>/dev/null && fastfetch --config ~/.config/fastfetch/compact_config.jsonc

#Theme set
OSH_THEME="quitto_theme"

#Autocomplete
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
command -v fzf &>/dev/null && eval "$(fzf --bash)"

# SHH Agent
if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    eval "$(ssh-agent -s)" >/dev/null
fi

ssh-add -l >/dev/null 2>&1 || { [[ -f ~/.ssh/git_hub_key ]] && ssh-add ~/.ssh/git_hub_key; }

shopt -s histappend

PROMPT_COMMAND="history -a"

# Functions

flatpakrun() {
    local pattern="$1"
    local apps matches

    # Lista apps Flatpak (Nome e ID)
    apps=$(flatpak list --app --columns=name,application)

    # Filtra apps que batem com o regex
    matches=()
    while IFS=$'\t' read -r name appid; do
        if [[ "$name" =~ $pattern ]]; then
            matches+=("$name|$appid")
        fi
    done <<< "$apps"

    if [ ${#matches[@]} -eq 0 ]; then
        echo "Nenhum app Flatpak encontrado para: $pattern"
        return 1
    fi

    # Se houver mais de um match, pergunta qual executar
    local selected
    if [ ${#matches[@]} -gt 1 ]; then
        echo "Mais de um app encontrado:"
        for i in "${!matches[@]}"; do
            IFS='|' read -r name appid <<< "${matches[$i]}"
            echo "[$i] $name ($appid)"
        done
        read -rp "Escolha o número do app para rodar: " choice
        selected="${matches[$choice]}"
    else
        selected="${matches[0]}"
    fi

    IFS='|' read -r name appid <<< "$selected"
    echo "Rodando $name ($appid)..."
    flatpak run "$appid"
}

mine() {
  flatpak run \
  --command=flatpak-spawn \
  org.prismlauncher.PrismLauncher \
  --host mangohud --dlsym \
  flatpak run org.prismlauncher.PrismLauncher --launch "Sodium(Fabric)"
}

flatup() {
  echo "Atualizando Flatpak..."
  flatpak update --appstream -y
  flatpak update -y
  flatpak uninstall --unused -y
  echo "Flatpak atualizado e limpo! ✅"
}

cleansys() {
  echo "Limpando cache do sistema..."
  sudo dnf clean all
  echo "Limpo! ✅"
}

# SSH Func

ssh_active(){
    if ! pgrep -u "$USER" ssh-agent >/dev/null; then
        eval "$(ssh-agent -s)" >/dev/null
    fi

    for key in ~/.ssh/*; do
        if [[ -f "$key" && "$key" != *.pub ]]; then
            ssh-add "$key" >/dev/null 2>&1
        fi
    done
}

ssh_create() {
    local name="$1"

    if [[ -z "$name" ]]; then
        echo "󰅖 Uso: ssh_create [key_name]"
        return 1
    fi

    local ssh_dir="$HOME/.ssh"
    local key="$ssh_dir/$name"

    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"

    if [[ -f "$key" ]]; then
        echo "󰅖 Chave já existe: $key"
        return 1
    fi

    echo "󰌆 Criando chave SSH: $key"

    ssh-keygen \
        -t ed25519 \
        -C "$USER@$(hostname)" \
        -f "$key"

    chmod 600 "$key"
    chmod 644 "${key}.pub"

    if ! pgrep -u "$USER" ssh-agent >/dev/null; then
        eval "$(ssh-agent -s)" >/dev/null
    fi

    ssh-add "$key"

    echo ""
    echo "󰄬 Chave criada e adicionada ao ssh-agent!"
    echo ""
    echo "󰷖 Chave pública:"
    echo ""

    cat "${key}.pub"

    echo ""
    echo "󰒓 Caminho: $key"
}

# Utils

# Add Modules

# Oh My Bash
source "$OSH"/oh-my-bash.sh

# Coffee SDK
source "$HOME/.coffe-sdk/coffe.sh"


# If you set OSH_THEME to "random", you can ignore themes you don't like.
# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")
# You can also specify the list from which a theme is randomly selected:
# OMB_THEME_RANDOM_CANDIDATES=("font" "powerline-light" "minimal")

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# To enable/disable Spack environment information
# OMB_PROMPT_SHOW_SPACK_ENV=true  # enable
# OMB_PROMPT_SHOW_SPACK_ENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  git
  composer
  ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
  general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bashmarks
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

# If you want to reduce the initialization cost of the "tput" command to
# initialize color escape sequences, you can uncomment the following setting.
# This disables the use of the "tput" command, and the escape sequences are
# initialized to be the ANSI version:
#
#OMB_TERM_USE_TPUT=no


# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"
