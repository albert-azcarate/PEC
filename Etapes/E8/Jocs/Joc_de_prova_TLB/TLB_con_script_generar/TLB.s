  ; 0x3d = 11_1101 (v=1,r=1,marco=13) 
   movi r1, 0x3d 
   movi r2, 4 
   wrpi r2, r1 
   halt 
  .org 0x1000 
   and  r0, r0, r0 
   and  r0, r0, r0 
   and  r0, r0, r0 
   movi r3, 7 
   wrpi r3, r1   	; dejamos la pos 7 igual 
   movi r4, 12 
   movi r5, 15 
   wrvi r3, r4   	; itlb.v[7] = 12 	TLBi(7) = C -> D
   wrvi r2, r5   	; itlb.v[6] = 15 	TLBi(4) = F -> D
   movi r1, 3 
   addi r1, r1, -5 
   out 6, r1     	; -2 a los LEDs rojos 
   movi r0, 0 
   movi r4, 0x20 	; (v=1, r=0, marco=0) 
   movi r5, 0x3c 	; (v=1, r=1, marco=12) 
   movi r1, 1 
   movi r2, 12 
   wrpd r1, r5 		; TLBd(1) = 1 -> C
   wrpd r0, r4 		; TLBd(0) = 0 -> 0
   wrvd r1, r0		; TLBd(1) = 0 -> C
   wrvd r0, r1		; TLBd(0) = 1 -> 0
   movi r3, 12 
   shl  r3, r1, r3 	; preprarem @ 0x1000
   ld r2, 0(r0)  	; @log: 0000, @fis: c000 
   st 0(r3), r2  	; @log: 1000, @fis: 0000 
   ld r2, 0(r3)		;
   movi r1, 0xf
   out 9, r1
   out 10, r2
   movi r1, 2
   flush r1
   halt 
