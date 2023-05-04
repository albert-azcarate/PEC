; Incluir las macros necesarias
.include "macros.s"


.set PILA, 0x4000               ;una posicion de memoria de una zona no ocupada para usarse como PILA
.set CHAR_CLEAR_SCREEN, 0x152E  ;borramos la pantalla con un punto gris oscuro
;.set CHAR_CLEAR_SCREEN, 0x0020  ;borramos la pantalla con un espacio negro
        

; seccion de datos
.data
        ; dades globals
        frase0a:          .asciz "Ticks Timer: "
        frase0b:          .asciz "Hora: "
        frase1:           .asciz "Pulsadores: "
        frase2:           .asciz "Interruptores: "
        frase3a:          .asciz "Codigo ASCII tecla: "
        frase3b:          .asciz "Numero repeticiones: "

        cadena_aux:       .fill  10, 1, 0      ;10 elementos de tamaño byte inicializados a 0

        .balign 2       ;garantiza que los siguientes datos de tipo word esten alineados en posiciones pares

        d_ticks:          .word 0
        d_pulsadores:     .word 0
        d_interruptores:  .word 0
        d_tecla:          .word 0
        d_clicks_tecla:   .word 0
        ;datos para mostrar un reloj por pantalla
        d_ticks_seg:      .word 0
        d_segundos:       .word 0
        d_minutos:        .word 0
        d_horas:          .word 0


; seccion de codigo
.text
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Inicializacion
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        $MOVEI r1, RSG
        wrs    s5, r1      ;inicializamos en S5 la direccion de la rutina de antencion a la interrupcion
        $MOVEI r7, PILA    ;inicializamos R7 como puntero a la pila
        $MOVEI r6, inici   ;direccion de la rutina principal
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina de servicio de interrupcion
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
RSG:    $PUSH r0, r1, r2, r3, r4, r5, r6 ;salvamos el estado en la pila
        getiid r1          
        movi   r3, 0                     ;comprueba si es una interrupcion del interval timer
        cmpeq  r2, r1, r3
        bnz    r2, __interrup_timer
        movi   r3, 1                     ;comprueba si es una interrupcion del controlador de los pulsadores
        cmpeq  r2, r1, r3 
        bnz    r2, __interrup_key
        movi   r3, 2                     ;comprueba si es una interrupcion del controlador de los interruptores
        cmpeq  r2, r1, r3
        bnz    r2, __interrup_switch
        movi   r3, 3                     ;comprueba si es una interrupcion del controlador del teclado
        cmpeq  r2, r1, r3
        bnz    r2, __interrup_keyboard
end_int:
        $POP r6, r5, r4, r3, r2, r1, r0  ;restauramos el estado desde la pila (ojo orden inverso)
        reti


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcion reloj
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_timer:
        $MOVEI r4, d_ticks         ;carga la direccion de memoria donde esta el dato sobre el # de ticks de reloj que han llegado
        ld     r3, 0(r4)           ;carga el numero de ticks
        addi   r3, r3, 1           ;lo incrementa en una unidad
        st     0(r4), r3           ;actualiza la variable sobre el numero de ticks
        out    10, r3              ;muesta el numero de ticks por los visores

        ;reloj
        $MOVEI r4, d_ticks_seg
        ld     r3, 0(r4)
        addi   r3, r3, 1           ;d_ticks_seg++
        st     0(r4), r3
        movi   r1, 20
        cmpeq  r1, r3, r1
        bz     r1, __finreloj
        movi   r3, 0               ;d_ticks_seg=0
        st     0(r4), r3
        $MOVEI r4, d_segundos
        ld     r3, 0(r4)
        addi   r3, r3, 1           ;d_segundos++
        st     0(r4), r3
        movi   r1, 60
        cmpeq  r1, r3, r1
        bz     r1, __finreloj
        movi   r3, 0               ;d_segundos=0
        st     0(r4), r3
        $MOVEI r4, d_minutos
        ld     r3, 0(r4)
        addi   r3, r3, 1           ;d_minutos++
        st     0(r4), r3
        movi   r1, 60
        cmpeq  r1, r3, r1
        bz     r1, __finreloj
        movi   r3, 0               ;d_minutos=0
        st     0(r4), r3
        $MOVEI r4, d_horas
        ld     r3, 0(r4)
        addi   r3, r3, 1           ;d_horas++
        st     0(r4), r3
 __finreloj:
        $MOVEI r6, end_int         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcion pulsadores
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_key:
        in     r3, 7               ;leemos el valor de los pulsadores
        not    r3,r3               ;los pulsadores son activos a '0'
        movi   r4,0x0F
        and    r3, r3, r4          ;mascara para apagar los leds que no corresponden a ningun pulsador
        out     5, r3              ;activa los leds verdes con el valor de los pulsadores
        $MOVEI r4, d_pulsadores    ;carga la direccion de memoria donde esta el dato sobre el estado de los pulsadores
        st     0(r4), r3           ;actualiza la variable sobre el estado de los pulsadores
        $MOVEI r6, end_int         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcion interruptores
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_switch:
        in     r3, 8               ;leemos el valor de los interruptores
        out     6, r3              ;activa los leds rojos con el valor de los interruptores
        $MOVEI r4, d_interruptores ;carga la direccion de memoria donde esta el dato sobre el estado de los interruptores
        st     0(r4), r3           ;actualiza la variable sobre el estado de los interruptores
        $MOVEI r6, end_int         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina interrupcion teclado PS/2
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__interrup_keyboard:
        in     r3, 15              ;leemos el valor correspondiente al caracter ASCII de la tecla pulsada
        $MOVEI r4, d_tecla         ;carga la direccion de memoria donde esta el dato sobre la ultima tecla pulsada
        ld     r5, 0(r4)           ;carga la ultima tecla pulsada
        st     0(r4), r3           ;actualiza la variable con la nueva tecla pulsada
        cmpeq  r3, r3, r5
        $MOVEI r4, d_clicks_tecla  ;carga la direccion de memoria donde esta el dato sobre el numero de veces que se ha pulsado la ultima tecla
        bz     r3, __distintas
        ; teclas iguales
        ld     r5, 0(r4)           ;carga el numero de veces consecutivas que se ha pulsado la tecla
        addi   r5, r5, 1           ;se incrementa en 1 el numero de repeticiones consecutivas
        bnz r3, __fin_keyboard
