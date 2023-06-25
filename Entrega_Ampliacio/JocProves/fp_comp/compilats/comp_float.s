.include "macros.s"
.set PILA, 0x4000               ;una posicion de memoria de una zona no ocupada para usarse como PILA

        

; seccion de datos
.data



; seccion de codigo
.text

$MOVEI r7, PILA    ;inicializamos R7 como puntero a la pila

$MOVEI r0, 0x0000	; 0
$MOVEI r1, 0x8000	; -0
$MOVEI r2, 0x7E00	; inf
$MOVEI r3, 0xFE00	; -inf
$MOVEI r4, 0x7E01	; NaN
$MOVEI r5, 0x4000	; 2
$MOVEI r6, 0x4001	; 2.00390625

; store and load into float register the data
st 0(r0), r0
st 2(r0), r1
st 4(r0), r2
st 6(r0), r3
st 8(r0), r4
st 10(r0), r5
st 12(r0), r6
ldf f0, 0(r0)
ldf f1, 2(r0)
ldf f2, 4(r0)
ldf f3, 6(r0)
ldf f4, 8(r0)
ldf f5, 10(r0)
ldf f6, 12(r0)
$MOVEI r2, 0x0000

; r2 comptador de trues
; COMP EQUAL
$MOVEI r5, add_rutine

cmpeqf 	r7, f0, f0 ; TRUE	0 = 0
jal r6, r5
cmpeqf 	r7, f1, f1 ; TRUE	-0 = -0
jal r6, r5
cmpeqf 	r7, f2, f2 ; TRUE	inf = inf
jal r6, r5
cmpeqf 	r7, f3, f3 ; TRUE	-inf = -inf
jal r6, r5
cmpeqf 	r7, f4, f4 ; FALSE	NaN != NaN
jal r6, r5
cmpeqf 	r7, f5, f5 ; TRUE	2 = 2
jal r6, r5
cmpeqf 	r7, f6, f6 ; TRUE	2.00390625 = 2.00390625
jal r6, r5

cmpeqf 	r7, f0, f1 ; 0 = -0 TRUE
jal r6, r5
cmpeqf 	r7, f5, f6 ; 2 = 2.0039625 FALSE
jal r6, r5
cmpeqf 	r7, f2, f3 ; inf = -inf FALSE
jal r6, r5

; r2 = 7

; COMP LESS THAN

cmpltf 	r7, f0, f0 ; FALSE	0 !< 0
jal r6, r5
cmpltf 	r7, f4, f4 ; FALSE 	NaN !< NaN
jal r6, r5
cmpltf 	r7, f1, f0 ; FALSE	-0 !< 0
jal r6, r5
cmpltf 	r7, f0, f5 ; TRUE	0 < 2
jal r6, r5
cmpltf 	r7, f0, f6 ; TRUE	0 < 2.00390625
jal r6, r5
cmpltf 	r7, f0, f4 ; FALSE	0 !< NaN
jal r6, r5
cmpltf 	r7, f3, f1 ; TRUE	-inf < -0 
jal r6, r5
cmpltf 	r7, f1, f3 ; FALSE	-0 !< -inf 
jal r6, r5
cmpltf 	r7, f3, f2 ; TRUE	-inf < inf 
jal r6, r5
cmpltf 	r7, f2, f3 ; FALSE	inf !< -inf 
jal r6, r5
cmpltf 	r7, f3, f3 ; FALSE	inf !< inf 
jal r6, r5
cmpltf 	r7, f5, f6 ; TRUE	2 < 2.00390625
jal r6, r5
cmpltf 	r7, f6, f5 ; FALSE	2.00390625 !< 2 
jal r6, r5

; r2 = C

cmplef 	r7, f0, f0 ; TRUE	0 <= 0
jal r6, r5
cmplef 	r7, f4, f4 ; FALSE 	NaN !<= NaN
jal r6, r5
cmplef 	r7, f1, f0 ; TRUE	-0 <= 0
jal r6, r5
cmplef 	r7, f0, f5 ; TRUE	0 <= 2
jal r6, r5
cmplef 	r7, f0, f6 ; TRUE	0 <= 2.00390625
jal r6, r5
cmplef 	r7, f0, f4 ; FALSE	0 !<= NaN
jal r6, r5
cmplef 	r7, f3, f1 ; TRUE	-inf <= -0 
jal r6, r5
cmplef 	r7, f1, f3 ; FALSE	-0 !<= -inf 
jal r6, r5
cmplef 	r7, f3, f2 ; TRUE	-inf <= inf 
jal r6, r5
cmplef 	r7, f2, f3 ; FALSE	inf !<= -inf 
jal r6, r5
cmplef 	r7, f3, f3 ; TRUE	inf <= inf 
jal r6, r5
cmplef 	r7, f5, f6 ; TRUE	2 <= 2.00390625
jal r6, r5
cmplef 	r7, f6, f5 ; FALSE	2.00390625 !<= 2 
jal r6, r5

; r2 = 14



; COMP LESS EQUAL
; mostrem per pantalla el resultat
$movei 	r1, 0x000F
out		9, r1
out		10 ,r2
halt

add_rutine:
	stf		0(r0), f7
	ld		r1, 0(r0)
	add 	r2, r1, r2 
	jmp 	r6
halt







