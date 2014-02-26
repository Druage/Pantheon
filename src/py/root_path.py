import os

def change(new_dir='images'):
    return os.path.abspath(os.path.join(os.path.dirname( __file__ ), '..', new_dir))

def path():
    return os.path.abspath(os.path.dirname( __file__ ))
