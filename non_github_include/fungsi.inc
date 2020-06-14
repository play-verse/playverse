publicFor: isRegistered(playerid)
{
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

		// Get Player Position
		cache_get_value_name(0, "last_x", temp_value);
		PlayerInfo[playerid][last_x] = floatstr(temp_value);
		cache_get_value_name(0, "last_y", temp_value);
		PlayerInfo[playerid][last_y] = floatstr(temp_value);
		cache_get_value_name(0, "last_z", temp_value);
		PlayerInfo[playerid][last_z] = floatstr(temp_value);
		cache_get_value_name(0, "last_a", temp_value);
		PlayerInfo[playerid][last_a] = floatstr(temp_value);
		
		cache_get_value_name(0, "last_int", temp_value);
		PlayerInfo[playerid][last_int] = strval(temp_value);
		cache_get_value_name(0, "last_vw", temp_value);
		PlayerInfo[playerid][last_vw] = strval(temp_value);

		cache_get_value_name_float(0, "last_hp", PlayerInfo[playerid][lastHp]);
		cache_get_value_name_float(0, "last_armour", PlayerInfo[playerid][lastArmour]);

		cache_get_value_name_float(0, "last_stats_makan", PlayerInfo[playerid][last_stats_makan]);
		cache_get_value_name_float(0, "last_stats_minum", PlayerInfo[playerid][last_stats_minum]);

		// Pindahkan player
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], 2093.7747, -1806.4586, 13.5499, 87.6500, 0, 0, 0, 0, 0, 0);
		SetPlayerVirtualWorld(playerid, playerid + 100);
		// SpawnPlayer(playerid);

        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,WHITE"Login",WHITE"Masukan Password untuk login ke akun!","Login","Keluar");
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

		// Spawn player
		SetSpawnInfo(playerid, 0, 0, 2093.7747,-1806.4586,13.5499,87.6500, 0, 0, 0, 0, 0, 0);
		SetPlayerVirtualWorld(playerid, playerid + 100);
		// SpawnPlayer(playerid);

        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""WHITE"SILAHKAN DAFTAR",""WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
	}
	return 1;

}

