import os
import sys
import zlib
import zipfile
import root_path
import constants
#import scraper_calls
import xml.etree.ElementTree as ET

def rom_tags(sys_element, fileName):
    xml_file = None
    if (('.sfc' in  fileName) or ('.smc' in fileName)
        or ('.fig' in fileName) or ('.gd3' in fileName)
        or ('.gd7' in fileName) or ('.dx2' in fileName)
        or ('.bsx' in fileName) or ('.swc' in fileName)):
            
        xml_file = 'Super Nintendo Entertainment System.xml'
        sys_element.text = 'Super Nintendo'
        
    elif (('.n64' in fileName) or ('.z64' in fileName)
          or ('.v64' in fileName)):
        
        xml_file = 'Nintendo 64.xml'
        sys_element.text = 'Nintendo 64'

    elif '.gba' in fileName:
        xml_file = 'Nintendo Game Boy Advance.xml'
        sys_element.text = "Game Boy Advance"
    
    elif '.gb' in fileName:
        xml_file = 'Nintendo Game Boy.xml'
        sys_element.text = "Game Boy"
                
    elif '.cue' in fileName:
        xml_file = 'Sony PlayStation.xml'
        sys_element.text = "Sony PlayStation"
        
    elif (('.nes' in fileName) or ('.unif' in fileName)
          or ('.fds' in fileName)):
        
        xml_file = 'Nintendo Entertainment System.xml'
        sys_element.text = "Nintendo Entertainment System"
        
    elif '.gbc' in fileName:
        xml_file = 'Nintendo Game Boy Color.xml'
        sys_element.text = 'Game Boy'
        
    else:
        xml_file = 'Unknown'
        sys_element.text = 'Unknown'
        
    return xml_file

def find_title(code, xml_file):
    ''' Takes in crc code, and finds matching crc code in .xml list and
        returns corresponding the game title as a string.
    '''
    filename = root_path.change('database/hyperlist') + '/' + xml_file
    tree = ET.parse(filename)
    root = tree.getroot()
    for game in root.iter('game'):
        for crc in game.iter('crc'):
            if str(code) == crc.text:
                return game.attrib['name']
    else:
        return None
                
def crc32_check(file_name, zip_obj=None):
    '''Takes in a file and returns the crc code as an int'''
    if zip_obj:
        return "%X"%(zlib.crc32(zip_obj.open(file_name,"r").read()) & 0xFFFFFFFF)
    else:
        return "%X"%(zlib.crc32(open(file_name,"rb").read()) & 0xFFFFFFFF)
    
def add_single_folder(path):
    '''Adds contents of single folder into the games.xml database'''
    file_dict = {}
    try:
        for file in os.listdir(path):
            if file.split('.')[-1] in constants.extensions():
                file_dict[file] = os.path.join(path, file)
        return file_dict;
    except FileNotFoundError:
        print('{:} is not a valid folder.'.format(path))

def zip_explore(fileName):
    ''' Takes in a file and calls the crc() function. It will return
        the result of the crc() function as an int.
    '''
    with zipfile.ZipFile(fileName, 'r') as zfile:
        for item in zfile.namelist():
            return [item, crc32_check(item, zfile)]

def get_file_name(file_name):
    ''' Takes in a file and calls zip_explore() and crc() and returns
        the game title as a string.
    '''
    try:
        if 'zip' in file_name:
            name = zip_explore(file_name)[0]
            code = zip_explore(file_name)[1]
            xml_file = rom_tags(sys_element, name)
        else:
            code = crc32_check(file_name)
        file_data = constants.data_switch(file_name.split('.')[-1])
        name = file_title(code, file_data[0])
        if name:
            file_data.append(name)
        else:
            file_data.append(file_name)
        print(file_data)
        #xml_file = rom_tags(sys_element, file_name)
        #return compare_crc(code, xml_file)
    
    except FileNotFoundError:
        print('{:} was not found '.format(file_name))
        return None
        
def cores_quick(path):
    try:
        raw_files = os.listdir(path)
        if len(raw_files) == 0:
            raise Exception
    except:
        return 'undefined'
        
    core_list = []
    for line in raw_files:
        i = line.lower()
        cores = {}
        cores['core'] = line
        core_list.append(cores)

    if len(core_list) == 0:
        return 'undefined'
        
    else:
        return core_list

def retroarch_folder(exe_path):
    retro_path = exe_path.split("retroarch.exe")[0]
    path_dict = {}
    for root, dirnames, filenames in os.walk(retro_path):
        for folder in dirnames:
            path_dict[folder] = retro_path + folder
        break
    path_dict["cfg_file"] = retro_path + 'retroarch.cfg'
    return path_dict

#Used for my own testing purposes

#a = retroarch_folder("C:\\Users\\robert\\Desktop\\retroarch\\retroarch.exe")
#for keys, vals in a.items():
    #print(keys, vals)
        
#cores_quick('C:/Users/robert/Desktop/retroarch/libretro')

