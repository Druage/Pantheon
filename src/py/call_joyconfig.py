import subprocess
import os
import shlex
import win32_check
import pyotherside
import constants
import sys

def call():
    if win32_check.check():
        joy_path = os.path.join(constants.walk_up_to('utilities'), 'retroarch-joyconfig.exe')
        subprocess.call(joy_path, shell=False)
        message = 'Windows'
    else:
        subprocess.Popen(shlex.split('gnome-terminal -x bash -c "/usr/bin/retroarch-joyconfig"'))
        message = 'Linux'
    pyotherside.send("ada", message)
    message = '{:} terminal called'.format(message)
    pyotherside.send('status', message)
    return message

from subprocess import Popen, PIPE

def run():
    joyconfig = root_path.path() + '/retroarch-joyconfig'
    p = subprocess.Popen([joyconfig], universal_newlines=True, stdout=PIPE)
    text = p.communicate()[0]
    print("hello")
    return text

