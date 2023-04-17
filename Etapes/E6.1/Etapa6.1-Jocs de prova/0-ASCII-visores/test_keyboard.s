.text

        ; Este test muestra por los dos visores 7 segmentos de mas a la
        ; derecha (HEX1-HEX0) el caracter pseudoASCII que devuelve el
        ; controlador de teclado PS2 correspoindiente a la tecla pulsada. 
        ; Por los dos visores 7 segmentos de la izquierda (HEX3-HEX2)
        ; muestra el numero de veces consecutivas que se ha pulsado esa
        ; tecla.


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



            movi r5,0        ; ponemos un registro a cero para usarlo como contador de repeticiones de una tecla por si se mantiene pulsada
            movi r6,0        ; inicializamos un registro para almacenar la ultima tecla pulsada
bucle:
polling:    in r1,16         ; leemos el estado del teclado
            bz r1,polling    ; esperamos ha que se haya pusado una tecla
            in r1,15         ; leemos el valor correspondiente al caracter ASCII de la tecla pulsada
            out 16,r1        ; hacemos un clear del teclado. Cualquier registro vale ya que el valor del registro no importa

    if1:    cmpeq r7,r1,r6   ; compara si la tecla pulsada es igual a la anterior
            bz r7, else1
            addi r5,r5,1     ; si es igual incrementa el contador de repeticiones
            bnz r7,endif1
    else1:  movi r5,0        ; si es distinta pone el contador de repeticiones a 0
            addi r6,r1,0     ; copiamos la tecla a r6
    endif1:

            ; vamos a crear un valor con los 8 bits de mayor peso con el
            ; valor del contador de repeticiones(r5<7..0>) y los 8 bits de
            ; menor peso con el valor ascii de la tecla (r1<7..0>)

            movi r3,8
            shl r3,r5,r3
            add r3,r3,r1

            ; mostraremos ese valor por el display
            movi r1,0xF
            out 9, r1     ; activa todos los visores
            out 10, r3    ; muestra el valor hexadecimal en los visores

            bnz r1, bucle ; Salta siempre. No hemos usado un jmp o un jal ya que aun no sabemos ensamblar reubicando el codigo a 0xc000

	    halt
