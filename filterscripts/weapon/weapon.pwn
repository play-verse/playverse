#include <a_samp>
#include <sscanf2>
#include <a_mysql>
#include "../../include/gl_spawns.inc"
#include <zcmd>

#define FILTERSCRIPT

#define function:%0(%1) forward %0(%1); public %0(%1)

#define COLOR_RED 0xFF0000FF
#define COLOR_YELLOW 0xFFF000FF
#define COLOR_BLUE 0x0023FFFF
#define COLOR_WHITE 0xFEFEFEFF
#define COLOR_BLUE_LIGHT 0x00FFE6FF

/**
    MYSQL Settings
 */
new MySQL:koneksi,
    errno;
#define SQL_HOSTNAME "localhost"
#define SQL_USERNAME "root"
#define SQL_DATABASE "weapon_samp"
#define SQL_PASSWORD ""

enum {
    DialogDummy = 1
}

enum InfoPemain {
    bool:sudahSpawn,
    bool:sudahLogin,
    namaPemain[MAX_PLAYER_NAME + 1],
    skinID
}
new PlayerInfo[MAX_PLAYERS][InfoPemain];

public OnFilterScriptInit(){
    koneksi = mysql_connect(SQL_HOSTNAME, SQL_USERNAME, SQL_PASSWORD, SQL_DATABASE);
    errno = mysql_errno(koneksi);
	mysql_log(); // MySQL log print

	if(errno != 0){
		new error[100];
		mysql_error(error, sizeof(error), koneksi);
		printf("[FS-ERROR] #%d '%s'", errno, error);
	}else
		printf("[WEAPON] Berhasil koneksi ke database!");
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(PlayerInfo[playerid][sudahLogin]) {
		spawnPemain(playerid);
		return 1;
	}    
    return 0; // Block player dari spawn sendiri
}

public OnPlayerRequestSpawn(playerid){
	if(PlayerInfo[playerid][sudahLogin]) return 1; // Allow player untuk spawn langsung
    return 0; // Block jika belum login tapi ingin spawn
}

public OnPlayerConnect(playerid)
{
    // Reset player variabel
    PlayerInfo[playerid][sudahSpawn] = false;
    PlayerInfo[playerid][sudahLogin] = false;

    // Pindahkan nama pemain ke variabel
    new tempNama[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, tempNama, MAX_PLAYER_NAME + 1);
    format(PlayerInfo[playerid][namaPemain], MAX_PLAYER_NAME + 1, "%s", tempNama);

    ShowPlayerDialog(playerid, DialogDummy, DIALOG_STYLE_INPUT, "Selamat datang", "Silahkan ketik id skin anda (0-299) :", "Ok", "Batal");
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason){
	PlayerInfo[playerid][sudahSpawn] = false;

    // Inisialisasi spawn info, untuk jaga-jaga jika callback spawn tidak terpanggil
    new randval = random(sizeof(gRandomSpawns_LosSantos));
    SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], gRandomSpawns_LosSantos[randval][0], gRandomSpawns_LosSantos[randval][1], gRandomSpawns_LosSantos[randval][2], gRandomSpawns_LosSantos[randval][3], 0, 0, 0, 0, 0, 0);

    return 1;
}

