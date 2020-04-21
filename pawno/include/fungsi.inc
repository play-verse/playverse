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
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,COL_WHITE"Login",COL_WHITE"Masukan Password untuk login ke akun!","Login","Keluar");
	}
	else
	{
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""COL_WHITE"SILAHKAN DAFTAR",""COL_WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
	}
	return 1;

}

pindahkanKameraKePemilihanKelas(playerid){
    SetPlayerInterior(playerid,11);
    SetPlayerPos(playerid,508.7362,-87.4335,998.9609);
    SetPlayerFacingAngle(playerid,0.0);
    SetPlayerCameraPos(playerid,508.7362,-83.4335,998.9609);
    SetPlayerCameraLookAt(playerid,508.7362,-87.4335,998.9609);
}

resetPlayerVariable(playerid){
	PlayerInfo[playerid][lastGlobalChat] = 0;
}

forward registerUser(playerid, password[]);
public registerUser(playerid, password[])
{
	new EncryptedPassword[65];
	SHA256_PassHash(password, PlayerInfo[playerid][pPlayerName], EncryptedPassword, 64);

	new Cache:result;
	mysql_format(koneksi, query, sizeof(query), "INSERT INTO `user` (`nama`, `password`, `jumlah_login`) VALUES ('%e', '%e', '1')", PlayerInfo[playerid][pPlayerName], EncryptedPassword);
	result = mysql_query(koneksi, query);
	PlayerInfo[playerid][pID] = cache_insert_id();
	PlayerInfo[playerid][loginKe] = 1;
    cache_delete(result);
	return 1;
}

forward spawnPemain(playerid);
public spawnPemain(playerid)
{
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