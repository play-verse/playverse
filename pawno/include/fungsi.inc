publicFor: isRegistered(playerid)
{
	if(cache_num_rows()) // IsRegistered
	{
		// Untuk string harus disimpan dlu ke variable, gabisa langsung masuk enum
		new temp_value[256], bool:is_null;
		cache_get_value_name_int(0, "id", PlayerInfo[playerid][pID]);
		cache_get_value_name_int(0, "current_skin", PlayerInfo[playerid][skinID]);
		cache_get_value_name(0, "password", temp_value);
		format(PlayerInfo[playerid][pPassword], 66, "%s", temp_value);
		cache_get_value_name_int(0, "jumlah_login", PlayerInfo[playerid][loginKe]);

		cache_get_value_name_int(0, "jenis_kelamin", PlayerInfo[playerid][jenisKelamin]);

		// Equiped phone
		cache_get_value_name_int(0, "use_phone", PlayerInfo[playerid][ePhone]);
		cache_get_value_name_int(0, "save_house", PlayerInfo[playerid][sHouse]);

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

	PlayerInfo[playerid][lastGlobalChat] = 0;
	PlayerInfo[playerid][reply] = -1;
	PlayerInfo[playerid][sudahLogin] = false;
	PlayerInfo[playerid][sudahSpawn] = false;

	PlayerInfo[playerid][onSelectedTextdraw] = false;

	PlayerInfo[playerid][sisaPalu] = 0;

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
}

resetPVarInventory(playerid){
	DeletePVar(playerid, "inv_indexlist");
	DeletePVar(playerid, "inv_model");
	DeletePVar(playerid, "inv_jumlah");
	DeletePVar(playerid, "inv_keterangan");
	DeletePVar(playerid, "inv_target_id");
}

publicFor: registerUser(playerid)
{
	new EncryptedPassword[65];
	SHA256_PassHash(registerInfo[playerid][registerPassword], PlayerInfo[playerid][pPlayerName], EncryptedPassword, 64);

	new Cache:result;
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO `user` (`nama`, `password`, `jumlah_login`, `join_date`, `jenis_kelamin`, `email`, `account_status`, `current_skin`) VALUES ('%e', '%e', '1', NOW(), '%d', '%e', '0', '%d')", PlayerInfo[playerid][pPlayerName], EncryptedPassword, registerInfo[playerid][jenisKelamin], registerInfo[playerid][email], registerInfo[playerid][freeSkinID]);
	result = mysql_query(koneksi, pQuery[playerid]);
	PlayerInfo[playerid][pID] = cache_insert_id();
	PlayerInfo[playerid][loginKe] = 1;
	PlayerInfo[playerid][jenisKelamin] = registerInfo[playerid][jenisKelamin];
	PlayerInfo[playerid][skinID] = registerInfo[playerid][freeSkinID];
    cache_delete(result);

	PlayerInfo[playerid][sudahLogin] = true;

	setUangPlayer(playerid, 100);

	tambahSkinPlayer(playerid, registerInfo[playerid][freeSkinID], 1, true);

	spawnPemain(playerid);
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
	tampilkanHUDStats(playerid);

	if(PlayerInfo[playerid][last_stats_makan] == 0 && PlayerInfo[playerid][last_stats_minum] == 0){
		setStatusMakanPemain(playerid, 80);
		setStatusMinumPemain(playerid, 80);
	}else{
		setStatusMakanPemain(playerid, PlayerInfo[playerid][last_stats_makan]);
		setStatusMinumPemain(playerid, PlayerInfo[playerid][last_stats_minum]);

		PlayerInfo[playerid][last_stats_makan] = 0;
		PlayerInfo[playerid][last_stats_minum] = 0;
	}
	

	if(house_Id != 0){
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], houseInfo[house_Id][icon_x], houseInfo[house_Id][icon_y], houseInfo[house_Id][icon_z], 0, 0, 0, 0, 0, 0, 0);
			
		SpawnPlayer(playerid);
		
		pindahkanPemain(playerid, houseInfo[house_Id][icon_x], houseInfo[house_Id][icon_y], houseInfo[house_Id][icon_z], 0, 0, 0, true);

		TogglePlayerControllable(playerid, 0);
		SetTimerEx("GantiSkinSaatSpawn", 2000, false, "i", playerid);

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
		if(!(PlayerInfo[playerid][last_x] == 0 && PlayerInfo[playerid][last_y] == 0 && PlayerInfo[playerid][last_z] == 0 && PlayerInfo[playerid][last_a] == 0) && PlayerInfo[playerid][sudahLogin]){
			SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], PlayerInfo[playerid][last_x], PlayerInfo[playerid][last_y], PlayerInfo[playerid][last_z], PlayerInfo[playerid][last_a], 0, 0, 0, 0, 0, 0);
			
			SpawnPlayer(playerid);

			pindahkanPemain(playerid, PlayerInfo[playerid][last_x], PlayerInfo[playerid][last_y], PlayerInfo[playerid][last_z], PlayerInfo[playerid][last_a], PlayerInfo[playerid][last_int], PlayerInfo[playerid][last_vw], true);

			TogglePlayerControllable(playerid, 0);
			SetTimerEx("GantiSkinSaatSpawn", 2000, false, "i", playerid);
			
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
			SetTimerEx("GantiSkinSaatSpawn", 2000, false, "i", playerid);
		}
	}
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
			format(msg, sizeof(msg), "Barang anda "BLUE"%s "WHITE"sudah dikembalikan ke inventory, silahkan cek kembali!", old_nama_item);
			strcat(pesan, msg);
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
		format(msg, sizeof(msg), WHITE"Anda telah mencapai batas maksimal pesan yang dapat dikirim yaitu "YELLOW"%d "WHITE"per "RED"%d"WHITE".\nSilahkan hapus terlebih dahulu "YELLOW"kotak terkirim "WHITE"anda!", banyak_pesan, MAX_SMS_PER_PLAYER);
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Maksimum limit pesan", msg, "Ok", "");
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
			format(msg, sizeof(msg), WHITE"Penerima telah mencapai batas maksimal pesan yang dapat diterima yaitu "YELLOW"%d "WHITE"per "RED"%d"WHITE".\nAnda hanya dapat mengirim saat penerima sudah menghapus "YELLOW"kotak masuknya "WHITE"dan menyisihkan tempat untuk pesan anda!", banyak_pesan, MAX_SMS_PER_PLAYER);
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Maksimum limit pesan", msg, "Ok", "");
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
		new string[MAX_SMS_PER_PLAYER * 60] = "Kode SMS\tPengirim\tTanggal Waktu\n";
		for(new i = 0; i < rows; i++){
			cache_get_value_name(i, "nomor_handphone", nomor);
			cache_get_value_name(i, "tanggal_dikirim", tanggal);
			cache_get_value_name_int(i, "id_sms", id_sms);

			format(subString, sizeof(subString), "%i\t%s\t%s\n", id_sms, nomor, tanggal);
			strcat(string, subString);
		}
		ShowPlayerDialog(playerid, DIALOG_KOTAK_MASUK, DIALOG_STYLE_TABLIST_HEADERS, "Kotak Masuk :", string, "Pilih", "Keluar");

		PlayerInfo[playerid][kotakPesan] = cache_save();
		return 1;
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"Kotak Masuk Kosong", WHITE"Saat ini kotak masuk anda kosong!\nSilahkan cek kembali saat kotak masuk berisi, ya.", "Ok", "");
	}
	return 1;
}

