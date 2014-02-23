#import pyotherside
import os
import sys
import win32_check

root_dir = os.path.dirname(os.path.realpath(__file__))

def exe(exe_path='\\retroarch_v1.0\\retroarch.exe'):
    return exe_path

def cfg(cfg_path = '\\retroarch_v1.0\\custom.cfg'):
    return cfg_path 

def launch(game_path, core, *args):
    '''game_path and core are defined in main.qml'''
    if win32_check.check():
        run = exe() + ' ' + '-c ' + root_dir + cfg() + ' ' + self._core + ' ' + game_path 
        return os.system(run)
    else:
        run = exe(exe_path='/usr/bin/retroarch') + ' {:}'.format("".join(args)) + '-c ' + cfg(cfg_path='~/.config/retroarch/custom.cfg') + ' -L ' + core + ' ' + game_path
        os.system(run)
        return run
