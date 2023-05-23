.include "macros.s"
.set PILA, 0x4000               ;una posicion de memoria de una zona no ocupada para usarse como PILA

        

; seccion de datos
.data

        .balign 2       ;garantiza que los siguientes datos de tipo word esten alineados en posiciones pares

		
		interrupts_vector:
			.word __interrup_timer 				; 0 Interval Timer
			.word __interrup_key 				; 1 Pulsadores (KEY)
			.word __interrup_switch 			; 2 Interruptores (SWITCH)
			.word __interrup_keyboard 			; 3 Teclado PS/2
			
		exceptions_vector:
			.word __ilegal_ins					; 0 Instrucción ilegal
			.word __no_align					; 1 Acceso a memoria no alineado
			.word RSE_default_halt				; 2 Overflow en coma flotante
			.word RSE_default_halt				; 3 División por cero flotante
			.word __div_zero					; 4 División por cero
			.word RSE_default_resume 			; 5 No excepcion
			.word __tlb_exc_m_i	 				; 6 Miss TLB pag ins
			.word __tlb_exc_m_d 				; 7 Miss TLB pag dat
			.word __tlb_exc_i_i 				; 8 Pagina invalida TLB ins
			.word __tlb_exc_i_d					; 9 Pagina invalida TLB dat
			.word __tlb_exc_pp_i				; A Pagina protegida TLB ins
			.word __tlb_exc_pp_d				; B Pagina protegida TLB dat
			.word __tlb_exc_ro_d				; C Pagina de solo lectura
			.word __protect						; D Proteccion IO o user
			.word __calls	 					; E Call
			.word RSE_default_resume 			; F Interrupcion
	
		call_sys_vector:		
			.word RSE_default_halt				; 0 Hay que definirla en el S.O.
			.word __calls						; 1 Hay que definirla en el S.O.
			.word RSE_default_halt				; 2 Hay que definirla en el S.O.
			.word RSE_default_halt				; 3 Hay que definirla en el S.O.
			.word RSE_default_halt				; 4 Hay que definirla en el S.O.
			.word RSE_default_halt				; 5 Hay que definirla en el S.O.
			.word RSE_default_halt				; 6 Hay que definirla en el S.O.
			.word RSE_default_halt				; 7 Hay que definirla en el S.O.


; seccion de codigo
.text
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Inicializacion
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        $MOVEI r1, RSG
        wrs    s5, r1      ;inicializamos en S5 la direccion de la rutina de antencion a la interrupcion
        $MOVEI r7, PILA    ;inicializamos R7 como puntero a la pila
		
		; cambien la TLB per adaptar la pila que apunti a 2000 cap avall
		movi	r1, 3		
		movi 	r2, 1		
		wrvd	r2, r1		; TLBd(1) 3 -> 1
		
		; borrem la entrada D de TLBi
		movi	r1, 3		
		movi 	r2, 5		
		wrvi	r2, r1		; TLBd(5) 3 -> d
		
		
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
RSE_excepcion_TLB: JMP R6

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




end_all:	
		halt
		
		
		; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina principal
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
		
		
inici: 
		$MOVEI r1, post_inici
		$MOVEI r2, 0x1000
		add r1, r1, r2
		jmp r1				; saltem a 0xD0XX, saltara miss i i farem TLBi D -> C
post_inici:
		$MOVEI	r0, 0x4000	; Aqui han de saltar excepcions de miss TLBi i invalid TLBi
		st		0(r0), r0	; Aqui ha de saltar miss TLBd, invalid TLBd i READ_ONLY TLBd
		$MOVEI	r0, 0xC000	
		ld		r0, 0(r0)	; pp_TLB_d
		
		
		
        movi   r1, 0xF
        out     9, r1				;activa todos los visores hexadecimales
		halt						; cmp no implementat 0x1010 rev
		halt						; mul no implementat 0x8018 rev
		halt						; jmp no implementat 0xA002 OK
		$MOVEI r0, end_all
		halt						; jmp no implementat 0xA00f
		halt						; stf no implementat 0xB000
		halt						; special no implementat 0xf004 (fake reti)
		halt						; special no implementat 0xfe10 (fake wrs)
		$MOVEI r0, 0x0000
		$MOVEI r2, 0x1010
		st 0(r0), r2				; guardem a 0x0000 la ins ilegal 1010
		$MOVEI r2, 0x2000
		st 2(r0), r2				; guardem a 0x0002 la ins ADDI r0,r0,0
		$MOVEI r1, tornar
		$MOVEI r2, 0xA043			; guardem a 0x0004 la ins JMP r1 (etiqueta tornar)
		st 4(r0), r2
		jmp r0
		
		
		
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
		di							; instruccions protegides
		wrpd	r0, r0
		wrpi 	r0, r0
		wrvi	r0, r0
		wrvd	r0, r0
		
		$MOVEI r2, 1				; calls ; calls recursive 
		calls r2					; en ppi posara 31 0x1F
		
		halt

