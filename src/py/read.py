import os
import sys
import zlib
import zipfile
import root_path
import xml.etree.ElementTree as ET

def compare_crc(code, xml_file='Nintendo 64.xml'):
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
    
'''def win32_tags(fileName):
    if ((".sfc" in fileName) or (".smc" in fileName) or (".n64" in fileName)
        or (".z64" in fileName) or (".gba" in fileName) or (".cue" in fileName)
        or (".nes" in fileName) or (".gb" in fileName) or (".gbc" in fileName)):
        
        return True
    
    else:
        raise False'''
                
def crc(fileName, zip_obj=None):
    '''Takes in a file and returns the crc code as an int'''
    prev = 0
    if zip_obj:
        for eachLine in zip_obj.open(fileName,'r'):
            prev = zlib.crc32(eachLine, prev)
    else:
        for eachLine in open(fileName,'rb'):
            prev = zlib.crc32(eachLine, prev)
    return '%X'%(prev & 0xFFFFFFFF)

def zip_explore(fileName):
    ''' Takes in a file and call the crc() function. It will return
        the result of the crc() function as an int.
    '''
    with zipfile.ZipFile(fileName, 'r') as zfile:
        for item in zfile.namelist():
            return crc(item, zfile)

def file_type(fileName):
    
    try:
        if 'zip' in fileName:
            code = zip_explore(fileName)
        else:
            code = crc(fileName)
            print(code)
        return compare_crc(code)
    
    except:
        print('Error: with ', fileName)
        return None
