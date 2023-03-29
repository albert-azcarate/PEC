.text
movi r0, 0
movi r1, 1
movi r2, 2
movi r3, -3

;//overflow (0x7fff + 1) EXPECTED 0x8000
movi r4, 0xFF
movhi r4, 0x7F
add r4, r4, r1
st 0(r0), r4

;//underflow (0xffff + 1) EXPECTED 0x0000
movi r4, 0xFF
movhi r4, 0xFF
addi r4, r4, 1
st 2(r0), r4

;//(0x7fff - 1) EXPECTED 0x7FFE
movi r4, 0xFF
movhi r4, 0x7F
addi r4, r4, -1
st 4(r0), r4

;//underflow (0xffff - 1) EXPECTED 0xFFFE
movi r4, 0xFF
movhi r4, 0xFF
addi r4, r4, -1
st 6(r0), r4
 
;//a+b (1 + 2) EXPECTED 0x3
add r4, r1, r2
st 8(r0), r4

;//a-b (1 - 3) EXPECTED -2 0xFFFE
add r4, r1, r3
st 10(r0), r4

;EXPECTED 4 0x0004
sub r4, r1, r3
st 12(r0), r4

;EXPECTED -4 0xFFFC
sub r4, r3, r1
st 14(r0), r4

;EXPECTED 1 0x0001
sub r4, r2, r1
st 16(r0), r4

;EXPECTED -1 0xFFFF
sub r4, r1, r2
st 18(r0), r4

halt
