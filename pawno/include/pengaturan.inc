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

#define MAX_MS_ITEM 4 // Diatur sesuai dengan banyak data didatabase - Boleh berlebih tapi jangan kurang

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
#define DIALOG_PILIH_SKIN 10
#define DIALOG_BELI_SKIN 11
#define DIALOG_OPTION_SKIN_INVENTORY 12
#define DIALOG_SHOW_ITEM_FOR_PLAYER 13
#define DIALOG_DAFTAR_NOMOR 14
#define DIALOG_PILIH_PLAYER_FOR_ITEM 15
#define DIALOG_PILIH_ITEM 16
#define DIALOG_OPTION_ITEM_INVENTORY 17
#define DIALOG_ADMIN_GIVE_ITEM 18
#define DIALOG_PILIH_JUMLAH_ITEM 19
#define DIALOG_MENU_EPHONE 20


/**********
*	DEFINED FUNCTION
***********/
#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif