import xml.etree.ElementTree as ET
import scraper_calls
import zlib
import constants
import os
import zipfile
import pyotherside

def data_switch(key):
    return {
        #Super Nintendo Entertainment System
        'sfc': ({'SYSTEM': 'Super Nintendo'},
                {'XML': 'Super Nintendo Entertainment System.xml'}),
        'smc': ({'SYSTEM': 'Super Nintendo'},
                {'XML': 'Super Nintendo Entertainment System.xml'}),
        'fig': ({'SYSTEM': 'Super Nintendo'},
                {'XML': 'Super Nintendo Entertainment System.xml'}),
        'gd3': ({'SYSTEM': 'Super Nintendo'},
                {'XML': 'Super Nintendo Entertainment System.xml'}),
        'gd7': ({'SYSTEM': 'Super Nintendo'},
                {'XML': 'Super Nintendo Entertainment System.xml'}),
        'dx2': ({'SYSTEM': 'Super Nintendo'},
                {'XML': 'Super Nintendo Entertainment System.xml'}),
        'bsx': ({'SYSTEM': 'Super Nintendo'},
                {'XML': 'Super Nintendo Entertainment System.xml'}),
        'swc': ({'SYSTEM': 'Super Nintendo'},
                {'XML': 'Super Nintendo Entertainment System.xml'}),

        #Nintendo Entertainment System
        'nes': ({'SYSTEM': 'Nintendo Entertainment System'},
                {'XML': 'Super Nintendo Entertainment System.xml'}),
        'fds': ({'SYSTEM': 'Nintendo Entertainment System'},
                {'XML': 'Nintendo Entertainment System.xml'}),
        'unif': ({'SYSTEM': 'Nintendo Entertainment System'},
                {'XML': 'Nintendo Entertainment System.xml'}),

        #Nintendo 64
        'n64': ({'SYSTEM': 'Nintendo 64'},
                {'XML': 'Nintendo 64.xml'}),
        'z64': ({'SYSTEM': 'Nintendo 64'},
                {'XML': 'Nintendo 64.xml'}),
        'v64': ({'SYSTEM': 'Nintendo 64'},
                {'XML': 'Nintendo 64.xml'}),

        #Game Boy
        'gb': ({'SYSTEM': 'Game Boy'},
                {'XML': 'Nintendo Game Boy.xml'}),

        #Game Boy Color
        'gbc': ({'SYSTEM': 'Game Boy Color'},
                {'XML': 'Nintendo Game Boy Color.xml'}),
        
        #Game Boy Advance
        'gba': ({'SYSTEM': 'Game Boy Advance'},
                {'XML': 'Nintendo Game Boy Advance.xml'}),

        #Sony PlayStation
        'cue': ({'SYSTEM': 'Sony PlayStation'},
                {'XML': 'Sony PlayStation.xml'}),
        
        }.get(key, None)

def check_validity(code, xml_file):
    ''' Takes in crc code, and finds matching crc code in .xml list and
        returns corresponding the game title as a string.
    '''
    filename = os.path.join(constants.walk_up_to('database'), 'hyperlist', xml_file)
    tree = ET.parse(filename)
    root = tree.getroot()
    for game in root.iter('game'):
        for crc in game.iter('crc'):
            if str(code) == crc.text:
                return game.attrib['name']
    else:
        return None
    

def add(infile, quick='slow'):
    path_and_ext = infile.split('.')
    extension = path_and_ext[-1].lower()
    #pyotherside.send('ada', quick)
    if quick == 'quick':
        crc = ''
    else:
        if 'zip' in infile:
            with zipfile.ZipFile(infile, 'r') as zfile:
                for item in zfile.namelist():
                    # Only checks the first file in the zip file, for speed things up.
                    # This may produce a false valid tag.
                    extension = item.split('.')[-1]
                    crc = '%X'%(zlib.crc32(zfile.open(item, "r").read()) & 0xFFFFFFFF)
                    break
        else:
            crc = "%X"%(zlib.crc32(open(infile,"rb").read()) & 0xFFFFFFFF)
    path = infile
    console_and_xml = data_switch(extension)
    if not console_and_xml:
        console = 'Unknown'
        title = infile.split('/')[-1].split('\\')[-1].split('.')[0]
    else:
        console = console_and_xml[0]['SYSTEM']
        title = check_validity(crc, console_and_xml[1]['XML'])
        
    if not title:
        valid = ''
        title = infile.split('/')[-1].split('\\')[-1].split('.')[0]
    else:
        valid = 'Yes'
    scraper_data = scraper_calls.get_data(title, console)
    image = scraper_data['images']
    genre = scraper_data['genre']
    publisher = scraper_data['publisher']
    description = scraper_data['description']
    return {'TITLE': title,
            'PATH': path,
            'CONSOLE': console,
            'VALID': valid,
            'EXTS': extension,
            'IMAGE': image,
            'GENRE': genre,
            'DESC': description,
            'PUB': publisher,
            'CRC32': crc}
