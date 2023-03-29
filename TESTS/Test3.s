.text
movi r0, 0
movhi r0, 0
movi r1, 1
movi r2, 2
movi r3, -1
movi r5, -2


; EXPECTED arithmetic -> CA2
; 0000
sha r4, r0, r2 
st 0(r0), r4

; EXPECTED 0xfffc
sha r4, r3, r2 
st 2(r0), r4

; 0000
sha r4, r0, r5 
st 4(r0), r4

; FFFF
sha r4, r3, r5 
st 6(r0), r4

; EXPECTED 0x0004
shl r4, r1, r2 
st 8(r0), r4

; 0000
shl r4, r1, r5 
st 10(r0), r4

; EXPECTED 0xfffc
shl r4, r3, r2 
st 12(r0), r4

; 3fff
shl r4, r3, r5 
st 14(r0), r4

; FFFE
shl r4, r3, r1 
st 16(r0), r4

halt
