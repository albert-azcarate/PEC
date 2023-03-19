#!/home/albert/mambaforge/bin/python
with open("All_instructions.asm", "w") as f:
    for i in range(0, 0xF001):
        hex_string = "{:04X}".format(i)
        f.write(hex_string + "\n")
        if hex_string == "F000":
            break
