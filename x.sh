#!/bin/bash
#shellcheck source=/home/tobi/.bash_functions/.bash_variables
source /home/"$USER"/.bash_functions/.bash_variables

# Default case
if [ $# -eq 0 ]
then
  uname -r
  echo "$(cat /etc/*release | grep '^NAME="' | cut -b 6-)" "$(cat /etc/*_version)"
  # cat /etc/{*-release,*_version}
  # cat /etc/*_version
else
  x=1
  while [ -n "${!x}" ]
  do
    case "${!x}" in
    h)
      cat "$WSL_HELP_DIR"/x
      break
      ;;
    hx)
      uname -a
      printf '\n'
      cat /etc/{*-release,*_version}
      ;;
    x_rls0)
      file_Path=$((x+1))
      echo "\"${!file_Path}\"" | cmd.exe > /dev/null 2>&1 &
      break
      ;;
    *)
      # Start statements (--> Windows Command Prompt)
      if echo "${!x}" | grep -iq '^start'
      then
        echo "${!x}" | cmd.exe > /dev/null 2>&1

      # Internet addresses
      elif echo "${!x}" | grep -qE '^http|www.'
      then
        echo "\"%SYSTEMDRIVE%\\$WSL_BROWSER_DIR\" \"${!x}\"" | cmd.exe > /dev/null 2>&1

      # Windows file paths / WSL / Linux distributions
      else

        # Function call with performance flag enabled
        if echo "${!x}" | grep -q 'x_rls1'
        then
          tmp=$((x+1))
        else
          tmp=$x
        fi

        if echo ${!tmp} | grep -iqE '^[a-z]:|^%SYSTEMDRIVE%|^%USERPROFILE%|^%APPDATA%|^%LOCALAPPDATA%|^%OneDrive%'
        then
          file_Path=$(readlink -f "${!tmp}" | sed "s|$PWD||g" | cut -b 2-)
        elif readlink -f ${!tmp} | grep -iq '/mnt/[a-z]/'
        then
          file_Path=$(readlink -f "${!tmp}" | sed 's|\/|\\|g' | cut -b 6- | sed 's/^\(.\{1\}\)/\1:/')
        else
          file_Path=$(readlink -f "${!tmp}")
        fi

        # Default function call with character encoding conversion
        if echo "${!x}" | grep -qv x_rls1
        then

          # Insertion of placeholders for incompatible chars
          file_Path=$(echo "$file_Path" | sed                  \
            -e 's/Ä/{00/g;  s/Á/{01/g;  s/À/{02/g;  s/Å/{03/g' \
            -e 's/ä/{04/g;  s/á/{05/g;  s/à/{06/g;  s/å/{07/g' \
            -e 's/Æ/{08/g'                                     \
            -e 's/æ/{09/g'                                     \
            -e 's/Ç/{10/g'                                     \
            -e 's/ç/{11/g'                                     \
            -e 's/Ë/{12/g;  s/É/{13/g;  s/È/{14/g'             \
            -e 's/ë/{15/g;  s/é/{16/g;  s/è/{17/g'             \
            -e 's/Ğ/{18/g'                                     \
            -e 's/ğ/{19/g'                                     \
            -e 's/Ï/{20/g;  s/Î/{21/g'                         \
            -e 's/ï/{22/g;  s/î/{23/g'                         \
            -e 's/Ñ/{24/g'                                     \
            -e 's/ñ/{25/g'                                     \
            -e 's/Ö/{26/g;  s/Ó/{27/g;  s/Ò/{28/g;  s/Ø/{29/g' \
            -e 's/ö/{30/g;  s/ó/{31/g;  s/ò/{32/g;  s/ø/{33/g' \
            -e 's/ẞ/{34/g;  s/Ş/{35/g'                         \
            -e 's/ß/{36/g;  s/ş/{37/g'                         \
            -e 's/Ü/{38/g;  s/Ú/{39/g;  s/Ù/{40/g'             \
            -e 's/ü/{41/g;  s/ú/{42/g;  s/ù/{43/g'             \
            -e 's/Ÿ/{44/g'                                     \
            -e 's/ÿ/{45/g'                                     \
            -e 's/©/{46/g;  s/℗/{47/g;  s/®/{48/g;  s/™/{49/g' )
        fi

        # Passed Windows file path / Execution within the WSL
        if echo "$file_Path" | grep -iqE '^[a-z]:|^%SYSTEMDRIVE%|^%USERPROFILE%|^%APPDATA%|^%LOCALAPPDATA%|^%OneDrive%'
        then

          # .exe / .bat / .lnk extension
          # shellcheck disable=SC1003
          if echo "$file_Path" | rev | cut -d'\' -f1 | rev | grep -iqE '.exe$|.bat$|.lnk$'
          then
            # shellcheck disable=SC1117
            echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" exe \"$file_Path\"" | cmd.exe > /dev/null 2>&1 &
            sleep 1
            pkill -n cmd.exe

          # Directories
          elif [ -d "${!x}" ]
          then
            # shellcheck disable=SC1117
            echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" dir \"$file_Path\"" | cmd.exe > /dev/null 2>&1 &

          # No file extension
          elif echo "$file_Path" | rev | cut -d'\' -f1 | rev | grep -ivq '\.'
          then
            # shellcheck disable=SC1117
            echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" code \"$file_Path\"" | cmd.exe > /dev/null 2>&1 &

          # Other file extensions
          else
            # shellcheck disable=SC1117
            echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" start \"$file_Path\"" | cmd.exe > /dev/null 2>&1 &
          fi

        # Execution within any Linux distribution
        else
          WSL_DISTRO_DIR=WSL_"$WSL_DISTRO_NAME"_DIR

          # .pdf file extension
          if echo "$file_Path" | rev | cut -d'/' -f1 | rev | grep -iq '.pdf'
          then

            # Get disk and current user if not available
            if [ -z "$disk" ]
            then
              value=$(cmd.exe /c echo %SYSTEMDRIVE% 2> /dev/null | cut -b 1 | tr '[:upper:]' '[:lower:]')
              export disk=$value
            fi

            if [ -z "$user" ]
            then
              # shellcheck disable=SC1012,SC2026
              value=$(cmd.exe /c echo %USERNAME% 2> /dev/null | tr -d '$'\r'')
              export user=$value
            fi

            # Copy the specified file outside the WSL and open it
            file_Name=$(basename "$file_Path")
            cp "${!x}" /mnt/"$disk"/users/"$user"/
            # shellcheck disable=SC1117
            echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" start \"%USERPROFILE%\\$file_Name\"" | cmd.exe > /dev/null 2>&1 &

            # Delete the file after it has been closed
            # shellcheck disable=SC1003
            value="/mnt/$disk/users/$user/${!x}":$(echo "$WSL_BROWSER_DIR" | rev | cut -d'\\' -f1 | rev)
            export WSL_REMOVE_INFO=$value
            # shellcheck disable=SC2016
            fish -c 'wsl r $WSL_REMOVE_INFO' > /dev/null 2>&1 &

          # Check if the current distribution is registered as a valid distribution in the WSL (--> $WSL_X_DIR)
          elif [ -n "${!WSL_DISTRO_DIR}" ]
          then

            # .exe / .bat / .lnk file extension
            if echo "$file_Path" | rev | cut -d"/" -f1 | rev | grep -iqE '.exe$|.bat$|.lnk$'
            then
              # shellcheck disable=SC1117
              echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" exe \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2>&1 &
              sleep 1
              pkill -n cmd.exe

            # Directories
            elif test -d "$file_Path"
            then
              editor "$file_Path"

            # No file extension
            elif echo "$file_Path" | rev | cut -d"/" -f1 | rev | grep -ivq '\.' || echo "$file_Path" | rev | cut -d"/" -f1 | rev | grep -q '^\.'
            then
              "$WSL_CODE_BIN" "$file_Path"

            # Other file extensions
            else
              # shellcheck disable=SC1117
              echo "\"$WSL_PROG_DIR\scripts\wsl_start.bat\" cmd \"\\\\wsl\$\\$WSL_DISTRO_NAME\\$file_Path\"" | cmd.exe > /dev/null 2>&1 &
            fi

          # Distribution is not compatible / Distribution needs to be registered (--> $WSL_X_DIR)
          else
            echo "x ${!x}: operation not supported"
          fi
        fi

        # Function call with performance flag enabled
        if echo "${!x}" | grep -q x_rls1
        then
          break
        fi

      fi
      ;;
    esac
    x=$((x+1))
  done
fi
