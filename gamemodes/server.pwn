/**************************************************************************************************
	ETERNITY LEGEND SCRIPT

	MAJOR MINUS :
	- Setiap item harus memiliki model_id yang unique, jika ingin menggunakan DIALOG_PREVIEW_MODEL
***************************************************************************************************/

#include <a_samp>
#include <pengaturan> // Pengaturan server disini letak pas dibawah a_samp
#include <colors> // https://forum.sa-mp.com/showthread.php?t=573049
#include <sscanf2>
#include <streamer>
#include <mapping>
#include <a_mysql>
#include <zcmd>
#include <YSI_Data\y_iterate>
#include <moneyhax>
#include <core>
#include <float>
#include <PreviewModelDialog>
/*
	INCLUDE INCLUDE BUATAN DIBAWAH
*/
#include <global_variable> // variable disini
#include <textdraw> // Textdraw Function Loader
#include <fungsi_tambahan> // Fungsi tambahan disini - Tambahan dulu baru fungsi
#include <fungsi> // Fungsi disini

#include "../include/gl_common.inc"

/**
	Unused params is here
 */

/**
	End Unused Params
 */

public OnPlayerConnect(playerid)
{
	removeBangunanUntukMapping(playerid);
	loadTextDrawPemain(playerid);
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

public OnPlayerDisconnect(playerid, reason){
	resetPVarInventory(playerid);
	updateOnPlayerDisconnect(playerid);
	resetPlayerVariable(playerid);
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
			        return ShowPlayerDialog(playerid, DIALOG_REPEAT_PASSWORD, DIALOG_STYLE_PASSWORD,WHITE"SILAHKAN ULANGI PASSWORD",WHITE"{FFFFFF}Silahkan ulangi kembali password!","Konfirmasi","Keluar");
				} else {
			        return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""WHITE"SILAHKAN DAFTAR",RED"Password harus berisi 8 hingga 24 karakter!\n"WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
				}
            }
            else 
				Kick(playerid);
			// Selalu return 1 - wiki samp OnDialogResponse should 1 return 1 when handled
			return 1;
        }
		case DIALOG_REPEAT_PASSWORD:
		{
			if(response){
				if( sama(registerInfo[playerid][registerPassword], inputtext) )
				{
					dialogEmail(playerid);
					return 1;
				} else {
			        return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""WHITE"SILAHKAN DAFTAR",RED"Password konfirmasi salah! Silahkan ulangi kembali!\n"WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
				}

			}
            else
				Kick(playerid);			
			return 1;
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
					PlayerInfo[playerid][sudahLogin] = true;

					mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET `jumlah_login` = `jumlah_login` + 1 WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
					mysql_tquery(koneksi, query);

					PlayerInfo[playerid][loginKe]++;
					format(msg, sizeof(msg), "~r~Selamat ~y~datang ~g~kembali~w~!~n~Anda masuk yang ke - ~g~ %d ~w~!", PlayerInfo[playerid][loginKe]);
					GameTextForPlayer(playerid, msg, 4000, 3);

					GivePlayerMoney(playerid, PlayerInfo[playerid][uang]);
					SpawnPlayer(playerid);
					return 1;
				}
				else
				{
					return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, WHITE"Login",RED"Password salah silahkan coba lagi, perhatikan penggunaan capslock!\n"WHITE"Masukan Password untuk login ke akun!","Login","Keluar");
				}
			}
			else
				Kick ( playerid );
			return 1;
		}
		case DIALOG_INPUT_EMAIL: {
			if(response){
				if(!isnull(inputtext)){
					new format_gmail[15] = "@gmail.com", len = strlen(inputtext), len_format = strlen(format_gmail);
					if(len <= len_format || strfind(inputtext, format_gmail, true, len - len_format) == -1){
						ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", RED"Format email invalid!\n"WHITE"Masukan email anda, kami hanya mensupport email "RED"@gmail.com\n:", "Simpan", "Keluar");
					}else{
						format(registerInfo[playerid][email], 100, "%s", inputtext);

						ShowPlayerDialog(playerid, DIALOG_INPUT_JEKEL, DIALOG_STYLE_LIST, "Pilih Jenis Kelamin", WHITE"Laki-Laki\nPerempuan", "Simpan", "Keluar");
					}
				}else{
					ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", RED"Anda harus memasukan email anda!\n"WHITE"Masukan email anda, kami hanya mensupport email "RED"@gmail.com\n:", "Simpan", "Keluar");
				}
			}else{
				Kick(playerid);
			}
			return 1;
		}
		case DIALOG_INPUT_JEKEL:
		{
			if(response){
				registerInfo[playerid][jenisKelamin] = listitem;

				new len;
				new subString[16];
				static string[500];
				len = registerInfo[playerid][jenisKelamin] == 0 ? sizeof(SKIN_MALE_GRATIS) : sizeof(SKIN_FEMALE_GRATIS);

				for (new i = 0; i < len; i++) {
					format(subString, sizeof(subString), "%i\n", registerInfo[playerid][jenisKelamin] == 0 ? SKIN_MALE_GRATIS[i] : SKIN_FEMALE_GRATIS[i]);
					strcat(string, subString);
				} 
				return ShowPlayerDialog(playerid, DIALOG_INPUT_SKIN_GRATIS, DIALOG_STYLE_PREVIEW_MODEL, "Pilih skin yang anda inginkan", string, "Pilih", "Keluar");
			}else{
				Kick(playerid);
			}
			return 1;
		}
		case DIALOG_INPUT_SKIN_GRATIS: 
		{
			if(response){
				registerInfo[playerid][freeSkinID] = (registerInfo[playerid][jenisKelamin] == 0) ? SKIN_MALE_GRATIS[listitem] : SKIN_FEMALE_GRATIS[listitem];
				registerUser(playerid);
				return 1;
			}else{
				Kick(playerid);
			}
			return 1;
		}
		case DIALOG_INVENTORY:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						/**
							OLD INVENTORY
						 */
						// mysql_format(koneksi, query, sizeof(query), "SELECT a.id_item, a.jumlah FROM `user_item` a WHERE a.`id_user` = '%d' ORDER BY a.id_item ASC", PlayerInfo[playerid][pID]);

						mysql_format(koneksi, query, sizeof(query), "SELECT b.model_id, b.nama_item, a.jumlah FROM `user_item` a LEFT JOIN `item` b ON a.id_item = b.id_item WHERE a.`id_user` = '%d' AND a.jumlah > 0", PlayerInfo[playerid][pID]);

						mysql_tquery(koneksi, query, "tampilInventoryBarangPlayer", "d", playerid);
					}
					case 1:
					{
						mysql_format(koneksi, query, sizeof(query), "SELECT * FROM `user_skin` WHERE `id_user` = '%d'", PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, query, "tampilInventorySkinPlayer", "d", playerid);
					}
				}
			}
			return 1;
		}
		case DIALOG_PILIH_SKIN:
		{
			if(response){
				ShowPlayerDialog(playerid, DIALOG_OPTION_SKIN_INVENTORY, DIALOG_STYLE_LIST, WHITE"Pilih aksi", GREEN"Pakai Skin\n"LIGHT_BLUE"Beritahu Item\n"BLUE"Info Item", "Ok", "Keluar");

				new id_skin = strval(inputtext);
				SetPVarInt(playerid, "inv_model", id_skin);
				SetPVarString(playerid, "inv_keterangan", "Jenis skin biasa, yang dapat digunakan jika kamu memilikinya.");
			}
			return 1;
		}
		case DIALOG_BELI_SKIN:
		{
			if(response){
				new id_skin = (PlayerInfo[playerid][jenisKelamin] == 0) ? SKIN_MALE_GRATIS[listitem] : SKIN_FEMALE_GRATIS[listitem];

				tambahSkinPlayer(playerid, id_skin, false);

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mendapatkan skin", GREEN"Anda berhasil mendapatkan skin!\n"WHITE"Silahkan buka inventory untuk melihatnya.", "Ok", "");
			}
			return 1;
		}
		case DIALOG_OPTION_SKIN_INVENTORY:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						new id_skin = GetPVarInt(playerid, "inv_model");
						
						updatePlayerCurrentSkin(playerid, id_skin);
						PlayerInfo[playerid][skinID] = id_skin;

						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", GREEN"Anda berhasil mengganti skin anda!\n"WHITE"Silahkan ke kamar ganti terdekat atau spawn ulang untuk mendapatkan efeknya.", "Ok", "");
					}
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");
					}
				}
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_SHOW_ITEM_FOR_PLAYER:
		{
			new target_id;
			if(response){
				if(sscanf(inputtext, "u", target_id)) return ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Invalid playerid, silahkan masukan kembali! "WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");

				if(!IsPlayerConnected(target_id)) return ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Player dengan id tersebut tidak ada, silahkan masukan kembali! "WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");
				
				if(target_id == playerid) return ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Anda tidak dapat memasukan ID anda sendiri, silahkan masukan kembali! "WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");

				new Float:me_x, Float:me_y, Float:me_z;
				GetPlayerPos(playerid, me_x, me_y, me_z);

				if(!IsPlayerInRangeOfPoint(target_id, 8.0, me_x, me_y, me_z)) return ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Player tersebut tidak berada di dekat anda, silahkan masukan kembali! "WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");

				// Tampilkan Textdraw
				new string[500];
				GetPVarString(playerid, "inv_keterangan", string, sizeof(string));
				tampilkanTextDrawShowItem(target_id, GetPVarInt(playerid, "inv_model"), 1, string, PlayerInfo[playerid][pPlayerName]);

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", WHITE"Anda "GREEN"berhasil "WHITE"menampilkan info item anda ke player tertuju!", "Ok", "");

			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_DAFTAR_NOMOR:
		{
			if(response){
				if(!(strlen(inputtext) == 4)) return ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP anda", RED"Kode harus terdiri dari 4 angka!\n"WHITE"Masukan nomor HP yang anda inginkan :", "Simpan", "Keluar");
				if(inputtext[0] == '-' || !isNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP anda", RED"Kode harus terdiri dari angka saja!\n"WHITE"Masukan nomor HP yang anda inginkan :", "Simpan", "Keluar");

				new Cache:result, bool:valid;
				new nomor_hp[16] = "62";
				strcat(nomor_hp, inputtext);
				mysql_format(koneksi, query, sizeof(query), "SELECT * FROM `user` WHERE nomor_handphone = '%s'", nomor_hp);
				result = mysql_query(koneksi, query);
				if(cache_num_rows())
					valid = false;
				else
					valid = true;
				cache_delete(result);

				if(valid){
					mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET nomor_handphone = '%e' WHERE id = '%d'", nomor_hp, PlayerInfo[playerid][pID]);
					mysql_tquery(koneksi, query);

					format(PlayerInfo[playerid][nomorHP], 12, "%s", nomor_hp);

					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mendaftarkan nomor HP", WHITE"Anda "GREEN"berhasil "WHITE"mendaftarkan nomor HP!", "Ok", "");
				}else{
					return ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP anda", RED"Nomor HP telah ada, silahkan input yang lain!\n"WHITE"Masukan nomor HP yang anda inginkan :", "Simpan", "Keluar");
				}
			}
			return 1;
		}
		case DIALOG_ADMIN_GIVE_ITEM:
		{
			if(response){
				SetPVarInt(playerid, "inv_indexlist", strval(inputtext));

				ShowPlayerDialog(playerid, DIALOG_PILIH_PLAYER_FOR_ITEM, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",WHITE"Masukan ID player yang akan kamu beri item.","Beri","Keluar");
			}
			return 1;
		}
		case DIALOG_PILIH_PLAYER_FOR_ITEM:
		{
			if(response){
				new target_id;
				if(sscanf(inputtext, "u", target_id)) return ShowPlayerDialog(playerid, DIALOG_PILIH_PLAYER_FOR_ITEM, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Invalid playerid, silahkan masukan kembali!\n"WHITE"Masukan ID player yang akan kamu tampilkan item.","Beri","Keluar");
				if(!IsPlayerConnected(target_id)) return ShowPlayerDialog(playerid, DIALOG_PILIH_PLAYER_FOR_ITEM, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Player dengan id tersebut tidak ada, silahkan masukan kembali!\n"WHITE"Masukan ID player yang akan kamu tampilkan item.","Beri","Keluar");

				SetPVarInt(playerid, "inv_target_id", target_id);

				ShowPlayerDialog(playerid, DIALOG_PILIH_JUMLAH_ITEM, DIALOG_STYLE_INPUT,""WHITE"Jumlah barang",WHITE"Berapa banyak yang ingin kamu berikan :", "Beri", "Keluar");
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_PILIH_JUMLAH_ITEM:
		{
			if(response){
				new jumlah, item_id, nama_item[256], model_id;
				if(sscanf(inputtext, "i", jumlah)) return ShowPlayerDialog(playerid, DIALOG_PILIH_JUMLAH_ITEM, DIALOG_STYLE_INPUT,""WHITE"Jumlah barang", RED"Inputan tidak valid!\n"WHITE"Berapa banyak yang ingin kamu berikan :", "Beri", "Keluar");

				if(!IsPlayerConnected(GetPVarInt(playerid, "inv_target_id"))) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX,""WHITE"Invalid", RED"Player dengan id tertuju sudah meninggalkan server!\n","Ok", "");

				model_id = GetPVarInt(playerid, "inv_indexlist");
				item_id = getIDbyModelItem(model_id);
				tambahItemPlayer(GetPVarInt(playerid, "inv_target_id"), item_id, jumlah);
				getNamaByIdItem(item_id, nama_item);
				format(msg, sizeof(msg), WHITE"Anda "GREEN"mendapatkan "WHITE"item "BLUE"%s "WHITE"dari admin!", nama_item);
				ShowPlayerDialog(GetPVarInt(playerid, "inv_target_id"), DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mendapatkan item", msg, "Ok", "");

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", WHITE"Anda "GREEN"berhasil "WHITE"memberikan item ke player tertuju!", "Ok", "");
				resetPVarInventory(playerid);
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_PILIH_ITEM:
		{
			if(response){
				mysql_format(koneksi, query, sizeof(query), "SELECT jumlah FROM `user_item` WHERE id_user = '%d' AND id_item = '%d'", PlayerInfo[playerid][pID], getIDbyModelItem(strval(inputtext)));
				mysql_tquery(koneksi, query, "cekJumlahItem", "dd", playerid, strval(inputtext));
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_OPTION_ITEM_INVENTORY:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						updatePlayerCurrentPhone(playerid, GetPVarInt(playerid, "inv_indexlist"));
						resetPVarInventory(playerid);
					}
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");
					}
					case 2:
					{
						// Tampilkan Textdraw
						new string[500];
						GetPVarString(playerid, "inv_keterangan", string, sizeof(string));
						tampilkanTextDrawShowItem(playerid, GetPVarInt(playerid, "inv_model"), GetPVarInt(playerid, "inv_jumlah"), string, PlayerInfo[playerid][pPlayerName]);

						resetPVarInventory(playerid);
					}
				}
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
    }

	// Wiki-SAMP OnDialogResponse should return 0
    return 0;
}


public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == showItem[playerid][4])
    {
        CancelSelectTextDraw(playerid);
		hideTextDrawShowItem(playerid);
        return 1;
    }else if(playertextid == myInfo[playerid][7]){
		CancelSelectTextDraw(playerid);
		hideTextDrawMyInfo(playerid);
		return 1;
	}
    return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_SUBMISSION)
    {
        SelectTextDraw(playerid, 0xFF4040AA);
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	spawnPemain(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
   	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;
	if(PlayerInfo[playerid][sudahLogin]) {
		SpawnPlayer(playerid);
		return 1;
	}
	// Interpolate Camera untuk login
	// Spawn di request class dihilangin
	// SetSpawnInfo(playerid, NO_TEAM, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	// SpawnPlayer(playerid);
	return 0;
}

public OnPlayerRequestSpawn(playerid){
	if(PlayerInfo[playerid][sudahLogin]) return 1;
	return 0;
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

	printf("[MAPPING] Load semua mappingan...");
	loadAllMapingan();
	printf("[MAPPING] Sukses load mapping!");

	printf("[ITEM] Load semua item...");
	loadAllItem();
	printf("[ITEM] Sukses load item!");

	SetGameModeText("EL v1.0");
	// ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
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
	return 1;
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

public OnPlayerStateChange(playerid, newstate, oldstate){
	return 1;
}

public OnPlayerText(playerid, text[]){
	format(msg,sizeof(msg), "[%d] %s : %s", playerid,  PlayerInfo[playerid][pPlayerName], text);
	ProxDetector(30.0, playerid, msg, COLOR_WHITE);
	format(msg,sizeof(msg), "berkata: %s", text);
	SetPlayerChatBubble(playerid, msg, -1, 40.0, 5000);
	ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1000);
	// Wiki Samp - OnPlayerText
	// Return 1 - Mengirimkan pesan default
	// Return 0 - Mengirimkan pesan yang sudah dicustom saja, tanpa menjalankan perintah default pesan
	return 0; // ignore the default text and send the custom one
}

#include <command>
