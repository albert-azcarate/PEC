movi r0, 64      ; r0 = 0x40
movi r1, 65      ; r1 = 0x41
movi r2, 66      ; r2 = 0x42
movi r3, 67      ; r3 = 0x43
movi r4, 68      ; r4 = 0x44
movi r5, 80      ; r5 = 0x50

; probamos los stores de byte
stb 2(r0), r1    ; mem[0x21] = 0x41		33L
stb 4(r3), r2    ; mem[0x23] = 0x42		35U
stb 0(r5), r3    ; mem[0x28] = 0x43		40L
stb -12(r5), r4  ; mem[0x22] = 0x44 	34L		(offset negativo)
stb -2(r0), r5   ; mem[0x1F] = 0x50 	31L

; probamos los loads de byte
movi r7, 74      ; r7 = 0x4a
ldb r4, -8(r7)   ; r4 = mem[0x21] = 0x41	33L
ldb r3, 4(r3)    ; r3 = mem[0x47] = 0x42	35U
ldb r2, 14(r2)   ; r2 = mem[0x50] = 0x43
ldb r1, 4(r0)    ; r1 = mem[0x44] = 0x44	
movi r7, 14      ; r7 = 0x0e
movhi r7, 0xc0   ; r7 = 0xc00e (cambio a modo de dirección ROM)
ldb r6, -1(r7)   ; r6 = mem[0xffff] (lectura byte de ROM)

stb 0(r0), r1    ; mem[0x40] = 0x44
stb 1(r0), r6    ; mem[0x41] = mem[0xffff] (lectura byte de ROM)
stb 2(r0), r4    ; mem[0x42] = 0x41
stb 3(r0), r2    ; mem[0x43] = 0x43
stb 4(r0), r3    ; mem[0x44] = 0x42

; loads de word
ld r1, -2(r3)    ; r1 = mem[0x45] + (mem[0x46] << 8)
ld r2, 0(r3)     ; r2 = mem[0x47] + (mem[0x48] << 8)
ld r3, 2(r3)     ; r3 = mem[0x49] + (mem[0x4a] << 8)
ld r7, -14(r7)   ; r7 = mem[0xfffc] + (mem[0xfffd] << 8) (lectura word de ROM)
; volcado de los reg. - stores de word
movi r0, 64		;
st 32(r0), r1	; mem[0x60] = r1
st 34(r0), r2	; mem[0x62] = r2
st 36(r0), r3	; mem[0x64] = r3
st 38(r0), r4	; mem[0x66] = r4
st 40(r0), r6	; mem[0x68] = r6
st 42(r0), r7	; mem[0x6A] = r7
halt