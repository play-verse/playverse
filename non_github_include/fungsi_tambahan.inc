/**
    Macro Function 
 */
#define PlayerTalking(%0)               ApplyAnimation(%0, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 0, 2000, 1)
#define ActorTalking(%0)                ApplyDynamicActorAnimation(%0, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 0, 0)
#define PlayerGivesAnimation(%0)        ApplyAnimation(%0, "DEALER", "SHOP_PAY", 4.1, 0, 1, 1, 0, 2000, 1)
#define PlayerTakesAnimation(%0)        ApplyAnimation(%0, "CASINO", "SLOT_PLYR", 4.1, 0, 1, 1, 0, 2000, 1)
#define PlayerFillingFuelOnLoop(%0)     ApplyAnimation(%0, "CASINO", "SLOT_WAIT", 4.1, 1, 1, 1, 0, 0, 1)
#define PlayerAtmAnimation(%0)          ApplyAnimation(%0, "SHOP", "SHP_SERVE_LOOP", 4.1, 0, 1, 1, 0, 2000, 1)
#define PlayerReviving(%0)              ApplyAnimation(%0, "MEDIC", "CPR", 4.1, 1, 1, 1, 1, 0, 1)
#define PlayerDied(%0)                  ApplyAnimation(%0, "PED", "KO_SHOT_STOM", 4.1, 0, 1, 1, 1, 0, 1)
#define PlayerCraftingMedicine(%0)      ApplyAnimation(%0, "CAR_CHAT", "CAR_SC4_FR", 4.1, 1, 1, 1, 1, 0, 1)

#define IsPlayerOnTrade(%0)         (PlayerInfo[%0][onTradeWith] != INVALID_PLAYER_ID)

#define ClearChatEx(%0)               for(new _i=0;_i!=10;++_i) SendClientMessage(%0, -1, "")

#define GetNamaRarity(%0)           ITEM_RARITY[%0 - 1][namaRarity]
#define GetColorRarity(%0)          ITEM_RARITY[%0 - 1][colorRarity]

#define IsPlayerPria(%0)         (PlayerInfo[%0][jenisKelamin] == 0)
#define IsPlayerWanita(%0)         (PlayerInfo[%0][jenisKelamin] == 1)

/**
    Bantuan Item
 */

/**
    Get slot yang terpakai oleh item dengan jumlah tertentu

    %0 - itemid
    %1 - jumlah
 */
#define GetSlotItemTerpakai(%0,%1) (getKapasitasByIdItem(%0) * %1)

// IMPORTANT: Gunakan fungsi "sama" dari pada menggunakan "strcmp" langsung
// strcmp jika membandingkan dengan string kosong maka dianggap tidak ada perbedaan
sama(const kata1[], const kata2[], bool:ignorecase=false)
    return (!strcmp(kata1, kata2, ignorecase) && !isnull(kata1) && !isnull(kata2));

// Hanya untuk tampilan saja
SetPlayerMoney(playerid, jumlah){
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, jumlah);
}

// Link YSI Secret - https://forum.sa-mp.com/showthread.php?t=570949
sendPesan(playerid, warna, const pesan[], {Float,_}:...){ // Bisa juga menggunakan GLOBAL_TAG_TYPES:... dari YSI
    new temp_string[128];
    format(temp_string, 128, pesan, ___(3));
    return SendClientMessage(playerid, warna, temp_string);
}

strcatEx(dest[], len_dest, const source[], {Float,_}:...){
    new temp_string[1000];
    format(temp_string, sizeof(temp_string), source, ___(3));
    strcat(dest, temp_string, len_dest);
}

isPlayerInOwnedHouse(playerid){
    if(GetPlayerInterior(playerid) > 0 && GetPlayerVirtualWorld(playerid) <= MAX_HOUSES){
        if(houseInfo[PlayerInfo[playerid][inHouse]][hOwner] == PlayerInfo[playerid][pID]) return 1;
    }
    return 0;
}

stock strreplace(sstring[], const search[], const replacement[], bool:ignorecase = false, pos = 0, limit = -1, maxlength = sizeof(sstring)) 
{
    if (limit == 0)
        return 0;
    new sublen = strlen(search), replen = strlen(replacement), bool:packed = ispacked(sstring), maxlen = maxlength, len = strlen(sstring), count = 0;
    if (packed)
        maxlen *= 4;
    if (!sublen)
        return 0;
    while (-1 != (pos = strfind(sstring, search, ignorecase, pos))) 
	{
        strdel(sstring, pos, pos + sublen);
        len -= sublen;
        if (replen && len + replen < maxlen) {
            strins(sstring, replacement, pos, maxlength);
            
            pos += replen;
            len += replen;
        }
        if (limit != -1 && ++count >= limit)
            break;
    }
    return count;
}


error_syntax(playerid, const syntax[]){
    new pesan[256] = "Invalid: "GREY"Gunakan "WHITE"";
    strcat(pesan, syntax);
    return SendClientMessage(playerid, COLOR_RED, pesan);
}

error_command(playerid, const message[]){
    new pesan[256] = "Error: "GREY;
    strcat(pesan, message);
    return SendClientMessage(playerid, COLOR_RED, pesan);
}

note_message(playerid, const message[]){
    new pesan[256] = "Note: "WHITE;
    strcat(pesan, message);
    return SendClientMessage(playerid, COLOR_YELLOW, pesan);
}

server_message(playerid, const message[]){
    new pesan[200];
    format(pesan, 200, TAG_SERVER" "GREY"%s", message);
    return SendClientMessage(playerid, COLOR_ORANGE, pesan);
}

getTotalLamaBermain(playerid){
    return gettime() - PlayerInfo[playerid][waktuSaatLogin] + PlayerInfo[playerid][lamaBermain]; 
}

addGajiPemain(playerid, nominal, const keterangan[]){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO `gaji`(id_user, nominal, tanggal, status, keterangan) VALUES('%d', '%d', NOW(), '0', '%e')", PlayerInfo[playerid][pID], nominal, keterangan);
    return mysql_tquery(koneksi, pQuery[playerid]);
}

addTagihanPemain(playerid, nominal, const keterangan[], jenis = JENIS_TAGIHAN_UNIVERSAL){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO `tagihan`(id_user, nominal, tanggal, keterangan, jenis) VALUES('%d', '%d', NOW(), '%e', %d)", PlayerInfo[playerid][pID], nominal, keterangan, jenis);
    return mysql_tquery(koneksi, pQuery[playerid]);
}

buatPickupDanLabel(modelid, Float:x, Float:y, Float:z, const text[]){
    CreateDynamic3DTextLabel(text, COLOR_WHITE, x, y, z, 20);
    return CreateDynamicPickup(modelid, 1, x, y, z);
}

// buatCPDanLabel(Float:x, Float:y, Float:z, const text[], Float:ukuran, vw = -1, interiorid = -1){
//     CreateDynamic3DTextLabel(text, COLOR_WHITE, x, y, z, 20);
//     return CreateDynamicCP(x, y, z, ukuran, vw, interiorid, -1, 5.0);
// }

