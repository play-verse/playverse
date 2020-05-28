/*
			CONFIG SERVER
*/

/*
	Connection Database
 */
// Sekarang pakai mysql.ini config file - disitu atur koneksi infonya	
// #define HOST "127.0.0.1"
// #define USER "root"
// #define DB  "server_samp" 
// #define PASS "" 

/*
	DEFINITION SETTING
*/
#undef MAX_PLAYERS
#define MAX_PLAYERS 50

#define MAX_SERVER_ITEM 13 // Diatur sesuai dengan banyak data didatabase - Boleh berlebih tapi jangan kurang

#define MAX_SMS_PER_PLAYER 50 // Maksimal pesan diterima dan maksimal pesan dikirim
// Harus menghapus riwayat pesan untuk dapat mengirim lagi

#define MAX_HOUSES 1000 // Maksimal rumah yang dapat dibuat
#define MAX_HOUSES_LEVEL 3 // Maksimal level rumah

#define MAX_BOARDS 100
#define MODEL_PAPAN 5846

/**
	INDEX ATTACHED OBJECT PLAYER
 */
#define MINING_ATTACH_INDEX 1


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
#define DIALOG_TELLER_BANK 47
#define DIALOG_DAFTAR_REKENING_INPUT_NOMOR 48
#define DIALOG_DAFTAR_REKENING_KONFIRMASI 49
#define DIALOG_DEPOSIT_UANG_TABUNGAN 50
#define DIALOG_KONFIRMASI_DEPOSIT 51
#define DIALOG_ATM 52
#define DIALOG_TRANSFER_NOMINAL 53
#define DIALOG_INPUT_REKENING_TUJUAN 54
#define DIALOG_TRANSFER_KONFIRMASI 55
#define DIALOG_TARIK_UANG_NOMINAL 56
#define DIALOG_TARIK_UANG_KONFIRMASI 57
#define DIALOG_INFO_SALDO_HISTORY 58
#define DIALOG_TANYA_TAMBANG 59
#define DIALOG_MENU_GAJI 60
#define DIALOG_PILIHAN_AMBIL_GAJI 61
#define DIALOG_E_BANKING_MENU 62
#define DIALOG_INFO_SALDO_HISTORY_EBANK 63
#define DIALOG_MENU_BELI_MAKAN 64
#define DIALOG_JUMLAH_PEMBELIAN_MAKANAN 65
#define DIALOG_METODE_BAYAR_MAKAN 66
#define DIALOG_KONFIRMASI_BAYAR_MAKANAN_VIA_ATM 67
#define DIALOG_JOB_SWEEPER 68
#define DIALOG_SIM_REGIS_MENU 69
#define DIALOG_DAFTAR_SIM_KONFIRMASI 70
#define DIALOG_ADMIN_PAPAN 71
#define DIALOG_ADMIN_PAPAN_GOTO 72
#define DIALOG_ADMIN_PAPAN_BUAT_PAPAN 73
#define DIALOG_ADMIN_PAPAN_EDIT_ID 74
#define DIALOG_ADMIN_PAPAN_ETEXT_ID 75
#define DIALOG_ADMIN_PAPAN_ETEXT_TEXT 76
#define DIALOG_ADMIN_PAPAN_ESIZE_ID 77
#define DIALOG_ADMIN_PAPAN_ESIZE_SIZE 78
#define DIALOG_ADMIN_PAPAN_HAPUS 79
#define DIALOG_ADMIN_VEHICLE 80
#define DIALOG_ADMIN_VEHICLE_NEW_MODELID 81
#define DIALOG_ADMIN_VEHICLE_NEW_COLOR 82
#define DIALOG_ADMIN_VEHICLE_NEW_HARGA 83
#define DIALOG_BELI_KENDARAAN_DEALER 84
#define DIALOG_METODE_BAYAR_KENDARAAN 85
#define DIALOG_KONFIRMASI_BAYAR_KENDARAAN_VIA_ATM 86

#define ENTER_PICKUP 0 // ENTER PICKUP ADALAH PICKUP YANG ADA DI PINTU MASUK
#define EXIT_PICKUP 1 // EXIT PICKUP ADALAH PICKUP YANG ADA DIDALAM INTERIOR

#define nama_A "Apple"
#define nama_B "Blueberry"
#define nama_C "Cherry"
#define nama_D "Durian"


// Uncomment untuk mengaktifkan debug mode player
// Comment untuk menonaktifkan
#define DEBUG_MODE_FOR_PLAYER true
#define DEBUG_SERVER_LOAD true

/**********
*	DEFINED FUNCTION
***********/
// Ketimpa oleh include dibawah"nya
#if !defined isnull
	// modif isnull dengan pengecekan "NULL" untuk counter NULL database field
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))) || !strcmp(%1, "NULL"))
#endif

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

#define publicFor:%0(%1) forward %0(%1); public %0(%1)

#define KickEx(%0) SetTimerEx("keluarkanPlayer", 1, 0, "d", %0) 

