function x
	# Default case
	if test (count $argv) -eq 0
		cat /etc/*-release
	else
		set -g x 1
		while ! test -z $argv[$x]
			switch $argv[$x]
			case h
				cat ~/.config/fish/functions/help/x | less
				break
			case '*'

				# Start statement (--> Windows Command Prompt)
				if echo $argv[$x] | grep -iq '^start'
					echo "$argv[$x]" | cmd.exe > /dev/null 2> /dev/null

				# Windows file paths / WSL / Linux distributions
				else 
					if echo $argv[$x] | grep -iqE '^[a-z]:|^%SYSTEMDRIVE%|^%USERPROFILE%|^%APPDATA%|^%LOCALAPPDATA%'
						set -g tmp (readlink -f $argv[$x] | sed "s|$PWD||g" | cut -b 2-)
					else if readlink -f $argv[$x] | grep -iq '/mnt/[a-z]/'
						set -g tmp (readlink -f $argv[$x] | sed 's/\//\\\\/g' | cut -b 6- | sed 's/^\(.\{1\}\)/\1:/')
					else
						set -g tmp (readlink -f $argv[$x])
					end

					# Insertion of placeholders for incompatible chars
					set -l file_Path (echo $tmp |
					tr Ä '{0' | tr ä '{1' | tr Á '{2' | tr á '{3' | tr À '{4' | tr à '{5' | tr Å '{6' | tr å '{7' |
					tr Ë '{8' | tr ë '{9' | tr É '{A' | tr é '{B' | tr È '{C' | tr è '{D' |
					tr Ñ '{E' | tr ñ '{F' |
					tr Ö '{G' | tr ö '{H' | tr Ó '{I' | tr ó '{J' | tr Ò '{K' | tr ò '{L' | tr Ø '{M' | tr ø '{N' |
					tr ẞ '{O' | tr ß '{P' |
					tr Ü '{Q' | tr ü '{R' | tr Ú '{S' | tr ú '{T' | tr Ù '{U' | tr ù '{V')

					# Passed Windows file path / Execution within the WSL
					if echo $file_Path | grep -iqE '^[a-z]:|^%SYSTEMDRIVE%|^%USERPROFILE%|^%APPDATA%|^%LOCALAPPDATA%'

						# .exe / .bat / .lnk extension
						if echo $file_Path | rev | cut -d"\\" -f1 | rev | grep -iqE '.exe$|.bat$|.lnk$'
							echo "\"%USERPROFILE%\\$WSL_PROG_DIR\wsl_start.bat\" exe \"$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &
							sleep 1
							pkill -n cmd.exe

						# No file extension
                                                else if echo $file_Path | rev | cut -d"\\" -f1 | rev | grep -ivq '\.'
                                                        echo "\"%USERPROFILE%\\$WSL_PROG_DIR\wsl_start.bat\" no \"$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &

						# Other file extensions
						else
							echo "\"%USERPROFILE%\\$WSL_PROG_DIR\wsl_start.bat\" start \"$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &
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
							cp $argv[$x] /mnt/$disk/users/$user/
							echo "\"%USERPROFILE%\\$WSL_PROG_DIR\wsl_start.bat\" start \"%USERPROFILE%\\$file_Name\"" | cmd.exe > /dev/null 2> /dev/null &

							# Delete the file after it has been closed
							set -U WSL_REMOVE_INFO "/mnt/$disk/users/$user/$argv[$x]" (echo $WSL_BROWSER_DIR | rev | cut -d"\\" -f1 | rev)
							fish -c 'wsl r $WSL_REMOVE_INFO' > /dev/null 2> /dev/null &

						# Check if the current distribution is registered as a valid distribution in the WSL (--> $WSL_X_DIR)
						else if test -n $$WSL_DISTRO_DIR

							# .exe / .bat / .lnk file extension
							if echo $file_Path | rev | cut -d"/" -f1 | rev | grep -iqE '.exe$|.bat$|.lnk$'
								echo "\"%USERPROFILE%\\$WSL_PROG_DIR\wsl_start.bat\" exe \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &
								sleep 1
								pkill -n cmd.exe

							# No file extension
							else if echo $file_Path | rev | cut -d"/" -f1 | rev | grep -ivq '\.'
								echo "\"%USERPROFILE%\\$WSL_PROG_DIR\wsl_start.bat\" no \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &

							# Other file extensions
							else
								echo "\"%USERPROFILE%\\$WSL_PROG_DIR\wsl_start.bat\" cmd \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &
							end

						# Distribution is not compatible / Distribution needs to be registered (--> $WSL_X_DIR)
						else
							echo "x $argv[$x]: operation not supported"
						end
					end
				end
			end
			set -g x (math $x+1)
		end
	end
end

