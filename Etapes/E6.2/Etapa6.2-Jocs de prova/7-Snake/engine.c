/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\
 * nSnake - The classic snake game with ncurses.                              *
 * Copyright (C) 2011-2012  Alexandre Dantas (kure)                           *
 *                                                                            *
 * This file is part of nSnake.                                               *
 *                                                                            *
 * nSnake is free software: you can redistribute it and/or modify             *
 * it under the terms of the GNU General Public License as published by       *
 * the Free Software Foundation, either version 3 of the License, or          *
 * any later version.                                                         *
 *                                                                            *
 * This program is distributed in the hope that it will be useful,            *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of             *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
 * GNU General Public License for more details.                               *
 *                                                                            *
 * You should have received a copy of the GNU General Public License          *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.      *
 *                                                                            *
 * homepage: http://sourceforge.net/projects/nsnake/                          *
 *                                                                            *
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/** @file engine.c
 *
 *	Definition of the graphical engine functions
 *
 *	This file presents the nCurses specifical implementation of the game`s
 * 	graphics.
 */


/*
#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>  // for the usleep () function
*/

#include "engine.h"
#include "lib_sisa.h"
#include "fruit.h"
#include "player.h"

/** The separate Highscore for the game mode with borders */
int HIGH_SCORE_BORDERS = 5000;

/** The separate Highscore for the game mode without borders */
int HIGH_SCORE_BORDERS_OFF = 5000;



int *stdscr; // no se usa en el sisa


/** This formula determines a time (in microseconds) the game must wait
 *  between each screen refresh. It is based on the current game level,
 *  so the higher its value, the lowest is the delay and faster the game
 *  will appear to be.
 *
 *  @note 1,000,000 microseconds == 1 second
 */
//#define   REFRESH_DELAY     (20000 + ((9 - game.level) * 25000))
//para el SISA hay que calcular el numero de milisegundos y no el de microsegundos ya que los valores (de 16 bits) no pueden almacenar valores tan grandes
#define   REFRESH_DELAY     (20 + ((9 - game.level) * 25))



static char PLAYER_HEAD_CHAR = '@'; ///< The 'image' of the snake head
static char PLAYER_CHAR	     = 'o'; ///< The 'image' of the snake body
static char FRUIT_CHAR	     = '$'; ///< The 'image' of the fruit
static char BORDER_CHAR	     = '#'; ///< The 'image' of the border in normal mode
static char NO_BORDER_CHAR 	 = '.'; ///< The 'image' of the border in teleport mode
static char MENU_BORDER_CHAR = '*'; ///< The 'image' of the border in the main menu



/** Simple enum to make the colors easier to read: FOREGROUND_BACKGROUND */
enum Colors { BLACK_WHITE = 1, CYAN_BLACK, BLUE_BLACK,
              WHITE_BLACK, GREEN_BLACK, RED_BLACK,  };



struct screen_t screen;



/**	Just erases everything to black
 */
void draw_background ()
{
	/* clear(); */
	erase();
}


/**	Draws the window border, according to the game.mode.
 */
void draw_borders ()
{
	int i;

	start_atrribute (COLOR_PAIR (WHITE_BLACK));
	if (game.mode == BORDERS_ON)
	{
		for (i = 0; i <= (screen.width-1); i++)	//upper
		{
			mvaddch (1, i, BORDER_CHAR);
			mvaddch ((screen.height-1), i, BORDER_CHAR);
		}
		for (i = 1; i <= (screen.height-1); i++)	//lower
		{
			mvaddch (i, 0, BORDER_CHAR);
			mvaddch (i, (screen.width-1), BORDER_CHAR);
		}
	}
	else if (game.mode == BORDERS_OFF)
	{
		for (i = 0; i <= (screen.width-1); i++)
		{
			mvaddch (1, i, NO_BORDER_CHAR);
			mvaddch ((screen.height-1), i, NO_BORDER_CHAR);
		}
		for (i = 1; i <= (screen.height-1); i++)
		{
			mvaddch (i, 0, NO_BORDER_CHAR);
			mvaddch (i, (screen.width-1), NO_BORDER_CHAR);
		}
	}
}


/**	Draws the current fruit on screen
 */
