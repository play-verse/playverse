	/*
	GAME MODE NATHAN
*/

#include <a_samp>
#include <pengaturan> // Pengaturan server disini letak pas dibawah a_samp
#include <sscanf2>
#include <a_mysql>
#include <zcmd>
#include <foreach>
#include <moneyhax>
#include <core>
#include <float>
#include <PreviewModelDialog>
/*
	INCLUDE INCLUDE BUATAN DIBAWAH
*/
#include <global_variable> // variable disini
#include <fungsi_tambahan> // Fungsi tambahan disini - Tambahan dulu baru fungsi
#include <fungsi> // Fungsi disini

#include "../include/gl_common.inc"
#include "../include/gl_spawns.inc"

#pragma tabsize 0

public OnPlayerConnect(playerid)
{
	/*
	Removes vending machines
	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
	*/
	SetPlayerColor(playerid, COLOR_WHITE);
	
	resetPlayerVariable(playerid);

	new nama[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nama, sizeof(nama));
	PlayerInfo[playerid][pPlayerName] = nama;
    mysql_format(koneksi, query, sizeof(query), "SELECT * FROM `user` WHERE `nama` = '%e'", PlayerInfo[playerid][pPlayerName]);
	mysql_tquery(koneksi, query, "isRegistered", "d", playerid);

	return 1;
}


//----------------------------------------------------------

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch( dialogid )
    {
        case DIALOG_REGISTER:
        {
            if(response)
            {
				if( strlen(inputtext) >= 8 && strlen(inputtext) <= 24 )
				{
					format(registerInfo[playerid][registerPassword], 25, "%s", inputtext);
			        return ShowPlayerDialog(playerid, DIALOG_REPEAT_PASSWORD, DIALOG_STYLE_PASSWORD,""COL_WHITE"SILAHKAN ULANGI PASSWORD",COL_WHITE"{FFFFFF}Silahkan ulangi kembali password!","Konfirmasi","Keluar");
				} else {
			        return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""COL_WHITE"SILAHKAN DAFTAR",COL_RED"Password harus berisi 8 hingga 24 karakter!\n"COL_WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
				}
            }
            else Kick(playerid);
        }
		case DIALOG_REPEAT_PASSWORD:
		{
			if(response){
				if( sama(registerInfo[playerid][registerPassword], inputtext) )
				{
					dialogEmail(playerid);
					return 1;
				} else {
			        return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""COL_WHITE"SILAHKAN DAFTAR",COL_RED"Password konfirmasi salah! Silahkan ulangi kembali!\n"COL_WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
				}

			}
            else Kick(playerid);			
		}
        case DIALOG_LOGIN:
        {
            if( response )
            {
				new hash[65];
				// hashing the text that user entered and salt that was loaded
				SHA256_PassHash(inputtext, PlayerInfo[playerid][pPlayerName], hash, 64);
				if(sama(hash, PlayerInfo[playerid][pPassword]))
				{
					mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET `jumlah_login` = `jumlah_login` + 1 WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
					mysql_tquery(koneksi, query, "spawnPemain", "d", playerid);

					PlayerInfo[playerid][loginKe]++;
					format(msg, sizeof(msg), "~r~Selamat ~y~datang ~g~kembali~w~!~n~Anda masuk yang ke - ~g~ %d ~w~!", PlayerInfo[playerid][loginKe]);
					GameTextForPlayer(playerid, msg, 4000, 3);

					GivePlayerMoney(playerid, strval(PlayerInfo[playerid][uang]));
					return 1;
				}
				else
				{
					return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, COL_WHITE"Login",COL_RED"Password salah silahkan coba lagi, perhatikan penggunaan capslock!\n"COL_WHITE"Masukan Password untuk login ke akun!","Login","Keluar");
				}
			}
			else Kick ( playerid );
		}
		case DIALOG_INPUT_EMAIL: {
			if(response){
				if(!isnull(inputtext)){
					new format_gmail[15] = "@gmail.com", len = strlen(inputtext), len_format = strlen(format_gmail);
					if(len <= len_format || strfind(inputtext, format_gmail, true, len - len_format) == -1){
						ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", COL_RED"Format email invalid!\n"COL_WHITE"Masukan email anda, kami hanya mensupport email "COL_RED"@gmail.com\n:", "Simpan Email", "Keluar");
					}else{
						format(registerInfo[playerid][email], 100, "%s", inputtext);

						ShowPlayerDialog(playerid, DIALOG_INPUT_JEKEL, DIALOG_STYLE_LIST, "Pilih Jenis Kelamin", COL_WHITE"Laki-Laki\nPerempuan", "Simpan", "Keluar");
					}
				}else{
					ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", COL_RED"Anda harus memasukan email anda!\n"COL_WHITE"Masukan email anda, kami hanya mensupport email "COL_RED"@gmail.com\n:", "Simpan Email", "Keluar");
				}
			}else{
				Kick(playerid);
			}
		}
		case DIALOG_INPUT_JEKEL:
		{
			if(response){
				registerInfo[playerid][jenisKelamin] = listitem;

				new len;
				new subString[16];
				static string[500];
				len = listitem == 0 ? sizeof(SKIN_MALE_GRATIS) : sizeof(SKIN_FEMALE_GRATIS);

				for (new i = 0; i < len; i++) {
					format(subString, sizeof(subString), "%i\n", listitem == 0 ? SKIN_MALE_GRATIS[i] : SKIN_FEMALE_GRATIS[i]);
					strcat(string, subString);
				} 
				return ShowPlayerDialog(playerid, DIALOG_INPUT_SKIN_GRATIS, DIALOG_STYLE_PREVIEW_MODEL, "Pilih skin yang anda inginkan", string, "Pilih", "Keluar");
			}else{
				Kick(playerid);
			}
		}
		case DIALOG_INPUT_SKIN_GRATIS: 
		{
			if(response){
				registerInfo[playerid][freeSkinID] = (registerInfo[playerid][jenisKelamin] == 0) ? SKIN_MALE_GRATIS[listitem] : SKIN_FEMALE_GRATIS[listitem];
				registerUser(playerid);

				spawnPemain(playerid);
				return 1;
			}else{
				Kick(playerid);
			}
		}
    }
    return 1;
}



