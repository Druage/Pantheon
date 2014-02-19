import os

def img_path():
    return os.path.abspath(os.path.join(os.path.dirname( __file__ ), '..', 'images'))

