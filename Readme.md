Bashmarks {#readmeTitle}
=====

Bashmarks is a shell script that allows you to save and jump to commonly used directories with tab completion. Also works with zsh
{#description}

Extra Features
--------------

* default directory when using `g` - default `$HOME`.
* Allows placing commands after the the letter e.g `g webfolder ls` would go the webfolder bookmark then perform `ls`
* `g -` Goes to the previous directory.
* `o command` to open the bookmark in Finder (Mac OS X Only).
* `y command` to open the bookmark in a new tab (Mac OS X Only).
* the `y command` works with Terminal and ITerm2

Install
-------

1. git clone git://github.com/Bilalh/shellmarks.git
2. cd shellmarks
2. make install  (or just put bashmarks.sh in your $PATH and source `it`  )
3. **source ~/.local/bin/bashmarks.sh** from within your **~.bash\_profile** or **~/.bashrc** file

Shell Commands
--------------

	s <bookmark_name>  - Saves the current directory as "bookmark_name"
	g <bookmark_name>  - Goes (cd) to the directory associated with "bookmark_name"
	d <bookmark_name>  - Deletes the bookmark
	l <bookmark_name>  - Lists the specified bookmark associated with "bookmark_name"
	l                  - Lists all available bookmarks
	s                  - Saves the default directory
	g                  - Goes to the default directory
	g -                - Goes to the previous directory
	_p <bookmark_name> - Prints the directory associated with "bookmark_name"
    
	# Mac OS X Only 
	o <bookmark_name>  - Open the directory associated with "bookmark_name" in Finder
	y <bookmark_name>  - Open the directory associated with "bookmark_name" in a new tab

Example Usage
-------------

	$ cd /var/www/
	$ s webfolder
	$ cd /usr/local/lib/
	$ s locallib
	$ l
		webfolder	 /var/www/
		locallib	 /usr/local/lib/
	$ g web<tab>
	$ g webfolder	  # cd to /var/www/
	$ o webfolder	  # Open in Finder if on mac
	$ l locallib
		locallib	 /usr/local/lib/
		
Options
-------

Set `BASHMARKS_ITERM_SESSION` to a session name to change the session that is launched when using `y` in iTerm2 on `osx` 

        
Where Bashmarks are stored
--------------------------
    
All of your directory bookmarks are saved in a file called `.sdirs` in your `$HOME` directory by default.

Authors
-------
* Bilal Syed Hussain
* Huy Nguyen (original version)

