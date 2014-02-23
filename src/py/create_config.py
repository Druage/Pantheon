import win32_check
import os


if win32_check.check():
    RETRO_PATH = os.path.abspath(os.path.join(os.path.dirname( __file__ ), '..', 'retroarch_v1.0'))
    OUTPUT_CFG = RETRO_PATH + '\\custom.cfg'
else:
    RETRO_PATH = os.path.abspath(os.path.dirname( __file__ ))
    OUTPUT_CFG = os.path.expanduser('~') + '/.config/retroarch/custom.cfg'

def get_config_data(cfg_file=RETRO_PATH + '/linux_retroarch.cfg'):
    with open(cfg_file, 'r') as  infile:
        cfg_data = infile.readlines()
        return cfg_data

def write_config(fid=OUTPUT_CFG, new_data=get_config_data()):
    with open(fid, "w") as outfile:
        outfile.seek(0)
        for lines in new_data:
            outfile.write("".join(lines))

