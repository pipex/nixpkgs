# Comment
#
my_git_prompt_info() {
	if [[ -z $(git_current_branch) ]]; then
		echo ""
	else
		color="%{$fg[green]%}"
		if [[ $(git diff --stat) != '' ]]; then
			color="%{$fg[yellow]%}"
		fi
		echo "$color  $(git_current_branch)%{$fg[magenta]%}"
	fi
}

if [ -z "$SSH_CLIENT" ] && [ -z "$SWEET_HOME_VERSION" ]; then
	PROMPT='%{$fg[magenta]%}[%c] %{$reset_color%}'
else
	PROMPT='%{$fg[magenta]%}[%m:%c] %{$reset_color%}'
fi

#RPROMPT='%{$fg[magenta]%}$(git_prompt_info)%{$reset_color%} $(git_prompt_status)%{$reset_color%}'
RPROMPT='%{$fg[magenta]%} $(my_git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ✸ %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓ %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_ADDED=""
ZSH_THEME_GIT_PROMPT_MODIFIED=""
ZSH_THEME_GIT_PROMPT_DELETED=""
ZSH_THEME_GIT_PROMPT_RENAMED=""
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%} ▼ %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED=""
