/*
			CONFIG SERVER
*/

/*
	Connection Database
 */
//#define HOST "37.59.45.199" // 127.0.0.1 / sa-mp.me / 37.59.45.199
//#define USER "190633" // root / 190633
//#define DB  "190633" // root / 190633
//#define PASS "$612&vK1efTp0Q1P7" // kosong / $612&vK1efTp0Q1P7
#define HOST "127.0.0.1" // 127.0.0.1 / sa-mp.me
#define USER "root" // root / 190633
#define DB  "server_samp" // 190633
#define PASS "" // kosong / $612&vK1efTp0Q1P7

/*
	DEFINITION SETTING
*/
#undef MAX_PLAYERS
#define MAX_PLAYERS 50


/*
	DIALOG ID
 */

#define DIALOG_MSG 0
#define DIALOG_REGISTER 1
#define DIALOG_REPEAT_PASSWORD 2
#define DIALOG_LOGIN 3
#define DIALOG_SUCCESS_1 4
#define DIALOG_SUCCESS_2 5
#define DIALOG_INPUT_EMAIL 6
#define DIALOG_INPUT_JEKEL 7
#define DIALOG_INPUT_SKIN_GRATIS 8
#define DIALOG_INVENTORY 9
#define DIALOG_PAKAI_SKIN 10
#define DIALOG_BELI_SKIN 11

/**********
*	DEFINED FUNCTION
***********/
#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif