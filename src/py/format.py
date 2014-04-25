import win32_check

def format(line):
    if win32_check.check():
        if 'file:///' in line:
            split_line = line.split()
            new = split_line[2].replace('file:///', '')
            clean_val = '{:}\n'.format(new)
            return " ".join([split_line[0], split_line[1], clean_val])
        else:
            split_line = line.split()
            if len(split_line) == 2:
                return " ".join([split_line[0], split_line[1], '""\n'])
            else:
                return line
            
    else:
        if 'file://' in line:
            split_line = line.split()
            clean_val = '"{:}"\n'.format(split_line[2].rstrip('file://'))
            return " ".join([split_line[0], split_line[1], clean_val])
        else:
            split_line = line.split()
            clean_val = '"{:}"'.format(split_line[2])
            return " ".join([split_line[0], split_line[1], clean_val])