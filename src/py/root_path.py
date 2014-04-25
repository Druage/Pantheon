import os

def change(new_dir='images'):
    return os.path.abspath(os.path.join(os.path.dirname( __file__ ), '..', new_dir))

def path():
    return os.path.abspath(os.path.dirname( __file__ ))

class Path:
    import os
    
    def __init__(self, path):
        self.path = path

    def set_path(self, new_path):
        self.path = new_path

    def walkup():
        new_path = os.path.join(self.path, '..')
        return new_path

    def file(self):
        if os.path.isfile(self.path):
            if '\\' in self.path:
                file = self.path.split('\\')[-1]
            if '/' in file:
                file = file.split('/')[-1]
            return file
            
        else:
            raise Exception("Cannot perform operation on folders")