buatSPDanLabel(Float:x, Float:y, Float:z, const text[], Float:ukuran, vw = -1, interiorid = -1, testlos = 1){
    CreateDynamic3DTextLabel(text, COLOR_WHITE, x, y, z, 20, .testlos = testlos);
    return CreateDynamicSphere(x, y, z, ukuran, vw, interiorid);
}

pindahkanPemain(playerid, Float:x, Float:y, Float:z, Float:a, int, vw, bool:preload_dynamic_map = false){
    SetPlayerFacingAngle(playerid, a);
    if(preload_dynamic_map){
        Streamer_UpdateEx(playerid, x, y, z, vw, int, -1, 2000, 1);
        GameTextForPlayer(playerid, "~w~Sedang ~y~loading..", 1500, 3);
    }
    if(preload_dynamic_map){
        SetPlayerPos(playerid, x, y, z + 0.5);
    }else{
        SetPlayerPos(playerid, x, y, z);
    }
    SetPlayerInterior(playerid, int);
    SetPlayerVirtualWorld(playerid, vw);
}


dialogMsgUangTdkCukup(playerid){
    return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Uang anda tidak mencukupi", WHITE"Maaf saat ini uang yang anda miliki tidak mencukupi untuk melakukan transaksi!", "Ok", "Batal");
}

/**
    Function manipulasi item menggunakan SVar
 */


getModelByIdItem(id_item){
    new nama_variabel[50];
    format(nama_variabel, sizeof(nama_variabel), "iIt_%d", id_item);
    return GetSVarInt(nama_variabel);
}

getKapasitasByIdItem(id_item){
    new nama_variabel[50];
    format(nama_variabel, sizeof(nama_variabel), "cIt_%d", id_item);
    return GetSVarInt(nama_variabel);
}

getRarityByIdItem(id_item){
    new nama_variabel[50];
    format(nama_variabel, sizeof(nama_variabel), "rIt_%d", id_item);
    return GetSVarInt(nama_variabel);
}

getKeteranganByIdItem(id_item, destinasi[], len = sizeof(destinasi)){
    new nama_variabel[50];
    format(nama_variabel, sizeof(nama_variabel), "kIt_%d", id_item);
    GetSVarString(nama_variabel, destinasi, len);
}

getNamaByIdItem(id_item, destinasi[], len = sizeof(destinasi)){
    new nama_variabel[50];
    format(nama_variabel, sizeof(nama_variabel), "nIt_%d", id_item);
    GetSVarString(nama_variabel, destinasi, len);
}

getFungsiByIdItem(id_item, destinasi[], len = sizeof(destinasi)){
    new nama_variabel[50];
    format(nama_variabel, sizeof(nama_variabel), "fIt_%d", id_item);
    GetSVarString(nama_variabel, destinasi, len);
}

/**
    End function manipulasi item menggunakan SVar
 */

getSaldoPlayer(playerid, const fungsi_callback[]){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(SUM(nominal), 0) as saldo FROM `trans_atm` WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
    mysql_tquery(koneksi, pQuery[playerid], fungsi_callback, "i", playerid);
}

getUangPlayer(playerid)
{
    // Set Tampilan uang player jika tidak sync dengan variabel 
    if(GetPlayerMoney(playerid) != PlayerInfo[playerid][uang])
        SetPlayerMoney(playerid, PlayerInfo[playerid][uang]);

    return PlayerInfo[playerid][uang];
}

givePlayerUang(playerid, jumlah, bool:simpanDb = true){
    PlayerInfo[playerid][uang] += jumlah;

    if(simpanDb){
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", jumlah, PlayerInfo[playerid][pID]);
        mysql_tquery(koneksi, pQuery[playerid]);
    }

    // Hanya tampilan untuk default
    // Money bawaan tidak ada efek sama sekali karena tidak akan menjadi acuan
    // Melainkan menggunakan variabel untuk pengecekan
    SetPlayerMoney(playerid, PlayerInfo[playerid][uang]);

    // new stringUang[50];
    // valstr(stringUang, PlayerInfo[playerid][uang]);
    // PlayerTextDrawSetString(playerid, RadarUang[playerid][1], stringUang);
}

#define getStatusMakanPemain(%0)        PlayerInfo[%0][statusMakan]

setStatusMakanPemain(playerid, Float:jumlah){
    if(jumlah < 0.0) 
        PlayerInfo[playerid][statusMakan] = 0.0;
    else
        PlayerInfo[playerid][statusMakan] = jumlah;

    if(PlayerInfo[playerid][statusMakan] <= 15.0)
        SetPlayerProgressBarColour(playerid, HUD_Stats_Bar[playerid][0], COLOR_RED);
    else if(PlayerInfo[playerid][statusMakan] <= 30.0)
        SetPlayerProgressBarColour(playerid, HUD_Stats_Bar[playerid][0], COLOR_ORANGE);
    else
        SetPlayerProgressBarColour(playerid, HUD_Stats_Bar[playerid][0], COLOR_YELLOW);
    
    SetPlayerProgressBarValue(playerid, HUD_Stats_Bar[playerid][0], PlayerInfo[playerid][statusMakan]);
    if(PlayerInfo[playerid][statusMakan] <= 0.0 && !PlayerInfo[playerid][inDie]) {
        // Buat player sekarat
        DamagePlayer(playerid, GetPlayerHealth(playerid));
    }
    else if(PlayerInfo[playerid][statusMakan] <= 10.0){
        SetPlayerDrunkLevel(playerid, 3500);
    }
    else{
        SetPlayerDrunkLevel(playerid, 0);
    }
}

#define getStatusMinumPemain(%0)        PlayerInfo[%0][statusMinum]

setStatusMinumPemain(playerid, Float:jumlah){
    if(jumlah < 0.0) 
        PlayerInfo[playerid][statusMinum] = 0.0;
    else
        PlayerInfo[playerid][statusMinum] = jumlah;

    if(PlayerInfo[playerid][statusMinum] <= 15.0)
        SetPlayerProgressBarColour(playerid, HUD_Stats_Bar[playerid][1], COLOR_DARK_BLUE);
    else if(PlayerInfo[playerid][statusMinum] <= 30.0)
        SetPlayerProgressBarColour(playerid, HUD_Stats_Bar[playerid][1], COLOR_BLUE);
    else
        SetPlayerProgressBarColour(playerid, HUD_Stats_Bar[playerid][1], COLOR_LIGHT_BLUE);

    SetPlayerProgressBarValue(playerid, HUD_Stats_Bar[playerid][1], PlayerInfo[playerid][statusMinum]);
}

// -- Uncomment fungsi jika ingin menggunakan
// resetUangPlayer(playerid, bool:simpanDb = true){
//     PlayerInfo[playerid][uang] = 0;

//     if(simpanDb){
//         mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET `uang` = '0' WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
//         mysql_tquery(koneksi, query);
//     }

//    ResetPlayerMoney(playerid);
//     // PlayerTextDrawSetString(playerid, RadarUang[playerid][1], "0");
// }
ubahSkinPemain(playerid, skinid){
    // Attach ulang mask/helm
    // Didalam fungsi ini telah terdapat pengecekan jika attachedobject telah terpakai maka remove
    AttachHelmetOrMask(playerid, PlayerInfo[playerid][isOnMask]);
    
    // Hide dlu untuk dapat efeknya
    PlayerTextDrawHide(playerid, HUD_Stats[playerid][0]);
    PlayerTextDrawSetPreviewModel(playerid, HUD_Stats[playerid][0], skinid);
    if(PlayerInfo[playerid][tampilHUDStats]) PlayerTextDrawShow(playerid, HUD_Stats[playerid][0]);
	SetPlayerSkin(playerid, skinid);
}

