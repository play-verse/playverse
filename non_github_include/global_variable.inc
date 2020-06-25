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

	// Skill EXP
	expMekanik,
	expMedic,

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
	inHouse,

    // Equiped Item
    ePhone, // Berisi versi HP, jika 0 maka hp tidak terequip
    sHouse, // Berisi ID Rumah, untuk spawn dirumah jika tidak 0
    nomorHP[12], // Berisi 62 + 4 kode
    nomorRekening[10], // Berisi 8 digit kode rekening
    
    waktuSaatLogin, // menyimpan gettickcount yang didapat saat login (untuk menghitung lama bermain sejak login)
    lamaBermain, // menyimpan waktu (dalam detik) yang didapat dari database

    // Tambang
    sisaPalu,
    sisaGergaji,
    bool:activeMarker,

    // Settings
    bool:tampilHUDStats,

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
    hOwnerName[MAX_PLAYER_NAME],
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
    {288.4492, -1985.4537, 2.4633, 357.8315, 0, 0}
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

new const POSISI_BELI_BARANG_MARKET[][COORD_OBJ] = {
    {-4.2324, -176.4322, 1003.5469, 17, -1},
    {-9.7521, -169.9181, 1003.5469, 17, -1},
    {-34.2435, -182.2766, 1003.5469, 17, -1},
    {-34.2461, -172.7712, 1003.5469, 17, -1},
    {1166.8647, -1445.9028, 15.7981, 0, 0},
    {1175.0690, -1438.7549, 15.7981, 0, 0},
    {1166.0021, -1432.7262, 15.7981, 0, 0}
};

new const POSISI_BELI_PERABOT[][COORD_OBJ] = {
	{1831.8854, -1402.5930, 13.5559, 0, 0}
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
    {19631, "Palu Tambang", 10}, // Palu Tambang
    {341, "Gergaji Mesin", 10} // Gergaji Mesin
};

enum INFO_JUAL_PERABOT {
	IDPerabotDijual,
	NamaPerabotDijual[100],
	HargaPerabotDijual
}
new const PERABOT_DIJUAL[][INFO_JUAL_PERABOT] = {
	{1, "Meja I", 1000},
	{2, "Kasur Besar I", 2500}
};

enum INFO_MENU_MAKANAN {
    idItemMakanan,
    namaMakanan[100],
    hargaMakanan,
    Float:energiNambah
}

