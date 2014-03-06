import pyotherside
import urllib.request as req
import struct
import os
import zipfile

retroarch_64bit = '''http://www.libretro.com/wp-content/plugins/cip4-folder-\
download-widget/cip4-download.php?target=wp-content/releases/Windows/RetroAr\
ch-20140105-Win64-MegaPack.zip'''

retroarch_32bit = '''http://www.libretro.com/wp-content/plugins/cip4-folder-\
download-widget/cip4-download.php?target=wp-content/releases/Windows/RetroAr\
ch-20140105-Win32-MegaPack.zip'''

def download(url):
    '''Downloads specified file at specific url'''
    u = req.urlopen(url)
    if os.path.exists('retroarch_v1.0'):
        return False
    else:
        with open('retroarch.zip', 'wb') as f:
            meta = u.info()
            meta_func = meta.getheaders if hasattr(meta, 'getheaders') else meta.get_all
            meta_length = meta_func("Content-Length")
            file_size = None
            if meta_length:
                file_size = int(meta_length[0])

            file_size_dl = 0
            block_sz = 8192

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
        pyotherside.send('download', 'Extracting...')
        z.extractall(out_folder)

def make_directory(directory):
    '''Creats a new directory for RetroArch if one is not already present'''
    if not os.path.exists(directory):
        os.makedirs(directory)
    status = unzip('retroarch.zip', directory)
    return status        
            
def start_process():
    '''Stars the download process'''
    if struct.calcsize('P') * 8 == 64:  #64 bit systems
        url = retroarch_64bit
    elif struct.calcsize('P') * 8 == 32: #32 bit systems
        url = retroarch_32bit
    else:
        return 'I am sorry but RetroArch does not support your system'

    if download(url) is not False:
            make_directory('retroarch_v1.0')
            print('Contents successfully extracted')
            os.remove('retroarch.zip')
    pyotherside.send('download', 'Download RetroArch')
    return 'Finished'

