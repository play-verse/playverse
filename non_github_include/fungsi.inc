publicFor: isRegistered(playerid)
{
	// ClearChat
	ClearChat(playerid);

	new randVal = random(2);
	if(randVal){
		InterpolateCameraPos(playerid, 354.041900, -1747.001220, 45.020599, 2453.882080, -1683.979370, 62.778331, 50000);
		InterpolateCameraLookAt(playerid, 355.294342, -1751.615600, 43.558235, 2457.219970, -1682.922363, 59.208766, 20000);
	}else{
		InterpolateCameraPos(playerid, 2572.200927, -1249.852050, 82.663887, 2463.226562, -1649.841552, 49.505981, 20000);
		InterpolateCameraLookAt(playerid, 2572.100097, -1254.850952, 82.680725, 2466.521972, -1651.870483, 46.339923, 15000);
	}


	// Cek jika field id user kosong - maka dianggap belum ada user
	new bool:is_null = true;
	if(cache_num_rows()) cache_is_value_name_null(0, "id", is_null);

	// Jika id user tidak kosong
	if(cache_num_rows() && is_null == false) // IsRegistered
	{
		// Untuk string harus disimpan dlu ke variable, gabisa langsung masuk enum
		new temp_value[256];
		cache_get_value_name_int(0, "id", PlayerInfo[playerid][pID]);
		cache_get_value_name_int(0, "current_skin", PlayerInfo[playerid][skinID]);
		cache_get_value_name(0, "password", temp_value);
		format(PlayerInfo[playerid][pPassword], 66, "%s", temp_value);
		cache_get_value_name_int(0, "jumlah_login", PlayerInfo[playerid][loginKe]);

		cache_get_value_name_int(0, "jenis_kelamin", PlayerInfo[playerid][jenisKelamin]);

		// Equiped phone
		cache_get_value_name_int(0, "use_phone", PlayerInfo[playerid][ePhone]);
		cache_get_value_name_int(0, "save_house", PlayerInfo[playerid][sHouse]);

		// Limit Item
		cache_get_value_name_int(0, "limit_item", PlayerInfo[playerid][limitItem]);

		cache_is_value_name_null(0, "nomor_handphone", is_null);
		if(is_null){
			// EOS = End Of String - '\0' sama
			PlayerInfo[playerid][nomorHP][0] = EOS;
		}else{
			cache_get_value_name(0, "nomor_handphone", temp_value);
			format(PlayerInfo[playerid][nomorHP], 12, "%s", temp_value);

			cache_get_value_name(0, "masa_aktif_nomor", temp_value);
			PlayerInfo[playerid][masaAktifNomor] = convStrSqlDateIntoUnix(temp_value);
		}

		cache_is_value_name_null(0, "rekening", is_null);
		if(is_null){
			PlayerInfo[playerid][nomorRekening][0] = EOS;
		}else{
			cache_get_value_name(0, "rekening", temp_value);
			format(PlayerInfo[playerid][nomorRekening], 10, "%s", temp_value);
		}

		cache_get_value_name_int(0, "uang", PlayerInfo[playerid][uang]);

		cache_get_value_name_int(0, "playtime", PlayerInfo[playerid][lamaBermain]);

		cache_get_value_name_int(0, "in_house", PlayerInfo[playerid][inHouse]);

		cache_get_value_name_int(0, "login_attempt", PlayerInfo[playerid][loginAttempt]);

		// Get Player Position
		cache_get_value_name(0, "last_x", temp_value);
		PlayerInfo[playerid][last_x] = floatstr(temp_value);
		cache_get_value_name(0, "last_y", temp_value);
		PlayerInfo[playerid][last_y] = floatstr(temp_value);
		cache_get_value_name(0, "last_z", temp_value);
		PlayerInfo[playerid][last_z] = floatstr(temp_value);
		cache_get_value_name(0, "last_a", temp_value);
		PlayerInfo[playerid][last_a] = floatstr(temp_value);
		
		cache_get_value_name_int(0, "last_int", PlayerInfo[playerid][last_int]);
		cache_get_value_name_int(0, "last_vw", PlayerInfo[playerid][last_vw]);

		cache_get_value_name_float(0, "last_hp", PlayerInfo[playerid][lastHp]);
		cache_get_value_name_float(0, "last_armour", PlayerInfo[playerid][lastArmour]);

		cache_get_value_name_float(0, "last_stats_makan", PlayerInfo[playerid][last_stats_makan]);
		cache_get_value_name_float(0, "last_stats_minum", PlayerInfo[playerid][last_stats_minum]);

		loadPlayerSkill(playerid);

		// Pindahkan player
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], 2093.7747, -1806.4586, 13.5499, 87.6500, 0, 0, 0, 0, 0, 0);
		SetPlayerVirtualWorld(playerid, playerid + 100);
		// SpawnPlayer(playerid);

		saveHistoryLogin(playerid);
	
		mysql_format(koneksi, pQuery[playerid], sizePQuery, "\
			SELECT a.*, b.nama AS nama_block \
			FROM user_blocked a \
			INNER JOIN jenis_blocked b ON b.id = a.jenis_block \
			WHERE a.id_user = %d \
				AND (a.expired > NOW() OR a.expired IS NULL) \
			ORDER BY a.id DESC", PlayerInfo[playerid][pID]);
		mysql_tquery(koneksi, pQuery[playerid], "filterLoginPemain", "i", playerid);
	}
	else
	{
		// Cek Nama Format Nama
		if(!cekAllowNama(PlayerInfo[playerid][pPlayerName])){
			// Sendclient messagenya sengaja dipisah agar pengeksekusiannya terstruktur dan tidak didahului oleh perintah Kick dikarenakan jika satu Sendclientmessage dengan string yang panjang, rendernya juga lama.
			SendClientMessage(playerid, COLOR_RED, "Nama yang anda gunakan tidak mengikuti rules server!");
			SendClientMessage(playerid, COLOR_YELLOW, "Nama hanya dapat berisi huruf dan _ (underscore), nama juga harus terdiri dari minimal 3 karakter.");
			SendClientMessage(playerid, COLOR_YELLOW, "Nama tidak dapat diawali dan diakhiri underscore!");
			KickEx(playerid);
			return 1;
		}

		PlayerInfo[playerid][tampilHUDStats] = true;		

		// Spawn player
		SetSpawnInfo(playerid, 0, 0, 2093.7747,-1806.4586,13.5499,87.6500, 0, 0, 0, 0, 0, 0);
		SetPlayerVirtualWorld(playerid, playerid + 100);
		// SpawnPlayer(playerid);

        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, WHITE"SILAHKAN DAFTAR", WHITE"Kamu "RED"belum "WHITE"terdaftar di server","Daftar","Keluar");
	}
	return 1;

}

publicFor: filterLoginPemain(playerid){
	if(cache_num_rows()){
		new nama_block[100], 
			happen[100],
			berakhir[100],
			keterangan[255];
		
		cache_get_value_name(0, "nama_block", nama_block);
		cache_get_value_name(0, "happen", happen);
		cache_get_value_name(0, "expired", berakhir);
		cache_get_value_name(0, "keterangan", keterangan);

		format(pDialog[playerid], sizePDialog, WHITE"Selamat datang kembali "GREEN"%s\n\n", PlayerInfo[playerid][pPlayerName]);
		strcatEx(pDialog[playerid], sizePDialog, ORANGE"Maaf saat ini akun kamu sedang diblock.\n");
		strcatEx(pDialog[playerid], sizePDialog, YELLOW"Dengan ketentuan sebagai berikut :\n\n");
		strcatEx(pDialog[playerid], sizePDialog, WHITE"->\tJenis Block \t: "ORANGE"%s\n", nama_block);
		strcatEx(pDialog[playerid], sizePDialog, WHITE"->\tTerjadi pada \t: "RED"%s\n", happen);
		strcatEx(pDialog[playerid], sizePDialog, WHITE"->\tBerakhir pada \t: "GREEN"%s\n", berakhir);
		strcatEx(pDialog[playerid], sizePDialog, WHITE"->\tKeterangan \t: "YELLOW"%s\n\n", keterangan);
		strcatEx(pDialog[playerid], sizePDialog, YELLOW"Dengan adanya pemblokiran pemain diharapkan dapat lebih tertib dan mengikuti peraturan server.\n");
		strcatEx(pDialog[playerid], sizePDialog, WHITE"Terimakasih, atas pengertiannya.\n");
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Diblockir", pDialog[playerid], "Ok", "");	
		KickEx(playerid);
		return 1;
	}
	format(pDialog[playerid], sizePDialog, WHITE"Selamat datang kembali "GREEN"%s\n\n", PlayerInfo[playerid][pPlayerName]);
	strcatEx(pDialog[playerid], sizePDialog, WHITE"Silahkan masukan password kamu, pastikan untuk memperhatikan huruf besar/kecil.\n");
	strcatEx(pDialog[playerid], sizePDialog, YELLOW"Jika mengalami kesalahan password sebanyak %dx maka kamu akan otomatis dikick.\n", BATAS_SALAH_PASSWORD);
	if(PlayerInfo[playerid][loginAttempt]) strcatEx(pDialog[playerid], sizePDialog, WHITE"\nPercobaan login yang dilakukan "YELLOW"%d "WHITE"dari "RED"%d\n", PlayerInfo[playerid][loginAttempt],  BATAS_SALAH_PASSWORD);

	strcat(pDialog[playerid], WHITE"\n+++++++++++++++++++++ RULES +++++++++++++++++++++\n"RULES_SERVER);

	ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,WHITE"Login", pDialog[playerid], "Login","Keluar");	
	return 1;
}

// Hanya digunakan saat Disconnect dan Connect
// dari_callback = 1 (dari OnPlayerConnect)
// dari_callback = 2 (dari OnPlayerDisconnect)
resetPlayerVariable(playerid, dari_callback){
	if(cache_is_valid(PlayerInfo[playerid][kotakPesan])) cache_delete(PlayerInfo[playerid][kotakPesan]);
	PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;

	if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
	PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;

	PlayerInfo[playerid][pID] = -1;
    PlayerInfo[playerid][pPlayerName][0] = EOS;
    PlayerInfo[playerid][skinID] = -1;
    PlayerInfo[playerid][pPassword][0] = EOS;
    PlayerInfo[playerid][loginKe] = -1;
    PlayerInfo[playerid][uang] = 0;
    PlayerInfo[playerid][jenisKelamin] = -1;
    PlayerInfo[playerid][sHouse] = 0;

	EditingATMID[playerid] = -1;

    PlayerInfo[playerid][ePhone] = 0;
    PlayerInfo[playerid][nomorHP][0] = EOS;
    PlayerInfo[playerid][masaAktifNomor] = 0;
	
    PlayerInfo[playerid][nomorRekening][0] = EOS;

	PlayerInfo[playerid][preloadAnim] = 0;
	PlayerInfo[playerid][lastGlobalChat] = 0;
	PlayerInfo[playerid][reply] = -1;
	PlayerInfo[playerid][sudahLogin] = false;
	PlayerInfo[playerid][sudahSpawn] = false;

	PlayerInfo[playerid][onSelectedTextdraw] = false;
	PlayerInfo[playerid][isOnAnimation] = false;
	PlayerInfo[playerid][isBusy] = false;

	PlayerInfo[playerid][tampilHUDStats] = false;

	lepasTandaTrade(playerid);

	if(PlayerInfo[playerid][activeMarker]) DisablePlayerCheckpoint(playerid);
	PlayerInfo[playerid][activeMarker] = false;

	PlayerInfo[playerid][sisaPalu] = 0;
	PlayerInfo[playerid][sisaGergaji] = 0;

	PlayerInfo[playerid][lamaBermain] = 0;
	PlayerInfo[playerid][waktuSaatLogin] = 0;

	PlayerInfo[playerid][last_x] = 0;
	PlayerInfo[playerid][last_y] = 0;
	PlayerInfo[playerid][last_z] = 0;
	PlayerInfo[playerid][last_a] = 0;

	// Reset skill
	PlayerInfo[playerid][expMekanik] = 0;
	PlayerInfo[playerid][activeMekanik] = 0;
	PlayerInfo[playerid][expMedic] = 0;
	PlayerInfo[playerid][activeMedic] = 0;

	PlayerInfo[playerid][levelMedic] = 0;
	PlayerInfo[playerid][levelPolice] = 0;

	PlayerInfo[playerid][last_int] = 0;
	PlayerInfo[playerid][last_vw] = 0;

	PlayerInfo[playerid][lastHp] = 0;
	PlayerInfo[playerid][lastArmour] = 0;

	PlayerInfo[playerid][loginAttempt] = 0;

	// Timer Pemain
	// Reset ID timer jadi -1 terlebih dahulu
	if(dari_callback == 1) PlayerInfo[playerid][timerPemain] = -1;
	else{
		if(PlayerInfo[playerid][timerPemain] != -1){
			DeletePreciseTimer(PlayerInfo[playerid][timerPemain]);
			PlayerInfo[playerid][timerPemain] = -1;
		}
	}

	PlayerInfo[playerid][hungryStackedTime] = 0;
	PlayerInfo[playerid][thirstyStackedTime] = 0;

	DeletePreciseTimer(PlayerAction[playerid][timerNambang]);
	PlayerAction[playerid][sedangNambang] = false;

	EditingObject[playerid] = EDITING_NONE;
}

ResetPVarTemporary(playerid){
	DeletePVar(playerid, "buatveh_id");
	DeletePVar(playerid, "buatveh_col");
	DeletePVar(playerid, "sharelock_pemilik");
	DeletePVar(playerid, "fixbayar_idpv");
	DeletePVar(playerid, "veh_select_id");
	DeletePVar(playerid, "halaman");
	DeletePVar(playerid, "index_terpilih");

	PlayerInfo[playerid][isBusy] = false;

	if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
	PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;
}

resetPVarInventory(playerid){
	DeletePVar(playerid, "inv_indexlist");
	DeletePVar(playerid, "inv_model");
	DeletePVar(playerid, "inv_jumlah");
	DeletePVar(playerid, "inv_keterangan");
	DeletePVar(playerid, "inv_target_id");

	if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
	PlayerInfo[playerid][tempCache] = MYSQL_INVALID_CACHE;
}

loadPlayerSkill(playerid){
	inline responseQuery(){
		new rows, idx = 0;
		cache_get_row_count(rows);
		if(rows){
			new id_skill, exp_skill, is_active;
			while(idx < rows)
			{
				cache_get_value_name_int(idx, "id_skill", id_skill);
				cache_get_value_name_int(idx, "exp", exp_skill);
				cache_get_value_name_int(idx, "is_active", is_active);

				switch(id_skill){
					case 1: // Mekanik
					{
						PlayerInfo[playerid][expMekanik] = exp_skill;
						PlayerInfo[playerid][activeMekanik] = is_active;
						break;
					}
					case 2: // Cheff
					{
						PlayerInfo[playerid][expMedic] = exp_skill;
						PlayerInfo[playerid][activeMedic] = is_active;
						break;
					}
				}
				idx++;
			}
		}
	}
	MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT * FROM user_skill WHERE id_user = %d", PlayerInfo[playerid][pID]);
}

publicFor: registerUser(playerid)
{
	new EncryptedPassword[65];
	SHA256_PassHash(registerInfo[playerid][registerPassword], PlayerInfo[playerid][pPlayerName], EncryptedPassword, 64);

	inline responseQuery(){
		PlayerInfo[playerid][pID] = cache_insert_id();
		PlayerInfo[playerid][loginKe] = 1;
		PlayerInfo[playerid][jenisKelamin] = registerInfo[playerid][jenisKelamin];

		PlayerInfo[playerid][sudahLogin] = true;
		PlayerInfo[playerid][waktuSaatLogin] = gettime();
		PlayerInfo[playerid][lamaBermain] = 0;

		mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO user_item_limit(id_user, jumlah, expired) VALUES('%d', '%d', NULL)", PlayerInfo[playerid][pID], DEFAULT_LIMIT_ITEM);
		mysql_tquery(koneksi, pQuery[playerid]);
		PlayerInfo[playerid][limitItem] = DEFAULT_LIMIT_ITEM;

		setUangPlayer(playerid, 100);
		// tampilkanTextDrawUang(playerid);

		// Register dan bind skin
		updatePlayerCurrentSkin(playerid, registerInfo[playerid][freeSkinID]);

		saveHistoryLogin(playerid);
		spawnPemain(playerid);
	}
	MySQL_TQueryInline(koneksi, using inline responseQuery, "INSERT INTO `user` (nama, password, jumlah_login, join_date, jenis_kelamin, email, account_status, current_skin) VALUES ('%e', '%e', '1', NOW(), '%d', '%e', '0', '%d')", PlayerInfo[playerid][pPlayerName], EncryptedPassword, registerInfo[playerid][jenisKelamin], registerInfo[playerid][email], registerInfo[playerid][freeSkinID]);
	return 1;
}

dialogEmail(playerid){
	ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", WHITE"Masukan email anda, kami hanya mensupport email "RED"@gmail.com\n:", "Simpan", "Keluar");
}

publicFor: spawnPemain(playerid)
{
	if(PlayerInfo[playerid][sudahSpawn]) return 1;
	PlayerInfo[playerid][sudahSpawn] = true;
	new house_Id = PlayerInfo[playerid][sHouse];

	// Tampilkan hanya jika settingan hidup
	if(PlayerInfo[playerid][tampilHUDStats]) tampilkanHUDStats(playerid);

	if(PlayerInfo[playerid][timerPemain] == -1)
		PlayerInfo[playerid][timerPemain] = SetPreciseTimer("pemainUpdate", INTERVAL_WAKTU_UPDATE_PEMAIN * 1000, true, "i", playerid);

	if(PlayerInfo[playerid][last_stats_makan] == 0 && PlayerInfo[playerid][last_stats_minum] == 0){
		setStatusMakanPemain(playerid, 80);
		setStatusMinumPemain(playerid, 80);
	}else{
		setStatusMakanPemain(playerid, PlayerInfo[playerid][last_stats_makan]);
		setStatusMinumPemain(playerid, PlayerInfo[playerid][last_stats_minum]);

		PlayerInfo[playerid][last_stats_makan] = 0;
		PlayerInfo[playerid][last_stats_minum] = 0;
	}
	
	if(!(PlayerInfo[playerid][last_x] == 0 && PlayerInfo[playerid][last_y] == 0 && PlayerInfo[playerid][last_z] == 0 && PlayerInfo[playerid][last_a] == 0) && PlayerInfo[playerid][sudahLogin]){
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], PlayerInfo[playerid][last_x], PlayerInfo[playerid][last_y], PlayerInfo[playerid][last_z], PlayerInfo[playerid][last_a], 0, 0, 0, 0, 0, 0);
		
		SpawnPlayer(playerid);

		pindahkanPemain(playerid, PlayerInfo[playerid][last_x], PlayerInfo[playerid][last_y], PlayerInfo[playerid][last_z], PlayerInfo[playerid][last_a], PlayerInfo[playerid][last_int], PlayerInfo[playerid][last_vw], true);

		TogglePlayerControllable(playerid, 0);
		SetPreciseTimer("GantiSkinSaatSpawn", 2000, false, "i", playerid);
		
		if(PlayerInfo[playerid][lastHp] > 0) {
			SetPlayerHealth(playerid, PlayerInfo[playerid][lastHp]);
			if(PlayerInfo[playerid][lastArmour] > 0) SetPlayerArmour(playerid, PlayerInfo[playerid][lastArmour]);
		}

		PlayerInfo[playerid][lastHp] = 0;
		PlayerInfo[playerid][lastArmour] = 0;

		PlayerInfo[playerid][last_x] = 0;
		PlayerInfo[playerid][last_y] = 0;
		PlayerInfo[playerid][last_z] = 0;
		PlayerInfo[playerid][last_a] = 0;
		PlayerInfo[playerid][last_vw] = 0;
		PlayerInfo[playerid][last_int] = 0;
	}else{
		if(house_Id != 0){
			SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], houseInfo[house_Id][icon_x], houseInfo[house_Id][icon_y], houseInfo[house_Id][icon_z], 0, 0, 0, 0, 0, 0, 0);
				
			SpawnPlayer(playerid);
			
			pindahkanPemain(playerid, houseInfo[house_Id][icon_x], houseInfo[house_Id][icon_y], houseInfo[house_Id][icon_z], 0, 0, 0, true);

			TogglePlayerControllable(playerid, 0);
			SetPreciseTimer("GantiSkinSaatSpawn", 2000, false, "i", playerid);

			if(PlayerInfo[playerid][lastHp] > 0) {
				SetPlayerHealth(playerid, PlayerInfo[playerid][lastHp]);
				if(PlayerInfo[playerid][lastArmour] > 0) SetPlayerArmour(playerid, PlayerInfo[playerid][lastArmour]);
			}
			
			PlayerInfo[playerid][lastHp] = 0;
			PlayerInfo[playerid][lastArmour] = 0;

			PlayerInfo[playerid][last_x] = 0;
			PlayerInfo[playerid][last_y] = 0;
			PlayerInfo[playerid][last_z] = 0;
			PlayerInfo[playerid][last_a] = 0;
			PlayerInfo[playerid][last_vw] = 0;
			PlayerInfo[playerid][last_int] = 0;
		}else{
			if(PlayerInfo[playerid][loginKe] == 1){
				ShowPlayerDialog(playerid, DIALOG_PILIH_SPAWN_REGISTER, DIALOG_STYLE_LIST, "Pilih tempat spawn yang anda inginkan : ", "Pantai Santa Maria\nStasiun Kereta Api Los Santos\nBandara Los Santos", "Pilih", "");
				return 1;
			}

			new random_spawn = random(sizeof(SPAWN_POINT));
			SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], SPAWN_POINT[random_spawn][SPAWN_POINT_X], SPAWN_POINT[random_spawn][SPAWN_POINT_Y], SPAWN_POINT[random_spawn][SPAWN_POINT_Z], SPAWN_POINT[random_spawn][SPAWN_POINT_A], 0, 0, 0, 0, 0, 0);
			
			SpawnPlayer(playerid);

			pindahkanPemain(playerid, SPAWN_POINT[random_spawn][SPAWN_POINT_X], SPAWN_POINT[random_spawn][SPAWN_POINT_Y], SPAWN_POINT[random_spawn][SPAWN_POINT_Z], SPAWN_POINT[random_spawn][SPAWN_POINT_A], SPAWN_POINT[random_spawn][SPAWN_POINT_INTERIOR], SPAWN_POINT[random_spawn][SPAWN_POINT_VW], true);

			TogglePlayerControllable(playerid, 0);
			SetPreciseTimer("GantiSkinSaatSpawn", 2000, false, "i", playerid);
		}
	}
	// Sinkronkan uang pemain
	getUangPlayer(playerid);
	return 1;
}

publicFor: GantiSkinSaatSpawn(playerid){
	TogglePlayerControllable(playerid, 1);
	ubahSkinPemain(playerid, PlayerInfo[playerid][skinID]);
}

publicFor: updatePlayerCurrentPhone(playerid, iditem){
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT a.use_phone, b.id_user_item, c.nama_item FROM `user` a LEFT JOIN `user_item` b ON b.id_user = a.id LEFT JOIN `item` c ON a.use_phone = c.id_item WHERE a.id = '%d'", PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid], "checkIfPhoneExist", "dd", playerid, iditem);
	return 1;
}

publicFor: checkIfPhoneExist(playerid, itemid){
	if(cache_num_rows()){
		new id_phone, id_user_item, old_nama_item[100], pesan[256], nama_item[256];
		getNamaByIdItem(itemid, nama_item);

		cache_get_value_name_int(0, "use_phone", id_phone);
		cache_get_value_name_int(0, "id_user_item", id_user_item);
		cache_get_value_name(0, "nama_item", old_nama_item);

		if(id_user_item == 0){
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Invalid item", WHITE"Anda tidak memiliki item yang dimaksud!", "Ok", "");
			return 1;
		}
		else if(id_phone == itemid)
		{
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Invalid item", WHITE"Anda sudah menggunakan item tersebut!", "Ok", "");
			return 1;
		}
		
		
		format(pesan, sizeof(pesan), WHITE"Anda berhasil menggunakan "GREEN"%s "WHITE"!\n", nama_item);
		
		if(id_phone != 0){
			// Lakukan pengembalian barang yang sudah terpasang
			tambahItemPlayer(playerid, id_phone, 1);
			format(pDialog[playerid], sizePDialog, "Barang anda "BLUE"%s "WHITE"sudah dikembalikan ke inventory, silahkan cek kembali!", old_nama_item);
			strcat(pesan, pDialog[playerid]);
		}
		// Lakukan pengurangan barang yang akan dipakai
		tambahItemPlayer(playerid, itemid, -1);

		// Set item terequip
		mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET use_phone = '%d' WHERE id = '%d'",itemid, PlayerInfo[playerid][pID]);
		mysql_tquery(koneksi, pQuery[playerid]);

		// Set player variabel
		PlayerInfo[playerid][ePhone] = itemid;

		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menggunakan item", pesan, "Ok", "");
	}
	return 1;
}

publicFor: cekPesanTerkirim(playerid){
	new banyak_pesan;
	cache_get_value_name_int(0, "banyak_pesan", banyak_pesan);
	if(banyak_pesan >= MAX_SMS_PER_PLAYER){
		format(pDialog[playerid], sizePDialog, WHITE"Anda telah mencapai batas maksimal pesan yang dapat dikirim yaitu "YELLOW"%d "WHITE"per "RED"%d"WHITE".\nSilahkan hapus terlebih dahulu "YELLOW"kotak terkirim "WHITE"anda!", banyak_pesan, MAX_SMS_PER_PLAYER);
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Maksimum limit pesan", pDialog[playerid], "Ok", "");
		return 1;
	}	

	ShowPlayerDialog(playerid, DIALOG_SMS_MASUKAN_NOMOR, DIALOG_STYLE_INPUT, WHITE"Nomor HP penerima", WHITE"Masukan nomor HP penerima dengan lengkap :", "Ok", "Batal");
	return 1;
}

