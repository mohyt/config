if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi
shopt -s checkwinsize
shopt -s histappend
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

use_color=false

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

usern=$(whoami)
hostn=$(hostname)
function prompt {
	ctime=$(date +%T)
	prmpt="-[ ${usern}@${hostn} ${PWD} ][${ctime}]"
	cols=$(tput cols)
	let FILLS=${cols}-${#prmpt}
	LINE=""

	if [[ "$PWD" =~ "/home/$usern" ]]
	 then
	  let FILLS=$FILLS+5+${#usern}
	fi

	for (( f=0; f<$FILLS; f++ ))  do
		LINE=$LINE"\e(0─\e(B"
	done
	if [[ ${EUID} == 0 ]] ; then
		PS1="\n\[\033[00;34m\]┌[ \[\033[00;31m\]\u\[\033[00;34m\]@\[\033[00;32m\]\h\[\033[00;34m\] \w ]${LINE}[\[\033[00;37m\]${ctime}\[\033[00;34m\]]\n└─»\[\033[00m\] "
	else
		PS1="\n\[\033[00;34m\]┌[ \[\033[00;32m\]\u\[\033[00;34m\]@\[\033[00;32m\]\h\[\033[00;34m\] \w ]${LINE}[\[\033[00;37m\]${ctime}\[\033[00;34m\]]\n└─»\[\033[00m\] "
	fi
}
PROMPT_COMMAND=prompt

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	alias ls='ls --group-directories-first --color=auto'
	alias grep='grep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
	alias ls='ls --group-directories-first'
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

# Help java apps work with awesomewm
export AWT_TOOLKIT=MToolkit

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/bin/python /usr/lib/command-not-found -- $1
                   return $?
                elif [ -x /usr/share/command-not-found ]; then
		   /usr/bin/python /usr/share/command-not-found -- $1
                   return $?
		else
		   return 127
		fi
	}
fi

# aliases
alias ll='ls -hl'
alias la='ll -A'
