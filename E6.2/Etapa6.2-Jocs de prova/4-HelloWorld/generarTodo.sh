#!/bin/bash


echo "Ensamblando ..."
#compila el ensamblador
sisa-as entrada.s -o entrada.o

echo "Compilando ..."
#compila el c (solo compila)  (para ver el codigo fuente entre el codigo desensamblado hay que compilar con la opcion -O0)
sisa-gcc -g3 -c HelloWorld.c -o HelloWorld.o

echo "Linkando ..."
#Linkamos los ficheros (la opcion -s es para que genere menos comentarios)
sisa-ld -s -T system.lds entrada.o HelloWorld.o -o temp_HelloWorld.o

#desensamblamos el codigo
sisa-objdump -d -z temp_HelloWorld.o >HelloWorld.code

./limpiar.pl codigo HelloWorld.code

#Linkamos los ficheros (sin la opcion -s es para que genere mas comentarios) y desensamblamos
#(para ver el codigo fuente entre el codigo desensamblado hay que haber compilado con la opcion -O0)
sisa-ld -T system.lds entrada.o HelloWorld.o -o temp_HelloWorld.o

sisa-objdump -S -x -w temp_HelloWorld.o >HelloWorld.dis

rm entrada.o HelloWorld.o temp_HelloWorld.o HelloWorld.code
