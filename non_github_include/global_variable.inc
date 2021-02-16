/*
    GLOBAL VARIABEL FOR SERVER
*/
new last_hari,
	worldTimer;

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
	expScore,
	pScore,
	usedWeapon,
	usedWeaponId,
	usedAmmo,
	usedKtp,

	levelAdmin,

	// Skill EXP
	expMekanik,
	activeMekanik,
	expMedic,
	activeMedic,
	expBlacksmith,
	activeBlacksmith,

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
    Float:last_stats_energi,

    // Status
    Float:lastHp,
    Float:lastArmour,

    Float:statusMakan,
    Float:statusMinum,
    Float:statusEnergi,

	statusVw,
	statusInt,

	// Menyimpan timer count down sebelum dia di spawn di rumah sakit
	inDie, // Jika sedang sekarat bilangan positif - untuk sekarat, 0 - untuk false
	inPenjara, // Jika sedang di penjara
	inHelp, // Jika sedang minta bantuan polisi

    preloadAnim, // Preload anim
	inHouse,

    // Equiped Item
    ePhone, // Berisi versi HP, jika 0 maka hp tidak terequip
    sHouse, // Berisi ID Rumah, untuk spawn dirumah jika tidak 0
    nomorHP[12], // Berisi 62 + 4 kode
	masaAktifNomor, // Berisi masa aktif dalam satuan detik
	masaAktifJamsos, // Berisi masa aktif dalam satuan detik

    nomorRekening[10], // Berisi 8 digit kode rekening
    
    waktuSaatLogin, // menyimpan gettickcount yang didapat saat login (untuk menghitung lama bermain sejak login)
    lamaBermain, // menyimpan waktu (dalam detik) yang didapat dari database

	sisaGergaji,
	sisaTombak,
	sisaJoran,
    // Tambang
    sisaPalu,
    bool:activeMarker,
	tidak_dikenali,

    // Settings
    bool:tampilHUDStats,
    bool:tampilSpeedo,
    bool:photoMode, // Photo Mode
    bool:tampilJam,

    bool:sudahSpawn,
    bool:sudahLogin,
    Cache:kotakPesan,
    reply, // -1 kalau gaada
	bool:onSelectedTextdraw,
    lastGlobalChat,
	lastAsk,
	lastReport,
	bool:isOnAnimation, // Save state untuk animation
	onTradeWith,

	bool:isBusy, // Saat melakukan kegiatan yang tidak dapat diganggu

	levelMedic,	
	levelPolice,

	onDutyPolice,
	onDutyMedic,

	skinDuty,

	// menyimpan ID item (mask/helm) yang sedang digunakan
	// 0 jika tidak memakai apapun
	isOnMask, 

	inSpectating, // ID player yang sedang di spec
	bool:inSpectate, // Jika sedang dispectator

	hungryStackedTime, // Untuk menghitung waktu yang berlalu di timer player update
	thirstyStackedTime, // Untuk menghitung waktu yang berlalu di timer player update
	energyStackedTime, // Untuk menghitung waktu yang berlalu di timer player update

	timerPemain,
	timerDie, // countdown saat died
	loginAttempt,

	// User Achievement
	ach_IkanArwana,
	ach_IkanKakap,
	ach_IkanMas,
	ach_IkanMujair,
	ach_UburUbur,
	ach_BintangLaut,
	ach_Berlian,
	ach_Emas,
	ach_Aluminium,
	ach_Perak,
	ach_Besi,
	ach_Kayu,
	ach_BatuBara,
	ach_BatuBata,
	ach_Berlaut,
	ach_Bertambang,
	ach_MotongPohon,
	ach_Sweeper,
	ach_Trashmaster,
	ach_Pizzaboy,
	ach_MontirListrik,

	// User Count
	ucnt_Payday
}
new PlayerInfo[MAX_PLAYERS][pInfo];

/**
	Index 0 pada ID_ITEM akan dikosongkan sebagai INVALID_ID_ITEM
 */
enum PLAYER_ITEM_INFO {
	jumlahItem,
	kunciItem
};
new PlayerItem[MAX_PLAYERS][MAX_SERVER_ITEM + 1][PLAYER_ITEM_INFO];

/**
	Menyimpan ID unik saat pemilihan DIALOG (Dialog yang menggunakan konsep PAGINATION)
 */
new TempPlayerDialog[MAX_PLAYERS][BANYAK_DATA_PER_PAGE];

enum rInfo
{
    freeSkinID,
    jenisKelamin, // 0 - Laki, 1 - Perempuan
    registerPassword[25],
    email[100]
}
new registerInfo[MAX_PLAYERS][rInfo];


new msg[256];
// new total_vehicles_from_files=0;

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
new houseInfo[MAX_HOUSES][hInfo],
	lastHousePickup[MAX_PLAYERS] = {-1, ...},
	Iterator:houseIterator<MAX_HOUSES>,
	Text3D:houseTextInfo[MAX_HOUSES],
	housePickup[MAX_HOUSES] = {-1, ...},
	houseId[MAX_HOUSES] = {-1, ...},
	houseNotif[MAX_PLAYERS];

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
new PlayerText:showItem[MAX_PLAYERS][7];
new PlayerText:myInfo[MAX_PLAYERS][9];
// new PlayerText:RadarUang[MAX_PLAYERS][2];

new Text:HUD_Stats_PB[7];
new PlayerText:HUD_Stats[MAX_PLAYERS][1];
new PlayerBar:HUD_Stats_Bar[MAX_PLAYERS][3];

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
    {988.1448,-1686.0592,14.3905,272.0553, 0, 0},
    {988.1206,-1691.5792,14.3923,269.6691, 0, 0},
    {988.2432,-1697.1013,14.2885,272.8525, 0, 0}
};

// 10000.0225 original z coordinat
// 6.500 derajat yang diturunkan
// z coords =  10000.0225 - 6.500 = 3.500 
new const POSISI_SPAWN_SETELAH_MATI[][SPAWN_POINT_INFO] = {
    {173.3954, 1761.8878, 3500.0225, 173.3254, 1, 1},
    {173.0196, 1755.2919, 3500.0225, 178.3621, 1, 1},
    {164.1930, 1755.6797, 3500.0225, 173.9520, 1, 1},
    {163.3318, 1761.8503, 3500.0225, 179.5920, 1, 1}
};

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

new const POSISI_PEMOTONGAN_KAYU[][COORD_OBJ] = {
	// {-755.1526, -126.1716,	65.8156, 0, 0},
	{2351.5806, -659.4711, 128.1192, 0, 0}
};

