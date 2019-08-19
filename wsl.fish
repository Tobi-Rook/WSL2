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

				set -l file $argv[(math $wsl+1)] $argv[(math $wsl+2)]
				mkdir -p /mnt/$disk/users/$user/$WSL_PROG_DIR/$distro_Name/$file[1]

				switch (echo $argv[$wsl] | cut -b -2)
				case cp
					cp -r (readlink -f $file[2]) /mnt/$disk/users/$user/$WSL_PROG_DIR/$distro_Name/$file[1]
				case mv
					mv (readlink -f $file[2]) /mnt/$disk/users/$user/$WSL_PROG_DIR/$distro_Name/$file[1]
				end

				set -l scripts (echo $WSL_PROG_DIR | sed 's/\//\\\\/g')
				x "%USERPROFILE%\\$scripts\wsl_"$distro_Name"_get.exe"
			case g
				rsync -a /mnt/$disk/users/$user/$WSL_PROG_DIR/$WSL_DISTRO_NAME/* ~/
				rm -rf /mnt/$disk/users/$user/$WSL_PROG_DIR/$WSL_DISTRO_NAME/*
			case h
				cat ~/.config/fish/functions/help/wsl | less
				break
			case k
				taskkill.exe /fi "IMAGENAME eq "$argv[(math $wsl+1)]"*" /im \* > /dev/null 2> /dev/null
			case kf
				taskkill.exe /f /fi "IMAGENAME eq "$argv[(math $wsl+1)]"*" /im \* > /dev/null
			case na
				x "start wsl -d ArchLinux"
			case nb
				x "start bash"
			case nc
				x "start cmd"
			case nk
				x "start wsl -d kali-linux"
			case nu
				x "start wsl -d Ubuntu"
			case q
				set -e WSL_RESTART_INFO
				wslconfig.exe /T $WSL_DISTRO_NAME
			case r
				while tasklist.exe | grep -i $argv[(math $wsl+2)] > /dev/null
					sleep 10
				end

				rm -f $argv[(math $wsl+1)]
				set -e WSL_REMOVE_INFO
			case sd
				set -U disk (cmd.exe /c echo %SYSTEMDRIVE% 2> /dev/null | cut -b 1 | tr '[:upper:]' '[:lower:]')
			case su
				set -U user (cmd.exe /c echo %USERNAME% 2> /dev/null | tr -d '$'\r'')
			case t
				switch $argv[(math $wsl+1)]
				case i
					if test "$WSL_THEME_INFO" = "dark"
						set -U WSL_THEME_INFO light
					else
						set -U WSL_THEME_INFO dark
					end
				case '*'
					if test -d ~/.wsl_config/.colors/$argv[(math $wsl+1)]
						set -U WSL_THEME_INFO $argv[(math $wsl+1)]
					else
						echo "wsl t: theme not found"
						break
					end
				end

				ln -fs ~/.wsl_config/.colors/$WSL_THEME_INFO/colorschemes $WSL_PYPKG_DIR/powerline/config_files/
				ln -fs ~/.wsl_config/.colors/$WSL_THEME_INFO/$hostname/.vimrc ~/.vimrc

				set -U WSL_RESTART_WD $PWD
				set -l theme (echo $WSL_PROG_DIR | sed 's/\//\\\\/g') (echo $WSL_THEME_INFO | sed 's/\([a-z]\)\([a-zA-Z]*\)/\u\1\2/g')
				echo "\"%USERPROFILE%\\$theme[1]\wsl_restart.bat\" $WSL_DISTRO_NAME \"%USERPROFILE%\\$theme[1]\Windows Subsystem for Linux ($theme[2] Theme).lnk\"" | cmd.exe > /dev/null 2> /dev/null
                        case '*'
                                echo "wsl $argv[$wsl]: command not found"
				break
			end

			switch (echo $argv[$wsl] | cut -b 1)
			case c m r
				set -g wsl (math $wsl+3)
			case k t
				set -g wsl (math $wsl+2)
			case '*'
				set -g wsl (math $wsl+1)
			end
		end
	end
end

