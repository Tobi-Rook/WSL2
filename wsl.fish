function wsl
	if test (count $argv) -eq 0
		wsl.exe
	else
		set -g wsl 1
		while ! test -z $argv[$wsl]
			switch $argv[$wsl]
			case cmd
				cmd.exe 2> /dev/null
			case cp'*' mv'*'
				switch (echo $argv[$wsl] | cut -b 3)
				case a
					set -g distro_Name archlinux
				case k
					set -g distro_Name kali-linux
				case u
					set -g distro_Name ubuntu
				case '*'
					echo "wsl $argv[$wsl]: command not found"
					break
				end

				set -l file_Name (echo $argv[(math $wsl+1)])
				set -l file_Dir (echo $argv[(math $wsl+2)])

				mkdir -p /mnt/$disk/users/$user/$WSL_DIR/$distro_Name/$file_Dir

				switch (echo $argv[$wsl] | cut -b -2)
				case cp
					cp -r (readlink -f $file_Name) /mnt/$disk/users/$user/$WSL_DIR/$distro_Name/$file_Dir
				case mv
					mv (readlink -f $file_Name) /mnt/$disk/users/$user/$WSL_DIR/$distro_Name/$file_Dir
				end

				set -l scripts (echo $WSL_DIR | sed 's/\//\\\\/g')
				s "%USERPROFILE%\\$scripts\wsl$distro_Name.exe"
				set -g wsl (math $wsl+2)
			case g
				rsync -a /mnt/$disk/users/$user/$WSL_DIR/$WSL_DISTRO_NAME/* ~/
				rm -rf /mnt/$disk/users/$user/$WSL_DIR/$WSL_DISTRO_NAME/*
			case help
				cat ~/.config/fish/functions/help/wsl | less
			case na
				s "start wsl -d ArchLinux"
			case nb
				s "start bash"
			case nc
				s "start cmd"
			case nk
				s "start wsl -d kali-linux"
			case nu
				s "start wsl -d Ubuntu"
			case r
				while tasklist.exe | grep -i $argv[(math $wsl+2)] > /dev/null
					sleep 10
				end

				rm -f $argv[(math $wsl+1)]

				set -e file
				set -e process
				set -e pwd
				set -g wsl (math $wsl+2)
			case sd
				set -U disk (cmd.exe /c echo %SYSTEMDRIVE% 2> /dev/null | cut -b 1 | tr '[:upper:]' '[:lower:]')
			case su
				set -U user (cmd.exe /c echo %USERNAME% 2> /dev/null | tr -d '$'\r'')
                        case '*'
                                echo "wsl $argv[$wsl]: command not found"
			end
			set -g wsl (math $wsl+1)
		end
	end
end
