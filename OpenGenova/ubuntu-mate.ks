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
#preseed partman-auto/method string regular

# You can choose one of the three predefined partitioning recipes:
# - atomic: all files in one partition
# - home: separate /home partition
# - multi: separate /home, /usr, /var, and /tmp partitions
#preseed partman-auto/choose_recipe select atomic

# This makes partman automatically partition without confirmation, provided
# that you told it what to do using one of the methods above.
#preseed partman-partitioning/confirm_write_new_label boolean true
#preseed partman/choose_partition select finish
#preseed partman/confirm boolean true
#preseed partman/confirm_nooverwrite boolean true

#Advanced partition
#part /boot --fstype=ext4 --size=500 --asprimary
#part pv.aQcByA-UM0N-siuB-Y96L-rmd3-n6vz-NMo8Vr --grow --size=1
#volgroup vg_mygroup --pesize=4096 pv.aQcByA-UM0N-siuB-Y96L-rmd3-n6vz-NMo8Vr
#logvol / --fstype=ext4 --name=lv_root --vgname=vg_mygroup --grow --size=10240 --maxsize=20480
#logvol swap --name=lv_swap --vgname=vg_mygroup --grow --size=1024 --maxsize=8192
part / --fstype ext4 --size 1 --grow --asprimary 
part swap --size 1024 
# part /boot --fstype ext4 --size 256 --asprimary 

#Setup NTP
preseed clock-setup/ntp boolean true
preseed clock-setup/ntp-server string pool.ntp.org

#System authorization infomation
auth --useshadow --enablemd5

#Network information
network --bootproto=dhcp --device=eth0

# If you want to force a hostname, regardless of what either the DHCP
# server returns or what the reverse DNS entry for the IP is, uncomment
# and adjust the following line.
preseed netcfg/hostname string opengenova

#Firewall configuration
firewall --disabled --trust=eth0 --ssh

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
