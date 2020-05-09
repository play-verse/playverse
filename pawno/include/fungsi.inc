forward isRegistered(playerid);
public isRegistered(playerid)
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
		
		cache_is_value_name_null(0, "nomor_handphone", is_null);

		if(is_null){
			// EOS = End Of String - '\0' sama
			PlayerInfo[playerid][nomorHP][0] = EOS;
		}else{
			cache_get_value_name(0, "nomor_handphone", temp_value);
			format(PlayerInfo[playerid][nomorHP], 12, "%s", temp_value);
		}

		cache_get_value_name(0, "uang", temp_value);
		PlayerInfo[playerid][uang] = strval(temp_value);
		// Reset dulu uangnya, saat berhasil login baru beri uang
		ResetPlayerMoney(playerid);

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

    PlayerInfo[playerid][ePhone] = 0;
    PlayerInfo[playerid][nomorHP][0] = EOS;

	PlayerInfo[playerid][lastGlobalChat] = 0;
	PlayerInfo[playerid][reply] = -1;
	PlayerInfo[playerid][sudahLogin] = false;
	PlayerInfo[playerid][sudahSpawn] = false;
}

resetPVarInventory(playerid){
	DeletePVar(playerid, "inv_indexlist");
	DeletePVar(playerid, "inv_model");
	DeletePVar(playerid, "inv_jumlah");
	DeletePVar(playerid, "inv_keterangan");
	DeletePVar(playerid, "inv_target_id");
}

forward registerUser(playerid);
public registerUser(playerid)
{
	new EncryptedPassword[65];
	SHA256_PassHash(registerInfo[playerid][registerPassword], PlayerInfo[playerid][pPlayerName], EncryptedPassword, 64);

	new Cache:result;
	mysql_format(koneksi, query, sizeof(query), "INSERT INTO `user` (`nama`, `password`, `jumlah_login`, `join_date`, `jenis_kelamin`, `email`, `account_status`, `current_skin`, `uang`) VALUES ('%e', '%e', '1', NOW(), '%d', '%e', '0', '%d', '100')", PlayerInfo[playerid][pPlayerName], EncryptedPassword, registerInfo[playerid][jenisKelamin], registerInfo[playerid][email], registerInfo[playerid][freeSkinID]);
	result = mysql_query(koneksi, query);
	PlayerInfo[playerid][pID] = cache_insert_id();
	PlayerInfo[playerid][loginKe] = 1;
	PlayerInfo[playerid][skinID] = registerInfo[playerid][freeSkinID];
    cache_delete(result);

	PlayerInfo[playerid][sudahLogin] = true;

	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, 100);

	tambahSkinPlayer(playerid, registerInfo[playerid][freeSkinID], true);

	spawnPemain(playerid);
	return 1;
}

dialogEmail(playerid){
	ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", WHITE"Masukan email anda, kami hanya mensupport email "RED"@gmail.com\n:", "Simpan", "Keluar");
}

