#!/usr/bin/env python

# Get pressure stall information (psi) from /proc/pressure/* and output it as JSON for i3status-rust

import json
import argparse
import re

parser = argparse.ArgumentParser()
parser.add_argument('type', choices=['cpu', 'io', 'memory'], default='cpu')
parser.add_argument('--period', choices=['10', '60', '300'], default='10')
parser.add_argument('--decimals', choices=[0, 1, 2], default=1, type=int)
parser.add_argument('--full', action='store_true')
args = parser.parse_args()

if args.type == 'cpu' and args.full:
    print(json.dumps({'text': 'cpu does not support full', 'state': 'Critical'}, indent=2))
    exit(1)


def get_psi(args):
    with open(f'/proc/pressure/{args.type}') as f:
        psi = f.read()

    if args.full:
        somefull = 'full'
    else:
        somefull = 'some'

    matches = re.finditer(
        r'(?P<somefull>....) avg10=(?P<avg10>\d+\.\d+) avg60=(?P<avg60>\d+\.\d+) avg300=(?P<avg300>\d+\.\d+) total=\d+',
        psi,
    )
    period = f'avg{args.period}'

    for m in matches:
        if m.group('somefull') == somefull:
            return m.group(period)


output = {'state': 'Info'}

# set icon
if args.type == 'cpu':
    output['icon'] = 'cpu'
if args.type == 'io':
    output['icon'] = 'memory_swap'
if args.type == 'memory':
    output['icon'] = 'memory_mem'

# set text
psi_avg = float(get_psi(args))
output['text'] = f'{psi_avg:.{args.decimals}f}'

# set state
if psi_avg == 0:
    output['state'] = 'Idle'
    output['text'] = ''
elif psi_avg < 1:
    output['state'] = 'Info'
elif psi_avg < 5:
    output['state'] = 'Good'
elif psi_avg < 25:
    output['state'] = 'Warning'
else:
    output['state'] = 'Critical'

print(json.dumps(output, indent=2))
