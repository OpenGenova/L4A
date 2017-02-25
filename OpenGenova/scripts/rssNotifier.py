#!/usr/bin/python
'''
rssNotifier is a RSS notifier, it sends the news received if any to notify daemon

License: GPLv3

Author:  Angelo Naselli <anaselli@linux.it>
'''

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


'''
notify a messag to the notify daemon
'''
def sendmessage(title, message):
    pynotify.init("Test")
    notice = pynotify.Notification(title, message)
    notice.show()
    return

if __name__ == "__main__":

    config = Config()
    if config.load() :
        print ("ok")
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
                if rss:
                    if rss.status == 304:
                        print("no changes")
                    else:
                        title = rss.channel.title
                        # Let's take the last news only
                        entry = rss.entries[0]
                        message = '<b>%s</b><br><%s><br><a href="%s">Leggi</a>'%(entry.title, entry.published, entry.link)
                        sendmessage(title, message)
                        #if not last_modified :
                            #entry = rss.entries[0]
                            #message = '<b>%s</b><br><%s><br><a href="%s">Leggi</a>'%(entry.title, entry.published, entry.link)
                            #sendmessage(title, message)
                        #else:
                            #for entry in rss.entries :
                                #message = '<n>%s</n><br><%s><br><a href="%s">Leggi</a>'%(entry.title, entry.published, entry.link)
                                #sendmessage(title, message)
                        ch["last_update"] = rss.modified

                print (ch)
        config.write()
    else :
        print ("Config file problem, doing nothing")

