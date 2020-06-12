/**************************************************************************************************
	ETERNITY LEGEND

	FUTURE BUG :
	- 
***************************************************************************************************/

#include <a_samp>
#include <pengaturan> // Pengaturan server disini letak pas dibawah a_samp
#include <colors> // https://forum.sa-mp.com/showthread.php?t=573049
#include <sscanf2>
#include <streamer>
#include <progress2>
#include <samp-precise-timers>

#include <a_mysql>
#include <zcmd>

#define YSI_NO_HEAP_MALLOC
#define YSI_NO_VERSION_CHECK
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_timers>
#include <YSI_Coding\y_inline>

#include <core>
#include <float>
#include <PreviewModelDialog>
/*
	INCLUDE INCLUDE BUATAN DIBAWAH
*/
#include <global_variable> // variable disini
#include <mapping> // Mappingan loader
#include <textdraw> // Textdraw Function Loader
#include <pickup> // Pickup Function Loader
#include <map_icon> // Map Icon Function Loader
#include <checkpoint> // CP Function Loader
#include <area> // Area loader
#include <dialog> // Function Dialog Loader
#include <fungsi_tambahan> // Fungsi tambahan disini - Tambahan dulu baru fungsi
#include <fungsi> // Fungsi disini

#include <../include/gl_common.inc>

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

	// Removes vending machines - SA-MP Official scripts
	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
	// End Remove vending machines

	SetPlayerColor(playerid, COLOR_WHITE);
	
	resetPlayerVariable(playerid);
	ResetPVarTemporary(playerid);
	ResetPlayerMoney(playerid);
	resetPlayerToDo(playerid);
	TextDrawShowForPlayer(playerid, TD_JamTanggal[0]);
	TextDrawShowForPlayer(playerid, TD_JamTanggal[1]);
	LoadSpeedoTextDraws(playerid);

	new nama[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nama, sizeof(nama));
	PlayerInfo[playerid][pPlayerName] = nama;

	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerConnect terpanggil (%d - %s)", playerid, nama);
	#endif

    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT a.*, sum(b.jumlah) as limit_item FROM `user` a LEFT JOIN user_item_limit b ON b.id_user = a.id WHERE nama = '%e' AND (b.expired > NOW() OR b.expired IS NULL)", PlayerInfo[playerid][pPlayerName]);
	mysql_tquery(koneksi, pQuery[playerid], "isRegistered", "d", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason){
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerDisconnect terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif	

	if(PlayerInfo[playerid][sudahLogin]) {
		updateOnPlayerDisconnect(playerid);

		if(IsPlayerInAnyVehicle(playerid)){
			new vehicleid = GetPlayerVehicleID(playerid);
			if(Iter_Contains(IDVehToPVehIterator, vehicleid)){
				new Float:darah;
				GetVehicleHealth(vehicleid, darah);

				if(!IsVehicleFlipped(vehicleid) && darah > 300)
				{
					new idpv = IDVehToPVeh[vehicleid];
					GetVehiclePos(vehicleid, PVeh[idpv][pVehCoord][0], PVeh[idpv][pVehCoord][1], PVeh[idpv][pVehCoord][2]);
					GetVehicleZAngle(vehicleid, PVeh[idpv][pVehCoord][3]);
					PVeh[idpv][pVehDarah] = darah;
					UpdatePosisiDarahVehiclePlayer(vehicleid);
				}
			}
		}
	}


	ResetPVarTemporary(playerid);

	DeletePVar(playerid, "sms_list_pesan");
	DeletePVar(playerid, "sms_id_pesan");
	
	// Delete PVar dialog SMS
	DeletePVar(playerid, "sms_id_penerima");

	// Regis Bank
	DeletePVar(playerid, "regis_rekening");	
	DeletePVar(playerid, "depo_nominal");

	// ATM
	DeletePVar(playerid, "tf_nama");
	DeletePVar(playerid, "tf_rekening");
	DeletePVar(playerid, "wd_nominal");

	UnloadVehiclePlayer(playerid);

	resetPVarInventory(playerid);
	resetPlayerToDo(playerid);
	resetPlayerVariable(playerid);
	// hideTextDrawUang(playerid);
	ResetPlayerMoney(playerid);
	unloadTextDrawPemain(playerid);
	return 1;
}

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
					return ShowPlayerDialog(playerid, DIALOG_REPEAT_PASSWORD, DIALOG_STYLE_PASSWORD,WHITE"Silahkan ulangi password",WHITE"Silahkan ulangi kembali password yang anda tulis tadi untuk mengkonfirmasi kebeneran password.","Konfirmasi","Keluar");
				} else {
					return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""WHITE"SILAHKAN DAFTAR",RED"Password harus berisi 8 hingga 24 karakter!\n"WHITE"Kamu {FF0000}belum terdaftar "WHITE"di server","Daftar","Keluar");
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

					mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `jumlah_login` = `jumlah_login` + 1 WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
					mysql_tquery(koneksi, pQuery[playerid]);

					PlayerInfo[playerid][loginKe]++;

					PlayerInfo[playerid][waktuSaatLogin] = gettime();

					// tampilkanTextDrawUang(playerid);
					LoadVehiclePlayer(playerid);

					// Set player uang tanpa menambahkan di database - maka diset false untuk parameter terakhir
					setUangPlayer(playerid, PlayerInfo[playerid][uang], false);
					#if defined DEBUG_MODE_FOR_PLAYER
					print("Spawn Called in Login Success");
					#endif
					spawnPemain(playerid);

					format(msg, sizeof(msg), "~w~Selamat datang ~g~kembali~w~!~n~Anda masuk yang ke - ~g~ %i ~w~!", PlayerInfo[playerid][loginKe]);
					GameTextForPlayer(playerid, msg, 4000, 3);
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
					case 0: // Item
					{
						SetPVarInt(playerid, "halaman", 0);
						showDialogListItem(playerid);
					}
					case 1: // Skin
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `user_skin` WHERE `id_user` = '%d' AND `jumlah` > 0", PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid], "tampilInventorySkinPlayer", "i", playerid);
					}
					case 2: // Kendaraan
					{
						new string[250 * BANYAK_DATA_PER_PAGE + 200];
						format(string, sizeof(string), "Kode\tNama\tJarak\tSisa Waktu Kunci\n");
						
						foreach(new i : PVehIterator){
							if(PVeh[i][pVehPemilik] == PlayerInfo[playerid][pID]){
								if(PVeh[i][pVehIsReparasi] == 1){ // Jika mobil sedang dalam reparasi (telah rusak) dan belum diperbaiki dan dibayar
									format(string, sizeof(string), "%s%d\t%s\t"RED"Rusak total\t"GREEN"Milik Sendiri\n", string, i, GetVehicleNameFromModel(PVeh[i][pVehModel]));
								}else if(PVeh[i][pVehIsReparasi] == 2){ // Jika mobil sedang dalam reparasi namun telah siap diambil
									format(string, sizeof(string), "%s%d\t%s\t"YELLOW"Telah direcovery\t"GREEN"Milik Sendiri\n", string, i, GetVehicleNameFromModel(PVeh[i][pVehModel]));
								}else{
									new Float:pos[3];
									GetVehiclePos(PVeh[i][pVehicle], pos[0], pos[1], pos[2]);
									format(string, sizeof(string), "%s%d\t%s\t%.2fm\t"GREEN"Milik Sendiri\n", string, i, GetVehicleNameFromModel(PVeh[i][pVehModel]), GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]));
								}
							}else if(Iter_Contains(PVehKeys[playerid], i) && PVehKeysTime[playerid][i] > gettime()){
								if(PVeh[i][pVehIsReparasi] == 1){ // Jika mobil sedang dalam reparasi (telah rusak) dan belum diperbaiki dan dibayar
									format(string, sizeof(string), "%s%d\t%s\t"RED"Rusak total\t"YELLOW"%i menit\n", string, i, GetVehicleNameFromModel(PVeh[i][pVehModel]), (PVehKeysTime[playerid][i] - gettime()) / 60);
								}else if(PVeh[i][pVehIsReparasi] == 2){ // Jika mobil sedang dalam reparasi namun telah siap diambil
									format(string, sizeof(string), "%s%d\t%s\t"YELLOW"Telah direcovery\t"YELLOW"%i menit\n", string, i, GetVehicleNameFromModel(PVeh[i][pVehModel]), (PVehKeysTime[playerid][i] - gettime()) / 60);
								}else{
									new Float:pos[3];
									GetVehiclePos(PVeh[i][pVehicle], pos[0], pos[1], pos[2]);
									format(string, sizeof(string), "%s%d\t%s\t%.2fm\t"YELLOW"%i menit\n", string, i, GetVehicleNameFromModel(PVeh[i][pVehModel]), GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]), (PVehKeysTime[playerid][i] - gettime()) / 60);
								}
							}
						}

						if(strcmp(string, "Kode\tNama\tJarak\tSisa Waktu Kunci\n") == 0){
							showDialogPesan(playerid, RED"Tidak terdapat kendaraan", WHITE"Tidak terdapat kendaraan apapun yang anda miliki.\nPastikan untuk memiliki kendaraan untuk dapat mengakses menu ini.");
						}else
							ShowPlayerDialog(playerid, DIALOG_PILIH_KENDARAAN, DIALOG_STYLE_TABLIST_HEADERS, "Kendaraan yang anda miliki.", string, "Pilih", "Kembali");
					}
					case 3: // Furniture
					{
						SetPVarInt(playerid, "halaman", 0);
						showDialogListFurniturePemain(playerid);
					}
				}
			}
			return 1;
		}
		case DIALOG_PILIH_KENDARAAN:
		{
			if(response){
				new id = strval(inputtext);
				SetPVarInt(playerid, "veh_select_id", id);
				ShowPlayerDialog(playerid, DIALOG_OPTION_KENDARAAN_INVENTORY, DIALOG_STYLE_LIST, WHITE"Pilih aksi:", "Tampilkan Lokasi Kendaraan\nPinjamkan Kunci kepada orang\nLihat kunci kendaraan ini yang dipinjamkan", "Pilih", "Batal");
			}else{
				resetPVarInventory(playerid);
				showDialogMenuInventory(playerid);
			}
			return 1;
		}
		case DIALOG_OPTION_KENDARAAN_INVENTORY:
		{
			if(response){
				switch(listitem){
					case 0: // Tampilkan Lokasi Kendaraan
					{
						new id = GetPVarInt(playerid, "veh_select_id");
						DeletePVar(playerid, "veh_select_id");
						if(PVeh[id][pVehIsReparasi]) return showDialogPesan(playerid, RED"Kendaraan sedang rusak", WHITE"Kendaraan yang anda maksud, sedang rusak dan harus diambil terlebih dahulu di "ORANGE"pusat reparasi"WHITE".");

						new Float:pos[3];
						GetVehiclePos(PVeh[id][pVehicle], pos[0], pos[1], pos[2]);
						SetPlayerCheckpoint(playerid, pos[0], pos[1], pos[2], 5.0);
						PlayerInfo[playerid][activeMarker] = true;

						SendClientMessage(playerid, COLOR_PINK, "[GPS] "WHITE"Lokasi mobil yang anda maksud telah ditandai pada peta menggunakan marker merah.");
						SendClientMessage(playerid, COLOR_PINK, "[GPS] "YELLOW"Penggunaan fitur ini akan menggantikan marker yang sebelumnya ada.");
						return 1;
					}
					case 1:
					{
						new id = GetPVarInt(playerid, "veh_select_id");

						if(PVeh[id][pVehPemilik] != PlayerInfo[playerid][pID]){
							return showDialogPesan(playerid, RED"Kendaraan tidak dapat dipinjamkan", WHITE"Kendaraan tidak dapat dipinjamkan, kendaraan ini bukanlah milik anda.\n"YELLOW"Anda hanya dapat meminjamkan kendaraan milik anda sendiri.");
						}
						inline responseQuery(){
							new total;
							cache_get_value_name_int(0, "total", total);
							if(total < MAXIMUM_PINJAMKAN_KEY){
								ShowPlayerDialog(playerid, DIALOG_PINJAMIN_KUNCI_PLAYERID, DIALOG_STYLE_INPUT, YELLOW"Masukan ID pemain", YELLOW"Silahkan masukan ID Pemain yang akan dipinjamkan kunci kendaraan.\n"WHITE"Hanya dapat meminjamkan kunci kepada pemain yang berada maksimal 2 meter.\n"WHITE"Pastikan player yang anda tuju belum dipinjami kendaraan yang sama.", "Pilih", "Batal");
							}else{
								format(pDialog[playerid], sizePDialog, YELLOW"Anda tidak dapat meminjamkan kunci lagi,\n"WHITE"Kendaraan yang anda pilih telah mencapai batas peminjaman kunci.\n"ORANGE"Batas peminjaman kunci adalah %i orang.", MAXIMUM_PINJAMKAN_KEY);
								showDialogPesan(playerid, RED"Tidak dapat meminjamnkan kunci", pDialog[playerid]);
							}

						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT COUNT(id) as total FROM vehicle_keys WHERE id_vehicle = '%d' AND UNIX_TIMESTAMP(NOW()) < expired", PVeh[id][pVehID]);
					}
					case 2:
					{
						new id = GetPVarInt(playerid, "veh_select_id");
						if(PVeh[id][pVehPemilik] != PlayerInfo[playerid][pID]){
							return showDialogPesan(playerid, RED"Kendaraan tidak milik anda", WHITE"Kendaraan ini tidak dapat dilihat siapa yang meminjam, kendaraan ini bukanlah milik anda.\n"YELLOW"Anda hanya dapat melihat kendaraan milik anda sendiri.");
						}						
						inline responseQuery(){
							new rows;
							cache_get_row_count(rows);
							if(rows){
								new idx = 0, temp_nama[MAX_PLAYER_NAME], temp_durasi, string[1000] = WHITE"Nama Pemain\tSisa Durasi\n";
								while(idx < rows){
									cache_get_value_name(idx, "nama", temp_nama);
									cache_get_value_name_int(idx, "expired", temp_durasi);

									format(string, sizeof(string), "%s"GREEN"%s\t"YELLOW"%i menit\n", string, temp_nama, ((temp_durasi - gettime()) / 60));
									idx++;
								}

								format(pDialog[playerid], sizePDialog, WHITE"Peminjam kunci "GREEN"%s "WHITE":", GetVehicleNameFromModel(PVeh[id][pVehModel]));
								ShowPlayerDialog(playerid, DIALOG_PILIH_PEMINJAMAN_KEY, DIALOG_STYLE_TABLIST_HEADERS, pDialog[playerid], string, "Pilih", "Batal");
							}else{
								format(pDialog[playerid], sizePDialog, WHITE"Kendaraan "YELLOW"%s "WHITE"milik anda. Tidak dipinjam oleh siapapun.\nAnda dapat meminjamkannya kepada orang lain. Dengan mengakses menu sebelumnya.", GetVehicleNameFromModel(PVeh[id][pVehModel]));
								return showDialogPesan(playerid, RED"Kendaraan tidak dipinjamkan", pDialog[playerid]);
							}
						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT a.id, a.expired, b.nama FROM vehicle_keys a LEFT JOIN `user` b ON a.id_user = b.id WHERE a.id_vehicle = '%d' AND a.expired > UNIX_TIMESTAMP(NOW())", PVeh[id][pVehID]);
					}
				}
			}else{
				DeletePVar(playerid, "veh_select_id");
			}
			return 1;
		}
		case DIALOG_PILIH_PEMINJAMAN_KEY:
		{
			if(response){
				SetPVarString(playerid, "peminjam_username", inputtext);
				ShowPlayerDialog(playerid, DIALOG_PILIH_PEMINJAMAN_KEY_OPT, DIALOG_STYLE_LIST, "Pilih aksi : ", "Tarik kunci yang dipinjamkan", "Pilih", "Batal");
			}
			return 1;
		}
		case DIALOG_PILIH_PEMINJAMAN_KEY_OPT:
		{
			if(response){
				new temp_nama[24];
				GetPVarString(playerid, "peminjam_username", temp_nama, sizeof(temp_nama));
				DeletePVar(playerid, "peminjam_username");
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE a FROM vehicle_keys a LEFT JOIN `user` b ON a.id_user = b.id WHERE a.id_vehicle = '%d' AND a.expired > UNIX_TIMESTAMP(NOW()) AND b.nama = '%e'", PVeh[GetPVarInt(playerid, "veh_select_id")][pVehID], temp_nama);
				mysql_tquery(koneksi, pQuery[playerid]);

				foreach(new i : Player){
					if(strcmp(PlayerInfo[i][pPlayerName], temp_nama) == 0){
						// Bersihkan iterator
						Iter_Remove(PVehKeys[i], GetPVarInt(playerid, "veh_select_id"));
						PVehKeysTime[i][GetPVarInt(playerid, "veh_select_id")] = 0;

						format(pDialog[playerid], sizePDialog, "[KENDARAAN] "WHITE"Kunci "YELLOW"%s "WHITE"yang anda pinjam dari "GREEN"%s "WHITE"telah ditarik.",PlayerInfo[playerid][pPlayerName], GetVehicleNameFromModel(PVeh[GetPVarInt(playerid, "veh_select_id")][pVehModel]));
						SendClientMessage(i, COLOR_ORANGE, pDialog[playerid]);
						break;
					}
				}

				format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil menarik kunci "YELLOW"%s\n"WHITE"Dari pemain "ORANGE"%s"WHITE", %s tidak akan dapat mengakses penuh kendaraan anda lagi.", GetVehicleNameFromModel(PVeh[GetPVarInt(playerid, "veh_select_id")][pVehModel]), temp_nama, temp_nama);

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menarik kunci", pDialog[playerid], "Ok", "");
			}
			return 1;
		}
		case DIALOG_PINJAMIN_KUNCI_PLAYERID:
		{
			if(response){
				new target_id;
				if(sscanf(inputtext, "u", target_id)) {
					return ShowPlayerDialog(playerid, DIALOG_PINJAMIN_KUNCI_PLAYERID, DIALOG_STYLE_INPUT, YELLOW"Masukan ID pemain", RED"ID pemain invalid.\n"YELLOW"Silahkan masukan ID Pemain yang akan dipinjamkan kunci kendaraan.\n"WHITE"Hanya dapat meminjamkan kunci kepada pemain yang berada maksimal 2 meter.\n"WHITE"Pastikan player yang anda tuju belum dipinjami kendaraan yang sama.", "Pilih", "Batal");
				}
				if(!IsPlayerConnected(target_id) || target_id == INVALID_PLAYER_ID || target_id == playerid) {
					return ShowPlayerDialog(playerid, DIALOG_PINJAMIN_KUNCI_PLAYERID, DIALOG_STYLE_INPUT, YELLOW"Masukan ID pemain", RED"Pemain dengan id tersebut tidak ada.\n"YELLOW"Silahkan masukan ID Pemain yang akan dipinjamkan kunci kendaraan.\n"WHITE"Hanya dapat meminjamkan kunci kepada pemain yang berada maksimal 2 meter.\n"WHITE"Pastikan player yang anda tuju belum dipinjami kendaraan yang sama.", "Pilih", "Batal");
				}
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				if(!IsPlayerInRangeOfPoint(target_id, 2.0, pos[0], pos[1], pos[2])){
					return ShowPlayerDialog(playerid, DIALOG_PINJAMIN_KUNCI_PLAYERID, DIALOG_STYLE_INPUT, YELLOW"Masukan ID pemain", RED"Pemain harus berada didekat anda.\n"YELLOW"Silahkan masukan ID Pemain yang akan dipinjamkan kunci kendaraan.\n"WHITE"Hanya dapat meminjamkan kunci kepada pemain yang berada maksimal 2 meter.\n"WHITE"Pastikan player yang anda tuju belum dipinjami kendaraan yang sama.", "Pilih", "Batal");
				}

				inline responseQuery(){
					new total;
					cache_get_value_name_int(0, "total", total);
					if(total > 0){
						showDialogPesan(playerid, RED"Pemain sudah menerima kunci", YELLOW"Pemain yang anda tuju telah memiliki kunci kendaraan yang anda pilih.\nSilahkan pilih pemain lain lagi.");
					}else{
						SetPVarInt(playerid, "pinjam_kunci_target", target_id);
						format(pDialog[playerid], sizePDialog, WHITE"Pemain "GREEN"%s "WHITE"akan menerima kunci pinjaman dari anda.\nSilahkan masukan lama waktu peminjaman dalam "ORANGE"satuan menit.\n"YELLOW"Minimal %i menit dan maksimal %i menit (setara dengan %i hari)", PlayerInfo[target_id][pPlayerName], MINIMUM_LAMA_PINJAMKAN_KEY, MAXIMUM_LAMA_PINJAMKAN_KEY, MAXIMUM_LAMA_PINJAMKAN_KEY / 1440);

						ShowPlayerDialog(playerid, DIALOG_PINJAMIN_KUNCI_WAKTU, DIALOG_STYLE_INPUT, YELLOW"Masukan lama waktu", pDialog[playerid], "Pilih", "Batal");
					}
				}

				MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT COUNT(*) as total FROM vehicle_keys WHERE id_user = '%d' AND id_vehicle = '%d' AND UNIX_TIMESTAMP(NOW()) < expired", PlayerInfo[target_id][pID], PVeh[GetPVarInt(playerid, "veh_select_id")][pVehID]);
			}else{
				DeletePVar(playerid, "veh_select_id");		
			}
			return 1;
		}
		case DIALOG_PINJAMIN_KUNCI_WAKTU:
		{
			if(response){
				new lama_waktu, target_id = GetPVarInt(playerid, "pinjam_kunci_target");
				if(!IsPlayerConnected(target_id)){
					return showDialogPesan(playerid, RED"Pemain yang dituju offline", YELLOW"Pemain yang dituju telah offline, tidak dapat melanjutkan.");
				}
				if(sscanf(inputtext, "i", lama_waktu)) {
					format(pDialog[playerid], sizePDialog, RED"Menit yang diinput invalid.\n"WHITE"Pemain "GREEN"%s "WHITE"akan menerima kunci pinjaman dari anda.\nSilahkan masukan lama waktu peminjaman dalam "ORANGE"satuan menit.\n"YELLOW"Minimal %i menit dan maksimal %i menit (setara dengan %i hari)", PlayerInfo[target_id][pPlayerName], MINIMUM_LAMA_PINJAMKAN_KEY, MAXIMUM_LAMA_PINJAMKAN_KEY, MAXIMUM_LAMA_PINJAMKAN_KEY / 1440);

					return ShowPlayerDialog(playerid, DIALOG_PINJAMIN_KUNCI_WAKTU, DIALOG_STYLE_INPUT, YELLOW"Masukan lama waktu", pDialog[playerid], "Pilih", "Batal");
				}
				if(lama_waktu < MINIMUM_LAMA_PINJAMKAN_KEY || lama_waktu > MAXIMUM_LAMA_PINJAMKAN_KEY){
					format(pDialog[playerid], sizePDialog, RED"Menit yang diinput melebihi batas.\n"WHITE"Pemain "GREEN"%s "WHITE"akan menerima kunci pinjaman dari anda.\nSilahkan masukan lama waktu peminjaman dalam "ORANGE"satuan menit.\n"YELLOW"Minimal %i menit dan maksimal %i menit (setara dengan %i hari)", PlayerInfo[target_id][pPlayerName], MINIMUM_LAMA_PINJAMKAN_KEY, MAXIMUM_LAMA_PINJAMKAN_KEY, MAXIMUM_LAMA_PINJAMKAN_KEY / 1440);

					return ShowPlayerDialog(playerid, DIALOG_PINJAMIN_KUNCI_WAKTU, DIALOG_STYLE_INPUT, YELLOW"Masukan lama waktu", pDialog[playerid], "Pilih", "Batal");					
				}

				SetPVarInt(playerid, "pinjam_kunci_waktu", lama_waktu);
				SetPVarInt(playerid, "pinjam_kunci_idpv", GetPVarInt(playerid, "veh_select_id"));

				format(pDialog[playerid], sizePDialog, WHITE"Pemain "GREEN"%s "WHITE"akan menerima kunci pinjaman dari anda.\nDengan lama peminjaman "ORANGE"%i menit.\n"YELLOW"Apakah anda yakin?\n"WHITE"Setelah waktu telah melebihi batas waktu yang telah ditentukan\n"WHITE"maka kunci akan otomatis hilang dari pemain tersebut.", PlayerInfo[target_id][pPlayerName], lama_waktu);
				ShowPlayerDialog(playerid, DIALOG_PINJAMIN_KUNCI_KONFIRMASI, DIALOG_STYLE_MSGBOX, YELLOW"Konfirmasi peminjaman kunci", pDialog[playerid], "Ok", "Batal");
			}
			return 1;
		}
		case DIALOG_PINJAMIN_KUNCI_KONFIRMASI:
		{
			if(response){
				new lama_waktu = GetPVarInt(playerid, "pinjam_kunci_waktu"), target_id = GetPVarInt(playerid, "pinjam_kunci_target"), idpv = GetPVarInt(playerid, "pinjam_kunci_idpv");

				format(pDialog[playerid], sizePDialog, WHITE"Anda akan dipinjamkan kunci kendaraan "GREEN"%s "WHITE"oleh "GREEN"%s\n"WHITE"Dengan lama waktu peminjaman "YELLOW"%i menit.\nApakah anda ingin menyetujuinya?", GetVehicleNameFromModel(PVeh[idpv][pVehModel]), PlayerInfo[playerid][pPlayerName], lama_waktu);

				SetPVarInt(target_id, "pinjam_kunci_dari", playerid);
				ShowPlayerDialog(target_id, DIALOG_PINJAMAN_KUNCI_CONF_TARGET, DIALOG_STYLE_MSGBOX, YELLOW"Peminjaman kunci", pDialog[playerid], "Terima", "Batal");

				showDialogPesan(playerid, GREEN"Berhasil mengirim request", WHITE"Request peminjaman kunci kepada pemain tertuju, berhasil dikirimkan.");
			}
			return 1;
		}
		case DIALOG_PINJAMAN_KUNCI_CONF_TARGET:
		{
			new target_id = GetPVarInt(playerid, "pinjam_kunci_dari");
			if(response){
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				
				if(IsPlayerConnected(target_id) && IsPlayerInRangeOfPoint(target_id, 2.0, pos[0], pos[1], pos[2])){
					format(pDialog[playerid], sizePDialog, "[KUNCI] "WHITE"Pemain %s berhasil menerima kunci dari anda.", PlayerInfo[playerid][pPlayerName]);
					SendClientMessage(target_id, COLOR_ORANGE, pDialog[playerid]);

					format(pDialog[playerid], sizePDialog, "[KUNCI] "WHITE"Anda berhasil menerima kunci dari %s.", PlayerInfo[playerid][pPlayerName]);
					SendClientMessage(playerid, COLOR_ORANGE, pDialog[playerid]);

					ApplyAnimation(target_id, "SHOP", "SHP_Rob_GiveCash", 4.1, 0, 1, 1, 0, 2000, 1);
					ApplyAnimation(playerid, "VENDING", "VEND_Use", 4.1, 0, 1, 1, 0, 2000, 1);

					new lama_waktu = GetPVarInt(target_id, "pinjam_kunci_waktu"), idpv = GetPVarInt(target_id, "pinjam_kunci_idpv");

					PinjamkanKunciKePemain(playerid, idpv, lama_waktu);
				}else{
					format(pDialog[playerid], sizePDialog, "[KUNCI] "WHITE"Pemain %s tidak bisa menerima kunci, karena berada terlalu jauh.", PlayerInfo[playerid][pPlayerName]);
					SendClientMessage(target_id, COLOR_ORANGE, pDialog[playerid]);

					SendClientMessage(playerid, COLOR_ORANGE, "[KUNCI] "WHITE"Anda tidak dapat menerima kunci, karena berada terlalu jauh.");
					return 1;
				}
			}else{
				format(pDialog[playerid], sizePDialog, "[KUNCI] "WHITE"Pemain %s menolak request peminjaman dari anda.", PlayerInfo[playerid][pPlayerName]);
				SendClientMessage(target_id, COLOR_ORANGE, pDialog[playerid]);
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
			}else{
				resetPVarInventory(playerid);
				showDialogMenuInventory(playerid);
			}
			return 1;
		}
		case DIALOG_BELI_SKIN:
		{
			if(response){
				new id_skin = (PlayerInfo[playerid][jenisKelamin] == 0) ? SKIN_MALE_GRATIS[listitem] : SKIN_FEMALE_GRATIS[listitem];

				SetPVarInt(playerid, "skinNormal_idx", id_skin);

				ShowPlayerDialog(playerid, DIALOG_CONFIRM_BELI_SKIN_NORMAL, DIALOG_STYLE_MSGBOX, "Konfirmasi pembelian", WHITE"Anda yakin ingin membeli skin ini?\nSkin normal memiliki harga "GREEN"2500"WHITE".", "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_CONFIRM_BELI_SKIN_NORMAL:
		{
			if(response){
				new id_skin = GetPVarInt(playerid, "skinNormal_idx");
				DeletePVar(playerid, "skinNormal_idx");
				if(getUangPlayer(playerid) < 2500) return dialogMsgUangTdkCukup(playerid);
				givePlayerUang(playerid, -2500);
				tambahSkinPlayer(playerid, id_skin, 1,false);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil ", GREEN"Anda berhasil mendapatkan skin!\n"WHITE"Silahkan buka inventory untuk melihatnya.", "Ok", "");
			}else{
				DeletePVar(playerid, "skinNormal_idx");
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
						if(PlayerInfo[playerid][skinID] == id_skin) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Skin sudah digunakan", WHITE"Anda tidak dapat menggunakan skin yang sedang digunakan,\nAnda harus memilih skin yang berbeda dengan yang anda gunakan skrng.", "Ok", "");
						
						updatePlayerCurrentSkin(playerid, id_skin);

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
				resetPVarInventory(playerid);
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

				new nomor_hp[16] = "62";
				strcat(nomor_hp, inputtext);

				inline responseCekNomorHP(){
					if(!cache_num_rows()){
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET nomor_handphone = '%e' WHERE id = '%d'", nomor_hp, PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid]);

						format(PlayerInfo[playerid][nomorHP], 12, "%s", nomor_hp);

						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mendaftarkan nomor HP", WHITE"Anda "GREEN"berhasil "WHITE"mendaftarkan nomor HP!", "Ok", "");
					}else{
						return ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP anda", RED"Nomor HP telah ada, silahkan input yang lain!\n"WHITE"Masukan nomor HP yang anda inginkan :", "Simpan", "Keluar");
					}
				}
				MySQL_TQueryInline(koneksi, using inline responseCekNomorHP, "SELECT * FROM `user` WHERE nomor_handphone = '%s'", nomor_hp);
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
				new jumlah, item_id, nama_item[256];
				if(sscanf(inputtext, "i", jumlah)) return ShowPlayerDialog(playerid, DIALOG_PILIH_JUMLAH_ITEM, DIALOG_STYLE_INPUT,""WHITE"Jumlah barang", RED"Inputan tidak valid!\n"WHITE"Berapa banyak yang ingin kamu berikan :", "Beri", "Keluar");

				if(!IsPlayerConnected(GetPVarInt(playerid, "inv_target_id"))) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX,""WHITE"Invalid", RED"Player dengan id tertuju sudah meninggalkan server!\n","Ok", "");

				item_id = GetPVarInt(playerid, "inv_indexlist");
				tambahItemPlayer(GetPVarInt(playerid, "inv_target_id"), item_id, jumlah);
				getNamaByIdItem(item_id, nama_item);
				format(pDialog[playerid], sizePDialog, WHITE"Anda "GREEN"mendapatkan "WHITE"item "BLUE"%s "WHITE"dari admin!", nama_item);
				ShowPlayerDialog(GetPVarInt(playerid, "inv_target_id"), DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mendapatkan item", pDialog[playerid], "Ok", "");

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", WHITE"Anda "GREEN"berhasil "WHITE"memberikan item ke player tertuju!", "Ok", "");
				resetPVarInventory(playerid);
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_PILIH_FURNITURE:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					showDialogListFurniturePemain(playerid);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);					
						showDialogListFurniturePemain(playerid);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						showDialogListFurniturePemain(playerid);
					}
					return 1;
				}

				SetPVarInt(playerid, "inv_indexlist", listitem);
				format(pDialog[playerid], sizePDialog, GREEN"Gunakan Furniture\n"WHITE"Beritahu Furniture\nInfo Furniture\n"RED"Buang Furniture");

				ShowPlayerDialog(playerid, DIALOG_OPTION_FURNITURE_INVENTORY, DIALOG_STYLE_LIST, WHITE"Pilih aksi", pDialog[playerid], "Ok", "Keluar");
			}else{
				showDialogMenuInventory(playerid);
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_OPTION_FURNITURE_INVENTORY:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						new id_object, id_furniture;
						cache_set_active(PlayerInfo[playerid][tempCache]);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "id_object", id_object);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "id_furniture", id_furniture);
						cache_delete(PlayerInfo[playerid][tempCache]);
						PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

						if(isPlayerInOwnedHouse(playerid)){
							new Float:pos[3];
							GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
							GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 3.0);

							inline responseQuery(){
								new objectid = CreateDynamicObject(id_object, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

								new data[e_furniture];
								data[fID] = cache_insert_id();
								data[fHouseID] = GetPlayerVirtualWorld(playerid);
								data[fFurnitureID] = id_furniture;
								data[fPosX] = pos[0];
								data[fPosY] = pos[1];
								data[fPosZ] = pos[2];
								data[fRotX] = 0.0;
								data[fRotY] = 0.0;
								data[fRotZ] = 0.0;

								Streamer_SetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);
								EditingObject[playerid] = EDITING_FURNITURE;
								EditDynamicObject(playerid, objectid);

								tambahFurniturePlayer(playerid, id_furniture, -1);
							}
							MySQL_TQueryInline(koneksi, using inline responseQuery, "INSERT INTO house_furniture(id_house, id_furniture, pos_x, pos_y, pos_z) VALUES('%d', '%d', '%f', '%f', '%f')", GetPlayerVirtualWorld(playerid), id_furniture, pos[0], pos[1], pos[2]);
						}else{
							return server_message(playerid, "Anda tidak berada didalam rumah anda sendiri.");
						}
						resetPVarInventory(playerid);
					}
					case 1:
					{
						new modelid, keterangan[100];
						cache_set_active(PlayerInfo[playerid][tempCache]);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "id_object", modelid);
						cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "keterangan", keterangan);
						cache_delete(PlayerInfo[playerid][tempCache]);
						PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

						SetPVarString(playerid, "inv_keterangan", keterangan);
						SetPVarInt(playerid, "inv_model", modelid);

						ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",WHITE"Masukan ID player yang akan kamu tampilkan furniture.","Show","Keluar");
					}
					case 2:
					{
						new modelid, keterangan[100], jumlah;
						cache_set_active(PlayerInfo[playerid][tempCache]);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "id_object", modelid);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "jumlah", jumlah);
						cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "keterangan", keterangan);
						cache_delete(PlayerInfo[playerid][tempCache]);
						PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

						tampilkanTextDrawShowItem(playerid, modelid, jumlah, keterangan, PlayerInfo[playerid][pPlayerName]);

						resetPVarInventory(playerid);
					}
					case 3: // Buang item
					{
						new jumlah, nama_furniture[50];
						cache_set_active(PlayerInfo[playerid][tempCache]);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "jumlah", jumlah);
						cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "nama_furniture", nama_furniture);
						cache_unset_active();

						format(pDialog[playerid], sizePDialog, WHITE"Silahkan masukan jumlah furniture yang ingin dibuang.\n\nNama Furniture : "PINK"%s\n"WHITE"Jumlah Item : "GREEN"%d", nama_furniture, jumlah);
						strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang furniture,\n"RED"Furniture yang telah dibuang tidak dapat dikembalikan lagi.");
						ShowPlayerDialog(playerid, DIALOG_BUANG_FURNITURE, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dibuang", pDialog[playerid], RED"Buang", "Batal");
					}
				}
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_PILIH_ITEM:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					showDialogListItem(playerid);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);					
						showDialogListItem(playerid);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						showDialogListItem(playerid);
					}
					return 1;
				}

				// mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT jumlah FROM `user_item` WHERE id_user = '%d' AND id_item = '%d'", PlayerInfo[playerid][pID], strval(inputtext));
				// mysql_tquery(koneksi, pQuery[playerid], "cekJumlahItem", "ii", playerid, strval(inputtext));

				SetPVarInt(playerid, "inv_indexlist", listitem);
				cache_set_active(PlayerInfo[playerid][tempCache]);
				new temp_kunci;
				cache_get_value_name_int(listitem, "kunci", temp_kunci);
				cache_unset_active();

				if(temp_kunci)
					format(pDialog[playerid], sizePDialog, GREEN"Pakai Item\n"WHITE"Beritahu Item\nInfo Item\n"GREEN"Buka Item "RED"(sedang terkunci)\n"RED"Buang Item");
				else
					format(pDialog[playerid], sizePDialog, GREEN"Pakai Item\n"WHITE"Beritahu Item\nInfo Item\n"RED"Kunci Item "GREEN"(sedang terbuka)\n"RED"Buang Item");

				ShowPlayerDialog(playerid, DIALOG_OPTION_ITEM_INVENTORY, DIALOG_STYLE_LIST, WHITE"Pilih aksi", pDialog[playerid], "Ok", "Keluar");
			}else{
				showDialogMenuInventory(playerid);
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
						new id_item, fungsi[50];
						cache_set_active(PlayerInfo[playerid][tempCache]);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "id_item", id_item);

						new bool:is_null;
						cache_is_value_name_null(GetPVarInt(playerid, "inv_indexlist"), "fungsi", is_null);
						if(is_null) format(fungsi, 50, "itemTidakDapatDipakai");
						else cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "fungsi", fungsi);

						cache_delete(PlayerInfo[playerid][tempCache]);
						PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

						CallRemoteFunction(fungsi, "ii", playerid, id_item);
						resetPVarInventory(playerid);
					}
					case 1:
					{
						new modelid, keterangan[100];
						cache_set_active(PlayerInfo[playerid][tempCache]);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "model_id", modelid);
						cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "keterangan", keterangan);
						cache_delete(PlayerInfo[playerid][tempCache]);
						PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

						SetPVarString(playerid, "inv_keterangan", keterangan);
						SetPVarInt(playerid, "inv_model", modelid);

						ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");
					}
					case 2:
					{
						new modelid, keterangan[100], jumlah;
						cache_set_active(PlayerInfo[playerid][tempCache]);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "model_id", modelid);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "jumlah", jumlah);
						cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "keterangan", keterangan);
						cache_delete(PlayerInfo[playerid][tempCache]);
						PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

						tampilkanTextDrawShowItem(playerid, modelid, jumlah, keterangan, PlayerInfo[playerid][pPlayerName]);

						resetPVarInventory(playerid);
					}
					case 3: // Kunci/Buka Kunci
					{
						new id_item, temp_kunci;
						cache_set_active(PlayerInfo[playerid][tempCache]);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "id_item", id_item);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "kunci", temp_kunci);
						cache_delete(PlayerInfo[playerid][tempCache]);
						PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;
						
						updateStatusKunciItem(playerid, id_item, (temp_kunci + 1) % 2);

						if(temp_kunci == 0){ // Jika sebelumnya terbuka berarti sekarang terkunci
							format(pDialog[playerid], sizePDialog, WHITE"Barang anda kini "RED"terkunci.\n"YELLOW"Note : Penguncian barang berguna untuk menghindari barang anda dari pembuangan item tanpa disengaja.\n");
							strcat(pDialog[playerid], "Terkadang kita tidak menyadari bahwa kita tidak sengaja menekan hal tersebut\nsehingga terbuang dan juga menghindari penjualan dan pemberian barang tanpa disengaja.\n"WHITE"Untuk dapat melakukan hal yang tersebut silahkan "GREEN"buka "WHITE"kembali item anda.");
							ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil "WHITE"mengubah status kunci barang", pDialog[playerid], "Ok", "");
						}else{ // Sebaliknya
							format(pDialog[playerid], sizePDialog, WHITE"Barang anda kini "GREEN"terbuka.\n"YELLOW"Note : Penguncian barang berguna untuk menghindari barang anda dari pembuangan item tanpa disengaja.\n");
							strcat(pDialog[playerid], "Terkadang kita tidak menyadari bahwa kita tidak sengaja menekan hal tersebut\nsehingga terbuang dan juga menghindari penjualan dan pemberian barang tanpa disengaja.\n"WHITE"Untuk dapat menghindari hal yang tersebut silahkan "RED"kunci "WHITE"kembali item anda.");
							ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil "WHITE"mengubah status kunci barang", pDialog[playerid], "Ok", "");
						}
						resetPVarInventory(playerid);
					}
					case 4: // Buang item
					{
						new jumlah, nama_item[50], temp_kunci;
						cache_set_active(PlayerInfo[playerid][tempCache]);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "jumlah", jumlah);
						cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "nama_item", nama_item);
						cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "kunci", temp_kunci);
						cache_unset_active();

						if(temp_kunci){
							// Selalu hapus cache setelah dipakai (tidak perlu di unset_active kalau mau langsung di hapus)
							cache_delete(PlayerInfo[playerid][tempCache]);
							PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE; // Selalu set jadi invalid_cache saat sudah di hapus kalau gak nanti ga ke deteksi bahwa udah di hapus

							resetPVarInventory(playerid);

							ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, ORANGE"Item tidak dapat dibuang", WHITE"Item ini "RED"dikunci.\n\n"YELLOW"Note : Item yang dikunci tidak dapat dibuang/dijual/diberi kepada orang lain.\nJika tetap ingin melakukan hal tersebut silahkan buka item terlebih dahulu.", "Ok", "");
							return 1;
						}

						format(pDialog[playerid], sizePDialog, WHITE"Silahkan masukan jumlah item yang ingin dibuang.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item : "GREEN"%d", nama_item, jumlah);
						strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang item,\n"RED"item yang telah dibuang tidak dapat dikembalikan lagi.");
						ShowPlayerDialog(playerid, DIALOG_BUANG_ITEM, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dibuang", pDialog[playerid], RED"Buang", "Batal");
					}
				}
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_BUANG_FURNITURE:
		{
			if(response){
				new jumlah, nama_furniture[50], input_jumlah, furniture_id;
				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "jumlah", jumlah);
				cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "id_furniture", furniture_id);
				cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "nama_furniture", nama_furniture);
				if(sscanf(inputtext, "i", input_jumlah)) {
					cache_unset_active(); // Unset_active agar tidak terjadi hal yang tidak diinginkan

					format(pDialog[playerid], sizePDialog, RED"Masukan inputan yang benar.\n"WHITE"Silahkan masukan jumlah furniture yang ingin dibuang.\n\nNama Furniture : "PINK"%s\n"WHITE"Jumlah Furniture : "GREEN"%d", nama_furniture, jumlah);
					strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang furniture,\n"RED"Furniture yang telah dibuang tidak dapat dikembalikan lagi.");
					return ShowPlayerDialog(playerid, DIALOG_BUANG_FURNITURE, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dibuang", pDialog[playerid], RED"Buang", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > jumlah){
					cache_unset_active(); // Unset_active agar tidak terjadi hal yang tidak diinginkan

					format(pDialog[playerid], sizePDialog, RED"Jumlah yang ingin anda buang salah.\n"WHITE"Silahkan masukan jumlah furniture yang ingin dibuang.\n\nNama Furniture : "PINK"%s\n"WHITE"Jumlah Furniture : "GREEN"%d", nama_furniture, jumlah);
					strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang furniture,\n"RED"Furniture yang telah dibuang tidak dapat dikembalikan lagi.");
					return ShowPlayerDialog(playerid, DIALOG_BUANG_FURNITURE, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dibuang", pDialog[playerid], RED"Buang", "Batal");
				}
				
				// Buang furniture player (beri player dalam jumlah minus)
				tambahFurniturePlayer(playerid, furniture_id, -input_jumlah);

				format(pDialog[playerid], sizePDialog, GREEN"Berhasil membuang Furniture.\n\nNama Furniture : "PINK"%s\n"WHITE"Jumlah yang dibuang : "RED"%d", nama_furniture, input_jumlah);
				strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang furniture,\n"RED"Furniture yang telah dibuang tidak dapat dikembalikan lagi.");
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membuang furniture", pDialog[playerid], "Ok", "");
				
				// Selalu hapus cache setelah dipakai (tidak perlu di unset_active kalau mau langsung di hapus)
				cache_delete(PlayerInfo[playerid][tempCache]);
				PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE; // Selalu set jadi invalid_cache saat sudah di hapus kalau gak nanti ga ke deteksi bahwa udah di hapus

				resetPVarInventory(playerid);
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_BUANG_ITEM:
		{
			if(response){
				new jumlah, nama_item[50], input_jumlah, item_id;
				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "jumlah", jumlah);
				cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "id_item", item_id);
				cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "nama_item", nama_item);
				if(sscanf(inputtext, "i", input_jumlah)) {
					cache_unset_active(); // Unset_active agar tidak terjadi hal yang tidak diinginkan

					format(pDialog[playerid], sizePDialog, RED"Masukan inputan yang benar.\n"WHITE"Silahkan masukan jumlah item yang ingin dibuang.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item : "GREEN"%d", nama_item, jumlah);
					strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang item,\n"RED"item yang telah dibuang tidak dapat dikembalikan lagi.");
					return ShowPlayerDialog(playerid, DIALOG_BUANG_ITEM, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dibuang", pDialog[playerid], RED"Buang", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > jumlah){
					cache_unset_active(); // Unset_active agar tidak terjadi hal yang tidak diinginkan

					format(pDialog[playerid], sizePDialog, RED"Jumlah yang ingin anda buang salah.\n"WHITE"Silahkan masukan jumlah item yang ingin dibuang.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item : "GREEN"%d", nama_item, jumlah);
					strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang item,\n"RED"item yang telah dibuang tidak dapat dikembalikan lagi.");
					return ShowPlayerDialog(playerid, DIALOG_BUANG_ITEM, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dibuang", pDialog[playerid], RED"Buang", "Batal");
				}
				
				// Buang item player (beri player dalam jumlah minus)
				tambahItemPlayer(playerid, item_id, -input_jumlah);

				format(pDialog[playerid], sizePDialog, GREEN"Berhasil membuang item.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah yng dibuang : "RED"%d", nama_item, input_jumlah);
				strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang item,\n"RED"item yang telah dibuang tidak dapat dikembalikan lagi.");
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membuang item", pDialog[playerid], "Ok", "");
				
				// Selalu hapus cache setelah dipakai (tidak perlu di unset_active kalau mau langsung di hapus)
				cache_delete(PlayerInfo[playerid][tempCache]);
				PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE; // Selalu set jadi invalid_cache saat sudah di hapus kalau gak nanti ga ke deteksi bahwa udah di hapus

				resetPVarInventory(playerid);
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_MENU_EPHONE:
		{
			if(response){
				switch(listitem){
					// Kirim Pesan
					case 0:
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT COUNT(*) AS banyak_pesan FROM `sms` WHERE `id_user_pengirim` = '%d' AND `id_pemilik_pesan` = '%d'", PlayerInfo[playerid][pID], PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid], "cekPesanTerkirim", "d", playerid);
						return 1;
					}
					// Kotak Masuk
					case 1:
					{
						SetPVarInt(playerid, "halaman", 0);
						tampilkanKotakMasuk(playerid);
					}
					// Kotak Terkirim
					case 2:
					{
						SetPVarInt(playerid, "halaman", 0);
						tampilkanKotakTerkirim(playerid);
					}
					case 3:
					{
						if(isnull(PlayerInfo[playerid][nomorRekening])) return showDialogPesan(playerid, RED"Anda tidak memiliki ATM", WHITE"Untuk dapat mengakses ATM Banking, anda harus mempunyai rekening bank terlebih dahulu.\n"YELLOW"Anda dapat pergi ke bank untuk mengurusnya.");

						showDialogEBank(playerid);
					}
					case 4: // Sharelock
					{
						return ShowPlayerDialog(playerid, DIALOG_SHARELOCK_HP, DIALOG_STYLE_INPUT, "Sharelock", WHITE"Silahkan masukan "GREEN"ID Pemain "WHITE"yang ingin anda bagikan lokasi anda.\n"ORANGE"Note : Pastikan pemain yang anda ingin bagikan memiliki HP yang terpakai (minimal ePhone 3)\n** Pada saat anda membagikan lokasi anda, pemain tersebut "GREEN" dapat melihat anda di peta mereka.", "Pilih", "Batal");
					}
					default:
						return 1;
				}
			}
			return 1;
		}
		case DIALOG_SHARELOCK_HP:
		{
			if(response){
				new target_id;
				if(sscanf(inputtext, "u", target_id)) return ShowPlayerDialog(playerid, DIALOG_SHARELOCK_HP, DIALOG_STYLE_INPUT, "Sharelock", RED"Anda harus memasukan inputan dengan benar.\n"WHITE"Silahkan masukan "GREEN"ID Pemain "WHITE"yang ingin anda bagikan lokasi anda.\n"ORANGE"Note : Pastikan pemain yang anda ingin bagikan memiliki HP yang terpakai (minimal ePhone 3)\n** Pada saat anda membagikan lokasi anda, pemain tersebut "GREEN" dapat melihat anda di peta mereka.", "Pilih", "Batal");

				if(target_id == INVALID_PLAYER_ID || !IsPlayerConnected(target_id) || !PlayerInfo[target_id][sudahLogin] || target_id == playerid) return ShowPlayerDialog(playerid, DIALOG_SHARELOCK_HP, DIALOG_STYLE_INPUT, "Sharelock", RED"Pemain yang anda tuju tidak tersedia.\n"WHITE"Silahkan masukan "GREEN"ID Pemain "WHITE"yang ingin anda bagikan lokasi anda.\n"ORANGE"Note : Pastikan pemain yang anda ingin bagikan memiliki HP yang terpakai (minimal ePhone 3)\n** Pada saat anda membagikan lokasi anda, pemain tersebut "GREEN" dapat melihat anda di peta mereka.", "Pilih", "Batal");

				// Apakah perlu dicounter bahwa si player yang dituju harus memiliki minimal ePhone 3 ?
				if(!PlayerInfo[target_id][ePhone]) return ShowPlayerDialog(playerid, DIALOG_SHARELOCK_HP, DIALOG_STYLE_INPUT, "Sharelock", RED"Pemain yang anda tuju tidak memiliki HP yang sedang terpakai.\n"WHITE"Silahkan masukan "GREEN"ID Pemain "WHITE"yang ingin anda bagikan lokasi anda.\n"ORANGE"Note : Pastikan pemain yang anda ingin bagikan memiliki HP yang terpakai (minimal ePhone 3)\n** Pada saat anda membagikan lokasi anda, pemain tersebut "GREEN" dapat melihat anda di peta mereka.", "Pilih", "Batal");

				sendPesan(playerid, COLOR_ORANGE, "[SHARELOCK] "WHITE"Berhasil mengirimkan request ke pada "GREEN"%s"WHITE".", PlayerInfo[target_id][pPlayerName]);
				sendPesan(playerid, COLOR_WHITE, "Anda akan dapat informasi jika "GREEN"%s "WHITE"menyetujui sharelock anda.", PlayerInfo[target_id][pPlayerName]);

				format(pDialog[playerid], sizePDialog, GREEN"%s "WHITE"ingin membagikan lokasinya kepada anda. Apakah anda ingin menerimanya?\n"YELLOW"Menerima sharelock dari orang lain akan menghilangkan marker merah anda yang sedang aktif, marker merah tersebut akan digantikan dengan marker merah yang baru\nyang mengarah kepada lokasi "GREEN"%s "YELLOW"sekarang berada.", PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][pPlayerName]);
				ShowPlayerDialog(target_id, DIALOG_KONFIRMASI_TERIMA_SHARELOCK, DIALOG_STYLE_MSGBOX, "Konfirmasi Sharelock", pDialog[playerid], GREEN"Terima", RED"Tidak");

				SetPVarInt(target_id, "sharelock_pemilik", playerid);
			}else
				cmd_ephone(playerid, "");
			return 1;
		}
		case DIALOG_KONFIRMASI_TERIMA_SHARELOCK:
		{
			new dari_id = GetPVarInt(playerid, "sharelock_pemilik"), string[256];
			DeletePVar(playerid, "sharelock_pemilik");
			if(!IsPlayerConnected(dari_id)) return SendClientMessage(playerid, COLOR_ORANGE, "[SHARELOCK] "WHITE"Pemain yang ingin membagikan lokasinya telah terputus dari server.");
			if(response){
				new Float:pos[3];
				GetPlayerPos(dari_id, pos[0], pos[1], pos[2]);
				SetPlayerCheckpoint(playerid, pos[0], pos[1], pos[2], 5.0);
				PlayerInfo[playerid][activeMarker] = true;

				format(string, 256, "[SHARELOCK] "BLUE"%s "WHITE"telah "GREEN"menerima "WHITE"sharelock yang ingin anda berikan. "YELLOW"Lokasi anda sekarang berhasil dibagikan.", PlayerInfo[playerid][pPlayerName]);
				SendClientMessage(dari_id, COLOR_ORANGE, string);

				format(string, 256, "[SHARELOCK] "WHITE"Lokasi "BLUE"%s "WHITE"telah ditampilkan pada map anda. "YELLOW"Silahkan ikuti marker merah yang telah tampil.", PlayerInfo[dari_id][pPlayerName]);
				SendClientMessage(playerid, COLOR_ORANGE, string);
			}else{
				format(string, 256, "[SHARELOCK] "BLUE"%s "WHITE"telah "RED"menolak "WHITE"sharelock yang ingin anda berikan.", PlayerInfo[playerid][pPlayerName]);
				SendClientMessage(dari_id, COLOR_ORANGE, string);
			}
			return 1;
		}
		case DIALOG_E_BANKING_MENU:
		{
			if(response){
				switch(listitem){
					case 0: // Info Saldo
					{
						inline responseDialog(){
							new saldo;
							if(cache_num_rows()){
								cache_get_value_name_int(0, "saldo", saldo);
								format(pDialog[playerid], sizePDialog, WHITE"Informasi saldo anda dan Rekening anda:\n\nNama : %s\nRekening : %s\nSaldo : %d\n\nInformasi saldo dapat berubah sewaktu-waktu sesuai dengan transaksi yang terjadi setiap saatnya.\nTerimakasih telah menggunakan Layanan dari kami.", PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][nomorRekening], saldo);
								ShowPlayerDialog(playerid, DIALOG_INFO_SALDO_HISTORY_EBANK, DIALOG_STYLE_MSGBOX, "Informasi saldo dan Akun Bank", pDialog[playerid], "Kembali", "Tutup");
							}
							else
								printf("[ERROR] #03 Error fungsi tampil saldo (%d)%s - ID user(%d)", playerid, PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][pID]);
						}

						MySQL_TQueryInline(koneksi, using inline responseDialog, "SELECT IFNULL(SUM(nominal), 0) as saldo FROM `trans_atm` WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
						return 1;
					}
					case 1: // Transfer Uang
					{
						ShowPlayerDialog(playerid, DIALOG_INPUT_REKENING_TUJUAN, DIALOG_STYLE_INPUT, "Nomor rekening tujuan", "Silahkan masukan nomor rekening tujuan:\nNomor rekening harus terdiri dari 8 digit.\nPastikan anda memasukan rekening yang benar.", "Ok", "Batal");
						return 1;
					}
					case 2: // History
					{
						SetPVarInt(playerid, "halaman", 0);
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
						mysql_tquery(koneksi, pQuery[playerid], "historyATMPemain_EBank", "i", playerid);
						return 1;
					}
				}
			}else
				showDialogEPhone(playerid);
			return 1;
		}
		case DIALOG_INFO_HISTORY_EBANK:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
					mysql_tquery(koneksi, pQuery[playerid], "historyATMPemain_EBank", "i", playerid);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
						
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
						mysql_tquery(koneksi, pQuery[playerid], "historyATMPemain_EBank", "i", playerid);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
						mysql_tquery(koneksi, pQuery[playerid], "historyATMPemain_EBank", "i", playerid);
					}
					return 1;
				}

				showDialogEBank(playerid);
			}
			return 1;
		}		
		case DIALOG_INFO_SALDO_HISTORY_EBANK:
		{
			if(response){
				showDialogEBank(playerid);
			}			
			return 1;
		}
		case DIALOG_SMS_MASUKAN_NOMOR:
		{
			if(response){
				if(strlen(inputtext) == 6 && inputtext[0] == '6' && inputtext[1] == '2'){
					if(strcmp(inputtext, PlayerInfo[playerid][nomorHP]) == 0) return ShowPlayerDialog(playerid, DIALOG_SMS_MASUKAN_NOMOR, DIALOG_STYLE_INPUT, WHITE"Nomor HP penerima", RED"Tidak dapat memasukan nomor HP sendiri!\n"YELLOW"Pastikan nomor HP terdiri dari 6 angka dan diawali dengan 62.\n\n"WHITE"Masukan nomor HP penerima dengan lengkap :", "Ok", "Batal");

					mysql_format(koneksi, pQuery[playerid], sizePQuery, "select a.id, COUNT(b.pesan) AS banyak_pesan from `user` a left join sms b on b.id_user_penerima = a.id WHERE a.nomor_handphone = '%e' GROUP BY a.id", inputtext);		
					mysql_tquery(koneksi, pQuery[playerid], "cekNomorPenerima", "d", playerid);
				}else{
					ShowPlayerDialog(playerid, DIALOG_SMS_MASUKAN_NOMOR, DIALOG_STYLE_INPUT, WHITE"Nomor HP penerima", RED"Nomor HP yang anda masukan invalid!\n"YELLOW"Pastikan nomor HP terdiri dari 6 angka dan diawali dengan 62.\n\n"WHITE"Masukan nomor HP penerima dengan lengkap :", "Ok", "Batal");
				}
			}
			return 1;
		}
		case DIALOG_SMS_MASUKAN_PESAN:
		{
			if(response){
				if(isnull(inputtext)){
					ShowPlayerDialog(playerid, DIALOG_SMS_MASUKAN_PESAN, DIALOG_STYLE_INPUT, WHITE"Pesan yang akan dikirim", RED"Pesan tidak boleh kosong!\n"WHITE"Masukan pesan yang ingin anda kirimkan :", "Ok", "Batal");
				}else{
					new id_user_penerima = GetPVarInt(playerid, "sms_id_penerima");
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO `sms`(id_user_pengirim, id_user_penerima, pesan, tanggal_dikirim, id_pemilik_pesan) VALUES('%d', '%d', '%e', NOW(), '%d'), ('%d', '%d', '%e', NOW(), '%d')", PlayerInfo[playerid][pID], id_user_penerima, inputtext, PlayerInfo[playerid][pID], PlayerInfo[playerid][pID], id_user_penerima, inputtext, id_user_penerima);
					mysql_tquery(koneksi, pQuery[playerid]);

					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mengirimkan SMS", GREEN"Anda berhasil mengirimkan SMS!\n"WHITE"Silahkan buka "YELLOW"kotak terkirim "WHITE"untuk melihat kembali SMS yang anda kirim.", "Ok", "");

					// Notifikasi SMS
					foreach(new i : Player){
						if(PlayerInfo[i][pID] == id_user_penerima){
							format(msg, sizeof(msg), ORANGE"[SMS] "WHITE"Pesan baru masuk dari nomor "BLUE"+%s "WHITE"silahkan cek pada kotak masuk anda.", PlayerInfo[playerid][nomorHP]);
							SendClientMessage(i, -1, msg);
							break;
						}
					}
					DeletePVar(playerid, "sms_id_penerima");
				}
			}else{
				DeletePVar(playerid, "sms_id_penerima");
			}
			return 1;
		}
		case DIALOG_KOTAK_TERKIRIM:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					tampilkanKotakTerkirim(playerid);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);					
						tampilkanKotakTerkirim(playerid);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						tampilkanKotakTerkirim(playerid);						
					}
					return 1;
				}

				SetPVarInt(playerid, "sms_id_list_pesan", listitem);
				SetPVarInt(playerid, "sms_id_pesan", strval(inputtext));
				ShowPlayerDialog(playerid, DIALOG_OPSI_KOTAK_TERKIRIM, DIALOG_STYLE_LIST, "Opsi kotak terkirim :","Baca Pesan\nHapus Pesan", "Pilih", "Keluar");
			}else{
				cache_delete(PlayerInfo[playerid][kotakPesan]);
				PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
			}
			return 1;
		}
		case DIALOG_OPSI_KOTAK_TERKIRIM:
		{
			if(response){
				new id_listpesan = GetPVarInt(playerid, "sms_id_list_pesan"), id_pesan = GetPVarInt(playerid, "sms_id_pesan");
				switch(listitem){
					case 0:
					{
						new string[1000], nomor_penerima[16], pesan[500];
						cache_set_active(PlayerInfo[playerid][kotakPesan]);

						cache_get_value_name(id_listpesan, "pesan", pesan);
						cache_get_value_name(id_listpesan, "nomor_handphone", nomor_penerima);

						format(string, sizeof(string), WHITE"Penerima : "YELLOW"%s"WHITE"\n\nPesan : \n%s", nomor_penerima, pesan);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Pesan terkirim", string, "Tutup", "");

						DeletePVar(playerid, "sms_list_pesan");
						DeletePVar(playerid, "sms_id_pesan");
						cache_delete(PlayerInfo[playerid][kotakPesan]);
						PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
					}
					case 1:
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `sms` WHERE `id_sms` = '%d' AND `id_user_pengirim` = '%d' AND `id_pemilik_pesan` = '%d'", id_pesan, PlayerInfo[playerid][pID], PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid]);

						SendClientMessage(playerid, COLOR_GREEN, "[SMS] "YELLOW"Pesan pada kotak terkirim berhasil dihapus!");

						DeletePVar(playerid, "sms_list_pesan");
						DeletePVar(playerid, "sms_id_pesan");
						cache_delete(PlayerInfo[playerid][kotakPesan]);
						PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;	

						tampilkanKotakTerkirim(playerid);		
					}
				}
			}else{
				DeletePVar(playerid, "sms_list_pesan");
				DeletePVar(playerid, "sms_id_pesan");
				cache_delete(PlayerInfo[playerid][kotakPesan]);
				PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
			}
			return 1;
		}
		case DIALOG_KOTAK_MASUK:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					tampilkanKotakMasuk(playerid);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);					
						tampilkanKotakMasuk(playerid);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						tampilkanKotakMasuk(playerid);						
					}
					return 1;
				}

				SetPVarInt(playerid, "sms_id_list_pesan", listitem);
				SetPVarInt(playerid, "sms_id_pesan", strval(inputtext));
				ShowPlayerDialog(playerid, DIALOG_OPSI_KOTAK_MASUK, DIALOG_STYLE_LIST, "Opsi kotak masuk :","Baca Pesan\nHapus Pesan", "Pilih", "Keluar");
			}else{
				cache_delete(PlayerInfo[playerid][kotakPesan]);
				PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
			}
			return 1;
		}
		case DIALOG_OPSI_KOTAK_MASUK:
		{
			if(response){
				new id_listpesan = GetPVarInt(playerid, "sms_id_list_pesan"), id_pesan = GetPVarInt(playerid, "sms_id_pesan");
				switch(listitem){
					case 0:
					{
						new string[1000], nomor_penerima[16], pesan[500];
						cache_set_active(PlayerInfo[playerid][kotakPesan]);

						cache_get_value_name(id_listpesan, "pesan", pesan);
						cache_get_value_name(id_listpesan, "nomor_handphone", nomor_penerima);

						format(string, sizeof(string), WHITE"Pengirim : "YELLOW"%s"WHITE"\n\nPesan : \n%s", nomor_penerima, pesan);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Pesan masuk", string, "Tutup", "");

						DeletePVar(playerid, "sms_list_pesan");
						DeletePVar(playerid, "sms_id_pesan");
						cache_delete(PlayerInfo[playerid][kotakPesan]);
						PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
					}
					case 1:
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `sms` WHERE `id_sms` = '%d' AND `id_user_penerima` = '%d' AND `id_pemilik_pesan` = '%d'", id_pesan, PlayerInfo[playerid][pID], PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid]);

						SendClientMessage(playerid, COLOR_GREEN, "[SMS] "YELLOW"Pesan pada kotak masuk berhasil dihapus!");

						DeletePVar(playerid, "sms_list_pesan");
						DeletePVar(playerid, "sms_id_pesan");
						cache_delete(PlayerInfo[playerid][kotakPesan]);
						PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;	

						tampilkanKotakMasuk(playerid);	
					}
				}
			}else{
				DeletePVar(playerid, "sms_list_pesan");
				DeletePVar(playerid, "sms_id_pesan");
				cache_delete(PlayerInfo[playerid][kotakPesan]);
				PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
			}
			return 1;
		}
		case DIALOG_ADMIN_RUMAH:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						format(pDialog[playerid], sizePDialog, WHITE"Silahkan input Level Rumah yang ingin dibuat [1-%i].", MAX_HOUSES_LEVEL);
						ShowPlayerDialog(playerid, DIALOG_LEVEL_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", pDialog[playerid], "Lanjut", "Batal");
					}
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_RESET_RUMAH, DIALOG_STYLE_INPUT, "Reset Rumah", WHITE"Apakah anda yakin ingin mereset semua rumah?\nKetik "GREEN"RESET"WHITE" jika setuju.", "Lanjut", "Batal");
					}
					case 2:
					{
						ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH, DIALOG_STYLE_LIST, WHITE"Hapus Rumah", "Hapus ID Rumah\nHapus Semua Rumah", "Pilih", "Batal");
					}
				}
			}
			return 1;
		}
		case DIALOG_LEVEL_RUMAH:
		{
			if(response){
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LEVEL_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Level tidak boleh kosong!\n"WHITE"Anda harus menginput level berupa angka.", "Lanjut", "Batal");

				if(!isnumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LEVEL_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Level tidak valid!\n"WHITE"Anda harus menginput level berupa angka.", "Lanjut", "Batal");

				if(strval(inputtext) >= 1 && strval(inputtext) <= MAX_HOUSES_LEVEL){
					new level_rumah = strval(inputtext);
					SetPVarInt(playerid, "level_rumah", level_rumah);
					ShowPlayerDialog(playerid, DIALOG_HARGA_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", WHITE"Silahkan input harga rumah yang ingin dibuat.", "Lanjut", "Batal");
				}else{
					format(pDialog[playerid], sizePDialog, RED"Level tidak valid!\n"WHITE"Anda harus menginput level minimal 1 dan maksimal %d.\n", MAX_HOUSES_LEVEL);
					ShowPlayerDialog(playerid, DIALOG_LEVEL_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", pDialog[playerid], "Lanjut", "Batal");
				}
			}
			return 1;
		}
		case DIALOG_HARGA_RUMAH:
		{
			if(response){
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_HARGA_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Harga tidak boleh kosong!\n"WHITE"Anda harus menginput harga berupa angka.", "Lanjut", "Batal");

				if(!isnumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_HARGA_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Harga tidak valid!\n"WHITE"Anda harus menginput harga berupa angka.", "Lanjut", "Batal");

				if(strval(inputtext) <= 1) return ShowPlayerDialog(playerid, DIALOG_HARGA_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Harga tidak valid!\n"WHITE"Anda harus menginput harga lebih dari 1.", "Lanjut", "Batal");

				new Cache:result, Float:me_x, Float:me_y, Float:me_z;
				new level_rumah = GetPVarInt(playerid, "level_rumah");
				GetPlayerPos(playerid, me_x, me_y, me_z);

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO `house` (level, harga, icon_x, icon_y, icon_z) VALUES ('%d', '%d', '%f', '%f', '%f')", level_rumah, strval(inputtext), me_x, me_y, me_z);
				result = mysql_query(koneksi, pQuery[playerid]);
				new id = cache_insert_id();

				createHouse(id, -1, level_rumah, strval(inputtext), 0, 1, 1, me_x, me_y, me_z);
				SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil membuat rumah!");
			    
			    DeletePVar(playerid, "level_rumah");
			    cache_delete(result);
			}else{
				DeletePVar(playerid, "level_rumah");
			}
			return 1;
		}
		case DIALOG_RESET_RUMAH:
		{
			if(response){
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_RESET_RUMAH, DIALOG_STYLE_INPUT, "Reset Rumah", RED"Input tidak boleh kosong!\n"WHITE"Silahkan ketik "GREEN"RESET"WHITE" untuk setuju.", "Lanjut", "Batal");

				if(!sama("RESET", inputtext)) return ShowPlayerDialog(playerid, DIALOG_RESET_RUMAH, DIALOG_STYLE_INPUT, "Reset Rumah", RED"Input tidak valid!\n"WHITE"Anda harus mengetik "GREEN"RESET"WHITE" untuk setuju.", "Lanjut", "Batal");
				
				for(new i = 0; i < MAX_HOUSES; i++){
					if(housePickup[i] != -1){
						new ownerName[256], beliRate = getHousePrice(i, "beli");
						format(ownerName, 256, "%s", getOwnerHouse(houseInfo[i][hOwner]));
						new ownerId = GetPlayerIdFromName(ownerName);
						if(ownerId != INVALID_PLAYER_ID){
							givePlayerUang(ownerId, beliRate);
						}else{
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, houseInfo[i][hOwner]);
		   			 		mysql_tquery(koneksi, pQuery[playerid]);
						}

						DestroyDynamicPickup(housePickup[i]);
						DestroyDynamic3DTextLabel(houseTextInfo[i]);
						houseInfo[i][hID] = -1;
						houseInfo[i][hOwner] = -1;
						houseInfo[i][hLevel] = 1;
						houseInfo[i][hKunci] = 1;
						houseInfo[i][hJual] = 0;
						houseId[housePickup[i]] = -1;
						housePickup[i] = -1;
					}
				}

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `id_user` = -1, `level` = 1, `kunci` = 1, `jual` = 1");
				mysql_query(koneksi, pQuery[playerid]);
				mysql_query(koneksi, "UPDATE `user` SET `save_house` = 0");

				loadAllHouse();

				SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil mereset semua rumah!");
			}
			return 1;
		}
		case DIALOG_HAPUS_RUMAH:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ID, DIALOG_STYLE_INPUT, "Hapus Rumah", WHITE"Silahkan input ID rumah yang ingin dihapus.", "Lanjut", "Batal");
					}
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ALL, DIALOG_STYLE_INPUT, "Hapus Rumah", WHITE"Apakah anda yakin ingin menghapus semua rumah? Ketik "GREEN"HAPUS"WHITE" untuk setuju.", "Lanjut", "Batal");
					}
				}
			}
			return 1;
		}
		case DIALOG_HAPUS_RUMAH_ID:
		{
			if(response){
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ID, DIALOG_STYLE_INPUT, "Hapus Rumah", RED"ID tidak boleh kosong!\n"WHITE"Silahkan input ID berupa angka.", "Lanjut", "Batal");

				if(!isnumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ID, DIALOG_STYLE_INPUT, "Hapus Rumah", RED"ID tidak valid!\n"WHITE"Anda harus menginput ID berupa angka.", "Lanjut", "Batal");

				new Cache:result, pmsg[256], userId, id = strval(inputtext);
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `house` WHERE `id_house` = '%d'", id);
				result = mysql_query(koneksi, pQuery[playerid]);
				if(cache_num_rows()){
				 	new beliRate = getHousePrice(id, "beli");
					cache_get_value_name_int(0, "id_user", userId);
					
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, userId);
					mysql_query(koneksi, pQuery[playerid]);
					
					if(houseInfo[id][hOwner] != -1){
						new ownerName[256];
						format(ownerName, 256, "%s", getOwnerHouse(houseInfo[id][hOwner]));
						new ownerId = GetPlayerIdFromName(ownerName);
						if(ownerId != INVALID_PLAYER_ID){
							givePlayerUang(ownerId, beliRate);
						}else{
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, houseInfo[id][hOwner]);
		   			 		mysql_tquery(koneksi, pQuery[playerid]);

		   			 		mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `save_house` = 0 WHERE `save_house` = '%d'", id);
							mysql_query(koneksi, pQuery[playerid]);
						}
					}

					DestroyDynamicPickup(housePickup[id]);
					DestroyDynamic3DTextLabel(houseTextInfo[id]);
					houseId[housePickup[id]] = -1;
					housePickup[id] = -1;
					houseInfo[id][hID] = -1;
					houseInfo[id][hOwner] = -1;
					houseInfo[id][hLevel] = 0;
					houseInfo[id][hHarga] = 0;
					houseInfo[id][hKunci] = 1;
					houseInfo[id][hJual] = 0;
					houseInfo[id][icon_x] = 0;
					houseInfo[id][icon_y] = 0;
					houseInfo[id][icon_z] = 0;

					mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `house` WHERE `id_house` = '%d'", id);
					mysql_query(koneksi, pQuery[playerid]);
					format(pmsg, sizeof(pmsg),  GREEN"[RUMAH] "WHITE"Anda berhasil menghapus rumah (id:"YELLOW"%d"WHITE")!", id);
				    SendClientMessage(playerid, COLOR_WHITE, pmsg);
				}else{
					SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "RED"Maaf ID Rumah tidak ada!");
				}
				cache_delete(result);
			}
			return 1;
		}
		case DIALOG_HAPUS_RUMAH_ALL:
		{
			if(response){
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ALL, DIALOG_STYLE_INPUT, "Hapus Rumah", RED"Input tidak boleh kosong!\n"WHITE"Silahkan ketik "GREEN"HAPUS"WHITE" untuk setuju.", "Lanjut", "Batal");

				if(!sama("HAPUS", inputtext)) return ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ALL, DIALOG_STYLE_INPUT, "Hapus Rumah", RED"Input tidak valid!\n"WHITE"Anda harus mengetik "GREEN"HAPUS"WHITE" untuk setuju.", "Lanjut", "Batal");

				for(new i = 0; i < MAX_HOUSES; i++){
					if(housePickup[i] != -1){
						new ownerName[256], beliRate = getHousePrice(i, "beli");
						format(ownerName, 256, "%s", getOwnerHouse(houseInfo[i][hOwner]));
						new ownerId = GetPlayerIdFromName(ownerName);
						if(ownerId != INVALID_PLAYER_ID){
							givePlayerUang(ownerId, beliRate);
						}else{
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, houseInfo[i][hOwner]);
		   			 		mysql_tquery(koneksi, pQuery[playerid]);
						}

						DestroyDynamicPickup(housePickup[i]);
						DestroyDynamic3DTextLabel(houseTextInfo[i]);
						houseInfo[i][hID] = -1;
						houseInfo[i][hOwner] = -1;
						houseInfo[i][hLevel] = 0;
						houseInfo[i][hHarga] = 0;
						houseInfo[i][hKunci] = 1;
						houseInfo[i][hJual] = 0;
						houseInfo[i][icon_x] = 0;
						houseInfo[i][icon_y] = 0;
						houseInfo[i][icon_z] = 0;
						houseId[housePickup[i]] = -1;
						housePickup[i] = -1;
					}
				}

				mysql_query(koneksi, "UPDATE `user` SET `save_house` = 0");
				mysql_query(koneksi, "TRUNCATE TABLE `house`");
				SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil menghapus semua rumah!");
			}
			return 1;
		}
		case DIALOG_INFO_RUMAH:
		{
			if(response){
				new infoRumah[128], id, ownerName[256], houseLevel, beliRate;
				GetPVarString(playerid, "info_rumah", infoRumah, 128);
				id = houseId[lastHousePickup[playerid]];
				houseLevel = houseInfo[id][hLevel];
				beliRate = getHousePrice(id, "beli");
				if(houseInfo[id][hOwner] != -1){
					format(ownerName, 256, "%s", getOwnerHouse(houseInfo[id][hOwner]));
				}else{
					format(ownerName, 256, "Tidak Ada");
				}
				if(sama("set_harga_rumah", infoRumah)){
					if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_INPUT, "Ubah Harga Rumah", RED"Harga tidak boleh kosong!\n"WHITE"Silahkan input harga berupa angka.", "Jual", "Batal");
					if(!isnumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_INPUT, "Ubah Harga Rumah", RED"Harga tidak valid!\n"WHITE"Anda harus menginput harga berupa angka.", "Jual", "Batal");
					if(strval(inputtext) < 0 || strval(inputtext) > 99999999) return ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_INPUT, "Ubah Harga Rumah", RED"Harga tidak valid!\n"WHITE"Silahkan input harga minimal 0 dan maksimal 99999999.\nJika anda mengisi 0 harga akan default, sesuai level dan harga beli.", "Jual", "Batal");
					goto label_set_harga_rumah;
				}
				if(sama("batal_jual", infoRumah)){
					switch(listitem){
						case 0:
						{
							goto label_tentang_rumah;
						}
						case 1:
						{
							houseInfo[id][hJual] = 0;
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `jual` = 0 WHERE `id_house` = '%d'", id);
							mysql_query(koneksi, pQuery[playerid]);
						 	reloadHouseLabel(id);
							SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Rumah anda batal untuk dijual!");
							DeletePVar(playerid, "info_rumah");
						}
						case 2:
						{
							goto label_upgrade_rumah;
						}
						case 3:
						{
							goto label_kunci_rumah;
						}
						case 4:
						{
							goto label_spawn_rumah;
						}
						case 5:
						{
							goto label_masuk_rumah;
						}
					}
				}else if(sama("jual_rumah", infoRumah)){
					switch(listitem){
						case 0:
						{
							goto label_tentang_rumah;
						}
						case 1:
						{
							SetPVarString(playerid, "info_rumah", "set_harga_rumah");
							if(sama("jual_rumah", infoRumah)) return ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_INPUT, "Ubah Harga Rumah", WHITE"Silahkan input harga rumah yang diinginkan.\nJika anda mengisi 0 harga akan default, sesuai level dan harga beli.", "Jual", "Batal");
							label_set_harga_rumah:
							new setHarga = strval(inputtext);
							houseInfo[id][hJual] = 1;
							houseInfo[id][hSetHarga] = setHarga;
							if(setHarga == 0){
								setHarga = beliRate;
							}
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `jual` = 1, `setharga` = '%d' WHERE `id_house` = '%d'", setHarga, id);
							mysql_query(koneksi, pQuery[playerid]);
						 	reloadHouseLabel(id);
							format(msg, sizeof(msg),  "[RUMAH] "YELLOW"Rumah anda berhasil untuk dijual dengan harga ("GREEN"%d"YELLOW")!", setHarga);
							SendClientMessage(playerid, COLOR_GREEN, msg);
							DeletePVar(playerid, "info_rumah");
						}
						case 2:
						{
							label_upgrade_rumah:							    
							if(houseLevel < MAX_HOUSES_LEVEL){
								new upgradeRate = getHousePrice(id, "upgrade");
								if(getUangPlayer(playerid) < upgradeRate) return SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "RED"Maaf uang anda tidak mencukupi!");

								inline responseQuery(){
									new terpasang;
									cache_get_value_name_int(0, "terpasang", terpasang);
									if(!terpasang){
										givePlayerUang(playerid, -upgradeRate);
										houseInfo[id][hLevel] = houseLevel+1;
										mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `level` = '%d'", houseInfo[id][hLevel]);
										mysql_tquery(koneksi, pQuery[playerid]);
										reloadHouseLabel(id);
										format(msg, sizeof(msg),  GREEN"[RUMAH] "WHITE"Anda telah berhasil upgrade rumah ke level ("YELLOW"%d"WHITE"), dengan harga ("YELLOW"%d"WHITE")!", houseInfo[id][hLevel], upgradeRate);
										SendClientMessage(playerid, COLOR_WHITE, msg);
										return 1;
									}else{
										return sendPesan(playerid, COLOR_GREEN, "[RUMAH] "RED"Anda harus melepas semua furniture didalam rumah terlebih dahulu!");
									}
								}
								MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT COUNT(*) as terpasang FROM house_furniture WHERE id_house = '%d'", id);
							}else{
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "RED"Maaf level rumah anda sudah maksimal!");
							}
							DeletePVar(playerid, "info_rumah");
						}
						case 3:
						{
							label_kunci_rumah:
							if(houseInfo[id][hKunci] == 1){
								houseInfo[id][hKunci] = 0;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `kunci` = '%d'", houseInfo[id][hKunci]);
							    mysql_tquery(koneksi, pQuery[playerid]);
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil membuka kunci rumah!");
							}else{
								houseInfo[id][hKunci] = 1;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `kunci` = '%d'", houseInfo[id][hKunci]);
							    mysql_tquery(koneksi, pQuery[playerid]);
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil mengunci rumah!");
							}
							DeletePVar(playerid, "info_rumah");
						}
						case 4:
						{
							label_spawn_rumah:
							new saveId = PlayerInfo[playerid][sHouse];
							if(saveId == id){
								PlayerInfo[playerid][sHouse] = 0;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `save_house` = 0 WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
							    mysql_tquery(koneksi, pQuery[playerid]);
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil membatalkan spawn disini!");
							}else{
								PlayerInfo[playerid][sHouse] = id;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `save_house` = '%d' WHERE `id` = '%d'", id, PlayerInfo[playerid][pID]);
							    mysql_tquery(koneksi, pQuery[playerid]);
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil menyimpan spawn disini!");
							}
							DeletePVar(playerid, "info_rumah");
						}
						case 5:
						{
							goto label_masuk_rumah;
						}
					}
				}else if(sama("beli_rumah", infoRumah)){
					switch(listitem){
						case 0:
						{
							goto label_tentang_rumah;
						}
						case 1:
						{
							if(houseInfo[id][hSetHarga] != 0){
								beliRate = houseInfo[id][hSetHarga];
							}
							if(PlayerInfo[playerid][uang] < beliRate) return SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "RED"Maaf uang anda tidak mencukupi!");
							if(houseInfo[id][hOwner] != -1){
								new ownerId = GetPlayerIdFromName(ownerName);
								if(ownerId != INVALID_PLAYER_ID){
									givePlayerUang(ownerId, beliRate);
								}else{
									mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, houseInfo[id][hOwner]);
				   			 		mysql_tquery(koneksi, pQuery[playerid]);

				   			 		mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `save_house` = 0 WHERE `save_house` = '%d'", id);
									mysql_query(koneksi, pQuery[playerid]);
								}
							}
							givePlayerUang(playerid, -beliRate);

						    houseInfo[id][hOwner] = PlayerInfo[playerid][pID];
						    houseInfo[id][hJual] = 0;
						    mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `id_user` = '%d', `jual` = 0 WHERE `id_house` = '%d'", PlayerInfo[playerid][pID], id);
						    mysql_tquery(koneksi, pQuery[playerid]);
						    reloadHouseLabel(id);
						    format(msg, sizeof(msg),  GREEN"[RUMAH] "WHITE"Anda telah berhasil membeli rumah (id:"YELLOW"%d"WHITE"), dengan harga ("YELLOW"%d"WHITE")!", houseInfo[id][hID], beliRate);
						    SendClientMessage(playerid, COLOR_WHITE, msg);
							DeletePVar(playerid, "info_rumah");
						}
						case 2:
						{
							goto label_masuk_rumah;
						}
					}
				}else if(sama("masuk_rumah", infoRumah)){
					switch(listitem){
						case 0:
						{
							label_tentang_rumah:
							new houseKunci[8], houseJual[16];
							if(houseInfo[id][hKunci] == 1){
								format(houseKunci, 8, "Iya");
							}else{
								format(houseKunci, 8, "Tidak");
							}
							if(houseInfo[id][hJual] == 1){
								format(houseJual, 16, "Dijual");
							}else{
								format(houseJual, 16, "Tidak Dijual");
							}
							format(pDialog[playerid], sizePDialog, "No : %d\nLevel : %d\nHarga : %d\nStatus : %s\nPemilik : %s\nTerkunci : %s", id, houseLevel, beliRate, houseJual, ownerName, houseKunci);
							ShowPlayerDialog(playerid, DIALOG_TENTANG_RUMAH, DIALOG_STYLE_MSGBOX, "Tentang Rumah", pDialog[playerid], "Kembali", "Batal");
							DeletePVar(playerid, "info_rumah");
						}
						case 1:
						{
							label_masuk_rumah:
							new id_level = houseInfo[id][hLevel];
							if(houseInfo[id][hKunci] != 1){
								pindahkanPemain(playerid, HouseLevel[id_level][intSpawn][0], HouseLevel[id_level][intSpawn][1], HouseLevel[id_level][intSpawn][2], HouseLevel[id_level][intSpawn][3], HouseLevel[id_level][intSpawnInterior], id);
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil masuk rumah!");
							}else{
								if(houseInfo[id][hOwner] == PlayerInfo[playerid][pID]){
									pindahkanPemain(playerid, HouseLevel[id_level][intSpawn][0], HouseLevel[id_level][intSpawn][1], HouseLevel[id_level][intSpawn][2], HouseLevel[id_level][intSpawn][3], HouseLevel[id_level][intSpawnInterior], id);
									SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil masuk rumah!");
								}else{
									SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "RED"Maaf rumah terkunci dan tidak dapat masuk!");
								}
							}
							DeletePVar(playerid, "info_rumah");
						}
					}
				}
			}else{
				DeletePVar(playerid, "info_rumah");
			}
			return 1;
		}
		case DIALOG_TENTANG_RUMAH:
		{
			if(response){
				cmd_inforumah(playerid, "");
			}
			return 1;
		}
		case DIALOG_BELI_BARANG_MARKET:
		{
			if(response){
				SetPVarInt(playerid, "bBarang_index", listitem);
				ShowPlayerDialog(playerid, DIALOG_JUMLAH_BARANG_MARKET, DIALOG_STYLE_INPUT, "Jumlah barang yang ingin dibeli", "Silahkan input jumlah barang yang ingin dibeli.", "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_JUMLAH_BARANG_MARKET:
		{
			if(response){
				new banyak_barang;
				if(sscanf(inputtext, "i", banyak_barang)) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_BARANG_MARKET, DIALOG_STYLE_INPUT, "Jumlah barang yang ingin dibeli", RED"Inputan anda tidak valid.\n"WHITE"Silahkan input jumlah barang yang ingin dibeli.", "Beli", "Batal");

				if(banyak_barang < 1 || banyak_barang > 1000) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_BARANG_MARKET, DIALOG_STYLE_INPUT, "Jumlah barang yang ingin dibeli", RED"Inputan anda tidak valid.\nMinimal pembelian 1 dan maksimal pembelian 999.\n"WHITE"Silahkan input jumlah barang yang ingin dibeli.", "Beli", "Batal");

				new index_barang = GetPVarInt(playerid, "bBarang_index");
				SetPVarInt(playerid, "bBarang_jumlah", banyak_barang);
				
				format(pDialog[playerid], sizePDialog, "Anda akan membeli barang "YELLOW"%s "WHITE"sebanyak "YELLOW"%d "WHITE"dengan total harga "GREEN"%d"WHITE".\nApakah anda yakin?", BARANG_MARKET[index_barang][namaBarang], banyak_barang, BARANG_MARKET[index_barang][hargaBarang] * banyak_barang);
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BARANG_MARKET, DIALOG_STYLE_MSGBOX, "Konfirmasi pembelian", pDialog[playerid], "Beli", "Batal");
			}
			else{
				DeletePVar(playerid, "bBarang_index");
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_BARANG_MARKET:
		{
			if(response){
				new index_barang = GetPVarInt(playerid, "bBarang_index");
				new jumlah = GetPVarInt(playerid, "bBarang_jumlah"); 
				new harga = jumlah * BARANG_MARKET[index_barang][hargaBarang];
				if(getUangPlayer(playerid) < harga) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Uang anda tidak mencukupi.", WHITE"Maaf uang anda tidak mencukupi!", "Ok", "");

				inline responseQuery(){
					new total_item;
					cache_get_value_name_int(0, "total_item", total_item);
					if((total_item + jumlah) > PlayerInfo[playerid][limitItem]){						
						format(pDialog[playerid], sizePDialog, "Maaf inventory item anda tidak memiliki cukup ruang,\nuntuk menyimpan sebanyak "ORANGE"%i "WHITE"item. Sisa ruang yang anda miliki adalah "ORANGE"(%i/%i).", jumlah, total_item, PlayerInfo[playerid][limitItem]);

						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory anda penuh", pDialog[playerid], "Ok", "");
					}else{
						tambahItemPlayer(playerid, getIDbyModelItem(BARANG_MARKET[index_barang][idModelBarang]), jumlah);
						givePlayerUang(playerid, -harga);

						format(pDialog[playerid], sizePDialog, "Anda berhasil membeli "YELLOW"%s"WHITE".\nSebanyak "YELLOW"%d"WHITE" dengan harga "GREEN"%d", BARANG_MARKET[index_barang][namaBarang], jumlah, harga);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli barang", pDialog[playerid], "Ok", "");

						DeletePVar(playerid, "bBarang_index");
						DeletePVar(playerid, "bBarang_jumlah");
					}
				}
				MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT SUM(a.jumlah * b.kapasitas) as total_item FROM user_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_user = '%d'", PlayerInfo[playerid][pID]);
			}
			else{
				DeletePVar(playerid, "bBarang_index");
				DeletePVar(playerid, "bBarang_jumlah");
			}
			return 1;
		}
		case DIALOG_TEMPAT_FOTO:
		{
			if(response){
				new banyak_foto;
				if(sscanf(inputtext, "i", banyak_foto)) return ShowPlayerDialog(playerid, DIALOG_TEMPAT_FOTO, DIALOG_STYLE_INPUT, "Foto dan Cetak", RED"Inputan anda tidak valid, harap input bilangan bulat!\n"WHITE"Berapa banyak foto yang ingin anda cetak ?", "Cetak", "Batal");

				new harga = (GetPlayerVirtualWorld(playerid) == VW_tempatFoto_2) ? 10 : 20;

				if(banyak_foto < 1 || banyak_foto > 1000) return ShowPlayerDialog(playerid, DIALOG_TEMPAT_FOTO, DIALOG_STYLE_INPUT, "Foto dan Cetak", RED"Inputan anda tidak valid, harap input bilangan bulat!\n"WHITE"Berapa banyak foto yang ingin anda cetak ?", "Cetak", "Batal");

				SetPVarInt(playerid, "foto_jumlahFoto", banyak_foto);
				format(pDialog[playerid], sizePDialog, "Anda akan mencetak foto sebanyak "GREEN"%d "WHITE"dengan harga "YELLOW"%d.\nApakah anda yakin?", banyak_foto, banyak_foto * harga);
				ShowPlayerDialog(playerid, DIALOG_BAYAR_FOTO, DIALOG_STYLE_MSGBOX, "Bayar dan cetak", pDialog[playerid], "Bayar", "Batal");
				return 1;
			}
			return 1;
		}
		case DIALOG_BAYAR_FOTO:
		{
			if(response){
				new jumlah = GetPVarInt(playerid, "foto_jumlahFoto"); 
				new harga = (GetPlayerVirtualWorld(playerid) == VW_tempatFoto_2) ? 10 : 20;
				harga = jumlah * harga;
				if(getUangPlayer(playerid) < harga) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Uang anda tidak mencukupi", WHITE"Maaf uang anda tidak mencukupi!", "Ok", "");

				inline responseQuery(){
					new total_item;
					cache_get_value_name_int(0, "total_item", total_item);
					if((total_item + jumlah) > PlayerInfo[playerid][limitItem]){						
						format(pDialog[playerid], sizePDialog, "Maaf inventory item anda tidak memiliki cukup ruang,\nuntuk menyimpan sebanyak "ORANGE"%i "WHITE"item. Sisa ruang yang anda miliki adalah "ORANGE"(%i/%i).", jumlah, total_item, PlayerInfo[playerid][limitItem]);

						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory anda penuh", pDialog[playerid], "Ok", "");
					}else{
						// 5 adalah id item untuk pas foto
						tambahItemPlayer(playerid, 5, jumlah);
						givePlayerUang(playerid, -harga);

						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli foto", WHITE"Anda berhasil membeli foto, foto anda sudah masuk inventory.\nSilahkan cek pada inventory anda.", "Ok", "");
						DeletePVar(playerid, "foto_jumlahFoto");
					}
				}
				MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT SUM(a.jumlah * b.kapasitas) as total_item FROM user_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_user = '%d'", PlayerInfo[playerid][pID]);				
				return 1;
			}else{
				DeletePVar(playerid, "foto_jumlahFoto");
			}
			return 1;
		}
		case DIALOG_REFRESH_SKIN:
		{
			if(response){
				if(GetPlayerSkin(playerid) == PlayerInfo[playerid][skinID]) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Skin sudah terpakai", WHITE"Maaf anda sudah menggunakan skin yang tertuju, silahkan pilih skin lain untuk mendapatkan perubahan!", "Ok", "");

				ClearAnimations(playerid);
				TogglePlayerControllable(playerid, 0);
				ubahSkinPemain(playerid, PlayerInfo[playerid][skinID]);
				TogglePlayerControllable(playerid, 1);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mengganti skin!", WHITE"Anda berhasil mengganti skin anda!", "Ok", "");
			}
			return 1;
		}
		case DIALOG_TANYA_INGIN_BELI_SKIN:
		{
			if(response){
				new subString[16];
				new len = ((PlayerInfo[playerid][jenisKelamin] == 0) ? sizeof(SKIN_MALE_GRATIS) : sizeof(SKIN_FEMALE_GRATIS));
				static stringMale[500], stringFemale[500];

				// Laki-laki
				if(PlayerInfo[playerid][jenisKelamin] == 0){
					if(stringMale[0] == EOS){
						for (new i = 0; i < len; i++) {
							format(subString, sizeof(subString), "%i\n", SKIN_MALE_GRATIS[i]);
							strcat(stringMale, subString);
						} 
					}
					ShowPlayerDialog(playerid, DIALOG_BELI_SKIN, DIALOG_STYLE_PREVIEW_MODEL, "Pilih skin yang anda inginkan", stringMale, "Pilih", "Keluar");
				}
				// Perempuan
				else{
					if(stringFemale[0] == EOS){
						for (new i = 0; i < len; i++) {
							format(subString, sizeof(subString), "%i\n", SKIN_FEMALE_GRATIS[i]);
							strcat(stringFemale, subString);
						} 
					}
					ShowPlayerDialog(playerid, DIALOG_BELI_SKIN, DIALOG_STYLE_PREVIEW_MODEL, "Pilih skin yang anda inginkan", stringFemale, "Pilih", "Keluar");
				}
			}
			return 1;
		}
		case DIALOG_RESPSIONIS_PEMERINTAH:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						showDialogRespsionisKTP(playerid);
						return 1;
					}
				}
			}
			return 1;
		}
		case DIALOG_RESPSIONIS_PILIH_KTP:
		{
			if(response){
				switch(listitem){
					// Buat KTP
					case 0:
					{
						// Eksekusi fungsi pengecekan, 
						// yang akan langsung mengeksekusi pembuatan jika memungkinkan
						getSudahBuatKTP(playerid, "cekSudahPunyaKTP");
					}
					// Ambil KTP yang sudah selesai
					case 1:
					{
						getSudahBuatKTP(playerid, "cekSudahBisaAmbilKTP", false);						
					}
				}
			}else
				showDialogResepsionis(playerid);
			return 1;
		}
		case DIALOG_CONFIRM_BUAT_KTP:
		{
			if(response){
				if(getUangPlayer(playerid) < 100) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Gagal membuat KTP", WHITE"Maaf uang yang diperlukan tidak mencukupi.", "Ok", "");

				new barang_barang[2][2] = {
					{5, 4},
					{6, 2}
				};
				cekKetersediaanMassiveItem(playerid, barang_barang, "cekKetersediaanItemBuatKTP");
			}
			return 1;
		}
		case DIALOG_TELLER_BANK:
		{
			if(response){
				switch(listitem){
					// Buat Rekening ATM
					case 0:
					{
						if(!isnull(PlayerInfo[playerid][nomorRekening])) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Rekening telah ada", WHITE"Maaf anda telah memiliki rekening dan tidak dapat membuatnya lagi.", "Ok", ""); 

						cekKetersediaanItem(playerid, 7, 1, "inputNomorRekeningATMBaru");
						return 1;
					}
					case 1:
					{
						if(isnull(PlayerInfo[playerid][nomorRekening])) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Anda tidak memiliki rekening", WHITE"Maaf anda tidak memiliki rekening dan tidak dapat menggunakan menu ini.\nSilahkan buat rekening anda terlebih dahulu untuk dapat menabung.", "Ok", ""); 
						
						ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk kedalam akun bank anda.", "Deposit", "Kembali");
						return 1;
					}
					case 2:
					{
						ShowPlayerDialog(playerid, DIALOG_MENU_GAJI, DIALOG_STYLE_LIST, WHITE"Pilihan gaji :", WHITE"Ambil Gaji\nLihat Gaji", "Pilih", "Kembali");
						return 1;
					}
					case 3: // Bayar Biaya Perbaiki Kendaraan
					{
						new string[250 * BANYAK_DATA_PER_PAGE + 200];
						format(string, sizeof(string), "Kode\tNama\tBiaya\n");
						
						foreach(new i : PVehIterator){
							if(PVeh[i][pVehPemilik] == PlayerInfo[playerid][pID] && PVeh[i][pVehIsReparasi] == 1){
								// Jika mobil sedang dalam reparasi (telah rusak) dan belum dibayar
								format(string, sizeof(string), "%s%d\t%s\t$%d\n", string, i, GetVehicleNameFromModel(PVeh[i][pVehModel]), BIAYA_PERBAIKI_KENDARAAN);
							}
						}

						if(strcmp(string, "Kode\tNama\tBiaya\n") == 0){
							showDialogPesan(playerid, RED"Tidak terdapat kendaraan rusak", WHITE"Tidak terdapat kendaraan rusak yang anda miliki.\nMenu ini digunakan untuk membayar tagihan kendaraan yang rusak, sehingga anda dapat mengambilnya di pusat reparasi.");
						}else
							ShowPlayerDialog(playerid, DIALOG_BAYAR_KENDARAAN_RUSAK, DIALOG_STYLE_TABLIST_HEADERS, "Kendaraan yang sedang rusak.", string, "Pilih", "Kembali");
					}
				}
			}
			return 1;
		}
		case DIALOG_METODE_BAYAR:
		{
			if(response){
				switch(listitem){
					case 0: // Uang cash
					{
						format(pDialog[playerid], sizePDialog, WHITE"Anda memilih pembayaran via cash.\nPembayaran via cash akan memotong uang yang sedang anda bawa saat ini.\n\n"ORANGE"Pembayaran yang akan ditagih sebesar "GREEN"$%d\n\n"WHITE"Pastikan anda memiliki cukup uang untuk membayar tagihan ini.\n"YELLOW"Anda yakin ingin mengkonfirmasi pembayaran ini?", GetPVarInt(playerid, "metode_nominal"));
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BAYAR_CASH, DIALOG_STYLE_MSGBOX, "Konfirmasi pembayaran Cash", pDialog[playerid], "Bayar", "Kembali");
						return 1;						
					}
					case 1: // E-Banking
					{
						if(isnull(PlayerInfo[playerid][nomorRekening])) {
							DeletePVar(playerid, "metode_nominal");
							DeletePVar(playerid, "metode_callback_sukses");
							DeletePVar(playerid, "metode_keterangan_atm");
							return showDialogPesan(playerid, RED"Tidak memiliki ATM", WHITE"Anda tidak memiliki ATM.\nSilahkan buat ATM terlebih dahulu untuk menggunakan metode ini.");
						}
						if(PlayerInfo[playerid][ePhone] < 2) {
							DeletePVar(playerid, "metode_nominal");
							DeletePVar(playerid, "metode_callback_sukses");
							DeletePVar(playerid, "metode_keterangan_atm");
							return showDialogPesan(playerid, RED"Tidak memiliki ePhone", WHITE"Anda tidak memiliki ePhone.\nSilahkan beli dan gunakan ePhone terlebih dahulu (minimal ePhone 2) untuk menggunakan metode ini.");
						}
						format(pDialog[playerid], sizePDialog, WHITE"Silahkan konfirmasi pembayaran Via E-Banking.\n\n"ORANGE"Harga yang akan dikenakan adalah "GREEN"$%d\n\n"YELLOW"Untuk mengkonfirmasi pembayaran silahkan ketikan nomor rekening anda.\n"GREY"** Pastikan bahwa anda memiliki cukup saldo untuk melakukan pembayaran.", GetPVarInt(playerid, "metode_nominal"));
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BAYAR_EBANKING, DIALOG_STYLE_INPUT, YELLOW"Konfirmasi pembayaran via E-Banking", pDialog[playerid], "Bayar", "Kembali");
						return 1;
					}
				}
			}else{
				DeletePVar(playerid, "metode_nominal");
				DeletePVar(playerid, "metode_callback_sukses");
				DeletePVar(playerid, "metode_keterangan_atm");
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_BAYAR_CASH:
		{
			if(response){
				new nominal = GetPVarInt(playerid, "metode_nominal"), fungsi_callback_sukses[50];
				GetPVarString(playerid, "metode_callback_sukses", fungsi_callback_sukses, 50);
				DeletePVar(playerid, "metode_nominal");
				DeletePVar(playerid, "metode_callback_sukses");
				DeletePVar(playerid, "metode_keterangan_atm");
				if(nominal > getUangPlayer(playerid)) return showDialogPesan(playerid, RED"Uang tidak mencukupi", WHITE"Uang anda tidak mencukupi untuk melakukan pembelian ini.\nSelalu pastikan untuk mempunyai uang yang cukup sebelum melakukan pembelian.");

				givePlayerUang(playerid, -nominal);
				if(fungsi_callback_sukses[0] != EOS)
					CallRemoteFunction(fungsi_callback_sukses, "i", playerid);
				else
					printf("[ERROR] #009-A Callback Error di metode pembayaran cash.");
			}else
				ShowPlayerDialog(playerid, DIALOG_METODE_BAYAR, DIALOG_STYLE_LIST, YELLOW"Silahkan pilih metode pembayaran", GREEN"Uang Cash\n"ORANGE"E-Banking", "Pilih", "Batal");
			return 1;
		}
		case DIALOG_KONFIRMASI_BAYAR_EBANKING:
		{
			if(response){
				if(strlen(inputtext) != 8 || strcmp(PlayerInfo[playerid][nomorRekening], inputtext) != 0) {
					format(pDialog[playerid], sizePDialog, RED"Nomor rekening tidak valid.\n"WHITE"Silahkan konfirmasi pembayaran Via E-Banking.\n\n"ORANGE"Harga yang akan dikenakan adalah "GREEN"$%d\n\n"YELLOW"Untuk mengkonfirmasi pembayaran silahkan ketikan nomor rekening anda.\n"GREY"** Pastikan bahwa anda memiliki cukup saldo untuk melakukan pembayaran.", GetPVarInt(playerid, "metode_nominal"));
					return ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BAYAR_EBANKING, DIALOG_STYLE_INPUT, YELLOW"Konfirmasi pembayaran via E-Banking", pDialog[playerid], "Bayar", "Kembali");
				}
				inline responseCekSaldo(){
					new nominal = GetPVarInt(playerid, "metode_nominal"), fungsi_callback_sukses[50], keterangan_atm[50], saldo;
					GetPVarString(playerid, "metode_callback_sukses", fungsi_callback_sukses, sizeof(fungsi_callback_sukses));
					GetPVarString(playerid, "metode_keterangan_atm", keterangan_atm, sizeof(keterangan_atm));
					DeletePVar(playerid, "metode_nominal");
					DeletePVar(playerid, "metode_callback_sukses");
					DeletePVar(playerid, "metode_keterangan_atm");

					cache_get_value_name_int(0, "saldo", saldo);

					if(saldo > nominal){
						addTransaksiTabungan(PlayerInfo[playerid][nomorRekening], -nominal, keterangan_atm);
						if(fungsi_callback_sukses[0] != EOS)
							CallRemoteFunction(fungsi_callback_sukses, "i", playerid);
						else
							printf("[ERROR] #009-B Callback Error di metode pembayaran atm.");
					}else{
						format(pDialog[playerid], sizePDialog, WHITE"Maaf saldo yang terdapat pada ATM anda tidak mencukupi.\n\n"ORANGE"Saldo rekening pada saat ini adalah "GREEN"$%d. \n"WHITE"Selalu pastikan bahwa saldo anda mencukupi untuk menggunakan metode E-Banking.\nSilahkan gunakan metode pembayaran lain.", nominal);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Saldo anda tidak mencukupi", pDialog[playerid], "Ok", "");
					}
				}
				MySQL_TQueryInline(koneksi, using inline responseCekSaldo, "SELECT IFNULL(SUM(nominal), 0) as saldo FROM `trans_atm` WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
			}else
				ShowPlayerDialog(playerid, DIALOG_METODE_BAYAR, DIALOG_STYLE_LIST, YELLOW"Silahkan pilih metode pembayaran", GREEN"Uang Cash\n"ORANGE"E-Banking", "Pilih", "Batal");
			return 1;
		}
		case DIALOG_BAYAR_KENDARAAN_RUSAK:
		{
			if(response){
				new idpv = strval(inputtext);
				if(PVeh[idpv][pVehIsReparasi] == 1 && PVeh[idpv][pVehPemilik] == PlayerInfo[playerid][pID]){
					new keterangan[50];
					format(keterangan, 50, "biaya perbaikan %s", GetVehicleNameFromModel(PVeh[idpv][pVehModel]));
					SetPVarInt(playerid, "fixbayar_idpv", idpv);
					dialogMetodeBayar(playerid, BIAYA_PERBAIKI_KENDARAAN, "selesaiBayarKerusakanKendaraan", keterangan);
				}
				else
					showDialogKesalahanSistem(playerid, "invalid vehicle id saat memilih kendaraan rusak");
			}else
				showDialogTellerBank(playerid);
			return 1;
		}
		case DIALOG_DAFTAR_REKENING_INPUT_NOMOR:
		{
			if(response){
				new inputan;
				if(strlen(inputtext) != 8) return ShowPlayerDialog(playerid, DIALOG_DAFTAR_REKENING_INPUT_NOMOR, DIALOG_STYLE_INPUT, "Input nomor rekening ATM baru", RED"Nomor rekening harus terdiri dari 8 digit angka 0 - 9!\n\n"WHITE"Input nomor rekening ATM yang baru:\n"WHITE"- Nomor rekening harus terdiri dari 8 karakter\n- Nomor rekening belum digunakan oleh orang lain sebelumnya", "Ok", "Kembali");

				if(sscanf(inputtext, "i", inputan) || inputtext[0] == '-') return ShowPlayerDialog(playerid, DIALOG_DAFTAR_REKENING_INPUT_NOMOR, DIALOG_STYLE_INPUT, "Input nomor rekening ATM baru", RED"Nomor rekening harus terdiri dari 8 digit angka 0 - 9!\n\n"WHITE"Input nomor rekening ATM yang baru:\n"WHITE"- Nomor rekening harus terdiri dari 8 karakter\n- Nomor rekening belum digunakan oleh orang lain sebelumnya", "Ok", "Kembali");

				SetPVarString(playerid, "regis_rekening", inputtext);

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT COUNT(*) AS hasil FROM `user` WHERE rekening = '%e'", inputtext);
				mysql_tquery(koneksi, pQuery[playerid], "isRekeningAda", "i", playerid);
			}else{
				showDialogTellerBank(playerid);
			}
			return 1;
		}
		case DIALOG_DAFTAR_REKENING_KONFIRMASI:
		{
			if(response){
				if(getUangPlayer(playerid) < 100) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Uang tidak mencukupi", "Anda tidak memiliki cukup uang untuk mendaftarkan rekening baru.", "Ok", "");

				new barang_barang_atm[2][2] = {
					{5, 4},
					{6, 2}
				};
				cekKetersediaanMassiveItem(playerid, barang_barang_atm, "konfirmasiPembuatanRekening");
			}else{
				DeletePVar(playerid, "regis_rekening");
			}
			return 1;
		}
		case DIALOG_DEPOSIT_UANG_TABUNGAN:
		{
			if(response){
				new nominal;
				if(sscanf(inputtext, "i", nominal)) return ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", RED"Anda harus memasukan nominal dengan benar!\n"WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk kedalam akun bank anda.", "Deposit", "Kembali");

				if(nominal < 10) return ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", RED"Anda harus memasukan nominal dengan benar, minimal penabungan adalah $10.\n"WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk kedalam akun bank anda.", "Deposit", "Kembali");

				if(getUangPlayer(playerid) < nominal) return ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", RED"Anda harus memasukan nominal dengan benar, nominal yang anda masukan melebihi uang anda.\n"WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk kedalam akun bank anda.", "Deposit", "Kembali");

				SetPVarInt(playerid, "depo_nominal", nominal);
				
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan menyimpan uang sebesar "GREEN"$%d "WHITE"pada tabungan anda.\nApakah anda yakin?\n\n"YELLOW"Pada saat uang disimpan anda dapat melihat nominalnya pada tabungan anda atau pada website.", nominal);
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_DEPOSIT, DIALOG_STYLE_MSGBOX, YELLOW"Konfirmasi penyimpanan", pDialog[playerid], "Simpan", "Batal");
			}else
				showDialogTellerBank(playerid);
			return 1;
		}
		case DIALOG_KONFIRMASI_DEPOSIT:
		{
			if(response){
				new nominal = GetPVarInt(playerid, "depo_nominal");
				DeletePVar(playerid, "depo_nominal");
				
				givePlayerUang(playerid, -nominal);
				addTransaksiTabungan(PlayerInfo[playerid][nomorRekening], nominal, "Deposit tabungan");
				
				format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil menyimpan uang sebesar "GREEN"$%d "WHITE"pada tabungan anda.\nSilahkan cek tabungan anda.\n"YELLOW"Note : Setiap transaksi yang dilakukan akan otomatis tercatat pada history rekening anda.", nominal);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menyimpan ke tabungan", pDialog[playerid], "Ok", "");
			}else
				DeletePVar(playerid, "depo_nominal");
			return 1;
		}
		case DIALOG_ATM:
		{
			if(response){
				switch(listitem){
					case 0: // Transfer Uang
					{
						ShowPlayerDialog(playerid, DIALOG_INPUT_REKENING_TUJUAN, DIALOG_STYLE_INPUT, "Nomor rekening tujuan", "Silahkan masukan nomor rekening tujuan:\nNomor rekening harus terdiri dari 8 digit.\nPastikan anda memasukan rekening yang benar.", "Ok", "Batal");
						return 1;
					}
					case 1: // Penarikan Uang
					{
						ShowPlayerDialog(playerid, DIALOG_TARIK_UANG_NOMINAL, DIALOG_STYLE_INPUT, "Nominal penarikan uang", "Silahkan masukan nominal yang ingin anda ambil :\n"YELLOW"Pastikan anda memiliki cukup saldo untuk mengambilnya.", "Tarik", "Kembali");
						return 1;
					}
					case 2: // Cek Saldo ATM
					{
						getSaldoPlayer(playerid, "tampilSaldoPlayer");
						return 1;
					}
					case 3: // History ATM
					{
						SetPVarInt(playerid, "halaman", 0);

						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
						mysql_tquery(koneksi, pQuery[playerid], "historyATMPemain", "i", playerid);
						return 1;
					}
				}
			}
			return 1;
		}
		case DIALOG_INPUT_REKENING_TUJUAN:
		{
			if(response){
				new inputan;
				if(strlen(inputtext) != 8 || sscanf(inputtext, "i", inputan) || inputtext[0] == '-') return ShowPlayerDialog(playerid, DIALOG_INPUT_REKENING_TUJUAN, DIALOG_STYLE_INPUT, "Nomor rekening tujuan", RED"Nomor rekening harus terdiri dari 8 digit angka.\n"WHITE"Silahkan masukan nomor rekening tujuan:\nNomor rekening harus terdiri dari 8 digit.\nPastikan anda memasukan rekening yang benar.", "Ok", "Kembali");

				if(strcmp(inputtext, PlayerInfo[playerid][nomorRekening]) == 0) return ShowPlayerDialog(playerid, DIALOG_INPUT_REKENING_TUJUAN, DIALOG_STYLE_INPUT, "Nomor rekening tujuan", RED"Tidak dapat mengirim ke nomor rekening sendiri.\n"WHITE"Silahkan masukan nomor rekening tujuan:\nNomor rekening harus terdiri dari 8 digit.\nPastikan anda memasukan rekening yang benar.", "Ok", "Kembali");

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT nama FROM `user` WHERE rekening = '%e'", inputtext);
				mysql_tquery(koneksi, pQuery[playerid], "isRekeningTujuanAda", "is", playerid, inputtext);
			}
			return 1;
		}
		case DIALOG_TRANSFER_NOMINAL:
		{
			if(response){
				new nominal;
				if(sscanf(inputtext, "i", nominal)) return ShowPlayerDialog(playerid, DIALOG_TRANSFER_NOMINAL, DIALOG_STYLE_INPUT, "Nominal yang ingin ditransfer", RED"Nominal salah, silahkan memasukan jumlah yang benar.\n"WHITE"Masukan nominal yang ingin ditransfer:\n"YELLOW"Pastikan bahwa nominal yang ingin anda transfer tidak melebihi saldo tabungan anda.", "Ok", "Batal");
				if(nominal < 10) return ShowPlayerDialog(playerid, DIALOG_TRANSFER_NOMINAL, DIALOG_STYLE_INPUT, "Nominal yang ingin ditransfer", RED"Minimal nominal adalah $10.\n"WHITE"Masukan nominal yang ingin ditransfer:\n"YELLOW"Pastikan bahwa nominal yang ingin anda transfer tidak melebihi saldo tabungan anda.", "Ok", "Batal");

				SetPVarInt(playerid, "tf_nominal", nominal);

				getSaldoPlayer(playerid, "isMencukupiTransfer");
			}else{
				DeletePVar(playerid, "tf_nama");
				DeletePVar(playerid, "tf_rekening");
			}				
			return 1;
		}
		case DIALOG_TRANSFER_KONFIRMASI:
		{
			if(response){
				new nama_penerima[50], rekening_penerima[10], nominal = GetPVarInt(playerid, "tf_nominal");
				GetPVarString(playerid, "tf_nama", nama_penerima, sizeof(nama_penerima));
				GetPVarString(playerid, "tf_rekening", rekening_penerima, sizeof(rekening_penerima));
				if(strlen(inputtext) > 50){

					format(pDialog[playerid], sizePDialog, RED"Tidak dapat memasukan lebih dari 50 karakter.\n"WHITE"Anda akan melakukan transfer dengan data berikut :\n\n"YELLOW"Nama Penerima : %s\nNo. Rek : %s\nNominal : %d\n\n"WHITE"Anda yakin ingin mengirimnya? Silahkan isi keterangan pengiriman menandakan anda setuju.", nama_penerima, rekening_penerima, nominal);
					return ShowPlayerDialog(playerid, DIALOG_TRANSFER_KONFIRMASI, DIALOG_STYLE_INPUT, "Konfirmasi Transfer", pDialog[playerid], "Kirim", "Batal");					
				}

				addTransaksiTabungan(PlayerInfo[playerid][nomorRekening], -nominal, inputtext, rekening_penerima);
				addTransaksiTabungan(rekening_penerima, nominal, inputtext, PlayerInfo[playerid][nomorRekening]);

				DeletePVar(playerid, "tf_nama");
				DeletePVar(playerid, "tf_rekening");
				DeletePVar(playerid, "tf_nominal");
				
				new tahun, bulan, hari, jam, menit, detik;
				gettime(jam, menit, detik);
				getdate(tahun, bulan, hari);
				format(pDialog[playerid], sizePDialog, GREEN"PENGIRIMAN SUKSES!\n\n"WHITE"Informasi transfer.\nNama Penerima\t\t: %s\nRekening Penerima\t\t: %s\nNominal\t\t\t: %d\n\nNama Pengirim\t\t: %s\nRekening Pengirim\t\t: %s\nTanggal Waktu : %d/%d/%d %02d:%02d:%02d", nama_penerima, rekening_penerima, nominal, PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][nomorRekening], hari, bulan, tahun, jam, menit, detik);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Berhasil transfer duit", pDialog[playerid], "Ok", "");
			}else{
				DeletePVar(playerid, "tf_nama");
				DeletePVar(playerid, "tf_rekening");
				DeletePVar(playerid, "tf_nominal");
			}
			return 1;
		}
		case DIALOG_TARIK_UANG_NOMINAL:
		{
			if(response){
				new nominal;
				if(sscanf(inputtext, "i", nominal)) return ShowPlayerDialog(playerid, DIALOG_TARIK_UANG_NOMINAL, DIALOG_STYLE_INPUT, "Nominal penarikan uang", RED"Silahkan masukan nominal yang benar.\n"WHITE"Silahkan masukan nominal yang ingin anda ambil :\n"YELLOW"Pastikan anda memiliki cukup saldo untuk mengambilnya.", "Tarik", "Kembali");

				if(nominal < 10) return ShowPlayerDialog(playerid, DIALOG_TARIK_UANG_NOMINAL, DIALOG_STYLE_INPUT, "Nominal penarikan uang", RED"Nominal penarikan minimal adalah $10.\n"WHITE"Silahkan masukan nominal yang ingin anda ambil :\n"YELLOW"Pastikan anda memiliki cukup saldo untuk mengambilnya.", "Tarik", "Kembali");

				SetPVarInt(playerid, "wd_nominal", nominal);
				
				getSaldoPlayer(playerid, "isMencukupiTarik");
			}else{
				DeletePVar(playerid, "wd_nominal");
				showDialogATM(playerid);
			}
			return 1;
		}
		case DIALOG_TARIK_UANG_KONFIRMASI:
		{
			if(response){
				new nominal = GetPVarInt(playerid, "wd_nominal");

				addTransaksiTabungan(PlayerInfo[playerid][nomorRekening], -nominal, "Penarikan uang");
				givePlayerUang(playerid, nominal);

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Berhasil melakukan penarikan", GREEN"Berhasil melakukan penarikan uang!\n"WHITE"Penarikan uang akan langsung menambahkan uang tunai anda, dan mengurangi saldo ATM anda.\nSemua transaksi pada ATM akan tercatat secara otomatis dan permanen.", "Ok", "");

				DeletePVar(playerid, "wd_nominal");
			}else
				DeletePVar(playerid, "wd_nominal");
			return 1;
		}
		case DIALOG_INFO_SALDO_HISTORY:
		{
			if(response){
				showDialogATM(playerid);
			}
			return 1;
		}
		case DIALOG_INFO_HISTORY_ATM:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
					mysql_tquery(koneksi, pQuery[playerid], "historyATMPemain", "i", playerid);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
						
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
						mysql_tquery(koneksi, pQuery[playerid], "historyATMPemain", "i", playerid);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
						mysql_tquery(koneksi, pQuery[playerid], "historyATMPemain", "i", playerid);
					}
					return 1;
				}

				showDialogATM(playerid);
			}
			return 1;
		}
		case DIALOG_TANYA_TAMBANG:
		{
			if(response){
				if(PlayerAction[playerid][sedangNambang]) return error_command(playerid, "Anda sedang menambang, tunggu beberapa saat.");
				if(getStatusMakanPemain(playerid) <= 10) return error_command(playerid, "Anda kehabisan energi, silahkan makan terlebih dahulu untuk dapat bekerja kembali.");

				inline responseQuery(){
					new total_item;
					cache_get_value_name_int(0, "total_item", total_item);
					if((total_item + 1) > PlayerInfo[playerid][limitItem]){
						format(pDialog[playerid], sizePDialog, "Maaf inventory item anda tidak memiliki cukup ruang,\nuntuk menyimpan minimal "ORANGE"%i "WHITE"item. Sisa ruang yang anda miliki adalah "ORANGE"(%i/%i).\nKosongkan ruang item anda sebelum memulai menambang kembali.", 1, total_item, PlayerInfo[playerid][limitItem]);

						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory anda penuh", pDialog[playerid], "Ok", "");
					}else{
						PlayerAction[playerid][timerNambang] = SetPreciseTimer("selesaiNambang", 3000, 0, "i", playerid);
						PlayerAction[playerid][sedangNambang] = true;
						GameTextForPlayer(playerid, "~w~Sedang ~y~menambang...", 3000, 3);

						SetPlayerAttachedObject(playerid, MINING_ATTACH_INDEX, 19631, 6, 0.048, 0.029, 0.103, -80.0, 80.0, 0.0);
						TogglePlayerControllable(playerid, 0);
						SetPlayerArmedWeapon(playerid, 0);
						ApplyAnimation(playerid, "CHAINSAW", "CSAW_1", 4.1, 1, 0, 0, 1, 0, 1);
					}
				}
				MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT SUM(a.jumlah * b.kapasitas) as total_item FROM user_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_user = '%d'", PlayerInfo[playerid][pID]);
			}
			return 1;
		}
		case DIALOG_MENU_GAJI:
		{
			if(response){
				switch(listitem){
					case 0: // Ambil gaji
					{
						ShowPlayerDialog(playerid, DIALOG_PILIHAN_AMBIL_GAJI, DIALOG_STYLE_LIST, WHITE"Pilihan ambil gaji :", WHITE"Masukin ke saldo Bank\nAmbil uang cash", "Pilih", "Batal");
						return 1;
					}
					case 1: // Lihat gaji
					{
						SetPVarInt(playerid, "halaman", 0);

						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT nominal, tanggal, keterangan FROM `gaji` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
						mysql_tquery(koneksi, pQuery[playerid], "showHistoryGajiPemain", "i", playerid);
						return 1;
					}
				}
			}else
				ShowPlayerDialog(playerid, DIALOG_MENU_GAJI, DIALOG_STYLE_LIST, WHITE"Pilihan gaji :", WHITE"Ambil Gaji\nLihat Gaji", "Pilih", "Kembali");
			return 1;
		}
		case DIALOG_LIHAT_GAJI:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT nominal, tanggal, keterangan FROM `gaji` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
					mysql_tquery(koneksi, pQuery[playerid], "showHistoryGajiPemain", "i", playerid);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
							
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT nominal, tanggal, keterangan FROM `gaji` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
						mysql_tquery(koneksi, pQuery[playerid], "showHistoryGajiPemain", "i", playerid);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT nominal, tanggal, keterangan FROM `gaji` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
						mysql_tquery(koneksi, pQuery[playerid], "showHistoryGajiPemain", "i", playerid);
					}
					return 1;
				}

				ShowPlayerDialog(playerid, DIALOG_MENU_GAJI, DIALOG_STYLE_LIST, WHITE"Pilihan gaji :", WHITE"Ambil Gaji\nLihat Gaji", "Pilih", "Kembali");
			}
			return 1;
		}
		case DIALOG_PILIHAN_AMBIL_GAJI:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						if(isnull(PlayerInfo[playerid][nomorRekening])) return showDialogPesan(playerid, RED"Tidak memiliki akun bank", WHITE"Anda tidak memiliki akun bank untuk menampung gaji anda.\nSilahkan buat akun bank anda terlebih dahulu, atau gunakan "YELLOW"metode pengambilan gaji lain.");

						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(SUM(nominal), 0) AS nominal FROM `gaji` WHERE id_user = '%d' AND status = '0'", PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid], "hitungGaji", "ii", playerid, 0);
					}
					case 1:
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(SUM(nominal), 0) AS nominal FROM `gaji` WHERE id_user = '%d' AND status = '0'", PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid], "hitungGaji", "ii", playerid, 1);
					}
				}
			}
			return 1;
		}
		case DIALOG_MENU_BELI_MAKAN:
		{
			if(response){
				SetPVarInt(playerid, "bmakan_index", listitem);
				ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_MAKANAN, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
			}else{
				DeletePVar(playerid, "bmakan_index");
				DeletePVar(playerid, "bmakan_jumlah");
			}
			return 1;
		}
		case DIALOG_JUMLAH_PEMBELIAN_MAKANAN:
		{
			if(response){
				new jumlah;
				if(sscanf(inputtext, "i", jumlah)) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_MAKANAN, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");

				if(jumlah < 1 || jumlah > 100) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_MAKANAN, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar dan anda hanya dapat membeli 100 dalam sekali pembelian.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");

				SetPVarInt(playerid, "bmakan_jumlah", jumlah);

				ShowPlayerDialog(playerid, DIALOG_METODE_BAYAR_MAKAN, DIALOG_STYLE_LIST, "Pilih Metode Pembayaran:", "Uang Cash\nVia E-Banking", "Beli", "Kembali");
			}else{
				DeletePVar(playerid, "bmakan_index");
				DeletePVar(playerid, "bmakan_jumlah");

				showDialogTempatMakan(playerid);
			}
			return 1;
		}
		case DIALOG_METODE_BAYAR_MAKAN:
		{
			if(response){
				switch(listitem){
					case 0: // Bayar cash
					{
						new idx = GetPVarInt(playerid, "bmakan_index"), jumlah = GetPVarInt(playerid, "bmakan_jumlah");
						new harga = jumlah * MENU_MAKANAN[idx][hargaMakanan];
						DeletePVar(playerid, "bmakan_index");
						DeletePVar(playerid, "bmakan_jumlah");
						if(harga > getUangPlayer(playerid)) return showDialogPesan(playerid, RED"Uang tidak mencukupi", WHITE"Uang anda tidak mencukupi untuk melakukan pembelian ini.");

						inline responseQuery(){
							new total_item;
							cache_get_value_name_int(0, "total_item", total_item);
							if((total_item + jumlah) > PlayerInfo[playerid][limitItem]){						
								format(pDialog[playerid], sizePDialog, "Maaf inventory item anda tidak memiliki cukup ruang,\nuntuk menyimpan sebanyak "ORANGE"%i "WHITE"item. Sisa ruang yang anda miliki adalah "ORANGE"(%i/%i).", jumlah, total_item, PlayerInfo[playerid][limitItem]);

								ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory anda penuh", pDialog[playerid], "Ok", "");
							}else{
								givePlayerUang(playerid, -harga);
								tambahItemPlayer(playerid, MENU_MAKANAN[idx][idItemMakanan], jumlah);

								format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil membeli "YELLOW"%s "WHITE" sebanyak "YELLOW"%d "WHITE"dengan harga total "GREEN"$%d\n"WHITE"Item langsung dikirimkan pada inventory anda, silahkan buka inventory untuk mengeceknya.", MENU_MAKANAN[idx][namaMakanan], jumlah, harga);
								showDialogPesan(playerid, GREEN"Berhasil membeli makanan", pDialog[playerid]);
							}
						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT SUM(a.jumlah * b.kapasitas) as total_item FROM user_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_user = '%d'", PlayerInfo[playerid][pID]);		
						return 1;
					}
					case 1: // Via E-Banking
					{
						if(isnull(PlayerInfo[playerid][nomorRekening])) {
							DeletePVar(playerid, "bmakan_index");
							DeletePVar(playerid, "bmakan_jumlah");
							return showDialogPesan(playerid, RED"Tidak memiliki ATM", WHITE"Anda tidak memiliki ATM.\nSilahkan buat ATM terlebih dahulu untuk menggunakan metode ini.");
						}
						if(PlayerInfo[playerid][ePhone] == 0) {
							DeletePVar(playerid, "bmakan_index");
							DeletePVar(playerid, "bmakan_jumlah");
							return showDialogPesan(playerid, RED"Tidak memiliki ePhone", WHITE"Anda tidak memiliki ePhone.\nSilahkan beli dan gunakan ePhone terlebih dahulu (minimal ePhone 2) untuk menggunakan metode ini.");
						}
						new idx = GetPVarInt(playerid, "bmakan_index"), jumlah = GetPVarInt(playerid, "bmakan_jumlah");
						new harga = jumlah * MENU_MAKANAN[idx][hargaMakanan];

						format(pDialog[playerid], sizePDialog, WHITE"Silahkan konfirmasi pembayaran Via E-Banking.\n\nHarga yang akan dikenakan adalah "GREEN"$%d.\n"YELLOW"Untuk mengkonfirmasi pembayaran silahkan ketikan nomor rekening anda.", harga);
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BAYAR_MAKANAN_VIA_ATM, DIALOG_STYLE_INPUT, YELLOW"Konfirmasi pembayaran", pDialog[playerid], "Bayar", "Batal");
						return 1;
					}
				}
			}else{
				DeletePVar(playerid, "bmakan_index");
				DeletePVar(playerid, "bmakan_jumlah");				
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_BAYAR_MAKANAN_VIA_ATM:
		{
			if(response){
				new idx = GetPVarInt(playerid, "bmakan_index"), jumlah = GetPVarInt(playerid, "bmakan_jumlah");
				new harga = jumlah * MENU_MAKANAN[idx][hargaMakanan];
				if(strlen(inputtext) != 8 || strcmp(PlayerInfo[playerid][nomorRekening], inputtext) != 0) {
					format(pDialog[playerid], sizePDialog, RED"Nomor rekening yang anda masukan tidak benar."WHITE"\n\nHarga yang akan dikenakan adalah "GREEN"$%d.\n"YELLOW"Untuk mengkonfirmasi pembayaran silahkan ketikan nomor rekening anda.", harga);
					return ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BAYAR_MAKANAN_VIA_ATM, DIALOG_STYLE_INPUT, YELLOW"Konfirmasi pembayaran", pDialog[playerid], "Bayar", "Batal");	
				}

				inline responseQuery(){
					new total_item;
					cache_get_value_name_int(0, "total_item", total_item);
					if((total_item + jumlah) > PlayerInfo[playerid][limitItem]){						
						format(pDialog[playerid], sizePDialog, "Maaf inventory item anda tidak memiliki cukup ruang,\nuntuk menyimpan sebanyak "ORANGE"%i "WHITE"item. Sisa ruang yang anda miliki adalah "ORANGE"(%i/%i).", jumlah, total_item, PlayerInfo[playerid][limitItem]);

						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory anda penuh", pDialog[playerid], "Ok", "");
					}else{
						getSaldoPlayer(playerid, "pembayaranMakananATM");
					}
				}
				MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT SUM(a.jumlah * b.kapasitas) as total_item FROM user_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_user = '%d'", PlayerInfo[playerid][pID]);	
			}else{
				DeletePVar(playerid, "bmakan_index");
				DeletePVar(playerid, "bmakan_jumlah");				
			}
		}
		case DIALOG_JOB_SWEEPER:
		{
			if(response){
				if(todoActive(playerid) == 1){
					RemovePlayerFromVehicle(playerid);
					return 1;
				}
				new vehid = GetPlayerVehicleID(playerid);
				sweeperJob[playerid] = 1;
				sweeperId[playerid] = vehid;
				usedSweeper[vehid] = 1;
				SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper1, CP_sweeper2, 3.0);
				SendClientMessage(playerid, COLOR_GREEN, "[JOB] "YELLOW"Anda berhasil bekerja sebagai "GREEN"Sweeper"YELLOW"!");
				SendClientMessage(playerid, COLOR_GREEN, "[JOB] "WHITE"Anda memiliki waktu 10 menit, jika belum selesai anda akan gagal.");
				todoTimeout[playerid] = SetPreciseTimer("todoExit", 600000, false, "ii", playerid, vehid);
			}else{
				RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_SIM_REGIS_MENU:
		{
			if(response){
				switch(listitem){
					// Buat SIM
					case 0:
					{
						if(todoActive(playerid) == 1){
							return 1;
						}
						SetPVarString(playerid, "sim_polisi", "buat_sim");
						getSudahBuatSIM(playerid, "cekSudahPunyaSIM");
					}
					// Ambil SIM yang sudah selesai
					case 1:
					{
						if(todoActive(playerid) == 1){
							return 1;
						}
						new Cache:result;
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT tanggal_buat FROM `pengambilan_sim` WHERE `id_user` = '%d' AND tanggal_buat = '0000-00-00 00:00:00'", PlayerInfo[playerid][pID]);
						result = mysql_query(koneksi, pQuery[playerid]);
						if(cache_num_rows()){
							showDialogPesan(playerid, RED"Anda Belum Ujian Praktik", WHITE"Maaf anda belum melakukan Ujian Praktik SIM, anda belum dapat mengambil SIM!\nSilahkan melakukan Ujian Praktik SIM terlebih dahulu, tempat Ujian Praktik SIM berada di sebelah Kantor Polisi Los Santos (Parkiran).");
						}else{
							getSudahBuatSIM(playerid, "cekSudahBisaAmbilSIM", false);
						}
						cache_delete(result);
					}
				}
			}
			return 1;
		}
		case DIALOG_SIM_PRAKTIK_MENU:
		{
			if(response){
				switch(listitem){
					// Mulai Praktik
					case 0:
					{
						if(todoActive(playerid) == 1){
							return 1;
						}
						SetPVarString(playerid, "sim_polisi", "mulai_praktik");
						getSudahBuatSIM(playerid, "cekSudahPunyaSIM");
					}
				}
			}
			return 1;
		}
		case DIALOG_DAFTAR_SIM_KONFIRMASI:
		{
			if(response){
				if(getUangPlayer(playerid) < 100){
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Uang tidak mencukupi", "Anda tidak memiliki cukup uang untuk mendaftarkan SIM baru.", "Ok", "");
				}else{
					cekKetersediaanItem(playerid, 7, 1, "cekPembuatanSIM");
				}
				DeletePVar(playerid, "sim_polisi");
			}
			return 1;
		}
		case DIALOG_PRAKTIK_SIM_KONFIRMASI:
		{
			if(response){
				mulaiPraktikSIM(playerid);
			}
			DeletePVar(playerid, "sim_polisi");
			return 1;
		}
		case DIALOG_SIM_SOAL:
		{
			if(response){
				new noSoal = GetPVarInt(playerid, "sim_soal");
				printf("noSoal %d", noSoal);
				if(noSoal == 0){
					poinSim[playerid] = 0;
				}
				if(noSoal >= 1){
					printf("noSoal %d", noSoal);
					if(sama(SIM_SOAL[0][simAnswer3], inputtext) && noSoal == 1){
						poinSim[playerid] += SIM_SOAL[0][simAnswerTrue];
						printf("1 %d", poinSim[playerid]);
					}else if(sama(SIM_SOAL[1][simAnswer1], inputtext) && noSoal == 2){
						poinSim[playerid] += SIM_SOAL[1][simAnswerTrue];
						printf("2 %d", poinSim[playerid]);
					}else if(sama(SIM_SOAL[2][simAnswer4], inputtext) && noSoal == 3){
						poinSim[playerid] += SIM_SOAL[2][simAnswerTrue];
						printf("3 %d", poinSim[playerid]);
					}else if(sama(SIM_SOAL[3][simAnswer3], inputtext) && noSoal == 4){
						poinSim[playerid] += SIM_SOAL[3][simAnswerTrue];
						printf("4 %d", poinSim[playerid]);
					}else if(sama(SIM_SOAL[4][simAnswer4], inputtext) && noSoal == 5){
						poinSim[playerid] += SIM_SOAL[4][simAnswerTrue];
						printf("5 %d", poinSim[playerid]);
					}else if(sama(SIM_SOAL[5][simAnswer1], inputtext) && noSoal == 6){
						poinSim[playerid] += SIM_SOAL[5][simAnswerTrue];
						printf("6 %d", poinSim[playerid]);
					}else{
						poinSim[playerid] += 0;
					}
				}
				if(noSoal == 6){
					if(poinSim[playerid] < 10){
						GameTextForPlayer(playerid, "~g~Ujian Teori Selesai", 2000, 3);
						format(pDialog[playerid], sizePDialog, WHITE"Anda mendapatkan poin sebesar "GREEN"%d"WHITE".\nSilahkan mencoba kembali ketika anda sudah siap.\n\nTerimakasih, Salam hangat "ORANGE"Kantor Polisi Lost Santos", poinSim[playerid]);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Gagal Ujian Teori SIM", pDialog[playerid], "Ok", "");
						poinSim[playerid] = 0;
						DeletePVar(playerid, "sim_soal");
						SetPlayerVirtualWorld(playerid, 1);
						return 1;
					}else{
						GameTextForPlayer(playerid, "~g~Ujian Teori Selesai", 2000, 3);
						format(pDialog[playerid], sizePDialog, WHITE"Anda mendapatkan poin sebesar "GREEN"%d"WHITE".\nSilahkan melanjutkan untuk Ujian Praktik SIM."WHITE"\nTempat Ujian Praktik SIM berada di sebelah Kantor Polisi Los Santos (Parkiran).\n\nTerimakasih, Salam hangat "ORANGE"Kantor Polisi Lost Santos", poinSim[playerid]);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil Ujian Teori SIM", pDialog[playerid], "Ok", "");
						poinSim[playerid] = 0;
						DeletePVar(playerid, "sim_soal");
						SetPlayerVirtualWorld(playerid, 1);
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO pengambilan_sim(id_user,status_teori) VALUES('%d',1)", PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid]);
						return 1;
					}
				}
				if(noSoal != 6){
					printf("noSoal %d", noSoal);
					format(pDialog[playerid], sizePDialog, "%s\n%s\n%s\n%s", SIM_SOAL[noSoal][simAnswer1], SIM_SOAL[noSoal][simAnswer2], SIM_SOAL[noSoal][simAnswer3], SIM_SOAL[noSoal][simAnswer4]);
					SendClientMessage(playerid, -1, SIM_SOAL[noSoal][simQuestionMSG]);
					ShowPlayerDialog(playerid, DIALOG_SIM_SOAL, DIALOG_STYLE_LIST, SIM_SOAL[noSoal][simQuestion], pDialog[playerid], "Lanjut", "Batal");
					SetPVarInt(playerid, "sim_soal", noSoal+1);
				}
			}else{
				poinSim[playerid] = 0;
				DeletePVar(playerid, "sim_soal");
				SetPlayerVirtualWorld(playerid, 1);
			}
			return 1;
		}
		case DIALOG_ADMIN_PAPAN:
		{
			if(response){
				switch(listitem){
					case 0: // Get Papan Sekitar
					{
						new hitung = 0, subString[50];
						format(pDialog[playerid], sizePDialog, WHITE"Daftar ID papan terdekat (sejauh radius 20 meter) "RED"dengan LIMIT 20 papan.\n");
						foreach(new i : Range(0, jumlahBoard)){
							if(IsPlayerInRangeOfPoint(playerid, 20, BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ])){
								format(subString, 50, "ID - %d\n", i);
								strcat(pDialog[playerid], subString);
								hitung++;
							}
							if(hitung == 20) break;
						}
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Daftar Papan terdekat", pDialog[playerid], "Ok", "");
						return 1;
					}
					case 1: // Teleport ke papan
					{
						return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN, DIALOG_STYLE_INPUT, "Input ID Papan", "Silahkan masukan ID papan yang ingin dikunjungi", "Pergi", "Kembali");
					}
					case 2: // Buat Papan
					{
						return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_BUAT_PAPAN, DIALOG_STYLE_INPUT, "Input tulisan", "Silahkan Input text yang ingin anda tulis di papan.", "Ok", "Kembali");
					}
					case 3: // Edit Posisi Papan
					{
						return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_EDIT_ID, DIALOG_STYLE_INPUT, "Edit Posisi Papan", "Silahkan masukan id papan yang mau di edit posisinya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
					}
					case 4: // Edit Text
					{
						return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ETEXT_ID, DIALOG_STYLE_INPUT, "Edit Text Papan", "Silahkan masukan id papan yang mau di edit textnya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
					}
					case 5: // Ukuran text
					{
						return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ESIZE_ID, DIALOG_STYLE_INPUT, "Edit Ukuran Text", "Silahkan masukan id papan yang mau di edit ukuran textnya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
					}
					case 6: // Hapus papan
					{
						return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_HAPUS, DIALOG_STYLE_INPUT, "Hapus Papan", "Masukan ID papan yang ingin anda hapus.", "Ok", "Kembali");
					}
				}
			}
			return 1;
		}
		case DIALOG_ADMIN_PAPAN_GOTO:
		{
			if(response){
				new i;
				if(sscanf(inputtext, "i", i)) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_GOTO, DIALOG_STYLE_INPUT, "Input ID Papan", RED"ID Papan salah.\n"WHITE"Silahkan masukan ID papan yang ingin dikunjungi", "Pergi", "Kembali");
				if(i < 0 || i > MAX_BOARDS) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_GOTO, DIALOG_STYLE_INPUT, "Input ID Papan", RED"ID Papan salah.\n"WHITE"Silahkan masukan ID papan yang ingin dikunjungi", "Pergi", "Kembali");
				if(!BoardInfo[i][bModel]) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_GOTO, DIALOG_STYLE_INPUT, "Input ID Papan", RED"Papan tidak ada.\n"WHITE"Silahkan masukan ID papan yang ingin dikunjungi", "Pergi", "Kembali");

				pindahkanPemain(playerid, BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ], 0, 0, 0);
				server_message(playerid, "Anda berhasil teleport ke board.");
			}else
				showDialogAdminPapan(playerid);
			return 1;
		}
		case DIALOG_ADMIN_PAPAN_BUAT_PAPAN:
		{
			if(response){
				if(strlen(inputtext) < 1 || strlen(inputtext) > 1000) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_BUAT_PAPAN, DIALOG_STYLE_INPUT, "Input tulisan", RED"Panjang tulisan harus antara 1 hingga 1000 karakter.\n"WHITE"Silahkan Input text yang ingin anda tulis di papan.", "Ok", "Kembali");

				if((jumlahBoard + 1) >= MAX_BOARDS) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_BUAT_PAPAN, DIALOG_STYLE_INPUT, "Input tulisan", RED"Server telah mencapai batas maksimal papan.\n"WHITE"Silahkan Input text yang ingin anda tulis di papan.", "Ok", "Kembali");

				new i = jumlahBoard;
				GetPlayerPos(playerid, BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ]);
				BoardInfo[i][bModel] = MODEL_PAPAN;
				BoardInfo[i][bCX] = BoardInfo[i][bCX] + 2;
				BoardInfo[i][bCY] = BoardInfo[i][bCY] + 2;
				BoardInfo[i][bCRX] = 0;
				BoardInfo[i][bCRY] = 0;
				BoardInfo[i][bCRZ] = 0;
				BoardInfo[i][bStatus] = 0;
				BoardInfo[i][bFontSiz] = 24;
				format(BoardInfo[i][bText], 999, BLACK"%s", inputtext);
				strreplace(BoardInfo[i][bText], "\\n", "\n");

				BoardInfo[i][bBoard] = CreateDynamicObject(BoardInfo[i][bModel], BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ], BoardInfo[i][bCRX], BoardInfo[i][bCRY], BoardInfo[i][bCRZ]);

				SetDynamicObjectMaterialText(BoardInfo[i][bBoard], 0, BoardInfo[i][bText], OBJECT_MATERIAL_SIZE_256x128,"Arial", BoardInfo[i][bFontSiz], 1, 0x000000FF,0xFFFFFFFF,OBJECT_MATERIAL_TEXT_ALIGN_CENTER);

				format(pDialog[playerid], sizePDialog, "Berhasil membuat board "WHITE"ID %d. (object: 5846)", i);
				SendClientMessage(playerid, COLOR_GREEN, pDialog[playerid]);

				SaveBoard(BoardInfo[i][bModel], BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ], BoardInfo[i][bCRX], BoardInfo[i][bCRY], BoardInfo[i][bCRZ], BoardInfo[i][bText], BoardInfo[i][bFontSiz]);
				jumlahBoard++;
			}else
				showDialogAdminPapan(playerid);
			return 1;
		}
		case DIALOG_ADMIN_PAPAN_EDIT_ID:
		{
			if(response){
				new i;
				if(sscanf(inputtext, "i", i)) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_EDIT_ID, DIALOG_STYLE_INPUT, "Edit Posisi Papan", RED"ID Papan salah.\n"WHITE"Silahkan masukan id papan yang mau di edit posisinya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
				if(i < 0 || i > MAX_BOARDS) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_EDIT_ID, DIALOG_STYLE_INPUT, "Edit Posisi Papan", RED"ID Papan tidak benar.\n"WHITE"Silahkan masukan id papan yang mau di edit posisinya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
				if(!BoardInfo[i][bModel]) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_EDIT_ID, DIALOG_STYLE_INPUT, "Edit Posisi Papan", RED"ID Papan tidak ada.\n"WHITE"Silahkan masukan id papan yang mau di edit posisinya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
				if(!IsPlayerInRangeOfPoint(playerid, 10, BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ])) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_EDIT_ID, DIALOG_STYLE_INPUT, "Edit Posisi Papan", RED"Papan tidak berada disekitar anda.\n"WHITE"Silahkan masukan id papan yang mau di edit posisinya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");

				EditingObject[playerid] = EDITING_BOARD;
				bEditID[playerid] = i;
				GetDynamicObjectPos(BoardInfo[i][bBoard], bCPos[playerid][0], bCPos[playerid][1], bCPos[playerid][2]);
				GetDynamicObjectRot(BoardInfo[i][bBoard], bCRot[playerid][0], bCRot[playerid][1], bCRot[playerid][2]);
				EditDynamicObject(playerid, BoardInfo[i][bBoard]);
			}else
				showDialogAdminPapan(playerid);
			return 1;
		}
		case DIALOG_ADMIN_PAPAN_ETEXT_ID:
		{
			if(response){
				new i;
				if(sscanf(inputtext, "i", i)) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ETEXT_ID, DIALOG_STYLE_INPUT, "Edit Text Papan", RED"ID Papan salah.\n"WHITE"Silahkan masukan id papan yang mau di edit textnya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
				if(i < 0 || i > MAX_BOARDS) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ETEXT_ID, DIALOG_STYLE_INPUT, "Edit Text Papan", RED"ID Papan tidak benar.\n"WHITE"Silahkan masukan id papan yang mau di edit textnya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
				if(!BoardInfo[i][bModel]) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ETEXT_ID, DIALOG_STYLE_INPUT, "Edit Text Papan", RED"ID Papan tidak ada.\n"WHITE"Silahkan masukan id papan yang mau di edit textnya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
				if(!IsPlayerInRangeOfPoint(playerid, 10, BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ])) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ETEXT_ID, DIALOG_STYLE_INPUT, "Edit Text Papan", RED"Papan tidak berada disekitar anda.\n"WHITE"Silahkan masukan id papan yang mau di edit textnya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");

				EditingObject[playerid] = EDITING_BOARD;
				bEditID[playerid] = i;
				ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ETEXT_TEXT, DIALOG_STYLE_INPUT, "Edit Text", "Silahkan isi text yang diinginkan.\nPastikan text tidak melebihi 1000 karakter dan minimal memiliki sebuah karakter.", "OK", "Batal");
			}else
				showDialogAdminPapan(playerid);
			return 1;
		}
		case DIALOG_ADMIN_PAPAN_ETEXT_TEXT:
		{
			if(response){
				new idx = bEditID[playerid];
				if(strlen(inputtext) < 1 || strlen(inputtext) > 1000) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ETEXT_TEXT, DIALOG_STYLE_INPUT, "Edit Text", RED"Jumlah karakter pada text tidak mengikuti aturan!\n"WHITE"Silahkan isi text yang diinginkan.\nPastikan text tidak melebihi 1000 karakter dan minimal memiliki sebuah karakter.", "OK", "Batal");

				format(BoardInfo[idx][bText], 1000, BLACK"%s", inputtext);
				strreplace(BoardInfo[idx][bText], "\\n", "\n");
				SetDynamicObjectMaterialText(BoardInfo[idx][bBoard], 0, BoardInfo[idx][bText],OBJECT_MATERIAL_SIZE_256x128, "Arial", BoardInfo[idx][bFontSiz], 1, 0x000000FF,0xFFFFFFFF,OBJECT_MATERIAL_TEXT_ALIGN_CENTER);

				SendClientMessage(playerid, COLOR_BLUE, "* Anda berhasil mengubah text pada papan.");
				SaveBoard(BoardInfo[idx][bModel], BoardInfo[idx][bCX], BoardInfo[idx][bCY], BoardInfo[idx][bCZ], BoardInfo[idx][bCRX], BoardInfo[idx][bCRY], BoardInfo[idx][bCRZ], BoardInfo[idx][bText], BoardInfo[idx][bFontSiz], BoardInfo[idx][boardID]);
				bEditID[playerid] = 0;
				EditingObject[playerid] = EDITING_NONE;
			}
			return 1;
		}
		case DIALOG_ADMIN_PAPAN_ESIZE_ID:
		{
			if(response){
				new i;
				if(sscanf(inputtext, "i", i)) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ESIZE_ID, DIALOG_STYLE_INPUT, "Edit Ukuran Text", RED"ID Papan salah.\n"WHITE"Silahkan masukan id papan yang mau di edit ukuran textnya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
				if(i < 0 || i > MAX_BOARDS) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ESIZE_ID, DIALOG_STYLE_INPUT, "Edit Ukuran Text", RED"ID Papan tidak benar.\n"WHITE"Silahkan masukan id papan yang mau di edit ukuran textnya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
				if(!BoardInfo[i][bModel]) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ESIZE_ID, DIALOG_STYLE_INPUT, "Edit Ukuran Text", RED"ID Papan tidak ada.\n"WHITE"Silahkan masukan id papan yang mau di edit ukuran textnya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");
				if(!IsPlayerInRangeOfPoint(playerid, 10, BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ])) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ESIZE_ID, DIALOG_STYLE_INPUT, "Edit Ukuran Text", RED"Papan tidak berada disekitar anda.\n"WHITE"Silahkan masukan id papan yang mau di edit ukuran textnya.\nPastikan papan tersebut berada maksimal 10 meter dari anda.", "Ok", "Kembali");

				bEditID[playerid] = i;
				EditingObject[playerid] = EDITING_BOARD;
				ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ESIZE_SIZE, DIALOG_STYLE_INPUT, "Input ukuran text", "Silahkan masukan ukuran text yang diinginkan.", "Ok", "Batal");
			}else
				showDialogAdminPapan(playerid);
			return 1;
		}
		case DIALOG_ADMIN_PAPAN_ESIZE_SIZE:
		{
			if(response){
				new idx = bEditID[playerid];
				if(strval(inputtext) < 1 || strval(inputtext) > 100) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_ESIZE_SIZE, DIALOG_STYLE_INPUT, "Input ukuran text", RED"Ukuran text harus antara 1 hingga 100!\n"WHITE"Silahkan masukan ukuran text yang diinginkan.", "Ok", "Batal");

				BoardInfo[idx][bFontSiz] = strval(inputtext);
				SetDynamicObjectMaterialText(BoardInfo[idx][bBoard], 0, BoardInfo[idx][bText],OBJECT_MATERIAL_SIZE_256x128, "Arial", BoardInfo[idx][bFontSiz], 1, 0x000000FF,0xFFFFFFFF,OBJECT_MATERIAL_TEXT_ALIGN_CENTER);

				SaveBoard(BoardInfo[idx][bModel], BoardInfo[idx][bCX], BoardInfo[idx][bCY], BoardInfo[idx][bCZ], BoardInfo[idx][bCRX], BoardInfo[idx][bCRY], BoardInfo[idx][bCRZ], BoardInfo[idx][bText], BoardInfo[idx][bFontSiz], BoardInfo[idx][boardID]);
				bEditID[playerid] = 0;
				EditingObject[playerid] = EDITING_NONE;
			}else{
				bEditID[playerid] = 0;
				EditingObject[playerid] = EDITING_NONE;
			}
			return 1;
		}
		case DIALOG_ADMIN_PAPAN_HAPUS:
		{
			if(response){
				new i;
				if(sscanf(inputtext, "i", i)) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_HAPUS, DIALOG_STYLE_INPUT, "Hapus Papan", RED"ID Papan salah.\n"WHITE"Masukan ID papan yang ingin anda hapus.", "Ok", "Kembali");
				if(i < 0 || i > MAX_BOARDS) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_HAPUS, DIALOG_STYLE_INPUT, "Hapus Papan", RED"ID Papan tidak benar.\n"WHITE"Masukan ID papan yang ingin anda hapus.", "Ok", "Kembali");
				if(!BoardInfo[i][bModel]) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_HAPUS, DIALOG_STYLE_INPUT, "Hapus Papan", RED"ID Papan tidak ada.\n"WHITE"Masukan ID papan yang ingin anda hapus.", "Ok", "Kembali");
				if(!IsPlayerInRangeOfPoint(playerid, 10, BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ])) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_HAPUS, DIALOG_STYLE_INPUT, "Hapus Papan", RED"Papan tidak berada disekitar anda.\n"WHITE"Masukan ID papan yang ingin anda hapus.", "Ok", "Kembali");

				DeleteBoard(i);
				SendClientMessage(playerid, COLOR_BLUE, "* Anda berhasil menghapus papan.");
			}
			return 1;
		}
		case DIALOG_ADMIN_VEHICLE:
		{
			if(response){
				switch(listitem){
					case 0: // Buat Kendaraan
					{
						ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE_NEW_MODELID, DIALOG_STYLE_INPUT, "Masukan model kendaraan", "Silahkan masukan model id kendaraan, silahkan cari di google kalau gak tau id modelnya.\nCari kata kuncinya \"Model ID SA-MP\" ketemu ntar.", "Ok", "Kembali");
						return 1;
					}
					case 1: // Parkir Vehicle Dealer
					{
						if(IsPlayerInAnyVehicle(playerid)){
							new idveh = GetPlayerVehicleID(playerid);
							if(Iter_Contains(DVehIterator, idveh) && DVeh[idveh][dVehID]){
								GetVehiclePos(idveh, DVeh[idveh][dVehCoord][0], DVeh[idveh][dVehCoord][1], DVeh[idveh][dVehCoord][2]);
								GetVehicleZAngle(idveh, DVeh[idveh][dVehCoord][3]);

								UpdateVehicleDealer(idveh);

								format(pDialog[playerid], sizePDialog, "[A-DEALER] "WHITE"Berhasil memarkirkan kendaraan dealer %s pada tempat ini.", GetVehicleNameFromModel(DVeh[idveh][dVehModel]));
								SendClientMessage(playerid, COLOR_CYAN, pDialog[playerid]);

								RemovePlayerFromVehicle(playerid);

								DestroyDynamic3DTextLabel(DVeh[idveh][dVehText3D]);
								DestroyVehicle(idveh);

								new id = CreateVehicle(DVeh[idveh][dVehModel], DVeh[idveh][dVehCoord][0], DVeh[idveh][dVehCoord][1], DVeh[idveh][dVehCoord][2], DVeh[idveh][dVehCoord][3], DVeh[idveh][dVehColor][0], DVeh[idveh][dVehColor][0], -1);

								if(id != idveh) {
									// Pindahkan Nilai
									DVeh[id] = DVeh[idveh];
									Iter_Add(DVehIterator, id);

									// Bersihkan
									static const kosong_dveh[DealerVehicleInfo];
									DVeh[idveh] = kosong_dveh;
									Iter_Remove(DVehIterator, idveh);
								}
								new str[150];
								format(str, sizeof(str), "Kendaraan ini dijual!\n"ORANGE"Nama Kendaraan: "WHITE"%s\n"PURPLE"Harga: "GREEN"$%d", GetVehicleNameFromModel(DVeh[id][dVehModel]), DVeh[id][dVehHarga]);
								DVeh[id][dVehText3D] = CreateDynamic3DTextLabel(str, COLOR_GREEN, 0.0, 0.0, 0.0, 50.0, INVALID_PLAYER_ID, id);

								SetVehicleToRespawn(id);
							}else{
								error_command(playerid, "Ini bukan kendaraan dealer.");
							}
						}else
							error_command(playerid, "Anda hanya dapat menggunakan perintah ini didalam kendaraan dealer.");
					}
					case 2: // Respawn all dealer vehicle
					{
						foreach(new i : DVehIterator){
							if(!IsVehicleOccupied(i)) // Respawn kendaraan yang tidak sedang dinaiki
								SetVehicleToRespawn(i);
						}
						SendClientMessage(playerid, COLOR_CYAN, "[A-DEALER] "WHITE"Berhasil merespawn semua kendaraan pada semua dealer!");
					}
					case 3: // Hapus kendaraan dealer
					{
						if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "[A-DEALER] "WHITE"Anda harus didalam kendaraan dealer yang ingin dihapus untuk dapat menggunakan perintah ini!");

						new idveh = GetPlayerVehicleID(playerid);
						if(Iter_Contains(DVehIterator, idveh) && DVeh[idveh][dVehID]){
							RemovePlayerFromVehicle(playerid);

							// Reset nilai & Hapus
							DestroyDynamic3DTextLabel(DVeh[idveh][dVehText3D]);
							DeleteVehicleDealer(DVeh[idveh][dVehID]);
							DestroyVehicle(idveh);

							Iter_Remove(DVehIterator, idveh);

							static const kosong_dveh[DealerVehicleInfo];
							DVeh[idveh] = kosong_dveh;

							SendClientMessage(playerid, COLOR_CYAN, "[A-DEALER] "WHITE"Berhasil menghapus kendaraan dealer!");
						}else{
							SendClientMessage(playerid, COLOR_RED, "[A-DEALER] "WHITE"Kendaraan ini bukan kendaraan dealer yang dapat dihapus!");
						}
					}
				}
			}
			return 1;
		}
		case DIALOG_ADMIN_VEHICLE_NEW_MODELID:
		{
			if(response){
				new modelid;
				if(sscanf(inputtext, "i", modelid) || !strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE_NEW_MODELID, DIALOG_STYLE_INPUT, "Masukan model kendaraan", RED"Silahkan masukan inputan yang benar.\n"WHITE"Silahkan masukan model id kendaraan, silahkan cari di google kalau gak tau id modelnya.\nCari kata kuncinya \"Model ID SA-MP\" ketemu ntar.", "Ok", "Kembali");				
				if(modelid < 400 || modelid > 611) return ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE_NEW_MODELID, DIALOG_STYLE_INPUT, "Masukan model kendaraan", RED"Silahkan masukan inputan yang benar antara 400 sampai 611.\n"WHITE"Silahkan masukan model id kendaraan, silahkan cari di google kalau gak tau id modelnya.\nCari kata kuncinya \"Model ID SA-MP\" ketemu ntar.", "Ok", "Kembali");

				SetPVarInt(playerid, "buatveh_id", modelid);

				format(pDialog[playerid], sizePDialog, WHITE"Kendaraan yang terpilih adalah "GREEN"%s "WHITE"\nSilahkan masukan warna kendaraan (0 - 255).", GetVehicleNameFromModel(GetPVarInt(playerid, "buatveh_id")));
				ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE_NEW_COLOR, DIALOG_STYLE_INPUT, "Input warna kendaraan", pDialog[playerid], "Pilih", "Batal");				
			}else
				showDialogAdminVehicle(playerid);
			return 1;
		}
		case DIALOG_ADMIN_VEHICLE_NEW_COLOR:
		{
			if(response){
				new warna;
				if(sscanf(inputtext, "i", warna) || !strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE_NEW_COLOR, DIALOG_STYLE_INPUT, "Input warna kendaraan - "RED"Warna salah.", pDialog[playerid], "Pilih", "Batal");
				
				if(warna < 0 || warna > 255) return ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE_NEW_COLOR, DIALOG_STYLE_INPUT, "Input warna kendaraan - "RED"Warna salah.", pDialog[playerid], "Pilih", "Batal");


				SetPVarInt(playerid, "buatveh_col", warna);
				format(pDialog[playerid], sizePDialog, WHITE"Kendaraan yang terpilih adalah "GREEN"%s "WHITE"\nWarna terpilih : %d\nSilahkan masukan harga kendaraan.", GetVehicleNameFromModel(GetPVarInt(playerid, "buatveh_id")), GetPVarInt(playerid, "buatveh_col"));
				ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE_NEW_HARGA, DIALOG_STYLE_INPUT, "Input harga kendaraan", pDialog[playerid], "Pilih", "Batal");
			}else
				DeletePVar(playerid, "buatveh_id");
			return 1;
		}
		case DIALOG_ADMIN_VEHICLE_NEW_HARGA:
		{
			if(response){
				new harga;
				if(sscanf(inputtext, "i", harga) || !strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE_NEW_HARGA, DIALOG_STYLE_INPUT, "Input harga kendaraan - "RED"Harga Salah.", pDialog[playerid], "Pilih", "Batal");
				
				if(harga < 1) return ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE_NEW_HARGA, DIALOG_STYLE_INPUT, "Input harga kendaraan - "RED"Harga Salah harus lebih dari 0.", pDialog[playerid], "Pilih", "Batal");

				new modelid = GetPVarInt(playerid, "buatveh_id"), warna = GetPVarInt(playerid, "buatveh_col");
				new Float:temp_pos[4];
				GetPlayerPos(playerid, temp_pos[0], temp_pos[1], temp_pos[2]);
				GetPlayerFacingAngle(playerid, temp_pos[3]);
				new id_kendaraan = CreateVehicleDealer(modelid, temp_pos[0], temp_pos[1], temp_pos[2], temp_pos[3], warna, warna, harga);

				PutPlayerInVehicle(playerid, id_kendaraan, 0);

				format(pDialog[playerid], sizePDialog, WHITE"Kendaraan berhasil dibuat dengan stats berikut :\n"ORANGE"Nama Kendaraan : "WHITE"%s\nWarna Kendaraan : %d\n"PURPLE"Harga Kendaraan : "GREEN"$%d\n\n"WHITE"Silahkan parkirkan dimanapun anda mau, dan gunakan /aveh untuk mengakses perintah parkir kendaraan dealer.", GetVehicleNameFromModel(modelid), warna, harga);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Berhasil membuat kendaraan", pDialog[playerid], "Ok", "");

				DeletePVar(playerid, "buatveh_id");
				DeletePVar(playerid, "buatveh_col");
			}else
				DeletePVar(playerid, "buatveh_id"), DeletePVar(playerid, "buatveh_col");
			return 1;
		}
		case DIALOG_BELI_KENDARAAN_DEALER:
		{
			if(response){
				inline responseQuery(){
					new total;
					cache_get_value_name_int(0, "total", total);
					if(total >= MAX_KENDARAAN_PER_PEMAIN){
						RemovePlayerFromVehicle(playerid);
						showDialogPesan(playerid, RED"Slot Kendaraan Penuh", WHITE"Maaf slot kendaraan anda penuh, kendaraan anda telah mencapai batas maksimal!\nSilahkan sediakan slot terlebih dahulu sebelum membeli kembali.");
					}else{
						ShowPlayerDialog(playerid, DIALOG_METODE_BAYAR_KENDARAAN, DIALOG_STYLE_LIST, "Pilih Metode Pembayaran:", "Uang Cash\nVia E-Banking", "Bayar", "Kembali");
					}
				}	

				MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT COUNT(*) AS total FROM vehicle WHERE id_pemilik = '%d'", PlayerInfo[playerid][pID]);
			}else{
				if(!IsPlayerAdmin(playerid)) RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_METODE_BAYAR_KENDARAAN:
		{
			if(response){
				switch(listitem){
					case 0: // Bayar Uang Cash
					{
						if(!IsPlayerInAnyVehicle(playerid)) return showDialogPesan(playerid, RED"Anda harus didalam mobil", WHITE"Anda harus didalam mobil yang ingin dibeli, jangan keluar hingga transaksi selesai.");

						new vehid = GetPlayerVehicleID(playerid);
						// Counter cheater jika model mobil dimanipulasi
						if(!Iter_Contains(DVehIterator, vehid) || GetVehicleModel(vehid) != DVeh[vehid][dVehModel]) {
							RemovePlayerFromVehicle(playerid);
							// Banned Cheater
							return 1;
						}

						if(getUangPlayer(playerid) < DVeh[vehid][dVehHarga]) {
							RemovePlayerFromVehicle(playerid);
							return showDialogPesan(playerid, RED"Uang tidak mencukupi", WHITE"Maaf uang anda tidak mencukupi untuk melakukan pembelian!");
						}

						givePlayerUang(playerid, -DVeh[vehid][dVehHarga]);

						new primary_id = BeliVehicleDariDealer(playerid, vehid, DVeh[vehid][dVehCoord][0], DVeh[vehid][dVehCoord][1], DVeh[vehid][dVehCoord][2], DVeh[vehid][dVehCoord][3]);

						// Pindah iterator
						Iter_Remove(DVehIterator, vehid);
						new idpv = Iter_Free(PVehIterator);
						Iter_Add(PVehIterator, idpv);

						Iter_Add(IDVehToPVehIterator, vehid);
						IDVehToPVeh[vehid] = idpv;

						PVeh[idpv][pVehID] = primary_id;
						PVeh[idpv][pVehPemilik] = PlayerInfo[playerid][pID];
						format(PVeh[idpv][pVehNamaPemilik], MAX_PLAYER_NAME, "%s", PlayerInfo[playerid][pPlayerName]);
						PVeh[idpv][pVehicle] = vehid;
						PVeh[idpv][pVehModel] = DVeh[vehid][dVehModel];
						PVeh[idpv][pVehCoord][0] = DVeh[vehid][dVehCoord][0];
						PVeh[idpv][pVehCoord][1] = DVeh[vehid][dVehCoord][1];
						PVeh[idpv][pVehCoord][2] = DVeh[vehid][dVehCoord][2];
						PVeh[idpv][pVehCoord][3] = DVeh[vehid][dVehCoord][3];
						PVeh[idpv][pVehColor][0] = DVeh[vehid][dVehColor][0];
						PVeh[idpv][pVehColor][1] = DVeh[vehid][dVehColor][1];
						PVeh[idpv][pVehDarah] = 1000;
						SetVehicleHealth(vehid, 1000);

						format(pDialog[playerid], sizePDialog, CYAN"*********************************************************************************\n\n", pDialog[playerid]);
						format(pDialog[playerid], sizePDialog, "%s"ORANGE"Selamat anda berhasil membeli kendaraan dengan spesifikasi sebagai berikut :\n\n", pDialog[playerid]);
						format(pDialog[playerid], sizePDialog, "%s"PURPLE"Nama Kendaraan: "WHITE"%s\n", pDialog[playerid], GetVehicleNameFromModel(DVeh[vehid][dVehModel]));
						format(pDialog[playerid], sizePDialog, "%sHarga: "GREEN"$%d\n\n", pDialog[playerid], DVeh[vehid][dVehHarga]);
						format(pDialog[playerid], sizePDialog, "%s"WHITE"Terimakasih sudah menggunakan layanan kami.\n\n"CYAN"*********************************************************************************\n", pDialog[playerid]);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Berhasil membeli kendaraan", pDialog[playerid], "Ok", "");						

						// Reset nilai & Hapus
						DestroyDynamic3DTextLabel(DVeh[vehid][dVehText3D]);
						DeleteVehicleDealer(DVeh[vehid][dVehID]);

						static const kosong_dveh[DealerVehicleInfo];
						DVeh[vehid] = kosong_dveh;					
					}
					case 1:
					{
						if(!IsPlayerInAnyVehicle(playerid)) return showDialogPesan(playerid, RED"Anda harus didalam mobil", WHITE"Anda harus didalam mobil yang ingin dibeli, jangan keluar hingga transaksi selesai.");

						new vehid = GetPlayerVehicleID(playerid);
						// Counter cheater jika model mobil dimanipulasi
						if(!Iter_Contains(DVehIterator, vehid) || GetVehicleModel(vehid) != DVeh[vehid][dVehModel]) {
							RemovePlayerFromVehicle(playerid);
							// Banned Cheater
							return 1;
						}

						if(isnull(PlayerInfo[playerid][nomorRekening])) {
							RemovePlayerFromVehicle(playerid);
							return showDialogPesan(playerid, RED"Tidak memiliki ATM", WHITE"Anda tidak memiliki ATM.\nSilahkan buat ATM terlebih dahulu untuk menggunakan metode ini.");
						}
						if(PlayerInfo[playerid][ePhone] == 0) {
							RemovePlayerFromVehicle(playerid);
							return showDialogPesan(playerid, RED"Tidak memiliki ePhone", WHITE"Anda tidak memiliki ePhone.\nSilahkan beli dan gunakan ePhone terlebih dahulu (minimal ePhone 2) untuk menggunakan metode ini.");
						}

						format(pDialog[playerid], sizePDialog, WHITE"Silahkan konfirmasi pembayaran Via E-Banking.\n\nHarga yang akan dikenakan adalah "GREEN"$%d.\n"YELLOW"Untuk mengkonfirmasi pembayaran silahkan ketikan nomor rekening anda.", DVeh[vehid][dVehHarga]);
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BAYAR_KENDARAAN_VIA_ATM, DIALOG_STYLE_INPUT, YELLOW"Konfirmasi pembayaran via E-Banking", pDialog[playerid], "Bayar", "Batal");
					}
				}
			}else{
				if(!IsPlayerAdmin(playerid)) RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_BAYAR_KENDARAAN_VIA_ATM:
		{
			if(response){
				if(!IsPlayerInAnyVehicle(playerid)) return showDialogPesan(playerid, RED"Anda harus didalam mobil", WHITE"Anda harus didalam mobil yang ingin dibeli, jangan keluar hingga transaksi selesai.");

				new vehid = GetPlayerVehicleID(playerid);
				if(strlen(inputtext) != 8 || strcmp(PlayerInfo[playerid][nomorRekening], inputtext) != 0) {
					format(pDialog[playerid], sizePDialog, RED"Anda tidak memasukan nomor rekening dengan benar!\n"WHITE"Silahkan konfirmasi pembayaran Via E-Banking.\n\nHarga yang akan dikenakan adalah "GREEN"$%d.\n"YELLOW"Untuk mengkonfirmasi pembayaran silahkan ketikan nomor rekening anda.", DVeh[vehid][dVehHarga]);
					return ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BAYAR_KENDARAAN_VIA_ATM, DIALOG_STYLE_INPUT, YELLOW"Konfirmasi pembayaran via E-Banking", pDialog[playerid], "Bayar", "Batal");
				}
				getSaldoPlayer(playerid, "pembayaranKendaraanATM");
			}else{
				if(!IsPlayerAdmin(playerid)) RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_AMBIL_KENDARAAN_REPARASI:
		{
			if(response){
				new idpv = strval(inputtext);
				if(Iter_Contains(PVehIterator, idpv)){
					if(PVeh[idpv][pVehPemilik] == PlayerInfo[playerid][pID]){
						if(IsValidDynamicCP(GetPlayerVisibleDynamicCP(playerid)) && CP_spawnReparasi[0] <= GetPlayerVisibleDynamicCP(playerid) && CP_spawnReparasi[sizeof(CP_spawnReparasi) - 1] >= GetPlayerVisibleDynamicCP(playerid)){
							PVeh[idpv][pVehIsReparasi] = STATUS_KENDARAAN_TIDAK_RUSAK;
							updatePVehReparasi(PVeh[idpv][pVehID], STATUS_KENDARAAN_TIDAK_RUSAK);

							new id_cp = GetPlayerVisibleDynamicCP(playerid) - CP_spawnReparasi[0];
							new idveh = CreateVehicle(PVeh[idpv][pVehModel], POSISI_SPAWN_REPARASI_MOBIL[id_cp][SPAWN_POINT_X], POSISI_SPAWN_REPARASI_MOBIL[id_cp][SPAWN_POINT_Y], POSISI_SPAWN_REPARASI_MOBIL[id_cp][SPAWN_POINT_Z], POSISI_SPAWN_REPARASI_MOBIL[id_cp][SPAWN_POINT_A], PVeh[idpv][pVehColor][0], PVeh[idpv][pVehColor][1], -1);

							PVeh[idpv][pVehicle] = idveh;
							IDVehToPVeh[idveh] = idpv;
							Iter_Add(IDVehToPVehIterator, idveh);

							LoadModifVehiclePlayer(idveh);

							#if defined DEBUG_SERVER_LOAD
							printf("Vehicle Player %s Vehicle-ID(%d) ig-ID(%d) load.",PlayerInfo[playerid][pPlayerName], PVeh[idpv][pVehID], idveh);
							#endif
							
							SetVehicleToRespawn(idveh);

							SetVehicleHealth(idveh, 1000);
							PVeh[idpv][pVehDarah] = 1000;
							
							new engine, lights, alarm, doors, bonnet, boot, objective;
							GetVehicleParamsEx(idveh, engine, lights, alarm, doors, bonnet, boot, objective);
							SetVehicleParamsEx(idveh, 0, 0, alarm, doors, bonnet, boot, objective);

							PutPlayerInVehicle(playerid, idveh, 0);

							UpdatePosisiDarahVehiclePlayer(idveh);
						}else{
							server_message(playerid, "Anda harus berada dekat salah satu lingkaran merah pengambilan reparasi.");
						}
					}
				}
			}
			return 1;
		}
		case DIALOG_MENU_DALAM_VEHICLE:
		{
			if(response){
				switch(listitem){
					case 0: // Info Vehicle
					{
						if(IsPlayerInAnyVehicle(playerid)){
							new vehid = GetPlayerVehicleID(playerid);
							format(pDialog[playerid], sizePDialog, WHITE"Info Kendaraan "YELLOW"%s "WHITE":\n\n", GetVehicleNameFromModel(PVeh[IDVehToPVeh[vehid]][pVehModel]));

							format(pDialog[playerid], sizePDialog, "%s"WHITE"Pemilik\t\t: "GREEN"%s\n\n", pDialog[playerid], PVeh[IDVehToPVeh[vehid]][pVehNamaPemilik]);

							format(pDialog[playerid], sizePDialog, "%s"YELLOW"Anda dapat menghidupkan/mematikan kendaraan jika anda memiliki kuncinya.", pDialog[playerid]);

							ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Info Kendaraan", pDialog[playerid], "Ok", "");
							return 1;
						}else{
							showDialogPesan(playerid, RED"Kendaraan tidak valid", "Anda telah keluar dari kendaraan.\nUntuk dapat melihat info kendaraan, anda harus berada didalam kendaraan tersebut.");
							return 1;
						}
					}
				}
			}
			return 1;
		}
		case DIALOG_MENU_RUMAH:
		{
			if(response){
				switch(listitem){
					case 0: // Inventory rumah
					{
						new house_id = GetPlayerVirtualWorld(playerid);
						inline responseQuery(){
							new total_item, kapasitas = HouseLevel[houseInfo[house_id][hLevel]][houseItemCapacity];
							cache_get_value_name_int(0, "total_item", total_item);
							if(total_item >= kapasitas){
								format(pDialog[playerid], sizePDialog, "Simpan Item\t"ORANGE"(%i/%i)\nAmbil Item", total_item, kapasitas);
							}else{
								format(pDialog[playerid], sizePDialog, "Simpan Item\t"GREEN"(%i/%i)\nAmbil Item", total_item, kapasitas);
							}
							ShowPlayerDialog(playerid, DIALOG_MENU_RUMAH_INVENTORY, DIALOG_STYLE_LIST, "Silahkan pilih aksi inventory rumah anda :", pDialog[playerid], "Pilih", "Batal");
						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT IFNULL(SUM(a.jumlah * b.kapasitas), 0) as total_item FROM house_inv_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_house = '%d'", house_id);
					}
					case 1: // Semua Furniture
					{
						SetPVarInt(playerid, "halaman", 0);
						tampilFurnitureHousePlayer(playerid, GetPlayerVirtualWorld(playerid), DIALOG_PILIH_FURNITURE_RUMAH);
						return 1;
					}
				}
			}
			return 1;
		}
		case DIALOG_PILIH_FURNITURE_RUMAH:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					tampilFurnitureHousePlayer(playerid, GetPlayerVirtualWorld(playerid), DIALOG_PILIH_FURNITURE_RUMAH);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
						tampilFurnitureHousePlayer(playerid, GetPlayerVirtualWorld(playerid), DIALOG_PILIH_FURNITURE_RUMAH);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						tampilFurnitureHousePlayer(playerid, GetPlayerVirtualWorld(playerid), DIALOG_PILIH_FURNITURE_RUMAH);
					}
					return 1;
				}

				SetPVarInt(playerid, "inv_indexlist", listitem);
				format(pDialog[playerid], sizePDialog, "Furniture terpilih "PINK"%s", inputtext);
				ShowPlayerDialog(playerid, DIALOG_OPTION_FURNITURE_RUMAH, DIALOG_STYLE_LIST, pDialog[playerid], "Tampilkan letak furniture\nEdit Furniture\nLepas dan simpan di inventory", "Pilih", "Batal");
			}
			return 1;
		}
		case DIALOG_OPTION_FURNITURE_RUMAH:
		{
			if(response){
				new idx = GetPVarInt(playerid, "inv_indexlist");
				new Float:pos[3], nama_furniture[50], id_house_furniture, id_furniture;
				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name_int(idx, "id", id_house_furniture);
				cache_get_value_name_int(idx, "id_furniture", id_furniture);
				cache_get_value_name(idx, "nama_furniture", nama_furniture);
				cache_get_value_name_float(idx, "pos_x", pos[0]);
				cache_get_value_name_float(idx, "pos_y", pos[1]);
				cache_get_value_name_float(idx, "pos_z", pos[2]);
				cache_delete(PlayerInfo[playerid][tempCache]);
				switch(listitem){
					case 0: // Tampilkan letak furniture
					{
						SetPlayerCheckpoint(playerid, pos[0], pos[1], pos[2], 2.0);
						PlayerInfo[playerid][activeMarker] = true;
						sendPesan(playerid, COLOR_PINK, "[FURNITURE] "WHITE"letak "GREEN"%s "WHITE" telah ditampilkan pada marker merah.", nama_furniture);
					}
					case 1: // Edit furniture
					{
						if(!IsPlayerInRangeOfPoint(playerid, 10.0, pos[0], pos[1], pos[2])){
							SendClientMessage(playerid, COLOR_PINK, "[FURNITURE] "WHITE"Anda harus berada minimal 10 meter dari furniture.");
							SendClientMessage(playerid, COLOR_PINK, "[FURNITURE] "WHITE"Gunakan fitur tampilkan lokasi untuk mengetahui letak furniture.");
							return 1;
						}
						new data[e_furniture];
						for(new i, maxval = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= maxval; ++i)
						{
							if(!IsValidDynamicObject(i)) continue;
							Streamer_GetArrayData(STREAMER_TYPE_OBJECT, i, E_STREAMER_EXTRA_ID, data);
							if(data[fID] == id_house_furniture) {
								EditingObject[playerid] = EDITING_FURNITURE;
								EditDynamicObject(playerid, i);
								return 1;
							}
						}
					}
					case 2: // Lepas dan simpan di inventory
					{
						tambahFurniturePlayer(playerid, id_furniture, 1);
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM house_furniture WHERE id = '%d'", id_house_furniture);
						mysql_tquery(koneksi, pQuery[playerid]);
						new data[e_furniture];
						for(new i, maxval = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= maxval; ++i)
						{
							if(!IsValidDynamicObject(i)) continue;
							Streamer_GetArrayData(STREAMER_TYPE_OBJECT, i, E_STREAMER_EXTRA_ID, data);
							if(data[fID] == id_house_furniture) {
								DestroyDynamicObject(i);
								SendClientMessage(playerid, COLOR_PINK, "[FURNITURE] "WHITE"Berhasil melepas dan memindahkan furniture ke inventory.");
								return 1;
							}
						}
					}
				}
			}
			return 1;
		}
		case DIALOG_MENU_RUMAH_INVENTORY:
		{
			if(response){
				switch(listitem){
					case 0: // Simpan Item dari Inventory tas
					{
						SetPVarInt(playerid, "halaman", 0);
						tampilInventoryItemPlayer(playerid, DIALOG_SIMPAN_ITEM_RUMAH);
					}
					case 1: // Ambil Item dari Inventory rumah
					{
						SetPVarInt(playerid, "halaman", 0);
						new house_id = GetPlayerVirtualWorld(playerid);
						tampilInventoryHousePlayer(playerid, house_id, DIALOG_AMBIL_ITEM_RUMAH, "Pilih item dari inventory rumah");
					}
				}
			}
			return 1;
		}
		case DIALOG_SIMPAN_ITEM_RUMAH:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					tampilInventoryItemPlayer(playerid, DIALOG_SIMPAN_ITEM_RUMAH);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
						tampilInventoryItemPlayer(playerid, DIALOG_SIMPAN_ITEM_RUMAH);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						tampilInventoryItemPlayer(playerid, DIALOG_SIMPAN_ITEM_RUMAH);
					}
					return 1;
				}

				SetPVarInt(playerid, "inv_indexlist", listitem);
				new nama_item[50], jumlah;

				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "jumlah", jumlah);
				cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "nama_item", nama_item);
				cache_unset_active();

				format(pDialog[playerid], sizePDialog, WHITE"Anda akan menyimpan item "GREEN"%s "WHITE"dari inventory anda ke inventory rumah.\n"WHITE"Banyak item yang tersedia "GREEN"%d\n"WHITE"Silahkan masukan jumlah yang ingin simpan :", nama_item, jumlah);
				ShowPlayerDialog(playerid, DIALOG_SIMPAN_ITEM_RUMAH_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah item yang ingin disimpan", pDialog[playerid], "Ambil", "Batal");
			}
			return 1;
		}
		case DIALOG_SIMPAN_ITEM_RUMAH_JUMLAH:
		{
			if(response){
				new nama_item[50], jumlah, id_item;

				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "jumlah", jumlah);
				cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "id_item", id_item);
				cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "nama_item", nama_item);
				cache_unset_active();

				new input_jumlah;
				if(sscanf(inputtext, "i", input_jumlah)) {
					format(pDialog[playerid], sizePDialog, RED"Inputan anda tidak valid\n"WHITE"Anda akan menyimpan item "GREEN"%s "WHITE"dari inventory anda ke inventory rumah.\n"WHITE"Banyak item yang tersedia "GREEN"%d\n"WHITE"Silahkan masukan jumlah yang ingin simpan :", nama_item, jumlah);
					return ShowPlayerDialog(playerid, DIALOG_SIMPAN_ITEM_RUMAH_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah item yang ingin disimpan", pDialog[playerid], "Ambil", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > jumlah){
					format(pDialog[playerid], sizePDialog, RED"Jumlah yang anda masukan tidak tepat\n"WHITE"Anda akan menyimpan item "GREEN"%s "WHITE"dari inventory anda ke inventory rumah.\n"WHITE"Banyak item yang tersedia "GREEN"%d\n"WHITE"Silahkan masukan jumlah yang ingin simpan :", nama_item, jumlah);
					return ShowPlayerDialog(playerid, DIALOG_SIMPAN_ITEM_RUMAH_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah item yang ingin disimpan", pDialog[playerid], "Ambil", "Batal");
				}
				// Karena sudah fix melewati yang sebelumnya maka bersihkan
				if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
				PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;
				
				// inline responseCek(){
				// 	printf("Masuk 1");
				// 	new total_item;
				// 	cache_get_value_name_int(0, "total_item", total_item);
				// 	printf("total item %d", total_item);
				// 	if((total_item + input_jumlah) > HouseLevel[houseInfo[GetPlayerVirtualWorld(playerid)][hLevel]][houseItemCapacity]){						
				// 		printf("Masuk 2");
				// 		format(pDialog[playerid], sizePDialog, "Maaf inventory rumah item anda tidak memiliki cukup ruang,\nuntuk menyimpan sebanyak "ORANGE"%i "WHITE"item. Sisa ruang yang anda miliki adalah "ORANGE"(%i/%i).", input_jumlah, total_item, HouseLevel[houseInfo[GetPlayerVirtualWorld(playerid)][hLevel]][houseItemCapacity]);

				// 		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory rumah anda penuh", pDialog[playerid], "Ok", "");
				// 	}else{
				// 		printf("Masuk 3");
				// 		tambahItemHouse(GetPlayerVirtualWorld(playerid), id_item, input_jumlah);
				// 		tambahItemPlayer(playerid, id_item, -input_jumlah);

				// 		format(pDialog[playerid], sizePDialog, "Anda berhasil menyimpan "YELLOW"%s"WHITE" ke dalam inventory rumah.\nSebanyak "YELLOW"%d"WHITE".\nAnda dapat mengambilnya kembali.", nama_item, input_jumlah);
				// 		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menyimpan barang", pDialog[playerid], "Ok", "");
				// 	}
				// 	resetPVarInventory(playerid);
				// }
				new house_id = GetPlayerVirtualWorld(playerid);
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(SUM(a.jumlah * b.kapasitas), 0) as total_item FROM house_inv_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_house = '%d'", house_id);
				mysql_tquery(koneksi, pQuery[playerid], "simpanItemKeInvenRumah", "iiiis", playerid, HouseLevel[houseInfo[GetPlayerVirtualWorld(playerid)][hLevel]][houseItemCapacity], id_item, input_jumlah, nama_item);
				// MySQL_TQueryInline(koneksi, using inline responseCek, "SELECT SUM(a.jumlah * b.kapasitas) as total_item FROM house_inv_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_house = '%d'", house_id);
			}
			return 1;
		}
		case DIALOG_AMBIL_ITEM_RUMAH:
		{
			if(response){
				new house_id = GetPlayerVirtualWorld(playerid);
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					tampilInventoryHousePlayer(playerid, house_id, DIALOG_AMBIL_ITEM_RUMAH, "Pilih item dari inventory rumah");
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);

						tampilInventoryHousePlayer(playerid, house_id, DIALOG_AMBIL_ITEM_RUMAH, "Pilih item dari inventory rumah");
					}else{
						SetPVarInt(playerid, "halaman", 0);
						tampilInventoryHousePlayer(playerid, house_id, DIALOG_AMBIL_ITEM_RUMAH, "Pilih item dari inventory rumah");
					}
					return 1;
				}

				SetPVarInt(playerid, "inv_indexlist", listitem);
				new nama_item[50], jumlah;

				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "jumlah", jumlah);
				cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "nama_item", nama_item);
				cache_unset_active();

				format(pDialog[playerid], sizePDialog, WHITE"Anda akan mengambil item "GREEN"%s "WHITE"dari inventory rumah anda.\n"WHITE"Banyak item yang tersedia "GREEN"%d\n"WHITE"Silahkan masukan jumlah yang ingin diambil :", nama_item, jumlah);
				ShowPlayerDialog(playerid, DIALOG_AMBIL_ITEM_RUMAH_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah item yang ingin diambil", pDialog[playerid], "Ambil", "Batal");
			}
			return 1;
		}
		case DIALOG_AMBIL_ITEM_RUMAH_JUMLAH:
		{
			if(response){
				new nama_item[50], jumlah, id_item;

				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "jumlah", jumlah);
				cache_get_value_name_int(GetPVarInt(playerid, "inv_indexlist"), "id_item", id_item);
				cache_get_value_name(GetPVarInt(playerid, "inv_indexlist"), "nama_item", nama_item);
				cache_unset_active();

				new input_jumlah;
				if(sscanf(inputtext, "i", input_jumlah)) {
					format(pDialog[playerid], sizePDialog, RED"Inputan anda tidak valid\n"WHITE"Anda akan mengambil item "GREEN"%s "WHITE"dari inventory rumah anda.\n"WHITE"Banyak item yang tersedia "GREEN"%d\n"WHITE"Silahkan masukan jumlah yang ingin diambil :", nama_item, jumlah);
					return ShowPlayerDialog(playerid, DIALOG_AMBIL_ITEM_RUMAH_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah item yang ingin diambil", pDialog[playerid], "Ambil", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > jumlah){
					format(pDialog[playerid], sizePDialog, RED"Jumlah yang anda masukan tidak tepat\n"WHITE"Anda akan mengambil item "GREEN"%s "WHITE"dari inventory rumah anda.\n"WHITE"Banyak item yang tersedia "GREEN"%d\n"WHITE"Silahkan masukan jumlah yang ingin diambil :", nama_item, jumlah);
					return ShowPlayerDialog(playerid, DIALOG_AMBIL_ITEM_RUMAH_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah item yang ingin diambil", pDialog[playerid], "Ambil", "Batal");
				}

				// Karena sudah fix melewati yang sebelumnya maka bersihkan
				cache_delete(PlayerInfo[playerid][tempCache]);
				PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;
				
				// inline responseQuery(){
				// 	new total_item;
				// 	cache_get_value_name_int(0, "total_item", total_item);
				// 	if((total_item + input_jumlah) > PlayerInfo[playerid][limitItem]){						
				// 		format(pDialog[playerid], sizePDialog, "Maaf inventory item anda tidak memiliki cukup ruang,\nuntuk menyimpan sebanyak "ORANGE"%i "WHITE"item. Sisa ruang yang anda miliki adalah "ORANGE"(%i/%i).", input_jumlah, total_item, PlayerInfo[playerid][limitItem]);

				// 		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory anda penuh", pDialog[playerid], "Ok", "");
				// 	}else{
				// 		tambahItemHouse(GetPlayerVirtualWorld(playerid), id_item, -input_jumlah);
				// 		tambahItemPlayer(playerid, id_item, input_jumlah);

				// 		format(pDialog[playerid], sizePDialog, "Anda berhasil mengambil "YELLOW"%s"WHITE" dari dalam inventory rumah.\nSebanyak "YELLOW"%d"WHITE".\nAnda dapat menyimpannya kembali selama anda memiliki cukup ruang.", nama_item, input_jumlah);
				// 		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mengambil barang", pDialog[playerid], "Ok", "");
				// 	}
				// 	resetPVarInventory(playerid);
				// }
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(SUM(a.jumlah * b.kapasitas), 0) as total_item FROM user_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_user = '%d'", PlayerInfo[playerid][pID]);
				mysql_tquery(koneksi, pQuery[playerid], "ambilItemDariInvenRumah", "iiis", playerid, id_item, input_jumlah, nama_item);
				// MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT SUM(a.jumlah * b.kapasitas) as total_item FROM user_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_user = '%d'", PlayerInfo[playerid][pID]);
			}
			return 1;
		}
		case DIALOG_MENU_PUSAT_PROPERTI:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						SetPVarInt(playerid, "halaman", 0);
						tampilSemuaRumahTerjual(playerid, DIALOG_PILIH_RUMAH_DIJUAL);
					}
				}
			}
			return 1;
		}
		case DIALOG_PILIH_RUMAH_DIJUAL:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					tampilSemuaRumahTerjual(playerid, DIALOG_PILIH_RUMAH_DIJUAL);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
						tampilSemuaRumahTerjual(playerid, DIALOG_PILIH_RUMAH_DIJUAL);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						tampilSemuaRumahTerjual(playerid, DIALOG_PILIH_RUMAH_DIJUAL);
					}
					return 1;
				}

				SetPVarInt(playerid, "index_terpilih", listitem);
				ShowPlayerDialog(playerid, DIALOG_OPTION_PILIH_RUMAH_DIJUAL, DIALOG_STYLE_LIST, "Pilih hal yang ingin dilakukan", "Tampilkan lokasi rumah pada map", "Pilih", "Batal");
			}
			return 1;
		}
		case DIALOG_OPTION_PILIH_RUMAH_DIJUAL:
		{
			if(response){
				switch(listitem){
					case 0: // Tampilkan lokasi rumah pada map
					{
						new id_house;
						cache_set_active(PlayerInfo[playerid][tempCache]);
						cache_get_value_name_int(GetPVarInt(playerid, "index_terpilih"), "id_house", id_house);
						// Selalu delete cache setelah digunakan
						cache_delete(PlayerInfo[playerid][tempCache]);
						PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

						SetPlayerCheckpoint(playerid, houseInfo[id_house][icon_x], houseInfo[id_house][icon_y], houseInfo[id_house][icon_z], 3.0);
						PlayerInfo[playerid][activeMarker] = true;

						server_message(playerid, WHITE"Lokasi rumah telah ditampilkan pada map.");
					}
				}
			}
			return 1;
		}
    }
	// Wiki-SAMP OnDialogResponse should return 0
    return 0;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid){
	if(clickedid == Text:INVALID_TEXT_DRAW){
		hideTextDrawMyInfo(playerid);
		hideTextDrawShowItem(playerid);
		if(PlayerInfo[playerid][onSelectedTextdraw]) CancelSelectTextDraw(playerid);
		PlayerInfo[playerid][onSelectedTextdraw] = false;
	}
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(playertextid == PlayerText:INVALID_TEXT_DRAW){
		hideTextDrawMyInfo(playerid);
		hideTextDrawShowItem(playerid);
		if(PlayerInfo[playerid][onSelectedTextdraw]) CancelSelectTextDraw(playerid);
		PlayerInfo[playerid][onSelectedTextdraw] = false;
		return 1;
	}
    else if(playertextid == showItem[playerid][4])
    {
		if(PlayerInfo[playerid][onSelectedTextdraw]) CancelSelectTextDraw(playerid);
		hideTextDrawShowItem(playerid);
		PlayerInfo[playerid][onSelectedTextdraw] = false;
        return 1;
    }else if(playertextid == myInfo[playerid][7]){
		if(PlayerInfo[playerid][onSelectedTextdraw]) CancelSelectTextDraw(playerid);
		hideTextDrawMyInfo(playerid);
		PlayerInfo[playerid][onSelectedTextdraw] = false;
		return 1;
	}
    return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_JUMP) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT){
		new Float:pos[3];
		if(getStatusMinumPemain(playerid) < 5){
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			ClearAnimations(playerid);
			server_message(playerid, "Anda tidak memiliki cukup energi untuk melompat.");
		}else{
			setStatusMinumPemain(playerid, getStatusMinumPemain(playerid) - 0.5);
		}
	}else if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && PRESSED(KEY_SUBMISSION)){
		new vehid = GetPlayerVehicleID(playerid);
		if(Iter_Contains(PVehIterator, IDVehToPVeh[vehid])){
			new idpv = IDVehToPVeh[vehid];
			if(PVeh[idpv][pVehPemilik] != PlayerInfo[playerid][pID] && !( Iter_Contains(PVehKeys[playerid], idpv) && PVehKeysTime[playerid][idpv] > gettime() )){
				server_message(playerid, "Anda tidak memiliki kunci mobil ini.");
				return 1;
			}
		}

		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective);
		if(engine) {
			GameTextForPlayer(playerid, "~w~Mesin kendaraan ~r~dimatikan", 1000, 3);
			SetVehicleParamsEx(vehid, 0, 0, alarm, doors, bonnet, boot, objective);
		}
		else {
			GameTextForPlayer(playerid, "~w~Mesin kendaraan ~g~dihidupkan", 1000, 3);
			SetVehicleParamsEx(vehid, 1, 1, alarm, doors, bonnet, boot, objective);
		}
	}else if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && PRESSED(KEY_YES)){
		if(IsPlayerInDynamicArea(playerid, areaToll[0]) && !isTollUsed[0]){
			if(getUangPlayer(playerid) < HARGA_TOLL) {
				return sendPesan(playerid, COLOR_RED, "[TOLL] "WHITE"Uang anda tidak cukup, harga toll "GREEN"$%d", HARGA_TOLL);
			}
			givePlayerUang(playerid, -HARGA_TOLL);
			GameTextForPlayer(playerid, "~w~Silahkan ~g~lewat", 1500, 3);
			MoveDynamicObject(palangToll[0], 48.61440, -1518.50549, 4.97830, 4.0, 0.00000, 90.00000, 85.00000);
			isTollUsed[0] = 1;
			SetPreciseTimer("tutupToll", 3000, false, "i", 0);
		}else if(IsPlayerInDynamicArea(playerid, areaToll[1]) && !isTollUsed[1]){
			if(getUangPlayer(playerid) < HARGA_TOLL) {
				return sendPesan(playerid, COLOR_RED, "[TOLL] "WHITE"Uang anda tidak cukup, harga toll "GREEN"$%d", HARGA_TOLL);
			}
			givePlayerUang(playerid, -HARGA_TOLL);
			GameTextForPlayer(playerid, "~w~Silahkan ~g~lewat", 1500, 3);
			MoveDynamicObject(palangToll[1], 58.10060, -1545.19714, 5.09970, 4.0, 0.00000, -90.00000, 85.00000);
			isTollUsed[1] = 1;
			SetPreciseTimer("tutupToll", 3000, 0, "i", 1);

		// TOLL LS LV
		}else if(IsPlayerInDynamicArea(playerid, areaToll_LSLV[0]) && !isTollUsed_LSLV[0]){
			// Masuk ke LS dari LV
			if(getUangPlayer(playerid) < HARGA_TOLL) {
				return sendPesan(playerid, COLOR_RED, "[TOLL] "WHITE"Uang anda tidak cukup, harga toll "GREEN"$%d", HARGA_TOLL);
			}
			givePlayerUang(playerid, -HARGA_TOLL);
			GameTextForPlayer(playerid, "~w~Silahkan ~g~lewat", 1500, 3);
			MoveDynamicObject(palangToll_LSLV[0], 1745.46155, 551.11792, 26.02680, 1.0, 0.00000, 0.00000, -18.16000);
			isTollUsed_LSLV[0] = 1;
			SetPreciseTimer("tutupToll", 3000, 0, "i", 3);
		}else if(IsPlayerInDynamicArea(playerid, areaToll_LSLV[1]) && !isTollUsed_LSLV[1]){
			// Masuk ke LV dari LS
			if(getUangPlayer(playerid) < HARGA_TOLL) {
				return sendPesan(playerid, COLOR_RED, "[TOLL] "WHITE"Uang anda tidak cukup, harga toll "GREEN"$%d", HARGA_TOLL);
			}
			givePlayerUang(playerid, -HARGA_TOLL);
			GameTextForPlayer(playerid, "~w~Silahkan ~g~lewat", 1500, 3);
			MoveDynamicObject(palangToll_LSLV[1], 1753.44653, 558.05688, 25.40680, 1.0, 0.00000, 0.00000, -198.00000);
			isTollUsed_LSLV[1] = 1;
			SetPreciseTimer("tutupToll", 3000, 0, "i", 4);
		}
	}else if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && PRESSED(KEY_NO)){
		if(lastHousePickup[playerid] < 0 || lastHousePickup[playerid] >= MAX_HOUSES) return 1;
		new id,
			Float:x,
			Float:y,
			Float:z;
		id = houseId[lastHousePickup[playerid]];

		x = houseInfo[id][icon_x];
		y = houseInfo[id][icon_y];
		z = houseInfo[id][icon_z];
		if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) {
			new id_level = houseInfo[id][hLevel];
			if(houseInfo[id][hKunci] != 1){
				pindahkanPemain(playerid, HouseLevel[id_level][intSpawn][0], HouseLevel[id_level][intSpawn][1], HouseLevel[id_level][intSpawn][2], HouseLevel[id_level][intSpawn][3], HouseLevel[id_level][intSpawnInterior], id);
				SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil masuk rumah!");
			}else{
				if(houseInfo[id][hOwner] == PlayerInfo[playerid][pID]){
					pindahkanPemain(playerid, HouseLevel[id_level][intSpawn][0], HouseLevel[id_level][intSpawn][1], HouseLevel[id_level][intSpawn][2], HouseLevel[id_level][intSpawn][3], HouseLevel[id_level][intSpawnInterior], id);
					SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil masuk rumah!");
				}else{
					SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "RED"Maaf rumah terkunci dan tidak dapat masuk!");
				}
			}
		}
		return 1;
	}
    return 1;
}

