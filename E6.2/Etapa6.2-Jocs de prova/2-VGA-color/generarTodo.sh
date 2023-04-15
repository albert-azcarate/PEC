#!/bin/bash


echo "Ensamblando ..."
#compila el ensamblador
sisa-as test_vga_basica.s -o test_vga_basica.o

#desensamblamos el codigo
sisa-objdump -d -z test_vga_basica.o > test_vga_basica.code


#a partir del codigo generamos los ficheros fuente con el formato adecuado para poder 
#ser ejecutado con el emulador (.rom) o en las placas DE1 o DE2-115
./limpiar.pl codigo test_vga_basica.code

#desensamblamos
sisa-objdump -x -w test_vga_basica.o >test_vga_basica.dis
sisa-objdump -d -w test_vga_basica.o >>test_vga_basica.dis

rm test_vga_basica.o test_vga_basica.code
