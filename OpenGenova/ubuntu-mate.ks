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
ubuntu-software
gimp
chromium-browser
inkscape



%post

cd /tmp
echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list
wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
apt-key add - < Release.key
rm -f Release.key
apt-get update
# 07/06/2017 key expired adding --allow-unauthenticated
apt-get install --allow-unauthenticated arc-theme

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

mkdir -p /usr/share/OpenGenova/theme
cd /usr/share/OpenGenova/theme
wget -q https://raw.githubusercontent.com/belinux-it/L4A/master/OpenGenova/theme/ubuntu-mate.png

#Let's apply our alredy set changes
wget -O user https://github.com/belinux-it/L4A/blob/master/OpenGenova/theme/user?raw=true
mkdir -p /home/opengenova/.config/dconf
cp user /home/opengenova/.config/dconf
chown -R 1000:1000 /home/opengenova/.config

# Telegram install
LC_ALL=C.UTF-8 add-apt-repository ppa:atareao/telegram -y
apt-get update
apt-get install telegram

# customize MATE theme layout
#mkdir -p /etc/dconf/db/mate.d/lock/
#mkdir -p /etc/dconf/profile/

#echo "user-db:user" > /etc/dconf/profile/user
#echo "system-db:mate" >> /etc/dconf/profile/user

#cat <<EOF > /etc/dconf/db/mate.d/10-keyboard
#[org/mate/desktop/peripherals/keyboard/kbd]
#layouts=['it','us','fr','de']

#[org/mate/desktop/peripherals/keyboard/general]
#group-per-window=false

#[org/mate/marco/global-keybindings]
#run-command-terminal='<Primary><Alt>t'

#[org/mate/terminal/global]
#use-menu-accelerators=false
#use-mnemonics=false
#EOF

#cat <<EOF > /etc/dconf/db/mate.d/10-touchpad
#[org/mate/desktop/peripherals/touchpad]
#tap-to-click=false
#horiz-scroll-enabled=true
#touchpad-enabled=true
#scroll-method=2
#EOF

#cat <<EOF > /etc/dconf/db/mate.d/15-theme
#[org/mate/desktop/background]
#picture-filename='/usr/share/OpenGenova/theme/ubuntu-mate.png'

#[org/mate/pluma]
#auto-indent=true
#insert-spaces=true
#color-scheme='Arc'

#[org/mate/caja/desktop]
#computer-icon-visible=true
#trash-icon-visible=true

#[org/mate/marco/general]
#num-workspaces=1

#[org/mate/caja/preferences]
#show-image-thumbnails='always'

#[org/mate/desktop/font-rendering]
#hinting='slight'

#[org/mate/desktop/media-handling]
#automount-open=false

#[org/mate/screensaver]
#lock-enabled=false
#mode='blank-only'
#themes='[]'

#[org/mate/desktop/interface]
#gtk-theme='Arc'
#icon-theme='Ultra-Flat-Orange'

#[org/mate/marco/general]
#num-workspaces=1
#theme='Arc'
#compositing-manager=false

#[org/mate/panel/general]
#locked-down=true

#[org/mate/power-manager]
#backlight-battery-reduce=false
#EOF

#cat <<EOF > /etc/dconf/db/mate.d/20-panel
#[org/mate/panel/general]
#toplevel-id-list=['bottom']
#object-id-list=['main-menu', 'show-desktop', 'window-list', 'notification-area', 'indicators', 'clock-applet']
#
#[org/mate/panel/toplevels/bottom]
#orientation='bottom'
#size=30

#[org/mate/panel/objects/main-menu]
#object-type='menu'
#toplevel-id='bottom'
#
#[org/mate/panel/objects/show-desktop]
#object-type='applet'
#applet-iid='WnckletFactory::ShowDesktopApplet'
#toplevel-id='bottom'
#panel-right-stick=false
#position=1
#
#[org/mate/panel/objects/window-list]
#applet-iid='WnckletFactory::WindowListApplet'
#toplevel-id='bottom'
#position=2
#object-type='applet'
#panel-right-stick=false
#
#
#[org/mate/panel/objects/indicators]
#object-type='applet'
#applet-iid='IndicatorAppletCompleteFactory::IndicatorAppletComplete'
#toplevel-id='bottom'
#panel-right-stick=true
#position=1
#
#[org/mate/panel/objects/notification-area]
#object-type='applet'
#applet-iid='NotificationAreaAppletFactory::NotificationArea'
#toplevel-id='bottom'
#panel-right-stick=true
#position=2
#
#[org/mate/panel/objects/clock-applet]
#object-type='applet'
#applet-iid='ClockAppletFactory::ClockApplet'
#toplevel-id='bottom'
#panel-right-stick=true
#position=0
#
#[org/mate/panel/objects/clock-applet/prefs]
#show-date=false
#EOF

# let's rebuild the database in /etc/dconf/db/mate:
#dconf update
