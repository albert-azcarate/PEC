.macro 	$movei p1 imm16
		movi    \p1, lo(\imm16)
		movhi   \p1, hi(\imm16)
.endm	

; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
; Inicialitzacio
; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*

		$MOVEI 	r0, RSE
		wrs    	s5, r0		; indiquem direcció de la RSE
		rds    	r0, s7
		addi   	r0, r0, 4	
		wrs    	s7, r0		; habilitem les excepcions de overflow de float
		$MOVEI 	r0, 0x000F
		out    	9, 	r0		; encenem la pantalla HEX
		$MOVEI 	r0, 0xFFFF	
		out    	10, r0		; posem FFFF a la pantalla HEX
		$MOVEI 	r0, start
		jmp    	r0
	
; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
; Rutina d'exceptions
; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*

RSE:   	rds		r3, s2
		out		6, r3		; posem codi d'excepció als leds vermells
		reti

; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
; Rutina principal
; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*

start: 
		$MOVEI 	r7, 0x0001			; posem r7 a 1 pel primer wait
		$MOVEI 	r5, wait	
		jal 	r6, r5
		
		$MOVEI 	r1, 0x4001			; 2.00390625
		$MOVEI 	r2, 0x7E00			; Inf
		$MOVEI 	r5, load_and_div	
		jal 	r6, r5				; Result = 0x0000  x/inf = 0
		$MOVEI 	r5, show	
		jal 	r6, r5
		
		$MOVEI 	r5, wait	
		jal 	r6, r5
		$MOVEI  r0,0x0000
		out		6, r0				; posem leds vermells a 0
		
		$MOVEI 	r1, 0x429D			; 5.2265625
		$MOVEI 	r2, 0x0000			; 0
		$MOVEI 	r5, load_and_div	
		jal 	r6, r5				; Result = 0x7E00  x/0 = inf (divisió entre zero)
		$MOVEI 	r5, show			; Display = 0x0003 (excepció divisió entre zero coma flotant)
		jal 	r6, r5					
		
		$MOVEI 	r5, wait	
		jal 	r6, r5
		$MOVEI  r0,0x0000
		out		6, r0				; posem leds vermells a 0
		
		$MOVEI 	r1, 0x7E00			; Inf
		$MOVEI 	r2, 0x4001			; 2.00390625
		$MOVEI 	r5, load_and_div	
		jal 	r6, r5				; Result = 0x7E00  inf/x = inf
		$MOVEI 	r5, show			; Display = 0x0002 (excepció coma flotant)
		jal 	r6, r5
		
		$MOVEI 	r5, wait	
		jal 	r6, r5
		$MOVEI  r0,0x0000
		out		6, r0				; posem leds vermells a 0
		
		$MOVEI 	r1, 0x4F66			; 435
		$MOVEI 	r2, 0x4540			; 13
		$MOVEI 	r5, load_and_div	
		jal 	r6, r5				; Result = 0x4817  435/13 = 33.4375	 (operació normal)
		$MOVEI 	r5, show	
		jal 	r6, r5
		
		$MOVEI 	r5, wait	
		jal 	r6, r5
		$MOVEI  r0,0x0000
		out		6, r0				; posem leds vermells a 0
		
		$MOVEI 	r1, 0x7001			; 33619968
		$MOVEI 	r2, 0x0001			; 0.000000000001818
		$MOVEI 	r5, load_and_div	
		jal 	r6, r5				; Result = 0x7E00  33619968/0.000000000001818 = 18492831683168316831  (overflow)
		$MOVEI 	r5, show			; Display = 0x0002 (excepció coma flotant)
		jal 	r6, r5						
		
		$MOVEI 	r5, wait	
		jal 	r6, r5
		$MOVEI  r0,0x0000
		out		6, r0				; posem leds vermells a 0	
		
		$MOVEI 	r1, 0x0001			; 0.000000000001818
		$MOVEI 	r2, 0x7001			; 33619968
		$MOVEI 	r5, load_and_div	
		jal 	r6, r5				; Result = 0x0000  0.000000000001818/33619968 = 5.40750068e-20 (underflow)
		$MOVEI 	r5, show	
		jal 	r6, r5
		
		halt

wait:		
		in		r1, 8		; llegim els switchos
		cmpeq	r0, r7, r1	
		bz		r0, wait	; fem loop si no es igual al valor de r7
		$MOVEI 	r0, 1
		shl    	r7, r7, r0	; actualitzem r7 pel següent wait
		jmp 	r6

load_and_div:
		$MOVEI 	r0,	0x0000
		st 		0(r0), r1
		st 		2(r0), r2
		ldf 	f1,	0(r0)
		ldf 	f2, 2(r0)	; carreguem els operands als registres float
		divf 	f0, f1, f2  ; divisió
		jmp 	r6

show:
		$MOVEI r0, 0x0000
		stf		0(r0), f0
		ld		r0, 0(r0)
		out		10, r0			; mostrem resultat a la pantalla HEX
		jmp 	r6