public OnPlayerSpawn(playerid)
{
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerSpawn terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif	
	if(IsPlayerNPC(playerid)) return 1;

	if(!PlayerInfo[playerid][preloadAnim]) {
		PreloadAnimLib(playerid,"BAR");
		PreloadAnimLib(playerid,"BOMBER");
		PreloadAnimLib(playerid,"RAPPING");
		PreloadAnimLib(playerid,"SHOP");
		PreloadAnimLib(playerid,"BEACH");
		PreloadAnimLib(playerid,"SMOKING");
		PreloadAnimLib(playerid,"FOOD");
		PreloadAnimLib(playerid,"ON_LOOKERS");
		PreloadAnimLib(playerid,"DEALER");
		PreloadAnimLib(playerid,"CRACK");
		PreloadAnimLib(playerid,"CARRY");
		PreloadAnimLib(playerid,"COP_AMBIENT");
		PreloadAnimLib(playerid,"PARK");
		PreloadAnimLib(playerid,"INT_HOUSE");
		PreloadAnimLib(playerid,"PED");
		PreloadAnimLib(playerid,"VENDING");
		PreloadAnimLib(playerid,"CHAINSAW");
		PlayerInfo[playerid][preloadAnim] = 1;
	}


	houseNotif[playerid] = -1;

	// Tambang
	if(IsPlayerAttachedObjectSlotUsed(playerid, MINING_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, MINING_ATTACH_INDEX);
	KillTimer(PlayerAction[playerid][timerNambang]);
	PlayerAction[playerid][sedangNambang] = false;

	PlayerInfo[playerid][onSelectedTextdraw] = false;

	spawnPemain(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerDeath terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif

	PlayerInfo[playerid][sudahSpawn] = false;
	hideHUDStats(playerid);
	
	PlayerInfo[playerid][onSelectedTextdraw] = false;

	resetPlayerToDo(playerid);

	new random_spawn = random(sizeof(SPAWN_POINT));
	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], SPAWN_POINT[random_spawn][SPAWN_POINT_X], SPAWN_POINT[random_spawn][SPAWN_POINT_Y], SPAWN_POINT[random_spawn][SPAWN_POINT_Z], SPAWN_POINT[random_spawn][SPAWN_POINT_A], 0, 0, 0, 0, 0, 0);

	if(IsPlayerInAnyVehicle(playerid)){
		new vehicleid = GetPlayerVehicleID(playerid);
		if(Iter_Contains(IDVehToPVehIterator, vehicleid)){
			new Float:darah;
			GetVehicleHealth(vehicleid, darah);

			if(!IsVehicleFlipped(vehicleid) && darah > 300)
			{
				new idpv = IDVehToPVeh[vehicleid];
				GetVehiclePos(vehicleid, PVeh[idpv][pVehCoord][0], PVeh[idpv][pVehCoord][1], PVeh[idpv][pVehCoord][2]);
				GetVehicleZAngle(vehicleid, PVeh[idpv][pVehCoord][3]);
				PVeh[idpv][pVehDarah] = darah;
				UpdatePosisiDarahVehiclePlayer(vehicleid);
			}
		}
	}

	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerRequestClass terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif

	if(IsPlayerNPC(playerid)) return 1;
	print("Request Class Fungsi");
	if(PlayerInfo[playerid][sudahLogin]) {
		print("Request Class Called");
		spawnPemain(playerid);
		return 1;
	}
	// Interpolate Camera untuk login
	// Spawn di request class dihilangin
	// SetSpawnInfo(playerid, NO_TEAM, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	// SpawnPlayer(playerid);
	return 0;
}

