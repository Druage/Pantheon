import os
print(os.getcwd())
def write_shader(data):
    with open("retroarch.cgp", "w") as retro_cgp:
        retro_cgp.seek(0)
        retro_cgp.write(data)

def read_shader(selected_shader):
    print()
    print(selected_shader)
    print()
    with open(selected_shader, "r") as shader_file:

        if ".cgp" in selected_shader:
            shader_data = shader_file.readlines()
            first_line = shader_data[0].split()
            num_of_shaders = int(first_line[2].split('"')[1])
            for i in range(0, num_of_shaders-1):
                for line in shader_data:
                    if "filter_linear{:}".format(str(i)) == line.split()[0]:
                        index_for_wrap = shader_data.index(line) + 1
                        shader_data[index_for_wrap] = 'wrap_mode{:} = "clamp_to_border"\n'.format(i)
                        break
            return write_shader("".join(shader_data))                

        else:
            cg_file = ['shaders = "1"\n', 'shader0 = ""', \
                       'wrap_mode0 = "clamp_to_border"\n', 'float_framebuffer0 = "false"\n']
            
            cg_file[1] = 'shader0 = "{:}"\n'.format(selected_shader)
            write_cfg("".join(cfg_file))







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
