set -g func rn_wsl

function $func
  if test (count $argv) -eq 0
    rename
  else
    set -g $func 1
    while ! test -z $argv[$$func]
      switch $argv[$$func]
      case cd
        if test -z $argv[(math $$func+1)]
          set -l dirname (ls -p | head -n1 | rev | cut -b 2- | rev)
          rename 's/.+/our $i; sprintf("'$dirname' %03d", 1+$i++)/e' (ls -p | grep /)
        else
          rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %03d", 1+$i++)/e' (ls -p | grep /)
          set -g $func (math $$func+1)
        end
        set -g $func (math $$func+1)
      case cn'*'d
        set -l number (echo $argv[$$func] | cut -d'd' -f1 | cut -b 3-)
        if test -z $argv[(math $$func+1)]
          set -l dirname (ls -p | head -n1 | rev | cut -b 2- | rev)
          rename 's/.+/our $i; sprintf("'$dirname' %03d", '$number'+$i++)/e' (ls -p | grep /)
        else
          rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %03d", '$number'+$i++)/e' (ls -p | grep /)
          set -g $func (math $$func+1)
        end
        set -g $func (math $$func+1)
      case c'*'n'*'d
        set -l digits (echo $argv[$$func] | cut -d'n' -f1 | cut -b 2-)
        set -l number (echo $argv[$$func] | cut -d'd' -f1 | cut -d'n' -f2)
        if test -z $argv[(math $$func+1)]
          set -l dirname (ls -p | head -n1 | rev | cut -b 2- | rev)
          rename 's/.+/our $i; sprintf("'$dirname' %0'$digits'd", '$number'+$i++)/e' (ls -p | grep /)
        else
          rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %0'$digits'd", '$number'+$i++)/e' (ls -p | grep /)
          set -g $func (math $$func+1)
        end
        set -g $func (math $$func+1)
      case c'*'d
        set -l digits (echo $argv[$$func] | cut -d'd' -f1 | cut -b 2-)
        if test -z $argv[(math $$func+1)]
          set -l dirname (ls -p | head -n1 | rev | cut -b 2- | rev)
          rename 's/.+/our $i; sprintf("'$dirname' %0'$digits'd", 1+$i++)/e' (ls -p | grep /)
        else
          rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %0'$digits'd", 1+$i++)/e' (ls -p | grep /)
          set -g $func (math $$func+1)
        end
        set -g $func (math $$func+1)
      case h
        cat $WSL_HELP_DIR/$func
        break
      case ia
        rename 's/'$argv[(math $$func+1)]'/'$argv[(math $$func+2)]'/' *
      case id
        rename 's/'$argv[(math $$func+1)]'/'$argv[(math $$func+2)]'/' (ls -p | grep /)
      case if
        rename 's/'$argv[(math $$func+1)]'/'$argv[(math $$func+2)]'/' (ls -p | grep -v /)
      case la
        rename 'y/A-Z/a-z/' *
      case ld
        rename 'y/A-Z/a-z/' (ls -p | grep /)
      case nf
        if test -z $argv[(math $$func+1)]
          rename 's/^/our $i; sprintf("%03d - ", 1+$i++)/e' (ls -p | grep -v /)
        else
          rename 's/[^.]+/our $i; sprintf("%03d - '$argv[(math $$func+1)]'", 1+$i++)/e' (ls -p | grep -v /)
          set -g $func (math $$func+1)
        end
        set -g $func (math $$func+1)
      case nn'*'f
        set -l number (echo $argv[$$func] | cut -d'n' -f3 | cut -b 1)
        if test -z $argv[(math $$func+1)]
          rename 's/^/our $i; sprintf("%03d - ", '$number'+$i++)/e' (ls -p | grep -v /)
        else
          rename 's/[^.]+/our $i; sprintf("%03d - '$argv[(math $$func+1)]'", '$number'+$i++)/e' (ls -p | grep -v /)
          set -g $func (math $$func+1)
        end
        set -g $func (math $$func+1)
      case n'*'n'*'f
        set -l digits (echo $argv[$$func] | cut -d'n' -f2)
        set -l number (echo $argv[$$func] | cut -d'n' -f3 | cut -b 1)
        if test -z $argv[(math $$func+1)]
          rename 's/^/our $i; sprintf("%0'$digits'd - ", '$number'+$i++)/e' (ls -p | grep -v /)
        else
          rename 's/[^.]+/our $i; sprintf("%0'$digits'd - '$argv[(math $$func+1)]'", '$number'+$i++)/e' (ls -p | grep -v /)
          set -g $func (math $$func+1)
        end
        set -g $func (math $$func+1)
      case n'*'f
        set -l digits (echo $argv[$$func] | cut -d'n' -f2 | cut -b 1)
        if test -z $argv[(math $$func+1)]
          rename 's/^/our $i; sprintf("%0'$digits'd - ", 1+$i++)/e' (ls -p | grep -v /)
        else
          rename 's/[^.]+/our $i; sprintf("%0'$digits'd - '$argv[(math $$func+1)]'", 1+$i++)/e' (ls -p | grep -v /)
          set -g $func (math $$func+1)
        end
        set -g $func (math $$func+1)
      case pd
        rename 's/^/'$argv[(math $$func+1)]'/' (ls -p | grep /)
      case pf
        rename 's/^/'$argv[(math $$func+1)]'/' (ls -p | grep -v /)
      case ra
        rename 's/'$argv[(math $$func+1)]'//' *
      case rd
        rename 's/'$argv[(math $$func+1)]'//' (ls -p | grep /)
      case rf
        rename 's/'$argv[(math $$func+1)]'//' (ls -p | grep -v /)
      case sd
        # rename 's/$/'$argv[(math $$func+1)]'/' (ls -p | grep /)
        echo "$func sd: operation not supported"
      case sf
        rename 's/$/'$argv[(math $$func+1)]'/' (ls -p | grep -v /)
      case ua
        rename 'y/a-z/A-Z/' *
      case ud
        rename 'y/a-z/A-Z/' (ls -p | grep /)
      case '*'
        # Check if filename contains an extension
        if ls -p | grep -v / | head -n1 | rev | cut -b -5 | rev | grep -q '\.'
          set -l ext (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f1 | rev)
          switch $argv[$$func]
          case cf
            if test -z $argv[(math $$func+1)]
              set -l filename (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
              rename 's/.+/our $i; sprintf("'$filename' %03d.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
            else
              rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %03d.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
              set -g $func (math $$func+1)
            end
            set -g $func (math $$func+1)
          case cn'*'f
            set -l number (echo $argv[$$func] | cut -d'f' -f1 | cut -b 3-)
            if test -z $argv[(math $$func+1)]
              set -l filename (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
              rename 's/.+/our $i; sprintf("'$filename' %03d.'$ext'", '$number'+$i++)/e' (ls -p | grep -v /)
            else
              rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %03d.'$ext'", '$number'+$i++)/e' (ls -p | grep -v /)
              set -g $func (math $$func+1)
            end
            set -g $func (math $$func+1)
          case c'*'n'*'f
            set -l digits (echo $argv[$$func] | cut -d'n' -f1 | cut -b 2-)
            set -l number (echo $argv[$$func] | cut -d'f' -f1 | cut -d'n' -f2)
            if test -z $argv[(math $$func+1)]
              set -l filename (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
              rename 's/.+/our $i; sprintf("'$filename' %0'$digits'd.'$ext'", '$number'+$i++)/e' (ls -p | grep -v /)
            else
              rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %0'$digits'd.'$ext'", '$number'+$i++)/e' (ls -p | grep -v /)
              set -g $func (math $$func+1)
            end
            set -g $func (math $$func+1)
          case c'*'f
            set -l digits (echo $argv[$$func] | cut -d'f' -f1 | cut -b 2-)
            if test -z $argv[(math $$func+1)]
              set -l filename (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
              rename 's/.+/our $i; sprintf("'$filename' %0'$digits'd.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
            else
              rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %0'$digits'd.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
              set -g $func (math $$func+1)
            end
            set -g $func (math $$func+1)
          case ef
            rename 's/\.'$ext'$/\.'$argv[(math $$func+1)]'/' *.$ext
          case lf
            rename 's/'$ext'$//; y/A-Z/a-z/; s/$/'$ext'/' (ls -p | grep -v /)
          case uf
            rename 's/'$ext'$//; y/a-z/A-Z/; s/$/'$ext'/' (ls -p | grep -v /)
          case '*'
            rename $argv
            break
          end
        else
          switch $argv[$$func]
          case cf
            if test -z $argv[(math $$func+1)]
              set -l filename (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
              rename 's/.+/our $i; sprintf("'$filename' %03d", 1+$i++)/e' (ls -p | grep -v /)
            else
              rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %03d", 1+$i++)/e' (ls -p | grep -v /)
              set -g $func (math $$func+1)
            end
            set -g $func (math $$func+1)
          case cn'*'f
            set -l number (echo $argv[$$func] | cut -d'f' -f1 | cut -b 3-)
            if test -z $argv[(math $$func+1)]
              set -l filename (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
              rename 's/.+/our $i; sprintf("'$filename' %03d", '$number'+$i++)/e' (ls -p | grep -v /)
            else
              rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %03d", '$number'+$i++)/e' (ls -p | grep -v /)
              set -g $func (math $$func+1)
            end
            set -g $func (math $$func+1)
          case c'*'n'*'f
            set -l digits (echo $argv[$$func] | cut -d'n' -f1 | cut -b 2-)
            set -l number (echo $argv[$$func] | cut -d'f' -f1 | cut -d'n' -f2)
            if test -z $argv[(math $$func+1)]
              set -l filename (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
              rename 's/.+/our $i; sprintf("'$filename' %0'$digits'd", '$number'+$i++)/e' (ls -p | grep -v /)
            else
              rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %0'$digits'd", '$number'+$i++)/e' (ls -p | grep -v /)
              set -g $func (math $$func+1)
            end
            set -g $func (math $$func+1)
          case c'*'f
            set -l digits (echo $argv[$$func] | cut -d'f' -f1 | cut -b 2-)
            if test -z $argv[(math $$func+1)]
              set -l filename (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f2 | rev)
              rename 's/.+/our $i; sprintf("'$filename' %0'$digits'd", 1+$i++)/e' (ls -p | grep -v /)
            else
              rename 's/.+/our $i; sprintf("'$argv[(math $$func+1)]' %0'$digits'd", 1+$i++)/e' (ls -p | grep -v /)
              set -g $func (math $$func+1)
            end
            set -g $func (math $$func+1)
          case ef
            rename 's/$/.'$argv[(math $$func+1)]'/' (ls -p | grep -v /)
          case lf
            rename 'y/A-Z/a-z/' (ls -p | grep -v /)
          case uf
            rename 'y/a-z/A-Z/' (ls -p | grep -v /)
          case '*'
            rename $argv
            break
          end
        end
      end

      switch (echo $argv[$$func] | cut -b 1)
      case l u
        set -g $func (math $$func+1)
      case e p r s
        set -g $func (math $$func+2)
      case i
        set -g $func (math $$func+3)
      end
    end
  end
end
