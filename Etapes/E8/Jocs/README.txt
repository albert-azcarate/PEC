Aquest directori conté els seguents jocs de proves:

	- Joc_de_prova_TLB/TLB_con_script_generar:
		- Joc de prova que comprova el funcionament de les instruccions WRV{I/D}, WRP{I/D}. S'ha modificat
		  la ultima part per carrergar de memoria la posicio 0x0000, que a TLB es 0xC000 i posarho al 7-seg

	- EXC-TLB:
		- Joc que verifica el correcte funcionament de totes les excepcions amb el TLB integrat
		  Per cada excepcio suma 1 a una variable i la mostra pel 7 segments. Un correcte funcionament
		  son 21 excepcions(0x15)

	- INT-TLB:
		- Joc de proves de la etapa 7.2 que mostra per pantalla el nombre de ticks, els pulsadors, PS2 i
		  interruptors. Adaptat per que funcioni amb TLB:
			
			; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=* ;
			; TLBd(1) Pila 								    ;
			; TLBd(2) VGA; En fallada de pagina per la 0xBXXX es modifica el TLBd(2)    ;
			; TLBd(0) Fallades de pagina random                                         ;
			;                                                                           ;
			; TLB instruccions no la toquem                                             ;
			; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=* ;