new const POSISI_POM_BENSIN[][COORD_OBJ] = {
	{1938.1053, -1769.1456, 13.4661, 0, 0},
	{1944.9032, -1776.5444, 13.4743, 0, 0},
	{-91.9739, -1175.7510, 2.2141, 0, 0},
	{-87.0256, -1164.6810, 2.2639, 0, 0},
	{-93.4246, -1161.1903, 2.2000, 0, 0},
	{-98.5865, -1172.6804, 2.4275, 0, 0},
	{-1609.5068, -2718.3643, 48.5391, 0, 0},
	{-1605.4352, -2714.5195, 48.5335, 0, 0},
	{-1602.0950, -2709.9807, 48.5391, 0, 0},
	{-2408.4580, 976.2238, 45.2969, 0, 0},
	{-2413.1545, 976.1708, 45.2969, 0, 0},
	{-2244.1072, -2560.9565, 31.9219, 0, 0},
	{-1668.2744, 411.0884, 7.1797, 0, 0},
	{-1675.1224, 417.6603, 7.1797, 0, 0},
	{2209.4446, 2474.5974, 10.8203, 0, 0},
	{2198.7783, 2474.6311, 10.8203, 0, 0},
	{605.2767, 1704.6172, 6.9922, 0, 0},
	{608.5376, 1699.8844, 6.9922, 0, 0},
	{611.9913, 1694.6963, 6.9922, 0, 0},
	{615.3057, 1689.8129, 6.9922, 0, 0},
	{618.8107, 1685.1272, 6.9922, 0, 0},
	{622.2621, 1680.0709, 6.9922, 0, 0},
	{-1328.9100, 2671.8999, 50.0625, 0, 0},
	{-1328.3160, 2677.4443, 50.0625, 0, 0},
	{-1327.3320, 2682.9253, 50.0625, 0, 0},
	{2114.8447, 927.4243, 10.8203, 0, 0},
	{2114.9688, 916.9023, 10.8203, 0, 0},
	{2639.8433, 1098.8259, 10.8203, 0, 0},
	{2639.9915, 1110.0159, 10.8203, 0, 0},
	{2147.4648, 2751.2532, 10.8203, 0, 0},
	{2147.6167, 2744.6179, 10.8203, 0, 0},
	{1596.2622, 2192.0042, 10.8203, 0, 0},
	{1596.0250, 2202.6191, 10.8203, 0, 0},
	{-1464.6050, 1858.9280, 32.6328, 0, 0},
	{-1477.5969, 1857.8298, 32.6398, 0, 0},
	{-1477.7167, 1865.6769, 32.6398, 0, 0},
	{-1465.5269, 1866.4586, 32.6328, 0, 0},
	{653.3097, -570.2745, 16.3359, 0, 0},
	{657.7396, -560.0369, 16.3359, 0, 0},
	{1382.6866, 457.3860, 19.9587, 0, 0},
	{1383.8420, 460.3765, 20.0818, 0, 0},
	{1020.2277, -1672.6490, 14.3501, 0, 0},
	{1016.2536, -1672.9060, 14.4898, 0, 0}
};

/**
    MARKET DIALOG
 */
enum INFO_BARANG_MARKET {
	idItemMarket,
    hargaItemMarket
}

new const BARANG_MARKET[][INFO_BARANG_MARKET] = {
    {6, 5}, // Materai
	{44, 8}, // Bensin 20 Liter
	{45, 15}, // Bensin 50 Liter
	{46, 23}, // Bensin 100 Liter
	{ID_PALU_TAMBANG, 20},
	{ID_GERGAJI_MESIN, 50},
	{ID_GPS, 50},
	{ID_ALAT_PERBAIKAN_KENDARAAN, 50},
	{ID_CAT_KENDARAAN, 500}
};

enum INFO_ENTRANCE {
	Float:enPosPickup[3],
	Float:enPosOut[4]
};

new const ENTRANCE_MARKET[][INFO_ENTRANCE] = {
	{{1352.3239, -1759.2528, 13.5078}, {1353.8392, -1757.3990, 13.5078, 269.0087}},
	{{1011.8785, -1668.0076, 14.8007}, {1013.8829, -1667.9923, 14.5905, 278.0317}},
	{{2368.1611, -1547.9805, 24.0093}, {2369.3091, -1545.4869, 24.0075, 354.1191}},
	{{1928.6827, -1776.2109, 13.5469}, {1930.2983, -1776.3458, 13.5469, 269.3515}},
	{{1833.5074, -1842.6177, 13.5781}, {1831.8655, -1842.7859, 13.5781, 90.4975}},
	{{1976.6428, -2036.7104, 13.5469}, {1974.7931, -2036.9342, 13.5469, 92.6177}},
	{{1000.3654, -920.0480, 42.3281}, {998.1776, -920.1943, 42.1797, 94.9204}}
};

new const ENTRANCE_RESTORAN[][INFO_ENTRANCE] = {
	{{928.9155, -1352.9557, 13.3438}, {924.8441, -1353.0880, 13.3768, 89.3053}},
	{{810.4855, -1616.1713, 13.5469}, {814.8109, -1616.3394, 13.6281, 245.7708}},
	{{2105.1301, -1806.5841, 13.5547}, {2103.7671, -1806.6877, 13.5547, 90.2480}},
	{{1199.3348, -918.1349, 43.1227}, {1199.2875, -919.6401, 43.1117, 181.3151}}
};

enum INFO_JUAL_PERABOT {
	IDPerabotDijual,
	NamaPerabotDijual[100],
	HargaPerabotDijual
}
new const PERABOT_DIJUAL[][INFO_JUAL_PERABOT] = {
	{1, "Meja I", 1000},
	{2, "Kasur Besar I", 2500},
	{3, "Kursi I", 750}
};

enum INFO_MENU_MAKANAN {
    idItemMakanan,
    hargaMakanan,
    Float:energiNambah
}

/*  
    $1 Minuman = 20%
    $1 Food = 10% 

	IMPORTANT: Definisikan Semua Makanan & Minuman Disini
		KARENA ENERGI AMBIL DARI SINI
*/
new const MENU_MAKANAN[][INFO_MENU_MAKANAN] = {
// Makanan
    {14, 10, 100.0}, // Steak
    {16, 7, 70.0}, // Nasi Bungkus
    {17, 4, 40.0}, // Sate
    {23, 3, 30.0}, // Roti
    {24, 1, 10.0}, // Telur Dadar

// Minuman
    {13, 1, 20.0}, // Air Mineral
    {18, 5, 100.0}, // Jus Jeruk
    {19, 3, 60.0}, // Es teh manis
    {20, 2, 40.0}, // Kopi Panas
    {21, 2, 40.0}, // Kopi Dingin
    {22, 4, 80.0} // Minuman Soda
};

enum INFO_MENU_ALAT {
    idItemAlat,
    hargaAlat
};

new const MENU_ALAT_MEKANIK[][INFO_MENU_ALAT] = {
    {ID_ALAT_PERBAIKAN_KENDARAAN, 45}, // Alat perbaikan kendaraan
    {ID_CAT_KENDARAAN, 480}, // Cat kendaraan
    {29, 500}, // Sparepart Kendaraan
    {30, 5000}, // Paint job
    {51, 10000} // Ultimate Parts
};

enum INFO_MENU_BLACKSMITH {
    idItemAlat,
    hargaAlat
};

new const MENU_ALAT_BLACKSMITH[][INFO_MENU_BLACKSMITH] = {
    {62, 10000} // Forger Case
};

new const MENU_BELI_ITEM_MEDIS[][INFO_BARANG_MARKET] = {
    {52, 25}, // Bubuk Herbal
    {53, 300}, // Obat Revive
    {58, 250}, // Pil Darah Merah 100
    {57, 150}, // Pil Darah Merah 50
    {56, 75}, // Pil Darah Merah 20
    {61, 200}, // Pil Darah Putih 100
    {60, 125}, // Pil Darah Putih 50
    {59, 60}, // Pil Darah Putih 20
    {55, 125}, // Medical Kit 100
    {54, 80} // Medical Kit 50
};

enum INFO_MENU_BIBIT {
    idItemBibit,
    namaBibit[100],
    hargaBibit,
	slotItem
}