// Hanya digunakan saat Disconnect dan Connect
resetPlayerVariable(playerid){
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

    PlayerInfo[playerid][ePhone] = 0;
    PlayerInfo[playerid][nomorHP][0] = EOS;
    PlayerInfo[playerid][nomorRekening][0] = EOS;

	PlayerInfo[playerid][preloadAnim] = 0;

	PlayerInfo[playerid][lastGlobalChat] = 0;
	PlayerInfo[playerid][reply] = -1;
	PlayerInfo[playerid][sudahLogin] = false;
	PlayerInfo[playerid][sudahSpawn] = false;

	PlayerInfo[playerid][onSelectedTextdraw] = false;

	PlayerInfo[playerid][tampilHUDStats] = false;

	if(PlayerInfo[playerid][activeMarker]) DisablePlayerCheckpoint(playerid);
	PlayerInfo[playerid][activeMarker] = false;

	PlayerInfo[playerid][sisaPalu] = 0;

	PlayerInfo[playerid][lamaBermain] = 0;
	PlayerInfo[playerid][waktuSaatLogin] = 0;

	PlayerInfo[playerid][last_x] = 0;
	PlayerInfo[playerid][last_y] = 0;
	PlayerInfo[playerid][last_z] = 0;
	PlayerInfo[playerid][last_a] = 0;
	
	PlayerInfo[playerid][last_int] = 0;
	PlayerInfo[playerid][last_vw] = 0;

	PlayerInfo[playerid][lastHp] = 0;
	PlayerInfo[playerid][lastArmour] = 0;

	KillTimer(PlayerAction[playerid][timerNambang]);
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

publicFor: registerUser(playerid)
{
	new EncryptedPassword[65];
	SHA256_PassHash(registerInfo[playerid][registerPassword], PlayerInfo[playerid][pPlayerName], EncryptedPassword, 64);

	inline responseQuery(){
		PlayerInfo[playerid][pID] = cache_insert_id();
		PlayerInfo[playerid][loginKe] = 1;
		PlayerInfo[playerid][jenisKelamin] = registerInfo[playerid][jenisKelamin];
		PlayerInfo[playerid][skinID] = registerInfo[playerid][freeSkinID];
	
		PlayerInfo[playerid][sudahLogin] = true;
		PlayerInfo[playerid][waktuSaatLogin] = gettime();
		PlayerInfo[playerid][lamaBermain] = 0;

		mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO user_item_limit(id_user, jumlah, expired) VALUES('%d', '%d', NULL)", PlayerInfo[playerid][pID], DEFAULT_LIMIT_ITEM);
		mysql_tquery(koneksi, pQuery[playerid]);
		PlayerInfo[playerid][limitItem] = DEFAULT_LIMIT_ITEM;

		setUangPlayer(playerid, 100);
		// tampilkanTextDrawUang(playerid);

		tambahSkinPlayer(playerid, registerInfo[playerid][freeSkinID], 1, true);

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
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `user_skin` WHERE id_skin = '%d' AND id_user = '%d'", skinid, PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid], "checkIfSkinExist", "dd", playerid, skinid);
	return 1;
}

publicFor: checkIfSkinExist(playerid, skinid){
	if(cache_num_rows()){
		mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET current_skin = '%d' WHERE id = '%d'",skinid, PlayerInfo[playerid][pID]);
		mysql_tquery(koneksi, pQuery[playerid]);

		// Kembalikan skin yang sama
		tambahSkinPlayer(playerid, PlayerInfo[playerid][skinID], 1, false);

		// Kurangkan setelah teruse
		tambahSkinPlayer(playerid, skinid, -1, false);
		PlayerInfo[playerid][skinID] = skinid;

	}
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
	new rows, subString[64], jumlah, nama_item[100];
	cache_get_row_count(rows);
	new string[1500] = "Nama\tJumlah\n"WHITE;
	if(rows){
		for(new i = 0; i < rows; i++){
			cache_get_value_name_int(i, "jumlah", jumlah);
			cache_get_value_name(i, "nama_item", nama_item);

			format(subString, sizeof(subString), "%s\t%i\n", nama_item,jumlah);
			strcat(string, subString);
		}
		strcat(string, ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

		if(cache_is_valid(PlayerInfo[playerid][tempCache])) cache_delete(PlayerInfo[playerid][tempCache]);
		PlayerInfo[playerid][tempCache] = cache_save();

		format(subString, 64, WHITE"Pilih barang anda : "GREEN"(page : %d)", GetPVarInt(playerid, "halaman") + 1);
		ShowPlayerDialog(playerid, DIALOG_PILIH_ITEM, DIALOG_STYLE_TABLIST_HEADERS, subString, string, "Pilih", "Kembali");
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
}

publicFor: pakaiPaluTambang(playerid){
	tambahItemPlayer(playerid, 8, -1);
	PlayerInfo[playerid][sisaPalu] += 15;

	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menggunakan item", "Penggunaan 1 item "YELLOW"Palu Tambang = "GREEN"Penambahan kesempatan menambang sebanyak 15 kali.\n"RED"Note : Saat anda disconnect dari server maka kesempatan menambang anda direset jadi 0.", "Ok", "");
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

	format(pDialog[playerid], sizePDialog, WHITE"Anda telah membayar biaya kerusakan untuk "GREEN"%s"YELLOW"\nSilahkan ambil kendaraan anda pada pusat reparasi yang berada didekat pantai. Terimakasih.", GetVehicleNameFromModel(PVeh[idpv][pVehModel]));
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membayar biaya perbaikan", pDialog[playerid], "Ok", "");
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
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Inventory item anda "RED"kosong", WHITE"Maaf saat ini inventory item anda tidak berisi apapun!", "Ok", "");
			else{ // Kembalikan ke halaman sebelumnya
				SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
				tampilInventoryItemPlayer(playerid, dialog_id, judul); // Recursive
			}
		}
		return 1;
	}

	MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT b.id_item, b.nama_item, b.keterangan, b.fungsi, b.model_id, a.kunci, a.id_user_item, a.jumlah FROM `user_item` a INNER JOIN `item` b ON a.id_item = b.id_item WHERE a.`id_user` = '%d' AND a.jumlah > 0 ORDER BY nama_item ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);

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
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Inventory item rumah anda "RED"kosong", WHITE"Maaf saat ini inventory item anda tidak berisi apapun!\n"YELLOW"Anda dapat menyimpan dari inventory didalam tas anda!", "Ok", "");
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
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Furniture rumah "RED"kosong", WHITE"Maaf saat ini furniture didalam rumah anda tidak ada!\n"YELLOW"Anda dapat memasangnya dari furniture yang ada di inventory anda!", "Ok", "");
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
		mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT tanggal_ambil, (CASE WHEN tanggal_ambil <= NOW() THEN 1 ELSE 0 END) AS hasil FROM `pengambilan_sim` WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
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

publicFor: cekPembuatanSIM(playerid, ada){
	if(ada){
		givePlayerUang(playerid, -100);
		SetPVarInt(playerid, "sim_soal", 0);
		SetPlayerVirtualWorld(playerid, playerid+2);
		ShowPlayerDialog(playerid, DIALOG_SIM_SOAL, DIALOG_STYLE_MSGBOX, "Praktik SIM", WHITE"Anda sekarang akan melakukan Ujian Teori SIM. Silahkan baca panduan agar anda dapat mengisinya.\nPanduan:\n"YELLOW"- Ketika anda mengendarai kendaraan, anda harus fokus dan menaati peraturan.\n- Gunakan jalur kanan ketika sedang berkendara.\n- Berhenti jika lampu lalu lintas merah, berhati-hati jika kuning.\n- Kurangi kecepatan jika ada player / kendaraan yang sedang lewat / menyalip.\n- Jika ingin menyalip kendaraan ambil jalur kiri dan jika ingin mengurangi kecepatan ambil jalur kanan.\n- Kecepatan normal dibawah "GREEN"80 KmpH"YELLOW", jika lebih maka anda harus mengurangi kecepatan.\n"WHITE"Note: Minimal poin yang didapat "GREEN"10", "Mengerti", "Batal");
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Tidak memiliki KTP", WHITE"Anda harus memiliki KTP terlebih dahulu untuk dapat mendaftarkan Ujian Praktik SIM.", "Ok", "");
	}
	return 1;
}

publicFor: cekSudahBisaAmbilSIM(playerid){
	new sudah_selesai, tanggal_pengambilan[50];
	if(cache_num_rows()){
		cache_get_value_name_int(0, "hasil", sudah_selesai);
		if(sudah_selesai){
			hapusSetelahPengambilanSIM(playerid);
			
			tambahItemPlayer(playerid, 15, 1);

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

publicFor: cekSudahPunyaSIM(playerid){
	new tanggal_pengambilan[50];
	if(cache_num_rows()){
		cache_get_value_name(0, "tanggal_ambil", tanggal_pengambilan);
		format(pDialog[playerid], sizePDialog, WHITE"SIM anda sedang dalam proses pembuatan, silahkan ke Kantor Polisi Los Santos pada tanggal :\n"YELLOW"%s\n"WHITE"Pengambilan SIM dapat anda lakukan dengan memilih menu "GREEN"Ambil SIM "WHITE"\nAnda akan mendapatkan SIM pada saat itu juga.", tanggal_pengambilan);

		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"SIM sedang diproses", pDialog[playerid], "Ok", "");
	}else{
		// ID SIM = 15
		cekKetersediaanItem(playerid, 15, 1, "isBisaBuatSIM");
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

		GetPlayerHealth(playerid, last_hp);
		GetPlayerArmour(playerid, last_armour);

		temp_stats_makan = getStatusMakanPemain(playerid);
		temp_stats_minum = getStatusMinumPemain(playerid);
	}else{
		// Reset nilai jadi 0 semua
		last_hp = last_armour = last_spawn_info_x = last_spawn_info_y = last_spawn_info_z = last_spawn_info_a = temp_stats_makan = temp_stats_minum = 0;
		last_spawn_info_int = last_spawn_info_vw = 0;
	}

	new lama_bermain = getTotalLamaBermain(playerid);

	mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET last_x = '%f', last_y = '%f', last_z = '%f',last_a = '%f', last_int = '%d', last_vw = '%d', last_hp = '%f', last_armour = '%f', last_stats_makan = '%f', last_stats_minum = '%f', playtime = '%d' WHERE id = '%d'", last_spawn_info_x, last_spawn_info_y, last_spawn_info_z, last_spawn_info_a, last_spawn_info_int, last_spawn_info_vw, last_hp, last_armour, temp_stats_makan, temp_stats_minum, lama_bermain, PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid]);
	return 1;
}

loadAllItem(){
	new id_item, model_id, nama_item[256], keterangan_item[500], fungsi[101], bool:is_null;
	new Cache:result, row, idx = 0;
	result = mysql_query(koneksi, "SELECT * FROM `item`");
	cache_get_row_count(row);
	while(idx < row){
		// iIt = Id Item > Menyimpan model id item
		// mIt = Model Item > Menyimpan id item
		// nIt = Nama Item > Menyimpan nama item diget dari id item
		// kIt = Keterangan Item > Menyimpan keterangan Item diget dari id item
		cache_get_value_name_int(idx, "id_item", id_item);
		cache_get_value_name_int(idx, "model_id", model_id);
		cache_get_value_name(idx, "nama_item", nama_item);
		cache_get_value_name(idx, "keterangan", keterangan_item);

		// Simpan value is null
		cache_is_value_name_null(idx, "fungsi", is_null);
		if(!is_null) cache_get_value_name(idx, "fungsi", fungsi);

		format(msg, sizeof(msg), "iIt_%d", id_item);
		SetSVarInt(msg, model_id);

		format(msg, sizeof(msg), "mIt_%d", model_id);
		SetSVarInt(msg, id_item);

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
	if((total_item + input_jumlah) > PlayerInfo[playerid][limitItem]){						
		format(pDialog[playerid], sizePDialog, "Maaf inventory item anda tidak memiliki cukup ruang,\nuntuk menyimpan sebanyak "ORANGE"%i "WHITE"item. Sisa ruang yang anda miliki adalah "ORANGE"(%i/%i).", input_jumlah, total_item, PlayerInfo[playerid][limitItem]);

		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory anda penuh", pDialog[playerid], "Ok", "");
	}else{
		tambahItemHouse(GetPlayerVirtualWorld(playerid), id_item, -input_jumlah);
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
	if((total_item + input_jumlah) > max_slot){						
		format(pDialog[playerid], sizePDialog, "Maaf inventory rumah item anda tidak memiliki cukup ruang,\nuntuk menyimpan sebanyak "ORANGE"%i "WHITE"item. Sisa ruang yang anda miliki adalah "ORANGE"(%i/%i).", input_jumlah, total_item, max_slot);

		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory rumah anda penuh", pDialog[playerid], "Ok", "");
	}else{
		tambahItemHouse(GetPlayerVirtualWorld(playerid), id_item, input_jumlah);
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
	if(PU_tempatKeluarRumah[0] + rows - 1 != PU_tempatKeluarRumah[1]){
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
			cache_get_value_name(0, "nama", temp_nama);
			format(houseInfo[house_Id][hOwnerName], MAX_PLAYER_NAME, "%s", temp_nama);
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
	
    houseTextInfo[house_Id] = CreateDynamic3DTextLabel(text_info, COLOR_WHITE, houseInfo[house_Id][icon_x], houseInfo[house_Id][icon_y], houseInfo[house_Id][icon_z]+0.75, 20);
}

// getOwnerHouse(ownerid){
// 	new Cache:result, nama[MAX_PLAYER_NAME], tempQuery[100];
// 	mysql_format(koneksi, tempQuery, 100, "SELECT nama FROM `user` WHERE `id` = '%d'", ownerid);
// 	result = mysql_query(koneksi, tempQuery);
// 	if(cache_num_rows()){
// 		cache_get_value_name(0, "nama", nama);
// 	}
// 	cache_delete(result);
// 	return nama;
// }

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

todoActive(playerid){
	if(sweeperJob[playerid] == 1){
		SendClientMessage(playerid, COLOR_GREEN, "[JOB] "RED"Maaf anda sedang bekerja sebagai Sweeper, silahkan kembali bekerja!");
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

forward todoExit(playerid, paramid);
public todoExit(playerid, paramid){
	if(sweeperJob[playerid] == 1){
		sweeperJob[playerid] = 0;
		usedSweeper[sweeperId[playerid]] = 0;
		sweeperId[playerid] = -1;
		DisablePlayerRaceCheckpoint(playerid);
		SetVehicleToRespawn(paramid);
		SendClientMessage(playerid, COLOR_GREEN, "[JOB] "RED"Anda telah berhenti bekerja!");
	}
	if(testSim[playerid] == 1){
		testSim[playerid] = 0;
		vehicleIdSIM[playerid] = -1;
		limitVehSIM[paramid] = 0;
		DisablePlayerRaceCheckpoint(playerid);
		SetVehicleToRespawn(paramid);
		SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "RED"Anda telah gagal melalukan Ujian Praktik SIM, silahkan coba lagi!");
	}
	return 1;
}

resetPlayerToDo(playerid){
	if(sweeperJob[playerid] == 1){
		SendClientMessage(playerid, COLOR_GREEN, "[JOB] "RED"Anda telah berhenti bekerja!");
		SetVehicleToRespawn(sweeperId[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		KillTimer(todoTimer[playerid]);
		KillTimer(todoTimeout[playerid]);
		sweeperJob[playerid] = 0;
		usedSweeper[sweeperId[playerid]] = 0;
		sweeperId[playerid] = -1;
	}
	if(testSim[playerid] == 1){
		SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "RED"Anda telah gagal melalukan Ujian Praktik SIM, silahkan coba lagi!");
		SetVehicleToRespawn(vehicleIdSIM[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		KillTimer(todoTimer[playerid]);
		KillTimer(todoTimeout[playerid]);
		testSim[playerid] = 0;
		poinSim[playerid] = 0;
		limitVehSIM[vehicleIdSIM[playerid]] = 0;
		vehicleIdSIM[playerid] = -1;
	}
	return 1;
}

mulaiPraktikSIM(playerid){
	foreach(new i : Player){
		foreach(new v : vehicleSIM){
			if(limitVehSIM[v] != 1){
				testSim[playerid] = 1;
				poinSim[playerid] = 100;
				PutPlayerInVehicle(playerid, v, 0);
				vehicleIdSIM[playerid] = v;
				limitVehSIM[v] = 1;
				SetPlayerRaceCheckpoint(playerid, 0, CP_simLS1, CP_simLS2, 3.0);
				SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "WHITE"Anda memiliki waktu 10 menit, jika belum selesai anda akan gagal.");
				todoTimeout[playerid] = SetPreciseTimer("todoExit", 600000, false, "ii", playerid, v);
				return 1;
			}
		}
	}
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Kendaraan Limit", WHITE"Maaf kendaraan untuk pengujian pembuatan SIM sedang digunakan, mohon untuk tunggu beberapa menit.", "Ok", "");
	return 1;	
}

ShowPlayerSpeedo(playerid){
    SpeedoTimer[playerid] = SetPreciseTimer("SpeedoUpdate", 1000, 1, "i", playerid);
    PlayerTextDrawShow(playerid, SpeedoTextDraws[playerid]);
    return 1;
}

HidePlayerSpeedo(playerid){
    KillTimer(SpeedoTimer[playerid]);
    PlayerTextDrawHide(playerid, SpeedoTextDraws[playerid]);
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

LoadVehiclePlayer(playerid){
	inline responseLoadVehicle(){
		new rows;
		cache_get_row_count(rows);
		if(rows){
			new idx = 0, idveh, idpv, temp_id, already_loaded, temp_time;

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

				format(PVeh[idpv][pVehNamaPemilik], MAX_PLAYER_NAME, "%s", PlayerInfo[playerid][pPlayerName]);

				if(temp_time != 0){
					// Sign waktu kunci
					Iter_Add(PVehKeys[playerid], idpv);
					PVehKeysTime[playerid][idpv] = temp_time;
				}

				if(!PVeh[idpv][pVehIsReparasi]) {
					idveh = CreateVehicle(PVeh[idpv][pVehModel], PVeh[idpv][pVehCoord][0], PVeh[idpv][pVehCoord][1], PVeh[idpv][pVehCoord][2], PVeh[idpv][pVehCoord][3], PVeh[idpv][pVehColor][0], PVeh[idpv][pVehColor][1], -1);

					PVeh[idpv][pVehicle] = idveh;

					IDVehToPVeh[idveh] = idpv;
					Iter_Add(IDVehToPVehIterator, idveh);

					LoadModifVehiclePlayer(idveh);

					#if defined DEBUG_SERVER_LOAD
					printf("Vehicle Player %s Vehicle-ID(%d) ig-ID(%d) load.",PlayerInfo[playerid][pPlayerName], PVeh[idpv][pVehID], idveh);
					#endif

					SetVehicleToRespawn(idveh);

					new engine, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(idveh, engine, lights, alarm, doors, bonnet, boot, objective);
					SetVehicleParamsEx(idveh, 0, 0, alarm, doors, bonnet, boot, objective);

					SetVehicleHealth(idveh, PVeh[idpv][pVehDarah]);
				}


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
		if(PVeh[idpv][pVehMod][i] >= 1000 && PVeh[idpv][pVehMod][i] <= 1193)
			AddVehicleComponent(vehicleid, PVeh[idpv][pVehMod]);
	}
	if(PVeh[idpv][pVehPaintJob]) ChangeVehiclePaintjob(vehicleid, PVeh[idpv][pVehPaintJob]);
}

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

	new temp_sql[1000];
	new pveh_data[PlayerVehicleInfo];
	pveh_data = PVeh[idpv];
	mysql_format(koneksi, temp_sql, 1000, "UPDATE vehicle SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', darah = '%f' WHERE id = '%d'", pveh_data[pVehCoord][0], pveh_data[pVehCoord][1], pveh_data[pVehCoord][2], pveh_data[pVehCoord][3], pveh_data[pVehDarah], pveh_data[pVehID]);
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
			format(str, sizeof(str), "Kendaraan ini dijual!\n"ORANGE"Nama Kendaraan: "WHITE"%s\n"PURPLE"Harga: "GREEN"$%d", GetVehicleNameFromModel(DVeh[id][dVehModel]), DVeh[id][dVehHarga]);
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
	format(str, sizeof(str), "Kendaraan ini dijual!\n"ORANGE"Nama Kendaraan: "WHITE"%s\n"PURPLE"Harga: "GREEN"$%d", GetVehicleNameFromModel(modelid), harga);
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

	if(!IsPlayerInAnyVehicle(playerid)) return showDialogPesan(playerid, RED"Anda harus didalam mobil", WHITE"Anda harus didalam mobil yang ingin dibeli, jangan keluar hingga transaksi selesai.");

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
			format(pDialog[playerid], sizePDialog, "Pembelian %s dari dealer", GetVehicleNameFromModel(DVeh[vehid][dVehModel]));
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
		MySQL_TQueryInline(koneksi, using inline responseQuery, "INSERT INTO vehicle(id_pemilik, id_model, pos_x, pos_y, pos_z, pos_a, color_1, color_2) SELECT '%d' AS id_pemilik, id_model, '%f' AS pos_x, '%f' AS pos_y, '%f' AS pos_z, '%f' AS pos_a, color_1, color_2 FROM vehicle_dealer WHERE id = '%d'", PlayerInfo[playerid][pID],  DVeh[vehid][dVehCoord][0], DVeh[vehid][dVehCoord][1], DVeh[vehid][dVehCoord][2], DVeh[vehid][dVehCoord][3], DVeh[vehid][dVehID]);
	}
	else{
		printf("[FATAL ERROR] #008 Invalid vehicle dealer ID.");
		return 1;
	}	
	return 1;
}

UpdateVehicleDealer(vehicleid){
	if(Iter_Contains(DVehIterator, vehicleid) && DVeh[vehicleid][dVehID]){
		mysql_format(koneksi, sQuery, sizeSQuery, "UPDATE vehicle_dealer SET id_model = '%d', pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', color_1 = '%d', color_2 = '%d', harga = '%d' WHERE id = '%d'", DVeh[vehicleid][dVehModel], DVeh[vehicleid][dVehCoord][0], DVeh[vehicleid][dVehCoord][1], DVeh[vehicleid][dVehCoord][2], DVeh[vehicleid][dVehCoord][3], DVeh[vehicleid][dVehColor][0], DVeh[vehicleid][dVehColor][1], DVeh[vehicleid][dVehHarga], DVeh[vehicleid][dVehID]);
		return mysql_tquery(koneksi, sQuery);
	}else
		return 0;
}

forward OnPlayerVehicleHealthChange(playerid, vehicleid, Float:newhealth, Float:oldhealth);
public OnPlayerVehicleHealthChange(playerid, vehicleid, Float:newhealth, Float:oldhealth){
  if(newhealth < oldhealth){
    if(testSim[playerid] == 1 && vehicleIdSIM[playerid] == vehicleid){
		poinSim[playerid]--;
    	GameTextForPlayer(playerid, "~y~Kesehatan Kendaraan~n~~r~Poin -1", 1000, 3);
	}
  }
  return true;
}

forward SpeedoUpdate(playerid);
public SpeedoUpdate(playerid)
{
    new text_speed[24],
    	vehid = GetPlayerVehicleID(playerid),
    	vehspeed = GetVehicleSpeed(vehid);

	newVehicleHealth[vehid] = VehicleHealth(vehid);
	if(newVehicleHealth[vehid] != oldVehicleHealth[vehid]){
		OnPlayerVehicleHealthChange(playerid, vehid, newVehicleHealth[vehid], oldVehicleHealth[vehid]);
		oldVehicleHealth[vehid] = newVehicleHealth[vehid];
	}

    //format(text_speed, 24, "Kecepatan: %i MpH", vehspeed); //Mph
	format(text_speed, 24, "Kecepatan: %i KmpH", vehspeed); //KmpH
    PlayerTextDrawSetString(playerid, SpeedoTextDraws[playerid], text_speed);
    if(testSim[playerid] == 1){
    	if(vehspeed >= 80){
    		poinSim[playerid]--;
    		GameTextForPlayer(playerid, "~y~Kecepatan Kendaraan~n~~r~Poin -1", 1000, 3);
    	}
	}
    return 1;
}