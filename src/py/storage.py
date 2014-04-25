import pyotherside
import root_path
import win32_check
import os
import shutil
import fileinput
import constants

if win32_check.check(): #Check for operating system
    cfg_file = root_path.change('..') + '/win32_retroarch.cfg'        
else:
    cfg_file = os.path.expanduser('~') + '/linux_retroarch.cfg'
        
def write(data, textfile='additional_systems.txt'):
    '''Writes list of data in CustomCoreDialog.qml, to a text file in parent directory'''
    with open(textfile, 'w') as fid:
        fid.seek(0)
        for i in data:
            fid.write(i + '\n')
    return "Additional Systems Updated"

def log(data):
    '''Logs console commands to log.txt'''
    with open('log.txt', 'w') as ofile:
        ofile.seek(0)
        ofile.write(data)
    return 'Wrote to log.txt'

def reset_library():
    '''Clears a file, which in this case is used to reset the library.'''
    library_file = os.path.join(constants.walk_up_to('database'), 'library.json')
    if os.path.isfile(library_file):
        os.remove(library_file)
        response = 'Library Cleared'
    else:
        response = 'Library is Empty'
    pyotherside.send('status', response)
    return response

def purge_folder(folder):
    '''Removes specific folder, in this case retroarch_v1.0 for win32 users'''
    if os.path.isdir(folder):
        shutil.rmtree(folder)
        response = '{:} removed'.format(folder)
    else:
        response = '{:} does not exist'.format(folder)
    pyotherside.send('status', response)
    return response

def write_cfg(data_list, input_file):
    ''''''
    with open(input_file, 'w') as ofile:
        ofile.writelines(data_list)

def create_missing_entry(search, added_entry, input_file):
    try:
        with open(input_file, 'a') as ifile:
            ifile.writelines('{:} = "{:}"\n'.format(search, added_entry))
    except:
        return "File was errored"
        
def read_cfg(specific_line, new_data, input_file):
    '''Find a specific_line in .cfg file. Returns list containing .cfg data.
    Raises NameError if specific_line could not be found in file.
    '''
    try:
        with open(input_file, 'r') as ifile:
            cfg_list = []
            occurance = 0
            for line_num, line_data in enumerate(ifile):
            
                if win32_check.check():
                    if "file:///" in new_data:
                        new_data = new_data.replace('file:///', '')
                else:
                    if "file://" in line_data:
                        line_data = line_data.replace('file://', '')
                        
                if specific_line in line_data.split():
                    occurance += 1
                    line_data = '{:} = "{:}"\n'.format(specific_line, new_data)
                    print('{:} was added'.format(line_data))
                cfg_list.append(line_data)
                
            if occurance == 0:
                cfg_list.append('{:} = "{:}"\n'.format(specific_line, new_data))
                
            return cfg_list
            
    except:
        raise FileNotFoundError('{:} could not be found'.format(cfg_file))

def ammend_cfg_data(line, data, input_f):
    '''Reads and writes data to cfg file'''
    cfg = root_path.change('database') + '/' + input_f
    a = read_cfg(line, data, cfg)
    write_cfg(a, input_f)
           
def cfg_to_json(input_file):
    if ((input_file == 'win32_retroarch.cfg') or 
            (input_file == 'frontend.cfg') or 
            (input_file == '.retroarch-core-options.cfg')):
       
        input_file = os.path.join(constants.walk_up_to('database'), input_file)
    with open(input_file, 'r') as infile:
        data_dict = {}
        for line in infile:
            line = line.split(' = ')
            key = line[0]
            value = line[-1][1:-2]
            data_dict[key] = value
        return data_dict

def json_to_cfg(output_file, json_data):
    try:
        if output_file == 'win32_retroarch.cfg':
            output_file = os.path.join(constants.walk_up_to('database'), output_file)
        elif output_file == 'frontend.cfg':
            output_file = os.path.join(constants.walk_up_to('database'), output_file)
        elif output_file == '.retroarch-core-options.cfg':
            output_file = os.path.join(constants.walk_up_to('database'), output_file)
        else:
            output_file = os.path.join(constants.walk_up_to('database'), output_file)
        pyotherside.send('ada', output_file)
        with open(output_file, 'w') as outfile:
            for key in sorted(json_data):
                outfile.write('{:} = "{:}"\n'.format(key, json_data[key]))
        return True
    except:
        return False
     
def import_custom_emulator(cfg_file):
    input_file = os.path.join(constants.custom_emulators_path(), cfg_file)
    return cfg_to_json(input_file)

def save_custom_emulators(cfg_outfile, data):
    output_file = os.path.join(constants.custom_emulators_path(), cfg_outfile)
    return json_to_cfg(output_file, data)
