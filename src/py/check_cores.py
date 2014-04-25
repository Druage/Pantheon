import os
import win32_check
import root_path
import xml_creator
import pyotherside

def scan_cores(path, exten):
    if os.path.exists(path):
        matches = xml_creator.scan(path, exten, tag='core_exists')
        return matches
    else:
        return False

def get_matches():
    if win32_check.check():
        path = root_path.change('..') + '/retroarch_v1.0/libretro'
        result = scan_cores(path, ('*.dll'))
    else:
        result = scan_cores('/usr/lib/libretro', ('*.so'))
        
    if result is not False:
        return result
    else:
        pyotherside.send('status', 'Cores were not found')

def get_jslist(a_list, tag='core_exists', index=0):
    jscript_list = []
    for entry in a_list:
        if '\n' in entry:
            entry = entry.replace('\n', '')
        jscript_dict = {}
        print(entry)
        if index != 0:
            jscript_dict[tag] = entry[index].rstrip(' ').rstrip('\n')
        else:
            jscript_dict[tag] = entry
        jscript_list.append(jscript_dict)
    return jscript_list

def get_shader_path(shader_list):
    path_list = []
    for line in shader_list:
        shader_path = line.split(':')
        path_list.append(shader_path)

        paths = get_jslist(shader_path, tag='shader_path')
    return get_jslist(path_list, tag='shader_path', index=1)

def get_title(get_path=0):
    with open(root_path.change('..') + '/shaders.txt', 'r') as fid:
        lines = fid.readlines()
        if get_path:
            return get_shader_path(lines)
        
        shader_title = get_jslist(lines, tag='shader')
        #shader_path = get_jslist(lines[1], tag='shader_path')
        #pyotherside.send('shader_path', shader_path)
    return shader_title
    
def cores_list():
    if win32_check.check():
        path = root_path.change('retroarch_v1.0')
    else:
        path = '/usr/lib/libretro'
    with open(root_path.path() + '/linux_cores.txt', 'r') as fid:
        cores = fid.readlines()
        clean_cores = get_jslist(cores, tag='available')
    return clean_cores

def get_core_database():
    input_file = root_path.change('..') + '/libretro_database.info'
    with open(input_file, 'r') as infile:
        data = {}
        for line in infile:
            if '>>' in line:
                key = line.replace('>>', '').replace('\n', '')
                data[key] = []
            elif line != '\n':
                value = line.replace('\n', '')
                data[key].append(value)
            else:
                pass
    return data

