if test -f /etc/profile.d/git-sdk.sh
then
	TITLEPREFIX=SDK-${MSYSTEM#MINGW}
else
	TITLEPREFIX=$MSYSTEM
fi

if test -f ~/.config/git/git-prompt.sh
then
	. ~/.config/git/git-prompt.sh
else
	PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
	PS1="$PS1"'\n'                 # new line
	if [ -z "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
		PS1="$PS1"'\[\033[95m\] \u ' 
		PS1="$PS1"'working in '  
		PS1="$PS1"'\w'
	else
			GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)  
			OWNER=$(git config --get remote.origin.url | sed -n 's/.*\/\([^/]*\)\/[^/]*$/\1/p') # Get the repository owner
			PS1="$PS1"'\[\033[95m\] \u '
			PS1="$PS1"'working in '  
			PS1="$PS1"'\w'
			PS1="$PS1"' on '  
			PS1="$PS1"'🍴 $GIT_BRANCH [$OWNER] is 📦 v1.0.0'
	fi
fi

if docker info &> /dev/null; then
	PS1="$PS1"'\[\033[34m\] 🐳 Docker on'  
else 
	PS1="$PS1"'\[\033[34m\] 🐳 Docker off'  
fi

if test -z "$WINELOADERNOEXEC"
then
	GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
	COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
	COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
	COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
	if test -f "$COMPLETION_PATH/git-prompt.sh"
	then
		. "$COMPLETION_PATH/git-completion.bash"
		. "$COMPLETION_PATH/git-prompt.sh"
		PS1="$PS1"'`__git_ps1`'   # bash function
	fi
fi

PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'→ '                 # prompt: always $

MSYS2_PS1="$PS1"               # for detection by MSYS2 SDK's bash.basrc

# Evaluate all user-specific Bash completion scripts (if any)
if test -z "$WINELOADERNOEXEC"
then
	for c in "$HOME"/bash_completion.d/*.bash
	do
		# Handle absence of any scripts (or the folder) gracefully
		test ! -f "$c" ||
		. "$c"
	done
fi
