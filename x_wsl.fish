function x_wsl
	# Default case
	if test (count $argv) -eq 0
		cat /etc/{*-release, *_version}
	else
		set -g x_wsl 1
		while ! test -z $argv[$x_wsl]
			switch $argv[$x_wsl]
			case h
				cat $WSL_HELP_DIR/x_wsl | less
				break
			case x_rls0
				set -l file_Path $argv[(math $x_wsl+1)]
				echo "\"$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &
				break
			case '*'
				# Start statements (--> Windows Command Prompt)
				if echo $argv[$x_wsl] | grep -iq '^start'
					echo "$argv[$x_wsl]" | cmd.exe > /dev/null 2> /dev/null

				# Internet addresses
				else if echo $argv[$x_wsl] | grep -qE '^http|www.'
					echo "\"%SYSTEMDRIVE%\\$WSL_BROWSER_DIR\" \"$argv[$x_wsl]\"" | cmd.exe > /dev/null 2> /dev/null

				# Windows file paths / WSL / Linux distributions
				else

					# Function call with performance flag enabled
					if echo $argv[$x_wsl] | grep -q x_rls1
						set -g tmp $argv[(math $x_wsl+1)]
					else
						set -g tmp $argv[$x_wsl]
					end

					if echo $tmp | grep -iqE '^[a-z]:|^%SYSTEMDRIVE%|^%USERPROFILE%|^%APPDATA%|^%LOCALAPPDATA%|^%OneDrive%'
						set -g file_Path (readlink -f $tmp | sed "s|$PWD||g" | cut -b 2-)
					else if readlink -f $tmp | grep -iq '/mnt/[a-z]/'
						set -g file_Path (readlink -f $tmp | sed 's/\//\\\\/g' | cut -b 6- | sed 's/^\(.\{1\}\)/\1:/')
					else
						set -g file_Path (readlink -f $tmp)
					end

					# Default function call with character encoding conversion
					if echo $argv[$x_wsl] | grep -qv x_rls1

						# Insertion of placeholders for incompatible chars
						set -g file_Path (echo $file_Path | sed                            \
						    -e 's/Ä/{00/g;      s/Á/{01/g;      s/À/{02/g;      s/Å/{03/g' \
						    -e 's/ä/{04/g;      s/á/{05/g;      s/à/{06/g;      s/å/{07/g' \
						    -e 's/Æ/{08/g;      s/æ/{09/g'                                 \
						    -e 's/Ç/{10/g;      s/ç/{11/g'                                 \
						    -e 's/Ë/{12/g;      s/É/{13/g;      s/È/{14/g'                 \
						    -e 's/ë/{15/g;      s/é/{16/g;      s/è/{17/g'                 \
						    -e 's/Ğ/{18/g'                                                 \
						    -e 's/ğ/{19/g'                                                 \
						    -e 's/Ï/{20/g;      s/Î/{21/g'                                 \
						    -e 's/ï/{22/g;      s/î/{23/g'                                 \
						    -e 's/Ñ/{24/g'                                                 \
						    -e 's/ñ/{25/g'                                                 \
						    -e 's/Ö/{26/g;      s/Ó/{27/g;      s/Ò/{28/g;      s/Ø/{29/g' \
						    -e 's/ö/{30/g;      s/ó/{31/g;      s/ò/{32/g;      s/ø/{33/g' \
						    -e 's/ẞ/{34/g;      s/Ş/{35/g'                                 \
						    -e 's/ß/{36/g;      s/ş/{37/g'                                 \
						    -e 's/Ü/{38/g;      s/Ú/{39/g;      s/Ù/{40/g'                 \
						    -e 's/ü/{41/g;      s/ú/{42/g;      s/ù/{43/g'                 \
						    -e 's/Ÿ/{44/g'                                                 \
						    -e 's/ÿ/{45/g'                                                 \
						    -e 's/©/{46/g;      s/℗/{47/g;      s/®/{48/g;      s/™/{49/g' )
					end

					# Passed Windows file path / Execution within the WSL
					if echo $file_Path | grep -iqE '^[a-z]:|^%SYSTEMDRIVE%|^%USERPROFILE%|^%APPDATA%|^%LOCALAPPDATA%|^%OneDrive%'

						# .exe / .bat / .lnk extension
						if echo $file_Path | rev | cut -d"\\" -f1 | rev | grep -iqE '.exe$|.bat$|.lnk$'
							echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" exe \"$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &
							sleep 1
							pkill -n cmd.exe

						# Directories
						else if test -d $argv[$x_wsl]
							echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" dir \"$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &

						# No file extension
						else if echo $file_Path | rev | cut -d"\\" -f1 | rev | grep -ivq '\.'
							echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" code \"$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &

						# Other file extensions
						else
							echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" start \"$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &
						end

					# Execution within any Linux distribution
					else
						set -l WSL_DISTRO_DIR (echo WSL_(echo $WSL_DISTRO_NAME)_DIR)

						# .pdf file extension
						if echo $file_Path | rev | cut -d"/" -f1 | rev | grep -iq '.pdf'

							# Get disk and current user if not available
							if test -z $disk
								set -U disk (cmd.exe /c echo %SYSTEMDRIVE% 2> /dev/null | cut -b 1 | tr '[:upper:]' '[:lower:]')
							end

							if test -z $user
								set -U user (cmd.exe /c echo %USERNAME% 2> /dev/null | tr -d '$'\r'')
							end

							# Copy the specified file outside the WSL and open it
							set -l file_Name (basename $file_Path)
							cp $argv[$x_wsl] /mnt/$disk/users/$user/
							echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" start \"%USERPROFILE%\\$file_Name\"" | cmd.exe > /dev/null 2> /dev/null &

							# Delete the file after it has been closed
							set -U WSL_REMOVE_INFO "/mnt/$disk/users/$user/$argv[$x_wsl]" (echo $WSL_BROWSER_DIR | rev | cut -d"\\" -f1 | rev)
							fish -c 'wsl r $WSL_REMOVE_INFO' > /dev/null 2> /dev/null &

						# Check if the current distribution is registered as a valid distribution in the WSL (--> $WSL_X_DIR)
						else if test -n $$WSL_DISTRO_DIR

							# .exe / .bat / .lnk file extension
							if echo $file_Path | rev | cut -d"/" -f1 | rev | grep -iqE '.exe$|.bat$|.lnk$'
								echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" exe \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &
								sleep 1
								pkill -n cmd.exe

							# Directories
							else if test -d $file_Path
								editor $file_Path

							# No file extension
							else if echo $file_Path | rev | cut -d"/" -f1 | rev | grep -ivq '\.' || echo $file_Path | rev | cut -d"/" -f1 | rev | grep -q '^\.'
								echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" code \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &

							# Other file extensions
							else
								echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" cmd \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &
							end

						# Distribution is not compatible / Distribution needs to be registered (--> $WSL_X_DIR)
						else
							echo "x_wsl $argv[$x_wsl]: operation not supported"
						end
					end

					# Function call with performance flag enabled
					if echo $argv[$x_wsl] | grep -q x_rls1
						break
					end
				end
			end
			set -g x_wsl (math $x_wsl+1)
		end
	end
end