__distintas:
        ; teclas distintas 
        movi   r5, 1               ;es la primera vez que se pulsa
__fin_keyboard:
        st     0(r4), r5           ;actualiza la variable con el numero de repeticiones
        $MOVEI r6, end_int         ;direccion del fin del servicio de interrupcion
        jmp    r6


        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Rutina principal
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici: 
        movi   r1, 0xF
        out     9, r1              ;activa todos los visores hexadecimales
        movi   r1, 0x00
        out    10, r1              ;muestra el valor 0x0000 en los visores
        out     5, r1              ;apaga los leds verdes
        in     r1, 8               ;leemos el valor de los interruptores
        out     6, r1              ;activa los leds rojos con el valor de los interruptores
        $CALL  r6, __clear_screen  ;borra la pantalla (en R6 se almacena la direccion de retorno de la subrutina)
        ei                         ;activa las interrupciones

binf:   
        $MOVEI r1, 0xA000          ;fila 0; columna 0
        $MOVEI r2, frase0a         ;frase 0a
        $CALL  r6, __write_line
        $MOVEI r1, 0xA01A          ;fila 0; columna 13
        $MOVEI r2, d_ticks         ;carga la direccion de memoria donde esta el dato sobre el # de ticks de reloj que han llegado
        ld     r2, 0(r2)           ;carga el numero de ticks
        $CALL  r6, __write_valor

        $MOVEI r1, 0xA032          ;fila 0; columna 25
        $MOVEI r2, frase0b         ;frase 0b
        $CALL  r6, __write_line
        $MOVEI r1, 0xA03E          ;fila 0; columna 31
        $CALL  r6, __mostrar_reloj

        $MOVEI r1, 0xA0A0          ;fila 1; columna 0
        $MOVEI r2, frase1          ;frase 1
        $CALL  r6, __write_line
        $MOVEI r1, 0xA0B8          ;fila 1; columna 12
        $MOVEI r2, d_pulsadores    ;carga la direccion de memoria donde esta el dato sobre el estado de los pulsadores
        ld     r2, 0(r2)          
        $CALL  r6, __write_valor

        $MOVEI r1, 0xA140          ;fila 2; columna 0
        $MOVEI r2, frase2          ;frase 2
        $CALL  r6, __write_line
        $MOVEI r1, 0xA15E          ;fila 2; columna 15
        $MOVEI r2, d_interruptores ;carga la direccion de memoria donde esta el dato sobre el estado de los interruptores
        ld     r2, 0(r2)
        $CALL  r6, __write_valor

        $MOVEI r1, 0xA1E0          ;fila 3; columna 0
        $MOVEI r2, frase3a         ;frase 3a
        $CALL  r6, __write_line
        $MOVEI r1, 0xA208          ;fila 3; columna 20
        $MOVEI r2, d_tecla         ;carga la direccion de memoria donde esta el dato sobre la ultima tecla pulsada
        ld     r2, 0(r2)           ;carga la ultima tecla pulsada
        $CALL  r6, __write_valor

        $MOVEI r1, 0xA212          ;fila 3; columna 25
        $MOVEI r2, frase3b         ;frase 3b
        $CALL  r6, __write_line
        $MOVEI r1, 0xA23C          ;fila 3; columna 21
        $MOVEI r2, d_clicks_tecla  ;carga la direccion de memoria donde esta el dato sobre el numero de veces que se ha pulsado la ultima tecla
        ld     r2, 0(r2)           ;carga el numero de veces consecutivas que se ha pulsado la tecla
        $CALL  r6, __write_valor

        $MOVEI r6, binf            ;bucle infinito a la espera de que lleguen interrupciones
        jmp    r6
        halt



        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Subrutina para limpiar la pantalla
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
__clear_screen:
        $MOVEI r0, 0xA000          ;0xA000 direccion de inicio de la memoria de video
        $MOVEI r1, 2400            ;(80*30=2400=0x0960) numero caracteres de la pantalla
        $MOVEI r2, CHAR_CLEAR_SCREEN ;caracter ASCII y color con el que se borra la pantalla