public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;

	new randSpawn = 0;
	
	SetPlayerInterior(playerid,0);
	SetPlayerSkin(playerid, PlayerInfo[playerid][skinID]);
	randSpawn = random(sizeof(gRandomSpawns_LosSantos));
	SetPlayerPos(playerid,
		gRandomSpawns_LosSantos[randSpawn][0],
		gRandomSpawns_LosSantos[randSpawn][1],
		gRandomSpawns_LosSantos[randSpawn][2]);

	SetPlayerFacingAngle(playerid,gRandomSpawns_LosSantos[randSpawn][3]);
	return 1;
}

//----------------------------------------------------------

public OnPlayerDeath(playerid, killerid, reason)
{
    new playercash;
        
	if(killerid == INVALID_PLAYER_ID) {
        ResetPlayerMoney(playerid);
	} else {
		playercash = GetPlayerMoney(playerid);
		if(playercash > 0)  {
			GivePlayerMoney(killerid, playercash);
			ResetPlayerMoney(playerid);
		}
	}
   	return 1;
}

//----------------------------------------------------------

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;
	return 1;
}

public OnPlayerRequestSpawn(playerid){
	if(PlayerInfo[playerid][loginKe] == 1){
		PlayerInfo[playerid][skinID] = GetPlayerSkin(playerid);
		format(msg, sizeof(msg), "PID : %d\nSkin ID : %d", PlayerInfo[playerid][pID], PlayerInfo[playerid][skinID]);
		print(msg);
		tambahSkinPlayer(playerid, PlayerInfo[playerid][skinID]);
		updatePlayerCurrentSkin(playerid, PlayerInfo[playerid][skinID]);
		return 1;
	}
	return 1;
}

/*
	UNTUK HILANGKAN INVALID INDEX PARAMETER (BAD ENTRY POINT) BIARKAN SAJA FUNGSI MAIN
*/
main( ) { }

public OnGameModeInit()
{
	koneksi = mysql_connect(HOST, USER, PASS, DB);
	errno = mysql_errno(koneksi);
	if(errno != 0){
		new error[100];
	
		mysql_error(error, sizeof (error), koneksi);
		printf("[ERROR] #%d '%s'", errno, error);
	}else{
		printf("[SUCCESS] Berhasil Koneksi ke database!");
	}

	SetGameModeText("EL v1.0");
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	ShowNameTags(1);
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetWeather(2);
	SetWorldTime(11);
	
	// SPECIAL
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/trains.txt");
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/pilots.txt");
    
    // LOS SANTOS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_inner.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_outer.txt");
    
    // OTHER AREAS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/whetstone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/bone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/flint.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/tierra.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/red_county.txt");

    printf("Total vehicles from files: %d",total_vehicles_from_files);
	return 1;
}

public OnGameModeExit(){
	mysql_close(koneksi);
}

//----------------------------------------------------------

public OnPlayerUpdate(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(IsPlayerNPC(playerid)) return 1;
	
	// No weapons in interiors
	//if(GetPlayerInterior(playerid) != 0 && GetPlayerWeapon(playerid) != 0) {
	    //SetPlayerArmedWeapon(playerid,0); // fists
	    //return 0; // no syncing until they change their weapon
	//}
	
	// Don't allow minigun
	if(GetPlayerWeapon(playerid) == WEAPON_MINIGUN) {
	    Kick(playerid);
	    return 0;
	}

	return 1;
}

public OnPlayerText(playerid, text[]){
	format(msg,sizeof(msg), "[{%06x}%d{FFFFFF}] {%06x}%s {FFFFFF}: %s",GetPlayerColor(playerid) >>> 8, playerid,  GetPlayerColor(playerid) >>> 8, PlayerInfo[playerid][pPlayerName], text);
	ProxDetector(30.0, playerid, msg, COLOR_WHITE);
	format(msg,sizeof(msg), "berkata: %s", text);
	SetPlayerChatBubble(playerid, msg, -1, 40.0, 5000);
	ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1000);
}

//----------------------------------------------------------

#include <command>
