#!/home/albert/mambaforge/bin/python
import sys
OPCODES = {
    0: "ALU",
    1: "COMP",
    2: "ADDI",
    3: "LD",
    4: "ST",
    5: "MOVE",
    6: "BRANCH",
    7: "IO",
    8: "MULDIV",
    9: "INV",
    10: "JUMP",
    11: "INV",
    12: "INV",
    13: "LDB",
    14: "STB",
    15: "SPECIAL"
}

FCODES_ALU = {
    0: "AND",
    1: "OR",
    2: "XOR",
    3: "NOT",
    4: "ADD",
    5: "SUB",
    6: "SHA",
    7: "SHL"
}
FCODES_COMP = {
    0: "CMPLT",
    1: "CMPLE",
    3: "CMPEQ",
    4: "CMPLTU",
    5: "CMPLEU"
}
FCODES_MULDIV = {
    0: "MUL",
    1: "MULH",
    2: "MULHU",
    3: "DIV",
    4: "DIVU"
}
FCODES_MOVE = {
    0: "MOVI",
    1: "MOVHI"
}

def sign_extend(value, length):
    # Convert value to 2's complement if necessary
    if value & (1 << (length - 1)):
        value = value - (1 << length)
    return value


def decode_instruction(instruction):
    opcode = (instruction >> 12) & 0b1111
    rd = (instruction >> 9) & 0b111
    rb9 = (instruction >> 9) & 0b111
    rb0 = instruction & 0b111
    ra = (instruction >> 6) & 0b111
    f = rt = (instruction >> 3) & 0b111
    n6 = sign_extend(instruction & 0b111111, 6)
    n6we = sign_extend((n6 << 1) & 0b111111,6)
    n6w = (n6 << 1) & 0b0111111
    n8e = sign_extend(instruction & 0b11111111, 8)
    n8 = instruction & 0b11111111
    m = (instruction >> 8) & 0b1
    try:
        decoded_instruction = ""
        if opcode in (0, 1, 8): #ALU COMP MULDIV
            if opcode == 0:     #ALU
                if f != 3:
                    decoded_instruction = f"{FCODES_ALU[f]} r{rd}, r{ra}, r{rb0}"
                else:
                    decoded_instruction = f"{FCODES_ALU[f]} r{rd}, r{ra}"
            elif opcode == 1:     #COMP
                decoded_instruction = f"{FCODES_COMP[f]} r{rd}, r{ra}, r{rb0}"
            elif opcode == 8:     #MULDIV
                decoded_instruction = f"{FCODES_MULDIV[f]} r{rd}, r{ra}, r{rb0}"
                
        elif opcode in (2, 3, 4): # ADDI LD ST        
            if opcode == 2:     #ADDI
                decoded_instruction = f"ADDI r{rd}, r{ra}, {n6}\t ;{hex(n6)}"
            elif opcode == 3:   #LD
                decoded_instruction = f"LD r{rd}, {n6we}(r{ra})"
            elif opcode == 4:   #ST
                decoded_instruction = f"ST {n6w}(r{ra}), r{rd}"
                
        elif opcode == 5: # MOVE        
            if m == 0:  # MOVI
                decoded_instruction = f"MOVI r{rd}, {n8e}\t ;{hex(n8e)}"
            elif m == 1:# MOVHI
                decoded_instruction = f"MOVHI r{rd}, {n8}\t ;{hex(n8)}"
                
        elif opcode in (13, 14):
            if opcode == 13:   #LD
                decoded_instruction = f"LDB r{rd}, {n6}(r{ra})"
            elif opcode == 14:     #ST
                decoded_instruction = f"STB {n6}(r{ra}), r{rd}"
        else :
            decoded_instruction = f"halt"
        #elif opcode in (6, 7, 8, 9, 10):
        #    decoded_instruction = f"{OPCODES[opcode]} r{rd}, r{rs}, {imm}"
        #elif opcode in (11, 12):
        #    decoded_instruction = f"{OPCODES[opcode]} r{rs}, r{rt}, {imm}"
        #elif opcode == 14:
        #    decoded_instruction = f"{OPCODES[opcode]} r{rd}, {imm}"
        #elif opcode == 15:
        #    func = instruction & 0b111
        #    decoded_instruction = f"{OPCODES[opcode]} r{rd}, r{rs}, {imm}, {func}"
        #elif opcode == 16:
        #    decoded_instruction = f"{OPCODES[opcode]} r{rd}, {imm}"
        decoded_instruction = decoded_instruction[:decoded_instruction.find(' ')].lower() + decoded_instruction[decoded_instruction.find(' '):]
        return decoded_instruction
    except:
        return "halt"




def main():

    # Read the input and output filenames from the terminal
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    decoded_instructions = []
    with open(input_file, 'r') as f:
        instructions = f.readlines()
        for instruction in instructions:
            # Convert the hexadecimal instruction to a binary string with leading zeros
            binary_string = format(int(instruction.strip(), 16), '016b')
            # Convert the binary string to the actual binary value it represents
            binary_value = int(binary_string, 2)
            # Convert the binary string to the actual binary value it represents
            binary_value = int(binary_string, 2)
            decoded_instruction = decode_instruction(binary_value)
            decoded_instructions.append(decoded_instruction)
            print(decoded_instruction)

    with open(output_file, 'w') as f:
        f.write('\n'.join(decoded_instructions))
    print("\n")
        
if __name__ == "__main__":
    main()