setUangPlayer(playerid, jumlah, bool:simpanDb = true){
    PlayerInfo[playerid][uang] = jumlah;

    if(simpanDb){
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = '%d' WHERE `id` = '%d'", jumlah, PlayerInfo[playerid][pID]);
        mysql_tquery(koneksi, pQuery[playerid]);
    }

    // Hanya tampilan untuk default
    // Money bawaan tidak ada efek sama sekali karena tidak akan menjadi acuan
    // Melainkan menggunakan variabel untuk pengecekan
    SetPlayerMoney(playerid, PlayerInfo[playerid][uang]);
    
    // new stringUang[50];
    // valstr(stringUang, PlayerInfo[playerid][uang]);
    // PlayerTextDrawSetString(playerid, RadarUang[playerid][1], stringUang);
}


cekAllowNama(const nama[]){
    new count_underscore = 0;
    if(nama[0] == '_' || nama[strlen(nama) - 1] == '_') return 0;
    for (new i, j = strlen(nama); i != j; i++)
    {
        switch (nama[i])
        {
            case 'A' .. 'Z', 'a' .. 'z': continue;
            case '_': count_underscore++;
            default: return 0;
        }
    }
    return count_underscore <= 1;
}

// Dimana array terdiri dari 2 dimensi
// 0 - ID Barang
// 1 - Jumlah dibutuhkan
cekKetersediaanMassiveItem(playerid, const barang_barang[][], const fungsi_callback[], banyak_barang = sizeof(barang_barang)){
    new kondisi[256] = "", sub_kondisi[50];
    new i = banyak_barang;
    while(i--){
        format(sub_kondisi, sizeof(kondisi), "(id_item='%d'AND jumlah>='%d')", barang_barang[i][0], barang_barang[i][1]);
        if(!isnull(kondisi)) {
            strcat(kondisi, "OR");
        }
        strcat(kondisi, sub_kondisi);
    }
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT COUNT(*) AS hasil FROM `user_item` WHERE id_user = '%d' AND (%s)", PlayerInfo[playerid][pID], kondisi);
    // Pada fungsi harus ada parameter untuk menampung banyak item
    if(!isnull(fungsi_callback)) mysql_tquery(koneksi, pQuery[playerid], "isItemCukup", "iis", playerid, banyak_barang, fungsi_callback);
}

cekKetersediaanItem(playerid, id_item, jumlah, const fungsi_callback[]){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT COUNT(*) AS hasil FROM user_item WHERE id_user = '%d' AND id_item = '%d' AND jumlah >= '%d'", PlayerInfo[playerid][pID], id_item, jumlah);
    mysql_tquery(koneksi, pQuery[playerid], "isItemCukup", "iis", playerid, 1, fungsi_callback);
}

publicFor: isItemCukup(playerid, syarat, const fungsi_callback[]){
    new hasil;
    cache_get_value_name_int(0, "hasil", hasil);
    if(hasil == syarat)
        CallRemoteFunction(fungsi_callback, "ii", playerid, 1);
    else
        CallRemoteFunction(fungsi_callback, "ii", playerid, 0);
    return 1;
}

publicFor: keluarkanPlayer(playerid){
    Kick(playerid);
    return 1;
}

/**
    ProxDetector
    ```
        Mengirim message kepada orang terdekat
    ```
 */
ProxDetector(Float:radi, playerid, const string[], color)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, radi, x, y, z))
        {
            SendClientMessage(i, color, string);
        }
    }
}

// Ganti menggunakan foreach untuk menghindari overlooping
// foreach Player == hanya looping pada player yang sedang online saja
stock GetPlayerIdFromName(const playername[])
{
    foreach(new i : Player){
        if(strcmp(PlayerInfo[i][pPlayerName], playername) == 0)
            return i;
    }
    return INVALID_PLAYER_ID;
}

stock GetVehicleSpeed(vehicleid) // Credits someone on SAMP Forums forgot the name
{
    new Float:x, Float:y, Float:z, vel;
    GetVehicleVelocity(vehicleid, x, y, z);
    vel = floatround(floatsqroot(x*x+y*y+z*z)*180); // KM/H
    //vel = floatround(floatsqroot(x*x+y*y+z*z)*180/1.60934); // M/H
    return vel;
}

/*stock IsVehicleOccupied(vehicleid){
    foreach(new i : Player){
        if(IsPlayerInVehicle(i, vehicleid)) return 1;
    }
    return 0;
}*/

stock IsVehicleFlipped(vehicleid)
{
    new Float:Quat[2];
    GetVehicleRotationQuat(vehicleid, Quat[0], Quat[1], Quat[0], Quat[0]);
    return (Quat[1] >= 0.60 || Quat[1] <= -0.60);
}

