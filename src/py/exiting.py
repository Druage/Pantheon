import pyotherside
import root_path
import format

def call_on_exit(*args):
    phoenix_cfg = root_path.change('..') + '/phoenix.cfg'
    with open(phoenix_cfg, 'w') as ifile:
        output = ''.join(map(format.format, args))
        ifile.write('{:}'.format(output))