__repe: st 0(r0), r2
        addi  r0, r0, 2
        addi  r1, r1, -1
        bnz   r1, __repe
        jmp r6                     ;R6 contiene la direccion de retorno de la subrutina



        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Subrutina para escribir una linea de texto en 
        ; pantalla seguida de un valor 
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; r1 <= contiene la direccion de memoria de pantalla donde se quiere escribir
        ; r2 <= contiene la direccion de memoria de la cadena de texto que queremos escribir
__write_line:
bucle_cad: ldb   r4, 0(r2)        
           bz    r4, fin_bucle_cad
           movhi r4, 0x0F          ;color amarillo   
           st    0(r1), r4
           addi  r1, r1, 2
           addi  r2, r2, 1
           bnz   r4, bucle_cad
fin_bucle_cad:
           jmp r6    ; retornar de la subrutina



        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Subrutina para escribir un valor por la pantalla
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; r1 <= contiene la direccion de memoria de pantalla donde se quiere escribir
        ; r2 <= contiene la direccion de memoria del valor que queremos escribir
__write_valor:
           $PUSH r1              ;guardamos r1 porque la rutina nos va a machacar el valor que es por donde devuelve el resultado

           $MOVEI r4, cadena_aux ;pone la direccion (puntero) de la cadena auxiliar para el resultado de la conversion
           $PUSH  r4
           $PUSH  r2             ;pone el valor entero a convertir a ASCII
           $CALL  r5, __itoa     ;convierte a ASCII el valor (R5=@ retorno, R7=@pila, retorno resultado por R1)
           addi   r7, r7, 4      ;recuperamos el espacio de la pila

           $POP r1               ;recuperamos r1 que contiene la posicion de pantalla a escribir

bucle_val: ldb   r5, 0(r4)        
           bz    r5, fin_bucle_val
           movhi r5, 0x3C        ;color cyan
           st    0(r1), r5
           addi  r1, r1, 2
           addi  r4, r4, 1
           bnz   r5, bucle_val
fin_bucle_val:
           ;imprime los dos siguentes caracteres para borrar los digitos 
           ;sobrantes si el numero anterior ocupaba más digitos que el actual
           $MOVEI r5, CHAR_CLEAR_SCREEN
           st    0(r1), r5
           st    2(r1), r5
           jmp   r6              ;retornar de la subrutina




        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Subrutina para escribir el reloj por pantalla
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; r1 <= contiene la direccion de memoria de pantalla donde se quiere escribir

__mostrar_reloj:
           addi   r0, r1, 0      ;copiamos la direccion de la posicion de pantalla del reloj

           $MOVEI r4, cadena_aux ;pone la direccion (puntero) de la cadena auxiliar para el resultado de la conversion
           $PUSH  r4
           $MOVEI r3, d_horas    ;carga la direccion de memoria donde esta el dato
           ld     r3, 0(r3)          
           $PUSH  r3             ;pone el valor entero a convertir a ASCII
           $CALL  r5, __itoa     ;convierte a ASCII el valor (R5=@ retorno, R7=@pila, retorno resultado por R1)
           addi   r7, r7, 4      ;recuperamos el espacio de la pila

bcad_hora: ldb   r5, 0(r4)        
           bz    r5, fin_bcad_hora
           movhi r5, 0x03        ;color rojo
           st    0(r0), r5
           addi  r0, r0, 2
           addi  r4, r4, 1
           bnz   r5, bcad_hora