forward spawnPemain(playerid);
public spawnPemain(playerid)
{
	if(PlayerInfo[playerid][sudahSpawn]) return 1;
	
	if(!(PlayerInfo[playerid][last_x] == 0 && PlayerInfo[playerid][last_y] == 0 && PlayerInfo[playerid][last_z] == 0 && PlayerInfo[playerid][last_a] == 0) && PlayerInfo[playerid][sudahLogin]){
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], PlayerInfo[playerid][last_x], PlayerInfo[playerid][last_y], PlayerInfo[playerid][last_z], PlayerInfo[playerid][last_a], 0, 0, 0, 0, 0, 0);
		
		Streamer_UpdateEx(playerid, PlayerInfo[playerid][last_x], PlayerInfo[playerid][last_y], PlayerInfo[playerid][last_z]);
		SpawnPlayer(playerid);

		SetPlayerInterior(playerid,  PlayerInfo[playerid][last_int]);
		SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][last_vw]);

		SetPlayerSkin(playerid, PlayerInfo[playerid][skinID]);
		// pindahkanPemain(playerid, PlayerInfo[playerid][last_x], PlayerInfo[playerid][last_y], PlayerInfo[playerid][last_z], PlayerInfo[playerid][last_a], PlayerInfo[playerid][last_int], PlayerInfo[playerid][last_vw], true);

		PlayerInfo[playerid][last_x] = 0;
		PlayerInfo[playerid][last_y] = 0;
		PlayerInfo[playerid][last_z] = 0;
		PlayerInfo[playerid][last_a] = 0;
		PlayerInfo[playerid][last_vw] = 0;
		PlayerInfo[playerid][last_int] = 0;
		PlayerInfo[playerid][sudahSpawn] = true;
	}else{
		new random_spawn = random(sizeof(SPAWN_POINT));
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], SPAWN_POINT[random_spawn][SPAWN_POINT_X], SPAWN_POINT[random_spawn][SPAWN_POINT_Y], SPAWN_POINT[random_spawn][SPAWN_POINT_Z], SPAWN_POINT[random_spawn][SPAWN_POINT_A], 0, 0, 0, 0, 0, 0);
		
		Streamer_UpdateEx(playerid, SPAWN_POINT[random_spawn][SPAWN_POINT_X], SPAWN_POINT[random_spawn][SPAWN_POINT_Y], SPAWN_POINT[random_spawn][SPAWN_POINT_Z]);
		SpawnPlayer(playerid);

		SetPlayerInterior(playerid,  SPAWN_POINT[random_spawn][SPAWN_POINT_INTERIOR]);
		SetPlayerVirtualWorld(playerid, SPAWN_POINT[random_spawn][SPAWN_POINT_VW]);
		// pindahkanPemain(playerid, SPAWN_POINT[random_spawn][SPAWN_POINT_X], SPAWN_POINT[random_spawn][SPAWN_POINT_Y], SPAWN_POINT[random_spawn][SPAWN_POINT_Z], SPAWN_POINT[random_spawn][SPAWN_POINT_A], SPAWN_POINT[random_spawn][SPAWN_POINT_INTERIOR], SPAWN_POINT[random_spawn][SPAWN_POINT_VW], true);
		SetPlayerSkin(playerid, PlayerInfo[playerid][skinID]);

		PlayerInfo[playerid][sudahSpawn] = true;
	}
	return 1;
}

forward updatePlayerCurrentPhone(playerid, listitem);
public updatePlayerCurrentPhone(playerid, listitem){
	mysql_format(koneksi, query, sizeof(query), "SELECT a.use_phone, b.id_user_item, c.nama_item FROM `user` a LEFT JOIN `user_item` b ON b.id_user = a.id LEFT JOIN `item` c ON a.use_phone = c.id_item WHERE a.id = '%d'", PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, query, "checkIfPhoneExist", "dd", playerid, listitem);
	return 1;
}

forward checkIfPhoneExist(playerid, listitem);
public checkIfPhoneExist(playerid, listitem){
	if(cache_num_rows()){
		new id_phone, id_user_item, itemid = getIDbyModelItem(listitem), old_nama_item[100], pesan[256], nama_item[256];
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
		mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET use_phone = '%d' WHERE id = '%d'",itemid, PlayerInfo[playerid][pID]);
		mysql_tquery(koneksi, query);

		// Set player variabel
		PlayerInfo[playerid][ePhone] = itemid;

		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menggunakan item", pesan, "Ok", "");
	}
	return 1;
}

