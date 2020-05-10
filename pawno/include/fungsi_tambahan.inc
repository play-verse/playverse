forward sama(const kata1[], const kata2[]);
public sama(const kata1[], const kata2[]){
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

buatPickupDanLabel(modelid, Float:x, Float:y, Float:z, const text[]){
    CreateDynamic3DTextLabel(text, COLOR_WHITE, x, y, z, 20);
    return CreateDynamicPickup(modelid, 1, x, y, z);
}

buatCPDanLabel(Float:x, Float:y, Float:z, const text[], Float:ukuran){
    CreateDynamic3DTextLabel(text, COLOR_WHITE, x, y, z, 20);
    return CreateDynamicCP(x, y, z, ukuran);
}

pindahkanPemain(playerid, Float:x, Float:y, Float:z, Float:a, int, vw, bool:preload_dynamic_map = false){
    if(preload_dynamic_map){
        Streamer_UpdateEx(playerid, x, y, z, vw, int, -1, 1000, 1);
    }
        
    SetPlayerPos(playerid, x, y, z);
    SetPlayerFacingAngle(playerid, a);
    SetPlayerInterior(playerid, int);
    SetPlayerVirtualWorld(playerid, vw);
}

// getModelByIdItem(id_item){
//     new nama_variabel[50];
//     format(nama_variabel, sizeof(nama_variabel), "iIt_%d", id_item);
//     return GetSVarInt(nama_variabel);
// }

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

getUangPlayer(playerid, bool:useDb = false)
{
    if(useDb){
        new jumlah_uang, Cache:result;
        mysql_format(koneksi, query, sizeof(query), "SELECT `uang` FROM `user` WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
        result = mysql_query(koneksi, "SELECT `uang` FROM `user` WHERE id = '%d'");    
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
        mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", jumlah, PlayerInfo[playerid][pID]);
        mysql_tquery(koneksi, query);
    }

    valstr(stringUang, PlayerInfo[playerid][uang]);
    PlayerTextDrawSetString(playerid, RadarUang[playerid][1], stringUang);
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

setUangPlayer(playerid, jumlah, bool:simpanDb = true){
    new stringUang[50];
    PlayerInfo[playerid][uang] = jumlah;
    valstr(stringUang, PlayerInfo[playerid][uang]);

    if(simpanDb){
        mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET `uang` = '%d' WHERE `id` = '%d'", jumlah, PlayerInfo[playerid][pID]);
        mysql_tquery(koneksi, query);
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

forward keluarkanPlayer(playerid);
public keluarkanPlayer(playerid){
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

stock GetPlayerIdFromName(playername[])
{
  for(new i = 0; i <= MAX_PLAYERS; i++)
  {
    if(IsPlayerConnected(i))
    {
      new playername2[MAX_PLAYER_NAME];
      GetPlayerName(i, playername2, sizeof(playername2));
      if(strcmp(playername2, playername, true, strlen(playername)) == 0)
      {
        return i;
      }
    }
  }
  return INVALID_PLAYER_ID;
}