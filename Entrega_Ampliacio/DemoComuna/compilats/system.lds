/*
 *  Canviem l'script per defecte
 *   per adequar-lo a l'arquitectura
 */

  /* 	__entry_point = LOADADDR(.sistema);
  	PROVIDE (__user_start = .);
  	__user_end = __user_start + SIZEOF(.user); */
 
OUTPUT_FORMAT("elf32-sisa","elf32-sisa","elf32-sisa")
OUTPUT_ARCH(sisa)
SECTIONS {
  
  . = 0xc000; /* Sistema CODE */
  .sistema : {
    OS.o(.text)
    OS.o(.rodata) 
    . = ALIGN(2);
  }
  
  . = 0x2000; /* User1 CODE */
  .user1 : {
    corre_letras.o(.text)
    corre_letras.o(.rodata)
    . = ALIGN(2);
  }
  
  . = 0x6000; /* User2 CODE */
  .user2 : {
    fibonacci.o(.text)
    fibonacci.o(.rodata)
    . = ALIGN(2);
  }
  
  . = 0x8000; /* Sistema DATA */
  .sysdata : {  OS.o(.data) }
  
  . = 0x0000; /* User1 DATA */
  .userdata1 : {  corre_letras.o(.data)  }

  . = 0x4000; /* User2 DATA */
  .userdata2 : {  fibonacci.o(.data)  }
  
}
