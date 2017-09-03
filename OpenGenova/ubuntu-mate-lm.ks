#Generic Kickstart template for Ubuntu
#Platform: x86 and x86-64
#

# fix local mirror hostname and directory
preseed mirror/country string manual
preseed mirror/http/hostname string 192.168.1.10
preseed mirror/http/directory string /ubuntu/
preseed mirror/http/proxy string
preseed mirror/codename string xenial
preseed mirror/suite string xenial

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
ubuntu-software
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

MIRROR_HOST="192.168.1.10"
# we install from a local mirror what we need as in network installation
# from http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/
cd /tmp
wget http://${MIRROR_HOST}/RigeneraDigitale/install/themes/arc-theme_1488477732.766ae1a-0_all.deb
gdebi -n -q arc-theme_1488477732.766ae1a-0_all.deb
rm -f arc-theme_1488477732.766ae1a-0_all.deb

#from https://launchpad.net/~noobslab/+archive/ubuntu/icons/+files/
wget -O Ultra-Flat-Orange.deb http://${MIRROR_HOST}/RigeneraDigitale/install/themes/ultra-flat-icons-orange_1.3.2~trusty~Noobslab.com_all.deb
gdebi -n -q Ultra-Flat-Orange.deb
rm -f Ultra-Flat-Orange.deb

# from http://ppa.launchpad.net/eugenesan/ppa/ubuntu/pool/main/m/mintmenu/
wget -O mintmenu_5.5.2-0~eugenesan~trusty1_all.deb http://${MIRROR_HOST}/RigeneraDigitale/install/themes/mintmenu_5.5.2-0~eugenesan~trusty1_all.deb 
gdebi -n -q mintmenu_5.5.2-0~eugenesan~trusty1_all.deb
rm -f mintmenu_5.5.2-0~eugenesan~trusty1_all.deb

# from ppa:atareao/telegram
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/other/telegram_1.1.0-0ubuntu0_i386.deb
gdebi -n -q telegram_1.1.0-0ubuntu0_i386.deb
rm -f telegram_1.1.0-0ubuntu0_i386.deb

# from github ghetto skype
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/other/ghetto-skype_1.5.0_i386.deb
gdebi -n -q ghetto-skype_1.5.0_i386.deb
rm -f ghetto-skype_1.5.0_i386.deb

#Let's install rss notifier (xliguria) scripts
# remove feedparser here if works in packages section
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/other/python-feedparser_5.1.3-3build1_all.deb
gdebi -n -q python-feedparser_5.1.3-3build1_all.deb
rm -f python-feedparser_5.1.3-3build1_all.deb

#from https://github.com/belinux-it/L4A/tree/master/OpenGenova/theme
mkdir -p /usr/share/OpenGenova/theme
cd /usr/share/OpenGenova/theme
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/themes/Applicazioni.png
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/themes/desktop.png
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/themes/login.png
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/themes/user.png
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/themes/lightdm-gtk-greeter.conf
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/themes/guest-user-skel
cp -f lightdm-gtk-greeter.conf /etc/lightdm

#Let's apply our alredy set changes
cd /usr/share/OpenGenova/
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/opengenova-home.tar.bz2
cd /home
rm -rf opengenova
tar xjvf /usr/share/OpenGenova/opengenova-home.tar.bz2

mkdir -p /usr/share/OpenGenova/scripts
cd /usr/share/OpenGenova/scripts
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/scripts/restore-opengenova-home.sh
chmod +x restore-opengenova-home.sh
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/scripts/rssNotifier.py
chmod +x rssNotifier.py
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/scripts/rssNotifyEnabler.py
chmod +x rssNotifyEnabler.py
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/scripts/rssNotifier.yaml
cp rssNotifier.yaml /home/opengenova/.rssNotifier.yaml
chown -R 1000:1000 /home/opengenova/.rssNotifier.yaml
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/scripts/xliguria.png
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/scripts/xliguria.desktop
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/scripts/Configurazione_xLiguria.desktop
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
cd -

# restore original source list (Ubuntu 16.04)
wget -q http://${MIRROR_HOST}/RigeneraDigitale/install/sources.list
mv sources.list /etc/apt

