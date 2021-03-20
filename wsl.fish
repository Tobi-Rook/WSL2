function wsl
  if test (count $argv) -eq 0
    x_wsl x_rls0 "wt"
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
        case d
          set -g distro_Name debian
        case k
          set -g distro_Name kali-linux
        case u
          set -g distro_Name ubuntu
        case z
          set -g distro_Name docker-desktop
        case '*'
          echo "wsl $argv[$wsl]: command not found"
          break
        end

        set -l file $argv[(math $wsl+1)] $argv[(math $wsl+2)]
        mkdir -p $WSL_PROG_DIR/$distro_Name/$file[1]

        switch (echo $argv[$wsl] | cut -b -2)
        case cp
          cp -r (readlink -f $file[2]) $WSL_PROG_DIR/$distro_Name/$file[1]
        case mv
          mv (readlink -f $file[2]) $WSL_PROG_DIR/$distro_Name/$file[1]
        end

        set -l wsl_prog_dir (echo $WSL_PROG_DIR | sed 's/\//\\\\/g')
        x_wsl "$wsl_prog_dir\scripts\wsl_"$distro_Name"_get.exe"
      case g
        rsync -a $WSL_PROG_DIR/$WSL_DISTRO_NAME/* ~/
        rm -rf $WSL_PROG_DIR/$WSL_DISTRO_NAME/*
      case h
        cat $WSL_HELP_DIR/wsl
        break
      case k
        taskkill.exe /fi "IMAGENAME eq "$argv[(math $wsl+1)]"*" /im \* > /dev/null 2> /dev/null
      case kf
        taskkill.exe /f /fi "IMAGENAME eq "$argv[(math $wsl+1)]"*" /im \* > /dev/null
      case na
        x_wsl "start wt new-tab -p \"Arch Linux\""
      case nac
        x_wsl "start wt new-tab -p \"Azure Cloud Shell\""
      case nb
        x_wsl "start bash"
      case nc
        x_wsl "start wt new-tab -p \"Command Prompt\""
      case nd
        x_wsl "start wt new-tab -p \"Debian\""
      case ndo
        x_wsl "start wt new-tab -p \"Docker\""
      case nf
        x_wsl "start wt -F"
      case ngc
        x_wsl "start wt new-tab -p \"Google Cloud Platform\""
      case nk
        x_wsl "start wt new-tab -p \"Kali Linux\""
      case nps
        x_wsl "start wt new-tab -p \"PowerShell\""
      case nu
        x_wsl "start wt new-tab -p \"Ubuntu\""
      case q
        set -e WSL_RESTART_INFO
        set -e WSL_RESTART_WINS
        wslconfig.exe /t $WSL_DISTRO_NAME
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
        if ! test -z $argv[(math $wsl+1)]
          switch $argv[(math $wsl+1)]
          case i
            if test "$WSL_THEME_INFO" = "dark"
              set -U WSL_THEME_INFO light
            else
              set -U WSL_THEME_INFO dark
            end
            wsl xl xr
          case '*'
            if test -d ~/.wsl_config/.colors/$argv[(math $wsl+1)]
              set -U WSL_THEME_INFO $argv[(math $wsl+1)]
              wsl xl xr
            else
              echo "wsl t: theme not found"
              break
            end
          end
        else
          set -U WSL_THEME_INFO dark
          wsl xl xr
        end
      case xi
        if tasklist.exe | grep -i WindowsTerminal.exe > /dev/null
          for session in $WSL_RESTART_WINS
            x_wsl "start wt"
          end
          t ks
        else if wmic.exe process get name, parentprocessid | grep conhost.exe | grep (wmic.exe process get name, parentprocessid | grep WMIC.exe | tr -d WMIC.exe | tr -d ' ' | tr -d '$'\r'') > /dev/null
          for session in $WSL_RESTART_WINS
            x_wsl "start wsl tmux new-session -s $session"
          end
          t ks
        else
          echo "wsl xi: settings not found"
        end
      case xl
        ln -fs ~/.wsl_config/.colors/$WSL_THEME_INFO/colorschemes $WSL_PYPKG_DIR/powerline/config_files/
        ln -fs ~/.wsl_config/.colors/$WSL_THEME_INFO/.vimrc ~/.vimrc
        ln -fs ~/.wsl_config/.colors/$WSL_THEME_INFO/.dircolors ~/.dircolors
      case xr
        set -U WSL_RESTART_INFO $PWD (history | head -1)
        set -U WSL_RESTART_WINS (tmux list-sessions -F "#{session_name}")
        set -l wsl_prog_dir (echo $WSL_PROG_DIR | sed 's/\//\\\\/g')

        if tasklist.exe | grep -i WindowsTerminal.exe > /dev/null && test -z $wsl_restart_inv
          sed -i "s/\"colorScheme.*/\"colorScheme\": \"$WSL_THEME_INFO\",/g" $WSL_TERM_FILE
          echo "\"$wsl_prog_dir\scripts\wsl_restart.bat\" $WSL_DISTRO_NAME \"wt -F\"" | cmd.exe > /dev/null 2> /dev/null
        else if wmic.exe process get name, parentprocessid | grep conhost.exe | grep (wmic.exe process get name, parentprocessid | grep WMIC.exe | tr -d WMIC.exe | tr -d ' ' | tr -d '$'\r'') > /dev/null || ! test -z $wsl_restart_inv
          echo "\"$wsl_prog_dir\ColorTool\ColorTool.exe\" -d -x $WSL_THEME_INFO.itermcolors" | cmd.exe > /dev/null 2> /dev/null
          echo "\"$wsl_prog_dir\scripts\wsl_restart.bat\" $WSL_DISTRO_NAME wsl" | cmd.exe > /dev/null 2> /dev/null
        else
          echo "wsl xr: program not found"
        end
      case xri
        set -g wsl_restart_inv 1
        wsl xr
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
