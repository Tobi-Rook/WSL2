function rn
	if test (count $argv) -eq 0
		rename
	else
		set -g rn 1
		while ! test -z $argv[$rn]
			switch $argv[$rn]
			case ad
				rename 's/'$argv[(math $rn+1)]'//' *
				set -g rn (math $rn+1)
			case al
				rename 'y/A-Z/a-z/' *
			case ar
				rename 's/'$argv[(math $rn+1)]'/'$argv[(math $rn+2)]'/' *
				set -g rn (math $rn+2)
			case au
				rename 'y/a-z/A-Z/' *
			case dc
				rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d", 1+$i++)/e' (ls -p | grep /)
				set -g rn (math $rn+1)
			case dc'*'
				set -l number (echo $argv[1] | cut -b 3-)
				rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$number'd", 1+$i++)/e' (ls -p | grep /)
				set -g rn (math $rn+1)
			case dd
				rename 's/'$argv[(math $rn+1)]'//' (ls -p | grep /)
				set -g rn (math $rn+1)
			case dl
				rename 'y/A-Z/a-z/' (ls -p | grep /)
			case dp
				rename 's/^/'$argv[(math $rn+1)]'/' (ls -p | grep /)
				set -g rn (math $rn+1)
			case dr
				rename 's/'$argv[(math $rn+1)]'/'$argv[(math $rn+2)]'/' (ls -p | grep /)
				set -g rn (math $rn+2)
			case ds
				# rename 's/$/'$argv[(math $rn+1)]'/' (ls -p | grep /)
				echo "rn ds $argv[(math $rn+1)]: operation not supported"
				set -g rn (math $rn+1)
			case du
				rename 'y/a-z/A-Z/' (ls -p | grep /)
			case fd
				rename 's/'$argv[(math $rn+1)]'//' (ls -p | grep -v /)
				set -g rn (math $rn+1)
			case fl
				rename 'y/A-Z/a-z/' (ls -p | grep -v /)
			case fp
				rename 's/^/'$argv[(math $rn+1)]'/' (ls -p | grep -v /)
				set -g rn (math $rn+1)
			case fr
				rename 's/'$argv[(math $rn+1)]'/'$argv[(math $rn+2)]'/' (ls -p | grep -v /)
				set -g rn (math $rn+2)
			case fs
				rename 's/$/'$argv[(math $rn+1)]'/' (ls -p | grep -v /)
				set -g rn (math $rn+1)
			case fu
				rename 'y/a-z/A-Z/' (ls -p | grep -v /)
			case help
				cat ~/.config/fish/functions/help/rn | less
			case '*'
				if ls -p | grep -v / | head -n1 | rev | cut -b -5 | rev | grep -q '\.'
					set -l ext (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f1 | rev)
					switch $argv[$rn]
					case fc
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
						set -g rn (math $rn+1)
					case fc'*'
						set -l number (echo $argv[$rn] | cut -b 3-)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$number'd.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
						set -g rn (math $rn+1)
					case fe
						rename 's/\.'$ext'$/\.'$argv[(math $rn+1)]'/' *.$ext
						set -g rn (math $rn+1)
					case '*'
						rename $argv
					end
				else
					switch $argv[$rn]
					case fc
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d", 1+$i++)/e' (ls -p | grep -v /)
						set -g rn (math $rn+1)
					case fc'*'
						set -l number (echo $argv[$rn] | cut -b 3-)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$number'd", 1+$i++)/e' (ls -p | grep -v /)
						set -g rn (math $rn+1)
					case fe
						rename 's/$/.'$argv[(math $rn+1)]'/' (ls -p | grep -v /)
						set -g rn (math $rn+1)
					case '*'
						rename $argv
					end
				end
			end
		set -g rn (math $rn+1)
		end
	end
end