publicFor: cekNomorPenerima(playerid){
	new banyak_pesan, id_penerima;
	cache_get_value_name_int(0, "banyak_pesan", banyak_pesan);
	cache_get_value_name_int(0, "id", id_penerima);
	if(id_penerima && id_penerima != PlayerInfo[playerid][pID]){
		if(banyak_pesan >= MAX_SMS_PER_PLAYER){
			format(pDialog[playerid], sizePDialog, WHITE"Penerima telah mencapai batas maksimal pesan yang dapat diterima yaitu "YELLOW"%d "WHITE"per "RED"%d"WHITE".\nAnda hanya dapat mengirim saat penerima sudah menghapus "YELLOW"kotak masuknya "WHITE"dan menyisihkan tempat untuk pesan anda!", banyak_pesan, MAX_SMS_PER_PLAYER);
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Maksimum limit pesan", pDialog[playerid], "Ok", "");
			return 1;
		}
		SetPVarInt(playerid, "sms_id_penerima", id_penerima);
		ShowPlayerDialog(playerid, DIALOG_SMS_MASUKAN_PESAN, DIALOG_STYLE_INPUT, WHITE"Pesan yang akan dikirim", WHITE"Masukan pesan yang ingin anda kirimkan :", "Ok", "Batal");
	}else{
		ShowPlayerDialog(playerid, DIALOG_SMS_MASUKAN_NOMOR, DIALOG_STYLE_INPUT, WHITE"Nomor HP penerima", RED"Nomor HP yang anda masukan tidak ditemukan!\nPastikan nomor tersebut aktif dan akurat, pastikan juga anda tidak memasukan nomor anda sendiri!\n"WHITE"Masukan nomor HP penerima dengan lengkap :", "Ok", "Batal");
		return 1;
	}
	return 1;
}

publicFor: lihatPesanMasuk(playerid){
	new rows;
	cache_get_row_count(rows);
	if(rows){
		new subString[60], id_sms, nomor[16], tanggal[35];
		new string[BANYAK_DATA_PER_PAGE * 60] = "Kode SMS\tPengirim\tTanggal Waktu\n";
		for(new i = 0; i < rows; i++){
			cache_get_value_name(i, "nomor_handphone", nomor);
			cache_get_value_name(i, "tanggal_dikirim", tanggal);
			cache_get_value_name_int(i, "id_sms", id_sms);

			format(subString, sizeof(subString), "%i\t%s\t%s\n", id_sms, nomor, tanggal);
			strcat(string, subString);
		}
		strcat(string, ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

		format(subString, 60, WHITE"Kotak Masuk "GREEN"(page : %d)", GetPVarInt(playerid, "halaman") + 1);
		ShowPlayerDialog(playerid, DIALOG_KOTAK_MASUK, DIALOG_STYLE_TABLIST_HEADERS, subString, string, "Pilih", "Keluar");

		if(cache_is_valid(PlayerInfo[playerid][kotakPesan])) cache_delete(PlayerInfo[playerid][kotakPesan]);
		PlayerInfo[playerid][kotakPesan] = cache_save();
		return 1;
	}else{
		if(GetPVarInt(playerid, "halaman") < 1)
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"Kotak Masuk Kosong", WHITE"Saat ini kotak masuk anda kosong!\nSilahkan cek kembali saat kotak masuk berisi, ya.", "Ok", "");
		else{ // Kembalikan ke halaman sebelumnya
			SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
			tampilkanKotakMasuk(playerid);
		}
	}
	return 1;
}

publicFor: lihatPesanTerkirim(playerid){
	new rows;
	cache_get_row_count(rows);
	if(rows){
		new subString[60], id_sms, nomor[16], tanggal[35];
		new string[BANYAK_DATA_PER_PAGE * 60] = "Kode SMS\tPenerima\tTanggal Waktu\n";
		for(new i = 0; i < rows; i++){
			cache_get_value_name(i, "nomor_handphone", nomor);
			cache_get_value_name(i, "tanggal_dikirim", tanggal);
			cache_get_value_name_int(i, "id_sms", id_sms);

			format(subString, sizeof(subString), "%i\t%s\t%s\n", id_sms, nomor, tanggal);
			strcat(string, subString);
		}
		strcat(string, ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");
		format(subString, 60, WHITE"Kotak Terkirim "GREEN"(page : %d)", GetPVarInt(playerid, "halaman") + 1);
		ShowPlayerDialog(playerid, DIALOG_KOTAK_TERKIRIM, DIALOG_STYLE_TABLIST_HEADERS, subString, string, "Pilih", "Keluar");

		if(cache_is_valid(PlayerInfo[playerid][kotakPesan])) cache_delete(PlayerInfo[playerid][kotakPesan]);
		PlayerInfo[playerid][kotakPesan] = cache_save();
		return 1;
	}else{
		if(GetPVarInt(playerid, "halaman") < 1)
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"Kotak Terkirim Kosong", WHITE"Saat ini kotak terkirim anda kosong!\nSilahkan cek kembali saat kotak terkirim berisi, ya.", "Ok", "");
		else{ // Kembalikan ke halaman sebelumnya
			SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
			tampilkanKotakTerkirim(playerid);
		}		
	}
	return 1;
}

publicFor: updatePlayerCurrentSkin(playerid, skinid){
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET current_skin = '%d' WHERE id = '%d'",skinid, PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid]);

	// Kembalikan skin yang lama
	tambahSkinPlayer(playerid, PlayerInfo[playerid][skinID], 1, false);

	// Kurangkan skin yang baru
	tambahSkinPlayer(playerid, skinid, -1, false);
	PlayerInfo[playerid][skinID] = skinid;
	return 1;
}

publicFor: tampilInventorySkinPlayer(playerid){
	new rows, string[500], subString[20], id_skin, jumlah;
	cache_get_row_count(rows);
	if(rows){
		for(new i = 0; i < rows; i++){
			cache_get_value_name_int(i, "jumlah", jumlah);
			cache_get_value_name_int(i, "id_skin", id_skin);
			format(subString, sizeof(subString), "%i\t~g~%i\n", id_skin, jumlah);
			strcat(string, subString);
		}
		ShowPlayerDialog(playerid, DIALOG_PILIH_SKIN, DIALOG_STYLE_PREVIEW_MODEL, "~w~Pilih skin anda :", string, "~w~Pilih", "Kembali");
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Tidak terdapat skin", WHITE"Tidak terdapat skin pada inventory anda.", "Ok", "");
	}
	return 1; // For deleteing cache tquery
}

publicFor: hitungGaji(playerid, tipe){
	new nominal;
	cache_get_value_name_int(0, "nominal", nominal);
	if(nominal > 0){
		if(tipe == 0){ // Ambil gaji via bank
			addTransaksiTabungan(PlayerInfo[playerid][nomorRekening], nominal, "Pencairan gaji");
		}else if(tipe == 1){ // Ambil gaji via kontan
			givePlayerUang(playerid, nominal);
		}
		mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `gaji` SET `status` = '1' WHERE id_user = '%d' AND status = '0'", PlayerInfo[playerid][pID]);
		mysql_tquery(koneksi, pQuery[playerid]);

		format(pDialog[playerid], sizePDialog, WHITE"Selamat anda berhasil mengambil gaji anda.\nGaji anda yang berhasil anda ambil sebesar "GREEN"$%d"WHITE".\n"YELLOW"Gaji yang sudah diterima tidak dapat claim kembali.", nominal);
		showDialogPesan(playerid, GREEN"Berhasil mengambil gaji", pDialog[playerid]);
	}else{
		showDialogPesan(playerid, RED"Kotak gaji kosong", WHITE"Gaji anda saat ini sedang kosong!\nUntuk dapat mengambil gaji anda harus bekerja terlebih dahulu, kemudian anda dapat mengambil gaji disini!");
	}
	return 1;
}

publicFor: tampilInventoryFurniturePlayer(playerid){
	new rows, jumlah, nama_furniture[100];
	cache_get_row_count(rows);
	new string[1500] = "Nama\tJumlah\n"WHITE;
	if(rows){
		for(new i = 0; i < rows; i++){
			cache_get_value_name_int(i, "jumlah", jumlah);
			cache_get_value_name(i, "nama_furniture", nama_furniture);
			strcatEx(string, sizeof(string), "%s\t%i\n", nama_furniture, jumlah);
		}
		strcat(string, ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

		// Save cache
		// IMPORTANT - PASTIKAN UNTUK SELALU MENGHAPUS SEBELUM MENYIMPAN CACHE YANG BARU
		if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
		PlayerInfo[playerid][tempCache] = cache_save();

		new subString[64];
		format(subString, 64, WHITE"Pilih furniture anda : "GREEN"(page : %d)", GetPVarInt(playerid, "halaman") + 1);
		ShowPlayerDialog(playerid, DIALOG_PILIH_FURNITURE, DIALOG_STYLE_TABLIST_HEADERS, subString, string, "Pilih", "Kembali");
	}else{
		if(GetPVarInt(playerid, "halaman") < 1)
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Inventory furniture "RED"kosong", WHITE"Maaf saat ini inventory furniture anda tidak berisi apapun!\n"YELLOW"Anda bisa mendapatkan furniture dari berbelanja ataupun saling bertukar furniture kepada player lain!", "Ok", "");
		else{ // Kembalikan ke halaman sebelumnya
			SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
			showDialogListFurniturePemain(playerid);
		}
	}

	return 1; // For deleteing cache tquery
}

publicFor: tampilInventoryBarangPlayer(playerid){
	new rows;
	cache_get_row_count(rows);
	if(rows){
		format(pDialog[playerid], sizePDialog, "Nama\tJumlah\tKapasitas per Item\tKapasitas Terpakai\n");
		new subString[64], jumlah, nama_item[100], kapasitas, id_item;
		for(new i = 0; i < rows; i++){
			cache_get_value_name_int(i, "id_item", id_item);
			cache_get_value_name_int(i, "jumlah", jumlah);
			cache_get_value_name(i, "nama_item", nama_item);
			cache_get_value_name_int(i, "kapasitas", kapasitas);

			strcatEx(pDialog[playerid], sizePDialog, "%s%s\t"WHITE"%i\t%i\t%i\n", GetColorRarity(getRarityByIdItem(id_item)), nama_item, jumlah, kapasitas, kapasitas * jumlah);
		}
		strcat(pDialog[playerid], ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

		if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
		PlayerInfo[playerid][tempCache] = cache_save();

		format(subString, 64, WHITE"Pilih barang anda : "GREEN"(page : %d)", GetPVarInt(playerid, "halaman") + 1);
		ShowPlayerDialog(playerid, DIALOG_PILIH_ITEM, DIALOG_STYLE_TABLIST_HEADERS, subString, pDialog[playerid], "Pilih", "Kembali");
	}else{
		if(GetPVarInt(playerid, "halaman") < 1)
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Inventory item "RED"kosong", WHITE"Maaf saat ini inventory item anda tidak berisi apapun!\n"YELLOW"Anda bisa mendapatkan item dari bekerja, berbelanja, ataupun saling bertukar item kepada player lain!", "Ok", "");
		else{ // Kembalikan ke halaman sebelumnya
			SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
			showDialogListItem(playerid);
		}
	}

	return 1; // For deleteing cache tquery
}

publicFor: tambahExpSkillPlayer(playerid, skillid, jumlah){
	switch(skillid){
		case ID_SKILL_MEKANIK: // Mekanik
		{
			PlayerInfo[playerid][expMekanik] += jumlah;
		}
		case ID_SKILL_MEDIC: // Medic
		{
			PlayerInfo[playerid][expMedic] += jumlah;
		}
	}

	// Pakai trigger procedure
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "CALL tambah_exp_skill(%d, %d, %d)", PlayerInfo[playerid][pID], skillid, jumlah);
	mysql_tquery(koneksi, pQuery[playerid]);
	return 1;
}

publicFor: tambahItemHouse(house_id, itemid, jumlah){
	// Pakai trigger procedure
	new temp_query[100];
	mysql_format(koneksi, temp_query, sizeof(temp_query), "CALL tambah_item_house(%d, %d, %d)", house_id, itemid, jumlah);
	mysql_tquery(koneksi, temp_query);
	return 1;
}

publicFor: tambahItemPlayer(playerid, itemid, jumlah){
	// Pakai trigger procedure
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "CALL tambah_item(%d, %d, %d)", PlayerInfo[playerid][pID], itemid, jumlah);
	mysql_tquery(koneksi, pQuery[playerid]);
	return 1;
}

publicFor: tambahFurniturePlayer(playerid, furnitureid, jumlah){
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "CALL tambah_furniture(%d, %d, %d)", PlayerInfo[playerid][pID], furnitureid, jumlah);
	mysql_tquery(koneksi, pQuery[playerid]);
	return 1;
}

publicFor: tambahSkinPlayer(playerid, skinid, jumlah, bool:langsung_gunakan){
	// Pakai trigger procedure
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "CALL tambah_skin(%d, %d, %d)", PlayerInfo[playerid][pID], skinid, jumlah);
	if(langsung_gunakan){
		mysql_tquery(koneksi, pQuery[playerid], "updatePlayerCurrentSkin", "dd", playerid, skinid);
	}else{
		mysql_tquery(koneksi, pQuery[playerid]);
	}
	return 1;
}

// publicFor: cekJumlahItem(playerid, itemid){
// 	if(cache_num_rows()){
// 		new jumlah, keterangan[500];
// 		cache_get_value_name_int(0, "jumlah", jumlah);

// 		if(jumlah > 0){
// 			SetPVarInt(playerid, "inv_indexlist", itemid);
// 			SetPVarInt(playerid, "inv_model", getModelByIdItem(itemid));
// 			SetPVarInt(playerid, "inv_jumlah", jumlah);

// 			getKeteranganByIdItem(itemid, keterangan);
// 			SetPVarString(playerid, "inv_keterangan", keterangan);

// 			ShowPlayerDialog(playerid, DIALOG_OPTION_ITEM_INVENTORY, DIALOG_STYLE_LIST, WHITE"Pilih aksi", GREEN"Pakai Item\n"WHITE"Beritahu Item\n"WHITE"Info Item\n"ORANGE"Kunci/Buka Item\n"RED"Buang Item", "Ok", "Keluar");
// 		}else{
// 			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Barang tidak ada!", WHITE"Maaf! Anda tidak memiliki barang tersebut!", "Ok", "");
// 			resetPVarInventory(playerid);
// 		}
// 	}else{
// 		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Barang tidak ada!", WHITE"Maaf! Anda tidak memiliki barang tersebut!", "Ok", "");
// 		resetPVarInventory(playerid);
// 	}
// 	return 1;
// }

/*
	ITEM USE TRIGGER
*/
publicFor: itemTidakDapatDipakai(playerid){
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"Item tidak dapat dipakai", WHITE"Maaf item yang anda pilih bukan merupakan jenis item yang dapat digunakan.\nAnda dapat memilih item lain yang dapat digunakan.", "Ok", "");

	resetPVarInventory(playerid);
	return 1;
}

publicFor: pakaiHpFromInven(playerid, itemid){
	updatePlayerCurrentPhone(playerid, itemid);
	resetPVarInventory(playerid);
	return 1;
}

// KTP

publicFor: cekKetersediaanItemBuatKTP(playerid, cukup){
    new hasil;
    cache_get_value_name_int(0, "hasil", hasil);
    if(cukup){
		// Proses pembuatan KTP dalam menit
		tambahItemPlayer(playerid, 5, -4);
		tambahItemPlayer(playerid, 6, -2);
		givePlayerUang(playerid, -100);

		prosesPembuatanKTP(playerid, 30);

        ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membuat KTP", "Berhasil membuat KTP, "YELLOW"pembuatan KTP akan memakan waktu sekitar 30 menit real-time."WHITE"\nAnda dapat mengeceknya dan mengambilnya pada resepsionis kembali, setelah sudah 30 menit berlalu.\n\nTerimakasih, Salam hangat "ORANGE"Pemerintah Lost Santos", "Ok", "");
    }else{
        ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Gagal membuat KTP", WHITE"Maaf item yang diperlukan tidak mencukupi.", "Ok", "");
	}
    return 1;
}

publicFor: isBisaBuatKTP(playerid, tidak_bisa){
	if(tidak_bisa){
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Anda telah memiliki KTP", WHITE"Maaf anda telah memiliki KTP, anda tidak dapat membuatnya lagi.", "Ok", "");
	}else{
		ShowPlayerDialog(playerid, DIALOG_CONFIRM_BUAT_KTP, DIALOG_STYLE_MSGBOX, "Buat KTP", WHITE"Anda harus memiliki "GREEN"100 "WHITE"Rupiah, "YELLOW"4 "WHITE"pas foto, "GREEN"2 "WHITE"Materai.\nApakah anda yakin sudah memiliki semua material yang dibutuhkan?", "Buat", "Batal");
	}
	return 1;
}

publicFor: isPunyaKTP(playerid, punya){
	if(punya){
		new nomor_hp[16];
		GetPVarString(playerid, "temp_nomor_hp", nomor_hp, 16);

		format(pDialog[playerid], sizePDialog, WHITE"Anda akan mendaftarkan nomor "GREEN"%s "WHITE"sebagai nomor HP anda.\n\n"YELLOW"Anda membutuhkan KTP dan uang sebesar "GREEN"$100 "YELLOW"untuk dapat mendaftarkan nomor HP.\n"WHITE"Apakah anda yakin?", nomor_hp);
		ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_DAFTAR_NOMOR_HP, DIALOG_STYLE_MSGBOX, "Konfirmasi pendaftaran", pDialog[playerid], "Daftar", "Batal");
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Tidak memiliki KTP", WHITE"Maaf anda tidak memiliki KTP.", "Ok", "");
	}
	return 1;
}

publicFor: pakaiPaluTambang(playerid){
	if(PlayerInfo[playerid][sisaPalu] > 0) return error_command(playerid, "Anda masih memiliki sisa item, silahkan habiskan terlebih dahulu.");
	tambahItemPlayer(playerid, 8, -1);
	PlayerInfo[playerid][sisaPalu] += 15;

	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menggunakan item", "Penggunaan 1 item "YELLOW"Palu Tambang = "GREEN"Penambahan kesempatan menambang sebanyak 15 kali.\n"RED"Note : Saat anda disconnect dari server maka kesempatan menambang anda direset jadi 0.", "Ok", "");
	return 1;
}

publicFor: pakaiGergajiMesin(playerid){
	if(PlayerInfo[playerid][sisaGergaji] > 0) return error_command(playerid, "Anda masih memiliki sisa item, silahkan habiskan terlebih dahulu.");
	tambahItemPlayer(playerid, 26, -1);
	PlayerInfo[playerid][sisaGergaji] += 15;

	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menggunakan item", "Penggunaan 1 item "YELLOW"Gergaji Mesin = "GREEN"Penambahan kesempatan memotong sebanyak 15 kali.\n"RED"Note : Saat anda disconnect dari server maka kesempatan memotong anda direset jadi 0.", "Ok", "");
	return 1;
}

publicFor: pakaiTombakIkan(playerid){
	if(PlayerInfo[playerid][sisaTombak] > 0) return error_command(playerid, "Anda masih memiliki sisa item, silahkan habiskan terlebih dahulu.");
	tambahItemPlayer(playerid, 36, -1);
	PlayerInfo[playerid][sisaTombak] += 15;

	SetPlayerArmedWeapon(playerid, 0);
	SetPlayerAttachedObject(playerid, TOMBAK_ATTACH_INDEX, 11716, 6, 0.048, 0.029, 0.103, -80.0, 80.0, 0.0);
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menggunakan item", "Penggunaan 1 item "YELLOW"Tombak Ikan = "GREEN"Penambahan kesempatan pakai tombak ikan sebanyak 15 kali.\n"RED"Note : Saat anda disconnect dari server maka kesempatan pakai tombak ikan anda direset jadi 0.", "Ok", "");
	return 1;
}

publicFor: pakaiJoranPancing(playerid){
	tambahItemPlayer(playerid, 35, -1);
	PlayerInfo[playerid][sisaJoran] += 10;

	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menggunakan item", "Penggunaan 1 item "YELLOW"Joran Pancing = "GREEN"Penambahan kesempatan pakai joran pancing sebanyak 10 kali.\n"RED"Note : Saat anda disconnect dari server maka kesempatan pakai tombak ikan anda direset jadi 0.", "Ok", "");
	return 1;
}

pakaiBibit(playerid, const nama_item[], id_bibit, id_buah){
	new Float: x, Float: y, Float: z, Float: a, Float: tmp, Float: x1, Float: y1, Float: x2, Float: y2,
	id = Iter_Free(PlantIterator), plant_Id = GetClosestPlant(playerid),
	vehid = GetPlayerVehicleID(playerid);
	if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada diluar Interior atau Virtual World 0!");
	if(id == -1 || playerMaxPlant(playerid)) return error_command(playerid, "Tidak dapat menanam bibit lagi, tunggu hingga beberapa tanaman dipanen.");
	if(plant_Id != -1) return error_command(playerid, "Anda tidak dapat menanam di tempat yang sudah ditanami bibit.");
	if(IsPlayerInVehicle(playerid, vehid)) return error_command(playerid, "Tidak dapat menanam bibit di dalam kendaraan.");
	if(!CA_IsPlayerOnSurface(playerid) || CA_IsPlayerNearWater(playerid)) return error_command(playerid, "Anda tidak berada di permukaan tanah.");
	GetPlayerPos(playerid, x, y, z);
	new obj = CA_RayCastLine(x, y, z+1.0, x, y, z-2.0, tmp, tmp, tmp);
	if(IsSurfacePlant(obj)){
		x1 = CA_RayCastLine(x, y, z+0.5, x+5.0, y, z, tmp, tmp, tmp);
		x2 = CA_RayCastLine(x, y, z+0.5, x-5.0, y, z, tmp, tmp, tmp);
		y1 = CA_RayCastLine(x, y, z+0.5, x, y+5.0, z, tmp, tmp, tmp);
		y2 = CA_RayCastLine(x, y, z+0.5, x, y-5.0, z, tmp, tmp, tmp);
		if(x1 == 0 && x2 == 0 && y1 == 0 && y2 == 0){
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 0, 0, 1, 0, 1);
			GetPlayerFacingAngle(playerid, a);
			x += (3.0 * floatsin(-a, degrees));
			y += (3.0 * floatcos(-a, degrees));
			z -= 1.0;
			createPlant(id, nama_item, id_buah, x, y, z, 0.0, 0.0, 0.0);
			tambahItemPlayer(playerid, id_bibit, -1);
			format(pDialog[playerid], sizePDialog, WHITE"Penggunaan 1 item "YELLOW"Bibit %s"WHITE".\n"RED"Note :\n- Jaga tanaman anda atau tanaman anda akan dicuri.\n- Tanaman dapat hilang sewaktu-waktu, segera panen jika sudah siap.", nama_item);
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menggunakan item", pDialog[playerid], "Ok", "");
			ClearAnimations(playerid);
		}else{
			error_command(playerid, "Maaf permukaan ini tidak datar dan tidak dapat ditanami bibit.");
		}
	}else{
		error_command(playerid, "Maaf permukaan ini tidak dapat ditanami bibit.");
	}
	return 1;
}

publicFor: pakaiBibitJeruk(playerid){
	pakaiBibit(playerid, "Jeruk", 31, 32);
	return 1;
}

publicFor: pakaiBibitGanja(playerid){
	pakaiBibit(playerid, "Ganja", 33, 34);
	return 1;
}

pakaiNarko(playerid, const nama_item[], id_item, persen){
	new Float:depth, Float:depth2, Float:tambahArmour = PlayerInfo[playerid][lastArmour]+persen;
	if(CA_IsPlayerInWater(playerid, depth, depth2)) return error_command(playerid, "Tidak dapat menggunakan item ini di dalam air.");
	if(PlayerInfo[playerid][lastArmour] > 0 || tambahArmour <= 50){
		//ApplyAnimation(playerid,"SMOKING", "m_smkstnd_loop", 4.0, 1, 0, 0, 0, 0);
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_SMOKE_CIGGY);
		SetPlayerDrunkLevel (playerid, 5000);
		puyengSecs[playerid] = 30;
		puyengTimer[playerid] = SetPreciseTimer("waktuPuyeng", 1000, true, "i", playerid);
		SetPlayerArmour(playerid, tambahArmour);
		PlayerInfo[playerid][lastArmour] = tambahArmour;
		tambahItemPlayer(playerid, id_item, -1);
		format(pDialog[playerid], sizePDialog, WHITE"Penggunaan 1 item "YELLOW"%s"WHITE", anda mendapat tambahan Armour sebesar "YELLOW"%d%%"WHITE".", nama_item, persen);
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menggunakan item", pDialog[playerid], "Ok", "");
	}else{
		error_command(playerid, "Maaf tidak dapat menggunakan item lagi, ketika keadaan tidak sadar.");
	}
	return 1;
}

publicFor: pakaiNarkoGanja(playerid){
	pakaiNarko(playerid, "Ganja", 34, 10);
	return 1;
}

getSudahBuatKTP(playerid, const fungsi_callback[], bool:cek_untuk_buat = true)
{
	if(cek_untuk_buat) {
		mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT tanggal_ambil FROM pengambilan_ktp WHERE id_user = '%d' AND tanggal_ambil > NOW()", PlayerInfo[playerid][pID]);
	}else{
		mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT tanggal_ambil, (CASE WHEN tanggal_ambil <= NOW() THEN 1 ELSE 0 END) AS hasil FROM `pengambilan_ktp` WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
	}
	mysql_tquery(koneksi, pQuery[playerid], fungsi_callback, "i", playerid);
}

hapusSetelahPengambilanKTP(playerid){
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM pengambilan_ktp WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid]);
}

