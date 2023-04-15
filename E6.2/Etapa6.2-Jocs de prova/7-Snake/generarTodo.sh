#!/bin/bash


echo "Ensamblando ..."
#compila el ensamblador
sisa-as entrada.s -o entrada.o

echo "Compilando ..."
#compila el c (solo compila)  (para ver el codigo fuente entre el codigo desensamblado hay que compilar con la opcion -O0)
sisa-gcc -g3 -c  lib_sisa.c -o lib_sisa.o
sisa-gcc -gstabs -c -Wall -Wextra -O2 fruit.c  -o fruit.o
sisa-gcc -gstabs -c -Wall -Wextra -O2 main.c   -o main.o
sisa-gcc -gstabs -c -Wall -Wextra -O2 nsnake.c -o nsnake.o
sisa-gcc -gstabs -c -Wall -Wextra -O2 player.c -o player.o
sisa-gcc -gstabs -c -Wall -Wextra -O2 engine.c -o engine.o -DVERSION=\""1.7"\"
      
echo "Linkando ..."
#Linkamos los ficheros (la opcion -s es para que genere menos comentarios)
sisa-ld -s -T system.lds entrada.o lib_sisa.o fruit.o engine.o nsnake.o player.o main.o -o temp_nsnake.o

#desensamblamos el codigo
sisa-objdump -d -z --section=.sistema temp_nsnake.o >nsnake.code
sisa-objdump -s -z --section=.sysdata temp_nsnake.o >nsnake.data

./limpiar.pl codigo nsnake.code
./limpiar.pl datos nsnake.data

#Linkamos los ficheros (sin la opcion -s es para que genere mas comentarios) y desensamblamos
#(para ver el codigo fuente entre el codigo desensamblado hay que haber compilado con la opcion -O0)
sisa-ld -T system.lds entrada.o lib_sisa.o fruit.o engine.o nsnake.o player.o main.o -o temp_nsnake.o

sisa-objdump -S -x -w --section=.sistema temp_nsnake.o >nsnake.dis
sisa-objdump -S -x -w --section=.sysdata temp_nsnake.o >>nsnake.dis

rm entrada.o lib_sisa.o fruit.o engine.o nsnake.o player.o main.o temp_nsnake.o nsnake.code nsnake.data

