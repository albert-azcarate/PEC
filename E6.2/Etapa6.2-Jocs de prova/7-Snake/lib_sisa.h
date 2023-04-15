/**	@file lib_sisa.h
 *
 *  Declaration of the lib_sisa functions, defines and globals
 */

#ifndef LIB_SISA_DEFINED
#define LIB_SISA_DEFINED

#undef  ERR
#define ERR     (-1)

#undef  OK
#define OK      (0)

#ifndef TRUE
  /** Boolean type TRUE - this will make things easier to read */
  #define TRUE  1 
#endif

#ifndef FALSE
  /** Boolean type FALSE - this will make things easier to read */
  #define FALSE 0
#endif


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

#define COLOR_PAIRS 64

/* key "ascii" codes */
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


void initscr(void);
int init_pair(short pair, short f, short b);
int start_color (void);
int COLOR_PAIR(int n);
int use_default_colors(void);
int erase(void);
int refresh(void);
int mvaddch(int y, int x, const char ch);
int mvprintw1(int y, int x, char *cadena);
int mvprintw2(int y, int x, char *cadena, int valor);
int mvprintw3(int y, int x, char *cadena, char valor);
int mvaddstr(int y, int x, char *str);
int has_colors(void);
int attron(int attrs);
int clear(void);
int curs_set(int visibility);

int nodelay(int *win, int bf);
int getch(void);
int usleep(int usec);
void exit(int status);
int rand(void);

#endif