void draw_fruit ()
{
	start_atrribute (COLOR_PAIR (CYAN_BLACK));
	mvaddch (fruit.y, fruit.x, FRUIT_CHAR);
}


/**	Draws the bonus value of the current fruit
 */
void draw_fruit_bonus ()
{
	start_atrribute (COLOR_PAIR (WHITE_BLACK));
	mvprintw2 (0, (screen.width-1)/2, "Bonus: ", fruit.bonus);
}


/**	Draws the snake - from the head to the whole body
*/
void draw_player ()
{
	start_atrribute (COLOR_PAIR (GREEN_BLACK));
	mvaddch (snake.body[0].y, snake.body[0].x, PLAYER_HEAD_CHAR);

	int i;
	for (i = 1; i < snake.size; i++)
		mvaddch (snake.body[i].y, snake.body[i].x, PLAYER_CHAR);
}


/**	Prints the current score
 */
void draw_score ()
{
	start_atrribute (COLOR_PAIR (CYAN_BLACK));
	mvprintw1 (0, 0, "nSnake v");
	mvprintw1 (0, 9, VERSION);

	start_atrribute (COLOR_PAIR (WHITE_BLACK));
	mvprintw2 (0, 17, "Lv", game.level);
	mvprintw2 (0, 23, "Score: ", snake.score);

	if (game.mode == BORDERS_ON)
		mvprintw2 (0, 60, "High Score: ", HIGH_SCORE_BORDERS);
	else if (game.mode == BORDERS_OFF)
		mvprintw2 (0, 60, "High Score: ", HIGH_SCORE_BORDERS_OFF);
}


/**	Exits and dealocates the memory required by ncurses.
 */
void engine_exit ()
{
	/* clear (); */
	erase();
	refresh ();
}


/**	Get the user input during game and make the right decisions
 */
int engine_get_game_input ()
{
	// The input variable MUST be int to accept non-ascii characters
	return getch ();
}


/**	Starts the game engine. Initializes all the stuff related to ncurses.
 *
 *  @note If some engine-specific initialization fails, the game aborts.
 */
void engine_init ()
{
	screen.width  = FIXED_WIDTH;
	screen.height = FIXED_HEIGHT;

	initscr (); // Starts the ncurses mode

	if (has_colors () == TRUE)
	{
		int bg_color;

		start_color (); // Start color support

		// Let's try grabbing the current terminal background color
		if (use_default_colors () == ERR)
			bg_color = COLOR_BLACK;
		else
			bg_color = -1;

		// Start support for colors (Name, Foreground, Background)
		init_pair (GREEN_BLACK, COLOR_GREEN, bg_color);
		init_pair (CYAN_BLACK,  COLOR_CYAN,  bg_color);
		init_pair (WHITE_BLACK, COLOR_WHITE, bg_color);
		init_pair (RED_BLACK,   COLOR_RED,   bg_color);
		init_pair (BLUE_BLACK,  COLOR_BLUE,  bg_color);
		init_pair (BLACK_WHITE, COLOR_BLACK, bg_color);
	}

	/// @todo There must have a game init function or something
	///       where i could put this
	game.mode = BORDERS_ON;
}


/**	Draws the Game Over screen.
 *
 *	Besides drawing 'Game Over', it highlights where the player died.
 */
void engine_show_game_over ()
{
	start_atrribute (COLOR_PAIR (RED_BLACK));
	mvaddch (snake.body[0].y, snake.body[0].x, 'x');

	mvprintw1(3, 22, " _______  _______  __   __  _______ ");
        mvprintw1(4, 22, "|       ||   _   ||  |_|  ||       |");
        mvprintw1(5, 22, "|    ___||  |_|  ||       ||    ___|");
        mvprintw1(6, 22, "|   | __ |       ||       ||   |___ ");
        mvprintw1(7, 22, "|   ||  ||       ||       ||    ___|");
        mvprintw1(8, 22, "|   |_| ||   _   || ||_|| ||   |___ ");
        mvprintw1(9, 22, "|_______||__| |__||_|   |_||_______|");
        mvprintw1(10, 22, " _______  __   __  _______  ______  ");
        mvprintw1(11, 22, "|       ||  | |  ||       ||    _ | ");
        mvprintw1(12, 22, "|   _   ||  |_|  ||    ___||   | || ");
        mvprintw1(13, 22, "|  | |  ||       ||   |___ |   |_|| ");
        mvprintw1(14, 22, "|  |_|  ||       ||    ___||    __ |");
        mvprintw1(15, 22, "|       | |     | |   |___ |   |  ||");
        mvprintw1(16, 22, "|_______|  |___|  |_______||___|  ||");
        mvprintw1(17, 22, " Press <space> or <enter> to retry");
        mvprintw1(18, 22, "          <m> to Main Menu");


	draw_score ();
	refresh ();
	nodelay (stdscr, FALSE);
}