publicFor: lihatPesanTerkirim(playerid){
	new rows;
	cache_get_row_count(rows);
	if(rows){
		new subString[60], id_sms, nomor[16], tanggal[35];
		new string[MAX_SMS_PER_PLAYER * 60] = "Kode SMS\tPenerima\tTanggal Waktu\n";
		for(new i = 0; i < rows; i++){
			cache_get_value_name(i, "nomor_handphone", nomor);
			cache_get_value_name(i, "tanggal_dikirim", tanggal);
			cache_get_value_name_int(i, "id_sms", id_sms);

			format(subString, sizeof(subString), "%i\t%s\t%s\n", id_sms, nomor, tanggal);
			strcat(string, subString);
		}
		ShowPlayerDialog(playerid, DIALOG_KOTAK_TERKIRIM, DIALOG_STYLE_TABLIST_HEADERS, "Kotak Terkirim :", string, "Pilih", "Keluar");

		PlayerInfo[playerid][kotakPesan] = cache_save();
		return 1;
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"Kotak Terkirim Kosong", WHITE"Saat ini kotak terkirim anda kosong!\nSilahkan cek kembali saat kotak terkirim berisi, ya.", "Ok", "");
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
	if(cache_get_row_count(rows)){
		for(new i = 0; i < rows; i++){
			cache_get_value_name_int(i, "jumlah", jumlah);
			cache_get_value_name_int(i, "id_skin", id_skin);
			format(subString, sizeof(subString), "%i\t~g~%i\n", id_skin, jumlah);
			strcat(string, subString);
		}
		ShowPlayerDialog(playerid, DIALOG_PILIH_SKIN, DIALOG_STYLE_PREVIEW_MODEL, "~w~Pilih skin anda :", string, "~w~Pilih", "Keluar");
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

publicFor: tampilInventoryBarangPlayer(playerid){
	new rows, subString[64], jumlah, id_item, nama_item[100];
	cache_get_row_count(rows);
	new string[MAX_SERVER_ITEM * 64 + 5] = "Kode\tNama\tJumlah\n"WHITE;
	if(rows){
		for(new i = 0; i < rows; i++){
			cache_get_value_name_int(i, "id_item", id_item);
			cache_get_value_name_int(i, "jumlah", jumlah);
			cache_get_value_name(i, "nama_item", nama_item);

			format(subString, sizeof(subString), "%i\t%s\t%i\n", id_item, nama_item,jumlah);
			strcat(string, subString);
		}
		ShowPlayerDialog(playerid, DIALOG_PILIH_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Pilih barang anda :", string, "Pilih", "Keluar");
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Inventory item "RED"kosong", WHITE"Maaf saat ini inventory item anda tidak berisi apapun!\n"YELLOW"Anda bisa mendapatkan item dari bekerja, berbelanja, ataupun saling bertukar item kepada player lain!", "Oke", "");
	}

	return 1; // For deleteing cache tquery
}

publicFor: tambahItemPlayer(playerid, itemid, jumlah){
	// Pakai trigger procedure
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "CALL tambah_item(%d, %d, %d)", PlayerInfo[playerid][pID], itemid, jumlah);
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

publicFor: cekJumlahItem(playerid, itemid){
	if(cache_num_rows()){
		new jumlah, keterangan[500];
		cache_get_value_name_int(0, "jumlah", jumlah);

		if(jumlah > 0){
			SetPVarInt(playerid, "inv_indexlist", itemid);
			SetPVarInt(playerid, "inv_model", getModelByIdItem(itemid));
			SetPVarInt(playerid, "inv_jumlah", jumlah);

			getKeteranganByIdItem(itemid, keterangan);
			SetPVarString(playerid, "inv_keterangan", keterangan);

			ShowPlayerDialog(playerid, DIALOG_OPTION_ITEM_INVENTORY, DIALOG_STYLE_LIST, WHITE"Pilih aksi", GREEN"Pakai Item\n"LIGHT_BLUE"Beritahu Item\n"BLUE"Info Item", "Ok", "Keluar");
		}else{
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Barang tidak ada!", WHITE"Maaf! Anda tidak memiliki barang tersebut!", "Ok", "");
			resetPVarInventory(playerid);
		}
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Barang tidak ada!", WHITE"Maaf! Anda tidak memiliki barang tersebut!", "Ok", "");
		resetPVarInventory(playerid);
	}
	return 1;
}

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
		format(msg, sizeof(msg), "Anda akan membuat rekening dengan nomor rekening "YELLOW"%s "WHITE"dengan ketentuan:\n"YELLOW"- Pembuatan rekening membutuhkan uang administrasi sebesar "GREEN"$100\n- Memiliki 2 Materai dan 4 Pas Foto", rekening);
		ShowPlayerDialog(playerid, DIALOG_DAFTAR_REKENING_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi Pembuatan Rekening", msg, "Daftar", "Batal");
	}else{
		DeletePVar(playerid, "regis_rekening");
		return ShowPlayerDialog(playerid, DIALOG_DAFTAR_REKENING_INPUT_NOMOR, DIALOG_STYLE_INPUT, "Input nomor rekening ATM baru", RED"Nomor rekening telah ada, silahkan pilih nomor rekening lain!\n\n"WHITE"Input nomor rekening ATM yang baru:\n"WHITE"- Nomor rekening harus terdiri dari 8 karakter\n- Nomor rekening belum digunakan oleh orang lain sebelumnya", "Ok", "Kembali");
	}
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
		format(msg, sizeof(msg), RED"Nomor rekening "YELLOW"%s "RED"tidak ada.\n"WHITE"Silahkan masukan nomor rekening tujuan:\nNomor rekening harus terdiri dari 8 digit.\nPastikan anda memasukan rekening yang benar.", rekening);
		ShowPlayerDialog(playerid, DIALOG_INPUT_REKENING_TUJUAN, DIALOG_STYLE_INPUT, "Nomor rekening tujuan", msg, "Ok", "Kembali");
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

		format(msg, sizeof(msg), WHITE"Anda akan melakukan transfer dengan data berikut :\n\n"YELLOW"Nama Penerima : %s\nNo. Rek : %s\nNominal : %d\n\n"WHITE"Anda yakin ingin mengirimnya? Silahkan isi keterangan pengiriman menandakan anda setuju.", nama_penerima, rekening_penerima, nominal);
		ShowPlayerDialog(playerid, DIALOG_TRANSFER_KONFIRMASI, DIALOG_STYLE_INPUT, "Konfirmasi Transfer", msg, "Kirim", "Batal");
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

		format(msg, sizeof(msg), WHITE"Anda akan menarik uang sebesar "GREEN"%d."WHITE"\nApakah anda yakin ingin melakukan penarikan?", nominal);
		ShowPlayerDialog(playerid, DIALOG_TARIK_UANG_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi penarikan uang", msg, "Konfirmasi", "Batal");
	}else
		printf("[ERROR] #02 Error fungsi penarikan (%d)%s - ID user(%d)", playerid, PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][pID]);
	return 1;
}

publicFor: tampilSaldoPlayer(playerid){
	new saldo;
	if(cache_num_rows()){
		cache_get_value_name_int(0, "saldo", saldo);
		format(msg, sizeof(msg), WHITE"Informasi saldo anda dan Rekening anda:\n\nNama : %s\nRekening : %s\nSaldo : %d\n\nInformasi saldo dapat berubah sewaktu-waktu sesuai dengan transaksi yang terjadi setiap saatnya.\nTerimakasih telah menggunakan Layanan dari kami.", PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][nomorRekening], saldo);
		ShowPlayerDialog(playerid, DIALOG_INFO_SALDO_HISTORY, DIALOG_STYLE_MSGBOX, "Informasi saldo dan Akun Bank", msg, "Kembali", "Tutup");
	}
	else
		printf("[ERROR] #03 Error fungsi tampil saldo (%d)%s - ID user(%d)", playerid, PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][pID]);
	return 1;
}

