#!/bin/bash
#shellcheck source=/home/tobi/.bash_functions/.bash_variables
source /home/"$USER"/.bash_functions/.bash_variables

if [ $# -eq 0 ]
then
  "$WSL_BASH_DIR"/.public/x.sh x_rls0 "wt"
else
  wsl=1
  while [ -n "${!wsl}" ]
  do
    case "${!wsl}" in
    cmd)
      cmd.exe 2> /dev/null
      ;;
    cp* | mv*)
      case $(echo "${!wsl}" | cut -b 3) in
        a)
          distro_Name=archlinux
          ;;
        d)
          distro_Name=debian
          ;;
        k)
          distro_Name=kali-linux
          ;;
        u)
          distro_Name=ubuntu
          ;;
        z)
          distro_Name=docker-desktop
          ;;
        *)
          echo "wsl ${!wsl}: command not found"
          break
          ;;
      esac
      file=($((wsl+1)) $((wsl+2)))
      # shellcheck disable=SC2153
      mkdir -p "$WSL_PROG_DIR"/"$distro_Name"/"${file[0]}"
      case "$(echo ${!wsl} | cut -b -2)" in
        cp)
          cp -r "$(readlink -f "${file[1]}")" "$WSL_PROG_DIR"/"$distro_Name"/"${file[0]}"
          ;;
        mv)
          mv "$(readlink -f "${file[1]}")" "$WSL_PROG_DIR"/"$distro_Name"/"${file[0]}"
          ;;
      esac
      wsl_prog_dir="${WSL_PROG_DIR//\//\\}"
      "$WSL_BASH_DIR"/.public/x.sh "$wsl_prog_dir\\scripts\\wsl_${distro_Name}_get.exe"
      ;;
    g)
      rsync -a "${WSL_PROG_DIR:?}"/"${WSL_DISTRO_NAME:?}"/* ~/
      rm -rf "${WSL_PROG_DIR:?}"/"${WSL_DISTRO_NAME:?}"/*
      ;;
    h)
      cat "$WSL_HELP_DIR"/wsl
      break
      ;;
    k)
      args=$((wsl+1))
      taskkill.exe /fi "IMAGENAME eq ${!args}*" /im \* > /dev/null 2>&1
      ;;
    kf)
      args=$((wsl+1))
      taskkill.exe /f /fi "IMAGENAME eq ${!args}*" /im \* > /dev/null
      ;;
    na)
      "$WSL_BASH_DIR"/.public/x.sh "start wt new-tab -p \"Arch Linux\""
      ;;
    naws)
      "$WSL_BASH_DIR"/.public/x.sh "start wt new-tab -p \"AWS Shell\""
      ;;
    naz)
      "$WSL_BASH_DIR"/.public/x.sh "start wt new-tab -p \"Azure Cloud Shell\""
      ;;
    nb)
      "$WSL_BASH_DIR"/.public/x.sh "start bash"
      ;;
    nc)
      "$WSL_BASH_DIR"/.public/x.sh "start wt new-tab -p \"Command Prompt\""
      ;;
    nd)
      "$WSL_BASH_DIR"/.public/x.sh "start wt new-tab -p \"Debian\""
      ;;
    ndo)
      "$WSL_BASH_DIR"/.public/x.sh "start wt new-tab -p \"Docker\""
      ;;
    nf)
      "$WSL_BASH_DIR"/.public/x.sh "start wt -F"
      ;;
    ngc)
      "$WSL_BASH_DIR"/.public/x.sh "start wt new-tab -p \"Google Cloud Platform\""
      ;;
    nk)
      "$WSL_BASH_DIR"/.public/x.sh "start wt new-tab -p \"Kali Linux\""
      ;;
    nps)
      "$WSL_BASH_DIR"/.public/x.sh "start wt new-tab -p \"PowerShell\""
      ;;
    nu)
      "$WSL_BASH_DIR"/.public/x.sh "start wt new-tab -p \"Ubuntu\""
      ;;
    q)
      unset WSL_RESTART_INFO
      unset WSL_RESTART_WINS
      wslconfig.exe /t "$WSL_DISTRO_NAME"
      ;;
    r)
      args=($((wsl+1)) $((wsl+2)))
      while tasklist.exe | grep -i "${!args[1]}" > /dev/null
      do
        sleep 10
      done
      rm -f "${!args[0]}"
      unset WSL_REMOVE_INFO
      ;;
    sd)
      value=$(cmd.exe /c echo %SYSTEMDRIVE% 2> /dev/null | cut -b 1 | tr '[:upper:]' '[:lower:]')
      export disk=$value
      ;;
    su)
      # shellcheck disable=SC1012,SC2026
      value=$(cmd.exe /c echo %USERNAME% 2> /dev/null | tr -d '$'\r'')
      export user=$value
      ;;
    t)
      arg=$((wsl+1))
      if [ -n "${!arg}" ]
      then
        case "${!arg}" in
        i)
          if readlink -f $WSL_PYPKG_DIR/powerline/config_files/colorschemes | grep -q dark
          then
            export WSL_THEME_INFO=light
          else
            export WSL_THEME_INFO=dark
          fi
          "$WSL_BASH_DIR"/.public/wsl.sh xl xr
          ;;
        *)
          if [ -d ~/.wsl_config/.colors/"${!arg}" ]
          then
            export WSL_THEME_INFO="${!arg}"
            "$WSL_BASH_DIR"/.public/wsl.sh xl xr
          else
            echo "wsl t: theme not found"
            break
          fi
          ;;
        esac
      else
        export WSL_THEME_INFO=dark
        "$WSL_BASH_DIR"/.public/wsl.sh xl xr
      fi
      ;;
    xi)
      # shellcheck disable=SC1012,SC2020,SC2026
      if tasklist.exe | grep -i WindowsTerminal.exe > /dev/null
      then
        for session in $WSL_RESTART_WINS
        do
          "$WSL_BASH_DIR"/.public/x.sh "start wt"
        done
        "$WSL_BASH_DIR"/.general/t.sh ks
      elif wmic.exe process get name, parentprocessid | grep conhost.exe | grep "$(wmic.exe process get name, parentprocessid | grep WMIC.exe | tr -d WMIC.exe | tr -d ' ' | tr -d '$'\r'')" > /dev/null
      then
        for session in $WSL_RESTART_WINS
        do
          "$WSL_BASH_DIR"/.public/x.sh "start wsl tmux new-session -s $session"
        done
        "$WSL_BASH_DIR"/.general/t.sh ks
      else
        echo "wsl xi: settings not found"
      fi
      ;;
    xl)
      ln -fs ~/.wsl_config/.colors/"$WSL_THEME_INFO"/colorschemes "$WSL_PYPKG_DIR"/powerline/config_files/
      ln -fs ~/.wsl_config/.colors/"$WSL_THEME_INFO"/.vimrc ~/.vimrc
      ln -fs ~/.wsl_config/.colors/"$WSL_THEME_INFO"/.dircolors ~/.dircolors
      ;;
    xr)
      values=("$PWD" "$(history | head -1)")
      export WSL_RESTART_INFO=${values[*]}

      value=$(tmux list-sessions -F "#{session_name}")
      export WSL_RESTART_WINS=$value

      wsl_prog_dir="${WSL_PROG_DIR//\//\\}"
      # shellcheck disable=SC1012,SC2020,SC2026
      if tasklist.exe | grep -i WindowsTerminal.exe > /dev/null && [ -z "$wsl_restart_inv" ]
      then
        sed -i "s/\"colorScheme.*/\"colorScheme\": \"$WSL_THEME_INFO\",/g" "$WSL_TERM_FILE"
        echo "\"$wsl_prog_dir\\scripts\\wsl_restart.bat\" $WSL_DISTRO_NAME \"wt\"" | cmd.exe > /dev/null 2>&1
      elif wmic.exe process get name, parentprocessid | grep conhost.exe | grep "$(wmic.exe process get name, parentprocessid | grep WMIC.exe | tr -d WMIC.exe | tr -d ' ' | tr -d '$'\r'')" > /dev/null || ! test -z "$wsl_restart_inv"
      then
        echo "\"$wsl_prog_dir\\ColorTool\\ColorTool.exe\" -d -x $WSL_THEME_INFO.itermcolors" | cmd.exe > /dev/null 2>&1
        echo "\"$wsl_prog_dir\\scripts\\wsl_restart.bat\" $WSL_DISTRO_NAME wsl" | cmd.exe > /dev/null 2>&1
      else
        echo "wsl xr: program not found"
      fi
      ;;
    xri)
      wsl_restart_inv=1
      "$WSL_BASH_DIR"/.public/wsl.sh xr
      ;;
    *)
      echo "wsl ${!wsl}: command not found"
      break
      ;;
    esac

    case $(echo "${!wsl}" | cut -b 1) in
      c | m | r)
        wsl=$((wsl+3))
        ;;
      k | t)
        wsl=$((wsl+2))
        ;;
      *)
        wsl=$((wsl+1))
        ;;
    esac
  done
fi
