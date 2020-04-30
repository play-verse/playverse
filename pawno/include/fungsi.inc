forward isRegistered(playerid);
public isRegistered(playerid)
{
	if(cache_num_rows()) // IsRegistered
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
		
		cache_get_value_name(0, "nomor_handphone", temp_value);
		format(PlayerInfo[playerid][nomorHP], 12, "%s", temp_value);

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
		SetSpawnInfo(playerid, 0, 0, 2093.7747, -1806.4586, 13.5499, 87.6500, 0, 0, 0, 0, 0, 0);
		SetPlayerVirtualWorld(playerid, playerid);
		SpawnPlayer(playerid);

        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,WHITE"Login",WHITE"Masukan Password untuk login ke akun!","Login","Keluar");
	}
	else
	{
		// Spawn player
		SetSpawnInfo(playerid, 0, 0,2093.7747,-1806.4586,13.5499,87.6500, 0, 0, 0, 0, 0, 0);
		SetPlayerVirtualWorld(playerid, playerid);
		SpawnPlayer(playerid);

        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""WHITE"SILAHKAN DAFTAR",""WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
	}
	return 1;

}

resetPlayerVariable(playerid){
	PlayerInfo[playerid][lastGlobalChat] = 0;
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

	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, 100);

	tambahSkinPlayer(playerid, registerInfo[playerid][freeSkinID]);
	return 1;
}

dialogEmail(playerid){
	ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", WHITE"Masukan email anda, kami hanya mensupport email "RED"@gmail.com\n:", "Simpan", "Keluar");
}

forward spawnPemain(playerid);
public spawnPemain(playerid)
{
	if(!(PlayerInfo[playerid][last_x] == 0 && PlayerInfo[playerid][last_y] == 0 && PlayerInfo[playerid][last_z] == 0 && PlayerInfo[playerid][last_a] == 0)){
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], PlayerInfo[playerid][last_x], PlayerInfo[playerid][last_y], PlayerInfo[playerid][last_z], PlayerInfo[playerid][last_a], 0, 0, 0, 0, 0, 0);
		SetPlayerFacingAngle(playerid, PlayerInfo[playerid][last_a]);

		SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][last_vw]);
		SetPlayerInterior(playerid, PlayerInfo[playerid][last_int]);

		PlayerInfo[playerid][last_x] = 0;
		PlayerInfo[playerid][last_y] = 0;
		PlayerInfo[playerid][last_z] = 0;
		PlayerInfo[playerid][last_a] = 0;
		PlayerInfo[playerid][last_vw] = 0;
		PlayerInfo[playerid][last_int] = 0;
	}else{
		new random_spawn = random(sizeof(SPAWN_POINT));
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], SPAWN_POINT[random_spawn][SPAWN_POINT_X], SPAWN_POINT[random_spawn][SPAWN_POINT_Y], SPAWN_POINT[random_spawn][SPAWN_POINT_Z], SPAWN_POINT[random_spawn][SPAWN_POINT_A], 0, 0, 0, 0, 0, 0);

		SetPlayerVirtualWorld(playerid, SPAWN_POINT[random_spawn][SPAWN_POINT_VW]);
		SetPlayerInterior(playerid, SPAWN_POINT[random_spawn][SPAWN_POINT_INTERIOR]);
	}
	SpawnPlayer(playerid);
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
		new id_phone, id_user_item, itemid = MasterItem[listitem][itemID], old_nama_item[100], pesan[256];
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
		
		
		format(pesan, sizeof(pesan), WHITE"Anda berhasil menggunakan "GREEN"%s "WHITE"!\n", MasterItem[listitem][namaItem]);
		
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
	}
	return 1;
}

