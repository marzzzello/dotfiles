#!/usr/bin/env python

from i3ipc import Connection  # use master branch for sway: https://github.com/altdesktop/i3ipc-python/pull/171
import argparse
import re
import subprocess


def wifi_nm():
    """
    get wifi state from networkmanager
    """
    output = subprocess.check_output(['nmcli', 'radio', 'wifi'])
    state = output.decode('utf-8').strip()
    if state == "enabled":
        return True
    else:
        return False


# def wifi_rfkill():
#     """
#     get wifi state from rfkill
#     """
#     output = subprocess.check_output(['rfkill', 'list', 'wifi'])
#     r = re.findall("blocked: yes", output.decode('utf-8'))
#     if len(r) == 0:
#         # wifi not blocked
#         return True
#     else:
#         return False

parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='''
Toggle app (open/close):
If the app is not open, it will be launched, if it is open, it will be closed.
use `xprop | grep WM_CLASS` first part of the WM_CLASS is the instance, the second part is the class
    ''',
)

group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('--class', dest='CLASS', help='class name of app')
group.add_argument('--instance', dest='INSTANCE', help='instance name of app')

parser.add_argument('--floating', action='store_true', help='only look for floating windows')
parser.add_argument('--title', help='only look for windows with this title (supports regex)')


parser.add_argument(
    '--exec', metavar='CMD', help='command to execute if app is not open (default: use instance/class name)'
)
parser.add_argument('--network', action='store_true', help='(automatic) network mode')


args = parser.parse_args()

conn = Connection()
if args.CLASS:
    ps = conn.get_tree().find_classed(args.CLASS)
elif args.INSTANCE:
    ps = conn.get_tree().find_instanced(args.INSTANCE)
else:
    parser.error('class or instance required')

killed = False
for p in ps:
    if (re.findall(args.title, p.name) if args.title else True) and (
        p.type == 'floating_con' if args.floating else True
    ):
        print('kill', p.app_id)
        p.command('kill')
        killed = True

if args.network and wifi_nm():
    net = ' wifi'
elif args.network:
    net = ' network'
else:
    net = ''

if not killed:
    if args.exec:
        conn.command(f'exec {args.exec}{net}')
    elif args.INSTANCE:
        conn.command(f'exec {args.INSTANCE}{net}')
    elif args.CLASS:
        conn.command(f'exec {args.CLASS}{net}')
    else:
        parser.error('exec, class or instance required')