publicFor: historyATMPemain(playerid){
	new rows;
	cache_get_row_count(rows);
	if(rows){
		new idx = 0, subString[150], string[1700] = "Pengirim/Penerima\tNominal\tTanggal\tKeterangan\n", temp_tanggal[20], rekening_temp[10], keterangan[60], nominal_temp;
		while(idx < rows){
			cache_get_value_name(idx, "rekening", rekening_temp);
			cache_get_value_name(idx, "keterangan", keterangan);
			cache_get_value_name(idx, "tanggal", temp_tanggal);
			cache_get_value_name_int(idx, "nominal", nominal_temp);
			format(subString, sizeof(subString), "%s\t%d\t%s\t%s\n", rekening_temp, nominal_temp, temp_tanggal, keterangan);
			strcat(string, subString);
			idx++;
		}
		ShowPlayerDialog(playerid, DIALOG_INFO_SALDO_HISTORY, DIALOG_STYLE_TABLIST_HEADERS, "Informasi History ATM", string, "Kembali", "Tutup");
	}else{
		ShowPlayerDialog(playerid, DIALOG_INFO_SALDO_HISTORY, DIALOG_STYLE_MSGBOX, "Informasi History ATM", "Tidak ada history ATM untuk saat ini.", "Kembali", "Tutup");
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

			format(msg, sizeof(msg), WHITE"Anda berhasil mendapatkan KTP yang sudah anda proses selama beberapa waktu.\nSilahkan gunakan data diri dan KTP anda dengan sebaik mungkin.\n"ORANGE"\nPemberian informasi data diri kepada orang lain, dapat menyebabkan hal yang tidak diinginkan.");
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"KTP sudah selesai", msg, "Ok", "");
		}else{
			cache_get_value_name(0, "tanggal_ambil", tanggal_pengambilan);
			format(msg, sizeof(msg), WHITE"KTP anda sedang dalam proses pembuatan, silahkan kembali pada tanggal :\n"YELLOW"%s\n"WHITE"Pengambilan KTP dapat anda lakukan di tempat resepsionis dengan memilih menu "GREEN"Ambil KTP "WHITE"\nAnda akan otomatis mendapatkan kartu anda pada saat itu juga.", tanggal_pengambilan);

			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"KTP sedang diproses", msg, "Ok", "");			
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
		format(msg, sizeof(msg), WHITE"KTP anda sedang dalam proses pembuatan, silahkan kembali pada tanggal :\n"YELLOW"%s\n"WHITE"Pengambilan KTP dapat anda lakukan di tempat resepsionis dengan memilih menu "GREEN"Ambil KTP "WHITE"\nAnda akan otomatis mendapatkan kartu anda pada saat itu juga.", tanggal_pengambilan);

		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"KTP sedang diproses", msg, "Ok", "");
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
			ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 1, 1, 0, 1, 1);
			tambahItemPlayer(playerid, 10, 1);
		}
		case 2..3:
		{
			showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "YELLOW"Emas"WHITE".\nEmas adalah hasil tambang yang sangat bagus, dan "PURPLE"langka"WHITE". Sangat beruntung!");
			ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 1, 1, 0, 1, 1);
			tambahItemPlayer(playerid, 9, 1);
		}
		case 4..6:{
			showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "SILVER"Perunggu"WHITE".\nPerunggu adalah hasil tambang yang berguna dan juga "BLUE"diminati orang banyak"WHITE". Keren sekali!");
			ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 1, 1, 0, 1, 1);
			tambahItemPlayer(playerid, 11, 1);
		}
		case 7..9:
		{
			showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "ORANGE"Perak"WHITE".\nPerak adalah hasil tambang bagus dan "GREEN"berguna untuk banyak hal"WHITE". Kerja bagus!");
			ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 1, 1, 0, 1, 1);

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
	//		ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 1, 1, 0, 1, 1);
	// }else if(angka >= 1601 && angka <= 20000){ // Kemungkinan 1,84%
	// 		showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "YELLOW"Emas"WHITE".\nEmas adalah hasil tambang yang sangat bagus, dan "PURPLE"langka"WHITE". Sangat beruntung!");
	// 		tambahItemPlayer(playerid, 9, 1);
	//		ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 1, 1, 0, 1, 1);
	// }else if(angka >= 20001 && angka <= 120000){ // Kemungkinan 10%
	// 		showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "SILVER"Perunggu"WHITE".\nPerunggu adalah hasil tambang yang berguna dan juga "BLUE"diminati orang banyak"WHITE". Keren sekali!");
	// 		tambahItemPlayer(playerid, 11, 1);
	//		ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 1, 1, 0, 1, 1);
	// }else if(angka >= 120001 && angka <= 420000){ // Kemungkinan 30%
	// 		showDialogPesan(playerid, "Hasil Tambang", GREEN"Selamat Anda mendapatkan "ORANGE"Perak"WHITE".\nPerak adalah hasil tambang bagus dan "GREEN"berguna untuk banyak hal"WHITE". Kerja bagus!");

	// 		tambahItemPlayer(playerid, 12, 1);
	//		ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 1, 1, 0, 1, 1);
	// }else{
	// 		SendClientMessage(playerid, COLOR_GREY, "[SERVER] Anda tidak mendapatkan apapun silahkan coba lagi.");
	// }
}

