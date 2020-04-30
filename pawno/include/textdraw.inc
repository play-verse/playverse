/*
    Hide and Show Textdraw
*/
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