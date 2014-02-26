
def write(data, textfile='additional_systems.txt'):
    '''Writes list of data in custom core dialog to a text file in parent directory'''
    with open(textfile, 'w') as fid:
        fid.seek(0)
        for i in data:
            fid.write(i + '\n')
    return "Additional Systems Updated"

def log(data):
    with open('log.txt', 'w') as fid:
        for i in data:
            fid.write(i + ' ')
    return 'Wrote to log.txt'

def clear():
    import os
    '''Clears the games.xml file, which resets the library.'''
    os.remove('games.xml')
    return 'Library Cleared'
