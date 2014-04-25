import os
import fnmatch
import constants
import pyotherside as py
        
def cg(shader):
    if shader is not None:
        if shader == '':
            shader_file = ""
        else:
            shader_file = os.path.join(constants.shaders_path(), shader)
        cg_file = {'shaders': '1',
                   'shader0': shader_file,
                   'wrap_mode0': 'clamp_to_border',
                   'float_framebuffer0': 'false'}
        return cg_file
    else:
        return None
     
def write_shader(shader, shader_type='cg'):
    if shader_type == 'cg':
        shader_file = cg(shader)
    if shader_file is not None:
        shader_path = constants.shader_config_path()
        cgp_file = os.path.join(shader_path, 'retroarch.cgp')
        with open(cgp_file, 'w') as infile:
            for key, val in shader_file.items():
                infile.writelines('{:} = "{:}"\n'.format(key, val))
    else:
        return None
