/*
    GLOBAL VARIABEL FOR SERVER
*/
new last_hari;

/*
	GLOBAL DEFINITION VARIABLE FOR MYSQL
 */
#define sizePQuery 800
#define sizePDialog 1500
#define sizeSQuery 1000
new MySQL:koneksi, errno, pQuery[MAX_PLAYERS][sizePQuery], sQuery[sizeSQuery];

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
    limitItem, // Menyimpan limit dari inventory

    Cache:tempCache, // digunakan untuk menyimpan temporary cache : Misalnya cache inventory, cache skin. Jangan gunakan untuk yang penting

    // Save status
    // Position
    Float:last_x,
    Float:last_y,
    Float:last_z,
    Float:last_a,
    last_int,
    last_vw,

    Float:last_stats_makan,
    Float:last_stats_minum,

    // Status
    Float:lastHp,
    Float:lastArmour,

    Float:statusMakan,
    Float:statusMinum,

    preloadAnim, // Preload anim

    // Equiped Item
    ePhone, // Berisi versi HP, jika 0 maka hp tidak terequip
    sHouse, // Berisi ID Rumah, untuk spawn dirumah jika tidak 0
    nomorHP[12], // Berisi 62 + 4 kode
    nomorRekening[10], // Berisi 8 digit kode rekening
    
    waktuSaatLogin, // menyimpan gettickcount yang didapat saat login (untuk menghitung lama bermain sejak login)
    lamaBermain, // menyimpan waktu (dalam detik) yang didapat dari database

    // Tambang
    sisaPalu,
    bool:activeMarker,

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
    hSetHarga,
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

enum hLevelInfo {
    namaLevel[50],
    Float:intSpawn[4], // x, y, z, a
    intSpawnInterior,
    houseItemCapacity
}
new HouseLevel[MAX_HOUSES_LEVEL + 1][hLevelInfo]; // Dimana house level 0 tidak diisi dan index sampai MAX + 1
new Iterator:HouseLevelIterator<MAX_HOUSES_LEVEL>;

/**
    House Furniture
*/
enum    e_furniture
{
	fID,
	fHouseID,
	fFurnitureID,
	Float: fPosX,
	Float: fPosY,
	Float: fPosZ,
	Float: fRotX,
	Float: fRotY,
	Float: fRotZ
};

#define EDITING_NONE 0
#define EDITING_FURNITURE 1
#define EDITING_BOARD 2
new EditingObject[MAX_PLAYERS] = {EDITING_NONE, ...};

/**
    Textdraw Variable For Player
*/
new PlayerText:showItem[MAX_PLAYERS][6];
new PlayerText:myInfo[MAX_PLAYERS][8];
// new PlayerText:RadarUang[MAX_PLAYERS][2];

new Text:HUD_Stats_PB[5];
new PlayerText:HUD_Stats[MAX_PLAYERS][1];
new PlayerBar:HUD_Stats_Bar[MAX_PLAYERS][2];

new Text:TD_JamTanggal[2];
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

