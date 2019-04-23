#!/bin/sh

link_files () {
  ln -vs $1 $2
}

link () {
	echo "This utility will symlink the files in this repo to the home directory"
	echo "Proceed? (y/n)"
	read resp

	# check answer
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then

		overwrite_all=false
		backup_all=false
		skip_all=false

		for source in $( find . -maxdepth 2 -name '*.symlink' ) ; 
		do
			dest="$HOME/$( basename "$source" '.symlink' )"

			# -f: true if file exists, -d: true if directory exists
			if [ -f $dest ] || [ -d $dest ];
    	then
				overwrite=false
				backup=false
				skip=false

				if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
				then
					echo "File already exists: $dest, what do you want to do?\n [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
					read -n 1 action

					case "$action" in
						o )
							overwrite=true;;
						O )
							overwrite_all=true;;
						b )
							backup=true;;
						B )
							backup_all=true;;
						s )
							skip=true;;
						S )
							skip_all=true;;
						* )
							;;
					esac
      	fi

				if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]
				then
					rm -rf $dest
					echo removed $dest
				fi

				if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]
				then
					mv $dest $dest\.backup
					echo moved $dest to $dest.backup
				fi

				if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]
				then
					link_files $source $dest
				else
					echo skipped $source
				fi

			else
				# -L: true if symlink already exists
				if [ -L $dest ]
				then
					echo "symlink for $dest already exists"
				else
					link_files $source $dest
				fi
			fi

		done

		echo "Symlinking complete"
		
		else
			echo "Symlinking cancelled by user"
		
		return 1
	fi
}

link