.include "macros.s"
.set PILA, 0x4000               ;una posicion de memoria de una zona no ocupada para usarse como PILA

        

; seccion de datos
.data

        .balign 2       ;garantiza que los siguientes datos de tipo word esten alineados en posiciones pares

		
		interrupts_vector:
			.word __interrup_timer ; 0 Interval Timer
			.word __interrup_key ; 1 Pulsadores (KEY)
			.word __interrup_switch ; 2 Interruptores (SWITCH)
			.word __interrup_keyboard ; 3 Teclado PS/2
			
		exceptions_vector:
			.word RSE_default_resume	; 0 Instrucción ilegal
			.word __no_align	; 1 Acceso a memoria no alineado
			.word RSE_default_resume	; 2 Overflow en coma flotante
			.word RSE_default_resume	; 3 División por cero flotante
			.word RSE_default_resume	; 4 División por cero
			.word RSE_default_resume 	; 5 No excepcion
			.word RSE_default_halt	 	; 6 Miss TLB pag ins
			.word RSE_default_halt 		; 7 Miss TLB pag dat
			.word RSE_default_halt 		; 8 Pagina invalida TLB ins
			.word RSE_default_halt 		; 9 Pagina invalida TLB dat
			.word RSE_default_halt 		; A Pagina protegida TLB ins
			.word RSE_default_resume	; B Pagina protegida TLB dat
			.word RSE_default_resume	; C Pagina de solo lectura
			.word RSE_default_resume	; D Proteccion IO o user
			.word __calls	 			; E Call
			.word RSE_default_resume 	; F Interrupcion
			
		call_sys_vector:
			.word RSE_default_halt		; 0 Hay que definirla en el S.O.
			.word __calls				; 1 Hay que definirla en el S.O.
			.word RSE_default_halt		; 2 Hay que definirla en el S.O.
			.word RSE_default_halt		; 3 Hay que definirla en el S.O.
			.word RSE_default_halt		; 4 Hay que definirla en el S.O.
			.word RSE_default_halt		; 5 Hay que definirla en el S.O.
			.word RSE_default_halt		; 6 Hay que definirla en el S.O.
			.word RSE_default_halt		; 7 Hay que definirla en el S.O.


; seccion de codigo
.text
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Inicializacion
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        $MOVEI r1, RSG
        wrs    s5, r1      ;inicializamos en S5 la direccion de la rutina de antencion a la interrupcion
        $MOVEI r7, PILA    ;inicializamos R7 como puntero a la pila
        $MOVEI r6, inici   ;direccion de la rutina principal
        wrs	s1, r6 
	ei
	$MOVEI 	r6, 0x02
	wrs 	s0, r6
	reti	; saltem a mode user c016
		;jmp    r6


; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
; Rutina de servicio de interrupción
; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
RSG: ; Salvar el estado
			$push R0, R1, R2, R3, R4, R5, R6
			rds R1, S0
			rds R2, S1
			rds R3, S3
			$push R1, R2, R3
			rds R1, S2 ;consultamos el contenido de S2
			movi R2, 14
			cmpeq R3, R1, R2 ;si es igual a 14 es una llamada a sistema
			bnz R3, __call_sistema ;saltamos a las llamadas a sistema si S2 es igual a 14
			movi R2, 15
			cmpeq R3, R1, R2 ;si es igual a 15 es una interrupción
			bnz R3, __interrupcion ;saltamos a las interrupciones si S2 es igual a 15
	__excepcion:
			rds r6, s4
			addi r6,r6,1
			out 10, r6
			wrs s4, r6
			movi R2, lo(exceptions_vector)
			movhi R2, hi(exceptions_vector)
			add R1, R1, R1 ;R1 contiene el identificador de excepción
			add R2, R2, R1
			ld R2, 0(R2)
			jal R6, R2
			bz R3, __finRSG
	__call_sistema:
			rds r6, s4
			addi r6,r6,1
			out 10, r6
			wrs s4, r6
			rds R1, S3 ;S3 contiene el identificador de la llamada a sistema
			movi R2,7
			and R1, R1, R2 ;nos quedamos con los 3 bits de menor peso limitar el número de servicios definidos en el S.O.
			add R1, R1, R1
			movi R2, lo(call_sys_vector)
			movhi R2, hi(call_sys_vector)
			add R2, R2, R1
			ld R2, 0(R2)
			jal R6, R2
			bnz R3, __finRSG
	__interrupcion:
			getiid R1
			add R1, R1, R1
			movi R2, lo(interrupts_vector)
			movhi R2, hi(interrupts_vector)
			add R2, R2, R1
			ld R2, 0(R2)
			jal R6, R2
	__finRSG: ;Restaurar el estado
			$pop R3, R2, R1
			wrs S3, R3
			wrs S1, R2
			wrs S0, R1
			$pop R6, R5, R4, R3, R2, R1, R0
			reti 

		
