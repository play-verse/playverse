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

		cache_get_value_name(0, "uang", PlayerInfo[playerid][uang]);
		// Reset dulu uangnya, saat berhasil login baru beri uang
		ResetPlayerMoney(playerid);

		// Pindahkan player
		SetSpawnInfo(playerid, 0, 0,2093.7747,-1806.4586,13.5499,87.6500, 0, 0, 0, 0, 0, 0);
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
	SetPlayerVirtualWorld(playerid, 0);
	SpawnPlayer(playerid);	
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

tampilkanTextDrawShowItem(playerid, model_id, jumlah, keterangan[], nama_pemilik[]){
	new string[128];
	// Atur
	PlayerTextDrawSetPreviewModel(playerid, showItem[playerid][0], model_id);
	
	format(string, sizeof(string), "Info Item Milik ~g~ %s", nama_pemilik);
	PlayerTextDrawSetString(playerid, showItem[playerid][1], string);


	format(string, sizeof(string), "Jumlah Item : ~g~ %d", jumlah);
	PlayerTextDrawSetString(playerid, showItem[playerid][2], string);	

	format(string, sizeof(string), "Keterangan : ~n~%s", keterangan);
	PlayerTextDrawSetString(playerid, showItem[playerid][3], string);	

	// Tampilkan
	PlayerTextDrawShow(playerid, showItem[playerid][5]);
	PlayerTextDrawShow(playerid, showItem[playerid][0]);
	PlayerTextDrawShow(playerid, showItem[playerid][1]);
	PlayerTextDrawShow(playerid, showItem[playerid][2]);
	PlayerTextDrawShow(playerid, showItem[playerid][3]);
	PlayerTextDrawShow(playerid, showItem[playerid][4]);

	SelectTextDraw(playerid, COLOR_RED);

	return 1;
}

hideTextDrawShowItem(playerid){
	PlayerTextDrawHide(playerid, showItem[playerid][5]);
	PlayerTextDrawHide(playerid, showItem[playerid][0]);
	PlayerTextDrawHide(playerid, showItem[playerid][1]);
	PlayerTextDrawHide(playerid, showItem[playerid][2]);
	PlayerTextDrawHide(playerid, showItem[playerid][3]);
	PlayerTextDrawHide(playerid, showItem[playerid][4]);
	return 1;
}

/**
	Load Textdraw For Player
 */
loadTextDrawPemain(playerid){
	// Show Item Textdraw

	showItem[playerid][5] = CreatePlayerTextDraw(playerid, 314.000000, 98.000000, "_");
	PlayerTextDrawFont(playerid, showItem[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, showItem[playerid][5], 10.804163, 27.150005);
	PlayerTextDrawTextSize(playerid, showItem[playerid][5], 40.000000, 356.000000);
	PlayerTextDrawSetOutline(playerid, showItem[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, showItem[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, showItem[playerid][5], 2);
	PlayerTextDrawColor(playerid, showItem[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, showItem[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, showItem[playerid][5], 207);
	PlayerTextDrawUseBox(playerid, showItem[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, showItem[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, showItem[playerid][5], 0);

	showItem[playerid][0] = CreatePlayerTextDraw(playerid, 157.000000, 145.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, showItem[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, showItem[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, showItem[playerid][0], 112.500000, 150.000000);
	PlayerTextDrawSetOutline(playerid, showItem[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, showItem[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, showItem[playerid][0], 1);
	PlayerTextDrawColor(playerid, showItem[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, showItem[playerid][0], -131);
	PlayerTextDrawBoxColor(playerid, showItem[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, showItem[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, showItem[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, showItem[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, showItem[playerid][0], 0);
	PlayerTextDrawSetPreviewRot(playerid, showItem[playerid][0], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, showItem[playerid][0], 1, 1);

	showItem[playerid][1] = CreatePlayerTextDraw(playerid, 143.000000, 110.000000, "INFO ITEM ~G~ COSINUS");
	PlayerTextDrawFont(playerid, showItem[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, showItem[playerid][1], 0.412499, 2.199999);
	PlayerTextDrawTextSize(playerid, showItem[playerid][1], 484.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, showItem[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, showItem[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, showItem[playerid][1], 1);
	PlayerTextDrawColor(playerid, showItem[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, showItem[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, showItem[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, showItem[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, showItem[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, showItem[playerid][1], 0);

	showItem[playerid][2] = CreatePlayerTextDraw(playerid, 284.000000, 167.000000, "Jumlah Item");
	PlayerTextDrawFont(playerid, showItem[playerid][2], 2);
	PlayerTextDrawLetterSize(playerid, showItem[playerid][2], 0.245830, 1.799998);
	PlayerTextDrawTextSize(playerid, showItem[playerid][2], 404.000000, 15.000000);
	PlayerTextDrawSetOutline(playerid, showItem[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, showItem[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, showItem[playerid][2], 1);
	PlayerTextDrawColor(playerid, showItem[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, showItem[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, showItem[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, showItem[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, showItem[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, showItem[playerid][2], 0);

	showItem[playerid][3] = CreatePlayerTextDraw(playerid, 284.000000, 212.000000, "Keterangan : ~n~asdasd~n~asdasd~n~askdjaskj qkwjel kq");
	PlayerTextDrawFont(playerid, showItem[playerid][3], 2);
	PlayerTextDrawLetterSize(playerid, showItem[playerid][3], 0.258332, 1.600000);
	PlayerTextDrawTextSize(playerid, showItem[playerid][3], 483.500000, 140.500000);
	PlayerTextDrawSetOutline(playerid, showItem[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, showItem[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, showItem[playerid][3], 1);
	PlayerTextDrawColor(playerid, showItem[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, showItem[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, showItem[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, showItem[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, showItem[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, showItem[playerid][3], 0);

	showItem[playerid][4] = CreatePlayerTextDraw(playerid, 310.000000, 315.000000, "TUTUP");
	PlayerTextDrawFont(playerid, showItem[playerid][4], 2);
	PlayerTextDrawLetterSize(playerid, showItem[playerid][4], 0.258332, 1.750000);
	PlayerTextDrawTextSize(playerid, showItem[playerid][4], 16.500000, 90.500000);
	PlayerTextDrawSetOutline(playerid, showItem[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, showItem[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, showItem[playerid][4], 2);
	PlayerTextDrawColor(playerid, showItem[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, showItem[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, showItem[playerid][4], 200);
	PlayerTextDrawUseBox(playerid, showItem[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, showItem[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, showItem[playerid][4], 1);

	// End Show Item
}