void engine_clean_game_over ()
{
	nodelay (stdscr, TRUE);
}

/**	Displays the main menu and gets the user input from it.
 *
 *  This function blocks the game execution and waits for user input,
 *  refreshing the main menu screen according to the options selected.
 */
void engine_show_main_menu ()
{
	int  speed_cur_option     = 1;
	char speed_cur_options[9] = {'1', '2', '3', '4', '5', '6', '7', '8', '9'};

	int menu_row_pos   = 13;
	int option_row_pos = menu_row_pos + 17;

	int wait = TRUE;
	int i;
	int j;

	clear ();

	while (wait == TRUE)
	{
		// The borders
		start_atrribute (COLOR_PAIR (WHITE_BLACK));
		for (i = 0; i < screen.width; i++)
		{
			mvaddch (0, i, MENU_BORDER_CHAR);
			mvaddch (screen.height - 1, i, MENU_BORDER_CHAR);
		}
		for (i = 0; i < screen.height; i++)
		{
			mvaddch (i, 0, MENU_BORDER_CHAR);
			mvaddch (i, screen.width - 1, MENU_BORDER_CHAR);
		}

		start_atrribute (COLOR_PAIR (GREEN_BLACK));
		mvprintw1(1, 3,  "         ,d8888b.                     888");
		mvprintw1(2, 3,  "        d88P  Y88b                    888");
		mvprintw1(3, 3,  "         Y88b.                        888");
		mvprintw1(4, 3,  "88888b.   Y888b.    88888b.    8888b. 888  888  .d88b.");
		mvprintw1(5, 3,  "888  88b     8Y88b. 888  88b      88b 888 .88P d8P  Y8b");
		mvprintw1(6, 3,  "888  888       888b 888  888 .d888888 888888K  88888888");
		mvprintw1(7, 3,  "888  888 Y88b  d88P 888  888 888  888 888  88b Y8b.");
		mvprintw1(8, 3,  "888  888   Y8888P   888  888  Y888888 888  888  Y88888");

		start_atrribute (COLOR_PAIR (CYAN_BLACK));
		mvaddch (8, 59, 'v');
		mvprintw1 (8, 60, VERSION);

		start_atrribute (COLOR_PAIR (BLUE_BLACK));
		mvprintw1 (10, 5, " ___________________________________________________ ");
		mvprintw1 (11, 5, "|                                                   |");
		mvprintw1 (12, 5, "|                                                   |");
		mvprintw1 (13, 5, "|                                                   |");
		mvprintw1 (14, 5, "|                                                   |");
		mvprintw1 (15, 5, "|                                                   |");
		mvprintw1 (16, 5, "|                                                   |");
		mvprintw1 (17, 5, "|                                                   |");
		mvprintw1 (18, 5, "|                                                   |");
		mvprintw1 (19, 5, "|___________________________________________________|");
		mvprintw1 (12, menu_row_pos, "Press <enter> or <space> to start game");
		mvprintw1 (13, menu_row_pos, "Press <q> to quit game");

		// Here we draw the game mode
		mvprintw1 (15, menu_row_pos, "Game Mode:");
		if (game.mode == BORDERS_ON)
		{
			start_atrribute (COLOR_PAIR (WHITE_BLACK));
			mvprintw1 (15, option_row_pos, "Borders On");

			start_atrribute (COLOR_PAIR (BLUE_BLACK));
			mvprintw1 (16, option_row_pos, "Borders Off");
		}
		else
		{
			start_atrribute (COLOR_PAIR (BLUE_BLACK));
			mvprintw1 (15, option_row_pos, "Borders On");

			start_atrribute (COLOR_PAIR (WHITE_BLACK));
			mvprintw1 (16, option_row_pos, "Borders Off");
		}

		// And here we draw the level numbers
		start_atrribute (COLOR_PAIR (BLUE_BLACK));
		mvprintw1 (18, menu_row_pos, "Starting speed:");

		// Tricky, draw the options with the right colors
		for (i = 0, j = 0; i < 9; i++)
		{
			if (i == (speed_cur_option-1))
				start_atrribute (COLOR_PAIR (WHITE_BLACK));
			else
				start_atrribute (COLOR_PAIR (BLUE_BLACK));

			mvprintw3 (18, option_row_pos+j, "", speed_cur_options [i]);
			j += 2;
		}

		start_atrribute (COLOR_PAIR (WHITE_BLACK));

		// Now we wait for orders
		wait = get_main_menu_input (&speed_cur_option);

		// This function is so refreshing...
		refresh ();
	}

	game.level = speed_cur_option;
}


