/*
    Hide and Show Textdraw
*/
// My Info Textdraw
tampilkanTextDrawMyInfo(playerid){
    new string[256],
        str_jenis_kelamin[50],
        str_ephone[50],
        str_nomor_hp[31],
		nama_item[256];

    if(PlayerInfo[playerid][jenisKelamin] == 0) format(str_jenis_kelamin, 50, "~b~Laki-laki");
    else format(str_jenis_kelamin, 50, "~r~Perempuan");

    if(PlayerInfo[playerid][ePhone] == 0) format(str_ephone, 50, "~r~Tidak ada");
    else {
		getNamaByIdItem(PlayerInfo[playerid][ePhone], nama_item);
		format(str_ephone, 50, "~g~%s", nama_item);
	}

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
	PlayerInfo[playerid][onSelectedTextdraw] = true;
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

loadTextdrawGlobal(){
	// HUD Stats
	HUD_Stats_PB[4] = TextDrawCreate(567.000000, 328.000000, "_");
	TextDrawFont(HUD_Stats_PB[4], 1);
	TextDrawLetterSize(HUD_Stats_PB[4], 0.600000, 13.800003);
	TextDrawTextSize(HUD_Stats_PB[4], 178.500000, 148.500000);
	TextDrawSetOutline(HUD_Stats_PB[4], 1);
	TextDrawSetShadow(HUD_Stats_PB[4], 0);
	TextDrawAlignment(HUD_Stats_PB[4], 2);
	TextDrawColor(HUD_Stats_PB[4], -1);
	TextDrawBackgroundColor(HUD_Stats_PB[4], 255);
	TextDrawBoxColor(HUD_Stats_PB[4], 135);
	TextDrawUseBox(HUD_Stats_PB[4], 1);
	TextDrawSetProportional(HUD_Stats_PB[4], 1);
	TextDrawSetSelectable(HUD_Stats_PB[4], 0);

	HUD_Stats_PB[0] = TextDrawCreate(502.000000, 344.000000, "~w~Makan");
	TextDrawFont(HUD_Stats_PB[0], 1);
	TextDrawLetterSize(HUD_Stats_PB[0], 0.400000, 1.649999);
	TextDrawTextSize(HUD_Stats_PB[0], 400.000000, 17.000000);
	TextDrawSetOutline(HUD_Stats_PB[0], 1);
	TextDrawSetShadow(HUD_Stats_PB[0], 0);
	TextDrawAlignment(HUD_Stats_PB[0], 1);
	TextDrawColor(HUD_Stats_PB[0], COLOR_WHITE);
	TextDrawBackgroundColor(HUD_Stats_PB[0], 255);
	TextDrawBoxColor(HUD_Stats_PB[0], 50);
	TextDrawUseBox(HUD_Stats_PB[0], 0);
	TextDrawSetProportional(HUD_Stats_PB[0], 1);
	TextDrawSetSelectable(HUD_Stats_PB[0], 0);

	HUD_Stats_PB[1] = TextDrawCreate(562.000000, 344.000000, "HUD:radar_pizza");
	TextDrawFont(HUD_Stats_PB[1], 4);
	TextDrawLetterSize(HUD_Stats_PB[1], 0.600000, 2.000000);
	TextDrawTextSize(HUD_Stats_PB[1], 15.500000, 14.000000);
	TextDrawSetOutline(HUD_Stats_PB[1], 1);
	TextDrawSetShadow(HUD_Stats_PB[1], 0);
	TextDrawAlignment(HUD_Stats_PB[1], 1);
	TextDrawColor(HUD_Stats_PB[1], -1);
	TextDrawBackgroundColor(HUD_Stats_PB[1], 255);
	TextDrawBoxColor(HUD_Stats_PB[1], 50);
	TextDrawUseBox(HUD_Stats_PB[1], 1);
	TextDrawSetProportional(HUD_Stats_PB[1], 1);
	TextDrawSetSelectable(HUD_Stats_PB[1], 0);

	HUD_Stats_PB[2] = TextDrawCreate(502.000000, 391.000000, "~w~Minum");
	TextDrawFont(HUD_Stats_PB[2], 1);
	TextDrawLetterSize(HUD_Stats_PB[2], 0.400000, 1.649999);
	TextDrawTextSize(HUD_Stats_PB[2], 400.000000, 17.000000);
	TextDrawSetOutline(HUD_Stats_PB[2], 1);
	TextDrawSetShadow(HUD_Stats_PB[2], 0);
	TextDrawAlignment(HUD_Stats_PB[2], 1);
	TextDrawColor(HUD_Stats_PB[2], COLOR_WHITE);
	TextDrawBackgroundColor(HUD_Stats_PB[2], 255);
	TextDrawBoxColor(HUD_Stats_PB[2], 50);
	TextDrawUseBox(HUD_Stats_PB[2], 0);
	TextDrawSetProportional(HUD_Stats_PB[2], 1);
	TextDrawSetSelectable(HUD_Stats_PB[2], 0);

	HUD_Stats_PB[3] = TextDrawCreate(562.000000, 391.000000, "HUD:radar_diner");
	TextDrawFont(HUD_Stats_PB[3], 4);
	TextDrawLetterSize(HUD_Stats_PB[3], 0.600000, 2.000000);
	TextDrawTextSize(HUD_Stats_PB[3], 15.500000, 14.000000);
	TextDrawSetOutline(HUD_Stats_PB[3], 1);
	TextDrawSetShadow(HUD_Stats_PB[3], 0);
	TextDrawAlignment(HUD_Stats_PB[3], 1);
	TextDrawColor(HUD_Stats_PB[3], -1);
	TextDrawBackgroundColor(HUD_Stats_PB[3], 255);
	TextDrawBoxColor(HUD_Stats_PB[3], 50);
	TextDrawUseBox(HUD_Stats_PB[3], 1);
	TextDrawSetProportional(HUD_Stats_PB[3], 1);
	TextDrawSetSelectable(HUD_Stats_PB[3], 0);
	// End HUD

	// Global Time
	TD_JamTanggal[0] = TextDrawCreate(548.000000, 24.000000, "00:00:00");
	TextDrawFont(TD_JamTanggal[0], 3);
	TextDrawLetterSize(TD_JamTanggal[0], 0.395833, 1.700000);
	TextDrawTextSize(TD_JamTanggal[0], 400.000000, 17.000000);
	TextDrawSetOutline(TD_JamTanggal[0], 1);
	TextDrawSetShadow(TD_JamTanggal[0], 0);
	TextDrawAlignment(TD_JamTanggal[0], 1);
	TextDrawColor(TD_JamTanggal[0], -1);
	TextDrawBackgroundColor(TD_JamTanggal[0], 255);
	TextDrawBoxColor(TD_JamTanggal[0], 50);
	TextDrawUseBox(TD_JamTanggal[0], 0);
	TextDrawSetProportional(TD_JamTanggal[0], 1);
	TextDrawSetSelectable(TD_JamTanggal[0], 0);

	TD_JamTanggal[1] = TextDrawCreate(501.000000, 10.000000, "Rabu, 10 20 2000");
	TextDrawFont(TD_JamTanggal[1], 3);
	TextDrawLetterSize(TD_JamTanggal[1], 0.404166, 1.400000);
	TextDrawTextSize(TD_JamTanggal[1], 859.500000, -250.000000);
	TextDrawSetOutline(TD_JamTanggal[1], 1);
	TextDrawSetShadow(TD_JamTanggal[1], 0);
	TextDrawAlignment(TD_JamTanggal[1], 1);
	TextDrawColor(TD_JamTanggal[1], -1);
	TextDrawBackgroundColor(TD_JamTanggal[1], 255);
	TextDrawBoxColor(TD_JamTanggal[1], 50);
	TextDrawUseBox(TD_JamTanggal[1], 0);
	TextDrawSetProportional(TD_JamTanggal[1], 1);
	TextDrawSetSelectable(TD_JamTanggal[1], 0);
	// End Global Time

	// Begin Global Speedo TD
	SpeedoTD[0] = TextDrawCreate(312.000000, 353.000000, "_");
	TextDrawFont(SpeedoTD[0], 1);
	TextDrawLetterSize(SpeedoTD[0], 0.600000, 10.300003);
	TextDrawTextSize(SpeedoTD[0], 402.000000, 168.500000);
	TextDrawSetOutline(SpeedoTD[0], 1);
	TextDrawSetShadow(SpeedoTD[0], 0);
	TextDrawAlignment(SpeedoTD[0], 2);
	TextDrawColor(SpeedoTD[0], -1);
	TextDrawBackgroundColor(SpeedoTD[0], 255);
	TextDrawBoxColor(SpeedoTD[0], 135);
	TextDrawUseBox(SpeedoTD[0], 1);
	TextDrawSetProportional(SpeedoTD[0], 1);
	TextDrawSetSelectable(SpeedoTD[0], 0);

	SpeedoTD[1] = TextDrawCreate(241.000000, 393.000000, "HUD:radar_impound");
	TextDrawFont(SpeedoTD[1], 4);
	TextDrawLetterSize(SpeedoTD[1], 0.600000, 2.000000);
	TextDrawTextSize(SpeedoTD[1], 17.000000, 17.000000);
	TextDrawSetOutline(SpeedoTD[1], 1);
	TextDrawSetShadow(SpeedoTD[1], 0);
	TextDrawAlignment(SpeedoTD[1], 1);
	TextDrawColor(SpeedoTD[1], -1);
	TextDrawBackgroundColor(SpeedoTD[1], 255);
	TextDrawBoxColor(SpeedoTD[1], 50);
	TextDrawUseBox(SpeedoTD[1], 1);
	TextDrawSetProportional(SpeedoTD[1], 1);
	TextDrawSetSelectable(SpeedoTD[1], 0);

	SpeedoTD[2] = TextDrawCreate(240.000000, 421.000000, "HUD:radar_girlfriend");
	TextDrawFont(SpeedoTD[2], 4);
	TextDrawLetterSize(SpeedoTD[2], 0.600000, 2.000000);
	TextDrawTextSize(SpeedoTD[2], 17.000000, 17.000000);
	TextDrawSetOutline(SpeedoTD[2], 1);
	TextDrawSetShadow(SpeedoTD[2], 0);
	TextDrawAlignment(SpeedoTD[2], 1);
	TextDrawColor(SpeedoTD[2], -1);
	TextDrawBackgroundColor(SpeedoTD[2], 255);
	TextDrawBoxColor(SpeedoTD[2], 50);
	TextDrawUseBox(SpeedoTD[2], 1);
	TextDrawSetProportional(SpeedoTD[2], 1);
	TextDrawSetSelectable(SpeedoTD[2], 0);

	SpeedoTD[3] = TextDrawCreate(375.000000, 372.000000, "~g~Km~w~/~r~Jam");
	TextDrawFont(SpeedoTD[3], 3);
	TextDrawLetterSize(SpeedoTD[3], 0.316666, 1.700000);
	TextDrawTextSize(SpeedoTD[3], 400.000000, 17.000000);
	TextDrawSetOutline(SpeedoTD[3], 1);
	TextDrawSetShadow(SpeedoTD[3], 0);
	TextDrawAlignment(SpeedoTD[3], 3);
	TextDrawColor(SpeedoTD[3], -1);
	TextDrawBackgroundColor(SpeedoTD[3], 255);
	TextDrawBoxColor(SpeedoTD[3], 50);
	TextDrawUseBox(SpeedoTD[3], 0);
	TextDrawSetProportional(SpeedoTD[3], 1);
	TextDrawSetSelectable(SpeedoTD[3], 0);
	// End Global Speedo TD
}

unloadTextdrawGlobal(){
	TextDrawDestroy(HUD_Stats_PB[0]);
	TextDrawDestroy(HUD_Stats_PB[1]);
	TextDrawDestroy(HUD_Stats_PB[2]);
	TextDrawDestroy(HUD_Stats_PB[3]);
	TextDrawDestroy(HUD_Stats_PB[4]);

	TextDrawDestroy(TD_JamTanggal[0]);
	TextDrawDestroy(TD_JamTanggal[1]);

	TextDrawDestroy(SpeedoTD[0]);
	TextDrawDestroy(SpeedoTD[1]);
	TextDrawDestroy(SpeedoTD[2]);
	TextDrawDestroy(SpeedoTD[3]);
}

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
	PlayerInfo[playerid][onSelectedTextdraw] = true; 
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

tampilkanHUDStats(playerid){
	TextDrawShowForPlayer(playerid, HUD_Stats_PB[0]);
	TextDrawShowForPlayer(playerid, HUD_Stats_PB[1]);
	TextDrawShowForPlayer(playerid, HUD_Stats_PB[2]);
	TextDrawShowForPlayer(playerid, HUD_Stats_PB[3]);
	TextDrawShowForPlayer(playerid, HUD_Stats_PB[4]);

	PlayerTextDrawShow(playerid, HUD_Stats[playerid][0]);

	ShowPlayerProgressBar(playerid, HUD_Stats_Bar[playerid][0]);
	ShowPlayerProgressBar(playerid, HUD_Stats_Bar[playerid][1]);
}

hideHUDStats(playerid){
	TextDrawHideForPlayer(playerid, HUD_Stats_PB[0]);
	TextDrawHideForPlayer(playerid, HUD_Stats_PB[1]);
	TextDrawHideForPlayer(playerid, HUD_Stats_PB[2]);
	TextDrawHideForPlayer(playerid, HUD_Stats_PB[3]);
	TextDrawHideForPlayer(playerid, HUD_Stats_PB[4]);

	PlayerTextDrawHide(playerid, HUD_Stats[playerid][0]);
	
	HidePlayerProgressBar(playerid, HUD_Stats_Bar[playerid][0]);
	HidePlayerProgressBar(playerid, HUD_Stats_Bar[playerid][1]);
}

// Radar Uang
// tampilkanTextDrawUang(playerid){
// 	PlayerTextDrawShow(playerid, RadarUang[playerid][0]);
// 	PlayerTextDrawShow(playerid, RadarUang[playerid][1]);
// }

// hideTextDrawUang(playerid){
// 	PlayerTextDrawHide(playerid, RadarUang[playerid][0]);
// 	PlayerTextDrawHide(playerid, RadarUang[playerid][1]);
// }
// End Radar Uang Textdraw

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

    myInfo[playerid][2] = CreatePlayerTextDraw(playerid, 146.000000, 83.000000, "Informasi saya");
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

	// Radar Uang
	// RadarUang[playerid][0] = CreatePlayerTextDraw(playerid, 455.000000, 80.000000, "$");
	// PlayerTextDrawFont(playerid, RadarUang[playerid][0], 3);
	// PlayerTextDrawLetterSize(playerid, RadarUang[playerid][0], 0.600000, 2.250000);
	// PlayerTextDrawTextSize(playerid, RadarUang[playerid][0], 610.000000, 36.500000);
	// PlayerTextDrawSetOutline(playerid, RadarUang[playerid][0], 1);
	// PlayerTextDrawSetShadow(playerid, RadarUang[playerid][0], 0);
	// PlayerTextDrawAlignment(playerid, RadarUang[playerid][0], 1);
	// PlayerTextDrawColor(playerid, RadarUang[playerid][0], 1097458175);
	// PlayerTextDrawBackgroundColor(playerid, RadarUang[playerid][0], 255);
	// PlayerTextDrawBoxColor(playerid, RadarUang[playerid][0], 1296911868);
	// PlayerTextDrawUseBox(playerid, RadarUang[playerid][0], 1);
	// PlayerTextDrawSetProportional(playerid, RadarUang[playerid][0], 1);
	// PlayerTextDrawSetSelectable(playerid, RadarUang[playerid][0], 0);

	// RadarUang[playerid][1] = CreatePlayerTextDraw(playerid, 606.000000, 81.000000, "0");
	// PlayerTextDrawFont(playerid, RadarUang[playerid][1], 3);
	// PlayerTextDrawLetterSize(playerid, RadarUang[playerid][1], 0.600000, 2.000000);
	// PlayerTextDrawTextSize(playerid, RadarUang[playerid][1], 400.000000, 17.000000);
	// PlayerTextDrawSetOutline(playerid, RadarUang[playerid][1], 1);
	// PlayerTextDrawSetShadow(playerid, RadarUang[playerid][1], 0);
	// PlayerTextDrawAlignment(playerid, RadarUang[playerid][1], 3);
	// PlayerTextDrawColor(playerid, RadarUang[playerid][1], 9109759);
	// PlayerTextDrawBackgroundColor(playerid, RadarUang[playerid][1], 255);
	// PlayerTextDrawBoxColor(playerid, RadarUang[playerid][1], 50);
	// PlayerTextDrawUseBox(playerid, RadarUang[playerid][1], 0);
	// PlayerTextDrawSetProportional(playerid, RadarUang[playerid][1], 1);
	// PlayerTextDrawSetSelectable(playerid, RadarUang[playerid][1], 0);

	// End Radar Uang

	// HUD Stats
	HUD_Stats[playerid][0] = CreatePlayerTextDraw(playerid, 532.000000, 325.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, HUD_Stats[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, HUD_Stats[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, HUD_Stats[playerid][0], 153.500000, 165.000000);
	PlayerTextDrawSetOutline(playerid, HUD_Stats[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, HUD_Stats[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, HUD_Stats[playerid][0], 1);
	PlayerTextDrawColor(playerid, HUD_Stats[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, HUD_Stats[playerid][0], 0);
	PlayerTextDrawBoxColor(playerid, HUD_Stats[playerid][0], 255);
	PlayerTextDrawUseBox(playerid, HUD_Stats[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, HUD_Stats[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, HUD_Stats[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, HUD_Stats[playerid][0], 0);
	PlayerTextDrawSetPreviewRot(playerid, HUD_Stats[playerid][0], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, HUD_Stats[playerid][0], 1, 1);
	// End HUD Stats

	// Stats Bar
	HUD_Stats_Bar[playerid][0] = CreatePlayerProgressBar(playerid, 503.000000, 365.000000, 81.500000, 7.000000, COLOR_YELLOW, 100.000000, 0);
	HUD_Stats_Bar[playerid][1] = CreatePlayerProgressBar(playerid, 503.000000, 412.000000, 81.500000, 7.000000, COLOR_LIGHT_BLUE, 100.000000, 0);

	// Cutting bar
	CuttingBar[playerid] = CreatePlayerProgressBar(playerid, 498.0, 104.0, 113.0, 6.2, COLOR_YELLOW, MAX_PROGRESS_BAR, 0);

	// Begin Speedo Pemain

	// Nama Kendaraan yang dinaikin
	SpeedoTD_VehInfo[playerid][0] = CreatePlayerTextDraw(playerid, 241.000000, 354.000000, "Nama Kendaraan");
	PlayerTextDrawFont(playerid, SpeedoTD_VehInfo[playerid][0], 2);
	PlayerTextDrawLetterSize(playerid, SpeedoTD_VehInfo[playerid][0], 0.316666, 1.700000);
	PlayerTextDrawTextSize(playerid, SpeedoTD_VehInfo[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpeedoTD_VehInfo[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, SpeedoTD_VehInfo[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, SpeedoTD_VehInfo[playerid][0], 1);
	PlayerTextDrawColor(playerid, SpeedoTD_VehInfo[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, SpeedoTD_VehInfo[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, SpeedoTD_VehInfo[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, SpeedoTD_VehInfo[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, SpeedoTD_VehInfo[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, SpeedoTD_VehInfo[playerid][0], 0);

	// Kecepatan
	SpeedoTD_VehInfo[playerid][1] = CreatePlayerTextDraw(playerid, 328.000000, 372.000000, "0");
	PlayerTextDrawFont(playerid, SpeedoTD_VehInfo[playerid][1], 3);
	PlayerTextDrawLetterSize(playerid, SpeedoTD_VehInfo[playerid][1], 0.316666, 1.700000);
	PlayerTextDrawTextSize(playerid, SpeedoTD_VehInfo[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpeedoTD_VehInfo[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, SpeedoTD_VehInfo[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, SpeedoTD_VehInfo[playerid][1], 3);
	PlayerTextDrawColor(playerid, SpeedoTD_VehInfo[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, SpeedoTD_VehInfo[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, SpeedoTD_VehInfo[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, SpeedoTD_VehInfo[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, SpeedoTD_VehInfo[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, SpeedoTD_VehInfo[playerid][1], 0);

	SpeedoTD_VehBar[playerid][0] = CreatePlayerProgressBar(playerid, 282.000000, 398.000000, 94.500000, 9.500000, -2686721, 1000.000000, 0);

	// Health
	// Untuk Health MAX_VALUE = 1000 - 260
	SpeedoTD_VehBar[playerid][1] = CreatePlayerProgressBar(playerid, 282.000000, 425.000000, 94.500000, 9.500000, -1962934017, 1000.000000 - 260.0, 0);
	// End Speedo Pemain
}

unloadTextDrawPemain(playerid){
	// My Info
	PlayerTextDrawDestroy(playerid, myInfo[playerid][0]);
	PlayerTextDrawDestroy(playerid, myInfo[playerid][1]);
	PlayerTextDrawDestroy(playerid, myInfo[playerid][2]);
	PlayerTextDrawDestroy(playerid, myInfo[playerid][3]);
	PlayerTextDrawDestroy(playerid, myInfo[playerid][4]);
	PlayerTextDrawDestroy(playerid, myInfo[playerid][5]);
	PlayerTextDrawDestroy(playerid, myInfo[playerid][6]);
	PlayerTextDrawDestroy(playerid, myInfo[playerid][7]);

	// Show Item
	PlayerTextDrawDestroy(playerid, showItem[playerid][0]);
	PlayerTextDrawDestroy(playerid, showItem[playerid][1]);
	PlayerTextDrawDestroy(playerid, showItem[playerid][2]);
	PlayerTextDrawDestroy(playerid, showItem[playerid][3]);
	PlayerTextDrawDestroy(playerid, showItem[playerid][4]);
	PlayerTextDrawDestroy(playerid, showItem[playerid][5]);	

	// Radar Uang
	// PlayerTextDrawDestroy(playerid, RadarUang[playerid][0]);
	// PlayerTextDrawDestroy(playerid, RadarUang[playerid][1]);

	// Bar Stats
	DestroyPlayerProgressBar(playerid, HUD_Stats_Bar[playerid][0]);
	DestroyPlayerProgressBar(playerid, HUD_Stats_Bar[playerid][1]);

	// Speedo
	PlayerTextDrawDestroy(playerid, SpeedoTD_VehInfo[playerid][0]);
	PlayerTextDrawDestroy(playerid, SpeedoTD_VehInfo[playerid][1]);
	DestroyPlayerProgressBar(playerid, SpeedoTD_VehBar[playerid][0]);
	DestroyPlayerProgressBar(playerid, SpeedoTD_VehBar[playerid][1]);
}

/*
	Show Player Speedo Textdraw
*/
ShowSpeedoForPlayer(playerid, vehicleid){
	if(SpeedoTimer[playerid] != -1){
        DeletePreciseTimer(SpeedoTimer[playerid]);
        SpeedoTimer[playerid] = -1;
	}
    SpeedoTimer[playerid] = SetPreciseTimer("SpeedoUpdate", 750, true, "ii", playerid, vehicleid);

	if(PlayerInfo[playerid][tampilSpeedo]){
		TextDrawShowForPlayer(playerid, SpeedoTD[0]);
		TextDrawShowForPlayer(playerid, SpeedoTD[1]);
		TextDrawShowForPlayer(playerid, SpeedoTD[2]);
		TextDrawShowForPlayer(playerid, SpeedoTD[3]);

		ShowPlayerProgressBar(playerid, SpeedoTD_VehBar[playerid][0]);
		ShowPlayerProgressBar(playerid, SpeedoTD_VehBar[playerid][1]);

		PlayerTextDrawShow(playerid, SpeedoTD_VehInfo[playerid][0]);
		PlayerTextDrawShow(playerid, SpeedoTD_VehInfo[playerid][1]);
	}
}

/*
	Hide Player Speedo Textdraw
*/
HideSpeedoForPlayer(playerid){
	if(SpeedoTimer[playerid] != -1){ // Assume that any callback may already delete it
        DeletePreciseTimer(SpeedoTimer[playerid]);
        SpeedoTimer[playerid] = -1;
	}

	TextDrawHideForPlayer(playerid, SpeedoTD[0]);
	TextDrawHideForPlayer(playerid, SpeedoTD[1]);
	TextDrawHideForPlayer(playerid, SpeedoTD[2]);
	TextDrawHideForPlayer(playerid, SpeedoTD[3]);

	HidePlayerProgressBar(playerid, SpeedoTD_VehBar[playerid][0]);
	HidePlayerProgressBar(playerid, SpeedoTD_VehBar[playerid][1]);

	PlayerTextDrawHide(playerid, SpeedoTD_VehInfo[playerid][0]);
	PlayerTextDrawHide(playerid, SpeedoTD_VehInfo[playerid][1]);
	return 1;
}