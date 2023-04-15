#!/bin/bash


echo "Ensamblando ..."
#compila el ensamblador
sisa-as test_vga_mini.s -o test_vga_mini.o

#desensamblamos el codigo
sisa-objdump -d -z test_vga_mini.o > test_vga_mini.code


#a partir del codigo generamos los ficheros fuente con el formato adecuado para poder 
#ser ejecutado con el emulador (.rom) o en las placas DE1 o DE2-115
./limpiar.pl codigo test_vga_mini.code

#desensamblamos
sisa-objdump -x -w test_vga_mini.o >test_vga_mini.dis
sisa-objdump -d -w test_vga_mini.o >>test_vga_mini.dis

rm test_vga_mini.o test_vga_mini.code
