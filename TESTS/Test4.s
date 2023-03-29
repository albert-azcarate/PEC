.text
movi r0, 0
movi r1, 1
movi r2, 2
movi r3, -1
movi r5, -1

;cmplt
; 0001
cmplt r4, r0, r1 
st 0(r0), r4

; 0000
cmplt r4, r0, r3
st 2(r0), r4

; 0001
cmplt r4, r1, r2
st 4(r0), r4

; 0000
cmplt r4, r2, r1 
st 6(r0), r4

; 0000
cmplt r4, r1, r1 
st 8(r0), r4

; cmple
cmple r4, r0, r0 ; 1
st 10(r0), r4
cmple r4, r3, r3 ; 1
st 12(r0), r4
cmple r4, r3, r1 ; 1
st 14(r0), r4
cmple r4, r1, r3 ; 0
st 16(r0), r4
cmple r4, r1, r2 ; 1
st 18(r0), r4
cmple r4, r2, r1 ; 0
st 20(r0), r4

; cmpeq
cmpeq r4, r2, r3 ; 0
st 22(r0), r4
cmpeq r4, r3, r3 ; 1
st 24(r0), r4
cmpeq r4, r1, r1 ; 1
st 26(r0), r4
cmpeq r4, r3, r5 ; 1
st 28(r0), r4
cmpeq r4, r3, r2 ; 0
st 30(r0), r4

; cmpltu
cmpltu r4, r3, r1 ; 0
st 32(r0), r4
cmpltu r4, r1, r3 ; 1
st 34(r0), r4
cmpltu r4, r1, r1 ; 0
st 36(r0), r4
cmpltu r4, r1, r2 ; 1
st 38(r0), r4
cmpltu r4, r3, r5 ; 0
st 40(r0), r4

; cmpleu
cmpleu r4, r3, r5 ; 1
st 42(r0), r4
cmpleu r4, r3, r1 ; 0
st 44(r0), r4
cmpleu r4, r1, r2 ; 1
st 46(r0), r4
cmpleu r4, r0, r1 ; 1
st 48(r0), r4
cmpleu r4, r2, r0 ; 0
st 50(r0), r4

halt