fin_bcad_hora:
           $MOVEI r5,0x0C3A      ;dos puntos ':' verdes
           st     0(r0), r5
           addi   r0, r0, 2

           $MOVEI r4, cadena_aux ;pone la direccion (puntero) de la cadena auxiliar para el resultado de la conversion
           $PUSH  r4
           $MOVEI r3, d_minutos  ;carga la direccion de memoria donde esta el dato
           ld     r3, 0(r3)          
           $PUSH  r3             ;pone el valor entero a convertir a ASCII
           $CALL  r5, __itoa     ;convierte a ASCII el valor (R5=@ retorno, R7=@pila, retorno resultado por R1)
           addi   r7, r7, 4      ;recuperamos el espacio de la pila

           ;comprobamos si el numero tiene un solo digito y le añadimos el 0 delante
           movi  r1, 9
           cmple r1, r3, r1
           bz    r1, bcad_min
           ;un solo digito
           ldb   r3, 0(r4)
           stb   1(r4),r3
           movi  r3, 48   ; caracter 0
           stb   0(r4),r3
           movi  r3, 0    ; fin de cadena '\0'
           stb   2(r4),r3
bcad_min:  ldb   r5, 0(r4)        
           bz    r5, fin_bcad_min
           movhi r5, 0x03        ;color rojo
           st    0(r0), r5
           addi  r0, r0, 2
           addi  r4, r4, 1
           bnz   r5, bcad_min
fin_bcad_min:
           $MOVEI r5,0x0C3A      ;dos puntos ':' verdes
           st    0(r0), r5
           addi  r0, r0, 2

           $MOVEI r4, cadena_aux ;pone la direccion (puntero) de la cadena auxiliar para el resultado de la conversion
           $PUSH  r4
           $MOVEI r3, d_segundos  ;carga la direccion de memoria donde esta el dato
           ld     r3, 0(r3)          
           $PUSH  r3             ;pone el valor entero a convertir a ASCII
           $CALL  r5, __itoa     ;convierte a ASCII el valor (R5=@ retorno, R7=@pila, retorno resultado por R1)
           addi   r7, r7, 4      ;recuperamos el espacio de la pila

           ;comprobamos si el numero tiene un solo digito y le añadimos el 0 delante
           movi  r1, 9
           cmple r1, r3, r1
           bz    r1, bcad_seg
           ;un solo digito
           ldb   r3, 0(r4)
           stb   1(r4),r3
           movi  r3, 48   ; caracter 0
           stb   0(r4),r3
           movi  r3, 0    ; fin de cadena '\0'
           stb   2(r4),r3
bcad_seg:  ldb   r5, 0(r4)        
           bz    r5, fin_bcad_seg
           movhi r5, 0x03        ;color rojo
           st    0(r0), r5
           addi  r0, r0, 2
           addi  r4, r4, 1
           bnz   r5, bcad_seg
fin_bcad_seg:
           jmp r6    ; retornar de la subrutina



        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Subrutina itoa() - fa la conversió d'un enter a
        ; ASCII, retorna la longitud de la cadena
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; al top de la pila conte el punter a la cadena auxiliar on deixara la conversio
        ; seguidament a la pila conte el valor enter a convertir
        ; r5 conte l'adreça de retorn i r7 el punter a la pila
        ; retorna per r1 la longitud de la cadena convertida (si es igual a 0 ==> error)
__itoa: 
        addi      r7, r7, -32  ;reserva 24 bytes a la pila per variables temporals mes 4 bytes per backup de l'adreça de retorn y el registe R6 Base Pointer (BP) mes 4 bytes per salvar R0 i R2
        st        30(r7), r5
        st        28(r7), r6
        addi      r6, r7, 28   ;actualiza el registre BP
        addi      r7, r7, -4   ;reserva 4 bytes mes per salvar l'estat d'R4 i R3
        st        6(r7), r0
        st        4(r7), r2
        st        2(r7), r3
        st        0(r7), r4

        ;  int neg=0, i, j;
        ;  char tmpstr[10];
        ;  if (in<0) { str[0]='-'; neg=1; in=-in; }
        movi      r1, 0
        st        -6(r6), r1   ;neg=0
        ld        r2, 4(r6)    ;r2=valor enter
        movi      r1, 0
        cmplt     r1, r2, r1  
        bz        r1, __for1
        ld        r1, 6(r6)    ;r1=@cadena_aux
        movi      r2, 45
        stb       0(r1), r2    ;cadena_aux[0]='-' el signe negatiu
        movi      r1, 1
        st        -6(r6), r1   ;neg=1
        ld        r1, 4(r6)    ;r1=valor enter
        not       r1, r1       ;canvi de signe
        addi      r1, r1, 1
        st        4(r6), r1    ;valor=-valor
        ;  for (i=0; in>=10; i++)
        ;    {
        ;      tmpstr[9-i]=(in%10) + '0';
        ;      in/=10;
        ;    }
        ;  tmpstr[9-i] = in + '0';
