function rn
	if test (count $argv) -eq 0
		rename
	else
		switch $argv[1]
		case ad
			rename 's/'$argv[2]'//' *
		case al
			rename 'y/A-Z/a-z/' *
		case ar
			rename 's/'$argv[2]'/'$argv[3]'/' *
		case au
			rename 'y/a-z/A-Z/' *
		case dc
			rename 's/.+/our $i; sprintf("'$argv[2]' %03d", 1+$i++)/e' (ls -p | grep /)
		case dc'*'
			set -l number (echo $argv[1] | cut -b 3-)
			rename 's/.+/our $i; sprintf("'$argv[2]' %0'$number'd", 1+$i++)/e' (ls -p | grep /)
		case dd
			rename 's/'$argv[2]'//' (ls -p | grep /)
		case dl
			rename 'y/A-Z/a-z/' (ls -p | grep /)
		case dp
			rename 's/^/'$argv[2]'/' (ls -p | grep /)
		case dr
			rename 's/'$argv[2]'/'$argv[3]'/' (ls -p | grep /)
		case ds
			# rename 's/$/'$argv[2]'/' (ls -p | grep /)
			echo "rn ds $argv[2]: operation not supported"
		case du
			rename 'y/a-z/A-Z/' (ls -p | grep /)
		case fd
			rename 's/'$argv[2]'//' (ls -p | grep -v /)
		case fl
			rename 'y/A-Z/a-z/' (ls -p | grep -v /)
		case fp
			rename 's/^/'$argv[2]'/' (ls -p | grep -v /)
		case fr
			rename 's/'$argv[2]'/'$argv[3]'/' (ls -p | grep -v /)
		case fs
			rename 's/$/'$argv[2]'/' (ls -p | grep -v /)
		case fu
			rename 'y/a-z/A-Z/' (ls -p | grep -v /)
		case help
			cat ~/.config/fish/functions/help/rn | less
		case '*'
			if ls -p | grep -v / | head -n1 | rev | cut -b -5 | rev | grep -q '\.'
				set -l ext (ls -p | grep -v / | head -n1 | rev | cut -d'.' -f1 | rev)
				switch $argv[1]
				case fc 
					rename 's/.+/our $i; sprintf("'$argv[2]' %03d.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
				case fc'*'
					set -l number (echo $argv[1] | cut -b 3-)
					rename 's/.+/our $i; sprintf("'$argv[2]' %0'$number'd.'$ext'", 1+$i++)/e' (ls -p | grep -v /)
				case fe
					rename 's/\.'$ext'$/\.'$argv[2]'/' *.$ext
				case '*'
					rename $argv
				end
			else
				switch $argv[1]
				case fc
					rename 's/.+/our $i; sprintf("'$argv[2]' %03d", 1+$i++)/e' (ls -p | grep -v /)
				case fc'*'
					set -l number (echo $argv[1] | cut -b 3-)
					rename 's/.+/our $i; sprintf("'$argv[2]' %0'$number'd", 1+$i++)/e' (ls -p | grep -v /)
				case fe
					rename 's/$/.'$argv[2]'/' (ls -p | grep -v /)
				case '*'
					rename $argv
				end
			end
		end
	end
end
