movi r0, 0
movi r1, 1
movi r2, 2
movi r3, -1
movi r4, -2

div r5, r1, r2 ; 0000
divu r6, r1, r2 ; 0000
st 0(r0), r5
st 2(r0), r6

div r5, r2, r1 ; 0002
divu r6, r2, r1 ; 0002
st 4(r0), r5
st 6(r0), r6

div r5, r0, r0 ; 0000?XXXX
divu r6, r0, r0 ; 0000?XXXX
st 8(r0), r5
st 10(r0), r6

div r5, r0, r1 ; 0000
divu r6, r0, r1 ; 0000
st 12(r0), r5
st 14(r0), r6

div r5, r0, r3 ; 0000
divu r6, r0, r3 ; 0000
st 16(r0), r5
st 18(r0), r6

div r5, r3, r3 ; 0001
divu r6, r3, r3 ; 0001
st 20(r0), r5
st 22(r0), r6

div r5, r1, r3 ; FFFF
divu r6, r1, r3 ; 0000
st 24(r0), r5
st 26(r0), r6

div r5, r3, r1 ; FFFF
divu r6, r3, r1 ; FFFF
st 28(r0), r5
st 30(r0), r6

movi r4, 0x00
movhi r4, 0x80
div r5, r4, r3 ; XXXX
divu r6, r4, r3 ; 0000
st 32(r0), r5
st 34(r0), r6


halt
