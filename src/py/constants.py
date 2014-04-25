import os

def walk_up_to(new_folder):
    return os.path.abspath(os.path.join(os.path.dirname( __file__ ), '..', new_folder))

def shader_config_path():
    return os.path.join(walk_up_to('database'), 'shader-config')

def shader_cgp_path():
    return os.path.join(shader_config_path(), 'retroarch.cgp')

def shaders_path():
    return walk_up_to('common-shaders-master')

def custom_emulators_path():
    return os.path.join(walk_up_to('database'), 'configs', 'custom_emulators')
    
def root_path():
    return walk_up_to('..')

EXTENSIONS = ('*.nes', '*.sfc', '*.smc',
              '*.fig', '*.gd3', '*.cue',
              '*.gd7', '*.dx2', '*.bsx',
              '*.swc','*.n64', '*.z64',
              '*.v64', '*.gba', '*.gb',
              '*.gbc', '*.cue', '*.fds',
              '*.gen', '*.zip')


def DATA_SWITCH(key):
    return {
        #Super Nintendo Entertainment System
        'sfc': ['Super Nintendo Entertainment System.xml',
                'Super Nintendo'],
        'smc': ['Super Nintendo Entertainment System.xml',
                'Super Nintendo'],
        'fig': ['Super Nintendo Entertainment System.xml',
                'Super Nintendo'],
        'gd3': ['Super Nintendo Entertainment System.xml',
                'Super Nintendo'],
        'gd7': ['Super Nintendo Entertainment System.xml',
                'Super Nintendo'],
        'dx2': ['Super Nintendo Entertainment System.xml',
                'Super Nintendo'],
        'bsx': ['Super Nintendo Entertainment System.xml',
                'Super Nintendo'],
        'swc': ['Super Nintendo Entertainment System.xml',
                'Super Nintendo'],

        #Nintendo Entertainment System
        'nes': ['Nintendo Entertainment System.xml',
                'Nintendo Entertainment System'],
        'fds': ['Nintendo Entertainment System.xml',
                'Nintendo Entertainment System'],
        'unif': ['Nintendo Entertainment System.xml',
                'Nintendo Entertainment System'],

        #Nintendo 64
        'n64': ['Nintendo 64.xml', 'Nintendo 64'],
        'z64': ['Nintendo 64.xml', 'Nintendo 64'],
        'v64': ['Nintendo 64.xml', 'Nintendo 64'],

        #Game Boy
        'gb': ['Nintendo Game Boy Color.xml',
                 'Game Boy'],

        #Game Boy Color
        'gbc': ['Nintendo Game Boy Color.xml',
                 'Game Boy'],

        #Sony PlayStation
        'cue': ['Sony PlayStation.xml',
                'Sony PlayStation'],
        'zip': ['ada', 'zippy']
        }.get(key, None)
