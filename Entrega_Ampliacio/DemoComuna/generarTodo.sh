#!/bin/bash


echo "Ensamblando ..."
#compila el ensamblador
sisa-as OS.s -o OS.o

echo "Compilando ..."
#compila el c (solo compila)  (para ver el codigo fuente entre el codigo desensamblado hay que compilar con la opcion -O0)
sisa-gcc -g3 -O0 -c -Wall corre_letras.c -o corre_letras.o
sisa-gcc -g3 -O0 -c -Wall fibonacci.c -o fibonacci.o
      
echo "Linkando ..."
#Linkamos los ficheros (la opcion -s es para que genere menos comentarios)
sisa-ld -s -T system.lds OS.o corre_letras.o fibonacci.o -o temp_all.o

#desensamblamos el codigo
sisa-objdump -d --section=.sistema temp_all.o > os.code
sisa-objdump -s --section=.sysdata temp_all.o > os.data
sisa-objdump -d --section=.user1 temp_all.o > corre_letras.code
sisa-objdump -s --section=.userdata1 temp_all.o > corre_letras.data
sisa-objdump -d --section=.user2 temp_all.o > fibonacci.code
sisa-objdump -s --section=.userdata2 temp_all.o > fibonacci.data

./limpiar.pl codigo os.code
./limpiar.pl datos os.data
./limpiar.pl codigo corre_letras.code
./limpiar.pl datos corre_letras.data
./limpiar.pl codigo fibonacci.code
./limpiar.pl datos fibonacci.data

#Linkamos los ficheros (sin la opcion -s es para que genere mas comentarios) y desensamblamos
#(para ver el codigo fuente entre el codigo desensamblado hay que haber compilado con la opcion -O0)
sisa-ld -T system.lds OS.o corre_letras.o fibonacci.o -o temp_all.o

sisa-objdump -S -x -w --section=.sistema temp_all.o > os.dis
sisa-objdump -S -x -w --section=.sysdata temp_all.o >> os.dis
sisa-objdump -S -x -w --section=.user1 temp_all.o > corre_letras.dis
sisa-objdump -S -x -w --section=.userdata1 temp_all.o >> corre_letras.dis
sisa-objdump -S -x -w --section=.user2 temp_all.o > fibonacci.dis
sisa-objdump -S -x -w --section=.userdata2 temp_all.o >> fibonacci.dis

rm OS.o corre_letras.o fibonacci.o temp_all.o os.code os.data corre_letras.code corre_letras.data fibonacci.code fibonacci.data *.rom *.DE2-115.hex