__for1:
        movi      r1, 0
        st        -4(r6), r1   ;i=0
        $MOVEI r5, __condfor1
        jmp       r5
__cosfor1:
        movi      r2, 9
        ld        r1, -4(r6)   ;r1=i
        sub       r2, r2, r1   ;r2=9-i
        st        -20(r6), r2  ;@aux1=r2
        ld        r3, 4(r6)    ;r3=valor enter
        movi      r1, 10
        div       r5, r3, r1   ;r5=r3/10 (quocient)
        add       r1, r5, r5   ;r1=r5*2
        movi      r2, 2
        sha       r2, r1, r2   ;r2=(r5*4)*2
        add       r1, r1, r2   ;r1=quocient*10  (r1=r5*8+r5*2)
        sub       r1, r3, r1   ;r1=residu modul 10
        movi      r2, 48
        add       r1, r1, r2   ;convertir a carcater ASCII el digit
        addi      r4, r1, 0    ;r4=r1=digit ASCII
        st        4(r6), r5    ;@val=r5 actualitzem el valor enter amb el quocient
        addi      r0, r6, -16  ;inici cadena auxiliar tmpstr
        ld        r3, -20(r6)  ;r3=@aux1=9-i
        add       r1, r0, r3
        stb       0(r1), r4    ;tmpstr[9-i]=digit ASCII
        ld        r1, -4(r6)   ;r1=i
        addi      r1, r1, 1    ;i++
        st        -4(r6), r1
__condfor1:
        ld        r1, 4(r6)    ;r1=i
        movi      r2, 9
        cmple     r1, r1, r2   ;r1<=9?
        $MOVEI    r5, __cosfor1
        jz        r1, r5
        movi      r2, 9
        ld        r1, -4(r6)
        sub       r4, r2, r1
        ld        r1, 4(r6)
        movi      r2, 48
        add       r1, r1, r2
        addi      r0, r1, 0
        addi      r3, r6, -16
        st        -22(r6), r3
        movi      r1, 15
        not       r1, r1
        addi      r1, r1, 1
        sha       r3, r4, r1
        addi      r1, r4, 0
        addi      r2, r3, 0
        ld        r3, -22(r6)
        add       r1, r3, r1
        stb       0(r1), r0
        ;  for(j=neg; j<=i+neg; j++)
        ;    str[j] = tmpstr[9-i+j-neg];
        ;  str[j] = '\0';
        ld        r1, -6(r6)
        st        -2(r6), r1
        movi      r5, 0
        bz        r5, __condfor2
__cosfor2:
        ld        r2, -2(r6)
        ld        r1, 6(r6)
        add       r2, r2, r1
        st        -18(r6), r2
        movi      r2, 9
        ld        r1, -4(r6)
        sub       r2, r2, r1
        ld        r1, -2(r6)
        add       r1, r2, r1
        addi      r2, r1, 0
        ld        r1, -6(r6)
        sub       r4, r2, r1
        addi      r0, r6, -16
        addi      r1, r4, 0
        add       r1, r0, r1
        ldb       r1, 0(r1)
        ld        r2, -18(r6)
        stb       0(r2), r1
        ld        r1, -2(r6)
        addi      r1, r1, 1
        st        -2(r6), r1
__condfor2:
        ld        r2, -4(r6)
        ld        r1, -6(r6)
        add       r2, r2, r1
        ld        r1, -2(r6)
        cmplt     r1, r2, r1
        bz        r1, __cosfor2
        ld        r2, -2(r6)   ;str[j] = '\0';
        ld        r1, 6(r6)
        add       r2, r2, r1
        movi      r1, 0
        stb       0(r2), r1

        ;  return j;
        ld        r1, -2(r6)   ;devolvemos la longitud de la cadena por R1

        ld        r0, 6(r7)    ;recuperamos el estado 
        ld        r2, 4(r7)
        ld        r3, 2(r7)
        ld        r4, 0(r7)
        addi      r7, r6, 0
        ld        r6, 0(r7)
        ld        r5, 2(r7)
        addi      r7, r7, 4
        jmp       r5