forward tambahSkinPlayer(playerid, skinid);
public tambahSkinPlayer(playerid, skinid)
{
	mysql_format(koneksi, query, sizeof(query), "INSERT INTO `user_skin` (id_user, id_skin) VALUES('%d', '%d')", PlayerInfo[playerid][pID], skinid);
	mysql_tquery(koneksi, query);
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
	new rows, subString[64], id_item, jumlah, idx, bool:stored = false;
	new string[MAX_MS_ITEM * 64];
	
	cache_get_row_count(rows);
	idx = (rows > 0 ? 0 : -1);

	for(new i = 0; i < MAX_MS_ITEM; i++){
		format(subString, sizeof(subString), "%i\t%s~n~", MasterItem[i][modelID], MasterItem[i][namaItem]);
		strcat(string, subString);

		if(idx != -1 && idx < rows){
			if(stored == false){
				cache_get_value_name_int(idx, "id_item", id_item);
				cache_get_value_name_int(idx, "jumlah", jumlah);
				stored = true;
			}
		}
		if(idx != -1 && MasterItem[i][itemID] == id_item){
			format(subString, sizeof(subString), "~g~%i\n", jumlah);
			strcat(string, subString);

			stored = false;
			idx++;

			if(idx >= rows) idx = -1;
		}else{
			format(subString, sizeof(subString), "~r~0\n");
			strcat(string, subString);
		}
    }
	ShowPlayerDialog(playerid, DIALOG_PILIH_ITEM, DIALOG_STYLE_PREVIEW_MODEL, "~w~Pilih barang anda :", string, "~w~Pilih", "Keluar");
	return 1; // For deleteing cache tquery
}

forward tambahItemPlayer(playerid, itemid, jumlah);
public tambahItemPlayer(playerid, itemid, jumlah){
	mysql_format(koneksi, query, sizeof(query), "INSERT INTO `user_item` (id_user, id_item, jumlah) VALUES('%d', '%d', '%d') ON DUPLICATE KEY UPDATE `jumlah` = `jumlah` + '%d'", PlayerInfo[playerid][pID], itemid, jumlah, jumlah);
	mysql_tquery(koneksi, query);
	return 1;
}

forward cekJumlahItem(playerid, listitem);
public cekJumlahItem(playerid, listitem){
	if(cache_num_rows()){
		new jumlah;
		cache_get_value_name_int(0, "jumlah", jumlah);

		if(jumlah > 0){
			SetPVarInt(playerid, "inv_indexlist", listitem);
			SetPVarInt(playerid, "inv_model", MasterItem[listitem][modelID]);
			SetPVarInt(playerid, "inv_jumlah", jumlah);
			SetPVarString(playerid, "inv_keterangan", MasterItem[listitem][keteranganItem]);

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

updateOnPlayerDisconnect(playerid){
	// new temp_value[256];

	// Position
	new Float:last_spawn_info_x, Float:last_spawn_info_y, Float:last_spawn_info_z, Float:last_spawn_info_a, last_spawn_info_int, last_spawn_info_vw;
	GetPlayerPos(playerid, last_spawn_info_x, last_spawn_info_y, last_spawn_info_z);
	GetPlayerFacingAngle(playerid, last_spawn_info_a);
	last_spawn_info_vw = GetPlayerVirtualWorld(playerid);
	last_spawn_info_int = GetPlayerInterior(playerid);

	// Uang
	new str_uang[100];
	valstr(str_uang, GetPlayerMoney(playerid));

	mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET last_x = '%f', last_y = '%f', last_z = '%f',last_a = '%f', last_int = '%d', last_vw = '%d', uang = '%s' WHERE id = '%d'", last_spawn_info_x, last_spawn_info_y, last_spawn_info_z, last_spawn_info_a, last_spawn_info_int, last_spawn_info_vw, str_uang, PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, query);
	return 1;
}

loadAllItem(){
	new id_item, model_id, nama_item[256], keterangan_item[500];
	new Cache:result, row, idx = 0;
	result = mysql_query(koneksi, "SELECT * FROM `item`");
	cache_get_row_count(row);
	if(row != MAX_MS_ITEM){
		printf("[ERROR] Size item pada database tidak sama dengan defined variable MAX_MS_ITEM, ganti terlebih dahulu!\nInfo : [defined] = %d, [database] = %d", MAX_MS_ITEM, row);
		SendRconCommand("exit");
	}
	while(idx < row){
		cache_get_value_name_int(idx, "id_item", id_item);
		cache_get_value_name_int(idx, "model_id", model_id);
		cache_get_value_name(idx, "nama_item", nama_item);
		cache_get_value_name(idx, "keterangan", keterangan_item);
		MasterItem[idx][itemID] = id_item;
		MasterItem[idx][modelID] = model_id;
		format(MasterItem[idx][namaItem], 256, "%s", nama_item);
		format(MasterItem[idx][keteranganItem], 500, "%s", keterangan_item);
		idx++;
	}
	cache_delete(result);
}