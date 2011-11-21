
# fork of bashmarks that has mac specific features	  

# USAGE: 
# s <bookmark_name>  - Saves the current directory as "bookmark_name"
# g <bookmark_name>  - Goes (cd) to the directory associated with "bookmark_name"
# o <bookmark_name>  - Open the directory associated with "bookmark_name" in Finder
# d <bookmark_name>  - Deletes the bookmark
# l <bookmark_name>  - Lists the specified bookmark associated with "bookmark_name"
# l                  - Lists all available bookmarks
# s                  - Saves the default directory
# g                  - Goes to the default directory
# g -                - Goes to the previous directory
# _p <bookmark_name> - Prints the directory associated with "bookmark_name"

# Tab completion for g o p and d 
# setup file to store bookmarks
if [ ! -n "$SDIRS" ]; then
	SDIRS=~/.sdirs
fi
touch $SDIRS

# save current directory to bookmarks
function s {
	check_help $1
	_bookmark_name_valid "$@"
	if [ -z "$exit_message" ]; then
		if [ -z "$@" ]; then
			_purge_line "$SDIRS" "export DIR_DEFAULT="
			CURDIR=$(echo $PWD| sed "s#^$HOME#\$HOME#g")
			echo "export DIR_DEFAULT=\"$CURDIR\"" >> $SDIRS
		else
			_purge_line "$SDIRS" "export DIR_$1="
			CURDIR=$(echo $PWD| sed "s#^$HOME#\$HOME#g")
			echo "export DIR_$1=\"$CURDIR\"" >> $SDIRS
		fi
	fi
}

# open the specifed bookmark
function o {
	if [ -z $1 ]; then
		bashmarks_list
	else
		check_help $1
		source $SDIRS
		open "$(eval $(echo echo $(echo \$DIR_$1)))"
		cd "$(eval $(echo echo $(echo \$DIR_$1)))"
		pwd; shift; $*
		osascript -e 'tell application "Finder"' -e 'activate' -e 'end tell'
	fi
}

# jump to bookmark
function g {
	check_help $1
	source $SDIRS
	if [ -z "$@" ]; then
		cd "$(eval $(echo echo $(echo \$DIR_DEFAULT)))"
		pwd; $*
	elif [ "$1" == "-" ]; then 
		cd -;
		shift; $*
	else 
		cd "$(eval $(echo echo $(echo \$DIR_$1)))"
		pwd; shift; $*
	fi
}

# print bookmark
function _p {
	check_help $1
	source $SDIRS
	echo "$(eval $(echo echo $(echo \$DIR_$1)))"
}

# delete bookmark
function d {
	check_help $1
	_bookmark_name_valid "$@"
	if [ -z "$exit_message" ]; then
		_purge_line "$SDIRS" "export DIR_$1="
		unset "DIR_$1"
	fi
}

# print out help for the forgetful
function check_help {
	if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] ; then
		echo ''
		echo 's <bookmark_name>	 - Saves the current directory as "bookmark_name"'
		echo 'o <bookmark_name>	 - Open the directory associated with "bookmark_name" in Finder'
		echo 'g <bookmark_name>	 - Goes (cd) to the directory associated with "bookmark_name"'
		echo 'd <bookmark_name>	 - Deletes the bookmark'
		echo 's					 - Saves the default directory'
		echo 'g					 - Goes to the default directory'
		echo 'l					 - Lists all available bookmarks'
		echo 'l <bookmark_name>	 - Lists the specified bookmark associated with "bookmark_name"'
		echo '_p <bookmark_name> - Prints the directory associated with "bookmark_name"'
		kill -SIGINT $$
	fi
}

# list bookmarks with dirnam
alias l='_bookmarks'
function _bookmarks {
	check_help $1
	source $SDIRS
	 
	if [  -n "$1" ]; then 
		# if color output is not working for you, comment out the line below '\033[1;34m' == "blue"
		env | sort | grep "DIR_$1" |  awk '/DIR_.+/{split(substr($0,5),parts,"="); printf("\033[1;34m%-20s\033[0m %s\n", parts[1], parts[2]);}'
		# uncomment this line if color output is not working with the line above
		# env | grep "^DIR_" | cut -c5-	 | grep "^.*=" | sort
	else 
		# if color output is not working for you, comment out the line below '\033[1;34m' == "blue"
		env | sort | awk '/DIR_.+/{split(substr($0,5),parts,"="); printf("\033[1;34m%-20s\033[0m %s\n", parts[1], parts[2]);}'
		# uncomment this line if color output is not working with the line above
		# env | grep "^DIR_" | cut -c5-	 | grep "^.*=" | sort  
	fi
}

# list bookmarks without dirname
function _l {
	source $SDIRS
	env | grep "^DIR_" | cut -c5- | sort | grep "^.*=" | cut -f1 -d "=" 
}

# validate bookmark name
function _bookmark_name_valid {
	exit_message=""
	if [ "$1" != "$(echo $1 | sed 's/[^A-Za-z0-9_]//g')" ]; then
		exit_message="bookmark name is not valid"
		echo $exit_message
	fi
}

# completion command
function _comp {
	local curw
	COMPREPLY=()
	curw=${COMP_WORDS[COMP_CWORD]}
	COMPREPLY=($(compgen -W '`_l`' -- $curw))
	return 0
}

# ZSH completion command
function _compzsh {
	reply=($(_l))
}

# safe delete line from sdirs
function _purge_line {
	if [ -s "$1" ]; then
		# safely create a temp file
		t=$(mktemp -t bashmarks.XXXXXX) || exit 1
		trap "rm -f -- '$t'" EXIT

		# purge line
		sed "/$2/d" "$1" > "$t"
		mv "$t" "$1"

		# cleanup temp file
		rm -f -- "$t"
		trap - EXIT
	fi
}

# bind completion command for o g,p,d to _comp
if [ $ZSH_VERSION ]; then
	compctl -K _compzsh o
	compctl -K _compzsh g
	compctl -K _compzsh _p
	compctl -K _compzsh d
else
	shopt -s progcomp
	complete -F _comp o
	complete -F _comp g
	complete -F _comp _p
	complete -F _comp d
fi
