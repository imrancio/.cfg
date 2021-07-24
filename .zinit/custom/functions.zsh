####################
# Custom functions #
####################

# Conky

# kill Conky-Skeleton
conkykill()
{
	kill $(pgrep -f conkyrc.lua)
}

# change Conky-Skeleton wifi interface
conkywifi()
{
	if [ -n $1 ]; then
		find ~/.conky/Conky-Skeleton -type f -name "skeleton*.lua" -exec sed -i'' -e "s/$(grep -oP 'upspeed ([a-z0-9]*)+' ~/.conky/Conky-Skeleton/conkyrc.lua | cut -d ' ' -f 2)/$1/g" {} +
	else
		echo "Usage: conkywifi <new interface>"
	fi
}

# conkylan()
# {
# 	if [ -n $1 ]; then
# 		find ~/.conky/Conky-Skeleton -type f -name "skeleton*.lua" -exec sed -i'' -e "s/$(grep -oP 'Wired LAN device: ${color0}([a-z0-9]*)+${color}' ~/.conky/Conky-Skeleton/conkyrc.lua | cut -d ' ' -f 2)/$1/g" {} +
# 	else
# 		echo "Usage: conkylan <new interface>"
# 	fi
# }

conkys()
{

	conky -dc ~/.conky/Conky-Skeleton/conkyrc.lua
}

# start Conky-Skeleton
conkystart()
{
	conky -c ~/.conky/Conky-Skeleton/conkyrc.lua &>/dev/null
}

# Networking
abyss_vpn()
{
	if [ $# -eq 1 ]; then
		sudo wg-quick $1 abyss
	else
		echo "usage: abyss_vpn <up/down>"
	fi
}

# get public facing ip
whereami()
{
	command -v dig >/dev/null 2>&1 || { 
		curl https://ipinfo.io/ip; 
		echo "Install 'bind-tools' or 'dnsutils' for faster results!"; 
		return }
	# faster dig ip from DNS (if exists)
	dig @resolver4.opendns.com myip.opendns.com +short
}

# private IPs
ipv4()
{
	if [ $# -eq 1 ]; then
		ip addr show $1 | grep "inet\b" | awk '{print $2}'
	else
		echo "Usage: ipv4 <net interface>"
	fi
}
ipv6()
{
	if [ $# -eq 1 ]; then
		ip addr show $1 | grep "inet6\b" | awk '{print $2}'
	else
		echo "Usage: ipv4 <net interface>"
	fi
}

# show MAC addr of net interface
mac()
{
	if [ $# -eq 1 ]; then
		ip link show $1 | grep ether | awk '{print toupper($2)}'
	else
		echo "Usage: mac <net interface>"
	fi
}

# list net interfaces
interfaces()
{
	ip a | grep -P "^[\d]+:" | awk '{print $2}' | tr -d ":$"
}

# update git fork from upstream
gitfu()
{
	git fetch upstream
	git checkout master
	git merge upstream/master
}

# Dirs / Files

# search in files
in()
{
	if [ $# -eq 1  ]; then
		grep --exclude=*.o 
--exclude-dir={/boot,/dev,/initrd,/proc} -rnw '/' -e $1
	elif [ $# -eq 2 ]; then
		grep -rnw $1 -e $2
	else
		echo 'Usage: in <optional: dir/to/search> "<regexp>"'
	fi
}

# search in PDFs (requires pdfgrep)
inpdf()
{
	if [ $(command -v pdfgrep) ]; then
		if [ $# -eq 1  ]; then
	        find ./ -name '*.pdf' -exec pdfgrep $1 "{}" +;
	    elif [ $# -eq 2 ]; then
	        find $1 -name '*.pdf' -exec pdfgrep $2 "{}" +;
	    else
	        echo 'Usage: inpdf <optional: dir/to/search> "<regexp>"'
	    fi
	else
		echo "Install pdfgrep first!"
	fi
}

# list biggest n files in current directory; defaults to 10
biggest()
{
	if [ $# -eq 0 ] || [ $1 -lt 1 ]; then
		du | sort -hr | head
	else
		du | sort -hr | head -n $1
	fi
}

# more efficient removal of directory with many folders/files
rmfast()
{
	if [ -d "$1" ]; then
		command -v rsync >/dev/null 2>&1 || { "Install rsync package first!"; return }
		vared -p $'\033[31m[WARNING]\e[0m '"Permanently remove '$1' ? [y/N] " -c yn
		case $yn in
		    [Yy]* )
				mkdir -p empty_dir
				rsync -av --stats --delete empty_dir/ "$1"
				rmdir empty_dir "$1"
				;;
			* )
				;;
		esac
	else
		echo "Usage: rmfast dir/to/delete"
	fi
}

# Fix tearing issue with nvidia
tearing() 
{
	local f="$1"
	if [ "$f" == "off"  ]; then
        nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
    elif [ "$f" == "on" ]; then
        nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = Off }"
    else
        echo 'Usage: tearing <off>'
    fi
}

# kill process in port
portkill()
{
	if [ $# -eq 1 ]; then
		fuser -k $1/tcp
	fi
}

venv() {
	if [ $# -eq 1 ]; then
		source ~/venvs/$1/bin/activate
	fi
}

update_zsh_plugins() {
	for plugin in $ZSH_CUSTOM/plugins/*; do
		if [ $(basename $plugin) != example ]; then
		  cd $plugin && git pull
		fi
	done
}

dump() {
	if [ $# -eq 1 ]; then
		while true; do echo "$1"; done
	else
		echo "Usage: dump <string>"
	fi
}

whatcanido() {
	echo "Everything!"
}

abyss_start() {
	abyss_vpn up
	firefox https://mail.google.com/mail/u/1/#inbox https://calendar.google.com/calendar/u/1/r & disown > /dev/null
}
abyss_stop() {
	abyss_vpn down
}
update-boot() {
	sdboot-manage gen
}
# remove orphaned packages
pacman-clean() {
	sudo pacman -Rns $(pacman -Qtdq)
}

xfce-reset-keyboard-shortcuts() {
	killall xfconfd
	/usr/lib/xfce4/xfconf/xfconfd &
	xfsettingsd --replace &
}
