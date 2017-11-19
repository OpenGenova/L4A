#Generic Kickstart template for Ubuntu
#Platform: x86 and x86-64
#

### Minimal server Virtual Machine
#preseed preseed/file=/cdrom/preseed/ubuntu-server-minimalvm.seed

#System language
lang it_IT

# Language modules to install
langsupport it_IT

# System keyboard
keyboard it

#System mouse
mouse

# System timezone
timezone Europe/Rome

#Root password
rootpw --disabled

#Initial user (user with sudo capabilities) 
user opengenova --fullname "Open Genova" --password opengenova

#Reboot after installation
reboot

#Use text mode install
text

#Install OS instead of upgrade
install

#Installation media
cdrom


#System bootloader configuration
bootloader --location=mbr

#Clear the Master Boot Record
zerombr yes

#Partition clearing information
clearpart --all --initlabel

#Basic disk partition
# The presently available methods are:
# - regular: use the usual partition types for your architecture
# - lvm: use LVM to partition the disk
# - crypto: use LVM within an encrypted partition
preseed partman-auto/method string regular

# You can choose one of the three predefined partitioning recipes:
# - atomic: all files in one partition
# - home: separate /home partition
# - multi: separate /home, /usr, /var, and /tmp partitions
preseed partman-auto/choose_recipe select atomic

# This makes partman automatically partition without confirmation, provided
# that you told it what to do using one of the methods above.
preseed partman-partitioning/confirm_write_new_label boolean true
preseed partman/choose_partition select finish
preseed partman/confirm boolean true
preseed partman/confirm_nooverwrite boolean true

#Advanced partition
#part /boot --fstype=ext4 --size=500 --asprimary
#part pv.aQcByA-UM0N-siuB-Y96L-rmd3-n6vz-NMo8Vr --grow --size=1
#volgroup vg_mygroup --pesize=4096 pv.aQcByA-UM0N-siuB-Y96L-rmd3-n6vz-NMo8Vr
#logvol / --fstype=ext4 --name=lv_root --vgname=vg_mygroup --grow --size=10240 --maxsize=20480
#logvol swap --name=lv_swap --vgname=vg_mygroup --grow --size=1024 --maxsize=8192
#part / --fstype ext4 --size 1 --grow --asprimary 
#part swap --size 1024 
# part /boot --fstype ext4 --size 256 --asprimary 

# By default the installer requires that repositories be authenticated
# using a known gpg key. This setting can be used to disable that
# authentication. Warning: Insecure, not recommended.
#preseed debian-installer/allow_unauthenticated boolean true


#Setup NTP
preseed clock-setup/ntp boolean true
preseed clock-setup/ntp-server string pool.ntp.org

#System authorization infomation
auth --useshadow --enablemd5

#Network information
network --bootproto=dhcp

# If you want to force a hostname, regardless of what either the DHCP
# server returns or what the reverse DNS entry for the IP is, uncomment
# and adjust the following line.
preseed netcfg/hostname string opengenova

#Firewall configuration
firewall --disabled --ssh

# Policy for applying updates. May be "none" (no automatic updates),
# "unattended-upgrades" (install security updates automatically), or
# "landscape" (manage system with Landscape).
preseed pkgsel/update-policy select unattended-upgrades


#Do not configure the X Window System
#skipx

%packages
ubuntu-mate-core
ubuntu-mate-desktop

# pre school edu
#ubuntu-edu-preschool
# primary school edu
#ubuntu-edu-primary
# secondary school edu
#ubuntu-edu-secondary
# tertiary school edu
#ubuntu-edu-tertiary

libreoffice-style-breeze
#ubuntu-software
software-center
gimp
chromium-browser
inkscape

#rss notifier
python-yaml
python-notify
python-pip
#pyhton-feedparser fails here :(
#pyhton-feedparser

%post

cd /tmp
# 14/10/2017 repository fails
#echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list
#wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
#apt-key add - < Release.key
#rm -f Release.key
#apt-get update
## 07/06/2017 key expired adding --allow-unauthenticated
#apt-get install --allow-unauthenticated arc-theme
# 14/10/2017 installing manually from its url
wget -O arc-theme-all.deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/all/arc-theme_1488477732.766ae1a-0_all.deb
gdebi -n -q arc-theme-all.deb
rm -f arc-theme-all.deb