new const MENU_BIBIT[][INFO_MENU_BIBIT] = {
// Bibit
    {ID_BIBIT_JERUK, "Bibit Jeruk", 15, 9},
	{ID_BIBIT_JAHE, "Bibit Jahe", 10, 9},
	{ID_BIBIT_TEMULAWAK, "Bibit Temulawak", 10, 9},
	{ID_BIBIT_ALPUKAT, "Bibit Alpukat", 15, 9},
	{ID_BIBIT_PEPAYA, "Bibit Pepaya", 15, 9},
	{ID_BIBIT_BELIMBING, "Bibit Belimbing", 15, 9},
	{ID_BIBIT_SRIKAYA, "Bibit Srikaya", 10, 9}
	#if HALLOWEEN_EVENT == true
	{ID_BIBIT_LABU, "Bibit Labu", 15, 9},
	#endif
};

new const MENU_BIBIT_NARKO[][INFO_MENU_BIBIT] = {
// Bibit Narko
    {33, "Bibit Kangkung Ijo", 25, 9}
};

enum INFO_MENU_ALAT_PANCING {
    idItem,
    namaItem[100],
    hargaItem,
	slotItem
}

new const MENU_ALAT_PANCING[][INFO_MENU_ALAT_PANCING] = {
// Item Pancing
    {35, "Joran Pancing", 50, 1},
	{36, "Tombak Ikan", 250, 1},
	{43, "Roti - Umpan Ikan", 1, 1}

};

new const MENU_PHONE[][INFO_BARANG_MARKET] = {
// Item Phone
    {1, 150}, // Ephone 1
    {2, 300},
	{3, 450},
    {4, 600}  // Ephone 4
};

enum INFO_RARITY {
	namaRarity[50],
	colorRarity[14] // Dalam bentuk string {hex}
}
new ITEM_RARITY[MAX_RARITY_ITEM][INFO_RARITY];

/**
    CHECKPOINT VARIABEL

new CP_tempatFoto,
    CP_spotBarangMarket[sizeof(POSISI_BELI_BARANG_MARKET)],
    CP_spotGantiSkin,
    CP_spotBeliSkin[3],
    CP_tellerBankLS[2],
    CP_Tambang[sizeof(POSISI_NAMBANG)],
    CP_beliMakanCepatSaji,
	CP_spawnReparasi[sizeof(POSISI_SPAWN_REPARASI_MOBIL)],
	CP_simRegis[1],
    CP_simPraktik[1],
    CP_pusatProperti[1];
*/

/**
    PICKUP VARIABEL
 */
new PU_tempatFoto_in[2],
    PU_tempatFoto_out,
    PU_market[sizeof(ENTRANCE_MARKET)],
    PU_restoran[sizeof(ENTRANCE_RESTORAN)],
	PU_keluarMarket,
    PU_tempatBaju[1][2],
    PU_cityHallMasuk[3],
    PU_cityHallKeluar,
    PU_bankLS[2][2], // [ENTER/EXIT][0/1]
    PU_keluarRestoran,
    PU_tempatKeluarRumah[2], // Hanya menyimpan ID terkecil dan Terbesar
    PU_policeDept_in[1],
    PU_policeDept_out[1],
	PU_marketPlace[2],
	PU_rumahSakit[1], // Untuk pintu keluar pakai Dynamic Area karena pickup tidak muncul
	PU_tokoGadget[1][2],
	PU_tambangBesi[2],
	PU_tempatBlacksmith[2],
	PU_tempatIlegalBlacksmith[2];

/**
	ACTOR VARIABEL
 */
enum {
	ACTOR_SKILL_MEKANIK,
	ACTOR_SKILL_BLACKSMITH,
	ACTOR_PENJUAL_DEALER,
	ACTOR_PERALATAN_PANCING,
	ACTOR_TOKO_BIBIT,
	ACTOR_TOKO_GADGET,
	ACTOR_RESEPSIONIS_PEMERINTAH,
	ACTOR_TELLER_BANK_LS_1,
	ACTOR_TELLER_BANK_LS_2,
	ACTOR_RUMAH_SAKIT,
	ACTOR_MARKETPLACE_1,
	ACTOR_MARKETPLACE_2,
	ACTOR_MARKETPLACE_3,
	ACTOR_MARKETPLACE_4,
	ACTOR_PEMBELI_TAMBANG_1,
	ACTOR_PEMBELI_KAYU_1,
	ACTOR_PEMBELI_IKAN,
	ACTOR_PEMBELI_BUAH
};

enum ACT_POSITION_INFO {
	ACT__Skin,
	ACT__Id,
	Float:ACT__Pos[4],
	ACT__Int,
	ACT__Vw,
	ACT__Nama[24]
};

/**
	IMPORTANT: LANGKAH MENAMBAHKAN ACTOR
	1. TAMBAHKAN CONSTANT DIBAWAH INI SESUAI DENGAN IDENTITAS ACTOR
	2. TAMBAHKAN PADA ONPLAYERTEXT

	SELESAI..
 */
new const ACT_POSITION[][ACT_POSITION_INFO] = {
	{50, ACTOR_SKILL_MEKANIK, {1003.1812, -1670.5426, 14.5905, 88.4179}, 0, 0, NAMA_ACTOR_SKILL_MEKANIK},
	{151, ACTOR_SKILL_BLACKSMITH, {699.5562, -454.6995, -25.6099, 0.8854}, 1, 1, NAMA_ACTOR_SKILL_BLACKSMITH},
	{17, ACTOR_PENJUAL_DEALER, {1012.9276, -1733.4741, 13.4834, 90.0930}, 0, 0, NAMA_ACTOR_PENJUAL_DEALER},
	{65, ACTOR_PERALATAN_PANCING, {1021.7353, -1892.2639, 12.7341, 273.1771}, 0, 0, NAMA_ACTOR_PENJUAL_PANCING},
	{130, ACTOR_TOKO_BIBIT, {-71.6964, 105.2363, 3.1172, 71.9547}, 0, 0, NAMA_ACTOR_PENJUAL_BIBIT},
	{141, ACTOR_TOKO_GADGET, {446.3421, 1238.8604, 1081.9045, 89.6002}, 1, 1, NAMA_ACTOR_PENJUAL_GADGET},
	{76, ACTOR_RESEPSIONIS_PEMERINTAH, {-501.2156, 296.5012, 2001.0950, 182.1136}, 1, 1, NAMA_ACTOR_PEMERINTAH},
	{141, ACTOR_TELLER_BANK_LS_1, {1391.5345, -30.0384, 1000.8950, 175.7600}, 1, 1, NAMA_ACTOR_TELLER_BANK_1},
	{141, ACTOR_TELLER_BANK_LS_2, {1386.0791, -30.0127, 1000.8950, 175.5193}, 1, 1, NAMA_ACTOR_TELLER_BANK_2},
	{141, ACTOR_RUMAH_SAKIT, {180.7404, 1777.2717, 3500.0225, 89.0838}, 1, 1, NAMA_ACTOR_RUMAH_SAKIT},
	{141, ACTOR_MARKETPLACE_1, {-2658.6680, 1413.9584, 906.2734, 359.4943}, 3, 1, NAMA_ACTOR_MARKETPLACE_1},
	{141, ACTOR_MARKETPLACE_2, {-2662.8401, 1410.8647, 906.2734, 88.1685}, 3, 1, NAMA_ACTOR_MARKETPLACE_2},
	{141, ACTOR_MARKETPLACE_3, {-2659.6921, 1406.6693, 906.2734, 178.7227}, 3, 1, NAMA_ACTOR_MARKETPLACE_3},
	{141, ACTOR_MARKETPLACE_4, {-2655.5066, 1409.6869, 906.2734, 270.2169}, 3, 1, NAMA_ACTOR_MARKETPLACE_4},
	{26, ACTOR_PEMBELI_TAMBANG_1, {-539.1688, -542.0021, 25.5234, 179.2752}, 0, 0, NAMA_ACTOR_PEMBELI_TAMBANG_1},
	{26, ACTOR_PEMBELI_KAYU_1, {-752.8927, -133.0457, 65.8281, 17.1701}, 0, 0, NAMA_ACTOR_PEMBELI_KAYU_1},
	{158, ACTOR_PEMBELI_IKAN, {403.8720, -2088.7983, 7.8359, 181.5444}, 0, 0, NAMA_ACTOR_PEMBELI_IKAN},
	{161, ACTOR_PEMBELI_BUAH, {-1061.4474, -1195.5634, 129.8281, 265.0136}, 0, 0, NAMA_ACTOR_PEMBELI_BUAH}
};

