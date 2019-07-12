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

					# Insertion of placeholders for a few incompatible chars
					set -l file_Path (readlink -f $argv[$s] |
					tr Ä '{A' | tr ä '{B' | tr Å '{C' | tr å '{D' |
					tr É '{E' | tr é '{F' |
					tr Ñ '{G' | tr ñ '{H' |
					tr Ö '{I' | tr ö '{J' | tr Ø '{K' | tr ø '{L' |
					tr ẞ '{M' | tr ß '{N' |
					tr Ü '{O' | tr ü '{P')

					# Passed Windows file path
					if echo $argv[$s] | grep -iq '^[a-z]:'
						set -l file_Path_Win (echo $file_Path | sed "s|$PWD||g" | cut -b 2-)

						# .exe / .bat / .lnk extension
						if echo $file_Path_Win | grep -iqE '.exe$|.bat$|.lnk$'
							echo "\"$DISK:\Users\%USERNAME%\\$WSL_DIR\wslstart.bat\" exe \"$file_Path_Win\"" | cmd.exe > /dev/null 2> /dev/null &

						# Other file extensions
						else
							echo "\"$DISK:\Users\%USERNAME%\\$WSL_DIR\wslstart.bat\" start \"$file_Path_Win\"" | cmd.exe > /dev/null 2> /dev/null &
						end

					# Execution within the WSL
					else if echo $file_Path | grep -iq '/mnt/[a-z]/'

						# Linux file path conversion
						set -l file_Path_Win (echo $file_Path | sed 's/\//\\\\/g' | cut -b 6- | sed 's/^\(.\{1\}\)/\1:/')

						# .exe / .bat / .lnk extension or whitespaces in the file's absolute path
						if echo $file_Path_Win | grep -iqE '.exe$|.bat$|.lnk$'
							echo "\"$DISK:\Users\%USERNAME%\\$WSL_DIR\wslstart.bat\" exe \"$file_Path_Win\"" | cmd.exe > /dev/null 2> /dev/null &

						# Other file extensions
						else
							echo "\"$DISK:\Users\%USERNAME%\\$WSL_DIR\wslstart.bat\" start \"$file_Path_Win\"" | cmd.exe > /dev/null 2> /dev/null &
						end

					# Execution within any Linux distribution
					else
						set -l WSL_DISTRO_DIR (echo WSL_(echo $WSL_DISTRO_NAME)_DIR)

						# .pdf file extension
						if echo $argv[$s] | grep -iq '.pdf'
							set -l file_Name (basename $file_Path)
							cp $argv[$s] /mnt/$DISK/users/$USER/
							echo "\"$DISK:\Users\%USERNAME%\\$WSL_DIR\wslstart.bat\" start \"$DISK:\Users\%USERNAME%\\$file_Name\" \"$DISK:\\$BROWSER\"" | cmd.exe > /dev/null 2> /dev/null &
							set -U process (echo $BROWSER | rev | cut -d"\\" -f1 | rev)
							fish -c 'wsl r '/mnt/$DISK/users/$USER/$argv[$s]' $process' > /dev/null &

						# Check if the current distribution is registered as a valid distribution in the WSL (--> $WSL_X_DIR)
						else if test -n $$WSL_DISTRO_DIR

							# .exe / .bat / .lnk file extension
							if echo $argv[$s] | grep -iqE '.exe$|.bat$|.lnk$'
								echo "\"$DISK:\Users\%USERNAME%\\$WSL_DIR\wslstart.bat\" exe \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &

							# No file extension
							else if echo $argv[$s] | grep -ivq '\.'
								echo "\"$DISK:\Users\%USERNAME%\\$WSL_DIR\wslstart.bat\" no \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null &

							# Other file extensions
							else
								echo "\"$DISK:\Users\%USERNAME%\\$WSL_DIR\wslstart.bat\" cmd \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2> /dev/null & 
							end

						# Distribution is not compatible / Distribution needs to be registered (--> $WSL_X_DIR)
						else
							echo "Operation not supported."
						end
					end
				end
			end
			set -g s (math $s+1)
		end
	end
end

