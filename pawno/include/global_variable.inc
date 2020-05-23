/*
	GLOBAL DEFINITION VARIABLE FOR MYSQL
 */
#define sizePQuery 500
#define sizePDialog 1000
new MySQL:koneksi, errno, pQuery[MAX_PLAYERS][sizePQuery];

/*
    GLOBAL VARIABLE FOR PLAYER VAR
*/
new pDialog[MAX_PLAYERS][sizePDialog];

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
    sHouse, // Berisi ID Rumah, untuk spawn dirumah jika tidak 0
    nomorHP[12], // Berisi 62 + 4 kode
    nomorRekening[10], // Berisi 8 digit kode rekening

    // Tambang
    sisaPalu,

    bool:sudahSpawn,
    bool:sudahLogin,
    Cache:kotakPesan,
    reply, // -1 kalau gaada
	bool:onSelectedTextdraw,
    lastGlobalChat
}
new PlayerInfo[MAX_PLAYERS][pInfo];

enum pInfoAct {
    timerNambang,
    bool:sedangNambang
}
new PlayerAction[MAX_PLAYERS][pInfoAct];

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

/*
    GLOBAL VARIABLE FOR HOUSE VAR
*/
enum hInfo
{
    hID,
    hOwner,
    hHarga,
    hKunci,
    hJual,
    hLevel,

    // Position
    Float:icon_x,
    Float:icon_y,
    Float:icon_z,
    Float:last_a
}
new houseInfo[MAX_HOUSES][hInfo];
new lastHousePickup[MAX_PLAYERS] = {-1};
new Text3D:houseTextInfo[MAX_HOUSES];
new housePickup[MAX_HOUSES] = {-1};
new houseId[MAX_HOUSES] = {-1};
new houseNotif[MAX_PLAYERS];

/**
    Textdraw Variable For Player
*/
new PlayerText:showItem[MAX_PLAYERS][6];
new PlayerText:myInfo[MAX_PLAYERS][8];
new PlayerText:RadarUang[MAX_PLAYERS][2];

/*
    SERVER VAR
*/

new const SKIN_FEMALE_GRATIS[] = {
    9, 11, 12, 13, 40, 41, 54, 55, 56, 69, 76, 141, 148, 150, 151,
    157, 172, 190, 191, 192, 193, 194, 195, 198, 201, 211, 225, 233, 226, 298
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

new const SPAWN_POINT_OUT_CH[][SPAWN_POINT_INFO] = {
    {1472.6016,-1784.5383,15.4500,4.1420, 0, 0},
    {1479.5529,-1784.4342,15.4631,1.3221, 0, 0},
    {1486.7635,-1784.4592,15.4578,4.4554, 0, 0}
};

new const SP_OUT_BANK_LS[][SPAWN_POINT_INFO] = {
    {1460.3286,-1012.4295,26.8438,181.3176, 0, 0},
    {1482.3094,-1012.5512,26.8438,181.6309, 0, 0},
    {1443.1084,-1012.1120,26.8438,182.5710, 0, 0}
};

/**
    TAMBANG
 */
enum COORD_OBJ {
	Float:POSISI_X,
	Float:POSISI_Y,
	Float:POSISI_Z,
	POSISI_INT,
	POSISI_VW
};
new const POSISI_NAMBANG[][COORD_OBJ] = {
	{575.7255,929.9250,-42.9609, 0, 0},
	{565.1822,924.5467,-42.9609, 0, 0},
	{542.5571,880.1495,-35.3621, 0, 0},
	{487.5997,785.2530,-21.9707, 0, 0},
	{500.3391,779.7797,-21.4040, 0, 0},
	{493.7244,782.7761,-22.0686, 0, 0},
	{606.7349,867.3848,-40.1793, 0, 0},
	{638.0242,856.9865,-40.2213, 0, 0},
	{637.5353,827.0684,-40.1530, 0, 0},
	{545.4601,920.2059,-34.5900, 0, 0},
	{594.1041,926.6013,-37.4588, 0, 0},
	{696.3278,867.3004,-41.5850, 0, 0},
	{558.5338,823.9658,-30.1737, 0, 0},
	{586.0295,814.5699,-29.9435, 0, 0},
	{585.8745,836.0759,-32.0639, 0, 0},
	{461.7570,889.4465,-27.8676, 0, 0},
	{464.8721,866.6505,-27.6602, 0, 0},
    {678.4865,929.3945,-40.8417, 0, 0},
    {693.2300,905.4773,-39.1949, 0, 0},
    {699.5500,894.7210,-38.6479, 0, 0},
    {694.0032,851.4238,-42.9609, 0, 0},
    {682.1595,830.2545,-42.9609, 0, 0},
    {501.6256,971.4416,-24.5734, 0, 0}
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
    {2059, "Materai", 5}, // Materai
    {19631, "Palu Tambang", 10} // Materai
};


/**
    CHECKPOINT VARIABEL
 */
new CP_tempatFoto,
    CP_spotBarangMarket[4],
    CP_spotGantiSkin,
    CP_spotBeliSkin[3],
    CP_resepsionisCityHall,
    CP_tellerBankLS[2],
    CP_ATM[1],
    CP_Tambang[sizeof(POSISI_NAMBANG)];

/**
    PICKUP VARIABEL
 */
new PU_tempatFoto_in[2],
    PU_tempatFoto_out,
    PU_miniMarket[1][2],
    PU_tempatBaju[1][2],
    PU_cityHallMasuk[3],
    PU_cityHallKeluar,
    PU_bankLS[2];

/*
    Virtual World untuk ngebedain pickup
*/
#define VW_tempatFoto_1 1
#define VW_tempatFoto_2 2