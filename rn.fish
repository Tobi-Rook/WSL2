function rn
	if test (count $argv) -eq 0
		rename
	else
		set -g rn 1
		while ! test -z $argv[$rn]
			switch $argv[$rn]
			case cd
				rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d", 1+$i++)/e' (ls -p | grep /)
			case cn'*'d
				set -l number (echo $argv[$rn] | cut -d'd' -f1 | cut -b 3-)
				rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d", '$number'+$i++)/e' (ls -p | grep /)
			case c'*'n'*'d
				set -l digits (echo $argv[$rn] | cut -d'n' -f1 | cut -b 2-)
				set -l number (echo $argv[$rn] | cut -d'd' -f1 | cut -d'n' -f2)
				rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd", '$number'+$i++)/e' (ls -p | grep /)
			case c'*'d
				set -l digits (echo $argv[$rn] | cut -d'd' -f1 | cut -b 2-)
				rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd", 1+$i++)/e' (ls -p | grep /)
			case h
				cat $WSL_HELP_DIR/rn | less
				break
			case ia
				rename 's/'$argv[(math $rn+1)]'/'$argv[(math $rn+2)]'/' *
			case id
				rename 's/'$argv[(math $rn+1)]'/'$argv[(math $rn+2)]'/' (ls -p | grep /)
			case if
				rename 's/'$argv[(math $rn+1)]'/'$argv[(math $rn+2)]'/' (ls -p | grep -v /)
			case la
				rename 'y/A-Z/a-z/' *
			case ld
				rename 'y/A-Z/a-z/' (ls -p | grep /)
			case pd
				rename 's/^/'$argv[(math $rn+1)]'/' (ls -p | grep /)
			case pf
				rename 's/^/'$argv[(math $rn+1)]'/' (ls -p | grep -v /)
			case ra
				rename 's/'$argv[(math $rn+1)]'//' *
			case rd
				rename 's/'$argv[(math $rn+1)]'//' (ls -p | grep /)
			case rf
				rename 's/'$argv[(math $rn+1)]'//' (ls -p | grep -v /)
			case sd
				# rename 's/$/'$argv[(math $rn+1)]'/' (ls -p | grep /)
				echo "rn ds $argv[(math $rn+1)]: operation not supported"
			case sf
				rename 's/$/'$argv[(math $rn+1)]'/' (ls -p | grep -v /)
			case ua
				rename 'y/a-z/A-Z/' *
			case ud
				rename 'y/a-z/A-Z/' (ls -p | grep /)
			case '*'
				if ls -p | grep -v / | head -n1 | rev | cut -b -5 | rev | grep -q '\.'
					set -l ext (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f1 | rev)
					switch $argv[$rn]
					case cf
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
					case cn'*'f
						set -l number (echo $argv[$rn] | cut -d'f' -f1 | cut -b 3-)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d.'$ext'", '$number'+$i++)/e' (ls -p | grep -v /)
					case c'*'n'*'f
						set -l digits (echo $argv[$rn] | cut -d'n' -f1 | cut -b 2-)
						set -l number (echo $argv[$rn] | cut -d'f' -f1 | cut -d'n' -f2)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd.'$ext'", '$number'+$i++)/e' (ls -p | grep -v /)
					case c'*'f
						set -l digits (echo $argv[$rn] | cut -d'f' -f1 | cut -b 2-)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
					case ef
						rename 's/\.'$ext'$/\.'$argv[(math $rn+1)]'/' *.$ext
					case lf
						rename 's/'$ext'$//; y/A-Z/a-z/; s/$/'$ext'/' (ls -p | grep -v /)
					case uf
						rename 's/'$ext'$//; y/a-z/A-Z/; s/$/'$ext'/' (ls -p | grep -v /)
					case '*'
						rename $argv
						break
					end
				else
					switch $argv[$rn]
					case cf
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d", 1+$i++)/e' (ls -p | grep -v /)
					case cn'*'f
						set -l number (echo $argv[$rn] | cut -d'f' -f1 | cut -b 3-)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d", '$number'+$i++)/e' (ls -p | grep -v /)
					case c'*'n'*'f
						set -l digits (echo $argv[$rn] | cut -d'n' -f1 | cut -b 2-)
						set -l number (echo $argv[$rn] | cut -d'f' -f1 | cut -d'n' -f2)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd", '$number'+$i++)/e' (ls -p | grep -v /)
					case c'*'f
						set -l digits (echo $argv[$rn] | cut -d'f' -f1 | cut -b 2-)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd", 1+$i++)/e' (ls -p | grep -v /)
					case ef
						rename 's/$/.'$argv[(math $rn+1)]'/' (ls -p | grep -v /)
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

			switch (echo $argv[$rn] | cut -b 1)
			case l u
				set -g rn (math $rn+1)
			case c e p r s
				set -g rn (math $rn+2)
			case i
				set -g rn (math $rn+3)
			end
		end
	end
end

