#!/bin/bash

download()
{
    #Let's apply our alredy set changes
    cd /usr/share/OpenGenova/
    wget -O opengenova-home.tar.bz2 https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/opengenova-home.tar.bz2?raw=true
    cd /usr/share/OpenGenova/scripts
    wget -O rssNotifier.py https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/rssNotifier.py?raw=true
    chmod +x rssNotifier.py
    wget -O rssNotifyEnabler.py https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/rssNotifyEnabler.py?raw=true
    chmod +x rssNotifyEnabler.py
    wget -O rssNotifier.yaml https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/rssNotifier.yaml?raw=true
    wget -O xliguria.png https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/xliguria.png?raw=true
    wget -O xliguria.desktop https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/xliguria.desktop?raw=true
    wget -O Configurazione_xLiguria.desktop https://github.com/OpenGenova/L4A/blob/master/RigeneraDigitale/scripts/Configurazione_xLiguria.desktop?raw=true
    cp Configurazione_xLiguria.desktop /usr/share/applications
}


while getopts ":rh" opt; do
  case $opt in
    r)
      echo "Downloading configuration from remote"
      download
      ;;
    h)
      echo "$0 [options]"
      echo "-r : download configuration from remote"
      echo "-h : help"
      exit
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit
      ;;
  esac
done

#Let's apply our alredy set changes
cd /home
rm -rf opengenova
tar xjvf /usr/share/OpenGenova/opengenova-home.tar.bz2

#Let's install rss notifier (xliguria) scripts
cd /usr/share/OpenGenova/scripts
cp rssNotifier.yaml /home/opengenova/.rssNotifier.yaml
chown -R 1000:1000 /home/opengenova/.rssNotifier.yaml
mkdir -p /home/opengenova/.config/autostart
cp xliguria.desktop /home/opengenova/.config/autostart
chown -R 1000:1000 /home/opengenova/.config

echo press return to reboot
read
reboot