PreloadAnimLib(playerid, const animlib[])
{
	ApplyAnimation(playerid, animlib, "null", 0.0, 0, 0, 0, 0, 0);
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float: a;
	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);
	if (GetPlayerVehicleID(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

stock GetZoneName(Float: x, Float: y, Float: z)
{
	new zone[28];
    for(new i = 0; i < sizeof(SAZones); i++)
    {
		if(x >= SAZones[i][SAZONE_AREA][0] && x <= SAZones[i][SAZONE_AREA][3] && y >= SAZones[i][SAZONE_AREA][1] && y <= SAZones[i][SAZONE_AREA][4] && z >= SAZones[i][SAZONE_AREA][2] && z <= SAZones[i][SAZONE_AREA][5])
		{
            strcat(zone, SAZones[i][SAZONE_NAME]);
            return zone;
		}
	}

	strcat(zone, "Tidak diketahui");
	return zone;
}

stock GetCityName(Float: x, Float: y, Float: z)
{
	new city[28];
	for(new i = 356; i < sizeof(SAZones); i++)
	{
		if(x >= SAZones[i][SAZONE_AREA][0] && x <= SAZones[i][SAZONE_AREA][3] && y >= SAZones[i][SAZONE_AREA][1] && y <= SAZones[i][SAZONE_AREA][4] && z >= SAZones[i][SAZONE_AREA][2] && z <= SAZones[i][SAZONE_AREA][5])
		{
            strcat(city, SAZones[i][SAZONE_NAME]);
            return city;
		}
	}

	strcat(city, "San Andreas");
	return city;
}

stock formatHarga(nominal_uang, const pemisah[] = "."){
    new stringTemp[16];
    format(stringTemp, 16, "%d", nominal_uang);
    for(new i = strlen(stringTemp) - 3; i > 0; i -= 3){
        strins(stringTemp, pemisah, i);
    }
    return stringTemp;
}

ConvertToMinutes(time) // http://forum.sa-mp.com/showpost.php?p=3223897&postcount=11
{
    new string[15]; //-2000000000:00 could happen, so make the string 15 chars to avoid any errors
    format(string, sizeof(string), "%02d:%02d", time / 60, time % 60);
    return string;
}

SetPlayerLookAt(playerid, Float:x, Float:y){
    // somewhere on samp forums, couldn't find the source
    new Float:Px, Float:Py, Float: Pa;
    GetPlayerPos(playerid, Px, Py, Pa);
    Pa = floatabs(atan((y-Py)/(x-Px)));
    if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
    else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
    else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
    Pa = floatsub(Pa, 90.0);
    if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
    SetPlayerFacingAngle(playerid, Pa);
}

IsSurfacePlant(Obj){
	switch(Obj){
		case 4315, 4262, 4265, 4264, 4322, 4261, 4535, 4347, 4259, 4338, 4336, 4321, 4348, 4540, 4340, 4288, 4258, 4349,
		12864, 4350, 4263, 4326, 4358, 4257, 4341, 4314, 4252, 4286, 17096, 4351, 4344, 4345, 4335, 4250, 4316, 4251,
		4330, 4346, 13723, 13019, 4354, 13036, 4320, 17083, 4359, 17084, 4331, 4352, 17088, 4260, 4271, 4268, 4323,
		17138, 4334, 4287, 4317, 13821, 12825, 4274, 17130, 17471, 17091, 17132, 17102, 17095, 4337, 4275, 4270, 17129,
		17090, 4283, 4289, 17115, 4844, 17099, 4373, 4319, 17081, 17100, 4361, 4362, 17097, 17098, 4324, 4845, 17139,
		4875, 13121, 7475, 12989, 17093, 13049, 4318, 13082, 13692, 4285, 17103, 7459, 17114, 8470, 8462, 12868, 10418,
		13490, 13211, 4249, 11628, 4353, 17145, 17108, 17137, 13157, 13120, 4328, 17136, 4360, 17140, 17106, 13123,
		13149, 8002, 13122, 4533, 13823, 10492, 13147, 13148, 17131, 13040, 13156, 4847, 13041, 4329, 8007, 4342, 13101,
		13150, 17107, 4254, 13297, 4267, 12866, 4269, 17142, 4852, 11514, 13710, 10453, 17122, 13700, 4308, 18332, 13070,
		18340, 11106, 13050, 11107, 4842, 11509, 11524, 18333, 13124, 13042, 11510, 12804, 13824, 11521, 18350, 10864,
		4306, 17301, 13100, 18331, 18352, 9212, 13102, 13698, 13107, 7359, 12865, 13212, 13715, 11557, 8091, 4339, 11520,
		4355, 4368, 12871, 11516, 13208, 17118, 11692, 18339, 13711, 13044, 11538, 17116, 13081, 13017, 8072, 4277, 4281,
		4273, 4276, 4278, 4280, 4282, 4284, 4538, 18322, 9218, 13756, 6065, 4356, 12916, 4313, 4291, 18351, 13818, 17144,
		13825, 4302, 4293, 4253, 4290, 4292, 4298, 4851, 4295, 18341, 9213, 11537, 18338, 10601, 9207, 10961, 13235,
		17109, 9206, 13125, 4255, 13043, 4357, 4242, 4248, 13030, 11335, 13871, 11515, 4245, 13809, 8460, 4312, 10861,
		4246, 4247, 4279, 11303, 13039, 17133, 13105, 13158, 10960, 4299, 4369, 18343, 4244, 12824, 13071, 10491, 13702,
		12872, 13237, 4327, 7458, 11552, 9214, 11530, 11539, 13084, 4307, 18473, 13716, 13072, 10454, 13810, 4364, 18354,
		17113, 17119, 18356, 13051, 11540, 4810, 4310, 7457, 16183, 13099, 4256, 17094, 5114, 4325, 17101, 13167, 13236,
		18345, 10451, 10962, 4366, 13021, 18344, 17141, 9235, 18357, 4240, 16198, 4243, 4241, 9219, 4333, 11554, 13795,
		4363, 13370, 4297, 4367, 4309, 4815, 17075, 16685, 4296, 13181, 4332, 4294, 16202, 13719, 11555, 10959, 4371,
		9211, 17126, 12869, 13126, 8008, 11560, 13207, 13826, 4372, 10694, 8461, 4266, 18359, 4311, 10926, 17302, 9217,
		13371, 4897, 9208, 17678, 7998, 18485, 16684, 4304, 9210, 9609, 4305, 8983, 4365, 7536, 16210, 9610, 4374,
		8459, 4303, 5036, 8200, 13165, 4272, 4896, 18323, 11541, 13741, 13035, 9617, 10386, 9614, 10903, 10904, 9555,
		10905, 8547, 16233, 6315, 10851, 10151, 13757, 10560, 13740, 17143, 9616, 17594, 11364, 13177, 13172, 7537,
		11097, 10638, 10939, 5172, 6487, 4300, 13209, 13163, 8468, 17117, 8655, 13742, 18358, 4343, 11332, 9863, 13210,
		4876, 9225, 16238, 8532, 6203, 6229, 9605, 9276, 18334, 7616, 13872, 13180, 7461, 8577, 11297, 8845, 10384,
		10290, 13104, 4301, 9611, 4843, 6094, 5871, 16194, 18231, 18475, 4898, 5424, 13734, 7353, 17509, 5427, 7032,
		17865, 9596, 11408, 10983, 9554, 7579, 10034, 5458, 13691, 9519, 9226, 10403, 17601, 9556, 9889, 4849, 4370,
		8654, 9082, 11340, 10612, 5640, 9891, 11363, 10562, 11362, 10972, 17696, 7582, 17548, 10411, 5987, 10863, 4859,
		5743, 4701, 4591, 10613, 17691, 10400, 17694, 10616, 4702, 10615, 9242, 10087, 8678, 5457, 17505, 5875, 10862,
		17866, 13686, 17620, 5471, 5887, 17953, 9905, 10356, 9607, 6007, 13737, 9606, 8560, 4592, 5428, 5812, 10273,
		5443, 9930, 6233, 9086, 4685, 17617, 9046, 17614, 17618, 5878, 4684, 6234, 6236, 9248, 8868, 10618, 17615,
		17664, 10416, 10415, 6006, 10414, 17665, 10419, 10422, 17616, 10917, 10420, 5429, 10358, 13679, 10417, 6356,
		17589, 10421, 5624, 10637, 12814, 6959, 17864, 17878, 9353, 17877, 9087, 17574, 17881, 17880, 9307, 11224,
		11226, 11223, 3694, 9345, 11225, 7955, 3048, 9305, 3522:
		{
			return 1;
		}
	}
    return 0;
}

getRateBerhasilSkill(current_exp, needed_level){
    new current_level = 1;
    if(current_exp >= LEVEL_SKILL_DUA) ++current_level;
    if(current_exp >= LEVEL_SKILL_TIGA) ++current_level;
    if(current_exp >= LEVEL_SKILL_EMPAT) ++current_level;
    if(current_exp >= LEVEL_SKILL_LIMA) ++current_level;

    if(current_level < needed_level) {
        printf("#ERROR 013 - Rate skill invalid.");
        return 0;
    }
    // Base rate - 80%
    // Setiap level menaikan 5% rate skill sebelumnya
    return ((current_level - needed_level) * 5 >= 20) ? 100 : (current_level - needed_level) * 5 + 80;
}

getLevelBlacksmithPlayer(playerid){
    if(PlayerInfo[playerid][expBlacksmith] < BLACKSMITH_LEVEL_SKILL_DUA)
        return 1;
    else if(PlayerInfo[playerid][expBlacksmith] < BLACKSMITH_LEVEL_SKILL_TIGA)
        return 2;
    else if(PlayerInfo[playerid][expBlacksmith] < BLACKSMITH_LEVEL_SKILL_EMPAT)
        return 3;
    else if(PlayerInfo[playerid][expBlacksmith] < BLACKSMITH_LEVEL_SKILL_LIMA)
        return 4;
    else if(PlayerInfo[playerid][expBlacksmith] < BLACKSMITH_LEVEL_SKILL_ENAM)
        return 5;
    else if(PlayerInfo[playerid][expBlacksmith] >= BLACKSMITH_LEVEL_SKILL_ENAM)
        return 6;
    else
        return 0;
}

stock IsPointInRangeOfPoint(Float:x, Float:y, Float:z, Float:x2, Float:y2, Float:z2, Float:range){
    x2 -= x;
    y2 -= y;
    z2 -= z;
    return ((x2 * x2) + (y2 * y2) + (z2 * z2)) < (range * range);
}

IsValidPaintjobForVehicle(vehicleid, paintjobid){
    switch (GetVehicleModel(vehicleid))
    {
        case 483: return (paintjobid == 0);
        case 575: return (paintjobid == 0 && paintjobid == 1);
        case 534 .. 536, 558 .. 562, 565, 567, 576: return (paintjobid >= 0 && paintjobid <= 2);
        default: return false;
    }
    return false;
}

IsMobilPickup(vehicleid) {
    if(!IsValidVehicle(vehicleid)) return 0;
    switch(GetVehicleModel(vehicleid)){
        // 422 - Bobcat
        // 455 - Flatbed (ada barang dibelakangnya, tapi bolehkan aja)
        // 478 - Walton
        // 543 - Sadler
        // 552 - Utility Van (punya wadah dibelakang, tapi tidak cocok)
        // 554 - Yosemite
        // 578 - DFT-30 (truck, bolehkan saja)
        case 422, 455, 478, 543, 554, 578:
            return 1;
    }
    return 0;
}

/**
    >> Query untuk cek kapasitas item
    ```
        Field yang menyimpan nilai total 
        slot item pada player adalah 'total_item'
    ```
 */
stock QueryCekSlotItem(playerid){
    new queryFormated[500];
    format(queryFormated, 500, "SELECT IFNULL(SUM(a.jumlah * b.kapasitas), 0) as total_item FROM user_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_user = '%d'", PlayerInfo[playerid][pID]);
    return queryFormated;
}

IsPemainPunyaNomorAktif(playerid){
    return !isnull(PlayerInfo[playerid][nomorHP]) && PlayerInfo[playerid][masaAktifNomor] >= gettime();
}

// jday = julian day
datetime_to_unix(year, month, day, hour, minute, second)
{
	new jday = 367 * year - 7 * (year + (month + 9) / 12) / 4 - 3 * ((year + (month - 9) / 7) / 100 + 1) / 4 + 275 * month / 9 + day + 1721029 - 2440588;
    // Kita mengurangan dengan konstanta tertentu untuk menyamakan convert dengan gettime (unixtimestamp server)
	return (jday * 86400 + hour * 3600 + minute * 60 + second) - PENGURANGAN_UNTUK_MENYAMAKAN_DENGAN_GETTIME;
}

/**
    Convert SQL String ke Unixtimestamp satuan detik
    ```
        format string harus dalam bentuk
        year-month-day hours:minutes:seconds
    ```
 */
convStrSqlDateIntoUnix(const date_string[]){
    new year = 0, 
        month = 0, 
        day = 0, 
        hour = 0, 
        minute = 0, 
        second = 0;
    /**
        P = Delimeter
        <ele> = element yang ingin di pecah
     */
    if(!sscanf(date_string, "P<-:>iiiiii", year, month, day, hour, minute, second))
        return datetime_to_unix(year, month, day, hour, minute, second);
    return 0;
}


/**
    Penandaan trade
 */
tandaiSedangTrade(playerid, withplayerid){
    PlayerInfo[playerid][onTradeWith] = withplayerid;
    PlayerInfo[withplayerid][onTradeWith] = playerid;
    return 1;
}

/**
    Pelepasan Trade Sepihak
 */
lepasTandaTrade(playerid){
    if(playerid == INVALID_PLAYER_ID || PlayerInfo[playerid][onTradeWith] == INVALID_PLAYER_ID) return 0;

    PlayerInfo[PlayerInfo[playerid][onTradeWith]][onTradeWith] = INVALID_PLAYER_ID;
    PlayerInfo[playerid][onTradeWith] = INVALID_PLAYER_ID;
    return 1;
}

stock bool:IsValidDate(dStr[]) {

    new
        monthDays[12] = {
            31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
        },
        temp_YMD[3],
        temp_Pos    = 0,
        temp_ePos   = 0,
        temp_Index  = 0
    ;
        //Thought about implementing SSCANF_QUIET, but it requires spaces to work "currently".
    for(temp_Index = strlen(dStr) - 1; temp_Index != 0; temp_Index--) {

        if(!(dStr[temp_Index] >= 48 && dStr[temp_Index] <= 57))
            dStr[temp_Index] = ' ';
    }
    if(sscanf(dStr, "iii", temp_YMD[0], temp_YMD[1], temp_YMD[2]))
        return false;

    temp_ePos = temp_Pos = -1;
    for(temp_Index = 0; temp_Index < 3; temp_Index++) {

        if(temp_YMD[temp_Index] > 1750) {

            if((temp_YMD[temp_Index] % 400) == 0 || ((temp_YMD[temp_Index] % 100) != 0 && (temp_YMD[temp_Index] % 4) == 0))
                monthDays[1] = 29;

        }
        else if(temp_YMD[temp_Index] > 12)
            temp_Pos = temp_Index;
        else
            if(temp_ePos == -1)
                temp_ePos = temp_Index;
            else
                temp_Pos = temp_Index;
    }
    if(temp_ePos == -1 || temp_Pos == -1)
        return false;

    if(temp_YMD[temp_ePos] < 1 || temp_YMD[temp_ePos] > 12)
        return false;

    if(temp_YMD[temp_Pos] < 1 || temp_YMD[temp_Pos] > monthDays[temp_YMD[temp_ePos] - 1])
        return false;

    return true;
}

stock IsABike(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
    switch(model)
    {
        case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: 
            return true;
        default:
            return false;
    }
}

IsMaskOrHelmet(itemid){
    return (itemid == ID_ITEM_HELM || itemid == ID_ITEM_MASK);
}

#define AttachHelmetFixed(%0,%1,%2,%3,%4,%5,%6) \
    SetPlayerAttachedObject(%0, MASK_ATTACH_INDEX, 18645, 2, (%1), (%2), (%3), (%4), (%5), (%6))

#define AttachMaskFixed(%0,%1,%2,%3,%4,%5,%6) \
    SetPlayerAttachedObject(%0, MASK_ATTACH_INDEX, 19037, 2, (%1), (%2), (%3), (%4), (%5), (%6))

// %0, MASK_ATTACH_INDEX, 19037, 2, 0.107999, 0.019999, -0.004000, -16.100000, 90.100051, 102.900100
// %0, MASK_ATTACH_INDEX, 19163, 2, 0.082000, 0.02499, 0.001000, 0.00000, 84.599906, 178.200057

AttachMaskToPlayer(playerid){
    if(IsPlayerAttachedObjectSlotUsed(playerid, MASK_ATTACH_INDEX))
        RemovePlayerAttachedObject(playerid, MASK_ATTACH_INDEX);

    switch(GetPlayerSkin(playerid)){
        case 0:
            AttachMaskFixed(playerid, 0.107999, 0.019999, -0.004000, -16.100000, 90.100051, 102.900100);
        case 28:
            AttachMaskFixed(playerid, 0.107998, 0.042998, -0.007000, -16.10000, 90.100051, 103.400070);
        default:
            AttachMaskFixed(playerid, 0.107998, 0.042998, -0.007000, -16.10000, 90.100051, 103.400070);
    }
    return 1;
}

#define AttachHelmetToPlayer(%0)     \
    SetPlayerAttachedObject(%0, MASK_ATTACH_INDEX, 18645, 2, 0.101, -0.0, 0.0, 5.50, 84.60, 83.7)

AttachHelmetOrMask(playerid, itemid){
    if(IsPlayerAttachedObjectSlotUsed(playerid, MASK_ATTACH_INDEX))
        RemovePlayerAttachedObject(playerid, MASK_ATTACH_INDEX);

    if(!IsMaskOrHelmet(itemid)) return 1;

    switch(itemid){
        case ID_ITEM_HELM:
            AttachHelmetToPlayerFixed(playerid);
        case ID_ITEM_MASK:{
            AttachMaskToPlayer(playerid);
        }
        default:
            return 1;
    }
    return 1;
}

AttachHelmetToPlayerFixed(playerid)
{
    if(IsPlayerAttachedObjectSlotUsed(playerid, MASK_ATTACH_INDEX))
        RemovePlayerAttachedObject(playerid, MASK_ATTACH_INDEX);

    switch(GetPlayerSkin(playerid))
    {
        case 0, 65, 74, 149, 208, 273:  
            AttachHelmetFixed(playerid, 0.070000, 0.000000, 0.000000, 88.000000, 75.000000, 0.000000);
        case 1..6, 8, 14, 16, 22, 27, 29, 33, 41..49, 82..84, 86, 87, 119, 289: 
            AttachHelmetFixed(playerid, 0.070000, 0.000000, 0.000000, 88.000000, 77.000000, 0.000000);
        case 7, 10: 
            AttachHelmetFixed(playerid, 0.090000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000);
        case 9: 
            AttachHelmetFixed(playerid, 0.059999, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000);
        case 11..13: 
            AttachHelmetFixed(playerid, 0.070000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000);
        case 15: 
            AttachHelmetFixed(playerid, 0.059999, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000);
        case 17..21: 
            AttachHelmetFixed(playerid, 0.059999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 23..26, 28, 30..32, 34..39, 57, 58, 98, 99, 104..118, 120..131: 
            AttachHelmetFixed(playerid, 0.079999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 40: 
            AttachHelmetFixed(playerid, 0.050000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 50, 100..103, 148, 150..189, 222: 
            AttachHelmetFixed(playerid, 0.070000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 51..54: 
            AttachHelmetFixed(playerid, 0.100000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 55, 56, 63, 64, 66..73, 75, 76, 78..81, 133..143, 147, 190..207, 209..219, 221, 247..272, 274..288, 290..293: 
            AttachHelmetFixed(playerid, 0.070000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 59..62: 
            AttachHelmetFixed(playerid, 0.079999, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 77: 
            AttachHelmetFixed(playerid, 0.059999, 0.019999, 0.000000, 87.000000, 82.000000, 0.000000);
        case 85, 88, 89: 
            AttachHelmetFixed(playerid, 0.070000, 0.039999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 90..97: 
            AttachHelmetFixed(playerid, 0.050000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 132: 
            AttachHelmetFixed(playerid, 0.000000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 144..146: 
            AttachHelmetFixed(playerid, 0.090000, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000);
        case 220: 
            AttachHelmetFixed(playerid, 0.029999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 223, 246: 
            AttachHelmetFixed(playerid, 0.070000, 0.050000, 0.000000, 88.000000, 82.000000, 0.000000);
        case 224..245: 
            AttachHelmetFixed(playerid, 0.070000, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 294: 
            AttachHelmetFixed(playerid, 0.070000, 0.019999, 0.000000, 91.000000, 84.000000, 0.000000);
        case 295: 
            AttachHelmetFixed(playerid, 0.050000, 0.019998, 0.000000, 86.000000, 82.000000, 0.000000);
        case 296..298: 
            AttachHelmetFixed(playerid, 0.064999, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000);
        case 299: 
            AttachHelmetFixed(playerid, 0.064998, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000);
        default:
            AttachHelmetToPlayer(playerid);
    }
}

HidePlayerMarker(playerid){
    if(!IsPlayerConnected(playerid)) return; 
    foreach(new i : Player){
        if(i != playerid)
            ShowPlayerNameTagForPlayer(i, playerid, 0);
    } 
}

ShowPlayerMarker(playerid){
    if(!IsPlayerConnected(playerid)) return; 
    foreach(new i : Player) {
        if(i != playerid)
            ShowPlayerNameTagForPlayer(i, playerid, 1);
    }
}


/*
 * Digunakan untuk menghide player lain yang menggunakan mask 
 * dari playerid yang menjadi parameter
 */
// SyncMarkerMaskToPlayer(playerid){
//     foreach(new i : Player){
//         if(i != playerid) {
//             if(PlayerInfo[i][isOnMask])
//                 ShowPlayerNameTagForPlayer(playerid, i, 0);
//             else
//                 ShowPlayerNameTagForPlayer(playerid, i, 1);
//         }
//     }
// }

/**
    Manipulasi Array Item

    IMPORTANT: INI HANYA FUNGSI BANTUAN UNTUK MANIPULASI ARRAY
    IMPORTANT: TETAP GUNAKAN tambahItemPlayer UNTUK MENGURANGI DAN MENAMBAHKAN ITEM
 */
#define LoopingItem(%0) \
    for(new %0=1;%0<=MAX_SERVER_ITEM;%0++)

#define LoopingItemDefStart(%0,%1) \
    for(new %0=%1;%0<=MAX_SERVER_ITEM;%0++)

#define bersihkanVariabelItemPlayer(%0) \
    LoopingItem(i) PlayerItem[%0][i][jumlahItem] = 0, PlayerItem[%0][i][kunciItem] = 0


/**
    Params:
        %0 = playerid
        %1 = id item
*/
#define IsPlayerHaveItem(%0,%1) \
    (PlayerItem[%0][%1][jumlahItem] > 0)

#define IsItemPlayerTerkunci(%0,%1) \
    (PlayerItem[%0][%1][kunciItem] > 0)

#define GetJumlahItemPlayer(%0,%1) \
    PlayerItem[%0][%1][jumlahItem]

#define GetStatusKunciItemPlayer(%0,%1) \
    PlayerItem[%0][%1][kunciItem]


/**
    Params:
        %0 = playerid
 */
#define GetAllItemPlayer(%0) \
    PlayerItem[%0]

GetSlotInventoryPlayer(playerid){
    new kapasitas = 0;
    LoopingItem(i){
        if(GetJumlahItemPlayer(playerid, i) < 1) continue;
        kapasitas += GetJumlahItemPlayer(playerid, i) * getKapasitasByIdItem(i);
    }
    return kapasitas;
}

/**
    %0 = playerid
    %1 = id item yang akan masuk
    %2 = jumlah item yang akan masuk
 */
#define CekJikaInventoryPlayerMuat(%0,%1,%2) \
    ((GetSlotInventoryPlayer(%0) + GetSlotItemTerpakai(%1,%2)) <= PlayerInfo[%0][limitItem])

/**
    Params:
        %0 = playerid
        %1 = id item
        %2 = jumlah 
 */
#define SetJumlahItemPlayer(%0,%1,%2) \
    PlayerItem[%0][%1][jumlahItem] = %2

/**
    Params:
        %0 = playerid
        %1 = id item
        %2 = status (0 untuk tidak kunci, 1 untuk kunci)
 */
#define SetKunciItemPlayer(%0,%1,%2) \
    PlayerItem[%0][%1][kunciItem] = %2

/**
    Params:
        %0 = playerid
        %1 = id item
*/
#define ResetItemPlayer(%0,%1) \
    PlayerItem[%0][%1][kunciItem] = 0, PlayerItem[%0][%1][kunciItem] = 0


/**
    Faction Related Function
 */
#define IsPlayerMedic(%0)           (PlayerInfo[%0][levelMedic] > 0)
#define IsPlayerPolice(%0)          (PlayerInfo[%0][levelPolice] > 0)

#define IsPlayerOnDutyMedic(%0)         (IsPlayerMedic(%0) && PlayerInfo[%0][onDutyMedic])
#define IsPlayerOnDutyPolice(%0)        (IsPlayerPolice(%0) && PlayerInfo[%0][onDutyPolice])

#define SetPlayerDutyMedic(%0,%1)     PlayerInfo[%0][onDutyMedic] = %1
#define SetPlayerDutyPolice(%0,%1)     PlayerInfo[%0][onDutyPolice] = %1

#define GetPlayerMedicLevel(%0)     PlayerInfo[%0][levelMedic]
#define GetPlayerPoliceLevel(%0)     PlayerInfo[%0][levelPolice]

#define IsPlayerIsNotInAnyDuty(%0)      (!IsPlayerOnDutyMedic(%0) && !IsPlayerOnDutyPolice(%0))

/**
    Actor Function
 */
ActorResponse(actorid, const text[], lama_text_atau_respon = LAMA_BATAS_RESPON_RESEPSIONIS){    
    ActorTalking(actorid);
    
    if(actorid == ACT_resepsionisPemerintah){
        if(ACT_resepsionisPemerintah_Timer != -1)
            DeletePreciseTimer(ACT_resepsionisPemerintah_Timer);
        // 15 detik batas interaksi
        ACT_resepsionisPemerintah_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_resepsionisPemerintah_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_skillMekanik){
        if(ACT_skillMekanik_Timer != -1)
            DeletePreciseTimer(ACT_skillMekanik_Timer);
        // 15 detik batas interaksi
        ACT_skillMekanik_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_skillMekanik_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_peralatanPancing){
        if(ACT_peralatanPancing_Timer != -1)
            DeletePreciseTimer(ACT_peralatanPancing_Timer);
        // 15 detik batas interaksi
        ACT_peralatanPancing_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_peralatanPancing_Text, COLOR_WHITE, text);
    }    else if(actorid == ACT_tokoBibit){
        if(ACT_tokoBibit_Timer != -1)
            DeletePreciseTimer(ACT_tokoBibit_Timer);
        // 15 detik batas interaksi
        ACT_tokoBibit_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_tokoBibit_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_tokoGadget){
        if(ACT_tokoGadget_Timer != -1)
            DeletePreciseTimer(ACT_tokoGadget_Timer);
        // 15 detik batas interaksi
        ACT_tokoGadget_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_tokoGadget_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_penjualDealer){
        if(ACT_penjualDealer_Timer != -1)
            DeletePreciseTimer(ACT_penjualDealer_Timer);
        // 15 detik batas interaksi
        ACT_penjualDealer_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_penjualDealer_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_tellerBankLS_1){
        if(ACT_tellerBankLS_1_Timer != -1)
            DeletePreciseTimer(ACT_tellerBankLS_1_Timer);
        // 15 detik batas interaksi
        ACT_tellerBankLS_1_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_tellerBankLS_1_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_tellerBankLS_2){
        if(ACT_tellerBankLS_2_Timer != -1)
            DeletePreciseTimer(ACT_tellerBankLS_2_Timer);
        // 15 detik batas interaksi
        ACT_tellerBankLS_2_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_tellerBankLS_2_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_tokoNarko){
        if(ACT_tokoNarko_Timer != -1)
            DeletePreciseTimer(ACT_tokoNarko_Timer);
        // 15 detik batas interaksi
        ACT_tokoNarko_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_tokoNarko_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_rumahSakit){
        if(ACT_rumahSakit_Timer != -1)
            DeletePreciseTimer(ACT_rumahSakit_Timer);
        // 15 detik batas interaksi
        ACT_rumahSakit_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_rumahSakit_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_marketPlace_1){
        if(ACT_marketPlace_1_Timer != -1)
            DeletePreciseTimer(ACT_marketPlace_1_Timer);
        // 15 detik batas interaksi
        ACT_marketPlace_1_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_marketPlace_1_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_marketPlace_2){
        if(ACT_marketPlace_2_Timer != -1)
            DeletePreciseTimer(ACT_marketPlace_2_Timer);
        // 15 detik batas interaksi
        ACT_marketPlace_2_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_marketPlace_2_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_marketPlace_3){
        if(ACT_marketPlace_3_Timer != -1)
            DeletePreciseTimer(ACT_marketPlace_3_Timer);
        // 15 detik batas interaksi
        ACT_marketPlace_3_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_marketPlace_3_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_marketPlace_4){
        if(ACT_marketPlace_4_Timer != -1)
            DeletePreciseTimer(ACT_marketPlace_4_Timer);
        // 15 detik batas interaksi
        ACT_marketPlace_4_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_marketPlace_4_Text, COLOR_WHITE, text);
    }else if(actorid == ACT_skillBlacksmith){
        if(ACT_skillBlacksmith_Timer != -1)
            DeletePreciseTimer(ACT_skillBlacksmith_Timer);
        // 15 detik batas interaksi
        ACT_skillBlacksmith_Timer = SetPreciseTimer("TerminateInteraksi", lama_text_atau_respon * 1000, false, "i", actorid);
        UpdateDynamic3DTextLabelText(ACT_skillBlacksmith_Text, COLOR_WHITE, text);
    }
}

ActorResetAndProses(actorid, playerid, const text[] = ""){
    SetPVarInt(playerid, "interaksi_actor", -1);

    if(actorid == ACT_resepsionisPemerintah){
        ACT_resepsionisPemerintah_User = INVALID_PLAYER_ID;
        ACT_resepsionisPemerintah_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_resepsionisPemerintah, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_resepsionisPemerintah, text, 5);
    }
    else if(actorid == ACT_skillMekanik){
        ACT_skillMekanik_User = INVALID_PLAYER_ID;
        ACT_skillMekanik_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_skillMekanik, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_skillMekanik, text, 5);
    }
    else if(actorid == ACT_peralatanPancing){
        ACT_peralatanPancing_User = INVALID_PLAYER_ID;
        ACT_peralatanPancing_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_peralatanPancing, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_peralatanPancing, text, 5);
    }
    else if(actorid == ACT_tokoBibit){
        ACT_tokoBibit_User = INVALID_PLAYER_ID;
        ACT_tokoBibit_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_tokoBibit, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_tokoBibit, text, 5);
    }
    else if(actorid == ACT_tokoGadget){
        ACT_tokoGadget_User = INVALID_PLAYER_ID;
        ACT_tokoGadget_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_tokoGadget, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_tokoGadget, text, 5);
    }
    else if(actorid == ACT_penjualDealer){
        ACT_penjualDealer_User = INVALID_PLAYER_ID;
        ACT_penjualDealer_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_penjualDealer, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_penjualDealer, text, 5);
    }else if(actorid == ACT_tellerBankLS_1){
        ACT_tellerBankLS_1_User = INVALID_PLAYER_ID;
        ACT_tellerBankLS_1_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_tellerBankLS_1, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_tellerBankLS_1, text, 5);
    }else if(actorid == ACT_tellerBankLS_2){
        ACT_tellerBankLS_2_User = INVALID_PLAYER_ID;
        ACT_tellerBankLS_2_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_tellerBankLS_2, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_tellerBankLS_2, text, 5);
    }
    else if(actorid == ACT_tokoNarko){
        ACT_tokoNarko_User = INVALID_PLAYER_ID;
        ACT_tokoNarko_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_tokoNarko, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_tokoNarko, text, 5);
    }
    else if(actorid == ACT_rumahSakit){
        ACT_rumahSakit_User = INVALID_PLAYER_ID;
        ACT_rumahSakit_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_rumahSakit, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_rumahSakit, text, 5);
    }
    else if(actorid == ACT_marketPlace_1){
        ACT_marketPlace_1_User = INVALID_PLAYER_ID;
        ACT_marketPlace_1_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_marketPlace_1, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_marketPlace_1, text, 5);
    }
    else if(actorid == ACT_marketPlace_2){
        ACT_marketPlace_2_User = INVALID_PLAYER_ID;
        ACT_marketPlace_2_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_marketPlace_2, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_marketPlace_2, text, 5);
    }
    else if(actorid == ACT_marketPlace_3){
        ACT_marketPlace_3_User = INVALID_PLAYER_ID;
        ACT_marketPlace_3_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_marketPlace_3, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_marketPlace_3, text, 5);
    }
    else if(actorid == ACT_marketPlace_4){
        ACT_marketPlace_4_User = INVALID_PLAYER_ID;
        ACT_marketPlace_4_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_marketPlace_4, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_marketPlace_4, text, 5);
    }
    else if(actorid == ACT_skillBlacksmith){
        ACT_skillBlacksmith_User = INVALID_PLAYER_ID;
        ACT_skillBlacksmith_Res = 0;

        // 5 Detik
        if(text[0] == '\0'){
            format(pDialog[playerid], sizePDialog, "Oke %s, silahkan lanjutkan prosesnya.", PlayerInfo[playerid][pPlayerName]);
            ActorResponse(ACT_skillBlacksmith, pDialog[playerid], 5);
        }else
            ActorResponse(ACT_skillBlacksmith, text, 5);
    }
}