wget -O Ultra-Flat-Orange.deb https://launchpad.net/~noobslab/+archive/ubuntu/icons/+files/ultra-flat-icons-orange_1.3.2~trusty~Noobslab.com_all.deb
gdebi -n -q Ultra-Flat-Orange.deb
rm -f Ultra-Flat-Orange.deb

wget -O mintmenu_5.5.2-0~eugenesan~trusty1_all.deb http://ppa.launchpad.net/eugenesan/ppa/ubuntu/pool/main/m/mintmenu/mintmenu_5.5.2-0~eugenesan~trusty1_all.deb 
gdebi -n -q mintmenu_5.5.2-0~eugenesan~trusty1_all.deb
rm -f mintmenu_5.5.2-0~eugenesan~trusty1_all.deb

wget https://github.com/stanfieldr/ghetto-skype/releases/download/v1.5.0/ghetto-skype_1.5.0_i386.deb
gdebi -n -q ghetto-skype_1.5.0_i386.deb
rm -f ghetto-skype_1.5.0_i386.deb

cd -

# import png to be used in our home
mkdir -p /usr/share/OpenGenova/theme
cd /usr/share/OpenGenova/theme
wget -q https://raw.githubusercontent.com/OpenGenova/L4A/master/RigeneraDigitale/theme/Applicazioni.png
wget -q https://raw.githubusercontent.com/OpenGenova/L4A/master/RigeneraDigitale/theme/desktop.png
wget -q https://raw.githubusercontent.com/OpenGenova/L4A/master/RigeneraDigitale/theme/login.png
wget -q https://raw.githubusercontent.com/OpenGenova/L4A/master/RigeneraDigitale/theme/user.png
wget -q https://raw.githubusercontent.com/OpenGenova/L4A/master/RigeneraDigitale/theme/lightdm-gtk-greeter.conf
wget -O guest-user-skel https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/theme/guest-user-skel?raw=true
cp -f lightdm-gtk-greeter.conf /etc/lightdm

#Let's apply our alredy set changes
cd /usr/share/OpenGenova/
wget -O opengenova-home.tar.bz2 https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/opengenova-home.tar.bz2?raw=true
cd /home
rm -rf opengenova
tar xjvf /usr/share/OpenGenova/opengenova-home.tar.bz2

#Let's install rss notifier (xliguria) scripts
# remove feedparser here if works in packages section
pip install --disable-pip-version-check -q feedparser
mkdir -p /usr/share/OpenGenova/scripts
cd /usr/share/OpenGenova/scripts
wget -O restore-opengenova-home.sh https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/restore-opengenova-home.sh?raw=true
chmod +x restore-opengenova-home.sh
wget -O rssNotifier.py https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/rssNotifier.py?raw=true
chmod +x rssNotifier.py
wget -O rssNotifyEnabler.py https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/rssNotifyEnabler.py?raw=true
chmod +x rssNotifyEnabler.py
wget -O rssNotifier.yaml https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/rssNotifier.yaml?raw=true
cp rssNotifier.yaml /home/opengenova/.rssNotifier.yaml
chown -R 1000:1000 /home/opengenova/.rssNotifier.yaml
wget -O xliguria.png https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/xliguria.png?raw=true
wget -O xliguria.desktop https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/xliguria.desktop?raw=true
wget -O Configurazione_xLiguria.desktop https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/Configurazione_xLiguria.desktop?raw=true
cp Configurazione_xLiguria.desktop /usr/share/applications
mkdir -p /home/opengenova/.config/autostart
cp xliguria.desktop /home/opengenova/.config/autostart
chown -R 1000:1000 /home/opengenova/.config

# something in our menu is not available for guest user
# let's add a new skel for guest based on the our one but with default menu
cp -r /etc/skel /etc/guest-session
mkdir -p /etc/guest-session/skel/.config/dconf
cp -f /usr/share/OpenGenova/theme/guest-user-skel /etc/guest-session/skel/.config/dconf/user

#let's change user skel
mkdir -p /etc/skel/.config/dconf
mkdir -p /etc/skel/.config/autostart
cp /home/opengenova/.rssNotifier.yaml /etc/skel/
cp /home/opengenova/.config/dconf/user /etc/skel/.config/dconf
cp /home/opengenova/.config/autostart/xliguria.desktop /etc/skel/.config/autostart

# Telegram install
LC_ALL=C.UTF-8 add-apt-repository ppa:atareao/telegram -y
apt-get update
apt-get install telegram