publicFor: isRekeningAda(playerid){
	new hasil, rekening[10];
	cache_get_value_name_int(0, "hasil", hasil);
	if(hasil == 0){
		GetSVarString("regis_rekening", rekening, sizeof(rekening));
		format(pDialog[playerid], sizePDialog, "Anda akan membuat rekening dengan nomor rekening "YELLOW"%s "WHITE"dengan ketentuan:\n"YELLOW"- Pembuatan rekening membutuhkan uang administrasi sebesar "GREEN"$100\n- Memiliki 2 Materai dan 4 Pas Foto", rekening);
		ShowPlayerDialog(playerid, DIALOG_DAFTAR_REKENING_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi Pembuatan Rekening", pDialog[playerid], "Daftar", "Batal");
	}else{
		DeletePVar(playerid, "regis_rekening");
		return ShowPlayerDialog(playerid, DIALOG_DAFTAR_REKENING_INPUT_NOMOR, DIALOG_STYLE_INPUT, "Input nomor rekening ATM baru", RED"Nomor rekening telah ada, silahkan pilih nomor rekening lain!\n\n"WHITE"Input nomor rekening ATM yang baru:\n"WHITE"- Nomor rekening harus terdiri dari 8 karakter\n- Nomor rekening belum digunakan oleh orang lain sebelumnya", "Ok", "Kembali");
	}
	return 1;
}

publicFor: selesaiBayarKerusakanKendaraan(playerid){
	new idpv = GetPVarInt(playerid, "fixbayar_idpv");
	DeletePVar(playerid, "fixbayar_idpv");

	PVeh[idpv][pVehIsReparasi] = 2;
	updatePVehReparasi(PVeh[idpv][pVehID], 2);

	format(pDialog[playerid], sizePDialog, WHITE"Anda telah membayar biaya kerusakan untuk "GREEN"%s"YELLOW"\nSilahkan ambil kendaraan anda pada pusat reparasi yang berada di dekat pantai. Terimakasih.", GetVehicleModelName(PVeh[idpv][pVehModel]));
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membayar biaya perbaikan", pDialog[playerid], "Ok", "");
	return 1;
}

publicFor: selesaiBeliPerabot(playerid) {
	tambahFurniturePlayer(playerid, PERABOT_DIJUAL[GetPVarInt(playerid, "index_terpilih")][IDPerabotDijual], GetPVarInt(playerid, "jumlah_terpilih"));

	format(pDialog[playerid], sizePDialog, "Anda berhasil membeli furniture %s.\nSebanyak %d dengan harga total $%d.\nSilahkan cek inventory anda untuk melihat.", PERABOT_DIJUAL[GetPVarInt(playerid, "index_terpilih")][NamaPerabotDijual], GetPVarInt(playerid, "jumlah_terpilih"), GetPVarInt(playerid, "jumlah_terpilih") * PERABOT_DIJUAL[GetPVarInt(playerid, "index_terpilih")][HargaPerabotDijual]);
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli furniture", pDialog[playerid], "Ok", "");
	return 1;
}

publicFor: selesaiBeliBibit(playerid) {
	tambahItemPlayer(playerid, MENU_BIBIT[GetPVarInt(playerid, "index_terpilih")][idItemBibit], GetPVarInt(playerid, "jumlah_terpilih"));

	format(pDialog[playerid], sizePDialog, "Anda berhasil membeli %s.\nSebanyak %d dengan harga total $%d.\nSilahkan cek inventory anda untuk melihat.", MENU_BIBIT[GetPVarInt(playerid, "index_terpilih")][namaBibit], GetPVarInt(playerid, "jumlah_terpilih"), GetPVarInt(playerid, "jumlah_terpilih") * MENU_BIBIT[GetPVarInt(playerid, "index_terpilih")][hargaBibit]);
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli bibit", pDialog[playerid], "Ok", "");
	return 1;
}

publicFor: selesaiBeliNarko(playerid) {
	tambahItemPlayer(playerid, MENU_BIBIT_NARKO[GetPVarInt(playerid, "index_terpilih")][idItemBibit], GetPVarInt(playerid, "jumlah_terpilih"));

	format(pDialog[playerid], sizePDialog, "Anda berhasil membeli %s.\nSebanyak %d dengan harga total $%d.\nSilahkan cek inventory anda untuk melihat.", MENU_BIBIT_NARKO[GetPVarInt(playerid, "index_terpilih")][namaBibit], GetPVarInt(playerid, "jumlah_terpilih"), GetPVarInt(playerid, "jumlah_terpilih") * MENU_BIBIT_NARKO[GetPVarInt(playerid, "index_terpilih")][hargaBibit]);
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli bibit", pDialog[playerid], "Ok", "");
	return 1;
}

publicFor: selesaiBeliPancing(playerid) {
	tambahItemPlayer(playerid, MENU_ALAT_PANCING[GetPVarInt(playerid, "index_terpilih")][idItem], GetPVarInt(playerid, "jumlah_terpilih"));

	format(pDialog[playerid], sizePDialog, "Anda berhasil membeli %s.\nSebanyak %d dengan harga total $%d.\nSilahkan cek inventory anda untuk melihat.", MENU_ALAT_PANCING[GetPVarInt(playerid, "index_terpilih")][namaItem], GetPVarInt(playerid, "jumlah_terpilih"), GetPVarInt(playerid, "jumlah_terpilih") * MENU_ALAT_PANCING[GetPVarInt(playerid, "index_terpilih")][hargaItem]);
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli peralatan pancing", pDialog[playerid], "Ok", "");
	return 1;
}

publicFor: selesaiBeliPhone(playerid) {
	tambahItemPlayer(playerid, MENU_PHONE[GetPVarInt(playerid, "index_terpilih")][idItem], GetPVarInt(playerid, "jumlah_terpilih"));

	format(pDialog[playerid], sizePDialog, "Anda berhasil membeli %s.\nSebanyak %d dengan harga total $%d.\nSilahkan cek inventory anda untuk melihat.", MENU_PHONE[GetPVarInt(playerid, "index_terpilih")][namaItem], GetPVarInt(playerid, "jumlah_terpilih"), GetPVarInt(playerid, "jumlah_terpilih") * MENU_PHONE[GetPVarInt(playerid, "index_terpilih")][hargaItem]);
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli phone", pDialog[playerid], "Ok", "");
	return 1;
}

publicFor: isRekeningTujuanAda(playerid, const rekening[]){
	new result_nama[50], rekening_temp[10];
	if(cache_num_rows()){
		cache_get_value_name(0, "nama", result_nama);
		SetPVarString(playerid, "tf_nama", result_nama);
		format(rekening_temp, sizeof(rekening_temp), "%s", rekening);
		SetPVarString(playerid, "tf_rekening", rekening_temp);

		ShowPlayerDialog(playerid, DIALOG_TRANSFER_NOMINAL, DIALOG_STYLE_INPUT, "Nominal yang ingin ditransfer", "Masukan nominal yang ingin ditransfer:\n"YELLOW"Pastikan bahwa nominal yang ingin anda transfer tidak melebihi saldo tabungan anda.", "Ok", "Batal");
	}
	else{
		format(pDialog[playerid], sizePDialog, RED"Nomor rekening "YELLOW"%s "RED"tidak ada.\n"WHITE"Silahkan masukan nomor rekening tujuan:\nNomor rekening harus terdiri dari 8 digit.\nPastikan anda memasukan rekening yang benar.", rekening);
		ShowPlayerDialog(playerid, DIALOG_INPUT_REKENING_TUJUAN, DIALOG_STYLE_INPUT, "Nomor rekening tujuan", pDialog[playerid], "Ok", "Kembali");
	}
	return 1;
}

publicFor: isMencukupiTransfer(playerid){
	new saldo, nominal = GetPVarInt(playerid, "tf_nominal");
	if(cache_num_rows()){
		cache_get_value_name_int(0, "saldo", saldo);
		if(nominal > saldo){
			ShowPlayerDialog(playerid, DIALOG_TRANSFER_NOMINAL, DIALOG_STYLE_INPUT, "Nominal yang ingin ditransfer", RED"Saldo ATM anda tidak mencukupi.\n"WHITE"Masukan nominal yang ingin ditransfer:\n"YELLOW"Pastikan bahwa nominal yang ingin anda transfer tidak melebihi saldo tabungan anda.", "Ok", "Batal");
			return 1;
		}

		new nama_penerima[50], rekening_penerima[10];
		GetPVarString(playerid, "tf_nama", nama_penerima, sizeof(nama_penerima));
		GetPVarString(playerid, "tf_rekening", rekening_penerima, sizeof(rekening_penerima));

		format(pDialog[playerid], sizePDialog, WHITE"Anda akan melakukan transfer dengan data berikut :\n\n"YELLOW"Nama Penerima : %s\nNo. Rek : %s\nNominal : %d\n\n"WHITE"Anda yakin ingin mengirimnya? Silahkan isi keterangan pengiriman menandakan anda setuju.", nama_penerima, rekening_penerima, nominal);
		ShowPlayerDialog(playerid, DIALOG_TRANSFER_KONFIRMASI, DIALOG_STYLE_INPUT, "Konfirmasi Transfer", pDialog[playerid], "Kirim", "Batal");
	}else
		printf("[ERROR] #01 Error fungsi transfer (%d)%s - ID user(%d)", playerid, PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][pID]);
	return 1;
}

publicFor: isMencukupiTarik(playerid){
	new saldo, nominal = GetPVarInt(playerid, "wd_nominal");
	if(cache_num_rows()){
		cache_get_value_name_int(0, "saldo", saldo);
		if(nominal > saldo){
			ShowPlayerDialog(playerid, DIALOG_TARIK_UANG_NOMINAL, DIALOG_STYLE_INPUT, "Nominal penarikan uang", RED"Saldo tidak mencukupi nominal yang ingin ditarik.\n"WHITE"Silahkan masukan nominal yang ingin anda ambil :\n"YELLOW"Pastikan anda memiliki cukup saldo untuk mengambilnya.", "Tarik", "Kembali");
			return 1;
		}

		format(pDialog[playerid], sizePDialog, WHITE"Anda akan menarik uang sebesar "GREEN"%d."WHITE"\nApakah anda yakin ingin melakukan penarikan?", nominal);
		ShowPlayerDialog(playerid, DIALOG_TARIK_UANG_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi penarikan uang", pDialog[playerid], "Konfirmasi", "Batal");
	}else
		printf("[ERROR] #02 Error fungsi penarikan (%d)%s - ID user(%d)", playerid, PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][pID]);
	return 1;
}

publicFor: tampilSaldoPlayer(playerid){
	new saldo;
	if(cache_num_rows()){
		cache_get_value_name_int(0, "saldo", saldo);
		format(pDialog[playerid], sizePDialog, WHITE"Informasi saldo anda dan Rekening anda:\n\nNama : %s\nRekening : %s\nSaldo : %d\n\nInformasi saldo dapat berubah sewaktu-waktu sesuai dengan transaksi yang terjadi setiap saatnya.\nTerimakasih telah menggunakan Layanan dari kami.", PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][nomorRekening], saldo);
		ShowPlayerDialog(playerid, DIALOG_INFO_SALDO_HISTORY, DIALOG_STYLE_MSGBOX, "Informasi saldo dan Akun Bank", pDialog[playerid], "Kembali", "Tutup");
	}
	else
		printf("[ERROR] #03 Error fungsi tampil saldo (%d)%s - ID user(%d)", playerid, PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][pID]);
	return 1;
}

tampilInventoryItemPlayer(playerid, dialog_id, const judul[] = "Pilih item"){
	inline responseQuery(){
		new rows;
		cache_get_row_count(rows);
		if(rows){
			format(pDialog[playerid], sizePDialog, "Nama\tJumlah\tKapasitas per Item\tKapasitas Terpakai\n");
			new subString[64], jumlah, nama_item[100], kapasitas, id_item;
			for(new i = 0; i < rows; i++){
				cache_get_value_name_int(i, "id_item", id_item);
				cache_get_value_name_int(i, "jumlah", jumlah);
				cache_get_value_name(i, "nama_item", nama_item);
				cache_get_value_name_int(i, "kapasitas", kapasitas);

				strcatEx(pDialog[playerid], sizePDialog, "%s%s\t"WHITE"%i\t%i\t%i\n", GetColorRarity(getRarityByIdItem(id_item)), nama_item, jumlah, kapasitas, kapasitas * jumlah);
			}
			strcat(pDialog[playerid], ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

			// IMPORTANT untuk selalu menghapus cache yang lama setiap ingin menyimpannya dengan yang baru
			if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
			PlayerInfo[playerid][tempCache] = cache_save();

			format(subString, 64, WHITE"%s : "GREEN"(page : %d)", judul, GetPVarInt(playerid, "halaman") + 1);
			return ShowPlayerDialog(playerid, dialog_id, DIALOG_STYLE_TABLIST_HEADERS, subString, pDialog[playerid], "Pilih", "Kembali");
		}else{
			if(GetPVarInt(playerid, "halaman") < 1)
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Inventory item anda "RED"kosong", WHITE"Maaf saat ini inventory item anda tidak berisi apapun!", "Ok", "");
			else{ // Kembalikan ke halaman sebelumnya
				SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
				tampilInventoryItemPlayer(playerid, dialog_id, judul); // Recursive
			}
		}
		return 1;
	}

	MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT b.id_item, b.nama_item, b.keterangan, b.fungsi, b.model_id, a.kunci, a.id_user_item, a.jumlah, b.kapasitas FROM `user_item` a INNER JOIN `item` b ON a.id_item = b.id_item WHERE a.`id_user` = '%d' AND a.jumlah > 0 ORDER BY nama_item ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);

	return 1;
}

tampilInventoryHousePlayer(playerid, house_id, dialog_id, const judul[] = "Pilih item"){
	inline responseQuery(){
		new rows, jumlah, nama_item[100];
		cache_get_row_count(rows);
		new string[1500] = "Nama\tJumlah\n"WHITE;
		if(rows){
			for(new i = 0; i < rows; i++){
				cache_get_value_name_int(i, "jumlah", jumlah);
				cache_get_value_name(i, "nama_item", nama_item);

				strcatEx(string, sizeof(string), "%s\t%i\n", nama_item, jumlah);
			}
			strcat(string, ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

			// IMPORTANT untuk selalu menghapus cache yang lama setiap ingin menyimpannya dengan yang baru
			if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
			PlayerInfo[playerid][tempCache] = cache_save();

			new subString[64];
			format(subString, 64, WHITE"%s : "GREEN"(page : %d)", judul, GetPVarInt(playerid, "halaman") + 1);
			ShowPlayerDialog(playerid, dialog_id, DIALOG_STYLE_TABLIST_HEADERS, subString, string, "Pilih", "Kembali");
		}else{
			if(GetPVarInt(playerid, "halaman") < 1)
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Inventory item rumah anda "RED"kosong", WHITE"Maaf saat ini inventory item anda tidak berisi apapun!\n"YELLOW"Anda dapat menyimpan dari inventory di dalam tas anda!", "Ok", "");
			else{ // Kembalikan ke halaman sebelumnya
				SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
				tampilInventoryHousePlayer(playerid, house_id, dialog_id, judul); // Recursive
			}
		}
		return 1;
	}

	MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT b.id_item, b.nama_item, a.id, a.jumlah FROM `house_inv_item` a INNER JOIN `item` b ON a.id_item = b.id_item WHERE a.id_house = '%d' AND a.jumlah > 0 ORDER BY b.nama_item ASC LIMIT %i, %i", house_id, BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);

	return 1;
}

tampilFurnitureHousePlayer(playerid, house_id, dialog_id, const judul[] = "Pilih furniture"){
	inline responseQuery(){
		new rows, Float:pos_obj[3], nama_furniture[100];
		cache_get_row_count(rows);
		new string[1500] = "Nama\tJarak dari anda\n"WHITE;
		if(rows){
			for(new i = 0; i < rows; i++){
				cache_get_value_name_float(i, "pos_x", pos_obj[0]);
				cache_get_value_name_float(i, "pos_y", pos_obj[1]);
				cache_get_value_name_float(i, "pos_z", pos_obj[2]);
				cache_get_value_name(i, "nama_furniture", nama_furniture);

				strcatEx(string, sizeof(string), "%s\t%.2fm\n", nama_furniture, GetPlayerDistanceFromPoint(playerid, pos_obj[0], pos_obj[1], pos_obj[2]));
			}
			strcat(string, ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

			// IMPORTANT untuk selalu menghapus cache yang lama setiap ingin menyimpannya dengan yang baru
			if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
			PlayerInfo[playerid][tempCache] = cache_save();

			new subString[64];
			format(subString, 64, WHITE"%s : "GREEN"(page : %d)", judul, GetPVarInt(playerid, "halaman") + 1);
			ShowPlayerDialog(playerid, dialog_id, DIALOG_STYLE_TABLIST_HEADERS, subString, string, "Pilih", "Kembali");
		}else{
			if(GetPVarInt(playerid, "halaman") < 1)
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Furniture rumah "RED"kosong", WHITE"Maaf saat ini furniture di dalam rumah anda tidak ada!\n"YELLOW"Anda dapat memasangnya dari furniture yang ada di inventory anda!", "Ok", "");
			else{ // Kembalikan ke halaman sebelumnya
				SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
				tampilFurnitureHousePlayer(playerid, house_id, dialog_id, judul); // Recursive
			}
		}
		return 1;
	}

	MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT a.id, a.id_furniture, a.pos_x, a.pos_y, a.pos_z, b.nama_furniture FROM house_furniture a INNER JOIN furniture b ON a.id_furniture = b.id WHERE a.id_house = '%d' ORDER BY b.nama_furniture ASC LIMIT %i, %i", house_id, BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
	return 1;
}

tampilSemuaRumahTerjual(playerid, dialog_id, const judul[] = "Pilih Rumah"){
	inline responseQuery(){
		new rows, id_house, nama_pemilik[100], harga;
		cache_get_row_count(rows);
		new string[1500] = "Level\tNama Pemilik\tHarga\tJarak\n"WHITE;
		if(rows){
			for(new i = 0; i < rows; i++){
				cache_get_value_name_int(i, "id_house", id_house);
				cache_get_value_name(i, "nama", nama_pemilik);

				if(houseInfo[id_house][hSetHarga] != 0)
					harga = houseInfo[id_house][hSetHarga];
				else
					harga = houseInfo[id_house][hHarga];

				strcatEx(string, sizeof(string), "%s\t%s\t%d\t%.2fm\n", HouseLevel[houseInfo[id_house][hLevel]][namaLevel], nama_pemilik, harga, GetPlayerDistanceFromPoint(playerid, houseInfo[id_house][icon_x], houseInfo[id_house][icon_y], houseInfo[id_house][icon_z]));
			}
			strcat(string, ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

			// IMPORTANT untuk selalu menghapus cache yang lama setiap ingin menyimpannya dengan yang baru
			if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
			PlayerInfo[playerid][tempCache] = cache_save();

			new subString[64];
			format(subString, 64, WHITE"%s : "GREEN"(page : %d)", judul, GetPVarInt(playerid, "halaman") + 1);
			ShowPlayerDialog(playerid, dialog_id, DIALOG_STYLE_TABLIST_HEADERS, subString, string, "Pilih", "Kembali");
		}else{
			if(GetPVarInt(playerid, "halaman") < 1)
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Tidak ada rumah "RED"sedang dijual", WHITE"Maaf saat ini tidak ada rumah yang berstatus sedang dijual!\n"YELLOW"Anda dapat menunggu beberapa saat dan mengecek disini kembali.", "Ok", "");
			else{ // Kembalikan ke halaman sebelumnya
				SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
				tampilSemuaRumahTerjual(playerid, dialog_id, judul); // Recursive
			}
		}
		return 1;
	}

	MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT a.id_house, IFNULL(b.nama, \"Server\") as nama FROM `house` a LEFT JOIN `user` b ON a.id_user = b.id WHERE a.jual = 1 ORDER BY a.harga ASC LIMIT %i, %i", BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);

	return 1;
}

publicFor: historyATMPemain(playerid){
	new rows;
	cache_get_row_count(rows);
	if(rows){
		new idx = 0, subString[150], string[1700 + 200] = "Pengirim/Penerima\tNominal\tTanggal\tKeterangan\n", temp_tanggal[20], rekening_temp[10], keterangan[60], nominal_temp;
		while(idx < rows){
			cache_get_value_name(idx, "rekening", rekening_temp);
			cache_get_value_name(idx, "keterangan", keterangan);
			cache_get_value_name(idx, "tanggal", temp_tanggal);
			cache_get_value_name_int(idx, "nominal", nominal_temp);
			format(subString, sizeof(subString), "%s\t%d\t%s\t%s\n", rekening_temp, nominal_temp, temp_tanggal, keterangan);
			strcat(string, subString);
			idx++;
		}

		strcat(string, ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

		format(subString, 150, WHITE"Informasi History ATM "GREEN"(page : %d)", GetPVarInt(playerid, "halaman") + 1);
		ShowPlayerDialog(playerid, DIALOG_INFO_HISTORY_ATM, DIALOG_STYLE_TABLIST_HEADERS, subString, string, "Kembali", "Tutup");
	}else{
		if(GetPVarInt(playerid, "halaman") < 1)
			ShowPlayerDialog(playerid, DIALOG_INFO_HISTORY_ATM, DIALOG_STYLE_MSGBOX, "Informasi History ATM", "Tidak ada history ATM untuk saat ini.", "Kembali", "Tutup");
		else{ // Kembalikan ke halaman sebelumnya
			SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
			
			mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
			mysql_tquery(koneksi, pQuery[playerid], "historyATMPemain", "i", playerid);
		}
	}
	return 1;
}

publicFor: historyATMPemain_EBank(playerid){
	new rows;
	cache_get_row_count(rows);
	if(rows){
		new idx = 0, subString[150], string[1700 + 200] = "Pengirim/Penerima\tNominal\tTanggal\tKeterangan\n", temp_tanggal[20], rekening_temp[10], keterangan[60], nominal_temp;
		while(idx < rows){
			cache_get_value_name(idx, "rekening", rekening_temp);
			cache_get_value_name(idx, "keterangan", keterangan);
			cache_get_value_name(idx, "tanggal", temp_tanggal);
			cache_get_value_name_int(idx, "nominal", nominal_temp);
			format(subString, sizeof(subString), "%s\t%d\t%s\t%s\n", rekening_temp, nominal_temp, temp_tanggal, keterangan);
			strcat(string, subString);
			idx++;
		}

		strcat(string, ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

		format(subString, 150, WHITE"Informasi History ATM "GREEN"(page : %d)", GetPVarInt(playerid, "halaman") + 1);
		ShowPlayerDialog(playerid, DIALOG_INFO_HISTORY_EBANK, DIALOG_STYLE_TABLIST_HEADERS, subString, string, "Kembali", "Tutup");
	}else{
		if(GetPVarInt(playerid, "halaman") < 1)
			ShowPlayerDialog(playerid, DIALOG_INFO_HISTORY_EBANK, DIALOG_STYLE_MSGBOX, "Informasi History ATM", "Tidak ada history ATM untuk saat ini.", "Kembali", "Tutup");
		else{ // Kembalikan ke halaman sebelumnya
			SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
			
			mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT %i, %i", PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
			mysql_tquery(koneksi, pQuery[playerid], "historyATMPemain_EBank", "i", playerid);
		}
	}
	return 1;
}

publicFor: konfirmasiPaintjobMekanik(playerid, ada){
	if(ada){
		new vehicleid = GetPVarInt(playerid, "mekanik_vehicle_id");
		if(!IsValidVehicle(vehicleid)) return error_command(playerid, "Mobil yang ingin dipaintjob tidak ada!");

		new modelid = GetVehicleModel(vehicleid);

		switch (modelid)
		{
			case 483: ShowPlayerDialog(playerid, DIALOG_PILIH_PAINTJOB, DIALOG_STYLE_LIST, "Pilih Paintjob", "Paintjob tipe 1\nLepas Paintjob", "Pilih", "Batal");
			case 575: ShowPlayerDialog(playerid, DIALOG_PILIH_PAINTJOB, DIALOG_STYLE_LIST, "Pilih Paintjob", "Paintjob tipe 1\nPaintjob tipe 2\nLepas Paintjob", "Pilih", "Batal");
			case 534 .. 536, 558 .. 562, 565, 567, 576: ShowPlayerDialog(playerid, DIALOG_PILIH_PAINTJOB, DIALOG_STYLE_LIST, "Pilih Paintjob", "Paintjob tipe 1\nPaintjob tipe 2\nPaintjob tipe 3\nLepas Paintjob", "Pilih", "Batal");
			default: 
				return error_command(playerid, "Mobil tidak dapat di paintjob!");
		}
		
	}else{
		format(pDialog[playerid], sizePDialog, WHITE"Maaf anda tidak memiliki cukup bahan untuk paintjob kendaraan ini.\n"YELLOW"Anda butuh "GREEN"1 item paintjob kendaraan "YELLOW"untuk dapat paintjob kendaraan ini.");
		showDialogPesan(playerid, RED"Tidak memiliki bahan", pDialog[playerid]);
	}
	return 1;
}

publicFor: konfirmasiModifMekanik(playerid, ada){
	if(ada){
		new vehicleid = GetPVarInt(playerid, "mekanik_vehicle_id");
		if(!IsValidVehicle(vehicleid)) return error_command(playerid, "Mobil yang ingin dimodifikasi tidak ada!");

		new modelid = GetVehicleModel(vehicleid);
		if((534 <= modelid && modelid >= 536) || (558 <= modelid && modelid <= 562) || modelid == 565 || modelid == 567 || modelid == 575 || modelid == 576)
        {
            new temp_query[76];
            mysql_format(koneksi, temp_query, sizeof(temp_query), "SELECT part FROM vehicle_components WHERE cars=%i OR cars=-1 GROUP BY part", modelid);
            mysql_tquery(koneksi, temp_query, "OnTuneLoad", "ii", playerid, 0);
        }
        else
        {
            new temp_query[354];

            mysql_format(koneksi, temp_query, sizeof(temp_query),
            "SELECT " \
            "IF(parts & 1 <> 0,'Exhausts','')," \
            "IF(parts & 2 <> 0,'Hood','')," \
            "IF(parts & 4 <> 0,'Hydraulics','')," \
            "IF(parts & 8 <> 0,'Lights','')," \
            "IF(parts & 16 <> 0,'Roof','')," \
            "IF(parts & 32 <> 0,'Side Skirts','')," \
            "IF(parts & 64 <> 0,'Spoilers','')," \
            "IF(parts & 128 <> 0,'Vents','')," \
            "IF(parts & 256 <> 0,'Wheels','') " \
            "FROM vehicle_model_parts WHERE modelid=%i", modelid);
            mysql_tquery(koneksi, temp_query, "OnTuneLoad", "ii", playerid, 1);
        }
	}else{
		format(pDialog[playerid], sizePDialog, WHITE"Maaf anda tidak memiliki cukup bahan untuk modif kendaraan ini.\n"YELLOW"Anda butuh "GREEN"1 item sparepart kendaraan "YELLOW"untuk dapat modif kendaraan ini.");
		showDialogPesan(playerid, RED"Tidak memiliki bahan", pDialog[playerid]);
	}
	return 1;
}

publicFor: OnTuneLoad(playerid, idx){
	switch (idx)
    {
        case 0:
        {
            new dialog_info[83], part_name[15];

            for (new i, j = cache_num_rows(); i != j; i++)
            {
                cache_get_value_index(i, 0, part_name);

                strcat(dialog_info, part_name);
                strcat(dialog_info, "\n");
            }
            ShowPlayerDialog(playerid, DIALOG_PILIH_COMPONENT, DIALOG_STYLE_LIST, "Komponen yang dapat terpasang", dialog_info, "Pilih", "Batal");
        }
        case 1:
        {
            if (cache_num_rows())
            {
                new dialog_info[83], part_name[14], num_fields;
                cache_get_field_count(num_fields);

                for (new i; i != num_fields; i++)
                {
                    cache_get_value_index(0, i, part_name);

                    if (!isnull(part_name) && strlen(part_name))
                    {
                        strcat(dialog_info, part_name);
                        strcat(dialog_info, "\n");
                    }
                }
				
                ShowPlayerDialog(playerid, DIALOG_PILIH_COMPONENT, DIALOG_STYLE_LIST, "Komponen yang dapat terpasang", dialog_info, "Pilih", "Batal");
            }
            else {
				error_command(playerid, "Kamu tidak dapat memodifikasi kendaraan ini.");
			}
        }
        case 2:
        {
            new dialog_info[716];
            new componentid, type[22];

            dialog_info = "{FF0000}ID Komponen\t{FF8000}Tipe\n";

            for (new i, j = cache_num_rows(); i != j; i++)
            {
                cache_get_value_index_int(i, 0, componentid);
                cache_get_value_index(i, 1, type);

                format(dialog_info, sizeof dialog_info, "%s%i\t%s\n", dialog_info, componentid, type);
            }
            
            if (componentid == 1087) strcat(dialog_info, "Lepas Hydraulics");

            ShowPlayerDialog(playerid, DIALOG_PILIH_COMPONENT_2, DIALOG_STYLE_TABLIST_HEADERS, "Komponen yang dapat terpasang", dialog_info, "Pilih", "Batal");
        }
    }
	return 1;
}

publicFor: konfirmasiWarnainMekanik(playerid, ada){
	if(ada){
		showDialogPilihWarnaKendaraan(playerid, DIALOG_PILIH_WARNA_1, "Pilih warna kendaraan - Warna 1");
	}else{
		format(pDialog[playerid], sizePDialog, WHITE"Maaf anda tidak memiliki cukup bahan untuk mewarnain kendaraan ini.\n"YELLOW"Anda butuh "GREEN"1 item pewarna kendaraan "YELLOW"untuk dapat mewarnain kendaraan ini.");
		showDialogPesan(playerid, RED"Tidak memiliki bahan", pDialog[playerid]);
	}
	return 1;
}

publicFor: konfirmasiPerbaikiMekanik(playerid, ada){
	if(ada){
		new vehid = GetPVarInt(playerid, "mekanik_vehicle_id");
		if(IsValidVehicle(vehid)){
			PerbaikiTimer[playerid] = SetPreciseTimer("progressPerbaikiKendaraan", 1000, true, "iii", playerid, vehid, GetPVarInt(playerid, "mekanik_alat_dibutuhkan"));

			// Pinjam progress bar dari potong pohon
			SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
			ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "~w~Sedang ~y~memperbaiki...", 3000, 3);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 0, 0, 1, 0, 1);
			PlayerInfo[playerid][isOnAnimation] = true;				
			PlayerInfo[playerid][isBusy] = true;				
		}else{
			showDialogPesan(playerid, RED"Kendaraan tidak ada", WHITE"Maaf kendaraan tidak ada. \nDisebabkan akibat kendaraan hancur atau pemilik kendaraan telah keluar dari server.");
		}
	}else{
		format(pDialog[playerid], sizePDialog, WHITE"Maaf anda tidak memiliki cukup bahan untuk memperbaiki kendaraan ini.\n"YELLOW"Anda butuh "GREEN"%d alat perbaikan "YELLOW"untuk dapat memperbaiki kendaraan ini.", GetPVarInt(playerid, "mekanik_alat_dibutuhkan"));
		showDialogPesan(playerid, RED"Tidak memiliki bahan", pDialog[playerid]);
	}

	// Bersihkan variable
	DeletePVar(playerid, "mekanik_alat_dibutuhkan");
	DeletePVar(playerid, "mekanik_vehicle_id");
	return 1;
}

reset_PerbaikiKendaraan(playerid){
	if(IsPlayerConnected(playerid)){
		ClearAnimations(playerid);
		PlayerInfo[playerid][isOnAnimation] = false;
		PlayerInfo[playerid][isBusy] = false;
		TogglePlayerControllable(playerid, 1);
		SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
		HidePlayerProgressBar(playerid, CuttingBar[playerid]);
	}

	if(PerbaikiTimer[playerid] != -1){
		DeletePreciseTimer(PerbaikiTimer[playerid]);
		PerbaikiTimer[playerid] = -1;
	}

	return 1;
}

publicFor: progressPerbaikiKendaraan(playerid, vehicleid, alat_dibutuhkan){
    if(IsValidVehicle(vehicleid)){
		new Float:vpos[3], Float:pos[3];

		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);
		GetVehicleHood(vehicleid, vpos[0], vpos[1], vpos[2]);

		if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 2.0)){
			new Float:value = GetPlayerProgressBarValue(playerid, CuttingBar[playerid]) + MAX_PROGRESS_BAR / PERBAIKI_KENDARAAN_TIME;
			if(value >= MAX_PROGRESS_BAR){
				tambahItemPlayer(playerid, 27, -alat_dibutuhkan);

				new Float:vehdarah;
				GetVehicleHealth(vehicleid, vehdarah);
				if(vehdarah <= 260.0){
					PVeh[vehicleid][pVehDarah] = 300.0;
					SetVehicleHealth(vehicleid, 300.0);
				}else{
					PVeh[vehicleid][pVehDarah] = 1000.0;
					RepairVehicle(vehicleid);
				}
				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);

				sendPesan(playerid, COLOR_GREEN, TAG_MEKANIK" "WHITE"Berhasil memperbaiki kendaraan %s, alat yang terpakai %d pcs.", GetVehicleModelName(GetVehicleModel(vehicleid)), alat_dibutuhkan);
				reset_PerbaikiKendaraan(playerid);

				/**
					Tambah exp				
				 */
				new exp_didapat = 0;
				if(PlayerInfo[playerid][expMekanik] < LEVEL_SKILL_TIGA) // Jika level exp player adalah lvl 2
					exp_didapat = EXP_SUKSES_CURR_SKILL;
				else // Jika level exp player > 2
					exp_didapat = EXP_SUKSES_DOWN_SKILL;

				tambahExpSkillPlayer(playerid, ID_SKILL_MEKANIK, exp_didapat); // 1 adalah id skill mekanik
				sendPesan(playerid, COLOR_YELLOW, "[SKILL] "WHITE"Anda mendapatkan exp sebanyak %d, karena telah menggunakan skill "YELLOW"memperbaiki kendaraan", exp_didapat);
				sendPesan(playerid, COLOR_LIGHT_BLUE, "[SKILL] "WHITE"Exp dari skill mekanik anda saat ini adalah %d.", PlayerInfo[playerid][expMekanik]);
			}else{
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], value);
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal memperbaiki kendaraan. Kendaraan berpindah keposisi lain.");
			reset_PerbaikiKendaraan(playerid);
		}
    }else{
		SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal memperbaiki kendaraan, disebabkan oleh kendaraan tidak ada.");
		reset_PerbaikiKendaraan(playerid);
	}
    return 1;
}

