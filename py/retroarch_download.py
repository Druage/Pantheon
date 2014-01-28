import urllib.request
import struct
import os
import zipfile

def download(url):
    if os.path.exists("retroarch_v1.0"):
        return False
    else:
        print("Please be patient while RetroArch Downloads")
        urllib.request.urlretrieve(url, "retroarch_v1.0.zip")
        print("RetroArch was successfully downloaded")
        return True


def unzip(zip_file, out_folder):
    with zipfile.ZipFile(zip_file, "r") as z:
        print("Extracting to", out_folder)
        z.extractall(out_folder)

def make_directory(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)
    status = unzip("retroarch_v1.0.zip", directory)
    return status        
            
retroarch_64bit = """http://www.libretro.com/wp-content/plugins/cip4-folder-download-widget/cip4-download.php?target=wp-content/releases/Windows/RetroArch-20140105-Win64-MegaPack.zip"""
retroarch_32bit = """http://www.libretro.com/wp-content/plugins/cip4-folder-download-widget/cip4-download.php?target=wp-content/releases/Windows/RetroArch-20140105-Win32-MegaPack.zip"""

def start_process():
    choice = input("This program will now download Retroarch for Windows. Continue? (y,n) ")
    if choice.lower() == "y":
        if struct.calcsize("P") * 8 == 64:
            download(retroarch_64bit)
            make_directory("retroarch_v1.0")
            print("Contents successfully extracted")
            os.remove("retroarch_v1.0.zip")
    
        elif struct.calcsize("P") * 8 == 32:
            download(retroarch_32bit)
            make_directory("retroarch_v1.0")
            print("Contents successfully extracted")
    else:
        print("Then you must go into game_launcher.py and change the retroarch.exe directory")
