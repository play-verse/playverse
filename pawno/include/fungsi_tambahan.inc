publicFor: sama(const kata1[], const kata2[]){
    return (!strcmp(kata1, kata2) && !isnull(kata1) && !isnull(kata2)) ? 1 : 0;
}

error_syntax(playerid, const syntax[]){
    new pesan[256] = "[{FF0000}Invalid{FFFFFF}] {FF0000}Gunakan {FFFFFF}: ";

    strcat(pesan, syntax);
    return SendClientMessage(playerid, COLOR_WHITE, pesan);
}

error_command(playerid, const message[]){
    new pesan[256] = "[{FF0000}Error{FFFFFF}] : ";
    strcat(pesan, message);
    return SendClientMessage(playerid, COLOR_WHITE, pesan);
}

server_message(playerid, const message[]){
    new pesan[200];
    format(pesan, 200, "SERVER: "GREY"%s", message);
    return SendClientMessage(playerid, COLOR_ORANGE, pesan);
}

addGajiPemain(playerid, nominal){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO `gaji`(id_user, nominal, tanggal, status) VALUES('%d', '%d', NOW(), '0')", PlayerInfo[playerid][pID], nominal);
    mysql_tquery(koneksi, pQuery[playerid]);
}

buatPickupDanLabel(modelid, Float:x, Float:y, Float:z, const text[]){
    CreateDynamic3DTextLabel(text, COLOR_WHITE, x, y, z, 20);
    return CreateDynamicPickup(modelid, 1, x, y, z);
}

buatCPDanLabel(Float:x, Float:y, Float:z, const text[], Float:ukuran, vw = -1, interiorid = -1){
    CreateDynamic3DTextLabel(text, COLOR_WHITE, x, y, z, 20);
    return CreateDynamicCP(x, y, z, ukuran, vw, interiorid, -1, 20.0);
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

getModelByIdItem(id_item){
    new nama_variabel[50];
    format(nama_variabel, sizeof(nama_variabel), "iIt_%d", id_item);
    return GetSVarInt(nama_variabel);
}

getIDbyModelItem(id_model){
    new nama_variabel[50];
    format(nama_variabel, sizeof(nama_variabel), "mIt_%d", id_model);
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

getSaldoPlayer(playerid, const fungsi_callback[]){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(SUM(nominal), 0) as saldo FROM `trans_atm` WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
    mysql_tquery(koneksi, pQuery[playerid], fungsi_callback, "i", playerid);
}

getUangPlayer(playerid, bool:useDb = false)
{
    if(useDb){
        new jumlah_uang, Cache:result;
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT `uang` FROM `user` WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
        result = mysql_query(koneksi, pQuery[playerid]);    
        cache_get_value_name_int(0, "uang", jumlah_uang);
        cache_delete(result);
        return jumlah_uang;
    }else
        return PlayerInfo[playerid][uang];
}

givePlayerUang(playerid, jumlah, bool:simpanDb = true){
    new stringUang[50];
    PlayerInfo[playerid][uang] += jumlah;

    if(simpanDb){
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", jumlah, PlayerInfo[playerid][pID]);
        mysql_tquery(koneksi, pQuery[playerid]);
    }

    valstr(stringUang, PlayerInfo[playerid][uang]);
    PlayerTextDrawSetString(playerid, RadarUang[playerid][1], stringUang);
}

Float:getStatusMakanPemain(playerid){
    return PlayerInfo[playerid][statusMakan];
}

setStatusMakanPemain(playerid, Float:jumlah){
    PlayerInfo[playerid][statusMakan] = jumlah;
    SetPlayerProgressBarValue(playerid, HUD_Stats_Bar[playerid][0], jumlah);
}

Float:getStatusMinumPemain(playerid){
    return PlayerInfo[playerid][statusMinum];
}

setStatusMinumPemain(playerid, Float:jumlah){
    PlayerInfo[playerid][statusMinum] = jumlah;
    SetPlayerProgressBarValue(playerid, HUD_Stats_Bar[playerid][1], jumlah);
}

// -- Uncomment fungsi jika ingin menggunakan
// resetUangPlayer(playerid, bool:simpanDb = true){
//     PlayerInfo[playerid][uang] = 0;

//     if(simpanDb){
//         mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET `uang` = '0' WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
//         mysql_tquery(koneksi, query);
//     }

//     PlayerTextDrawSetString(playerid, RadarUang[playerid][1], "0");
// }
ubahSkinPemain(playerid, skinid){
    // Hide dlu untuk dapat efeknya
    PlayerTextDrawHide(playerid, HUD_Stats[playerid][0]);
    PlayerTextDrawSetPreviewModel(playerid, HUD_Stats[playerid][0], skinid);
    PlayerTextDrawShow(playerid, HUD_Stats[playerid][0]);
	SetPlayerSkin(playerid, skinid);
}

setUangPlayer(playerid, jumlah, bool:simpanDb = true){
    new stringUang[50];
    PlayerInfo[playerid][uang] = jumlah;
    valstr(stringUang, PlayerInfo[playerid][uang]);

    if(simpanDb){
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = '%d' WHERE `id` = '%d'", jumlah, PlayerInfo[playerid][pID]);
        mysql_tquery(koneksi, pQuery[playerid]);
    }

    PlayerTextDrawSetString(playerid, RadarUang[playerid][1], stringUang);
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

stock ProxDetector(Float:radi, playerid, string[], color)
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
stock GetPlayerIdFromName(playername[])
{
    foreach(new i : Player){
        if(strcmp(PlayerInfo[i][pPlayerName], playername) == 0)
            return i;
    }
    return INVALID_PLAYER_ID;
}

stock GetVehicleSpeed(vehicleid) //Credits someone on SAMP Forums forgot the name
{
    new Float:x, Float:y, Float:z, vel;
    GetVehicleVelocity(vehicleid, x, y, z);
    vel = floatround(floatsqroot(x*x+y*y+z*z)*180); // KM/H
    //vel = floatround(floatsqroot(x*x+y*y+z*z)*180/1.60934); // M/H
    return vel;
}

Float:VehicleHealth(vehicleid){
  new Float:health;
  GetVehicleHealth(vehicleid, health);
  return health;
}