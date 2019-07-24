function rn
	if test (count $argv) -eq 0
		rename
	else
		set -g rn 1
		while ! test -z $argv[$rn]
			switch $argv[$rn]
			case ad
				rename 's/'$argv[(math $rn+1)]'//' *
			case al
				rename 'y/A-Z/a-z/' *
			case ar
				rename 's/'$argv[(math $rn+1)]'/'$argv[(math $rn+2)]'/' *
			case au
				rename 'y/a-z/A-Z/' *
			case dc
				rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d", 1+$i++)/e' (ls -p | grep /)
			case dcn'*'
				set -l number (echo $argv[$rn] | cut -b 4-)
				rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d", '$number'+$i++)/e' (ls -p | grep /)
			case dc'*'n'*'
				set -l digits (echo $argv[$rn] | cut -d'c' -f2 | cut -d'n' -f1)
				set -l number (echo $argv[$rn] | cut -d'n' -f2)
				rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd", '$number'+$i++)/e' (ls -p | grep /)
			case dc'*'
				set -l digits (echo $argv[$rn] | cut -b 3-)
				rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd", 1+$i++)/e' (ls -p | grep /)
			case dd
				rename 's/'$argv[(math $rn+1)]'//' (ls -p | grep /)
			case dl
				rename 'y/A-Z/a-z/' (ls -p | grep /)
			case dp
				rename 's/^/'$argv[(math $rn+1)]'/' (ls -p | grep /)
			case dr
				rename 's/'$argv[(math $rn+1)]'/'$argv[(math $rn+2)]'/' (ls -p | grep /)
			case ds
				# rename 's/$/'$argv[(math $rn+1)]'/' (ls -p | grep /)
				echo "rn ds $argv[(math $rn+1)]: operation not supported"
			case du
				rename 'y/a-z/A-Z/' (ls -p | grep /)
			case fd
				rename 's/'$argv[(math $rn+1)]'//' (ls -p | grep -v /)
			case fp
				rename 's/^/'$argv[(math $rn+1)]'/' (ls -p | grep -v /)
			case fr
				rename 's/'$argv[(math $rn+1)]'/'$argv[(math $rn+2)]'/' (ls -p | grep -v /)
			case fs
				rename 's/$/'$argv[(math $rn+1)]'/' (ls -p | grep -v /)
			case help
				cat ~/.config/fish/functions/help/rn | less
			case '*'
				if ls -p | grep -v / | head -n1 | rev | cut -b -5 | rev | grep -q '\.'
					set -l ext (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f1 | rev)
					switch $argv[$rn]
					case fc
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
					case fcn'*'
						set -l number (echo $argv[$rn] | cut -b 4-)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d.'$ext'", '$number'+$i++)/e' (ls -p | grep -v /)
					case fc'*'n'*'
						set -l digits (echo $argv[$rn] | cut -d'c' -f2 | cut -d'n' -f1)
						set -l number (echo $argv[$rn] | cut -d'n' -f2)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd.'$ext'", '$number'+$i++)/e' (ls -p | grep -v /)
					case fc'*'
						set -l digits (echo $argv[$rn] | cut -b 3-)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
					case fe
						rename 's/\.'$ext'$/\.'$argv[(math $rn+1)]'/' *.$ext
					case fl
						rename 's/'$ext'$//; y/A-Z/a-z/; s/$/'$ext'/' (ls -p | grep -v /)
					case fu
						rename 's/'$ext'$//; y/a-z/A-Z/; s/$/'$ext'/' (ls -p | grep -v /)
					case '*'
						rename $argv
					end
				else
					switch $argv[$rn]
					case fc
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d", 1+$i++)/e' (ls -p | grep -v /)
					case fcn'*'
						set -l number (echo $argv[$rn] | cut -b 4-)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %03d", '$number'+$i++)/e' (ls -p | grep -v /)
					case fc'*'n'*'
						set -l digits (echo $argv[$rn] | cut -d'c' -f2 | cut -d'n' -f1)
						set -l number (echo $argv[$rn] | cut -d'n' -f2)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd", '$number'+$i++)/e' (ls -p | grep -v /)
					case fc'*'
						set -l digits (echo $argv[$rn] | cut -b 3-)
						rename 's/.+/our $i; sprintf("'$argv[(math $rn+1)]' %0'$digits'd", 1+$i++)/e' (ls -p | grep -v /)
					case fe
						rename 's/$/.'$argv[(math $rn+1)]'/' (ls -p | grep -v /)
					case fl
						rename 'y/A-Z/a-z/' (ls -p | grep -v /)
					case fu
						rename 'y/a-z/A-Z/' (ls -p | grep -v /)
					case '*'
						rename $argv
					end
				end
			end

			switch (echo $argv[$rn] | cut -b 2)
			case help l u
				set -g rn (math $rn+1)
			case c d e p s
				set -g rn (math $rn+2)
			case r
				set -g rn (math $rn+3)
			end
		end
	end
end