/*
	Sweeper Job
*/
#define CP_sweeper1 685.1526,-1176.0032,14.8604
#define CP_sweeper2 632.4408,-1216.5146,17.8345
#define CP_sweeper3 639.7727,-1299.1718,14.0871
#define CP_sweeper4 639.5603,-1392.3169,13.1777
#define CP_sweeper5 779.8635,-1392.8464,13.1393
#define CP_sweeper6 901.7383,-1393.3590,12.9473
#define CP_sweeper7 981.7356,-1393.0287,12.7561
#define CP_sweeper8 1065.9674,-1392.5452,13.2625
#define CP_sweeper9 1057.4473,-1480.0160,13.1114
#define CP_sweeper10 1040.3539,-1569.8606,13.1123
#define CP_sweeper11 1139.7485,-1569.9484,13.0024
#define CP_sweeper12 1182.9963,-1570.6260,13.0865
#define CP_sweeper13 1299.3595,-1570.2694,13.1080
#define CP_sweeper14 1299.8340,-1699.2252,13.1079
#define CP_sweeper15 1300.7025,-1848.5142,13.1080
#define CP_sweeper16 1386.8743,-1869.8636,13.1119
#define CP_sweeper17 1387.3251,-1729.8380,13.1080
#define CP_sweeper18 1526.9502,-1730.3479,13.1101
#define CP_sweeper19 1527.4050,-1594.3849,13.1158
#define CP_sweeper20 1427.3721,-1594.3196,13.1158
#define CP_sweeper21 1451.8590,-1455.1904,13.0890
#define CP_sweeper22 1452.1901,-1320.9355,13.1080
#define CP_sweeper23 1452.4602,-1253.9421,13.1080
#define CP_sweeper24 1452.3005,-1163.2198,23.3853
#define CP_sweeper25 1340.4973,-1140.7695,23.3821
#define CP_sweeper26 1351.2671,-1055.5128,26.3598
#define CP_sweeper27 1364.5836,-946.3105,33.9127
#define CP_sweeper28 1274.6550,-936.4373,41.7557
#define CP_sweeper29 1178.1888,-953.2437,42.3175
#define CP_sweeper30 1099.5901,-959.1092,42.1100
#define CP_sweeper31 979.2032,-973.3516,39.1838
#define CP_sweeper32 912.6642,-984.9422,37.6227
#define CP_sweeper33 808.1688,-1055.2218,24.5509
#define CP_sweeper34 746.4445,-1071.9420,22.9642
#define CP_sweeper35 697.3962,-1183.2972,15.3125

/*
	SIM Los Santos
*/
#define CP_simLS1 1527.2363,-1617.6631,13.1038
#define CP_simLS2 1525.9187,-1594.7374,13.1085
#define CP_simLS3 1427.0365,-1594.7550,13.1107
#define CP_simLS4 1449.0212,-1481.6285,13.0967
#define CP_simLS5 1453.0236,-1438.2443,13.1111
#define CP_simLS6 1601.3315,-1438.7969,13.1043
#define CP_simLS7 1603.3353,-1304.0758,17.0020
#define CP_simLS8 1452.8043,-1296.8346,13.1027
#define CP_simLS9 1452.7142,-1221.0813,14.6014
#define CP_simLS10 1452.5627,-1163.2841,23.3802
#define CP_simLS11 1344.1279,-1137.0828,23.3844
#define CP_simLS12 1354.5541,-1043.1460,25.9924
#define CP_simLS13 1389.0247,-1033.1663,25.2336
#define CP_simLS14 1471.1166,-1031.3356,23.3778
#define CP_simLS15 1565.8168,-1078.1226,23.2402
#define CP_simLS16 1581.2787,-1158.7296,23.6325
#define CP_simLS17 1660.3805,-1158.1237,23.4405
#define CP_simLS18 1716.9380,-1158.8601,23.3708
#define CP_simLS19 1718.8711,-1298.0957,13.1075
#define CP_simLS20 1797.5321,-1266.9669,13.1920
#define CP_simLS21 1852.9678,-1259.2980,13.1111
#define CP_simLS22 1852.6808,-1349.6024,13.1097
#define CP_simLS23 1852.2544,-1447.9307,13.1242
#define CP_simLS24 1835.0704,-1542.6741,13.1020
#define CP_simLS25 1824.1018,-1627.7905,13.1043
#define CP_simLS26 1824.4741,-1739.2527,13.1036
#define CP_simLS27 1823.1952,-1835.4011,13.1353
#define CP_simLS28 1752.5378,-1824.1658,13.1088
#define CP_simLS29 1692.7274,-1814.8640,13.1089
#define CP_simLS30 1666.8082,-1872.9930,13.1072
#define CP_simLS31 1567.3307,-1873.6450,13.1083
#define CP_simLS32 1567.6167,-1809.4325,13.1044
#define CP_simLS33 1566.2480,-1734.6050,13.1089
#define CP_simLS34 1526.4672,-1734.0198,13.1086
#define CP_simLS35 1527.3645,-1674.0238,13.1040
#define CP_simLS36 1532.3368,-1687.7728,13.1010
#define CP_simLS37 1531.5006,-1720.7034,13.1053
#define CP_simLS38 1526.5812,-1707.2993,13.1033
#define CP_simLS39 1527.3547,-1625.8934,13.1053
#define CP_simLS40 1590.3997,-1634.8812,13.1595