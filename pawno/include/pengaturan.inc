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

#define MAX_SERVER_ITEM 4 // Diatur sesuai dengan banyak data didatabase - Boleh berlebih tapi jangan kurang

#define MAX_SMS_PER_PLAYER 50 // Maksimal pesan diterima dan maksimal pesan dikirim
// Harus menghapus riwayat pesan untuk dapat mengirim lagi

#define MAX_HOUSES 1000 // Maksimal rumah yang dapat dibuat
#define MAX_HOUSES_LEVEL 3 // Maksimal level rumah

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
#define DIALOG_SMS_MASUKAN_NOMOR 21
#define DIALOG_SMS_MASUKAN_PESAN 22
#define DIALOG_KOTAK_MASUK 23
#define DIALOG_KOTAK_TERKIRIM 24
#define DIALOG_OPSI_KOTAK_MASUK 25
#define DIALOG_OPSI_KOTAK_TERKIRIM 26
#define DIALOG_TEMPAT_FOTO 27
#define DIALOG_BAYAR_FOTO 28
#define DIALOG_ADMIN_RUMAH 29
#define DIALOG_LEVEL_RUMAH 30
#define DIALOG_HARGA_RUMAH 31
#define DIALOG_RESET_RUMAH 32
#define DIALOG_HAPUS_RUMAH 33
#define DIALOG_HAPUS_RUMAH_ID 34
#define DIALOG_HAPUS_RUMAH_ALL 35
#define DIALOG_INFO_RUMAH 36
#define DIALOG_TENTANG_RUMAH 37
#define DIALOG_BELI_BARANG_MARKET 38
#define DIALOG_JUMLAH_BARANG_MARKET 39
#define DIALOG_KONFIRMASI_BARANG_MARKET 40
#define DIALOG_REFRESH_SKIN 41
#define DIALOG_CONFIRM_BELI_SKIN_NORMAL 42
#define DIALOG_TANYA_INGIN_BELI_SKIN 43
#define DIALOG_RESPSIONIS_PEMERINTAH 44
#define DIALOG_RESPSIONIS_PILIH_KTP 45
#define DIALOG_CONFIRM_BUAT_KTP 46


#define ENTER_PICKUP 0 // ENTER PICKUP ADALAH PICKUP YANG ADA DI PINTU MASUK
#define EXIT_PICKUP 1 // EXIT PICKUP ADALAH PICKUP YANG ADA DIDALAM INTERIOR

#define nama_A "Apple"
#define nama_B "Blueberry"
#define nama_C "Cherry"
#define nama_D "Durian"

/**********
*	DEFINED FUNCTION
***********/
// Ketimpa oleh include dibawah"nya
#if !defined isnull
	// modif isnull dengan pengecekan "NULL" untuk counter NULL database field
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))) || !strcmp(%1, "NULL"))
#endif

#define KickEx(%0) SetTimerEx("keluarkanPlayer", 1, 0, "d", %0) 