publicFor: progressWarnainKendaraan(playerid, vehicleid, color1, color2){
	if(IsValidVehicle(vehicleid)){
		new Float:vpos[3], Float:pos[3];

		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);
		GetVehiclePos(vehicleid, vpos[0], vpos[1], vpos[2]);

		if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
			new Float:value = GetPlayerProgressBarValue(playerid, CuttingBar[playerid]) + MAX_PROGRESS_BAR / WARNAIN_KENDARAAN_TIME;
			if(value >= MAX_PROGRESS_BAR){
				new idpv = IDVehToPVeh[vehicleid];

				PVeh[idpv][pVehColor][0] = color1;
				PVeh[idpv][pVehColor][1] = color2;
				ChangeVehicleColor(vehicleid, PVeh[idpv][pVehColor][0], PVeh[idpv][pVehColor][1]);
				UpdateTampilanVehiclePlayer(vehicleid);

				tambahItemPlayer(playerid, 28, -1); // 28 adalah item pewarna kendaraan

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);

				sendPesan(playerid, COLOR_GREEN, TAG_MEKANIK" "WHITE"Berhasil mewarnain kendaraan %s, item pewarna yang terpakai 1 pcs.", GetVehicleModelName(GetVehicleModel(vehicleid)));
				reset_PerbaikiKendaraan(playerid);

				/**
					Tambah exp				
				 */
				new exp_didapat = 0;
				if(PlayerInfo[playerid][expMekanik] < LEVEL_SKILL_EMPAT) // Jika level exp player adalah lvl 3
					exp_didapat = EXP_SUKSES_CURR_SKILL;
				else // Jika level exp player > 3
					exp_didapat = EXP_SUKSES_DOWN_SKILL;

				tambahExpSkillPlayer(playerid, ID_SKILL_MEKANIK, exp_didapat); // 1 adalah id skill mekanik
				sendPesan(playerid, COLOR_YELLOW, "[SKILL] "WHITE"Anda mendapatkan exp sebanyak %d, karena telah menggunakan skill "YELLOW"mewarnain kendaraan", exp_didapat);
				sendPesan(playerid, COLOR_LIGHT_BLUE, "[SKILL] "WHITE"Exp dari skill mekanik anda saat ini adalah %d.", PlayerInfo[playerid][expMekanik]);
			}else{
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], value);
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal mewarnain kendaraan. Kendaraan berpindah keposisi lain.");
			reset_PerbaikiKendaraan(playerid); // Pinjam juga fungsinya
		}
    }else{
		SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal mewarnain kendaraan, disebabkan oleh kendaraan tidak ada.");
		reset_PerbaikiKendaraan(playerid); // Pinjam juga fungsinya
	}
	return 1;
}

publicFor: progressPaintjobKendaraan(playerid, vehicleid, paintjobid){
	if(IsValidVehicle(vehicleid)){
		new Float:vpos[3], Float:pos[3];

		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);
		GetVehiclePos(vehicleid, vpos[0], vpos[1], vpos[2]);

		if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
			new Float:value = GetPlayerProgressBarValue(playerid, CuttingBar[playerid]) + MAX_PROGRESS_BAR / PAINTJOB_KENDARAAN_TIME;
			if(value >= MAX_PROGRESS_BAR){
				new idpv = IDVehToPVeh[vehicleid];

				PVeh[idpv][pVehPaintJob] = paintjobid;
				ChangeVehiclePaintjob(vehicleid, paintjobid);

				UpdateTampilanVehiclePlayer(vehicleid);
				tambahItemPlayer(playerid, 30, -1); // 30 adalah item paintjob kendaraan

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);

				sendPesan(playerid, COLOR_GREEN, TAG_MEKANIK" "WHITE"Berhasil paintjob kendaraan %s, dengan item yang terpakai 1 pcs.", GetVehicleModelName(GetVehicleModel(vehicleid)));
				reset_PerbaikiKendaraan(playerid); // Pinjam fungsinya

				/**
					Tambah exp				
				 */
				new exp_didapat = 0;
				if(PlayerInfo[playerid][expMekanik] < LEVEL_SKILL_LIMA) // Jika level exp player adalah lvl 4
					exp_didapat = EXP_SUKSES_CURR_SKILL;
				else // Jika level exp player > 4
					exp_didapat = EXP_SUKSES_DOWN_SKILL;

				tambahExpSkillPlayer(playerid, ID_SKILL_MEKANIK, exp_didapat); // 1 adalah id skill mekanik
				sendPesan(playerid, COLOR_YELLOW, "[SKILL] "WHITE"Anda mendapatkan exp sebanyak %d, karena telah menggunakan skill "YELLOW"paintjob kendaraan", exp_didapat);
				sendPesan(playerid, COLOR_LIGHT_BLUE, "[SKILL] "WHITE"Exp dari skill mekanik anda saat ini adalah %d.", PlayerInfo[playerid][expMekanik]);
			}else{
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], value);
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal paintjob kendaraan. Kendaraan berpindah keposisi lain.");
			reset_PerbaikiKendaraan(playerid); // Pinjam juga fungsinya
		}
    }else{
		SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal paintjob kendaraan, disebabkan oleh kendaraan tidak ada.");
		reset_PerbaikiKendaraan(playerid); // Pinjam juga fungsinya
	}
	return 1;
}

publicFor: progressModifKendaraan(playerid, vehicleid, componentid){
	if(IsValidVehicle(vehicleid)){
		new Float:vpos[3], Float:pos[3];

		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);
		GetVehiclePos(vehicleid, vpos[0], vpos[1], vpos[2]);

		if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
			new Float:value = GetPlayerProgressBarValue(playerid, CuttingBar[playerid]) + MAX_PROGRESS_BAR / MODIF_KENDARAAN_TIME;
			if(value >= MAX_PROGRESS_BAR){
				new idpv = IDVehToPVeh[vehicleid];
				new slotid = GetVehicleComponentType(componentid);

				PVeh[idpv][pVehMod][slotid] = componentid;
				AddVehicleComponent(vehicleid, PVeh[idpv][pVehMod][slotid]);

				// sideskirts and vents that have left and right side should be applied twice
				switch (PVeh[idpv][pVehMod][slotid])
				{
					case 1007, 1027, 1030, 1039, 1040, 1051, 1052, 1062, 1063, 1071, 1072, 1094, 1099, 1101, 1102, 1107, 1120, 1121, 1124, 1137, 1142 .. 1145: AddVehicleComponent(vehicleid, PVeh[idpv][pVehMod][slotid]);
				}

				UpdateTampilanVehiclePlayer(vehicleid);
				tambahItemPlayer(playerid, 29, -1); // 29 adalah item sparepart kendaraan

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);

				sendPesan(playerid, COLOR_GREEN, TAG_MEKANIK" "WHITE"Berhasil modifikasi kendaraan %s, dengan item yang terpakai 1 pcs.", GetVehicleModelName(GetVehicleModel(vehicleid)));
				reset_PerbaikiKendaraan(playerid);

				/**
					Tambah exp				
				 */
				new exp_didapat = 0;
				if(PlayerInfo[playerid][expMekanik] < LEVEL_SKILL_LIMA) // Jika level exp player adalah lvl 4
					exp_didapat = EXP_SUKSES_CURR_SKILL;
				else // Jika level exp player > 4
					exp_didapat = EXP_SUKSES_DOWN_SKILL;

				tambahExpSkillPlayer(playerid, ID_SKILL_MEKANIK, exp_didapat); // 1 adalah id skill mekanik
				sendPesan(playerid, COLOR_YELLOW, "[SKILL] "WHITE"Anda mendapatkan exp sebanyak %d, karena telah menggunakan skill "YELLOW"modifikasi kendaraan", exp_didapat);
				sendPesan(playerid, COLOR_LIGHT_BLUE, "[SKILL] "WHITE"Exp dari skill mekanik anda saat ini adalah %d.", PlayerInfo[playerid][expMekanik]);
			}else{
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], value);
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal modif kendaraan. Kendaraan berpindah keposisi lain.");
			reset_PerbaikiKendaraan(playerid); // Pinjam juga fungsinya
		}
    }else{
		SendClientMessage(playerid, COLOR_RED, TAG_MEKANIK" "WHITE"Gagal modif kendaraan, disebabkan oleh kendaraan tidak ada.");
		reset_PerbaikiKendaraan(playerid); // Pinjam juga fungsinya
	}
	return 1;
}

publicFor: progressIsiBensin(playerid){
	new vehicleid = GetPVarInt(playerid, "id_vehicle_bensin");

	if(IsValidVehicle(vehicleid)){
		new Float:vpos[3], Float:pos[3];

		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);
		GetVehiclePos(vehicleid, vpos[0], vpos[1], vpos[2]);

		if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
			new Float:value = GetPlayerProgressBarValue(playerid, CuttingBar[playerid]) + MAX_PROGRESS_BAR / ISI_BENSIN_TIME;
			if(value >= MAX_PROGRESS_BAR){
				new harga = GetPVarInt(playerid, "harga_bensin"),
					persen = GetPVarInt(playerid, "persen_bensin");
				
				DeletePVar(playerid, "harga_bensin");
				DeletePVar(playerid, "persen_bensin");
				DeletePVar(playerid, "id_vehicle_bensin");

				givePlayerUang(playerid, -harga);

				// Prevent from minus value
				if(GetVehicleFuel(vehicleid) < 0) SetVehicleFuel(vehicleid, 0);

				SetVehicleFuel(vehicleid, (GetVehicleFuel(vehicleid) + (MAX_VEHICLE_FUEL * persen / 100)) > MAX_VEHICLE_FUEL ? MAX_VEHICLE_FUEL : (GetVehicleFuel(vehicleid) + (MAX_VEHICLE_FUEL * persen / 100)));

				reset_PerbaikiKendaraan(playerid); // Pinjam fungsinya

				sendPesan(playerid, COLOR_GREEN, TAG_BENSIN" "WHITE"Berhasil mengisi bensin sebanyak %d persen dengan harga "GREEN"$%d", persen, harga);
			}else{
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], value);
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, TAG_BENSIN" "WHITE"Gagal mengisi bensin, kendaraan tidak pada posisi semula.");
			reset_PerbaikiKendaraan(playerid); // Pinjam juga fungsinya
		}
    }else{
		SendClientMessage(playerid, COLOR_RED, TAG_BENSIN" "WHITE"Gagal mengisi bensin, kendaraan tidak ada.");
		reset_PerbaikiKendaraan(playerid); // Pinjam juga fungsinya
	}
	return 1;
}

publicFor: progressIsiBensinPakaiItem(playerid, itemid, vehicleid){
	if(IsValidVehicle(vehicleid)){
		new Float:vpos[3], Float:pos[3];

		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1.0);
		GetVehiclePos(vehicleid, vpos[0], vpos[1], vpos[2]);

		if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 3.0)){
			new Float:value = GetPlayerProgressBarValue(playerid, CuttingBar[playerid]) + MAX_PROGRESS_BAR / ISI_BENSIN_TIME;
			if(value >= MAX_PROGRESS_BAR){
				new persen = 0;
				switch(itemid){
					case 44: { // 20 liter
						persen = 20;
					}
					case 45: { // 50 liter
						persen = 50;
					}
					case 46: { // 100 liter
						persen = 100;
					}
				}

				// Prevent from minus value
				if(GetVehicleFuel(vehicleid) < 0) SetVehicleFuel(vehicleid, 0);

				SetVehicleFuel(vehicleid, (GetVehicleFuel(vehicleid) + (MAX_VEHICLE_FUEL * persen / 100)) > MAX_VEHICLE_FUEL ? MAX_VEHICLE_FUEL : (GetVehicleFuel(vehicleid) + (MAX_VEHICLE_FUEL * persen / 100)));

				reset_PerbaikiKendaraan(playerid); // Pinjam fungsinya

				sendPesan(playerid, COLOR_GREEN, TAG_BENSIN" "WHITE"Berhasil mengisi bensin sebanyak "GREEN"%d liter", persen);
			}else{
				SetPlayerProgressBarValue(playerid, CuttingBar[playerid], value);
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, TAG_BENSIN" "WHITE"Gagal mengisi bensin, kendaraan tidak pada posisi semula.");
			reset_PerbaikiKendaraan(playerid); // Pinjam juga fungsinya
		}
    }else{
		SendClientMessage(playerid, COLOR_RED, TAG_BENSIN" "WHITE"Gagal mengisi bensin, kendaraan tidak ada.");
		reset_PerbaikiKendaraan(playerid); // Pinjam juga fungsinya
	}
	return 1;
}

publicFor: konfirmasiBuatAlatPerbaikan(playerid, ada){
	if(ada){
		new rate_sukses = getRateBerhasilSkill(PlayerInfo[playerid][expMekanik], 1);

		format(pDialog[playerid], sizePDialog, WHITE"Anda akan membuat "GREEN"Alat Perbaikan Kendaraan.\n"WHITE"Rate keberhasilan penggunaan skill ini adalah "YELLOW"%d persen"WHITE".\n\nApakah anda yakin ?", rate_sukses);
		ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BUAT_ALAT_PERBAIKAN, DIALOG_STYLE_MSGBOX, "Konfirmasi pembuatan", pDialog[playerid], "Konfirmasi", "Batal");
		return 1;
	}else
		return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Item tidak mencukupi", "Anda tidak memiliki cukup item yang diperlukan.\nAnda tidak dapat membuat item alat perbaikan.\n\n"YELLOW"Anda membutuhkan 1 Perunggu dan 3 Perak.", "Ok", "");
}


publicFor: konfirmasiPembuatanRekening(playerid, ada){
	if(ada){
		new rekening[10];

		tambahItemPlayer(playerid, 5, -4);
		tambahItemPlayer(playerid, 6, -2);
		givePlayerUang(playerid, -100);

		GetPVarString(playerid, "regis_rekening", rekening, sizeof(rekening));
		// Update rekening player
		mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET rekening = '%e' WHERE id = '%d'", rekening, PlayerInfo[playerid][pID]);
		mysql_tquery(koneksi, pQuery[playerid]);

		format(PlayerInfo[playerid][nomorRekening], 10, "%s", rekening);

		DeletePVar(playerid, "regis_rekening");

		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membuat rekening ATM", "Berhasil membuat rekening ATM, anda dapat menggunakan ATM untuk mengirim dan menerima uang dari orang lain.\n\n"YELLOW"Anda juga menggunakan eBanking jika memiliki ePhone yang mendukung.\nSetiap transaksi pada ATM dapat anda lakukan pada mesin ATM manapun.", "Ok", "");
	}else{
		DeletePVar(playerid, "regis_rekening");
		return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Item tidak mencukupi", "Anda tidak memiliki cukup item yang diperlukan untuk pembuatan rekening.", "Ok", "");
	}
	return 1;
}

publicFor: cekSudahBisaAmbilKTP(playerid){
	new sudah_selesai, tanggal_pengambilan[50];
	if(cache_num_rows()){
		cache_get_value_name_int(0, "hasil", sudah_selesai);
		if(sudah_selesai){
			hapusSetelahPengambilanKTP(playerid);
			
			tambahItemPlayer(playerid, 7, 1);

			format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil mendapatkan KTP yang sudah anda proses selama beberapa waktu.\nSilahkan gunakan data diri dan KTP anda dengan sebaik mungkin.\n"ORANGE"\nPemberian informasi data diri kepada orang lain, dapat menyebabkan hal yang tidak diinginkan.");
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"KTP sudah selesai", pDialog[playerid], "Ok", "");
		}else{
			cache_get_value_name(0, "tanggal_ambil", tanggal_pengambilan);
			format(pDialog[playerid], sizePDialog, WHITE"KTP anda sedang dalam proses pembuatan, silahkan kembali pada tanggal :\n"YELLOW"%s\n"WHITE"Pengambilan KTP dapat anda lakukan di tempat resepsionis dengan memilih menu "GREEN"Ambil KTP "WHITE"\nAnda akan otomatis mendapatkan kartu anda pada saat itu juga.", tanggal_pengambilan);

			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"KTP sedang diproses", pDialog[playerid], "Ok", "");			
		}
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Maaf KTP tidak ditemukan", WHITE"Maaf KTP atas nama anda tidak ditemukan, anda harus membuatnya terlebih dahulu. \nMaka setelah anda membuatnya, anda dapat mengambilnya disini.", "Ok", "");
	}
	return 1;
}

publicFor: cekSudahPunyaKTP(playerid){
	new tanggal_pengambilan[50];
	if(cache_num_rows()){
		cache_get_value_name(0, "tanggal_ambil", tanggal_pengambilan);
		format(pDialog[playerid], sizePDialog, WHITE"KTP anda sedang dalam proses pembuatan, silahkan kembali pada tanggal :\n"YELLOW"%s\n"WHITE"Pengambilan KTP dapat anda lakukan di tempat resepsionis dengan memilih menu "GREEN"Ambil KTP "WHITE"\nAnda akan otomatis mendapatkan kartu anda pada saat itu juga.", tanggal_pengambilan);

		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"KTP sedang diproses", pDialog[playerid], "Ok", "");
	}else{
		// ID KTP = 7
		cekKetersediaanItem(playerid, 7, 1, "isBisaBuatKTP");
	}
	return 1;
}

