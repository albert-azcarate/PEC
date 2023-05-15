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
			.word __ilegal_ins 			; 0 Instrucción ilegal
			.word __no_align 			; 1 Acceso a memoria no alineado
			.word RSE_default_halt 		; 2 Overflow en coma flotante
			.word RSE_default_halt 		; 3 División por cero flotante
			.word __div_zero	 		; 4 División por cero
			.word RSE_default_resume 	; 5 No excepcion
			.word RSE_default_halt	 	; 6 Miss TLB pag ins
			.word RSE_default_halt 		; 7 Miss TLB pag dat
			.word RSE_default_halt 		; 8 Pagina invalida TLB ins
			.word RSE_default_halt 		; 9 Pagina invalida TLB dat
			.word RSE_default_halt 		; A Pagina protegida TLB ins
			.word __pp_tlb_dat 			; B Pagina protegida TLB dat
			.word RSE_default_halt 		; C Pagina de solo lectura
			.word __protect 			; D Proteccion IO o user
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
        wrs		s1, r6 
		ei
		rds 	r6, s7
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
			movi R2, lo(exceptions_vector)
			movhi R2, hi(exceptions_vector)
			add R1, R1, R1 ;R1 contiene el identificador de excepción
			add R2, R2, R1
			ld R2, 0(R2)
			jal R6, R2
			bz R3, __finRSG
	__call_sistema:
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
       
        $MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcion pulsadores
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_key:
        
        $MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcion interruptores
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_switch:
       
        $MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcion teclado PS/2
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_keyboard:
       
        $MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina principal
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici: 
        movi   r1, 0xF
        out     9, r1              ;activa todos los visores hexadecimales
		$MOVEI r0, 0
		$MOVEI r1 , 0xffff
bucle_inf:	
		addi	r0, r0, 1
		cmpeq 	r2,r0,r1
		bz		r2, bucle_inf
		$MOVEI	r2 jmp_bucle
		addi	r2, r2, 1
		jmp		r2				; no_al 7seg = dead
		halt
		addi 	r0, r0,0
jmp_bucle:
		$MOVEI r0, 0
		$MOVEI r1 , 0xffff
bucle_inf_2:	
		addi	r0, r0, 1
		cmpeq 	r2,r0,r1
		bz		r2, bucle_inf_2
		$MOVEI  r2, 1
		calls 	r2				; calls inception 7seg = d00d
		$MOVEI r0, 0
		$MOVEI r1 , 0xffff
bucle_inf_3:	
		addi	r0, r0, 1
		cmpeq 	r2,r0,r1
		bz		r2, bucle_inf_3
		$MOVEI 	r2, 0x0000
		jmp 	r2				; deod
end_test:	
		halt

__ilegal_ins:
		
		$MOVEI r1, 0xd00d
		movi 	r2, 0xF
		out 9, r2
		out 10, r1
		$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6
		
__div_zero:
		$MOVEI r1, 0xdead
		movi 	r2, 0xF
		out 9, r2
		out 10, r1
		$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6
		
__no_align:
		movhi r3, 0xc0
		rds		r5, s3				; mirem si > a c000
		$CMPGEU r3, r5, r3			
		bz	r3, end_no_al			; si es major restem 1 al pc i ho posem a la pila
		addi r5, r5, -1
		st		2(r7), r5
		
end_no_al:							; else no cal fer res
		$MOVEI r1, 0xdead
		movi 	r2, 0xF
		out 9, r2
		out 10, r1
		$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6
		
__protect:
		$MOVEI r1, 0xde0d
		movi 	r2, 0xF
		out 9, r2
		out 10, r1
		movhi r3, 0xc0
		rds		r5, s3				; mirem si < a c000
		cmpltu r3, r5, r3			
		bz	r3, end_no_p			
		halt
end_no_p:
		halt

__calls:
		calls 	r1
		$MOVEI r1, 0xd00d
		movi 	r2, 0xF
		out 9, r2
		out 10, r1
		$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6
		
__pp_tlb_dat:
		$MOVEI r1, 0xdddd
		movi 	r2, 0xF
		out 9, r2
		out 10, r1
		$MOVEI r6, __finRSG         ;direccion del fin del servicio de interrupcion
        jmp    r6