public OnPlayerDisconnect(playerid, reason){
    new weaponid, ammo;

    // Save weapon pemain satu per satu
    for(new i = 0; i < 13; i++)
    {
        GetPlayerWeaponData(playerid, i, weaponid, ammo);

        if(!weaponid || !ammo) continue; // Jangan import jika gaada weapon

        new sqlQuery[200];
        mysql_format(koneksi, sqlQuery, sizeof(sqlQuery), "INSERT INTO weapon_user VALUES ('%e', %d, %d, %d) ON DUPLICATE KEY UPDATE ammo = %d, weapon_id = %d", PlayerInfo[playerid][namaPemain], i, weaponid, ammo, ammo, weaponid);
        mysql_pquery(koneksi, sqlQuery);
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
    switch(dialogid){
        case DialogDummy:
        {
            if(response){
                new skinid;
                if(sscanf(inputtext, "i", skinid) || skinid < 0 || skinid > 299) return ShowPlayerDialog(playerid, DialogDummy, DIALOG_STYLE_INPUT, "Selamat datang", "Invalid skin id\nSilahkan ketik id skin anda (0-299) :", "Ok", "Batal");

                PlayerInfo[playerid][skinID] = skinid;
                PlayerInfo[playerid][sudahLogin] = true;

				spawnPemain(playerid);
            }
            else 
                ShowPlayerDialog(playerid, DialogDummy, DIALOG_STYLE_INPUT, "Selamat datang", "Anda harus login\nSilahkan ketik id skin anda (0-299) :", "Ok", "Batal");
            return 1;
        }
    }
    return 0;
}

// Fungsi untuk alternatif spawn
spawnPemain(playerid)
{
	if(PlayerInfo[playerid][sudahSpawn]) return 1; // Pastikan hanya terpanggil 1x
	PlayerInfo[playerid][sudahSpawn] = true;
	
    new randval = random(sizeof(gRandomSpawns_LosSantos));
    SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], gRandomSpawns_LosSantos[randval][0], gRandomSpawns_LosSantos[randval][1], gRandomSpawns_LosSantos[randval][2], gRandomSpawns_LosSantos[randval][3], 0, 0, 0, 0, 0, 0);
    
    SpawnPlayer(playerid);

	pindahkanPemain(playerid, gRandomSpawns_LosSantos[randval][0], gRandomSpawns_LosSantos[randval][1], gRandomSpawns_LosSantos[randval][2], gRandomSpawns_LosSantos[randval][3], 0, 0, true);

    new sqlQuery[128];
    mysql_format(koneksi, sqlQuery, sizeof(sqlQuery), "SELECT * FROM weapon_user WHERE username = '%e'", PlayerInfo[playerid][namaPemain]);
    mysql_tquery(koneksi, sqlQuery, "loadWeapon", "i", playerid);

    // Mengatasi masalah skin bug saat spawn jika tidak memilih class
    // Konsekuensi dari bypass class selection
    TogglePlayerControllable(playerid, 0);
    SetTimerEx("GantiSkinSaatSpawn", 2000, false, "i", playerid);
	return 1;
}

function: loadWeapon(playerid){
    new rows;
    cache_get_row_count(rows);
    if(rows){
        new idx = 0, weaponid, ammo;
        while(idx < rows){
            // Load semua weapon player
            cache_get_value_name_int(idx, "ammo", ammo);
            cache_get_value_name_int(idx, "weapon_id", weaponid);
            GivePlayerWeapon(playerid, weaponid, ammo);
            idx++;
        }

        // Hapus semua weapon player yang ada didatabase
        new sqlQuery[128];
        mysql_format(koneksi, sqlQuery, sizeof(sqlQuery), "DELETE FROM weapon_user WHERE username = '%e'", PlayerInfo[playerid][namaPemain]);
        mysql_tquery(koneksi, sqlQuery);
    }
    return 1;
}


function: GantiSkinSaatSpawn(playerid){
	TogglePlayerControllable(playerid, 1);
	SetPlayerSkin(playerid, PlayerInfo[playerid][skinID]);
}

pindahkanPemain(playerid, Float:x, Float:y, Float:z, Float:a, int, vw, bool:preload_dynamic_map = false){
    SetPlayerFacingAngle(playerid, a);

    if(preload_dynamic_map){
        // Siapa tau ingin spawn, terus load dynamic object dulu
        // Uncomment kalau ingin digunakan
        // Streamer_UpdateEx(playerid, x, y, z, vw, int, -1, 2000, 1);
        GameTextForPlayer(playerid, "~w~Sedang ~y~loading..", 1500, 3);
    }

    if(preload_dynamic_map)
        // Spawn agak tinggi 0.5 z dari ground jika lagi load dynamic object
        SetPlayerPos(playerid, x, y, z + 0.5);
    else
        SetPlayerPos(playerid, x, y, z);

    SetPlayerInterior(playerid, int);
    SetPlayerVirtualWorld(playerid, vw);
}


/***
    Dummy command untuk testing
    -- Hapus kalau mau diupload ke server
 */
CMD:getweapon(playerid, params[]){
    new weaponid, ammo;
    if(sscanf(params, "ii", weaponid, ammo)) return SendClientMessage(playerid, COLOR_RED, "gunakan /getweapon [weaponid] [ammo]");
    GivePlayerWeapon(playerid, weaponid, ammo);
    return 1;
}

CMD:killme(playerid, params[]){
    SetPlayerHealth(playerid, 0);
    return 1;
}