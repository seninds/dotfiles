#!/usr/bin/env python

import sys
import re
import subprocess


status_colors = {
    '^\s*M\s+': '31',     # red
    '^\s*\?\s+': '37',    # grey
    '^\s*A\s+': '32',     # green
    '^\s*X\s+': '33',     # yellow
    '^\s*C\s+': '30;41',  # black on red
    '^-[^-]': '31',       # red
    '^\s*D\s+': '31;1',   # bold red
    '^\+[^+]': '32',      # green
}


def colorize(line):
    for s, color in status_colors.items():
        if re.match(s, line):
            return ''.join(('\033[', color, 'm', line, '\033[m'))
    return line


def escape(s):
    s = s.replace('$', r'\$')
    s = s.replace('"', r'\"')
    s = s.replace('`', r'\`')
    return s


def quote(arg):
    return '"%s"' % escape(arg) if ' ' in arg else arg


if __name__ == '__main__':
    args_list = [quote(arg) for arg in sys.argv[1:]]
    cmd = ' '.join(['svn'] + args_list)
    output = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)

    tabsize = 4
    colorized_cmds = ('st', 'stat', 'status', 'add', 'rm', 'remove', 'diff', 'log')
    for line in output.stdout:
        line = line.expandtabs(tabsize)
        if(sys.argv[1] in colorized_cmds):
            line = colorize(line)
        try:
            sys.stdout.write(line)
        except:
            sys.exit(1)
