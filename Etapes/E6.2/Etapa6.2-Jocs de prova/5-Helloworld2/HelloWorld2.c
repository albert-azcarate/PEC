
int write_one(int fila, int col, int c)
{
  int res;
  int pos;

  pos=(80*fila+col)*2;    // cada caracter ocupa 2 bytes de memoria de video
  pos = pos + 0xA000;	  // la memoria de video empieza en la direccion 0xA000 (40960)

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


int strlen_s(char *str)
{
  int len;
  for (len = 0; *str++; len++);
  return len;
}


#define BLANCO 		0x3F
#define ROJO		0x03
#define VERDE		0x0C
#define AZUL		0x30
#define GRIS_OSCURO	0x15
#define AZUL_CIELO	0x3C
#define AMARILLO	0x0F
#define LILA		0x2A
#define GRIS_CLARO	0x3F


char mensaje1[] = "Hello World.";
char mensaje2[] = "Hola Mon. Benvinguts al primer programa en C que te seccio de dades.";
char mensaje3[] = "Hola Mundo. Bienvenidos al primer programa en C que tiene seccion de datos.";

int main () {
  int long_mensaje1;
  int long_mensaje2;
  int long_mensaje3;

  long_mensaje1 = strlen_s(mensaje1);
  long_mensaje2 = strlen_s(mensaje2);
  long_mensaje3 = strlen_s(mensaje3);

  write(0,  0, mensaje1, long_mensaje1, BLANCO);
  write(1,  3, mensaje2, long_mensaje2, ROJO);
  write(2,  6, mensaje3, long_mensaje3, VERDE);
  write(3,  9, mensaje1, long_mensaje1, AZUL);
  write(4, 12, mensaje2, long_mensaje2, GRIS_OSCURO);
  write(5, 15, mensaje3, long_mensaje3, AZUL_CIELO);
  write(6, 18, mensaje1, long_mensaje1, AMARILLO);
  write(7, 21, mensaje2, long_mensaje2, LILA);
  write(8, 24, mensaje3, long_mensaje3, GRIS_CLARO);

  return 1;
}