RSE_default_resume: JMP R6
RSE_default_halt: HALT
RSE_excepcion_TLB: JMP R6; fragmento de código
 ; falta el código de la tarea a hacer
 ;rds R2, S1 ; hay que volver a ejecutar la instrucción que ha fallado

        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcion reloj
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_timer:
       
        ;$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcion pulsadores
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_key:
        
        ;$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcion interruptores
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_switch:
       
        ;$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcion teclado PS/2
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_keyboard:
       
        ;$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina principal
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici: 
        movi   r1, 0xF
        out     9, r1				; activa todos los visores hexadecimales
		halt						; cmp no implementat 0x1010
		halt						; mul no implementat 0x8018
		halt						; jmp no implementat 0xA002
		$MOVEI r0, end_all
		halt						; jmp no implementat 0xA00f
		halt						; stf no implementat 0xB000
		halt						; special no implementat 0xf004 (fake reti)
		halt						; special no implementat 0xfe10 (fake wrd)
		$MOVEI r0, 0x0000			; posem la adressa 0 a r0 
		$MOVEI r2, 0x1010			; cmp no implementat 0x1010 i ho posem a 0x0000
		st 0(r0), r2				
		$MOVEI r2, 0x2000			; addi r0, r0, 0 i ho posem a 0x0002
		st 2(r0), r2
		$MOVEI r1, tornar			; posem a r1 la direccio de retorn
		$MOVEI r2, 0xA043			; jmp r1 i ho posem a 0x0004
		st 4(r0), r2
		jmp r0						; saltem a 0x0000
		
		
		
tornar:
		$MOVEI r0, 0					
		div r0,r0,r0				; div 0
		
		$MOVEI r0, end_jmp
		addi r0,r0,1
		jmp r0						; no al, fetch
		
		addi r0,r0,1
end_jmp:
		$MOVEI r0, 0x1
		st	0(r0), r0				; no al, en st, ld
		
		$MOVEI r0, 0x8000
		st	0(r0), r0				; st > 0x8000 en mode user
		
		addi r0,r0, 1
		ld  r0, 0(r0)				; ld > 0x8000 en mode user
		
		wrs	s0, r0
		rds r0, s0
		reti
		getiid r0
		ei
		di							; instruccio protegida
		$MOVEI r2, 1
		calls r2					; calls ; calls recursive 
									; en ppi posara 0x14
		halt

__ilegal_ins:
		
		;out 9, r2
		;out 10, r1
		;$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6
		
__div_zero:
		;$MOVEI r1, 0xdead
		;movi 	r2, 0xF
		;out 9, r2
		;out 10, r1
		;$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6
		
__no_align:
		rds		r5, s3				; mirem si s3 i s1 son iguals, si no ho son, es una fallada en fetch
		rds		r4, s1
		cmpeq r4, r5, r4			
		bz	r4, end_no_al			; si son iguals restem 1 al pc i ho posem a la pila
		addi r5, r5, -1
		st		2(r7), r5
		
end_no_al:							; else no cal fer res
		;$MOVEI r1, 0xdead
		;movi 	r2, 0xF
		;out 9, r2
		;out 10, r1
		;$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6
		
__protect:
		;$MOVEI r1, 0xde0d
		;movi 	r2, 0xF
		;;out 9, r2
		;;out 10, r1
		;movhi r3, 0xc0
		;rds		r5, s3				; mirem si < a c000
		;cmpltu r3, r5, r3			
		;bz	r3, end_no_p			
		;halt
end_no_p:
		;halt
		jmp r6

__calls:
		calls 	r1
		;$MOVEI r1, 0xd00d
		;movi 	r2, 0xF
		;out 9, r2
		;out 10, r1
		;;addi r7,r7,6
		;$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6
		
__pp_tlb_dat:
		;$MOVEI r1, 0xdddd
		;movi 	r2, 0xF
		;out 9, r2
		;out 10, r1
		;$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6
end_all:	
		halt
		