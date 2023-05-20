El joc de proves per a fer una prova de la TLB fa servir una directiva ".org 0x1000" que fa que s'ompli un espai de 4KB del codi amb el valor 0.

Per facilitar la lectura del codi desensamblat, aquest codi que val 0 s'acostuma a substituir per tres punts suspensius. Per tant, el script que es fa servir per generar el fitxers per a la placa i per al Modelsim no acaba de funcionar ja que parteix d'un codi al que li falta un fragment. Per solucionar això només cal afegir la opció "-z" o "--disassemble-zeroes" a la comanda sisa-objdump que hi ha dins del fitxer generar.sh

En el directori "TLB_con_script_generar" del fitxer adjunt teniu una versió arreglada del fitxer generar.sh.


I ha un mètode alternatiu de per obtenir el fitxer necessari per al Modelsim fent servir la comanda hexdump. Les comandes necessàries per generar els fitxers són les següents:

$> sisa-as TLB.s -o TLB.o
$> sisa-ld -Ttext=0xC000 TLB.o -o TLB.exe

Un cop compilat cal obtenir del fitxer executable on comença el codi i quina és la seva longitud. La comanda que ens ho mostra és la següent:

$> sisa-objdump -h -w TLB.exe

Per a aquest exemple del TLB, podem veure que Size=0x00001034 i que File off=0x00000054

Per obtenir el fitxer "TLB.rom" cal executar la següent comanda posant l'inici i la longitud en valors decimals (0x54=84, 0x1034=4148).

$> hexdump -v -s 84 -n 4148 -e '/2 "%04X\n"' TLB.exe >TLB.rom