new const POSISI_SPAWN_REPARASI_MOBIL[][SPAWN_POINT_INFO] = {
    {1013.6084, -1715.4836, 14.8368, 0.4314, 0, 0},
    {986.8361,-1693.0780,14.6905,267.1821, 0, 0},
    {988.2069,-1687.9666,14.6843,271.3264, 0, 0},
    {987.8882,-1698.7465,14.3796,267.0156, 0, 0}
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

new const POSISI_ATM[][COORD_OBJ] = {
	{1412.3097,-987.6777,-55.2764, 1, 1},
	{1154.9031,-1464.9263,15.7981, 0, 0}
};

new const POSISI_BELI_BARANG_MARKET[][COORD_OBJ] = {
    {-4.2324, -176.4322, 1003.5469, 17, -1},
    {-9.7521, -169.9181, 1003.5469, 17, -1},
    {-34.2435, -182.2766, 1003.5469, 17, -1},
    {-34.2461, -172.7712, 1003.5469, 17, -1},
    {1166.8647, -1445.9028, 15.7981, 0, 0},
    {1175.0690, -1438.7549, 15.7981, 0, 0},
    {1166.0021, -1432.7262, 15.7981, 0, 0}
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

enum INFO_MENU_MAKANAN {
    idItemMakanan,
    namaMakanan[100],
    hargaMakanan
}

new const MENU_MAKANAN[][INFO_MENU_MAKANAN] = {
    {14, "Steak", 10},
    {13, "Air Minum Mineral", 2}
};

/**
    CHECKPOINT VARIABEL
 */
new CP_tempatFoto,
    CP_spotBarangMarket[sizeof(POSISI_BELI_BARANG_MARKET)],
    CP_spotGantiSkin,
    CP_spotBeliSkin[3],
    CP_resepsionisCityHall,
    CP_tellerBankLS[2],
    CP_ATM[sizeof(POSISI_ATM)],
    CP_Tambang[sizeof(POSISI_NAMBANG)],
    CP_beliMakanCepatSaji,
    CP_spawnReparasi[sizeof(POSISI_SPAWN_REPARASI_MOBIL)],
    CP_simRegis[1],
    CP_simPraktik[1];

/**
    PICKUP VARIABEL
 */
new PU_tempatFoto_in[2],
    PU_tempatFoto_out,
    PU_miniMarket[1][2],
    PU_tempatBaju[1][2],
    PU_cityHallMasuk[3],
    PU_cityHallKeluar,
    PU_bankLS[2],
    PU_tempatMakan_in[2],
    PU_tempatMakan_out,
    PU_tempatKeluarRumah[2], // Hanya menyimpan ID terkecil dan Terbesar
    PU_policeDept_in[1],
    PU_policeDept_out[1];

/*
    Virtual World untuk ngebedain pickup
*/
#define VW_tempatFoto_1 1
#define VW_tempatFoto_2 2

#define VW_tempatMakan_1 1
#define VW_tempatMakan_2 2

/**
    Job / Aktifitas
*/
new todoTimer[MAX_PLAYERS];
new todoTimeout[MAX_PLAYERS];

/* Sweeper */
new Iterator:vehicleSweeper<MAX_VEHICLES>,
    sweeperJob[MAX_PLAYERS],
    sweeperId[MAX_PLAYERS] = {-1},
    vehicleSweeper[3],
    usedSweeper[MAX_VEHICLES];

/* SIM Kendaraan */
new Iterator:vehicleSIM<MAX_VEHICLES>,
    testSim[MAX_PLAYERS],
    poinSim[MAX_PLAYERS],
    vehicleIdSIM[MAX_PLAYERS] = {-1},
    vehicleSIM[3],
    limitVehSIM[MAX_VEHICLES],
    Float:oldVehicleHealth[MAX_VEHICLES], 
    Float:newVehicleHealth[MAX_VEHICLES];

enum INFO_SOAL {
    simQuestion[16],
    simAnswer1[240],
    simAnswer2[240],
    simAnswer3[240],
    simAnswer4[240],
    simAnswerTrue,
    simQuestionMSG[240]
};

new SIM_SOAL[][INFO_SOAL] = {
    {"Pertanyaan 1", "A. Jalur tengah", "B. Jalur kiri", "C. Jalur kanan", "D. Semua salah", 1, GREEN"[HALO Polisi] "WHITE"Saat berkendara kita harus memilih jalur?"},
    {"Pertanyaan 2", "A. 80 KmpH", "B. 35 KmpH", "C. 75 KmpH", "D. 50 KmpH", 2, GREEN"[HALO Polisi] "WHITE"Batas kecepatan saat mengendarai kendaraan?"},
    {"Pertanyaan 3", "A. Membawa surat lengkap", "B. Jalur kanan untuk mengurangi kecepatan", "C. Berhenti jika lampu lalu lintas merah", "D. Semua benar", 3, GREEN"[HALO Polisi] "WHITE"Berikut merupakan aturan berkendara yang benar?"},
    {"Pertanyaan 4", "A. Ambil jalur kanan", "B. Tidak menyalip", "C. Memberi tanda klakson", "D. Tetap menyalip", 4, GREEN"[HALO Polisi] "WHITE"Jika anda ingin menyalip ketika ada kendaraan dijalur kiri, apa yang anda lakukan?"},
    {"Pertanyaan 5", "A. Siapa saja", "B. Satpol PP", "C. Satpam", "D. Polisi", 3, GREEN"[HALO Polisi] "WHITE"Siapa yang berhak menindak pelanggaran lalu lintas?"},
    {"Pertanyaan 6", "A. Siapa saja", "B. Satpol PP", "C. Satpam", "D. Polisi", 2, GREEN"[HALO Polisi] "WHITE"Siapa yang berhak menasehati pelanggar lalu lintas?"}
};

/**
    Speedometer
*/
new PlayerText:SpeedoTextDraws[MAX_PLAYERS],
    SpeedoTimer[MAX_PLAYERS];

/**
    System Board
 */
enum boardInfo
{
	boardID,
	bBoard,
	bModel,
	Float:bCX,
	Float:bCY,
	Float:bCZ,
	Float:bCRX,
	Float:bCRY,
	Float:bCRZ,
	bStatus,
	bText[1000],
	bFontSiz
}
new BoardInfo[MAX_BOARDS][boardInfo];
new jumlahBoard = 0; // Menyimpan jumlah Board

new bEditID[MAX_PLAYERS];
new Float:bCPos[MAX_PLAYERS][3];
new Float:bCRot[MAX_PLAYERS][3];

/**
    VEHICLE DEFINITION
*/
new const NAMA_KENDARAAN[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
	"Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
	"Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "BerkleysRCVan",
	"Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale",
	"Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
	"Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "NewsChopper",
	"Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"BlistaCompact", "PoliceMaverick", "Boxvillde", "Benson", "Mesa", "RCGoblin",
	"HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT",
	"Elegant", "Journey", "Bike", "MountainBike", "Beagle", "Cropduster", "Stunt",
 	"Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
 	"FCR-900", "NRG-500", "HPV1000", "CementTruck", "TowTruck", "Fortune",
 	"Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
 	"Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
    "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
	"Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
	"Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratium",
	"Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper",
	"Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
	"News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"FreightBox", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD",
 	"SFPD", "LVPD", "PoliceRanger", "Picador", "S.W.A.T", "Alpha",
 	"Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville",
 	"Tiller", "UtilityTrailer"
};

/**
    Vehicle Dealer
*/

enum DealerVehicleInfo
{
    dVehID, // ID Primary Key Database
    dVehModel,
    Float:dVehCoord[4],
    dVehColor[2],
    Text3D:dVehText3D,
    dVehHarga
}

enum PlayerVehicleInfo
{
    pVehID, // Primary Key
    pVehPemilik,
    pVehNamaPemilik[MAX_PLAYER_NAME],
    pVehicle, // Menyimpan id vehicle
    pVehModel,
    Float:pVehCoord[4],
    pVehColor[2],
    pVehMod[14],
    pVehPaintJob,
    Float:pVehDarah,
    pVehIsReparasi // Status Reparasi : 0 - kendaraan baik-baik aja, 1 - kendaraan rusak dan sedang dalam reparasi (harus diambil dari tempat reparasi), 2 - Kendaraan telah diperbaiki dan siap diambil
}
new 
    Iterator:DVehIterator<MAX_VEHICLES>, // Nyimpan Iterator vehicle
    DVeh[MAX_VEHICLES][DealerVehicleInfo],
    Iterator:IDVehToPVehIterator<MAX_VEHICLES>, // Menyimpan iterator vehicle player yang sedang aktif (TERSPAWN)
    IDVehToPVeh[MAX_VEHICLES], // Menyimpan index PVeh berdasarkan id vehicle
    Iterator:PVehIterator<MAX_VEHICLES>,
    PVeh[MAX_VEHICLES][PlayerVehicleInfo],
    Iterator:PVehKeys[MAX_PLAYERS]<MAX_VEHICLES>, // Nyimpan data vehicle berdasarkan ID vehicle (playerid, idpv)
    PVehKeysTime[MAX_PLAYERS][MAX_VEHICLES]; // Nyimpan waktu expired terhadap waktu (playerid, idpv) - Standart penghitungan menggunakan UNIX_TIMESTAMP

/**
    Lumberjack
*/
enum TreeInfo
{
    treeID,
    treeTimer,
    treeObjID,
    Text3D:treeLabel,
    treeCP,
    treeSecs,
    treeAmbil,
    treeAngkut,
    bool: treeTumbang,
    Float: treeX,
    Float: treeY,
    Float: treeZ,
    Float: treeRX,
    Float: treeRY,
    Float: treeRZ
}
new Iterator:TreeIterator<MAX_TREES>,
    DTree[MAX_TREES][TreeInfo],
    vehDTree[MAX_VEHICLES][TreeInfo],
    CuttingTreeID[MAX_PLAYERS] = {-1, ...},
    CuttingTimer[MAX_PLAYERS] = {-1, ...},
    PlayerBar: CuttingBar[MAX_PLAYERS] = {INVALID_PLAYER_BAR_ID, ...},
    treeEditID[MAX_PLAYERS] = {-1, ...};
