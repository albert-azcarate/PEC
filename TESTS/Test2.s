.text
movi r0, 0
movi r1, 1
movi r2, 2
movi r3, -1

and r4, r3, r0 ; expected 0x0000
st 0(r0), r4

and r4, r0, r0 ; expected 0x0000
st 2(r0), r4

and r4, r3, r3 ; expected 0xFFFF
st 4(r0), r4

and r4, r1, r1 ; expected 0x0001
st 6(r0), r4

not r4, r3; expected 0x0000
st 8(r0), r4

not r4, r0; expected 0xFFFF
st 10(r0), r4

not r4, r1; expected 0xFFFE
st 12(r0), r4

not r4, r2; expected 0xFFFD
st 14(r0), r4

or r4, r0, r0 ; expected 0x0000
st 16(r0), r4

or r4, r3, r3 ; expected 0xFFFF
st 18(r0), r4

or r4, r1, r2 ; expected 0x0003
st 20(r0), r4

or r4, r1, r0 ; expected 0x0001
st 22(r0), r4

xor r4, r1, r2 ; expected 0x0003
st 24(r0), r4

xor r4, r0, r0 ; expected 0x0000
st 26(r0), r4

xor r4, r3, r3 ; expected 0x0000
st 28(r0), r4

xor r4, r3, r0 ; expected 0xFFFF
st 30(r0), r4



halt
