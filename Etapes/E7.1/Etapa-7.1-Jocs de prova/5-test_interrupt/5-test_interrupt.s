.macro $movei p1 imm16
        movi    \p1, lo(\imm16)
        movhi   \p1, hi(\imm16)
.endm


.text
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Inicializacion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       $MOVEI r1, RSG	; c000 c002
       wrs    s5, r1      ;inicializamos en S5 la direccion de la rutina de antencion a las interrupcciones	4
       movi   r1, 0xF	;6
       out     9, r1      ;activa todos los visores hexadecimales  8
       movi   r1, 0xFF	;A
       out    10, r1      ;muestra el valor 0xFFFF en los visores	;C
       $MOVEI r6, inici   ;adreça de la rutina principal	;E ;10
       jmp    r6		; 12

       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina de servicio de interrupcion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
RSG:   getiid r7          ;obtiene el numero identificador de la interrupcion que se esta atendiendo
       out    10, r7      ;muestra el numero de la interrupcion atendida en los visores hexadecimales
       reti


       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina principal
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici: 
       ei                 ;activa las interrupciones
binf:  movi R0,0
       bz   r0,binf       ;bucle infinito a la espera de que lleguen interrupciones
       halt
