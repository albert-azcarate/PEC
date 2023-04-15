.text

    ; Este test muestra algunos caracters por la pantalla en diversos
    ; colores usando las instrucciones STB y ST indistintamente


    movi  r0, lo(0xA000)
    movhi r0, hi(0xA000) ; posicion inicial de la memoria de video

    ; usando store word  ==> 0xcolor,0xcaracter
    ;    ==> movi r1,0xcaracter
    ;    ==> movhi r1,0xcolor
    ;    ==> st 0(rz),r1

    ; usando store byte
    ;    ==> movi r1,0xcaracter
    ;    ==> stb 0(rz),r1
    ;    ==> movi r1,0xcolor
    ;    ==> stb 1(rz),r1

    ;Muestra en las tres primeras posiciones de pantalla una 'A' roja, seguida de una 'C' verde oscuro y de una 'E' naranja 
    movi r1,65
    stb 0(r0), r1 ;
    movi r1,66
    stb 1(r0), r1 ;
    movi r1,67
    stb 2(r0), r1 ;
    movi r1,68
    stb 3(r0), r1 ;
    movi r1,69
    stb 4(r0), r1 ;
    movi r1,70
    stb 5(r0), r1 ;


    ;Avanzamos hasta la posicion 5 de la pantalla y mostramos los caracteres de la 'A' a la 'E' en diversos colores mediante STB (store_byte)
    addi r0,r0, 10
    movi r1,65
    stb 0(r0), r1 ;
    movi r1,0xff
    stb 1(r0), r1 ;    A blanca
    movi r1,66
    stb 2(r0), r1 ;
    movi r1,0x00
    stb 3(r0), r1 ;    B negra
    movi r1,67
    stb 4(r0), r1 ;
    movi r1,0x03
    stb 5(r0), r1 ;    C roja
    movi r1,68
    stb 6(r0), r1 ;
    movi r1,0x0C
    stb 7(r0), r1 ;    D verde
    movi r1,69
    stb 8(r0), r1 ;
    movi r1,0x30
    stb 9(r0), r1 ;    E azul

    ;Avanzamos hasta la posicion 10 de la pantalla y mostramos los caracteres de la 'F' a la 'J' en diversos colores mediante ST (store_word)
    addi r0,r0, 10
    movi r1,70
    movhi r1,0xff
    st 0(r0), r1 ;    F blanca
    movi r1,71
    movhi r1,0x00
    st 2(r0), r1 ;    G negra
    movi r1,72
    movhi r1,0x03
    st 4(r0), r1 ;    H roja
    movi r1,73
    movhi r1,0x0C
    st 6(r0), r1 ;    I verde
    movi r1,74
    movhi r1,0x30
    st 8(r0), r1 ;    J azul


    ;Avanzamos hasta la posicion 15 de la pantalla y mostramos diversos caracteres en diversos colores que pueden ayudarnos a encontrar errores de little/big-endian
    addi r0,r0, 10

    movi  r1, lo(0x0030) ; caracter '0' negro
    movhi r1, hi(0x0030)
    st 0(r0),r1   ;almacenamos el caracter en la memoria de video (word)
    addi r0,r0,2  ;acualizamos la siguiente direccion de memoria de video

    movi  r1, lo(0x3F30) ; caracter '0' blanco
    movhi r1, hi(0x3F30)
    st 0(r0),r1   ;almacenamos el caracter en la memoria de video (word)
    addi r0,r0,2  ;acualizamos la siguiente direccion de memoria de video

    movi  r1, lo(0x3000) ;incorrecto: 'interrogante video inverso' azul
    movhi r1, hi(0x3000)
    st 0(r0),r1   ;almacenamos el caracter en la memoria de video (word)
    addi r0,r0,2  ;acualizamos la siguiente direccion de memoria de video

    movi  r1, lo(0x303F) ;incorrecto: 'interrogante' azul
    movhi r1, hi(0x303F)
    st 0(r0),r1   ;almacenamos el caracter en la memoria de video (word)
    addi r0,r0,2  ;acualizamos la siguiente direccion de memoria de video

    movi  r1, lo(0x3541) ; caracter 'A' lila
    movhi r1, hi(0x3541)
    st 0(r0),r1   ;almacenamos el caracter en la memoria de video (word)
    addi r0,r0,2  ;acualizamos la siguiente direccion de memoria de video

    movi  r1, lo(0x3A41) ; caracter 'A' azul claro
    movhi r1, hi(0x3A41)
    st 0(r0),r1   ;almacenamos el caracter en la memoria de video (word)
    addi r0,r0,2  ;acualizamos la siguiente direccion de memoria de video

    movi  r1, lo(0x4135) ; caracter '5' rojo
    movhi r1, hi(0x4135)
    st 0(r0),r1   ;almacenamos el caracter en la memoria de video (word)
    addi r0,r0,2  ;acualizamos la siguiente direccion de memoria de video

    movi  r1, lo(0x413A) ; incorrecto: ':' rojo
    movhi r1, hi(0x413A)
    st 0(r0),r1   ;almacenamos el caracter en la memoria de video (word)
    addi r0,r0,2  ;acualizamos la siguiente direccion de memoria de video

    halt
