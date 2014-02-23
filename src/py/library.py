import os
import root_path

def clear():
    '''Clears the games.xml file, which resets the library.'''
    os.remove(root_path.img_path('..') + '/games.xml')
    return 'Library Cleared'