public OnPlayerRequestSpawn(playerid){
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerRequestSpawn terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif	
	if(PlayerInfo[playerid][sudahLogin]) return 1;
	return 0;
}

/*
	UNTUK HILANGKAN INVALID INDEX PARAMETER (BAD ENTRY POINT) BIARKAN SAJA FUNGSI MAIN
*/
main( ) { }

public OnGameModeInit()
{
	// Initializing iterator
	Iter_Init(PVehKeys);

	koneksi = mysql_connect_file();
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

	printf("[PICKUP] Load semua pickup...");
	loadAllPickup();
	printf("[PICKUP] Sukses load pickup!");

	printf("[CHECKPOINT] Load semua checkpoint...");
	loadAllCP();
	printf("[CHECKPOINT] Sukses load checkpoint!");

	printf("[AREA] Load semua area...");
	loadAllArea();
	printf("[AREA] Sukses load area!");

	printf("[MAP ICON] Load semua map icon...");
	loadAllMapIcon();
	printf("[MAP ICON] Sukses load map icon!");

	printf("[HOUSE LEVEL] Load semua HOUSE LEVEL...");
	loadAllHouseLevel();
	printf("[HOUSE LEVEL] Sukses load HOUSE LEVEL!");

	printf("[HOUSE] Load semua house...");
	resetAllHouse();
	printf("[HOUSE] Sukses load house!");

	printf("[PAPAN] Load semua papan...");
	LoadBoards();
	printf("[PAPAN] Sukses load papan!");

	printf("[VEHICLE] Load vehicle dealer");
	LoadVehicleDealer();
	printf("[VEHICLE] Sukses load vehicle dealer.");
	
	SetGameModeText("EL v0.5");
	// ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	ShowNameTags(1);
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	
	printf("[TEXTDRAW] Load textdraw global..");
	loadTextdrawGlobal();
	printf("[TEXTDRAW] Sukses load textdraw!");

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

    // Sweeper Vehicle
    vehicleSweeper[0] = CreateVehicle(574, 708.4822, -1193.1827, 15.0324, 0.0000, -1, -1, 60);
	vehicleSweeper[1] = CreateVehicle(574, 706.6257, -1196.5216, 14.9840, 0.0000, -1, -1, 60);
	vehicleSweeper[2] = CreateVehicle(574, 704.5869, -1199.6705, 14.9557, 0.0000, -1, -1, 60);
	Iter_Add(vehicleSweeper, vehicleSweeper[0]);
	Iter_Add(vehicleSweeper, vehicleSweeper[1]);
	Iter_Add(vehicleSweeper, vehicleSweeper[2]);


	// SIM Vehicle
	vehicleSIM[0] = CreateVehicle(596, 1584.9463, -1606.8075, 13.1038, 180.6711, -1, -1, 60);
	vehicleSIM[1] = CreateVehicle(596, 1580.1217, -1607.0674, 13.1037, 179.7378, -1, -1, 60);
	vehicleSIM[2] = CreateVehicle(596, 1575.1067, -1606.8228, 13.1040, 179.4362, -1, -1, 60);
	Iter_Add(vehicleSIM, vehicleSIM[0]);
	Iter_Add(vehicleSIM, vehicleSIM[1]);
	Iter_Add(vehicleSIM, vehicleSIM[2]);
	return 1;
}

