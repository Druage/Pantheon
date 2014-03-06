def write(data, textfile='additional_systems.txt'):
    '''Writes list of data in custom core dialog to a text file in parent directory'''
    with open(textfile, 'w') as fid:
        fid.seek(0)
        for i in data:
            fid.write(i + '\n')
    return "Additional Systems Updated"

def log(data):
    '''Logs console commands to log.txt'''
    with open('log.txt', 'w') as fid:
        for i in data:
            fid.write(i + ' ')
    return 'Wrote to log.txt'

def reset_library(library):
    '''Clears a file, which resets the library.'''
    import os
    if os.path.isfile(library):
        os.remove(library)
        response = 'Library Cleared'
    else:
        response = 'Library is Empty'
    return response

def purge_folder(folder):
    import shutil
    import os
    if os.path.isdir(folder):
        shutil.rmtree(folder)
        response = '{:} removed'.format(folder)
    else:
        response = '{:} does not exist'.format(folder)
    return response