publicFor: inputNomorRekeningATMBaru(playerid, ada){
	if(ada){
		ShowPlayerDialog(playerid, DIALOG_DAFTAR_REKENING_INPUT_NOMOR, DIALOG_STYLE_INPUT, "Input nomor rekening ATM baru", "Input nomor rekening ATM yang baru:\n"WHITE"- Nomor rekening harus terdiri dari 8 karakter\n- Nomor rekening belum digunakan oleh orang lain sebelumnya", "Ok", "Kembali");
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Tidak memiliki KTP", WHITE"Anda harus memiliki KTP terlebih dahulu untuk dapat mendaftarkan rekening ATM.", "Ok", "");
	}
	return 1;
}

publicFor: selesaiNambang(playerid){
	PlayerAction[playerid][sedangNambang] = false;
	ClearAnimations(playerid);
	PlayerInfo[playerid][isOnAnimation] = false;
	PlayerInfo[playerid][isBusy] = false;

	TogglePlayerControllable(playerid, 1);
	if(IsPlayerAttachedObjectSlotUsed(playerid, MINING_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, MINING_ATTACH_INDEX);

	PlayerInfo[playerid][sisaPalu]--;

	setStatusMakanPemain(playerid, getStatusMakanPemain(playerid) - 1.5);

	// Testing Probalities
	new angka = random(15);
	switch(angka){
		case 1:
		{
			showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "LIGHT_BLUE"Berlian"WHITE".\nBerlian adalah hasil tambang nomor satu dan pastinya "PURPLE"sangat langka"WHITE". Luar biasa!\nAnda dapat menjualnya dengan harga sangat tinggi.");
			tambahItemPlayer(playerid, 10, 1);
		}
		case 2..3:
		{
			showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "YELLOW"Emas"WHITE".\nEmas adalah hasil tambang yang sangat bagus, dan "PURPLE"langka"WHITE". Sangat beruntung!");
			tambahItemPlayer(playerid, 9, 1);
		}
		case 4..6:{
			showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "SILVER"Perunggu"WHITE".\nPerunggu adalah hasil tambang yang berguna dan juga "BLUE"diminati orang banyak"WHITE". Keren sekali!");
			tambahItemPlayer(playerid, 11, 1);
		}
		case 7..9:
		{
			showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "ORANGE"Perak"WHITE".\nPerak adalah hasil tambang bagus dan "GREEN"berguna untuk banyak hal"WHITE". Kerja bagus!");
			tambahItemPlayer(playerid, 12, 1);
		}
		default:{
			SendClientMessage(playerid, COLOR_GREY, "[SERVER] Anda tidak mendapatkan apapun silahkan coba lagi.");
		}
	}
	// Real Probalities
	// new angka = random(1000000);
	// if(angka > 0 && angka <= 80){ // Probabilitas 0,008%
	// 		showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "LIGHT_BLUE"Berlian"WHITE".\nBerlian adalah hasil tambang nomor satu dan pastinya "PURPLE"sangat langka"WHITE". Luar biasa!\nAnda dapat menjualnya dengan harga sangat tinggi.");
	// 		tambahItemPlayer(playerid, 10, 1);
	// }else if(angka >= 1601 && angka <= 20000){ // Kemungkinan 1,84%
	// 		showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "YELLOW"Emas"WHITE".\nEmas adalah hasil tambang yang sangat bagus, dan "PURPLE"langka"WHITE". Sangat beruntung!");
	// 		tambahItemPlayer(playerid, 9, 1);
	// }else if(angka >= 20001 && angka <= 120000){ // Kemungkinan 10%
	// 		showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "SILVER"Perunggu"WHITE".\nPerunggu adalah hasil tambang yang berguna dan juga "BLUE"diminati orang banyak"WHITE". Keren sekali!");
	// 		tambahItemPlayer(playerid, 11, 1);
	// }else if(angka >= 120001 && angka <= 420000){ // Kemungkinan 30%
	// 		showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "ORANGE"Perak"WHITE".\nPerak adalah hasil tambang bagus dan "GREEN"berguna untuk banyak hal"WHITE". Kerja bagus!");
	// 		tambahItemPlayer(playerid, 12, 1);
	// }else{
	// 		SendClientMessage(playerid, COLOR_GREY, "[SERVER] Anda tidak mendapatkan apapun silahkan coba lagi.");
	// }
}

publicFor: showHistoryGajiPemain(playerid){
	new rows;
	cache_get_row_count(rows);
	if(rows){
		new tmp_tanggal[50], tmp_nominal, temp_dialog[150], tmp_keterangan[50];
		format(pDialog[playerid], sizePDialog, WHITE"Tanggal\t"GREEN"Nominal\t"WHITE"Keterangan\n");
		foreach(new i : Range(0, rows)){
			cache_get_value_name(i, "tanggal", tmp_tanggal);
			cache_get_value_name(i, "keterangan", tmp_keterangan);
			cache_get_value_name_int(i, "nominal", tmp_nominal);

			format(temp_dialog, 149, "%s\t%i\t%s\n", tmp_tanggal, tmp_nominal, tmp_keterangan);
			strcat(pDialog[playerid], temp_dialog);
		}
		strcat(pDialog[playerid], ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");
		format(temp_dialog, 150, WHITE"History Gaji Pemain "GREEN"(page : %d)", GetPVarInt(playerid, "halaman") + 1);
		ShowPlayerDialog(playerid, DIALOG_LIHAT_GAJI, DIALOG_STYLE_TABLIST_HEADERS, temp_dialog, pDialog[playerid], "Kembali", "Tutup");
	}else{
		if(GetPVarInt(playerid, "halaman") < 1)
			showDialogPesan(playerid, RED"Kotak gaji kosong", WHITE"Saat ini gaji anda tidak ada yang mau diambil.");
		else{ // Kembalikan ke halaman sebelumnya
			SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
			
			mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT nominal, tanggal, keterangan FROM `gaji` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
			mysql_tquery(koneksi, pQuery[playerid], "showHistoryGajiPemain", "i", playerid);
		}
	}
	return 1;
}

prosesPembuatanKTP(playerid, interval_menit){
	// Interval dalam menit
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO pengambilan_ktp(id_user,tanggal_buat,tanggal_ambil) VALUES('%d', NOW(), NOW() + INTERVAL %d MINUTE)", PlayerInfo[playerid][pID], interval_menit);
	mysql_tquery(koneksi, pQuery[playerid]);
}

addTransaksiTabungan(const rekening_user[], nominal, const keterangan[], const rekening_pengirim_penerima[] = ""){
	new tempQuery[100];
	mysql_format(koneksi, tempQuery, 100, "CALL `tambah_transaksi_atm`('%e', '%e', %d, '%e')", rekening_pengirim_penerima, rekening_user, nominal, keterangan);
	mysql_tquery(koneksi, tempQuery);
}

getSudahBuatSIM(playerid, const fungsi_callback[], bool:cek_untuk_buat = true)
{
	if(cek_untuk_buat) {
		mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT tanggal_ambil FROM pengambilan_sim WHERE id_user = '%d' AND tanggal_ambil > NOW()", PlayerInfo[playerid][pID]);
	}else{
		mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT tanggal_ambil, tipe_sim, (CASE WHEN tanggal_ambil <= NOW() THEN 1 ELSE 0 END) AS hasil FROM `pengambilan_sim` WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
	}
	mysql_tquery(koneksi, pQuery[playerid], fungsi_callback, "i", playerid);
}

prosesPembuatanSIM(playerid, interval_menit){
	// Interval dalam menit
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE pengambilan_sim SET tanggal_buat = NOW(), tanggal_ambil = NOW() + INTERVAL %d MINUTE WHERE id_user = '%d'", interval_menit, PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid]);
}

hapusSetelahPengambilanSIM(playerid){
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM pengambilan_sim WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid]);
}

saveHistoryLogin(playerid){
	new temp_country[MAX_COUNTRY_LENGTH + 1], temp_ip[50], temp_city[MAX_CITY_LENGTH + 1];
	GetPlayerIp(playerid, temp_ip, 50);
	GetPlayerCountry(playerid, temp_country, MAX_COUNTRY_LENGTH);
	GetPlayerCity(playerid, temp_city, MAX_CITY_LENGTH);

	mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO logs_user_konek(id_user, ip, kota, negara, tanggal) VALUES('%d', '%s', '%s', '%s', NOW())", PlayerInfo[playerid][pID], temp_ip, temp_city, temp_country);
	mysql_tquery(koneksi, pQuery[playerid]);	
}

publicFor: cekPembuatanSIM(playerid, ada){
	if(ada){
		givePlayerUang(playerid, -100);
		SetPVarInt(playerid, "sim_soal", 0);
		SetPlayerVirtualWorld(playerid, playerid+2);
		ShowPlayerDialog(playerid, DIALOG_SIM_SOAL, DIALOG_STYLE_MSGBOX, "Praktik SIM", WHITE"Anda sekarang akan melakukan Ujian Teori SIM. Silahkan baca panduan agar anda dapat mengisinya.\nPanduan:\n"YELLOW"- Ketika anda mengendarai kendaraan, anda harus fokus dan menaati peraturan.\n- Gunakan jalur kanan ketika sedang berkendara.\n- Berhenti jika lampu lalu lintas merah, berhati-hati jika kuning.\n- Kurangi kecepatan jika ada player / kendaraan yang sedang lewat / menyalip.\n- Jika ingin menyalip kendaraan ambil jalur kiri dan jika ingin mengurangi kecepatan ambil jalur kanan.\n- Kecepatan normal di bawah "GREEN"80 KmpH"YELLOW", jika lebih maka anda harus mengurangi kecepatan.\n"WHITE"Note: Minimal poin yang didapat "GREEN"10", "Mengerti", "Batal");
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Tidak memiliki KTP", WHITE"Anda harus memiliki KTP terlebih dahulu untuk dapat mendaftarkan Ujian Praktik SIM.", "Ok", "");
	}
	return 1;
}

publicFor: cekSudahBisaAmbilSIM(playerid){
	new sudah_selesai, tipe_sim, tanggal_pengambilan[50];
	if(cache_num_rows()){
		cache_get_value_name_int(0, "hasil", sudah_selesai);
		cache_get_value_name_int(0, "tipe_sim", tipe_sim);
		if(sudah_selesai){
			// ID SIM A = 15
			// ID SIM B = 47
			// ID SIM C = 48
			if(tipe_sim == 1) tipe_sim = 15;
			else if(tipe_sim == 2) tipe_sim = 47;
			else if(tipe_sim == 3) tipe_sim = 48;
			else return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Maaf SIM tidak ditemukan", WHITE"Maaf SIM atas nama anda tidak ditemukan, anda harus membuatnya terlebih dahulu. \nMaka setelah anda membuatnya, anda dapat mengambilnya disini.", "Ok", "");
			hapusSetelahPengambilanSIM(playerid);
			tambahItemPlayer(playerid, tipe_sim, 1);

			format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil mendapatkan SIM yang sudah anda proses selama beberapa waktu.\nSilahkan berkendara dengan sebaik mungkin.\n"ORANGE"\nMelakukan pelanggaran lalu lintas akan mendapat tindakan tegas.");
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"SIM sudah selesai", pDialog[playerid], "Ok", "");
		}else{
			cache_get_value_name(0, "tanggal_ambil", tanggal_pengambilan);
			format(pDialog[playerid], sizePDialog, WHITE"SIM anda sedang dalam proses pembuatan, silahkan kembali pada tanggal :\n"YELLOW"%s\n"WHITE"Pengambilan SIM dapat anda lakukan dengan memilih menu "GREEN"Ambil SIM "WHITE"\nAnda akan mendapatkan SIM pada saat itu juga.", tanggal_pengambilan);

			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"SIM sedang diproses", pDialog[playerid], "Ok", "");			
		}
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Maaf SIM tidak ditemukan", WHITE"Maaf SIM atas nama anda tidak ditemukan, anda harus membuatnya terlebih dahulu. \nMaka setelah anda membuatnya, anda dapat mengambilnya disini.", "Ok", "");
	}

	return 1;
}

publicFor: responseUpdateHari(tahun, hari){
	new nama_hari, indo_hari[20], str_hari[80];
	cache_get_value_name_int(0, "nama_hari", nama_hari);
	switch(nama_hari){
		case 2:
		{
			format(indo_hari, 20, "Senin");
		}
		case 3:
		{
			format(indo_hari, 20, "Selasa");
		}
		case 4:{
			format(indo_hari, 20, "Rabu");
		}
		case 5:
		{
			format(indo_hari, 20, "Kamis");
		}
		case 6:
		{
			format(indo_hari, 20, "Jumat");
		}
		case 7:
		{
			format(indo_hari, 20, "Sabtu");
		}
		default:
			format(indo_hari, 20, "Minggu");
	}
	new	temp_tahun, temp_bulan, temp_hari;
	getdate(temp_tahun, temp_bulan, temp_hari);

	format(str_hari, 80, "%s, %d/%d/%d", indo_hari, temp_hari, temp_bulan, temp_tahun);
	TextDrawSetString(TD_JamTanggal[1], str_hari);
}

publicFor: pembayaranMakananATM(playerid){	
	new idx = GetPVarInt(playerid, "bmakan_index"), jumlah = GetPVarInt(playerid, "bmakan_jumlah");
	new harga = jumlah * MENU_MAKANAN[idx][hargaMakanan];
	DeletePVar(playerid, "bmakan_index");
	DeletePVar(playerid, "bmakan_jumlah");				

	new saldo;
	cache_get_value_name_int(0, "saldo", saldo);
	if(saldo > harga){
		new string_keterangan[100];
		format(string_keterangan, 100, "Pembelian %s sebanyak %d", MENU_MAKANAN[idx][namaMakanan], jumlah);
		addTransaksiTabungan(PlayerInfo[playerid][nomorRekening], -harga, string_keterangan);
		tambahItemPlayer(playerid, MENU_MAKANAN[idx][idItemMakanan], jumlah);
		format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil membeli "YELLOW"%s "WHITE" sebanyak "YELLOW"%d "WHITE"dengan harga total "GREEN"$%d\n"WHITE"Item langsung dikirimkan pada inventory anda, silahkan buka inventory untuk mengeceknya.", MENU_MAKANAN[idx][namaMakanan], jumlah, harga);
		showDialogPesan(playerid, GREEN"Berhasil membeli makanan", pDialog[playerid]);
	}else{
		showDialogPesan(playerid, RED"Saldo anda tidak mencukupi", WHITE"Maaf saldo yang terdapat pada ATM anda tidak mencukupi.\nSilahkan gunakan metode lain.");
	}
	return 1;
}

publicFor: pakaiMakanan(playerid, itemid){
	tambahItemPlayer(playerid, itemid, -1);
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 0, 0, 1);

	for(new i = 0; i < sizeof(MENU_MAKANAN); i++){
		if(MENU_MAKANAN[i][idItemMakanan] == itemid){
			setStatusMakanPemain(playerid, getStatusMakanPemain(playerid) + MENU_MAKANAN[i][energiNambah]);
			break;
		}
	}
	return 1;
}

publicFor: pakaiBensin(playerid, itemid){
	if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_RED, TAG_BENSIN" "WHITE"Tidak dapat mengisi bensin didalam kendaraan.");

	new Float:pos[3], Float:vpos[3], vehid = INVALID_VEHICLE_ID;
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 3.0);

	foreach(new vid : Vehicle){
		if(!IsValidVehicle(vid)) continue;
		GetVehiclePos(vid, vpos[0], vpos[1], vpos[2]);
		if(IsPointInRangeOfPoint(pos[0], pos[1], pos[2], vpos[0], vpos[1], vpos[2], 2.0)){
			vehid = vid;
			break;
		}
	}

	if(vehid == INVALID_VEHICLE_ID) 
		return SendClientMessage(playerid, COLOR_RED, TAG_BENSIN" "WHITE"Kendaraan yang akan diisi bensin harus berada didepan anda.");

	// Langsung kurangkan item
	tambahItemPlayer(playerid, itemid, -1);

	// Pinjam timer perbaiki
	PerbaikiTimer[playerid] = SetPreciseTimer("progressIsiBensinPakaiItem", 1000, true, "iii", playerid, itemid, vehid);

	// Pinjam progress bar dari potong pohon
	SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
	ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
	TogglePlayerControllable(playerid, 0);
	PlayerFillingFuelOnLoop(playerid);
	GameTextForPlayer(playerid, "~w~Sedang ~y~Mengisi Bensin...", 3000, 3);

	PlayerInfo[playerid][isOnAnimation] = true;
	PlayerInfo[playerid][isBusy] = true;
	return 1;
}

publicFor: cekSudahPunyaSIM(playerid){
	new tanggal_pengambilan[50];
	if(cache_num_rows()){
		cache_get_value_name(0, "tanggal_ambil", tanggal_pengambilan);
		format(pDialog[playerid], sizePDialog, WHITE"SIM anda sedang dalam proses pembuatan, silahkan ke Kantor Polisi Los Santos pada tanggal :\n"YELLOW"%s\n"WHITE"Pengambilan SIM dapat anda lakukan dengan memilih menu "GREEN"Ambil SIM "WHITE"\nAnda akan mendapatkan SIM pada saat itu juga.", tanggal_pengambilan);

		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"SIM sedang diproses", pDialog[playerid], "Ok", "");
	}else{
		// ID SIM A = 15
		// ID SIM B = 47
		// ID SIM C = 48
		new tipe_sim = GetPVarInt(playerid, "tipe_sim");
		if(tipe_sim == 1) tipe_sim = 15;
		else if(tipe_sim == 2) tipe_sim = 47;
		else if(tipe_sim == 3) tipe_sim = 48;
		cekKetersediaanItem(playerid, tipe_sim, 1, "isBisaBuatSIM");
	}
	return 1;
}

publicFor: pakaiMinuman(playerid, itemid){
	tambahItemPlayer(playerid, itemid, -1);
	ApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 1, 1, 0, 0, 1);

	for(new i = 0; i < sizeof(MENU_MAKANAN); i++){
		if(MENU_MAKANAN[i][idItemMakanan] == itemid){
			setStatusMinumPemain(playerid, getStatusMinumPemain(playerid) + MENU_MAKANAN[i][energiNambah]);
			break;
		}
	}
	return 1;
}

