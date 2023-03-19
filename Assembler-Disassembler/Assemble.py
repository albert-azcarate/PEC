#!/home/albert/mambaforge/bin/python
import sys
INSTRUCTIONS = {
    "AND":   {"ALU": 0, "f": 0},
    "OR":    {"ALU": 0, "f": 1},
    "XOR":   {"ALU": 0, "f": 2},
    "NOT":   {"ALU": 0, "f": 3},
    "ADD":   {"ALU": 0, "f": 4},
    "SUB":   {"ALU": 0, "f": 5},
    "SHA":   {"ALU": 0, "f": 6},
    "SHL":   {"ALU": 0, "f": 7},
    "CMPLT": {"COMP": 1, "f": 0},
    "CMPLE": {"COMP": 1, "f": 1},
    "CMPEQ": {"COMP": 1, "f": 2},
    "CMPLTU":{"COMP": 1, "f": 3},
    "CMPLEU":{"COMP": 1, "f": 4},
    "MUL":   {"MULDIV": 8, "f": 0},
    "MULH":  {"MULDIV": 8, "f": 1},
    "MULHU": {"MULDIV": 8, "f": 2},
    "DIV":   {"MULDIV": 8, "f": 3},
    "DIVU":  {"MULDIV": 8, "f": 4},
    "ADDI":  {"ADDI": 2},
    "LD":    {"LD": 3},
    "ST":    {"ST": 4},
    "MOVI":  {"MOVE": 5, "m": 0},
    "MOVHI": {"MOVE": 5, "m": 1},
    "LDB":   {"LDB": 13},
    "STB":   {"STB": 14},
    "HALT/NAI":  {"SPECIAL": 15, "f": 0},
    "HALT":  {"SPECIAL": 15, "f": 0},
}

def sign_extend(value, length):
    # Convert value to 2's complement if necessary
    if value & (1 << (length - 1)):
        value = value - (1 << length)
    return value

def assemble(instruction):
    opcode = 0
    rd = 0
    ra = 0
    rb9 = 0
    rb0 = 0
    rt = 0
    f = 0
    n6 = 0
    n8 = 0
    m = 0
    
    operands, mnemonic = instruction.split(" ")[1:], instruction.split(" ")[0]
    operands = [elem.replace('r', '').replace(',', '') for elem in operands]
    mnemonic = mnemonic.upper()

    for i, elem in enumerate(operands):
        if "(" in elem:             # Convert N(rX) into ['N', 'rX']
            mem_acces = elem.split("(")
            mem_acces = [mem_elem.replace('(', '').replace(')', '') for mem_elem in mem_acces]
            operands[i:i+1] = mem_acces
        if elem.startswith("0x"):   #accept 0xNN as parameters
            operands[i] = int(elem[2:], 16)
    
    #print(mnemonic)
    opcode = INSTRUCTIONS[mnemonic][list(INSTRUCTIONS[mnemonic].keys())[0]]
    #print(opcode)
    hex_str=""
    combined_bits=65535
    #print(operands)
    #print(instruction)
    if opcode in (5,):   # 1-REG        oooo ddd e nnnnnnnn MOVI, MOVHI, (BZ, BNZ) 
        rd = int(operands[0]) 
        n8 = sign_extend(int(operands[1]),8)
        m = INSTRUCTIONS[mnemonic][list(INSTRUCTIONS[mnemonic].keys())[1]]
            
        combined_bits = opcode << 12 | (rd << 9) | (m << 8) | (n8 & 0b111111111) 
            
    elif opcode in (14, 13, 3, 4, 2,): # 2-REG-MEM    oooo ddd aaaa nnnnnn STs, LDs, ADDI, (JUMPS)
        if opcode in (14,4,):    #STORES
            rb9 = int(operands[2]) 
            n = sign_extend(int(operands[0]),6)
            ra = int(operands[1])
        elif opcode in (3,13,):  #LOADS
            rb9 = int(operands[0]) 
            n = sign_extend(int(operands[1]),6)
            ra = int(operands[2])
        elif opcode in (2,):    #ADDI
            rb9 = int(operands[0]) 
            n = sign_extend(int(operands[2]),6)
            ra = int(operands[1])
            
        if opcode in (4,3,):    #If LD or ST /2 immd
            n = n >> 1
        
        combined_bits = opcode << 12 | (rb9 << 9) | (ra << 6) | (n & 0b111111) 
        
    elif opcode in (18,): # 2-REG        oooo ddd aaaa e nnnnn
        pass
    elif opcode in (0,1,8,): # 3-REG        oooo ddd aaa ffff bbb ALU, COMP, MULDIV
        rd = int(operands[0]) 
        ra = int(operands[1])
        if(len(operands) > 2):
            rb0 = int(operands[2])
        f = INSTRUCTIONS[mnemonic][list(INSTRUCTIONS[mnemonic].keys())[1]]
        combined_bits = opcode << 12 | (rd << 9) | (ra << 6) | (f << 3) | rb0

    hex_str = hex(combined_bits)[2:].zfill(4).upper()
    return hex_str


def main():
    # Read the input and output filenames from the terminal
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    assembled_instructions = []
    with open(input_file, 'r') as f:
        instructions = f.readlines()
        for instruction in instructions:
            assembled_instruction = assemble(instruction.strip())
            assembled_instructions.append(assembled_instruction)
            print(assembled_instruction)

    with open(output_file, 'w') as f:
        f.write('\n'.join(assembled_instructions))
        f.write('\n')
        
if __name__ == "__main__":
    main()