publicFor: showHistoryGajiPemain(playerid){
	new rows;
	cache_get_row_count(rows);
	if(rows){
		new tmp_tanggal[50], tmp_nominal, temp_dialog[150];
		format(pDialog[playerid], sizePDialog, WHITE"Tanggal\t"GREEN"Nominal\n"WHITE);
		foreach(new i : Range(0, rows)){
			cache_get_value_name(i, "tanggal", tmp_tanggal);
			cache_get_value_name_int(i, "nominal", tmp_nominal);

			format(temp_dialog, 149, "%s\t%i\n", tmp_tanggal, tmp_nominal);
			strcat(pDialog[playerid], temp_dialog);
		}
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_TABLIST_HEADERS, "History Gaji Pemain", pDialog[playerid], "Tutup", "");
	}else
		showDialogPesan(playerid, RED"Kotak gaji kosong", WHITE"Saat ini gaji anda tidak ada yang mau diambil.");
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
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO pengambilan_sim(id_user,tanggal_buat,tanggal_ambil) VALUES('%d', NOW(), NOW() + INTERVAL %d MINUTE)", PlayerInfo[playerid][pID], interval_menit);
	mysql_tquery(koneksi, pQuery[playerid]);
}

hapusSetelahPengambilanSIM(playerid){
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM pengambilan_sim WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid]);
}

