set -g func wsl

function $func
  if test (count $argv) -eq 0
    x_wsl x_rls0 "wt"
  else
    set -g $func 1
    while ! test -z $argv[$$func]
      switch $argv[$$func]
      case cmd
        cmd.exe 2> /dev/null
      case cp'*' mv'*'
        switch (echo $argv[$$func] | cut -b 3)
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
          echo "$func $argv[$$func]: command not found"
          break
        end

        set -l file $argv[(math $$func+1)] $argv[(math $$func+2)]
        mkdir -p $WSL_PROG_DIR/$distro_Name/$file[1]

        switch (echo $argv[$$func] | cut -b -2)
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
        cat $WSL_HELP_DIR/$func
        break
      case k
        taskkill.exe /fi "IMAGENAME eq "$argv[(math $$func+1)]"*" /im \* > /dev/null 2> /dev/null
      case kf
        taskkill.exe /f /fi "IMAGENAME eq "$argv[(math $$func+1)]"*" /im \* > /dev/null
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
        while tasklist.exe | grep -i $argv[(math $$func+2)] > /dev/null
          sleep 10
        end

        rm -f $argv[(math $$func+1)]
        set -e WSL_REMOVE_INFO
      case sd
        set -U disk (cmd.exe /c echo %SYSTEMDRIVE% 2> /dev/null | cut -b 1 | tr '[:upper:]' '[:lower:]')
      case su
        set -U user (cmd.exe /c echo %USERNAME% 2> /dev/null | tr -d '$'\r'')
      case t
        if ! test -z $argv[(math $$func+1)]
          switch $argv[(math $$func+1)]
          case i
            if test "$WSL_THEME_INFO" = "dark"
              set -U WSL_THEME_INFO light
            else
              set -U WSL_THEME_INFO dark
            end
            $func xl xr
          case '*'
            if test -d ~/.wsl_config/.colors/$argv[(math $$func+1)]
              set -U WSL_THEME_INFO $argv[(math $$func+1)]
              $func xl xr
            else
              echo "$func t: theme not found"
              break
            end
          end
        else
          set -U WSL_THEME_INFO dark
          $func xl xr
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
          echo "$func xi: settings not found"
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
          echo "\"$wsl_prog_dir\scripts\wsl_restart.bat\" $WSL_DISTRO_NAME \"wt -f\"" | cmd.exe > /dev/null 2> /dev/null
        else if wmic.exe process get name, parentprocessid | grep conhost.exe | grep (wmic.exe process get name, parentprocessid | grep WMIC.exe | tr -d WMIC.exe | tr -d ' ' | tr -d '$'\r'') > /dev/null || ! test -z $wsl_restart_inv
          echo "\"$wsl_prog_dir\ColorTool\ColorTool.exe\" -d -x $WSL_THEME_INFO.itermcolors" | cmd.exe > /dev/null 2> /dev/null
          echo "\"$wsl_prog_dir\scripts\wsl_restart.bat\" $WSL_DISTRO_NAME wsl" | cmd.exe > /dev/null 2> /dev/null
        else
          echo "$func xr: program not found"
        end
      case xri
        set -g wsl_restart_inv 1
        $func xr
      case '*'
        echo "$func $argv[$$func]: command not found"
        break
      end

      switch (echo $argv[$$func] | cut -b 1)
      case c m r
        set -g $func (math $$func+3)
      case k t
        set -g $func (math $$func+2)
      case '*'
        set -g $func (math $$func+1)
      end
    end
  end
end
