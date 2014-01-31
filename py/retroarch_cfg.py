import os
print(os.getcwd())

def write_cfg(ammended_data):
    with open("retroarch_v1.0\\shaders\\retroarch.cgp", "w") as ofile:
        ofile.seek(0)
        ofile.write('shaders = "1"\n')
        ofile.write(ammended_data)
        ofile.write('wrap_mode0 = "clamp_to_border"\n')
        ofile.write('float_framebuffer0 = "false"\n')
        
def add_data(specific_line, new_data):
    with open("retroarch_v1.0\\retroarch.cfg", "r") as ofile:
        for line in ofile:
            if specific_line == line.split()[0]:
                data = 'shader0 = {:}\n'.format(new_data)
                return data
    print("never found")