publicFor: cekPembuatanSIM(playerid, ada){
	if(ada){
		mulaiPembuatanSIM(playerid);
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Tidak memiliki KTP", WHITE"Anda harus memiliki KTP terlebih dahulu untuk dapat mendaftarkan praktik pengujian SIM.", "Ok", "");
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

			format(msg, sizeof(msg), WHITE"Anda berhasil mendapatkan SIM yang sudah anda proses selama beberapa waktu.\nSilahkan berkendara dengan sebaik mungkin.\n"ORANGE"\nMelakukan pelanggaran lalu lintas akan mendapat tindakan tegas.");
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"SIM sudah selesai", msg, "Ok", "");
		}else{
			cache_get_value_name(0, "tanggal_ambil", tanggal_pengambilan);
			format(msg, sizeof(msg), WHITE"SIM anda sedang dalam proses pembuatan, silahkan kembali pada tanggal :\n"YELLOW"%s\n"WHITE"Pengambilan SIM dapat anda lakukan dengan memilih menu "GREEN"Ambil SIM "WHITE"\nAnda akan mendapatkan SIM pada saat itu juga.", tanggal_pengambilan);

			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"SIM sedang diproses", msg, "Ok", "");			
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

	format(str_hari, 80, "%s, %d/%d/%d", indo_hari, temp_hari, temp_bulan, temp_hari);
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
	switch(itemid){
		case 14: // Steak
		{
			tambahItemPlayer(playerid, itemid, -1);
			ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 0, 0, 1);
			setStatusMakanPemain(playerid, getStatusMakanPemain(playerid) + 80);
		}
		default:
			return 1;
	}
	return 1;
}

