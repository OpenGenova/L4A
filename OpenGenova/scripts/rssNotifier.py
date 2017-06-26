#!/usr/bin/python
# vim: set fileencoding=utf-8 :

'''
rssNotifier is a RSS notifier, it sends the news received if any to notify daemon

License: GPLv3

Author:  Angelo Naselli <anaselli@linux.it>
'''

import time
import feedparser
import pynotify

import sys
import yaml

from os.path import expanduser, join
import os


class Config() :
    ''' Config reads and writes the rssNotifier configuration,
    such as ~/.rssNotifier.yaml
    '''
    def __init__(self) :
        self.content    = None
        self._project   = 'rssNotifier'
        self._fileName  = "." + self._project + ".yaml"
        pathdir = os.path.expanduser("~")
        self._pathName = os.path.join(pathdir, self._fileName)

    '''
    load configuration file into content and return it
    '''
    def load(self) :
        try:
            with open(self._pathName, 'r') as ymlfile:
                self.content = yaml.load(ymlfile)
                return self.content
        except IOError as e:
            print ("Skipped exception: <%s> " % str(e))
            return None

        return None

    '''
    write content into the configuration file
    '''
    def write(self) :
        with open(self._pathName, 'w') as outfile:
            yaml.dump(self.content, outfile, default_flow_style=False)

class Notifier:

    def __init__(self):
        self.__running     = True
        #default 60 minutes
        self.__updateInterval = 60

    def run(self):
        self.__loop()

    def __loop(self):
        event = None
        while self.__running == True:
            self.__checkAndNotify()
            time.sleep(self.__updateInterval*60)

    def __checkAndNotify(self):
        config = Config()
        if config.load() :
            print ("ok - %s"%(time.strftime("%a, %d %b %Y %H:%M:%S +0000", time.localtime())))
            if "settings" in config.content.keys():
                if "update_interval" in config.content['settings'] :
                    self.__updateInterval = config.content['settings']['update_interval']
                    print("read update interval %d"%(self.__updateInterval)) 
            else :
                config.content['settings'] = {'update_interval' : 60}
            pynotify.init("markup")
            if "channels" in config.content.keys():
                for ch in config.content["channels"] :
                    rss = None
                    last_modified = None
                    if "url" in ch.keys() and "enabled" in ch.keys():
                        if ch["enabled"]:
                            if "last_update" in ch.keys() :
                                last_modified = ch["last_update"]
                                rss = feedparser.parse(ch["url"], modified=last_modified)
                            else:
                                rss = feedparser.parse(ch["url"])
                            time.sleep(1)
                    if rss:
                        if rss.status == 304:
                            print("no changes")
                        else:
                            if 'title' in rss.channel.keys() :
                                title    = rss.channel.title
                            else:
                                print("No channel title found - broken read??? - skipping channel")
                                continue
                            subtitle = rss.channel.subtitle if "subtitle" in rss.channel.keys() else ""
                            # Let's take the last news only
                            entry = rss.entries[0]

                            if entry :
                                entry      = rss.entries[0]
                                etitle     = entry.title if "title" in entry.keys() else ""
                                epublished = entry.published if "published" in entry.keys() else ""
                                elink      = entry.link if "link" in entry.keys() else "https://xliguria.it/"
                                message = '''%s

%s

<b>%s</b>

<a href="%s">Leggi</a>'''%(subtitle, epublished, etitle, elink)
                                self.sendmessage(title, message)
                            if "updated" in rss.channel.keys() :
                                ch["last_update"] =  rss.channel.updated 

                    print (ch)
            config.write()
        else :
            print ("Config file problem, doing nothing")

    def sendmessage(self, title, message):
        '''
        notify a messag to the notify daemon
        '''

        notice = pynotify.Notification(title, message)
        notice.set_timeout(pynotify.EXPIRES_NEVER)
        notice.show()
        return

if __name__ == "__main__":
    n = Notifier()
    n.run()

