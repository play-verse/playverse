/*
    Hide and Show Textdraw
*/
// My Info Textdraw
tampilkanTextDrawMyInfo(playerid){
    new string[256],
        str_jenis_kelamin[50],
        str_ephone[50],
        str_nomor_hp[31];

    if(PlayerInfo[playerid][jenisKelamin] == 0) format(str_jenis_kelamin, 50, "~b~Laki-laki");
    else format(str_jenis_kelamin, 50, "~r~Perempuan");

    if(PlayerInfo[playerid][ePhone] == 0) format(str_ephone, 50, "~r~Tidak ada");
    else format(str_ephone, 50, "~g~%s", MasterItem[PlayerInfo[playerid][ePhone]-1][namaItem]);

    if(isnull(PlayerInfo[playerid][nomorHP])) format(str_nomor_hp, 30, "~r~Tidak ada");
    else format(str_nomor_hp, 30, "~g~%s", PlayerInfo[playerid][nomorHP]);

	// Atur
	PlayerTextDrawSetPreviewModel(playerid, myInfo[playerid][1], PlayerInfo[playerid][skinID]);

	format(string, sizeof(string), "Nama : ~g~%s", PlayerInfo[playerid][pPlayerName]);
	PlayerTextDrawSetString(playerid, myInfo[playerid][3], string);	

	format(string, sizeof(string), "Jenis Kelamin : %s", str_jenis_kelamin);
	PlayerTextDrawSetString(playerid, myInfo[playerid][4], string);	

    // Nomor HP
	format(string, sizeof(string), "Nomor HP : ~g~%s", str_nomor_hp);
	PlayerTextDrawSetString(playerid, myInfo[playerid][5], string);	

    // Jenis HP
	format(string, sizeof(string), "Jenis HP : %s", str_ephone);
	PlayerTextDrawSetString(playerid, myInfo[playerid][6], string);	

	// Tampilkan
	PlayerTextDrawShow(playerid, myInfo[playerid][0]);
	PlayerTextDrawShow(playerid, myInfo[playerid][1]);
	PlayerTextDrawShow(playerid, myInfo[playerid][2]);
	PlayerTextDrawShow(playerid, myInfo[playerid][3]);
	PlayerTextDrawShow(playerid, myInfo[playerid][4]);
	PlayerTextDrawShow(playerid, myInfo[playerid][5]);
	PlayerTextDrawShow(playerid, myInfo[playerid][6]);
	PlayerTextDrawShow(playerid, myInfo[playerid][7]);

	SelectTextDraw(playerid, COLOR_RED);
	return 1;
}

hideTextDrawMyInfo(playerid){
	PlayerTextDrawHide(playerid, myInfo[playerid][0]);
	PlayerTextDrawHide(playerid, myInfo[playerid][1]);
	PlayerTextDrawHide(playerid, myInfo[playerid][2]);
	PlayerTextDrawHide(playerid, myInfo[playerid][3]);
	PlayerTextDrawHide(playerid, myInfo[playerid][4]);
	PlayerTextDrawHide(playerid, myInfo[playerid][5]);
	PlayerTextDrawHide(playerid, myInfo[playerid][6]);
	PlayerTextDrawHide(playerid, myInfo[playerid][7]);
	return 1;
}
// End My Info Textdraw

// Show Item Textdraw
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
	PlayerTextDrawShow(playerid, showItem[playerid][0]);
	PlayerTextDrawShow(playerid, showItem[playerid][1]);
	PlayerTextDrawShow(playerid, showItem[playerid][2]);
	PlayerTextDrawShow(playerid, showItem[playerid][3]);
	PlayerTextDrawShow(playerid, showItem[playerid][4]);
	PlayerTextDrawShow(playerid, showItem[playerid][5]);

	SelectTextDraw(playerid, COLOR_RED);

	return 1;
}

