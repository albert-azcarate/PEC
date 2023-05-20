import argparse

rom_size = 64 * 1024  # Size of the ROM in bytes

# Parse command-line arguments
parser = argparse.ArgumentParser(description='Initialize an FPGA ROM.')
parser.add_argument('program_name', metavar='program_name', type=str, help='the name of the program')
args = parser.parse_args()

# Append the suffixes to the program name to get the data and code file names
data_file = args.program_name + '.data.DE1.hex'
code_file = args.program_name + '.code.DE1.hex'

# Initialize the ROM string with all zeros
rom = '0' * rom_size

# Read the DATA file and copy its contents to the ROM starting at address 0x4000
with open(data_file, 'r') as f:
    data = f.read().strip()
    rom = rom[:0x4000*2] + data + rom[(0x4000+len(data))*2:]

# Read the CODE file and copy its contents to the ROM starting at address 0x6000
with open(code_file, 'r') as f:
    code = f.read().strip()
    rom = rom[:0x6000*2] + code + rom[(0x6000+len(code))*2:]

# Write the final ROM string to a file
with open(args.program_name +'.hex', 'w') as f:
    f.write(rom)
