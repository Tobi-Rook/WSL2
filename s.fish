function s
	# Default case
	if test (count $argv) -eq 0
		cat /etc/*-release
	else
		set -g s 1
		while ! test -z $argv[$s]
			switch $argv[$s]
			case help
				cat ~/.config/fish/functions/help/s | less
			case '*'

				# Start statement (--> Windows Command Prompt)
				if echo $argv[$s] | grep -iq '^start'
					echo "$argv[$s]" | cmd.exe > /dev/null 2> /dev/null

				# Windows file paths / WSL / Linux distributions
				else 
					if echo $argv[$s] | grep -iqE '^[a-z]:|^%SYSTEMDRIVE%'
						set -g tmp (readlink -f $argv[$s] | sed "s|$PWD||g" | cut -b 2-)
					else if readlink -f $argv[$s] | grep -iq '/mnt/[a-z]/'
						set -g tmp (readlink -f $argv[$s] | sed 's/\//\\\\/g' | cut -b 6- | sed 's/^\(.\{1\}\)/\1:/')
					else
						set -g tmp (readlink -f $argv[$s])
					end

					# Insertion of placeholders for a few incompatible chars
					set -l file_Path (echo $tmp |
					tr Ä '{A' | tr ä '{B' | tr Å '{C' | tr å '{D' |
					tr É '{E' | tr é '{F' |
					tr Ñ '{G' | tr ñ '{H' |
					tr Ö '{I' | tr ö '{J' | tr Ø '{K' | tr ø '{L' |
					tr ẞ '{M' | tr ß '{N' |
					tr Ü '{O' | tr ü '{P')

					# Passed Windows file path / Execution within the WSL
					if echo $file_Path | grep -iqE '^[a-z]:|^%SYSTEMDRIVE%'

						# .exe / .bat / .lnk extension
						if echo $file_Path | rev | cut -d"\\" -f1 | rev | grep -iqE '.exe$|.bat$|.lnk$'
							echo "\"%USERPROFILE%\\$WSL_DIR\wslstart.bat\" exe \"$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &

						# No file extension
                                                else if echo $file_Path | rev | cut -d"\\" -f1 | rev | grep -ivq '\.'
                                                        echo "\"%USERPROFILE%\\$WSL_DIR\wslstart.bat\" no \"$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &

						# Other file extensions
						else
							echo "\"%USERPROFILE%\\$WSL_DIR\wslstart.bat\" start \"$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &
						end

					# Execution within any Linux distribution
					else
						set -l WSL_DISTRO_DIR (echo WSL_(echo $WSL_DISTRO_NAME)_DIR)

						# .pdf file extension
						if echo $file_Path | rev | cut -d"/" -f1 | rev | grep -iq '.pdf'

							# Get disk and current user
							set -l disk (cmd.exe /c echo %SYSTEMDRIVE% 2> /dev/null | cut -b 1 | tr '[:upper:]' '[:lower:]')
							set -l user (cmd.exe /c echo %USERNAME% 2> /dev/null | tr -d '$'\r'')

							# Copy the specified file outside the WSL and open it
							set -l file_Name (basename $file_Path)
							cp $argv[$s] /mnt/$disk/users/$user/
							echo "\"%USERPROFILE%\\$WSL_DIR\wslstart.bat\" start \"%USERPROFILE%\\$file_Name\"" | cmd.exe > /dev/null 2> /dev/null &

							# Delete the file after it has been closed
							set -U file "/mnt/$disk/users/$user/$argv[$s]"
							set -U process (echo $BROWSER | rev | cut -d"\\" -f1 | rev)
							fish -c 'wsl r $file $process' > /dev/null 2> /dev/null &

						# Check if the current distribution is registered as a valid distribution in the WSL (--> $WSL_X_DIR)
						else if test -n $$WSL_DISTRO_DIR

							# .exe / .bat / .lnk file extension
							if echo $file_Path | rev | cut -d"/" -f1 | rev | grep -iqE '.exe$|.bat$|.lnk$'
								echo "\"%USERPROFILE%\\$WSL_DIR\wslstart.bat\" exe \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &

							# No file extension
							else if echo $file_Path | rev | cut -d"/" -f1 | rev | grep -ivq '\.'
								echo "\"%USERPROFILE%\\$WSL_DIR\wslstart.bat\" no \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &

							# Other file extensions
							else
								echo "\"%USERPROFILE%\\$WSL_DIR\wslstart.bat\" cmd \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &
							end

						# Distribution is not compatible / Distribution needs to be registered (--> $WSL_X_DIR)
						else
							echo "s $argv[$s]: operation not supported"
						end
					end
				end
			end
			set -g s (math $s+1)
		end
	end
end