public OnGameModeExit(){
	foreach(new i : Player){
		if(i != INVALID_PLAYER_ID)
			Kick(i);
	}
	unloadTextdrawGlobal();
	unloadAllHouse();
	UnloadBoards();
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
	new vehid = GetPlayerVehicleID(playerid);
	if(newstate == PLAYER_STATE_DRIVER && Iter_Contains(DVehIterator, vehid)){
		format(pDialog[playerid], sizePDialog, CYAN"*********************************************************************************\n\n", pDialog[playerid]);
		format(pDialog[playerid], sizePDialog, "%s"ORANGE"Kendaraan ini dijual dengan informasi sebagai berikut :\n\n", pDialog[playerid]);
		format(pDialog[playerid], sizePDialog, "%s"PURPLE"Nama Kendaraan: "WHITE"%s\n", pDialog[playerid], GetVehicleNameFromModel(DVeh[vehid][dVehModel]));
		format(pDialog[playerid], sizePDialog, "%sHarga: "GREEN"$%d\n\n", pDialog[playerid], DVeh[vehid][dVehHarga]);
		format(pDialog[playerid], sizePDialog, "%s"YELLOW"Anda ingin membeli kendaraan ini ?\n\n"CYAN"*********************************************************************************\n", pDialog[playerid]);
		ShowPlayerDialog(playerid, DIALOG_BELI_KENDARAAN_DEALER, DIALOG_STYLE_MSGBOX, "Kendaraan ini dijual.", pDialog[playerid], GREEN"Beli", GREY"Tidak");
	}else if(newstate == PLAYER_STATE_PASSENGER && Iter_Contains(DVehIterator, vehid)){
		error_command(playerid, "Tidak dapat menumpangi kendaraan yang sedang dijual.");
		RemovePlayerFromVehicle(playerid);
	}
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER){
		ShowPlayerSpeedo(playerid);
	}
	else if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_ONFOOT){
		HidePlayerSpeedo(playerid);
	}
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_PASSENGER){
		if(Iter_Contains(vehicleSIM, vehid)){
			if(testSim[playerid] == 1 && vehicleIdSIM[playerid] == vehid){
				KillTimer(todoTimer[playerid]);
			}else if(testSim[playerid] == 1 && vehicleIdSIM[playerid] != vehid){
				error_command(playerid, "Anda salah menaiki kendaaraan, silahkan kembali ke kendaraan sebelumnya.");
				RemovePlayerFromVehicle(playerid);
			}else if(testSim[playerid] == 0){
				error_command(playerid, "Tidak dapat menumpangi kendaraan untuk Ujian Praktik SIM.");
				RemovePlayerFromVehicle(playerid);
			}
		}else if(Iter_Contains(vehicleSweeper, vehid)){
			if(sweeperJob[playerid] == 0 && usedSweeper[vehid] != 1){
				ShowPlayerDialog(playerid, DIALOG_JOB_SWEEPER, DIALOG_STYLE_MSGBOX, "Sweeper Job", WHITE"Apakah anda ingin bekerja sebagai "GREEN"Sweeper"WHITE"? Jika anda ingin bekerja klik "GREEN"Setuju"WHITE" untuk memulai.", "Setuju", "Batal");
			}else if(sweeperJob[playerid] == 1 && sweeperId[playerid] == vehid){
				KillTimer(todoTimer[playerid]);
			}else if(sweeperJob[playerid] == 1 && sweeperId[playerid] != vehid){
				error_command(playerid, "Anda salah menaiki kendaaraan, silahkan kembali ke kendaraan sebelumnya.");
				RemovePlayerFromVehicle(playerid);
			}else if(sweeperJob[playerid] == 0 && usedSweeper[vehid] == 1){
				error_command(playerid, "Tidak dapat menumpangi kendaraan yang sedang melakukan pekerjaan Sweeper.");
				RemovePlayerFromVehicle(playerid);
			}
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(Iter_Contains(vehicleSweeper, vehicleid) && sweeperJob[playerid] == 1 && sweeperId[playerid] == vehicleid){
		SendClientMessage(playerid, COLOR_GREEN, "[JOB] "RED"Anda keluar dari kendaraan, silahkan kembali bekerja! "WHITE"Sebelum 30 detik atau anda berhenti bekerja.");
		todoTimer[playerid] = SetPreciseTimer("todoExit", 30000, false, "ii", playerid, sweeperId[playerid]);
	}else if(Iter_Contains(vehicleSIM, vehicleid) && testSim[playerid] == 1 && vehicleIdSIM[playerid] == vehicleid){
		SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "RED"Anda keluar dari kendaraan, silahkan kembali praktik! "WHITE"Sebelum 30 detik atau anda gagal Ujian Praktik SIM.");
		todoTimer[playerid] = SetPreciseTimer("todoExit", 30000, false, "ii", playerid, vehicleIdSIM[playerid]);
	}else if(Iter_Contains(IDVehToPVehIterator, vehicleid)){
		new Float:darah;
		GetVehicleHealth(vehicleid, darah);

		if(!IsVehicleFlipped(vehicleid) && darah > 300)
		{
			new idpv = IDVehToPVeh[vehicleid];
			GetVehiclePos(vehicleid, PVeh[idpv][pVehCoord][0], PVeh[idpv][pVehCoord][1], PVeh[idpv][pVehCoord][2]);
			GetVehicleZAngle(vehicleid, PVeh[idpv][pVehCoord][3]);
			PVeh[idpv][pVehDarah] = darah;
			UpdatePosisiDarahVehiclePlayer(vehicleid);
		}
	}
    return 1;
}

public OnPlayerText(playerid, text[]){
	format(msg,sizeof(msg), "[%d] %s : %s", playerid,  PlayerInfo[playerid][pPlayerName], text);
	ProxDetector(30.0, playerid, msg, COLOR_WHITE);
	format(msg,sizeof(msg), "berkata: %s", text);
	SetPlayerChatBubble(playerid, msg, -1, 40.0, 5000);
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1000);
	// Wiki Samp - OnPlayerText
	// Return 1 - Mengirimkan pesan default
	// Return 0 - Mengirimkan pesan yang sudah dicustom saja, tanpa menjalankan perintah default pesan
	return 0; // ignore the default text and send the custom one
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid){
	if(pickupid == PU_tempatFoto_in[0]){
		pindahkanPemain(playerid, -203.9351, -25.4899, 1002.2734, 330.6535, 16, VW_tempatFoto_1, false);
		return 1;
	}else if(pickupid == PU_tempatFoto_in[1]){
		pindahkanPemain(playerid, -203.9351, -25.4899, 1002.2734, 330.6535, 16, VW_tempatFoto_2, false);
		return 1;
	}
	else if(pickupid == PU_tempatFoto_out){
		switch(GetPlayerVirtualWorld(playerid)){
			case VW_tempatFoto_1:
			{
				pindahkanPemain(playerid, 1112.2352, -1372.2939, 13.9844, 178.5421, 0, 0, true);
				return 1;
			}
			case VW_tempatFoto_2:
			{
				pindahkanPemain(playerid, 1553.7258, -1448.3143, 13.5469, 359.9397, 0, 0, false);
				return 1;
			}
		}
		return 1;
	}
	else if(pickupid == PU_tempatMakan_in[0]){
		pindahkanPemain(playerid, 365.5712,-8.7934,1001.8516,351.2707, 9, VW_tempatMakan_1, false);
		return 1;
	}
	else if(pickupid == PU_tempatMakan_in[1]){
		pindahkanPemain(playerid, 365.5712,-8.7934,1001.8516,351.2707, 9, VW_tempatMakan_2, false);
		return 1;
	}
	else if(pickupid == PU_tempatMakan_out){
		switch(GetPlayerVirtualWorld(playerid)){
			case VW_tempatMakan_1:
			{
				pindahkanPemain(playerid, 924.8441, -1353.0880, 13.3768, 89.3053, 0, 0, true);
				return 1;
			}
			case VW_tempatMakan_2:
			{
				pindahkanPemain(playerid, 814.8109,-1616.3394,13.6281, 245.7708, 0,0, true);
				return 1;	
			}
		}
		return 1;
	}
	else if(pickupid == PU_miniMarket[0][ENTER_PICKUP]){
		pindahkanPemain(playerid, -25.884498, -185.868988, 1003.546875, 0.0, 17, 1, false);
		return 1;
	}
	else if(pickupid == PU_miniMarket[0][EXIT_PICKUP]){
		pindahkanPemain(playerid, 1353.8392, -1757.3990, 13.5078, 269.0087, 0, 0, false);
		return 1;
	}
	else if(pickupid == PU_tempatBaju[0][ENTER_PICKUP]){
		pindahkanPemain(playerid, 161.3910, -93.1592, 1001.8047, 0.0, 18, 1, false);
		return 1;
	}
	else if(pickupid == PU_tempatBaju[0][EXIT_PICKUP]){
		pindahkanPemain(playerid, 500.7141, -1357.8710, 16.1328, 336.5217, 0, 0, false);
		return 1;
	}
	else if(pickupid == housePickup[houseId[pickupid]]){
		new id = houseId[pickupid];
		lastHousePickup[playerid] = pickupid;
		if(houseNotif[playerid] != id){
			houseNotif[playerid] = id;
			format(msg, 256, "[RUMAH]"WHITE" Ketik "GREEN"/inforumah"WHITE" untuk melihat info tentang rumah.");
	    	SendClientMessage(playerid, COLOR_GREEN, msg);
		}
	}else if(pickupid == PU_cityHallMasuk[0] || pickupid == PU_cityHallMasuk[1] || pickupid == PU_cityHallMasuk[2]){
		pindahkanPemain(playerid, -501.2855,289.1127,2001.0950, 357.5606, 1, 1, true);
		return 1;
	}else if(pickupid == PU_cityHallKeluar){
		new rand_idx = random(sizeof(SPAWN_POINT_OUT_CH));
		pindahkanPemain(playerid, SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_X],SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_Y],SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_Z],SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_A], SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_INTERIOR], SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_VW], true);
		return 1;
	}else if(pickupid == PU_bankLS[ENTER_PICKUP]){
		pindahkanPemain(playerid, 1417.1097,-982.6887,-55.2764,180.0692, 1, 1, true);
		return 1;
	}else if(pickupid == PU_bankLS[EXIT_PICKUP]){
		new rand_idx = random(sizeof(SP_OUT_BANK_LS));
		pindahkanPemain(playerid, SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_X],SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_Y],SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_Z],SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_A], SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_INTERIOR], SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_VW], true);
		return 1;
	}else if(pickupid >= PU_tempatKeluarRumah[0] && pickupid <= PU_tempatKeluarRumah[1]){
		new id_rumah = GetPlayerVirtualWorld(playerid);
		pindahkanPemain(playerid, houseInfo[id_rumah][icon_x], houseInfo[id_rumah][icon_y], houseInfo[id_rumah][icon_z], houseInfo[id_rumah][last_a], 0, 0, true);
		return 1;
	}else if(pickupid == PU_policeDept_in[0]){
		pindahkanPemain(playerid, 246.6298,64.2289,1003.6406,6.9548, 6, 1, false);
		return 1;
	}else if(pickupid == PU_policeDept_out[0]){
		pindahkanPemain(playerid, 1552.9425,-1675.7598,16.1953,92.6288, 0, 0, false);
		return 1;
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid){
	if(checkpointid == CP_tempatFoto){
		new jam, menit, detik;
		gettime(jam, menit, detik);
		if(GetPlayerVirtualWorld(playerid) == VW_tempatFoto_2 && !(jam >= 20 || jam <= 5)) return SendClientMessage(playerid, COLOR_RED, "Maaf Tempat foto "nama_B" saat ini tutup! Silahkan kembali antara jam 20.00 hingga 05.59.");

		new harga = (GetPlayerVirtualWorld(playerid) == VW_tempatFoto_2) ? 10 : 20;

		format(pDialog[playerid], sizePDialog, WHITE"Berapa banyak foto yang ingin anda cetak?\n"YELLOW"Harga 1 foto adalah "GREEN"%d", harga);

		ShowPlayerDialog(playerid, DIALOG_TEMPAT_FOTO, DIALOG_STYLE_INPUT, "Foto dan Cetak", pDialog[playerid], "Cetak", "Batal");
		return 1;
	}else if(checkpointid >= CP_spotBarangMarket[0] && checkpointid <= CP_spotBarangMarket[sizeof(CP_spotBarangMarket) - 1]){
		showDialogBeliBarang(playerid);
		return 1;
	}else if(checkpointid >= CP_spawnReparasi[0] && checkpointid <= CP_spawnReparasi[sizeof(CP_spawnReparasi) - 1]){
		if(!IsPlayerInAnyVehicle(playerid)){
			showDialogAmbilMobilReparasi(playerid);
		}
		return 1;
	}else if(checkpointid == CP_spotGantiSkin){
		ShowPlayerDialog(playerid, DIALOG_REFRESH_SKIN, DIALOG_STYLE_MSGBOX, "Refresh skin anda", "Apakah anda yakin ingin mensinkronisasikan kembali skin anda?\n\n"YELLOW"** Skin yang akan direfresh adalah skin yang sudah anda use pada inventory anda.\nJika anda belum memilih skin yang ingin anda gunakan, anda dapat membuka inventory\nLalu pilih skin yang ingin anda gunakan.", "Ganti", "Batal");
		return 1;
	}else if(checkpointid == CP_spotBeliSkin[0] || checkpointid == CP_spotBeliSkin[1] || checkpointid == CP_spotBeliSkin[2]){
		ShowPlayerDialog(playerid, DIALOG_TANYA_INGIN_BELI_SKIN, DIALOG_STYLE_MSGBOX, WHITE"Ingin beli skin?", "Apakah anda ingin membeli "YELLOW"skin normal "WHITE"dengan harga "GREEN"2500 "WHITE"per skin?", "Beli", "Batal");
		return 1;
	}else if(checkpointid == CP_resepsionisCityHall){
		showDialogResepsionis(playerid);
		return 1;
	}else if(checkpointid == CP_tellerBankLS[0] || checkpointid == CP_tellerBankLS[1]){
		showDialogTellerBank(playerid);
		return 1;
	// ID nya harus simetris (berurut dengan setiap |x2 - x1| = 1)
	}else if(checkpointid >= CP_ATM[0] && checkpointid <= CP_ATM[sizeof(CP_ATM) - 1]){
		if(isnull(PlayerInfo[playerid][nomorRekening])) return SendClientMessage(playerid, COLOR_RED, "[ATM] "WHITE"Anda tidak dapat menggunakan ATM jika tidak memiliki rekening");
		showDialogATM(playerid);
		return 1;
	// ID nya harus simetris (berurut dengan setiap |x2 - x1| = 1)
	}else if(checkpointid >= CP_Tambang[0] && checkpointid <= CP_Tambang[sizeof(CP_Tambang) - 1]) {
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return error_command(playerid, "Anda harus berjalan kaki untuk dapat menambang!");
		if(PlayerInfo[playerid][sisaPalu] <= 0) return error_command(playerid, "Anda kehabisan kesempatan menambang, gunakan item Palu Tambang untuk menambah kesempatan anda.");
		ShowPlayerDialog(playerid, DIALOG_TANYA_TAMBANG, DIALOG_STYLE_MSGBOX, "Ingin menambang", "Apakah anda ingin menambang?\n"YELLOW"Note : Anda membutuhkan cangkul untuk menambang.", "Ya", "Tidak");
	}else if(checkpointid == CP_beliMakanCepatSaji){
		showDialogTempatMakan(playerid);
		return 1;
	}else if(checkpointid == CP_simRegis[0]){
		showDialogSimRegis(playerid);
		return 1;
	}else if(checkpointid == CP_simPraktik[0]){
		showDialogSimPraktik(playerid);
		return 1;
	}else if(checkpointid == CP_pusatProperti[0]){
		ShowPlayerDialog(playerid, DIALOG_MENU_PUSAT_PROPERTI, DIALOG_STYLE_LIST, "Apa yang ingin anda tanya :", "Lihat semua rumah yang terjual", "Ok", "Batal");
		return 1;
	}
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid){
	new vehid = GetPlayerVehicleID(playerid);
	if(Iter_Contains(vehicleSweeper, vehid) && sweeperJob[playerid] == 1 && sweeperId[playerid] == vehid){
		if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper1)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper2, CP_sweeper3, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper2)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper3, CP_sweeper4, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper3)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper4, CP_sweeper5, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper4)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper5, CP_sweeper6, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper5)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper6, CP_sweeper7, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper6)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper7, CP_sweeper8, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper7)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper8, CP_sweeper9, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper8)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper9, CP_sweeper10, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper9)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper10, CP_sweeper11, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper10)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper11, CP_sweeper12, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper11)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper12, CP_sweeper13, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper12)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper13, CP_sweeper14, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper13)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper14, CP_sweeper15, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper14)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper15, CP_sweeper16, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper15)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper16, CP_sweeper17, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper16)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper17, CP_sweeper18, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper17)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper18, CP_sweeper19, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper18)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper19, CP_sweeper20, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper19)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper20, CP_sweeper21, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper20)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper21, CP_sweeper22, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper21)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper22, CP_sweeper23, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper22)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper23, CP_sweeper24, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper23)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper24, CP_sweeper25, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper24)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper25, CP_sweeper26, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper25)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper26, CP_sweeper27, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper26)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper27, CP_sweeper28, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper27)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper28, CP_sweeper29, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper28)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper29, CP_sweeper30, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper29)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper30, CP_sweeper31, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper30)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper31, CP_sweeper32, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper31)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper32, CP_sweeper33, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper32)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper33, CP_sweeper34, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper33)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper34, CP_sweeper35, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper34)){
			SetPlayerRaceCheckpoint(playerid, 1, CP_sweeper35, 0.0, 0.0, 0.0, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper35)){
			addGajiPemain(playerid, 100, "Pembersih jalan (sweeper)");
			GameTextForPlayer(playerid, "~g~Pekerjaan Selesai", 2000, 3);
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", GREEN"Anda telah berhasil menyelesaikan pekerjaan!\n"WHITE"Upah sudah terkirim ke rekening gaji anda sebesar "GREEN"$100\n"WHITE"Silahkan ambil gaji anda ke Bank terdekat.", "Ok", "");
			DisablePlayerRaceCheckpoint(playerid);
			SetVehicleToRespawn(sweeperId[playerid]);
			KillTimer(todoTimer[playerid]);
			KillTimer(todoTimeout[playerid]);
			sweeperJob[playerid] = 0;
			sweeperId[playerid] = -1;
			usedSweeper[vehid] = 0;
		}
	}
	if(Iter_Contains(vehicleSIM, vehid) && testSim[playerid] == 1 && vehicleIdSIM[playerid] == vehid){
		if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS1)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS2, CP_simLS3, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS2)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS3, CP_simLS4, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS3)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS4, CP_simLS5, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS4)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS5, CP_simLS6, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS5)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS6, CP_simLS7, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS6)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS7, CP_simLS8, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS7)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS8, CP_simLS9, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS8)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS9, CP_simLS10, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS9)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS10, CP_simLS11, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS10)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS11, CP_simLS12, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS11)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS12, CP_simLS13, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS12)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS13, CP_simLS14, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS13)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS14, CP_simLS15, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS14)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS15, CP_simLS16, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS15)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS16, CP_simLS17, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS16)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS17, CP_simLS18, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS17)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS18, CP_simLS19, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS18)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS19, CP_simLS20, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS19)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS20, CP_simLS21, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS20)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS21, CP_simLS22, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS21)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS22, CP_simLS23, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS22)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS23, CP_simLS24, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS23)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS24, CP_simLS25, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS24)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS25, CP_simLS26, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS25)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS26, CP_simLS27, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS26)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS27, CP_simLS28, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS27)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS28, CP_simLS29, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS28)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS29, CP_simLS30, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS29)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS30, CP_simLS31, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS30)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS31, CP_simLS32, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS31)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS32, CP_simLS33, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS32)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS33, CP_simLS34, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS33)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS34, CP_simLS35, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS34)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS35, CP_simLS36, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS35)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS36, CP_simLS37, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS36)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS37, CP_simLS38, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS37)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS38, CP_simLS39, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS38)){
			SetPlayerRaceCheckpoint(playerid, 1, CP_simLS39, 0.0, 0.0, 0.0, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS39)){
			if(poinSim[playerid] <= 80){
				givePlayerUang(playerid, -100);
				GameTextForPlayer(playerid, "~g~Praktik SIM Selesai", 2000, 3);
				format(pDialog[playerid], sizePDialog, WHITE"Anda mendapatkan poin sebesar "GREEN"%d"WHITE".\nSilahkan mencoba kembali ketika anda sudah siap.\n\nTerimakasih, Salam hangat "ORANGE"Kantor Polisi Lost Santos", poinSim[playerid]);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Gagal Praktik SIM", pDialog[playerid], "Ok", "");
				DisablePlayerRaceCheckpoint(playerid);
				SetVehicleToRespawn(vehicleIdSIM[playerid]);
				KillTimer(todoTimer[playerid]);
				KillTimer(todoTimeout[playerid]);
				testSim[playerid] = 0;
				poinSim[playerid] = 0;
				vehicleIdSIM[playerid] = -1;
				limitVehSIM[vehid] = 0;
			}else{
				prosesPembuatanSIM(playerid, 30);
				givePlayerUang(playerid, -100);
				GameTextForPlayer(playerid, "~g~Praktik SIM Selesai", 2000, 3);
				format(pDialog[playerid], sizePDialog, WHITE"Anda mendapatkan poin sebesar "GREEN"%d"WHITE".\nSilahkan tunggu sekitar 30 menit real-time."WHITE"\nAnda dapat mengecek dan mengambilnya di tempat Registrasi sebelumnya, setelah sudah 30 menit berlalu.\n\nTerimakasih, Salam hangat "ORANGE"Kantor Polisi Lost Santos", poinSim[playerid]);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil Praktik SIM", pDialog[playerid], "Ok", "");
				DisablePlayerRaceCheckpoint(playerid);
				SetVehicleToRespawn(vehicleIdSIM[playerid]);
				KillTimer(todoTimer[playerid]);
				KillTimer(todoTimeout[playerid]);
				testSim[playerid] = 0;
				poinSim[playerid] = 0;
				vehicleIdSIM[playerid] = -1;
				limitVehSIM[vehid] = 0;
			}
		}
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid){
	if(Iter_Contains(IDVehToPVehIterator, vehicleid)){
		PVeh[IDVehToPVeh[vehicleid]][pVehIsReparasi] = STATUS_KENDARAAN_RUSAK;
		updatePVehReparasi(PVeh[IDVehToPVeh[vehicleid]][pVehID], STATUS_KENDARAAN_RUSAK);
		// Kirim Pesan ke pemain
		foreach(new i : Player){
			if(PVeh[IDVehToPVeh[vehicleid]][pVehPemilik] == PlayerInfo[i][pID] && IsPlayerConnected(i)){
				new temp_msg[128];
				format(temp_msg, 128,"[KENDARAAN] "WHITE"Kendaraan "ORANGE"%s "WHITE"milik anda telah rusak total dan masuk pusat reparasi.", GetVehicleNameFromModel(PVeh[IDVehToPVeh[vehicleid]][pVehModel]));
				SendClientMessage(i, COLOR_RED, temp_msg);
				break;
			}
		}

		DestroyVehicle(vehicleid);
		IDVehToPVeh[vehicleid] = 0;
		Iter_Remove(IDVehToPVehIterator, vehicleid);
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid){
	if(PlayerInfo[playerid][activeMarker]){
		PlayerInfo[playerid][activeMarker] = false;
		DisablePlayerCheckpoint(playerid);
	}
	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[]){
	if(PlayerInfo[playerid][sudahLogin] == false){
		error_command(playerid, "Anda harus login terlebih dahulu untuk dapat menggunakan command!");
		error_command(playerid, "Anda telah dikick dari server karena menggunakan command sebelum login.");
		KickEx(playerid);
		return 0;
	}
	return 1;
}

/**
	TIMER TASK
**/
task updateWorldTime[1000]()
{
	new temp_jam, temp_menit, temp_detik, str_waktu[32],
		temp_tahun, temp_bulan, temp_hari;
	gettime(temp_jam, temp_menit, temp_detik);
	SetWorldTime(temp_jam);

	format(str_waktu,32,"%02d:%02d:%02d", temp_jam, temp_menit, temp_detik);
	TextDrawSetString(TD_JamTanggal[0], str_waktu);

	getdate(temp_tahun, temp_bulan, temp_hari);
	if(temp_hari != last_hari){
		last_hari = temp_hari;
		mysql_tquery(koneksi, "SELECT DAYOFWEEK(CURRENT_DATE()) AS nama_hari", "responseUpdateHari");
	}

	foreach(new i : Player){
		SetPlayerTime(i, temp_jam, temp_menit);
	}
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new idx = bEditID[playerid];
	if(EditingObject[playerid] == EDITING_BOARD){
		if(response == EDIT_RESPONSE_UPDATE)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			SetDynamicObjectPos(objectid, bCPos[playerid][0], bCPos[playerid][1], bCPos[playerid][2]);
			SetDynamicObjectRot(objectid, bCRot[playerid][0], bCRot[playerid][1],bCRot[playerid][2]);
			bCPos[playerid][0] = bCPos[playerid][1] = bCPos[playerid][2] = 0;
			bCRot[playerid][0] = bCRot[playerid][1] = bCRot[playerid][2] = 0;

			format(pDialog[playerid], sizePDialog, "* Anda membatalkan edit board id : %d.", idx);
			SendClientMessage(playerid, COLOR_BLUE, pDialog[playerid]);
		}
		else if(response == EDIT_RESPONSE_FINAL)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);

			BoardInfo[idx][bCX] = x;
			BoardInfo[idx][bCY] = y;
			BoardInfo[idx][bCZ] = z;
			BoardInfo[idx][bCRX] = rx;
			BoardInfo[idx][bCRY] = ry;
			BoardInfo[idx][bCRZ] = rz;

			bEditID[playerid] = 0;
			EditingObject[playerid] = EDITING_NONE;
			BoardInfo[idx][bStatus] = 0;
			
			SaveBoard(BoardInfo[idx][bModel], BoardInfo[idx][bCX], BoardInfo[idx][bCY], BoardInfo[idx][bCZ], BoardInfo[idx][bCRX], BoardInfo[idx][bCRY], BoardInfo[idx][bCRZ], BoardInfo[idx][bText], BoardInfo[idx][bFontSiz], BoardInfo[idx][boardID]);
			format(pDialog[playerid], sizePDialog, "* Kamu berhasil mengedit posisi dari board ID : %d.", idx);
			SendClientMessage(playerid, COLOR_GREEN, pDialog[playerid]);
		}
	}else if(EditingObject[playerid] == EDITING_FURNITURE){
		switch(response)
		{
			case EDIT_RESPONSE_CANCEL:
			{
				new data[e_furniture];
				Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);
				SetDynamicObjectPos(objectid, data[fPosX], data[fPosY], data[fPosZ]);
				SetDynamicObjectRot(objectid, data[fRotX], data[fRotY], data[fRotZ]);

				EditingObject[playerid] = EDITING_NONE;
			}

			case EDIT_RESPONSE_FINAL:
			{
				new data[e_furniture];
				Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);
				data[fPosX] = x;
				data[fPosY] = y;
				data[fPosZ] = z;
				data[fRotX] = rx;
				data[fRotY] = ry;
				data[fRotZ] = rz;
				SetDynamicObjectPos(objectid, data[fPosX], data[fPosY], data[fPosZ]);
				SetDynamicObjectRot(objectid, data[fRotX], data[fRotY], data[fRotZ]);
				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE house_furniture SET pos_x=%f, pos_y=%f, pos_z=%f, rot_x=%f, rot_y=%f, rot_z=%f WHERE id=%d", data[fPosX], data[fPosY], data[fPosZ], data[fRotX], data[fRotY], data[fRotZ], data[fID]);
				mysql_tquery(koneksi, pQuery[playerid]);
				EditingObject[playerid] = EDITING_NONE;

				SendClientMessage(playerid, COLOR_PINK, "[FURNITURE] "WHITE"Berhasil menyimpan posisi furniture.");
			}
		}
	}
	return 1;
}

#include <command>