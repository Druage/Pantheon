import xml.etree.ElementTree as ET
from xml.etree.ElementTree import Element
from xml.etree.ElementTree import tostring
import sys
import os
import fnmatch
import win32_check
import root_path
import pyotherside
import constants
import scan
import add_data

PLATFORM = sys.platform #Check what operating system this is running on for the cores.

def check_core(value):
    tag = 'unsupported'
    if ('.dll' in value) or ('.so' in value):
        print(value)
        if (('nestopia' in value) or
            ('fceumm' in value) or
            ('bnes' in value) or
            ('quicknes' in value)):
            tag = 'NES'
        
        elif ('bsnes' in value) or ('snes' in value):
            tag = 'SNES'
        elif ('gambatte' in value):
            tag = 'GB'
        elif ('genesis' in value):
            tag = 'GENESIS'
        elif ('mame' in value) or ('fb_alpha' in value):
            tag = 'ARCADE'
        elif ('meteor' in value) or ('vba' in value) or ('gba' in value):
            tag = 'GBA'
        elif ('pcsx' in value) or ('psx' in value):
            tag = 'PSX'
        elif ('mupen' in value):
            tag = 'N64'
        elif ('dinothawr' in value):
            tag = 'INDIE'
        elif ('ffmpeg' in value):
            tag = 'FILM'
        elif ('dos' in value) or ('prboom' in value) or ('quake' in value):
            tag = 'PC'
        elif 'vb' in value:
            tag = 'VB'
        elif 'stella' in value:
            tag = 'ATARI2600'
    return tag

def indent(elem, level=0):              # Good
    '''Makes xml object have proper indentation for readability.'''
    i = '\n' + level * '  '
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + '  '
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
        for elem in elem:
            indent(elem, level+1)
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = i

def insert_artwork(title, new_artwork): # Good
    xml_file = constants.walk_up_to('database') + '/games.xml'
    tree = ET.parse(xml_file)
    root = tree.getroot()
    for game in root.iter('game'):
        for subelement in game:
            if subelement.text == title:
                break
        else:
            continue
        break
    for image in game.iter('image'):
        image.text = new_artwork
    indent(root)
    ammended_data = ET.tostring(root).decode('utf-8')
    with open(xml_file, 'w') as outfile:
        outfile.write(ammended_data)
    

def save_cores(core):                   # Good
    games_xml = root_path.change('..') + '/games.xml'
    tree = ET.parse(games_xml)
    root = tree.getroot()
    for game in root.findall('game'):
        for system in game.findall('system'):
            print(system.text)

def xmlwriter(data, count):             # Good
    games_xml = root_path.change('database') + '/games.xml'
    with open(games_xml, 'w') as tree:
        counter = 0
        tree.write('''<?xml version="1.0"?>\n''')
        root = Element("Library")
        for key, value in sorted(data.items()):
            game = ET.SubElement(root, 'game')
            system = ET.SubElement(game, 'system')
            title = ET.SubElement(game, 'title')
            path = ET.SubElement(game, 'path')
            core = ET.SubElement(game, 'core')
            image = ET.SubElement(game, 'image')
            valid = ET.SubElement(game, 'valid')
            description = ET.SubElement(game, 'description')
            publisher = ET.SubElement(game, 'publisher')
            genre = ET.SubElement(game, 'genre')

            data = add_data.add(value)

            system.text = data['CONSOLE']
            title.text = data['TITLE']
            path.text = data['PATH']
            image.text = data['IMAGE']
            valid.text = data['VALID']
            description.text = data['DESC']
            publisher.text = data['PUB']
            genre.text = data['GENRE']
            
            counter += 1
            progress = counter / count * 100
            pyotherside.send('download', progress)

        indent(root)
        tree.write(ET.tostring(root).decode('utf-8'))
        pyotherside.send('status', 'Wrote XML')
        
def add_to_xml(data):
    xml_file = os.path.join(constants.walk_up_to('database'), 'games.xml')
    try:
        tree = ET.parse(xml_file)
        root = tree.getroot()
        
        for key, value in data.items():
            game = ET.Element('game')
            system = ET.SubElement(game, 'system')
            title = ET.SubElement(game, 'title')
            path = ET.SubElement(game, 'path')
            core = ET.SubElement(game, 'core')
            image = ET.SubElement(game, 'image')
            valid = ET.SubElement(game, 'valid')
            description = ET.SubElement(game, 'descipton')
            publisher = ET.SubElement(game, 'publisher')
            genre = ET.SubElement(game, 'genre')
            
            data = add_data.add(value)

            system.text = data['CONSOLE']
            title.text = data['TITLE']
            path.text = data['PATH']
            image.text = data['IMAGE']
            valid.text = data['VALID']
            description.text = data['DESC']
            publisher.text = data['PUB']
            genre.text = data['GENRE']

            pyotherside.send('download', len(data))
    
        with open(xml_file, 'w') as infile:
            infile.write(ET.tostring(root).decode('utf-8'))
            
    except FileNotFoundError:
        xmlwriter(data, len(data))

def shader_xml_writer(data_obj):
    xml_path = root_path.change('database') + '/shaders.xml'
    PUNC = '\\/'
    with open(xml_path, 'w') as tree:
        tree.write('''<?xml version="1.0"?>\n''')
        root = Element("Shaders")
        for dicts in data_obj:
            for key, value in dicts.items():
                file = ET.SubElement(root, 'file')
                name = ET.SubElement(file, 'name')
                path = ET.SubElement(file, 'path')

                path.text = value
                new_val = value
                for num, i in enumerate(value[::-1]):
                    if i in PUNC:
                        new_val = value[-num:]
                        break
                
                clean_val = new_val
                name.text = clean_val
                
        indent(root)
        tree.write(ET.tostring(root).decode('utf-8'))

def core_xml_writer(data_obj):
    xml_path = root_path.change('database') + '/cores.xml'
    PUNC = '\\/'
    with open(xml_path, 'w') as tree:
        tree.write('''<?xml version="1.0"?>\n''')
        root = Element("Cores")
        for dicts in data_obj:
            for key, value in dicts.items():
                file = ET.SubElement(root, 'file')
                system_tag = check_core(value)
                system = ET.SubElement(file, system_tag)
                system.text = value
                                
        indent(root)
        tree.write(ET.tostring(root).decode('utf-8'))

def deep_scan(directory, filter_extens=('*.sfc', '*.smc', '*.nes', '*.gba', '*.n64', '*.z64',
        '*.cue', '*.zip'), tag=None):
    matches = {}
    tag_list = []
    for root, dirnames, filenames in os.walk(directory):
        for extension in filter_extens:
            for filename in fnmatch.filter(filenames, extension):
                if tag != None:
                    tag_matches = {}
                    tag_matches[tag] = filename
                    tag_list.append(tag_matches)
                else:
                    matches[filename] = os.path.join(root, filename)
                    
    if len(matches) == 0 and len(tag_list) == 0:
        return 0
        pyotherside.send('status', '0 files were found')
    else:
        if tag != None:
            return tag_list
        xmlwriter(matches, len(matches))

#deep_scan('D:\\ROMS\\Emulation')
