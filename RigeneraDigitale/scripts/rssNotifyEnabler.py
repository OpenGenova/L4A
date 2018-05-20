#!/usr/bin/python
'''
rssNotifyEnabler allow to enable rss feeds for rssNotifier

License: GPLv3

Author:  Angelo Naselli <anaselli@linux.it>
Author:  Luigi Sainini  <luigi.sainini@tiscali.it>

'''


import sys
import yaml

from os.path import expanduser, join, exists
import os


class Config() :
    ''' Config reads and writes the rssNotifier self.configuration,
    such as ~/.rssNotifier.yaml
    '''
    def __init__(self) :
        self.content    = None
        self._project   = 'rssNotifier'
        self._fileName  = "." + self._project + ".yaml"
        pathdir = os.path.expanduser("~")
        self._pathName = os.path.join(pathdir, self._fileName)

    '''
    load self.configuration file into content and return it
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
    write content into the self.configuration file
    '''
    def write(self) :
        with open(self._pathName, 'w') as outfile:
            yaml.dump(self.content, outfile, default_flow_style=False)


import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

class TableWindow(Gtk.Window):

  def __init__(self):
    self.config = Config()
    if self.config.load() :
      print ("ok")
      if "channels" in self.config.content.keys():
        Gtk.Window.__init__(self, title="Abilitazione notifiche")
        self.set_border_width(40)
        #### TODO icon name must be the application one and we need to set one icon for channels or
        #### channel group (read from configuration file)
        icon_file = "/usr/share/OpenGenova/scripts/xliguria.png"
        if os.path.exists(icon_file):
            self.set_icon_from_file(icon_file)

        box_outer = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.add(box_outer)

        # add generic group if not present to avoid crash soon after
        for ch in self.config.content["channels"]:
          if 'group' not in ch.keys():
            ch['group'] = "Other"

        group_name = None
        for ch in (sorted(self.config.content["channels"], key=lambda ch: (ch['group'], ch['name']))) :
          if "url" in ch.keys() and "enabled" in ch.keys():
            if ("name" in ch.keys()) :
              if group_name != ch['group'] :
                listbox = Gtk.ListBox()
                listbox.set_selection_mode(Gtk.SelectionMode.NONE)
                box_outer.pack_start(listbox, True, True, 0)
                group_name = ch['group']

              row = Gtk.ListBoxRow()
              hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=50)
              row.add(hbox)
              vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
              hbox.pack_start(vbox, True, True, 0)

              label1 = Gtk.Label(ch['name'], xalign=0)
              vbox.pack_start(label1, True, True, 0)

              switch = Gtk.Switch()
              switch.set_active(ch["enabled"])
              switch.connect("notify::active", self.on_switch_activated, ch)
              switch.props.valign = Gtk.Align.CENTER
              hbox.pack_start(switch, False, True, 0)

              listbox.add(row)
        
        hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=50)
        box_outer.pack_start(hbox, True, True, 0)
        button = Gtk.Button.new_with_label("Salva")
        button.connect("clicked", self.on_Save_clicked)
        hbox.pack_start(button, True, True, 0)

        button = Gtk.Button.new_with_mnemonic("_Esci")
        button.connect("clicked", self.on_Exit_clicked)
        hbox.pack_start(button, True, True, 0)
          
  def on_switch_activated(self, switch, gparam, ch):
    ch["enabled"] = switch.get_active()
    print("Switch was turned")

  def on_Exit_clicked(self, button):
    Gtk.main_quit()
    print("Good bye")

  def on_Save_clicked(self, button):
    self.config.write()
    print("Saved")
        
if __name__ == "__main__":

  win = TableWindow()
  win.connect("delete-event", Gtk.main_quit)
  win.show_all()
  Gtk.main()