enum INFO_ACT_NPC {
	actConst,
	actID,
	Float:actPos[4],
	Text3D:actText,
	actUser,
	actRes,
	actTimer,
	actArea
};
new 
	ACT__reload,
	ACT_NPC[sizeof(ACT_POSITION)][INFO_ACT_NPC],
	
	/**
		Khusus Narko, karena actor pindah"
		Jadi dipisahkan dari actor umumnya
	 */
	ACT_tokoNarko,
	Text3D:ACT_tokoNarko_Text,
	ACT_tokoNarko_User = INVALID_PLAYER_ID,
	ACT_tokoNarko_Res = 0,
	ACT_tokoNarko_Timer = -1,
	ACT_tokoNarko_Area
	;

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

// Object Pintu Penjara
new pintuPenjara[3];

/*
    Virtual World untuk ngebedain pickup
*/
#define VW_tempatFoto_1 1
#define VW_tempatFoto_2 2

#define VW_tempatMakan_1 1
#define VW_tempatMakan_2 2

#define VW_tambangInterior 10

/**
    Job / Aktifitas
*/
new	todoFinish[MAX_PLAYERS],
	todoTimer[MAX_PLAYERS] = {-1, ...},
	todoTimeout[MAX_PLAYERS],
	removedVeh[MAX_PLAYERS],
	removedTimer[MAX_PLAYERS] = {-1, ...};

/* Sweeper */
new Iterator:vehicleSweeper<MAX_VEHICLES>,
    sweeperJob[MAX_PLAYERS],
    sweeperId[MAX_PLAYERS] = {-1, ...},
    vehicleSweeper[3],
    usedSweeper[MAX_VEHICLES];

/* Trashmaster */
new Iterator:trashM_Veh<MAX_VEHICLES>,
    trashM_Job[MAX_PLAYERS],
    trashM_Id[MAX_PLAYERS] = {-1, ...},
    trashM_Veh[3],
    trashM_Used[MAX_VEHICLES],
	trashM_House[MAX_PLAYERS] = {-1},
	trashM_Take[MAX_PLAYERS],
	trashM_BagCap[MAX_PLAYERS],
	trashM_VehCap[MAX_VEHICLES],
	Float:trashM_X[MAX_PLAYERS],
	Float:trashM_Y[MAX_PLAYERS],
	Float:trashM_Z[MAX_PLAYERS];

new jobHouseTake[MAX_PLAYERS][JOB_MAX_TASK],
	jobSallary[MAX_PLAYERS],
	Float:jobDistance[MAX_PLAYERS];

/* Pizzaboy */
new Iterator:pizza_Veh<MAX_VEHICLES>,
    pizza_Job[MAX_PLAYERS],
    pizza_Id[MAX_PLAYERS] = {-1, ...},
    pizza_Veh[3],
    pizza_Used[MAX_VEHICLES],
	pizza_House[MAX_PLAYERS] = {-1, ...},
	pizza_HouseDrop[MAX_PLAYERS],
	pizza_Carry[MAX_PLAYERS],
	pizza_VehCap[MAX_VEHICLES],
	pizza_Palang,
	pizza_PalangArea,
	pizza_PalangUsed,
	Float:pizza_X[MAX_PLAYERS],
	Float:pizza_Y[MAX_PLAYERS],
	Float:pizza_Z[MAX_PLAYERS];

/* Montir Listrik */
enum POINT_GARDU_PADAM_INFO {
	Float:GARDU_X,
    Float:GARDU_Y,
    Float:GARDU_Z,
	Float:GARDU_A
}

new const POINT_GARDU_PADAM[][POINT_GARDU_PADAM_INFO] = {
    {2687.3708,-1954.2535,13.5469,179.2838},
    {2666.5459,-1954.2578,13.5469,181.1639},
	{2644.8496,-1954.2562,13.5469,182.7306}
};

// Tiang Listrik
enum TiangInfo
{
    tiangObjID,
    Text3D:tiangLabel,
    Float: tiangX,
    Float: tiangY,
    Float: tiangZ,
    Float: tiangRX,
    Float: tiangRY,
    Float: tiangRZ
}

new Iterator:montirL_Veh<MAX_VEHICLES>,
    montirL_Job[MAX_PLAYERS],
    montirL_Id[MAX_PLAYERS] = {-1, ...},
    montirL_Veh[3],
    montirL_Used[MAX_VEHICLES],
	montirL_Alat[MAX_PLAYERS],
	montirL_AlatObj[MAX_PLAYERS],
	montirL_AlatPasang[MAX_PLAYERS],
	montirL_Timer[MAX_PLAYERS] = {-1, ...},

	Text3D:montirL_GarduLabel[MAX_PLAYERS],
	montirL_GarduPoint[MAX_PLAYERS] = {-1, ...},
	montirL_GarduPadam[sizeof(POINT_GARDU_PADAM)],
	montirL_GarduPadamEvent,
	montirL_GarduStart = -1,
	montirL_GarduEnd = -1,
	Float:montirL_PlayerX[MAX_PLAYERS],
	Float:montirL_PlayerY[MAX_PLAYERS],
	Float:montirL_PlayerZ[MAX_PLAYERS],
	Float:montirL_X[MAX_PLAYERS],
	Float:montirL_Y[MAX_PLAYERS],
	Float:montirL_Z[MAX_PLAYERS],

	Iterator:TiangIterator<MAX_TIANG_LISTRIK>,
    DTiang[MAX_TIANG_LISTRIK][TiangInfo],
    tiangEditID[MAX_PLAYERS] = {-1, ...},
	montirL_Tiang[MAX_PLAYERS] = {-1},
	montirL_TiangProses[MAX_PLAYERS] = {-1, ...},
	montirL_TiangCap[MAX_PLAYERS];

new ambulance_Veh[2];

/* SIM Kendaraan */
new Iterator:vehicleSIM<MAX_VEHICLES>,
    testSim[MAX_PLAYERS],
    poinSim[MAX_PLAYERS],
    vehicleIdSIM[MAX_PLAYERS] = {-1, ...},
    vehicleSIM[3],
    limitVehSIM[MAX_VEHICLES],
    Float:oldVehicleHealth[MAX_VEHICLES];

enum INFO_SOAL {
    simQuestion[16],
    simAnswer1[240],
    simAnswer2[240],
    simAnswer3[240],
    simAnswer4[240],
    simAnswerTrue,
    simQuestionMSG[240]
};

