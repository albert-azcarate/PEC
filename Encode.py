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
}

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

    for i, elem in enumerate(operands):
        if "(" in elem:
            mem_acces = elem.split("(")
            mem_acces = [mem_elem.replace('(', '').replace(')', '') for mem_elem in mem_acces]
            operands[i:i+1] = mem_acces
    
    #print(operands)
    #print(mnemonic)
    opcode = INSTRUCTIONS[mnemonic][list(INSTRUCTIONS[mnemonic].keys())[0]]
    #print(opcode)
    hex_str=""
    combined_bits=65535
    #print(operands)
    #print(instruction)
    if opcode in (5,):   # 1-REG        oooo ddd e nnnnnnnn
        rd = int(operands[0]) 
        n8 = int(operands[1])
        m = INSTRUCTIONS[mnemonic][list(INSTRUCTIONS[mnemonic].keys())[1]]
            
        combined_bits = opcode << 12 | (rd << 9) | (m << 8) | (n8 & 0b111111111) 
            
    elif opcode in (14, 13, 3, 4, 2,): # 2-REG-MEM    oooo ddd aaaa nnnnnn
        if opcode in (14,4,):    #STORES
            rb9 = int(operands[2]) 
            n = int(operands[0])
            ra = int(operands[1])
        elif opcode in (3,13,):  #LOADS
            rb9 = int(operands[0]) 
            n = int(operands[1])
            ra = int(operands[2])
        elif opcode in (2,):    #ADDI
            rb9 = int(operands[0]) 
            n = int(operands[2])
            ra = int(operands[1])
            
        if opcode in (4,3,):    #If LD or ST /2 immd
            n = n >> 1
        
        combined_bits = opcode << 12 | (rb9 << 9) | (ra << 6) | (n & 0b111111) 
        
    elif opcode in (0,): # 2-REG        oooo ddd aaaa e nnnnn
        pass
    elif opcode in (15,0): # 3-REG        oooo ddd aaa ffff bbb
        pass

    hex_str = hex(combined_bits)[2:].zfill(4).upper()
    return hex_str


def main():
    assembled_instructions = []
    with open('Mem_test.txt', 'r') as f:
        instructions = f.readlines()
        for instruction in instructions:
            assembled_instruction = assemble(instruction.strip())
            assembled_instructions.append(assembled_instruction)
            print(assembled_instruction)

    with open('Mem_test.asm', 'w') as f:
        f.write('\n'.join(assembled_instructions))
        f.write('\n')
        
if __name__ == "__main__":
    main()
