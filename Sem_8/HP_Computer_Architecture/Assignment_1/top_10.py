from pathlib import Path

output_root = Path("output")

def read_cpi(filepath_to_stats):
    with open(filepath_to_stats, 'r') as f:
        for i, line in enumerate(f):
            if (i==17):
                data = line.split()
                if data[0] != "system.cpu.cpi":
                    print(filepath_to_stats)
                    exit(0)
                return data[1]


dir_cpi_values = []
subdirectories = [x for x in output_root.iterdir() if x.is_dir()]
total = len(subdirectories)
i = 0
for directory in subdirectories:
    dir_cpi_values.append([str(directory), read_cpi(str(directory) + "/stats.txt")])
    i += 1
    print(f'traversed {i} of {total}', end="\r")
dir_cpi_values = sorted(dir_cpi_values, key=lambda x: x[1])


for i in range(10):
    print(dir_cpi_values[i])