// Cheatsheet : https://regexr.com/
/**
    Untuk mengecek apakah string text, memiliki pattern yang sesuai
 */
cekPattern(const text[], const pattern[]){
    new Regex:r = Regex_New(pattern, REGEX_ICASE);
    new ret = Regex_Check(text, r, MATCH_ANY);
    Regex_Delete(r);
    return ret;
}

RemovePlayerFromVehicleEx(playerid){
    removedVeh[playerid] = 1;
    TogglePlayerControllable(playerid, false);
    RemovePlayerFromVehicle(playerid);
    removedTimer[playerid] = SetPreciseTimer("resetPlayerToDo", 1000, false, "i", playerid);
    return 1;
}

SendMessageToDutyPolice(warna, const pesan[]){
    new ret = 0;
    foreach(new i : Player){
        if(IsPlayerOnDutyPolice(i))
            SendClientMessage(i, warna, pesan), ret++;
    }
    return ret;
}

SendMessageToDutyMedic(warna, const pesan[]){
    new ret = 0;
    foreach(new i : Player){
        if(IsPlayerOnDutyMedic(i))
            SendClientMessage(i, warna, pesan), ret++;
    }
    return ret;
}

#define GetExpMedicPlayer(%0)               PlayerInfo[%0][expMedic]
#define GetExpMekanikPlayer(%0)             PlayerInfo[%0][expMekanik]