publicFor: cekSudahPunyaSIM(playerid){
	new tanggal_pengambilan[50];
	if(cache_num_rows()){
		cache_get_value_name(0, "tanggal_ambil", tanggal_pengambilan);
		format(msg, sizeof(msg), WHITE"SIM anda sedang dalam proses pembuatan, silahkan kembali pada tanggal :\n"YELLOW"%s\n"WHITE"Pengambilan SIM dapat anda lakukan dengan memilih menu "GREEN"Ambil SIM "WHITE"\nAnda akan mendapatkan SIM pada saat itu juga.", tanggal_pengambilan);

		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"SIM sedang diproses", msg, "Ok", "");
	}else{
		// ID SIM = 13
		cekKetersediaanItem(playerid, 13, 1, "isBisaBuatSIM");
	}
	return 1;
}

publicFor: pakaiMinuman(playerid, itemid){
	switch(itemid)
	{
		case 13: // Air minum mineral
		{
			tambahItemPlayer(playerid, itemid, -1);
			ApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 1, 1, 0, 0, 1);
			setStatusMinumPemain(playerid, getStatusMinumPemain(playerid) + 5);
		}
		default :
			return 1;
	}
	return 1;
}

publicFor: isBisaBuatSIM(playerid, tidak_bisa){
	if(tidak_bisa){
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Anda telah memiliki SIM", WHITE"Maaf anda telah memiliki SIM, anda tidak dapat membuatnya lagi.", "Ok", "");
	}else{
		ShowPlayerDialog(playerid, DIALOG_DAFTAR_SIM_KONFIRMASI, DIALOG_STYLE_MSGBOX, "Konfirmasi Pembuatan SIM", WHITE"Anda akan membuat SIM dengan syarat berikut.\nPersyaratan:\n"YELLOW"- Biaya administrasi sebesar "GREEN"$100"YELLOW"\n- Memiliki KTP", "Daftar", "Batal");
	}
	return 1;
}

/**
	END ITEM TRIGGER
 */

tampilkanKotakMasuk(playerid){
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT a.id_sms, a.tanggal_dikirim, b.nomor_handphone, a.pesan FROM `sms` a LEFT JOIN `user` b ON a.id_user_pengirim = b.id WHERE a.id_user_penerima = '%d' AND a.id_pemilik_pesan = '%d'", PlayerInfo[playerid][pID], PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid], "lihatPesanMasuk", "d", playerid);
}

