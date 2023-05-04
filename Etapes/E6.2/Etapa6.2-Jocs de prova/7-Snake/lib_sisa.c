
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
      if (car=='\n') {f++; c=0;}
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


/*
 * itoa() - fa la conversió d'un enter a
 * ASCII, retorna la longitud de la cadena
 */
   
int itoa(int in, char *str)
{
  int neg=0, i, j;
  char tmpstr[10];
  if (in<0) { str[0]='-'; neg=1; in=-in; }

  for (i=0; in>=10; i++)
    {
      tmpstr[9-i]=(in%10) + '0';
      in/=10;
    }
  tmpstr[9-i] = in + '0';

  for(j=neg; j<=i+neg; j++)
    str[j] = tmpstr[9-i+j-neg];
  str[j] = '\0';

  return j;
}
                                              


/*

http://www.gnu.org/software/guile-ncurses/manual/html_node/Index.html#Index
http://linux.die.net/man/3/

*/

/*valiables globales para los colores de la pantalla*/
int COLOR_PAIRS_ARRAY[COLOR_PAIRS+1];
int current_color;

/*variables globales para el comportamiento del teclado*/
int no_wait_keyboard; // indica si la lectura del teclado mediante "getch" es bloqueante o no

/*ncurses.h*/
void initscr (void)
{
}

int start_color (void)
{
  return OK;
}

int use_default_colors(void)
{
  return OK;
}

int COLOR_PAIR(int n) 
{
  int color_rgb;
  color_rgb=COLOR_PAIRS_ARRAY[n];
  
  return color_rgb;
}

int init_pair(short pair, short f, short b)
{
  COLOR_PAIRS_ARRAY[pair]=f;  /*solo se asigna el color para la letra. el fondo siempre es negro*/
  return OK;
}

int erase(void)
{
  clear();

  return OK;
}


int refresh(void)
{
  return OK;
}


int mvaddch(int x, int y, const char ch)
{
  write_one_char(x, y, ch, current_color);

  return OK;
}



int mvprintw1(int x, int y, char *cadena)
{
  int long_cadena;

  long_cadena = strlen_s(cadena);

  write(x, y, cadena, long_cadena, current_color);

  return OK;
}


int mvprintw2(int x, int y, char *cadena, int valor)
{
  int long_cadena1;
  int long_cadena2;
  char str_aux[20];

  // muestra por pantalla el texto
  long_cadena1 = strlen_s(cadena);
  write(x, y, cadena, long_cadena1, current_color);

  //convierte el valor (int) en una cadena de caracterres y lo muestra por pantalla a continuacion del texto
  long_cadena2= itoa(valor, str_aux);
  write(x, y+long_cadena1, str_aux, long_cadena2, current_color);

  return OK;
}


int mvprintw3(int x, int y, char *cadena, char valor)
{
  int long_cadena;

  // muestra por pantalla el texto
  long_cadena = strlen_s(cadena);
  write(x, y, cadena, long_cadena, current_color);

  // muestar el caracter a cointinuacion del texto
  write_one_char(x, y+long_cadena, valor, current_color);

  return OK;
}

int mvaddstr(int x, int y, char *str)
{
  mvprintw1(x, y, str);

  return OK;
}


int curs_set(int visibility)
{
  return OK;
}

int has_colors(void)
{
  return TRUE;
}


int attron(int attrs)
{
  current_color=attrs;
  return OK;
}



int nodelay(int *win, int bf)
{
  //* "win" no se usa pero se mentiene para no modificar mucho el codigo fuente del snake
  no_wait_keyboard=bf;
  
  return OK;
}


int getch(void)
{
  int res;

  if (no_wait_keyboard==TRUE) {
	// mirar si hay tecla pulsada y si no devolver un 0
	res=read_one_No_bloq();
  
  } else {
	// si no hay tecla pulsada esperar mediante un bucle a que se pulse una tecla
	res=read_one_bloq();
  }

  return res;
}

int usleep(int msec)
{
  //rutina que se bloquea durante k MILISEGUNDOS. 
  //debido a la implementacion hardware, la unidad de tiempo minima es de 1 milisegundo y 
  //el tiempo maximo de bloqueo es de 2^16=65536milisegundos(65s)

  int aux;
  
//write_7segments(msec, 0xF);
  
  //inicializa el puerto 21 con el numero de milisegundos a esperar y un bucle que se bloquea hasta que el registros ese valga cero.
  __asm__ (
        "out %1,%0\n\t"
        "__esp_milisec: in %2,%1\n\t"
        "bnz %2, __esp_milisec\n\t"
        : /* sin salidas*/
        : "r" (msec),
          "i" (21),       //puerto del contador de milisegundos
          "r" (aux));  
  
  return OK;
}


void exit(int status)
{
}


int rand(void)
{
  // crear un puerto de entrada que se actualize a cada ciclo de reloj
  // y devolver directamente su valor

  int res,aux1,aux2;

__asm__ (  
        "movi  %1, lo(0x7FFF)\n\t" //0x7FFF para hacer una mascara
        "movhi %1, hi(0x7FFF)\n\t"
        "in    %2, %3\n\t"
        "and   %0, %2, %1\n\t"    //devuelve un valor entre 0 y 32767
        : "=r" (res)
        : "r" (aux1),
          "r" (aux2),
          "i" (20));              // Puerto 20=Registro especial para numeros pseudoaleatorios

  return res;
}
