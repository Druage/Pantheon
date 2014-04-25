#import pyotherside
import os
import sys
import win32_check
import root_path
import subprocess as subp
import storage
import pyotherside
import format

def check_for_bios(core):
    if 'psx' in core or 'gba' in core:
        pyotherside.send('status', 'Bios may not have been found, try finding here <a href=\"http://emulation-general.wikia.com/wiki/Recommended_PSX_Plugins">Wiki</a>')
        
def launch(exe_path, game_path, core_path, cfg_path):
    '''game_path and core are defined in main.qml'''
    if win32_check.check():
        exe_path = '"{:}"'.format(exe_path)
        cfg_path = '"{:}"'.format(cfg_path)
        libcore_path = '"{:}"'.format(core_path)
        run = '{:} -c {:} -L {:} "{:}"'.format(exe_path, cfg_path, libcore_path, game_path)
        storage.log(run)
        try:
            pyotherside.send('status', 'Game Launched!')
            subp.check_call(run, shell=True)
        except FileNotFoundError:
            pyotherside.send('status', 'RetroArch was not found')
        except subp.CalledProcessError:
            pass
            #check_for_bios(core_path)
