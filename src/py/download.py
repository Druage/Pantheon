import urllib.request as req
import struct
import os
import zipfile
import pyotherside

def download(url, save_file):
    '''Downloads specified file at specific url'''
    u = req.urlopen(url)
    if os.path.exists('retroarch_v1.0'):
        pyotherside.send('status', 'RetroArch is already installed')
        return False
    else:
        with open(save_file, 'wb') as f:
            meta = u.info()
            meta_func = meta.getheaders if hasattr(meta, 'getheaders') else meta.get_all
            meta_length = meta_func("Content-Length") #File size is stored here
            file_size = None
            if meta_length:
                file_size = int(meta_length[0])

            file_size_dl = 0
            block_sz = 8192                     # requests.urlopen uses this block size
            pyotherside.send('status', 'Downloading RetroArch')
            while True:
                buff = u.read(block_sz)
                if not buff:
                    break

                file_size_dl += len(buff)
                f.write(buff)
                status = ""
                if file_size:
                    status += "{0:6.2f}".format(file_size_dl * 100 / file_size)
                status += chr(13)
                pyotherside.send('download', status)
            print('RetroArch was successfully downloaded')
            return True


def unzip(zip_file, out_folder):
    '''Unzips RetroArch zip package'''
    with zipfile.ZipFile(zip_file, 'r') as z:
        pyotherside.send('status', 'Extracting...')
        z.extractall(out_folder)

def make_directory(directory, save_file):
    '''Creats a new directory for RetroArch if one is not already present'''
    if not os.path.exists(directory):
        os.makedirs(directory)
    status = unzip(save_file, directory)
    return status        
            
def retroarch():
    '''Starts the Retroarch download process'''
    retroarch_64bit = '''http://www.libretro.com/wp-content/plugins/cip4-folder-download-widget/cip4-download.php?target=wp-content/releases/Windows/RetroArch-v1.0.0.2-64-bit.zip'''

    retroarch_32bit = '''http://www.libretro.com/wp-content/plugins/cip4-folder-download-widget/cip4-download.php?target=wp-content/releases/Windows/RetroArch-v1.0.0.2-32bit.zip'''
    
    if struct.calcsize('P') * 8 == 64:      #64 bit systems
        url = retroarch_64bit
    elif struct.calcsize('P') * 8 == 32:    #32 bit systems
        url = retroarch_32bit
    else:
        return 'I am sorry but RetroArch does not support your system'
       
    save_zip = 'retroarch.zip'              #Saves download to specified zip file
    if download(url, save_zip) is not False:
        make_directory('retroarch_v1.0', save_zip)
        os.remove(save_zip)
        pyotherside.send('status', 'Downloaded RetroArch')
    else:
        return 'An error has occurred in downloading RetroArch or RetroArch already exists.'
    
def shaders():
    '''Starts the Shader Pack download process'''
    url = '''https://github.com/libretro/common-shaders/archive/master.zip'''
    save_zip = 'shaders.zip'
    if download(url, save_zip) is not False:
        make_directory('shaders', save_zip)
        os.remove(save_zip)
        pyotherside.send('status', 'Downloaded Shader Pack')
    else:
        return 'An error has occurred in downloading shader pack.'