new const SIM_SOAL[][INFO_SOAL] = {
    {"Pertanyaan 1", "A. Jalur tengah", "B. Jalur kiri", "C. Jalur kanan", "D. Semua salah", 1, GREEN"[HALO Polisi] "WHITE"Saat berkendara kita harus memilih jalur?"},
    {"Pertanyaan 2", "A. 80 KmpH", "B. 35 KmpH", "C. 75 KmpH", "D. 50 KmpH", 2, GREEN"[HALO Polisi] "WHITE"Batas kecepatan saat mengendarai kendaraan?"},
    {"Pertanyaan 3", "A. Membawa surat lengkap", "B. Jalur kanan untuk mengurangi kecepatan", "C. Berhenti jika lampu lalu lintas merah", "D. Semua benar", 3, GREEN"[HALO Polisi] "WHITE"Berikut merupakan aturan berkendara yang benar?"},
    {"Pertanyaan 4", "A. Ambil jalur kanan", "B. Tidak menyalip", "C. Memberi tanda klakson", "D. Tetap menyalip", 4, GREEN"[HALO Polisi] "WHITE"Jika anda ingin menyalip ketika ada kendaraan dijalur kiri, apa yang anda lakukan?"},
    {"Pertanyaan 5", "A. Siapa saja", "B. Satpol PP", "C. Satpam", "D. Polisi", 3, GREEN"[HALO Polisi] "WHITE"Siapa yang berhak menindak pelanggaran lalu lintas?"},
    {"Pertanyaan 6", "A. Siapa saja", "B. Satpol PP", "C. Satpam", "D. Polisi", 2, GREEN"[HALO Polisi] "WHITE"Siapa yang berhak menasehati pelanggar lalu lintas?"}
};

/**
    Sewa Kendaraan
*/
enum INFO_HARGA_VEHICLE_RENT {
	namaModel[16],
	idModel,
    hargaModel
}

new const HARGA_VEHICLE_RENT[][INFO_HARGA_VEHICLE_RENT] = {
    {"Fagio", 462, 4},
	{"Bike", 509, 1},
	{"Bobcat", 422,10}
};

enum RentVehicleInfo
{
	rentVehID,
	rentVehList,
    rentVehModel,
	rentVehPlaceID,
    Float:rentVehPos[4],
	rentPlaceID,
	rentPlaceFree,
	rentPlaceFreeDurasi,
	Text3D:rentPlaceLabel,
	Float:rentPlacePos[3],
	rentPlayerVehID,
	rentPlayerVehList,
	rentPlayerVehUser,
	rentPlayerVehUserPid,
    rentPlayerVehModel,
	rentPlayerVehPlaceID,
	rentPlayerVehTime,
    Float:rentPlayerVehPos[4],
}

new Iterator:RentVehIterator<MAX_VEHICLES>,
	RentVeh[MAX_VEHICLES][RentVehicleInfo],
	Iterator:RentPlaceIterator<MAX_PLACE_RENT_VEHICLES>,
	RentPlace[MAX_PLACE_RENT_VEHICLES][RentVehicleInfo],
	Iterator:RentPlayerVehIter<MAX_VEHICLES>,
	RentPlayerVeh[MAX_VEHICLES][RentVehicleInfo],
	RentPlaceID[2048] = {-1, ...}, // Jumlah sphere / dynamic area, kalau di isi MAX_PLACE_RENT_VEHICLES jadi minus karena kelebihan kapasitas
	RentVehID[MAX_VEHICLES] = {-1, ...},
	RentVehEdit[MAX_PLAYERS],
	RentPlayerVehID[MAX_VEHICLES] = {-1, ...},
	RentPlayerVehUser[MAX_PLAYERS] = {-1, ...};

/**
    Speedometer
*/
new PlayerText:SpeedoTD_VehInfo[MAX_PLAYERS][2],
	PlayerBar:SpeedoTD_VehBar[MAX_PLAYERS][2],
    SpeedoTimer[MAX_PLAYERS] = {-1, ...},
	Text:SpeedoTD[4];


/**
    System Board
 */
