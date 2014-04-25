import json
import constants
import fnmatch
import call_scraper
import os
import zipfile
from operator import itemgetter
import pyotherside

__LIBRARY_OUTPUT_FILE = 'library.json'

def explore_zip(input_file):
    try:
        with zipfile.ZipFile(input_file, 'r') as zfile:
            for item in zfile.namelist():
                item = item.split('.')
                title = item[0]
                ext = '*.' + item[-1]
                if ext in constants.EXTENSIONS:
                    console_and_xml = constants.DATA_SWITCH(item[-1])
                    xml = console_and_xml[0]
                    console = console_and_xml[-1]
                    return (title, ext, console, xml)
                else:
                    raise
    except:
        return None

def save_data(json_data, output_file=__LIBRARY_OUTPUT_FILE):
    '''
    Saves JSON data to a json data file in the database directory.

    Usage:
        json_data = json_object => [{}]
        input_file = 'library.json'
    '''
    output_file = os.path.join(constants.walk_up_to('database'), output_file)
    with open(output_file, 'w') as outfile:
        json.dump(json_data, outfile, ensure_ascii=False, indent=4)


def read_data(input_file=__LIBRARY_OUTPUT_FILE):
    '''
    Simply opens the library.json file and returns a JSON object.

    Usage:
        input_file = 'library.json'
    '''
    try:
        input_file = os.path.join(constants.walk_up_to('database'), input_file)
        with open(input_file, 'r') as infile:
            return json.load(infile)
    except:
        return None

def check_duplicates(json_data, new_data, keyword):
    if not any(new_data.get('path', None) == keyword for new_data in json_data):
        return False
    return True
    
def populate_json(data, counter):
    '''
    Add's data to a JSON model and send that model to QML in order to
    be added to the LibraryModel.

    Usage:
        data = [{}]

            or
    
        data = [{}, {}, {}, ..., {}nth]
    '''
    library_data = read_data(__LIBRARY_OUTPUT_FILE)
    if not library_data:
        library_data = list()
    count = 1
    image = 'file:///' + os.path.join(constants.walk_up_to('images'), 'missing_artwork.png')
    for key, val in data.items():
        title = key.split('.')[0]
        ext = key.split('.')[-1]
        if 'zip' in ext:
            title_and_ext = explore_zip(val)
            if title_and_ext is None:
                continue
            else:
                title = title_and_ext[0]
                ext = title_and_ext[1]
                console = title_and_ext[2]
                xml = title_and_ext[-1]
        else:
            console_and_xml = constants.DATA_SWITCH(ext)
            if not console_and_xml:
                continue
            xml = console_and_xml[0]
            console = console_and_xml[-1]

        new_data = {'title': title,
                    'console': console,
                    'xml': xml,
                    'path': val,
                    'ext': ext,
                    'image': image}
            
        if not check_duplicates(library_data, new_data, val):
            library_data.append(new_data)
        else:
            continue
        pyotherside.send('download', count / counter * 100)
        count += 1
    library_data = sorted(library_data, key=itemgetter('title'))
    save_data(library_data)
    return read_data()

def recursive_scan(directory, filter_extens=constants.EXTENSIONS, tag=None):
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
        return read_data()
        pyotherside.send('status', '0 files were found')
    else:
        if tag != None:
            return tag_list
        return populate_json(matches, len(matches))

#recursive_scan("D:\\ROMS\\Emulation")
