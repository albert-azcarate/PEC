.text
        ; Este test rellena completamente la pantalla de caracteres (80x30)
        ; mostrando el repertorio de los 256 caracteres ASCII en varios
        ; colores (de los 64 disponibles)

        ; Tambien muestra por los visores 7 segmentos las cordenadas
        ; fila/columna de la pantalla en las que esta pintando cada caracter
        ; (util si la frecuencia de reloj es baja)

        ; PUERTOS
        ; =======
        ;  5 - IN/OUT - los 8 leds VERDES mapeados en los 8 bits de menor peso del puerto
        ;  6 - IN/OUT - los 8 leds ROJOS mapeados en los 8 bits de menor peso del puerto
        ;  7 - IN     - los 4 pulsadores (KEY) de la placa estan constantemente mapeados en los 4 bits de menor peso del registro del puerto
        ;  8 - IN     - los 8 interruptores (SW) de la placa estan constantemente mapeados en los 8 bits de menor peso del registro del puerto
        ;  9 - IN/OUT - los 4 bits de menor peso del registro indica si el visor correspondiente debe estar encendido o apagado.
        ; 10 - IN/OUT - el valor de los 16 bits del puerto se muestran mediante caracteres hexadecimales el los 4 visores de la placa (HEX3...HEX0)
        ; 15 - IN     - Valor del caracter ASCII correspondiente a la tecla pulsada
        ; 16 - IN/OUT - Registro de Status para saber si hay una tecla nueva. El controlador del teclado lo pone a 1 para indicar que hay una tecla nueva y nosotros lo ponemos a 0 cuando ya la hemos leido


        movi r7,0x0F   ; enciende todos visores
        out 9, r7

        movi  r0, lo(0xA000)
        movhi r0, hi(0xA000) ; posicion inicial de la memoria de video

        movi r1,0      ;fila
        movi r3,48     ;ASCII del caracter '0'. Es el primer carcater que mostraremos
        movi r5,0      ;color del carcater desde 0 hasta 63 (0x00 hasta 0x3F). El 0 es el negro

bvga1:  movi r2,0      ;columna

bvga2:  movi r7,0x8
        shl r7,r1,r7   ;pone en los 8 bits de mayor peso el valor de la fila
        or r7,r7,r2    ;pone en los 8 bits de menor peso el valor de la columna
        out 10, r7     ;muestra el valor por los visores 7 segmentos

        movi r7,80     ;calculamos la direccion de pantalla 0xA000+fila*80+columna
        mul r4,r1,r7   ;fila*80
        add r4,r4,r2   ;fila*80+columna

        movi r7,8
        shl r7,r5,r7   ;ponemos el color el los 8 bits de mayor peso
        add r7,r3,r7   ;copiamos el caracter ascii que està en r3 a r7 en los 8 bits de menor peso
        out 10, r7     ;muestra el valor por los visores 7 segmentos

        add r4,r4,r4   ;multiplicamos por 2 si el aceso a memoria de video es de word
        add r4,r4,r0   ;0xA000+fila*80+columna
        st 0(r4),r7    ;almacenamos el caracter y su color en la memoria de video (word) para el driver de 80x40
        addi r3,r3,1   ;mostraremos el siguiente caracter ASCII a cada incremento de columna

        addi r5,r5,1   ;mostraremos el siguiente color disponible
        movi r7,64
        cmplt r7,r5,r7 ;miramos si el color ha llegado a 63
        bnz r7, inccol
        movi r5,0      ;color del carcater desde 0 hasta 63 (0x00 hasta 0x3F)

inccol: addi r2,r2,1   ;columna++
        movi r7,80
        cmplt r7,r2,r7 ;miramos si la columna ha llegado a 80
        bnz r7, bvga2

incfil: addi r1,r1,1   ;fila++
        movi r7,30
        cmplt r7,r1,r7 ;miramos si la fila ha llegado a 30
        bnz r7, bvga1

        halt