enum boardInfo
{
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
new Iterator:BoardIterator<MAX_BOARDS>;

new bEditID[MAX_PLAYERS];
new Float:bCPos[MAX_PLAYERS][3];
new Float:bCRot[MAX_PLAYERS][3];

/**
    VEHICLE DEFINITION
*/

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

new const
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

new AREA_beliPerabot[sizeof(POSISI_BELI_PERABOT)],
	AREA_pomBensin[sizeof(POSISI_POM_BENSIN)],
	AREA_keluarRumahSakit[1], // Rumah Sakit pakai AREA karena pickup tidak bisa muncul di mappingannya
	AREA_onDutyPolisi, // Area On dan Off polisi
	AREA_onDutyMedic, // Area On dan Off medic
	AREA_GuidePemerintah,
	AREA_GuideAhliMekanik,
	AREA_GuideAhliBlacksmith,
	AREA_Guide_peralatanPancing,
	// AREA_Guide_tokoBibit,
	AREA_Guide_tokoGadget,
	AREA_Guide_penjualDealer,
	AREA_tempatFoto,
    AREA_spotBarangMarket[sizeof(POSISI_BELI_BARANG_MARKET)],
    AREA_spotGantiSkin,
    AREA_spotBeliSkin[3],
    // AREA_tellerBankLS[2],
    AREA_Tambang[sizeof(POSISI_NAMBANG)],
    AREA_beliMakanCepatSaji,
    AREA_simRegis[1],
    AREA_simPraktik[1],
    AREA_pusatProperti[1],
	AREA_spawnReparasi[sizeof(POSISI_SPAWN_REPARASI_MOBIL)],
	AREA_dalamPenjara,
	AREA_bisaNambang;

enum E_ATM
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

/**
    Farmer
*/
enum FarmInfo{
	plantName[32],
	plantItemID,
	// plantTimer,
	// destroyTimer,
	playerId,
	playerPlant,
	plantObjID,
	// plantSecs,
	plantHarvest,
	Text3D:plantLabel,
	Float: plantX,
    Float: plantY,
    Float: plantZ,
    Float: plantRX,
    Float: plantRY,
    Float: plantRZ,
	plantSecond
}

enum POINT_NARKO_ACTOR_INFO {
	Float:NARKO_X,
    Float:NARKO_Y,
    Float:NARKO_Z,
	Float:NARKO_A
}

new const POINT_NARKO_ACTOR[][POINT_NARKO_ACTOR_INFO] = {
    {-347.8122,-1045.7191,59.8125,182.658},
    {-76.8813,-1136.6028,1.0781,68.5732},
	{-401.5252,-1419.8257,26.3281,2.6630},
	{-611.1347,-1071.5476,23.4347,91.3293}
};

new Iterator:PlantIterator<MAX_PLANTS>,
    DFarm[MAX_PLANTS][FarmInfo],
	MrPuyengRand;

new PerbaikiTimer[MAX_PLAYERS] = {-1, ...};

new const gVehicleColors[] =
{
    0x000000AA, 0xF5F5F5AA, 0x2A77A1AA, 0x840410AA, 0x263739AA, 0x86446EAA, 0xD78E10AA, 0x4C75B7AA, 0xBDBEC6AA, 0x5E7072AA,
    0x46597AAA, 0x656A79AA, 0x5D7E8DAA, 0x58595AAA, 0xD6DAD6AA, 0x9CA1A3AA, 0x335F3FAA, 0x730E1AAA, 0x7B0A2AAA, 0x9F9D94AA,
    0x3B4E78AA, 0x732E3EAA, 0x691E3BAA, 0x96918CAA, 0x515459AA, 0x3F3E45AA, 0xA5A9A7AA, 0x635C5AAA, 0x3D4A68AA, 0x979592AA,
    0x421F21AA, 0x5F272BAA, 0x8494ABAA, 0x767B7CAA, 0x646464AA, 0x5A5752AA, 0x252527AA, 0x2D3A35AA, 0x93A396AA, 0x6D7A88AA,
    0x221918AA, 0x6F675FAA, 0x7C1C2AAA, 0x5F0A15AA, 0x193826AA, 0x5D1B20AA, 0x9D9872AA, 0x7A7560AA, 0x989586AA, 0xADB0B0AA,
    0x848988AA, 0x304F45AA, 0x4D6268AA, 0x162248AA, 0x272F4BAA, 0x7D6256AA, 0x9EA4ABAA, 0x9C8D71AA, 0x6D1822AA, 0x4E6881AA,
    0x9C9C98AA, 0x917347AA, 0x661C26AA, 0x949D9FAA, 0xA4A7A5AA, 0x8E8C46AA, 0x341A1EAA, 0x6A7A8CAA, 0xAAAD8EAA, 0xAB988FAA,
    0x851F2EAA, 0x6F8297AA, 0x585853AA, 0x9AA790AA, 0x601A23AA, 0x20202CAA, 0xA4A096AA, 0xAA9D84AA, 0x78222BAA, 0x0E316DAA,
    0x722A3FAA, 0x7B715EAA, 0x741D28AA, 0x1E2E32AA, 0x4D322FAA, 0x7C1B44AA, 0x2E5B20AA, 0x395A83AA, 0x6D2837AA, 0xA7A28FAA,
    0xAFB1B1AA, 0x364155AA, 0x6D6C6EAA, 0x0F6A89AA, 0x204B6BAA, 0x2B3E57AA, 0x9B9F9DAA, 0x6C8495AA, 0x4D8495AA, 0xAE9B7FAA,
    0x406C8FAA, 0x1F253BAA, 0xAB9276AA, 0x134573AA, 0x96816CAA, 0x64686AAA, 0x105082AA, 0xA19983AA, 0x385694AA, 0x525661AA,
    0x7F6956AA, 0x8C929AAA, 0x596E87AA, 0x473532AA, 0x44624FAA, 0x730A27AA, 0x223457AA, 0x640D1BAA, 0xA3ADC6AA, 0x695853AA,
    0x9B8B80AA, 0x620B1CAA, 0x5B5D5EAA, 0x624428AA, 0x731827AA, 0x1B376DAA, 0xEC6AAEAA, 0x000000AA, 0x177517AA, 0x210606AA,
    0x125478AA, 0x452A0DAA, 0x571E1EAA, 0x010701AA, 0x25225AAA, 0x2C89AAAA, 0x8A4DBDAA, 0x35963AAA, 0xB7B7B7AA, 0x464C8DAA,
    0x84888CAA, 0x817867AA, 0x817A26AA, 0x6A506FAA, 0x583E6FAA, 0x8CB972AA, 0x824F78AA, 0x6D276AAA, 0x1E1D13AA, 0x1E1306AA,
    0x1F2518AA, 0x2C4531AA, 0x1E4C99AA, 0x2E5F43AA, 0x1E9948AA, 0x1E9999AA, 0x999976AA, 0x7C8499AA, 0x992E1EAA, 0x2C1E08AA,
    0x142407AA, 0x993E4DAA, 0x1E4C99AA, 0x198181AA, 0x1A292AAA, 0x16616FAA, 0x1B6687AA, 0x6C3F99AA, 0x481A0EAA, 0x7A7399AA,
    0x746D99AA, 0x53387EAA, 0x222407AA, 0x3E190CAA, 0x46210EAA, 0x991E1EAA, 0x8D4C8DAA, 0x805B80AA, 0x7B3E7EAA, 0x3C1737AA,
    0x733517AA, 0x781818AA, 0x83341AAA, 0x8E2F1CAA, 0x7E3E53AA, 0x7C6D7CAA, 0x020C02AA, 0x072407AA, 0x163012AA, 0x16301BAA,
    0x642B4FAA, 0x368452AA, 0x999590AA, 0x818D96AA, 0x99991EAA, 0x7F994CAA, 0x839292AA, 0x788222AA, 0x2B3C99AA, 0x3A3A0BAA,
    0x8A794EAA, 0x0E1F49AA, 0x15371CAA, 0x15273AAA, 0x375775AA, 0x060820AA, 0x071326AA, 0x20394BAA, 0x2C5089AA, 0x15426CAA,
    0x103250AA, 0x241663AA, 0x692015AA, 0x8C8D94AA, 0x516013AA, 0x090F02AA, 0x8C573AAA, 0x52888EAA, 0x995C52AA, 0x99581EAA,
    0x993A63AA, 0x998F4EAA, 0x99311EAA, 0x0D1842AA, 0x521E1EAA, 0x42420DAA, 0x4C991EAA, 0x082A1DAA, 0x96821DAA, 0x197F19AA,
    0x3B141FAA, 0x745217AA, 0x893F8DAA, 0x7E1A6CAA, 0x0B370BAA, 0x27450DAA, 0x071F24AA, 0x784573AA, 0x8A653AAA, 0x732617AA,
    0x319490AA, 0x56941DAA, 0x59163DAA, 0x1B8A2FAA, 0x38160BAA, 0x041804AA, 0x355D8EAA, 0x2E3F5BAA, 0x561A28AA, 0x4E0E27AA,
    0x706C67AA, 0x3B3E42AA, 0x2E2D33AA, 0x7B7E7DAA, 0x4A4442AA, 0x28344EAA
};

/*
	Mancing
*/
new mancingTimer[MAX_PLAYERS] = {-1, ...},
	mancingSecs[MAX_PLAYERS],
	mancingAktif[MAX_PLAYERS],
	nombakDelay[MAX_PLAYERS],
	Float:nombakDepth[MAX_PLAYERS];


/**
	Begin Faction
 */

/**		Define Faction ID	 **/
#define ID_FACTION_POLISI 1
#define ID_FACTION_MEDIC 2
#define ID_FACTION_PEMERINTAH 3

#define MEDIC_MAX_LEVEL 2
#define POLICE_MAX_LEVEL 4

#define MAX_OBJECT_POLICE 500
#define MIN_SPEEDLIMIT 50
#define MAX_SPEEDLIMIT 200

/*
	Jika tidak ada skin Female dan Male seperti Intel 
		> (berarti tidak perlu pakai skin dari faction) - Langsung On duty tanpa ganti skin
 */
enum InfoLevelFaction {
	namaJabatan[50],
	banyakSkinMale,
	banyakSkinFemale
}

// Medic
// NOTE : Level sesuai dengan urutan array
new const MEDIC_LEVEL[MEDIC_MAX_LEVEL][InfoLevelFaction] = {
	{"Perawat", 3, 1},
	{"Dokter", 1, 0}
};

new const MEDIC_SKIN_MALE[MEDIC_MAX_LEVEL][] = {
	{274, 275, 276},
	{70}
};

new const MEDIC_SKIN_FEMALE[MEDIC_MAX_LEVEL][] = {
	{308},
	{}
};

// Get Nama Level Medic menggunakan Macro
#define GetNamaLevelMedic(%0)				MEDIC_LEVEL[%0 - 1][namaJabatan]
#define GetMaleSkinMedicByLevel(%0)			MEDIC_SKIN_MALE[%0 - 1]
#define GetFemaleSkinMedicByLevel(%0)		MEDIC_SKIN_FEMALE[%0 - 1]

#define GetBanyakSkinMaleMedicByLevel(%0)			MEDIC_LEVEL[%0-1][banyakSkinMale]
#define GetBanyakSkinFemaleMedicByLevel(%0)		MEDIC_LEVEL[%0-1][banyakSkinFemale]

// Police
// NOTE : Level sesuai dengan urutan array
new const POLICE_LEVEL[POLICE_MAX_LEVEL][InfoLevelFaction] = {
	{"Polisi", 9, 3},
	{"FBI", 1, 0},
	{"S.W.A.T", 1, 0}, 
	{"CIA", 5, 0} // CIA bisa pakai skin orang biasa
};

new const POLICE_SKIN_MALE[POLICE_MAX_LEVEL][] = {
	{280, 281, 282, 283, 284, 310, 311, 300, 301},
	{286},
	{285},
	{165, 166, 163, 164}
};

new const POLICE_SKIN_FEMALE[POLICE_MAX_LEVEL][] = {
	{306, 307, 309},
	{},
	{},
	{}
};

// Get Nama Level Medic menggunakan Macro
#define GetNamaLevelPolice(%0)				POLICE_LEVEL[%0-1][namaJabatan]
#define GetMaleSkinPoliceByLevel(%0)		POLICE_SKIN_MALE[%0 - 1]
#define GetFemaleSkinPoliceByLevel(%0)		POLICE_SKIN_FEMALE[%0 - 1]

#define GetBanyakSkinMalePoliceByLevel(%0)		POLICE_LEVEL[%0-1][banyakSkinMale]
#define GetBanyakSkinFemalePoliceByLevel(%0)		POLICE_LEVEL[%0-1][banyakSkinFemale]

#define COLOR_POLISI 		COLOR_LIGHT_BLUE
#define COLOR_MEDIC 		COLOR_PINK

enum _:OBJECT_POLICE_TYPE
{
	OBJECT_TYPE_RANJAU,
	OBJECT_TYPE_BARIKADE,
	OBJECT_TYPE_GARIS,
	OBJECT_TYPE_SIGN,
	OBJECT_TYPE_SPEEDCAM
}

enum INFO_OBJECT_POLICE
{
	objID,
	objType,
	objAktif,
	objData,
	objArea,
	Text3D:objLabel,
	Float:objX,
	Float:objY,
	Float:objZ
};

new OBJECT_POLICE[MAX_OBJECT_POLICE][INFO_OBJECT_POLICE],
	Iterator:ObjPoliceIterator<MAX_OBJECT_POLICE>,
	EditingObjPolice[MAX_PLAYERS] = {-1, ...};
/**
	End Faction
 */

new Iterator:TidakDikenali<MAX_PLAYERS + 1>;

// Textdraw Photo Mode
new Text:TextDraw_PhotoMode[8],
    PlayerText:TextDraw_PhotoMode_Nama[MAX_PLAYERS];

/**
	Bahan-Bahan Blacksmith
 */
new const bahan_joran_pancing[][2] = {
	{12, 1}, // Perak - 1
	{25, 1}  // Kayu - 1
};

new const bahan_tombak_ikan[][2] = {
	{11, 1}, // Aluminium - 1
	{25, 1}  // Kayu - 1
};

new const bahan_bubuk_herbal[][2] = {
	{ID_KANGKUNG_IJO, 9}
};

new const bahan_pil_darah_merah_20[][2] = {
	{ID_BUBUK_HERBAL, 2},
	{ID_JAHE, 9},
	{ID_TEMULAWAK, 9}
};

new const bahan_pil_darah_merah_50[][2] = {
	{ID_BUBUK_HERBAL, 4},
	{ID_JAHE, 18},
	{ID_TEMULAWAK, 18}
};

new const bahan_pil_darah_merah_100[][2] = {
	{ID_BUBUK_HERBAL, 7},
	{ID_JAHE, 27},
	{ID_TEMULAWAK, 27}
};

new const bahan_weapon_colt_45[][2] = {
	{ID_BESI, 25},
	{ID_ALUMINIUM, 25}
};

new const bahan_weapon_s_colt_45[][2] = {
	{ID_BESI, 25},
	{ID_ALUMINIUM, 25},
	{ID_PERAK, 5}
};

new const bahan_weapon_deagle[][2] = {
	{ID_BESI, 30},
	{ID_ALUMINIUM, 25},
	{ID_PERAK, 30}
};

new const bahan_weapon_sg[][2] = {
	{ID_BESI, 30},
	{ID_ALUMINIUM, 30},
	{ID_PERAK, 10}
};

new const bahan_weapon_sawn_sg[][2] = {
	{ID_BESI, 40},
	{ID_ALUMINIUM, 30},
	{ID_PERAK, 10}
};

new const bahan_weapon_combat_sg[][2] = {
	{ID_BESI, 40},
	{ID_ALUMINIUM, 30},
	{ID_PERAK, 10}
};

new const bahan_weapon_uzi[][2] = {
	{ID_BESI, 20},
	{ID_ALUMINIUM, 30},
	{ID_PERAK, 20}
};

new const bahan_weapon_mp5[][2] = {
	{ID_BESI, 20},
	{ID_ALUMINIUM, 30},
	{ID_PERAK, 30}
};

new const bahan_weapon_tec[][2] = {
	{ID_BESI, 20},
	{ID_ALUMINIUM, 30},
	{ID_PERAK, 20}
};

new const bahan_weapon_m4[][2] = {
	{ID_BESI, 40},
	{ID_ALUMINIUM, 50},
	{ID_PERAK, 30}
};

new const bahan_weapon_ak47[][2] = {
	{ID_BESI, 40},
	{ID_ALUMINIUM, 50},
	{ID_PERAK, 30}
};

new const bahan_weapon_ammo45[][2] = {
	{ID_BESI, 2},
	{ID_ALUMINIUM, 2},
	{ID_BATU_BARA, 10}
};

new const bahan_weapon_ammo75[][2] = {
	{ID_BESI, 2},
	{ID_ALUMINIUM, 2},
	{ID_BATU_BARA, 10}
};

new const bahan_weapon_ammo125[][2] = {
	{ID_BESI, 5},
	{ID_ALUMINIUM, 5},
	{ID_BATU_BARA, 10}
};

new const bahan_besi_utuh[][2] = {
	{ID_BIJIH_BESI, 5} // Bijih besi - 5
};

new const bahan_emas_utuh[][2] = {
	{ID_SERBUK_EMAS, 9} 
};

new const bahan_perak_utuh[][2] = {
	{ID_BIJIH_PERAK, 5}
};

new const bahan_berlian_utuh[][2] = {
	{ID_SERBUK_BERLIAN, 9}
};

new const bahan_aluminium_utuh[][2] = {
	{ID_BIJIH_ALUMINIUM, 5} 
};

/**
	Penjual Tambang
 */
enum INFO_BARANG_DENGAN_JUMLAH {
	brgId,
	brgJumlah, // Satuan jumlah per stack
	// Harga jual ("harga asli" - 10%)
	brgHarga
};

new const list_barang_tampung_tambang[][INFO_BARANG_DENGAN_JUMLAH] = {
	{ID_PERAK, 4, 100},
	{ID_ALUMINIUM, 1, 200},
	{ID_BERLIAN, 1, 5000},
	{ID_EMAS, 1, 2500},
	{ID_BESI, 10, 100},
	{ID_BATU_BATA, 10, 50},
	{ID_BATU_BARA, 10, 50}
};

new const list_barang_tampung_ikan[][INFO_BARANG_DENGAN_JUMLAH] = {
	{ID_IKAN_ARWANA, 1, 500},
	{ID_IKAN_KAKAP, 1, 200},
	{ID_IKAN_MAS, 2, 150},
	{ID_IKAN_MUJAIR, 2, 75},
	{ID_UBUR_UBUR, 4, 75},
	{ID_BINTANG_LAUT, 4, 50}
};

new const list_barang_tampung_buah[][INFO_BARANG_DENGAN_JUMLAH] = {
	{ID_JERUK, 9, 23},
	{ID_JAHE, 9, 15},
	{ID_TEMULAWAK, 9, 15},
	{ID_ALPUKAT, 9, 23},
	{ID_PEPAYA, 9, 23},
	{ID_BELIMBING, 9, 23},
	{ID_SRIKAYA, 9, 15}
	#if HALLOWEEN_EVENT == true
	{ID_LABU, 9, 25}
	#endif
};

new const item_beli_tambang[][INFO_BARANG_MARKET] = {
	{ID_PALU_TAMBANG, 18}
};

new const list_barang_tampung_kayu[][INFO_BARANG_DENGAN_JUMLAH] = {
	{ID_KAYU, 20, 200}
};

new const item_beli_kayu[][INFO_BARANG_MARKET] = {
	{ID_GERGAJI_MESIN, 10}
};

/*
	Bagasi Item
**/
/**
	Index 0 pada ID_ITEM akan dikosongkan sebagai INVALID_ID_ITEM
 */
new VehicleItem[MAX_VEHICLES][MAX_SERVER_ITEM + 1];

enum VEHICLE_LUGGAGE_INFO {
	lvModel,
	lvLimit
};
new const VehicleLuggageLimit[][VEHICLE_LUGGAGE_INFO] = {
	// 2-Door cars
	{602, 50},
	{496, 50},
	{401, 50},
	{518, 50},
	{527, 50},
	{589, 50},
	{419, 50},
	{587, 50},
	{533, 50},
	{474, 50},
	{545, 50},
	{517, 50},
	{410, 50},
	{600, 50},
	{436, 50},
	{439, 50},
	{549, 50},
	{491, 50},

	// 4-Door cars
	{445, 50},
	{604, 50},
	{507, 50},
	{585, 50},
	{466, 50},
	{492, 50},
	{546, 50},
	{551, 50},
	{516, 50},
	{467, 50},
	{426, 50},
	{547, 50},
	{405, 50},
	{580, 50},
	{409, 50},
	{550, 50},
	{566, 50},
	{540, 50},
	{421, 50},
	{529, 50},
	{546, 50},

	// Low riders
	{536, 50},
	{575, 50},
	{534, 50},
	{567, 50},
	{535, 50},
	{576, 50},
	{412, 50},

	// Muscle Cars
	{402, 50},
	{542, 50},
	{603, 50},
	{475, 50},
	
	// Street racers
	{429, 50},
	{541, 50},
	{415, 50},
	{480, 50},
	{562, 50},
	{565, 50},
	{434, 50},
	{494, 50},
	{502, 50},
	{503, 50},
	{411, 50},
	{559, 50},
	{561, 50},
	{560, 50},
	{506, 50},
	{451, 50},
	{558, 50},
	{555, 50},
	{477, 50},

	// SUVs & Wagons
	{579, 50}, // Huntley	
	{400, 50},
	{404, 50},
	{489, 50},
	{505, 50},
	{479, 50},
	{442, 50},
	{458, 50},

	// Light trucks & Vans
	{459, 80},
	{422, 80},
	{482, 80},
	{530, 80},
	{418, 80},
	{582, 80},
	{413, 80},
	{440, 80},
	{543, 80},
	{478, 80},
	{554, 80},

	// Heavy & Utility trucks
	{499, 150},
	{609, 150},
	{498, 150},
	{578, 150},
	{406, 150},
	{573, 150},
	{455, 150},
	{588, 150},
	{403, 150},
	{423, 150},
	{414, 150},
	{443, 150},
	{515, 150},
	{514, 150},
	{456, 150},

	// Recreational
	{568, 50},
	{424, 50},
	{504, 50},
	{483, 50},
	{508, 50},
	{500, 50},
	{444, 100},
	{556, 100},
	{557, 100},
	{495, 50}
};
// Penampung Limit
new VehicleItemLimit[MAX_VEHICLE_MODELS];

enum GPS_INFO_ENUM {
	gpsNama[50],
	Float:gpsPos[3]
};

new GPS_LOCATION[][GPS_INFO_ENUM] = {
	{"Tempat Cetak foto "nama_A, {1111.9841, -1370.0327, 13.9844}},
	{"Tempat Cetak foto "nama_B, {1553.9622, -1450.5079, 13.5469}},
	{"Minimarket "nama_A, {1352.3239, -1759.2528, 13.507}},
	{"Tempat baju "nama_A, {499.5623, -1360.6381, 16.3685}},
	{"Kantor Pemerintah Los Santos", {1479.5580, -1786.4991, 15.4566}},
	{"Bank Los Santos", {1464.5782, -1009.9889, 26.8438}},
	{"Restoran Makanan "nama_A, {928.9155, -1352.9557, 13.3438}},
	{"Polisi Metro Los Santos", {1555.4991, -1675.5791, 16.1953}},
	{"Marketplace", {1477.3682, -1638.5536, 14.1786}},
	{"Rumah Sakit Los Santos", {1172.2648, -1323.4558, 15.4032}},
	{"Toko Gadget "nama_A, {1097.6610, -1370.0361, 13.9844}},
	{"Pusat Tambang", {-685.2260, 2372.3379, 129.8383}},
	{"Pusat Blacksmith", {998.8984, -1251.3457, 19.3988}},
	{"Perkebunan Blueberry", {-72.4007, 105.3258, 3.1172}},
	{"Pusat Mekanik", {1006.1548, -1650.7123, 14.5905}},
	{"Sidejob Trashmaster", {1640.8062, -1550.8942 , 13.5837}},
	{"Sidejob Sweeper", {684.8059, -1189.2422 , 15.7512}},
	{"Sidejob Pizza Delivery", {2106.6531, -1822.8940 , 13.6000}},
	{"Sidejob Electrician", {2396.3955, -2077.6990 , 13.5241}}
};
// Panduan Bermain
new aktifPanduanStream[MAX_PLAYERS],
	timerPanduanStream[MAX_PLAYERS] = {-1, ...};

/**
	Weather
 */
new const fine_weather_ids[] = {1,2,3,4,5,6,7,12,13,14,15,17,18};
new const foggy_weather_ids[] = {9,19,20};

// Cuaca kedepannya
new curr_weather_seq = 0, weather_time = 0,
	curr_weather_id;
new seq_weather[5],
	weather_string[1000];

new Float:LastVehiclePos[MAX_VEHICLES][4];

// Check Android
new Android_Check[MAX_PLAYERS],
	Android_Official[MAX_PLAYERS],
	Android_Timer[MAX_PLAYERS] = {-1, ...};

// Unused Part
new Float:_unusedDepth[2];

/**
	Setup Variable
 */
new 
	GAJI_SWEEPER,
	GAJI_PIZZABOY,
	GAJI_TRASHMASTER,
	GAJI_MONTIR_LISTRIK,
	TAGIHAN_MATI_RS,
	TAGIHAN_DENDA_SEWA_KENDARAAN,
	TAGIHAN_REVIVE;