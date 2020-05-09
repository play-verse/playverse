/*
	GLOBAL DEFINITION VARIABLE FOR MYSQL
 */
new MySQL:koneksi, query[400], errno;

/*
    GLOBAL VARIABLE FOR PLAYER VAR
*/
enum pInfo
{
	pID,
    pPlayerName[MAX_PLAYER_NAME],
    skinID,
    pPassword[65],
    loginKe, // Mencatat jumlah login
    uang,
    jenisKelamin, // 0 - Laki , 1 - Perempuan

    // Position
    Float:last_x,
    Float:last_y,
    Float:last_z,
    Float:last_a,
    last_int,
    last_vw,

    // Equiped Item
    ePhone, // Berisi versi HP, jika 0 maka hp tidak terequip
    nomorHP[12], // Berisi 62 + 4 kode

    bool:sudahSpawn,
    bool:sudahLogin,
    Cache:kotakPesan,
    reply, // -1 kalau gaada
    lastGlobalChat
}
new PlayerInfo[MAX_PLAYERS][pInfo];

enum rInfo
{
    freeSkinID,
    jenisKelamin, // 0 - Laki, 1 - Perempuan
    registerPassword[25],
    email[100]
}
new registerInfo[MAX_PLAYERS][rInfo];


new msg[256];
new total_vehicles_from_files=0;

/**
    Textdraw Variable For Player
*/
new PlayerText:showItem[MAX_PLAYERS][6];
new PlayerText:myInfo[MAX_PLAYERS][8];

/*
    SERVER VAR
*/

new const SKIN_FEMALE_GRATIS[] = {
    9, 11, 12, 13, 40, 41, 54, 55, 56, 69, 76, 141, 148, 150, 151,
    157, 172, 190, 191, 192, 193, 194, 195, 198, 201, 211, 225, 233, 226, 298, 304
};

new const SKIN_MALE_GRATIS[] = {
    1, 2, 7, 14, 15, 17, 19, 20, 21, 22, 24, 25, 27, 28, 30, 47, 48,
    60, 68, 67, 72, 73, 98, 101, 125, 142, 143, 170, 179, 183, 184
};

enum SPAWN_POINT_INFO {
    Float:SPAWN_POINT_X,
    Float:SPAWN_POINT_Y,
    Float:SPAWN_POINT_Z,
    Float:SPAWN_POINT_A,
    SPAWN_POINT_INTERIOR,
    SPAWN_POINT_VW
}
new const SPAWN_POINT[][SPAWN_POINT_INFO] = {
    {154.0393, -1942.6648, 3.7734, 359.4115, 0, 0},
    {299.0191, -2026.3314, 1.4131, 1.1118, 0, 0}
};

/**
    MARKET DIALOG
 */
enum INFO_BARANG_MARKET {
    idModelBarang,
    namaBarang[100],
    hargaBarang
}

new const BARANG_MARKET[][INFO_BARANG_MARKET] = {
    {2059, "Materai", 5} // Materai
};


/**
    CHECKPOINT VARIABEL
 */
new CP_tempatFoto,
    CP_spotBarangMarket[4];

/**
    PICKUP VARIABEL
 */
new PU_tempatFoto[2],
    PU_miniMarket[1][2];