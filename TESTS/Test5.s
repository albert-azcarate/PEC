.text
movi r0, 0
movi r1, 1
movi r2, 2
movi r3, -1
movi r4, -1


mul r5, r0, r1 ; 0000
mulh r6, r0, r1 ; 0000
mulhu r7, r0, r1 ; 0000
st 0(r0), r5
st 2(r0), r6
st 4(r0), r7

mul r5, r1, r1 ; 0001
mulh r6, r1, r1 ; 0000
mulhu r7, r1, r1 ; 0000
st 6(r0), r5
st 8(r0), r6
st 10(r0), r7

mul r5, r1, r2 ; 0002
mulh r6, r1, r2 ; 0000
mulhu r7, r1, r2 ; 0000
st 12(r0), r5
st 14(r0), r6
st 16(r0), r7

mul r5, r2, r2 ; 0004
mulh r6, r2, r2 ; 0000
mulhu r7, r2, r2 ; 0000
st 18(r0), r5
st 20(r0), r6
st 22(r0), r7

mul r5, r3, r4 ; 0001
mulh r6, r3, r4 ; 0000
mulhu r7, r3, r4 ; fffe
st 24(r0), r5
st 26(r0), r6
st 28(r0), r7

mul r5, r3, r1 ; FFFF
mulh r6, r3, r1 ; ffff
mulhu r7, r3, r1 ; 0000
st 30(r0), r5
st 32(r0), r6
st 34(r0), r7


halt