tampilkanKotakTerkirim(playerid){
	mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT a.id_sms, a.tanggal_dikirim, b.nomor_handphone, a.pesan FROM `sms` a LEFT JOIN `user` b ON a.id_user_penerima = b.id WHERE a.id_user_pengirim = '%d' AND a.id_pemilik_pesan = '%d'", PlayerInfo[playerid][pID], PlayerInfo[playerid][pID]);
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

	mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET last_x = '%f', last_y = '%f', last_z = '%f',last_a = '%f', last_int = '%d', last_vw = '%d', last_hp = '%f', last_armour = '%f', last_stats_makan = '%f', last_stats_minum = '%f' WHERE id = '%d'", last_spawn_info_x, last_spawn_info_y, last_spawn_info_z, last_spawn_info_a, last_spawn_info_int, last_spawn_info_vw, last_hp, last_armour, temp_stats_makan, temp_stats_minum, PlayerInfo[playerid][pID]);
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

loadAllHouse(){
	new house_Id, userId, houseLevel, houseHarga, houseKunci, houseJual, hX[256], hY[256], hZ[256];
	new Cache:result, row, idx = 0;
	result = mysql_query(koneksi, "SELECT * FROM `house`");
	cache_get_row_count(row);
	while(idx < row){
		result = cache_save();
		cache_get_value_name_int(idx, "id_house", house_Id);
		cache_get_value_name_int(idx, "id_user", userId);
		cache_get_value_name_int(idx, "level", houseLevel);
		cache_get_value_name_int(idx, "harga", houseHarga);
		cache_get_value_name_int(idx, "kunci", houseKunci);
		cache_get_value_name_int(idx, "jual", houseJual);
		cache_get_value_name(idx, "icon_x", hX);
		cache_get_value_name(idx, "icon_y", hY);
		cache_get_value_name(idx, "icon_z", hZ);
		createHouse(house_Id, userId, houseLevel, houseHarga, houseKunci, houseJual, floatstr(hX), floatstr(hY), floatstr(hZ));
		cache_set_active(result);
		
		#if DEBUG_SERVER_LOAD == true
			printf("House load id(%d)", house_Id);
		#endif

		idx++;
	}
	cache_delete(result);
}

unloadAllHouse(){
	for(new i = 0; i < MAX_HOUSES; i++){
		if(housePickup[i] != -1){
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
}

resetAllHouse(){
	unloadAllHouse();
	loadAllHouse();
}

createHouse(house_Id, ownerId, houseLevel, houseHarga, houseKunci, houseJual, Float:hX, Float:hY, Float:hZ)
{
	if(house_Id < MAX_HOUSES ){
		new Id = CreateDynamicPickup(1273, 1, hX, hY, hZ);
		housePickup[house_Id] = Id;
		houseId[Id] = house_Id;
		houseInfo[house_Id][hID] = house_Id;
		houseInfo[house_Id][hOwner] = ownerId;
		houseInfo[house_Id][hLevel] = houseLevel;
		houseInfo[house_Id][hHarga] = houseHarga;
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
	new text_info[256], ownerName[MAX_PLAYER_NAME], beliRate;
	beliRate = getHousePrice(house_Id, "beli");
	houseTextInfo[house_Id] = Text3D:INVALID_3DTEXT_ID;
	if(houseInfo[house_Id][hOwner] != -1){
		format(ownerName, 256, "%s", getOwnerHouse(houseInfo[house_Id][hOwner]));
	}
	if(houseInfo[house_Id][hJual] == 1){
		if(houseInfo[house_Id][hOwner] != -1){
			format(text_info, 256, WHITE"["GREEN"Rumah"WHITE"]\nNo : "GREEN"%d"WHITE"\nStatus : "GREEN"Dijual"WHITE"\nPemilik : "GREEN"%s"WHITE"\nHarga : "GREEN"%d", houseInfo[house_Id][hID], ownerName, beliRate);
		}else{
			format(text_info, 256, WHITE"["GREEN"Rumah"WHITE"]\nNo : "GREEN"%d"WHITE"\nStatus : "GREEN"Dijual"WHITE"\nPemilik : "GREEN"Tidak Ada"WHITE"\nHarga : "GREEN"%d", houseInfo[house_Id][hID], beliRate);
		}
	}else{
		if(houseInfo[house_Id][hOwner] != -1){
			format(text_info, 256, WHITE"["GREEN"Rumah"WHITE"]\nNo : "GREEN"%d"WHITE"\nStatus : "GREEN"Tidak Dijual"WHITE"\nPemilik : "GREEN"%s"WHITE"\nHarga : "GREEN"%d", houseInfo[house_Id][hID], ownerName, beliRate);
		}else{
			format(text_info, 256, WHITE"["GREEN"Rumah"WHITE"]\nNo : "GREEN"%d"WHITE"\nStatus : "GREEN"Tidak Dijual"WHITE"\nPemilik : "GREEN"Tidak Ada"WHITE"\nHarga : "GREEN"%d", houseInfo[house_Id][hID], beliRate);
		}
	}
    houseTextInfo[house_Id] = CreateDynamic3DTextLabel(text_info, COLOR_WHITE, houseInfo[house_Id][icon_x], houseInfo[house_Id][icon_y], houseInfo[house_Id][icon_z]+0.75, 20);
}

getOwnerHouse(ownerid){
	new Cache:result, nama[MAX_PLAYER_NAME], tempQuery[100];
	mysql_format(koneksi, tempQuery, 100, "SELECT * FROM `user` WHERE `id` = '%d'", ownerid);
	result = mysql_query(koneksi, tempQuery);
	if(cache_num_rows()){
		cache_get_value_name(0, "nama", nama);
	}
	cache_delete(result);
	return nama;
}

getHousePrice(house_Id, method[16]=""){
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
		SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "RED"Maaf anda sedang melakukan praktik pengujian SIM, silahkan kembali praktik!");
		return 1;
	}
	return 0;
}

forward todoExit(playerid, paramid);
public todoExit(playerid, paramid){
	if(sweeperJob[playerid] == 1){
		sweeperJob[playerid] = 0;
		sweeperId[playerid] = -1;
		DisablePlayerRaceCheckpoint(playerid);
		SetVehicleToRespawn(paramid);
		SendClientMessage(playerid, COLOR_GREEN, "[JOB] "RED"Anda telah berhenti bekerja!");
	}
	if(testSim[playerid] == 1){
		testSim[playerid] = 0;
		vehicleIdSIM[playerid] = -1;
		DisablePlayerRaceCheckpoint(playerid);
		SetVehicleToRespawn(paramid);
		SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "RED"Anda telah gagal melalukan praktik pengujian SIM, silahkan coba lagi!");
	}
	return 1;
}

resetPlayerToDo(playerid){
	if(sweeperJob[playerid] == 1){
		SendClientMessage(playerid, COLOR_GREEN, "[JOB] "RED"Anda telah berhenti bekerja!");
		KillTimer(todoTimer[playerid]);
		SetVehicleToRespawn(sweeperId[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		sweeperJob[playerid] = 0;
		sweeperId[playerid] = -1;
	}
	if(testSim[playerid] == 1){
		SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "RED"Anda telah gagal melalukan praktik pengujian SIM, silahkan coba lagi!");
		KillTimer(todoTimer[playerid]);
		SetVehicleToRespawn(vehicleIdSIM[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		testSim[playerid] = 0;
		vehicleIdSIM[playerid] = -1;
	}
	return 1;
}

mulaiPembuatanSIM(playerid){
	for(new i = 0; i < MAX_PLAYERS; i++){
		for(new v = 0; v < 3; v++){
			if(vehicleSIM[v]){
				if(!IsPlayerInVehicle(i, vehicleSIM[v])){
					testSim[playerid] = 1;
					poinSim[playerid] = 100;
					PutPlayerInVehicle(playerid, vehicleSIM[v], 0);
					vehicleIdSIM[playerid] = GetPlayerVehicleID(playerid);
					SetPlayerRaceCheckpoint(playerid, 0, CP_simLS1, CP_simLS2, 3.0);
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Praktik SIM", WHITE"Anda sekarang akan melakukan praktik mengemudi kendaraan.\nSilahkan ikuti aturan dan arah jalan dengan benar sebagai berikut.\nAturan:\n"YELLOW"- Maksimal kecepatan "GREEN"80 KmpH\n"YELLOW"- Kendaraan tidak boleh menabrak apapun disekitar\n- Minimal poin "GREEN"80", "Ok", "");
					goto label_berhenti_sim;
				}else if(v == 1 && v == 2 && v == 3 && IsPlayerInVehicle(i, vehicleSIM[v])){
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Kendaraan Limit", WHITE"Maaf kendaraan untuk pengujian pembuatan SIM sedang digunakan, mohon untuk tunggu beberapa menit.", "Ok", "");
					goto label_berhenti_sim;
				}
			}
		}
	}
	label_berhenti_sim:
	return 1;	
}

ShowPlayerSpeedo(playerid){
    SpeedoTimer[playerid] = SetTimerEx("SpeedoUpdate", 1000, 1, "i", playerid);
    PlayerTextDrawShow(playerid, SpeedoTextDraws[playerid]);
    return 1;
}

HidePlayerSpeedo(playerid){
    KillTimer(SpeedoTimer[playerid]);
    PlayerTextDrawHide(playerid, SpeedoTextDraws[playerid]);
    return 1;
}

forward OnPlayerVehicleHealthChange(playerid, vehicleid, Float:newhealth, Float:oldhealth);
public OnPlayerVehicleHealthChange(playerid, vehicleid, Float:newhealth, Float:oldhealth){
  if(newhealth < oldhealth){
    if(testSim[playerid] == 1){
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

    //format(text_speed, 24, "Speed: %i MpH", vehspeed); //Mph
	format(text_speed, 24, "Speed: %i KmpH", vehspeed); //KmpH
    PlayerTextDrawSetString(playerid, SpeedoTextDraws[playerid], text_speed);
    if(testSim[playerid] == 1){
    	if(vehspeed >= 80){
    		poinSim[playerid]--;
    		GameTextForPlayer(playerid, "~y~Kecepatan Kendaraan~n~~r~Poin -1", 1000, 3);
    	}
	}
    return 1;
}