#define IsPlayerInAnyAreaPenjara(%0)        (GetPVarType(%0, "last_area") && (GetPVarInt(%0, "last_area") == AREA_dalamPenjara))

IsItemPlayerCukup_Massive(playerid, const barang_barang[][], banyak_barang = sizeof(barang_barang)){
    for(new i=0;i<banyak_barang;i++){
        if(GetJumlahItemPlayer(playerid, barang_barang[i][0]) < barang_barang[i][1])
            return 0;
    }
    return 1;
}

#define GetLevelAdminPlayer(%0)             PlayerInfo[%0][levelAdmin]

/**
    Playerid untuk mengecek apakah dia menginput id sendiri

*/
// Tipe Aktif - Player yang menjadi target, sudah spawn, sudah login, dan tidak sedang sekarat
#define TIPE_TARGET_AKTIF        0
// Tipe Aktif - Player yang menjadi target, sudah spawn, sudah login, dan "bisa saja" sedang sekarat (tidak harus sekarat)
#define TIPE_TARGET_ALLOW_SEKARAT      1
IsInvalidTargetId(target_id, playerid, type = TIPE_TARGET_AKTIF){
    if(type == TIPE_TARGET_AKTIF){
        return (!IsPlayerConnected(target_id) || playerid == target_id || !PlayerInfo[target_id][sudahSpawn] || !PlayerInfo[target_id][sudahLogin] || PlayerInfo[target_id][inDie] > 0);
    }else if(type == TIPE_TARGET_ALLOW_SEKARAT){
        return (!IsPlayerConnected(target_id) || playerid == target_id || !PlayerInfo[target_id][sudahSpawn] || !PlayerInfo[target_id][sudahLogin]);
    }
    return 0;
}

publicFor: SpectatePlayer(playerid, idtujuan)
{
	if (IsPlayerInAnyVehicle(idtujuan)) {
        SetPlayerInterior(playerid, GetPlayerInterior(idtujuan));
        SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(idtujuan));
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(idtujuan));
	} else {
        SetPlayerInterior(playerid, GetPlayerInterior(idtujuan));
        SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(idtujuan));
		PlayerSpectatePlayer(playerid, idtujuan);
    }
	return 1;
}