hideTextDrawShowItem(playerid){
	PlayerTextDrawHide(playerid, showItem[playerid][0]);
	PlayerTextDrawHide(playerid, showItem[playerid][1]);
	PlayerTextDrawHide(playerid, showItem[playerid][2]);
	PlayerTextDrawHide(playerid, showItem[playerid][3]);
	PlayerTextDrawHide(playerid, showItem[playerid][4]);
	PlayerTextDrawHide(playerid, showItem[playerid][5]);
	return 1;
}
// End Show Item Textdraw

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

	showItem[playerid][3] = CreatePlayerTextDraw(playerid, 284.000000, 212.000000, "Keterangan");
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

    // My Info
    myInfo[playerid][7] = CreatePlayerTextDraw(playerid, 329.000000, 334.000000, "Tutup");
    PlayerTextDrawFont(playerid, myInfo[playerid][7], 2);
    PlayerTextDrawLetterSize(playerid, myInfo[playerid][7], 0.258332, 1.750000);
    PlayerTextDrawTextSize(playerid, myInfo[playerid][7], 16.500000, 90.500000);
    PlayerTextDrawSetOutline(playerid, myInfo[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, myInfo[playerid][7], 0);
    PlayerTextDrawAlignment(playerid, myInfo[playerid][7], 2);
    PlayerTextDrawColor(playerid, myInfo[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, myInfo[playerid][7], 255);
    PlayerTextDrawBoxColor(playerid, myInfo[playerid][7], 200);
    PlayerTextDrawUseBox(playerid, myInfo[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, myInfo[playerid][7], 1);
    PlayerTextDrawSetSelectable(playerid, myInfo[playerid][7], 1);

    myInfo[playerid][0] = CreatePlayerTextDraw(playerid, 327.000000, 76.000000, "_");
    PlayerTextDrawFont(playerid, myInfo[playerid][0], 1);
    PlayerTextDrawLetterSize(playerid, myInfo[playerid][0], 0.858332, 32.100006);
    PlayerTextDrawTextSize(playerid, myInfo[playerid][0], 348.500000, 390.000000);
    PlayerTextDrawSetOutline(playerid, myInfo[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, myInfo[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, myInfo[playerid][0], 2);
    PlayerTextDrawColor(playerid, myInfo[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, myInfo[playerid][0], 255);
    PlayerTextDrawBoxColor(playerid, myInfo[playerid][0], 235);
    PlayerTextDrawUseBox(playerid, myInfo[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, myInfo[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, myInfo[playerid][0], 0);

    myInfo[playerid][1] = CreatePlayerTextDraw(playerid, 339.000000, 114.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, myInfo[playerid][1], 5);
    PlayerTextDrawLetterSize(playerid, myInfo[playerid][1], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, myInfo[playerid][1], 172.500000, 205.000000);
    PlayerTextDrawSetOutline(playerid, myInfo[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, myInfo[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, myInfo[playerid][1], 1);
    PlayerTextDrawColor(playerid, myInfo[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, myInfo[playerid][1], -131);
    PlayerTextDrawBoxColor(playerid, myInfo[playerid][1], 255);
    PlayerTextDrawUseBox(playerid, myInfo[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, myInfo[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, myInfo[playerid][1], 0);
    PlayerTextDrawSetPreviewModel(playerid, myInfo[playerid][1], 0);
    PlayerTextDrawSetPreviewRot(playerid, myInfo[playerid][1], 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, myInfo[playerid][1], 1, 1);

    myInfo[playerid][2] = CreatePlayerTextDraw(playerid, 146.000000, 83.000000, "My Info");
    PlayerTextDrawFont(playerid, myInfo[playerid][2], 1);
    PlayerTextDrawLetterSize(playerid, myInfo[playerid][2], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, myInfo[playerid][2], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, myInfo[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, myInfo[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, myInfo[playerid][2], 1);
    PlayerTextDrawColor(playerid, myInfo[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, myInfo[playerid][2], 255);
    PlayerTextDrawBoxColor(playerid, myInfo[playerid][2], 50);
    PlayerTextDrawUseBox(playerid, myInfo[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, myInfo[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, myInfo[playerid][2], 0);

    myInfo[playerid][3] = CreatePlayerTextDraw(playerid, 144.000000, 120.000000, "Nama : tes");
    PlayerTextDrawFont(playerid, myInfo[playerid][3], 1);
    PlayerTextDrawLetterSize(playerid, myInfo[playerid][3], 0.354166, 1.500000);
    PlayerTextDrawTextSize(playerid, myInfo[playerid][3], 325.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, myInfo[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, myInfo[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, myInfo[playerid][3], 1);
    PlayerTextDrawColor(playerid, myInfo[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, myInfo[playerid][3], 255);
    PlayerTextDrawBoxColor(playerid, myInfo[playerid][3], 50);
    PlayerTextDrawUseBox(playerid, myInfo[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, myInfo[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, myInfo[playerid][3], 0);

    myInfo[playerid][4] = CreatePlayerTextDraw(playerid, 144.000000, 148.000000, "Jenis Kelamin : Laki Laki");
    PlayerTextDrawFont(playerid, myInfo[playerid][4], 1);
    PlayerTextDrawLetterSize(playerid, myInfo[playerid][4], 0.354166, 1.500000);
    PlayerTextDrawTextSize(playerid, myInfo[playerid][4], 325.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, myInfo[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, myInfo[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, myInfo[playerid][4], 1);
    PlayerTextDrawColor(playerid, myInfo[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, myInfo[playerid][4], 255);
    PlayerTextDrawBoxColor(playerid, myInfo[playerid][4], 50);
    PlayerTextDrawUseBox(playerid, myInfo[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, myInfo[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, myInfo[playerid][4], 0);

    myInfo[playerid][5] = CreatePlayerTextDraw(playerid, 144.000000, 164.000000, "Nomor HP : 62123456");
    PlayerTextDrawFont(playerid, myInfo[playerid][5], 1);
    PlayerTextDrawLetterSize(playerid, myInfo[playerid][5], 0.354166, 1.500000);
    PlayerTextDrawTextSize(playerid, myInfo[playerid][5], 325.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, myInfo[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, myInfo[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, myInfo[playerid][5], 1);
    PlayerTextDrawColor(playerid, myInfo[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, myInfo[playerid][5], 255);
    PlayerTextDrawBoxColor(playerid, myInfo[playerid][5], 50);
    PlayerTextDrawUseBox(playerid, myInfo[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, myInfo[playerid][5], 1);
    PlayerTextDrawSetSelectable(playerid, myInfo[playerid][5], 0);

    myInfo[playerid][6] = CreatePlayerTextDraw(playerid, 144.000000, 180.000000, "Jenis HP : ePhone 4");
    PlayerTextDrawFont(playerid, myInfo[playerid][6], 1);
    PlayerTextDrawLetterSize(playerid, myInfo[playerid][6], 0.354166, 1.500000);
    PlayerTextDrawTextSize(playerid, myInfo[playerid][6], 325.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, myInfo[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, myInfo[playerid][6], 0);
    PlayerTextDrawAlignment(playerid, myInfo[playerid][6], 1);
    PlayerTextDrawColor(playerid, myInfo[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, myInfo[playerid][6], 255);
    PlayerTextDrawBoxColor(playerid, myInfo[playerid][6], 50);
    PlayerTextDrawUseBox(playerid, myInfo[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, myInfo[playerid][6], 1);
    PlayerTextDrawSetSelectable(playerid, myInfo[playerid][6], 0);
    // End My Info
}