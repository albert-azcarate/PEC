.text
        ; Este test muestra por la pantalla de caracteres (80x30) cada uno
        ; de los caracteres que se van pulsando en el teclado PS2.

        ; Tambien muestra por los visores 7 segmentos la posicion actual del
        ; cursor y en caso que el driver de pantalla tenga cursor lo muestra
        ; activo.

        ; PUERTOS
        ; =======
        ;  5 - IN/OUT - los 8 leds VERDES mapeados en los 8 bits de menor peso del puerto
        ;  6 - IN/OUT - los 8 leds ROJOS mapeados en los 8 bits de menor peso del puerto
        ;  7 - IN     - los 4 pulsadores (KEY) de la placa estan constantemente mapeados en los 4 bits de menor peso del registro del puerto
        ;  8 - IN     - los 8 interruptores (SW) de la placa estan constantemente mapeados en los 8 bits de menor peso del registro del puerto
        ;  9 - IN/OUT - los 4 bits de menor peso del registro indica si el visor correspondiente debe estar encendido o apagado.
        ; 10 - IN/OUT - el valor de los 16 bits del puerto se muestran mediante caracteres hexadecimales el los 4 visores de la placa (HEX3...HEX0)
        ; 11 - OUT    - posicion del cursor en la pantalla de texto (en caso de que lo implemente el controlador de VGA)
        ; 15 - IN     - Valor del caracter ASCII correspondiente a la tecla pulsada
        ; 16 - IN/OUT - Registro de Status para saber si hay una tecla nueva. El controlador del teclado lo pone a 1 para indicar que hay una tecla nueva y nosotros lo ponemos a 0 cuando ya la hemos leido


            movi r7,0x0F         ;enciende todos visores
            out 9, r7

            movi  r0, lo(0xA000)
            movhi r0, hi(0xA000) ;posicion de memoria inicial

            movi r6,0
            out 11, r6           ;cursor en posicion en la posicion 0

bucle3:     out 10, r6           ;muestra el valor por los visores 7 segmentos

polling:    in r1,16             ;leemos el estado del teclado
            bz r1,polling        ;esperamos ha que se haya pusado una tecla
            in r1,15             ;leemos el valor correspondiente al caracter ASCII de la tecla pulsada
            out 16,r1            ;hacemos un clear del teclado. Cualquier registro vale ya que el valor del registro no importa

            movhi r1,0x3f        ;an~adimos el color (0x3f=blanco) a la tecla ascii pulsada

            st 0(r0),r1          ;almacenamos el caracter y su color en la memoria de video (word) para el driver de 80x40

            addi r0,r0,2         ;incrementamos la posicion de memoria para el siguiente carcater
            addi r6,r6,1         ;incrementamos en 1 la posicion del cursor
            movi r7,lo(2399)     ;80*30-1=2399
            movhi r7,hi(2399)
            cmple r7,r6,r7
            bnz r7, act_cursor
            movi  r0, lo(0xA000)
            movhi r0, hi(0xA000) ;posicion de memoria inicial
            movi r6,0            ;cursor en posicion en la posicion 0

act_cursor: out 11, r6
            movi r7,1
            bnz r7, bucle3

            halt
