/**************************************************************************************************
	PLAYVERSE

	FUTURE BUG (PREDIKSI) :
	- INT 32 BIT DARI AUTO INCREMENT (HUGE PLAYER SERVER)
	- LIMIT TERCAPAI PADA VEHICLE DAN LAINNYA
***************************************************************************************************/

#include <a_samp>

#include <pengaturan> // Pengaturan server disini letak pas di bawah a_samp
#include <colors> // https://forum.sa-mp.com/showthread.php?t=573049
#include <sscanf2>
#include <streamer>
#include <a_mysql>

#include <weapon-config> // Custom Damage

#define YSI_NO_HEAP_MALLOC
#define YSI_NO_VERSION_CHECK
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_inline>

#include <progress2>

#include <samp-precise-timers>
#include <colandreas>
#include <geolite>

#include <Pawn.Regex>

// Timpa SetTimer dengan PreciseTimer
#define SetTimerEx				SetPreciseTimer
#define SetTimer				SetPreciseTimer
#define KillTimer				DeletePreciseTimer

/**
	Include EVF sudah gak 100% original
	Sudah diedit beberapa kali sesuai kebutuhan server
 */
#include <EVF> // Fungsi tambahan vehicle
#include <garage_block> // Block all PayNSpray dan modshop lain

#include <zcmd>

#include <core>
#include <float>
#include <PreviewModelDialog>

/*
	INCLUDE INCLUDE BUATAN DIBAWAH
*/
#include <global_variable> // variable disini

#include <fungsi_tambahan> // Fungsi tambahan disini - Tambahan dulu baru fungsi
#include <fungsi> // Fungsi disini

#include <mapping> // Mappingan loader
#include <textdraw> // Textdraw Function Loader
#include <pickup> // Pickup Function Loader
#include <map_icon> // Map Icon Function Loader
#include <checkpoint> // CP Function Loader
#include <area> // Area loader
#include <actor> // Actor loader
#include <dialog> // Function Dialog Loader

#include <../include/gl_common.inc>

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
	
	resetPlayerVariable(playerid, 1);
	ResetPVarTemporary(playerid);
	ResetPlayerMoney(playerid);
	resetPlayerToDo(playerid);
	TextDrawShowForPlayer(playerid, TD_JamTanggal[0]);
	TextDrawShowForPlayer(playerid, TD_JamTanggal[1]);

	new nama[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nama, sizeof(nama));
	PlayerInfo[playerid][pPlayerName] = nama;

    mysql_format(koneksi, pQuery[playerid], sizePQuery, "\
	SELECT a.*, \
		sum(b.jumlah) as limit_item \
	FROM `user` a \
	LEFT JOIN user_item_limit b \
		ON b.id_user = a.id \
	WHERE nama = '%e' \
		AND (b.expired > NOW() OR b.expired IS NULL)", PlayerInfo[playerid][pPlayerName]);
	mysql_tquery(koneksi, pQuery[playerid], "isRegistered", "d", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason){
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerDisconnect terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif

	if(SpeedoTimer[playerid] != -1){
		DeletePreciseTimer(SpeedoTimer[playerid]);
		SpeedoTimer[playerid] = -1;
	}

	if(PlayerInfo[playerid][inSpectating] != INVALID_PLAYER_ID && IsPlayerConnected(PlayerInfo[playerid][inSpectating])){
		new cnt = 0;
        foreach(new i : Player){
            if(i != playerid && PlayerInfo[i][inSpectating] == PlayerInfo[playerid][inSpectating])
                cnt++;
        }
        if(cnt <= 0)
            PlayerInfo[PlayerInfo[playerid][inSpectating]][inSpectate] = false;
	}

	if(PlayerInfo[playerid][inSpectate]){
		foreach(new i : Player){
			if(PlayerInfo[i][inSpectating] == playerid){
				cmd_specoff(playerid, "");
				sendPesan(i, COLOR_BLUE, TAG_SPEC" "WHITE"%s telah meninggalkan server.", PlayerInfo[playerid][pPlayerName]);
			}
		}
	}

	reset_PerbaikiKendaraan(playerid);

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
	}else{
		// Pastikan dia memiliki loginAttempt dan merupakan player terdaftar
		if(PlayerInfo[playerid][pID]){
			mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET login_attempt = %d WHERE id = %d", PlayerInfo[playerid][loginAttempt], PlayerInfo[playerid][pID]);
			mysql_tquery(koneksi, pQuery[playerid]);
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
	resetPlayerVariable(playerid, 2);
	// hideTextDrawUang(playerid);
	ResetPlayerMoney(playerid);
	unloadTextDrawPemain(playerid);
	if(RentPlayerVehUser[playerid] != -1){
		unloadRentPlayerVeh(playerid, 0);		
	}
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
					PlayerInfo[playerid][loginAttempt] = 0;

					// Increment jumlah login, dan reset login attempt
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `jumlah_login` = `jumlah_login` + 1, login_attempt = 0 WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
					mysql_tquery(koneksi, pQuery[playerid]);

					PlayerInfo[playerid][loginKe]++;

					PlayerInfo[playerid][waktuSaatLogin] = gettime();

					// tampilkanTextDrawUang(playerid);
					LoadVehiclePlayer(playerid);
				
					LoadFactionPlayer(playerid);

					LoadItemPlayer(playerid);

					loadRentPlayerVeh(playerid);

					// Set player uang tanpa menambahkan di database - maka diset false untuk parameter terakhir
					setUangPlayer(playerid, PlayerInfo[playerid][uang], false);

					UpdateExpScore(playerid);

					PlayerInfo[playerid][tampilHUDStats] = true;
					spawnPemain(playerid);

					format(msg, sizeof(msg), "~w~Selamat datang ~g~kembali~w~!~n~Anda masuk yang ke - ~g~ %i ~w~!", PlayerInfo[playerid][loginKe]);
					GameTextForPlayer(playerid, msg, 4000, 3);
					return 1;
				}
				else
				{
					++PlayerInfo[playerid][loginAttempt];
					if(PlayerInfo[playerid][loginAttempt] >= BATAS_SALAH_PASSWORD) {
						PlayerInfo[playerid][loginAttempt] = 0;
						
						// Jenis blocked untuk akun terkunci adalah 1
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO user_blocked(id_user,jenis_block,happen,expired,keterangan) VALUES(%d, 1, NOW(), NOW() + INTERVAL %d MINUTE, '%e')", PlayerInfo[playerid][pID], LAMA_PENGUNCIAN_AKUN_JIKA_SALAH_PASSWORD, "Salah memasukan password hingga melebihi batas attempt.");
						mysql_tquery(koneksi, pQuery[playerid]);

						// Kirim informasi dari email juga
						// Disini panggil fungsi kirim email

						format(pDialog[playerid], sizePDialog, YELLOW"%s "RED"kamu telah melebihi batas percobaan login yang diberikan.\n\n", PlayerInfo[playerid][pPlayerName]);
						strcatEx(pDialog[playerid], sizePDialog, YELLOW"Akun kamu akan dikunci selama %d menit.\n\n", LAMA_PENGUNCIAN_AKUN_JIKA_SALAH_PASSWORD);
						strcatEx(pDialog[playerid], sizePDialog, RED"Jika kamu merasa akun ini bukan milik kamu, mohon agar tidak mencoba menghack akun ini.\nMencoba menghack akun merupakan pelanggaran berat peraturan server.\n");
						strcatEx(pDialog[playerid], sizePDialog, WHITE"Namun jika ini merupakan akun kamu, dan kamu lupa password.\nKamu dapat mereset password kamu melalui website resmi dan mengirimkan verifikasi melalui email.\n");
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Login melebihi batas maksimal", pDialog[playerid], "Ok", "");
						return KickEx(playerid);
					}

					format(pDialog[playerid], sizePDialog, WHITE"Selamat datang kembali "GREEN"%s\n\n", PlayerInfo[playerid][pPlayerName]);
					strcatEx(pDialog[playerid], sizePDialog, WHITE"Silahkan masukan password kamu, pastikan untuk memperhatikan huruf besar/kecil.\n");
					strcatEx(pDialog[playerid], sizePDialog, YELLOW"Jika mengalami kesalahan password sebanyak %dx maka kamu akan otomatis dikick.\n", BATAS_SALAH_PASSWORD);
					strcatEx(pDialog[playerid], sizePDialog, WHITE"\nPercobaan login yang dilakukan "YELLOW"%d "WHITE"dari "RED"%d\n", PlayerInfo[playerid][loginAttempt],  BATAS_SALAH_PASSWORD);
					strcat(pDialog[playerid], WHITE"\n+++++++++++++++++++++ RULES +++++++++++++++++++++\n"RULES_SERVER);
					return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, WHITE"Login", pDialog[playerid], "Login", "Keluar");
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
				new string[500];
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
									format(string, sizeof(string), "%s%d\t%s\t"RED"Rusak total\t"GREEN"Milik Sendiri\n", string, i, GetVehicleModelName(PVeh[i][pVehModel]));
								}else if(PVeh[i][pVehIsReparasi] == 2){ // Jika mobil sedang dalam reparasi namun telah siap diambil
									format(string, sizeof(string), "%s%d\t%s\t"YELLOW"Telah direcovery\t"GREEN"Milik Sendiri\n", string, i, GetVehicleModelName(PVeh[i][pVehModel]));
								}else{
									new Float:pos[3];
									GetVehiclePos(PVeh[i][pVehicle], pos[0], pos[1], pos[2]);
									format(string, sizeof(string), "%s%d\t%s\t%.2fm\t"GREEN"Milik Sendiri\n", string, i, GetVehicleModelName(PVeh[i][pVehModel]), GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]));
								}
							}else if(Iter_Contains(PVehKeys[playerid], i) && PVehKeysTime[playerid][i] > gettime()){
								if(PVeh[i][pVehIsReparasi] == 1){ // Jika mobil sedang dalam reparasi (telah rusak) dan belum diperbaiki dan dibayar
									format(string, sizeof(string), "%s%d\t%s\t"RED"Rusak total\t"YELLOW"%i menit\n", string, i, GetVehicleModelName(PVeh[i][pVehModel]), (PVehKeysTime[playerid][i] - gettime()) / 60);
								}else if(PVeh[i][pVehIsReparasi] == 2){ // Jika mobil sedang dalam reparasi namun telah siap diambil
									format(string, sizeof(string), "%s%d\t%s\t"YELLOW"Telah direcovery\t"YELLOW"%i menit\n", string, i, GetVehicleModelName(PVeh[i][pVehModel]), (PVehKeysTime[playerid][i] - gettime()) / 60);
								}else{
									new Float:pos[3];
									GetVehiclePos(PVeh[i][pVehicle], pos[0], pos[1], pos[2]);
									format(string, sizeof(string), "%s%d\t%s\t%.2fm\t"YELLOW"%i menit\n", string, i, GetVehicleModelName(PVeh[i][pVehModel]), GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]), (PVehKeysTime[playerid][i] - gettime()) / 60);
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
					case 4:
					{
						inline responseQuery(){
							new rows;
							cache_get_row_count(rows);
							if(rows){
								new idx = 0, id_house, temp_string[50];
								format(pDialog[playerid], sizePDialog, "Alamat\tNama Level\tJarak\n");
								while(idx < rows){
									cache_get_value_name_int(idx, "id_house", id_house);
									format(temp_string, sizeof(temp_string), "%d, %s, %s", id_house, GetZoneName(houseInfo[id_house][icon_x], houseInfo[id_house][icon_y], houseInfo[id_house][icon_z]), GetCityName(houseInfo[id_house][icon_x], houseInfo[id_house][icon_y], houseInfo[id_house][icon_z]));

									strcatEx(pDialog[playerid], sizePDialog, ORANGE"%s\t"PURPLE"%s\t"GREEN"%.2fm\n", temp_string, HouseLevel[houseInfo[id_house][hLevel]][namaLevel], GetPlayerDistanceFromPoint(playerid, houseInfo[id_house][icon_x], houseInfo[id_house][icon_y], houseInfo[id_house][icon_z]));
									idx++;
								}

								/**
									PASTIKAN UNTUK SELALU HAPUS SEBELUM MENYIMPAN CACHE BARU
								*/
								if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
								PlayerInfo[playerid][tempCache] = cache_save();

								ShowPlayerDialog(playerid, DIALOG_PILIH_RUMAH, DIALOG_STYLE_TABLIST_HEADERS, "Daftar rumah anda", pDialog[playerid], "Pilih", "Kembali");
							}else
								showDialogPesan(playerid, RED"Anda tidak memiliki rumah", WHITE"Anda tidak memiliki rumah saat ini.\n"YELLOW"Anda dapat membelinya ke sesama player atau pun membeli rumah yang tak berpenghuni.");
						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT id_house FROM house WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
					}
				}
			}
			return 1;
		}
		case DIALOG_PILIH_RUMAH:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);
				ShowPlayerDialog(playerid, DIALOG_OPTION_RUMAH_INVENTORY, DIALOG_STYLE_LIST, WHITE"Pilih aksi :", "Tampilkan Lokasi Rumah", "Pilih", "Batal");
			}else{
				resetPVarInventory(playerid);
				showDialogMenuInventory(playerid);
			}
			return 1;
		}
		case DIALOG_OPTION_RUMAH_INVENTORY:
		{
			if(response){
				switch(listitem){
					case 0: // Tampilkan lokasi rumah
					{
						new id;
						cache_set_active(PlayerInfo[playerid][tempCache]);
						cache_get_value_name_int(GetPVarInt(playerid, "index_terpilih"), "id_house", id);
						cache_delete(PlayerInfo[playerid][tempCache]);
						PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

						SetPlayerCheckpoint(playerid, houseInfo[id][icon_x], houseInfo[id][icon_y], houseInfo[id][icon_z], 3.0);
						PlayerInfo[playerid][activeMarker] = true;
						server_message(playerid, WHITE"Rumah yang terpilih telah ditampilkan pada marker anda.");
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
				format(pDialog[playerid], sizePDialog, "\
					Tampilkan Lokasi Kendaraan\
					\nPinjamkan Kunci kepada orang\
					\nLihat kunci kendaraan ini yang dipinjamkan");

				if(PVeh[id][pVehPemilik] == PlayerInfo[playerid][pID]) 
					strcat(pDialog[playerid], "\nJual ke orang");
				
				ShowPlayerDialog(playerid, DIALOG_OPTION_KENDARAAN_INVENTORY, DIALOG_STYLE_LIST, WHITE"Pilih aksi:", pDialog[playerid], "Pilih", "Batal");
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

						SendClientMessage(playerid, COLOR_PINK, "[GPS] "WHITE"Lokasi kendaraan yang anda maksud telah ditandai pada peta menggunakan marker merah.");
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

								format(pDialog[playerid], sizePDialog, WHITE"Peminjam kunci "GREEN"%s "WHITE":", GetVehicleModelName(PVeh[id][pVehModel]));
								ShowPlayerDialog(playerid, DIALOG_PILIH_PEMINJAMAN_KEY, DIALOG_STYLE_TABLIST_HEADERS, pDialog[playerid], string, "Pilih", "Batal");
							}else{
								format(pDialog[playerid], sizePDialog, WHITE"Kendaraan "YELLOW"%s "WHITE"milik anda. Tidak dipinjam oleh siapapun.\nAnda dapat meminjamkannya kepada orang lain. Dengan mengakses menu sebelumnya.", GetVehicleModelName(PVeh[id][pVehModel]));
								return showDialogPesan(playerid, RED"Kendaraan tidak dipinjamkan", pDialog[playerid]);
							}
						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT a.id, a.expired, b.nama FROM vehicle_keys a LEFT JOIN `user` b ON a.id_user = b.id WHERE a.id_vehicle = '%d' AND a.expired > UNIX_TIMESTAMP(NOW())", PVeh[id][pVehID]);
					}
					case 3: // Jual kepada orang
					{
						if(IsPlayerOnTrade(playerid)) return showDialogPesan(playerid, RED"Anda sedang dalam trade", WHITE"Anda sedang berada dalam sebuah trade.\nAnda harus menunggu hingga anda tidak dalam trade lagi.\n"YELLOW"Jika anda merasa tidak dalam trade silahkan relogin untuk mengatasi kesalahan sistem.");

						new id = GetPVarInt(playerid, "veh_select_id");

						// Prevent injection listitem
						if(PVeh[id][pVehPemilik] != PlayerInfo[playerid][pID]) return 1;

						format(pDialog[playerid], sizePDialog, WHITE"Masukan ID pemain yang ingin kamu tawarkan "GREEN"%s\n\
							"YELLOW"Pastikan pemain yang kamu tawarkan berada didekat kamu.", GetVehicleModelName(PVeh[id][pVehModel]));
						ShowPlayerDialog(playerid, DIALOG_KENDARAAN_JUAL_KE_ORANG, DIALOG_STYLE_INPUT, "Masukan id pemain", pDialog[playerid], "Pilih", "Batal");
					}
				}
			}else{
				DeletePVar(playerid, "veh_select_id");
			}
			return 1;
		}
		case DIALOG_KENDARAAN_JUAL_KE_ORANG:
		{
			if(response){
				new target_id,
					id = GetPVarInt(playerid, "veh_select_id");
				if(sscanf(inputtext, "u", target_id)) {
					format(pDialog[playerid], sizePDialog, 
							RED"ID Pemain invalid\n\
							"WHITE"Masukan ID pemain yang ingin kamu tawarkan "GREEN"%s\n\
							"YELLOW"Pastikan pemain yang kamu tawarkan berada didekat kamu.", GetVehicleModelName(PVeh[id][pVehModel]));
					return ShowPlayerDialog(playerid, DIALOG_KENDARAAN_JUAL_KE_ORANG, DIALOG_STYLE_INPUT, "Masukan id pemain", pDialog[playerid], "Pilih", "Batal");
				}
				if(!IsPlayerConnected(target_id) || target_id == INVALID_PLAYER_ID || target_id == playerid) {
					format(pDialog[playerid], sizePDialog, 
							RED"ID Pemain invalid\n\
							"WHITE"Masukan ID pemain yang ingin kamu tawarkan "GREEN"%s\n\
							"YELLOW"Pastikan pemain yang kamu tawarkan berada didekat kamu.", GetVehicleModelName(PVeh[id][pVehModel]));
					return ShowPlayerDialog(playerid, DIALOG_KENDARAAN_JUAL_KE_ORANG, DIALOG_STYLE_INPUT, "Masukan id pemain", pDialog[playerid], "Pilih", "Batal");
				}
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				if(!IsPlayerInRangeOfPoint(target_id, 2.0, pos[0], pos[1], pos[2])){
					format(pDialog[playerid], sizePDialog, 
							RED"Pemain harus berada didekat anda. Minimal 2 meter.\n\
							"WHITE"Masukan ID pemain yang ingin kamu tawarkan "GREEN"%s\n\
							"YELLOW"Pastikan pemain yang kamu tawarkan berada didekat kamu.", GetVehicleModelName(PVeh[id][pVehModel]));
					return ShowPlayerDialog(playerid, DIALOG_KENDARAAN_JUAL_KE_ORANG, DIALOG_STYLE_INPUT, "Masukan id pemain", pDialog[playerid], "Pilih", "Batal");
				}

				if(IsPlayerOnTrade(target_id)){
					return showDialogPesan(playerid, RED"Player yang dituju sedang melakukan trade", 
						WHITE"Maaf player yang dituju sedang melakukan trade!\nAnda hanya dapat melakukan trade saat player sedang tidak melakukan trade dengan yang orang lain.");
				}

				inline responseQuery(){
					new total;
					cache_get_value_name_int(0, "total", total);
					if(total >= MAX_KENDARAAN_PER_PEMAIN){
						showDialogPesan(playerid, RED"Slot Kendaraan Penuh", 
						WHITE"Slot kendaraan pemain yang dituju penuh, kendaraan pemain telah mencapai batas maksimal!\nSilahkan informasikan untuk menyediakan slot terlebih dahulu sebelum bertransaksi kembali.");
					}else{
						// Simpan ID target
						SetPVarInt(playerid, "sell_veh_target_id", target_id);

						format(pDialog[playerid], sizePDialog, 
							WHITE"Masukan "YELLOW"harga "WHITE"yang ingin kamu tawarkan "GREEN"%s\n\n\
							"YELLOW"Note : Untuk saat ini pembayaran hanya dapat dilakukan via uang cash.", GetVehicleModelName(PVeh[id][pVehModel]));
						ShowPlayerDialog(playerid, DIALOG_KENDARAAN_JUAL_KE_ORANG_HARGA, DIALOG_STYLE_INPUT, "Masukan Harga Jual", pDialog[playerid], "Ok", "Batal");
					}
				}	
				MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT COUNT(*) AS total FROM vehicle WHERE id_pemilik = '%d'", PlayerInfo[target_id][pID]);
			}else{
				DeletePVar(playerid, "veh_select_id");		
			}
			return 1;
		}
		case DIALOG_KENDARAAN_JUAL_KE_ORANG_HARGA:
		{
			if(response){
				new target_id = GetPVarInt(playerid, "sell_veh_target_id"),
					idpv = GetPVarInt(playerid, "veh_select_id"),
					harga;
				if(sscanf(inputtext, "i", harga)) {
					format(pDialog[playerid], sizePDialog, 
						RED"Harga tidak valid.\
						"WHITE"Masukan "YELLOW"harga "WHITE"yang ingin kamu tawarkan "GREEN"%s\n\n\
						"YELLOW"Note : Untuk saat ini pembayaran hanya dapat dilakukan via uang cash.", GetVehicleModelName(PVeh[idpv][pVehModel]));
					return ShowPlayerDialog(playerid, DIALOG_KENDARAAN_JUAL_KE_ORANG_HARGA, DIALOG_STYLE_INPUT, "Masukan Harga Jual", pDialog[playerid], "Ok", "Batal");
				}
				if(harga <= 0 || harga >= MAXIMAL_MONEY_TRADE) {
					format(pDialog[playerid], sizePDialog, 
						RED"Harga minimal 1 hingga %d.\n\
						"WHITE"Masukan "YELLOW"harga "WHITE"yang ingin kamu tawarkan "GREEN"%s\n\n\
						"YELLOW"Note : Untuk saat ini pembayaran hanya dapat dilakukan via uang cash.",MAXIMAL_MONEY_TRADE, GetVehicleModelName(PVeh[idpv][pVehModel]));
					return ShowPlayerDialog(playerid, DIALOG_KENDARAAN_JUAL_KE_ORANG_HARGA, DIALOG_STYLE_INPUT, "Masukan Harga Jual", pDialog[playerid], "Ok", "Batal");
				}

				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				if(!IsPlayerConnected(target_id) || !IsPlayerInRangeOfPoint(target_id, 2.0, pos[0], pos[1], pos[2])){
					return showDialogPesan(playerid, RED"Transaksi Batal", 
						WHITE"Pemain yang akan ditawarkan telah meninggalkan server atau menjauh dari anda.\nSaat bertransaksi pastikan pemain tidak meninggalkan server ataupun menjauh.");
				}

				SetPVarInt(playerid, "sell_veh_harga", harga);
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan menjual sebuah kendaraan dengan spesifikasi :\n\
					Jenis Kendaraan\t\t: "ORANGE"%s\n\
					"WHITE"Harga Penawaran\t\t: "GREEN"$%d\n\
					"WHITE"Target Penawaran\t\t: "PINK"%s\n\n", 
					GetVehicleModelName(PVeh[idpv][pVehModel]),
					harga,
					PlayerInfo[target_id][pPlayerName]);
				strcatEx(pDialog[playerid], sizePDialog, WHITE"Apakah anda yakin ingin mengajukan penawaran tersebut ?\n\n"RED"Important : "YELLOW"Pastikan untuk tetap pada posisi saat ini hingga nanti menyelesaikan transaksi\nTransaksi dapat batal jika salah satu pihak meninggalkan server atau berpindah posisi.");
				ShowPlayerDialog(playerid, DIALOG_KENDARAAN_JUAL_KE_ORANG_KONFIRMASI_PIHAK_PERTAMA, DIALOG_STYLE_MSGBOX, "Konfirmasi Penawaran", pDialog[playerid], "Konfirmasi", "Batal");
			}else{
				DeletePVar(playerid, "sell_veh_target_id");		
				DeletePVar(playerid, "veh_select_id");		
			}
			return 1;
		}
		case DIALOG_KENDARAAN_JUAL_KE_ORANG_KONFIRMASI_PIHAK_PERTAMA:
		{
			if(response){
				new target_id = GetPVarInt(playerid, "sell_veh_target_id"),
					idpv = GetPVarInt(playerid, "veh_select_id"),
					harga = GetPVarInt(playerid, "sell_veh_harga");
				
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				if(!IsPlayerConnected(target_id) || !IsPlayerInRangeOfPoint(target_id, 2.0, pos[0], pos[1], pos[2])){
					return showDialogPesan(playerid, RED"Transaksi Batal", 
						WHITE"Pemain yang akan ditawarkan telah meninggalkan server atau menjauh dari anda.\nSaat bertransaksi pastikan pemain tidak meninggalkan server ataupun menjauh.");
				}

				sendPesan(playerid, COLOR_YELLOW, "Kendaraan: "WHITE"Anda berhasil menawarkan kendaraan kepada "GREEN"%s", PlayerInfo[target_id][pPlayerName]);
				SendClientMessage(playerid, COLOR_YELLOW, "Kendaraan: "WHITE"Notifikasi akan diberikan kepada anda mengenai ditolak/diterimanya tawaran anda.");

				tandaiSedangTrade(playerid, target_id);

				// Simpan id player ke pemain
				SetPVarInt(target_id, "buy_veh_target_id", playerid);
				SetPVarInt(target_id, "buy_veh_harga", harga);
				SetPVarInt(target_id, "buy_veh_select_id", idpv);

				// Remove pvar playerid karena sudah tidak dipakai
				DeletePVar(playerid, "sell_veh_harga");		
				DeletePVar(playerid, "sell_veh_target_id");		
				DeletePVar(playerid, "veh_select_id");

				// Tetap Pinjam dialog pihak pertama
				format(pDialog[playerid], sizePDialog, WHITE"Anda mendapatkan tawaran penjualan kendaraan dengan spesifikasi :\n\
					Jenis Kendaraan\t\t: "ORANGE"%s\n\
					"WHITE"Harga Penawaran\t\t: "GREEN"$%d\n\
					"WHITE"Nama Penjual\t\t\t: "PINK"%s\n\n", 
					GetVehicleModelName(PVeh[idpv][pVehModel]),
					harga,
					PlayerInfo[playerid][pPlayerName]);
				strcatEx(pDialog[playerid], sizePDialog, WHITE"Apakah anda ingin membeli kendaraan ini? Ketik "GREEN"konfirmasi "WHITE"untuk membeli.\n\n"RED"Important : "YELLOW"Pastikan untuk tetap pada posisi saat ini hingga nanti menyelesaikan transaksi\nTransaksi dapat batal jika salah satu pihak meninggalkan server atau berpindah posisi.");

				ShowPlayerDialog(target_id, DIALOG_KENDARAAN_JUAL_KE_ORANG_KONFIRMASI_PIHAK_KEDUA, DIALOG_STYLE_INPUT, "Konfirmasi Pembelian", pDialog[playerid], "Konfirmasi", "Batal");
			}else{
				DeletePVar(playerid, "sell_veh_harga");		
				DeletePVar(playerid, "sell_veh_target_id");		
				DeletePVar(playerid, "veh_select_id");		
			}
			return 1;
		}
		case DIALOG_KENDARAAN_JUAL_KE_ORANG_KONFIRMASI_PIHAK_KEDUA:
		{
			// Fetch all pvar
			new target_id = GetPVarInt(playerid, "buy_veh_target_id"),
				idpv = GetPVarInt(playerid, "buy_veh_select_id"),
				harga = GetPVarInt(playerid, "buy_veh_harga");
			
			// Cek dlu apakah player target masih ada disekitar dan terconnect ke server
			new Float:pos[3];
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			if(!IsPlayerConnected(target_id) || !IsPlayerInRangeOfPoint(target_id, 2.0, pos[0], pos[1], pos[2])){
				return showDialogPesan(playerid, RED"Transaksi Batal", 
					WHITE"Pemain yang akan menawarkan telah meninggalkan server atau menjauh dari anda.\nSaat bertransaksi pastikan kedua pihak tidak meninggalkan server ataupun menjauh.");
			}

			if(response){
				// Prevent dari penjualan kepada lebih dari 1 orang untuk mengambil keuntungan
				if(PlayerInfo[target_id][pID] != PVeh[idpv][pVehPemilik]) {
					// Remove assigned trade value
					lepasTandaTrade(playerid);

					// Remove all 
					DeletePVar(playerid, "buy_veh_harga");		
					DeletePVar(playerid, "buy_veh_target_id");		
					DeletePVar(playerid, "buy_veh_select_id");

					printf("Hacking Potential: Mencoba menjual kepada pemain yang berbeda sekaligus.");
					return 1;
				}

				// Jika tidak mengetik konfirmasi
				if(!sama("konfirmasi", inputtext)) {
					format(pDialog[playerid], sizePDialog, RED"Tulisan konfirmasi tidak valid\n\n");
					strcatEx(pDialog[playerid], sizePDialog, WHITE"Anda mendapatkan tawaran penjualan kendaraan dengan spesifikasi :\n\
						Jenis Kendaraan\t\t: "ORANGE"%s\n\
						"WHITE"Harga Penawaran\t\t: "GREEN"$%d\n\
						"WHITE"Nama Penjual\t\t: "PINK"%s\n\n", 
						GetVehicleModelName(PVeh[idpv][pVehModel]),
						harga,
						PlayerInfo[target_id][pPlayerName]);
					strcatEx(pDialog[playerid], sizePDialog, WHITE"Apakah anda ingin membeli kendaraan ini? Ketik "GREEN"konfirmasi "WHITE"untuk membeli.\n\n"RED"Important : "YELLOW"Pastikan untuk tetap pada posisi saat ini hingga nanti menyelesaikan transaksi\nTransaksi dapat batal jika salah satu pihak meninggalkan server atau berpindah posisi.");

					return ShowPlayerDialog(playerid, DIALOG_KENDARAAN_JUAL_KE_ORANG_KONFIRMASI_PIHAK_KEDUA, DIALOG_STYLE_INPUT, "Konfirmasi Pembelian", pDialog[playerid], "Konfirmasi", "Batal");
				}

				if(getUangPlayer(playerid) < harga) {
					sendPesan(target_id, COLOR_RED, "Kendaraan: "WHITE"%s menolak penawaran penjualan kendaraan anda, dikarenakan tidak memiliki cukup uang.", PlayerInfo[playerid][pPlayerName]);
					// Remove assigned trade value
					lepasTandaTrade(playerid);
					return SendClientMessage(playerid, COLOR_RED, "Uang: "WHITE"Anda tidak memiliki cukup uang untuk membayar transaksi.");
				}

				// Berikan uang
				givePlayerUang(playerid, -harga);
				givePlayerUang(target_id, harga);

				// Play animations
				PlayerGivesAnimation(playerid);
				PlayerTakesAnimation(target_id);

				sendPesan(target_id, COLOR_GREEN, "Kendaraan: "WHITE"%s menerima penawaran penjualan kendaraan anda.", PlayerInfo[playerid][pPlayerName]);
				sendPesan(target_id, COLOR_GREEN, "Kendaraan: "WHITE"Anda menerima uang sebesar "GREEN"$%d "WHITE"dari hasil penjualan.", harga);

				sendPesan(playerid, COLOR_GREEN, "Kendaraan: "WHITE"Anda berhasil membeli %s dari %s sebesar "GREEN"$%d", GetVehicleModelName(PVeh[idpv][pVehModel]), PlayerInfo[target_id][pPlayerName], harga);

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE vehicle SET id_pemilik = %d WHERE id = %d", PlayerInfo[playerid][pID], PVeh[idpv][pVehID]);
				mysql_tquery(koneksi, pQuery[playerid]);

				// Remove kunci dipinjamkan dari database
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM vehicle_keys WHERE id_vehicle  = %d", PVeh[idpv][pVehID]);
				mysql_tquery(koneksi, pQuery[playerid]);

				// Lepas semua kunci yang dipinjam
				// Looping ke player lain apakah ada pemegang kunci
				// Jika ada maka lepas kuncinya secara paksa
				foreach(new j : Player){
					if(Iter_Contains(PVehKeys[j], idpv)){
						Iter_Remove(PVehKeys[j], idpv);
						PVehKeysTime[j][idpv] = 0;
					}
				}

				// Reassign pemilik
				PVeh[idpv][pVehPemilik] = PlayerInfo[playerid][pID];
				format(PVeh[idpv][pVehNamaPemilik], MAX_PLAYER_NAME + 1, "%s", PlayerInfo[playerid][pPlayerName]);
				
				// Remove assigned trade value
				lepasTandaTrade(playerid);

				// Remove all 
				DeletePVar(playerid, "buy_veh_harga");		
				DeletePVar(playerid, "buy_veh_target_id");		
				DeletePVar(playerid, "buy_veh_select_id");				
			}else{
				// Remove assigned trade value
				lepasTandaTrade(playerid);

				sendPesan(target_id, COLOR_RED, "Kendaraan: "WHITE"%s menolak penawaran penjualan kendaraan anda.", PlayerInfo[playerid][pPlayerName]);

				// Remove all 
				DeletePVar(playerid, "buy_veh_harga");		
				DeletePVar(playerid, "buy_veh_target_id");		
				DeletePVar(playerid, "buy_veh_select_id");
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

						format(pDialog[playerid], sizePDialog, TAG_KENDARAAN" "WHITE"Kunci "YELLOW"%s "WHITE"yang anda pinjam dari "GREEN"%s "WHITE"telah ditarik.",PlayerInfo[playerid][pPlayerName], GetVehicleModelName(PVeh[GetPVarInt(playerid, "veh_select_id")][pVehModel]));
						SendClientMessage(i, COLOR_ORANGE, pDialog[playerid]);
						break;
					}
				}

				format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil menarik kunci "YELLOW"%s\n"WHITE"Dari pemain "ORANGE"%s"WHITE", %s tidak akan dapat mengakses penuh kendaraan anda lagi.", GetVehicleModelName(PVeh[GetPVarInt(playerid, "veh_select_id")][pVehModel]), temp_nama, temp_nama);

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
					return ShowPlayerDialog(playerid, DIALOG_PINJAMIN_KUNCI_PLAYERID, DIALOG_STYLE_INPUT, YELLOW"Masukan ID pemain", RED"Pemain harus berada di dekat anda.\n"YELLOW"Silahkan masukan ID Pemain yang akan dipinjamkan kunci kendaraan.\n"WHITE"Hanya dapat meminjamkan kunci kepada pemain yang berada maksimal 2 meter.\n"WHITE"Pastikan player yang anda tuju belum dipinjami kendaraan yang sama.", "Pilih", "Batal");
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

				format(pDialog[playerid], sizePDialog, WHITE"Anda akan dipinjamkan kunci kendaraan "GREEN"%s "WHITE"oleh "GREEN"%s\n"WHITE"Dengan lama waktu peminjaman "YELLOW"%i menit.\nApakah anda ingin menyetujuinya?", GetVehicleModelName(PVeh[idpv][pVehModel]), PlayerInfo[playerid][pPlayerName], lama_waktu);

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

					PlayerGivesAnimation(target_id);
					PlayerTakesAnimation(playerid);

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
				ShowPlayerDialog(playerid, DIALOG_OPTION_SKIN_INVENTORY, DIALOG_STYLE_LIST, WHITE"Pilih aksi", GREEN"Pakai Skin\n"LIGHT_BLUE"Beritahu Skin\n"BLUE"Info Skin", "Ok", "Keluar");

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
				static const id_item_ktp = 7; // ID Item KTP = 7
				
				if(getUangPlayer(playerid) < 100) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Uang tidak cukup", WHITE"Maaf uang anda tidak mencukupi", "Ok", "");
				
				if(!(strlen(inputtext) == 4)) return ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP yang diinginkan", RED"Anda harus menginput 4 digit angka.\n"WHITE"Masukan nomor HP yang ingin digunakan.\n\n* Nomor HP harus terdiri dari 4 angka.\n* Nomor HP anda akan dicek keunik-annya, dimana setiap orang memiliki nomor HP yang berbeda.", "Simpan", "Batal");

				if(inputtext[0] == '-' || !isNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP yang diinginkan", RED"Inputan hanya dapat berupa angka.\n"WHITE"Masukan nomor HP yang ingin digunakan.\n\n* Nomor HP harus terdiri dari 4 angka.\n* Nomor HP anda akan dicek keunik-annya, dimana setiap orang memiliki nomor HP yang berbeda.", "Simpan", "Batal");

				new nomor_hp[16] = "62";
				strcat(nomor_hp, inputtext);
				SetPVarString(playerid, "temp_nomor_hp", nomor_hp);

				cekKetersediaanItem(playerid, id_item_ktp, 1, "isPunyaKTP");
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_DAFTAR_NOMOR_HP:
		{
			if(response){
				new nomor_hp[16];
				GetPVarString(playerid, "temp_nomor_hp", nomor_hp, 16);

				inline responseCekNomorHP(){
					if(!cache_num_rows()){
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET nomor_handphone = '%e', masa_aktif_nomor = NOW() + INTERVAL %d DAY WHERE id = '%d'", nomor_hp, MASA_AKTIF_SETIAP_PERPANJANG_NOMOR, PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid]);

						format(PlayerInfo[playerid][nomorHP], 12, "%s", nomor_hp);

						format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil mendaftarkan "GREEN"%s "WHITE"sebagai nomor HP anda.\nSekarang anda dapat menggunakan nomor HP anda sebagai sarana komunikasi dan sebagainya.\nPastikan untuk tidak menyalahgunakannya.\n\n"YELLOW"Nomor HP hanya dapat digunakan selama masa aktif masih ada,\nanda dapat perpanjang masa aktif nomor hp di kantor pemerintah.\n\nMasa aktif nomor HP anda saat ini adalah %d hari.", nomor_hp, MASA_AKTIF_SETIAP_PERPANJANG_NOMOR);

						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mendaftarkan nomor HP", pDialog[playerid], "Ok", "");
					}else{
						ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP yang diinginkan", RED"Nomor HP telah ada.\n"WHITE"Masukan nomor HP yang ingin digunakan.\n\n* Nomor HP harus terdiri dari 4 angka.\n* Nomor HP anda akan dicek keunik-annya, dimana setiap orang memiliki nomor HP yang berbeda.", "Simpan", "Batal");
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
				if(sscanf(inputtext, "u", target_id)) return ShowPlayerDialog(playerid, DIALOG_PILIH_PLAYER_FOR_ITEM, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Invalid playerid, silahkan masukan kembali!\n"WHITE"Masukan ID player yang akan kamu berikan item.","Beri","Keluar");
				if(!IsPlayerConnected(target_id)) return ShowPlayerDialog(playerid, DIALOG_PILIH_PLAYER_FOR_ITEM, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Player dengan id tersebut tidak ada, silahkan masukan kembali!\n"WHITE"Masukan ID player yang akan kamu berikan item.","Beri","Keluar");

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
								data[fHouseID] = PlayerInfo[playerid][inHouse];
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
							MySQL_TQueryInline(koneksi, using inline responseQuery, "INSERT INTO house_furniture(id_house, id_furniture, pos_x, pos_y, pos_z) VALUES('%d', '%d', '%f', '%f', '%f')", PlayerInfo[playerid][inHouse], id_furniture, pos[0], pos[1], pos[2]);
						}else{
							return server_message(playerid, "Anda tidak berada di dalam rumah anda sendiri.");
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

				SetPVarInt(playerid, "inv_indexlist", listitem);
				if(GetStatusKunciItemPlayer(playerid, TempPlayerDialog[playerid][listitem]))
					format(pDialog[playerid], sizePDialog, GREEN"Pakai Item\n"WHITE"Beritahu Item\nInfo Item\n"ORANGE"Beri Item\n"GREEN"Buka Item "RED"(sedang terkunci)\n"RED"Buang Item");
				else
					format(pDialog[playerid], sizePDialog, GREEN"Pakai Item\n"WHITE"Beritahu Item\nInfo Item\n"ORANGE"Beri Item\n"RED"Kunci Item "GREEN"(sedang terbuka)\n"RED"Buang Item");

				new temp_string[100],
					nama_item[50];
				getNamaByIdItem(TempPlayerDialog[playerid][listitem], nama_item);
				format(temp_string, sizeof(temp_string), WHITE"Pilih aksi untuk %s", nama_item);
				ShowPlayerDialog(playerid, DIALOG_OPTION_ITEM_INVENTORY, DIALOG_STYLE_LIST, temp_string, pDialog[playerid], "Ok", "Keluar");
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
						new id_item = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")], fungsi[50];
						getFungsiByIdItem(id_item, fungsi);
						CallRemoteFunction(fungsi, "ii", playerid, id_item);
						resetPVarInventory(playerid);
					}
					case 1:
					{
						new keterangan[100],
							id_item = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")]
						;
						getKeteranganByIdItem(id_item, keterangan);

						SetPVarString(playerid, "inv_keterangan", keterangan);
						SetPVarInt(playerid, "inv_model", getModelByIdItem(id_item));

						ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");
					}
					case 2:
					{
						new keterangan[100], 
							id_item = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")]
						;
						getKeteranganByIdItem(id_item, keterangan);
						tampilkanTextDrawShowItem(playerid, getModelByIdItem(id_item), GetJumlahItemPlayer(playerid, id_item), keterangan, PlayerInfo[playerid][pPlayerName]);

						resetPVarInventory(playerid);
					}
					case 3: // Beri item
					{
						new 
							nama_item[50], 
							id_item = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")]
						;
						if(GetStatusKunciItemPlayer(playerid, id_item)){
							resetPVarInventory(playerid);

							ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, ORANGE"Item tidak dapat diberi", WHITE"Item ini "RED"dikunci.\n\n"YELLOW"Note : Item yang dikunci tidak dapat dibuang/dijual/diberi kepada orang lain.\nJika tetap ingin melakukan hal tersebut silahkan buka item terlebih dahulu.", "Ok", "");
							return 1;
						}

						getNamaByIdItem(id_item, nama_item);

						format(pDialog[playerid], sizePDialog, WHITE"Silahkan masukan jumlah item yang ingin diberi.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item saat ini: "GREEN"%d", nama_item, GetJumlahItemPlayer(playerid, id_item));
						strcat(pDialog[playerid], YELLOW"\n\nPastikan anda teliti dalam mengecek item yang diberikan,\n"RED"untuk menghindari penipuan dan kesalahan.");
						ShowPlayerDialog(playerid, DIALOG_BERI_ITEM, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin berikan", pDialog[playerid], LIGHT_BLUE"Beri", "Batal");
					}
					case 4: // Kunci/Buka Kunci
					{
						new id_item = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")], 
							temp_kunci
						;
						temp_kunci = GetStatusKunciItemPlayer(playerid, id_item);

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
					case 5: // Buang item
					{
						new 
							id_item = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")],
							nama_item[50]
						;

						getNamaByIdItem(id_item, nama_item);

						if(GetStatusKunciItemPlayer(playerid, id_item)){
							resetPVarInventory(playerid);

							ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, ORANGE"Item tidak dapat dibuang", WHITE"Item ini "RED"dikunci.\n\n"YELLOW"Note : Item yang dikunci tidak dapat dibuang/dijual/diberi kepada orang lain.\nJika tetap ingin melakukan hal tersebut silahkan buka item terlebih dahulu.", "Ok", "");
							return 1;
						}

						format(pDialog[playerid], sizePDialog, WHITE"Silahkan masukan jumlah item yang ingin dibuang.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item : "GREEN"%d", nama_item, GetJumlahItemPlayer(playerid, id_item));
						strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang item,\n"RED"item yang telah dibuang tidak dapat dikembalikan lagi.");
						ShowPlayerDialog(playerid, DIALOG_BUANG_ITEM, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dibuang", pDialog[playerid], RED"Buang", "Batal");
					}
				}
			}else{
				showDialogListItem(playerid);
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
				new jumlah, 
					nama_item[50], 
					input_jumlah, 
					item_id = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")];

				jumlah = GetJumlahItemPlayer(playerid, item_id);
				getNamaByIdItem(item_id, nama_item);

				if(sscanf(inputtext, "i", input_jumlah)) {
					format(pDialog[playerid], sizePDialog, RED"Masukan inputan yang benar.\n"WHITE"Silahkan masukan jumlah item yang ingin dibuang.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item : "GREEN"%d", nama_item, jumlah);
					strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang item,\n"RED"item yang telah dibuang tidak dapat dikembalikan lagi.");
					return ShowPlayerDialog(playerid, DIALOG_BUANG_ITEM, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dibuang", pDialog[playerid], RED"Buang", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > jumlah){
					format(pDialog[playerid], sizePDialog, RED"Jumlah yang ingin anda buang salah.\n"WHITE"Silahkan masukan jumlah item yang ingin dibuang.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item : "GREEN"%d", nama_item, jumlah);
					strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang item,\n"RED"item yang telah dibuang tidak dapat dikembalikan lagi.");
					return ShowPlayerDialog(playerid, DIALOG_BUANG_ITEM, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dibuang", pDialog[playerid], RED"Buang", "Batal");
				}
				
				// Buang item player (beri player dalam jumlah minus)
				tambahItemPlayer(playerid, item_id, -input_jumlah);

				format(pDialog[playerid], sizePDialog, GREEN"Berhasil membuang item.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah yng dibuang : "RED"%d", nama_item, input_jumlah);
				strcat(pDialog[playerid], YELLOW"\n\nPastikan anda mengetahui konsekuensi dari membuang item,\n"RED"item yang telah dibuang tidak dapat dikembalikan lagi.");
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membuang item", pDialog[playerid], "Ok", "");
				
				resetPVarInventory(playerid);
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_BERI_ITEM:
		{
			if(response){
				new 
					nama_item[50], 
					input_jumlah, 
					jumlah,
					item_id = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")]
				;

				getNamaByIdItem(item_id, nama_item);
				jumlah = GetJumlahItemPlayer(playerid, item_id);

				if(sscanf(inputtext, "i", input_jumlah)) {
					format(pDialog[playerid], sizePDialog, RED"Masukan inputan yang benar.\n"WHITE"Silahkan masukan jumlah item yang ingin diberi.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item saat ini: "GREEN"%d", nama_item, jumlah);
					strcat(pDialog[playerid], YELLOW"\n\nPastikan anda teliti dalam mengecek item yang diberikan,\n"RED"untuk menghindari penipuan dan kesalahan.");
					return ShowPlayerDialog(playerid, DIALOG_BERI_ITEM, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin berikan", pDialog[playerid], LIGHT_BLUE"Beri", "Batal");
				}				
				if(input_jumlah < 1 || input_jumlah > jumlah){
					format(pDialog[playerid], sizePDialog, RED"Jumlah yang ingin anda beri tidak valid.\n"WHITE"Silahkan masukan jumlah item yang ingin diberi.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item saat ini: "GREEN"%d", nama_item, jumlah);
					strcat(pDialog[playerid], YELLOW"\n\nPastikan anda teliti dalam mengecek item yang diberikan,\n"RED"untuk menghindari penipuan dan kesalahan.");
					return ShowPlayerDialog(playerid, DIALOG_BERI_ITEM, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin berikan", pDialog[playerid], LIGHT_BLUE"Beri", "Batal");
				}

				SetPVarInt(playerid, "beri_item_jumlah", input_jumlah);
				SetPVarInt(playerid, "beri_item_id_item", item_id);

				ShowPlayerDialog(playerid, DIALOG_BERI_ITEM_ID_PLAYER, DIALOG_STYLE_INPUT, ORANGE"ID Pemain yang akan diberi",  WHITE"Masukan id pemain yang ingin anda berikan item."YELLOW"\n\nPastikan anda teliti dalam mengecek item yang diberikan,\n"RED"untuk menghindari penipuan dan kesalahan.", LIGHT_BLUE"Beri", "Batal");
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_BERI_ITEM_ID_PLAYER:
		{
			if(response){
				new target_id;
				if(sscanf(inputtext, "u", target_id)) {
					return ShowPlayerDialog(playerid, DIALOG_BERI_ITEM_ID_PLAYER, DIALOG_STYLE_INPUT, ORANGE"ID Pemain yang akan diberi", RED"ID pemain invalid.\n"WHITE"Masukan id pemain yang ingin anda berikan item."YELLOW"\n\nPastikan anda teliti dalam mengecek item yang diberikan,\n"RED"untuk menghindari penipuan dan kesalahan.", LIGHT_BLUE"Beri", "Batal");
				}
				if(!IsPlayerConnected(target_id) || target_id == INVALID_PLAYER_ID || target_id == playerid) {
					return ShowPlayerDialog(playerid, DIALOG_BERI_ITEM_ID_PLAYER, DIALOG_STYLE_INPUT, ORANGE"ID Pemain yang akan diberi", RED"ID pemain invalid.\n"WHITE"Masukan id pemain yang ingin anda berikan item."YELLOW"\n\nPastikan anda teliti dalam mengecek item yang diberikan,\n"RED"untuk menghindari penipuan dan kesalahan.", LIGHT_BLUE"Beri", "Batal");
				}

				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				if(!IsPlayerInRangeOfPoint(target_id, 2.0, pos[0], pos[1], pos[2])){
					return ShowPlayerDialog(playerid, DIALOG_BERI_ITEM_ID_PLAYER, DIALOG_STYLE_INPUT, ORANGE"ID Pemain yang akan diberi", RED"Pemain harus berada didekat anda.\n"WHITE"Masukan id pemain yang ingin anda berikan item."YELLOW"\n\nPastikan anda teliti dalam mengecek item yang diberikan,\n"RED"untuk menghindari penipuan dan kesalahan.", LIGHT_BLUE"Beri", "Batal");
				}

				SetPVarInt(playerid, "beri_item_target_id", target_id);

				new jumlah = GetPVarInt(playerid, "beri_item_jumlah"), 
					id_item = GetPVarInt(playerid, "beri_item_id_item");

				if(GetSlotInventoryPlayer(target_id) + getKapasitasByIdItem(id_item) * jumlah <= PlayerInfo[target_id][limitItem]){
					new nama_item[50];
					getNamaByIdItem(id_item, nama_item);

					format(pDialog[playerid], sizePDialog, WHITE"Anda akan memberikan item dengan spesifikasi.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item yang ingin diberi: "GREEN"%d\n"WHITE"Pemain yang ingin diberi : "ORANGE"%s\n", nama_item, jumlah, PlayerInfo[target_id][pPlayerName]);
					strcat(pDialog[playerid], WHITE"\nApakah anda yakin ?");
					strcat(pDialog[playerid], WHITE"\n\nPastikan anda teliti dalam mengecek item yang diberikan,\n"RED"untuk menghindari penipuan dan kesalahan.\n* Pastikan orang yang diberikan adalah orang terpecaya, jika melakukan transaksi.");

					return ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BERI_ITEM, DIALOG_STYLE_MSGBOX, ORANGE"Konfirmasi pemberian", pDialog[playerid], LIGHT_BLUE"Beri", "Batal");
				}else{
					resetPVarInventory(playerid);
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Slot item tidak cukup", WHITE"Slot item pemain yang ingin diberi tidak muat.\n"YELLOW"Suruh pemain untuk menyisihkan ruang terlebih dahulu.", "Ok", "");
				}				
			}else
				resetPVarInventory(playerid);
			return 1;
		}
		case DIALOG_KONFIRMASI_BERI_ITEM:
		{
			if(response){
				new jumlah = GetPVarInt(playerid, "beri_item_jumlah"), 
					id_item = GetPVarInt(playerid, "beri_item_id_item"),
					target_id = GetPVarInt(playerid, "beri_item_target_id");

				if(!IsPlayerConnected(target_id)) {
					resetPVarInventory(playerid);
					return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Gagal memberi item", WHITE"Pemain yang anda tuju telah offline dan meninggalkan server.\nAnda dapat memberi item lagi nanti.", "Ok", "");
				}

				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				if(!IsPlayerInRangeOfPoint(target_id, 2.0, pos[0], pos[1], pos[2])){
					return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Gagal memberi item", WHITE"Pemain yang anda tuju tidak berada disekitar anda.\nAnda hanya dapat memberi item kepada pemain yang berada disekitar anda.", "Ok", "");
				}

				new nama_item[50];
				getNamaByIdItem(id_item, nama_item);

				// Tukarkan item
				tambahItemPlayer(playerid, id_item, -jumlah);
				tambahItemPlayer(target_id, id_item, jumlah);

				PlayerGivesAnimation(playerid);
				PlayerTakesAnimation(target_id); 

				sendPesan(target_id, COLOR_GREEN, "Item: "WHITE"Anda telah mendapatkan item "PINK"%s "WHITE"dari "ORANGE"%s "WHITE"sebanyak "GREEN"%dx", nama_item, PlayerInfo[playerid][pPlayerName], jumlah);

				sendPesan(playerid, COLOR_ORANGE, "Item: "WHITE"Berhasil memberi item "PINK"%s "WHITE"ke "ORANGE"%s "WHITE"sebanyak "LIGHT_BLUE"%dx", nama_item, PlayerInfo[target_id][pPlayerName], jumlah);
				resetPVarInventory(playerid);
			}else
				resetPVarInventory(playerid);
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
					// ATM Banking
					case 3:
					{
						if(isnull(PlayerInfo[playerid][nomorRekening])) return showDialogPesan(playerid, RED"Anda tidak memiliki ATM", WHITE"Untuk dapat mengakses ATM Banking, anda harus mempunyai rekening bank terlebih dahulu.\n"YELLOW"Anda dapat pergi ke bank untuk mengurusnya.");

						showDialogEBank(playerid);
					}
					// Sharelock
					case 4:
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

				format(pDialog[playerid], sizePDialog, GREEN"%s "WHITE"ingin membagikan lokasinya kepada anda. Apakah anda ingin menerimanya?\n"YELLOW"Menerima sharelock dari orang lain akan menghilangkan marker merah anda yang sedang aktif,\nmarker merah tersebut akan digantikan dengan marker merah yang baru\nyang mengarah kepada lokasi "GREEN"%s "YELLOW"sekarang berada.", PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][pPlayerName]);
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

					// Cek juga masa aktif nomor tujuan
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "select a.id, COUNT(b.pesan) AS banyak_pesan from `user` a left join sms b on b.id_user_penerima = a.id WHERE a.nomor_handphone = '%e' AND a.masa_aktif_nomor >= NOW() GROUP BY a.id", inputtext);
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
				new harga;
				if(sscanf(inputtext, "i", harga)) return ShowPlayerDialog(playerid, DIALOG_HARGA_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Harga tidak valid!\n"WHITE"Anda harus menginput harga berupa angka.", "Lanjut", "Batal");

				if(harga <= 1) return ShowPlayerDialog(playerid, DIALOG_HARGA_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Harga tidak valid!\n"WHITE"Anda harus menginput harga lebih dari 1.", "Lanjut", "Batal");

				new Float:me_x, Float:me_y, Float:me_z;
				new level_rumah = GetPVarInt(playerid, "level_rumah");
				GetPlayerPos(playerid, me_x, me_y, me_z);

				inline responseQuery(){
					new id = cache_insert_id();
					createHouse(id, -1, level_rumah, harga, 0, 1, 1, me_x, me_y, me_z);
					SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "YELLOW"Anda berhasil membuat rumah!");
					
					DeletePVar(playerid, "level_rumah");
				}
				MySQL_TQueryInline(koneksi, using inline responseQuery, "INSERT INTO `house` (level, harga, icon_x, icon_y, icon_z) VALUES ('%d', '%d', '%f', '%f', '%f')", level_rumah, harga, me_x, me_y, me_z);
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
						new beliRate = getHousePrice(i, "beli");
						new ownerId = INVALID_PLAYER_ID;
						foreach(new j : Player){
							if(houseInfo[i][hOwner] == PlayerInfo[j][pID]){
								ownerId = j;
								break;
							}
						}
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
						houseInfo[i][hOwnerName][0] = EOS;
						houseInfo[i][hLevel] = 1;
						houseInfo[i][hKunci] = 1;
						houseInfo[i][hJual] = 0;
						houseId[housePickup[i]] = -1;
						housePickup[i] = -1;
					}
				}

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `id_user` = -1, `level` = 1, `kunci` = 1, `jual` = 1");
				mysql_tquery(koneksi, pQuery[playerid]);
				mysql_tquery(koneksi, "UPDATE `user` SET `save_house` = 0");

				loadAllHouse();

				SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "YELLOW"Anda berhasil mereset semua rumah!");
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
				new id;
				if(sscanf(inputtext, "i", id)) return ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ID, DIALOG_STYLE_INPUT, "Hapus Rumah", RED"ID tidak valid!\n"WHITE"Anda harus menginput ID berupa angka.", "Lanjut", "Batal");

				new pmsg[256], userId;
				inline responseQuery(){
					if(cache_num_rows()){
						new beliRate = getHousePrice(id, "beli");
						cache_get_value_name_int(0, "id_user", userId);
						
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, userId);
						mysql_tquery(koneksi, pQuery[playerid]);
						
						if(houseInfo[id][hOwner] != -1){
							new ownerId = INVALID_PLAYER_ID;
							foreach(new i : Player){
								if(PlayerInfo[i][pID] == houseInfo[id][hOwner]){
									ownerId = i;
									break;
								}
							}
							if(ownerId != INVALID_PLAYER_ID){
								givePlayerUang(ownerId, beliRate);
							}else{
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, houseInfo[id][hOwner]);
								mysql_tquery(koneksi, pQuery[playerid]);

								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `save_house` = 0 WHERE `save_house` = '%d'", id);
								mysql_tquery(koneksi, pQuery[playerid]);
							}
						}

						DestroyDynamicPickup(housePickup[id]);
						DestroyDynamic3DTextLabel(houseTextInfo[id]);
						houseId[housePickup[id]] = -1;
						housePickup[id] = -1;
						houseInfo[id][hID] = -1;
						houseInfo[id][hOwner] = -1;
						houseInfo[id][hOwnerName][0] = EOS;
						houseInfo[id][hLevel] = 0;
						houseInfo[id][hHarga] = 0;
						houseInfo[id][hKunci] = 1;
						houseInfo[id][hJual] = 0;
						houseInfo[id][icon_x] = 0;
						houseInfo[id][icon_y] = 0;
						houseInfo[id][icon_z] = 0;

						mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `house` WHERE `id_house` = '%d'", id);
						mysql_tquery(koneksi, pQuery[playerid]);
						format(pmsg, sizeof(pmsg),  TAG_RUMAH" "WHITE"Anda berhasil menghapus rumah (id:"YELLOW"%d"WHITE")!", id);
						SendClientMessage(playerid, COLOR_GREEN, pmsg);
					}else{
						SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "RED"Maaf ID Rumah tidak ada!");
					}
				}
				MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT * FROM `house` WHERE `id_house` = '%d'", id);
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
						new beliRate = getHousePrice(i, "beli");
						new ownerId = INVALID_PLAYER_ID;
						foreach(new j : Player){
							if(PlayerInfo[j][pID] == houseInfo[i][hOwner]){
								ownerId = j;
								break;
							}
						}
						
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
						houseInfo[i][hOwnerName][0] = EOS;
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

				mysql_tquery(koneksi, "UPDATE `user` SET `save_house` = 0");
				mysql_tquery(koneksi, "TRUNCATE TABLE `house`");
				SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "YELLOW"Anda berhasil menghapus semua rumah!");
			}
			return 1;
		}
		case DIALOG_INFO_RUMAH:
		{
			if(response){
				new infoRumah[128], id, houseLevel, beliRate;
				GetPVarString(playerid, "info_rumah", infoRumah, 128);
				id = houseId[lastHousePickup[playerid]];
				houseLevel = houseInfo[id][hLevel];
				beliRate = getHousePrice(id, "beli");
				if(sama("set_harga_rumah", infoRumah)){
					if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_INPUT, "Ubah Harga Rumah", RED"Harga tidak boleh kosong!\n"WHITE"Silahkan input harga berupa angka.", "Jual", "Batal");
					if(!isnumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_INPUT, "Ubah Harga Rumah", RED"Harga tidak valid!\n"WHITE"Anda harus menginput harga berupa angka.", "Jual", "Batal");
					if(strval(inputtext) < 0 || strval(inputtext) > MAXIMAL_MONEY_TRADE) return ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_INPUT, "Ubah Harga Rumah", RED"Harga tidak valid!\n"WHITE"Silahkan input harga minimal 0 dan maksimal 9999999.\nJika anda mengisi 0 harga akan default, sesuai level dan harga beli.", "Jual", "Batal");
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
							mysql_tquery(koneksi, pQuery[playerid]);
						 	reloadHouseLabel(id);
							SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "YELLOW"Rumah anda batal untuk dijual!");
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
							mysql_tquery(koneksi, pQuery[playerid]);
						 	reloadHouseLabel(id);
							format(msg, sizeof(msg),  TAG_RUMAH" "YELLOW"Rumah anda berhasil untuk dijual dengan harga ("GREEN"%d"YELLOW")!", setHarga);
							SendClientMessage(playerid, COLOR_GREEN, msg);
							DeletePVar(playerid, "info_rumah");
						}
						case 2:
						{
							label_upgrade_rumah:							    
							if(houseLevel < MAX_HOUSES_LEVEL){
								new upgradeRate = getHousePrice(id, "upgrade");
								if(getUangPlayer(playerid) < upgradeRate) return SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "RED"Maaf uang anda tidak mencukupi!");

								inline responseQuery(){
									new terpasang, cukup;
									cache_get_value_name_int(0, "terpasang", terpasang);
									cache_get_value_name_int(0, "cukup", cukup);
									if(!cukup) return sendPesan(playerid, COLOR_ORANGE, "SERVER: "WHITE"Anda harus memiliki %d kayu untuk upgrade ke level selanjutnya.", getKayuForUpgradeHouse(houseInfo[id][hLevel]));
									if(!terpasang){
										givePlayerUang(playerid, -upgradeRate);
										tambahItemPlayer(playerid, 25, -getKayuForUpgradeHouse(houseInfo[id][hLevel]));

										houseInfo[id][hLevel] = houseLevel + 1;

										mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `level` = '%d'", houseInfo[id][hLevel]);
										mysql_tquery(koneksi, pQuery[playerid]);
										reloadHouseLabel(id);
										sendPesan(playerid, COLOR_GREEN, TAG_RUMAH" "WHITE"Anda berhasil mengupgrade rumah ke level %d.", houseInfo[id][hLevel]);
										sendPesan(playerid, COLOR_YELLOW, "[INFO] "WHITE"Anda telah dikenakan harga "GREEN"$%d", upgradeRate);
										return 1;
									}else{
										return sendPesan(playerid, COLOR_GREEN, TAG_RUMAH" "RED"Anda harus melepas semua furniture di dalam rumah terlebih dahulu!");
									}
								}
								MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT(SELECT COUNT(*) FROM house_furniture WHERE id_house = '%d') as terpasang, (SELECT COUNT(*) FROM user_item WHERE id_user = '%d' AND id_item = '%d' AND jumlah >= '%d') as cukup", id, PlayerInfo[playerid][pID], 25, getKayuForUpgradeHouse(houseInfo[id][hLevel]));
							}else{
								SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "RED"Maaf level rumah anda sudah maksimal!");
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
								SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "YELLOW"Anda berhasil membuka kunci rumah!");
							}else{
								houseInfo[id][hKunci] = 1;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `kunci` = '%d'", houseInfo[id][hKunci]);
							    mysql_tquery(koneksi, pQuery[playerid]);
								SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "YELLOW"Anda berhasil mengunci rumah!");
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
								SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "YELLOW"Anda berhasil membatalkan spawn disini!");
							}else{
								PlayerInfo[playerid][sHouse] = id;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `save_house` = '%d' WHERE `id` = '%d'", id, PlayerInfo[playerid][pID]);
							    mysql_tquery(koneksi, pQuery[playerid]);
								SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "YELLOW"Anda berhasil menyimpan spawn disini!");
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
							if(PlayerInfo[playerid][uang] < beliRate) return SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "RED"Maaf uang anda tidak mencukupi!");
							if(houseInfo[id][hOwner] != -1){
								new ownerId = INVALID_PLAYER_ID;
								foreach(new i : Player){
									if(PlayerInfo[i][pID] == houseInfo[id][hOwner]){
										ownerId = i;
										break;
									}
								}								
								if(ownerId != INVALID_PLAYER_ID){
									givePlayerUang(ownerId, beliRate);
								}else{
									mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, houseInfo[id][hOwner]);
				   			 		mysql_tquery(koneksi, pQuery[playerid]);

				   			 		mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `save_house` = 0 WHERE `save_house` = '%d'", id);
									mysql_tquery(koneksi, pQuery[playerid]);
								}
							}
							givePlayerUang(playerid, -beliRate);

						    houseInfo[id][hOwner] = PlayerInfo[playerid][pID];
							// Update house owner name
							format(houseInfo[id][hOwnerName], MAX_PLAYER_NAME + 1, "%s", PlayerInfo[playerid][pPlayerName]);
						    houseInfo[id][hJual] = 0;
						    mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `id_user` = '%d', `jual` = 0 WHERE `id_house` = '%d'", PlayerInfo[playerid][pID], id);
						    mysql_tquery(koneksi, pQuery[playerid]);
						    reloadHouseLabel(id);
						    format(msg, sizeof(msg),  TAG_RUMAH" "WHITE"Anda telah berhasil membeli rumah (id:"YELLOW"%d"WHITE"), dengan harga ("YELLOW"%d"WHITE")!", houseInfo[id][hID], beliRate);
						    SendClientMessage(playerid, COLOR_GREEN, msg);
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
							format(pDialog[playerid], sizePDialog, "No : %d\nLevel : %d\nHarga : %d\nStatus : %s\nPemilik : %s\nTerkunci : %s", id, houseLevel, beliRate, houseJual, houseInfo[id][hOwnerName], houseKunci);
							ShowPlayerDialog(playerid, DIALOG_TENTANG_RUMAH, DIALOG_STYLE_MSGBOX, "Tentang Rumah", pDialog[playerid], "Kembali", "Batal");
							DeletePVar(playerid, "info_rumah");
						}
						case 1:
						{
							label_masuk_rumah:
							new id_level = houseInfo[id][hLevel];
							if(houseInfo[id][hKunci] != 1){
								pindahkanPemain(playerid, HouseLevel[id_level][intSpawn][0], HouseLevel[id_level][intSpawn][1], HouseLevel[id_level][intSpawn][2], HouseLevel[id_level][intSpawn][3], HouseLevel[id_level][intSpawnInterior], id);
								SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "YELLOW"Anda berhasil masuk rumah!");
							}else{
								if(houseInfo[id][hOwner] == PlayerInfo[playerid][pID]){
									pindahkanPemain(playerid, HouseLevel[id_level][intSpawn][0], HouseLevel[id_level][intSpawn][1], HouseLevel[id_level][intSpawn][2], HouseLevel[id_level][intSpawn][3], HouseLevel[id_level][intSpawnInterior], id);
									SendClientMessage(playerid, COLOR_YELLOW, "Rumah: "WHITE"Ketik "YELLOW"/house "WHITE"untuk mengelola inventory & furniture rumah.");
								}else{
									SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "RED"Maaf rumah terkunci dan tidak dapat masuk!");
								}
							}
							DeletePVar(playerid, "info_rumah");
						}
					}
				}else if(sama("trashM_rumah", infoRumah)){
					switch(listitem){
						case 0:
						{
							goto label_tentang_rumah;
						}
						case 1:
						{
							// Ambil Sampah
							if(trashM_BagCap[playerid] == 1) return error_command(playerid, "Anda sedang membawa sampah, taruh ke dalam truk sampah terlebih dahulu!");
							trashM_BagCap[playerid] = 1;
							trashM_HouseTake[playerid][trashM_House[playerid]] = 1;
							SetPlayerArmedWeapon(playerid, 0);
							SetPlayerAttachedObject(playerid, TRASH_ATTACH_INDEX, 1264, 6, 0.222, 0.024, 0.128, 1.90, -90.0, 0.0, 0.5,0.5, 0.5);
							GameTextForPlayer(playerid, "~y~Terus Bekerja", 2000, 3);
							ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
							SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "WHITE"Anda berhasil mengangkut sampah ke dalam tas sampah.");
							new houseClosest = GetClosestHouse(playerid, 10, 10000, 1);
							if(houseClosest == -1){
								error_command(playerid, "Mohon maaf sampah tidak tersedia untuk di ambil, silahkan kembali.");
								TogglePlayerAllDynamicCPs(playerid, 1);
								SetPlayerCheckpoint(playerid, 1644.5551,-1537.3542,13.5697, 3.0);
								return 1;
							}
							trashM_House[playerid] = houseClosest;
							trashM_X[playerid] = houseInfo[houseClosest][icon_x];
							trashM_Y[playerid] = houseInfo[houseClosest][icon_y];
							trashM_Z[playerid] = houseInfo[houseClosest][icon_z];
							SetPlayerCheckpoint(playerid, trashM_X[playerid], trashM_Y[playerid], trashM_Z[playerid], 3.0);
							PlayerInfo[playerid][activeMarker] = true;
						}
					}
				}else if(sama("pizza_rumah", infoRumah)){
					switch(listitem){
						case 0:
						{
							goto label_tentang_rumah;
						}
						case 1:
						{
							// Taruh Pizza
							if(pizza_Carry[playerid] != 1) return error_command(playerid, "Anda tidak membawa pizza, silahkan ambil pizza terlebih dahulu!");
							pizza_Carry[playerid] = 0;
							pizza_HouseDrop[playerid]++;
							pizza_HouseTake[playerid][pizza_House[playerid]] = 1;
							if(IsPlayerAttachedObjectSlotUsed(playerid, PIZZA_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, PIZZA_ATTACH_INDEX);
							GameTextForPlayer(playerid, "~y~Terus Bekerja", 2000, 3);
							ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
							SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "WHITE"Anda berhasil menaruh pizza di depan rumah.");
							if(pizza_HouseDrop[playerid] == DROP_PIZZA_LIMIT){
								TogglePlayerAllDynamicCPs(playerid, 1);
								SetPlayerCheckpoint(playerid, 2092.4819,-1829.4832,13.5568, 3.0);
								PlayerInfo[playerid][activeMarker] = true;
								return 1;
							}
							new houseClosest = GetClosestHouse(playerid, 10, 10000, 1);
							if(houseClosest == -1){
								error_command(playerid, "Mohon maaf saat ini pembeli tidak tersedia, silahkan kembali.");
								TogglePlayerAllDynamicCPs(playerid, 1);
								SetPlayerCheckpoint(playerid, 2092.4819,-1829.4832,13.5568, 3.0);
								return 1;
							}
							pizza_House[playerid] = houseClosest;
							pizza_X[playerid] = houseInfo[houseClosest][icon_x];
							pizza_Y[playerid] = houseInfo[houseClosest][icon_y];
							pizza_Z[playerid] = houseInfo[houseClosest][icon_z];
							SetPlayerCheckpoint(playerid, pizza_X[playerid], pizza_Y[playerid], pizza_Z[playerid], 3.0);
							PlayerInfo[playerid][activeMarker] = true;
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
				cmd_houseinfo(playerid, "");
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

				new index_barang = GetPVarInt(playerid, "bBarang_index"),
					nama_item[50];
				getNamaByIdItem(BARANG_MARKET[index_barang][idItemMarket], nama_item);
				SetPVarInt(playerid, "bBarang_jumlah", banyak_barang);
				
				format(pDialog[playerid], sizePDialog, "Anda akan membeli barang "YELLOW"%s "WHITE"sebanyak "YELLOW"%d "WHITE"dengan total harga "GREEN"%d"WHITE".\nApakah anda yakin?", nama_item, banyak_barang, BARANG_MARKET[index_barang][hargaItemMarket] * banyak_barang);
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
				new harga = jumlah * BARANG_MARKET[index_barang][hargaItemMarket],
					nama_item[50];
				getNamaByIdItem(BARANG_MARKET[index_barang][idItemMarket], nama_item);
				if(getUangPlayer(playerid) < harga) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Uang anda tidak mencukupi.", WHITE"Maaf uang anda tidak mencukupi!", "Ok", "");

				if(CekJikaInventoryPlayerMuat(playerid, BARANG_MARKET[index_barang][idItemMarket], jumlah)){
					tambahItemPlayer(playerid, BARANG_MARKET[index_barang][idItemMarket], jumlah);
					givePlayerUang(playerid, -harga);

					format(pDialog[playerid], sizePDialog, "Anda berhasil membeli "YELLOW"%s"WHITE".\nSebanyak "YELLOW"%d"WHITE" dengan harga "GREEN"%d", nama_item, jumlah, harga);
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli barang", pDialog[playerid], "Ok", "");

					DeletePVar(playerid, "bBarang_index");
					DeletePVar(playerid, "bBarang_jumlah");
				}else{
					dialogInventoryItemTidakMuat(playerid, jumlah, GetSlotInventoryPlayer(playerid), BARANG_MARKET[index_barang][idItemMarket]);
				}
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
				
				if(CekJikaInventoryPlayerMuat(playerid,ID_PAS_FOTO,jumlah)){
					tambahItemPlayer(playerid, ID_PAS_FOTO, jumlah);
					givePlayerUang(playerid, -harga);

					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli foto", WHITE"Anda berhasil membeli foto, foto anda sudah masuk inventory.\nSilahkan cek pada inventory anda.", "Ok", "");
					DeletePVar(playerid, "foto_jumlahFoto");
				}else{
					dialogInventoryItemTidakMuat(playerid, jumlah, GetSlotInventoryPlayer(playerid), ID_PAS_FOTO);
				}
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
		case DIALOG_RESEPSIONIS_PEMERINTAH:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						showDialogResepsionisKTP(playerid);
						return 1;
					}
					case 1:
					{
						if(!isnull(PlayerInfo[playerid][nomorHP])) return server_message(playerid, "Maaf anda telah memiliki nomor HP");
						// Dalam detik
						if(getTotalLamaBermain(playerid) < 3600 * MINIMAL_WAKTU_BERMAIN_UNTUK_BUAT_NOMOR){
							return server_message(playerid, "Maaf minimal waktu bermain yang dibutuhkan adalah 6 jam.");
						}

						ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP yang diinginkan", WHITE"Masukan nomor HP yang ingin digunakan.\n\n* Nomor HP harus terdiri dari 4 angka.\n* Nomor HP anda akan dicek keunik-annya, dimana setiap orang memiliki nomor HP yang berbeda.", "Simpan", "Batal");
					}
					case 2: // Perpanjang Masa Aktif Nomor HP
					{
						if(isnull(PlayerInfo[playerid][nomorHP])) return server_message(playerid, "Anda harus memiliki nomor HP yang telah terdaftar lebih dahulu.");

						inline responseQuery(){
							new expired[100];
							cache_get_value_name(0, "expired", expired);

							if(gettime() > PlayerInfo[playerid][masaAktifNomor])
								format(pDialog[playerid], sizePDialog, RED"Masa aktif nomor anda telah berakhir "WHITE"pada %s.\n", expired);
							else
								format(pDialog[playerid], sizePDialog, LIGHT_BLUE"Nomor anda aktif "WHITE"hingga %s.\n", expired);
							strcat(pDialog[playerid], "\nAnda dapat memperpanjangnya disini.\n\n"YELLOW"Anda akan dikenakan biaya sebesar "GREEN"$100 "WHITE"untuk setiap kali perpanjangan.\n");
							strcatEx(pDialog[playerid], sizePDialog, YELLOW"Perpanjangan akan menambah masa aktif sebanyak %d hari.\n"WHITE"Apakah anda yakin?", MASA_AKTIF_SETIAP_PERPANJANG_NOMOR);

							ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_PERPANJANG_NOMOR_HP, DIALOG_STYLE_MSGBOX, "Perpanjang nomor", pDialog[playerid], "Perpanjang", "Kembali");
						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT DATE_FORMAT(masa_aktif_nomor, \"%%W, %%d-%%M-%%Y %%H:%%i:%%S\") AS expired FROM `user` WHERE id = %d", PlayerInfo[playerid][pID]);
					}
				}
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_PERPANJANG_NOMOR_HP:
		{
			if(response){
				if(getUangPlayer(playerid) < 100) return server_message(playerid, "Anda tidak memiliki cukup uang untuk membayar.");

				givePlayerUang(playerid, -100);

				// Jika belum expired maka tambahkan saja
				if(gettime() < PlayerInfo[playerid][masaAktifNomor])
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET masa_aktif_nomor = DATE_ADD(masa_aktif_nomor, INTERVAL %d DAY) WHERE id = %d", MASA_AKTIF_SETIAP_PERPANJANG_NOMOR, PlayerInfo[playerid][pID]);
				else // Jika sudah expired maka timpa dengan hari yang baru
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET masa_aktif_nomor = NOW() + INTERVAL %d DAY WHERE id = %d", MASA_AKTIF_SETIAP_PERPANJANG_NOMOR, PlayerInfo[playerid][pID]);
				mysql_tquery(koneksi, pQuery[playerid]);

				inline responseQuery(){
					new expired[100], masa_aktif_nomor[100];
					cache_get_value_name(0, "masa_aktif_nomor", masa_aktif_nomor);
					cache_get_value_name(0, "expired", expired);
					PlayerInfo[playerid][masaAktifNomor] = convStrSqlDateIntoUnix(masa_aktif_nomor);
					format(pDialog[playerid], sizePDialog, GREEN"Berhasil menambahkan masa aktif anda sebanyak %d hari.\n"WHITE"Masa aktif anda saat ini "YELLOW"%s\n\n", MASA_AKTIF_SETIAP_PERPANJANG_NOMOR, expired);
					strcat(pDialog[playerid], WHITE"Masa aktif mempengaruhi orang lain untuk dapat menghubungi anda.\nMasa aktif pada nomor anda akan berkurang secara real-time sesuai dengan tanggal yang tertera.\nTerima kasih.");
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Masa diperpanjang", pDialog[playerid], "Ok", "");
				}
				MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT DATE_FORMAT(masa_aktif_nomor, \"%%W, %%d-%%M-%%Y %%H:%%i:%%S\") AS expired, masa_aktif_nomor FROM `user` WHERE id = %d", PlayerInfo[playerid][pID]);
			}
			return 1;
		}
		case DIALOG_RESEPSIONIS_PILIH_KTP:
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
			}
			else
				showDialogResepsionis(playerid);
			return 1;
		}
		case DIALOG_CONFIRM_BUAT_KTP:
		{
			if(response){
				if(getUangPlayer(playerid) < 100) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Gagal membuat KTP", WHITE"Maaf uang yang diperlukan tidak mencukupi.", "Ok", "");

				static const barang_barang[2][2] = {
					{5, 4}, // Pas foto - 4 biji
					{6, 2}  // Materai - 2 biji
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
						
						ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk ke dalam akun bank anda.", "Deposit", "Kembali");
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
								format(string, sizeof(string), "%s%d\t%s\t$%d\n", string, i, GetVehicleModelName(PVeh[i][pVehModel]), BIAYA_PERBAIKI_KENDARAAN);
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
			new fungsi_callback_gagal[50];
			GetPVarString(playerid, "metode_callback_gagal", fungsi_callback_gagal, sizeof(fungsi_callback_gagal));
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
							DeletePVar(playerid, "metode_callback_gagal");
							DeletePVar(playerid, "metode_keterangan_atm");
							CallRemoteFunction(fungsi_callback_gagal, "i", playerid);
							return showDialogPesan(playerid, RED"Tidak memiliki ATM", WHITE"Anda tidak memiliki ATM.\nSilahkan buat ATM terlebih dahulu untuk menggunakan metode ini.");
						}
						if(PlayerInfo[playerid][ePhone] < 2) {
							DeletePVar(playerid, "metode_nominal");
							DeletePVar(playerid, "metode_callback_sukses");
							DeletePVar(playerid, "metode_callback_gagal");
							DeletePVar(playerid, "metode_keterangan_atm");
							CallRemoteFunction(fungsi_callback_gagal, "i", playerid);
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
				CallRemoteFunction(fungsi_callback_gagal, "i", playerid);
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_BAYAR_CASH:
		{
			if(response){
				new nominal = GetPVarInt(playerid, "metode_nominal"), fungsi_callback_sukses[50], fungsi_callback_gagal[50];
				GetPVarString(playerid, "metode_callback_sukses", fungsi_callback_sukses, 50);
				GetPVarString(playerid, "metode_callback_gagal", fungsi_callback_gagal, 50);
				new langsung_potong = GetPVarInt(playerid, "metode_langsung_potong");

				
				DeletePVar(playerid, "metode_langsung_potong");
				DeletePVar(playerid, "metode_nominal");
				DeletePVar(playerid, "metode_callback_gagal");
				DeletePVar(playerid, "metode_callback_sukses");
				DeletePVar(playerid, "metode_keterangan_atm");
				if(nominal > getUangPlayer(playerid)){
					CallRemoteFunction(fungsi_callback_gagal, "i", playerid);
					return showDialogPesan(playerid, RED"Uang tidak mencukupi", WHITE"Uang anda tidak mencukupi untuk melakukan pembelian ini.\nSelalu pastikan untuk mempunyai uang yang cukup sebelum melakukan pembelian.");
				}

				if(langsung_potong)
					givePlayerUang(playerid, -nominal);
				
				if(fungsi_callback_sukses[0] != EOS)
					// Keterangan ATM dikasih dummy text untuk formalitas saja
					CallRemoteFunction(fungsi_callback_sukses, "iiis", playerid, METODE_BAYAR_CASH, nominal, "a");
				else{
					CallRemoteFunction(fungsi_callback_gagal, "i", playerid);
					printf("[ERROR] #009-A Callback Error di metode pembayaran cash.");
				}
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
					new nominal = GetPVarInt(playerid, "metode_nominal"), fungsi_callback_sukses[50], keterangan_atm[50], saldo, fungsi_callback_gagal[50];
					GetPVarString(playerid, "metode_callback_sukses", fungsi_callback_sukses, sizeof(fungsi_callback_sukses));
					GetPVarString(playerid, "metode_callback_gagal", fungsi_callback_gagal, sizeof(fungsi_callback_gagal));
					GetPVarString(playerid, "metode_keterangan_atm", keterangan_atm, sizeof(keterangan_atm));
					new langsung_potong = GetPVarInt(playerid, "metode_langsung_potong");

					DeletePVar(playerid, "metode_langsung_potong");
					DeletePVar(playerid, "metode_nominal");
					DeletePVar(playerid, "metode_callback_sukses");
					DeletePVar(playerid, "metode_keterangan_atm");

					cache_get_value_name_int(0, "saldo", saldo);

					if(saldo > nominal){
						if(langsung_potong)
							addTransaksiTabungan(PlayerInfo[playerid][nomorRekening], -nominal, keterangan_atm);

						if(fungsi_callback_sukses[0] != EOS)
							CallRemoteFunction(fungsi_callback_sukses, "iiis", playerid, METODE_BAYAR_EBANKING, nominal, keterangan_atm);
						else{
							CallRemoteFunction(fungsi_callback_gagal, "i", playerid);
							printf("[ERROR] #009-B Callback Error di metode pembayaran atm.");
						}
					}else{
						CallRemoteFunction(fungsi_callback_gagal, "i", playerid);
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
					format(keterangan, 50, "biaya perbaikan %s", GetVehicleModelName(PVeh[idpv][pVehModel]));
					SetPVarInt(playerid, "fixbayar_idpv", idpv);
					dialogMetodeBayar(playerid, BIAYA_PERBAIKI_KENDARAAN, "selesaiBayarKerusakanKendaraan", keterangan);
				}
				else
					showDialogKesalahanSistem(playerid, "invalid vehicle id saat memilih kendaraan rusak");
			}
			// else
			// 	showDialogTellerBank(playerid);
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
			}
			// else{
			// 	showDialogTellerBank(playerid);
			// }
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
				if(sscanf(inputtext, "i", nominal)) return ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", RED"Anda harus memasukan nominal dengan benar!\n"WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk ke dalam akun bank anda.", "Deposit", "Kembali");

				if(nominal < 10) return ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", RED"Anda harus memasukan nominal dengan benar, minimal penabungan adalah $10.\n"WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk ke dalam akun bank anda.", "Deposit", "Kembali");

				if(getUangPlayer(playerid) < nominal) return ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", RED"Anda harus memasukan nominal dengan benar, nominal yang anda masukan melebihi uang anda.\n"WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk ke dalam akun bank anda.", "Deposit", "Kembali");

				SetPVarInt(playerid, "depo_nominal", nominal);
				
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan menyimpan uang sebesar "GREEN"$%d "WHITE"pada tabungan anda.\nApakah anda yakin?\n\n"YELLOW"Pada saat uang disimpan anda dapat melihat nominalnya pada tabungan anda atau pada website.", nominal);
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_DEPOSIT, DIALOG_STYLE_MSGBOX, YELLOW"Konfirmasi penyimpanan", pDialog[playerid], "Simpan", "Batal");
			}
			// else
			// 	showDialogTellerBank(playerid);
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
				PlayerAtmAnimation(playerid); // Playing while choosing dialog
				
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
				PlayerAtmAnimation(playerid); // Playing while choosing dialog

				new nominal;
				if(sscanf(inputtext, "i", nominal)) return ShowPlayerDialog(playerid, DIALOG_TRANSFER_NOMINAL, DIALOG_STYLE_INPUT, "Nominal yang ingin ditransfer", RED"Nominal salah, silahkan memasukan jumlah yang benar.\n"WHITE"Masukan nominal yang ingin ditransfer:\n"YELLOW"Pastikan bahwa nominal yang ingin anda transfer tidak melebihi saldo tabungan anda.", "Ok", "Batal");
				if(nominal < 10 || nominal > MAXIMAL_MONEY_TRADE) return ShowPlayerDialog(playerid, DIALOG_TRANSFER_NOMINAL, DIALOG_STYLE_INPUT, "Nominal yang ingin ditransfer", RED"Minimal nominal adalah $10 dan maksimal $999,999.\n"WHITE"Masukan nominal yang ingin ditransfer:\n"YELLOW"Pastikan bahwa nominal yang ingin anda transfer tidak melebihi saldo tabungan anda.", "Ok", "Batal");

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
				PlayerAtmAnimation(playerid); // Playing while choosing dialog

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
				PlayerAtmAnimation(playerid); // Playing while choosing dialog

				showDialogATM(playerid);
			}
			return 1;
		}
		case DIALOG_INFO_HISTORY_ATM:
		{
			if(response){
				PlayerAtmAnimation(playerid); // Playing while choosing dialog

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
			}
			// else
			// 	ShowPlayerDialog(playerid, DIALOG_MENU_GAJI, DIALOG_STYLE_LIST, WHITE"Pilihan gaji :", WHITE"Ambil Gaji\nLihat Gaji", "Pilih", "Kembali");
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
		case DIALOG_KONFIRMASI_AMBIL_GAJI:
		{
			if(response){
				ShowPlayerDialog(playerid, DIALOG_PILIHAN_AMBIL_GAJI, DIALOG_STYLE_LIST, WHITE"Pilihan ambil gaji :", WHITE"Masukin ke saldo Bank\nAmbil uang cash", "Pilih", "Batal");
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

				new const idx = GetPVarInt(playerid, "bmakan_index");

				if(!CekJikaInventoryPlayerMuat(playerid, MENU_MAKANAN[idx][idItemMakanan], jumlah)){	
					return dialogInventoryItemTidakMuat(playerid, jumlah, GetSlotInventoryPlayer(playerid), MENU_MAKANAN[idx][idItemMakanan]);
				}

				new
					keterangan[50],
					nama_item[50];

				SetPVarInt(playerid, "bmakan_jumlah", jumlah);

				getNamaByIdItem(MENU_MAKANAN[idx][idItemMakanan], nama_item);
				format(keterangan, 50, "Beli %s sebanyak %d", nama_item, jumlah);
				dialogMetodeBayar(playerid, MENU_MAKANAN[idx][hargaMakanan] * jumlah, "selesaiBeliMakanan", keterangan);
			}else{
				DeletePVar(playerid, "bmakan_index");
				DeletePVar(playerid, "bmakan_jumlah");

				showDialogTempatMakan(playerid);
			}
			return 1;
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
				SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "YELLOW"Anda berhasil bekerja sebagai "GREEN"Sweeper"YELLOW"!");
				sendPesan(playerid, COLOR_GREEN, TAG_JOB" "WHITE"Anda memiliki waktu %d menit, jika belum selesai anda akan gagal.", TIME_SWEEPER);
				todoTimeout[playerid] = SetPreciseTimer("resetPlayerToDo", TIME_SWEEPER*60000, false, "i", playerid);
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
						ShowPlayerDialog(playerid, DIALOG_SIM_REGIS_TYPE, DIALOG_STYLE_LIST, WHITE"Pilihan jenis kendaraan SIM", "SIM A\nSIM B\nSIM C", "Pilih", "Kembali");
					}
					// Tipe Kendaraan
					case 1:
					{
						format(pDialog[playerid], sizePDialog, "SIM adalah bukti kepada seseorang yang telah memenuhi persyaratan administrasi, memahami peraturan lalu lintas dan terampil berkendara.\n");
						strcatEx(pDialog[playerid], sizePDialog, "Ada 3 tipe SIM kendaraan yaitu :\n");
						strcatEx(pDialog[playerid], sizePDialog, "1. SIM A, SIM untuk mengendarai kendaraan berupa mobil pribadi.\n");
						strcatEx(pDialog[playerid], sizePDialog, "2. SIM B, SIM untuk mengendarai kendaraan berupa mobil penumpang atau barang.\n");
						strcatEx(pDialog[playerid], sizePDialog, "3. SIM C, SIM untuk mengendarai kendaraan berupa motor.\n");
						strcatEx(pDialog[playerid], sizePDialog, "Jika anda sudah mengetahui info dan tipe SIM kendaraan, diharapkan anda paham ketika melakukan pendaftaraan SIM.");
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Tentang SIM", pDialog[playerid], "Ok", "");
					}
					// Ambil SIM yang sudah selesai
					case 2:
					{
						if(todoActive(playerid) == 1){
							return 1;
						}
						inline responseQuery(){
							if(cache_num_rows()){
								getSudahBuatSIM(playerid, "cekSudahBisaAmbilSIM", false);
							}else{
								showDialogPesan(playerid, RED"Anda Belum Ujian Praktik", WHITE"Maaf anda belum melakukan Ujian Praktik SIM, anda belum dapat mengambil SIM!\nSilahkan melakukan Ujian Praktik SIM terlebih dahulu, tempat Ujian Praktik SIM berada di sebelah Kantor Polisi Los Santos (Parkiran).");
							}
						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT tanggal_buat FROM `pengambilan_sim` WHERE `id_user` = '%d' AND tanggal_buat != NULL", PlayerInfo[playerid][pID]);
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
				if(noSoal == 0){
					poinSim[playerid] = 0;
				}
				if(noSoal >= 1){
					if(sama(SIM_SOAL[0][simAnswer3], inputtext) && noSoal == 1){
						poinSim[playerid] += SIM_SOAL[0][simAnswerTrue];
					}else if(sama(SIM_SOAL[1][simAnswer1], inputtext) && noSoal == 2){
						poinSim[playerid] += SIM_SOAL[1][simAnswerTrue];
					}else if(sama(SIM_SOAL[2][simAnswer4], inputtext) && noSoal == 3){
						poinSim[playerid] += SIM_SOAL[2][simAnswerTrue];
					}else if(sama(SIM_SOAL[3][simAnswer3], inputtext) && noSoal == 4){
						poinSim[playerid] += SIM_SOAL[3][simAnswerTrue];
					}else if(sama(SIM_SOAL[4][simAnswer4], inputtext) && noSoal == 5){
						poinSim[playerid] += SIM_SOAL[4][simAnswerTrue];
					}else if(sama(SIM_SOAL[5][simAnswer1], inputtext) && noSoal == 6){
						poinSim[playerid] += SIM_SOAL[5][simAnswerTrue];
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
						DeletePVar(playerid, "tipe_sim");
						SetPlayerVirtualWorld(playerid, 1);
						return 1;
					}else{
						new tipeSIM = GetPVarInt(playerid, "tipe_sim");
						GameTextForPlayer(playerid, "~g~Ujian Teori Selesai", 2000, 3);
						format(pDialog[playerid], sizePDialog, WHITE"Anda mendapatkan poin sebesar "GREEN"%d"WHITE".\nSilahkan melanjutkan untuk Ujian Praktik SIM."WHITE"\nTempat Ujian Praktik SIM berada di seberang Kantor Polisi Los Santos.\n\nTerimakasih, Salam hangat "ORANGE"Kantor Polisi Lost Santos", poinSim[playerid]);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil Ujian Teori SIM", pDialog[playerid], "Ok", "");
						poinSim[playerid] = 0;
						DeletePVar(playerid, "sim_soal");
						DeletePVar(playerid, "tipe_sim");
						SetPlayerVirtualWorld(playerid, 1);
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO pengambilan_sim(id_user,tipe_sim,status_teori) VALUES('%d','%d',1)", PlayerInfo[playerid][pID],tipeSIM);
						mysql_tquery(koneksi, pQuery[playerid]);
						return 1;
					}
				}
				if(noSoal != 6){
					format(pDialog[playerid], sizePDialog, "%s\n%s\n%s\n%s", SIM_SOAL[noSoal][simAnswer1], SIM_SOAL[noSoal][simAnswer2], SIM_SOAL[noSoal][simAnswer3], SIM_SOAL[noSoal][simAnswer4]);
					SendClientMessage(playerid, -1, SIM_SOAL[noSoal][simQuestionMSG]);
					ShowPlayerDialog(playerid, DIALOG_SIM_SOAL, DIALOG_STYLE_LIST, SIM_SOAL[noSoal][simQuestion], pDialog[playerid], "Lanjut", "Batal");
					SetPVarInt(playerid, "sim_soal", noSoal+1);
				}
			}else{
				poinSim[playerid] = 0;
				DeletePVar(playerid, "sim_soal");
				DeletePVar(playerid, "tipe_sim");
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

						foreach(new i : BoardIterator){
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
						return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_BUAT_PAPAN_MODEL, DIALOG_STYLE_INPUT, "Input ID Object Papan", "Input ID object papan (gunakan \"19805\" jika ingin papan biasa)\nJika ingin melihat model lain buka dev.prineside.com lalu masukan keyword \"board\"\nPastikan untuk menginputkan id yang benar.", "Ok", "Kembali");
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
		case DIALOG_ADMIN_PAPAN_BUAT_PAPAN_MODEL:
		{
			if(response){
				new modelid;
				if(sscanf(inputtext, "i", modelid))	return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_BUAT_PAPAN_MODEL, DIALOG_STYLE_INPUT, "Input ID Object Papan", "ID Object tidak valid.\nInput ID object papan (gunakan \"19805\" jika ingin papan biasa)\nJika ingin melihat model lain buka dev.prineside.com lalu masukan keyword \"board\"\nPastikan untuk menginputkan id yang benar.", "Ok", "Kembali");
				SetPVarInt(playerid, "a_model_papan", modelid);
				
				ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_BUAT_PAPAN, DIALOG_STYLE_INPUT, "Input tulisan", "Silahkan Input text yang ingin anda tulis di papan.", "Ok", "Kembali");
			}else
				showDialogAdminPapan(playerid);
			return 1;
		}
		case DIALOG_ADMIN_PAPAN_BUAT_PAPAN:
		{
			if(response){
				if(strlen(inputtext) < 1 || strlen(inputtext) > 1000) return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_BUAT_PAPAN, DIALOG_STYLE_INPUT, "Input tulisan", RED"Panjang tulisan harus antara 1 hingga 1000 karakter.\n"WHITE"Silahkan Input text yang ingin anda tulis di papan.", "Ok", "Kembali");

				new i = Iter_Free(BoardIterator);

				if(i == -1) return showDialogPesan(playerid, "Maximum", RED"Server telah mencapai batas maksimal papan.");

				Iter_Add(BoardIterator, i);

				GetPlayerPos(playerid, BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ]);
				BoardInfo[i][bModel] = GetPVarInt(playerid, "a_model_papan");
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

				SaveBoard(BoardInfo[i][bModel], BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ], BoardInfo[i][bCRX], BoardInfo[i][bCRY], BoardInfo[i][bCRZ], BoardInfo[i][bText], BoardInfo[i][bFontSiz], i, true);
			}else{
				return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN_BUAT_PAPAN_MODEL, DIALOG_STYLE_MSGBOX, "Input ID Object Papan", "Input ID object papan (gunakan \"19805\" jika ingin papan biasa)\nJika ingin melihat model lain buka dev.prineside.com lalu masukan keyword \"board\"\nPastikan untuk menginputkan id yang benar.", "Ok", "Kembali");
			}
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
				
				SaveBoard(BoardInfo[idx][bModel], BoardInfo[idx][bCX], BoardInfo[idx][bCY], BoardInfo[idx][bCZ], BoardInfo[idx][bCRX], BoardInfo[idx][bCRY], BoardInfo[idx][bCRZ], BoardInfo[idx][bText], BoardInfo[idx][bFontSiz], idx);

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

				SaveBoard(BoardInfo[idx][bModel], BoardInfo[idx][bCX], BoardInfo[idx][bCY], BoardInfo[idx][bCZ], BoardInfo[idx][bCRX], BoardInfo[idx][bCRY], BoardInfo[idx][bCRZ], BoardInfo[idx][bText], BoardInfo[idx][bFontSiz], idx);

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

								format(pDialog[playerid], sizePDialog, TAG_ADMIN_DEALER" "WHITE"Berhasil memarkirkan kendaraan dealer %s pada tempat ini.", GetVehicleModelName(DVeh[idveh][dVehModel]));
								SendClientMessage(playerid, COLOR_CYAN, pDialog[playerid]);

								EVF::SetVehicleSpawnInfo(idveh, DVeh[idveh][dVehCoord][0], DVeh[idveh][dVehCoord][1], DVeh[idveh][dVehCoord][2], DVeh[idveh][dVehCoord][3], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
							}else{
								error_command(playerid, "Ini bukan kendaraan dealer.");
							}
						}else
							error_command(playerid, "Anda hanya dapat menggunakan perintah ini di dalam kendaraan dealer.");
					}
					case 2: // Respawn all dealer vehicle
					{
						foreach(new i : DVehIterator){
							if(!IsVehicleOccupied(i)) // Respawn kendaraan yang tidak sedang dinaiki
								SetVehicleToRespawn(i);
						}
						SendClientMessage(playerid, COLOR_CYAN, TAG_ADMIN_DEALER" "WHITE"Berhasil merespawn semua kendaraan pada semua dealer!");
					}
					case 3: // Hapus kendaraan dealer
					{
						if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, TAG_ADMIN_DEALER" "WHITE"Anda harus di dalam kendaraan dealer yang ingin dihapus untuk dapat menggunakan perintah ini!");

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

							SendClientMessage(playerid, COLOR_CYAN, TAG_ADMIN_DEALER" "WHITE"Berhasil menghapus kendaraan dealer!");
						}else{
							SendClientMessage(playerid, COLOR_RED, TAG_ADMIN_DEALER" "WHITE"Kendaraan ini bukan kendaraan dealer yang dapat dihapus!");
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

				format(pDialog[playerid], sizePDialog, WHITE"Kendaraan yang terpilih adalah "GREEN"%s "WHITE"\nSilahkan masukan warna kendaraan (0 - 255).", GetVehicleModelName(GetPVarInt(playerid, "buatveh_id")));
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
				format(pDialog[playerid], sizePDialog, WHITE"Kendaraan yang terpilih adalah "GREEN"%s "WHITE"\nWarna terpilih : %d\nSilahkan masukan harga kendaraan.", GetVehicleModelName(GetPVarInt(playerid, "buatveh_id")), GetPVarInt(playerid, "buatveh_col"));
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

				format(pDialog[playerid], sizePDialog, WHITE"Kendaraan berhasil dibuat dengan stats berikut :\n"ORANGE"Nama Kendaraan : "WHITE"%s\nWarna Kendaraan : %d\n"PURPLE"Harga Kendaraan : "GREEN"$%d\n\n"WHITE"Silahkan parkirkan dimanapun anda mau, dan gunakan /aveh untuk mengakses perintah parkir kendaraan dealer.", GetVehicleModelName(modelid), warna, harga);
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
						if(!IsPlayerInAnyVehicle(playerid))
							return showDialogPesan(playerid, RED"Anda harus di dalam kendaraan", WHITE"Anda harus didalam kendaraan yang ingin dibeli, jangan keluar hingga transaksi selesai.");

						new vehid = GetPlayerVehicleID(playerid);
						
						if(!Iter_Contains(DVehIterator, vehid) || GetVehicleModel(vehid) != DVeh[vehid][dVehModel]) {
							// case dimana mobil terganti
							RemovePlayerFromVehicle(playerid);
							return 1;
						}
						SetPVarInt(playerid, "dveh_id", vehid);
						
						new temp[50];
						format(temp, 50, "membeli %s dari dealer", GetVehicleModelName(DVeh[vehid][dVehModel]));
						dialogMetodeBayar(playerid, DVeh[vehid][dVehHarga], "selesaiBeliKendaraan", temp, 0, "gagalBeliKendaraan");
					}
				}	

				MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT COUNT(*) AS total FROM vehicle WHERE id_pemilik = '%d'", PlayerInfo[playerid][pID]);
			}else{
				if(GetLevelAdminPlayer(playerid) <= 1)
					RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_AMBIL_KENDARAAN_REPARASI:
		{
			if(response){
				new idpv = strval(inputtext);
				if(Iter_Contains(PVehIterator, idpv)){
					if(PVeh[idpv][pVehPemilik] == PlayerInfo[playerid][pID]){
						if(IsPlayerInAnyDynamicArea(playerid) && GetPVarInt(playerid, "last_area") >= AREA_spawnReparasi[0] && GetPVarInt(playerid, "last_area") <= AREA_spawnReparasi[sizeof(AREA_spawnReparasi) - 1]){
							PVeh[idpv][pVehIsReparasi] = STATUS_KENDARAAN_TIDAK_RUSAK;
							updatePVehReparasi(PVeh[idpv][pVehID], STATUS_KENDARAAN_TIDAK_RUSAK);

							new id_area = GetPVarInt(playerid, "last_area") - AREA_spawnReparasi[0];
							new idveh = CreateVehicle(PVeh[idpv][pVehModel], POSISI_SPAWN_REPARASI_MOBIL[id_area][SPAWN_POINT_X], POSISI_SPAWN_REPARASI_MOBIL[id_area][SPAWN_POINT_Y], POSISI_SPAWN_REPARASI_MOBIL[id_area][SPAWN_POINT_Z], POSISI_SPAWN_REPARASI_MOBIL[id_area][SPAWN_POINT_A], PVeh[idpv][pVehColor][0], PVeh[idpv][pVehColor][1], -1);

							PVeh[idpv][pVehicle] = idveh;
							IDVehToPVeh[idveh] = idpv;
							Iter_Add(IDVehToPVehIterator, idveh);
		
							// Kita tidak mengambil ke database karena asumsinya, 
							// barang ikut hilang saat masuk ke reparasi.
							bersihkanVariabelItemVehicle(idveh);

							#if DEBUG_SERVER_LOAD == true
							printf("Vehicle Player %s Vehicle-ID(%d) ig-ID(%d) load.",PlayerInfo[playerid][pPlayerName], PVeh[idpv][pVehID], idveh);
							#endif
							
							SetVehicleToRespawn(idveh);

							SetVehicleHealth(idveh, 1000);
							PVeh[idpv][pVehDarah] = 1000;

							SetVehicleFuel(idveh, MAX_VEHICLE_FUEL);
							
							new engine, lights, alarm, doors, bonnet, boot, objective;
							GetVehicleParamsEx(idveh, engine, lights, alarm, doors, bonnet, boot, objective);
							SetVehicleParamsEx(idveh, 0, 0, alarm, doors, bonnet, boot, objective);

							PutPlayerInVehicle(playerid, idveh, 0);

							UpdatePosisiDarahVehiclePlayer(idveh);
						}else{
							server_message(playerid, "Anda harus berada pada tempat spawn reparasi.");
						}
					}
				}
			}
			return 1;
		}
		case DIALOG_MENU_DALAM_VEHICLE:
		{
			if(response){
				if(!IsPlayerInAnyVehicle(playerid)){
					showDialogPesan(playerid, RED"Kendaraan tidak valid", "Anda telah keluar dari kendaraan.\nUntuk dapat melihat info kendaraan, anda harus berada didalam kendaraan tersebut.");
					return 1;
				}

				new vehid = GetPlayerVehicleID(playerid),
					kendaraan_berpemilik = Iter_Contains(IDVehToPVehIterator, vehid);

				switch((kendaraan_berpemilik ? (listitem) : (listitem + 1))){
					case 0: // Info Vehicle
					{
						format(pDialog[playerid], sizePDialog, WHITE"Info Kendaraan "YELLOW"%s "WHITE":\n\n", GetVehicleModelName(PVeh[IDVehToPVeh[vehid]][pVehModel]));

						format(pDialog[playerid], sizePDialog, "%s"WHITE"Pemilik\t\t: "GREEN"%s\n\n", pDialog[playerid], PVeh[IDVehToPVeh[vehid]][pVehNamaPemilik]);

						format(pDialog[playerid], sizePDialog, "%s"YELLOW"Anda dapat menghidupkan/mematikan kendaraan jika anda memiliki kuncinya.", pDialog[playerid]);

						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Info Kendaraan", pDialog[playerid], "Ok", "");
						return 1;
					}
					case 1: // Tutup atau buka kap
					{
						new idpv = IDVehToPVeh[vehid];
						if(kendaraan_berpemilik && PVeh[idpv][pVehPemilik] != PlayerInfo[playerid][pID] && !( Iter_Contains(PVehKeys[playerid], idpv) && PVehKeysTime[playerid][idpv] > gettime()))
							return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Anda tidak memiliki kunci kendaraan untuk membuka kap.");

						SetVehicleParams(vehid, VEHICLE_TYPE_BONNET, ((GetVehicleParams(vehid, VEHICLE_TYPE_BONNET) + 1) % 2));					
						if(GetVehicleParams(vehid, VEHICLE_TYPE_BONNET))
							SendClientMessage(playerid, COLOR_LIGHT_BLUE, TAG_KENDARAAN" "WHITE"Berhasil membuka kap kendaraan ini.");
						else
							SendClientMessage(playerid, COLOR_LIGHT_BLUE, TAG_KENDARAAN" "WHITE"Berhasil menutup kap kendaraan ini.");
						return 1;
					}
					case 2: // Tutup atau buka bagasi
					{
						new idpv = IDVehToPVeh[vehid];
						if(kendaraan_berpemilik && PVeh[idpv][pVehPemilik] != PlayerInfo[playerid][pID] && !( Iter_Contains(PVehKeys[playerid], idpv) && PVehKeysTime[playerid][idpv] > gettime()))
							return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Anda tidak memiliki kunci kendaraan untuk membuka bagasi.");

						SetVehicleParams(vehid, VEHICLE_TYPE_BOOT, ((GetVehicleParams(vehid, VEHICLE_TYPE_BOOT) + 1) % 2));

						if(GetVehicleParams(vehid, VEHICLE_TYPE_BOOT))
							SendClientMessage(playerid, COLOR_LIGHT_BLUE, TAG_KENDARAAN" "WHITE"Berhasil membuka bagasi kendaraan ini.");
						else
							SendClientMessage(playerid, COLOR_LIGHT_BLUE, TAG_KENDARAAN" "WHITE"Berhasil menutup bagasi kendaraan ini.");
						return 1;
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
						new house_id = PlayerInfo[playerid][inHouse];
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
						tampilFurnitureHousePlayer(playerid, PlayerInfo[playerid][inHouse], DIALOG_PILIH_FURNITURE_RUMAH);
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
					tampilFurnitureHousePlayer(playerid, PlayerInfo[playerid][inHouse], DIALOG_PILIH_FURNITURE_RUMAH);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
						tampilFurnitureHousePlayer(playerid, PlayerInfo[playerid][inHouse], DIALOG_PILIH_FURNITURE_RUMAH);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						tampilFurnitureHousePlayer(playerid, PlayerInfo[playerid][inHouse], DIALOG_PILIH_FURNITURE_RUMAH);
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
				PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

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
						new house_id = PlayerInfo[playerid][inHouse];
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
				// 	new total_item;
				// 	cache_get_value_name_int(0, "total_item", total_item);
				// 	if((total_item + input_jumlah) > HouseLevel[houseInfo[GetPlayerVirtualWorld(playerid)][hLevel]][houseItemCapacity]){						
				// 		format(pDialog[playerid], sizePDialog, "Maaf inventory rumah item anda tidak memiliki cukup ruang,\nuntuk menyimpan sebanyak "ORANGE"%i "WHITE"item. Sisa ruang yang anda miliki adalah "ORANGE"(%i/%i).", input_jumlah, total_item, HouseLevel[houseInfo[GetPlayerVirtualWorld(playerid)][hLevel]][houseItemCapacity]);

				// 		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory rumah anda penuh", pDialog[playerid], "Ok", "");
				// 	}else{
				// 		tambahItemHouse(GetPlayerVirtualWorld(playerid), id_item, input_jumlah);
				// 		tambahItemPlayer(playerid, id_item, -input_jumlah);

				// 		format(pDialog[playerid], sizePDialog, "Anda berhasil menyimpan "YELLOW"%s"WHITE" ke dalam inventory rumah.\nSebanyak "YELLOW"%d"WHITE".\nAnda dapat mengambilnya kembali.", nama_item, input_jumlah);
				// 		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menyimpan barang", pDialog[playerid], "Ok", "");
				// 	}
				// 	resetPVarInventory(playerid);
				// }
				new house_id = PlayerInfo[playerid][inHouse];
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(SUM(a.jumlah * b.kapasitas), 0) as total_item FROM house_inv_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_house = '%d'", house_id);
				mysql_tquery(koneksi, pQuery[playerid], "simpanItemKeInvenRumah", "iiiis", playerid, HouseLevel[houseInfo[house_id][hLevel]][houseItemCapacity], id_item, input_jumlah, nama_item);
				// MySQL_TQueryInline(koneksi, using inline responseCek, "SELECT SUM(a.jumlah * b.kapasitas) as total_item FROM house_inv_item a INNER JOIN item b ON a.id_item = b.id_item WHERE a.id_house = '%d'", house_id);
			}
			return 1;
		}
		case DIALOG_AMBIL_ITEM_RUMAH:
		{
			if(response){
				new house_id = PlayerInfo[playerid][inHouse];
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
		case DIALOG_LUMBER_ADMIN:
		{
			if(response){
				switch(listitem){
					case 0:
					{
                        // Buat Pohon
						new Float: x, Float: y, Float: z, Float: a;
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, a);
						x += (3.0 * floatsin(-a, degrees));
						y += (3.0 * floatcos(-a, degrees));
						z -= 1.0;
						inline responseQuery(){
							new id = cache_insert_id(),
								free = Iter_Free(TreeIterator);
							new create = createTree(id, free, x, y, z, 0.0, 0.0, 0.0);
							if(create){
								treeEditID[playerid] = id;
								EditDynamicObject(playerid, DTree[id][treeObjID]);
								SendClientMessage(playerid, COLOR_GREEN, "[LUMBERJACK] "YELLOW"Anda berhasil membuat pohon!");
								SendClientMessage(playerid, COLOR_GREEN, "[LUMBERJACK] "WHITE"Anda dapat mengedit pohon sekarang atau batal untuk mengedit lain kali.");
							}else{
								treeEditID[playerid] = -1;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `lumber` WHERE `id` = '%d'", id);
								mysql_tquery(koneksi, pQuery[playerid]);
								error_command(playerid, "Tidak dapat membuat pohon lagi.");
							}
						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "INSERT INTO `lumber` (treeX, treeY, treeZ, treeRX, treeRY, treeRZ) VALUES ('%f', '%f', '%f', '0.0', '0.0', '0.0')", x, y, z);
					}
					case 1:
					{
                        // Edit Pohon
						ShowPlayerDialog(playerid, DIALOG_LUMBER_EDIT, DIALOG_STYLE_INPUT, "Edit Pohon", WHITE"Silahkan input ID pohon yang ingin diedit.", "Lanjut", "Batal");
					}
					case 2:
					{
                        // Reset Pohon
						ShowPlayerDialog(playerid, DIALOG_LUMBER_RESET, DIALOG_STYLE_INPUT, "Reset Pohon", WHITE"Apakah anda yakin ingin mereset semua rumah?\nKetik "GREEN"RESET"WHITE" jika setuju.", "Lanjut", "Batal");
					}
                    case 3:
					{
                        // Hapus Pohon
						ShowPlayerDialog(playerid, DIALOG_LUMBER_HAPUS, DIALOG_STYLE_LIST, WHITE"Hapus Pohon", "Hapus ID Pohon\nHapus Semua Pohon", "Pilih", "Batal");
					}
				}
			}
			return 1;
		}
		case DIALOG_LUMBER_EDIT:
		{
			if(response){
				new id = strval(inputtext);
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LUMBER_EDIT, DIALOG_STYLE_INPUT, "Edit Pohon", RED"ID tidak boleh kosong!\n"WHITE"Anda harus menginput ID berupa angka.", "Lanjut", "Batal");
				if(!isnumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LUMBER_EDIT, DIALOG_STYLE_INPUT, "Edit Pohon", RED"ID tidak valid!\n"WHITE"Anda harus menginput ID berupa angka.", "Lanjut", "Batal");
                if(treeEditID[playerid] != -1) return ShowPlayerDialog(playerid, DIALOG_LUMBER_EDIT, DIALOG_STYLE_INPUT, "Edit Pohon", RED"Anda sedang mengedit!\n"WHITE"Batalkan edit pohon sebelumnya, untuk melakukannya kembali.", "Lanjut", "Batal");
                if(!Iter_Contains(TreeIterator, id)) return ShowPlayerDialog(playerid, DIALOG_LUMBER_EDIT, DIALOG_STYLE_INPUT, "Edit Pohon", RED"ID tidak valid!\n"WHITE"ID pohon tidak tersedia.", "Lanjut", "Batal");
                if(DTree[id][treeTumbang]) return ShowPlayerDialog(playerid, DIALOG_LUMBER_EDIT, DIALOG_STYLE_INPUT, "Edit Pohon", RED"Pohon sedang tumbang!\n"WHITE"ID pohon tersebut sedang tumbang, tunggu hingga pulih.", "Lanjut", "Batal");
                if(!IsPlayerInRangeOfPoint(playerid, 30.0, DTree[id][treeX], DTree[id][treeY], DTree[id][treeZ])) return ShowPlayerDialog(playerid, DIALOG_LUMBER_EDIT, DIALOG_STYLE_INPUT, "Edit Pohon", RED"Pohon diluar jangkauan!\n"WHITE"ID pohon tersebut diluar jangkauan, silahkan lebih dekat dengan pohon tersebut.", "Lanjut", "Batal");
                treeEditID[playerid] = id;
                EditDynamicObject(playerid, DTree[id][treeObjID]);
			}
			return 1;
		}
		case DIALOG_LUMBER_RESET:
		{
			if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_RESET_RUMAH, DIALOG_STYLE_INPUT, "Reset Rumah", RED"Input tidak boleh kosong!\n"WHITE"Silahkan ketik "GREEN"RESET"WHITE" untuk setuju.", "Lanjut", "Batal");
			if(!sama("RESET", inputtext)) return ShowPlayerDialog(playerid, DIALOG_RESET_RUMAH, DIALOG_STYLE_INPUT, "Reset Pohon", RED"Input tidak valid!\n"WHITE"Anda harus mengetik "GREEN"RESET"WHITE" untuk setuju.", "Lanjut", "Batal");
			foreach(new i : TreeIterator){
				DTree[i][treeSecs] = 0;
				DTree[i][treeTimer] = -1;
				reloadTreeLabel(i);
			}
			SendClientMessage(playerid, COLOR_GREEN, "[LUMBERJACK] "YELLOW"Anda berhasil mereset semua pohon!");
		}
		case DIALOG_LUMBER_HAPUS:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						ShowPlayerDialog(playerid, DIALOG_LUMBER_HAPUS_ID, DIALOG_STYLE_INPUT, "Hapus Pohon", WHITE"Silahkan input ID pohon yang ingin dihapus.", "Lanjut", "Batal");
					}
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_LUMBER_HAPUS_ALL, DIALOG_STYLE_INPUT, "Hapus Pohon", WHITE"Apakah anda yakin ingin menghapus semua pohon? Ketik "GREEN"HAPUS"WHITE" untuk setuju.", "Lanjut", "Batal");
					}
				}
			}
			return 1;
		}
		case DIALOG_LUMBER_HAPUS_ID:
		{
			if(response){
				new id;
				if(sscanf(inputtext, "i", id)) return ShowPlayerDialog(playerid, DIALOG_LUMBER_HAPUS_ID, DIALOG_STYLE_INPUT, "Hapus Lumber", RED"ID tidak valid!\n"WHITE"Anda harus menginput ID berupa angka.", "Lanjut", "Batal");

				new pmsg[256];
				if(Iter_Contains(TreeIterator, id)){
					DestroyDynamicObject(DTree[id][treeObjID]);
					DestroyDynamicCP(DTree[id][treeCP]);
					DestroyDynamic3DTextLabel(DTree[id][treeLabel]);
					
					DTree[id][treeSecs] = 0;
					DTree[id][treeObjID] = DTree[id][treeTimer] = -1;
					DTree[id][treeLabel] = Text3D: -1;
					Iter_Remove(TreeIterator, id);
					
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `lumber` WHERE `id` = '%d'", id);
					mysql_tquery(koneksi, pQuery[playerid]);

					format(pmsg, sizeof(pmsg),  GREEN"[LUMBERJACK] "WHITE"Anda berhasil menghapus pohon (id:"YELLOW"%d"WHITE")!", id);
					SendClientMessage(playerid, COLOR_WHITE, pmsg);
				}else{
					ShowPlayerDialog(playerid, DIALOG_LUMBER_HAPUS_ID, DIALOG_STYLE_INPUT, "Hapus Pohon", RED"ID tidak valid!\n"WHITE"ID pohon tidak tersedia.", "Lanjut", "Batal");
				}
			}
			return 1;
		}
		case DIALOG_LUMBER_HAPUS_ALL:
		{
			if(response){
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LUMBER_HAPUS_ALL, DIALOG_STYLE_INPUT, "Hapus Rumah", RED"Input tidak boleh kosong!\n"WHITE"Silahkan ketik "GREEN"HAPUS"WHITE" untuk setuju.", "Lanjut", "Batal");
				if(!sama("HAPUS", inputtext)) return ShowPlayerDialog(playerid, DIALOG_LUMBER_HAPUS_ALL, DIALOG_STYLE_INPUT, "Hapus Rumah", RED"Input tidak valid!\n"WHITE"Anda harus mengetik "GREEN"HAPUS"WHITE" untuk setuju.", "Lanjut", "Batal");
				foreach(new i : TreeIterator){
					if (Iter_Contains(TreeIterator, i)){
						DestroyDynamicObject(DTree[i][treeObjID]);
						DestroyDynamicCP(DTree[i][treeCP]);
						DestroyDynamic3DTextLabel(DTree[i][treeLabel]);
						
						DTree[i][treeSecs] = 0;
						DTree[i][treeObjID] = DTree[i][treeTimer] = -1;
						DTree[i][treeLabel] = Text3D: -1;
						Iter_SafeRemove(TreeIterator, i, i);
					}
				}

				mysql_tquery(koneksi, "TRUNCATE TABLE `lumber`");
				SendClientMessage(playerid, COLOR_GREEN, "[LUMBERJACK] "YELLOW"Anda berhasil menghapus semua pohon!");
			}
			return 1;
		}
		case DIALOG_LUMBER:
		{
			if(response){
				switch(listitem){
					case 0:
					{
                        // Cari Pohon
						new status[256], subString[100], string[1500] = "ID\tJarak\tStatus\n"WHITE, Float:tempdist;
						foreach(new i : TreeIterator){
        					tempdist = GetPlayerDistanceFromPoint(playerid, DTree[i][treeX], DTree[i][treeY], DTree[i][treeZ]);
							if(DTree[i][treeSecs] < 1){
								format(status, sizeof(status), GREEN"Tersedia");
							}else{
								format(status, sizeof(status), YELLOW"%s menit", ConvertToMinutes(DTree[i][treeSecs]));
							}
							format(subString, sizeof(subString), "%d\t%d meter\t%s\n", i, floatround(tempdist, floatround_round), status);
							strcat(string, subString);
						}

						format(subString, 64, WHITE"Cari Pohon");
						ShowPlayerDialog(playerid, DIALOG_PILIH_TREE, DIALOG_STYLE_TABLIST_HEADERS, subString, string, "Pilih", "Batal");
					}
					case 1:
					{
						// Potong Pohon
						if(PlayerInfo[playerid][sisaGergaji] > 0 && CuttingTreeID[playerid] == -1){
							new tid = GetClosestTree(playerid);
							if(tid != -1){
								if(!Tree_BeingEdited(tid) && !DTree[tid][treeTumbang] && DTree[tid][treeSecs] < 1){
									if(IsPlayerInDynamicCP(playerid, DTree[tid][treeCP])){
										if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return error_command(playerid, "Tidak dapat memotong dalam keadaan sekarang.");
										SetPlayerLookAt(playerid, DTree[tid][treeX], DTree[tid][treeY]);
										Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, DTree[tid][treeLabel], E_STREAMER_COLOR, COLOR_WHITE);
										CuttingTimer[playerid] = SetPreciseTimer("CutTree", 1000, true, "i", playerid);
										CuttingTreeID[playerid] = tid;
										SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
										ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
										TogglePlayerControllable(playerid, 0);
										SetPlayerArmedWeapon(playerid, WEAPON_CHAINSAW);
										GameTextForPlayer(playerid, "~w~Sedang ~y~memotong...", 3000, 3);
										SetPlayerAttachedObject(playerid, CUTTING_ATTACH_INDEX, 341, 6, 0.048, 0.029, 0.103, -80.0, 80.0, 0.0);
										ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 1, 0, 0, 1, 0, 1);
										DTree[tid][treeTumbang] = true;
				
										PlayerInfo[playerid][isOnAnimation] = true;						
										PlayerInfo[playerid][isBusy] = true;
									}
								}else{
									error_command(playerid, "Tidak terdapat pohon yang siap di tebang.");
								}
							}else{
								error_command(playerid, "Anda tidak berada di sekitar pohon yang siap di tebang.");
							}
						}else{
							error_command(playerid, "Anda tidak sedang menggunakan gergaji mesin.");
						}
					}
					case 2:
					{
						// Pindahkan Pohon
						new pid = GetClosestTree(playerid);
						if(pid == -1) return error_command(playerid, "Anda tidak berada disekitar pohon.");
						if(!DTree[pid][treeTumbang]) return error_command(playerid, "Anda tidak berada disekitar pohon tumbang.");
						new vid = GetNearestVehicleToPlayer(playerid);
						if(!IsMobilPickup(vid)) return error_command(playerid, "Anda tidak berada disekitar mobil pick up.");
						new Float: x, Float: y, Float: z;
						GetVehicleBoot(vid, x, y, z);
						if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return error_command(playerid, "Anda tidak berada tepat dibelakang mobil pick up.");
						if(vehDTree[vid][treeAngkut] >= VEH_TREE_LIMIT) return error_command(playerid, "Anda tidak dapat menambahkan pohon lagi ke mobil pick up.");
						SetDynamicObjectPos(DTree[pid][treeObjID], DTree[pid][treeX], DTree[pid][treeY], DTree[pid][treeZ]-50.0);
						ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
						SetPlayerLookAt(playerid, x, y);
						vehDTree[vid][treeAngkut]++;
						DTree[pid][treeTumbang] = false;
						DTree[pid][treeAmbil] = true;
						reloadTreeLabel(pid);
						SendClientMessage(playerid, COLOR_GREEN, "[LUMBERJACK] "WHITE"Anda berhasil mengangkut pohon ke dalam mobil pick up.");
					}
					case 3:
					{	
						// Turunkan Pohon
						TurunkanPohon(playerid);
					}
					case 4:
					{
						// Muatan Pohon
						if(!IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda tidak berada di dalam kendaraan.");

						new vehid = GetPlayerVehicleID(playerid);
						if(!IsMobilPickup(vehid)) return error_command(playerid, "Anda tidak berada di dalam kendaraan pick up.");
						format(pDialog[playerid], sizePDialog, WHITE"Kendaraan anda memiliki muatan pohon sebanyak "GREEN"%d"WHITE" buah.", vehDTree[vehid][treeAngkut]);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Muatan Pohon", pDialog[playerid], "Ok", "");
					}
					case 5:
					{
						format(pDialog[playerid], sizePDialog, "Nama\tJarak\n");
						// Tempat Pemotongan Pohon
						for(new i = 0; i < sizeof(POSISI_PEMOTONGAN_KAYU); i++){
							strcatEx(pDialog[playerid], sizePDialog, "#%d - %s\t%.2fm\n", i + 1, GetZoneName(POSISI_PEMOTONGAN_KAYU[i][POSISI_X], POSISI_PEMOTONGAN_KAYU[i][POSISI_Y], POSISI_PEMOTONGAN_KAYU[i][POSISI_Z]), GetPlayerDistanceFromPoint(playerid, POSISI_PEMOTONGAN_KAYU[i][POSISI_X], POSISI_PEMOTONGAN_KAYU[i][POSISI_Y], POSISI_PEMOTONGAN_KAYU[i][POSISI_Z]));
						}
						ShowPlayerDialog(playerid, DIALOG_PILIH_TEMPAT_PEMOTONGAN, DIALOG_STYLE_TABLIST_HEADERS, "Pilih tempat pemotongan :", pDialog[playerid], "Pilih", "Kembali");						
					}
				}
			}
			return 1;
		}
		case DIALOG_PILIH_TEMPAT_PEMOTONGAN:
		{
			if(response){
				SetPlayerCheckpoint(playerid, POSISI_PEMOTONGAN_KAYU[listitem][POSISI_X], POSISI_PEMOTONGAN_KAYU[listitem][POSISI_Y], POSISI_PEMOTONGAN_KAYU[listitem][POSISI_Z], 5.0);
				PlayerInfo[playerid][activeMarker] = true;
				SendClientMessage(playerid, COLOR_GREEN, "[LUMBERJACK] "WHITE"Anda telah berhasil menandai Tempat Pemotongan Pohon.");
			}else
				cmd_lumberjack(playerid, "");
			return 1;
		}
		case DIALOG_PILIH_TREE:
		{
			if(response){
				new id = strval(inputtext);
				SetPlayerCheckpoint(playerid, DTree[id][treeX], DTree[id][treeY], DTree[id][treeZ], 5.0);
				PlayerInfo[playerid][activeMarker] = true;
				SendClientMessage(playerid, COLOR_GREEN, "[LUMBERJACK] "WHITE"Anda telah berhasil menandai pohon.");
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
		case DIALOG_PENGATURAN:
		{
			if(response){
				switch(listitem){
					case 0: // Hud stats
					{
						PlayerInfo[playerid][tampilHUDStats] = !PlayerInfo[playerid][tampilHUDStats];	

						if(PlayerInfo[playerid][tampilHUDStats]){
							if(PlayerInfo[playerid][photoMode]){
								PlayerInfo[playerid][photoMode] = false;
								hidePhotoMode(playerid);
							}
							tampilkanHUDStats(playerid);
							server_message(playerid, "Berhasil menampilkan HUD status");
						}
						else{
							hideHUDStats(playerid);
							server_message(playerid, "Berhasil menyembunyikan HUD status");
						}
					}
					case 1:
					{
						PlayerInfo[playerid][tampilSpeedo] = !PlayerInfo[playerid][tampilSpeedo];

						if(PlayerInfo[playerid][tampilSpeedo]){
							server_message(playerid, "Berhasil menampilkan speedo");

							if(IsPlayerInAnyVehicle(playerid)){
								TextDrawShowForPlayer(playerid, SpeedoTD[0]);
								TextDrawShowForPlayer(playerid, SpeedoTD[1]);
								TextDrawShowForPlayer(playerid, SpeedoTD[2]);
								TextDrawShowForPlayer(playerid, SpeedoTD[3]);

								ShowPlayerProgressBar(playerid, SpeedoTD_VehBar[playerid][0]);
								ShowPlayerProgressBar(playerid, SpeedoTD_VehBar[playerid][1]);

								PlayerTextDrawShow(playerid, SpeedoTD_VehInfo[playerid][0]);
								PlayerTextDrawShow(playerid, SpeedoTD_VehInfo[playerid][1]);
							}
						}
						else{
							server_message(playerid, "Berhasil menyembunyikan speedo");
							if(IsPlayerInAnyVehicle(playerid)){
								TextDrawHideForPlayer(playerid, SpeedoTD[0]);
								TextDrawHideForPlayer(playerid, SpeedoTD[1]);
								TextDrawHideForPlayer(playerid, SpeedoTD[2]);
								TextDrawHideForPlayer(playerid, SpeedoTD[3]);

								HidePlayerProgressBar(playerid, SpeedoTD_VehBar[playerid][0]);
								HidePlayerProgressBar(playerid, SpeedoTD_VehBar[playerid][1]);

								PlayerTextDrawHide(playerid, SpeedoTD_VehInfo[playerid][0]);
								PlayerTextDrawHide(playerid, SpeedoTD_VehInfo[playerid][1]);								
							}
						}
					}
					case 2: // Hide/show photo mode
					{
						PlayerInfo[playerid][photoMode] = !PlayerInfo[playerid][photoMode];
						if(PlayerInfo[playerid][photoMode]){
							SendClientMessage(playerid, COLOR_YELLOW, "* Berhasil menampilkan photo mode.");
							SendClientMessage(playerid, COLOR_YELLOW, TAG_NOTE" "WHITE"Jika anda sebelumnya mengaktifkan HUD status, maka HUD akan terhide.");
							SendClientMessage(playerid, COLOR_YELLOW, TAG_NOTE" "WHITE"Tekan F7 untuk hide chat dan HUD bawaan GTA.");
							showPhotoMode(playerid);
						}
						else{
							SendClientMessage(playerid, COLOR_YELLOW, "* Berhasil menyembunyikan photo mode.");
							hidePhotoMode(playerid);
						}
					}
					case 3:
					{
						PlayerInfo[playerid][tampilJam] = !PlayerInfo[playerid][tampilJam];
						if(PlayerInfo[playerid][tampilJam]){
							TextDrawShowForPlayer(playerid, TD_JamTanggal[0]);
							TextDrawShowForPlayer(playerid, TD_JamTanggal[1]);

							SendClientMessage(playerid, COLOR_YELLOW, "* Berhasil menampilkan tanggal dan waktu.");
						}else{
							TextDrawHideForPlayer(playerid, TD_JamTanggal[0]);
							TextDrawHideForPlayer(playerid, TD_JamTanggal[1]);

							SendClientMessage(playerid, COLOR_YELLOW, "* Berhasil menyembunyikan tanggal dan waktu.");
						}
					}
				}
			}
			return 1;
		}
		case DIALOG_ADMIN_ATM:
		{
			if(response){
				switch(listitem){
					case 0: // Buat ATM
					{
						new id = Iter_Free(ATMs);
						if(id == -1) return error_command(playerid, "ATM telah melampui limit");

						ATMData[id][atmRX] = ATMData[id][atmRY] = 0.0;
						GetPlayerPos(playerid, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ]);
						GetPlayerFacingAngle(playerid, ATMData[id][atmRZ]);

						ATMData[id][atmX] += (2.0 * floatsin(-ATMData[id][atmRZ], degrees));
						ATMData[id][atmY] += (2.0 * floatcos(-ATMData[id][atmRZ], degrees));
						ATMData[id][atmZ] -= 0.3;

						ATMData[id][atmObjID] = CreateDynamicObject(19324, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ], ATMData[id][atmRX], ATMData[id][atmRY], ATMData[id][atmRZ]);
						if(IsValidDynamicObject(ATMData[id][atmObjID]))
						{		
							EditingATMID[playerid] = id;
							EditDynamicObject(playerid, ATMData[id][atmObjID]);
						}

						new label_string[128];
						format(label_string, sizeof(label_string), "%d, %s, %s\n"WHITE"ATM tersedia\n\n"WHITE"Tekan "GREEN"Y"WHITE" untuk mengakses", id, GetZoneName(ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ]), GetCityName(ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ]));
						ATMData[id][atmLabel] = CreateDynamic3DTextLabel(label_string, COLOR_GREEN, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ] + 0.85, 5.0);

						mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO tempat_atm SET id=%d, pos_x='%f', pos_y='%f', pos_z='%f', rot_x='%f', rot_y='%f', rot_z='%f'", id, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ], ATMData[id][atmRX], ATMData[id][atmRY], ATMData[id][atmRZ]);
						mysql_tquery(koneksi, pQuery[playerid]);
						Iter_Add(ATMs, id);
						return 1;
					}
					case 1:
					{
						return ShowPlayerDialog(playerid, DIALOG_ADMIN_ATM_PILIH_ID_EDIT, DIALOG_STYLE_INPUT, "Pilih ID", "Masukan ID mesin ATM yang ingin di edit.", "Ok", "Batal");
					}
					case 2:
					{
						return ShowPlayerDialog(playerid, DIALOG_ADMIN_ATM_PILIH_ID_HAPUS, DIALOG_STYLE_INPUT, "Pilih ID", "Masukan ID mesin ATM yang ingin di hapus.", "Ok", "Batal");
					}
				}
			}
			return 1;
		}
		case DIALOG_ADMIN_ATM_PILIH_ID_EDIT:
		{
			if(response){
				new id;
				if(sscanf(inputtext, "i", id)) return ShowPlayerDialog(playerid, DIALOG_ADMIN_ATM_PILIH_ID_EDIT, DIALOG_STYLE_INPUT, "Pilih ID", RED"Anda harus menginput id dengan benar.\n"WHITE"Masukan ID mesin ATM yang ingin di edit.", "Ok", "Batal");
				if(!Iter_Contains(ATMs, id) || id == 0) return ShowPlayerDialog(playerid, DIALOG_ADMIN_ATM_PILIH_ID_EDIT, DIALOG_STYLE_INPUT, "Pilih ID", RED"ATM tidak ada.\n"WHITE"Masukan ID mesin ATM yang ingin di edit.", "Ok", "Batal");
				if(!IsPlayerInRangeOfPoint(playerid, 30.0, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ])) return ShowPlayerDialog(playerid, DIALOG_ADMIN_ATM_PILIH_ID_EDIT, DIALOG_STYLE_INPUT, "Pilih ID", RED"Anda tidak berada di dekat ATM.\n"WHITE"Masukan ID mesin ATM yang ingin di edit.", "Ok", "Batal");
				EditingATMID[playerid] = id;
				EditDynamicObject(playerid, ATMData[id][atmObjID]);
				return 1;
			}
			return 1;
		}
		case DIALOG_ADMIN_ATM_PILIH_ID_HAPUS:
		{
			if(response){
				new id;
				if(sscanf(inputtext, "i", id)) return ShowPlayerDialog(playerid, DIALOG_ADMIN_ATM_PILIH_ID_HAPUS, DIALOG_STYLE_INPUT, "Pilih ID", RED"Masukan inputan ID yang benar.\n"WHITE"Masukan ID mesin ATM yang ingin di hapus.", "Ok", "Batal");
				if(!Iter_Contains(ATMs, id) || id == 0) return ShowPlayerDialog(playerid, DIALOG_ADMIN_ATM_PILIH_ID_HAPUS, DIALOG_STYLE_INPUT, "Pilih ID", RED"ATM tidak ada.\n"WHITE"Masukan ID mesin ATM yang ingin di hapus.", "Ok", "Batal");
				if(!IsPlayerInRangeOfPoint(playerid, 30.0, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ])) return ShowPlayerDialog(playerid, DIALOG_ADMIN_ATM_PILIH_ID_HAPUS, DIALOG_STYLE_INPUT, "Pilih ID", RED"ATM tidak berada di dekat anda.\n"WHITE"Masukan ID mesin ATM yang ingin di hapus.", "Ok", "Batal");

				if(IsValidDynamicObject(ATMData[id][atmObjID])) DestroyDynamicObject(ATMData[id][atmObjID]);
				ATMData[id][atmObjID] = -1;
				if(IsValidDynamic3DTextLabel(ATMData[id][atmLabel])) DestroyDynamic3DTextLabel(ATMData[id][atmLabel]);

				ATMData[id][atmLabel] = Text3D: -1;
				Iter_Remove(ATMs, id);
				
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM tempat_atm WHERE id=%d", id);
				mysql_tquery(koneksi, pQuery[playerid]);
				return 1;
			}
			return 1;
		}
		case DIALOG_MENU_BELI_PERABOT:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);

				format(pDialog[playerid], sizePDialog, "Anda akan membeli furniture %s dengan harga %d.\
						\nSilahkan masukan jumlah yang ingin dibeli.", PERABOT_DIJUAL[GetPVarInt(playerid, "index_terpilih")][NamaPerabotDijual], PERABOT_DIJUAL[GetPVarInt(playerid, "index_terpilih")][HargaPerabotDijual]);
				return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_PERABOT, DIALOG_STYLE_INPUT, "Silahkan input jumlah", pDialog[playerid], "Ok", "Kembali");
			}
			return 1;
		}
		case DIALOG_JUMLAH_PEMBELIAN_PERABOT:
		{
			if(response){
				new jumlah;
				if(sscanf(inputtext, "i", jumlah)) {
					format(pDialog[playerid], sizePDialog, "\
							"RED"Inputan anda invalid.\
							\n"WHITE"Anda akan membeli furniture %s dengan harga %d.\
							\nSilahkan masukan jumlah yang ingin dibeli.", PERABOT_DIJUAL[GetPVarInt(playerid, "index_terpilih")][NamaPerabotDijual], PERABOT_DIJUAL[GetPVarInt(playerid, "index_terpilih")][HargaPerabotDijual]);
					return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_PERABOT, DIALOG_STYLE_INPUT, "Silahkan input jumlah", pDialog[playerid], "Ok", "Kembali");					
				}

				if(jumlah < 1 || jumlah > 999) {
					format(pDialog[playerid], sizePDialog, "\
							"RED"Hanya bisa membeli sebanyak 1 - 999.\
							\n"WHITE"Anda akan membeli furniture %s dengan harga %d.\
							\nSilahkan masukan jumlah yang ingin dibeli.", PERABOT_DIJUAL[GetPVarInt(playerid, "index_terpilih")][NamaPerabotDijual], PERABOT_DIJUAL[GetPVarInt(playerid, "index_terpilih")][HargaPerabotDijual]);
					return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_PERABOT, DIALOG_STYLE_INPUT, "Silahkan input jumlah", pDialog[playerid], "Ok", "Kembali");					
				}
				
				SetPVarInt(playerid, "jumlah_terpilih", jumlah);
				format(pDialog[playerid], sizePDialog, "Pembelian %s sebanyak %d", PERABOT_DIJUAL[GetPVarInt(playerid, "index_terpilih")][NamaPerabotDijual], jumlah);
				dialogMetodeBayar(playerid, GetPVarInt(playerid, "jumlah_terpilih") * PERABOT_DIJUAL[GetPVarInt(playerid, "index_terpilih")][HargaPerabotDijual], "selesaiBeliPerabot", pDialog[playerid]);
			}else
				showDialogBeliPerabot(playerid);
			return 1;
		}
		case DIALOG_INFO_SAYA:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						inline responseQuery(){
							new rows;
							cache_get_row_count(rows);
							if(rows){
								new idx, string[2000] = WHITE"Nama Skill\t"GREEN"Exp\n"WHITE, temp_nama_skill[200], temp_exp_skill;
								while(idx < rows){
									cache_get_value_name(idx, "nama_skill", temp_nama_skill);
									cache_get_value_name_int(idx, "exp", temp_exp_skill);
									strcatEx(string, sizeof(string), "%s\t%d\n", temp_nama_skill, temp_exp_skill);
									idx++;
								}
								ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_TABLIST_HEADERS, "Skill anda", string, "Ok", "");
							}else{
								showDialogPesan(playerid, RED"Anda tidak memiliki skill", "Anda tidak memiliki apapun.\n"YELLOW"Anda harus mempelajari skill terlebih dahulu untuk dapat melihat exp nya disini.");
							}
						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT a.nama_skill, b.id, a.id AS id_skill, IFNULL(b.exp, 0) AS exp FROM skill a LEFT JOIN user_skill b ON a.id = b.id_skill WHERE b.id_user = %d ORDER BY b.exp DESC", PlayerInfo[playerid][pID]);
						return 1;
					}
					case 1:
					{
						tampilkanTextDrawMyInfo(playerid);
						return 1;
					}
				}
			}
			return 1;
		}
		case DIALOG_MENU_SKILL:
		{
			if(response){
				switch(listitem){
					case 0: // Mekanik
					{
						if(!PlayerInfo[playerid][activeMekanik]) return server_message(playerid, "Maaf skill mekanik anda tidak aktif.");
						format(pDialog[playerid], sizePDialog, "Rakit Alat Perbaikan");
						if(PlayerInfo[playerid][expMekanik] >= LEVEL_SKILL_DUA) strcat(pDialog[playerid], "\nPerbaiki Kendaraan");
						if(PlayerInfo[playerid][expMekanik] >= LEVEL_SKILL_DUA) strcat(pDialog[playerid], "\nHidupkan Kendaraan yang rusak total");
						if(PlayerInfo[playerid][expMekanik] >= LEVEL_SKILL_TIGA) strcat(pDialog[playerid], "\nWarnain Kendaraan");
						if(PlayerInfo[playerid][expMekanik] >= LEVEL_SKILL_EMPAT) strcat(pDialog[playerid], "\nPasang Sparepart (Modif)");
						if(PlayerInfo[playerid][expMekanik] >= LEVEL_SKILL_LIMA) strcat(pDialog[playerid], "\nPaintjob kendaraan (khusus)");
						
						ShowPlayerDialog(playerid, DIALOG_PILIH_SKILL_MEKANIK, DIALOG_STYLE_LIST, "Skill mekanik : ", pDialog[playerid], "Pilih", "Batal");
						return 1;
					}
					case 1: // Medic
					{
						if(!PlayerInfo[playerid][activeMedic] && !IsPlayerOnDutyMedic(playerid)) return server_message(playerid, "Maaf skill medic anda tidak aktif.");

						format(pDialog[playerid], sizePDialog, "Buat obat herbal (untuk menyelamatkan yang sekarat)");

						if(GetExpMedicPlayer(playerid) >= MEDIC_LEVEL_SKILL_DUA || IsPlayerOnDutyMedic(playerid))
							strcat(pDialog[playerid], "\nRevive orang yang sekarat");
						
						ShowPlayerDialog(playerid, DIALOG_PILIH_SKILL_MEDIC, DIALOG_STYLE_LIST, "Skill medis : ", pDialog[playerid], "Pilih", "Batal");
						return 1;
					}
					case 2: // Blacksmith
					{
						if(!PlayerInfo[playerid][activeBlacksmith]) return server_message(playerid, "Maaf skill blacksmith anda tidak aktif.");

						/**
							@IMPORTANT :
								PASTIKAN UNTUK SELALU MENAMBAHKAN PADA BAGIAN 
									``` RESPONSE DIALOG_KONFIRMASI_BUAT_ITEM ```
								SETIAP MENAMBAH ITEM BARU PADA BLACKSMITH
						*/
						format(pDialog[playerid], sizePDialog, "Rakit Joran Pancing");
						strcat(pDialog[playerid], "\nRakit Tombak Ikan");
						
						ShowPlayerDialog(playerid, DIALOG_PILIH_SKILL_BLACKSMITH, DIALOG_STYLE_LIST, "Skill blacksmith : ", pDialog[playerid], "Pilih", "Batal");
						return 1;
					}
				}
			}
			return 1;
		}
		case DIALOG_PILIH_SKILL_MEDIC:
		{
			if(response){
				switch(listitem){
					case 0: // Buat obat
					{
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BUAT_OBAT, DIALOG_STYLE_MSGBOX, "Konfirmasi buat obat", WHITE"Untuk dapat membuat obat (penyelamat sekarat)\nAnda akan membutuhkan "YELLOW"2 Kangkung Ijo dan 1 bubuk herbal\n"WHITE"Apakah anda memilikinya?", "Ok", "Batal");
					}
					case 1: // Revive
					{
						new Float:pos[3],
							target_id = INVALID_PLAYER_ID;
						GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
						foreach(new i : Player){
							if(IsPlayerInRangeOfPoint(i, 2.0, pos[0], pos[1], pos[2]) && PlayerInfo[i][inDie] && playerid != i){
								target_id = i;
								break; // Break gak work di foreach?
							}
						}
						if(target_id == INVALID_PLAYER_ID){
							return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Orang sekarat tidak ada", YELLOW"Tidak ada orang yang sedang sekarat disekitar anda.", "Ok", "");
						}
						SetPVarInt(playerid, "target_revive", target_id);
						format(pDialog[playerid], sizePDialog, WHITE"Anda akan merevive %s\nUntuk revive orang yang sekarat\nAnda akan membutuhkan "YELLOW"1 obat herbal revive\n"WHITE"Apakah anda memilikinya?", PlayerInfo[target_id][pPlayerName]);
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_REVIVE, DIALOG_STYLE_MSGBOX, "Konfirmasi revive", pDialog[playerid], "Ok", "Batal");
					}
				}
			}else
				cmd_skill(playerid, "");
			return 1;
		}
		case DIALOG_KONFIRMASI_REVIVE:
		{
			if(response){
				if(GetJumlahItemPlayer(playerid, ID_OBAT_HERBAL) < 1){
					return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Item tidak mencukupi", WHITE"Anda tidak memiliki cukup item yang diperlukan.\nAnda tidak dapat merevive.\n\n"YELLOW"Anda membutuhkan setidaknya 1 obat herbal revive.", "Ok", "");
				}

				// Pinjam timer perbaiki
				if(PerbaikiTimer[playerid] != -1)
					DeletePreciseTimer(PerbaikiTimer[playerid]);
				PerbaikiTimer[playerid] = SetPreciseTimer("progressRevive", 1000, true, "i", playerid);

				// Pinjam progress bar dari potong pohon
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
				ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
				TogglePlayerControllable(playerid, 0);
				GameTextForPlayer(playerid, "~w~Sedang ~y~menyelamatkan...", 3000, 3);
				PlayerReviving(playerid);
				PlayerInfo[playerid][isOnAnimation] = true;	
				PlayerInfo[playerid][isBusy] = true;
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_BUAT_OBAT:
		{
			if(response){
				// Cek jumlah item
				if(GetJumlahItemPlayer(playerid, ID_GANJOS) < 2 || GetJumlahItemPlayer(playerid, ID_BUBUK_HERBAL) < 1){
					return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Item tidak mencukupi", WHITE"Anda tidak memiliki cukup item yang diperlukan.\nAnda tidak dapat membuat obat.\n\n"YELLOW"Anda membutuhkan 2 Kangkung Ijo dan 1 bubuk herbal.", "Ok", "");
				}
				// Pinjam timer perbaiki
				if(PerbaikiTimer[playerid] != -1)
					DeletePreciseTimer(PerbaikiTimer[playerid]);
				PerbaikiTimer[playerid] = SetPreciseTimer("progressBuatObatHerbal", 1000, true, "i", playerid);

				// Pinjam progress bar dari potong pohon
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
				ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
				TogglePlayerControllable(playerid, 0);
				GameTextForPlayer(playerid, "~w~Sedang ~y~membuat...", 3000, 3);
				PlayerCraftingMedicine(playerid);
				PlayerInfo[playerid][isOnAnimation] = true;	
				PlayerInfo[playerid][isBusy] = true;
			}
			return 1;
		}
		case DIALOG_PILIH_SKILL_MEKANIK:
		{
			if(response){
				switch(listitem){
					case 0: // Craft alat perbaikan
					{
						static const barang_barang_mekanik[2][2] = {
							{11, 1}, // Aluminium - 1
							{12, 3}  // Perak - 3
						};
						// Mungkin butuh besi dll lagi
						cekKetersediaanMassiveItem(playerid, barang_barang_mekanik, "konfirmasiBuatAlatPerbaikan");
					}
					case 1: // Perbaiki vehicle
					{
						new Float:pos[3];
						GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
						GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);

						new vehid = INVALID_VEHICLE_ID;
						new Float:vpos[3];

						foreach(new vid : Vehicle){
							if(!IsValidVehicle(vid)) continue;
							if(GetVehicleHood(vid, vpos[0], vpos[1], vpos[2])){
								if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 2.0)){
									vehid = vid;
									break;
								}
							}
						}
						
						if(vehid == INVALID_VEHICLE_ID) return showDialogPesan(playerid, RED"Tidak ada kendaraan didepan anda", WHITE"Tidak terdapat kendaraan yang berada didepan anda.\n"YELLOW"Anda harus mendekati kendaraan tersebut dan berdiri didepan kap nya.\nJika yang ingin diperbaiki bukan kendaraan yang memiliki kap\nMaka anda juga cukup berdiri didepannya.");

						if(!GetVehicleParams(vehid, VEHICLE_TYPE_BONNET)) return showDialogPesan(playerid, RED"Buka Kap terlebih dahulu", WHITE"Untuk dapat memperbaiki kendaraan, anda harus membuka kapnya terlebih dahulu.");

						new Float:veh_darah, alat_dibutuhkan = 0;
						GetVehicleHealth(vehid, veh_darah);

						if(veh_darah <= 260.0)
							return showDialogPesan(playerid, RED"Kendaraan rusak total", WHITE"Kendaraan rusak total tidak dapat diperbaiki dengan cara biasa.\nGunakan skill "YELLOW"Perbaiki kendaraan yang rusak total"WHITE" untuk dapat memperbaikinya.");

						if(veh_darah > 600) alat_dibutuhkan = 1;
						else alat_dibutuhkan = 2;

						SetPVarInt(playerid, "mekanik_alat_dibutuhkan", alat_dibutuhkan);
						SetPVarInt(playerid, "mekanik_vehicle_id", vehid);

						format(pDialog[playerid], sizePDialog, WHITE"Anda akan memperbaiki kendaraan jenis "GREEN"%s\n\
							"WHITE"Darah kendaraan saat ini adalah "ORANGE"%.2f/1000.0\n\n\
							"WHITE"Anda memerlukan "RED"%d alat perbaikan "WHITE"untuk dapat memperbaiki.\n\
							Anda yakin ingin memperbaikinya ?\n", GetVehicleModelName(GetVehicleModel(vehid)), veh_darah, alat_dibutuhkan);
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_PERBAIKI_MEKANIK, DIALOG_STYLE_MSGBOX, "Perbaiki kendaraan", pDialog[playerid], "Perbaiki", "Batal");
					}
					case 2: // Perbaiki vehicle yang rusak total
					{
						new Float:pos[3];
						GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
						GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);

						new vehid = INVALID_VEHICLE_ID;
						new Float:vpos[3];

						foreach(new vid : Vehicle){
							if(!IsValidVehicle(vid)) continue;
							if(GetVehicleHood(vid, vpos[0], vpos[1], vpos[2])){
								if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 2.0)){
									vehid = vid;
									break;
								}
							}
						}
						
						if(vehid == INVALID_VEHICLE_ID) return showDialogPesan(playerid, RED"Tidak ada kendaraan didepan anda", WHITE"Tidak terdapat kendaraan yang berada didepan anda.\n"YELLOW"Anda harus mendekati kendaraan tersebut dan berdiri didepan kap nya.\nJika yang ingin diperbaiki bukan kendaraan yang memiliki kap\nMaka anda juga cukup berdiri didepannya.");

						if(!GetVehicleParams(vehid, VEHICLE_TYPE_BONNET)) return showDialogPesan(playerid, RED"Buka Kap terlebih dahulu", WHITE"Untuk dapat memperbaiki kendaraan, anda harus membuka kapnya terlebih dahulu.");

						new Float:veh_darah, alat_dibutuhkan = 3;
						GetVehicleHealth(vehid, veh_darah);

						if(veh_darah > 260.0)
							return showDialogPesan(playerid, RED"Kendaraan rusak biasa", WHITE"Kendaraan tidak rusak total.\nGunakan skill "YELLOW"Perbaiki kendaraan"WHITE" untuk dapat memperbaikinya.");

						SetPVarInt(playerid, "mekanik_alat_dibutuhkan", alat_dibutuhkan);
						SetPVarInt(playerid, "mekanik_vehicle_id", vehid);

						format(pDialog[playerid], sizePDialog, WHITE"Anda akan memperbaiki kendaraan jenis "GREEN"%s\n\
							"WHITE"Kendaraan saat ini rusak total dan akan diperbaiki mesinnya terlebih dahulu.\n\n\
							Anda memerlukan "RED"%d alat perbaikan "WHITE"untuk dapat memperbaiki.\n\
							Anda yakin ingin memperbaikinya ?\n", GetVehicleModelName(GetVehicleModel(vehid)), alat_dibutuhkan);
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_PERBAIKI_MEKANIK, DIALOG_STYLE_MSGBOX, "Perbaiki kendaraan", pDialog[playerid], "Perbaiki", "Batal");
					}
					case 3: // Warnain kendaraan
					{
						new Float:pos[3];
						GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
						GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);

						new vehid = INVALID_VEHICLE_ID;
						new Float:vpos[3];

						foreach(new vid : Vehicle){
							if(!IsValidVehicle(vid)) continue;
							if(GetVehiclePos(vid, vpos[0], vpos[1], vpos[2])){
								if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
									vehid = vid;
									break;
								}
							}
						}
						
						if(vehid == INVALID_VEHICLE_ID) return showDialogPesan(playerid, RED"Tidak ada kendaraan didepan anda", WHITE"Tidak terdapat kendaraan yang berada didepan anda.\n"YELLOW"Anda harus mendekati kendaraan tersebut dan berdiri didekat bagian tengahnya.\nJika tidak bisa juga, coba diberbagai posisi bagian kendaraan untukk mendapatkan titik yang terdeteksi.");

						if(!Iter_Contains(IDVehToPVehIterator, vehid)) return showDialogPesan(playerid, RED"Kendaraan tidak berpemilik", WHITE"Kendaraan yang dapat di warnain adalah kendaraan yang memiliki pemilik.\n"YELLOW"Kendaraan yang ada didepan anda saat ini tidak memiliki pemilik.");

						SetPVarInt(playerid, "mekanik_vehicle_id", vehid);

						format(pDialog[playerid], sizePDialog, WHITE"Anda akan mewarnai kendaraan jenis "GREEN"%s\n\n\
							"WHITE"Anda memerlukan "RED"1 item pewarna kendaraan "WHITE"untuk dapat mewarnainya.\n\
							Anda yakin ingin mewarnainya ?\n", GetVehicleModelName(GetVehicleModel(vehid)));
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_WARNAIN_MEKANIK, DIALOG_STYLE_MSGBOX, "Warnain kendaraan", pDialog[playerid], "Warnain", "Batal");
					}
					case 4: // Modifikasi Vehicle
					{
						new Float:pos[3];
						GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
						GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);

						new vehid = INVALID_VEHICLE_ID;
						new Float:vpos[3];

						foreach(new vid : Vehicle){
							if(!IsValidVehicle(vid)) continue;
							if(GetVehiclePos(vid, vpos[0], vpos[1], vpos[2])){
								if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
									vehid = vid;
									break;
								}
							}
						}
						
						if(vehid == INVALID_VEHICLE_ID) return showDialogPesan(playerid, RED"Tidak ada kendaraan didepan anda", WHITE"Tidak terdapat kendaraan yang berada didepan anda.\n"YELLOW"Anda harus mendekati kendaraan tersebut dan berdiri didekat bagian tengahnya.\nJika tidak bisa juga, coba diberbagai posisi bagian kendaraan untukk mendapatkan titik yang terdeteksi.");

						if(!Iter_Contains(IDVehToPVehIterator, vehid)) return showDialogPesan(playerid, RED"Kendaraan tidak berpemilik", WHITE"Kendaraan yang dapat di modif adalah kendaraan yang memiliki pemilik.\n"YELLOW"Kendaraan yang ada didepan anda saat ini tidak memiliki pemilik.");

						if(!GetVehicleParams(vehid, VEHICLE_TYPE_BONNET)) return showDialogPesan(playerid, RED"Buka Kap terlebih dahulu", WHITE"Untuk dapat memodifikasi kendaraan, anda harus membuka kapnya terlebih dahulu.");

						SetPVarInt(playerid, "mekanik_vehicle_id", vehid);

						format(pDialog[playerid], sizePDialog, WHITE"Anda akan memodif kendaraan jenis "GREEN"%s\n\n\
							"WHITE"Anda memerlukan "RED"1 sparepart kendaraan "WHITE"untuk dapat memodifnya.\n\
							Anda yakin ingin memodifnya ?\n", GetVehicleModelName(GetVehicleModel(vehid)));
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_MODIF_MEKANIK, DIALOG_STYLE_MSGBOX, "Modif kendaraan", pDialog[playerid], "Modifikasi", "Batal");
					}
					case 5: // Paintjob Vehicle
					{
						new Float:pos[3];
						GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
						GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);

						new vehid = INVALID_VEHICLE_ID;
						new Float:vpos[3];

						foreach(new vid : Vehicle){
							if(!IsValidVehicle(vid)) continue;
							if(GetVehiclePos(vid, vpos[0], vpos[1], vpos[2])){
								if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
									vehid = vid;
									break;
								}
							}
						}
						
						if(vehid == INVALID_VEHICLE_ID) return showDialogPesan(playerid, RED"Tidak ada kendaraan didepan anda", WHITE"Tidak terdapat kendaraan yang berada didepan anda.\n"YELLOW"Anda harus mendekati kendaraan tersebut dan berdiri didekat bagian tengahnya.\nJika tidak bisa juga, coba diberbagai posisi bagian kendaraan untukk mendapatkan titik yang terdeteksi.");

						if(!Iter_Contains(IDVehToPVehIterator, vehid)) return showDialogPesan(playerid, RED"Kendaraan tidak berpemilik", WHITE"Kendaraan yang dapat di paintjob adalah kendaraan yang memiliki pemilik.\n"YELLOW"Kendaraan yang ada didepan anda saat ini tidak memiliki pemilik.");

						if(!(GetVehicleModel(vehid) == 483 || GetVehicleModel(vehid) == 575 || \
							(GetVehicleModel(vehid) >= 534 && GetVehicleModel(vehid) <= 536) || \
							(GetVehicleModel(vehid) >= 558 && GetVehicleModel(vehid) <= 562) || \
							GetVehicleModel(vehid) == 565 || GetVehicleModel(vehid) == 567 || GetVehicleModel(vehid) == 576))
							return showDialogPesan(playerid, RED"Kendaraan tidak bisa di paintjob", WHITE"Kendaraan ini tidak bisa di paintjob.\n"YELLOW"Pastikan anda sudah mengetahui kendaraan apa saja yang dapat di paintjob.\n\nAnda dapat melihatnya di website "ORANGE"resmi server.");
						

						SetPVarInt(playerid, "mekanik_vehicle_id", vehid);

						format(pDialog[playerid], sizePDialog, WHITE"Anda akan paintjob kendaraan jenis "GREEN"%s\n\n\
							"WHITE"Anda memerlukan "RED"1 item paintjob kendaraan "WHITE"untuk dapat menggantinya.\n\
							Anda yakin ingin ?\n", GetVehicleModelName(GetVehicleModel(vehid)));
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_PAINTJOB_MEKANIK, DIALOG_STYLE_MSGBOX, "Paintjob kendaraan", pDialog[playerid], "Paintjob", "Batal");
					}
				}
			}else
				cmd_skill(playerid, "");
			return 1;
		}
		case DIALOG_FARM:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						// Panen Tanaman
						new randomDrop = 0, plant_Id = GetClosestPlant(playerid);
						if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return error_command(playerid, "Tidak dapat memanen tanaman dalam keadaan sekarang.");
						if(plant_Id == -1) return error_command(playerid, "Anda tidak berada disekitar tanaman.");
						if(!DFarm[plant_Id][plantHarvest]) return error_command(playerid, "Tanaman belum siap untuk dipanen, silahkan tunggu beberapa saat.");

						new const max_item_didapat = 18;
						if(!CekJikaInventoryPlayerMuat(playerid, DFarm[plant_Id][plantItemID], max_item_didapat)){
							format(pDialog[playerid], sizePDialog, RED"Sisakan minimal %d slot.\n\
								"WHITE"Untuk dapat memanen tanaman ini.", GetSlotItemTerpakai(DFarm[plant_Id][plantItemID], max_item_didapat));
							return showDialogPesan(
								playerid, 
								"Inventory tidak muat", 
								pDialog[playerid]);
						}

						ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
						DestroyTime(plant_Id);
						// Random 9 - 18
						randomDrop = random(9) + 10;
						tambahItemPlayer(playerid, DFarm[plant_Id][plantItemID], randomDrop);
						DFarm[plant_Id][plantItemID] = -1;
						format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil memanen Tanaman %s (id:"YELLOW"%d"WHITE") dan mendapatkan %s sebanyak %d.", DFarm[plant_Id][plantName], plant_Id, DFarm[plant_Id][plantName], randomDrop);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Farm System", pDialog[playerid], "Ok", "");
						// Exp Score
						TambahExpScore(playerid, EXP_TAMBAH_PANEN);
					}
				}
			}
			return 1;
		}
		case DIALOG_MENU_BELI_BIBIT:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);
				ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_BIBIT, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
			}else{
				DeletePVar(playerid, "index_terpilih");
				DeletePVar(playerid, "jumlah_terpilih");
			}
			return 1;
		}
		case DIALOG_JUMLAH_PEMBELIAN_BIBIT:
		{
			if(response){
				new jumlah;
				if(sscanf(inputtext, "i", jumlah)) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_BIBIT, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
				if(jumlah < 1 || jumlah > 10) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_BIBIT, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar dan anda hanya dapat membeli 10 dalam sekali pembelian.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
				SetPVarInt(playerid, "jumlah_terpilih", jumlah);
				format(pDialog[playerid], sizePDialog, "Pembelian %s sebanyak %d", MENU_BIBIT[GetPVarInt(playerid, "index_terpilih")][hargaBibit], jumlah);
				dialogMetodeBayar(playerid, GetPVarInt(playerid, "jumlah_terpilih") * MENU_BIBIT[GetPVarInt(playerid, "index_terpilih")][hargaBibit], "selesaiBeliBibit", pDialog[playerid]);
			}else{
				DeletePVar(playerid, "index_terpilih");
				DeletePVar(playerid, "jumlah_terpilih");
				showDialogBeliBibit(playerid);
			}
			return 1;
		}
		case DIALOG_MENU_BELI_BIBIT_NARKO:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);
				ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_BIBIT_NARKO, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
			}else{
				DeletePVar(playerid, "index_terpilih");
				DeletePVar(playerid, "jumlah_terpilih");
			}
			return 1;
		}
		case DIALOG_JUMLAH_PEMBELIAN_BIBIT_NARKO:
		{
			if(response){
				new jumlah;
				if(sscanf(inputtext, "i", jumlah)) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_BIBIT_NARKO, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
				if(jumlah < 1 || jumlah > 10) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_BIBIT_NARKO, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar dan anda hanya dapat membeli 10 dalam sekali pembelian.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
				SetPVarInt(playerid, "jumlah_terpilih", jumlah);
				format(pDialog[playerid], sizePDialog, "Pembelian %s sebanyak %d", MENU_BIBIT[GetPVarInt(playerid, "index_terpilih")][hargaBibit], jumlah);
				dialogMetodeBayar(playerid, GetPVarInt(playerid, "jumlah_terpilih") * MENU_BIBIT[GetPVarInt(playerid, "index_terpilih")][hargaBibit], "selesaiBeliNarko", pDialog[playerid]);
			}else{
				DeletePVar(playerid, "index_terpilih");
				DeletePVar(playerid, "jumlah_terpilih");
				showDialogBeliBibitNarko(playerid);
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_PAINTJOB_MEKANIK:
		{
			if(response){
				cekKetersediaanItem(playerid, 30, 1, "konfirmasiPaintjobMekanik"); // Paintjob kendaraan id 30 - butuh 1pcs
			}else
				DeletePVar(playerid, "mekanik_vehicle_id");
			return 1;
		}
		case DIALOG_KONFIRMASI_MODIF_MEKANIK:
		{
			if(response){
				cekKetersediaanItem(playerid, 29, 1, "konfirmasiModifMekanik"); // Sparepart kendaraan id 29 - butuh 1pcs
			}else
				DeletePVar(playerid, "mekanik_vehicle_id");
			return 1;
		}
		case DIALOG_PILIH_COMPONENT:
		{
			if(response){
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);

				new Float:vpos[3];
				new vid = GetPVarInt(playerid, "mekanik_vehicle_id");

				if(!IsValidVehicle(vid)) {
					SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal modif kendaraan, disebabkan oleh kendaraan tidak ada.");

					DeletePVar(playerid, "mekanik_vehicle_id");
					DeletePVar(playerid, "mekanik_warna_1");
					DeletePVar(playerid, "mekanik_warna_2");
					return 1;
				}
				GetVehiclePos(vid, vpos[0], vpos[1], vpos[2]);
				if(!IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
					SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal modif kendaraan. Kendaraan berpindah keposisi lain.");			

					DeletePVar(playerid, "mekanik_vehicle_id");
					DeletePVar(playerid, "mekanik_warna_1");
					DeletePVar(playerid, "mekanik_warna_2");
					return 1;
				}

				new modelid = GetVehicleModel(vid);

				switch (modelid)
				{
					case 534 .. 536, 558 .. 562, 565, 567, 575, 576:
					{
						if (!strcmp(inputtext, "Wheels") || !strcmp(inputtext, "Hydraulics"))
						{
							new Query[99];
							
							mysql_format(koneksi, Query, sizeof Query, "SELECT componentid,type FROM vehicle_components WHERE part='%e' ORDER BY type", inputtext);
							mysql_tquery(koneksi, Query, "OnTuneLoad", "ii", playerid, 2);
						}
						else
						{
							new Query[113];
							
							mysql_format(koneksi, Query, sizeof Query, "SELECT componentid,type FROM vehicle_components WHERE cars=%i AND part='%e' ORDER BY type", modelid, inputtext);
							mysql_tquery(koneksi, Query, "OnTuneLoad", "ii", playerid, 2);
						}
					}
					default:
					{
						new Query[101];
						
						mysql_format(koneksi, Query, sizeof Query, "SELECT componentid,type FROM vehicle_components WHERE cars<=0 AND part='%e' ORDER BY type", inputtext);
						mysql_tquery(koneksi, Query, "OnTuneLoad", "ii", playerid, 2);
					}
				}			
			}
			return 1;
		}
		case DIALOG_PILIH_COMPONENT_2:
		{
			if(response){
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);

				new Float:vpos[3];
				new vid = GetPVarInt(playerid, "mekanik_vehicle_id");

				if(!IsValidVehicle(vid)) {
					SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal modif kendaraan, disebabkan oleh kendaraan tidak ada.");

					DeletePVar(playerid, "mekanik_vehicle_id");
					return 1;
				}
				GetVehiclePos(vid, vpos[0], vpos[1], vpos[2]);
				if(!IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
					SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal modif kendaraan. Kendaraan berpindah keposisi lain.");			

					DeletePVar(playerid, "mekanik_vehicle_id");
					return 1;
				}

				new componentid;
				if (!sscanf(inputtext, "i", componentid)) {
					if(IsValidComponentForVehicle(vid, PVeh[IDVehToPVeh[vid]][pVehMod][GetVehicleComponentType(componentid)])){
						if(PVeh[IDVehToPVeh[vid]][pVehMod][GetVehicleComponentType(componentid)] == componentid) {
							new nama_komponen[50];
							GetComponentName(componentid, nama_komponen);
							sendPesan(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Komponen %s telah terpasang pada kendaraan ini.", nama_komponen);

							DeletePVar(playerid, "mekanik_vehicle_id");
							return 1;
						}
					}

					AddVehicleComponent(vid, componentid);
				}else{
					SendClientMessage(playerid, COLOR_BLUE, TAG_KENDARAAN" "WHITE"Berhasil melepas hydraulics dari kendaraan anda.");
					SendClientMessage(playerid, COLOR_YELLOW, TAG_KENDARAAN" "WHITE"Khusus untuk penyabutan barang, anda tidak dikenakan biaya atau apapaun.");

					// Lepas komponen hydraulics
					PVeh[IDVehToPVeh[vid]][pVehMod][GetVehicleComponentType(1087)] = 0;
					RemoveVehicleComponent(vid, 1087);
					UpdateTampilanVehiclePlayer(vid);
					return 1;
				}

				// sideskirts and vents that have left and right side should be applied twice
				switch (componentid)
				{
					case 1007, 1027, 1030, 1039, 1040, 1051, 1052, 1062, 1063, 1071, 1072, 1094, 1099, 1101, 1102, 1107, 1120, 1121, 1124, 1137, 1142 .. 1145: AddVehicleComponent(vid, componentid);
				}
				
				new component_name[40];
				SetPVarInt(playerid, "mekanik_komponen_id", componentid);
				GetComponentName(componentid, component_name);

				format(pDialog[playerid], sizePDialog, WHITE"Anda akan modifikasi kendaraan jenis "GREEN"%s\n\
					"YELLOW"Anda akan memasang %s pada kendaraan anda.\n\n", GetVehicleModelName(GetVehicleModel(vid)), component_name);
				strcat(pDialog[playerid], WHITE"Anda akan menggunakan "RED"1 item sparepart kendaraan "WHITE"untuk dapat memodifikasi.\n\
					Anda yakin ingin memodifikasinya ?\n");
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_PREVIEW_MODIF_MEKANIK, DIALOG_STYLE_MSGBOX, "Modifikasi kendaraan", pDialog[playerid], "Konfirmasi", "Batal");				
			}
			return 1;
		}
		case DIALOG_PILIH_PAINTJOB:
		{
			if(response){
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);

				new Float:vpos[3];
				new vid = GetPVarInt(playerid, "mekanik_vehicle_id");

				if(!IsValidVehicle(vid)) {
					SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal paintjob kendaraan, disebabkan oleh kendaraan tidak ada.");

					DeletePVar(playerid, "mekanik_vehicle_id");
					return 1;
				}
				GetVehiclePos(vid, vpos[0], vpos[1], vpos[2]);
				if(!IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
					SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal paintjob kendaraan. Kendaraan berpindah keposisi lain.");			

					DeletePVar(playerid, "mekanik_vehicle_id");
					return 1;
				}

				if(!strcmp(inputtext, "Lepas Paintjob")){
					SendClientMessage(playerid, COLOR_BLUE, TAG_KENDARAAN" "WHITE"Berhasil melepas paintjob dari kendaraan anda.");
					SendClientMessage(playerid, COLOR_YELLOW, TAG_KENDARAAN" "WHITE"Khusus untuk penyabutan barang, anda tidak dikenakan biaya atau apapaun.");

					// Lepas paintjob
					PVeh[IDVehToPVeh[vid]][pVehPaintJob] = INVALID_PAINTJOB_ID;
					RemoveVehiclePaintjob(vid);
					UpdateTampilanVehiclePlayer(vid);
					return 1;
				}

				if(IsValidPaintjobForVehicle(vid, PVeh[IDVehToPVeh[vid]][pVehPaintJob])){
					if(PVeh[IDVehToPVeh[vid]][pVehPaintJob] == listitem) {
						sendPesan(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Paintjob tipe %d telah terpasang pada kendaraan ini.", listitem + 1);

						DeletePVar(playerid, "mekanik_vehicle_id");
						return 1;
					}
				}

				new paintjobid = listitem;

				SetPVarInt(playerid, "mekanik_paintjob_id", paintjobid);
				ChangeVehiclePaintjob(vid, listitem);
				
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan paintjob kendaraan jenis "GREEN"%s\n\
					"YELLOW"Anda akan memasang paintjob tipe %d pada kendaraan ini.\n\n", GetVehicleModelName(GetVehicleModel(vid)), paintjobid + 1);
				strcat(pDialog[playerid], WHITE"Anda akan menggunakan "RED"1 item paintjob kendaraan "WHITE"untuk dapat menpaintjobnya.\n\
					Apakah anda yakin ?\n");
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_PREVIEW_PAINTJOB_MEKANIK, DIALOG_STYLE_MSGBOX, "Paintjob kendaraan", pDialog[playerid], "Konfirmasi", "Batal");				
			}
			return 1;	
		}
		case DIALOG_KONFIRMASI_PREVIEW_PAINTJOB_MEKANIK:
		{
			new vehid = GetPVarInt(playerid, "mekanik_vehicle_id"),
				paintjobid = GetPVarInt(playerid, "mekanik_paintjob_id");
			if(response){
				// Pinjam timer perbaiki
				PerbaikiTimer[playerid] = SetPreciseTimer("progressPaintjobKendaraan", 1000, true, "iii", playerid, vehid, paintjobid);

				// Pinjam progress bar dari potong pohon
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
				ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
				TogglePlayerControllable(playerid, 0);
				GameTextForPlayer(playerid, "~w~Sedang ~y~Paintjob...", 3000, 3);
				ApplyAnimation(playerid, "SPRAYCAN", "spraycan_fire", 4.1, 1, 0, 0, 1, 0, 1);	
				PlayerInfo[playerid][isOnAnimation] = true;	
				PlayerInfo[playerid][isBusy] = true;	
			}

			// Lepas
			RemoveVehiclePaintjob(vehid);

			new idpv = IDVehToPVeh[vehid];
			if(IsValidPaintjobForVehicle(vehid, PVeh[idpv][pVehPaintJob])){
				ChangeVehiclePaintjob(vehid, PVeh[idpv][pVehPaintJob]);
			}
			
			DeletePVar(playerid, "mekanik_vehicle_id");
			DeletePVar(playerid, "mekanik_paintjob_id");				
			return 1;
		}
		case DIALOG_KONFIRMASI_PREVIEW_MODIF_MEKANIK:
		{
			new vehid = GetPVarInt(playerid, "mekanik_vehicle_id"),
				componentid = GetPVarInt(playerid, "mekanik_komponen_id");
			if(response){
				// Pinjam timer perbaiki
				PerbaikiTimer[playerid] = SetPreciseTimer("progressModifKendaraan", 1000, true, "iii", playerid, vehid, componentid);

				// Pinjam progress bar dari potong pohon
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
				ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
				TogglePlayerControllable(playerid, 0);
				GameTextForPlayer(playerid, "~w~Sedang ~y~Modifikasi...", 3000, 3);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 0, 0, 1, 0, 1);
				PlayerInfo[playerid][isOnAnimation] = true;				
				PlayerInfo[playerid][isBusy] = true;				
			}

			// Lepas
			new slotid = GetVehicleComponentType(componentid);
			new idpv = IDVehToPVeh[vehid];
			
			RemoveVehicleComponent(vehid, componentid);
			// sideskirts and vents that have left and right side should be applied twice
			switch (componentid)
			{
				case 1007, 1027, 1030, 1039, 1040, 1051, 1052, 1062, 1063, 1071, 1072, 1094, 1099, 1101, 1102, 1107, 1120, 1121, 1124, 1137, 1142 .. 1145: RemoveVehicleComponent(vehid, componentid);
			}


			if(IsValidComponentForVehicle(vehid, PVeh[idpv][pVehMod][slotid])){
				// Kembalikan ke awal
				AddVehicleComponent(vehid, PVeh[idpv][pVehMod][slotid]);
			}

			DeletePVar(playerid, "mekanik_vehicle_id");
			DeletePVar(playerid, "mekanik_komponen_id");				
			return 1;
		}
		case DIALOG_KONFIRMASI_WARNAIN_MEKANIK:
		{
			if(response){
				cekKetersediaanItem(playerid, 28, 1, "konfirmasiWarnainMekanik"); // Pewarna kendaraan id 28 - butuh 1pcs
			}else{
				DeletePVar(playerid, "mekanik_vehicle_id");
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_PERBAIKI_MEKANIK:
		{
			if(response){
				cekKetersediaanItem(playerid, 27, GetPVarInt(playerid, "mekanik_alat_dibutuhkan"), "konfirmasiPerbaikiMekanik");
			}else{
				DeletePVar(playerid, "mekanik_vehicle_id");
				DeletePVar(playerid, "mekanik_alat_dibutuhkan");
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_BUAT_ALAT_PERBAIKAN:
		{
			if(response){
				tambahItemPlayer(playerid, 11, -1);
				tambahItemPlayer(playerid, 12, -3);

				new rate_sukses = getRateBerhasilSkill(PlayerInfo[playerid][expMekanik], 1),
					rand = random(100) + 1, // Generate random value 1 to 100
					exp_didapat;

				if(rand <= rate_sukses){
					tambahItemPlayer(playerid, 27, 1); // Beri item

					if(PlayerInfo[playerid][expMekanik] < LEVEL_SKILL_DUA) // Jika level exp player adalah lvl 1
						exp_didapat = EXP_SUKSES_CURR_SKILL;
					else // Jika level exp player >  1
						exp_didapat = EXP_SUKSES_DOWN_SKILL;

					tambahExpSkillPlayer(playerid, ID_SKILL_MEKANIK, exp_didapat); // 1 adalah id skill mekanik
					format(pDialog[playerid], sizePDialog, WHITE"Berhasil membuat alat perbaikan kendaraan.\nAnda dapat menggunakan item ini untuk memperbaiki kendaraan.\n\n"YELLOW"Karena berhasil membuat alat anda mendapatkan %d exp mekanik.", exp_didapat);
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membuat alat perbaikan", pDialog[playerid], "Ok", "");

					sendPesan(playerid, COLOR_LIGHT_BLUE, "[SKILL] "WHITE"Exp dari skill mekanik anda saat ini adalah %d.", PlayerInfo[playerid][expMekanik]);
					// Exp Score
					TambahExpScore(playerid, EXP_TAMBAH_SKILL);
					return 1;
				}else{
					if(PlayerInfo[playerid][expMekanik] < LEVEL_SKILL_DUA) // Jika level exp player adalah lvl 1
						exp_didapat = EXP_GAGAL_CURR_SKILL;
					else // Jika level exp player >  1
						exp_didapat = EXP_GAGAL_DOWN_SKILL;
					
					tambahExpSkillPlayer(playerid, ID_SKILL_MEKANIK, exp_didapat); // 1 adalah id skill mekanik
					
					format(pDialog[playerid], sizePDialog, WHITE"Gagal membuat alat perbaikan kendaraan.\n\n"YELLOW"Anda mendapatkan %d exp mekanik.", exp_didapat);
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Gagal membuat alat perbaikan", pDialog[playerid], "Ok", "");
					// Exp Score
					TambahExpScore(playerid, EXP_TAMBAH_SKILL);
					return 1;
				}						
			}
			return 1;
		}
		case DIALOG_PILIH_WARNA_1:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					showDialogPilihWarnaKendaraan(playerid, dialogid, "Pilih warna kendaraan - Warna 1");
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
						showDialogPilihWarnaKendaraan(playerid, dialogid, "Pilih warna kendaraan - Warna 1");
					}else{
						SetPVarInt(playerid, "halaman", 0);
						showDialogPilihWarnaKendaraan(playerid, dialogid, "Pilih warna kendaraan - Warna 1");
					}
					return 1;
				}

				SetPVarInt(playerid, "mekanik_warna_1", listitem);
				showDialogPilihWarnaKendaraan(playerid, DIALOG_PILIH_WARNA_2, "Pilih warna kendaraan - Warna 2");
			}else
				DeletePVar(playerid, "mekanik_vehicle_id");
			return 1;
		}
		case DIALOG_PILIH_WARNA_2:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					showDialogPilihWarnaKendaraan(playerid, dialogid, "Pilih warna kendaraan - Warna 2");
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
						showDialogPilihWarnaKendaraan(playerid, dialogid, "Pilih warna kendaraan - Warna 2");
					}else{
						SetPVarInt(playerid, "halaman", 0);
						showDialogPilihWarnaKendaraan(playerid, dialogid, "Pilih warna kendaraan - Warna 2");
					}
					return 1;
				}

				SetPVarInt(playerid, "mekanik_warna_2", listitem);

				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);

				new Float:vpos[3];
				new vid = GetPVarInt(playerid, "mekanik_vehicle_id");

				if(!IsValidVehicle(vid)) {
					SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal mewarnai kendaraan, disebabkan oleh kendaraan tidak ada.");

					DeletePVar(playerid, "mekanik_vehicle_id");
					DeletePVar(playerid, "mekanik_warna_1");
					DeletePVar(playerid, "mekanik_warna_2");
					return 1;
				}
				GetVehiclePos(vid, vpos[0], vpos[1], vpos[2]);
				if(!IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
					SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal mewarnai kendaraan. Kendaraan berpindah keposisi lain.");			

					DeletePVar(playerid, "mekanik_vehicle_id");
					DeletePVar(playerid, "mekanik_warna_1");
					DeletePVar(playerid, "mekanik_warna_2");
					return 1;
				}
				
				format(pDialog[playerid], sizePDialog, "Anda akan mewarnai kendaraan jenis "GREEN"%s\n\
					"WHITE"Anda memilih warna 1 {%06x}##### "WHITE"- %d dan warna 2 {%06x}##### "WHITE"- %d\n\n", GetVehicleModelName(GetVehicleModel(vid)), gVehicleColors[GetPVarInt(playerid, "mekanik_warna_1")] >>> 8, GetPVarInt(playerid, "mekanik_warna_1"), gVehicleColors[GetPVarInt(playerid, "mekanik_warna_2")] >>> 8, GetPVarInt(playerid, "mekanik_warna_2"));
				strcat(pDialog[playerid], WHITE"Anda akan menggunakan "RED"1 item pewarna kendaraan "WHITE"untuk dapat mewarnainya.\n\
					Anda yakin ingin mewarnainya ?\n");
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_PREVIEW_WARNA_MEKANIK, DIALOG_STYLE_MSGBOX, "Warnain kendaraan", pDialog[playerid], "Konfirmasi", "Batal");

				ChangeVehicleColor(vid, GetPVarInt(playerid, "mekanik_warna_1"), GetPVarInt(playerid, "mekanik_warna_2"));
			}else{
				DeletePVar(playerid, "mekanik_vehicle_id");
				DeletePVar(playerid, "mekanik_warna_1");
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_PREVIEW_WARNA_MEKANIK:
		{
			new vehid = GetPVarInt(playerid, "mekanik_vehicle_id"),
				col1 = GetPVarInt(playerid, "mekanik_warna_1"),
				col2 = GetPVarInt(playerid, "mekanik_warna_2");
			if(response){
				// Pinjam timer perbaiki
				PerbaikiTimer[playerid] = SetPreciseTimer("progressWarnainKendaraan", 1000, true, "iiii", playerid, vehid, col1, col2);

				// Pinjam progress bar dari potong pohon
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
				ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
				TogglePlayerControllable(playerid, 0);
				GameTextForPlayer(playerid, "~w~Sedang ~y~mewarnain...", 3000, 3);
				ApplyAnimation(playerid, "SPRAYCAN", "spraycan_fire", 4.1, 1, 0, 0, 1, 0, 1);
			}

			new idpv = IDVehToPVeh[vehid];
			// Kembalikan ke awal
			ChangeVehicleColor(vehid, PVeh[idpv][pVehColor][0], PVeh[idpv][pVehColor][1]);
			
			DeletePVar(playerid, "mekanik_vehicle_id");
			DeletePVar(playerid, "mekanik_warna_1");
			DeletePVar(playerid, "mekanik_warna_2");			
			return 1;
		}
		case DIALOG_MENU_BELI_ALAT_PANCING:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);
				ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_ALAT_PANCING, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
			}else{
				DeletePVar(playerid, "index_terpilih");
				DeletePVar(playerid, "jumlah_terpilih");
			}
			return 1;
		}
		case DIALOG_JUMLAH_PEMBELIAN_ALAT_PANCING:
		{
			if(response){
				new jumlah;
				if(sscanf(inputtext, "i", jumlah)) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_ALAT_PANCING, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
				if(jumlah < 1 || jumlah > 10) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_ALAT_PANCING, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar dan anda hanya dapat membeli 10 dalam sekali pembelian.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
				SetPVarInt(playerid, "jumlah_terpilih", jumlah);
				format(pDialog[playerid], sizePDialog, "Pembelian %s sebanyak %d", MENU_ALAT_PANCING[GetPVarInt(playerid, "index_terpilih")][hargaItem], jumlah);
				dialogMetodeBayar(playerid, GetPVarInt(playerid, "jumlah_terpilih") * MENU_ALAT_PANCING[GetPVarInt(playerid, "index_terpilih")][hargaItem], "selesaiBeliPancing", pDialog[playerid]);
			}else{
				DeletePVar(playerid, "index_terpilih");
				DeletePVar(playerid, "jumlah_terpilih");
				showDialogBeliAlatPancing(playerid);
			}
			return 1;
		}
		case DIALOG_PILIH_SPAWN_REGISTER:
		{
			if(response){
				new Float:temp_pos[4];
				switch(listitem){
					case 0: // pantai st maria
					{
						temp_pos[0] = 288.5987;
						temp_pos[1] = -1984.3574;
						temp_pos[2] = 2.4633;
						temp_pos[3] = 357.0744;
					}
					case 1: // Kereta api
					{
						temp_pos[0] = 1754.5775;
						temp_pos[1] = -1898.9517;
						temp_pos[2] = 13.5615;
						temp_pos[3] = 269.7162;						
					}
					case 2: // bandara ls
					{
						temp_pos[0] = 1649.4506;
						temp_pos[1] = -2329.8547;
						temp_pos[2] = 13.5469;
						temp_pos[3] = 7.0336;
					}
				}
				SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], temp_pos[0], temp_pos[1], temp_pos[2], temp_pos[3], 0, 0, 0, 0, 0, 0);

				SpawnPlayer(playerid);

				pindahkanPemain(playerid, temp_pos[0], temp_pos[1], temp_pos[2], temp_pos[3], 0, 0, true);
			}else{
				new random_spawn = random(sizeof(SPAWN_POINT));
				SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], SPAWN_POINT[random_spawn][SPAWN_POINT_X], SPAWN_POINT[random_spawn][SPAWN_POINT_Y], SPAWN_POINT[random_spawn][SPAWN_POINT_Z], SPAWN_POINT[random_spawn][SPAWN_POINT_A], 0, 0, 0, 0, 0, 0);
				
				SpawnPlayer(playerid);

				pindahkanPemain(playerid, SPAWN_POINT[random_spawn][SPAWN_POINT_X], SPAWN_POINT[random_spawn][SPAWN_POINT_Y], SPAWN_POINT[random_spawn][SPAWN_POINT_Z], SPAWN_POINT[random_spawn][SPAWN_POINT_A], SPAWN_POINT[random_spawn][SPAWN_POINT_INTERIOR], SPAWN_POINT[random_spawn][SPAWN_POINT_VW], true);
			}
			TogglePlayerControllable(playerid, 0);
			SetPreciseTimer("GantiSkinSaatSpawn", 2000, false, "i", playerid);

			// Sync uang player
			getUangPlayer(playerid);
			return 1;
		}
		case DIALOG_FISHING:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						if(GetSlotInventoryPlayer(playerid) + 1 > PlayerInfo[playerid][limitItem]){
							return showDialogPesan(playerid, RED"Inventory anda penuh", WHITE"Silahkan sisakan minimal 1 slot item anda terlebih dahulu.\nPengosongan berguna untuk menyisakan tempat untuk hasil yang didapat nantinya.");
						}

						// Mancing Ikan
						new Float: x, Float: y, Float: z, Float: a, Float: tmp, obj;
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, a);
						obj = CA_RayCastLine(x, y, z, x+(3.0*floatsin(-a, degrees)), y+(3.0*floatsin(-a, degrees)), z-3.0, tmp, tmp, tmp);
						if(PlayerInfo[playerid][sisaJoran] <= 0) return error_command(playerid, "Anda tidak memiliki joran pancing.");
						if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
						if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return error_command(playerid, "Tidak dapat memancing dalam keadaan sekarang.");
						if(obj != 20000) return error_command(playerid, "Anda harus berada di pinggir perairan untuk dapat memancing.");

						if(GetJumlahItemPlayer(playerid, ID_ROTI_UMPAN_IKAN) <= 0){
							return error_command(playerid, "Anda tidak memiliki umpan untuk melakukan mancing.");
						}
						tambahItemPlayer(playerid, 43, -1);
						TogglePlayerControllable(playerid , 0);
						SetPlayerArmedWeapon(playerid, 0);
						ApplyAnimation(playerid,"SWORD","sword_block", 50.0, 0, 1, 0, 1, 1);
						SetPlayerAttachedObject(playerid, PANCINGAN_ATTACH_INDEX,18632, 6, 0.079376, 0.037070, 0.007706, 181.482910, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
						mancingSecs[playerid] = 30;
						mancingAktif[playerid] = 1;
						mancingTimer[playerid] = SetPreciseTimer("waktuMancing", 1000, true, "i", playerid);
						// Achievement berlaut
						PlayerInfo[playerid][ach_Berlaut]++;
					}
					case 1:
					{
						// Toko Peralatan Pancing
						SetPlayerCheckpoint(playerid, 1024.2606,-1892.4369,12.8019, 2.0); // Dibuat list jika lebih dari 1
						PlayerInfo[playerid][activeMarker] = true;
						SendClientMessage(playerid, COLOR_GREEN, "[Fishing System] "WHITE"Anda telah berhasil menandai toko peralatan pancing.");
					}
				}
			}
			return 1;
		}
		case DIALOG_TALK_TO_DEALER_MANAGER:
		{
			if(response)
				showDialogDealerManager(playerid);
			return 1;
		}
		case DIALOG_TALK_TO_DEALER_MANAGER_LIST:
		{
			if(response)
			{
				ActorTalking(ACT_NPC[ACTOR_SKILL_MEKANIK][actID]);
				switch(listitem){
					case 0: // Jual Vehicle
					{
						inline responseQuery(){
							new rows;
							cache_get_row_count(rows);
							if(rows){
								new idx = 0, harga, modelid;
								format(pDialog[playerid], sizePDialog, "Jenis Kendaraan\tHarga Beli\n");
								do{
									cache_get_value_name_int(idx, "harga_beli", harga);
									cache_get_value_name_int(idx, "id_model", modelid);
									strcatEx(pDialog[playerid], sizePDialog, WHITE"%s\t"GREEN"$%d\n", GetVehicleModelName(modelid), harga);
								}
								while(++idx < rows);
								
								// Hapus jika ada cache sebelumnya, untuk menghindari memory leak
								if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
								// Save cache
								PlayerInfo[playerid][tempCache] = cache_save();

								ShowPlayerDialog(playerid, DIALOG_TALK_TO_DEALER_MANAGER_JUAL_KENDARAAN, DIALOG_STYLE_TABLIST_HEADERS, "Pilih kendaraan yang ingin kamu jual", pDialog[playerid], "Pilih", "Kembali");
							}else
								showDialogPesan(playerid, RED"Tidak memiliki kendaraan", WHITE"Anda tidak memiliki kendaraan apapun.\n\
									Anda hanya dapat menjual kendaraan yang merupakan milik anda.");
						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT * FROM vehicle WHERE id_pemilik = %d", PlayerInfo[playerid][pID]);
					}
				}
			}
			return 1;
		}
		case DIALOG_TALK_TO_DEALER_MANAGER_JUAL_KENDARAAN:
		{
			if(response){
				new harga_beli, modelid;
				SetPVarInt(playerid, "index_terpilih", listitem);
				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name_int(listitem, "harga_beli", harga_beli);
				cache_get_value_name_int(listitem, "id_model", modelid);
				cache_unset_active();
				
				new harga;

				// Prevent division by zero
				if(harga_beli > 0) 
					harga = harga_beli * PERSEN_HARGA_JUAL_DARI_HARGA_BELI_KENDARAAN / 100;
				else
					harga = 0;

				format(pDialog[playerid], sizePDialog, WHITE"\
						Anda akan menjual kendaraan anda dengan spesifikasi berikut:\n\n\
						Jenis Kendaraan\t: "ORANGE"%s\n\
						"WHITE"Harga Jual\t\t: "GREEN"$%d\n", GetVehicleModelName(modelid), 
						harga);
				strcatEx(pDialog[playerid], sizePDialog, "\n\
					"YELLOW"Harga didapat dari %d persen harga beli.\n\
					Yang berarti "WHITE"$%d x %d persen = "GREEN"$%d\n\n\
					"WHITE"Apakah anda yakin ?\n\n\
					"YELLOW"Note : Penghitungan harga dilakukan dengan pembulatan kebawah.", PERSEN_HARGA_JUAL_DARI_HARGA_BELI_KENDARAAN, harga_beli, PERSEN_HARGA_JUAL_DARI_HARGA_BELI_KENDARAAN, harga);
				ShowPlayerDialog(playerid, DIALOG_TALK_TO_DEALER_MANAGER_JUAL_KENDARAAN_KONFIRMASI, DIALOG_STYLE_MSGBOX, WHITE"Konfirmasi Jual Kendaraan", pDialog[playerid], "Jual", "Batal");
			}else{
				showDialogDealerManager(playerid);
				ResetPVarTemporary(playerid);
			}
			return 1;
		}
		case DIALOG_TALK_TO_DEALER_MANAGER_JUAL_KENDARAAN_KONFIRMASI:
		{
			if(response){
				new idx = GetPVarInt(playerid, "index_terpilih");
				new harga_beli, id_primary, harga, id_pemilik, modelid;

				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name_int(idx, "id", id_primary);
				cache_get_value_name_int(idx, "harga_beli", harga_beli);
				cache_get_value_name_int(idx, "id_model", modelid);
				cache_get_value_name_int(idx, "id_pemilik", id_pemilik);
				cache_unset_active();
				ResetPVarTemporary(playerid); // Reset all variabel temp

				if(id_pemilik != PlayerInfo[playerid][pID]) {
					printf("#Error 013 - ID Pemilik dengan ID penjual mobil tidak sama.");
					return 1;
				}

				// Prevent division by zero
				if(harga_beli > 0) 
					harga = harga_beli * PERSEN_HARGA_JUAL_DARI_HARGA_BELI_KENDARAAN / 100;
				else
					harga = 0;				

				harga = harga_beli * PERSEN_HARGA_JUAL_DARI_HARGA_BELI_KENDARAAN / 100;
				givePlayerUang(playerid, harga);

				// IMPORTANT TODO - Sebaiknya tidak didelete datanya namun dipindahkan ke table deleted vehicle
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM vehicle WHERE id = %d", id_primary);
				mysql_tquery(koneksi, pQuery[playerid]);

				// Remove kunci dipinjamkan dari database
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM vehicle_keys WHERE id_vehicle  = %d", id_primary);
				mysql_tquery(koneksi, pQuery[playerid]);

				format(pDialog[playerid], sizePDialog, WHITE"\
						Anda berhasil menjual kendaraan berikut :\n\n\
						Jenis Kendaraan\t: "ORANGE"%s\n\
						"WHITE"Harga Jual\t\t: "GREEN"$%d\n", GetVehicleModelName(modelid), 
						harga);
				strcatEx(pDialog[playerid], sizePDialog, "\n\
					"YELLOW"Kendaraan yang dijual akan otomatis hilang dari inventory dan server. \nKendaraan yang telah dijual tidak dapat dikembalikan lagi.\nJika terjadi kesalahan user saat menjual kendaraan diluar tanggung jawab server.");
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Anda berhasil menjual kendaraan", pDialog[playerid], "Ok", "");

				PlayerGivesAnimation(ACT_NPC[ACTOR_SKILL_MEKANIK][actID]);
				PlayerTakesAnimation(playerid);

				// Hancurkan vehicle
				static const kosong_pveh[PlayerVehicleInfo];
				foreach(new i : PVehIterator){
					if(PVeh[i][pVehPemilik] == PlayerInfo[playerid][pID] && PVeh[i][pVehID] == id_primary) {
						// Looping ke player lain apakah ada pemegang kunci
						// Jika ada maka lepas kuncinya secara paksa
						foreach(new j : Player){
							if(PVeh[i][pVehPemilik] != PlayerInfo[j][pID] && Iter_Contains(PVehKeys[j], i)){
								Iter_Remove(PVehKeys[j], i);
								PVehKeysTime[j][i] = 0;
							}
						}

						new cur = i;
						#if DEBUG_SERVER_LOAD == true
						printf("Vehicle Player %s Vehicle-ID(%d) ig-ID(%d) unloaded.", PlayerInfo[playerid][pPlayerName], PVeh[i][pVehID], i);
						#endif
						if(IsValidVehicle(PVeh[i][pVehicle]) && Iter_Contains(IDVehToPVehIterator, PVeh[i][pVehicle]))
						{
							Iter_Remove(IDVehToPVehIterator, PVeh[i][pVehicle]);
							IDVehToPVeh[PVeh[i][pVehicle]] = 0;
							DestroyVehicle(PVeh[i][pVehicle]);
						}

						PVeh[i] = kosong_pveh;
						Iter_SafeRemove(PVehIterator, cur, i);
					}
				}			
			}else{
				ResetPVarTemporary(playerid);
			}
			return 1;
		}
		case DIALOG_SIM_REGIS_TYPE:
		{
			if(response){
				if(todoActive(playerid) == 1){
					return 1;
				}
				switch(listitem){
					case 0:
					{
						SetPVarInt(playerid, "tipe_sim", 1);
					}
					case 1:
					{
						SetPVarInt(playerid, "tipe_sim", 2);
					}
					case 2:
					{
						SetPVarInt(playerid, "tipe_sim", 3);
					}
				}
				SetPVarString(playerid, "sim_polisi", "buat_sim");
				getSudahBuatSIM(playerid, "cekSudahPunyaSIM");
			}else{
				ShowPlayerDialog(playerid, DIALOG_SIM_REGIS_MENU, DIALOG_STYLE_LIST, WHITE"Pilihan tindakan SIM", "Buat SIM\nTentang SIM (Tipe Kendaraan)\nAmbil SIM yang sudah selesai", "Pilih", "Batal");
			}
			return 1;
		}
		case DIALOG_PILIH_ISI_BENSIN:
		{
			if(response){
				new vehicleid = GetPVarInt(playerid, "id_vehicle_bensin"),
					harga = 0,
					persen = 0;

				switch(listitem){
					case 0: // 20 persen - $5
					{
						harga = 5;
						persen = 20;
					}
					case 1: // 50 persen - $10
					{
						harga = 10;
						persen = 50;
					}
					case 2: // 100 persen - $17
					{
						harga = 17;
						persen = 100;
					}
				}

				format(
					pDialog[playerid], 
					sizePDialog, 
					WHITE"Bensin anda akan diisi dengan spesifikasi berikut.\n\n\
					Nama Kendaraan\t: %s\n\
					Bensin yang diisi\t: %d\n\
					Harga Bensin\t\t: $%d\n\n\
					"YELLOW"Apakah anda yakin ingin membeli bensin ini ?", 
					GetVehicleModelName(GetVehicleModel(vehicleid)),
					persen,
					harga
				);

				SetPVarInt(playerid, "harga_bensin", harga);
				SetPVarInt(playerid, "persen_bensin", persen);

				ShowPlayerDialog(
					playerid, 
					DIALOG_KONFIRMASI_BELI_BENSIN, DIALOG_STYLE_MSGBOX, 
					"Konfirmasi Pembelian",	
					pDialog[playerid],
					"Konfirmasi", 
					"Kembali"
				);
			}else
				DeletePVar(playerid, "id_vehicle_bensin");
			return 1;
		}
		case DIALOG_KONFIRMASI_BELI_BENSIN:
		{
			if(response){
				new harga = GetPVarInt(playerid, "harga_bensin"),
					vehid = GetPVarInt(playerid, "id_vehicle_bensin");

				if(getUangPlayer(playerid) < harga) 
					return SendClientMessage(playerid, COLOR_RED, "Uang: "WHITE"Anda tidak memiliki cukup uang.");

				new Float:pos[3], Float:vpos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 3.0);
				GetVehiclePos(vehid, vpos[0], vpos[1], vpos[2]);

				if(!IsValidVehicle(vehid) || !IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0))
					return SendClientMessage(playerid, COLOR_RED, TAG_BENSIN" "WHITE"Kendaraan harus tetap berada didekat anda.");

				// Pinjam timer perbaiki
				PerbaikiTimer[playerid] = SetPreciseTimer("progressIsiBensin", 1000, true, "i", playerid);

				// Pinjam progress bar dari potong pohon
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
				ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
				TogglePlayerControllable(playerid, 0);
				PlayerFillingFuelOnLoop(playerid);
				GameTextForPlayer(playerid, "~w~Sedang ~y~Mengisi Bensin...", 3000, 3);
				
				PlayerInfo[playerid][isOnAnimation] = true;
				PlayerInfo[playerid][isBusy] = true;
			}else{
				DeletePVar(playerid, "harga_bensin");
				DeletePVar(playerid, "persen_bensin");

				showDialogPilihBensin(playerid);
			}
			return 1;
		}
		case DIALOG_JOB_TRASHMASTER_ENTER:
		{
			if(response){
				if(todoActive(playerid) == 1){
					RemovePlayerFromVehicle(playerid);
					return 1;
				}
				trashM_Job[playerid] = 1;
				new vehid = GetPlayerVehicleID(playerid),
				houseClosest = GetClosestHouse(playerid, 10, 10000, 1);
				if(houseClosest == -1){
					trashM_Job[playerid] = 0;
					RemovePlayerFromVehicle(playerid);
					error_command(playerid, "Mohon maaf saat ini tidak tersedia sampah untuk di ambil.");
					return 1;
				}
				trashM_House[playerid] = houseClosest;
				trashM_X[playerid] = houseInfo[houseClosest][icon_x];
				trashM_Y[playerid] = houseInfo[houseClosest][icon_y];
				trashM_Z[playerid] = houseInfo[houseClosest][icon_z];
				trashM_Id[playerid] = vehid;
				trashM_Used[vehid] = 1;
				TogglePlayerAllDynamicCPs(playerid, 0);
				SetPlayerCheckpoint(playerid, trashM_X[playerid], trashM_Y[playerid], trashM_Z[playerid], 3.0);
				PlayerInfo[playerid][activeMarker] = true;
				SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "YELLOW"Anda berhasil bekerja sebagai "GREEN"Trashmaster"YELLOW"!");
				sendPesan(playerid, COLOR_GREEN, TAG_JOB" "WHITE"Anda memiliki waktu %d menit, jika belum selesai anda akan gagal.", TIME_TRASHMASTER);
				SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "WHITE"Gunakan perintah "GREEN"/trashmaster"WHITE" untuk melakukan aktivitas pekerjaan.");
				todoTimeout[playerid] = SetPreciseTimer("resetPlayerToDo", TIME_TRASHMASTER*60000, false, "i", playerid);
			}else{
				RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_JOB_TRASHMASTER_CMD:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						// Angkut Sampah
						if(trashM_BagCap[playerid] == 0) return error_command(playerid, "Anda tidak membawa sampah, silahkan ambil sampah terlebih dahulu.");
						new vid = GetNearestVehicleToPlayer(playerid);
						if(trashM_Used[vid] != 1) return error_command(playerid, "Maaf kendaraan yang anda tuju sedang tidak beroperasi.");
						if(GetVehicleModel(vid) != 408) return error_command(playerid, "Anda tidak berada disekitar truk sampah.");
						new Float: x, Float: y, Float: z;
						GetVehicleBoot(vid, x, y, z);
						if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return error_command(playerid, "Anda tidak berada tepat dibelakang truk sampah.");
						if(trashM_VehCap[vid] >= VEH_TRASH_LIMIT) return error_command(playerid, "Maaf kapasitas truk sampah sudah penuh, tidak dapat mengangkut lagi.");
						trashM_VehCap[vid] += trashM_BagCap[playerid];
						trashM_BagCap[playerid] = 0;
						SetPlayerLookAt(playerid, x, y);
						ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0);
						if(IsPlayerAttachedObjectSlotUsed(playerid, TRASH_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, TRASH_ATTACH_INDEX);
						SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "WHITE"Anda berhasil mengangkut sampah ke dalam truk sampah.");
						if(trashM_VehCap[vid] == VEH_TRASH_LIMIT){
							TogglePlayerAllDynamicCPs(playerid, 1);
							SetPlayerCheckpoint(playerid, 1644.5551,-1537.3542,13.5697, 3.0);
							PlayerInfo[playerid][activeMarker] = true;
						}
					}
					case 1:
					{
						// Muatan Sampah
						if(!IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda tidak berada di dalam kendaraan.");

						new vid = GetPlayerVehicleID(playerid);
						if(GetVehicleModel(vid) != 408) return error_command(playerid, "Anda tidak berada di dalam kendaraan truk sampah.");
						format(pDialog[playerid], sizePDialog, WHITE"Kendaraan anda memiliki muatan sampah sebanyak "GREEN"%d"WHITE" buah.", trashM_VehCap[vid]);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Muatan Sampah", pDialog[playerid], "Ok", "");
					}
				}
			}
			return 1;
		}
		case DIALOG_JOB_PIZZABOY_ENTER:
		{
			if(response){
				if(todoActive(playerid) == 1){
					RemovePlayerFromVehicle(playerid);
					return 1;
				}
				pizza_Job[playerid] = 1;
				new vehid = GetPlayerVehicleID(playerid),
				houseClosest = GetClosestHouse(playerid, 10, 10000, 1);
				if(houseClosest == -1){
					pizza_Job[playerid] = 0;
					RemovePlayerFromVehicle(playerid);
					error_command(playerid, "Mohon maaf saat ini tidak tersedia pesanan untuk di antar.");
					return 1;
				}
				pizza_House[playerid] = houseClosest;
				pizza_X[playerid] = houseInfo[houseClosest][icon_x];
				pizza_Y[playerid] = houseInfo[houseClosest][icon_y];
				pizza_Z[playerid] = houseInfo[houseClosest][icon_z];
				pizza_Used[vehid] = 1;
				pizza_VehCap[vehid] = VEH_PIZZA_LIMIT;
				pizza_Id[playerid] = vehid;
				TogglePlayerAllDynamicCPs(playerid, 0);
				SetPlayerCheckpoint(playerid, pizza_X[playerid], pizza_Y[playerid], pizza_Z[playerid], 3.0);
				PlayerInfo[playerid][activeMarker] = true;
				SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "YELLOW"Anda berhasil bekerja sebagai "GREEN"Pizzaboy"YELLOW"!");
				sendPesan(playerid, COLOR_GREEN, TAG_JOB" "WHITE"Anda memiliki waktu %d menit, jika belum selesai anda akan gagal.", TIME_PIZZABOY);
				SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "WHITE"Gunakan perintah "GREEN"/pizzaboy"WHITE" untuk melakukan aktivitas pekerjaan.");
				todoTimeout[playerid] = SetPreciseTimer("resetPlayerToDo", TIME_PIZZABOY*60000, false, "i", playerid);
			}else{
				RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_JOB_PIZZABOY_CMD:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						// Restok Pizza
						new vid = GetNearestVehicleToPlayer(playerid);
						if(GetVehicleModel(vid) != 448) return error_command(playerid, "Anda tidak berada disekitar kendaraan pengantar pizza.");
						if(!IsPlayerInRangeOfPoint(playerid, 3.0, 2105.01367, -1809.01233, 12.96600)) return error_command(playerid, "Anda tidak berada di sekitar tempat restok pizza.");
						new Float: x, Float: y, Float: z;
						GetVehicleBoot(vid, x, y, z);
						if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return error_command(playerid, "Anda tidak berada tepat dibelakang kendaraan pengantar pizza.");
						if(pizza_VehCap[vid] >= VEH_PIZZA_LIMIT) return error_command(playerid, "Maaf kapasitas box pizza sudah penuh, silahkan antar pesanan.");
						if(pizza_Carry[playerid] == 1) return error_command(playerid, "Anda sedang membawa pizza, silahkan antar terlebih dahulu.");
						pizza_VehCap[vid] = VEH_PIZZA_LIMIT;
						SetPlayerLookAt(playerid, x, y);
						ApplyAnimation(playerid,"CARRY","crry_prtial", 4.1, 0, 0, 0, 0, 0);
						SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "WHITE"Anda berhasil merestok kembali pizza, silahkan antar pesanan.");
						SetPlayerCheckpoint(playerid, pizza_X[playerid], pizza_Y[playerid], pizza_Z[playerid], 3.0);
						PlayerInfo[playerid][activeMarker] = true;
					}
					case 1:
					{
						// Ambil Pizza
						new vid = GetNearestVehicleToPlayer(playerid);
						if(GetVehicleModel(vid) != 448) return error_command(playerid, "Anda tidak berada disekitar kendaraan pengantar pizza.");
						new Float: x, Float: y, Float: z;
						GetVehicleBoot(vid, x, y, z);
						if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return error_command(playerid, "Anda tidak berada tepat dibelakang kendaraan pengantar pizza.");
						if(pizza_VehCap[vid] == 0){
							SetPlayerCheckpoint(playerid, 2105.01367, -1809.01233, 12.96600, 3.0);
							PlayerInfo[playerid][activeMarker] = true;
							error_command(playerid, "Maaf stok pizza sudah habis, silahkan restok kembali.");
							return 1;
						}
						if(pizza_Carry[playerid] == 1) return error_command(playerid, "Anda sedang membawa pizza, silahkan antar terlebih dahulu.");
						pizza_VehCap[vid]--;
						pizza_Carry[playerid] = 1;
						SetPlayerLookAt(playerid, x, y);
						SetPlayerArmedWeapon(playerid, 0);
						ApplyAnimation(playerid,"CARRY","crry_prtial", 4.1, 1, 1, 1, 1, 1);
						SetPlayerAttachedObject(playerid, PIZZA_ATTACH_INDEX, 1582, 1, 0.002953, 0.469660, -0.009797, 269.851104, 88.443557, 0.000000, 0.804894, 1.000000, 0.822361 );
						SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "WHITE"Anda berhasil mengambil pizza dari kendaraan, silahkan antar pesanan.");
					}
					case 2:
					{
						// Muatan Pizza
						if(!IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda tidak berada di dalam kendaraan.");

						new vid = GetPlayerVehicleID(playerid);
						if(GetVehicleModel(vid) != 448) return error_command(playerid, "Anda tidak berada di dalam kendaraan pengantar pizza.");
						format(pDialog[playerid], sizePDialog, WHITE"Kendaraan anda memiliki muatan pizza sebanyak "GREEN"%d"WHITE" buah.", pizza_VehCap[vid]);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Muatan Pizza", pDialog[playerid], "Ok", "");
					}
				}
			}
			return 1;
		}
		case DIALOG_TALK_TO_PENJUAL_PANCING:
		{
			if(response)
				showDialogPenjualPancing(playerid);
			return 1;
		}
		case DIALOG_TALK_TO_PENJUAL_PANCING_LIST:
		{
			if(response)
			{
				ActorTalking(ACT_NPC[ACTOR_SKILL_MEKANIK][actID]);
				switch(listitem){
					case 0: // Beli peralatan pancing
					{
						showDialogBeliAlatPancing(playerid);
					}
				}
			}
			return 1;
		}
		case DIALOG_TALK_TO_PENJUAL_BIBIT:
		{
			if(response)
				showDialogPenjualBibit(playerid);
			return 1;
		}
		case DIALOG_TALK_TO_PENJUAL_BIBIT_LIST:
		{
			if(response)
			{
				ActorTalking(ACT_NPC[ACTOR_SKILL_MEKANIK][actID]);
				switch(listitem){
					case 0: // Beli bibit
					{
						showDialogBeliBibit(playerid);
					}
				}
			}
			return 1;
		}
		case DIALOG_TALK_TO_PENJUAL_BIBIT_NARKO:
		{
			if(response)
				showDialogPenjualBibitNarko(playerid);
			return 1;
		}
		case DIALOG_TALK_TO_PENJUAL_BIBIT_NARKO_LIST:
		{
			if(response)
			{
				ActorTalking(ACT_tokoNarko);
				switch(listitem){
					case 0: // Beli bibit narko
					{
						showDialogBeliBibitNarko(playerid);
					}
				}
			}
			return 1;
		}
		case DIALOG_TALK_TO_AHLI_MEKANIK:
		{
			if(response){
				ActorTalking(ACT_NPC[ACTOR_SKILL_MEKANIK][actID]);
				/*
				 * Lakukan Reset Skill dan Sebagainya
				 */
			}
		}
		case DIALOG_MENU_BELI_PHONE:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);
				ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_PHONE, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
			}else{
				DeletePVar(playerid, "index_terpilih");
				DeletePVar(playerid, "jumlah_terpilih");
			}
			return 1;
		}
		case DIALOG_JUMLAH_PEMBELIAN_PHONE:
		{
			if(response){
				new jumlah;
				if(sscanf(inputtext, "i", jumlah)) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_PHONE, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
				if(jumlah < 1 || jumlah > 10) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_PHONE, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar dan anda hanya dapat membeli 10 dalam sekali pembelian.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
				SetPVarInt(playerid, "jumlah_terpilih", jumlah);
				format(pDialog[playerid], sizePDialog, "Pembelian %s sebanyak %d", MENU_PHONE[GetPVarInt(playerid, "index_terpilih")][hargaItemMarket], jumlah);
				dialogMetodeBayar(playerid, GetPVarInt(playerid, "jumlah_terpilih") * MENU_PHONE[GetPVarInt(playerid, "index_terpilih")][hargaItemMarket], "selesaiBeliPhone", pDialog[playerid]);
			}else{
				DeletePVar(playerid, "index_terpilih");
				DeletePVar(playerid, "jumlah_terpilih");
				showDialogBeliPhone(playerid);
			}
			return 1;
		}
		case DIALOG_TALK_TO_PENJUAL_GADGET:
		{
			if(response)
				showDialogPenjualGadget(playerid);
			return 1;
		}
		case DIALOG_TALK_TO_PENJUAL_GADGET_LIST:
		{
			if(response)
			{
				ActorTalking(ACT_NPC[ACTOR_SKILL_MEKANIK][actID]);
				switch(listitem){
					case 0: // Beli phone
					{
						showDialogBeliPhone(playerid);
					}
				}
			}
			return 1;
		}
		case DIALOG_ADMIN_ACTOR:
		{
			if(response){
				switch(listitem){
					case 0: // Respawn Actor
					{
						ACT__reload = 1;
						// Reload actor
						re_loadAllActor();
					}
				}
			}
			return 1;
		}
		case DIALOG_ON_DUTY_POLICE_PILIH_SKIN:
		{
			if(response){
				PlayerInfo[playerid][skinDuty] = strval(inputtext);
				format(pDialog[playerid], sizePDialog, \
					WHITE"Anda akan menjadi bekerja sebagai anggota kepolisian dengan pangkat "YELLOW"%s\n\
					"WHITE"Anda akan diberi akses untuk melakukan hal-hal yang dapat dilakukan oleh anggota kepolisian sesuai dengan pangkat anda.\n"GREY"Jika anda membutukan guide tentang menjadi anggota polisi yang baik, anda dapat membaca pada artikel yang tersedia.\n\n"YELLOW"Apakah anda ingin mulai bekerja?", GetNamaLevelPolice(GetPlayerPoliceLevel(playerid)));
				return ShowPlayerDialog(playerid, DIALOG_ON_DUTY_POLICE_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Mulai bekerja:", pDialog[playerid], "Mulai", "Batal");
			}
			return 1;
		}
		case DIALOG_ON_DUTY_POLICE_KONFIRMASI:
		{
			if(response){
				if(PlayerInfo[playerid][skinDuty] > 0){
					ClearAnimations(playerid);
					ubahSkinPemain(playerid, PlayerInfo[playerid][skinDuty]);
				}

				switch(GetPlayerPoliceLevel(playerid)){
					case 1:
					{
						GivePlayerWeapon(playerid, WEAPON_NITESTICK, 1); // Tongkat Pukul
						GivePlayerWeapon(playerid, WEAPON_COLT45, 50);
					}
					case 2:
					{
						GivePlayerWeapon(playerid, WEAPON_NITESTICK, 1); // Tongkat Pukul
						GivePlayerWeapon(playerid, WEAPON_DEAGLE, 50);
					}
					case 3:
					{
						GivePlayerWeapon(playerid, WEAPON_NITESTICK, 1); // Tongkat Pukul
						GivePlayerWeapon(playerid, WEAPON_DEAGLE, 50);
						GivePlayerWeapon(playerid, WEAPON_MP5, 100);
						GivePlayerWeapon(playerid, WEAPON_M4, 150);
					}
					case 4:
					{
						GivePlayerWeapon(playerid, WEAPON_NITESTICK, 1); // Tongkat Pukul
						GivePlayerWeapon(playerid, WEAPON_DEAGLE, 50);
						GivePlayerWeapon(playerid, WEAPON_MP5, 100);
						GivePlayerWeapon(playerid, WEAPON_M4, 150);
					}
				}

				SetPlayerDutyPolice(playerid, 1);
				SetPlayerColor(playerid, COLOR_POLISI);
				SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Anda sekarang bekerja sebagai polisi. Selamat bekerja!");
			}
			return 1;
		}
		case DIALOG_OFF_DUTY_POLICE:
		{
			if(response){
				if(PlayerInfo[playerid][skinID] != GetPlayerSkin(playerid)){
					ClearAnimations(playerid);
					ubahSkinPemain(playerid, PlayerInfo[playerid][skinID]);
					PlayerInfo[playerid][skinDuty] = 0;
				}

				SetPlayerDutyPolice(playerid, 0);
				ResetPlayerWeapons(playerid);
				SetPlayerColor(playerid, COLOR_WHITE);
				SendClientMessage(playerid, COLOR_ORANGE, TAG_POLICE" "WHITE"Anda telah mengakiri shift anda sebagai polisi.");
			}
			return 1;
		}
		case DIALOG_ON_DUTY_MEDIC_PILIH_SKIN:
		{
			if(response){
				PlayerInfo[playerid][skinDuty] = strval(inputtext);
				format(pDialog[playerid], sizePDialog, \
					WHITE"Anda akan menjadi bekerja sebagai anggota medis dengan pangkat "YELLOW"%s\n\
					"WHITE"Anda akan diberi akses untuk melakukan hal-hal yang dapat dilakukan oleh anggota medis sesuai dengan pangkat anda.\n"GREY"Jika anda membutukan guide tentang menjadi anggota medis yang benar, anda dapat membaca pada artikel yang tersedia.\n\n"YELLOW"Apakah anda ingin mulai bekerja?", GetNamaLevelMedic(GetPlayerMedicLevel(playerid)));
				return ShowPlayerDialog(playerid, DIALOG_ON_DUTY_MEDIC_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Mulai bekerja:", pDialog[playerid], "Mulai", "Batal");
			}
			return 1;
		}
		case DIALOG_ON_DUTY_MEDIC_KONFIRMASI:
		{
			if(response){
				if(PlayerInfo[playerid][skinDuty] > 0){
					ClearAnimations(playerid);
					ubahSkinPemain(playerid, PlayerInfo[playerid][skinDuty]);
				}

				SetPlayerDutyMedic(playerid, 1);
				SetPlayerColor(playerid, COLOR_MEDIC);
				SendClientMessage(playerid, COLOR_MEDIC, TAG_MEDIC" "WHITE"Anda sekarang bekerja sebagai medis. Selamat bekerja!");
			}
			return 1;
		}
		case DIALOG_OFF_DUTY_MEDIC:
		{
			if(response){
				if(PlayerInfo[playerid][skinID] != GetPlayerSkin(playerid)){
					ClearAnimations(playerid);
					ubahSkinPemain(playerid, PlayerInfo[playerid][skinID]);
					PlayerInfo[playerid][skinDuty] = 0;
				}

				SetPlayerDutyMedic(playerid, 0);
				SetPlayerColor(playerid, COLOR_WHITE);
				SendClientMessage(playerid, COLOR_ORANGE, TAG_MEDIC" "WHITE"Anda telah mengakiri shift anda sebagai medis.");
			}
			return 1;
		}
		case DIALOG_BELI_ALAT_MEKANIK:
		{
			if(response){
				SetPVarInt(playerid, "bAlat_index", listitem);
				ShowPlayerDialog(playerid, DIALOG_JUMLAH_BELI_ALAT_MEKANIK, DIALOG_STYLE_INPUT, "Jumlah dibeli", WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_BELI_ITEM_MEDIS:
		{
			if(response){
				SetPVarInt(playerid, "bItem_index", listitem);
				ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_MEDIS_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_JUMLAH_BELI_ALAT_MEKANIK:
		{
			if(response){
				new banyak_barang;
				if(sscanf(inputtext, "i", banyak_barang)) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_BELI_ALAT_MEKANIK, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Jumlah tidak valid\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");

				if(banyak_barang < 1 || banyak_barang > 1000) return ShowPlayerDialog(playerid, 				
				DIALOG_JUMLAH_BELI_ALAT_MEKANIK, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Jumlah harus berkisar antara 1 hingga 1000.\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");

				new idx = GetPVarInt(playerid, "bAlat_index");

				if(!CekJikaInventoryPlayerMuat(playerid, MENU_ALAT_MEKANIK[idx][idItemAlat], banyak_barang)){
					return ShowPlayerDialog(playerid, 				
				DIALOG_JUMLAH_BELI_ALAT_MEKANIK, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Inventory anda tidak muat untuk menampung item sebanyak itu.\nCek inventory terlebih dahulu.\n\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");
				}

				new nama_alat[50];
				getNamaByIdItem(MENU_ALAT_MEKANIK[idx][idItemAlat], nama_alat);
				
				SetPVarInt(playerid, "bAlat_jumlah", banyak_barang);
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan membeli "YELLOW"%s "WHITE"sebanyak "YELLOW"%d \n"WHITE"dengan total harga "GREEN"%d"WHITE".\nApakah anda yakin?", nama_alat, banyak_barang, MENU_ALAT_MEKANIK[idx][hargaAlat] * banyak_barang);
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_ALAT_MEKANIK, DIALOG_STYLE_MSGBOX, "Konfirmasi pembelian", pDialog[playerid], "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_BELI_ITEM_MEDIS_JUMLAH:
		{
			if(response){
				new banyak_barang;
				if(sscanf(inputtext, "i", banyak_barang)) return ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_MEDIS_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Jumlah tidak valid\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");

				if(banyak_barang < 1 || banyak_barang > 1000) return ShowPlayerDialog(playerid, 				
				DIALOG_BELI_ITEM_MEDIS_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Jumlah harus berkisar antara 1 hingga 1000.\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");

				new idx = GetPVarInt(playerid, "bItem_index");

				if(!CekJikaInventoryPlayerMuat(playerid, MENU_BELI_ITEM_MEDIS[idx][idItemMarket], banyak_barang)){
					return ShowPlayerDialog(playerid, 				
				DIALOG_BELI_ITEM_MEDIS_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Inventory anda tidak muat untuk menampung item sebanyak itu.\nCek inventory terlebih dahulu.\n\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");
				}

				new nama_alat[50];
				getNamaByIdItem(MENU_BELI_ITEM_MEDIS[idx][idItemMarket], nama_alat);
				
				SetPVarInt(playerid, "bItem_jumlah", banyak_barang);
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan membeli "YELLOW"%s "WHITE"sebanyak "YELLOW"%d \n"WHITE"dengan total harga "GREEN"%d"WHITE".\nApakah anda yakin?", nama_alat, banyak_barang, MENU_BELI_ITEM_MEDIS[idx][hargaItemMarket] * banyak_barang);
				ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_MEDIS_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi pembelian", pDialog[playerid], "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_BELI_ITEM_MEDIS_KONFIRMASI:
		{
			if(response){
				new keterangan[50];
				new idx = GetPVarInt(playerid, "bItem_index"),
					nama_alat[50];
				getNamaByIdItem(MENU_BELI_ITEM_MEDIS[idx][idItemMarket], nama_alat);
				format(keterangan, 50, "beli %s sebanyak %dx", nama_alat, GetPVarInt(playerid, "bItem_index"));
				dialogMetodeBayar(playerid, MENU_BELI_ITEM_MEDIS[idx][hargaItemMarket] * GetPVarInt(playerid, "bItem_index"), "selesaiBayarItemMedis", keterangan);
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_ALAT_MEKANIK:
		{
			if(response){
				new keterangan[50];
				new idx = GetPVarInt(playerid, "bAlat_index"),
					nama_alat[50];
				getNamaByIdItem(MENU_ALAT_MEKANIK[idx][idItemAlat], nama_alat);
				format(keterangan, 50, "beli %s sebanyak %dx", nama_alat, GetPVarInt(playerid, "bAlat_jumlah"));
				dialogMetodeBayar(playerid, MENU_ALAT_MEKANIK[idx][hargaAlat] * GetPVarInt(playerid, "bAlat_jumlah"), "selesaiBayarAlatMekanik", keterangan);
			}
			return 1;
		}
		case DIALOG_LIST_TAGIHAN:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					
					if(GetPVarInt(playerid, "jenis_tagihan"))
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `tagihan` WHERE id_user = '%d' AND status = '0' AND jenis = %d ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "jenis_tagihan"), BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
					else
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `tagihan` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);

					mysql_tquery(koneksi, pQuery[playerid], "showTagihanPemain", "i", playerid);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
							
						if(GetPVarInt(playerid, "jenis_tagihan"))
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `tagihan` WHERE id_user = '%d' AND status = '0' AND jenis = %d ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "jenis_tagihan"), BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
						else
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `tagihan` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);

						mysql_tquery(koneksi, pQuery[playerid], "showTagihanPemain", "i", playerid);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						

						if(GetPVarInt(playerid, "jenis_tagihan"))
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `tagihan` WHERE id_user = '%d' AND status = '0' AND jenis = %d ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "jenis_tagihan"), BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
						else
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `tagihan` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);

						mysql_tquery(koneksi, pQuery[playerid], "showTagihanPemain", "i", playerid);
					}
					return 1;
				}
				// Pilihan
				new nominal,
					temp_id,
					temp_keterangan[50],
					temp_tanggal[50];
				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name_int(listitem, "id_tagihan", temp_id);
				cache_get_value_name_int(listitem, "nominal", nominal);
				cache_get_value_name(listitem, "tanggal", temp_tanggal);
				cache_get_value_name(listitem, "keterangan", temp_keterangan);
				cache_delete(PlayerInfo[playerid][tempCache]);
				PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

				SetPVarInt(playerid, "bill_nominal", nominal);
				SetPVarInt(playerid, "bill_id_tagihan", temp_id); // Bisa kah 
				SetPVarString(playerid, "bill_keterangan", temp_keterangan);

				format(pDialog[playerid], sizePDialog, WHITE"Anda akan membayar tagihan.\nDengan spesifikasi berikut:\n\n");
				strcatEx(pDialog[playerid], sizePDialog, WHITE"Nominal\t\t: "GREEN"$%d\n", nominal);
				strcatEx(pDialog[playerid], sizePDialog, WHITE"Tanggal\t\t: "YELLOW"%s\n", temp_tanggal);
				strcatEx(pDialog[playerid], sizePDialog, WHITE"Keterangan\t\t: %s\n\n", temp_keterangan);
				strcatEx(pDialog[playerid], sizePDialog, "Apakah anda yakin ingin membayar?");
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BAYAR_TAGIHAN, DIALOG_STYLE_MSGBOX, "Konfirmasi Bayar Tagihan", pDialog[playerid], "Bayar", "Batal");
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_BAYAR_TAGIHAN:
		{
			if(response){
				new keterangan[50];
				GetPVarString(playerid, "bill_keterangan", keterangan, 50);
				DeletePVar(playerid, "bill_keterangan");
				format(pDialog[playerid], sizePDialog, "bayar tagihan %s", keterangan);
				dialogMetodeBayar(playerid, GetPVarInt(playerid, "bill_nominal"), "selesaiBayarTagihan", pDialog[playerid]);
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_PERIKSA_INVENTORY:
		{
			new target_id = GetPVarInt(playerid, "periksa_target_id");
			DeletePVar(playerid, "periksa_target_id");
			if(response){
				sendPesan(playerid, COLOR_BLUE, TAG_INFO" "WHITE"Anda memperbolehkan %s untuk melihat inventory anda.", PlayerInfo[target_id][pPlayerName]);

				sendPesan(playerid, COLOR_YELLOW, TAG_NOTE" "WHITE"Anda harus tetap berada dekat dengan %s, agar inventory anda dapat diperiksa.", PlayerInfo[target_id][pPlayerName]);
				sendPesan(target_id, COLOR_YELLOW, TAG_NOTE" "WHITE"Anda harus tetap berada dekat dengan %s, agar dapat memeriksa inventorynya.", PlayerInfo[playerid][pPlayerName]);

				sendPesan(target_id, COLOR_GREEN, TAG_INFO" "WHITE"%s membolehkan anda untuk memeriksa inventorynya.", PlayerInfo[playerid][pPlayerName]);

				SetPVarInt(target_id, "periksa_sedang_diperiksa_id", playerid);
				showDialogListItem(target_id, playerid, DIALOG_PERIKSA_INVENTORY);
			}else{
				sendPesan(playerid, COLOR_RED, TAG_INFO" "WHITE"Anda menolak %s untuk melihat inventory anda.", PlayerInfo[target_id][pPlayerName]);
				sendPesan(target_id, COLOR_RED, TAG_INFO" "WHITE"%s menolak anda untuk memeriksa inventorynya.", PlayerInfo[playerid][pPlayerName]);
			}
			return 1;
		}
		case DIALOG_PERIKSA_INVENTORY:
		{
			if(response){
				new target_id = GetPVarInt(playerid, "periksa_sedang_diperiksa_id");
				new Float:pos[3];

				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					if(!IsPlayerConnected(target_id))
						return error_command(playerid, "Pemain yang sedang diperiksa tidak ada.");

					GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
					if(!IsPlayerInRangeOfPoint(playerid, 3.0, pos[0], pos[1], pos[2]))
						return error_command(playerid, "Pemain yang sedang diperiksa tidak berada didekat anda.");


					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					showDialogListItem(playerid, target_id, DIALOG_PERIKSA_INVENTORY);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						if(!IsPlayerConnected(target_id))
							return error_command(playerid, "Pemain yang sedang diperiksa tidak ada.");

						GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
						if(!IsPlayerInRangeOfPoint(playerid, 3.0, pos[0], pos[1], pos[2]))
							return error_command(playerid, "Pemain yang sedang diperiksa tidak berada didekat anda.");

						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);					
						showDialogListItem(playerid, target_id, DIALOG_PERIKSA_INVENTORY);
					}else{
						if(!IsPlayerConnected(target_id))
							return error_command(playerid, "Pemain yang sedang diperiksa tidak ada.");

						GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
						if(!IsPlayerInRangeOfPoint(playerid, 3.0, pos[0], pos[1], pos[2]))
							return error_command(playerid, "Pemain yang sedang diperiksa tidak berada didekat anda.");


						SetPVarInt(playerid, "halaman", 0);
						showDialogListItem(playerid, target_id, DIALOG_PERIKSA_INVENTORY);
					}
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_PILIH_ITEM_MARKETPLACE:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					showDialogBeliItemMarketplace(playerid);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);					
						showDialogBeliItemMarketplace(playerid);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						showDialogBeliItemMarketplace(playerid);
					}
					return 1;
				}

				new id_item,
					id_penjual,
					nama_penjual[MAX_PLAYER_NAME + 1],
					jumlah,
					harga,
					id_mp;

				cache_set_active(PlayerInfo[playerid][tempCache]);

				cache_get_value_name_int(listitem, "id_item", id_item);
				SetPVarInt(playerid, "mp_id_item", id_item);

				cache_get_value_name_int(listitem, "id_user", id_penjual);
				SetPVarInt(playerid, "mp_id_penjual", id_penjual);

				cache_get_value_name_int(listitem, "jumlah", jumlah);
				SetPVarInt(playerid, "mp_jumlah", jumlah);

				cache_get_value_name_int(listitem, "harga", harga);
				SetPVarInt(playerid, "mp_harga", harga);

				cache_get_value_name_int(listitem, "id", id_mp);
				SetPVarInt(playerid, "mp_id", id_mp);

				cache_get_value_name(listitem, "nama", nama_penjual);
				SetPVarString(playerid, "mp_nama_penjual", nama_penjual);

				cache_delete(PlayerInfo[playerid][tempCache]);
				PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

				new nama_item[50];
				getNamaByIdItem(id_item, nama_item);
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan membeli item dari markeplace, dengan spesifikasi :\n\n\
					Nama Item \t: %s%s\n\
					"WHITE"Jumlah \t: "ORANGE"%d\n\
					"WHITE"Harga \t\t: "GREEN"$%d\n\
					"WHITE"Nama Penjual \t: %s\n\n\
					Apakah anda yakin ingin membelinya ?", 
					GetColorRarity(getRarityByIdItem(id_item)),
					nama_item,
					jumlah,
					harga,
					nama_penjual);
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_ITEM_MARKETPLACE, DIALOG_STYLE_MSGBOX, "Konfirmasi beli item", pDialog[playerid], "Ok", "Keluar");
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_ITEM_MARKETPLACE:
		{
			if(response){
				if(!CekJikaInventoryPlayerMuat(playerid, GetPVarInt(playerid, "mp_id_item"), GetPVarInt(playerid, "mp_jumlah"))){
					dialogInventoryItemTidakMuat(playerid, GetPVarInt(playerid, "mp_jumlah"), GetSlotInventoryPlayer(playerid), GetPVarInt(playerid, "mp_id_item"));

					DeletePVar(playerid, "mp_id_item");
					DeletePVar(playerid, "mp_id_penjual");
					DeletePVar(playerid, "mp_id");
					DeletePVar(playerid, "mp_jumlah");
					DeletePVar(playerid, "mp_harga");
					DeletePVar(playerid, "mp_nama_penjual");
					return 1;
				}

				new keterangan[50],
					nama_item[50];
				getNamaByIdItem(GetPVarInt(playerid, "mp_id_item"), nama_item);
				format(keterangan, 50, "Beli %s sebanyak %d dari marketplace", nama_item, GetPVarInt(playerid, "mp_jumlah"));
				dialogMetodeBayar(playerid, GetPVarInt(playerid, "mp_harga"), "selesaiMembeliItemMarketplace", keterangan, 0); // Jangan langsung potong
			}
			return 1;
		}
		case DIALOG_JUAL_ITEM_MARKETPLACE:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					showDialogListItem(playerid, .dialogid = DIALOG_JUAL_ITEM_MARKETPLACE);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);					
						showDialogListItem(playerid, .dialogid = DIALOG_JUAL_ITEM_MARKETPLACE);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						showDialogListItem(playerid, .dialogid = DIALOG_JUAL_ITEM_MARKETPLACE);
					}
					return 1;
				}

				SetPVarInt(playerid, "inv_indexlist", listitem);
				new 
					id_item = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")],
					nama_item[50]
				;

				getNamaByIdItem(id_item, nama_item);

				if(GetStatusKunciItemPlayer(playerid, id_item)){
					resetPVarInventory(playerid);

					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, ORANGE"Item tidak dapat dibuang", WHITE"Item ini "RED"dikunci.\n\n"YELLOW"Note : Item yang dikunci tidak dapat dibuang/dijual/diberi kepada orang lain.\nJika tetap ingin melakukan hal tersebut silahkan buka item terlebih dahulu.", "Ok", "");
					return 1;
				}

				format(pDialog[playerid], sizePDialog, WHITE"Silahkan masukan jumlah item yang ingin dijual.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item : "GREEN"%d", nama_item, GetJumlahItemPlayer(playerid, id_item));
				strcat(pDialog[playerid], YELLOW"\n\nPastikan anda memasukan jumlah yang benar.");
				ShowPlayerDialog(playerid, DIALOG_JUAL_ITEM_MARKETPLACE_JUMLAH, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dijual", pDialog[playerid], "Jual", "Batal");
			}
			return 1;
		}
		case DIALOG_JUAL_ITEM_MARKETPLACE_JUMLAH:
		{
			if(response)
			{
				new jumlah, 
					nama_item[50], 
					input_jumlah, 
					item_id = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")];

				jumlah = GetJumlahItemPlayer(playerid, item_id);
				getNamaByIdItem(item_id, nama_item);

				if(sscanf(inputtext, "i", input_jumlah)) {
					format(pDialog[playerid], sizePDialog, RED"Masukan jumlah yang benar.\n"WHITE"Silahkan masukan jumlah item yang ingin dijual.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item : "GREEN"%d", nama_item, jumlah);
					strcat(pDialog[playerid], YELLOW"\n\nPastikan anda memasukan jumlah yang benar.");
					return ShowPlayerDialog(playerid, DIALOG_JUAL_ITEM_MARKETPLACE_JUMLAH, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dijual", pDialog[playerid], "Jual", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > jumlah){
					format(pDialog[playerid], sizePDialog, RED"Jumlah yang dimasukan tidak valid.\n"WHITE"Silahkan masukan jumlah item yang ingin dijual.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Item : "GREEN"%d", nama_item, jumlah);
					strcat(pDialog[playerid], YELLOW"\n\nPastikan anda memasukan jumlah yang benar.");
					return ShowPlayerDialog(playerid, DIALOG_JUAL_ITEM_MARKETPLACE_JUMLAH, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin dijual", pDialog[playerid], "Jual", "Batal");
				}
				SetPVarInt(playerid, "mp_banyak_dijual", input_jumlah);

				format(pDialog[playerid], sizePDialog, WHITE"Silahkan masukan harga jual.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Dijual : "GREEN"%d\n\n"YELLOW"Note: Harga yang dimasukan adalah harga total (bukan harga satuan).", nama_item, GetPVarInt(playerid, "mp_banyak_dijual"));
				return ShowPlayerDialog(playerid, DIALOG_JUAL_ITEM_MARKETPLACE_HARGA, DIALOG_STYLE_INPUT, ORANGE"Masukan harga jual", pDialog[playerid], "Jual", "Batal");
			}
			return 1;
		}
		case DIALOG_JUAL_ITEM_MARKETPLACE_HARGA:
		{
			if(response){
				new 
					nama_item[50], 
					input_harga, 
					item_id = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")];

				getNamaByIdItem(item_id, nama_item);

				if(sscanf(inputtext, "i", input_harga)) {
					format(pDialog[playerid], sizePDialog, RED"Masukan harga yang benar.\n"WHITE"Silahkan masukan harga jual.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Dijual : "GREEN"%d\n\n"YELLOW"Note: Harga yang dimasukan adalah harga total (bukan harga satuan).", nama_item, GetPVarInt(playerid, "mp_banyak_dijual"));
					return ShowPlayerDialog(playerid, DIALOG_JUAL_ITEM_MARKETPLACE_HARGA, DIALOG_STYLE_INPUT, ORANGE"Masukan harga jual", pDialog[playerid], "Jual", "Batal");
				}
				if(input_harga < 10 || input_harga > MAXIMAL_MONEY_TRADE){
					format(pDialog[playerid], sizePDialog, RED"Harga harus berkisar $10 hingga $%d.\n"WHITE"Silahkan masukan harga jual.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Dijual : "GREEN"%d\n\n"YELLOW"Note: Harga yang dimasukan adalah harga total (bukan harga satuan).", MAXIMAL_MONEY_TRADE, nama_item, GetPVarInt(playerid, "mp_banyak_dijual"));
					return ShowPlayerDialog(playerid, DIALOG_JUAL_ITEM_MARKETPLACE_HARGA, DIALOG_STYLE_INPUT, ORANGE"Masukan harga jual", pDialog[playerid], "Jual", "Batal");
				}

				SetPVarInt(playerid, "mp_harga_jual", input_harga);

				format(pDialog[playerid], sizePDialog, WHITE"Anda akan menjual.\n\nNama Item : "PINK"%s\n"WHITE"Jumlah Dijual : "GREEN"%d\n"WHITE"Harga \t: "GREEN"$%d\n\n"YELLOW"Apakah anda yakin ingin menjualnya?\nJika barang laku maka, anda akan dikenakan pajak sebesar %d persen.", nama_item, GetPVarInt(playerid, "mp_banyak_dijual"), input_harga, PAJAK_MARKETPLACE);
				return ShowPlayerDialog(playerid, DIALOG_JUAL_ITEM_MARKETPLACE_KONFIRMASI, DIALOG_STYLE_MSGBOX, ORANGE"Konfirmasi Penjualan", pDialog[playerid], "Jual", "Batal");
			}
			return 1;
		}
		case DIALOG_JUAL_ITEM_MARKETPLACE_KONFIRMASI:
		{
			if(response){
				new	item_id = TempPlayerDialog[playerid][GetPVarInt(playerid, "inv_indexlist")],
					jumlah = GetPVarInt(playerid, "mp_banyak_dijual");

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO marketplace(id_item, id_user, jumlah, harga, tanggal) VALUES(%d, %d, %d, %d, NOW())", item_id, PlayerInfo[playerid][pID], jumlah, GetPVarInt(playerid, "mp_harga_jual"));

				if(mysql_tquery(koneksi, pQuery[playerid])){
					new nama_item[50];
					getNamaByIdItem(item_id, nama_item);

					tambahItemPlayer(playerid, item_id, -jumlah);
					format(pDialog[playerid], sizePDialog, WHITE"Berhasil memasukan dagangan, dengan spesifikasi.\n\n\
						Nama Item : "PINK"%s\n\
						"WHITE"Jumlah Dijual : "GREEN"%d\n\
						"WHITE"Harga \t: "GREEN"$%d\n\n\
						"YELLOW"Note: Jika barang laku maka, anda akan dikenakan pajak sebesar %d persen.", nama_item, 
						jumlah, 
						GetPVarInt(playerid, "mp_harga_jual"), 
						PAJAK_MARKETPLACE);
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Dagangan Marketplace", pDialog[playerid], "Ok", "");
				}
			}
			return 1;
		}
		case DIALOG_PILIH_DAGANGAN_MARKETPLACE:
		{
			if(response){
				new mp_id,
					status,
					harga,
					jumlah,
					id_item,
					nama_item[50];

				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name_int(listitem, "id", mp_id);
				cache_get_value_name_int(listitem, "id_item", id_item);
				cache_get_value_name_int(listitem, "harga", harga);
				cache_get_value_name_int(listitem, "jumlah", jumlah);
				cache_get_value_name_int(listitem, "status", status);

				cache_delete(PlayerInfo[playerid][tempCache]);
				PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

				SetPVarInt(playerid, "mpg_id", mp_id);
				SetPVarInt(playerid, "mpg_id_item", id_item);
				SetPVarInt(playerid, "mpg_harga", harga);
				SetPVarInt(playerid, "mpg_jumlah", jumlah);

				getNamaByIdItem(id_item, nama_item);

				if(status == 0){
					format(pDialog[playerid], sizePDialog, WHITE"Anda akan menarik dagangan anda, dengan spesifikasi.\n\
						Nama Item \t: %s\n\
						Jumlah \t: "YELLOW"%d\n\
						"WHITE"Harga \t\t: "GREEN"$%d\n\n\
						"YELLOW"Apakah anda yakin ingin menarik dagangan anda ?", 
						nama_item, jumlah, harga);
					ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_PENARIKAN_DAGANGAN, DIALOG_STYLE_MSGBOX, "Konfirmasi penarikan dagangan", pDialog[playerid], "Tarik", "Batal");
				}else{
					format(pDialog[playerid], sizePDialog, WHITE"Anda akan mengambil hasil dagangan anda, dengan spesifikasi.\n\
						Nama Item \t: %s\n\
						Jumlah \t: "YELLOW"%d\n\
						"WHITE"Harga \t\t: "ORANGE"$%d "WHITE"-> "GREEN"$%d\n\n\
						"YELLOW"Apakah anda yakin ingin mengambil hasil dagangan anda ?\n\n\
						Note: Harga yang tertera adalah harga setelah kena pajak sebesar %d persen.", 
						nama_item, jumlah, harga, harga - floatround(float(harga) * (float(PAJAK_MARKETPLACE) / 100.0), floatround_floor), PAJAK_MARKETPLACE);
					ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_HASIL_DAGANGAN, DIALOG_STYLE_MSGBOX, "Konfirmasi pengambilan hasil dagangan", pDialog[playerid], "Ambil", "Batal");
				}
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_PENARIKAN_DAGANGAN:
		{
			if(response){
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM marketplace WHERE id = %d AND id_user = %d AND status = 0", GetPVarInt(playerid, "mpg_id"), PlayerInfo[playerid][pID]);
				mysql_tquery(koneksi, pQuery[playerid], "selesaiPenarikanDagangan", "i", playerid);
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_HASIL_DAGANGAN:
		{
			if(response){
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM marketplace WHERE id = %d", GetPVarInt(playerid, "mpg_id"), PlayerInfo[playerid][pID]);
				mysql_tquery(koneksi, pQuery[playerid]);

				new const harga = GetPVarInt(playerid, "mpg_harga");
				new const harga_final = harga - floatround(float(harga) * (float(PAJAK_MARKETPLACE) / 100.0), floatround_floor);
				
				givePlayerUang(playerid, harga_final);

				format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil mengambil hasil dagangan anda.\n\
					Uang hasil dagangan telah diberikan secara cash,\n\
					Uang yang didapat telah dipotong oleh pajak sebesar %d persen.\n\nHasil dagangan sebelum terkena pajak "ORANGE"$%d "WHITE"dan setelah dikenakan menjadi "GREEN"$%d", PAJAK_MARKETPLACE, GetPVarInt(playerid, "mpg_harga"), harga_final);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Berhasil mengambil hasil dagangan", pDialog[playerid], "Tutup", "");
			}
			return 1;
		}
		case DIALOG_PILIH_SKILL_BLACKSMITH:
		{
			if(response){
				/**
					@IMPORTANT :
						PASTIKAN UNTUK SELALU MENAMBAHKAN PADA BAGIAN 
							``` RESPONSE DIALOG_KONFIRMASI_BUAT_ITEM ```
						SETIAP MENAMBAH ITEM BARU PADA BLACKSMITH
				 */
				switch(listitem){
					case 0: // Craft joran pancing
					{
						SetPVarInt(playerid, "bs_buat_id_item", ID_JORAN_PANCING); 
						SetPVarInt(playerid, "bs_buat_needed_level", 1); // Level skill yang dibutuhkan untuk membuka 
						dialogKonfirmasiBuatItemBs(playerid, bahan_joran_pancing);
					}
					case 1: // Craft tombak ikan
					{
						SetPVarInt(playerid, "bs_buat_id_item", ID_TOMBAK_IKAN); 
						SetPVarInt(playerid, "bs_buat_needed_level", 1); // Level skill yang dibutuhkan untuk membuka 
						dialogKonfirmasiBuatItemBs(playerid, bahan_tombak_ikan);
					}
				}
			}else
				cmd_skill(playerid, "");
			return 1;
		}
		case DIALOG_BELI_ALAT_BLACKSMITH:
		{
			if(response){
				SetPVarInt(playerid, "bAlat_index", listitem);
				ShowPlayerDialog(playerid, DIALOG_JUMLAH_BELI_ALAT_BLACKSMITH, DIALOG_STYLE_INPUT, "Jumlah dibeli", WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_JUMLAH_BELI_ALAT_BLACKSMITH:
		{
			if(response){
				new banyak_barang;
				if(sscanf(inputtext, "i", banyak_barang)) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_BELI_ALAT_BLACKSMITH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Jumlah tidak valid\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");

				if(banyak_barang < 1 || banyak_barang > 1000) return ShowPlayerDialog(playerid, 				
				DIALOG_JUMLAH_BELI_ALAT_BLACKSMITH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Jumlah harus berkisar antara 1 hingga 1000.\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");

				new idx = GetPVarInt(playerid, "bAlat_index");

				if(!CekJikaInventoryPlayerMuat(playerid, MENU_ALAT_BLACKSMITH[idx][idItemAlat], banyak_barang)){
					return ShowPlayerDialog(playerid, 				
				DIALOG_JUMLAH_BELI_ALAT_BLACKSMITH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Inventory anda tidak muat untuk menampung item sebanyak itu.\nCek inventory terlebih dahulu.\n\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");
				}

				new nama_alat[50];
				getNamaByIdItem(MENU_ALAT_BLACKSMITH[idx][idItemAlat], nama_alat);
				
				SetPVarInt(playerid, "bAlat_jumlah", banyak_barang);
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan membeli "YELLOW"%s "WHITE"sebanyak "YELLOW"%d \n"WHITE"dengan total harga "GREEN"%d"WHITE".\nApakah anda yakin?", nama_alat, banyak_barang, MENU_ALAT_BLACKSMITH[idx][hargaAlat] * banyak_barang);
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_ALAT_BLACKSMITH, DIALOG_STYLE_MSGBOX, "Konfirmasi pembelian", pDialog[playerid], "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_ALAT_BLACKSMITH:
		{
			if(response){
				new keterangan[50];
				new idx = GetPVarInt(playerid, "bAlat_index"),
					nama_alat[50];
				getNamaByIdItem(MENU_ALAT_BLACKSMITH[idx][idItemAlat], nama_alat);
				format(keterangan, 50, "beli %s sebanyak %dx", nama_alat, GetPVarInt(playerid, "bAlat_jumlah"));
				dialogMetodeBayar(playerid, MENU_ALAT_BLACKSMITH[idx][hargaAlat] * GetPVarInt(playerid, "bAlat_jumlah"), "selesaiBayarAlatBlacksmith", keterangan);
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_BUAT_ITEM:
		{
			if(response){		
				new ret = 0;
				/**
					@IMPORTANT :
						PASTIKAN UNTUK SELALU MENAMBAHKAN PADA BAGIAN INI 
						SETIAP MENAMBAH ITEM BARU PADA BLACKSMITH
				 */
				if(!CekJikaInventoryPlayerMuat(playerid, GetPVarInt(playerid, "bs_buat_id_item"), 1)){
					new nama_item[50];
					getNamaByIdItem(GetPVarInt(playerid, "bs_buat_id_item"), nama_item);

					format(pDialog[playerid], sizePDialog, WHITE"Inventory anda tidak muat untuk menyimpan.\nSisihkan terlebih dahulu slot untuk item %s yang akan dibuat.", nama_item);
					return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Slot inventory tidak muat", pDialog[playerid], "Ok", "");
				}
				
				switch(GetPVarInt(playerid, "bs_buat_id_item")){
					case ID_JORAN_PANCING:
					{
						ret = IsItemPlayerCukup_Massive(playerid, bahan_joran_pancing);
						if(ret){
							for(new i=0;i<sizeof(bahan_joran_pancing);i++)
								tambahItemPlayer(playerid, bahan_joran_pancing[i][0], -bahan_joran_pancing[i][1]);
						}
					}
					case ID_TOMBAK_IKAN:
					{
						ret = IsItemPlayerCukup_Massive(playerid, bahan_tombak_ikan);
						if(ret){
							for(new i=0;i<sizeof(bahan_tombak_ikan);i++)
								tambahItemPlayer(playerid, bahan_tombak_ikan[i][0], -bahan_tombak_ikan[i][1]);
						}
					}
					default:
						return 1;
				}

				if(!ret)
					return showDialogPesan(playerid, RED"Maaf item tidak cukup", WHITE"Item yang anda butuhkan untuk membuat item, tidak cukup.\nSilahkan kumpulkan item terlebih dahulu untuk dapat melanjutkan.");

				// Pinjam timer perbaiki
				if(PerbaikiTimer[playerid] != -1)
					DeletePreciseTimer(PerbaikiTimer[playerid]);
				PerbaikiTimer[playerid] = SetPreciseTimer("progressBuatItemBlacksmith", 1000, true, "i", playerid);

				// Pinjam progress bar dari potong pohon
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
				ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
				TogglePlayerControllable(playerid, 0);
				GameTextForPlayer(playerid, "~w~Sedang ~y~membuat...", 3000, 3);
				PlayerCraftingMedicine(playerid);
				PlayerInfo[playerid][isOnAnimation] = true;	
				PlayerInfo[playerid][isBusy] = true;					
			}
			return 1;
		}
		case DIALOG_PILIH_MASAK_TAMBANG:
		{
			if(response){				
				/**
					@IMPORTANT :
					PADA SETIAP PENAMBAHAN MASAK ITEM
					TAMBAHKAN JUGA PADA BAGIAN INI
				*/
				switch(listitem){
					case 0: // Besi
					{
						SetPVarInt(playerid, "masak_buat_id_item", ID_BESI);
						dialogKonfirmasiMasakItem(playerid, bahan_besi_utuh);
					}
					case 1: // Emas
					{
						SetPVarInt(playerid, "masak_buat_id_item", ID_EMAS);
						dialogKonfirmasiMasakItem(playerid, bahan_emas_utuh);
					}
					case 2: // Aluminium
					{
						SetPVarInt(playerid, "masak_buat_id_item", ID_ALUMINIUM);
						dialogKonfirmasiMasakItem(playerid, bahan_aluminium_utuh);
					}
					case 3: // Perak
					{
						SetPVarInt(playerid, "masak_buat_id_item", ID_PERAK);
						dialogKonfirmasiMasakItem(playerid, bahan_perak_utuh);
					}
					case 4: // Berlian
					{
						SetPVarInt(playerid, "masak_buat_id_item", ID_BERLIAN);
						dialogKonfirmasiMasakItem(playerid, bahan_berlian_utuh);
					}
				}
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_MASAK_ITEM_TAMBANG:
		{
			if(response){
				new ret = 0;
				/**
					@IMPORTANT :
					PADA SETIAP PENAMBAHAN MASAK ITEM
					TAMBAHKAN JUGA PADA BAGIAN INI
				*/
				if(!CekJikaInventoryPlayerMuat(playerid, GetPVarInt(playerid, "masak_buat_id_item"), 1)){
					new nama_item[50];
					getNamaByIdItem(GetPVarInt(playerid, "masak_buat_id_item"), nama_item);

					format(pDialog[playerid], sizePDialog, WHITE"Inventory anda tidak muat untuk menyimpan.\nSisihkan terlebih dahulu slot untuk item %s yang akan dibuat.", nama_item);
					return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Slot inventory tidak muat", pDialog[playerid], "Ok", "");
				}

				switch(GetPVarInt(playerid, "masak_buat_id_item")){
					case ID_BESI:
					{
						ret = IsItemPlayerCukup_Massive(playerid, bahan_besi_utuh);
						if(ret){
							for(new i=0;i<sizeof(bahan_besi_utuh);i++)
								tambahItemPlayer(playerid, bahan_besi_utuh[i][0], -bahan_besi_utuh[i][1]);
						}
					}
					case ID_EMAS:
					{
						ret = IsItemPlayerCukup_Massive(playerid, bahan_emas_utuh);
						if(ret){
							for(new i=0;i<sizeof(bahan_emas_utuh);i++)
								tambahItemPlayer(playerid, bahan_emas_utuh[i][0], -bahan_emas_utuh[i][1]);
						}
					}
					case ID_ALUMINIUM:
					{
						ret = IsItemPlayerCukup_Massive(playerid, bahan_aluminium_utuh);
						if(ret){
							for(new i=0;i<sizeof(bahan_aluminium_utuh);i++)
								tambahItemPlayer(playerid, bahan_aluminium_utuh[i][0], -bahan_aluminium_utuh[i][1]);
						}
					}
					case ID_PERAK:
					{
						ret = IsItemPlayerCukup_Massive(playerid, bahan_perak_utuh);
						if(ret){
							for(new i=0;i<sizeof(bahan_perak_utuh);i++)
								tambahItemPlayer(playerid, bahan_perak_utuh[i][0], -bahan_perak_utuh[i][1]);
						}
					}
					case ID_BERLIAN:
					{
						ret = IsItemPlayerCukup_Massive(playerid, bahan_berlian_utuh);
						if(ret){
							for(new i=0;i<sizeof(bahan_berlian_utuh);i++)
								tambahItemPlayer(playerid, bahan_berlian_utuh[i][0], -bahan_berlian_utuh[i][1]);
						}
					}
					default:
						return 1;
				}

				if(!ret)
					return showDialogPesan(playerid, RED"Maaf item tidak cukup", WHITE"Item yang anda butuhkan untuk membuat item, tidak cukup.\nSilahkan kumpulkan item terlebih dahulu untuk dapat melanjutkan.");

				// Pinjam timer perbaiki
				if(PerbaikiTimer[playerid] != -1)
					DeletePreciseTimer(PerbaikiTimer[playerid]);
				PerbaikiTimer[playerid] = SetPreciseTimer("progressBuatItemMasak", 1000, true, "i", playerid);

				// Pinjam progress bar dari potong pohon
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
				ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
				TogglePlayerControllable(playerid, 0);
				GameTextForPlayer(playerid, "~w~Sedang ~y~membuat...", 3000, 3);
				PlayerCraftingMedicine(playerid);
				PlayerInfo[playerid][isOnAnimation] = true;	
				PlayerInfo[playerid][isBusy] = true;
			}
			return 1;
		}
		case DIALOG_PANGGIL_DARURAT:
		{
			if(response){
				switch(listitem){
					// Medis
					case 0:
					{
						if(!PlayerInfo[playerid][inDie])
							return error_command(playerid, "Anda tidak sedang sekarat.");

						new pesan[144];
						format(pesan, sizeof(pesan), TAG_MEDIC" "WHITE"%s(%d) sedang sekarat dan membutuhkan bantuan. Ketik /showpatientlocation %d untuk menandai marker.", PlayerInfo[playerid][pPlayerName], playerid);
						new online_medic = SendMessageToDutyMedic(COLOR_RED, pesan);

						if(!online_medic)
							return SendClientMessage(playerid, COLOR_RED, TAG_MEDIC" "WHITE"Tidak ada medis yang sedang bertugas saat ini.");

						SendClientMessage(playerid, COLOR_MEDIC, TAG_MEDIC" "WHITE"Berhasil mengirim pesan ke medis, tunggu beberapa saat..");
					}
					// Polisi
					case 1:
					{
						if(PlayerInfo[playerid][inDie])
							return error_command(playerid, "Anda sedang sekarat dan perlu bantuan medis.");

						new pesan[144];
						format(pesan, sizeof(pesan), TAG_POLICE" "WHITE"%s(%d) sedang membutuhkan bantuan. Ketik /showvictimlocation %d untuk menandai marker.", PlayerInfo[playerid][pPlayerName], playerid);
						new online_polisi = SendMessageToDutyPolice(COLOR_RED, pesan);

						if(!online_polisi)
							return SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Tidak ada polisi yang sedang bertugas saat ini.");

						PlayerInfo[playerid][inHelp] = 1;
						SendClientMessage(playerid, COLOR_MEDIC, TAG_POLICE" "WHITE"Berhasil mengirim pesan ke polisi, tunggu beberapa saat..");
					}
				}
			}
			return 1;
		}
		case DIALOG_ADMIN_RENT:
		{
			if(response){
				switch(listitem){
					// Vehicle
					case 0:
					{
						ShowPlayerDialog(playerid, DIALOG_ADMIN_RENT_VEHICLE, DIALOG_STYLE_LIST, "Vehicle Rent System :", "Buat Rent Place\nHapus Rent Place\nSewa Gratis\nBuat Vehicle\nEdit Vehicle", "Pilih", "Batal");
					}
				}
			}
			return 1;
		}
		case DIALOG_ADMIN_RENT_VEHICLE:
		{
			if(response){
				switch(listitem){
					// Buat Rent Place
					case 0:
					{
						new Float: x, Float: y, Float: z;
						GetPlayerPos(playerid, x, y, z);
						inline responseQuery(){
							new id = cache_insert_id(),
								free = Iter_Free(RentPlaceIterator),
								closest = ClosestRentVehPlace(playerid);
							if(closest != -1) return error_command(playerid, "Tidak dapat membuat di sekitar penyewaan kendaraan.");
							new create = createRentVehPlace(id, free, 0, x, y, z);
							if(create){
								SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Anda telah berhasil membuat tempat penyewaan kendaraan.");
							}else{
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `vehicle_rent_place` WHERE `id` = '%d'", id);
								mysql_tquery(koneksi, pQuery[playerid]);
								error_command(playerid, "Tidak dapat membuat penyewaan kendaraan lagi.");
							}
						}
						MySQL_TQueryInline(koneksi, using inline responseQuery, "INSERT INTO `vehicle_rent_place` (pos_x, pos_y, pos_z) VALUES ('%f', '%f', '%f')", x, y, z);
					
					}
					// Hapus Rent Place
					case 1:
					{
						new placeid = ClosestRentVehPlace(playerid);
						if(placeid != -1){
							foreach(new i : RentVehIterator){
								if(Iter_Contains(RentVehIterator, i)){
									if(RentVeh[i][rentVehPlaceID] == placeid){
										error_command(playerid, "Tidak menghapus tempat penyewaan kendaraan ketika terdapat kendaraan sewa.");
										return 1;
									}
								}
							}
							foreach(new i : RentPlayerVehIter){
								if(Iter_Contains(RentPlayerVehIter, i)){
									if(RentPlayerVeh[i][rentPlayerVehPlaceID] == placeid){
										error_command(playerid, "Tidak menghapus tempat penyewaan kendaraan ketika terdapat kendaraan yang disewa.");
										return 1;
									}
								}
							}
							DestroyDynamicArea(RentPlace[placeid][rentPlaceID]);
							DestroyDynamic3DTextLabel(RentPlace[placeid][rentPlaceLabel]);
							RentPlaceID[RentPlace[placeid][rentPlaceID]] = -1;
							RentPlace[placeid][rentPlaceID] = -1;
							RentPlace[placeid][rentPlacePos][0] = 0;
							RentPlace[placeid][rentPlacePos][1] = 0;
							RentPlace[placeid][rentPlacePos][2] = 0;
							RentPlace[placeid][rentPlaceLabel] = Text3D:INVALID_3DTEXT_ID;
							Iter_Remove(RentPlaceIterator, placeid);
							
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `vehicle_rent_place` WHERE `id` = '%d'", placeid);
							mysql_tquery(koneksi, pQuery[playerid]);
							SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Anda berhasil menghapus penyewaan kendaraan.");
						}else{
							error_command(playerid, "Anda tidak berada di tempat penyewaan kendaraan.");
						}
					}
					// Gratis
					case 2:
					{
						new placeid = ClosestRentVehPlace(playerid);
						if(placeid != -1){
							if(RentPlace[placeid][rentPlaceFree] == 1){
								ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_PLACE_FREE, DIALOG_STYLE_LIST, "Vehicle Rent System :", "Ubah Gratis (On)\nUbah Semua Gratis", "Pilih", "Batal");
							}else{
								ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_PLACE_FREE, DIALOG_STYLE_LIST, "Vehicle Rent System :", "Ubah Gratis (Off)\nUbah Semua Gratis", "Pilih", "Batal");
							}
						}else{
							error_command(playerid, "Anda tidak berada di tempat penyewaan kendaraan.");
						}
					}
					// Buat Vehicle
					case 3:
					{
						showDialogBuatRentVeh(playerid);
					}
					// Edit Vehicle
					case 4:
					{
						if(RentVehEdit[playerid] == 0){
							ShowPlayerDialog(playerid, DIALOG_ADMIN_RENT_VEHICLE_EDIT, DIALOG_STYLE_LIST, "Vehicle Rent System :", "Simpan Vehicle\nHapus Vehicle\nRespawn Vehicle\nMode Edit (Off)", "Pilih", "Batal");
						}else{
							ShowPlayerDialog(playerid, DIALOG_ADMIN_RENT_VEHICLE_EDIT, DIALOG_STYLE_LIST, "Vehicle Rent System :", "Simpan Vehicle\nHapus Vehicle\nRespawn Vehicle\nMode Edit (On)", "Pilih", "Batal");
						}
					}
				}
			}
			return 1;
		}
		case DIALOG_ADMIN_RENT_VEHICLE_BUAT:
		{
			if(response){
				new placeid = ClosestRentVehPlace(playerid);
				if(placeid != -1){
					new Float: x, Float: y, Float: z, Float: a;
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, a);
					x += (3.0 * floatsin(-a, degrees));
					y += (3.0 * floatcos(-a, degrees));
					inline responseQuery(){
						new id = cache_insert_id(),
							create = createRentVeh(id, listitem, placeid, x, y, z, a);
						if(create){
							SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Anda telah berhasil membuat kendaraan sewa.");
						}else{
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `vehicle_rent` WHERE `id` = '%d'", id);
							mysql_tquery(koneksi, pQuery[playerid]);
							error_command(playerid, "Tidak dapat membuat vehicle rent lagi.");
						}
					}
					MySQL_TQueryInline(koneksi, using inline responseQuery, "INSERT INTO `vehicle_rent` (id_list, id_place, pos_x, pos_y, pos_z, pos_a) VALUES ('%d', '%d', '%f', '%f', '%f', '%f')", listitem, placeid, x, y, z, a);
				}else{
					error_command(playerid, "Anda tidak berada di tempat penyewaan kendaraan.");
				}
			}
			return 1;
		}
		case DIALOG_RENT_VEHICLE:
		{
			if(response){
				inline responseQueryRent(){
					new rows, denda;
					cache_get_row_count(rows);
					if(rows){
						showDialogPesan(playerid, RED"Anda telah memiliki kendaraan sewa", WHITE"Saat ini anda telah memiliki kendaraan sewa.\n"YELLOW"Anda dapat menyewa kembali jika anda tidak memiliki kendaraan sewa.");
						RemovePlayerFromVehicle(playerid);
					}else{
						inline responseQueryBlacklist(){
							cache_get_row_count(rows);
							if(rows){
								cache_get_value_name_int(0, "nominal", denda);
								format(pDialog[playerid], sizePDialog, WHITE"Saat ini anda telah masuk daftar blacklist.\n\
								Anda dapat menyewa kembali jika anda telah membayar denda ke Bank terdekat.\n\
								Silahkan melakukan pembayaran denda sebesar "GREEN"%d"WHITE".", denda);
								ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Anda telah masuk daftar blacklist", pDialog[playerid], "Ok", "");
								RemovePlayerFromVehicle(playerid);
							}else{
								new vehid = GetPlayerVehicleID(playerid);
								SetPVarInt(playerid, "id_vehicle_rent", vehid);
								ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_WAKTU, DIALOG_STYLE_LIST, "Pilih jenis waktu penyewaan :", "Jam\nHari", "Pilih", "Batal");
							}
						}
						MySQL_TQueryInline(koneksi, using inline responseQueryBlacklist, "SELECT * FROM `tagihan` WHERE id_user = '%d' AND status = '0' AND jenis = '%d'", PlayerInfo[playerid][pID], JENIS_TAGIHAN_DENDA_SEWA_KENDARAAN);
					}
				}
				MySQL_TQueryInline(koneksi, using inline responseQueryRent, "SELECT id_user FROM `vehicle_rent_player` WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
			}else{
				RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_RENT_VEHICLE_WAKTU:
		{
			if(response){
				switch(listitem){
					// Jam
					case 0:
					{
						new vehid = GetPVarInt(playerid, "id_vehicle_rent"),
							listid = RentVeh[RentVehID[vehid]][rentVehList];
						format(pDialog[playerid], sizePDialog, WHITE"Berapa lama durasi waktu penyewaan kendaraan yang anda inginkan?\n"YELLOW"Harga sewa 1 jam adalah "GREEN"$%d", HARGA_VEHICLE_RENT[listid][hargaModel]);
						ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_WAKTU_JAM, DIALOG_STYLE_INPUT, "Pilih durasi waktu penyewaan :", pDialog[playerid], "Lanjut", "Batal");
					}
					// Hari
					case 1:
					{
						new vehid = GetPVarInt(playerid, "id_vehicle_rent"),
							listid = RentVeh[RentVehID[vehid]][rentVehList];
						format(pDialog[playerid], sizePDialog, WHITE"Berapa lama durasi waktu penyewaan kendaraan yang anda inginkan?\n"YELLOW"Harga sewa 1 hari adalah "GREEN"$%d", HARGA_VEHICLE_RENT[listid][hargaModel]*24);
						ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_WAKTU_HARI, DIALOG_STYLE_INPUT, "Pilih durasi waktu penyewaan :", pDialog[playerid], "Lanjut", "Batal");
					}
				}
			}else{
				DeletePVar(playerid, "id_vehicle_rent");
				RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_RENT_VEHICLE_WAKTU_JAM:
		{
			if(response){
				new input_jam;
				if(sscanf(inputtext, "i", input_jam)) {
					format(pDialog[playerid], sizePDialog, RED"Masukan durasi jam yang benar.\n"WHITE"Silahkan masukan durasi jam.");
					return ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_WAKTU_JAM, DIALOG_STYLE_INPUT, ORANGE"Masukan durasi waktu penyewaan :", pDialog[playerid], "Lanjut", "Batal");
				}
				if(input_jam < 2 || input_jam > 23){
					format(pDialog[playerid], sizePDialog, RED"Durasi jam berkisar 3 hingga 23\n"WHITE"Silahkan masukan durasi jam.");
					return ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_WAKTU_JAM, DIALOG_STYLE_INPUT, ORANGE"Masukan durasi waktu penyewaan :", pDialog[playerid], "Lanjut", "Batal");
				}
				new vehid = GetPVarInt(playerid, "id_vehicle_rent"),
					listid = RentVeh[RentVehID[vehid]][rentVehList],
					placeid = RentVeh[RentVehID[vehid]][rentVehPlaceID],
					hargasewa = input_jam*HARGA_VEHICLE_RENT[listid][hargaModel];
				if(RentPlace[placeid][rentPlaceFree] == 1){
					hargasewa = 0;
				}
				SetPVarInt(playerid, "durasi_vehicle_rent", input_jam);
				SetPVarInt(playerid, "harga_vehicle_rent", hargasewa);
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan melakukan penyewaan kendaraan sebagai berikut.\n\
				No. Penyewaan Kendaraan : "GREEN"%d\n\
				"WHITE"Nama Kendaraan : "GREEN"%s\n\
				"WHITE"Lama Durasi : "GREEN"%d jam\n\
				"WHITE"Harga Sewa : "GREEN"$%d\n", placeid, HARGA_VEHICLE_RENT[listid][namaModel], input_jam, hargasewa);
				ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_KONFIRMASI, DIALOG_STYLE_MSGBOX, GREEN"Konfirmasi Penyewaan Kendaraan", pDialog[playerid], "Setuju", "Batal");
			}else{
				DeletePVar(playerid, "id_vehicle_rent");
				RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_RENT_VEHICLE_WAKTU_HARI:
		{
			if(response){
				new input_hari;
				if(sscanf(inputtext, "i", input_hari)) {
					format(pDialog[playerid], sizePDialog, RED"Masukan durasi hari yang benar.\n"WHITE"Silahkan masukan durasi hari.");
					return ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_WAKTU_HARI, DIALOG_STYLE_INPUT, ORANGE"Masukan durasi waktu penyewaan :", pDialog[playerid], "Lanjut", "Batal");
				}
				if(input_hari < 0 || input_hari > 3){
					format(pDialog[playerid], sizePDialog, RED"Durasi hari berkisar 1 hingga 3\n"WHITE"Silahkan masukan durasi hari.");
					return ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_WAKTU_HARI, DIALOG_STYLE_INPUT, ORANGE"Masukan durasi waktu penyewaan :", pDialog[playerid], "Lanjut", "Batal");
				}
				new vehid = GetPVarInt(playerid, "id_vehicle_rent"),
					listid = RentVeh[RentVehID[vehid]][rentVehList],
					placeid = RentVeh[RentVehID[vehid]][rentVehPlaceID],
					hargajam = input_hari*24,
					hargasewa = hargajam*HARGA_VEHICLE_RENT[listid][hargaModel];
				if(RentPlace[placeid][rentPlaceFree] == 1){
					if(input_hari > 1){
						format(pDialog[playerid], sizePDialog, RED"Durasi hari di batasi hingga 1\n"WHITE"Silahkan masukan durasi hari.");
						return ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_WAKTU_HARI, DIALOG_STYLE_INPUT, ORANGE"Masukan durasi waktu penyewaan :", pDialog[playerid], "Lanjut", "Batal");
					}
					hargasewa = 0;
				}
				SetPVarInt(playerid, "durasi_vehicle_rent", hargajam);
				SetPVarInt(playerid, "harga_vehicle_rent", hargasewa);
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan melakukan penyewaan kendaraan sebagai berikut.\n\
				No. Penyewaan Kendaraan : "GREEN"%d\n\
				"WHITE"Nama Kendaraan : "GREEN"%s\n\
				"WHITE"Lama Durasi : "GREEN"%d hari\n\
				"WHITE"Harga Sewa : "GREEN"$%d\n", RentPlaceID[placeid], HARGA_VEHICLE_RENT[listid][namaModel], input_hari, hargasewa);
				ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE_KONFIRMASI, DIALOG_STYLE_MSGBOX, GREEN"Konfirmasi Penyewaan Kendaraan", pDialog[playerid], "Setuju", "Batal");
			}else{
				DeletePVar(playerid, "id_vehicle_rent");
				RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_RENT_VEHICLE_KONFIRMASI:
		{
			if(response){
				new vehid = GetPVarInt(playerid, "id_vehicle_rent"),
				listid = RentVeh[RentVehID[vehid]][rentVehList],
				placeid = RentVeh[RentVehID[vehid]][rentVehPlaceID],
				durasisewa = GetPVarInt(playerid, "durasi_vehicle_rent"),
				hargasewa = GetPVarInt(playerid, "harga_vehicle_rent"),
				hargatotal = durasisewa*hargasewa,
				durasitotal = gettime()+(durasisewa*3600);
				inline responseQuery(){
					new id = cache_insert_id();
					if(getUangPlayer(playerid) < hargatotal){
						DeletePVar(playerid, "id_vehicle_rent");
						DeletePVar(playerid, "durasi_vehicle_rent");
						DeletePVar(playerid, "harga_vehicle_rent");
						SendClientMessage(playerid, COLOR_RED, "Uang: "WHITE"Anda tidak memiliki cukup uang.");
						return 1;
					}
					new create = createRentPlayerVeh(playerid, id, PlayerInfo[playerid][pID], listid, placeid, RentPlace[placeid][rentPlacePos][0], RentPlace[placeid][rentPlacePos][1], RentPlace[placeid][rentPlacePos][2], 0, durasitotal);
					if(create){
						SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Anda telah berhasil melakukan penyewaan kendaraan.");
						SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Jika anda ingin membatalkan sewa, silahkan kembali ke sini dan ketik "GREEN"/cancelrentvehicle"WHITE".");
						RemovePlayerFromVehicle(playerid);
					}else{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `vehicle_rent_player` WHERE `id` = '%d'", id);
						mysql_tquery(koneksi, pQuery[playerid]);
						error_command(playerid, "Tidak dapat melakukan penyewaan kendaraan untuk saat ini.");
						RemovePlayerFromVehicle(playerid);
					}
				}
				MySQL_TQueryInline(koneksi, using inline responseQuery, "INSERT INTO `vehicle_rent_player` (id_user, id_list, id_place, pos_x, pos_y, pos_z, pos_a, expired) VALUES ('%d', '%d', '%d', '%f', '%f', '%f', '%f', '%d')", PlayerInfo[playerid][pID], listid, placeid, RentPlace[placeid][rentPlacePos][0], RentPlace[placeid][rentPlacePos][1], RentPlace[placeid][rentPlacePos][2], 0, durasitotal);
				
			}else{
				DeletePVar(playerid, "id_vehicle_rent");
				DeletePVar(playerid, "durasi_vehicle_rent");
				DeletePVar(playerid, "harga_vehicle_rent");
				RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_ADMIN_RENT_VEHICLE_EDIT:
		{
			if(response){
				switch(listitem){
					// Simpan Vehicle
					case 0:
					{
						if(!IsPlayerInAnyVehicle(playerid)) return showDialogPesan(playerid, RED"Anda harus di dalam kendaraan", WHITE"Anda harus didalam kendaraan yang ingin diedit.");
						new vehid = GetPlayerVehicleID(playerid);
						if(!Iter_Contains(RentVehIterator, RentVehID[vehid])) return showDialogPesan(playerid, RED"Kendaraan tidak valid", WHITE"Anda harus didalam kendaraan sewa.");
						new placeid = ClosestRentVehPlace(playerid);
						if(placeid != -1){
							if(placeid != RentVeh[RentVehID[vehid]][rentVehPlaceID]) return error_command(playerid, "Anda harus di sekitar penyewaan kendaraan.");
							respawnRentVeh(playerid, vehid, RentVehID[vehid]);
							SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Anda telah berhasil menyimpan kendaraan sewa.");
						}else{
							error_command(playerid, "Anda tidak berada di tempat penyewaan kendaraan.");
						}
					}
					// Hapus Vehicle
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_ADMIN_RENT_VEHICLE_HAPUS, DIALOG_STYLE_LIST, "Vehicle Rent System :", "Hapus Vehicle\nHapus Semua Vehicle", "Pilih", "Batal");
					}
					// Respawn Vehicle
					case 2:
					{
						foreach(new i : RentVehIterator){
							if(Iter_Contains(RentVehIterator, i)){
								SetVehicleToRespawn(RentVeh[i][rentVehID]);
							}
						}
						SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Semua kendaraan sewa telah di respawn.");
					}
					// Mode Edit
					case 3:
					{
						if(RentVehEdit[playerid] == 0){
							RentVehEdit[playerid] = 1;
							SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Mode edit kendaraan sewa aktif.");
						}else{
							RentVehEdit[playerid] = 0;
							SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Mode edit kendaraan sewa tidak aktif.");
						}
					}
				}
			}
			return 1;
		}
		case DIALOG_ADMIN_RENT_VEHICLE_HAPUS:
		{
			if(response){
				switch(listitem){
					// Hapus Vehicle
					case 0:
					{
						new vehid = GetPlayerVehicleID(playerid);
						if(!IsPlayerInAnyVehicle(playerid)) return showDialogPesan(playerid, RED"Anda harus di dalam kendaraan", WHITE"Anda harus didalam kendaraan yang ingin diedit.");
						if(!Iter_Contains(RentVehIterator, RentVehID[vehid])) return showDialogPesan(playerid, RED"Kendaraan tidak valid", WHITE"Anda harus didalam kendaraan sewa.");
						DestroyVehicle(vehid);
						RentVeh[RentVehID[vehid]][rentVehID] = -1;
						RentVeh[RentVehID[vehid]][rentVehList] = -1;
						RentVeh[RentVehID[vehid]][rentVehPlaceID] = -1;
						RentVeh[RentVehID[vehid]][rentVehModel] = 0;
						RentVeh[RentVehID[vehid]][rentVehPos][0] = 0;
						RentVeh[RentVehID[vehid]][rentVehPos][1] = 0;
						RentVeh[RentVehID[vehid]][rentVehPos][2] = 0;
						RentVeh[RentVehID[vehid]][rentVehPos][3] = 0;
						Iter_Remove(RentVehIterator, RentVehID[vehid]);
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `vehicle_rent` WHERE `id` = '%d'", RentVehID[vehid]);
						mysql_tquery(koneksi, pQuery[playerid]);
						sendPesan(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Anda berhasil menghapus kendaraan sewa (id:"YELLOW"%d"WHITE")!", RentVehID[vehid]);
						RentVehID[vehid] = -1;
					}
					// Hapus Semua Vehicle
					case 1:
					{
						new placeid = ClosestRentVehPlace(playerid);
						if(placeid != -1){							
							foreach(new i : RentVehIterator){
								if(Iter_Contains(RentVehIterator, i)){
									if(RentVeh[i][rentVehPlaceID] == placeid){
										mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM vehicle_rent WHERE id = '%d'", i);
										mysql_tquery(koneksi, pQuery[playerid]);

										new vehid = RentVeh[i][rentVehID];
										DestroyVehicle(vehid);
										RentVehID[vehid] = -1;
										RentVeh[i][rentVehID] = -1;
										RentVeh[i][rentVehList] = -1;
										RentVeh[i][rentVehPlaceID] = -1;
										RentVeh[i][rentVehModel] = 0;
										RentVeh[i][rentVehPos][0] = 0;
										RentVeh[i][rentVehPos][1] = 0;
										RentVeh[i][rentVehPos][2] = 0;
										RentVeh[i][rentVehPos][3] = 0;
										Iter_SafeRemove(RentVehIterator, i, i);
									}
								}
							}
							SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Anda berhasil menghapus semua kendaraan di penyewaan kendaraan.");
						}else{
							error_command(playerid, "Anda tidak berada di tempat penyewaan kendaraan.");
						}
					}
				}
			}
			return 1;
		}
		case DIALOG_RENT_VEHICLE_PLACE_FREE:
		{
			if(response){
				switch(listitem){
					// Ubah Gratis
					case 0:
					{
						new placeid = ClosestRentVehPlace(playerid);
						if(placeid != -1){
							SetPVarInt(playerid, "tipe_vehicle_rent_free", 0);
							SetPVarInt(playerid, "placeid_vehicle_rent", placeid);
							ShowPlayerDialog(playerid, DIALOG_RENT_PLACE_FREE_WAKTU, DIALOG_STYLE_LIST, "Pilih jenis waktu :", "Jam\nHari", "Pilih", "Batal");
						}else{
							error_command(playerid, "Anda tidak berada di tempat penyewaan kendaraan.");
						}
					}
					// Ubah Semua Gratis
					case 1:
					{
						SetPVarInt(playerid, "tipe_vehicle_rent_free", 1);
						ShowPlayerDialog(playerid, DIALOG_RENT_PLACE_FREE_WAKTU, DIALOG_STYLE_LIST, "Pilih jenis waktu :", "Jam\nHari", "Pilih", "Batal");
					}
				}
			}
			return 1;
		}
		case DIALOG_RENT_PLACE_FREE_WAKTU:
		{
			if(response){
				switch(listitem){
					// Jam
					case 0:
					{
						ShowPlayerDialog(playerid, DIALOG_RENT_PLACE_FREE_JAM, DIALOG_STYLE_INPUT, "Pilih durasi waktu penyewaan :", WHITE"Berapa lama durasi waktu penyewaan kendaraan yang anda inginkan?\nJika anda mengisi "GREEN"0"WHITE", maka anda menonaktifkan fitur gratis penyewaan kendaraan.", "Lanjut", "Batal");
					}
					// Hari
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_RENT_PLACE_FREE_HARI, DIALOG_STYLE_INPUT, "Pilih durasi waktu penyewaan :", WHITE"Berapa lama durasi waktu penyewaan kendaraan yang anda inginkan?\nJika anda mengisi "GREEN"0"WHITE", maka anda menonaktifkan fitur gratis penyewaan kendaraan.", "Lanjut", "Batal");
					}
				}
			}else{
				DeletePVar(playerid, "tipe_vehicle_rent_free");
				DeletePVar(playerid, "placeid_vehicle_rent");
			}
			return 1;
		}
		case DIALOG_RENT_PLACE_FREE_JAM:
		{
			if(response){
				new input_jam;
				if(sscanf(inputtext, "i", input_jam)) {
					format(pDialog[playerid], sizePDialog, RED"Masukan durasi jam yang benar.\n"WHITE"Silahkan masukan durasi jam.");
					return ShowPlayerDialog(playerid, DIALOG_RENT_PLACE_FREE_JAM, DIALOG_STYLE_INPUT, ORANGE"Masukan durasi waktu penyewaan :", pDialog[playerid], "Lanjut", "Batal");
				}
				if(input_jam < 0 || input_jam > 23){
					format(pDialog[playerid], sizePDialog, RED"Durasi jam berkisar 1 hingga 23\n"WHITE"Silahkan masukan durasi jam.");
					return ShowPlayerDialog(playerid, DIALOG_RENT_PLACE_FREE_JAM, DIALOG_STYLE_INPUT, ORANGE"Masukan durasi waktu penyewaan :", pDialog[playerid], "Lanjut", "Batal");
				}
				SetPVarInt(playerid, "tipewaktu_vehicle_rent_free", 0);
				SetPVarInt(playerid, "durasi_vehicle_free", input_jam);
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan mengatur penyewaan kendaraan menjadi gratis dengan lama durasi "GREEN"%d jam"WHITE".", input_jam);
				ShowPlayerDialog(playerid, DIALOG_RENT_PLACE_FREE_KONFRIM, DIALOG_STYLE_MSGBOX, GREEN"Konfirmasi Penyewaan Kendaraan", pDialog[playerid], "Setuju", "Batal");
			}else{
				DeletePVar(playerid, "tipe_vehicle_rent_free");
				DeletePVar(playerid, "placeid_vehicle_rent");
			}
			return 1;
		}
		case DIALOG_RENT_PLACE_FREE_HARI:
		{
			if(response){
				new input_hari;
				if(sscanf(inputtext, "i", input_hari)) {
					format(pDialog[playerid], sizePDialog, RED"Masukan durasi hari yang benar.\n"WHITE"Silahkan masukan durasi hari.");
					return ShowPlayerDialog(playerid, DIALOG_RENT_PLACE_FREE_HARI, DIALOG_STYLE_INPUT, ORANGE"Masukan durasi waktu penyewaan :", pDialog[playerid], "Lanjut", "Batal");
				}
				if(input_hari < 0 || input_hari > 28){
					format(pDialog[playerid], sizePDialog, RED"Durasi hari berkisar 1 hingga 28\n"WHITE"Silahkan masukan durasi hari.");
					return ShowPlayerDialog(playerid, DIALOG_RENT_PLACE_FREE_HARI, DIALOG_STYLE_INPUT, ORANGE"Masukan durasi waktu penyewaan :", pDialog[playerid], "Lanjut", "Batal");
				}
				new inputjam = input_hari*24;
				SetPVarInt(playerid, "tipewaktu_vehicle_rent_free", 1);
				SetPVarInt(playerid, "durasi_vehicle_free", inputjam);
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan mengatur penyewaan kendaraan menjadi gratis dengan lama durasi "GREEN"%d hari"WHITE".", input_hari);
				ShowPlayerDialog(playerid, DIALOG_RENT_PLACE_FREE_KONFRIM, DIALOG_STYLE_MSGBOX, GREEN"Konfirmasi Penyewaan Kendaraan", pDialog[playerid], "Setuju", "Batal");
			}else{
				DeletePVar(playerid, "tipe_vehicle_rent_free");
				DeletePVar(playerid, "placeid_vehicle_rent");
			}
			return 1;
		}
		case DIALOG_RENT_PLACE_FREE_KONFRIM:
		{
			if(response){
				new tipe_waktu = GetPVarInt(playerid, "tipewaktu_vehicle_rent_free"),
					tipe_free = GetPVarInt(playerid, "tipe_vehicle_rent_free"),
					time_durasi = GetPVarInt(playerid, "durasi_vehicle_free"),
					placeid = GetPVarInt(playerid, "placeid_vehicle_rent"),
					durasi_habis = gettime()+(time_durasi*3600);
				// input durasi 0 - kosong, disable
				if(time_durasi == 0){
					RentPlace[placeid][rentPlaceFree] = 0;
					RentPlace[placeid][rentPlaceFreeDurasi] = 0;
					// 1 tempat
					if(tipe_free == 0){
						sendPesan(playerid, COLOR_RED, GREEN"[KENDARAAN SEWA] "WHITE"Anda berhasil menonaktifkan sewa gratis di penyewaan kendaraan ("GREEN"ID:%d"WHITE").", placeid);
					// semua tempat
					}else{
						SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Anda berhasil menonaktifkan sewa gratis di semua penyewaan kendaraan.");
					}
				}else{
					// 1 tempat
					if(tipe_free == 0){
						// jam
						if(tipe_waktu == 0){
							sendPesan(playerid, COLOR_RED, GREEN"[KENDARAAN SEWA] "WHITE"Anda berhasil mengatur penyewaan kendaraan ("GREEN"ID:%d"WHITE") menjadi gratis selama %d jam.", placeid, time_durasi);
						// hari
						}else{
							sendPesan(playerid, COLOR_RED, GREEN"[KENDARAAN SEWA] "WHITE"Anda berhasil mengatur penyewaan kendaraan ("GREEN"ID:%d"WHITE") menjadi gratis selama %d hari.", placeid, time_durasi/24);
						}
						RentPlace[placeid][rentPlaceFree] = 1;
						RentPlace[placeid][rentPlaceFreeDurasi] = durasi_habis;
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE vehicle_rent_place SET durasi_gratis = %d WHERE id = %d", durasi_habis, placeid);
						mysql_tquery(koneksi, pQuery[playerid]);
						reloadRentVehPlaceLabel(placeid);
					// semua tempat
					}else{
						// jam
						if(tipe_waktu == 0){
							sendPesan(playerid, COLOR_RED, GREEN"[KENDARAAN SEWA] "WHITE"Anda berhasil mengatur semua penyewaan kendaraan menjadi gratis selama %d jam.", time_durasi);
						// hari
						}else{
							sendPesan(playerid, COLOR_RED, GREEN"[KENDARAAN SEWA] "WHITE"Anda berhasil mengatur semua penyewaan kendaraan menjadi gratis selama %d hari.", time_durasi/24);
						}
						foreach(new i : RentPlaceIterator){
							if(Iter_Contains(RentPlaceIterator, i)){
								RentPlace[i][rentPlaceFree] = 1;
								RentPlace[i][rentPlaceFreeDurasi] = durasi_habis;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE vehicle_rent_place SET durasi_gratis = %d WHERE id = %d", durasi_habis, i);
								mysql_tquery(koneksi, pQuery[playerid]);
								reloadRentVehPlaceLabel(i);
							}
						}
					}
				}
				DeletePVar(playerid, "durasi_vehicle_free");
				DeletePVar(playerid, "tipe_vehicle_rent_free");
				DeletePVar(playerid, "placeid_vehicle_rent");
				DeletePVar(playerid, "tipewaktu_vehicle_rent_free");
			}else{
				DeletePVar(playerid, "durasi_vehicle_free");
				DeletePVar(playerid, "tipe_vehicle_rent_free");
				DeletePVar(playerid, "placeid_vehicle_rent");
				DeletePVar(playerid, "tipewaktu_vehicle_rent_free");
			}
			return 1;
		}
		case DIALOG_TAMPIL_REPORT:
		{
			if(response){
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					showReportPlayer(playerid);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);					
						showReportPlayer(playerid);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						showReportPlayer(playerid);
					}
					return 1;
				}

				new nama_user[MAX_PLAYER_NAME + 1], 
					keterangan[244], 
					temp_tanggal[50];
				cache_set_active(PlayerInfo[playerid][tempCache]);
				cache_get_value_name(listitem, "nama", nama_user);
				cache_get_value_name(listitem, "text", keterangan);
				cache_get_value_name(listitem, "tanggal", temp_tanggal);

				cache_delete(PlayerInfo[playerid][tempCache]);
				PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

				format(
					pDialog[playerid], 
					sizePDialog, 
					WHITE"Nama pelapor : "GREEN"%s\n\
					"WHITE"Tanggal lapor : "GREEN"%s\n\
					"WHITE"Text : %s\n", 
					nama_user, 
					temp_tanggal, 
					keterangan
				);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Detail report", pDialog[playerid], "Ok", "");
			}
			return 1;
		}
		case DIALOG_HELP_MENU:
		{
			if(response){
				switch(listitem){
					// Umum
					case 0:
					{
						new str_guide[2000];
						SetPVarInt(playerid, "menu_help_page", 0);
						SetPVarString(playerid, "menu_help_name", "umum");
						format(str_guide, sizeof(str_guide), \
							YELLOW"/tutorial "WHITE"- Panduan bermain secara singkat\n"\
							YELLOW"/stats "WHITE"- Melihat informasi akun\n"\
							YELLOW"/inventory (/inv) "WHITE"- Melihat isi tas\n"\
							YELLOW"/settings "WHITE"- Pengaturan tampilan dan akun\n"\
							YELLOW"/clearchat "WHITE"- Menghapus histori chat\n"\
							YELLOW"/ask "WHITE"- Tanya kepada admin\n"\
							YELLOW"/report "WHITE"- Melaporkan pemain\n"\
							YELLOW"/houseinfo "WHITE"- Informasi dan akses pada rumah\n"\
							YELLOW"/house "WHITE"- Mengakses menu rumah\n"\
							YELLOW"/givemoney"WHITE"- Memberi uang kepada pemain lain\n"\
							YELLOW"/pm "WHITE"- Chat kepada pemain lain\n"\
							YELLOW"/r "WHITE"- Membalas chat dari pemain lain\n"\
							YELLOW"/vehicle "WHITE"- Perintah kendaraan\n"\
							YELLOW"/v "WHITE"- Perintah kendaraan\n"\
							YELLOW"/lock "WHITE"- Mengunci kendaraan\n"\
							YELLOW"/unlock "WHITE"- Membuka kunci kendaraan\n"\
							YELLOW"/cancelrentvehicle "WHITE"- Membatalkan sewa kendaraan\n"\
							YELLOW"/removehelmet "WHITE"- Melepas helm\n"\
							YELLOW"/removemask "WHITE"- Melepas topeng\n"\
							YELLOW"/anim "WHITE"- Daftar perintah animasi\n"\
							YELLOW"/stand "WHITE"- Animasi berdiri\n"\
							YELLOW"/sit "WHITE"- Animasi duduk\n"\
							YELLOW"/checkinventory "WHITE"- Memeriksa inventory pemain lain\n"\
							YELLOW"/ephone "WHITE"- Akses ponsel pribadi\n"\
							YELLOW"/call "WHITE"- Memanggil pemain atau organisasi\n"\
							YELLOW"/bc "WHITE"- Iklan teks\n"\
							YELLOW"/exit "WHITE"- Aksi untuk keluar bangunan\n"\
							YELLOW"/skill "WHITE"- Daftar kemampuan\n"\
							YELLOW"/suicide "WHITE"- Akhiri hidup");
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Perintah Bantuan (Umum):", str_guide, "Ok", "");
					}
					// Pekerjaan
					case 1:
					{
						new str_guide[2000];
						SetPVarInt(playerid, "menu_help", 0);
						SetPVarString(playerid, "menu_help_name", "kerja");
						format(str_guide, sizeof(str_guide), \
							YELLOW"/cook "WHITE"- Melakukan aksi masak\n"\
							YELLOW"/lumberjack "WHITE"- Menu perintah pemotong kayu\n"\
							YELLOW"/trashmaster "WHITE"- Menu perintah pengangkut sampah\n"\
							YELLOW"/pizzaboy "WHITE"- Menu perintah pengantar pizza\n"\
							YELLOW"/dig "WHITE"- Melakukan aksi gali\n"\
							YELLOW"/farm "WHITE"- Menu perintah menanam\n"\
							YELLOW"/fishing "WHITE"- Menu perintah memancing");
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Perintah Bantuan (Pekerjaan):", str_guide, "Ok", "");
					}
					// Admin
					case 2:
					{
						new str_guide[2000];
						SetPVarInt(playerid, "menu_help", 0);
						SetPVarString(playerid, "menu_help_name", "admin");
						format(str_guide, sizeof(str_guide), "");
						if(GetLevelAdminPlayer(playerid) >= 1){
							strcatEx(str_guide, sizeof(str_guide), \
							YELLOW"Level 1 :\n"\
							YELLOW"/kick "WHITE"- Mengeluarkan pemain\n"\
							YELLOW"/jetpack "WHITE"- Melakukan aksi jetpack\n"\
							YELLOW"/spawn "WHITE"- Menghidupkan kembali pemain\n"\
							YELLOW"/pindahpos "WHITE"- Berpindah sesuai kordinat\n"\
							YELLOW"/ach "WHITE"- Admin chat\n"\
							YELLOW"/slap "WHITE"- Menampar pemain\n"\
							YELLOW"/apapan "WHITE"- Menu perintah papan\n"\
							YELLOW"/alumber "WHITE"- Menu perintah lumber\n"\
							YELLOW"/aatm "WHITE"- Menu perintah atm\n"\
							YELLOW"/aactor "WHITE"- Menu perintah actor\n"\
							YELLOW"/unban "WHITE"- Membuka blokir pemain\n"\
							YELLOW"/ban "WHITE"- Memblokir pemain\n"\
							YELLOW"/setmedic "WHITE"- Mengangkat pemain menjadi medis\n"\
							YELLOW"/removemedic "WHITE"- Mencopot pemain dari medis\n"\
							YELLOW"/setpolice "WHITE"- Mengangkat pemain menjadi polisi\n"\
							YELLOW"/removepolice "WHITE"- Mencopot pemain dari polisi\n"\
							YELLOW"/tele "WHITE"- Berpindah ke lokasi pemain\n"\
							YELLOW"/showreport "WHITE"- Menampilkan daftar laporan\n"\
							YELLOW"/get "WHITE"- Memindahkan pemain ke lokasi sekarang\n"\
							YELLOW"/pma "WHITE"- Chat admin ke pemain\n");
						}
						if(GetLevelAdminPlayer(playerid) >= 2){
							strcatEx(str_guide, sizeof(str_guide), \
							YELLOW"Level 2 :\n"\
							YELLOW"/aveh "WHITE"- Menu perintah kendaraan\n"\
							YELLOW"/agiveitem "WHITE"- Beri pemain item\n"\
							YELLOW"/agivemoney "WHITE"- Beri pemain uang\n"\
							YELLOW"/arumah "WHITE"- Menu perintah rumah\n"\
							YELLOW"/arent "WHITE"- Menu perintah sewa\n"\
							YELLOW"/setadmin "WHITE"- Mengangkat pemain menjadi admin");
						}
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Perintah Bantuan (Admin):", str_guide, "Ok", "");
					}
					// Fraksi
					case 3:
					{
						new str_guide[2000];
						SetPVarInt(playerid, "menu_help", 0);
						SetPVarString(playerid, "menu_help_name", "fraksi");
						if(GetLevelAdminPlayer(playerid) >= 0 || IsPlayerOnDutyMedic(playerid)){
							format(str_guide, sizeof(str_guide), \
							YELLOW"/skill "WHITE"- Menu perintah kemampuan\n"\
							YELLOW"/showpatientlocation "WHITE"- Menampilkan lokasi pasien");
						}
						if(GetLevelAdminPlayer(playerid) >= 0 || IsPlayerOnDutyPolice(playerid)){
							format(str_guide, sizeof(str_guide), \
							YELLOW"/skill "WHITE"- Menu perintah kemampuan\n"\
							YELLOW"/showvictimlocation "WHITE"- Menampilkan lokasi peminta\n"\
							YELLOW"/open "WHITE"- Aksi untuk membuka sesuatu\n"\
							YELLOW"/close "WHITE"- Aksi untuk menutup sesuatu\n"\
							YELLOW"/jail "WHITE"- Memenjarakan pemain\n"\
							YELLOW"/removejail "WHITE"- Menghapus masa tahanan\n"\
							YELLOW"/destroy "WHITE"- Aksi untuk menghapus sesuatu\n"\
							YELLOW"/create "WHITE"- Aksi untuk membuat sesuatu\n"\
							YELLOW"/adjust "WHITE"- Aksi untuk mengubah sesuatu\n"\
							YELLOW"/cuff "WHITE"- Memborgol pemain\n"\
							YELLOW"/uncuff "WHITE"- Membuka borgol pemain\n"\
							YELLOW"/checksuspect "WHITE"- Mengecek masa tahanan\n");
						}
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Perintah Bantuan (Fraksi):", str_guide, "Ok", "");
					}
				}
			}
			return 1;
		}
		case DIALOG_PENJUAL_TAMBANG_LIST_JUAL:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);
				
				new nama_item[50],
					i = GetPVarInt(playerid, "index_terpilih");
				getNamaByIdItem(list_barang_tampung_tambang[i][brgId], nama_item);
				
				format(pDialog[playerid], sizePDialog, 
					WHITE"Anda akan menjual "PURPLE"%s "WHITE"dengan harga satuan "GREEN"$%d "WHITE"per %d item.\n\
					"WHITE"Berapa stack yang anda akan jual?\n\n\
					"YELLOW"Note: "WHITE"1 stack = %d item = "GREEN"$%d", 
					nama_item,
					list_barang_tampung_tambang[i][brgHarga] - floatround(float(list_barang_tampung_tambang[i][brgHarga]) * 0.1, floatround_floor),
					list_barang_tampung_tambang[i][brgJumlah],
					list_barang_tampung_tambang[i][brgJumlah],
					list_barang_tampung_tambang[i][brgHarga] - floatround(float(list_barang_tampung_tambang[i][brgHarga]) * 0.1, floatround_floor)
					);
				ShowPlayerDialog(playerid, DIALOG_PENJUAL_TAMBANG_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", pDialog[playerid], "Jual", "Batal");
			}
			return 1;
		}
		case DIALOG_PENJUAL_TAMBANG_LIST_JUAL_JUMLAH:
		{
			if(response){				
				new input_jumlah;
				new nama_item[50],
					i = GetPVarInt(playerid, "index_terpilih");
				getNamaByIdItem(list_barang_tampung_tambang[i][brgId], nama_item);
				
				if(sscanf(inputtext, "i", input_jumlah)) {
					new str_temp[500];
					format(str_temp, 500, 
						RED"Jumlah stack invalid.\n%s", 
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_TAMBANG_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > 100){
					new str_temp[500];
					format(str_temp, 500, 
						RED"Hanya dapat menjual 1 hingga 100 stack dalam sekali penjualan.\n%s", 
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_TAMBANG_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}	
				if(input_jumlah * list_barang_tampung_tambang[i][brgJumlah] > GetJumlahItemPlayer(playerid, list_barang_tampung_tambang[i][brgId])){
					new str_temp[500];
					format(str_temp, 500, 
						RED"Jumlah item anda tidak mencukupi, %d stack = %d item.\nJumlah saat ini %d.\n%s", 
						input_jumlah, 
						input_jumlah * list_barang_tampung_tambang[i][brgJumlah],
						GetJumlahItemPlayer(playerid, list_barang_tampung_tambang[i][brgId]),
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_TAMBANG_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}

				SetPVarInt(playerid, "jumlah_stack", input_jumlah);

				format(pDialog[playerid], sizePDialog, WHITE"Anda akan menjual %s dengan spesifikasi:\n\
					"WHITE"Jumlah stack\t\t: "YELLOW"%d\n\
					"WHITE"Jumlah per stack\t: "YELLOW"%d\n\
					"WHITE"Jumlah total\t\t: "YELLOW"%d\n\
					"WHITE"Harga jual per stack\t: "GREEN"$%d\n\
					"WHITE"Harga Jual Total\t: "GREEN"$%d\n\n\
					"WHITE"Apakah anda ingin menjual item ini?", 
					nama_item,
					input_jumlah,
					list_barang_tampung_tambang[i][brgJumlah],
					input_jumlah * list_barang_tampung_tambang[i][brgJumlah],
					list_barang_tampung_tambang[i][brgHarga] - floatround(float(list_barang_tampung_tambang[i][brgHarga]) * 0.1, floatround_floor),
					input_jumlah * (list_barang_tampung_tambang[i][brgHarga] - floatround(float(list_barang_tampung_tambang[i][brgHarga]) * 0.1, floatround_floor)));
				ShowPlayerDialog(playerid, DIALOG_PENJUAL_TAMBANG_LIST_JUAL_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi penjualan", pDialog[playerid], "Jual", "Batal");
			}
			return 1;
		}
		case DIALOG_PENJUAL_TAMBANG_LIST_JUAL_KONFIRMASI:
		{
			if(response){
				new i = GetPVarInt(playerid, "index_terpilih"),
					jumlah_stack = GetPVarInt(playerid, "jumlah_stack");
				new id_item = list_barang_tampung_tambang[i][brgId];
				givePlayerUang(playerid, jumlah_stack * (list_barang_tampung_tambang[i][brgHarga] - floatround(float(list_barang_tampung_tambang[i][brgHarga]) * 0.1, floatround_floor)));
				tambahItemPlayer(playerid, id_item, -(jumlah_stack * list_barang_tampung_tambang[i][brgJumlah]));

				PlayerTakesAnimation(playerid);

				new nama_item[50];
				getNamaByIdItem(id_item, nama_item);
				sendPesan(playerid, COLOR_GREEN, TAG_INFO" "WHITE"Berhasil menjual %s sebanyak "ORANGE"%d "WHITE"dengan total harga "GREEN"$%d", nama_item, jumlah_stack * list_barang_tampung_tambang[i][brgJumlah], jumlah_stack * (list_barang_tampung_tambang[i][brgHarga] - floatround(float(list_barang_tampung_tambang[i][brgHarga]) * 0.1, floatround_floor)));
			}
			return 1;
		}
		case DIALOG_BELI_ITEM_TAMBANG_LIST:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);
				ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_TAMBANG_LIST_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_BELI_ITEM_TAMBANG_LIST_JUMLAH:
		{
			if(response){
				new banyak_barang;
				if(sscanf(inputtext, "i", banyak_barang)) 
					return ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_TAMBANG_LIST_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Jumlah tidak valid.\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");

				if(banyak_barang < 1 || banyak_barang > 1000) 
					return ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_TAMBANG_LIST_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Jumlah yang dibeli harus antara 1 hingga 1000.\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");

				new idx = GetPVarInt(playerid, "index_terpilih");

				if(!CekJikaInventoryPlayerMuat(playerid, item_beli_tambang[idx][idItemMarket], banyak_barang)){
					return ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_TAMBANG_LIST_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Inventory tidak muat untuk membeli item sebanyak itu.\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");
				}

				new nama_item[50];
				getNamaByIdItem(item_beli_tambang[idx][idItemMarket], nama_item);
				
				SetPVarInt(playerid, "banyak_barang", banyak_barang);

				format(pDialog[playerid], 
					sizePDialog, 
					WHITE"Anda akan membeli "YELLOW"%s "WHITE"sebanyak "YELLOW"%d\n\
					"WHITE"Dengan total harga "GREEN"$%d"WHITE".\n\
					Apakah anda yakin?", 
					nama_item, 
					banyak_barang, 
					item_beli_tambang[idx][hargaItemMarket] * banyak_barang);
				
				ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_TAMBANG_LIST_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi pembelian", pDialog[playerid], "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_BELI_ITEM_TAMBANG_LIST_KONFIRMASI:
		{
			if(response){
				new idx = GetPVarInt(playerid, "index_terpilih"),
					banyak_barang = GetPVarInt(playerid, "banyak_barang"),
					nama_item[50];

				if(getUangPlayer(playerid) < item_beli_tambang[idx][hargaItemMarket] * banyak_barang)
					return SendClientMessage(playerid, COLOR_RED, TAG_GAGAL" "WHITE"Uang anda tidak mencukupi untuk membayar.");

				givePlayerUang(playerid, -(item_beli_tambang[idx][hargaItemMarket] * banyak_barang));
				tambahItemPlayer(playerid, item_beli_tambang[idx][idItemMarket], banyak_barang);

				getNamaByIdItem(item_beli_tambang[idx][idItemMarket], nama_item);

				format(pDialog[playerid], sizePDialog, 
					WHITE"Anda telah berhasil membeli "GREEN"%s"WHITE" sebanyak %dx.\n\
					Dengan harga "GREEN"$%d\n\
					"YELLOW"Silahkan cek inventory kamu.", 
					nama_item, 
					banyak_barang, 
					item_beli_tambang[idx][hargaItemMarket] * banyak_barang);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli item", pDialog[playerid], "Ok", "");
			}
		}
		case DIALOG_PENJUAL_KAYU_LIST_JUAL:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);
				
				new nama_item[50],
					i = GetPVarInt(playerid, "index_terpilih");
				getNamaByIdItem(list_barang_tampung_kayu[i][brgId], nama_item);
				
				format(pDialog[playerid], sizePDialog, 
					WHITE"Anda akan menjual "PURPLE"%s "WHITE"dengan harga satuan "GREEN"$%d "WHITE"per %d item.\n\
					"WHITE"Berapa stack yang anda akan jual?\n\n\
					"YELLOW"Note: "WHITE"1 stack = %d item = "GREEN"$%d", 
					nama_item,
					list_barang_tampung_kayu[i][brgHarga] - floatround(float(list_barang_tampung_kayu[i][brgHarga]) * 0.1, floatround_floor),
					list_barang_tampung_kayu[i][brgJumlah],
					list_barang_tampung_kayu[i][brgJumlah],
					list_barang_tampung_kayu[i][brgHarga] - floatround(float(list_barang_tampung_kayu[i][brgHarga]) * 0.1, floatround_floor)
					);
				ShowPlayerDialog(playerid, DIALOG_PENJUAL_KAYU_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", pDialog[playerid], "Jual", "Batal");
			}
			return 1;
		}
		case DIALOG_PENJUAL_KAYU_LIST_JUAL_JUMLAH:
		{
			if(response){				
				new input_jumlah;
				new nama_item[50],
					i = GetPVarInt(playerid, "index_terpilih");
				getNamaByIdItem(list_barang_tampung_kayu[i][brgId], nama_item);
				
				if(sscanf(inputtext, "i", input_jumlah)) {
					new str_temp[500];
					format(str_temp, 500, 
						RED"Jumlah stack invalid.\n%s", 
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_KAYU_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > 100){
					new str_temp[500];
					format(str_temp, 500, 
						RED"Hanya dapat menjual 1 hingga 100 stack dalam sekali penjualan.\n%s", 
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_KAYU_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}	
				if(input_jumlah * list_barang_tampung_kayu[i][brgJumlah] > GetJumlahItemPlayer(playerid, list_barang_tampung_kayu[i][brgId])){
					new str_temp[500];
					format(str_temp, 500, 
						RED"Jumlah item anda tidak mencukupi, %d stack = %d item.\nJumlah saat ini %d.\n%s", 
						input_jumlah, 
						input_jumlah * list_barang_tampung_kayu[i][brgJumlah],
						GetJumlahItemPlayer(playerid, list_barang_tampung_kayu[i][brgId]),
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_KAYU_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}

				SetPVarInt(playerid, "jumlah_stack", input_jumlah);

				format(pDialog[playerid], sizePDialog, WHITE"Anda akan menjual %s dengan spesifikasi:\n\
					"WHITE"Jumlah stack\t\t: "YELLOW"%d\n\
					"WHITE"Jumlah per stack\t: "YELLOW"%d\n\
					"WHITE"Jumlah total\t\t: "YELLOW"%d\n\
					"WHITE"Harga jual per stack\t: "GREEN"$%d\n\
					"WHITE"Harga Jual Total\t: "GREEN"$%d\n\n\
					"WHITE"Apakah anda ingin menjual item ini?", 
					nama_item,
					input_jumlah,
					list_barang_tampung_kayu[i][brgJumlah],
					input_jumlah * list_barang_tampung_kayu[i][brgJumlah],
					list_barang_tampung_kayu[i][brgHarga] - floatround(float(list_barang_tampung_kayu[i][brgHarga]) * 0.1, floatround_floor),
					input_jumlah * (list_barang_tampung_kayu[i][brgHarga] - floatround(float(list_barang_tampung_kayu[i][brgHarga]) * 0.1, floatround_floor)));
				ShowPlayerDialog(playerid, DIALOG_PENJUAL_KAYU_LIST_JUAL_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi penjualan", pDialog[playerid], "Jual", "Batal");
			}
			return 1;
		}
		case DIALOG_PENJUAL_KAYU_LIST_JUAL_KONFIRMASI:
		{
			if(response){
				new i = GetPVarInt(playerid, "index_terpilih"),
					jumlah_stack = GetPVarInt(playerid, "jumlah_stack");
				new id_item = list_barang_tampung_kayu[i][brgId];
				givePlayerUang(playerid, jumlah_stack * (list_barang_tampung_kayu[i][brgHarga] - floatround(float(list_barang_tampung_kayu[i][brgHarga]) * 0.1, floatround_floor)));
				tambahItemPlayer(playerid, id_item, -(jumlah_stack * list_barang_tampung_kayu[i][brgJumlah]));

				PlayerTakesAnimation(playerid);

				new nama_item[50];
				getNamaByIdItem(id_item, nama_item);
				sendPesan(playerid, COLOR_GREEN, TAG_INFO" "WHITE"Berhasil menjual %s sebanyak "ORANGE"%d "WHITE"dengan total harga "GREEN"$%d", nama_item, jumlah_stack * list_barang_tampung_kayu[i][brgJumlah], jumlah_stack * (list_barang_tampung_kayu[i][brgHarga] - floatround(float(list_barang_tampung_kayu[i][brgHarga]) * 0.1, floatround_floor)));
			}
			return 1;
		}
		case DIALOG_BELI_ITEM_KAYU_LIST:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);
				ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_KAYU_LIST_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_BELI_ITEM_KAYU_LIST_JUMLAH:
		{
			if(response){
				new banyak_barang;
				if(sscanf(inputtext, "i", banyak_barang)) 
					return ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_KAYU_LIST_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Jumlah tidak valid.\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");

				if(banyak_barang < 1 || banyak_barang > 1000) 
					return ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_KAYU_LIST_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Jumlah yang dibeli harus antara 1 hingga 1000.\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");

				new idx = GetPVarInt(playerid, "index_terpilih");

				if(!CekJikaInventoryPlayerMuat(playerid, item_beli_kayu[idx][idItemMarket], banyak_barang)){
					return ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_KAYU_LIST_JUMLAH, DIALOG_STYLE_INPUT, "Jumlah dibeli", RED"Inventory tidak muat untuk membeli item sebanyak itu.\n"WHITE"Silahkan input jumlah yang ingin dibeli.", "Beli", "Batal");
				}

				new nama_item[50];
				getNamaByIdItem(item_beli_kayu[idx][idItemMarket], nama_item);
				
				SetPVarInt(playerid, "banyak_barang", banyak_barang);

				format(pDialog[playerid], 
					sizePDialog, 
					WHITE"Anda akan membeli "YELLOW"%s "WHITE"sebanyak "YELLOW"%d\n\
					"WHITE"Dengan total harga "GREEN"$%d"WHITE".\n\
					Apakah anda yakin?", 
					nama_item, 
					banyak_barang, 
					item_beli_kayu[idx][hargaItemMarket] * banyak_barang);
				
				ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_KAYU_LIST_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi pembelian", pDialog[playerid], "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_BELI_ITEM_KAYU_LIST_KONFIRMASI:
		{
			if(response){
				new idx = GetPVarInt(playerid, "index_terpilih"),
					banyak_barang = GetPVarInt(playerid, "banyak_barang"),
					nama_item[50];

				if(getUangPlayer(playerid) < item_beli_kayu[idx][hargaItemMarket] * banyak_barang)
					return SendClientMessage(playerid, COLOR_RED, TAG_GAGAL" "WHITE"Uang anda tidak mencukupi untuk membayar.");

				givePlayerUang(playerid, -(item_beli_kayu[idx][hargaItemMarket] * banyak_barang));
				tambahItemPlayer(playerid, item_beli_kayu[idx][idItemMarket], banyak_barang);

				getNamaByIdItem(item_beli_kayu[idx][idItemMarket], nama_item);

				format(pDialog[playerid], sizePDialog, 
					WHITE"Anda telah berhasil membeli "GREEN"%s"WHITE" sebanyak %dx.\n\
					Dengan harga "GREEN"$%d\n\
					"YELLOW"Silahkan cek inventory kamu.", 
					nama_item, 
					banyak_barang, 
					item_beli_kayu[idx][hargaItemMarket] * banyak_barang);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli item", pDialog[playerid], "Ok", "");
			}
			return 1;
		}
		case DIALOG_OPTION_INVENTORY_VEHICLE:
		{
			if(response){
				new vehicleid = GetPVarInt(playerid, "inventory_vehicle");

				switch(listitem){
					case 0: // Ambil Item
					{
						SetPVarInt(playerid, "halaman", 0);
						showDialogListItemVehicle(playerid, vehicleid);
					}
					case 1: // Simpan Item
					{
						SetPVarInt(playerid, "halaman", 0);
						showDialogListItem(playerid, .dialogid = DIALOG_SIMPAN_ITEM_VEHICLE);
					}
				}
			}
			return 1;
		}
		case DIALOG_AMBIL_ITEM_VEHICLE:
		{
			if(response){
				new vehicleid = GetPVarInt(playerid, "inventory_vehicle"),
					Float:vpos[3];

				GetVehicleBoot(vehicleid, vpos[0], vpos[1], vpos[2]);
				if(!IsPlayerInRangeOfPoint(playerid, 1.0, vpos[0], vpos[1], vpos[2])){
					return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Kendaraan berada menjauh dari anda.");
				}else if(!GetVehicleParams(vehicleid, VEHICLE_TYPE_BOOT)){
					return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Bagasi kendaraan tertutup.");
				}
				
				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					showDialogListItemVehicle(playerid, vehicleid);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);					
						showDialogListItemVehicle(playerid, vehicleid);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						showDialogListItemVehicle(playerid, vehicleid);
					}
					return 1;
				}

				new nama_item[50];
				SetPVarInt(playerid, "bagasi_id_item", TempPlayerDialog[playerid][listitem]);
				getNamaByIdItem(TempPlayerDialog[playerid][listitem], nama_item);

				format(pDialog[playerid], sizePDialog, 
					WHITE"Anda akan mengambil item "GREEN"%s "WHITE"dari bagasi.\n\
					"WHITE"Banyak item yang tersedia "GREEN"%d\n\
					"WHITE"Silahkan masukan jumlah yang ingin diambil :", 
					nama_item, 
					GetJumlahItemVehicle(vehicleid, GetPVarInt(playerid, "bagasi_id_item"))
				);
				ShowPlayerDialog(playerid, DIALOG_AMBIL_ITEM_VEHICLE_JUMLAH, DIALOG_STYLE_INPUT, "Ambil Item", pDialog[playerid], "Ambil", "Batal");
			}
			return 1;
		}
		case DIALOG_AMBIL_ITEM_VEHICLE_JUMLAH:
		{
			if(response){
				new vehicleid = GetPVarInt(playerid, "inventory_vehicle"),
					Float:vpos[3];

				GetVehicleBoot(vehicleid, vpos[0], vpos[1], vpos[2]);
				if(!IsPlayerInRangeOfPoint(playerid, 1.0, vpos[0], vpos[1], vpos[2])){
					return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Kendaraan berada menjauh dari anda.");
				}else if(!GetVehicleParams(vehicleid, VEHICLE_TYPE_BOOT)){
					return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Bagasi kendaraan tertutup.");
				}

				new nama_item[50], id_item = GetPVarInt(playerid, "bagasi_id_item");
				new jumlah = GetJumlahItemVehicle(vehicleid, id_item);
				getNamaByIdItem(id_item, nama_item);

				new input_jumlah;
				if(sscanf(inputtext, "i", input_jumlah)) {
					format(pDialog[playerid], sizePDialog, 
						RED"Inputan tidak valid.\n\
						"WHITE"Anda akan mengambil item "GREEN"%s "WHITE"dari bagasi.\n\
						"WHITE"Banyak item yang tersedia "GREEN"%d\n\
						"WHITE"Silahkan masukan jumlah yang ingin diambil :", 
						nama_item, 
						jumlah
					);
					return ShowPlayerDialog(playerid, DIALOG_AMBIL_ITEM_VEHICLE_JUMLAH, DIALOG_STYLE_INPUT, "Ambil Item", pDialog[playerid], "Ambil", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > jumlah){
					format(pDialog[playerid], sizePDialog, 
						RED"Jumlah yang dimasukan tidak tepat.\n\
						"WHITE"Anda akan mengambil item "GREEN"%s "WHITE"dari bagasi.\n\
						"WHITE"Banyak item yang tersedia "GREEN"%d\n\
						"WHITE"Silahkan masukan jumlah yang ingin diambil :", 
						nama_item, 
						jumlah
					);
					return ShowPlayerDialog(playerid, DIALOG_AMBIL_ITEM_VEHICLE_JUMLAH, DIALOG_STYLE_INPUT, "Ambil Item", pDialog[playerid], "Ambil", "Batal");
				}
				if(!CekJikaInventoryPlayerMuat(playerid, id_item, input_jumlah)){
					format(pDialog[playerid], sizePDialog, 
						RED"Inventory anda tidak muat.\n\
						"WHITE"Anda akan mengambil item "GREEN"%s "WHITE"dari bagasi.\n\
						"WHITE"Banyak item yang tersedia "GREEN"%d\n\
						"WHITE"Silahkan masukan jumlah yang ingin diambil :", 
						nama_item, 
						jumlah
					);
					return ShowPlayerDialog(playerid, DIALOG_AMBIL_ITEM_VEHICLE_JUMLAH, DIALOG_STYLE_INPUT, "Ambil Item", pDialog[playerid], "Ambil", "Batal");
				}
				tambahItemPlayer(playerid, id_item, input_jumlah);
				tambahItemVehicle(vehicleid, id_item, -input_jumlah);
				
				sendPesan(playerid, COLOR_GREEN, TAG_KENDARAAN" "WHITE"Anda mengambil "YELLOW"%s "WHITE"sebanyak "GREEN"%d "WHITE"dari bagasi %s.", nama_item, input_jumlah, GetVehicleModelName(GetVehicleModel(vehicleid)));
			}
			return 1;
		}
		case DIALOG_SIMPAN_ITEM_VEHICLE:
		{
			if(response){
				new vehicleid = GetPVarInt(playerid, "inventory_vehicle"),
					Float:vpos[3];

				GetVehicleBoot(vehicleid, vpos[0], vpos[1], vpos[2]);
				if(!IsPlayerInRangeOfPoint(playerid, 1.0, vpos[0], vpos[1], vpos[2])){
					return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Kendaraan berada menjauh dari anda.");
				}else if(!GetVehicleParams(vehicleid, VEHICLE_TYPE_BOOT)){
					return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Bagasi kendaraan tertutup.");
				}

				if(strcmp(inputtext, STRING_SELANJUTNYA) == 0){
					SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") + 1);
					showDialogListItem(playerid, .dialogid = DIALOG_SIMPAN_ITEM_VEHICLE);
					return 1;
				}else if(strcmp(inputtext, STRING_SEBELUMNYA) == 0){
					if(GetPVarInt(playerid, "halaman") > 0){
						SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);					
						showDialogListItem(playerid, .dialogid = DIALOG_SIMPAN_ITEM_VEHICLE);
					}else{
						SetPVarInt(playerid, "halaman", 0);
						showDialogListItem(playerid, .dialogid = DIALOG_SIMPAN_ITEM_VEHICLE);
					}
					return 1;
				}

				new 
					id_item = TempPlayerDialog[playerid][listitem],
					nama_item[50]
				;
				SetPVarInt(playerid, "bagasi_id_item", id_item);
				getNamaByIdItem(id_item, nama_item);

				if(GetStatusKunciItemPlayer(playerid, id_item)){
					resetPVarInventory(playerid);

					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, ORANGE"Item tidak dapat dibuang", WHITE"Item ini "RED"dikunci.\n\n"YELLOW"Note : Item yang dikunci tidak dapat dibuang/dijual/diberi kepada orang lain.\nJika tetap ingin melakukan hal tersebut silahkan buka item terlebih dahulu.", "Ok", "");
					return 1;
				}

				format(pDialog[playerid], 
					sizePDialog, 
					WHITE"Silahkan masukan jumlah item yang ingin disimpan.\n\n\
					"WHITE"Nama Item : "PINK"%s\n\
					"WHITE"Jumlah Item : "GREEN"%d", 
					nama_item, 
					GetJumlahItemPlayer(playerid, id_item)
				);
				ShowPlayerDialog(playerid, DIALOG_SIMPAN_ITEM_VEHICLE_JUMLAH, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin disimpan", pDialog[playerid], "Simpan", "Batal");
			}
			return 1;
		}
		case DIALOG_SIMPAN_ITEM_VEHICLE_JUMLAH:
		{
			if(response){
				new vehicleid = GetPVarInt(playerid, "inventory_vehicle"),
					Float:vpos[3];

				GetVehicleBoot(vehicleid, vpos[0], vpos[1], vpos[2]);
				if(!IsPlayerInRangeOfPoint(playerid, 1.0, vpos[0], vpos[1], vpos[2])){
					return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Kendaraan berada menjauh dari anda.");
				}else if(!GetVehicleParams(vehicleid, VEHICLE_TYPE_BOOT)){
					return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Bagasi kendaraan tertutup.");
				}

				new nama_item[50], 
					id_item = GetPVarInt(playerid, "bagasi_id_item");
				new jumlah = GetJumlahItemPlayer(playerid, id_item);
				getNamaByIdItem(id_item, nama_item);

				new input_jumlah;
				if(sscanf(inputtext, "i", input_jumlah)) {
					format(pDialog[playerid], 
						sizePDialog, 
						RED"Inputan tidak valid.\n\
						"WHITE"Silahkan masukan jumlah item yang ingin disimpan.\n\n\
						"WHITE"Nama Item : "PINK"%s\n\
						"WHITE"Jumlah Item : "GREEN"%d", 
						nama_item, 
						GetJumlahItemPlayer(playerid, id_item)
					);
					return ShowPlayerDialog(playerid, DIALOG_SIMPAN_ITEM_VEHICLE_JUMLAH, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin disimpan", pDialog[playerid], "Simpan", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > jumlah){
					format(pDialog[playerid], 
						sizePDialog, 
						RED"Jumlah yang dimasukan tidak tepat.\n\
						"WHITE"Silahkan masukan jumlah item yang ingin disimpan.\n\n\
						"WHITE"Nama Item : "PINK"%s\n\
						"WHITE"Jumlah Item : "GREEN"%d", 
						nama_item, 
						GetJumlahItemPlayer(playerid, id_item)
					);
					return ShowPlayerDialog(playerid, DIALOG_SIMPAN_ITEM_VEHICLE_JUMLAH, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin disimpan", pDialog[playerid], "Simpan", "Batal");
				}
				if(!CekJikaInventoryVehicleMuat(vehicleid, id_item, input_jumlah)){
					format(pDialog[playerid], 
						sizePDialog, 
						RED"Bagasi kendaraan tidak muat.\n\
						"WHITE"Silahkan masukan jumlah item yang ingin disimpan.\n\n\
						"WHITE"Nama Item : "PINK"%s\n\
						"WHITE"Jumlah Item : "GREEN"%d", 
						nama_item, 
						GetJumlahItemPlayer(playerid, id_item)
					);
					return ShowPlayerDialog(playerid, DIALOG_SIMPAN_ITEM_VEHICLE_JUMLAH, DIALOG_STYLE_INPUT, ORANGE"Berapa banyak yang ingin disimpan", pDialog[playerid], "Simpan", "Batal");
				}
				tambahItemPlayer(playerid, id_item, -input_jumlah);
				tambahItemVehicle(vehicleid, id_item, input_jumlah);
				
				sendPesan(playerid, COLOR_GREEN, TAG_KENDARAAN" "WHITE"Anda menyimpan "YELLOW"%s "WHITE"sebanyak "GREEN"%d "WHITE"ke bagasi %s.", nama_item, input_jumlah, GetVehicleModelName(GetVehicleModel(vehicleid)));
			}
			return 1;
		}
		case DIALOG_PILIH_LOKASI_GPS:
		{
			if(response){
				SetPlayerCheckpoint(playerid, GPS_LOCATION[listitem][gpsPos][0], GPS_LOCATION[listitem][gpsPos][1], GPS_LOCATION[listitem][gpsPos][2], 4.0);
				PlayerInfo[playerid][activeMarker] = true;

				SendClientMessage(playerid, COLOR_PINK, "[GPS] "WHITE"Lokasi yang anda maksud telah ditandai pada peta menggunakan marker merah.");
				SendClientMessage(playerid, COLOR_PINK, "[GPS] "YELLOW"Penggunaan gps ini akan menggantikan marker yang sebelumnya ada.");
			}
			return 1;
		}
		case DIALOG_TUTORIAL:
		{
			if(response){
				new temp_panduan[24];
				GetPVarString(playerid, "panduan_bermain", temp_panduan, sizeof(temp_panduan));
				
				// Masuk panduan bermain 1
				if(sama(temp_panduan, "panduan_bermain_1")){
					// Set variabel panduan bermain 1 -> 2
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_2");
					format(pDialog[playerid], sizePDialog, 
					WHITE"Saat awal bermain anda akan berada di tempat yang sudah di pilih,\n\
					kamu akan di beri sejumlah uang, untuk digunakan sebagai modal awal,\n\
					tentukan tujuan awalmu dengan bekerja, bertransaksi atau berinvestasi.\n\
					Ada beberapa fitur dan tempat yang harus kamu ketahui.\n\
					Disarankan menggunakan perintah "GREEN"/help"WHITE" untuk menu bantuan.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Awal) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 2
				if(sama(temp_panduan, "panduan_bermain_2")){
					// Set variabel panduan bermain 2 -> 3
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_3");
					// Preload object
					Streamer_UpdateEx(playerid, 1478.335205, -1730.107177, 44.398784, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1478.335205, -1730.107177, 44.398784, 1479.400512, -1775.524169, 18.056886, 5000);
					InterpolateCameraLookAt(playerid, 1478.424682, -1734.859375, 42.846801, 1479.493041, -1780.440795, 17.152063, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Kantor Pemerintah (Los Santos)\n\n"\
					WHITE"Terdapat kantor pemerintah salah satunya yang terdapat di daerah\n\
					Los Santos, kamu dapat melakukan pembuatan ktp, pendaftaran nomor hp\n\
					dan lainnya disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 3
				if(sama(temp_panduan, "panduan_bermain_3")){
					// Set variabel panduan bermain 3 -> 4
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_4");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1500.841186, -1677.795166, 45.571907, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1500.841186, -1677.795166, 45.571907, 1548.980468, -1675.600952, 17.869146, 5000);
					InterpolateCameraLookAt(playerid, 1505.678344, -1677.619262, 44.318572, 1553.855102, -1675.565429, 16.756946, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Polisi Metro (Los Santos)\n\n"\
					WHITE"Terdapat kantor polisi metro salah satunya yang terdapat di daerah\n\
					Los Santos, kamu dapat melakukan pembuatan sim, membuat laporan dan\n\
					lainnya disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 4
				if(sama(temp_panduan, "panduan_bermain_4")){
					// Set variabel panduan bermain 4 -> 5
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_5");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1462.544067, -1038.169189, 79.659347, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1518.877441, -1081.966308, 67.912002, 1465.668334, -1017.780212, 27.675041, 5000);
					InterpolateCameraLookAt(playerid, 1516.185058, -1078.150024, 66.126831, 1465.415771, -1012.810546, 27.186794, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Bank (Los Santos)\n\n"\
					WHITE"Terdapat bank salah satunya yang terdapat di daerah Los Santos,\n\
					kamu dapat melakukan buka rekening, terima gaji atau keperluan\n\
					keuangan lainnya disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 5
				if(sama(temp_panduan, "panduan_bermain_5")){
					// Set variabel panduan bermain 5 -> 6
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_6");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1224.142333, -1324.592285, 51.018974, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1224.142333, -1324.592285, 51.018974, 1179.968505, -1323.868164, 16.555538, 5000);
					InterpolateCameraLookAt(playerid, 1219.928710, -1324.618530, 48.327301, 1175.025024, -1323.812866, 15.807853, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Rumah Sakit (Los Santos)\n\n"\
					WHITE"Terdapat rumah sakit salah satunya yang terdapat di daerah\n\
					Los Santos, kamu dapat melakukan cek kesehatan, membeli obat atau\n\
					keperluan kesehatan lainnya disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 6
				if(sama(temp_panduan, "panduan_bermain_6")){
					// Set variabel panduan bermain 6 -> 7
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_7");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1350.927734, -1729.150390, 38.162387, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1350.927734, -1729.150390, 38.162387, 1352.030883, -1752.793457, 14.466343, 5000);
					InterpolateCameraLookAt(playerid, 1350.838989, -1732.702270, 34.644378, 1352.022216, -1757.790771, 14.631426, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Minimarket\n\n"\
					WHITE"Terdapat minimarket yang tersebar di beberapa titik, kamu\n\
					dapat membeli kebutuhan sehari-hari yang tersedia disini, bayar\n\
					bisa via Uang Cash atau E-Banking.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 7
				if(sama(temp_panduan, "panduan_bermain_7")){
					// Set variabel panduan bermain 7 -> 8
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_8");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 889.065734, -1338.378051, 30.718097, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 889.065734, -1338.378051, 30.718097, 920.687255, -1353.059082, 15.314036, 5000);
					InterpolateCameraLookAt(playerid, 893.465332, -1340.159545, 29.146455, 925.683288, -1352.861938, 15.342244, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Restoran Makanan\n\n"\
					WHITE"Terdapat restoran makanan yang tersebar di beberapa titik,\n\
					kamu dapat membeli makanan dan minuman yang tersedia disini,\n\
					bayar bisa via Uang Cash atau E-Banking.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 8
				if(sama(temp_panduan, "panduan_bermain_8")){
					// Set variabel panduan bermain 8 -> 9
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_9");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1478.033569, -1684.874023, 48.674427, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1478.033569, -1684.874023, 48.674427, 1477.369995, -1646.051391, 16.643753, 5000);
					InterpolateCameraLookAt(playerid, 1477.936523, -1680.814941, 45.756477, 1477.105957, -1641.071044, 16.288347, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Marketplace\n\n"\
					WHITE"Terdapat marketplace yang tersebar di beberapa titik utama\n\
					perkotaan, kamu dapat melakukan jual-beli barang, kendaraan,\n\
					rumah dan lainnya disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 9
				if(sama(temp_panduan, "panduan_bermain_9")){
					// Set variabel panduan bermain 9 -> 10
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_10");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1113.098876, -1402.881103, 38.305709, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1113.098876, -1402.881103, 38.305709, 1112.288940, -1375.725463, 15.041452, 5000);
					InterpolateCameraLookAt(playerid, 1113.090942, -1399.252563, 34.865707, 1112.162475, -1370.750244, 14.560559, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Cetak Foto\n\n"\
					WHITE"Terdapat cetak foto yang tersebar di beberapa titik, kamu\n\
					dapat melakukan cetak foto untuk keperluan persyaratan disini,\n\
					bayar bisa via Uang Cash atau E-Banking.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 10
				if(sama(temp_panduan, "panduan_bermain_10")){
					// Set variabel panduan bermain 10 -> 11
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_11");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1097.264770, -1406.969970, 39.328311, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1097.264770, -1406.969970, 39.328311, 1097.696899, -1375.371582, 14.874300, 5000);
					InterpolateCameraLookAt(playerid, 1097.217285, -1402.964111, 36.336597, 1097.666870, -1370.386840, 14.485650, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Toko Gadget\n\n"\
					WHITE"Terdapat toko gadget yang tersebar di beberapa titik, kamu\n\
					dapat membeli berbagai alat elektronik yang tersedia seperti Phone,\n\
					bayar bisa via Uang Cash atau E-Banking.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 11
				if(sama(temp_panduan, "panduan_bermain_11")){
					// Set variabel panduan bermain 11 -> 12
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_12");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 511.693481, -1326.749511, 41.180870, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 511.693481, -1326.749511, 41.180870, 502.465393, -1353.963012, 16.287780, 5000);
					InterpolateCameraLookAt(playerid, 510.081542, -1330.454345, 38.235466, 500.324554, -1358.449218, 16.826824, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Toko Baju\n\n"\
					WHITE"Terdapat toko baju yang tersebar di beberapa titik, kamu dapat\n\
					membeli skin atau tampilan yang kamu suka yang tersedia disini, bayar\n\
					bisa via Uang Cash atau E-Banking.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 12
				if(sama(temp_panduan, "panduan_bermain_12")){
					// Set variabel panduan bermain 12 -> 13
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_13");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1494.063598, -1640.976562, 26.910634, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1494.063598, -1640.976562, 26.910634, 1494.217529, -1655.772216, 14.339630, 5000);
					InterpolateCameraLookAt(playerid, 1494.089355, -1644.998046, 23.939535, 1494.026123, -1660.546142, 12.865449, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Toko Bibit\n\n"\
					WHITE"Terdapat kantor polisi metro salah satunya yang terdapat di daerah\n\
					Los Santos, kamu dapat melakukan pembuatan sim, membuat laporan dan\n\
					lainnya disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 13
				if(sama(temp_panduan, "panduan_bermain_13")){
					// Set variabel panduan bermain 13 -> 14
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_14");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1049.365844, -1891.333618, 34.265365, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1049.365844, -1891.333618, 34.265365, 1026.764526, -1892.213745, 13.816367, 5000);
					InterpolateCameraLookAt(playerid, 1045.736083, -1891.353149, 30.826658, 1021.824462, -1892.297729, 13.049029, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Toko Peralatan Pancing\n\n"\
					WHITE"Terdapat peralatan pancing yang terdapat di beberapa titik daerah\n\
					pantai, kamu dapat membeli peralatan pancing seperti umpan, alat pancing\n\
					dan lainnya disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 14
				if(sama(temp_panduan, "panduan_bermain_14")){
					// Set variabel panduan bermain 14 -> 15
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_15");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1720.815429, -1699.454345, 35.159568, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1720.815429, -1699.454345, 35.159568, 1720.038208, -1735.628051, 14.701961, 5000);
					InterpolateCameraLookAt(playerid, 1720.764892, -1704.017089, 33.115386, 1720.069946, -1740.626953, 14.600712, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Blacksmith\n\n"\
					WHITE"Terdapat pusat keahlian blacksmith salah satunya yang terdapat di\n\
					daerah Los Santos, kamu dapat mengaktifkan keahlian blacksmith lainnya\n\
					disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 15
				if(sama(temp_panduan, "panduan_bermain_15")){
					// Set variabel panduan bermain 15 -> 16
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_16");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1065.145874, -1596.411865, 76.654823, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1065.145874, -1596.411865, 76.654823, 1018.630371, -1648.135986, 17.464708, 5000);
					InterpolateCameraLookAt(playerid, 1062.830932, -1599.725219, 73.711608, 1014.563110, -1650.957641, 16.760589, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Mekanik\n\n"\
					WHITE"Terdapat pusat keahlian mekanik salah satunya yang terdapat di\n\
					daerah Los Santos, kamu dapat mengaktifkan keahlian mekanik dan\n\
					lainnya disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 16
				if(sama(temp_panduan, "panduan_bermain_16")){
					// Set variabel panduan bermain 16 -> 17
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_17");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, -760.148620, 2412.814697, 182.083770, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, -760.148620, 2412.814697, 182.083770, -695.408020, 2372.162841, 131.952316, 5000);
					InterpolateCameraLookAt(playerid, -756.505187, 2410.497802, 179.562500, -690.479614, 2372.063232, 131.114959, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Pusat Tambang\n\n"\
					WHITE"Terdapat pusat tambang yang terdapat di daerah perbukitan atau\n\
					pegunungan, kamu dapat melakukan penambangan untuk mendapat besi,\n\
					perak hingga berlian disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 17
				if(sama(temp_panduan, "panduan_bermain_17")){
					// Set variabel panduan bermain 17 -> 18
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_18");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 2426.137939, -712.909851, 170.045761, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 2426.137939, -712.909851, 170.045761, 2353.179199, -664.940917, 130.071197, 5000);
					InterpolateCameraLookAt(playerid, 2422.548339, -709.992492, 168.147247, 2351.868164, -660.351196, 128.582534, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Pemotong Kayu (Lumberjack)\n\n"\
					WHITE"Terdapat pemotong kayu yang tersebar di beberapa titik, kamu\n\
					dapat melakukan pemotongan kayu disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 18
				if(sama(temp_panduan, "panduan_bermain_18")){
					// Set variabel panduan bermain 18 -> 19
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_19");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, -574.269836, -610.014770, 86.486259, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, -574.269836, -610.014770, 86.486259, -538.679077, -546.212341, 26.071489, 5000);
					InterpolateCameraLookAt(playerid, -572.335083, -606.385192, 83.643241, -539.133056, -541.254882, 25.604776, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Penadah Besi\n\n"\
					WHITE"Terdapat penadah besi yang tersebar di beberapa titik, kamu dapat\n\
					melakukan transaksi jual hasil tambang kamu seperti besi disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 19
				if(sama(temp_panduan, "panduan_bermain_19")){
					// Set variabel panduan bermain 19 -> 20
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_20");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, -727.737487, -29.341276, 128.404617, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, -727.737487, -29.341276, 128.404617, -763.137512, -125.981948, 67.885345, 5000);
					InterpolateCameraLookAt(playerid, -729.086364, -33.520061, 126.013336, -759.313232, -128.896392, 66.513816, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Penadah Kayu\n\n"\
					WHITE"Terdapat penadah kayu yang tersebar di beberapa titik, kamu dapat\n\
					melakukan transaksi jual kayu kamu disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 20
				if(sama(temp_panduan, "panduan_bermain_20")){
					// Set variabel panduan bermain 20 -> 21
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_21");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 578.765502, -1212.911865, 59.076316, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 578.765502, -1212.911865, 59.076316, 544.736389, -1268.873046, 27.509140, 5000);
					InterpolateCameraLookAt(playerid, 576.182006, -1216.255737, 56.403537, 544.194519, -1273.466430, 25.609746, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Dealer Kendaraan\n\n"\
					WHITE"Terdapat dealer kendaraan yang tersebar di beberapa titik, kamu\n\
					dapat melakukan pembelian kendaraan yang kamu sukai disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 21
				if(sama(temp_panduan, "panduan_bermain_21")){
					// Set variabel panduan bermain 21 -> 22
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_22");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1051.402954, -1812.562866, 68.486885, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1051.402954, -1812.562866, 68.486885, 1002.576843, -1744.829101, 14.272160, 5000);
					InterpolateCameraLookAt(playerid, 1048.593261, -1809.252807, 66.007125, 1005.750061, -1741.035156, 13.539529, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Penjual Dealer\n\n"\
					WHITE"Terdapat penjual dealer salah satunya yang terdapat di daerah Los\n\
					Santos, kamu dapat melakukan transaksi jual kendaraaan disini.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 22
				if(sama(temp_panduan, "panduan_bermain_22")){
					// Set variabel panduan bermain 22 -> 23
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_23");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 321.235260, -1884.306884, 56.054317, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 321.235260, -1884.306884, 56.054317, 320.550689, -1806.583129, 7.684374, 5000);
					InterpolateCameraLookAt(playerid, 321.281768, -1880.024291, 53.474117, 320.489227, -1801.618286, 7.095487, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Penyewaan Kendaraan\n\n"\
					WHITE"Terdapat penyewaan kendaraan yang tersebar di beberapa titik, kamu\n\
					dapat memilih dan menyewa kendaraan, bayar sewa kendaraan sesuai jam yang\n\
					kamu tentukan.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Tempat) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 23
				if(sama(temp_panduan, "panduan_bermain_23")){
					// Set variabel panduan bermain 23 -> 24
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_24");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1011.859069, -1729.953613, 14.682651, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1011.859069, -1729.953613, 14.682651, 1024.166381, -1892.424438, 13.399143, 5000);
					InterpolateCameraLookAt(playerid, 1012.823486, -1734.738525, 13.598794, 1019.169860, -1892.295654, 13.265370, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Actor\n\n"\
					WHITE"Terdapat actor yang tersebar di beberapa titik, kamu dapat\n\
					berinteraksi untuk melakukan transaksi atau hal lainnya dengan\n\
					mengawali atau menyapa actor tersebut, seperti:\n\
					"YELLOW"Siapa nama kamu\n"\
					WHITE"actor tersebut akan membalas dan kamu dapat melanjutkan\n\
					dengan beberapa sapaan, beberapa panduan actor tersedia di\n\
					titik actor tersebut atau kamu dapat mengunjungi wiki kami\n\
					"GREEN"wiki.playverse.org"WHITE" untuk lebih lanjutnya.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Fitur) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 24
				if(sama(temp_panduan, "panduan_bermain_24")){
					// Set variabel panduan bermain 24 -> 25
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_25");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1109.572631, -1455.740478, 47.453723, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1109.572631, -1455.740478, 47.453723, 1150.003173, -1449.080932, 17.992271, 5000);
					InterpolateCameraLookAt(playerid, 1113.656005, -1455.769531, 44.568454, 1154.212036, -1448.890625, 15.299870, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"ATM\n\n"\
					WHITE"Terdapat atm yang tersebar di beberapa titik, kamu dapat melakukan\n\
					transaksi, cek rekening atau lainnya dengan menggunakan ATM.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Fitur) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 25
				if(sama(temp_panduan, "panduan_bermain_25")){
					// Set variabel panduan bermain 25 -> 26
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_26");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 654.655090, -1146.930053, 45.391319, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 654.655090, -1146.930053, 45.391319, 679.027954, -1176.712280, 17.457517, 5000);
					InterpolateCameraLookAt(playerid, 657.653076, -1150.161376, 43.031127, 682.978942, -1179.742919, 17.004770, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Sweeper\n\n"\
					WHITE"Kamu akan bekerja sebagai Pembersih Jalan (Sweeper), tugas kamu\n\
					adalah mengikuti setiap checkpoint yang ada, ikuti aturan lalu lintas\n\
					agar kamu selamat dan tidak di tilang.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Pekerjaan) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 26
				if(sama(temp_panduan, "panduan_bermain_26")){
					// Set variabel panduan bermain 26 -> 27
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_27");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 1693.901855, -1502.005493, 54.984382, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 1693.901855, -1502.005493, 54.984382, 1643.594848, -1537.513549, 17.273342, 5000);
					InterpolateCameraLookAt(playerid, 1690.491821, -1504.008544, 51.924995, 1639.298461, -1540.037231, 16.857881, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Trashmaster\n\n"\
					WHITE"Kamu akan bekerja sebagai Pengangkut Sampah (Trashmaster), tugas kamu\n\
					adalah mengikuti setiap checkpoint yang ada, ikuti aturan lalu lintas\n\
					agar kamu selamat dan tidak di tilang.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Pekerjaan) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 27
				if(sama(temp_panduan, "panduan_bermain_27")){
					// Set variabel panduan bermain 27 -> 28
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_28");
					// Preload object
					tungguPanduanDialog(playerid, 0);
					Streamer_UpdateEx(playerid, 2070.390625, -1852.886962, 41.899188, -1, -1, -1, 2700000, 1);
					timerPanduanStream[playerid] = SetPreciseTimer("tungguPanduanDialog", 1800000, false, "ii", playerid, 2);
					// Set camera
					InterpolateCameraPos(playerid, 2070.390625, -1852.886962, 41.899188, 2136.613281, -1821.368774, 21.421680, 5000);
					InterpolateCameraLookAt(playerid, 2073.250732, -1849.787719, 39.213085, 2132.467529, -1821.113159, 18.638294, 2000);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					GREEN"Pizzaboy\n\n"\
					WHITE"Kamu akan bekerja sebagai Pengantar Pizza (Pizzaboy), tugas kamu\n\
					adalah mengikuti setiap checkpoint yang ada, ikuti aturan lalu lintas\n\
					agar kamu selamat dan tidak di tilang.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Pekerjaan) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Masuk panduan bermain 28
				if(sama(temp_panduan, "panduan_bermain_28")){
					// Set variabel panduan bermain 28 -> 29
					SetPVarString(playerid, "panduan_bermain", "panduan_bermain_29");
					// Reset
					tungguPanduanDialog(playerid, 1);
					// Dialog
					format(pDialog[playerid], sizePDialog, 
					WHITE"Anda sudah membaca penjelasa singkat yang perlu di ketahui, fitur\n\
					dan tempat akan terus bertambah dengan berjalannya waktu, untuk itu anda\n\
					perlu mengunjungi wiki kami di "GREEN"wiki.playverse.org"WHITE" untuk panduan\n\
					lebih lengkapnya dan untuk menu bantuan anda dapat mengakses perintah "GREEN"/help"WHITE".\n\n\
					Jika anda memiliki pertanyaan atau saran anda dapat mengunjungi forum kami\n\
					"GREEN"forum.playverse.org"WHITE", jangan sungkan untuk berdiskusi bersama kami,\n\
					terima kasih.");
					return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Akhir) :", pDialog[playerid], "Lanjut", "Tutup");
				}
				// Akhir panduan bermain 29
				if(sama(temp_panduan, "panduan_bermain_29")){
					DeletePVar(playerid, "panduan_bermain");
					DeletePVar(playerid, "panduan_bermain_x");
					DeletePVar(playerid, "panduan_bermain_y");
					DeletePVar(playerid, "panduan_bermain_z");
					DeletePVar(playerid, "panduan_bermain_a");
				}
			}else{
				tungguPanduanDialog(playerid, 1);
				DeletePVar(playerid, "panduan_bermain");
				DeletePVar(playerid, "panduan_bermain_x");
				DeletePVar(playerid, "panduan_bermain_y");
				DeletePVar(playerid, "panduan_bermain_z");
				DeletePVar(playerid, "panduan_bermain_a");
			}
			return 1;
		}
		case DIALOG_PENJUAL_IKAN_LIST_JUAL:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);
				
				new nama_item[50],
					i = GetPVarInt(playerid, "index_terpilih");
				getNamaByIdItem(list_barang_tampung_ikan[i][brgId], nama_item);
				
				format(pDialog[playerid], sizePDialog, 
					WHITE"Anda akan menjual "PURPLE"%s "WHITE"dengan harga satuan "GREEN"$%d "WHITE"per %d item.\n\
					"WHITE"Berapa stack yang anda akan jual?\n\n\
					"YELLOW"Note: "WHITE"1 stack = %d item = "GREEN"$%d", 
					nama_item,
					list_barang_tampung_ikan[i][brgHarga] - floatround(float(list_barang_tampung_ikan[i][brgHarga]) * 0.1, floatround_floor),
					list_barang_tampung_ikan[i][brgJumlah],
					list_barang_tampung_ikan[i][brgJumlah],
					list_barang_tampung_ikan[i][brgHarga] - floatround(float(list_barang_tampung_ikan[i][brgHarga]) * 0.1, floatround_floor)
					);
				ShowPlayerDialog(playerid, DIALOG_PENJUAL_IKAN_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", pDialog[playerid], "Jual", "Batal");
			}
			return 1;
		}
		case DIALOG_PENJUAL_IKAN_LIST_JUAL_JUMLAH:
		{
			if(response){				
				new input_jumlah;
				new nama_item[50],
					i = GetPVarInt(playerid, "index_terpilih");
				getNamaByIdItem(list_barang_tampung_ikan[i][brgId], nama_item);
				
				if(sscanf(inputtext, "i", input_jumlah)) {
					new str_temp[500];
					format(str_temp, 500, 
						RED"Jumlah stack invalid.\n%s", 
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_IKAN_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > 100){
					new str_temp[500];
					format(str_temp, 500, 
						RED"Hanya dapat menjual 1 hingga 100 stack dalam sekali penjualan.\n%s", 
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_IKAN_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}	
				if(input_jumlah * list_barang_tampung_ikan[i][brgJumlah] > GetJumlahItemPlayer(playerid, list_barang_tampung_ikan[i][brgId])){
					new str_temp[500];
					format(str_temp, 500, 
						RED"Jumlah item anda tidak mencukupi, %d stack = %d item.\nJumlah saat ini %d.\n%s", 
						input_jumlah, 
						input_jumlah * list_barang_tampung_ikan[i][brgJumlah],
						GetJumlahItemPlayer(playerid, list_barang_tampung_ikan[i][brgId]),
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_IKAN_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}

				SetPVarInt(playerid, "jumlah_stack", input_jumlah);

				format(pDialog[playerid], sizePDialog, WHITE"Anda akan menjual %s dengan spesifikasi:\n\
					"WHITE"Jumlah stack\t\t: "YELLOW"%d\n\
					"WHITE"Jumlah per stack\t: "YELLOW"%d\n\
					"WHITE"Jumlah total\t\t: "YELLOW"%d\n\
					"WHITE"Harga jual per stack\t: "GREEN"$%d\n\
					"WHITE"Harga Jual Total\t: "GREEN"$%d\n\n\
					"WHITE"Apakah anda ingin menjual item ini?", 
					nama_item,
					input_jumlah,
					list_barang_tampung_ikan[i][brgJumlah],
					input_jumlah * list_barang_tampung_ikan[i][brgJumlah],
					list_barang_tampung_ikan[i][brgHarga] - floatround(float(list_barang_tampung_ikan[i][brgHarga]) * 0.1, floatround_floor),
					input_jumlah * (list_barang_tampung_ikan[i][brgHarga] - floatround(float(list_barang_tampung_ikan[i][brgHarga]) * 0.1, floatround_floor)));
				ShowPlayerDialog(playerid, DIALOG_PENJUAL_IKAN_LIST_JUAL_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi penjualan", pDialog[playerid], "Jual", "Batal");
			}
			return 1;
		}
		case DIALOG_PENJUAL_IKAN_LIST_JUAL_KONFIRMASI:
		{
			if(response){
				new i = GetPVarInt(playerid, "index_terpilih"),
					jumlah_stack = GetPVarInt(playerid, "jumlah_stack");
				new id_item = list_barang_tampung_ikan[i][brgId];
				givePlayerUang(playerid, jumlah_stack * (list_barang_tampung_ikan[i][brgHarga] - floatround(float(list_barang_tampung_ikan[i][brgHarga]) * 0.1, floatround_floor)));
				tambahItemPlayer(playerid, id_item, -(jumlah_stack * list_barang_tampung_ikan[i][brgJumlah]));

				PlayerTakesAnimation(playerid);

				new nama_item[50];
				getNamaByIdItem(id_item, nama_item);
				sendPesan(playerid, COLOR_GREEN, TAG_INFO" "WHITE"Berhasil menjual %s sebanyak "ORANGE"%d "WHITE"dengan total harga "GREEN"$%d", nama_item, jumlah_stack * list_barang_tampung_ikan[i][brgJumlah], jumlah_stack * (list_barang_tampung_ikan[i][brgHarga] - floatround(float(list_barang_tampung_ikan[i][brgHarga]) * 0.1, floatround_floor)));
			}
			return 1;
		}
		case DIALOG_PENJUAL_BUAH_LIST_JUAL:
		{
			if(response){
				SetPVarInt(playerid, "index_terpilih", listitem);
				
				new nama_item[50],
					i = GetPVarInt(playerid, "index_terpilih");
				getNamaByIdItem(list_barang_tampung_buah[i][brgId], nama_item);
				
				format(pDialog[playerid], sizePDialog, 
					WHITE"Anda akan menjual "PURPLE"%s "WHITE"dengan harga satuan "GREEN"$%d "WHITE"per %d item.\n\
					"WHITE"Berapa stack yang anda akan jual?\n\n\
					"YELLOW"Note: "WHITE"1 stack = %d item = "GREEN"$%d", 
					nama_item,
					list_barang_tampung_buah[i][brgHarga] - floatround(float(list_barang_tampung_buah[i][brgHarga]) * 0.1, floatround_floor),
					list_barang_tampung_buah[i][brgJumlah],
					list_barang_tampung_buah[i][brgJumlah],
					list_barang_tampung_buah[i][brgHarga] - floatround(float(list_barang_tampung_buah[i][brgHarga]) * 0.1, floatround_floor)
					);
				ShowPlayerDialog(playerid, DIALOG_PENJUAL_BUAH_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", pDialog[playerid], "Jual", "Batal");
			}
			return 1;
		}
		case DIALOG_PENJUAL_BUAH_LIST_JUAL_JUMLAH:
		{
			if(response){				
				new input_jumlah;
				new nama_item[50],
					i = GetPVarInt(playerid, "index_terpilih");
				getNamaByIdItem(list_barang_tampung_buah[i][brgId], nama_item);
				
				if(sscanf(inputtext, "i", input_jumlah)) {
					new str_temp[500];
					format(str_temp, 500, 
						RED"Jumlah stack invalid.\n%s", 
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_BUAH_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}
				if(input_jumlah < 1 || input_jumlah > 100){
					new str_temp[500];
					format(str_temp, 500, 
						RED"Hanya dapat menjual 1 hingga 100 stack dalam sekali penjualan.\n%s", 
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_BUAH_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}	
				if(input_jumlah * list_barang_tampung_buah[i][brgJumlah] > GetJumlahItemPlayer(playerid, list_barang_tampung_buah[i][brgId])){
					new str_temp[500];
					format(str_temp, 500, 
						RED"Jumlah item anda tidak mencukupi, %d stack = %d item.\nJumlah saat ini %d.\n%s", 
						input_jumlah, 
						input_jumlah * list_barang_tampung_buah[i][brgJumlah],
						GetJumlahItemPlayer(playerid, list_barang_tampung_buah[i][brgId]),
						pDialog[playerid]);
					return ShowPlayerDialog(playerid, DIALOG_PENJUAL_BUAH_LIST_JUAL_JUMLAH, DIALOG_STYLE_INPUT, "Banyak stack yang ingin dijual", str_temp, "Jual", "Batal");
				}

				SetPVarInt(playerid, "jumlah_stack", input_jumlah);

				format(pDialog[playerid], sizePDialog, WHITE"Anda akan menjual %s dengan spesifikasi:\n\
					"WHITE"Jumlah stack\t\t: "YELLOW"%d\n\
					"WHITE"Jumlah per stack\t: "YELLOW"%d\n\
					"WHITE"Jumlah total\t\t: "YELLOW"%d\n\
					"WHITE"Harga jual per stack\t: "GREEN"$%d\n\
					"WHITE"Harga Jual Total\t: "GREEN"$%d\n\n\
					"WHITE"Apakah anda ingin menjual item ini?", 
					nama_item,
					input_jumlah,
					list_barang_tampung_buah[i][brgJumlah],
					input_jumlah * list_barang_tampung_buah[i][brgJumlah],
					list_barang_tampung_buah[i][brgHarga] - floatround(float(list_barang_tampung_buah[i][brgHarga]) * 0.1, floatround_floor),
					input_jumlah * (list_barang_tampung_buah[i][brgHarga] - floatround(float(list_barang_tampung_buah[i][brgHarga]) * 0.1, floatround_floor)));
				ShowPlayerDialog(playerid, DIALOG_PENJUAL_BUAH_LIST_JUAL_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi penjualan", pDialog[playerid], "Jual", "Batal");
			}
			return 1;
		}
		case DIALOG_PENJUAL_BUAH_LIST_JUAL_KONFIRMASI:
		{
			if(response){
				new i = GetPVarInt(playerid, "index_terpilih"),
					jumlah_stack = GetPVarInt(playerid, "jumlah_stack");
				new id_item = list_barang_tampung_buah[i][brgId];
				givePlayerUang(playerid, jumlah_stack * (list_barang_tampung_buah[i][brgHarga] - floatround(float(list_barang_tampung_buah[i][brgHarga]) * 0.1, floatround_floor)));
				tambahItemPlayer(playerid, id_item, -(jumlah_stack * list_barang_tampung_buah[i][brgJumlah]));

				PlayerTakesAnimation(playerid);

				new nama_item[50];
				getNamaByIdItem(id_item, nama_item);
				sendPesan(playerid, COLOR_GREEN, TAG_INFO" "WHITE"Berhasil menjual %s sebanyak "ORANGE"%d "WHITE"dengan total harga "GREEN"$%d", nama_item, jumlah_stack * list_barang_tampung_buah[i][brgJumlah], jumlah_stack * (list_barang_tampung_buah[i][brgHarga] - floatround(float(list_barang_tampung_buah[i][brgHarga]) * 0.1, floatround_floor)));
			}
			return 1;
		}		
    }
	// Wiki-SAMP OnDialogResponse should return 0
    return 0;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
 	// Ojol - klik map marker
	if(ojol_AppShow[playerid] == 1){
		DeletePreciseTimer(ojol_AppTimer[playerid]);
		ojol_AppShow[playerid] = 0;
		ojol_AppTimer[playerid] = -1;
	}
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
    }else if(playertextid == myInfo[playerid][8]){
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
		if(getStatusMinumPemain(playerid) <= 5.0 && !PlayerInfo[playerid][inDie]){
			if(random(2)){
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				ClearAnimations(playerid);
				ApplyAnimation(playerid, "PED", "IDLE_TIRED", 4.1, 0, 0, 0, 0, 0);
			}
		}else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED){
			ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff", 4.1, 0, 1, 1, 0, 0);
		}else{
			setStatusMinumPemain(playerid, getStatusMinumPemain(playerid) - 0.1);
		}
	}else if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && PRESSED(KEY_SUBMISSION)){
		new vehid = GetPlayerVehicleID(playerid);
		if(Iter_Contains(IDVehToPVehIterator, vehid)){
			new idpv = IDVehToPVeh[vehid];
			if(PVeh[idpv][pVehPemilik] != PlayerInfo[playerid][pID] && !( Iter_Contains(PVehKeys[playerid], idpv) && PVehKeysTime[playerid][idpv] > gettime() )){
				server_message(playerid, "Anda tidak memiliki kunci kendaraan ini.");
				return 1;
			}
			
			// Mesin tidak bisa dihidupkan, hanya berefek pada kendaraan berpemilik
			new Float:vehhealth;
			GetVehicleHealth(vehid, vehhealth);
			if(vehhealth <= 260.0)
				return SendClientMessage(playerid, COLOR_RED, "Kendaraan: "WHITE"Darah kendaraan habis dan rusak total.");
		}
		else if(vehid == ambulance_Veh[0] || vehid == ambulance_Veh[1]){
			if(!IsPlayerOnDutyMedic(playerid))
				return SendClientMessage(playerid, COLOR_RED, TAG_MEDIC" "WHITE"Anda tidak sedang bertugas sebagai medis.");
		}

		if(GetVehicleFuel(vehid) <= 0) 
			return SendClientMessage(playerid, COLOR_RED, TAG_BENSIN" "WHITE"Kendaraan kehabisan bensin.");

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
			MoveDynamicObject(palangToll_LSLV[0], 1745.46155, 551.11792, 26.0269, 0.0001, 0.00000, 0.00000, -18.16000);
			isTollUsed_LSLV[0] = 1;
			SetPreciseTimer("tutupToll", 3000, 0, "i", 3);
		}else if(IsPlayerInDynamicArea(playerid, areaToll_LSLV[1]) && !isTollUsed_LSLV[1]){
			// Masuk ke LV dari LS
			if(getUangPlayer(playerid) < HARGA_TOLL) {
				return sendPesan(playerid, COLOR_RED, "[TOLL] "WHITE"Uang anda tidak cukup, harga toll "GREEN"$%d", HARGA_TOLL);
			}
			givePlayerUang(playerid, -HARGA_TOLL);
			GameTextForPlayer(playerid, "~w~Silahkan ~g~lewat", 1500, 3);
			MoveDynamicObject(palangToll_LSLV[1], 1753.44653, 558.05688, 25.4069, 0.0001, 0.00000, 0.00000, -198.00000);
			isTollUsed_LSLV[1] = 1;
			SetPreciseTimer("tutupToll", 3000, 0, "i", 4);
		}else if(IsPlayerInDynamicArea(playerid, pizza_PalangArea) && !pizza_PalangUsed){
			// Masuk ke parkiran Pizzaboy LS
			GameTextForPlayer(playerid, "~w~Silahkan ~g~lewat", 1500, 3);
			MoveDynamicObject(pizza_Palang, 2106.10010, -1823.50000, 13.00000, 0.0001, 0.07700, 18.00100, 268.75101);
			pizza_PalangUsed = 1;
			SetPreciseTimer("tutupPalang", 3000, 0, "i", 0);
		}
	}else if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && PRESSED(KEY_NO) && IsPlayerInAnyDynamicArea(playerid)){
		if(GetPVarType(playerid, "last_area")){
			new areaid = GetPVarInt(playerid, "last_area");
			if(AREA_beliPerabot[0] <= areaid && areaid <= AREA_beliPerabot[sizeof(POSISI_BELI_PERABOT) - 1]){
				return showDialogBeliPerabot(playerid);
			}
			else if(AREA_pomBensin[0] <= areaid && areaid <= AREA_pomBensin[sizeof(POSISI_POM_BENSIN) - 1]){
				// Run stuff
				new Float:pos[3], Float:vpos[3], vehid = INVALID_VEHICLE_ID;
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 3.0);

				foreach(new vid : Vehicle){
					if(!IsValidVehicle(vid)) continue;
					GetVehiclePos(vid, vpos[0], vpos[1], vpos[2]);
					if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
						vehid = vid;
						break;
					}
				}

				if(vehid != INVALID_VEHICLE_ID){
					SetPVarInt(playerid, "id_vehicle_bensin", vehid);
					showDialogPilihBensin(playerid);
				}
				return 1;
			}else if(areaid == AREA_onDutyPolisi){
				if(IsPlayerPolice(playerid)){
					if(IsPlayerOnDutyPolice(playerid))
					{
						// Tampilkan Dialog konfirmasi akan OffDuty
						ShowPlayerDialog(playerid, \
							DIALOG_OFF_DUTY_POLICE, \
							DIALOG_STYLE_MSGBOX, \
							"Selesai bekerja.", \
							WHITE"Apakah anda yakin ingin selesai bekerja sebagai polisi pada shift kali ini?\n", "Pilih", "Batal");
					}else if(IsPlayerIsNotInAnyDuty(playerid)){
						// Tampilkan Dialog konfirmasi akan OnDuty
						new temp_judul[50],
							string_skin_polisi[100] = "",
							len = 0;

						PlayerInfo[playerid][skinDuty] = 0;

						if(IsPlayerPria(playerid)){
							// Ambil Skill Pria
							len = GetBanyakSkinMalePoliceByLevel(GetPlayerPoliceLevel(playerid));
							for (new i = 0; i < len; i++) {
								strcatEx(string_skin_polisi, sizeof(string_skin_polisi), "%i\n", GetMaleSkinPoliceByLevel(GetPlayerPoliceLevel(playerid))[i]);
							}

							if(len == 0){ // Jika tidak memiliki skin juga maka langsung ke dialog konfirmasi saja
								format(pDialog[playerid], sizePDialog, \
									WHITE"Anda akan menjadi bekerja sebagai anggota kepolisian dengan pangkat "YELLOW"%s\n\
									"WHITE"Anda akan diberi akses untuk melakukan hal-hal yang dapat dilakukan oleh anggota kepolisian sesuai dengan pangkat anda.\n"GREY"Jika anda membutukan guide tentang menjadi anggota polisi yang baik, anda dapat membaca pada artikel yang tersedia.\n\n"YELLOW"Apakah anda ingin mulai bekerja?", GetNamaLevelPolice(GetPlayerPoliceLevel(playerid)));
								return ShowPlayerDialog(playerid, DIALOG_ON_DUTY_POLICE_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Mulai bekerja:", pDialog[playerid], "Mulai", "Batal");
							}
						}else{ // Jika Player Perempuan
							len = GetBanyakSkinFemalePoliceByLevel(GetPlayerPoliceLevel(playerid));
							for (new i = 0; i < len; i++) {
								strcatEx(string_skin_polisi, sizeof(string_skin_polisi), "%i\n", GetFemaleSkinPoliceByLevel(GetPlayerPoliceLevel(playerid))[i]);
							}

							if(len == 0){
								// Ambil Skill Pria
								len = GetBanyakSkinMalePoliceByLevel(GetPlayerPoliceLevel(playerid));
								for (new i = 0; i < len; i++) {
									strcatEx(string_skin_polisi, sizeof(string_skin_polisi), "%i\n", GetMaleSkinPoliceByLevel(GetPlayerPoliceLevel(playerid))[i]);
								}

								if(len == 0){ // Jika tidak memiliki skin juga maka langsung ke dialog konfirmasi saja
									format(pDialog[playerid], sizePDialog, \
										WHITE"Anda akan menjadi bekerja sebagai anggota kepolisian dengan pangkat "YELLOW"%s\n\
										"WHITE"Anda akan diberi akses untuk melakukan hal-hal yang dapat dilakukan oleh anggota kepolisian sesuai dengan pangkat anda.\n"GREY"Jika anda membutukan guide tentang menjadi anggota polisi yang baik, anda dapat membaca pada artikel yang tersedia.\n\n"YELLOW"Apakah anda ingin mulai bekerja?", GetNamaLevelPolice(GetPlayerPoliceLevel(playerid)));
									return ShowPlayerDialog(playerid, DIALOG_ON_DUTY_POLICE_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Mulai bekerja:", pDialog[playerid], "Mulai", "Batal");
								}
							}
						}

						format(temp_judul, sizeof(temp_judul), YELLOW"Pilih skin %s yang ingin digunakan:", GetNamaLevelPolice(GetPlayerPoliceLevel(playerid)));

						ShowPlayerDialog(playerid, 
							DIALOG_ON_DUTY_POLICE_PILIH_SKIN, 
							DIALOG_STYLE_PREVIEW_MODEL,
							temp_judul, string_skin_polisi, "Pilih", "Batal");
					}else
						server_message(playerid, "Anda sedang menjalan tugas lain sekarang.");
				}else
					server_message(playerid, "Anda bukan pegawai kantor polisi ini.");
				return 1;
			}else if(areaid == AREA_onDutyMedic){
				if(IsPlayerMedic(playerid)){
					if(IsPlayerOnDutyMedic(playerid))
					{
						// Tampilkan Dialog konfirmasi akan OffDuty
						ShowPlayerDialog(playerid, \
							DIALOG_OFF_DUTY_MEDIC, \
							DIALOG_STYLE_MSGBOX, \
							"Selesai bekerja.", \
							WHITE"Apakah anda yakin ingin selesai bekerja sebagai medis pada shift kali ini?\n", "Pilih", "Batal");
					}else if(IsPlayerIsNotInAnyDuty(playerid)){ // Cek Jika dia tidak dalam duty polisi ataupun yang lain
						// Tampilkan Dialog konfirmasi akan OnDuty
						new temp_judul[50],
							string_skin_medis[100] = "",
							len = 0;

						PlayerInfo[playerid][skinDuty] = 0;

						if(IsPlayerPria(playerid)){
							// Ambil Skill Pria
							len = GetBanyakSkinMaleMedicByLevel(GetPlayerMedicLevel(playerid));
							for (new i = 0; i < len; i++) {
								strcatEx(string_skin_medis, sizeof(string_skin_medis), "%i\n", GetMaleSkinMedicByLevel(GetPlayerMedicLevel(playerid))[i]);
							}

							if(len == 0){ // Jika tidak memiliki skin juga maka langsung ke dialog konfirmasi saja
								format(pDialog[playerid], sizePDialog, \
									WHITE"Anda akan menjadi bekerja sebagai anggota medis dengan pangkat "YELLOW"%s\n\
									"WHITE"Anda akan diberi akses untuk melakukan hal-hal yang dapat dilakukan oleh anggota medis sesuai dengan pangkat anda.\n"GREY"Jika anda membutukan guide tentang menjadi anggota medis yang benar, anda dapat membaca pada artikel yang tersedia.\n\n"YELLOW"Apakah anda ingin mulai bekerja?", GetNamaLevelMedic(GetPlayerMedicLevel(playerid)));
								return ShowPlayerDialog(playerid, DIALOG_ON_DUTY_MEDIC_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Mulai bekerja:", pDialog[playerid], "Mulai", "Batal");
							}
						}else{ // Jika Player Perempuan
							len = GetBanyakSkinFemaleMedicByLevel(GetPlayerMedicLevel(playerid));
							for (new i = 0; i < len; i++) {
								strcatEx(string_skin_medis, sizeof(string_skin_medis), "%i\n", GetFemaleSkinMedicByLevel(GetPlayerMedicLevel(playerid))[i]);
							}

							if(len == 0){
								// Ambil Skill Pria
								len = GetBanyakSkinMaleMedicByLevel(GetPlayerMedicLevel(playerid));
								for (new i = 0; i < len; i++) {
									strcatEx(string_skin_medis, sizeof(string_skin_medis), "%i\n", GetMaleSkinMedicByLevel(GetPlayerMedicLevel(playerid))[i]);
								}

								if(len == 0){ // Jika tidak memiliki skin juga maka langsung ke dialog konfirmasi saja
									format(pDialog[playerid], sizePDialog, \
										WHITE"Anda akan menjadi bekerja sebagai anggota medis dengan pangkat "YELLOW"%s\n\
										"WHITE"Anda akan diberi akses untuk melakukan hal-hal yang dapat dilakukan oleh anggota medis sesuai dengan pangkat anda.\n"GREY"Jika anda membutukan guide tentang menjadi anggota medis yang benar, anda dapat membaca pada artikel yang tersedia.\n\n"YELLOW"Apakah anda ingin mulai bekerja?", GetNamaLevelMedic(GetPlayerMedicLevel(playerid)));
									return ShowPlayerDialog(playerid, DIALOG_ON_DUTY_MEDIC_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Mulai bekerja:", pDialog[playerid], "Mulai", "Batal");
								}
							}
						}

						format(temp_judul, sizeof(temp_judul), YELLOW"Pilih skin %s yang ingin digunakan:", GetNamaLevelMedic(GetPlayerMedicLevel(playerid)));

						ShowPlayerDialog(playerid, 
							DIALOG_ON_DUTY_MEDIC_PILIH_SKIN, 
							DIALOG_STYLE_PREVIEW_MODEL,
							temp_judul, string_skin_medis, "Pilih", "Batal");				
					}else
						server_message(playerid, "Anda sedang menjalan tugas lain sekarang.");
				}else
					server_message(playerid, "Anda bukan pegawai rumah sakit ini.");
				return 1;
			}else if(areaid == AREA_GuidePemerintah){
				showDialogGuideKantorPemerintah(playerid);
				return 1;
			}else if(areaid == AREA_GuideAhliMekanik){
				showDialogGuideAhliMekanik(playerid);
				return 1;
			}else if(areaid >= AREA_spawnReparasi[0] && areaid <= AREA_spawnReparasi[sizeof(AREA_spawnReparasi) - 1]){
				if(!IsPlayerInAnyVehicle(playerid)){
					showDialogAmbilMobilReparasi(playerid);
				}
			}else if(areaid == AREA_Guide_peralatanPancing || /*areaid == AREA_Guide_tokoBibit ||*/
					areaid == AREA_Guide_tokoGadget || areaid == AREA_Guide_penjualDealer ||
					areaid == AREA_GuideAhliBlacksmith){
				showDialogGuideText(playerid);
				return 1;
			}
		}
	}else if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && PRESSED(KEY_NO)){
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -516.3520, 294.1110, 2001.0859)){
			return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Ramalan cuaca", weather_string, "Tutup", "");
		}

		if(lastHousePickup[playerid] < 0 || lastHousePickup[playerid] >= MAX_HOUSES) return 1;
		new id,
			Float:x,
			Float:y,
			Float:z;
		id = houseId[lastHousePickup[playerid]];
		if(id == -1) return 1; // Return jika invalid house id
		x = houseInfo[id][icon_x];
		y = houseInfo[id][icon_y];
		z = houseInfo[id][icon_z];
		if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) {
			new id_level = houseInfo[id][hLevel];
			if(houseInfo[id][hKunci] != 1){
				PlayerInfo[playerid][inHouse] = id;
				
				pindahkanPemain(playerid, HouseLevel[id_level][intSpawn][0], HouseLevel[id_level][intSpawn][1], HouseLevel[id_level][intSpawn][2], HouseLevel[id_level][intSpawn][3], HouseLevel[id_level][intSpawnInterior], id);
				SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "YELLOW"Anda berhasil masuk rumah!");
			}else{
				if(houseInfo[id][hOwner] == PlayerInfo[playerid][pID]){
					PlayerInfo[playerid][inHouse] = id;
					pindahkanPemain(playerid, HouseLevel[id_level][intSpawn][0], HouseLevel[id_level][intSpawn][1], HouseLevel[id_level][intSpawn][2], HouseLevel[id_level][intSpawn][3], HouseLevel[id_level][intSpawnInterior], id);
					SendClientMessage(playerid, COLOR_YELLOW, "Rumah: "WHITE"Ketik "YELLOW"/house "WHITE"untuk mengelola inventory & furniture rumah.");
				}else{
					SendClientMessage(playerid, COLOR_GREEN, TAG_RUMAH" "RED"Maaf rumah terkunci dan tidak dapat masuk!");
				}
			}
		}
		return 1;
	}else if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && PRESSED(KEY_YES)){
		// ATM
		new idatm = GetClosestATM(playerid);
		if(idatm != -1) return showDialogATM(playerid);
		// Nombak Ikan
		new Float:depth, Float:depth2;
		if(CA_IsPlayerInWater(playerid, depth, depth2)){
			if(PlayerInfo[playerid][sisaTombak] > 0 && depth2 > 2.0){ // Minimal kedalaman > 2
				if(GetSlotInventoryPlayer(playerid) + 1 > PlayerInfo[playerid][limitItem]){
					return showDialogPesan(playerid, RED"Inventory anda penuh", WHITE"Silahkan sisakan minimal 1 slot item anda terlebih dahulu.\nPengosongan berguna untuk menyisakan tempat untuk hasil yang didapat nantinya.");
				}

				if(IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda harus keluar dari dalam kendaraan.");
				if(nombakDelay[playerid] < gettime()){
					nombakDelay[playerid] = gettime() + 10;
					nombakDepth[playerid] = depth2;
					// Achievement berlaut
					PlayerInfo[playerid][ach_Berlaut]++;
					randomIkan(playerid);
				}else{
					error_command(playerid, "Tunggu beberapa detik untuk dapat menombak ikan.");
				}
			}
		}
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
		PreloadAnimLib(playerid,"CAR");
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
		PreloadAnimLib(playerid,"SPRAYCAN");
		PreloadAnimLib(playerid,"MEDIC");
		PreloadAnimLib(playerid,"CAR_CHAT");
		PreloadAnimLib(playerid,"CASINO");
		PlayerInfo[playerid][preloadAnim] = 1;
	}

	houseNotif[playerid] = -1;

	// Tambang
	if(IsPlayerAttachedObjectSlotUsed(playerid, MINING_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, MINING_ATTACH_INDEX);
	DeletePreciseTimer(PlayerAction[playerid][timerNambang]);
	PlayerAction[playerid][sedangNambang] = false;
	// Mancing
	if(PlayerInfo[playerid][sisaTombak] > 0){
		if(!IsPlayerAttachedObjectSlotUsed(playerid, TOMBAK_ATTACH_INDEX)) SetPlayerAttachedObject(playerid, TOMBAK_ATTACH_INDEX, 11716, 6, 0.048, 0.029, 0.103, -80.0, 80.0, 0.0);
	}else{
		if(IsPlayerAttachedObjectSlotUsed(playerid, TOMBAK_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, TOMBAK_ATTACH_INDEX);
	}
	
	PlayerInfo[playerid][onSelectedTextdraw] = false;

	spawnPemain(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerDeath terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif

	// PlayerInfo[playerid][inHouse] = 0;
	PlayerInfo[playerid][sudahSpawn] = false;

	SetPlayerDutyMedic(playerid, 0);
	SetPlayerDutyPolice(playerid, 0);
	ResetPlayerWeapons(playerid);

	/*
	 * Hilangkan Mask jika sedang terpakai
	 */
	if(PlayerInfo[playerid][isOnMask]){
		PlayerInfo[playerid][isOnMask] = 0;
		if(PlayerInfo[playerid][tidak_dikenali] != 0)
			Iter_Remove(TidakDikenali, PlayerInfo[playerid][tidak_dikenali]);
		PlayerInfo[playerid][tidak_dikenali] = 0;
		mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET on_mask = 0 WHERE id = %d", PlayerInfo[playerid][pID]);
		mysql_tquery(koneksi, pQuery[playerid]);

		if(IsPlayerAttachedObjectSlotUsed(playerid, MASK_ATTACH_INDEX))
			RemovePlayerAttachedObject(playerid, MASK_ATTACH_INDEX);
	}

	PlayerInfo[playerid][inDie] = 1; // Supaya langsung teleport ke rumah sakit
	// GetPlayerPos(playerid, PlayerInfo[playerid][last_x], PlayerInfo[playerid][last_y], PlayerInfo[playerid][last_z]);
	// GetPlayerFacingAngle(playerid, PlayerInfo[playerid][last_a]);
	// PlayerInfo[playerid][last_int] = GetPlayerInterior(playerid); 
	// PlayerInfo[playerid][last_vw] = GetPlayerVirtualWorld(playerid);
	onPlayerDeath_Alt(playerid);

	hideHUDStats(playerid);

	// Reset Tampilan
	PlayerInfo[playerid][photoMode] = false;
	hidePhotoMode(playerid);

	new random_spawn = random(sizeof(SPAWN_POINT));
	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], SPAWN_POINT[random_spawn][SPAWN_POINT_X], SPAWN_POINT[random_spawn][SPAWN_POINT_Y], SPAWN_POINT[random_spawn][SPAWN_POINT_Z], SPAWN_POINT[random_spawn][SPAWN_POINT_A], 0, 0, 0, 0, 0, 0);

	if(IsPlayerInAnyVehicle(playerid)){
		new vehicleid = GetPlayerVehicleID(playerid);
		if(Iter_Contains(IDVehToPVehIterator, vehicleid)){
			new Float:darah;
			GetVehicleHealth(vehicleid, darah);

			if(darah > 300.0)
			{
				new idpv = IDVehToPVeh[vehicleid];
				GetVehiclePos(vehicleid, PVeh[idpv][pVehCoord][0], PVeh[idpv][pVehCoord][1], PVeh[idpv][pVehCoord][2]);
				GetVehicleZAngle(vehicleid, PVeh[idpv][pVehCoord][3]);
				PVeh[idpv][pVehDarah] = darah;
				UpdatePosisiDarahVehiclePlayer(vehicleid);
			}
		}
		if(Iter_Contains(RentPlayerVehIter, RentPlayerVehID[vehicleid])){
			new Float:darah;
			GetVehicleHealth(vehicleid, darah);
			if(darah > 300.0)
			{
				saveRentPlayerVeh(playerid);
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
	if(PlayerInfo[playerid][sudahLogin]) {
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
main() {}

public OnGameModeInit()
{	
	// Initializing map andreas
	CA_Init();

	ManualVehicleEngineAndLights();

	// Initializing iterator
	Iter_Init(PVehKeys);
	Iter_Add(ATMs, 0);
	Iter_Add(TidakDikenali, 0);
	Iter_Clear(RentPlayerVehIter);

	koneksi = mysql_connect_file();
	errno = mysql_errno(koneksi);
	mysql_log(); // Buat mysql log
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

	printf("[ITEM RARITY] Load semua item rarity...");
	loadAllRarity();
	printf("[ITEM RARITY] Sukses load item rarity!");

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
	
	printf("[LUMBERJACK] Load semua pohon");
	loadAllTree();
	printf("[LUMBERJACK] Sukses load semua pohon.");

	printf("[LUMBERJACK] Load semua ATM");
	LoadSemuaATM();
	printf("[LUMBERJACK] Sukses load ATM.");

	buatTokoNarko();
	printf("[NARKO] Narko telah dibuat.");

	printf("[ACTOR] Load semua Actor");
	loadAllActor();
	printf("[ACTOR] Sukses load Actor.");
	
	printf("[TEXTDRAW] Load textdraw global..");
	loadTextdrawGlobal();
	printf("[TEXTDRAW] Sukses load textdraw!");

	printf("[VEHICLE RENT] Load tempat penyewaan..");
	loadAllRentVehPlace();
	printf("[VEHICLE RENT] Sukses load tempat penyewaan!");

	printf("[VEHICLE RENT] Load kendaraan sewa..");
	loadAllRentVeh();
	printf("[VEHICLE RENT] Sukses load kendaraan sewa!");

	// Setting up Game mode
	SetGameModeText(NAMA_GAMEMODE);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	ShowNameTags(1);
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();

	for(new i = 0; i < sizeof(VehicleItemLimit); i++){
		VehicleItemLimit[i] = 0;
	}

	// Load Vehicle Limit
	for(new i = 0; i < sizeof(VehicleLuggageLimit); i++){
		VehicleItemLimit[VehicleLuggageLimit[i][lvModel] - 400] = VehicleLuggageLimit[i][lvLimit];
	}
	
	BlockGarages(.text="DITUTUP");

	// weapon-config
    SetVehiclePassengerDamage(true);
    SetDisableSyncBugs(true);	
	SetCbugAllowed(false);

	/**
		Weather Init
	 */
	new rand;
	for(new i = 0; i < sizeof(seq_weather); i++){
		rand = random(100) + 1;
		if(rand <= 65)
			seq_weather[i] = fine_weather_ids[random(sizeof(fine_weather_ids))];
		else if(rand <= 90)
			seq_weather[i] = ID_WEATHER_RAIN;
		else
			seq_weather[i] = foggy_weather_ids[random(sizeof(foggy_weather_ids))];
	}
	gantiCuaca(100);

	worldTimer = SetPreciseTimer("updateWorldTime", 1000, true);

	#if defined LOAD_VEHICLE_FROM_FILES
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
	#endif

    // Sweeper Vehicle
    vehicleSweeper[0] = CreateVehicle(574, 708.4822, -1193.1827, 15.0324, 0.0000, -1, -1, TIME_SWEEPER*60000);
	vehicleSweeper[1] = CreateVehicle(574, 706.6257, -1196.5216, 14.9840, 0.0000, -1, -1, TIME_SWEEPER*60000);
	vehicleSweeper[2] = CreateVehicle(574, 704.5869, -1199.6705, 14.9557, 0.0000, -1, -1, TIME_SWEEPER*60000);
	Iter_Add(vehicleSweeper, vehicleSweeper[0]);
	Iter_Add(vehicleSweeper, vehicleSweeper[1]);
	Iter_Add(vehicleSweeper, vehicleSweeper[2]);

	// Trashmaster Vehicle
    trashM_Veh[0] = CreateVehicle(408, 1617.6511, -1554.3311, 13.4784, 0.0000, -1, -1, TIME_TRASHMASTER*60000);
	trashM_Veh[1] = CreateVehicle(408, 1607.9219, -1554.7930, 13.4762, 0.0000, -1, -1, TIME_TRASHMASTER*60000);
	trashM_Veh[2] = CreateVehicle(408, 1597.0359, -1554.9255, 13.4827, 0.0000, -1, -1, TIME_TRASHMASTER*60000);
	Iter_Add(trashM_Veh, trashM_Veh[0]);
	Iter_Add(trashM_Veh, trashM_Veh[1]);
	Iter_Add(trashM_Veh, trashM_Veh[2]);

	// Ambulance Rumah sakit
	ambulance_Veh[0] = AddStaticVehicleEx(416, 1177.6633, -1308.5510, 14.0078, 268.5052, 1, 3, -1, 1);
	ambulance_Veh[1] = AddStaticVehicleEx(416, 1179.5927, -1338.8085, 13.9587, 271.2625, 1, 3, -1, 1);

	SetVehicleParams(ambulance_Veh[0], VEHICLE_TYPE_ENGINE, 0);
	SetVehicleParams(ambulance_Veh[0], VEHICLE_TYPE_LIGHTS, 0);

	SetVehicleParams(ambulance_Veh[1], VEHICLE_TYPE_ENGINE, 0);
	SetVehicleParams(ambulance_Veh[1], VEHICLE_TYPE_LIGHTS, 0);

	ToggleVehicleFuel(ambulance_Veh[0], 0);
	ToggleVehicleFuel(ambulance_Veh[1], 0);

	// Pizzaboy Vehicle
	CreateDynamic3DTextLabel("Tempat Restok Pizza\n"GREEN"Pengantar Pizza (Pizzaboy)", COLOR_WHITE, 2105.00439, -1808.99744, 13.66980, 20.0);
    pizza_Veh[0] = CreateVehicle(448, 2125.2305, -1819.5576, 13.1988, 0.0000, -1, -1, TIME_PIZZABOY*60000);
	pizza_Veh[1] = CreateVehicle(448, 2125.2546, -1817.6587, 13.1990, 0.0000, -1, -1, TIME_PIZZABOY*60000);
	pizza_Veh[2] = CreateVehicle(448, 2125.2192, -1815.8719, 13.1992, 0.0000, -1, -1, TIME_PIZZABOY*60000);
	Iter_Add(pizza_Veh, pizza_Veh[0]);
	Iter_Add(pizza_Veh, pizza_Veh[1]);
	Iter_Add(pizza_Veh, pizza_Veh[2]);

	// SIM Vehicle
	vehicleSIM[0] = CreateVehicle(410, 1362.7140, -1651.1733, 13.1261, 270.3739, -1, -1, TIME_SIMPRAKTIK*60000);
	vehicleSIM[1] = CreateVehicle(414, 1362.9814, -1643.2692, 13.1263, 269.2806, -1, -1, TIME_SIMPRAKTIK*60000);
	vehicleSIM[2] = CreateVehicle(462, 1362.8998, -1635.5781, 13.1262, 269.8343, -1, -1, TIME_SIMPRAKTIK*60000);
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
	unloadAllRentVeh();
	unloadAllRentVehPlace();
	DeletePreciseTimer(worldTimer);
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
	new const vehid = GetPlayerVehicleID(playerid);	
	/*
	 *	Stating entering vehicle or exiting vehicle
	 */
	if(oldstate == PLAYER_STATE_ONFOOT && (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)){
		// Stuff need to be executed 
		PlayerTextDrawSetString(playerid, SpeedoTD_VehInfo[playerid][0], GetVehicleModelName(GetVehicleModel(vehid)));
		ShowSpeedoForPlayer(playerid, vehid);

		if(PlayerInfo[playerid][inSpectate]){
			foreach(new i : Player){
				if(PlayerInfo[i][inSpectating] == playerid)
					SpectatePlayer(i, playerid);
			}
		}

		// Filtering state and condition
		if(newstate == PLAYER_STATE_DRIVER && Iter_Contains(DVehIterator, vehid)){
			format(pDialog[playerid], sizePDialog, CYAN"*********************************************************************************\n\n", pDialog[playerid]);
			format(pDialog[playerid], sizePDialog, "%s"ORANGE"Kendaraan ini dijual dengan informasi sebagai berikut :\n\n", pDialog[playerid]);
			format(pDialog[playerid], sizePDialog, "%s"PURPLE"Nama Kendaraan: "WHITE"%s\n", pDialog[playerid], GetVehicleModelName(DVeh[vehid][dVehModel]));
			format(pDialog[playerid], sizePDialog, "%sHarga: "GREEN"$%d\n\n", pDialog[playerid], DVeh[vehid][dVehHarga]);
			format(pDialog[playerid], sizePDialog, "%s"YELLOW"Anda ingin membeli kendaraan ini ?\n\n"CYAN"*********************************************************************************\n", pDialog[playerid]);
			ShowPlayerDialog(playerid, DIALOG_BELI_KENDARAAN_DEALER, DIALOG_STYLE_MSGBOX, "Kendaraan ini dijual.", pDialog[playerid], GREEN"Beli", GREY"Tidak");
		}else if(newstate == PLAYER_STATE_PASSENGER && Iter_Contains(DVehIterator, vehid)){
			error_command(playerid, "Tidak dapat menumpangi kendaraan yang sedang dijual.");
			RemovePlayerFromVehicle(playerid);
		}else if(Iter_Contains(vehicleSIM, vehid)){
			if(testSim[playerid] == 1 && vehicleIdSIM[playerid] == vehid){
				DeletePreciseTimer(todoTimer[playerid]);
			}else if(testSim[playerid] == 1 && vehicleIdSIM[playerid] != vehid){
				error_command(playerid, "Anda salah menaiki kendaaraan, silahkan kembali ke kendaraan sebelumnya.");
				RemovePlayerFromVehicleEx(playerid);
			}else if(testSim[playerid] == 0){
				error_command(playerid, "Tidak dapat menumpangi kendaraan untuk Ujian Praktik SIM.");
				RemovePlayerFromVehicleEx(playerid);
			}
		}else if(Iter_Contains(vehicleSweeper, vehid)){
			if(sweeperJob[playerid] == 0 && usedSweeper[vehid] != 1){
				ShowPlayerDialog(playerid, DIALOG_JOB_SWEEPER, DIALOG_STYLE_MSGBOX, "Sweeper Job", WHITE"Apakah anda ingin bekerja sebagai "GREEN"Sweeper"WHITE"? Jika anda ingin bekerja klik "GREEN"Setuju"WHITE" untuk memulai.", "Setuju", "Batal");
			}else if(sweeperJob[playerid] == 1 && sweeperId[playerid] == vehid){
				DeletePreciseTimer(todoTimer[playerid]);
			}else if(sweeperJob[playerid] == 1 && sweeperId[playerid] != vehid){
				error_command(playerid, "Anda salah menaiki kendaaraan, silahkan kembali ke kendaraan sebelumnya.");
				RemovePlayerFromVehicle(playerid);
			}else if(sweeperJob[playerid] == 0 && usedSweeper[vehid] == 1){
				error_command(playerid, "Tidak dapat menumpangi kendaraan yang sedang melakukan pekerjaan Sweeper.");
				RemovePlayerFromVehicle(playerid);
			}
		}else if(Iter_Contains(trashM_Veh, vehid)){
			if(trashM_Job[playerid] == 0 && trashM_Used[vehid] != 1){
				ShowPlayerDialog(playerid, DIALOG_JOB_TRASHMASTER_ENTER, DIALOG_STYLE_MSGBOX, "Trashmaster Job", WHITE"Apakah anda ingin bekerja sebagai "GREEN"Trashmaster"WHITE"? Jika anda ingin bekerja klik "GREEN"Setuju"WHITE" untuk memulai.", "Setuju", "Batal");
			}else if(trashM_Job[playerid] == 1 && trashM_Id[playerid] == vehid){
				DeletePreciseTimer(todoTimer[playerid]);
			}else if(trashM_Job[playerid] == 1 && trashM_Id[playerid] != vehid){
				error_command(playerid, "Anda salah menaiki kendaaraan, silahkan kembali ke kendaraan sebelumnya.");
				RemovePlayerFromVehicle(playerid);
			}else if(trashM_Job[playerid] == 0 && trashM_Used[vehid] == 1){
				error_command(playerid, "Tidak dapat menumpangi kendaraan yang sedang melakukan pekerjaan Sweeper.");
				RemovePlayerFromVehicle(playerid);
			}
		}else if(Iter_Contains(pizza_Veh, vehid)){
			if(pizza_Job[playerid] == 0 && pizza_Used[vehid] != 1){
				ShowPlayerDialog(playerid, DIALOG_JOB_PIZZABOY_ENTER, DIALOG_STYLE_MSGBOX, "Pizzaboy Job", WHITE"Apakah anda ingin bekerja sebagai "GREEN"Pizzaboy"WHITE"? Jika anda ingin bekerja klik "GREEN"Setuju"WHITE" untuk memulai.", "Setuju", "Batal");
			}else if(pizza_Job[playerid] == 1 && pizza_Id[playerid] == vehid){
				DeletePreciseTimer(todoTimer[playerid]);
			}else if(pizza_Job[playerid] == 1 && pizza_Id[playerid] != vehid){
				error_command(playerid, "Anda salah menaiki kendaaraan, silahkan kembali ke kendaraan sebelumnya.");
				RemovePlayerFromVehicle(playerid);
			}else if(pizza_Job[playerid] == 0 && pizza_Used[vehid] == 1){
				error_command(playerid, "Tidak dapat menumpangi kendaraan yang sedang melakukan pekerjaan Sweeper.");
				RemovePlayerFromVehicle(playerid);
			}
		}else if(Iter_Contains(RentVehIterator, RentVehID[vehid])){
			new placeid = ClosestRentVehPlace(playerid);
			if(placeid != -1){
				if(RentPlace[placeid][rentPlaceFree] == 1){
					if(gettime() > RentPlace[placeid][rentPlaceFreeDurasi]){
						RentPlace[placeid][rentPlaceFree] = 0;
						RentPlace[placeid][rentPlaceFreeDurasi] = 0;
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE vehicle_rent_place SET durasi_gratis = 0 WHERE id = %d", placeid);
						mysql_tquery(koneksi, pQuery[playerid]);
						reloadRentVehPlaceLabel(placeid);
						RemovePlayerFromVehicle(playerid);
					}
				}
			}
			if(GetLevelAdminPlayer(playerid) == 2 && RentVehEdit[playerid] == 1) return 1;
			if(RentPlayerVehID[vehid] == -1){
				ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE, DIALOG_STYLE_MSGBOX, "Penyewaan Kendaraan", WHITE"Apakah anda ingin menyewa kendaraan ini? Jika anda ingin silahkan klik "GREEN"Sewa"WHITE" untuk melanjutkan.", "Sewa", "Batal");
			}else{
				error_command(playerid, "Anda sudah memiliki kendaraan sewa dan tidak dapat menyewa lagi.");
				RemovePlayerFromVehicle(playerid);
			}
		}else if(Iter_Contains(RentPlayerVehIter, RentPlayerVehID[vehid])){
			if(newstate == PLAYER_STATE_DRIVER){
				if(RentPlayerVehUser[playerid] != vehid){
					error_command(playerid, "Anda tidak dapat menaiki kendaraan yang sedang disewa.");
					RemovePlayerFromVehicle(playerid);
				}else{
					new rentid = RentPlayerVehID[vehid];
					if(gettime() > RentPlayerVeh[rentid][rentPlayerVehTime]){
						if(Iter_Contains(RentPlayerVehIter, rentid)){
							if(RentPlayerVehUser[playerid] == vehid){
								unloadRentPlayerVeh(playerid, 1);
							}
						}
					}
				}
			}
		}
	}else if((oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) && newstate == PLAYER_STATE_ONFOOT){
		if(PlayerInfo[playerid][inSpectate]){
			foreach(new i : Player){
				if(PlayerInfo[i][inSpectating] == playerid)
					SpectatePlayer(i, playerid);
			}
		}
		HideSpeedoForPlayer(playerid);
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(Iter_Contains(vehicleSweeper, vehicleid) && sweeperJob[playerid] == 1 && sweeperId[playerid] == vehicleid){
		SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "RED"Anda keluar dari kendaraan, silahkan kembali bekerja! "WHITE"Sebelum 30 detik atau anda berhenti bekerja.");
		todoTimer[playerid] = SetPreciseTimer("resetPlayerToDo", 30000, false, "i", playerid);
	}else if(Iter_Contains(trashM_Veh, vehicleid) && trashM_Job[playerid] == 1 && trashM_Id[playerid] == vehicleid){
		SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "RED"Silahkan lakukan pekerjaan dengan benar! "WHITE"Sebelum 5 menit atau anda berhenti bekerja.");
		todoTimer[playerid] = SetPreciseTimer("resetPlayerToDo", 5*60000, false, "i", playerid);
	}else if(Iter_Contains(pizza_Veh, vehicleid) && pizza_Job[playerid] == 1 && pizza_Id[playerid] == vehicleid){
		SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "RED"Silahkan lakukan pekerjaan dengan benar! "WHITE"Sebelum 1 menit atau anda berhenti bekerja.");
		todoTimer[playerid] = SetPreciseTimer("resetPlayerToDo", 1*60000, false, "i", playerid);
	}else if(Iter_Contains(vehicleSIM, vehicleid) && testSim[playerid] == 1 && vehicleIdSIM[playerid] == vehicleid){
		SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "RED"Anda keluar dari kendaraan, silahkan kembali praktik! "WHITE"Sebelum 30 detik atau anda gagal Ujian Praktik SIM.");
		todoTimer[playerid] = SetPreciseTimer("resetPlayerToDo", 30000, false, "i", playerid);
	}else if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){ // Jika player baru saja keluar dari mengemudi
		if(Iter_Contains(IDVehToPVehIterator, vehicleid)){ // Jika kendaraan adalah kendaraan berpemilik
			new Float:darah;
			GetVehicleHealth(vehicleid, darah);

			if(!IsVehicleFlipped(vehicleid) && darah > 251) // kendaraan tidak terbalik dan kendaraan tidak berasap parah
			{
				new idpv = IDVehToPVeh[vehicleid];
				GetVehiclePos(vehicleid, PVeh[idpv][pVehCoord][0], PVeh[idpv][pVehCoord][1], PVeh[idpv][pVehCoord][2]);
				GetVehicleZAngle(vehicleid, PVeh[idpv][pVehCoord][3]);
				PVeh[idpv][pVehDarah] = darah;
				UpdatePosisiDarahVehiclePlayer(vehicleid);
			}
		}
		if(Iter_Contains(RentPlayerVehIter, RentPlayerVehID[vehicleid])){
			new Float:darah;
			GetVehicleHealth(vehicleid, darah);
			if(!IsVehicleFlipped(vehicleid) && darah > 251) // kendaraan tidak terbalik dan kendaraan tidak berasap parah
			{
				saveRentPlayerVeh(playerid);
			}
		}
	}
    return 1;
}

public OnPlayerText(playerid, text[]){
	if(PlayerInfo[playerid][isOnMask]){
		switch(PlayerInfo[playerid][isOnMask]){
			case ID_ITEM_HELM:
				format(msg,sizeof(msg), "Helm#%d: %s", PlayerInfo[playerid][tidak_dikenali], text);
			case ID_ITEM_MASK:
				format(msg,sizeof(msg), "Topeng#%d: %s", PlayerInfo[playerid][tidak_dikenali], text);
			default:
				format(msg,sizeof(msg), "Tidak dikenali#%d: %s", PlayerInfo[playerid][tidak_dikenali], text);
		}
	}
	else
		format(msg,sizeof(msg), "%s: %s", PlayerInfo[playerid][pPlayerName], text);

	ProxDetector(30.0, playerid, msg, COLOR_WHITE);
	format(msg,sizeof(msg), "berkata: %s", text);
	SetPlayerChatBubble(playerid, msg, -1, 40.0, 5000);

	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !PlayerInfo[playerid][isOnAnimation] && !PlayerInfo[playerid][inDie]) PlayerTalking(playerid);

	/**
		Filter Actor
	 */
	if(IsPlayerInAnyDynamicArea(playerid)){
		// GetPVarType untuk cek apakah ada atau tidak
		if(GetPVarType(playerid, "last_area")){
			new areaid = GetPVarInt(playerid, "last_area");
			if(areaid == ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actArea]){ // Cek Jika berada pada area actor
				if(ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_PEMERINTAH".*")){
						ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actUser] = playerid;
						ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_PEMERINTAH, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membuat|buat|bikin|membikin)\\sktp.*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid,DIALOG_RESEPSIONIS_PILIH_KTP, 1, 0, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(ambil|mengambil)\\sktp.*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid,DIALOG_RESEPSIONIS_PILIH_KTP, 1, 1, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membuat|buat|bikin|membikin)\\snomor\\shp.*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid,DIALOG_RESEPSIONIS_PEMERINTAH, 1, 1, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(memperpanjang|perpanjang|menambah|nambah|tambah)\\smasa\\saktif\\snomor.*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid,DIALOG_RESEPSIONIS_PEMERINTAH, 1, 2, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_RESEPSIONIS_PEMERINTAH][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_SKILL_MEKANIK][actArea]){ // Cek Jika berada pada area actor
				if(ACT_NPC[ACTOR_SKILL_MEKANIK][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_SKILL_MEKANIK".*")){
						ACT_NPC[ACTOR_SKILL_MEKANIK][actUser] = playerid;
						ACT_NPC[ACTOR_SKILL_MEKANIK][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_SKILL_MEKANIK][actID]);
						format(pDialog[playerid], sizePDialog, "Hey %s!\nApa yang kamu perlukan disini?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_SKILL_MEKANIK][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Hey %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_SKILL_MEKANIK, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("bro")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_SKILL_MEKANIK][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_SKILL_MEKANIK][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_SKILL_MEKANIK][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(mengambil|ambil|mengaktifkan|aktifkan)\\sskill\\smekanik.*")){
							if(PlayerInfo[playerid][activeMekanik]){
								format(pDialog[playerid], sizePDialog, "%s kamu telah mengaktifkan skill mekanik\nKamu hanya dapat mengaktifkan saat belum diaktifkan saja.", PlayerInfo[playerid][pPlayerName]);
								ActorResetAndProses(ACT_NPC[ACTOR_SKILL_MEKANIK][actID], playerid, pDialog[playerid]);
							}else{
								static nama_item_ult[50];
								if(nama_item_ult[0] == '\0')
									getNamaByIdItem(ID_ULTIMATE_PART, nama_item_ult);
								format(pDialog[playerid], sizePDialog, "Oke %s\nKamu akan membutuhkan %s sebanyak %dx\nApakah kamu memilikinya?", PlayerInfo[playerid][pPlayerName], 
								nama_item_ult,
								BANYAK_ITEM_YANG_DIBUTUHKAN_UNTUK_AKTIFKAN_SKILL_MEKANIK);
								ACT_NPC[ACTOR_SKILL_MEKANIK][actRes] = 1;
								ActorResponse(ACT_NPC[ACTOR_SKILL_MEKANIK][actID], pDialog[playerid]);
							}
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membeli|beli)\\sitem.*")){
							showDialogBeliAlat(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_SKILL_MEKANIK][actID], playerid);
						}						
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_SKILL_MEKANIK][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_SKILL_MEKANIK][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "%s, saya tidak mengerti\napa yang anda bilang.\n", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_SKILL_MEKANIK][actID], pDialog[playerid], 5);
						}
					}
					else if(ACT_NPC[ACTOR_SKILL_MEKANIK][actRes] == 1){ // Saya ingin mengaktifkan skill mekanik
						if(cekPattern(text, "(iya|ya|punya)[\\s\\S]*")){
							if(GetJumlahItemPlayer(playerid, ID_ULTIMATE_PART) >= BANYAK_ITEM_YANG_DIBUTUHKAN_UNTUK_AKTIFKAN_SKILL_MEKANIK){
								format(pDialog[playerid], sizePDialog, "%s kamu berhasil mengaktifkan skill mekanik\nSilahkan latih skill kamu\nsehingga dapat melakukan lebih banyak kemampuan.", PlayerInfo[playerid][pPlayerName]);
								tambahItemPlayer(playerid, ID_ULTIMATE_PART, -BANYAK_ITEM_YANG_DIBUTUHKAN_UNTUK_AKTIFKAN_SKILL_MEKANIK);

								mysql_format(koneksi, pQuery[playerid], sizePQuery, "\
									INSERT INTO user_skill(id_skill, id_user, exp, is_active)\
									VALUES(%d, %d, 0, 1) ON DUPLICATE KEY UPDATE is_active = 1\
								", ID_SKILL_MEKANIK, PlayerInfo[playerid][pID]);
								mysql_tquery(koneksi, pQuery[playerid]);
								PlayerInfo[playerid][activeMekanik] = 1;
							}else{
								static nama_item_ult[50];
								if(nama_item_ult[0] == '\0')
									getNamaByIdItem(ID_ULTIMATE_PART, nama_item_ult);
								format(pDialog[playerid], sizePDialog, "Maaf %s.\nKamu tidak memiliki cukup %s\nSilahkan datang kembali lagi nanti.", PlayerInfo[playerid][pPlayerName], nama_item_ult);
							}
							ActorResetAndProses(ACT_NPC[ACTOR_SKILL_MEKANIK][actID], playerid, pDialog[playerid]);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_SKILL_MEKANIK][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_SKILL_MEKANIK][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "%s, saya tidak mengerti\napa yang anda bilang.\n", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_SKILL_MEKANIK][actID], pDialog[playerid], 5);
						}
					}

				}
			}
			else if(areaid == ACT_NPC[ACTOR_PERALATAN_PANCING][actArea]){ // Cek Jika berada pada area actor
				if(ACT_NPC[ACTOR_PERALATAN_PANCING][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_PENJUAL_PANCING".*")){
						ACT_NPC[ACTOR_PERALATAN_PANCING][actUser] = playerid;
						ACT_NPC[ACTOR_PERALATAN_PANCING][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_PERALATAN_PANCING][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_PERALATAN_PANCING][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_PENJUAL_PANCING, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_PERALATAN_PANCING][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_PERALATAN_PANCING][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_PERALATAN_PANCING][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(beli|membeli)\\s(alat|peralatan)\\s(pancing|pancingan|mancing).*")){
							showDialogBeliAlatPancing(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_PERALATAN_PANCING][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_PERALATAN_PANCING][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_PERALATAN_PANCING][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_PERALATAN_PANCING][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_TOKO_BIBIT][actArea]){ // Cek Jika berada pada area actor
				if(ACT_NPC[ACTOR_TOKO_BIBIT][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_PENJUAL_BIBIT".*")){
						ACT_NPC[ACTOR_TOKO_BIBIT][actUser] = playerid;
						ACT_NPC[ACTOR_TOKO_BIBIT][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_TOKO_BIBIT][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_TOKO_BIBIT][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_PENJUAL_BIBIT, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_TOKO_BIBIT][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_TOKO_BIBIT][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_TOKO_BIBIT][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(beli|membeli)\\s(bibit|benih).*")){
							showDialogBeliBibit(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TOKO_BIBIT][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_TOKO_BIBIT][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_TOKO_BIBIT][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_TOKO_BIBIT][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_TOKO_GADGET][actArea]){ // Cek Jika berada pada area actor
				if(ACT_NPC[ACTOR_TOKO_GADGET][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_PENJUAL_GADGET".*")){
						ACT_NPC[ACTOR_TOKO_GADGET][actUser] = playerid;
						ACT_NPC[ACTOR_TOKO_GADGET][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_TOKO_GADGET][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_TOKO_GADGET][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_PENJUAL_GADGET, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_TOKO_GADGET][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_TOKO_GADGET][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_TOKO_GADGET][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(beli|membeli)\\s(hp|phone).*")){
							showDialogBeliPhone(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TOKO_GADGET][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_TOKO_GADGET][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_TOKO_GADGET][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_TOKO_GADGET][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_PENJUAL_DEALER][actArea]){ // Cek Jika berada pada area actor
				if(ACT_NPC[ACTOR_PENJUAL_DEALER][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_PENJUAL_DEALER".*")){
						ACT_NPC[ACTOR_PENJUAL_DEALER][actUser] = playerid;
						ACT_NPC[ACTOR_PENJUAL_DEALER][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_PENJUAL_DEALER][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_PENJUAL_DEALER][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_PENJUAL_DEALER, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_PENJUAL_DEALER][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_PENJUAL_DEALER][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_PENJUAL_DEALER][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(jual|menjual)\\s(mobil|kendaraan).*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid, DIALOG_TALK_TO_DEALER_MANAGER_LIST, 1, 0, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_PENJUAL_DEALER][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_PENJUAL_DEALER][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_PENJUAL_DEALER][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_PENJUAL_DEALER][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_TELLER_BANK_LS_1][actArea]){ // Cek Jika berada pada area actor
				if(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_TELLER_BANK_1".*")){
						ACT_NPC[ACTOR_TELLER_BANK_LS_1][actUser] = playerid;
						ACT_NPC[ACTOR_TELLER_BANK_LS_1][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_TELLER_BANK_LS_1][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_TELLER_BANK_1, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membuat|buat|bikin|membikin)\\s(atm|rekening|rekening atm).*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid, DIALOG_TELLER_BANK, 1, 0, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\sdeposit\\s(atm|rekening|rekening atm|tabungan|uang).*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid, DIALOG_TELLER_BANK, 1, 1, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(mengambil|ambil)\\sgaji.*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid, DIALOG_MENU_GAJI, 1, 0, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(melihat|lihat)\\sgaji.*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid, DIALOG_MENU_GAJI, 1, 1, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actID], playerid);
						}				
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membayar|bayar)\\s(reparasi|perbaikan|perbaiki)\\skendaraan.*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid, DIALOG_TELLER_BANK, 1, 3, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membayar|bayar)\\stagihan.*")){
							SetPVarInt(playerid, "halaman", 0);
							SetPVarInt(playerid, "jenis_tagihan", 0);

							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `tagihan` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
							mysql_tquery(koneksi, pQuery[playerid], "showTagihanPemain", "i", playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membayar|bayar)\\sdenda\\s(sewa|menyewa|penyewaan)\\skendaraan.*")){
							SetPVarInt(playerid, "halaman", 0);
							SetPVarInt(playerid, "jenis_tagihan", JENIS_TAGIHAN_DENDA_SEWA_KENDARAAN);

							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `tagihan` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
							mysql_tquery(koneksi, pQuery[playerid], "showTagihanPemain", "i", playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_TELLER_BANK_LS_1][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_TELLER_BANK_LS_1][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_TELLER_BANK_LS_1][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_tokoNarko_Area){ // Cek Jika berada pada area actor
				if(ACT_tokoNarko_User == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_PENJUAL_NARKO".*")){
						ACT_tokoNarko_User = playerid;
						ACT_tokoNarko_Res = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_tokoNarko);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_tokoNarko, pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_PENJUAL_NARKO, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_tokoNarko, playerid, pDialog[playerid]);
					}
				}else if(ACT_tokoNarko_User == playerid){
					// Check apakah ini response yang pertama
					if(ACT_tokoNarko_Res == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(beli|membeli)\\s(bibit|benih)\\silegal.*")){
							showDialogBeliBibitNarko(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_tokoNarko, playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_tokoNarko_User = INVALID_PLAYER_ID;
							ACT_tokoNarko_Res = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_tokoNarko, pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_TELLER_BANK_LS_2][actArea]){ // Cek Jika berada pada area actor
				if(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_TELLER_BANK_2".*")){
						ACT_NPC[ACTOR_TELLER_BANK_LS_2][actUser] = playerid;
						ACT_NPC[ACTOR_TELLER_BANK_LS_2][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_TELLER_BANK_LS_2][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_TELLER_BANK_2, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membuat|buat|bikin|membikin)\\s(atm|rekening|rekening atm).*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid, DIALOG_TELLER_BANK, 1, 0, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\sdeposit\\s(atm|rekening|rekening atm|tabungan|uang).*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid, DIALOG_TELLER_BANK, 1, 1, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(mengambil|ambil)\\sgaji.*")){
							showKonfirmasiAmbilGaji(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(melihat|lihat)\\sgaji.*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid, DIALOG_MENU_GAJI, 1, 1, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actID], playerid);
						}				
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membayar|bayar)\\s(reparasi|perbaikan|perbaiki)\\skendaraan.*")){
							CallLocalFunction("OnDialogResponse", "iiiis", playerid, DIALOG_TELLER_BANK, 1, 3, "a");

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membayar|bayar)\\stagihan.*")){
							SetPVarInt(playerid, "halaman", 0);
							SetPVarInt(playerid, "jenis_tagihan", JENIS_TAGIHAN_UNIVERSAL);

							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `tagihan` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
							mysql_tquery(koneksi, pQuery[playerid], "showTagihanPemain", "i", playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_TELLER_BANK_LS_2][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_TELLER_BANK_LS_2][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_TELLER_BANK_LS_2][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_RUMAH_SAKIT][actArea]){ // Cek Jika berada pada area actor
				if(ACT_NPC[ACTOR_RUMAH_SAKIT][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_RUMAH_SAKIT".*")){
						ACT_NPC[ACTOR_RUMAH_SAKIT][actUser] = playerid;
						ACT_NPC[ACTOR_RUMAH_SAKIT][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_RUMAH_SAKIT][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_RUMAH_SAKIT][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_RUMAH_SAKIT, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_RUMAH_SAKIT][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_RUMAH_SAKIT][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_RUMAH_SAKIT][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membeli|beli)\\sitem.*")){
							showDialogBeliItemMedis(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_RUMAH_SAKIT][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membayar|bayar)\\stagihan.*")){
							SetPVarInt(playerid, "halaman", 0);
							SetPVarInt(playerid, "jenis_tagihan", JENIS_TAGIHAN_RUMAH_SAKIT);

							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `tagihan` WHERE id_user = '%d' AND status = '0' AND jenis = %d ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], JENIS_TAGIHAN_RUMAH_SAKIT, BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
							mysql_tquery(koneksi, pQuery[playerid], "showTagihanPemain", "i", playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_RUMAH_SAKIT][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_RUMAH_SAKIT][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_RUMAH_SAKIT][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_RUMAH_SAKIT][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_MARKETPLACE_1][actArea]){
				if(ACT_NPC[ACTOR_MARKETPLACE_1][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_MARKETPLACE_1".*")){
						ACT_NPC[ACTOR_MARKETPLACE_1][actUser] = playerid;
						ACT_NPC[ACTOR_MARKETPLACE_1][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_MARKETPLACE_1][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_MARKETPLACE_1][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_MARKETPLACE_1, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_1][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_MARKETPLACE_1][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_MARKETPLACE_1][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membeli|beli)\\sitem.*")){
							SetPVarInt(playerid, "halaman", 0);
							showDialogBeliItemMarketplace(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_1][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(menjual|jual)\\sitem.*")){
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT COUNT(*) as jumlah FROM marketplace WHERE id_user = %d", PlayerInfo[playerid][pID]);
							mysql_tquery(koneksi, pQuery[playerid], "cekJumlahDagangan", "i", playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_1][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(melihat|lihat|mengecek|cek)\\sdagangan.*")){
							SetPVarInt(playerid, "halaman", 0);
							showDialogDaganganMarketplace(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_1][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_MARKETPLACE_1][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_MARKETPLACE_1][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_MARKETPLACE_1][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_MARKETPLACE_2][actArea]){
				if(ACT_NPC[ACTOR_MARKETPLACE_2][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_MARKETPLACE_2".*")){
						ACT_NPC[ACTOR_MARKETPLACE_2][actUser] = playerid;
						ACT_NPC[ACTOR_MARKETPLACE_2][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_MARKETPLACE_2][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_MARKETPLACE_2][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_MARKETPLACE_2, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_2][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_MARKETPLACE_2][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_MARKETPLACE_2][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membeli|beli)\\sitem.*")){
							SetPVarInt(playerid, "halaman", 0);
							showDialogBeliItemMarketplace(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_2][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(menjual|jual)\\sitem.*")){
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT COUNT(*) as jumlah FROM marketplace WHERE id_user = %d", PlayerInfo[playerid][pID]);
							mysql_tquery(koneksi, pQuery[playerid], "cekJumlahDagangan", "i", playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_2][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(melihat|lihat|mengecek|cek)\\sdagangan.*")){
							SetPVarInt(playerid, "halaman", 0);
							showDialogDaganganMarketplace(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_2][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_MARKETPLACE_2][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_MARKETPLACE_2][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_MARKETPLACE_2][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_MARKETPLACE_3][actArea]){
				if(ACT_NPC[ACTOR_MARKETPLACE_3][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_MARKETPLACE_3".*")){
						ACT_NPC[ACTOR_MARKETPLACE_3][actUser] = playerid;
						ACT_NPC[ACTOR_MARKETPLACE_3][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_MARKETPLACE_3][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_MARKETPLACE_3][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_MARKETPLACE_3, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_3][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_MARKETPLACE_3][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_MARKETPLACE_3][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membeli|beli)\\sitem.*")){
							SetPVarInt(playerid, "halaman", 0);
							showDialogBeliItemMarketplace(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_3][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(menjual|jual)\\sitem.*")){
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT COUNT(*) as jumlah FROM marketplace WHERE id_user = %d", PlayerInfo[playerid][pID]);
							mysql_tquery(koneksi, pQuery[playerid], "cekJumlahDagangan", "i", playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_3][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(melihat|lihat|mengecek|cek)\\sdagangan.*")){
							SetPVarInt(playerid, "halaman", 0);
							showDialogDaganganMarketplace(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_3][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_MARKETPLACE_3][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_MARKETPLACE_3][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_MARKETPLACE_3][actID], pDialog[playerid], 5);
						}
					}
				}
			}	
			else if(areaid == ACT_NPC[ACTOR_MARKETPLACE_4][actArea]){
				if(ACT_NPC[ACTOR_MARKETPLACE_4][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_MARKETPLACE_4".*")){
						ACT_NPC[ACTOR_MARKETPLACE_4][actUser] = playerid;
						ACT_NPC[ACTOR_MARKETPLACE_4][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_MARKETPLACE_4][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_MARKETPLACE_4][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_MARKETPLACE_4, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_4][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_MARKETPLACE_4][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_MARKETPLACE_4][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membeli|beli)\\sitem.*")){
							SetPVarInt(playerid, "halaman", 0);
							showDialogBeliItemMarketplace(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_4][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(menjual|jual)\\sitem.*")){
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT COUNT(*) as jumlah FROM marketplace WHERE id_user = %d", PlayerInfo[playerid][pID]);
							mysql_tquery(koneksi, pQuery[playerid], "cekJumlahDagangan", "i", playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_4][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(melihat|lihat|mengecek|cek)\\sdagangan.*")){
							SetPVarInt(playerid, "halaman", 0);
							showDialogDaganganMarketplace(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_MARKETPLACE_4][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_MARKETPLACE_4][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_MARKETPLACE_4][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_MARKETPLACE_4][actID], pDialog[playerid], 5);
						}
					}
				}
			}					
			else if(areaid == ACT_NPC[ACTOR_SKILL_BLACKSMITH][actArea]){ // Cek Jika berada pada area actor
				if(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_SKILL_BLACKSMITH".*")){
						ACT_NPC[ACTOR_SKILL_BLACKSMITH][actUser] = playerid;
						ACT_NPC[ACTOR_SKILL_BLACKSMITH][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_SKILL_BLACKSMITH][actID]);
						format(pDialog[playerid], sizePDialog, "Hey %s!\nApa yang kamu perlukan disini?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Hey %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_SKILL_BLACKSMITH, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("bro")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(mengambil|ambil|mengaktifkan|aktifkan)\\sskill\\sblacksmith.*")){
							if(PlayerInfo[playerid][activeBlacksmith]){
								format(pDialog[playerid], sizePDialog, "%s kamu telah mengaktifkan skill blacksmith\nKamu hanya dapat mengaktifkan saat belum diaktifkan saja.", PlayerInfo[playerid][pPlayerName]);
								ActorResetAndProses(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actID], playerid, pDialog[playerid]);
							}else{
								static nama_item_forger[50];
								if(nama_item_forger[0] == '\0')
									getNamaByIdItem(ID_FORGER_CASE, nama_item_forger);
								format(pDialog[playerid], sizePDialog, "Oke %s\nKamu akan membutuhkan %s sebanyak %dx\nApakah kamu memilikinya?", PlayerInfo[playerid][pPlayerName], 
								nama_item_forger,
								BANYAK_ITEM_YANG_DIBUTUHKAN_UNTUK_AKTIFKAN_SKILL_BLACKSMITH);
								ACT_NPC[ACTOR_SKILL_BLACKSMITH][actRes] = 1;
								ActorResponse(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actID], pDialog[playerid]);
							}
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membeli|beli)\\sitem.*")){
							showDialogBeliBlacksmith(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actID], playerid);
						}						
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_SKILL_BLACKSMITH][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_SKILL_BLACKSMITH][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "%s, saya tidak mengerti\napa yang anda bilang.\n", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actID], pDialog[playerid], 5);
						}
					}
					else if(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actRes] == 1){ // Saya ingin mengaktifkan skill blacksmith
						if(cekPattern(text, "(iya|ya|punya)[\\s\\S]*")){
							if(GetJumlahItemPlayer(playerid, ID_FORGER_CASE) >= BANYAK_ITEM_YANG_DIBUTUHKAN_UNTUK_AKTIFKAN_SKILL_BLACKSMITH){
								format(pDialog[playerid], sizePDialog, "%s kamu berhasil mengaktifkan skill blacksmith\nSilahkan latih skill kamu\nsehingga dapat melakukan lebih banyak kemampuan.", PlayerInfo[playerid][pPlayerName]);
								tambahItemPlayer(playerid, ID_FORGER_CASE, -BANYAK_ITEM_YANG_DIBUTUHKAN_UNTUK_AKTIFKAN_SKILL_BLACKSMITH);

								mysql_format(koneksi, pQuery[playerid], sizePQuery, "\
									INSERT INTO user_skill(id_skill, id_user, exp, is_active)\
									VALUES(%d, %d, 0, 1) ON DUPLICATE KEY UPDATE is_active = 1\
								", ID_SKILL_BLACKSMITH, PlayerInfo[playerid][pID]);
								mysql_tquery(koneksi, pQuery[playerid]);
								PlayerInfo[playerid][activeBlacksmith] = 1;
							}else{
								static nama_item_ult[50];
								if(nama_item_ult[0] == '\0')
									getNamaByIdItem(ID_FORGER_CASE, nama_item_ult);
								format(pDialog[playerid], sizePDialog, "Maaf %s.\nKamu tidak memiliki cukup %s\nSilahkan datang kembali lagi nanti.", PlayerInfo[playerid][pPlayerName], nama_item_ult);
							}
							ActorResetAndProses(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actID], playerid, pDialog[playerid]);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_SKILL_BLACKSMITH][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_SKILL_BLACKSMITH][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "%s, saya tidak mengerti\napa yang anda bilang.\n", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_SKILL_BLACKSMITH][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actArea]){
				if(ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_PEMBELI_TAMBANG_1".*")){
						ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actUser] = playerid;
						ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_PEMBELI_TAMBANG_1, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membeli|beli)\\sitem.*")){
							showDialogBeliItemTambang(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(menjual|jual)\\sitem.*")){
							showDialogJualItemTambang(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_PEMBELI_TAMBANG_1][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_PEMBELI_KAYU_1][actArea]){
				if(ACT_NPC[ACTOR_PEMBELI_KAYU_1][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_PEMBELI_KAYU_1".*")){
						ACT_NPC[ACTOR_PEMBELI_KAYU_1][actUser] = playerid;
						ACT_NPC[ACTOR_PEMBELI_KAYU_1][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_PEMBELI_KAYU_1][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_PEMBELI_KAYU_1][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_PEMBELI_KAYU_1, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_PEMBELI_KAYU_1][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_PEMBELI_KAYU_1][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_PEMBELI_KAYU_1][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(membeli|beli)\\sitem.*")){
							showDialogBeliItemKayu(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_PEMBELI_KAYU_1][actID], playerid);
						}
						else if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(menjual|jual)\\sitem.*")){
							showDialogJualItemKayu(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_PEMBELI_KAYU_1][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_PEMBELI_KAYU_1][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_PEMBELI_KAYU_1][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_PEMBELI_KAYU_1][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_PEMBELI_IKAN][actArea]){
				if(ACT_NPC[ACTOR_PEMBELI_IKAN][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_PEMBELI_IKAN".*")){
						ACT_NPC[ACTOR_PEMBELI_IKAN][actUser] = playerid;
						ACT_NPC[ACTOR_PEMBELI_IKAN][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_PEMBELI_IKAN][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_PEMBELI_IKAN][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_PEMBELI_IKAN, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_PEMBELI_IKAN][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_PEMBELI_IKAN][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_PEMBELI_IKAN][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(menjual|jual)\\s(item|ikan).*")){
							showDialogJualItemIkan(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_PEMBELI_IKAN][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_PEMBELI_IKAN][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_PEMBELI_IKAN][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_PEMBELI_IKAN][actID], pDialog[playerid], 5);
						}
					}
				}
			}
			else if(areaid == ACT_NPC[ACTOR_PEMBELI_BUAH][actArea]){
				if(ACT_NPC[ACTOR_PEMBELI_BUAH][actUser] == INVALID_PLAYER_ID && (!GetPVarType(playerid, "interaksi_actor") || GetPVarInt(playerid, "interaksi_actor") == -1)){ // Cek Jika Actor sedang tidak interaksi dengan siapapun atau sedang interaksi dengan player tersebut					
					if(cekPattern(text, "(ha|he).*(lo|y|i)[\\s\\S]"NAMA_ACTOR_PEMBELI_BUAH".*")){
						ACT_NPC[ACTOR_PEMBELI_BUAH][actUser] = playerid;
						ACT_NPC[ACTOR_PEMBELI_BUAH][actRes] = 0;

						SetPVarInt(playerid, "interaksi_actor", ACT_NPC[ACTOR_PEMBELI_BUAH][actID]);
						format(pDialog[playerid], sizePDialog, "Halo %s!\nAda yang bisa saya bantu?", PlayerInfo[playerid][pPlayerName]);
						ActorResponse(ACT_NPC[ACTOR_PEMBELI_BUAH][actID], pDialog[playerid]);
					}
					else if(cekPattern(text, ".*(nama\\skamu\\ssiapa|siapa\\snama(\\skamu|mu|nya)).*")){
						format(pDialog[playerid], sizePDialog, "Halo %s %s!\nPerkenalkan nama saya "NAMA_ACTOR_PEMBELI_BUAH, ((PlayerInfo[playerid][jenisKelamin] == 1) ? ("mbak") : ("mas")), PlayerInfo[playerid][pPlayerName]);
						ActorResetAndProses(ACT_NPC[ACTOR_PEMBELI_BUAH][actID], playerid, pDialog[playerid]);
					}
				}else if(ACT_NPC[ACTOR_PEMBELI_BUAH][actUser] == playerid){
					// Check apakah ini response yang pertama
					if(ACT_NPC[ACTOR_PEMBELI_BUAH][actRes] == 0){
						if(cekPattern(text, "(aku|saya)\\s(ingin|pengen|mau)\\s(menjual|jual)\\s(item|buah).*")){
							showDialogJualItemBuah(playerid);

							// Reset Interaksi dan Biarkan player lanjut sendiri dialognya
							ActorResetAndProses(ACT_NPC[ACTOR_PEMBELI_BUAH][actID], playerid);
						}
						else{
							SetPVarInt(playerid, "interaksi_actor", -1);
							ACT_NPC[ACTOR_PEMBELI_BUAH][actUser] = INVALID_PLAYER_ID;
							ACT_NPC[ACTOR_PEMBELI_BUAH][actRes] = 0;

							format(pDialog[playerid], sizePDialog, "Maaf %s,\nSaya tidak mengerti\napa yang anda bicarakan.", PlayerInfo[playerid][pPlayerName]);
							ActorResponse(ACT_NPC[ACTOR_PEMBELI_BUAH][actID], pDialog[playerid], 5);
						}
					}
				}
			}			
		}
	}

	
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
	}else if(pickupid == PU_marketPlace[ENTER_PICKUP]){
		pindahkanPemain(playerid, -2640.2090, 1406.8171, 906.4609, 91.5918, 3, 1, true);
		return 1;
	}else if(pickupid == PU_marketPlace[EXIT_PICKUP]){
		pindahkanPemain(playerid, 1477.4969, -1641.4519, 14.1652, 179.7030, 0, 0, true);
		return 1;
	}else if(pickupid == PU_tempatFoto_out){
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
	else if(pickupid >= PU_restoran[0] && pickupid <= PU_restoran[sizeof(PU_restoran) - 1]){
		pindahkanPemain(playerid, 365.5712, -8.7934, 1001.8516, 351.2707, 9, pickupid - PU_restoran[0], false);
		return 1;
	}
	else if(pickupid == PU_keluarRestoran){
		// Jika terjadi virtual world yang lebih dari maximize size, maka akan di random tempatnya dengan modulo
		new idx = GetPlayerVirtualWorld(playerid) % sizeof(ENTRANCE_RESTORAN);
		pindahkanPemain(playerid, ENTRANCE_RESTORAN[idx][enPosOut][0], ENTRANCE_RESTORAN[idx][enPosOut][1], ENTRANCE_RESTORAN[idx][enPosOut][2], ENTRANCE_RESTORAN[idx][enPosOut][3], 0, 0, true);
		return 1;
	}
	else if(pickupid == PU_rumahSakit[0]){
		pindahkanPemain(playerid, 160.7758, 1770.8013, 10000.0225 - MAPPINGAN_RUMAH_SAKIT_TURUNKAN, 269.8320, 1, 1, true);
		return 1;
	}
	else if(pickupid >= PU_market[0] && pickupid <= PU_market[sizeof(PU_market) - 1]){
		pindahkanPemain(playerid, -25.884498, -185.868988, 1003.546875, 0.0, 17, pickupid - PU_market[0], false);
		return 1;
	}
	else if(pickupid == PU_keluarMarket){
		// Jika terjadi virtual world yang lebih dari maximize size, maka akan di random tempatnya dengan modulo
		new idx = GetPlayerVirtualWorld(playerid) % sizeof(ENTRANCE_MARKET);
		pindahkanPemain(playerid, ENTRANCE_MARKET[idx][enPosOut][0], ENTRANCE_MARKET[idx][enPosOut][1], ENTRANCE_MARKET[idx][enPosOut][2], ENTRANCE_MARKET[idx][enPosOut][3], 0, 0, true);
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
			format(msg, 256, TAG_RUMAH""WHITE" Ketik "GREEN"/houseinfo"WHITE" untuk melihat info tentang rumah.");
			SendClientMessage(playerid, COLOR_GREEN, msg);
		}
	}else if(pickupid == PU_cityHallMasuk[0] || pickupid == PU_cityHallMasuk[1] || pickupid == PU_cityHallMasuk[2]){
		pindahkanPemain(playerid, -501.2855,289.1127,2001.0950, 357.5606, 1, 1, true);
		return 1;
	}else if(pickupid == PU_cityHallKeluar){
		new rand_idx = random(sizeof(SPAWN_POINT_OUT_CH));
		pindahkanPemain(playerid, SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_X],SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_Y],SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_Z],SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_A], SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_INTERIOR], SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_VW], true);
		return 1;
	}else if(pickupid == PU_bankLS[ENTER_PICKUP][0]){
		if(random(2))
			pindahkanPemain(playerid, 1400.1552, -36.1771, 1000.8950, 88.7250, 1, 1, true);
		else
			pindahkanPemain(playerid, 1399.7180, -37.6216, 1000.8950, 92.1717, 1, 1, true);
		return 1;
	}else if(pickupid == PU_bankLS[EXIT_PICKUP][0] || pickupid == PU_bankLS[EXIT_PICKUP][1]){
		new rand_idx = random(sizeof(SP_OUT_BANK_LS));
		pindahkanPemain(playerid, SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_X],SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_Y],SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_Z],SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_A], SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_INTERIOR], SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_VW], true);
		return 1;
	}else if(pickupid >= PU_tempatKeluarRumah[0] && pickupid <= PU_tempatKeluarRumah[1]){
		new id_rumah = PlayerInfo[playerid][inHouse];
		pindahkanPemain(playerid, houseInfo[id_rumah][icon_x], houseInfo[id_rumah][icon_y], houseInfo[id_rumah][icon_z], houseInfo[id_rumah][last_a], 0, 0, true);
		return 1;
	}else if(pickupid == PU_policeDept_in[0]){
		pindahkanPemain(playerid, 246.6298,64.2289,1003.6406,6.9548, 6, 1, false);
		return 1;
	}else if(pickupid == PU_policeDept_out[0]){
		pindahkanPemain(playerid, 1552.9425,-1675.7598,16.1953,92.6288, 0, 0, false);
		return 1;
	}else if(pickupid == PU_tokoGadget[0][ENTER_PICKUP]){
		pindahkanPemain(playerid, 440.6347,1243.1987,1081.9045,269.2776, 1, 1, true);
		return 1;
	}else if(pickupid == PU_tokoGadget[0][EXIT_PICKUP]){
		pindahkanPemain(playerid, 1097.6973,-1372.5007,13.9844,178.3555, 0, 0, true);
		return 1;
	}else if(pickupid == PU_tambangBesi[ENTER_PICKUP]){
		pindahkanPemain(playerid, 2398.0542, -1506.9365, 1402.2000, 267.2652, 1, VW_tambangInterior, true);
	}else if(pickupid == PU_tambangBesi[EXIT_PICKUP]){
		pindahkanPemain(playerid, -688.4846, 2372.3027, 129.6614, 87.0446, 0, 0, true);
	}else if(pickupid == PU_tempatBlacksmith[ENTER_PICKUP]){
		pindahkanPemain(playerid, 699.5331, -448.1602, -25.6180, 180.3815, 1, 1, true);
	}else if(pickupid == PU_tempatBlacksmith[EXIT_PICKUP]){
		pindahkanPemain(playerid, 996.3550, -1251.7916, 19.3945, 180.5325, 0, 0, true);
	}else if(pickupid == PU_tempatIlegalBlacksmith[ENTER_PICKUP]){
		pindahkanPemain(playerid, 1072.0524, -764.2084, 1087.1460, 105.6685, 1, 1, true);
	}else if(pickupid == PU_tempatIlegalBlacksmith[EXIT_PICKUP]){
		pindahkanPemain(playerid, -1429.6885, -947.3187, 201.0938, 264.7964, 0, 0, true);
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid){
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
			todoFinish[playerid] = 1;
			resetPlayerToDo(playerid);
			addGajiPemain(playerid, GAJI_SWEEPER, "Pembersih jalan (sweeper)");
			GameTextForPlayer(playerid, "~g~Pekerjaan Selesai", 2000, 3);
			format(pDialog[playerid], sizePDialog, GREEN"Anda telah berhasil menyelesaikan pekerjaan!\n"WHITE"Upah sudah terkirim ke rekening gaji anda sebesar "GREEN"$%d\n"WHITE"Silahkan ambil gaji anda ke Bank terdekat.", GAJI_SWEEPER);
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", pDialog[playerid], "Ok", "");
			// Exp Score
			TambahExpScore(playerid, EXP_TAMBAH_JOB);
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
				todoFinish[playerid] = 1;
				GameTextForPlayer(playerid, "~g~Praktik SIM Selesai", 2000, 3);
				format(pDialog[playerid], sizePDialog, WHITE"Anda mendapatkan poin sebesar "GREEN"%d"WHITE".\nSilahkan mencoba kembali ketika anda sudah siap.\n\nTerimakasih, Salam hangat "ORANGE"Kantor Polisi Lost Santos", poinSim[playerid]);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Gagal Praktik SIM", pDialog[playerid], "Ok", "");
				resetPlayerToDo(playerid);
			}else{
				todoFinish[playerid] = 1;
				prosesPembuatanSIM(playerid, LAMA_PEMBUATAN_SIM);
				GameTextForPlayer(playerid, "~g~Praktik SIM Selesai", 2000, 3);
				format(pDialog[playerid], sizePDialog, WHITE"Anda mendapatkan poin sebesar "GREEN"%d"WHITE".\nSilahkan tunggu sekitar %d jam real-time."WHITE"\nAnda dapat mengecek dan mengambilnya di tempat Registrasi sebelumnya, setelah sudah %d jam berlalu.\n\nTerimakasih, Salam hangat "ORANGE"Kantor Polisi Lost Santos", poinSim[playerid], LAMA_PEMBUATAN_SIM, LAMA_PEMBUATAN_SIM);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil Praktik SIM", pDialog[playerid], "Ok", "");
				resetPlayerToDo(playerid);
			}
		}
	}
	return 1;
}

public OnVehicleSpawn(vehicleid){
	if(Iter_Contains(IDVehToPVehIterator, vehicleid))
		LoadModifVehiclePlayer(vehicleid);
	else
		SetVehicleFuel(vehicleid, MAX_VEHICLE_FUEL); // Set MAX_VEHICLE_FUEL
	return 1;
}

public OnVehicleVelocityChange(vehicleid,Float:newx,Float:newy,Float:newz,Float:oldx,Float:oldy,Float:oldz){
	if(GetVehicleFuel(vehicleid) <= 0) {
		SetVehicleParams(vehicleid, VEHICLE_TYPE_ENGINE, 0);
		SetVehicleParams(vehicleid, VEHICLE_TYPE_LIGHTS, 0);
	}
	return 1;
}

public OnVehicleHealthChange(vehicleid,Float:newhealth,Float:oldhealth){
	if(newhealth <= 260.0){
		if(Iter_Contains(IDVehToPVehIterator, vehicleid)){
			if(IsVehicleFlipped(vehicleid)) {
				new Float:ang;
				GetVehicleZAngle(vehicleid, ang);
				SetVehicleZAngle(vehicleid, ang);
			}

			new temp_engine, temp_lights, temp_alarm, temp_doors, temp_bonnet, temp_boot, temp_objective;
			GetVehicleParamsEx(vehicleid, temp_engine, temp_lights, temp_alarm, temp_doors, temp_bonnet, temp_boot, temp_objective);
			SetVehicleParamsEx(vehicleid, 0, 0, temp_alarm, temp_doors, temp_bonnet, temp_boot, temp_objective);

			// Restore vehicle HP
			SetVehicleHealth(vehicleid, 260.0);
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
				format(temp_msg, 128,TAG_KENDARAAN" "WHITE"Kendaraan "ORANGE"%s "WHITE"milik anda telah rusak total dan masuk pusat reparasi.", GetVehicleModelName(PVeh[IDVehToPVeh[vehicleid]][pVehModel]));
				SendClientMessage(i, COLOR_RED, temp_msg);
				format(temp_msg, 128,TAG_KENDARAAN" "WHITE"Anda juga kehilangan item didalamnya.");
				SendClientMessage(i, COLOR_RED, temp_msg);
				break;
			}
		}

		bersihkanVariabelItemVehicle(vehicleid);
		new str_temp[200];
		
		// Hapus semua item
		mysql_format(koneksi, str_temp, 200, "DELETE FROM vehicle_item WHERE id_vehicle = %d", PVeh[IDVehToPVeh[vehicleid]][pVehID]);
		mysql_tquery(koneksi, str_temp);
		
		DestroyVehicle(vehicleid);
		IDVehToPVeh[vehicleid] = 0;
		Iter_Remove(IDVehToPVehIterator, vehicleid);
	}
	if(GetVehicleModel(vehicleid) == 422){
		vehDTree[vehicleid][treeAngkut] = 0;
	}
	if(Iter_Contains(RentPlayerVehIter, RentPlayerVehID[vehicleid])){
		new rentid = RentPlayerVehID[vehicleid],
		Pid = RentPlayerVeh[rentid][rentPlayerVehUserPid];
		SendClientMessage(Pid, COLOR_BLUE, TAG_INFO" "WHITE"Kendaraan sewa anda telah rusak total, silahkan bayar denda ke Bank terdekat.");
		
		// Kenakan tagihan
		format(pDialog[Pid], 50, "denda sewa kendaraaan");
		addTagihanPemain(Pid, TAGIHAN_DENDA_SEWA_KENDARAAN, pDialog[Pid], JENIS_TAGIHAN_DENDA_SEWA_KENDARAAN);
		unloadRentPlayerVeh(Pid, 1);
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid){
	new vehid = GetPlayerVehicleID(playerid);
	if(PlayerInfo[playerid][activeMarker]){
		PlayerInfo[playerid][activeMarker] = false;
		DisablePlayerCheckpoint(playerid);
	}
	if(IsPlayerOnDutyPolice(playerid)){
		new Float:polx, Float:poly, Float:polz;
		GetPlayerPos(playerid, polx, poly, polz);
		foreach(new i : Player){
			if(IsPlayerInRangeOfPoint(i, 3.0, polx, poly, polz)){
				PlayerInfo[i][inHelp] = 0;
			}
		}
	}
	if(Iter_Contains(trashM_Veh, vehid) && trashM_Job[playerid] == 1 && trashM_Id[playerid] == vehid){
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1644.5551, -1537.3542, 13.5697)){
			if(IsPlayerInVehicle(playerid, trashM_Id[playerid])){
				new jumlah_trash = trashM_VehCap[trashM_Id[playerid]],
				gaji = jumlah_trash*GAJI_TRASHMASTER;
				todoFinish[playerid] = 1;
				resetPlayerToDo(playerid);
				addGajiPemain(playerid, gaji, "Truk Sampah (Trashmaster)");
				GameTextForPlayer(playerid, "~g~Pekerjaan Selesai", 2000, 3);
				format(pDialog[playerid], sizePDialog, GREEN"Anda telah berhasil menyelesaikan pekerjaan!\n"WHITE"Upah sudah terkirim ke rekening gaji anda sebesar "GREEN"$%d\n"WHITE"Silahkan ambil gaji anda ke Bank terdekat.", gaji);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", pDialog[playerid], "Ok", "");
				// Exp Score
				TambahExpScore(playerid, EXP_TAMBAH_JOB);
			}
		}
	}
	if(Iter_Contains(pizza_Veh, vehid) && pizza_Job[playerid] == 1 && pizza_Id[playerid] == vehid){
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 2092.4819,-1829.4832,13.5568)){
			if(IsPlayerInVehicle(playerid, pizza_Id[playerid])){
				new jumlah_pizza = pizza_HouseDrop[playerid],
				gaji = jumlah_pizza*GAJI_PIZZABOY;
				todoFinish[playerid] = 1;
				resetPlayerToDo(playerid);
				addGajiPemain(playerid, gaji, "Pengantar Pizza (Pizzaboy)");
				GameTextForPlayer(playerid, "~g~Pekerjaan Selesai", 2000, 3);
				format(pDialog[playerid], sizePDialog, GREEN"Anda telah berhasil menyelesaikan pekerjaan!\n"WHITE"Upah sudah terkirim ke rekening gaji anda sebesar "GREEN"$%d\n"WHITE"Silahkan ambil gaji anda ke Bank terdekat.", gaji);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", pDialog[playerid], "Ok", "");
				// Exp Score
				TambahExpScore(playerid, EXP_TAMBAH_JOB);
			}
		}
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
	if(PlayerInfo[playerid][inDie] && !sama(cmdtext, "/call 911") && !sama(cmdtext, "/suicide")){
		error_command(playerid, "Anda sedang sekarat tidak dapat menggunakan command ini.");
		SendClientMessage(playerid, COLOR_ORANGE, TAG_NOTE" "WHITE"Gunakan "GREEN"/call 911"WHITE" dan pilih Medis, untuk memanggil medis.");
		SendClientMessage(playerid, COLOR_ORANGE, TAG_NOTE" "WHITE"Atau gunakan /suicide untuk langsung spawn dirumah sakit.");
		return 0;
	}
	return 1;
}

/**
	TIMER TASK
**/
publicFor: updateWorldTime()
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

	// Setiap jamnya, random weather
	if(++weather_time >= 3600){
		gantiCuaca();
		weather_time = 0;
	}
	return 1;
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
			
			SaveBoard(BoardInfo[idx][bModel], BoardInfo[idx][bCX], BoardInfo[idx][bCY], BoardInfo[idx][bCZ], BoardInfo[idx][bCRX], BoardInfo[idx][bCRY], BoardInfo[idx][bCRZ], BoardInfo[idx][bText], BoardInfo[idx][bFontSiz], idx);

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
	}else if(Iter_Contains(ATMs, EditingATMID[playerid])){
	    if(response == EDIT_RESPONSE_FINAL)
	    {
	        new id = EditingATMID[playerid];
	        ATMData[id][atmX] = x;
	        ATMData[id][atmY] = y;
	        ATMData[id][atmZ] = z;
	        ATMData[id][atmRX] = rx;
	        ATMData[id][atmRY] = ry;
	        ATMData[id][atmRZ] = rz;

	        SetDynamicObjectPos(objectid, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ]);
	        SetDynamicObjectRot(objectid, ATMData[id][atmRX], ATMData[id][atmRY], ATMData[id][atmRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ATMData[id][atmLabel], E_STREAMER_X, ATMData[id][atmX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ATMData[id][atmLabel], E_STREAMER_Y, ATMData[id][atmY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ATMData[id][atmLabel], E_STREAMER_Z, ATMData[id][atmZ] + 0.85);

			new query[500];
			mysql_format(koneksi, query, sizeof(query), "UPDATE tempat_atm SET pos_x='%f', pos_y='%f', pos_z='%f', rot_x='%f', rot_y='%f', rot_z='%f' WHERE id=%d", x, y, z, rx, ry, rz, id);
			mysql_tquery(koneksi, query);
			EditingATMID[playerid] = -1;
		}
	    else if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new id = EditingATMID[playerid];
	        SetDynamicObjectPos(objectid, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ]);
	        SetDynamicObjectRot(objectid, ATMData[id][atmRX], ATMData[id][atmRY], ATMData[id][atmRZ]);
	        EditingATMID[playerid] = -1;
	    }
	}else if(treeEditID[playerid] != -1 && Iter_Contains(TreeIterator, treeEditID[playerid])){
        if(response == EDIT_RESPONSE_FINAL){
            new id = treeEditID[playerid];
            DTree[id][treeX] = x;
            DTree[id][treeY] = y;
            DTree[id][treeZ] = z;
            DTree[id][treeRX] = rx;
            DTree[id][treeRY] = ry;
            DTree[id][treeRZ] = rz;

            SetDynamicObjectPos(objectid, DTree[id][treeX], DTree[id][treeY], DTree[id][treeZ]);
            SetDynamicObjectRot(objectid, DTree[id][treeRX], DTree[id][treeRY], DTree[id][treeRZ]);

            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, DTree[id][treeLabel], E_STREAMER_X, DTree[id][treeX]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, DTree[id][treeLabel], E_STREAMER_Y, DTree[id][treeY]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, DTree[id][treeLabel], E_STREAMER_Z, DTree[id][treeZ] + 1.5);

			Streamer_SetFloatData(STREAMER_TYPE_CP, DTree[id][treeCP], E_STREAMER_X, DTree[id][treeX]);
            Streamer_SetFloatData(STREAMER_TYPE_CP, DTree[id][treeCP], E_STREAMER_Y, DTree[id][treeY]);
            Streamer_SetFloatData(STREAMER_TYPE_CP, DTree[id][treeCP], E_STREAMER_Z, DTree[id][treeZ]);
			
            mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE lumber SET treeX=%f, treeY=%f, treeZ=%f, treeRX=%f, treeRY=%f, treeRZ=%f WHERE id=%d", DTree[id][treeX], DTree[id][treeY], DTree[id][treeZ], DTree[id][treeRX], DTree[id][treeRY], DTree[id][treeRZ], id);
			mysql_tquery(koneksi, pQuery[playerid]);

            treeEditID[playerid] = -1;
        }
        if(response == EDIT_RESPONSE_CANCEL){
            new id = treeEditID[playerid];
            SetDynamicObjectPos(objectid, DTree[id][treeX], DTree[id][treeY], DTree[id][treeZ]);
            SetDynamicObjectRot(objectid, DTree[id][treeRX], DTree[id][treeRY], DTree[id][treeRZ]);
            treeEditID[playerid] = -1;
        }
    }else if(EditingObjPolice[playerid] != -1 && Iter_Contains(ObjPoliceIterator, EditingObjPolice[playerid])){
		new id = EditingObjPolice[playerid], Float:text_z;
        switch(OBJECT_POLICE[id][objType]){
			case OBJECT_TYPE_RANJAU: text_z = OBJECT_POLICE[id][objZ]+1.5;
			case OBJECT_TYPE_BARIKADE: text_z = OBJECT_POLICE[id][objZ]+1.5;
			case OBJECT_TYPE_GARIS: text_z = OBJECT_POLICE[id][objZ]+1.5;
			case OBJECT_TYPE_SIGN: text_z = OBJECT_POLICE[id][objZ]+0.7;
			case OBJECT_TYPE_SPEEDCAM: text_z = OBJECT_POLICE[id][objZ]+3.0;
		}
		if(response == EDIT_RESPONSE_FINAL){
            OBJECT_POLICE[id][objX] = x;
            OBJECT_POLICE[id][objY] = y;
            OBJECT_POLICE[id][objZ] = z;
            SetDynamicObjectPos(objectid, OBJECT_POLICE[id][objX], OBJECT_POLICE[id][objY], OBJECT_POLICE[id][objZ]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OBJECT_POLICE[id][objLabel], E_STREAMER_X, OBJECT_POLICE[id][objX]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OBJECT_POLICE[id][objLabel], E_STREAMER_Y, OBJECT_POLICE[id][objY]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OBJECT_POLICE[id][objLabel], E_STREAMER_Z, text_z);
            EditingObjPolice[playerid] = -1;
        }
        if(response == EDIT_RESPONSE_CANCEL){
            SetDynamicObjectPos(objectid, OBJECT_POLICE[id][objX], OBJECT_POLICE[id][objY], OBJECT_POLICE[id][objZ]);
            EditingObjPolice[playerid] = -1;
        }
    }
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid){
	SetPVarInt(playerid, "last_area", areaid);
	if(areaid == AREA_keluarRumahSakit[0]){
		pindahkanPemain(playerid, 1177.5511, -1323.2318, 14.0763, 272.1194, 0, 0, false);
		return 1;
	}else if(areaid == AREA_tempatFoto){
		new jam, menit, detik;
		gettime(jam, menit, detik);
		if(GetPlayerVirtualWorld(playerid) == VW_tempatFoto_2 && !(jam >= 20 || jam <= 5)) return SendClientMessage(playerid, COLOR_RED, "Maaf Tempat foto "nama_B" saat ini tutup! Silahkan kembali antara jam 20.00 hingga 05.59.");

		new harga = (GetPlayerVirtualWorld(playerid) == VW_tempatFoto_2) ? 10 : 20;

		format(pDialog[playerid], sizePDialog, WHITE"Berapa banyak foto yang ingin anda cetak?\n"YELLOW"Harga 1 foto adalah "GREEN"%d", harga);

		ShowPlayerDialog(playerid, DIALOG_TEMPAT_FOTO, DIALOG_STYLE_INPUT, "Foto dan Cetak", pDialog[playerid], "Cetak", "Batal");
		return 1;
	}else if(areaid >= AREA_spotBarangMarket[0] && areaid <= AREA_spotBarangMarket[sizeof(AREA_spotBarangMarket) - 1]){
		showDialogBeliBarang(playerid);
		return 1;
	}else if(areaid == AREA_spotGantiSkin){
		ShowPlayerDialog(playerid, DIALOG_REFRESH_SKIN, DIALOG_STYLE_MSGBOX, "Refresh skin anda", "Apakah anda yakin ingin mensinkronisasikan kembali skin anda?\n\n"YELLOW"** Skin yang akan direfresh adalah skin yang sudah anda use pada inventory anda.\nJika anda belum memilih skin yang ingin anda gunakan, anda dapat membuka inventory\nLalu pilih skin yang ingin anda gunakan.", "Ganti", "Batal");
		return 1;
	}else if(areaid == AREA_spotBeliSkin[0] || areaid == AREA_spotBeliSkin[1] || areaid == AREA_spotBeliSkin[2]){
		ShowPlayerDialog(playerid, DIALOG_TANYA_INGIN_BELI_SKIN, DIALOG_STYLE_MSGBOX, WHITE"Ingin beli skin?", "Apakah anda ingin membeli "YELLOW"skin normal "WHITE"dengan harga "GREEN"2500 "WHITE"per skin?", "Beli", "Batal");
		return 1;
	// }else if(areaid == AREA_tellerBankLS[0] || areaid == AREA_tellerBankLS[1]){
	// 	showDialogTellerBank(playerid);
	// 	return 1;
	}else if(areaid == AREA_beliMakanCepatSaji){
		showDialogTempatMakan(playerid);
		return 1;
	}else if(areaid == AREA_simRegis[0]){
		showDialogSimRegis(playerid);
		return 1;
	}else if(areaid == AREA_simPraktik[0]){
		showDialogSimPraktik(playerid);
		return 1;
	}else if(areaid == AREA_pusatProperti[0]){
		ShowPlayerDialog(playerid, DIALOG_MENU_PUSAT_PROPERTI, DIALOG_STYLE_LIST, "Apa yang ingin anda tanya :", "Lihat semua rumah yang terjual", "Ok", "Batal");
		return 1;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
		foreach(new i : ObjPoliceIterator){
			if(Iter_Contains(ObjPoliceIterator, i)){
				if(OBJECT_POLICE[i][objType] == OBJECT_TYPE_RANJAU){
					// Ranjau
					if(areaid == OBJECT_POLICE[i][objArea]){
						if(OBJECT_POLICE[i][objAktif] == 1){
							new panels, doors, lights, tires, vehid = GetPlayerVehicleID(playerid);
							GetVehicleDamageStatus(vehid, panels, doors, lights, tires);
							tires = EncodeTires(1, 1, 1, 1);
							UpdateVehicleDamageStatus(vehid, panels, doors, lights, tires);
							return 1;
						}
					}
				}else if(OBJECT_POLICE[i][objType] == OBJECT_TYPE_SPEEDCAM){
					// Speed Cam
					if(areaid == OBJECT_POLICE[i][objArea]){
						if(OBJECT_POLICE[i][objAktif] == 1){
							new vehid = GetPlayerVehicleID(playerid),
								vehspeed = GetVehicleSpeed(vehid);
							if(vehspeed > OBJECT_POLICE[i][objData]){
								new Float:x, Float:y, Float:z, vehmodel = GetVehicleModel(vehid);
								GetPlayerPos(playerid, x, y, z);
								PlayerPlaySound(playerid, 1132, 0.0, 0.0, 0.0);
								format(pDialog[playerid], 192, TAG_POLICE" "WHITE"Kendaraan model %s, di sekitar daerah %s telah melanggar lalu lintas (Batas Kecepatan).", GetVehicleModelName(vehmodel), GetZoneName(x, y, z));
								SendMessageToDutyPolice(COLOR_POLISI, pDialog[playerid]);
								return 1;
							}
						}
					}
				}
			}
		}
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid){
	DeletePVar(playerid, "last_area");
    if(GetPVarType(playerid, "interaksi_actor")){
		TerminateInteraksi_Alt(GetPVarInt(playerid, "interaksi_actor"));
	}
	return 1;
}

/*
 * IMPORTANT : issuerid perlu dicek apakah INVALID_PLAYER_ID
 */
public OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart){
	static Float:depth[2];
	new Float:health;
	GetPlayerHealth(playerid, health);
	if(!PlayerInfo[playerid][inDie] && health - amount <= 1.0 && !CA_IsPlayerInWater(playerid, depth[0], depth[1])){
		PlayerInfo[playerid][inDie] = LAMA_MENUNGGU_SAAT_SEKARAT;
		SetPlayerHealth(playerid, 1.0);
		animasiSekarat(playerid);
		return 0;
	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid){
	if(PlayerInfo[playerid][isOnMask])
		ShowPlayerNameTagForPlayer(playerid, forplayerid, 0);
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid){
	if(newinteriorid != oldinteriorid){
		foreach(new i : Player) {
			if(PlayerInfo[i][inSpectating] == playerid){
				SetPlayerInterior(i, GetPlayerInterior(playerid));
			}
		}
	}
	return 1;
}

#include <command>