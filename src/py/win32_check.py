import sys

def check():
    if sys.platform == 'win32':
        return True
    else:
        return False