forward cekPesanTerkirim(playerid);
public cekPesanTerkirim(playerid){
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

forward cekNomorPenerima(playerid);
public cekNomorPenerima(playerid){
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

forward lihatPesanMasuk(playerid);
public lihatPesanMasuk(playerid){
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

forward lihatPesanTerkirim(playerid);
public lihatPesanTerkirim(playerid){
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

forward updatePlayerCurrentSkin(playerid, skinid);
public updatePlayerCurrentSkin(playerid, skinid){
	mysql_format(koneksi, query, sizeof(query), "SELECT * FROM `user_skin` WHERE id_skin = '%d' AND id_user = '%d'", skinid, PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, query, "checkIfSkinExist", "dd", playerid, skinid);
	return 1;
}

forward checkIfSkinExist(playerid, skinid);
public checkIfSkinExist(playerid, skinid){
	if(cache_num_rows()){
		mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET current_skin = '%d' WHERE id = '%d'",skinid, PlayerInfo[playerid][pID]);
		mysql_tquery(koneksi, query);
		PlayerInfo[playerid][skinID] = skinid;
	}
	return 1;
}

forward tambahSkinPlayer(playerid, skinid, bool:langsung_gunakan);
public tambahSkinPlayer(playerid, skinid, bool:langsung_gunakan)
{
	mysql_format(koneksi, query, sizeof(query), "INSERT INTO `user_skin` (id_user, id_skin) VALUES('%d', '%d')", PlayerInfo[playerid][pID], skinid);

	if(langsung_gunakan){
		mysql_tquery(koneksi, query, "updatePlayerCurrentSkin", "dd", playerid, skinid);
	}else{
		mysql_tquery(koneksi, query);
	}
	return 1;
}

forward tampilInventorySkinPlayer(playerid);
public tampilInventorySkinPlayer(playerid){
	new rows, string[500], subString[16], id_skin;
	if(cache_get_row_count(rows)){
		for(new i = 0; i < rows; i++){
			cache_get_value_name_int(i, "id_skin", id_skin);
			format(subString, sizeof(subString), "%i\n", id_skin);
			strcat(string, subString);
		}
		ShowPlayerDialog(playerid, DIALOG_PILIH_SKIN, DIALOG_STYLE_PREVIEW_MODEL, "~w~Pilih skin anda :", string, "~w~Pilih", "Keluar");
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Invalid", WHITE"Tidak terdapat skin pada akun anda!\nAnda dapat menghubungi administrator untuk info lebih lanjut!", "Ok", "");
	}
	return 1; // For deleteing cache tquery
}

forward tampilInventoryBarangPlayer(playerid);
public tampilInventoryBarangPlayer(playerid){
	new rows, subString[64], jumlah, model_id, nama_item[100];
	cache_get_row_count(rows);
	new string[MAX_SERVER_ITEM * 64 + 5];
	if(rows){
		for(new i = 0; i < rows; i++){

			cache_get_value_name_int(i, "model_id", model_id);
			cache_get_value_name_int(i, "jumlah", jumlah);
			cache_get_value_name(i, "nama_item", nama_item);

			format(subString, sizeof(subString), "%i\t%s~n~~g~%i\n", model_id, nama_item,jumlah);
			strcat(string, subString);
		}
		ShowPlayerDialog(playerid, DIALOG_PILIH_ITEM, DIALOG_STYLE_PREVIEW_MODEL, "~w~Pilih barang anda :", string, "~w~Pilih", "Keluar");
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Inventory item "RED"kosong", WHITE"Maaf saat ini inventory item anda tidak berisi apapun!\n"YELLOW"Anda bisa mendapatkan item dari bekerja, berbelanja, ataupun saling bertukar item kepada player lain!", "Oke", "");
	}

	return 1; // For deleteing cache tquery
}

forward tambahItemPlayer(playerid, itemid, jumlah);
public tambahItemPlayer(playerid, itemid, jumlah){
	// mysql_format(koneksi, query, sizeof(query), "INSERT INTO `user_item` (id_user, id_item, jumlah) VALUES('%d', '%d', '%d') ON DUPLICATE KEY UPDATE `jumlah` = `jumlah` + '%d'", PlayerInfo[playerid][pID], itemid, jumlah, jumlah);

	// Pakai trigger procedure
	mysql_format(koneksi, query, sizeof(query), "CALL tambah_item(%d, %d, %d)", PlayerInfo[playerid][pID], itemid, jumlah);
	mysql_tquery(koneksi, query);
	return 1;
}

forward cekJumlahItem(playerid, model_id);
public cekJumlahItem(playerid, model_id){
	if(cache_num_rows()){
		new jumlah, keterangan[500], itemid = getIDbyModelItem(model_id);
		cache_get_value_name_int(0, "jumlah", jumlah);

		if(jumlah > 0){
			SetPVarInt(playerid, "inv_indexlist", model_id);
			SetPVarInt(playerid, "inv_model", model_id);
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
forward itemTidakDapatDipakai(playerid);
public itemTidakDapatDipakai(playerid){
	ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, YELLOW"Item tidak dapat dipakai", WHITE"Maaf item yang anda pilih bukan merupakan jenis item yang dapat digunakan.\nAnda dapat memilih item lain yang dapat digunakan.", "Ok", "");

	resetPVarInventory(playerid);
	return 1;
}

forward pakaiHpFromInven(playerid);
public pakaiHpFromInven(playerid){
	updatePlayerCurrentPhone(playerid, GetPVarInt(playerid, "inv_indexlist"));
	resetPVarInventory(playerid);
	return 1;
}

showDialogBeliBarang(playerid){
	new subString[45];
    static string[sizeof(BARANG_MARKET) * 45];

    if(string[0] == EOS){
		for(new i = 0; i < sizeof(BARANG_MARKET); i++){
			format(subString, sizeof(subString), "%i\t%s~n~~g~$%d\n", BARANG_MARKET[i][idModelBarang], BARANG_MARKET[i][namaBarang], BARANG_MARKET[i][hargaBarang]);
            strcat(string, subString);
		}
	}
	ShowPlayerDialog(playerid, DIALOG_BELI_BARANG_MARKET, DIALOG_STYLE_PREVIEW_MODEL, "Beli Barang", string, "Beli", "Batal");
	return 1;
}

/**
	END ITEM TRIGGER
 */

tampilkanKotakMasuk(playerid){
	mysql_format(koneksi, query, sizeof(query), "SELECT a.id_sms, a.tanggal_dikirim, b.nomor_handphone, a.pesan FROM `sms` a LEFT JOIN `user` b ON a.id_user_pengirim = b.id WHERE a.id_user_penerima = '%d' AND a.id_pemilik_pesan = '%d'", PlayerInfo[playerid][pID], PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, query, "lihatPesanMasuk", "d", playerid);
}

tampilkanKotakTerkirim(playerid){
	mysql_format(koneksi, query, sizeof(query), "SELECT a.id_sms, a.tanggal_dikirim, b.nomor_handphone, a.pesan FROM `sms` a LEFT JOIN `user` b ON a.id_user_penerima = b.id WHERE a.id_user_pengirim = '%d' AND a.id_pemilik_pesan = '%d'", PlayerInfo[playerid][pID], PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, query, "lihatPesanTerkirim", "d", playerid);
}

updateOnPlayerDisconnect(playerid){
	// new temp_value[256];

	// Position
	new Float:last_spawn_info_x, Float:last_spawn_info_y, Float:last_spawn_info_z, Float:last_spawn_info_a, last_spawn_info_int, last_spawn_info_vw;
	if(PlayerInfo[playerid][sudahSpawn]){
		GetPlayerPos(playerid, last_spawn_info_x, last_spawn_info_y, last_spawn_info_z);
		GetPlayerFacingAngle(playerid, last_spawn_info_a);
		last_spawn_info_vw = GetPlayerVirtualWorld(playerid);
		last_spawn_info_int = GetPlayerInterior(playerid);		
	}else{
		last_spawn_info_x = last_spawn_info_y = last_spawn_info_z = last_spawn_info_a, last_spawn_info_int = last_spawn_info_vw = 0;
	}

	// Uang
	new str_uang[100];
	valstr(str_uang, GetPlayerMoney(playerid));

	mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET last_x = '%f', last_y = '%f', last_z = '%f',last_a = '%f', last_int = '%d', last_vw = '%d', uang = '%s' WHERE id = '%d'", last_spawn_info_x, last_spawn_info_y, last_spawn_info_z, last_spawn_info_a, last_spawn_info_int, last_spawn_info_vw, str_uang, PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, query);
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

		idx++;
	}
	cache_delete(result);
}

getOwnerHouse(ownerid){
	new Cache:result, nama[MAX_PLAYER_NAME];
	mysql_format(koneksi, query, sizeof(query), "SELECT * FROM `user` WHERE `id` = '%d'", ownerid);
	result = mysql_query(koneksi, query);
	if(cache_num_rows())
	{
		cache_get_value_name(0, "nama", nama);
	}
	cache_delete(result);
	return nama;
}

loadAllHouse(){
	new houseId, userId, houseLevel, houseHarga, houseJual, hX[256], hY[256], hZ[256];
	new Cache:result, row, idx = 0;
	result = mysql_query(koneksi, "SELECT * FROM `house`");
	cache_get_row_count(row);
	while(idx < row){
		cache_get_value_name_int(idx, "id_house", houseId);
		cache_get_value_name_int(idx, "id_user", userId);
		cache_get_value_name_int(idx, "level", houseLevel);
		cache_get_value_name_int(idx, "harga", houseHarga);
		cache_get_value_name_int(idx, "jual", houseJual);
		cache_get_value_name(idx, "icon_x", hX);
		cache_get_value_name(idx, "icon_y", hY);
		cache_get_value_name(idx, "icon_z", hZ);

		createHouse(houseId, userId, houseLevel, houseHarga, houseJual, floatstr(hX), floatstr(hY), floatstr(hZ));

		idx++;
	}
	cache_delete(result);
}

unloadAllHouse(){
	new i, p;
	for(i = 0; i < MAX_HOUSES; i++){
		if(housePickup[i] != -1){
			DestroyPickup(i);
			p = housePickup[i];
			Delete3DTextLabel(houseTextInfo[p]);
			housePickup[i] = -1;
			houseInfo[p][hID] = -1;
			houseInfo[p][hOwner] = -1;
			houseInfo[p][hLevel] = 1;
			houseInfo[p][hJual] = 1;
		}
	}
}

reloadHouseLabel(houseId){
	new text_info[256], ownerName[MAX_PLAYER_NAME], houseLevel, houseHarga, beliRate;
	houseLevel = houseInfo[houseId][hLevel],
	houseHarga = houseInfo[houseId][hHarga];
	beliRate = houseLevel*houseLevel*houseHarga;
	Delete3DTextLabel(houseTextInfo[houseId]);
	houseTextInfo[houseId] = Text3D:INVALID_3DTEXT_ID;
	format(ownerName, 256, "%s", getOwnerHouse(houseInfo[houseId][hOwner]));
	if(houseInfo[houseId][hJual] == 1){
		if(houseInfo[houseId][hOwner] != -1){
			format(text_info, 256, WHITE"["GREEN"House"WHITE"]\nNo : "GREEN"%d"WHITE"\nStatus : "GREEN"Dijual"WHITE"\nPemilik : "GREEN"%s"WHITE"\nHarga : "GREEN"%d"WHITE, houseInfo[houseId][hID], ownerName, beliRate);
		}else{
			format(text_info, 256, WHITE"["GREEN"House"WHITE"]\nNo : "GREEN"%d"WHITE"\nStatus : "GREEN"Dijual"WHITE"\nPemilik : "GREEN"Tidak Ada"WHITE"\nHarga : "GREEN"%d"WHITE, houseInfo[houseId][hID], beliRate);
		}
	}else{
		if(houseInfo[houseId][hOwner] != -1){
			format(text_info, 256, WHITE"["GREEN"House"WHITE"]\nNo : "GREEN"%d"WHITE"\nStatus : "GREEN"Tidak Dijual"WHITE"\nPemilik : "GREEN"%s"WHITE"\nHarga : "GREEN"%d"WHITE, houseInfo[houseId][hID], ownerName, beliRate);
		}else{
			format(text_info, 256, WHITE"["GREEN"House"WHITE"]\nNo : "GREEN"%d"WHITE"\nStatus : "GREEN"Tidak Dijual"WHITE"\nPemilik : "GREEN"Tidak Ada"WHITE"\nHarga : "GREEN"%d"WHITE, houseInfo[houseId][hID], beliRate);
		}
	}
    houseTextInfo[houseId] = Create3DTextLabel(text_info, 0x88EE88FF, houseInfo[houseId][icon_x], houseInfo[houseId][icon_y], houseInfo[houseId][icon_z]+0.75, 20.0, 0, 1);
}

createHouse(houseId, ownerId, houseLevel, houseHarga, houseJual, Float:hX, Float:hY, Float:hZ)
{
	if(houseId < MAX_HOUSES ){
		new Id = CreatePickup(1273 ,23, hX, hY, hZ, 0);
		housePickup[Id] = houseId;
		houseInfo[houseId][hID] 	= houseId;
		houseInfo[houseId][hOwner] 	= ownerId;
		houseInfo[houseId][hLevel] 	= houseLevel;
		houseInfo[houseId][hHarga] 	= houseHarga;
		houseInfo[houseId][hJual] = houseJual;
		houseInfo[houseId][icon_x] 	= hX;
		houseInfo[houseId][icon_y] 	= hY;
		houseInfo[houseId][icon_z] 	= hZ;
		
		reloadHouseLabel(houseId);
	}
	else print("Rumah mencapai limit!");
}

resetAllHouse(){
	unloadAllHouse();
	loadAllHouse();
}