
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
                        

int main () {
    int valor;

    valor=0x3F48;     		/* H mayuscula en blanco */
    write_one(1,5,valor); 	/* escribe el caracter en la posicion fila=1,columna=5 */
    valor=0x0365;     		/* e minuscula en rojo */
    write_one(1,6,valor); 	/* escribe el caracter en la posicion fila=1,columna=6 */
    valor=0x0C6C;     		/* l minuscula en verde */
    write_one(1,7,valor); 	/* escribe el caracter en la posicion fila=1,columna=7 */
    valor=0x306C;     		/* l minuscula en azul */
    write_one(1,8,valor); 	/* escribe el caracter en la posicion fila=1,columna=8 */
    valor=0x156F;     		/* o minuscula en gris oscuro */
    write_one(1,9,valor); 	/* escribe el caracter en la posicion fila=1,columna=9 */


    valor=0x3C57;     		/* W mayuscula en azul cielo */
    write_one(1,11,valor); 	/* escribe el caracter en la posicion fila=1,columna=11 */
    valor=0x0F6F;     		/* o minuscula en amarillo */
    write_one(1,12,valor); 	/* escribe el caracter en la posicion fila=1,columna=12 */
    valor=0x3372;     		/* r minuscula en lila */
    write_one(1,13,valor); 	/* escribe el caracter en la posicion fila=1,columna=13 */
    valor=0x2A6C;     		/* l minuscula en gris claro */
    write_one(1,14,valor); 	/* escribe el caracter en la posicion fila=1,columna=14 */
    valor=0x3F64;     		/* d minuscula en blanco */
    write_one(1,15,valor); 	/* escribe el caracter en la posicion fila=1,columna=15 */

    return valor;
}
