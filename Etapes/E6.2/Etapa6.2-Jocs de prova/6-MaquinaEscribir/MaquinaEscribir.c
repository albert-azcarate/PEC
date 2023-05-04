
#include "lib_sisa.h"


#define KEY_UP	  0x90
#define KEY_DOWN  0x91
#define KEY_LEFT  0x92
#define KEY_RIGHT 0x93
#define KEY_F1    0x81
#define KEY_F2    0x82
#define KEY_F3    0x83
#define KEY_F4    0x84
#define KEY_F5    0x85
#define KEY_F6    0x86
#define KEY_F7    0x87
#define KEY_F8    0x88
#define KEY_F9 	  0x89
#define KEY_F10   0x8a
#define KEY_ESC   0x1b
#define KEY_ENTER 0x0d


char mensaje1[] = "Pulsa F1-F9 para elegir color. F10 para limpiar la pantalla. ESC para salir";
char mensaje2[] = "Muevete por la pantalla con las teclas de cursor (el cursor NO es visible)";

int main () {

  int long_mensaje1;
  int long_mensaje2;
  int tecla;
  int color;

  int fila_cursor,columna_cursor;
  
  int aux;

  clear();

  long_mensaje1 = strlen_s(mensaje1);
  long_mensaje2 = strlen_s(mensaje2);
  write(0, 0, mensaje1, long_mensaje1, COLOR_WHITE);
  write(1, 0, mensaje2, long_mensaje2, COLOR_GRIS_CLARO);

  tecla='0';
  color=COLOR_WHITE;
  fila_cursor=2;
  columna_cursor=0;

  while (tecla!=KEY_ESC) {

        //muestra por los visores 7 segmentos y los led la posicion actual del cursor "invisible"
        aux=(fila_cursor<<8)+columna_cursor;
        write_7segments(aux, 0x0F);
        write_green_leds(fila_cursor);
        write_red_leds(columna_cursor);
                

        tecla = read_one_bloq();  
        switch (tecla)
        {

        case KEY_UP: 
		if (fila_cursor>2) fila_cursor--;
                break;  

        case KEY_DOWN:
		if (fila_cursor<29) fila_cursor++;
                break;
 
        case KEY_LEFT:
		if (columna_cursor>0) columna_cursor--;
                break;
 
        case KEY_RIGHT:
		if (columna_cursor<79) columna_cursor++;
                break;

        case KEY_ENTER:
                columna_cursor=0;
                if (fila_cursor<29) {
                    fila_cursor++;
                } else {
                    fila_cursor=2;
                }
                break;

        case KEY_F1:
                color=COLOR_RED;
                break;
        case KEY_F2:
                color=COLOR_GREEN;
                break;
        case KEY_F3:
                color=COLOR_YELLOW;
                break;
        case KEY_F4:
                color=COLOR_BLUE;
                break;
        case KEY_F5:
                color=COLOR_MAGENTA;
                break;
        case KEY_F6:
                color=COLOR_CYAN;
                break;
        case KEY_F7:
                color=COLOR_WHITE;
                break;
        case KEY_F8:
                color=COLOR_GRIS_OSCURO;
                break;
        case KEY_F9:
                color=COLOR_GRIS_CLARO;
                break;

        case KEY_F10:
                clear();
                long_mensaje1 = strlen_s(mensaje1);
                long_mensaje2 = strlen_s(mensaje2);
                write(0, 0, mensaje1, long_mensaje1, COLOR_WHITE);
                write(1, 0, mensaje2, long_mensaje2, COLOR_GRIS_CLARO);
                break;

        default:
                write_one_char(fila_cursor, columna_cursor, tecla, color);
                if (columna_cursor<79) {
                    columna_cursor++;
                } else {
                    columna_cursor=0;
                    if (fila_cursor<29) {
                        fila_cursor++;
                    } else {
                        fila_cursor=2;
                    }
                }
                break;
        }
  }
  return 1;
}