__ilegal_ins:
        jmp    r6
		
__div_zero:
        jmp    r6
		
__no_align:
		rds		r5, s3				; mirem si s3 i s1 son iguals, si no ho son, es una fallada en fetch
		rds		r4, s1
		cmpeq r4, r5, r4			
		bz	r4, end_no_al			; si son iguals restem 1 al pc i ho posem a la pila
		addi r5, r5, -1
		st		2(r7), r5
		
end_no_al:							; else no cal fer res
        jmp    r6
		
__protect:
		jmp r6

__calls:
		calls 	r1
        jmp    r6	
		
 __tlb_exc_m_i:
		; posem a TLB
		; entra un pc d006
		
		rds r0,s3	; llegim quina adressa ha fallat
		movi r1, -12
		shl r1, r0, r1	; posem 0x000X
		movi r2, 7
		movi r3, 0x0C
		wrpi r2, r3		; TLBi(7) 7 -> C v = 0, r = 0	; POSEM INVALIDA per que salti la seguent excepcio de invalida
		wrvi r2, r1 	; TLBi(7) X -> C v = 0, r = 0
		
		movi r3, 0 			; posem r3 a 0 que si no al BZ de tornada no salta; En exc en Instruccio no cal fer pc - 2 perque no hem fet pc + 2
		jmp r6
 
 __tlb_exc_m_d: 
		; posem a TLB i rexecutem
		; entra una @ 0x4000
		
		rds r0,s3	; llegim quina adressa ha fallat
		movi r1, -12
		shl r1, r0, r1	; posem 0x000X
		movi r2, 2
		movi r3, 0x0A
		wrpd r2, r3		; TLBi(2) 2 -> A v = 0, r = 0	; POSEM INVALIDA per que salti la seguent excepcio de invalida
		wrvd r2, r1 	; TLBi(2) X -> A v = 0, r = 0
		movi r0, 0
		bz r0, __tlb_reexecute
 
 __tlb_exc_i_i: 
		; posem a valida 
		; entra un pc d006
		
		rds r0,s3	; llegim quina adressa ha fallat
		movi r1, -12
		shl r1, r0, r1	; posem 0x000X
		movi r2, 7
		movi r3, 0x2C
		wrpi r2, r3		; TLBi(7) 7 -> C v = 1, r = 0
		wrvi r2, r1 	; TLBi(7) X -> C v = 1, r = 0

		movi r3, 0 			; posem r3 a 0 que si no al BZ de tornada no salta; En exc en Instruccio no cal fer pc - 2 perque no hem fet pc + 2
		jmp r6
 
 
 __tlb_exc_i_d:	
		; posem a valida i rexecutem
		; entra una @ 0xA000 en invalida
		
		rds r0,s3	; llegim quina adressa ha fallat
		movi r1, -12
		shl r1, r0, r1	; posem 0x000X
		movi r2, 2
		movi r3, 0x3A
		wrpd r2, r3		; TLBi(2) 2 -> A v = 1, r = 1	; POSEM READ_ONLY per que salti la seguent excepcio
		wrvd r2, r1 	; TLBi(2) X -> A v = 1, r = 1
		movi r0, 0
		bz r0, __tlb_reexecute
		
 __tlb_exc_pp_i:
		jmp r6
 
 __tlb_exc_pp_d:
		jmp r6
 
 __tlb_exc_ro_d:
		jmp r6
		
__tlb_reexecute:
		ld 	r5, 2(r7)		; ld del pc antic
		addi r5, r5, -2
		st	2(r7), r5		; pc = pc - 2
		movi r3, 0 			; posem r3 a 0 que si no al BZ de tornada no salta
		jmp r6
		
		
		