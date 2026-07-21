#!/usr/bin/env bash
# Quitto Theme - clássico alinhado, git branch e ✞

# Cores ANSI
BLACK="\[\e[30m\]"
RED="\[\e[31m\]"
GREEN="\[\e[32m\]"
YELLOW="\[\e[33m\]"
BLUE="\[\e[34m\]"
MAGENTA="\[\e[35m\]"
CYAN="\[\e[36m\]"
WHITE="\[\e[37m\]"

# Cores brilhantes
BRIGHT_BLACK="\[\e[90m\]"
BRIGHT_RED="\[\e[91m\]"
BRIGHT_GREEN="\[\e[92m\]"
BRIGHT_YELLOW="\[\e[93m\]"
BRIGHT_BLUE="\[\e[94m\]"
BRIGHT_MAGENTA="\[\e[95m\]"
BRIGHT_CYAN="\[\e[96m\]"
BRIGHT_WHITE="\[\e[97m\]"

# Formatação
BOLD="\[\e[1m\]"
DIM="\[\e[2m\]"
UNDERLINE="\[\e[4m\]"
RESET="\[\e[0m\]"

#Prefixo De Comando
PREFIX="~"

# Ícones Nerd Fonts
ICON_BRANCH=""   # ícone branch Git
ICON=""
ICON_TERMINAL="" # ícone terminal

# Função para pegar branch do git
function _omb_theme_git_branch() {
    # Tenta pegar a branch, ignorando erros de ownership
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    if [ -n "$branch" ]; then
        echo "(${CYAN}${ICON_BRANCH} ${branch}${RESET})"
    fi
}

# Função para o prompt
function _omb_theme_PROMPT_COMMAND() {
    local git_branch=$(_omb_theme_git_branch)

    # Verifica se está na home e define path e prefix
    local prefix_text=""
    local path_display=""

    if [ "$PWD" = "$HOME" ]; then
        # Na home: mostra ~ sem prefix
        path_display="~"
    else
        # Fora da home: mostra o caminho completo + prefix
        path_display="${PWD/#$HOME/\~}"
        prefix_text="${PREFIX}"
    fi

    # parte esquerda do prompt
    local left="${ICON} ${GREEN}\u${RESET}@${BLUE}\h${RESET}:${BRIGHT_BLUE}${path_display}${RESET}${prefix_text}"

    # preencher com espaços até uma largura fixa (40 chars por exemplo)
    local padded_left=$(printf "%-40s" "$left")

    # prompt final
    PS1="${padded_left}${git_branch} "
}

# Registra a função no OMB
_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND
