#!/bin/bash
#shellcheck disable=SC2010,SC2012,SC2086
#shellcheck source=/home/tobi/.bash_functions/.bash_variables
source /home/"$USER"/.bash_functions/.bash_variables

if [ $# -eq 0 ]
then
  rename
else
  rn=1
  while [ -n "${!rn}" ]
  do
    args=($((rn+1)) $((rn+2)))
    case "${!rn}" in
      cd)
        if [ -z "${!args[0]}" ]
        then
          dirname=$(ls -p | head -n1 | rev | cut -b 2- | rev)
          rename 's/.+/our $i; sprintf("'$dirname' %03d", 1+$i++)/e' "$(ls -p | grep /)"
        else
          rename 's/.+/our $i; sprintf("'${!args[0]}' %03d", 1+$i++)/e' "$(ls -p | grep /)"
          rn=$((rn+1))
        fi
        rn=$((rn+1))
        ;;
      cn*d)
        number=$(echo "${!rn}" | cut -d'd' -f1 | cut -b 3-)
        if [ -z "${!args[0]}" ]
        then
          dirname=$(ls -p | head -n1 | rev | cut -b 2- | rev)
          rename 's/.+/our $i; sprintf("'$dirname' %03d", '$number'+$i++)/e' "$(ls -p | grep /)"
        else
          rename 's/.+/our $i; sprintf("'${!args[0]}' %03d", '$number'+$i++)/e' "$(ls -p | grep /)"
          rn=$((rn+1))
        fi
        rn=$((rn+1))
        ;;
      c*n*d)
        digits=$(echo "${!rn}" | cut -d'n' -f1 | cut -b 2-)
        number=$(echo "${!rn}" | cut -d'd' -f1 | cut -d'n' -f2)
        if [ -z "${!args[0]}" ]
        then
          dirname=$(ls -p | head -n1 | rev | cut -b 2- | rev)
          rename 's/.+/our $i; sprintf("'$dirname' %0'$digits'd", '$number'+$i++)/e' "$(ls -p | grep /)"
        else
          rename 's/.+/our $i; sprintf("'${!args[0]}' %0'$digits'd", '$number'+$i++)/e' "$(ls -p | grep /)"
          rn=$((rn+1))
        fi
        rn=$((rn+1))
        ;;
      c*d)
        digits=$(echo "${!rn}" | cut -d'd' -f1 | cut -b 2-)
        if [ -z "${!args[0]}" ]
        then
          set -l dirname "$(ls -p | head -n1 | rev | cut -b 2- | rev)"
          rename 's/.+/our $i; sprintf("'$dirname' %0'$digits'd", 1+$i++)/e' "$(ls -p | grep /)"
        else
          rename 's/.+/our $i; sprintf("'${!args[0]}' %0'$digits'd", 1+$i++)/e' "$(ls -p | grep /)"
          rn=$((rn+1))
        fi
        rn=$((rn+1))
        ;;
      h)
        cat "$WSL_HELP_DIR"/rn
        break
        ;;
      ia)
        rename 's/'${!args[0]}'/'${!args[1]}'/' ./*
        ;;
      id)
        rename 's/'${!args[0]}'/'${!args[1]}'/' "$(ls -p | grep /)"
        ;;
      if)
        rename 's/'${!args[0]}'/'${!args[1]}'/' "$(ls -p | grep -v /)"
        ;;
      la)
        rename 'y/A-Z/a-z/' ./*
        ;;
      ld)
        rename 'y/A-Z/a-z/' "$(ls -p | grep /)"
        ;;
      nf)
        if [ -z "${!args[0]}" ]
        then
          rename 's/^/our $i; sprintf("%03d - ", 1+$i++)/e' "$(ls -p | grep -v /)"
        else
          rename 's/[^.]+/our $i; sprintf("%03d - '${!args[0]}'", 1+$i++)/e' "$(ls -p | grep -v /)"
          rn=$((rn+1))
        fi
        rn=$((rn+1))
        ;;
      nn*f)
        number=$(echo "${!rn}" | cut -d'n' -f3 | cut -b 1)
        if [ -z "${!args[0]}" ]
        then
          rename 's/^/our $i; sprintf("%03d - ", '$number'+$i++)/e' "$(ls -p | grep -v /)"
        else
          rename 's/[^.]+/our $i; sprintf("%03d - '${!args[0]}'", '$number'+$i++)/e' "$(ls -p | grep -v /)"
          rn=$((rn+1))
        fi
        rn=$((rn+1))
        ;;
      n*n*f)
        digits=$(echo "${!rn}" | cut -d'n' -f2)
        number=$(echo "${!rn}" | cut -d'n' -f3 | cut -b 1)
        if [ -z "${!args[0]}" ]
        then
          rename 's/^/our $i; sprintf("%0'$digits'd - ", '$number'+$i++)/e' "$(ls -p | grep -v /)"
        else
          rename 's/[^.]+/our $i; sprintf("%0'$digits'd - '${!args[0]}'", '$number'+$i++)/e' "$(ls -p | grep -v /)"
          rn=$((rn+1))
        fi
        rn=$((rn+1))
        ;;
      n*f)
        digits=$(echo "${!rn}" | cut -d'n' -f2 | cut -b 1)
        if [ -z "${!args[0]}" ]
        then
          rename 's/^/our $i; sprintf("%0'$digits'd - ", 1+$i++)/e' "$(ls -p | grep -v /)"
        else
          rename 's/[^.]+/our $i; sprintf("%0'$digits'd - '${!args[0]}'", 1+$i++)/e' "$(ls -p | grep -v /)"
          rn=$((rn+1))
        fi
        rn=$((rn+1))
        ;;
      pd)
        rename 's/^/'${!args[0]}'/' "$(ls -p | grep /)"
        ;;
      pf)
        rename 's/^/'${!args[0]}'/' "$(ls -p | grep -v /)"
        ;;
      ra)
        rename 's/'${!args[0]}'//' ./*
        ;;
      rd)
        rename 's/'${!args[0]}'//' "$(ls -p | grep /)"
        ;;
      rf)
        rename 's/'${!args[0]}'//' "$(ls -p | grep -v /)"
        ;;
      sd)
        # rename 's/$/'${!args[0]}'/' (ls -p | grep /)
        echo "rn sd: operation not supported"
        ;;
      sf)
        rename 's/$/'${!args[0]}'/' "$(ls -p | grep -v /)"
        ;;
      ua)
        rename 'y/a-z/A-Z/' ./*
        ;;
      ud)
        rename 'y/a-z/A-Z/' "$(ls -p | grep /)"
        ;;
      *)
        # Check if filename contains an extension
        if ls -p | grep -v / | head -n1 | rev | cut -b -5 | rev | grep -q '\.'
        then
          ext="$(ls -p | grep -v / | head -n1 | rev | cut -d'.' -f1 | rev)"
          case "${!rn}" in
            cf)
              if [ -z "${!args[0]}" ]
              then
                filename="$(ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)"
                rename 's/.+/our $i; sprintf("'$filename' %03d.'$ext'", 1+$i++)/e' "$(ls -p | grep -v /)"
              else
                rename 's/.+/our $i; sprintf("'${!args[0]}' %03d.'$ext'", 1+$i++)/e' "$(ls -p | grep -v /)"
                rn=$((rn+1))
              fi
              rn=$((rn+1))
              ;;
            cn*f)
              number=$(echo "${!rn}" | cut -d'f' -f1 | cut -b 3-)
              if [ -z ${!args[0]} ]
              then
                filename="$(ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)"
                rename 's/.+/our $i; sprintf("'$filename' %03d.'$ext'", '$number'+$i++)/e' "$(ls -p | grep -v /)"
              else
                rename 's/.+/our $i; sprintf("'${!args[0]}' %03d.'$ext'", '$number'+$i++)/e' "$(ls -p | grep -v /)"
                rn=$((rn+1))
              fi
              rn=$((rn+1))
              ;;
            c*n*f)
              digits=$(echo "${!rn}" | cut -d'n' -f1 | cut -b 2-)
              number=$(echo "${!rn}" | cut -d'f' -f1 | cut -d'n' -f2)
              if [ -z "${!args[0]}" ]
              then
                filename=$(ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
                rename 's/.+/our $i; sprintf("'$filename' %0'$digits'd.'$ext'", '$number'+$i++)/e' "$(ls -p | grep -v /)"
              else
                rename 's/.+/our $i; sprintf("'${!args[0]}' %0'$digits'd.'$ext'", '$number'+$i++)/e' "$(ls -p | grep -v /)"
                rn=$((rn+1))
              fi
              rn=$((rn+1))
              ;;
            c*f)
              digits=$(echo "${!rn}" | cut -d'f' -f1 | cut -b 2-)
              if [ -z "${!args[0]}" ]
              then
                filename=$(ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
                rename 's/.+/our $i; sprintf("'$filename' %0'$digits'd.'$ext'", 1+$i++)/e' "$(ls -p | grep -v /)"
              else
                rename 's/.+/our $i; sprintf("'${!args[0]}' %0'$digits'd.'$ext'", 1+$i++)/e' "$(ls -p | grep -v /)"
                rn=$((rn+1))
              fi
              rn=$((rn+1))
              ;;
            ef)
              rename 's/\.'$ext'$/\.'${!args[0]}'/' ./*.$ext
              ;;
            lf)
              rename 's/'$ext'$//; y/A-Z/a-z/; s/$/'$ext'/' "$(ls -p | grep -v /)"
              ;;
            uf)
              rename 's/'$ext'$//; y/a-z/A-Z/; s/$/'$ext'/' "$(ls -p | grep -v /)"
              ;;
            *)
              rename "$@"
              break
              ;;
          esac
        else
          case "${!rn}" in
            cf)
              if [ -z "${!args[0]}" ]
              then
                filename=$(ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
                rename 's/.+/our $i; sprintf("'$filename' %03d", 1+$i++)/e' "$(ls -p | grep -v /)"
              else
                rename 's/.+/our $i; sprintf("'${!args[0]}' %03d", 1+$i++)/e' "$(ls -p | grep -v /)"
                rn=$((rn+1))
              fi
              rn=$((rn+1))
              ;;
            cn*f)
              number=$(echo "${!rn}" | cut -d'f' -f1 | cut -b 3-)
              if [ -z "${!args[0]}" ]
              then
                filename=$(ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
                rename 's/.+/our $i; sprintf("'$filename' %03d", '$number'+$i++)/e' "$(ls -p | grep -v /)"
              else
                rename 's/.+/our $i; sprintf("'${!args[0]}' %03d", '$number'+$i++)/e' "$(ls -p | grep -v /)"
                rn=$((rn+1))
              fi
              rn=$((rn+1))
              ;;
            c*n*f)
              digits=$(echo "${!rn}" | cut -d'n' -f1 | cut -b 2-)
              number=$(echo "${!rn}" | cut -d'f' -f1 | cut -d'n' -f2)
              if [ -z "${!args[0]}" ]
              then
                filename=$(ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
                rename 's/.+/our $i; sprintf("'$filename' %0'$digits'd", '$number'+$i++)/e' "$(ls -p | grep -v /)"
              else
                rename 's/.+/our $i; sprintf("'${!args[0]}' %0'$digits'd", '$number'+$i++)/e' "$(ls -p | grep -v /)"
                rn=$((rn+1))
              fi
              rn=$((rn+1))
              ;;
            c*f)
              digits=$(echo "${!rn}" | cut -d'f' -f1 | cut -b 2-)
              if [ -z "${!args[0]}" ]
              then
                filename=$(ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
                rename 's/.+/our $i; sprintf("'$filename' %0'$digits'd", 1+$i++)/e' "$(ls -p | grep -v /)"
              else
                rename 's/.+/our $i; sprintf("'${!args[0]}' %0'$digits'd", 1+$i++)/e' "$(ls -p | grep -v /)"
                rn=$((rn+1))
              fi
              rn=$((rn+1))
              ;;
            ef)
              rename 's/$/.'${!args[0]}'/' "$(ls -p | grep -v /)"
              ;;
            lf)
              rename 'y/A-Z/a-z/' "$(ls -p | grep -v /)"
              ;;
            uf)
              rename 'y/a-z/A-Z/' "$(ls -p | grep -v /)"
              ;;
            *)
              rename "$@"
              break
              ;;
          esac
        fi
    esac

    case $(echo "${!rn}" | cut -b 1) in
      l | u)
        rn=$((rn+1))
        ;;
      e | p | r | s)
        rn=$((rn+2))
        ;;
      i)
        rn=$((rn+3))
        ;;
    esac
  done
fi
