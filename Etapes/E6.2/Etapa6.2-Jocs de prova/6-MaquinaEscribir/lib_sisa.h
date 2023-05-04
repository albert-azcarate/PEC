/**    @file lib_sisa.h
 *
 *  Declaration of the lib_sisa functions, defines and globals
 */

#ifndef LIB_SISA_DEFINED
#define LIB_SISA_DEFINED

#undef  ERR
#define ERR     (-1)

#undef  OK
#define OK      (0)

/* *medidas de la pantalla en modo texto* */
#define FIXED_WIDTH   80
#define FIXED_HEIGHT  30

/* colors */
#define COLOR_BLACK     0x00  //NEGRO
#define COLOR_RED       0x03  //ROJO    
#define COLOR_GREEN     0x0C  //VERDE
#define COLOR_BLUE      0x30  //AZUL
#define COLOR_YELLOW    0x0F  //AMARILLO
#define COLOR_MAGENTA   0x33  //LILA 
#define COLOR_CYAN      0x3C  //AZUL_CIELO
#define COLOR_WHITE     0x3F  //BLANCO

#define COLOR_GRIS_OSCURO     0x15
#define COLOR_GRIS_CLARO      0x2A


int write_one(int fila, int col, int c);
int write_one_char(int fila, int col, char c, char color);
int write(int fila, int col, char *buf, int size, char color);
int read_one_No_bloq (void);
int read_one_bloq (void);
int write_7segments(int valor, char control);
int write_green_leds(char c);
int write_red_leds(char c);


int strlen_s(char *str);
int clear(void);

#endif
