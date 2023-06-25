; FITXER PRINCIPAL DEL S.O.
.include "macros.s"


.data
    .balign 2
	interrupts_vector:
		.word __interrup_timer 		; 0 Interval Timer
		.word __interrup_key 		; 1 Pulsadors (KEY)
		.word __interrup_switch 	; 2 Interruptors (SWITCH)
		.word __interrup_keyboard 	; 3 Teclado PS/2
			
	exceptions_vector:
		.word RSE_default_resume	; 0 Instrucció il.legal
		.word RSE_default_resume	; 1 Acces a memoria no alineat
		.word RSE_default_resume	; 2 Overflow en coma flotant
		.word RSE_default_resume	; 3 Divisió per zero flotant
		.word RSE_default_resume	; 4 Divisió per zero
		.word RSE_default_resume 	; 5 Res
		.word RSE_default_halt	 	; 6 Miss TLB pag ins
		.word RSE_default_halt 		; 7 Miss TLB pag dat
		.word RSE_default_halt 		; 8 Pagina invalida TLB ins
		.word RSE_default_halt 		; 9 Pagina invalida TLB dat
		.word RSE_default_halt 		; A Pagina protegida TLB ins
		.word RSE_default_resume	; B Pagina protegida TLB dat
		.word RSE_default_resume	; C Pagina read-only
		.word RSE_default_resume	; D Proteccio IO o user
		.word RSE_default_resume	; E Call
		.word RSE_default_resume 	; F Interrupcio

		        
	call_sys_vector:
	    .word RSE_default_resume  ; 0 
	    .word RSE_default_resume  ; 1 
	    .word RSE_default_resume  ; 2 
	    .word RSE_default_resume  ; 3 
	    .word RSE_default_resume  ; 4 
	    .word RSE_default_resume  ; 5 
	    .word RSE_default_resume  ; 6 
	    .word RSE_default_resume  ; 7 

	;; Vector de stack pointers dels dos programes
	
		programs_vector:
			.word 	0x2000		; Corre-letras
			.word	0x6000		; Fibonacci
		
.text

        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Inicialitzacio
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
		
	$MOVEI r6, programs_vector
	ld r7, 2(r6) 				; pila del segon programa
	xor r0, r0, r0
	
	$push r0, r0, r0, r0, r0, r0, r0	; estat artificial programa B (R0-6 = 0) 
	$MOVEI r0, main_fibonacci
        movi r1, 0x2
	$push r1, r0, r0			; s0, s1, s3
	st 2(r6), r7 				; Actualitzem la posicio de la pila

	$MOVEI r1, RSG
	wrs    s5, r1     			; inicializamos en S5 la direccion de la rutina de antencion a la interrupcion
	$MOVEI r1, main_corre_letras 		; inicialitzem R7 com a punter a la pila d'usuari
	wrs	s1, r1				; direccio inicial de programa A
	
	
	$MOVEI 	r1, 0x2				; paraula de estat de backup: Desactivem mode sistema i activem interrupcions
	wrs 	s0, r1			
	
	ld r7, 0(r6) 				; actualitzem ESP al del programa 1                                                                                                                                   
        movi r0, 0
        wrs s4, r0 				; PID del programa 1 
      
        reti					; saltem al primer programa
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*


    	; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
    	; Rutinas de servei
    	; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
RSI_default_resume: jmp R6
RSE_default_halt:   halt
RSE_default_resume: jmp R6

    
RCC: ; RUTINA DE CANVI DE CONTEXT
	
		rds r0, s4 			; Llegim S4 que ens indica el PID (0 -> Primer programa; 1 -> Segon)
  		$MOVEI r6, programs_vector
  		bnz r0, __RCC_p1
	__RCC_p0:
		st 0(r6), r7 			; Guardem ESP (r7) del programa 1
  		ld r7, 2(r6) 			; Actualitzem ESP programa 2
    		movi r0, 1
      		wrs s4, r0 			; Canviem PID
  		
  		$MOVEI r6, __finRCC
		jmp r6

	__RCC_p1:
		st 2(r6), r7 			; Guardem ESP (r7) del programa 2
  		ld r7, 0(r6) 			; Actualitzem ESP programa 1
    		movi r0, 0
      		wrs s4, r0 			; Canviem PID
		
	__finRCC:	
		$MOVEI r6, __finRSG
  		jmp r6
		
	; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
    	; Rutina interrupcio timer
    	; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_timer:
	$MOVEI r4, tics_timer      		
        ld     r3, 0(r4)          		; Carrega el nombre de tics actuals
        addi   r3, r3, 1           		; Incrementa un
        st     0(r4), r3           		; Actualitza el valor de la variable global usada per corre-letras
        out 6,r3        	   		; Solo para DEBUG; mostrem el valor als LEDs vermella
        $MOVEI r6, RCC         			; Saltem a la RCC ja que considerem quantum = 1
        jmp    r6



        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcio pulsadors
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_key:
        
        $MOVEI r6, __finRSG
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcio switches
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_switch:
       
        $MOVEI r6, __finRSG
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcio teclat
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_keyboard:
        in     r3, 15				; Llegim el valor corresponent del teclat
        $MOVEI r4, tecla_pulsada   		; I l'emmagatzemem a la variable global usada per corre-letras
        st     0(r4), r3	
        $MOVEI r6, __finRSG
        jmp    r6

	; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
	; Rutina de servei general
	; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
RSG: 						; Salvar l'estat
		$push R0, R1, R2, R3, R4, R5, R6
			
		rds R1, S0
		rds R2, S1
		rds R3, S3
		$push R1, R2, R3
		rds R1, S2 			; Consultem el contingut de S2
		movi R2, 14
		cmpeq R3, R1, R2 		; Si es igual a 14 es una syscall
		bnz R3, __call_sistema 		
		movi R2, 15
		cmpeq R3, R1, R2 		; Si es igual a 15 es una interrupció
		bnz R3, __interrupcion 
	__excepcion:
		movi R2, lo(exceptions_vector)
		movhi R2, hi(exceptions_vector)
		add R1, R1, R1 			;R1 conte l'identificador de excepció
		add R2, R2, R1
		ld R2, 0(R2)
		jal R6, R2
		bz R3, __finRSG

	__call_sistema:
		rds R1, S3 			; Els ultimms 3 bits de S3 identifiquen la syscall
		movi R2,7
		and R1, R1, R2 
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
	__finRSG: 				; Restaurar l'estat
		$pop R3, R2, R1
		wrs S3, R3
		wrs S1, R2
		wrs S0, R1
			

		$pop R6, R5, R4, R3, R2, R1, R0
		reti 
