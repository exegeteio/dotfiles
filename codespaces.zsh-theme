prompt() {
    if [ ! -z "${GITHUB_USER}" ]; then
        local USERNAME="@${GITHUB_USER}"
    else
        local USERNAME="%n"
    fi
    PROMPT="%{$fg[green]%}${USERNAME} %(?:%{$reset_color%}➜ :%{$fg_bold[red]%}➜ )"
    PROMPT+='%{$fg_bold[blue]%}%~%{$reset_color%} $(git_prompt_info)%{$fg[white]%}$ %{$reset_color%}'
}
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}(%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[yellow]%}✗%{$fg_bold[cyan]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[cyan]%})"
prompt

