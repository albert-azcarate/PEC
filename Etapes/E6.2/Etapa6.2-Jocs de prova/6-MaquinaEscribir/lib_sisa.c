
#include "lib_sisa.h"


int write_one(int fila, int col, int c)
{
  int res;
  int pos;

  /* para DEBUG:muestra por el visor 7segmentos la fila i la columna de la pantalla
  int aux;
  aux=(fila<<8)+col;
  write_7segments(aux, 0x0F);
  */

  pos=(80*fila+col)*2;   // cada caracter ocupa 2 bytes de memoria de video
  pos = pos + 0xA000;	// la memoria de video empieza en la direccion 0xA000 (40960)

  // para DEBUG: muestra por el visor 7segmentos la direccion de memoria de video en la que se va a escribir el caracter
  //write_7segments(pos, 0x0F);

  __asm__ (
      "st 0(%0), %1"      // %0 corresponde a la variable "pos" que habra sido cargada en un registro
                          // %1 corresponde a la variable "c" que habra sido cargada en otro registro
      : /* sin salidas */
      : "a" (pos), "b" (c));  

  res=1;
  return res;
}
                        
int write_one_char(int fila, int col, char c, char color)
{
  int res;
  int caracter_compuesto;

  caracter_compuesto=color*256+c;
  res=write_one(fila, col, caracter_compuesto);

  return res;
}
                        

int write(int fila, int col, char *buf, int size, char color)
{
  int i, r, t;
  int f, c, car;
  t = 0; f = fila; c = col;
  for (i=0; i<size; i++)   
    {
      car = buf[i];
      do
        {
          r=write_one_char(f, c, car, color);
        }
      /* Un altre procés està enviant */
      while (r!=1); t+=r;
      if (car=='\n') f++;
      else if (car=='\r') c=1;
      else if (car!=0) c++;   
    }

  return t;
}

int read_one_No_bloq (void)
{
  int res;

	/*
		in r1,16         ; leemos el estado del teclado
		bz r1,fin	 ; si no se ha pulsado ninguna tecla salimos de la espera
	        in r1,15         ; leemos el valor correspondiente al caracter ASCII de la tecla pulsada
        	out 16,r1        ; hacemos un clear del teclado. Cualquier registro vale ya que el valor del registro no importa
	   fin:
	*/

  __asm__ (
	"in %0, %1\n\t"
	"bz %0, __fin\n\t"    // avanzamos 2 instrucciones
	"in %0, %2\n\t"
	"out %1, %0\n\t"
	"__fin:"
 	: "=r" (res)
 	: "i" (16),           // Puerto 16=Status teclado
          "i" (15));          // Puerto 15=ASCII tecla
  return res;
}


int read_one_bloq (void)
{
  int res;

	/*
	polling:    in r1,16         ; leemos el estado del teclado
        	    bz r1,polling    ; esperamos ha que se haya pulsado una tecla
	            in r1,15         ; leemos el valor correspondiente al caracter ASCII de la tecla pulsada
        	    out 16,r1        ; hacemos un clear del teclado. Cualquier registro vale ya que el valor del registro no importa
	*/

  __asm__ (
	"__pol: in %0, %1\n\t"
	"bz %0, __pol\n\t"    // retorcedemos 2 instrucciones
	"in %0, %2\n\t"
	"out %1, %0\n\t"
 	: "=r" (res)
 	: "i" (16),           // Puerto 16=Status teclado
          "i" (15));          // Puerto 15=ASCII tecla

  return res;
}



int write_7segments(int valor, char control)
{
  int res;

  __asm__ (
	"out %0, %1\n\t"      // apagamos/endendemos los visores
	"out %2, %3\n\t"      // mostramos el valor
	: /* sin salidas*/
 	: "i" (9),            // Puerto 9=Control visores
	  "r" (control),
          "i" (10),  	      // Puerto 10=Valor visores
	  "r" (valor));

  return res;
}


int write_green_leds(char c)
{
  int res;

  __asm__ ( "out %0, %1" 
            : /* sin salidas*/
            : "i" (5), "r" (c));    // %0 corresponde al puerto 5 (leds verdes),  %1 corresponde a la variable "c" que habra sido cargada en otro registro

  return res;
}
                   
                   
int write_red_leds(char c)
{
  int res;

  __asm__ ( "out %0, %1" 
            : /* sin salidas*/
            : "i" (6), "r" (c));     // %0 corresponde al puerto 6 (leds rojos),  %1 corresponde a la variable "c" que habra sido cargada en otro registro

  return res;
}




int strlen_s(char *str)
{
  int len;
  for (len = 0; *str++; len++);
  return len;
}



int clear(void)
{
 // En c es muy lento

/*  int fila, col;
  char car;
  char color;
  
  car=' ';		//espacio en blanco
  color=COLOR_BLACK;	//color negro
  car='.';
  color=COLOR_GRIS_OSCURO; //util para debugar
  
  for (fila=0; fila<FIXED_HEIGHT; fila++) {
    for (col=0; col<FIXED_WIDTH; col++) {
          write_one_char(fila, col, car, color);
    }  
  }   
*/


  //mejor hacerlo en ensamblador por rapidez

  int aux1, aux2, aux3;

__asm__ (  
        "movi  %0, lo(0xA000)\n\t"   //0xA000 direccion de inicio de la memoria de video
        "movhi %0, hi(0xA000)\n\t"
        "movi  %1, lo(2400)\n\t"     //(80*30=2400=0x0960) numero caracteres de la pantalla
        "movhi %1, hi(2400)\n\t"
        //"movi  %2, lo(0x152E)\n\t"
        //"movhi %2, hi(0x152E)\n\t"   //un punto gris oscuro util para debugar
        "movi  %2, lo(0x0020)\n\t"
        "movhi %2, hi(0x0020)\n\t"   //un espacio en color negro
        "__repe: st 0(%0), %2\n\t"
        "addi  %0, %0,2\n\t"
        "addi  %1, %1,-1\n\t"
        "bnz   %1, __repe\n\t"
        : /* sin salidas*/
        : "r" (aux1),
          "r" (aux2),
          "r" (aux3));  

  return OK;
}