publicFor: isBisaBuatSIM(playerid, tidak_bisa){
	if(tidak_bisa){
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Anda telah memiliki SIM", WHITE"Maaf anda telah memiliki SIM, anda tidak dapat membuatnya lagi.", "Ok", "");
	}else{
		new sim_polisi[16];
		GetPVarString(playerid, "sim_polisi", sim_polisi, 16);
		if(sama("buat_sim", sim_polisi)){
			inline responseQuery(){
				if(cache_num_rows()){
					showDialogPesan(playerid, RED"Anda Sudah Ujian Teori", WHITE"Maaf anda sudah melakukan Ujian Teori SIM, anda tidak dapat melakukannya kembali!\nSilahkan melanjutkan ke tempat Ujian Praktik SIM berada di sebelah Kantor Polisi Los Santos (Parkiran).");
				}else{
					ShowPlayerDialog(playerid, DIALOG_DAFTAR_SIM_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi Pembuatan SIM", WHITE"Anda akan membuat SIM dengan syarat berikut.\nPersyaratan:\n"YELLOW"- Biaya administrasi sebesar "GREEN"$100"YELLOW"\n- Memiliki KTP", "Daftar", "Batal");
				}
			}
			MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT status_teori FROM `pengambilan_sim` WHERE `id_user` = '%d' AND status_teori = 1", PlayerInfo[playerid][pID]);
		}else if(sama("mulai_praktik", sim_polisi)){
			inline responseQuery(){
				if(!cache_num_rows()){
					showDialogPesan(playerid, RED"Anda Belum Ujian Teori", WHITE"Maaf anda belum melakukan Ujian Teori SIM, anda tidak dapat melakukan Ujian Praktik SIM!\nSilahkan melakukan Ujian Teori SIM terlebih dahulu, tempat Ujian Teori SIM berada di Kantor Polisi Los Santos.");
				}else{
					new tgl_buat[30];
					cache_get_value_name(0, "tanggal_buat", tgl_buat);
					if(sama("0000-00-00 00:00:00", tgl_buat)){
						ShowPlayerDialog(playerid, DIALOG_PRAKTIK_SIM_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Praktik SIM", WHITE"Anda sekarang akan melakukan praktik mengemudi kendaraan.\nSilahkan ikuti aturan dan arah jalan dengan benar sebagai berikut.\nAturan:\n"YELLOW"- Maksimal kecepatan "GREEN"80 KmpH\n"YELLOW"- Kendaraan tidak boleh menabrak apapun disekitar\n- Minimal poin "GREEN"80", "Ok", "Batal");
					}else{
						showDialogPesan(playerid, RED"Anda Sudah Ujian Praktik", WHITE"Maaf anda sudah melakukan Ujian Praktik SIM, anda tidak dapat melakukan kembali Ujian Praktik SIM!\nSilahkan ambil SIM di Kantor Polisi Los Santos.");
					}
				}
			}
			MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT * FROM `pengambilan_sim` WHERE `id_user` = '%d' AND status_teori = 1", PlayerInfo[playerid][pID]);
		}
	}
}

/**
	END ITEM TRIGGER
 */

updateStatusKunciItem(playerid, id_item, status){
	new temp_query[200];
	mysql_format(koneksi, temp_query, 200, "UPDATE user_item SET kunci = '%d' WHERE id_user = '%d' AND id_item = '%d'", status, PlayerInfo[playerid][pID], id_item);
	mysql_tquery(koneksi, temp_query);
}

tampilkanKotakMasuk(playerid){
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT a.id_sms, a.tanggal_dikirim, b.nomor_handphone, a.pesan FROM `sms` a LEFT JOIN `user` b ON a.id_user_pengirim = b.id WHERE a.id_user_penerima = '%d' AND a.id_pemilik_pesan = '%d' ORDER BY a.tanggal_dikirim DESC LIMIT %i, %i", PlayerInfo[playerid][pID], PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
	mysql_tquery(koneksi, pQuery[playerid], "lihatPesanMasuk", "d", playerid);
}

tampilkanKotakTerkirim(playerid){
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT a.id_sms, a.tanggal_dikirim, b.nomor_handphone, a.pesan FROM `sms` a LEFT JOIN `user` b ON a.id_user_penerima = b.id WHERE a.id_user_pengirim = '%d' AND a.id_pemilik_pesan = '%d' ORDER BY a.tanggal_dikirim DESC LIMIT %i, %i", PlayerInfo[playerid][pID], PlayerInfo[playerid][pID], GetPVarInt(playerid, "halaman") * BANYAK_DATA_PER_PAGE, BANYAK_DATA_PER_PAGE);
	mysql_tquery(koneksi, pQuery[playerid], "lihatPesanTerkirim", "d", playerid);
}

updateOnPlayerDisconnect(playerid){
	// Position
	new Float:last_spawn_info_x, Float:last_spawn_info_y, Float:last_spawn_info_z, Float:last_spawn_info_a, last_spawn_info_int, last_spawn_info_vw, Float:last_hp, Float:last_armour, Float:temp_stats_makan, Float:temp_stats_minum;
	if(PlayerInfo[playerid][sudahSpawn]){
		GetPlayerPos(playerid, last_spawn_info_x, last_spawn_info_y, last_spawn_info_z);
		GetPlayerFacingAngle(playerid, last_spawn_info_a);
		last_spawn_info_vw = GetPlayerVirtualWorld(playerid);
		last_spawn_info_int = GetPlayerInterior(playerid);

		last_hp = GetPlayerHealth(playerid);
		last_armour = GetPlayerArmour(playerid);

		temp_stats_makan = getStatusMakanPemain(playerid);
		temp_stats_minum = getStatusMinumPemain(playerid);
	}else{
		// Reset nilai jadi 0 semua
		last_hp = last_armour = last_spawn_info_x = last_spawn_info_y = last_spawn_info_z = last_spawn_info_a = temp_stats_makan = temp_stats_minum = 0;
		last_spawn_info_int = last_spawn_info_vw = 0;
	}

	new lama_bermain = getTotalLamaBermain(playerid);

	mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET last_x = '%f', last_y = '%f', last_z = '%f',last_a = '%f', last_int = '%d', last_vw = '%d', last_hp = '%f', last_armour = '%f', last_stats_makan = '%f', last_stats_minum = '%f', playtime = '%d', in_house = '%d' WHERE id = '%d'", last_spawn_info_x, last_spawn_info_y, last_spawn_info_z, last_spawn_info_a, last_spawn_info_int, last_spawn_info_vw, last_hp, last_armour, temp_stats_makan, temp_stats_minum, lama_bermain, PlayerInfo[playerid][inHouse], PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid]);
	return 1;
}

loadAllRarity(){
	new Cache:result, row, idx = 0;
	result = mysql_query(koneksi, "SELECT * FROM `item_rarity`");
	cache_get_row_count(row);
	while(idx < row){
		new id, nama[50], color[50];
		cache_get_value_name_int(idx, "id", id);
		cache_get_value_name(idx, "nama_rarity", nama);
		cache_get_value_name(idx, "hex_color", color);

		format(ITEM_RARITY[id-1][namaRarity], 50, "%s", nama);
		format(ITEM_RARITY[id-1][colorRarity], 14, "%s", color);

		#if DEBUG_SERVER_LOAD == true
			printf("Item rarity load id(%d) - %s", id, nama);
		#endif
		idx++;
	}
	cache_delete(result);
}

loadAllItem(){
	new id_item, 
		model_id, 
		nama_item[256], 
		keterangan_item[500],
		kapasitas,
		rarity,
		fungsi[101], 
		bool:is_null;
	new Cache:result, row, idx = 0;
	result = mysql_query(koneksi, "SELECT * FROM `item`");
	cache_get_row_count(row);
	while(idx < row){
		// iIt = Id Item > Menyimpan model id item
		// mIt = Model Item > Menyimpan id item
		// nIt = Nama Item > Menyimpan nama item diget dari id item
		// kIt = Keterangan Item > Menyimpan keterangan Item diget dari id item
		cache_get_value_name_int(idx, "id_item", id_item);
		cache_get_value_name_int(idx, "id_rarity", rarity);
		cache_get_value_name_int(idx, "model_id", model_id);
		cache_get_value_name_int(idx, "kapasitas", kapasitas);
		cache_get_value_name(idx, "nama_item", nama_item);
		cache_get_value_name(idx, "keterangan", keterangan_item);

		// Simpan value is null
		cache_is_value_name_null(idx, "fungsi", is_null);
		if(!is_null) cache_get_value_name(idx, "fungsi", fungsi);

		format(msg, sizeof(msg), "iIt_%d", id_item);
		SetSVarInt(msg, model_id);

		format(msg, sizeof(msg), "rIt_%d", id_item);
		SetSVarInt(msg, rarity);

		format(msg, sizeof(msg), "cIt_%d", id_item);
		SetSVarInt(msg, kapasitas);

		format(msg, sizeof(msg), "nIt_%d", id_item);
		SetSVarString(msg, nama_item);

		format(msg, sizeof(msg), "kIt_%d", id_item);
		SetSVarString(msg, keterangan_item);

		format(msg, sizeof(msg), "fIt_%d", id_item);
		if(is_null) SetSVarString(msg, "itemTidakDapatDipakai");
		else SetSVarString(msg, fungsi);

		#if DEBUG_SERVER_LOAD == true
			printf("Item load id(%d) - %s", id_item, nama_item);
		#endif

		idx++;
	}
	cache_delete(result);
}

publicFor: ambilItemDariInvenRumah(playerid, id_item, input_jumlah, const nama_item[]){
	new total_item;
	cache_get_value_name_int(0, "total_item", total_item);
	if((total_item + input_jumlah * getKapasitasByIdItem(id_item)) > PlayerInfo[playerid][limitItem]){
		dialogInventoryItemTidakMuat(playerid, input_jumlah, total_item, id_item);
	}else{
		tambahItemHouse(PlayerInfo[playerid][inHouse], id_item, -input_jumlah);
		tambahItemPlayer(playerid, id_item, input_jumlah);

		format(pDialog[playerid], sizePDialog, "Anda berhasil mengambil "YELLOW"%s"WHITE" dari dalam inventory rumah.\nSebanyak "YELLOW"%d"WHITE".\nAnda dapat menyimpannya kembali selama anda memiliki cukup ruang.", nama_item, input_jumlah);
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mengambil barang", pDialog[playerid], "Ok", "");
	}
	resetPVarInventory(playerid);
	return 1;
}

publicFor: simpanItemKeInvenRumah(playerid, max_slot, id_item, input_jumlah, const nama_item[])
{
	new total_item;
	cache_get_value_name_int(0, "total_item", total_item);
	if((total_item + input_jumlah * getKapasitasByIdItem(id_item)) > max_slot){
		format(pDialog[playerid], sizePDialog, "Maaf inventory rumah item anda tidak memiliki cukup ruang,\nUntuk menyimpan sebanyak "ORANGE"%i "WHITE"item yang membutuhkan kapasitas "ORANGE"%i "WHITE"per item.\n Sisa ruang yang anda miliki adalah "ORANGE"(%i/%i).", input_jumlah, getKapasitasByIdItem(id_item), total_item, max_slot);

		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory rumah anda penuh", pDialog[playerid], "Ok", "");
	}else{
		tambahItemHouse(PlayerInfo[playerid][inHouse], id_item, input_jumlah);
		tambahItemPlayer(playerid, id_item, -input_jumlah);

		format(pDialog[playerid], sizePDialog, "Anda berhasil menyimpan "YELLOW"%s"WHITE" ke dalam inventory rumah.\nSebanyak "YELLOW"%d"WHITE".\nAnda dapat mengambilnya kembali.", nama_item, input_jumlah);
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menyimpan barang", pDialog[playerid], "Ok", "");
	}
	resetPVarInventory(playerid);
	return 1;
}

loadAllHouseLevel(){
	new Cache:result = mysql_query(koneksi, "SELECT * FROM house_interior"), idx = 0, temp_str[50], Float:temp_fl[3], rows, id;
	cache_get_row_count(rows);
	while(idx < rows){
		cache_get_value_name_int(idx, "id_level", id);
		Iter_Add(HouseLevelIterator, id);
		cache_get_value_name(idx, "nama_level", temp_str);
		format(HouseLevel[id][namaLevel], 50, "%s", temp_str);
		cache_get_value_name_float(idx, "pickup_out_x", temp_fl[0]);
		cache_get_value_name_float(idx, "pickup_out_y", temp_fl[1]);
		cache_get_value_name_float(idx, "pickup_out_z", temp_fl[2]);
		if(idx == 0) PU_tempatKeluarRumah[0] = CreateDynamicPickup(1318, 1, temp_fl[0], temp_fl[1], temp_fl[2]);
		else PU_tempatKeluarRumah[1] = CreateDynamicPickup(1318, 1, temp_fl[0], temp_fl[1], temp_fl[2]);
		cache_get_value_name_float(idx, "spawn_in_x", HouseLevel[id][intSpawn][0]);
		cache_get_value_name_float(idx, "spawn_in_y", HouseLevel[id][intSpawn][1]);
		cache_get_value_name_float(idx, "spawn_in_z", HouseLevel[id][intSpawn][2]);
		cache_get_value_name_float(idx, "spawn_in_a", HouseLevel[id][intSpawn][3]);
		cache_get_value_name_int(idx, "spawn_in_interior", HouseLevel[id][intSpawnInterior]);
		cache_get_value_name_int(idx, "limit_item", HouseLevel[id][houseItemCapacity]);

		#if defined DEBUG_SERVER_LOAD
		printf("House Level %s berhasil load.", temp_str);
		#endif

		idx++;
	}
	if(rows >= 1 && PU_tempatKeluarRumah[0] + rows - 1 != PU_tempatKeluarRumah[1]){
		printf("[ERROR] #012 Pickup House Level tidak memiliki ID yang simetris.");
        SendRconCommand("exit");
	}

	cache_delete(result);
}

loadAllHouse(){
	new house_Id, userId, houseLevel, houseHarga, houseSetHarga, houseKunci, houseJual, hX[256], hY[256], hZ[256], temp_nama[MAX_PLAYER_NAME];
	new Cache:result, row, idx = 0;
	result = mysql_query(koneksi, "SELECT a.*, b.nama FROM `house` a LEFT JOIN `user` b ON a.id_user = b.id");
	cache_get_row_count(row);
	while(idx < row){
		result = cache_save();
		cache_get_value_name_int(idx, "id_house", house_Id);
		cache_get_value_name_int(idx, "id_user", userId);
		cache_get_value_name_int(idx, "level", houseLevel);
		cache_get_value_name_int(idx, "harga", houseHarga);
		cache_get_value_name_int(idx, "setharga", houseSetHarga);
		cache_get_value_name_int(idx, "kunci", houseKunci);
		cache_get_value_name_int(idx, "jual", houseJual);
		cache_get_value_name(idx, "icon_x", hX);
		cache_get_value_name(idx, "icon_y", hY);
		cache_get_value_name(idx, "icon_z", hZ);
		
		if(userId != -1){
			cache_get_value_name(idx, "nama", temp_nama);
			format(houseInfo[house_Id][hOwnerName], MAX_PLAYER_NAME + 1, "%s", temp_nama);
		}

		createHouse(house_Id, userId, houseLevel, houseHarga, houseSetHarga, houseKunci, houseJual, floatstr(hX), floatstr(hY), floatstr(hZ));
		loadHouseFurniture(house_Id);
		cache_set_active(result);
		
		#if DEBUG_SERVER_LOAD == true
			printf("House load id(%d)", house_Id);
		#endif

		idx++;
	}
	cache_delete(result);
}

loadHouseFurniture(house_id){
	inline responseQuery(){
		new rows, idx = 0;
		cache_get_row_count(rows);
		if(rows){
			new data[e_furniture], id_object, interior;

			while(idx < rows){
				cache_get_value_name_int(idx, "id", data[fID]);
				cache_get_value_name_int(idx, "id_furniture", data[fFurnitureID]);
				cache_get_value_name_int(idx, "id_object", id_object);
				cache_get_value_name_int(idx, "spawn_in_interior", interior);
				data[fHouseID] = house_id;
				cache_get_value_name_float(idx, "pos_x", data[fPosX]);
				cache_get_value_name_float(idx, "pos_y", data[fPosY]);
				cache_get_value_name_float(idx, "pos_z", data[fPosZ]);
				cache_get_value_name_float(idx, "rot_x", data[fRotX]);
				cache_get_value_name_float(idx, "rot_y", data[fRotY]);
				cache_get_value_name_float(idx, "rot_z", data[fRotZ]);

				new objectid = CreateDynamicObject(id_object, data[fPosX], data[fPosY], data[fPosZ], data[fRotX], data[fRotY], data[fRotZ], house_id, interior);

				#if defined DEBUG_SERVER_LOAD
				printf("House furniture (%d) - House ID(%d) - Object", data[fID], house_id, objectid);
				#endif

				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);
				idx++;
			}
		}
	}
	MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT a.*, b.id_object, d.spawn_in_interior FROM house_furniture a INNER JOIN furniture b ON a.id_furniture = b.id INNER JOIN house c ON c.id_house = a.id_house INNER JOIN house_interior d ON d.id_level = c.level WHERE a.id_house = %d", house_id);
}

publicFor: tutupToll(tollid){
	if(tollid == 0){
		MoveDynamicObject(palangToll[0], 48.55240, -1523.09351, 4.81230, 2.5, 0.00000, 0.00000, 85.00000);
		isTollUsed[0] = 0;
	}else if(tollid == 1){
		MoveDynamicObject(palangToll[1], 58.10060, -1539.95105, 5.09970, 2.5, 0.00000, 0.00000, 85.00000);
		isTollUsed[1] = 0;
	}else if(tollid == 3){
		MoveDynamicObject(palangToll_LSLV[0], 1745.46155, 551.11792, 26.02680, 0.0001, 0.00000, 270.00000, -18.16000);
		isTollUsed_LSLV[0] = 0;
	}else if(tollid == 4){
		MoveDynamicObject(palangToll_LSLV[1], 1753.44653, 558.05688, 25.40680, 0.0001, 0.00000, 270.00000, -198.00000);
		isTollUsed_LSLV[1] = 0;
	}
}

unloadAllHouse(){
	for(new i = 0; i < MAX_HOUSES; i++){
		if(housePickup[i] != -1){
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
}

resetAllHouse(){
	unloadAllHouse();
	loadAllHouse();
}

createHouse(house_Id, ownerId, houseLevel, houseHarga, houseSetHarga, houseKunci, houseJual, Float:hX, Float:hY, Float:hZ)
{
	if(house_Id < MAX_HOUSES ){
		new Id = CreateDynamicPickup(1273, 1, hX, hY, hZ);
		housePickup[house_Id] = Id;
		houseId[Id] = house_Id;
		houseInfo[house_Id][hID] = house_Id;
		houseInfo[house_Id][hOwner] = ownerId;
		houseInfo[house_Id][hLevel] = houseLevel;
		houseInfo[house_Id][hHarga] = houseHarga;
		houseInfo[house_Id][hSetHarga] = houseSetHarga;
		houseInfo[house_Id][hKunci] = houseKunci;
		houseInfo[house_Id][hJual] = houseJual;
		houseInfo[house_Id][icon_x] = hX;
		houseInfo[house_Id][icon_y] = hY;
		houseInfo[house_Id][icon_z] = hZ;
		reloadHouseLabel(house_Id);
	}else{
		print("Rumah mencapai limit!");
	}
}

reloadHouseLabel(house_Id){
	if(IsValidDynamic3DTextLabel(houseTextInfo[house_Id])){
		DestroyDynamic3DTextLabel(houseTextInfo[house_Id]);
	}
	new text_info[256], beliRate;
	if(houseInfo[house_Id][hSetHarga] != 0){
		beliRate = houseInfo[house_Id][hSetHarga];
	}else{
		beliRate = getHousePrice(house_Id, "beli");
	}
	houseTextInfo[house_Id] = Text3D:INVALID_3DTEXT_ID;

	format(text_info, 256, "%d, "YELLOW"%s, "ORANGE"%s\n", houseInfo[house_Id][hID], GetZoneName(houseInfo[house_Id][icon_x], houseInfo[house_Id][icon_y], houseInfo[house_Id][icon_z]), GetCityName(houseInfo[house_Id][icon_x], houseInfo[house_Id][icon_y], houseInfo[house_Id][icon_z]));

	if(houseInfo[house_Id][hJual] == 1){
		format(text_info, 256, "%s"GREEN"Dijual\n"WHITE"Harga : "GREEN"$%s\n", text_info, formatHarga(beliRate));
	}
	if(houseInfo[house_Id][hOwner] != -1)
		format(text_info, 256, "%s"WHITE"Pemilik : "PURPLE"%s\n", text_info, houseInfo[house_Id][hOwnerName]);
	else
		format(text_info, 256, "%s"WHITE"Pemilik : "GREY"Tidak ada\n", text_info);

	format(text_info, 256, "%s"WHITE"Level : "PINK"%s", text_info, HouseLevel[houseInfo[house_Id][hLevel]][namaLevel]);
	strcat(text_info, "\n"WHITE"Tekan "GREEN"N "WHITE"untuk masuk");
	
    houseTextInfo[house_Id] = CreateDynamic3DTextLabel(text_info, COLOR_WHITE, houseInfo[house_Id][icon_x], houseInfo[house_Id][icon_y], houseInfo[house_Id][icon_z]+0.75, 5.0);
}

getHousePrice(house_Id, const method[16] = ""){
	if(house_Id < MAX_HOUSES){
		new hargaRate, methodName[16];
		format(methodName, 16, method);
		if(sama("beli", methodName)){
			hargaRate = houseInfo[house_Id][hLevel]*houseInfo[house_Id][hLevel]*houseInfo[house_Id][hHarga];
		}else if(sama("upgrade", methodName)){
			hargaRate = houseInfo[house_Id][hLevel]*(houseInfo[house_Id][hLevel]+1)*houseInfo[house_Id][hHarga];
		}	
		return hargaRate;
	}
	return -1;
}

getKayuForUpgradeHouse(level){
	return level * JUMLAH_KAYU_PER_UPGRADE;
}

todoActive(playerid){
	if(sweeperJob[playerid] == 1){
		SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "RED"Maaf anda sedang bekerja sebagai Sweeper, silahkan kembali bekerja!");
		return 1;
	}
	if(trashM_Job[playerid] == 1){
		SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "RED"Maaf anda sedang bekerja sebagai Trashmaster, silahkan kembali bekerja!");
		return 1;
	}
	if(pizza_Job[playerid] == 1){
		SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "RED"Maaf anda sedang bekerja sebagai Pizzaboy, silahkan kembali bekerja!");
		return 1;
	}
	if(testSim[playerid] == 1){
		SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "RED"Maaf anda sedang melakukan Ujian Praktik SIM, silahkan kembali praktik!");
		return 1;
	}
	return 0;
}

updatePVehReparasi(primary_id, status){
	new temp_query[250];
	mysql_format(koneksi, temp_query, 250, "UPDATE vehicle SET is_reparasi = '%d' WHERE id = '%d'", status, primary_id);
	mysql_tquery(koneksi, temp_query);
}

publicFor: resetPlayerToDo(playerid){
	if(sweeperJob[playerid] == 1){
		if(todoFinish[playerid] != 1){
			SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "RED"Anda telah berhenti bekerja!");
		}
		SetVehicleToRespawn(sweeperId[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		DeletePreciseTimer(todoTimer[playerid]);
		DeletePreciseTimer(todoTimeout[playerid]);
		sweeperJob[playerid] = 0;
		usedSweeper[sweeperId[playerid]] = 0;
		sweeperId[playerid] = -1;
		todoFinish[playerid] = 0;
	}
	if(trashM_Job[playerid] == 1){
		if(todoFinish[playerid] != 1){
			SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "RED"Anda telah berhenti bekerja!");
		}
		DisablePlayerCheckpoint(playerid);
		TogglePlayerAllDynamicCPs(playerid, 1);
		SetVehicleToRespawn(trashM_Id[playerid]);
		DeletePreciseTimer(todoTimer[playerid]);
		DeletePreciseTimer(todoTimeout[playerid]);
		if(IsPlayerAttachedObjectSlotUsed(playerid, TRASH_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, TRASH_ATTACH_INDEX);
		todoFinish[playerid] = 0;
		trashM_Job[playerid] = 0;
		trashM_Used[trashM_Id[playerid]] = 0;
		trashM_BagCap[playerid] = 0;
		trashM_VehCap[trashM_Id[playerid]] = 0;
		trashM_Id[playerid] = -1;
		for(new i = 0; i < MAX_HOUSES; i++){
			if(housePickup[i] != -1){
				if(trashM_HouseTake[playerid][i] == 1){
					trashM_HouseTake[playerid][i] = 0;
				}
			}
		}
		trashM_House[playerid] = -1;
	}
	if(pizza_Job[playerid] == 1){
		if(todoFinish[playerid] != 1){
			SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "RED"Anda telah berhenti bekerja!");
		}
		DisablePlayerCheckpoint(playerid);
		TogglePlayerAllDynamicCPs(playerid, 1);
		SetVehicleToRespawn(pizza_Id[playerid]);
		DeletePreciseTimer(todoTimer[playerid]);
		DeletePreciseTimer(todoTimeout[playerid]);
		if(IsPlayerAttachedObjectSlotUsed(playerid, TRASH_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, TRASH_ATTACH_INDEX);
		todoFinish[playerid] = 0;
		pizza_Job[playerid] = 0;
		pizza_Used[pizza_Id[playerid]] = 0;
		pizza_Carry[playerid] = 0;
		pizza_VehCap[pizza_Id[playerid]] = 0;
		pizza_Id[playerid] = -1;
		for(new i = 0; i < MAX_HOUSES; i++){
			if(housePickup[i] != -1){
				if(pizza_HouseTake[playerid][i] == 1){
					pizza_HouseTake[playerid][i] = 0;
				}
			}
		}
		pizza_House[playerid] = -1;
		pizza_HouseDrop[playerid] = 0;
	}
	if(testSim[playerid] == 1){
		if(todoFinish[playerid] != 1){
			SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "RED"Anda telah gagal melalukan Ujian Praktik SIM, silahkan coba lagi!");
		}
		SetVehicleToRespawn(vehicleIdSIM[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		DeletePreciseTimer(todoTimer[playerid]);
		DeletePreciseTimer(todoTimeout[playerid]);
		testSim[playerid] = 0;
		poinSim[playerid] = 0;
		limitVehSIM[vehicleIdSIM[playerid]] = 0;
		vehicleIdSIM[playerid] = -1;
		todoFinish[playerid] = 0;
	}
	if(CuttingTreeID[playerid] != -1){
		CuttingTreeID[playerid] = -1;
		treeEditID[playerid] = -1;
	}

	// CuttingBar dipindahkan ke load player text draw
    if(CuttingTimer[playerid] != -1){
        DeletePreciseTimer(CuttingTimer[playerid]);
        CuttingTimer[playerid] = -1;
    }
	if(SpeedoTimer[playerid] != -1){
        DeletePreciseTimer(SpeedoTimer[playerid]);
        SpeedoTimer[playerid] = -1;
	}
    if(PerbaikiTimer[playerid] != -1){
        DeletePreciseTimer(PerbaikiTimer[playerid]);
        PerbaikiTimer[playerid] = -1;
    }

	PlayerInfo[playerid][hungryStackedTime] = 0;
	PlayerInfo[playerid][thirstyStackedTime] = 0;

	return 1;
}

mulaiPraktikSIM(playerid){
	inline responseQuery(){
		new tipe_sim;
		cache_get_value_name_int(0, "tipe_sim", tipe_sim);
		if(cache_num_rows()){
			foreach(new i : Player){
				new v = vehicleSIM[tipe_sim-1];
				if(limitVehSIM[v] != 1){
					testSim[playerid] = 1;
					poinSim[playerid] = 100;
					PutPlayerInVehicle(playerid, v, 0);
					vehicleIdSIM[playerid] = v;
					limitVehSIM[v] = 1;
					SetPlayerRaceCheckpoint(playerid, 0, CP_simLS1, CP_simLS2, 3.0);
					SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "WHITE"Anda memiliki waktu 10 menit, jika belum selesai anda akan gagal.");
					todoTimeout[playerid] = SetPreciseTimer("resetPlayerToDo", 600000, false, "i", playerid);
					return 1;
				}else{
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Kendaraan Limit", WHITE"Maaf kendaraan untuk pengujian pembuatan SIM sedang digunakan, mohon untuk tunggu beberapa menit.", "Ok", "");
					return 1;
				}
			}
		}else{
			showDialogPesan(playerid, RED"Anda Belum Ujian Teori", WHITE"Maaf anda belum melakukan Ujian Teori SIM, anda tidak dapat melakukan Ujian Praktik SIM!\nSilahkan melakukan Ujian Teori SIM terlebih dahulu, tempat Ujian Teori SIM berada di Kantor Polisi Los Santos.");
		}
	}
	MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT tipe_sim FROM `pengambilan_sim` WHERE `id_user` = '%d' AND status_teori = '1'", PlayerInfo[playerid][pID]);
	return 1;	
}

UnloadBoards(){
	static const kosong[boardInfo];
	foreach(new i : Range(0, jumlahBoard)){
		DestroyDynamicObject(BoardInfo[i][bBoard]);
		BoardInfo[i] = kosong;
	}
	jumlahBoard = 0;
}

DeleteBoard(i){
	DestroyDynamicObject(BoardInfo[i][bBoard]);
	mysql_format(koneksi, sQuery, sizeSQuery, "DELETE FROM papan WHERE id_papan = '%d'", BoardInfo[i][boardID]);
	mysql_tquery(koneksi, sQuery);

	static const kosong[boardInfo];
	BoardInfo[i] = kosong;
}

LoadBoards()
{
	new Cache:result = mysql_query(koneksi, "SELECT * FROM papan");
	new temp_text[1000];
	cache_get_row_count(jumlahBoard);
	foreach(new i : Range(0, jumlahBoard)){
		cache_get_value_name_int(i, "id_papan", BoardInfo[i][boardID]);
		cache_get_value_name_int(i, "id_model", BoardInfo[i][bModel]);
		cache_get_value_name_int(i, "font_size", BoardInfo[i][bFontSiz]);

		cache_get_value_name_float(i, "pos_x", BoardInfo[i][bCX]);
		cache_get_value_name_float(i, "pos_y", BoardInfo[i][bCY]);
		cache_get_value_name_float(i, "pos_z", BoardInfo[i][bCZ]);
		cache_get_value_name_float(i, "rot_x", BoardInfo[i][bCRX]);
		cache_get_value_name_float(i, "rot_y", BoardInfo[i][bCRY]);
		cache_get_value_name_float(i, "rot_z", BoardInfo[i][bCRZ]);
		
		cache_get_value_name(i, "text", temp_text);
		format(BoardInfo[i][bText], 1000, "%s", temp_text);

		#if defined DEBUG_SERVER_LOAD
			printf("Board ID(%d) berhasil di load", BoardInfo[i][boardID]);
		#endif

		strreplace(BoardInfo[i][bText], "\\n", "\n");
		
		BoardInfo[i][bBoard] = CreateDynamicObject(BoardInfo[i][bModel], BoardInfo[i][bCX], BoardInfo[i][bCY], BoardInfo[i][bCZ], BoardInfo[i][bCRX], BoardInfo[i][bCRY], BoardInfo[i][bCRZ]);

		SetDynamicObjectMaterialText(BoardInfo[i][bBoard], 0, BoardInfo[i][bText], OBJECT_MATERIAL_SIZE_256x128, "Arial", BoardInfo[i][bFontSiz], 1, 0x000000FF,0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
		BoardInfo[i][bStatus] = 1;
	}
	cache_delete(result);
}

// Kosongkan board id untuk INSERT
// isi argumen board id untuk UPDATE
SaveBoard(modelid, Float:x, Float:y, Float:z, Float:rot_x, Float:rot_y, Float:rot_z, const text[], fontsize, boardid = -1)
{
	if(boardid == -1){ // INSERT
		mysql_format(koneksi, sQuery, sizeSQuery, "INSERT INTO papan(id_model,pos_x,pos_y,pos_z,rot_x,rot_y,rot_z,text,font_size) VALUES('%d', '%f', '%f', '%f', '%f', '%f', '%f', '%e', '%d')", modelid, x, y, z, rot_x, rot_y, rot_z, text, fontsize);
	}else{ // Update
		mysql_format(koneksi, sQuery, sizeSQuery, "UPDATE papan SET id_model = '%d', pos_x = '%f', pos_y = '%f',pos_z = '%f', rot_x = '%f', rot_y = '%f', rot_z = '%f', text = '%e', font_size = '%d' WHERE id_papan = '%d'", modelid, x, y, z, rot_x, rot_y, rot_z, text, fontsize, boardid);
	}
	mysql_tquery(koneksi, sQuery);
}

LoadFactionPlayer(playerid){
	inline responseLoadFaction(){
		new rows;
		cache_get_row_count(rows);
		if(rows){
			new id_faction, temp_level;
			for(new idx=0; idx<rows; idx++){
				cache_get_value_name_int(idx, "id_faction", id_faction);
				cache_get_value_name_int(idx, "level", temp_level);

				switch(id_faction){
					case 1: // Polisi
						PlayerInfo[playerid][levelPolice] = temp_level;
					case 2: // Medis
						PlayerInfo[playerid][levelMedic] = temp_level;
				}
			}
		}
	}
	MySQL_TQueryInline(koneksi, using inline responseLoadFaction, "SELECT * FROM user_faction WHERE (expired > NOW() OR expired IS NULL) AND id_user = %d", PlayerInfo[playerid][pID]);
}

LoadVehiclePlayer(playerid){
	inline responseLoadVehicle(){
		new rows;
		cache_get_row_count(rows);
		if(rows){
			new idx = 0, idveh, idpv, temp_id, already_loaded, temp_time,
				panels, doors, lights, tires, engine, alarm, bonnet, boot, objective,
				bensin;

			while(idx < rows){
				already_loaded = -1; // Bakal menyimpan idpv kendaraan
				cache_get_value_name_int(idx, "id", temp_id);


				// Cek apakah sudah ada sebelumnya
				foreach(new i : PVehIterator){
					if(PVeh[i][pVehID] == temp_id) {
						already_loaded = i;
						break;
					}
				}
				cache_get_value_name_int(idx, "expired", temp_time); // Dalam unix_timestamp
				if(already_loaded != -1) {
					if(temp_time != 0){
						// Simpan waktu
						Iter_Add(PVehKeys[playerid], already_loaded);
						PVehKeysTime[playerid][already_loaded] = temp_time;
					}
					idx++;
					continue;
				}		

				// load kendaraan
				idpv = Iter_Free(PVehIterator);
				PVeh[idpv][pVehID] = temp_id;
				cache_get_value_name_int(idx, "id_pemilik", PVeh[idpv][pVehPemilik]);
				cache_get_value_name_float(idx, "darah", PVeh[idpv][pVehDarah]);

				cache_get_value_name_int(idx, "id_model", PVeh[idpv][pVehModel]);
				cache_get_value_name_float(idx, "pos_x", PVeh[idpv][pVehCoord][0]);
				cache_get_value_name_float(idx, "pos_y", PVeh[idpv][pVehCoord][1]);
				cache_get_value_name_float(idx, "pos_z", PVeh[idpv][pVehCoord][2]);
				cache_get_value_name_float(idx, "pos_a", PVeh[idpv][pVehCoord][3]);
				cache_get_value_name_int(idx, "color_1", PVeh[idpv][pVehColor][0]);
				cache_get_value_name_int(idx, "color_2", PVeh[idpv][pVehColor][1]);				
				cache_get_value_name_int(idx, "is_reparasi", PVeh[idpv][pVehIsReparasi]);

				cache_get_value_name_int(idx, "paintjob", PVeh[idpv][pVehPaintJob]);
				cache_get_value_name_int(idx, "veh_mod_1", PVeh[idpv][pVehMod][0]);
				cache_get_value_name_int(idx, "veh_mod_2", PVeh[idpv][pVehMod][1]);
				cache_get_value_name_int(idx, "veh_mod_3", PVeh[idpv][pVehMod][2]);
				cache_get_value_name_int(idx, "veh_mod_4", PVeh[idpv][pVehMod][3]);
				cache_get_value_name_int(idx, "veh_mod_5", PVeh[idpv][pVehMod][4]);
				cache_get_value_name_int(idx, "veh_mod_6", PVeh[idpv][pVehMod][5]);
				cache_get_value_name_int(idx, "veh_mod_7", PVeh[idpv][pVehMod][6]);
				cache_get_value_name_int(idx, "veh_mod_8", PVeh[idpv][pVehMod][7]);
				cache_get_value_name_int(idx, "veh_mod_9", PVeh[idpv][pVehMod][8]);
				cache_get_value_name_int(idx, "veh_mod_10", PVeh[idpv][pVehMod][9]);
				cache_get_value_name_int(idx, "veh_mod_11", PVeh[idpv][pVehMod][10]);
				cache_get_value_name_int(idx, "veh_mod_12", PVeh[idpv][pVehMod][11]);
				cache_get_value_name_int(idx, "veh_mod_13", PVeh[idpv][pVehMod][12]);
				cache_get_value_name_int(idx, "veh_mod_14", PVeh[idpv][pVehMod][13]);

				cache_get_value_name_int(idx, "status_panels", panels);
				cache_get_value_name_int(idx, "status_doors", doors);
				cache_get_value_name_int(idx, "status_lights", lights);
				cache_get_value_name_int(idx, "status_tires", tires);

				cache_get_value_name_int(idx, "bensin", bensin);

				format(PVeh[idpv][pVehNamaPemilik], MAX_PLAYER_NAME, "%s", PlayerInfo[playerid][pPlayerName]);

				if(temp_time != 0){
					// Sign waktu kunci
					Iter_Add(PVehKeys[playerid], idpv);
					PVehKeysTime[playerid][idpv] = temp_time;
				}

				if(PVeh[idpv][pVehDarah] <= 251){
					PVeh[idpv][pVehIsReparasi] = STATUS_KENDARAAN_RUSAK;
					updatePVehReparasi(PVeh[idpv][pVehID], STATUS_KENDARAAN_RUSAK);
				}

				if(!PVeh[idpv][pVehIsReparasi]) {
					idveh = CreateVehicle(PVeh[idpv][pVehModel], PVeh[idpv][pVehCoord][0], PVeh[idpv][pVehCoord][1], PVeh[idpv][pVehCoord][2], PVeh[idpv][pVehCoord][3], PVeh[idpv][pVehColor][0], PVeh[idpv][pVehColor][1], -1);

					PVeh[idpv][pVehicle] = idveh;

					IDVehToPVeh[idveh] = idpv;
					Iter_Add(IDVehToPVehIterator, idveh);

					#if defined DEBUG_SERVER_LOAD
					printf("Vehicle Player %s Vehicle-ID(%d) ig-ID(%d) load.",PlayerInfo[playerid][pPlayerName], PVeh[idpv][pVehID], idveh);
					#endif

					SetVehicleToRespawn(idveh);

					SetVehicleHealth(idveh, PVeh[idpv][pVehDarah]);
					UpdateVehicleDamageStatus(idveh, panels, doors, lights, tires);

					SetVehicleFuel(idveh, bensin);

					// Memakai variable yang sama dengan UpdateVehicleDamageStatus maka di terakhirkan saja, agar tidak ditimpa value nya oleh fungsi getter VehicleParamsEx
					GetVehicleParamsEx(idveh, engine, lights, alarm, doors, bonnet, boot, objective);
					SetVehicleParamsEx(idveh, 0, 0, alarm, doors, bonnet, boot, objective);
				}

				Iter_Add(PVehIterator, idpv);
				idx++;
			}
		}
	}
	MySQL_TQueryInline(koneksi, using inline responseLoadVehicle, "SELECT a.*, IFNULL(b.expired, 0) as expired FROM vehicle a LEFT JOIN vehicle_keys b ON b.id_vehicle = a.id WHERE (b.id_user = '%d' AND b.expired > UNIX_TIMESTAMP(NOW())) OR a.id_pemilik = '%d'", PlayerInfo[playerid][pID], PlayerInfo[playerid][pID]);
}

PinjamkanKunciKePemain(playerid, idpveh, menit){
	new temp_query[500];
	mysql_format(koneksi, temp_query, 500, "INSERT INTO vehicle_keys(id_user, id_vehicle, expired) VALUES('%d', '%d', UNIX_TIMESTAMP(NOW()) + %d)", PlayerInfo[playerid][pID], PVeh[idpveh][pVehID], menit * 60);
	mysql_tquery(koneksi, temp_query);

	// Simpan waktu
	Iter_Add(PVehKeys[playerid], idpveh);
	PVehKeysTime[playerid][idpveh] = gettime() + menit * 60;
}

LoadModifVehiclePlayer(vehicleid){
	new const idpv = IDVehToPVeh[vehicleid];
	for(new i = 0; i < 14; i++) {
		if(IsValidComponentForVehicle(vehicleid, PVeh[idpv][pVehMod][i])){
			AddVehicleComponent(vehicleid, PVeh[idpv][pVehMod][i]);
			
			// sideskirts and vents that have left and right side should be applied twice
			switch (PVeh[idpv][pVehMod][i])
			{
				case 1007, 1027, 1030, 1039, 1040, 1051, 1052, 1062, 1063, 1071, 1072, 1094, 1099, 1101, 1102, 1107, 1120, 1121, 1124, 1137, 1142 .. 1145: AddVehicleComponent(vehicleid, PVeh[idpv][pVehMod][i]);
			}
		}
	}
	if(PVeh[idpv][pVehPaintJob] != INVALID_PAINTJOB_ID) ChangeVehiclePaintjob(vehicleid, PVeh[idpv][pVehPaintJob]);
}

/**
	``` 
		nominal = nominal yang dibutuhkan untuk transaksi
		fungsi_callback_success = nama fungsi yang akan dipanggil saat pembayaran berhasil
		keterangan_atm = Kata-kata yang disimpan pada transaksi, contoh : pembelian burger
	```
 */

dialogMetodeBayar(playerid, nominal, const fungsi_callback_success[], const keterangan_atm[]){
	SetPVarString(playerid, "metode_callback_sukses", fungsi_callback_success);
	SetPVarString(playerid, "metode_keterangan_atm", keterangan_atm);
	SetPVarInt(playerid, "metode_nominal", nominal);
	ShowPlayerDialog(playerid, DIALOG_METODE_BAYAR, DIALOG_STYLE_LIST, YELLOW"Silahkan pilih metode pembayaran", GREEN"Uang Cash\n"ORANGE"E-Banking", "Pilih", "Batal");
}

UnloadVehiclePlayer(playerid){
	new id = PlayerInfo[playerid][pID], temp_nama[24], hancurkan;
	format(temp_nama, 24, "%s", PlayerInfo[playerid][pPlayerName]);
	static const kosong_pveh[PlayerVehicleInfo];
	foreach(new i : PVehIterator){
		if(PVeh[i][pVehPemilik] == id || Iter_Contains(PVehKeys[playerid], i)) {
			hancurkan = 1;
			
			foreach(new j : Player){
				if(j == playerid) continue;
				if(PVeh[i][pVehPemilik] == PlayerInfo[j][pID] || Iter_Contains(PVehKeys[j], i)){
					hancurkan = 0;
					break;
				}
			}

			// Bersihkan iterator
			Iter_Remove(PVehKeys[playerid], i);
			PVehKeysTime[playerid][i] = 0;

			if(hancurkan == 0) continue;

			new cur = i;
			#if defined DEBUG_SERVER_LOAD
			printf("Vehicle Player %s Vehicle-ID(%d) ig-ID(%d) unloaded.", temp_nama, PVeh[id][pVehID], i);
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
}

UpdatePosisiDarahVehiclePlayer(vehicleid){
	new idpv = IDVehToPVeh[vehicleid];
	if(!Iter_Contains(PVehIterator, idpv) || !PVeh[idpv][pVehID]) {
		printf("#011 Error save Posisi dan Darah ID(%d)", vehicleid);
		return 0;
	}
	new temp_sql[1000],
		panels, doors, lights, tires;
	new pveh_data[PlayerVehicleInfo];
	pveh_data = PVeh[idpv];

	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

	mysql_format(koneksi, temp_sql, 1000, "UPDATE vehicle SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', darah = '%f', status_panels = '%d', status_doors = '%d', status_lights = '%d', status_tires = '%d', bensin = '%d' WHERE id = '%d'", pveh_data[pVehCoord][0], pveh_data[pVehCoord][1], pveh_data[pVehCoord][2], pveh_data[pVehCoord][3], pveh_data[pVehDarah], panels, doors, lights, tires, GetVehicleFuel(vehicleid), pveh_data[pVehID]);
	return mysql_tquery(koneksi, temp_sql);
}

UpdateTampilanVehiclePlayer(vehicleid){
	new idpv = IDVehToPVeh[vehicleid];
	if(!PVeh[idpv][pVehID]) return 0;

	new temp_sql[1000];
	new pveh_data[PlayerVehicleInfo];
	pveh_data = PVeh[idpv];
	mysql_format(koneksi, temp_sql, 1000, "UPDATE vehicle SET color_1 = '%d', color_2 = '%d', paintjob = '%d', veh_mod_1 = '%d', veh_mod_2 = '%d', veh_mod_3 = '%d', veh_mod_4 = '%d', veh_mod_5 = '%d', veh_mod_6 = '%d', veh_mod_7 = '%d', veh_mod_8 = '%d', veh_mod_9 = '%d', veh_mod_10 = '%d', veh_mod_11 = '%d', veh_mod_12 = '%d', veh_mod_13 = '%d', veh_mod_14 = '%d', darah = '%f' WHERE id = '%d'", pveh_data[pVehColor][0], pveh_data[pVehColor][1], pveh_data[pVehPaintJob], pveh_data[pVehMod][0], pveh_data[pVehMod][1], pveh_data[pVehMod][2], pveh_data[pVehMod][3], pveh_data[pVehMod][4], pveh_data[pVehMod][5], pveh_data[pVehMod][6], pveh_data[pVehMod][7], pveh_data[pVehMod][8], pveh_data[pVehMod][9], pveh_data[pVehMod][10], pveh_data[pVehMod][11], pveh_data[pVehMod][12], pveh_data[pVehMod][13], pveh_data[pVehDarah], pveh_data[pVehID]);
	return mysql_tquery(koneksi, temp_sql);
}

LoadVehicleDealer(){
	new Cache:result = mysql_query(koneksi, "SELECT * FROM vehicle_dealer"), rows, idx = 0, id, temp_model, Float:temp_pos[4], temp_color[2];
	cache_get_row_count(rows);
	if(rows){
		while(idx < rows)
		{
			cache_get_value_name_int(idx, "id_model", temp_model);
			cache_get_value_name_float(idx, "pos_x", temp_pos[0]);
			cache_get_value_name_float(idx, "pos_y", temp_pos[1]);
			cache_get_value_name_float(idx, "pos_z", temp_pos[2]);
			cache_get_value_name_float(idx, "pos_a", temp_pos[3]);
			cache_get_value_name_int(idx, "color_1", temp_color[0]);
			cache_get_value_name_int(idx, "color_2", temp_color[1]);

			id = CreateVehicle(temp_model, temp_pos[0], temp_pos[1], temp_pos[2], temp_pos[3], temp_color[0], temp_color[1], -1);

			cache_get_value_name_int(idx, "id", DVeh[id][dVehID]);
			cache_get_value_name_int(idx, "harga", DVeh[id][dVehHarga]);

			DVeh[id][dVehCoord][0] = temp_pos[0];
			DVeh[id][dVehCoord][1] = temp_pos[1];
			DVeh[id][dVehCoord][2] = temp_pos[2];
			DVeh[id][dVehCoord][3] = temp_pos[3];
			DVeh[id][dVehColor][0] = temp_color[0];
			DVeh[id][dVehColor][1] = temp_color[1];
			DVeh[id][dVehModel] = temp_model;

			#if defined DEBUG_SERVER_LOAD
			printf("Vehicle Dealer ID(%d) ig-ID(%d) load.", DVeh[id][dVehID], id);
			#endif

			new str[150];
			format(str, sizeof(str), "Kendaraan ini dijual!\n"ORANGE"Nama Kendaraan: "WHITE"%s\n"PURPLE"Harga: "GREEN"$%d", GetVehicleModelName(DVeh[id][dVehModel]), DVeh[id][dVehHarga]);
			DVeh[id][dVehText3D] = CreateDynamic3DTextLabel(str, COLOR_GREEN, 0.0, 0.0, 0.0, 50.0, INVALID_PLAYER_ID, id);

			Iter_Add(DVehIterator, id);
			SetVehicleToRespawn(id);
			idx++;
		}
	}
	cache_delete(result);
}

CreateVehicleDealer(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2, harga)
{
	new id = CreateVehicle(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2, -1);	
	DVeh[id][dVehModel] = modelid;
	DVeh[id][dVehColor][0] = color1;
	DVeh[id][dVehColor][1] = color2;
	DVeh[id][dVehCoord][0] = spawn_x;
	DVeh[id][dVehCoord][1] = spawn_y;
	DVeh[id][dVehCoord][2] = spawn_z;
	DVeh[id][dVehCoord][3] = z_angle;
	DVeh[id][dVehHarga] = harga;

	SetVehicleToRespawn(id);

	Iter_Add(DVehIterator, id);

	format(sQuery, sizeSQuery,"INSERT INTO vehicle_dealer (id_model,pos_x,pos_y,pos_z,pos_a,color_1,color_2,harga) VALUES('%d', '%f', '%f', '%f', '%f', '%d', '%d', '%d')", modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2, harga);
	new Cache:result = mysql_query(koneksi, sQuery);
	DVeh[id][dVehID] = cache_insert_id();
	cache_delete(result);
	
	new str[150];
	format(str, sizeof(str), "Kendaraan ini dijual!\n"ORANGE"Nama Kendaraan: "WHITE"%s\n"PURPLE"Harga: "GREEN"$%d", GetVehicleModelName(modelid), harga);
	DVeh[id][dVehText3D] = CreateDynamic3DTextLabel(str, COLOR_GREEN, 0.0, 0.0, 0.0, 50.0, INVALID_PLAYER_ID, id);

	return id;
}

DeleteVehicleDealer(veh_primary){
	mysql_format(koneksi, sQuery, sizeSQuery, "DELETE FROM vehicle_dealer WHERE id = '%d'", veh_primary);
	mysql_tquery(koneksi, sQuery);
}

publicFor: pembayaranKendaraanATM(playerid){
	new saldo;
	cache_get_value_name_int(0, "saldo", saldo);

	if(!IsPlayerInAnyVehicle(playerid)) return showDialogPesan(playerid, RED"Anda harus di dalam mobil", WHITE"Anda harus di dalam mobil yang ingin dibeli, jangan keluar hingga transaksi selesai.");

	new vehid = GetPlayerVehicleID(playerid);
	// Counter cheater jika model mobil dimanipulasi
	if(!Iter_Contains(DVehIterator, vehid) || GetVehicleModel(vehid) != DVeh[vehid][dVehModel]) {
		RemovePlayerFromVehicle(playerid);
		// Banned Cheater
		return 1;
	}

	if(saldo < DVeh[vehid][dVehHarga]){
		RemovePlayerFromVehicle(playerid);
		return showDialogPesan(playerid, RED"Anda tidak memiliki cukup saldo", WHITE"Anda tidak memiliki cukup saldo untuk melakukan transaksi tersebut\nSilahkan menggunakan metode lain atau isi saldo terlebih dahulu.");
	}

	// Beli vehicle dan masukan ke dalam data player
	if(Iter_Contains(DVehIterator, vehid)){
		inline responseQuery(){
			new primary_id = cache_insert_id();
			format(pDialog[playerid], sizePDialog, "Pembelian %s dari dealer", GetVehicleModelName(DVeh[vehid][dVehModel]));
			addTransaksiTabungan(PlayerInfo[playerid][nomorRekening], -DVeh[vehid][dVehHarga], pDialog[playerid]);

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
			format(pDialog[playerid], sizePDialog, "%s"PURPLE"Nama Kendaraan: "WHITE"%s\n", pDialog[playerid], GetVehicleModelName(DVeh[vehid][dVehModel]));
			format(pDialog[playerid], sizePDialog, "%sHarga: "GREEN"$%d\n\n", pDialog[playerid], DVeh[vehid][dVehHarga]);
			format(pDialog[playerid], sizePDialog, "%s"WHITE"Terimakasih sudah menggunakan layanan kami.\n\n"CYAN"*********************************************************************************\n", pDialog[playerid]);
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Berhasil membeli kendaraan", pDialog[playerid], "Ok", "");						

			// Reset nilai & Hapus
			DestroyDynamic3DTextLabel(DVeh[vehid][dVehText3D]);
			DeleteVehicleDealer(DVeh[vehid][dVehID]);

			static const kosong_dveh[DealerVehicleInfo];
			DVeh[vehid] = kosong_dveh;	
		}
		MySQL_TQueryInline(koneksi, using inline responseQuery, "INSERT INTO vehicle(id_pemilik, id_model, pos_x, pos_y, pos_z, pos_a, color_1, color_2) SELECT '%d' AS id_pemilik, id_model, '%f' AS pos_x, '%f' AS pos_y, '%f' AS pos_z, '%f' AS pos_a, color_1, color_2 FROM vehicle_dealer WHERE id = '%d'", PlayerInfo[playerid][pID],  DVeh[vehid][dVehCoord][0], DVeh[vehid][dVehCoord][1], DVeh[vehid][dVehCoord][2], DVeh[vehid][dVehCoord][3], DVeh[vehid][dVehID]);
	}
	else{
		printf("[FATAL ERROR] #008 Invalid vehicle dealer ID.");
		return 1;
	}	
	return 1;
}

publicFor: CekSlotItemPemain(playerid, bedakan_callback){
	new total_item;
	cache_get_value_name_int(0, "total_item", total_item);
	if(bedakan_callback == 1){
		new jumlah = GetPVarInt(playerid, "beri_item_jumlah"), 
			id_item = GetPVarInt(playerid, "beri_item_id_item"),
			target_id = GetPVarInt(playerid, "beri_item_target_id");

		if(total_item + getKapasitasByIdItem(id_item) * jumlah <= PlayerInfo[target_id][limitItem]){
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
	}
	return 1;
}

publicFor: prosesBeliKendaraanCash(playerid, vehid){
	new primary_id = cache_insert_id();
	givePlayerUang(playerid, -DVeh[vehid][dVehHarga]);

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
	format(pDialog[playerid], sizePDialog, "%s"PURPLE"Nama Kendaraan: "WHITE"%s\n", pDialog[playerid], GetVehicleModelName(DVeh[vehid][dVehModel]));
	format(pDialog[playerid], sizePDialog, "%sHarga: "GREEN"$%d\n\n", pDialog[playerid], DVeh[vehid][dVehHarga]);
	format(pDialog[playerid], sizePDialog, "%s"WHITE"Terimakasih sudah menggunakan layanan kami.\n\n"CYAN"*********************************************************************************\n", pDialog[playerid]);
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Berhasil membeli kendaraan", pDialog[playerid], "Ok", "");						

	// Reset nilai & Hapus
	DestroyDynamic3DTextLabel(DVeh[vehid][dVehText3D]);
	DeleteVehicleDealer(DVeh[vehid][dVehID]);

	static const kosong_dveh[DealerVehicleInfo];
	DVeh[vehid] = kosong_dveh;	
	return 1;
}

UpdateVehicleDealer(vehicleid){
	if(Iter_Contains(DVehIterator, vehicleid) && DVeh[vehicleid][dVehID]){
		mysql_format(koneksi, sQuery, sizeSQuery, "UPDATE vehicle_dealer SET id_model = '%d', pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', color_1 = '%d', color_2 = '%d', harga = '%d' WHERE id = '%d'", DVeh[vehicleid][dVehModel], DVeh[vehicleid][dVehCoord][0], DVeh[vehicleid][dVehCoord][1], DVeh[vehicleid][dVehCoord][2], DVeh[vehicleid][dVehCoord][3], DVeh[vehicleid][dVehColor][0], DVeh[vehicleid][dVehColor][1], DVeh[vehicleid][dVehHarga], DVeh[vehicleid][dVehID]);
		return mysql_tquery(koneksi, sQuery);
	}else
		return 0;
}

publicFor: OnPlayerVehicleHealthChange(playerid, vehicleid, Float:newhealth, Float:oldhealth){
	if(newhealth < oldhealth){
		if(testSim[playerid] == 1 && vehicleIdSIM[playerid] == vehicleid){
			poinSim[playerid]--;
			GameTextForPlayer(playerid, "~y~Kesehatan Kendaraan~n~~r~Poin -1", 1000, 3);
		}
	}
	return true;
}

publicFor: SpeedoUpdate(playerid, vehid)
{
    new txtspeed[5],
		vehspeed = GetVehicleSpeed(vehid),
		Float:vehhealth;

	GetVehicleHealth(vehid, vehhealth);

	// BUG :  (Remove this if you solved it)
	// Jika fungsi telah tereksekusi pada player lain yang menaiki kendaraan yang sama
	// Maka player lain yang menaiki kendaraan yang sama, tidak akan terpanggil callback OnPlayerVehicle Change
	if(vehhealth != oldVehicleHealth[vehid]){
		OnPlayerVehicleHealthChange(playerid, vehid, vehhealth, oldVehicleHealth[vehid]);
		oldVehicleHealth[vehid] = vehhealth;
	}

	// Update Health
	SetPlayerProgressBarValue(playerid, SpeedoTD_VehBar[playerid][1], vehhealth - 260);

	// Update Fuel
	SetPlayerProgressBarValue(playerid, SpeedoTD_VehBar[playerid][0], GetVehicleFuel(vehid));

	// Update speedo
	format(txtspeed, 5, "%d", vehspeed);
    PlayerTextDrawSetString(playerid, SpeedoTD_VehInfo[playerid][1], txtspeed);

    if(testSim[playerid] == 1){
		if(vehspeed >= 80){
			poinSim[playerid]--;
			GameTextForPlayer(playerid, "~y~Kecepatan Kendaraan~n~~r~Poin -1", 1000, 3);
		}
	}
    return 1;
}

loadAllTree(){
	new tree_Id, tX[32], tY[32], tZ[32], tRX[32], tRY[32], tRZ[32];
	new Cache:result, row, idx = 0;
	result = mysql_query(koneksi, "SELECT * FROM `lumber`");
	cache_get_row_count(row);
	while(idx < row){
		result = cache_save();
		cache_get_value_name_int(idx, "id", tree_Id);
		cache_get_value_name(idx, "treeX", tX);
		cache_get_value_name(idx, "treeY", tY);
		cache_get_value_name(idx, "treeZ", tZ);
		cache_get_value_name(idx, "treeRX", tRX);
		cache_get_value_name(idx, "treeRY", tRY);
		cache_get_value_name(idx, "treeRZ", tRZ);
		createTree(tree_Id, floatstr(tX), floatstr(tY), floatstr(tZ), floatstr(tRX), floatstr(tRY), floatstr(tRZ));
		cache_set_active(result);
		
		#if DEBUG_SERVER_LOAD == true
			printf("Tree load id(%d)", tree_Id);
		#endif

		idx++;
	}
	cache_delete(result);
}

createTree(tree_Id, Float:tX, Float:tY, Float:tZ, Float:tRX, Float:tRY, Float:tRZ)
{
	if(tree_Id < MAX_TREES ){
		DTree[tree_Id][treeX] = tX;
		DTree[tree_Id][treeY] = tY;
		DTree[tree_Id][treeZ] = tZ;
		DTree[tree_Id][treeRX] = tRX;
		DTree[tree_Id][treeRY] = tRY;
		DTree[tree_Id][treeRZ] = tRZ;
	
		DTree[tree_Id][treeObjID] = CreateDynamicObject(657, DTree[tree_Id][treeX], DTree[tree_Id][treeY], DTree[tree_Id][treeZ], DTree[tree_Id][treeRX], DTree[tree_Id][treeRY], DTree[tree_Id][treeRZ]);
		
		new label[256];
		format(label, sizeof(label), WHITE"["GREEN"Pohon"WHITE"]\nNo : "GREEN"%d\n\n"WHITE"Ketik "GREEN"/lumberjack"WHITE" (pilih menu "GREEN"Potong Pohon"WHITE")\nUntuk memotong pohon", tree_Id);
		DTree[tree_Id][treeLabel] = CreateDynamic3DTextLabel(label, COLOR_WHITE, DTree[tree_Id][treeX], DTree[tree_Id][treeY], DTree[tree_Id][treeZ]+1.5, 5.0);
		DTree[tree_Id][treeCP] = CreateDynamicCP(DTree[tree_Id][treeX], DTree[tree_Id][treeY], DTree[tree_Id][treeZ], 3.0, 0, 0, -1, 5.0);
		DTree[tree_Id][treeTumbang] = false;
		Iter_Add(TreeIterator, tree_Id);
		reloadTreeLabel(tree_Id);
	}else{
		print("Pohon mencapai limit!");
	}
}

reloadTreeLabel(tree_Id){
	new label[256];
	if(!DTree[tree_Id][treeTumbang] && DTree[tree_Id][treeAmbil]){
		format(label, sizeof(label), WHITE"["GREEN"Pohon"WHITE"]\nNo : "GREEN"%d\n"WHITE"Waktu Pulih : "GREEN"%s menit", tree_Id, ConvertToMinutes(DTree[tree_Id][treeSecs]));
	}else if(DTree[tree_Id][treeTumbang] && !DTree[tree_Id][treeAmbil]){
		format(label, sizeof(label), WHITE"["GREEN"Pohon"WHITE"]\nNo : "GREEN"%d\n"WHITE"Waktu Pulih : "GREEN"%s menit\n\n"WHITE"Ketik "GREEN"/lumberjack"WHITE" (pilih menu "GREEN"Pindahkan Pohon"WHITE")\nUntuk memindahkan pohon ke mobil pickup", tree_Id, ConvertToMinutes(DTree[tree_Id][treeSecs]));
	}else{
		format(label, sizeof(label), WHITE"["GREEN"Pohon"WHITE"]\nNo : "GREEN"%d\n\n"WHITE"Ketik "GREEN"/lumberjack"WHITE" (pilih menu "GREEN"Potong Pohon"WHITE")\nUntuk memotong pohon", tree_Id);
	}
	UpdateDynamic3DTextLabelText(DTree[tree_Id][treeLabel], COLOR_WHITE, label);
}

GetClosestTree(playerid, Float: range = 2.0){
    new id = -1, Float: dist = range, Float: tempdist;
    foreach(new i : TreeIterator){
        tempdist = GetPlayerDistanceFromPoint(playerid, DTree[i][treeX], DTree[i][treeY], DTree[i][treeZ]);
        if(tempdist > range) continue;
        if(tempdist <= dist){
            dist = tempdist;
            id = i;
        }
    }
    return id;
}

GetClosestATM(playerid, Float: range = 3.0)
{
	new id = -1, Float: dist = range, Float: tempdist;
	foreach(new i : ATMs)
	{
		tempdist = GetPlayerDistanceFromPoint(playerid, ATMData[i][atmX], ATMData[i][atmY], ATMData[i][atmZ]);

		if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}
	return id;
}

GetClosestHouse(playerid, Float: min = 0.0, Float: max = 2.0, job = 0){
    new id = -1, Float: dist = min, Float: tempdist;
    for(new i = 0; i < MAX_HOUSES; i++){
		if(housePickup[i] != -1){
			tempdist = GetPlayerDistanceFromPoint(playerid, houseInfo[i][icon_x], houseInfo[i][icon_y], houseInfo[i][icon_z]);
			if(tempdist > max) continue;
			if(tempdist >= dist && tempdist <= max){
				if(job == 1){
					if(trashM_Job[playerid] == 1){
						if(trashM_HouseTake[playerid][i] != 1){
							dist = tempdist;
							id = i;
						}
					}
					if(pizza_Job[playerid] == 1){
						if(pizza_HouseTake[playerid][i] != 1){
							dist = tempdist;
							id = i;
						}
					}
				}else{
					dist = tempdist;
					id = i;
				}
			}
		}
    }
    return id;
}

Player_ResetCutting(playerid){
    if(!IsPlayerConnected(playerid) || CuttingTreeID[playerid] == -1) return 0;
    new id = CuttingTreeID[playerid];
    if(DTree[id][treeSecs] < 1) Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, DTree[id][treeLabel], E_STREAMER_COLOR, COLOR_WHITE);
    ClearAnimations(playerid);
	PlayerInfo[playerid][isOnAnimation] = false;
	PlayerInfo[playerid][isBusy] = false;

    TogglePlayerControllable(playerid, 1);
	if(IsPlayerAttachedObjectSlotUsed(playerid, CUTTING_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, CUTTING_ATTACH_INDEX);
    CuttingTreeID[playerid] = -1;
	PlayerInfo[playerid][sisaGergaji]--;
    if(CuttingTimer[playerid] != -1){
        DeletePreciseTimer(CuttingTimer[playerid]);
        CuttingTimer[playerid] = -1;
    }
    SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
    HidePlayerProgressBar(playerid, CuttingBar[playerid]);
    return 1;
}

publicFor: CutTree(playerid){
    if(CuttingTreeID[playerid] != -1){
        new id = CuttingTreeID[playerid], Float: value = GetPlayerProgressBarValue(playerid, CuttingBar[playerid]) + (MAX_PROGRESS_BAR / CUTTING_TIME);
        if(value >= MAX_PROGRESS_BAR){
            Player_ResetCutting(playerid);
            MoveDynamicObject(DTree[id][treeObjID], DTree[id][treeX], DTree[id][treeY], DTree[id][treeZ] + 0.03, 0.025, DTree[id][treeRX], DTree[id][treeRY] - 80.0, DTree[id][treeRZ]);

            DTree[id][treeSecs] = TREE_RESPAWN;
			DTree[id][treeAmbil] = false;
			DTree[id][treeTimer] = SetPreciseTimer("RespawnTree", 1000, true, "i", id);
            reloadTreeLabel(id);
        }else{
            SetPlayerProgressBarValue(playerid, CuttingBar[playerid], value);
        }
    }
    return 1;
}

publicFor: RespawnTree(tree_Id){
    if(DTree[tree_Id][treeSecs] > 1) {
        DTree[tree_Id][treeSecs]--;
        reloadTreeLabel(tree_Id);
    }else if(DTree[tree_Id][treeSecs] == 1) {
        DeletePreciseTimer(DTree[tree_Id][treeTimer]);
        DTree[tree_Id][treeSecs] = 0;
        DTree[tree_Id][treeTimer] = -1;
       	DTree[tree_Id][treeTumbang] = false;
		DTree[tree_Id][treeAmbil] = false;
        SetDynamicObjectPos(DTree[tree_Id][treeObjID], DTree[tree_Id][treeX], DTree[tree_Id][treeY], DTree[tree_Id][treeZ]);
        SetDynamicObjectRot(DTree[tree_Id][treeObjID], DTree[tree_Id][treeRX], DTree[tree_Id][treeRY], DTree[tree_Id][treeRZ]);
        reloadTreeLabel(tree_Id);
    }
    return 1;
}

Tree_BeingEdited(tree_Id){
    if(!Iter_Contains(TreeIterator, tree_Id)) return 0;
    foreach(new i : Player) if(treeEditID[i] == tree_Id) return 1;
    return 0;
}

LoadSemuaATM()
{
	new Cache:result = mysql_query(koneksi, "SELECT * FROM tempat_atm");
	new rows = cache_num_rows();
	if(rows)
	{
		new id, label_string[128];

		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", id);
			cache_get_value_name_float(i, "pos_x", ATMData[id][atmX]);
			cache_get_value_name_float(i, "pos_y", ATMData[id][atmY]);
			cache_get_value_name_float(i, "pos_z", ATMData[id][atmZ]);
			cache_get_value_name_float(i, "rot_x", ATMData[id][atmRX]);
			cache_get_value_name_float(i, "rot_y", ATMData[id][atmRY]);
			cache_get_value_name_float(i, "rot_z", ATMData[id][atmRZ]);

			ATMData[id][atmObjID] = CreateDynamicObject(19324, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ], ATMData[id][atmRX], ATMData[id][atmRY], ATMData[id][atmRZ]);
			
			format(label_string, sizeof(label_string), "%d, %s, %s\n"WHITE"ATM tersedia\n\n"WHITE"Tekan "GREEN"Y"WHITE" untuk mengakses", id, GetZoneName(ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ]), GetCityName(ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ]));
			ATMData[id][atmLabel] = CreateDynamic3DTextLabel(label_string, COLOR_GREEN, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ] + 0.85, 5.0);

			Iter_Add(ATMs, id);
		}
	}
	cache_delete(result);
    printf("[ATM] %d Mesin ATM berhasil di load.", Iter_Count(ATMs) - 1);
	return 1;
}

TurunkanPohon(playerid){
	inline responseQuery(){
		new total_item, vehid = GetPlayerVehicleID(playerid), treeVeh = vehDTree[vehid][treeAngkut];
		if(!IsPlayerInVehicle(playerid, vehid)) return error_command(playerid, "Anda tidak berada di dalam kendaraan.");
		if(!IsMobilPickup(vehid)) return error_command(playerid, "Anda tidak berada di dalam kendaraan pick up.");

		// Filter apakah dia berada disekitar tempat pemotongan mana saja
		for(new i = 0; i < sizeof(POSISI_PEMOTONGAN_KAYU); i++) {
			// Jika dia benar-benar disekitar tempat pemotongan kayu maka langsung berhentikan looping
			if(IsPlayerInRangeOfPoint(playerid, 3.0, POSISI_PEMOTONGAN_KAYU[i][POSISI_X], POSISI_PEMOTONGAN_KAYU[i][POSISI_Y], POSISI_PEMOTONGAN_KAYU[i][POSISI_Z])) break;
			
			// Jika mencapai akhir looping dan ternyata tidak berada ditempat pemotongan manapun, maka return dan keluar dari fungsi
			if(i == sizeof(POSISI_PEMOTONGAN_KAYU) - 1) return error_command(playerid, "Anda tidak berada di tempat pemotongan kayu.");
		}

		if(treeVeh <= 0) return error_command(playerid, "Anda tidak memiliki muatan pohon.");
		cache_get_value_name_int(0, "total_item", total_item);
		static const id_item_kayu = 25;
		if((total_item + (4*treeVeh*getKapasitasByIdItem(id_item_kayu))) > PlayerInfo[playerid][limitItem]){
			dialogInventoryItemTidakMuat(playerid, 4 * treeVeh, total_item, .kapasitas_unpredict = getKapasitasByIdItem(id_item_kayu));
		}else{
			new randomLog = 0, randomNo;
			for(new i = 0; i < treeVeh; i++){
				randomNo = random(4)+1;
				randomLog += randomNo;
			}
			format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil melakukan pemotongan "GREEN"%d"WHITE" buah pohon, dan mendapatkan total kayu "GREEN"%d"WHITE" buah.", treeVeh, randomLog);
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Pemotongan Pohon", pDialog[playerid], "Ok", "");
			tambahItemPlayer(playerid, id_item_kayu, randomLog);
			vehDTree[vehid][treeAngkut] = 0;
		}
	}
	MySQL_TQueryInline(koneksi, using inline responseQuery, QueryCekSlotItem(playerid));
	return 1;
}

createPlant(plant_Id, const nama_bibit[], item_Id, Float:pX, Float:pY, Float:pZ, Float:pRX, Float:pRY, Float:pRZ)
{
	if(plant_Id < MAX_PLANTS ){
		format(DFarm[plant_Id][plantName], 32, "%s", nama_bibit);
		DFarm[plant_Id][plantItemID] = item_Id;
		DFarm[plant_Id][plantX] = pX;
		DFarm[plant_Id][plantY] = pY;
		DFarm[plant_Id][plantZ] = pZ;
		DFarm[plant_Id][plantRX] = pRX;
		DFarm[plant_Id][plantRY] = pRY;
		DFarm[plant_Id][plantRZ] = pRZ;

		DFarm[plant_Id][plantObjID] = CreateDynamicObject(3409, DFarm[plant_Id][plantX], DFarm[plant_Id][plantY], DFarm[plant_Id][plantZ]-1.25, DFarm[plant_Id][plantRX], DFarm[plant_Id][plantRY], DFarm[plant_Id][plantRZ]);
		DFarm[plant_Id][plantTimer] = SetPreciseTimer("HarvestTime", 1000, true, "i", plant_Id);
		DFarm[plant_Id][plantSecs] = PLANT_HARVEST;
		DFarm[plant_Id][plantHarvest] = false;
		new label[256];
		format(label, sizeof(label), WHITE"["GREEN"Tanaman %s"WHITE"]\nNo : "GREEN"%d\n"WHITE"Waktu Panen : "GREEN"%s menit", DFarm[plant_Id][plantName], plant_Id, ConvertToMinutes(DFarm[plant_Id][plantSecs]));
		DFarm[plant_Id][plantLabel] = CreateDynamic3DTextLabel(label, COLOR_WHITE, DFarm[plant_Id][plantX], DFarm[plant_Id][plantY], DFarm[plant_Id][plantZ]+1.5, 3.0);
		Iter_Add(PlantIterator, plant_Id);
		reloadPlantLabel(plant_Id);
	}else{
		print("Tanaman mencapai limit!");
	}
}

reloadPlantLabel(plant_Id){
	new label[256];
	if(!DFarm[plant_Id][plantHarvest]){
		format(label, sizeof(label), WHITE"["GREEN"Tanaman %s"WHITE"]\nNo : "GREEN"%d\n"WHITE"Waktu Panen : "GREEN"%s menit", DFarm[plant_Id][plantName], plant_Id, ConvertToMinutes(DFarm[plant_Id][plantSecs]));
	}else{
		format(label, sizeof(label), WHITE"["GREEN"Tanaman %s"WHITE"]\nNo : "GREEN"%d\n\n"WHITE"Ketik "GREEN"/farm"WHITE" (pilih menu "GREEN"Panen Tanaman"WHITE")\nUntuk memanen tanaman", DFarm[plant_Id][plantName], plant_Id);
	}
	UpdateDynamic3DTextLabelText(DFarm[plant_Id][plantLabel], COLOR_WHITE, label);
}

publicFor: HarvestTime(plant_Id){
    if(DFarm[plant_Id][plantSecs] > 1) {
        DFarm[plant_Id][plantSecs]--;
        reloadPlantLabel(plant_Id);
    }else if(DFarm[plant_Id][plantSecs] == 1){
        DeletePreciseTimer(DFarm[plant_Id][plantTimer]);
        DFarm[plant_Id][plantSecs] = 0;
        DFarm[plant_Id][plantTimer] = -1;
		DFarm[plant_Id][plantHarvest] = true;
		DFarm[plant_Id][destroyTimer] = SetPreciseTimer("DestroyTime", 1800000, false, "i", plant_Id);
        SetDynamicObjectPos(DFarm[plant_Id][plantObjID], DFarm[plant_Id][plantX], DFarm[plant_Id][plantY], DFarm[plant_Id][plantZ]-0.75);
        SetDynamicObjectRot(DFarm[plant_Id][plantObjID], DFarm[plant_Id][plantRX], DFarm[plant_Id][plantRY], DFarm[plant_Id][plantRZ]);
        reloadPlantLabel(plant_Id);
    }
    return 1;
}

publicFor: DestroyTime(plant_Id){
	DeletePreciseTimer(DFarm[plant_Id][destroyTimer]);
	if(IsValidDynamicObject(DFarm[plant_Id][plantObjID])) DestroyDynamicObject(DFarm[plant_Id][plantObjID]);
	if(IsValidDynamic3DTextLabel(DFarm[plant_Id][plantLabel])) DestroyDynamic3DTextLabel(DFarm[plant_Id][plantLabel]);
	DFarm[plant_Id][plantSecs] = 0;
	DFarm[plant_Id][plantObjID] = DFarm[plant_Id][destroyTimer] = -1;
	DFarm[plant_Id][plantLabel] = Text3D: -1;
	Iter_Remove(PlantIterator, plant_Id);
	return 1;
}

playerMaxPlant(playerid){
	new count = 0;
    foreach(new i : PlantIterator){
		if(DFarm[i][playerId] == playerid){
			count++;
			if(count == 5){
				return 1;
			}
		}
	}
	return 0;
}

GetClosestPlant(playerid, Float: range = 5.0){
    new id = -1, Float: dist = range, Float: tempdist;
    foreach(new i : PlantIterator){
        tempdist = GetPlayerDistanceFromPoint(playerid, DFarm[i][plantX], DFarm[i][plantY], DFarm[i][plantZ]);
        if(tempdist > range) continue;
        if(tempdist <= dist){
            dist = tempdist;
            id = i;
        }
    }
    return id;
}

publicFor: buatTokoNarko(){
	MrPuyengRand = random(sizeof(POINT_NARKO));
	DeletePreciseTimer(MrPuyengStart);
	labelTokoNarko = CreateDynamic3DTextLabel("Mr. Puyeng\n"YELLOW"Ketik /bicara untuk berbicara.", COLOR_WHITE, POINT_NARKO[MrPuyengRand][NARKO_X], POINT_NARKO[MrPuyengRand][NARKO_Y], POINT_NARKO[MrPuyengRand][NARKO_Z] + 1.0, 10.0, .testlos = 1);
	ACT_tokoNarko = CreateDynamicActor(272, POINT_NARKO_ACTOR[MrPuyengRand][NARKO_X], POINT_NARKO_ACTOR[MrPuyengRand][NARKO_Y], POINT_NARKO_ACTOR[MrPuyengRand][NARKO_Z], POINT_NARKO_ACTOR[MrPuyengRand][NARKO_A], .worldid = 0, .interiorid = 0);
	MrPuyengEnd = SetPreciseTimer("re_TokoNarko", 300000, false); // Buat random toko
	return 1;
}

publicFor: re_TokoNarko(){
	DeletePreciseTimer(MrPuyengEnd);
	if(IsValidDynamic3DTextLabel(labelTokoNarko)) DestroyDynamic3DTextLabel(labelTokoNarko);
	if(IsValidDynamicActor(ACT_tokoNarko)) DestroyDynamicActor(ACT_tokoNarko);
	MrPuyengRand = -1;
	MrPuyengEnd = -1;
	labelTokoNarko = Text3D: -1;
	MrPuyengStart = SetPreciseTimer("buatTokoNarko", 60000, false); // Cooldown toko
	return 1;
}

publicFor: waktuPuyeng(playerid){
	if(puyengSecs[playerid] >= 0){
		puyengSecs[playerid]--;
		if(puyengSecs[playerid] == 0){
			puyengSecs[playerid] = -1;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			SetPlayerDrunkLevel (playerid, 0);
			DeletePreciseTimer(puyengTimer[playerid]);
		}
	}
	return 1;
}

randomIkan(playerid){
	new angka;
	if(mancingAktif[playerid] == 1){
		mancingAktif[playerid] = 0;
		if(IsPlayerAttachedObjectSlotUsed(playerid, PANCINGAN_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, PANCINGAN_ATTACH_INDEX);
		angka = random(70);
	}else if(PlayerInfo[playerid][sisaTombak] > 0){ // Pakai tombak keberuntungan +14%
		PlayerInfo[playerid][sisaTombak]--;
		if(PlayerInfo[playerid][sisaTombak] == 0){
			if(IsPlayerAttachedObjectSlotUsed(playerid, TOMBAK_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, TOMBAK_ATTACH_INDEX);
		}
		angka = random(60);
	}else{
		angka = 0;
	}
	re_switch:
	switch(angka){
		case 34:{ // 1.4%
			if(nombakDepth[playerid] > 10.0){ // Ikan Arwana kedalaman > 10
				showDialogPesan(playerid, "Hasil Mancing", GREEN"Selamat Anda mendapatkan "SILVER"Ikan Arwana"WHITE".\nIkan Arwana adalah hasil mancing nomor satu dan pastinya "PURPLE"sangat langka"WHITE". Luar biasa!\nAnda dapat menjualnya dengan harga sangat tinggi.");
				tambahItemPlayer(playerid, 35, 1);
			}else{
				angka = angka+1;
				goto re_switch;
			}
		}
		case 15,26,45:
		{ // 4.3%
			if(nombakDepth[playerid] > 5.0 || nombakDepth[playerid] < 10.0){ // Ikan Kakap kedalaman > 5-10
				showDialogPesan(playerid, "Hasil Mancing", GREEN"Selamat Anda mendapatkan "YELLOW"Ikan Kakap"WHITE".\nIkan Kakap adalah hasil mancing yang sangat bagus, dan "PURPLE"langka"WHITE". Sangat beruntung!");
				tambahItemPlayer(playerid, 36, 1);
			}else{
				angka = angka+1;
				goto re_switch;
			}
		}
		case 27..30,57,58:
		{ // 10%
			showDialogPesan(playerid, "Hasil Mancing", GREEN"Selamat Anda mendapatkan "LIGHT_BLUE"Ikan Mas"WHITE".\nIkan Mas adalah hasil mancing yang mirip dengan "BLUE"Ikan Mujair"WHITE" tapi lebih bagus. Keren sekali!");
			tambahItemPlayer(playerid, 37, 1);
		}
		case 11..14,41..44,56,59:
		{ // 14.3%
			showDialogPesan(playerid, "Hasil Mancing", GREEN"Selamat Anda mendapatkan "ORANGE"Ikan Mujair"WHITE".\nIkan Mujair adalah hasil mancing yang berguna dan juga "BLUE"diminati orang banyak"WHITE". Keren sekali!");
			tambahItemPlayer(playerid, 38, 1);
		}
		case 6..10,21..25,36..40:
		{ // 21.4%
			showDialogPesan(playerid, "Hasil Mancing", GREEN"Selamat Anda mendapatkan "ORANGE"Ubur-ubur"WHITE".\nUbur-ubur adalah hasil mancing bagus dan "GREEN"berguna untuk banyak hal"WHITE". Kerja bagus!");
			tambahItemPlayer(playerid, 39, 1);
		}
		case 1..5,16..20,46..50,61..65,66..70:
		{ // 35.7%
			showDialogPesan(playerid, "Hasil Mancing", GREEN"Selamat Anda mendapatkan "ORANGE"Bintang Laut"WHITE".\nBintang Laut adalah hasil mancing bagus dan "GREEN"berguna untuk banyak hal"WHITE". Kerja bagus!");
			tambahItemPlayer(playerid, 40, 1);
		}
		default:
		{ // 12.8%
			SendClientMessage(playerid, COLOR_GREY, "[SERVER] Anda tidak mendapatkan apapun silahkan coba lagi.");
		}
	}
	nombakDepth[playerid] = 0.0;
	return 1;
}

publicFor: waktuMancing(playerid){
	if(mancingSecs[playerid] >= 0){
		mancingSecs[playerid]--;
		new string[128];
		format(string, 128, "~r~WAKTU TERSISA ~b~: %d", mancingSecs[playerid]);
		GameTextForPlayer(playerid, string , 1000, 3);
		if(mancingSecs[playerid] == 0){
			mancingSecs[playerid] = -1;
			DeletePreciseTimer(mancingTimer[playerid]);
			TogglePlayerControllable(playerid , 1);
			GameTextForPlayer(playerid, "~g~MEMANCING SELESAI!", 1000, 3);
			ClearAnimations(playerid);
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
			randomIkan(playerid);
		}
	}
	return 1;
}

publicFor: delayNombak(playerid){
	if(nombakSecs[playerid] >= 0){
		nombakSecs[playerid]--;
		if(nombakSecs[playerid] == 0){
			nombakSecs[playerid] = -1;
			nombakDelay[playerid] = 0;
			DeletePreciseTimer(nombakTimer[playerid]);
		}
	}
	return 1;
}

/*
 *	Dieksekusi setiap detik
 *  
 *  Pada saat player mati/belum login maka timer akan berhenti 
 */
publicFor: pemainUpdate(playerid){
	if(!IsPlayerConnected(playerid)){
		if(PlayerInfo[playerid][timerPemain] != -1){
			DeletePreciseTimer(PlayerInfo[playerid][timerPemain]);
			PlayerInfo[playerid][timerPemain] = -1;
		}
		return 1;
	}

	// Setiap 90 detik sekali kurangi status makan sebanyak constanta STATUS_MAKAN_BERKURANG_PER_WAKTU
	if(++PlayerInfo[playerid][hungryStackedTime] >= 90){
		PlayerInfo[playerid][hungryStackedTime] = 0;
		setStatusMakanPemain(playerid, getStatusMakanPemain(playerid) - STATUS_MAKAN_BERKURANG_PER_WAKTU);
	}

	if(++PlayerInfo[playerid][thirstyStackedTime] >= 60){
		PlayerInfo[playerid][thirstyStackedTime] = 0;
		setStatusMinumPemain(playerid, getStatusMinumPemain(playerid) - STATUS_MINUM_BERKURANG_PER_WAKTU);
	}
	return 1;
}