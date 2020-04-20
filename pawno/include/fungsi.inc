forward isRegistered(playerid);
public isRegistered(playerid)
{
	if(cache_num_rows()) // IsRegistered
	{
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

forward registerUser(playerid, password[]);
public registerUser(playerid, password[])
{
	new EncryptedPassword[65];
	SHA256_PassHash(password, PlayerInfo[playerid][pPlayerName], EncryptedPassword, 64);

	new Cache:result;
	mysql_format(koneksi, query, sizeof(query), "INSERT INTO `user` (`nama`, `password`) VALUES ('%e', '%e')", PlayerInfo[playerid][pPlayerName], EncryptedPassword);
	result = mysql_query(koneksi, query);
	PlayerInfo[playerid][pID] = cache_insert_id();
    cache_delete(result);
    //	SpawnPlayer(playerid); // Goes to Skin Selection
	return 1;
}