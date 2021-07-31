#!/usr/bin/env python
# modified from original:
# https://github.com/madnight/dotfiles/blob/5ba9c19107478cd07fc5eb36a815c54d51105763/scripts/lock.py
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
import dbus
import subprocess
import sys
import threading

from PIL import Image
import mss

import time


class Locker:
    def __init__(self):
        self.locked = False
        self.notifications_props = None
        self.secrets_props = None

    def set_dbus_props(self, refresh=False):
        if self.notifications_props is None or refresh is True:
            notifications = dbus.SessionBus().get_object(
                'org.freedesktop.Notifications', '/org/freedesktop/Notifications'
            )
            self.notifications_props = dbus.Interface(notifications, 'org.freedesktop.DBus.Properties')

        if self.secrets_props is None or refresh is True:
            secrets = dbus.SessionBus().get_object(
                'org.freedesktop.secrets', '/org/freedesktop/secrets/aliases/default'
            )
            self.secrets_props = dbus.Interface(secrets, 'org.freedesktop.DBus.Properties')

    def run(self):
        DBusGMainLoop(set_as_default=True)
        systembus = dbus.SystemBus()
        sessionbus = dbus.SessionBus()
        # register your signal callback
        systembus.add_signal_receiver(
            self.signal_handler_session,
            # bus_name='org.freedesktop.DBus',
            dbus_interface='org.freedesktop.login1.Session',
            # destination_keyword='destination',
            # interface_keyword='interface',
            member_keyword='member',
            message_keyword='message',
            path_keyword='path',
            # sender_keyword='sender',
        )
        sessionbus.add_signal_receiver(
            self.signal_handler_secretservice,
            # bus_name='org.freedesktop.DBus',
            dbus_interface='org.freedesktop.Secret.Service',
            # destination_keyword='destination',
            # interface_keyword='interface',
            member_keyword='member',
            message_keyword='message',
            path_keyword='path',
            # sender_keyword='sender',
        )
        loop = GLib.MainLoop()
        loop.run()

    def signal_handler_session(self, *args, **kwargs):
        if kwargs['member'] == 'Lock':
            self.lock()
        elif kwargs['member'] == 'Unlock':
            self.unlock()

    def signal_handler_secretservice(self, *args, **kwargs):
        if kwargs['member'] == 'CollectionChanged':
            self.set_dbus_props(refresh=True)
            try:
                locked = bool(self.secrets_props.GetAll('org.freedesktop.Secret.Collection')['Locked'])
            except dbus.exceptions.DBusException:
                print('Keyring not available')
                locked = True
            print('Keyring locked:', locked)

            if locked is True:
                # pause evolution
                subprocess.run(['killall', 'evolution', '-s', 'STOP'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            elif locked is False:
                # if keyring is unlocked, resume evolution
                time.sleep(0.1)
                subprocess.run(['killall', 'evolution', '-s', 'CONT'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    def i3lock(self, result):
        print('LOCKED')
        self.locked = True
        self.killprog = 'i3lock'
        subprocess.run(
            ['i3lock', '--raw', str(result.width) + 'x' + str(result.height) + ':rgb', '-i', '/dev/stdin'],
            stdout=subprocess.PIPE,
            input=result.tobytes(),
        )
        self.unlock(kill=False)

    def betterlockscreen(self):
        print('LOCKED')
        self.locked = True
        self.killprog = 'i3lock'
        subprocess.run(['betterlockscreen', '--lock'], stdout=subprocess.PIPE)
        self.unlock(kill=False)

    def unlock(self, kill=True):
        if self.locked is False:
            return

        if kill is True:
            subprocess.run(['killall', self.killprog], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        print('UNLOCKED')
        self.locked = False

        subprocess.run(['loginctl', 'unlock-session'], stdout=subprocess.PIPE)

        # if notifications have been on then resume them
        if self.notifications_paused_before is False:
            self.notifications_props.Set('org.dunstproject.cmd0', 'paused', False)
            print('resumed notifications')

    def lock(self):
        if self.locked:
            return

        sct = mss.mss()

        # take screenshot
        sct_img = sct.grab(sct.monitors[0])
        img = Image.frombytes('RGB', sct_img.size, sct_img.bgra, 'raw', 'BGRX')

        # pixelate
        imgSmall = img.resize((int(img.size[0] / 10), int(img.size[1] / 10)), resample=Image.BILINEAR)
        result = imgSmall.resize(img.size, Image.NEAREST)

        # add lock icon
        try:
            icon_path = sys.argv[1]
        except IndexError:
            print('No lock icon path set')
            # icon_path = '/usr/share/i3lock-fancy-dualmonitor/lock.png'
        else:
            icon = Image.open(icon_path)

            # show lock icon on all monitors
            for monitor in sct.monitors[1:]:
                area = (
                    int(((monitor['width'] / 2) + monitor['left']) - icon.size[0] / 2),
                    int(((monitor['height'] / 2) + monitor['top']) - icon.size[1] / 2),
                )
                # add lock icon to bg image
                result.paste(icon, area, icon)

        self.set_dbus_props()
        self.notifications_paused_before = bool(self.notifications_props.GetAll('org.dunstproject.cmd0')['paused'])

        # if notifications are on then pause them
        if self.notifications_paused_before is False:
            self.notifications_props.Set('org.dunstproject.cmd0', 'paused', True)
            print('paused notifications')

        threading.Thread(target=self.i3lock, args=(result,)).start()
        # threading.Thread(target=self.betterlockscreen).start()


print(time.asctime(), 'Starting', flush=True)

locker = Locker()
try:
    locker.run()
except KeyboardInterrupt:
    pass

print('\nExiting...', flush=True)