/**	Prints the pause message
 */
void engine_show_pause ()
{
	curs_set (1); // Makes the cursor visible
	nodelay (stdscr, FALSE); // We'll wait for input again

	start_atrribute (COLOR_PAIR (RED_BLACK));

	mvprintw1 ((screen.height-1)/2, ((screen.width-1)/2)-5, "Game Paused ");
	mvprintw1 (((screen.height-1)/2)+1, ((screen.width-1)/2)-11, "Press <p> to Continue...");
}


/**	Completely draws the screen during game.
 *
 * 	The usleep() function interrupts the program for 'n' microseconds.
 * 	It was difficult to get a stable value for the game progression.
 *
 *	@note This is the main function of this file because it shows
 * 	      logically how the process of drawing the screen sould be
 */
void engine_show_screen ()
{
	draw_background ();
	draw_borders ();
	draw_fruit ();
	draw_player ();
	draw_fruit_bonus();
	draw_score ();

	usleep (REFRESH_DELAY);

	refresh();
}


/**	Waits for an user action during the 'Game Over' screen
 */
void get_game_over_input ()
{
	int wait = TRUE;

	nodelay (stdscr, FALSE);
	while (wait == TRUE)
	{
		int input = getch();

		switch (input)
		{
		case 'q':	case 'Q':
			engine_exit ();
			nsnake_exit ();
			break;

		case 'm':	case 'M':
			wait = FALSE;
			engine_show_main_menu ();

		case ' ':
		case '\r':
		case '\n':
			wait = FALSE;
			break;

		default:
			break;
		}
	}
	nodelay (stdscr, TRUE);
}


/**	Gets the input for the main menu.
 */
int get_main_menu_input (int* speed_cur_option)
{
	nodelay (stdscr, FALSE);

	int input = getch();
	switch (input)
	{
	case '\n':	case ' ':      case '\r':
		nodelay (stdscr, TRUE);
		return FALSE;
		break;

	case 'q':	case 'Q':
		engine_exit();
		nsnake_exit();
		break;

	case KEY_UP: case 'k':
		if (game.mode == BORDERS_OFF)
			game.mode = BORDERS_ON;
		break;

	case KEY_DOWN: case 'j':
		if (game.mode == BORDERS_ON)
			game.mode = BORDERS_OFF;
		break;

	case KEY_LEFT: case 'h':
		if (*speed_cur_option > 1)
			(*speed_cur_option)--;
		break;

	case KEY_RIGHT: case 'l':
		if (*speed_cur_option < 9)
			(*speed_cur_option)++;
		break;

	case '1': case '2': case '3': case '4': case '5':
	case '6': case '7': case '8': case '9':
		*speed_cur_option = (input - '0'); // ASCII table value
		break;

	default:
		break;
	}

	return TRUE;
}


/**	Cleans the pause menu effects
 */
void engine_clean_pause ()
{
	nodelay (stdscr, TRUE); // We'll no longer wait for input
	curs_set (0); // And here it becomes invisible again
}


/** Wrapper to the attron() function, in case the current terminal
 *  doesn't support colors.
 */
void start_atrribute (int attr)
{
	if (has_colors () == TRUE)
	{
		attron (attr);
	}
}

