import random

class ALU:
    def __init__(self):
        pass
    # Define the ALU operations
    def add(a, b):
        return a + b

    def sub(a, b):
        return a - b

    def and_(a, b):
        return a & b

    def or_(a, b):
        return a | b

    def xor(a, b):
        return a ^ b

    def not_(a):
        return ~a & 0xFFFF

    def sll(a, b):
        return a << b

    def srl(a, b):
        return a >> b

    def sra(a, b):
        if a & 0x8000:
            a = (a >> b) | (0xFFFF << (16-b))
        else:
            a = a >> b
        return a

# Define the SISA register bank
#class RegBank:
#    def __init__(self):
#        self.regs = [0] * 8
#
#    def read(self, reg):
#        return self.regs[reg]
#
#    def write(self, reg, value):
#        self.regs[reg] = value

# Define the SISA simulator
class SISA:
    def __init__(self):
        self.registers = [0] * 8
        self.memory = [0] * 65536
        self.pc = 0
        self.alu = ALU()

     def add(self, dest, src1, src2):
        self.registers[dest] = self.alu.add(self.registers[src1], self.registers[src2])

    def addi(self, dest, src, imm):
        self.registers[dest] = self.alu.add(self.registers[src], imm)

    def sub(self, dest, src1, src2):
        self.registers[dest] = self.alu.sub(self.registers[src1], self.registers[src2])

    def and_(self, dest, src1, src2):
        self.registers[dest] = self.alu.and_(self.registers[src1], self.registers[src2])

    def or_(self, dest, src1, src2):
        self.registers[dest] = self.alu.or_(self.registers[src1], self.registers[src2])

    def xor(self, dest, src1, src2):
        self.registers[dest] = self.alu.xor(self.registers[src1], self.registers[src2])

    def not_(self, dest, src):
        self.registers[dest] = self.alu.not_(self.registers[src])

    def sll(self, dest, src, imm):
        self.registers[dest] = self.alu.sll(self.registers[src], imm)

    def srl(self, dest, src, imm):
        self.registers[dest] = self.alu.srl(self.registers[src], imm)

    def sra(self, dest, src, imm):
        self.registers[dest] = self.alu.sra(self.registers[src], imm)

    def slt(self, dest, src1, src2):
        result = self.alu.compare(self.registers[src1], self.registers[src2])
        if result == -1:
            self.registers[dest] = 1
        else:
            self.registers[dest] = 0

    def beq(self, src1, src2, imm):
        if self.registers[src1] == self.registers[src2]:
            self.pc += imm

    def bne(self, src1, src2, imm):
        if self.registers[src1] != self.registers[src2]:
            self.pc += imm

    def jal(self, dest):
        self.registers[7] = self.pc
        self.pc = dest

    def lw(self, dest, src, imm):
        address = self.registers[src] + imm
        self.registers[dest] = self.memory[address]

    def sw(self, src, dest, imm):
        address = self.registers[dest] + imm
        self.memory[address] = self.registers[src]

    def execute(self, instruction):
        opcode = (instruction >> 13) & 0b111
        if opcode == 0:
            # ADD
            dest = (instruction >> 10) & 0b111
            src1 = (instruction >> 7) & 0b111
            src2 = instruction & 0b111
            self.add(dest, src1, src2)
        elif opcode == 1:
            # ADDI
            dest = (instruction >> 10) & 0b111
             src = (instruction >> 7) & 0b111
            imm = instruction & 0b1111111
            self.addi(dest, src, imm)
        elif opcode == 2:
            # SUB
            dest = (instruction >> 10) & 0b111
            src1 = (instruction >> 7) & 0b111
            src2 = instruction & 0b111
            self.sub(dest, src1, src2)
        elif opcode == 3:
            # AND
            dest = (instruction >> 10) & 0b111
            src1 = (instruction >> 7) & 0b111
            src2 = instruction & 0b111
            self.and_(dest, src1, src2)
        elif opcode == 4:
            # OR
            dest = (instruction >> 10) & 0b111
            src1 = (instruction >> 7) & 0b111
            src2 = instruction & 0b111
            self.or_(dest, src1, src2)
        elif opcode == 5:
            # XOR
            dest = (instruction >> 10) & 0b111
            src1 = (instruction >> 7) & 0b111
            src2 = instruction & 0b111
            self.xor(dest, src1, src2)
        elif opcode == 6:
            # NOT
            dest = (instruction >> 10) & 0b111
            src = (instruction >> 7) & 0b111
            self.not_(dest, src)
        elif opcode == 7:
            # SLL
            dest = (instruction >> 10) & 0b111
            src = (instruction >> 7) & 0b111
            imm = instruction & 0b111
            self.sll(dest, src, imm)
        elif opcode == 8:
            # SRL
            dest = (instruction >> 10) & 0b111
            src = (instruction >> 7) & 0b111
            imm = instruction & 0b111
            self.srl(dest, src, imm)
        elif opcode == 9:
            # SRA
            dest = (instruction >> 10) & 0b111
            src = (instruction >> 7) & 0b111
            imm = instruction & 0b111
            self.sra(dest, src, imm)
        elif opcode == 10:
            # SLT
            dest = (instruction >> 10) & 0b111
            src1 = (instruction >> 7) & 0b111
            src2 = instruction & 0b111
            self.slt(dest, src1, src2)
        elif opcode == 11:
            # BEQ
            src1 = (instruction >> 10) & 0b111
            src2 = (instruction >> 7) & 0b111
            imm = instruction & 0b1111
            self.beq(src1, src2, imm)
        elif opcode == 12:
            # BNE
            src1 = (instruction >> 10) & 0b111
            src2 = (instruction >> 7) & 0b111
            imm = instruction & 0b1111
            self.bne(src1, src2, imm)
        elif opcode == 13:
            # JAL
            dest = instruction & 0b111111111111
            self.jal(dest)
        elif opcode == 14:
            # LD
            dest = (instruction >> 10) & 0b111
            offset = instruction & 0b1111111111
            src = (instruction >> 7) & 0b111
            self.ld(dest, src, offset)
        elif opcode == 15:
            # ST
            src1 = (instruction >> 10) & 0b111
            offset = instruction & 0b1111111111
            src2 = (instruction >> 7) & 0b111
            self.st(src1, src2, offset)
        else:
            raise ValueError(f"Invalid opcode {opcode}")
        
def sign_extend(self, value, bits):
    sign_bit = 1 << (bits - 1)
    return (value & (sign_bit - 1)) - (value & sign_bit)

def run(self, instructions):
    self.pc = 0
    self.memory = instructions
    while True:
        instruction = self.memory[self.pc]
        self.execute(instruction)
        self.pc += 1
        if self.pc >= len(self.memory):
            break
def run():

    sisa = SISA()
    # Generate batches of 10 random instructions
    for batch in range(10):
        for i in range(10):
            # Generate a random ALU operation
            opcode = random.choice([0, 1, 2, 3, 4, 6, 7, 8, 9, 10])
            dest = random.randint(0, 7)
            src1 = random.randint(0, 7)
            src2 = random.randint(0, 7)

            # Encode the instruction
            instruction = (opcode << 13) | (dest << 10) | (src1 << 7) | src2

            # Store the instruction in memory at address 0xC000 + the current index
            memory[0xC000 + i + (batch * 10)] = instruction
    
    sisa.pc = 0xC000 
    
    for batch in range(10):
        for i in range(10):
            sisa.execute(sisa.memory[sisa.pc])
            sisa.pc += 1
            
    
    
    
    
    
    
    