/*  
    $1 Minuman = 5%
    $1 Food = 2.5% 
*/
new const MENU_MAKANAN[][INFO_MENU_MAKANAN] = {
// Makanan
    {14, "Steak", 20, 50.0},
    {16, "Nasi Bungkus", 15, 37.5},
    {17, "Sate", 12, 30.0},
    {23, "Roti", 10, 25.0},
    {24, "Telur Dadar", 5, 12.5},

// Minuman
    {13, "Air Mineral", 1, 5.0},
    {18, "Jus Jeruk", 5, 25.0},
    {19, "Es Teh Manis", 4, 20.0},
    {20, "Kopi Panas", 7, 35.0},
    {21, "Kopi Dingin", 7, 35.0},
    {22, "Minuman Soda", 6, 30.0}
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
    CP_Tambang[sizeof(POSISI_NAMBANG)],
    CP_beliMakanCepatSaji,
    CP_spawnReparasi[sizeof(POSISI_SPAWN_REPARASI_MOBIL)],
    CP_simRegis[1],
    CP_simPraktik[1],
    CP_pusatProperti[1];

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

/**
    Area
 */
new areaToll[2],
    areaToll_LSLV[2];

/**
    OBJECT TOLL
 */
new palangToll[2],
    isTollUsed[2],
    palangToll_LSLV[2],
    isTollUsed_LSLV[2];

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

enum    e_sazone
{
    SAZONE_NAME[28],
    Float: SAZONE_AREA[6]
};

new
	SAZones[][e_sazone] = {
		{"The Big Ear",	                {-410.00,1403.30,-3.00,-137.90,1681.20,200.00}},
		{"Aldea Malvada",               {-1372.10,2498.50,0.00,-1277.50,2615.30,200.00}},
		{"Angel Pine",                  {-2324.90,-2584.20,-6.10,-1964.20,-2212.10,200.00}},
		{"Arco del Oeste",              {-901.10,2221.80,0.00,-592.00,2571.90,200.00}},
		{"Avispa Country Club",         {-2646.40,-355.40,0.00,-2270.00,-222.50,200.00}},
		{"Avispa Country Club",         {-2831.80,-430.20,-6.10,-2646.40,-222.50,200.00}},
		{"Avispa Country Club",         {-2361.50,-417.10,0.00,-2270.00,-355.40,200.00}},
		{"Avispa Country Club",         {-2667.80,-302.10,-28.80,-2646.40,-262.30,71.10}},
		{"Avispa Country Club",         {-2470.00,-355.40,0.00,-2270.00,-318.40,46.10}},
		{"Avispa Country Club",         {-2550.00,-355.40,0.00,-2470.00,-318.40,39.70}},
		{"Back o Beyond",               {-1166.90,-2641.10,0.00,-321.70,-1856.00,200.00}},
		{"Battery Point",               {-2741.00,1268.40,-4.50,-2533.00,1490.40,200.00}},
		{"Bayside",                     {-2741.00,2175.10,0.00,-2353.10,2722.70,200.00}},
		{"Bayside Marina",              {-2353.10,2275.70,0.00,-2153.10,2475.70,200.00}},
		{"Beacon Hill",                 {-399.60,-1075.50,-1.40,-319.00,-977.50,198.50}},
		{"Blackfield",                  {964.30,1203.20,-89.00,1197.30,1403.20,110.90}},
		{"Blackfield",                  {964.30,1403.20,-89.00,1197.30,1726.20,110.90}},
		{"Blackfield Chapel",           {1375.60,596.30,-89.00,1558.00,823.20,110.90}},
		{"Blackfield Chapel",           {1325.60,596.30,-89.00,1375.60,795.00,110.90}},
		{"Blackfield Intersection",     {1197.30,1044.60,-89.00,1277.00,1163.30,110.90}},
		{"Blackfield Intersection",     {1166.50,795.00,-89.00,1375.60,1044.60,110.90}},
		{"Blackfield Intersection",     {1277.00,1044.60,-89.00,1315.30,1087.60,110.90}},
		{"Blackfield Intersection",     {1375.60,823.20,-89.00,1457.30,919.40,110.90}},
		{"Blueberry",                   {104.50,-220.10,2.30,349.60,152.20,200.00}},
		{"Blueberry",                   {19.60,-404.10,3.80,349.60,-220.10,200.00}},
		{"Blueberry Acres",             {-319.60,-220.10,0.00,104.50,293.30,200.00}},
		{"Caligula's Palace",           {2087.30,1543.20,-89.00,2437.30,1703.20,110.90}},
		{"Caligula's Palace",           {2137.40,1703.20,-89.00,2437.30,1783.20,110.90}},
		{"Calton Heights",              {-2274.10,744.10,-6.10,-1982.30,1358.90,200.00}},
		{"Chinatown",                   {-2274.10,578.30,-7.60,-2078.60,744.10,200.00}},
		{"City Hall",                   {-2867.80,277.40,-9.10,-2593.40,458.40,200.00}},
		{"Come-A-Lot",                  {2087.30,943.20,-89.00,2623.10,1203.20,110.90}},
		{"Commerce",                    {1323.90,-1842.20,-89.00,1701.90,-1722.20,110.90}},
		{"Commerce",                    {1323.90,-1722.20,-89.00,1440.90,-1577.50,110.90}},
		{"Commerce",                    {1370.80,-1577.50,-89.00,1463.90,-1384.90,110.90}},
		{"Commerce",                    {1463.90,-1577.50,-89.00,1667.90,-1430.80,110.90}},
		{"Commerce",                    {1583.50,-1722.20,-89.00,1758.90,-1577.50,110.90}},
		{"Commerce",                    {1667.90,-1577.50,-89.00,1812.60,-1430.80,110.90}},
		{"Conference Center",           {1046.10,-1804.20,-89.00,1323.90,-1722.20,110.90}},
		{"Conference Center",           {1073.20,-1842.20,-89.00,1323.90,-1804.20,110.90}},
		{"Cranberry Station",           {-2007.80,56.30,0.00,-1922.00,224.70,100.00}},
		{"Creek",                       {2749.90,1937.20,-89.00,2921.60,2669.70,110.90}},
		{"Dillimore",                   {580.70,-674.80,-9.50,861.00,-404.70,200.00}},
		{"Doherty",                     {-2270.00,-324.10,-0.00,-1794.90,-222.50,200.00}},
		{"Doherty",                     {-2173.00,-222.50,-0.00,-1794.90,265.20,200.00}},
		{"Downtown",                    {-1982.30,744.10,-6.10,-1871.70,1274.20,200.00}},
		{"Downtown",                    {-1871.70,1176.40,-4.50,-1620.30,1274.20,200.00}},
		{"Downtown",                    {-1700.00,744.20,-6.10,-1580.00,1176.50,200.00}},
		{"Downtown",                    {-1580.00,744.20,-6.10,-1499.80,1025.90,200.00}},
		{"Downtown",                    {-2078.60,578.30,-7.60,-1499.80,744.20,200.00}},
		{"Downtown",                    {-1993.20,265.20,-9.10,-1794.90,578.30,200.00}},
		{"Downtown Los Santos",         {1463.90,-1430.80,-89.00,1724.70,-1290.80,110.90}},
		{"Downtown Los Santos",         {1724.70,-1430.80,-89.00,1812.60,-1250.90,110.90}},
		{"Downtown Los Santos",         {1463.90,-1290.80,-89.00,1724.70,-1150.80,110.90}},
		{"Downtown Los Santos",         {1370.80,-1384.90,-89.00,1463.90,-1170.80,110.90}},
		{"Downtown Los Santos",         {1724.70,-1250.90,-89.00,1812.60,-1150.80,110.90}},
		{"Downtown Los Santos",         {1370.80,-1170.80,-89.00,1463.90,-1130.80,110.90}},
		{"Downtown Los Santos",         {1378.30,-1130.80,-89.00,1463.90,-1026.30,110.90}},
		{"Downtown Los Santos",         {1391.00,-1026.30,-89.00,1463.90,-926.90,110.90}},
		{"Downtown Los Santos",         {1507.50,-1385.20,110.90,1582.50,-1325.30,335.90}},
		{"East Beach",                  {2632.80,-1852.80,-89.00,2959.30,-1668.10,110.90}},
		{"East Beach",                  {2632.80,-1668.10,-89.00,2747.70,-1393.40,110.90}},
		{"East Beach",                  {2747.70,-1668.10,-89.00,2959.30,-1498.60,110.90}},
		{"East Beach",                  {2747.70,-1498.60,-89.00,2959.30,-1120.00,110.90}},
		{"East Los Santos",             {2421.00,-1628.50,-89.00,2632.80,-1454.30,110.90}},
		{"East Los Santos",             {2222.50,-1628.50,-89.00,2421.00,-1494.00,110.90}},
		{"East Los Santos",             {2266.20,-1494.00,-89.00,2381.60,-1372.00,110.90}},
		{"East Los Santos",             {2381.60,-1494.00,-89.00,2421.00,-1454.30,110.90}},
		{"East Los Santos",             {2281.40,-1372.00,-89.00,2381.60,-1135.00,110.90}},
		{"East Los Santos",             {2381.60,-1454.30,-89.00,2462.10,-1135.00,110.90}},
		{"East Los Santos",             {2462.10,-1454.30,-89.00,2581.70,-1135.00,110.90}},
		{"Easter Basin",                {-1794.90,249.90,-9.10,-1242.90,578.30,200.00}},
		{"Easter Basin",                {-1794.90,-50.00,-0.00,-1499.80,249.90,200.00}},
		{"Easter Bay Airport",          {-1499.80,-50.00,-0.00,-1242.90,249.90,200.00}},
		{"Easter Bay Airport",          {-1794.90,-730.10,-3.00,-1213.90,-50.00,200.00}},
		{"Easter Bay Airport",          {-1213.90,-730.10,0.00,-1132.80,-50.00,200.00}},
		{"Easter Bay Airport",          {-1242.90,-50.00,0.00,-1213.90,578.30,200.00}},
		{"Easter Bay Airport",          {-1213.90,-50.00,-4.50,-947.90,578.30,200.00}},
		{"Easter Bay Airport",          {-1315.40,-405.30,15.40,-1264.40,-209.50,25.40}},
		{"Easter Bay Airport",          {-1354.30,-287.30,15.40,-1315.40,-209.50,25.40}},
		{"Easter Bay Airport",          {-1490.30,-209.50,15.40,-1264.40,-148.30,25.40}},
		{"Easter Bay Chemicals",        {-1132.80,-768.00,0.00,-956.40,-578.10,200.00}},
		{"Easter Bay Chemicals",        {-1132.80,-787.30,0.00,-956.40,-768.00,200.00}},
		{"El Castillo del Diablo",      {-464.50,2217.60,0.00,-208.50,2580.30,200.00}},
		{"El Castillo del Diablo",      {-208.50,2123.00,-7.60,114.00,2337.10,200.00}},
		{"El Castillo del Diablo",      {-208.50,2337.10,0.00,8.40,2487.10,200.00}},
		{"El Corona",                   {1812.60,-2179.20,-89.00,1970.60,-1852.80,110.90}},
		{"El Corona",                   {1692.60,-2179.20,-89.00,1812.60,-1842.20,110.90}},
		{"El Quebrados",                {-1645.20,2498.50,0.00,-1372.10,2777.80,200.00}},
		{"Esplanade East",              {-1620.30,1176.50,-4.50,-1580.00,1274.20,200.00}},
		{"Esplanade East",              {-1580.00,1025.90,-6.10,-1499.80,1274.20,200.00}},
		{"Esplanade East",              {-1499.80,578.30,-79.60,-1339.80,1274.20,20.30}},
		{"Esplanade North",             {-2533.00,1358.90,-4.50,-1996.60,1501.20,200.00}},
		{"Esplanade North",             {-1996.60,1358.90,-4.50,-1524.20,1592.50,200.00}},
		{"Esplanade North",             {-1982.30,1274.20,-4.50,-1524.20,1358.90,200.00}},
		{"Fallen Tree",                 {-792.20,-698.50,-5.30,-452.40,-380.00,200.00}},
		{"Fallow Bridge",               {434.30,366.50,0.00,603.00,555.60,200.00}},
		{"Fern Ridge",                  {508.10,-139.20,0.00,1306.60,119.50,200.00}},
		{"Financial",                   {-1871.70,744.10,-6.10,-1701.30,1176.40,300.00}},
		{"Fisher's Lagoon",             {1916.90,-233.30,-100.00,2131.70,13.80,200.00}},
		{"Flint Intersection",          {-187.70,-1596.70,-89.00,17.00,-1276.60,110.90}},
		{"Flint Range",                 {-594.10,-1648.50,0.00,-187.70,-1276.60,200.00}},
		{"Fort Carson",                 {-376.20,826.30,-3.00,123.70,1220.40,200.00}},
		{"Foster Valley",               {-2270.00,-430.20,-0.00,-2178.60,-324.10,200.00}},
		{"Foster Valley",               {-2178.60,-599.80,-0.00,-1794.90,-324.10,200.00}},
		{"Foster Valley",               {-2178.60,-1115.50,0.00,-1794.90,-599.80,200.00}},
		{"Foster Valley",               {-2178.60,-1250.90,0.00,-1794.90,-1115.50,200.00}},
		{"Frederick Bridge",            {2759.20,296.50,0.00,2774.20,594.70,200.00}},
		{"Gant Bridge",                 {-2741.40,1659.60,-6.10,-2616.40,2175.10,200.00}},
		{"Gant Bridge",                 {-2741.00,1490.40,-6.10,-2616.40,1659.60,200.00}},
		{"Ganton",                      {2222.50,-1852.80,-89.00,2632.80,-1722.30,110.90}},
		{"Ganton",                      {2222.50,-1722.30,-89.00,2632.80,-1628.50,110.90}},
		{"Garcia",                      {-2411.20,-222.50,-0.00,-2173.00,265.20,200.00}},
		{"Garcia",                      {-2395.10,-222.50,-5.30,-2354.00,-204.70,200.00}},
		{"Garver Bridge",               {-1339.80,828.10,-89.00,-1213.90,1057.00,110.90}},
		{"Garver Bridge",               {-1213.90,950.00,-89.00,-1087.90,1178.90,110.90}},
		{"Garver Bridge",               {-1499.80,696.40,-179.60,-1339.80,925.30,20.30}},
		{"Glen Park",                   {1812.60,-1449.60,-89.00,1996.90,-1350.70,110.90}},
		{"Glen Park",                   {1812.60,-1100.80,-89.00,1994.30,-973.30,110.90}},
		{"Glen Park",                   {1812.60,-1350.70,-89.00,2056.80,-1100.80,110.90}},
		{"Green Palms",                 {176.50,1305.40,-3.00,338.60,1520.70,200.00}},
		{"Greenglass College",          {964.30,1044.60,-89.00,1197.30,1203.20,110.90}},
		{"Greenglass College",          {964.30,930.80,-89.00,1166.50,1044.60,110.90}},
		{"Hampton Barns",               {603.00,264.30,0.00,761.90,366.50,200.00}},
		{"Hankypanky Point",            {2576.90,62.10,0.00,2759.20,385.50,200.00}},
		{"Harry Gold Parkway",          {1777.30,863.20,-89.00,1817.30,2342.80,110.90}},
		{"Hashbury",                    {-2593.40,-222.50,-0.00,-2411.20,54.70,200.00}},
		{"Hilltop Farm",                {967.30,-450.30,-3.00,1176.70,-217.90,200.00}},
		{"Hunter Quarry",               {337.20,710.80,-115.20,860.50,1031.70,203.70}},
		{"Idlewood",                    {1812.60,-1852.80,-89.00,1971.60,-1742.30,110.90}},
		{"Idlewood",                    {1812.60,-1742.30,-89.00,1951.60,-1602.30,110.90}},
		{"Idlewood",                    {1951.60,-1742.30,-89.00,2124.60,-1602.30,110.90}},
		{"Idlewood",                    {1812.60,-1602.30,-89.00,2124.60,-1449.60,110.90}},
		{"Idlewood",                    {2124.60,-1742.30,-89.00,2222.50,-1494.00,110.90}},
		{"Idlewood",                    {1971.60,-1852.80,-89.00,2222.50,-1742.30,110.90}},
		{"Jefferson",                   {1996.90,-1449.60,-89.00,2056.80,-1350.70,110.90}},
		{"Jefferson",                   {2124.60,-1494.00,-89.00,2266.20,-1449.60,110.90}},
		{"Jefferson",                   {2056.80,-1372.00,-89.00,2281.40,-1210.70,110.90}},
		{"Jefferson",                   {2056.80,-1210.70,-89.00,2185.30,-1126.30,110.90}},
		{"Jefferson",                   {2185.30,-1210.70,-89.00,2281.40,-1154.50,110.90}},
		{"Jefferson",                   {2056.80,-1449.60,-89.00,2266.20,-1372.00,110.90}},
		{"Julius Thruway East",         {2623.10,943.20,-89.00,2749.90,1055.90,110.90}},
		{"Julius Thruway East",         {2685.10,1055.90,-89.00,2749.90,2626.50,110.90}},
		{"Julius Thruway East",         {2536.40,2442.50,-89.00,2685.10,2542.50,110.90}},
		{"Julius Thruway East",         {2625.10,2202.70,-89.00,2685.10,2442.50,110.90}},
		{"Julius Thruway North",        {2498.20,2542.50,-89.00,2685.10,2626.50,110.90}},
		{"Julius Thruway North",        {2237.40,2542.50,-89.00,2498.20,2663.10,110.90}},
		{"Julius Thruway North",        {2121.40,2508.20,-89.00,2237.40,2663.10,110.90}},
		{"Julius Thruway North",        {1938.80,2508.20,-89.00,2121.40,2624.20,110.90}},
		{"Julius Thruway North",        {1534.50,2433.20,-89.00,1848.40,2583.20,110.90}},
		{"Julius Thruway North",        {1848.40,2478.40,-89.00,1938.80,2553.40,110.90}},
		{"Julius Thruway North",        {1704.50,2342.80,-89.00,1848.40,2433.20,110.90}},
		{"Julius Thruway North",        {1377.30,2433.20,-89.00,1534.50,2507.20,110.90}},
		{"Julius Thruway South",        {1457.30,823.20,-89.00,2377.30,863.20,110.90}},
		{"Julius Thruway South",        {2377.30,788.80,-89.00,2537.30,897.90,110.90}},
		{"Julius Thruway West",         {1197.30,1163.30,-89.00,1236.60,2243.20,110.90}},
		{"Julius Thruway West",         {1236.60,2142.80,-89.00,1297.40,2243.20,110.90}},
		{"Juniper Hill",                {-2533.00,578.30,-7.60,-2274.10,968.30,200.00}},
		{"Juniper Hollow",              {-2533.00,968.30,-6.10,-2274.10,1358.90,200.00}},
		{"K.A.C.C. Military Fuels",     {2498.20,2626.50,-89.00,2749.90,2861.50,110.90}},
		{"Kincaid Bridge",              {-1339.80,599.20,-89.00,-1213.90,828.10,110.90}},
		{"Kincaid Bridge",              {-1213.90,721.10,-89.00,-1087.90,950.00,110.90}},
		{"Kincaid Bridge",              {-1087.90,855.30,-89.00,-961.90,986.20,110.90}},
		{"King's",                      {-2329.30,458.40,-7.60,-1993.20,578.30,200.00}},
		{"King's",                      {-2411.20,265.20,-9.10,-1993.20,373.50,200.00}},
		{"King's",                      {-2253.50,373.50,-9.10,-1993.20,458.40,200.00}},
		{"LVA Freight Depot",           {1457.30,863.20,-89.00,1777.40,1143.20,110.90}},
		{"LVA Freight Depot",           {1375.60,919.40,-89.00,1457.30,1203.20,110.90}},
		{"LVA Freight Depot",           {1277.00,1087.60,-89.00,1375.60,1203.20,110.90}},
		{"LVA Freight Depot",           {1315.30,1044.60,-89.00,1375.60,1087.60,110.90}},
		{"LVA Freight Depot",           {1236.60,1163.40,-89.00,1277.00,1203.20,110.90}},
		{"Las Barrancas",               {-926.10,1398.70,-3.00,-719.20,1634.60,200.00}},
		{"Las Brujas",                  {-365.10,2123.00,-3.00,-208.50,2217.60,200.00}},
		{"Las Colinas",                 {1994.30,-1100.80,-89.00,2056.80,-920.80,110.90}},
		{"Las Colinas",                 {2056.80,-1126.30,-89.00,2126.80,-920.80,110.90}},
		{"Las Colinas",                 {2185.30,-1154.50,-89.00,2281.40,-934.40,110.90}},
		{"Las Colinas",                 {2126.80,-1126.30,-89.00,2185.30,-934.40,110.90}},
		{"Las Colinas",                 {2747.70,-1120.00,-89.00,2959.30,-945.00,110.90}},
		{"Las Colinas",                 {2632.70,-1135.00,-89.00,2747.70,-945.00,110.90}},
		{"Las Colinas",                 {2281.40,-1135.00,-89.00,2632.70,-945.00,110.90}},
		{"Las Payasadas",               {-354.30,2580.30,2.00,-133.60,2816.80,200.00}},
		{"Las Venturas Airport",        {1236.60,1203.20,-89.00,1457.30,1883.10,110.90}},
		{"Las Venturas Airport",        {1457.30,1203.20,-89.00,1777.30,1883.10,110.90}},
		{"Las Venturas Airport",        {1457.30,1143.20,-89.00,1777.40,1203.20,110.90}},
		{"Las Venturas Airport",        {1515.80,1586.40,-12.50,1729.90,1714.50,87.50}},
		{"Last Dime Motel",             {1823.00,596.30,-89.00,1997.20,823.20,110.90}},
		{"Leafy Hollow",                {-1166.90,-1856.00,0.00,-815.60,-1602.00,200.00}},
		{"Liberty City",                {-1000.00,400.00,1300.00,-700.00,600.00,1400.00}},
		{"Lil' Probe Inn",              {-90.20,1286.80,-3.00,153.80,1554.10,200.00}},
		{"Linden Side",                 {2749.90,943.20,-89.00,2923.30,1198.90,110.90}},
		{"Linden Station",              {2749.90,1198.90,-89.00,2923.30,1548.90,110.90}},
		{"Linden Station",              {2811.20,1229.50,-39.50,2861.20,1407.50,60.40}},
		{"Little Mexico",               {1701.90,-1842.20,-89.00,1812.60,-1722.20,110.90}},
		{"Little Mexico",               {1758.90,-1722.20,-89.00,1812.60,-1577.50,110.90}},
		{"Los Flores",                  {2581.70,-1454.30,-89.00,2632.80,-1393.40,110.90}},
		{"Los Flores",                  {2581.70,-1393.40,-89.00,2747.70,-1135.00,110.90}},
		{"Los Santos International",    {1249.60,-2394.30,-89.00,1852.00,-2179.20,110.90}},
		{"Los Santos International",    {1852.00,-2394.30,-89.00,2089.00,-2179.20,110.90}},
		{"Los Santos International",    {1382.70,-2730.80,-89.00,2201.80,-2394.30,110.90}},
		{"Los Santos International",    {1974.60,-2394.30,-39.00,2089.00,-2256.50,60.90}},
		{"Los Santos International",    {1400.90,-2669.20,-39.00,2189.80,-2597.20,60.90}},
		{"Los Santos International",    {2051.60,-2597.20,-39.00,2152.40,-2394.30,60.90}},
		{"Marina",                      {647.70,-1804.20,-89.00,851.40,-1577.50,110.90}},
		{"Marina",                      {647.70,-1577.50,-89.00,807.90,-1416.20,110.90}},
		{"Marina",                      {807.90,-1577.50,-89.00,926.90,-1416.20,110.90}},
		{"Market",                      {787.40,-1416.20,-89.00,1072.60,-1310.20,110.90}},
		{"Market",                      {952.60,-1310.20,-89.00,1072.60,-1130.80,110.90}},
		{"Market",                      {1072.60,-1416.20,-89.00,1370.80,-1130.80,110.90}},
		{"Market",                      {926.90,-1577.50,-89.00,1370.80,-1416.20,110.90}},
		{"Market Station",              {787.40,-1410.90,-34.10,866.00,-1310.20,65.80}},
		{"Martin Bridge",               {-222.10,293.30,0.00,-122.10,476.40,200.00}},
		{"Missionary Hill",             {-2994.40,-811.20,0.00,-2178.60,-430.20,200.00}},
		{"Montgomery",                  {1119.50,119.50,-3.00,1451.40,493.30,200.00}},
		{"Montgomery",                  {1451.40,347.40,-6.10,1582.40,420.80,200.00}},
		{"Montgomery Intersection",     {1546.60,208.10,0.00,1745.80,347.40,200.00}},
		{"Montgomery Intersection",     {1582.40,347.40,0.00,1664.60,401.70,200.00}},
		{"Mulholland",                  {1414.00,-768.00,-89.00,1667.60,-452.40,110.90}},
		{"Mulholland",                  {1281.10,-452.40,-89.00,1641.10,-290.90,110.90}},
		{"Mulholland",                  {1269.10,-768.00,-89.00,1414.00,-452.40,110.90}},
		{"Mulholland",                  {1357.00,-926.90,-89.00,1463.90,-768.00,110.90}},
		{"Mulholland",                  {1318.10,-910.10,-89.00,1357.00,-768.00,110.90}},
		{"Mulholland",                  {1169.10,-910.10,-89.00,1318.10,-768.00,110.90}},
		{"Mulholland",                  {768.60,-954.60,-89.00,952.60,-860.60,110.90}},
		{"Mulholland",                  {687.80,-860.60,-89.00,911.80,-768.00,110.90}},
		{"Mulholland",                  {737.50,-768.00,-89.00,1142.20,-674.80,110.90}},
		{"Mulholland",                  {1096.40,-910.10,-89.00,1169.10,-768.00,110.90}},
		{"Mulholland",                  {952.60,-937.10,-89.00,1096.40,-860.60,110.90}},
		{"Mulholland",                  {911.80,-860.60,-89.00,1096.40,-768.00,110.90}},
		{"Mulholland",                  {861.00,-674.80,-89.00,1156.50,-600.80,110.90}},
		{"Mulholland Intersection",     {1463.90,-1150.80,-89.00,1812.60,-768.00,110.90}},
		{"North Rock",                  {2285.30,-768.00,0.00,2770.50,-269.70,200.00}},
		{"Ocean Docks",                 {2373.70,-2697.00,-89.00,2809.20,-2330.40,110.90}},
		{"Ocean Docks",                 {2201.80,-2418.30,-89.00,2324.00,-2095.00,110.90}},
		{"Ocean Docks",                 {2324.00,-2302.30,-89.00,2703.50,-2145.10,110.90}},
		{"Ocean Docks",                 {2089.00,-2394.30,-89.00,2201.80,-2235.80,110.90}},
		{"Ocean Docks",                 {2201.80,-2730.80,-89.00,2324.00,-2418.30,110.90}},
		{"Ocean Docks",                 {2703.50,-2302.30,-89.00,2959.30,-2126.90,110.90}},
		{"Ocean Docks",                 {2324.00,-2145.10,-89.00,2703.50,-2059.20,110.90}},
		{"Ocean Flats",                 {-2994.40,277.40,-9.10,-2867.80,458.40,200.00}},
		{"Ocean Flats",                 {-2994.40,-222.50,-0.00,-2593.40,277.40,200.00}},
		{"Ocean Flats",                 {-2994.40,-430.20,-0.00,-2831.80,-222.50,200.00}},
		{"Octane Springs",              {338.60,1228.50,0.00,664.30,1655.00,200.00}},
		{"Old Venturas Strip",          {2162.30,2012.10,-89.00,2685.10,2202.70,110.90}},
		{"Palisades",                   {-2994.40,458.40,-6.10,-2741.00,1339.60,200.00}},
		{"Palomino Creek",              {2160.20,-149.00,0.00,2576.90,228.30,200.00}},
		{"Paradiso",                    {-2741.00,793.40,-6.10,-2533.00,1268.40,200.00}},
		{"Pershing Square",             {1440.90,-1722.20,-89.00,1583.50,-1577.50,110.90}},
		{"Pilgrim",                     {2437.30,1383.20,-89.00,2624.40,1783.20,110.90}},
		{"Pilgrim",                     {2624.40,1383.20,-89.00,2685.10,1783.20,110.90}},
		{"Pilson Intersection",         {1098.30,2243.20,-89.00,1377.30,2507.20,110.90}},
		{"Pirates in Men's Pants",      {1817.30,1469.20,-89.00,2027.40,1703.20,110.90}},
		{"Playa del Seville",           {2703.50,-2126.90,-89.00,2959.30,-1852.80,110.90}},
		{"Prickle Pine",                {1534.50,2583.20,-89.00,1848.40,2863.20,110.90}},
		{"Prickle Pine",                {1117.40,2507.20,-89.00,1534.50,2723.20,110.90}},
		{"Prickle Pine",                {1848.40,2553.40,-89.00,1938.80,2863.20,110.90}},
		{"Prickle Pine",                {1938.80,2624.20,-89.00,2121.40,2861.50,110.90}},
		{"Queens",                      {-2533.00,458.40,0.00,-2329.30,578.30,200.00}},
		{"Queens",                      {-2593.40,54.70,0.00,-2411.20,458.40,200.00}},
		{"Queens",                      {-2411.20,373.50,0.00,-2253.50,458.40,200.00}},
		{"Randolph Industrial Estate",  {1558.00,596.30,-89.00,1823.00,823.20,110.90}},
		{"Redsands East",               {1817.30,2011.80,-89.00,2106.70,2202.70,110.90}},
		{"Redsands East",               {1817.30,2202.70,-89.00,2011.90,2342.80,110.90}},
		{"Redsands East",               {1848.40,2342.80,-89.00,2011.90,2478.40,110.90}},
		{"Redsands West",               {1236.60,1883.10,-89.00,1777.30,2142.80,110.90}},
		{"Redsands West",               {1297.40,2142.80,-89.00,1777.30,2243.20,110.90}},
		{"Redsands West",               {1377.30,2243.20,-89.00,1704.50,2433.20,110.90}},
		{"Redsands West",               {1704.50,2243.20,-89.00,1777.30,2342.80,110.90}},
		{"Regular Tom",                 {-405.70,1712.80,-3.00,-276.70,1892.70,200.00}},
		{"Richman",                     {647.50,-1118.20,-89.00,787.40,-954.60,110.90}},
		{"Richman",                     {647.50,-954.60,-89.00,768.60,-860.60,110.90}},
		{"Richman",                     {225.10,-1369.60,-89.00,334.50,-1292.00,110.90}},
		{"Richman",                     {225.10,-1292.00,-89.00,466.20,-1235.00,110.90}},
		{"Richman",                     {72.60,-1404.90,-89.00,225.10,-1235.00,110.90}},
		{"Richman",                     {72.60,-1235.00,-89.00,321.30,-1008.10,110.90}},
		{"Richman",                     {321.30,-1235.00,-89.00,647.50,-1044.00,110.90}},
		{"Richman",                     {321.30,-1044.00,-89.00,647.50,-860.60,110.90}},
		{"Richman",                     {321.30,-860.60,-89.00,687.80,-768.00,110.90}},
		{"Richman",                     {321.30,-768.00,-89.00,700.70,-674.80,110.90}},
		{"Robada Intersection",         {-1119.00,1178.90,-89.00,-862.00,1351.40,110.90}},
		{"Roca Escalante",              {2237.40,2202.70,-89.00,2536.40,2542.50,110.90}},
		{"Roca Escalante",              {2536.40,2202.70,-89.00,2625.10,2442.50,110.90}},
		{"Rockshore East",              {2537.30,676.50,-89.00,2902.30,943.20,110.90}},
		{"Rockshore West",              {1997.20,596.30,-89.00,2377.30,823.20,110.90}},
		{"Rockshore West",              {2377.30,596.30,-89.00,2537.30,788.80,110.90}},
		{"Rodeo",                       {72.60,-1684.60,-89.00,225.10,-1544.10,110.90}},
		{"Rodeo",                       {72.60,-1544.10,-89.00,225.10,-1404.90,110.90}},
		{"Rodeo",                       {225.10,-1684.60,-89.00,312.80,-1501.90,110.90}},
		{"Rodeo",                       {225.10,-1501.90,-89.00,334.50,-1369.60,110.90}},
		{"Rodeo",                       {334.50,-1501.90,-89.00,422.60,-1406.00,110.90}},
		{"Rodeo",                       {312.80,-1684.60,-89.00,422.60,-1501.90,110.90}},
		{"Rodeo",                       {422.60,-1684.60,-89.00,558.00,-1570.20,110.90}},
		{"Rodeo",                       {558.00,-1684.60,-89.00,647.50,-1384.90,110.90}},
		{"Rodeo",                       {466.20,-1570.20,-89.00,558.00,-1385.00,110.90}},
		{"Rodeo",                       {422.60,-1570.20,-89.00,466.20,-1406.00,110.90}},
		{"Rodeo",                       {466.20,-1385.00,-89.00,647.50,-1235.00,110.90}},
		{"Rodeo",                       {334.50,-1406.00,-89.00,466.20,-1292.00,110.90}},
		{"Royal Casino",                {2087.30,1383.20,-89.00,2437.30,1543.20,110.90}},
		{"San Andreas Sound",           {2450.30,385.50,-100.00,2759.20,562.30,200.00}},
		{"Santa Flora",                 {-2741.00,458.40,-7.60,-2533.00,793.40,200.00}},
		{"Santa Maria Beach",           {342.60,-2173.20,-89.00,647.70,-1684.60,110.90}},
		{"Santa Maria Beach",           {72.60,-2173.20,-89.00,342.60,-1684.60,110.90}},
		{"Shady Cabin",                 {-1632.80,-2263.40,-3.00,-1601.30,-2231.70,200.00}},
		{"Shady Creeks",                {-1820.60,-2643.60,-8.00,-1226.70,-1771.60,200.00}},
		{"Shady Creeks",                {-2030.10,-2174.80,-6.10,-1820.60,-1771.60,200.00}},
		{"Sobell Rail Yards",           {2749.90,1548.90,-89.00,2923.30,1937.20,110.90}},
		{"Spinybed",                    {2121.40,2663.10,-89.00,2498.20,2861.50,110.90}},
		{"Starfish Casino",             {2437.30,1783.20,-89.00,2685.10,2012.10,110.90}},
		{"Starfish Casino",             {2437.30,1858.10,-39.00,2495.00,1970.80,60.90}},
		{"Starfish Casino",             {2162.30,1883.20,-89.00,2437.30,2012.10,110.90}},
		{"Temple",                      {1252.30,-1130.80,-89.00,1378.30,-1026.30,110.90}},
		{"Temple",                      {1252.30,-1026.30,-89.00,1391.00,-926.90,110.90}},
		{"Temple",                      {1252.30,-926.90,-89.00,1357.00,-910.10,110.90}},
		{"Temple",                      {952.60,-1130.80,-89.00,1096.40,-937.10,110.90}},
		{"Temple",                      {1096.40,-1130.80,-89.00,1252.30,-1026.30,110.90}},
		{"Temple",                      {1096.40,-1026.30,-89.00,1252.30,-910.10,110.90}},
		{"The Camel's Toe",             {2087.30,1203.20,-89.00,2640.40,1383.20,110.90}},
		{"The Clown's Pocket",          {2162.30,1783.20,-89.00,2437.30,1883.20,110.90}},
		{"The Emerald Isle",            {2011.90,2202.70,-89.00,2237.40,2508.20,110.90}},
		{"The Farm",                    {-1209.60,-1317.10,114.90,-908.10,-787.30,251.90}},
		{"The Four Dragons Casino",     {1817.30,863.20,-89.00,2027.30,1083.20,110.90}},
		{"The High Roller",             {1817.30,1283.20,-89.00,2027.30,1469.20,110.90}},
		{"The Mako Span",               {1664.60,401.70,0.00,1785.10,567.20,200.00}},
		{"The Panopticon",              {-947.90,-304.30,-1.10,-319.60,327.00,200.00}},
		{"The Pink Swan",               {1817.30,1083.20,-89.00,2027.30,1283.20,110.90}},
		{"The Sherman Dam",             {-968.70,1929.40,-3.00,-481.10,2155.20,200.00}},
		{"The Strip",                   {2027.40,863.20,-89.00,2087.30,1703.20,110.90}},
		{"The Strip",                   {2106.70,1863.20,-89.00,2162.30,2202.70,110.90}},
		{"The Strip",                   {2027.40,1783.20,-89.00,2162.30,1863.20,110.90}},
		{"The Strip",                   {2027.40,1703.20,-89.00,2137.40,1783.20,110.90}},
		{"The Visage",                  {1817.30,1863.20,-89.00,2106.70,2011.80,110.90}},
		{"The Visage",                  {1817.30,1703.20,-89.00,2027.40,1863.20,110.90}},
		{"Unity Station",               {1692.60,-1971.80,-20.40,1812.60,-1932.80,79.50}},
		{"Valle Ocultado",              {-936.60,2611.40,2.00,-715.90,2847.90,200.00}},
		{"Verdant Bluffs",              {930.20,-2488.40,-89.00,1249.60,-2006.70,110.90}},
		{"Verdant Bluffs",              {1073.20,-2006.70,-89.00,1249.60,-1842.20,110.90}},
		{"Verdant Bluffs",              {1249.60,-2179.20,-89.00,1692.60,-1842.20,110.90}},
		{"Verdant Meadows",             {37.00,2337.10,-3.00,435.90,2677.90,200.00}},
		{"Verona Beach",                {647.70,-2173.20,-89.00,930.20,-1804.20,110.90}},
		{"Verona Beach",                {930.20,-2006.70,-89.00,1073.20,-1804.20,110.90}},
		{"Verona Beach",                {851.40,-1804.20,-89.00,1046.10,-1577.50,110.90}},
		{"Verona Beach",                {1161.50,-1722.20,-89.00,1323.90,-1577.50,110.90}},
		{"Verona Beach",                {1046.10,-1722.20,-89.00,1161.50,-1577.50,110.90}},
		{"Vinewood",                    {787.40,-1310.20,-89.00,952.60,-1130.80,110.90}},
		{"Vinewood",                    {787.40,-1130.80,-89.00,952.60,-954.60,110.90}},
		{"Vinewood",                    {647.50,-1227.20,-89.00,787.40,-1118.20,110.90}},
		{"Vinewood",                    {647.70,-1416.20,-89.00,787.40,-1227.20,110.90}},
		{"Whitewood Estates",           {883.30,1726.20,-89.00,1098.30,2507.20,110.90}},
		{"Whitewood Estates",           {1098.30,1726.20,-89.00,1197.30,2243.20,110.90}},
		{"Willowfield",                 {1970.60,-2179.20,-89.00,2089.00,-1852.80,110.90}},
		{"Willowfield",                 {2089.00,-2235.80,-89.00,2201.80,-1989.90,110.90}},
		{"Willowfield",                 {2089.00,-1989.90,-89.00,2324.00,-1852.80,110.90}},
		{"Willowfield",                 {2201.80,-2095.00,-89.00,2324.00,-1989.90,110.90}},
		{"Willowfield",                 {2541.70,-1941.40,-89.00,2703.50,-1852.80,110.90}},
		{"Willowfield",                 {2324.00,-2059.20,-89.00,2541.70,-1852.80,110.90}},
		{"Willowfield",                 {2541.70,-2059.20,-89.00,2703.50,-1941.40,110.90}},
		{"Yellow Bell Station",         {1377.40,2600.40,-21.90,1492.40,2687.30,78.00}},
		{"Los Santos",                  {44.60,-2892.90,-242.90,2997.00,-768.00,900.00}},
		{"Las Venturas",                {869.40,596.30,-242.90,2997.00,2993.80,900.00}},
		{"Bone County",                 {-480.50,596.30,-242.90,869.40,2993.80,900.00}},
		{"Tierra Robada",               {-2997.40,1659.60,-242.90,-480.50,2993.80,900.00}},
		{"Tierra Robada",               {-1213.90,596.30,-242.90,-480.50,1659.60,900.00}},
		{"San Fierro",                  {-2997.40,-1115.50,-242.90,-1213.90,1659.60,900.00}},
		{"Red County",                  {-1213.90,-768.00,-242.90,2997.00,596.30,900.00}},
		{"Flint County",                {-1213.90,-2892.90,-242.90,44.60,-768.00,900.00}},
		{"Whetstone",                   {-2997.40,-2892.90,-242.90,-1213.90,-1115.50,900.00}}
	};
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

new AREA_beliPerabot[sizeof(POSISI_BELI_PERABOT)];

enum    E_ATM
{
	// saved
	Float: atmX,
	Float: atmY,
	Float: atmZ,
	Float: atmRX,
	Float: atmRY,
	Float: atmRZ,
	// temp
	atmObjID,	
	Text3D: atmLabel
}
new	ATMData[MAX_ATMS][E_ATM],
	Iterator: ATMs<MAX_ATMS>,
	EditingATMID[MAX_PLAYERS] = {-1, ...};
