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

		cache_get_value_name(0, "uang", PlayerInfo[playerid][uang]);
		// Reset dulu uangnya, saat berhasil login baru beri uang
		ResetPlayerMoney(playerid);

		// Pindahkan player
		SetSpawnInfo(playerid, 0, 0,2093.7747,-1806.4586,13.5499,87.6500, 0, 0, 0, 0, 0, 0);
		SetPlayerVirtualWorld(playerid, playerid);
		SpawnPlayer(playerid);

        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,COL_WHITE"Login",COL_WHITE"Masukan Password untuk login ke akun!","Login","Keluar");
	}
	else
	{
		// Spawn player
		SetSpawnInfo(playerid, 0, 0,2093.7747,-1806.4586,13.5499,87.6500, 0, 0, 0, 0, 0, 0);
		SetPlayerVirtualWorld(playerid, playerid);
		SpawnPlayer(playerid);

        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""COL_WHITE"SILAHKAN DAFTAR",""COL_WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
	}
	return 1;

}

resetPlayerVariable(playerid){
	PlayerInfo[playerid][lastGlobalChat] = 0;
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
	ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", COL_WHITE"Masukan email anda, kami hanya mensupport email "COL_RED"@gmail.com\n:", "Simpan Email", "Keluar");
}

forward spawnPemain(playerid);
public spawnPemain(playerid)
{
	SetPlayerVirtualWorld(playerid, 0);
	SpawnPlayer(playerid);	
}



forward updatePlayerCurrentSkin(playerid, skinid);
public updatePlayerCurrentSkin(playerid, skinid){
	mysql_format(koneksi, query, sizeof(query), "SELECT * FROM `user_skin` WHERE id_skin = '%d' AND id_user = '%d'", skinid, PlayerInfo[playerid][pID]);
	return mysql_tquery(koneksi, query, "checkIfSkinExist", "dd", playerid, skinid);
}

forward checkIfSkinExist(playerid, skinid);
public checkIfSkinExist(playerid, skinid){
	if(cache_num_rows()){
		mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET current_skin = '%d' WHERE id = '%d'",skinid, PlayerInfo[playerid][pID]);
		return mysql_tquery(koneksi, query);
	}
	return 0;
}

forward tambahSkinPlayer(playerid, skinid);
public tambahSkinPlayer(playerid, skinid)
{
	mysql_format(koneksi, query, sizeof(query), "INSERT INTO `user_skin` (id_user, id_skin) VALUES('%d', '%d')", PlayerInfo[playerid][pID], skinid);
	mysql_tquery(koneksi, query);
	return 1;
}