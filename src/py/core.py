import os
import root_path

def main():
    input_file = root_path.change('..') + '/database/libretro_database.info'
    with open(input_file, 'r') as infile:
        data = {}
        for line in infile:
            if '>>' in line:
                key = line.replace('>>', '').replace('\n', '')
                data[key] = []
            elif line != '\n':
                value = line.replace('\n', '')
                data[key].append(value)
            else:
                pass
    return data
    
a = main()
for keys, value in a.items():
    print(keys, value)

       
 
