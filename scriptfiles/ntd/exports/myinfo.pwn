/*
This file was generated by Nickk's TextDraw editor script
Nickk888 is the author of the NTD script
*/

//Variables
new Text:PublicTD[1];
new PlayerText:PlayerTD[MAX_PLAYERS][7];

//Textdraws
PublicTD[0] = TextDrawCreate(329.000000, 334.000000, "Tutup");
TextDrawFont(PublicTD[0], 2);
TextDrawLetterSize(PublicTD[0], 0.258332, 1.750000);
TextDrawTextSize(PublicTD[0], 16.500000, 90.500000);
TextDrawSetOutline(PublicTD[0], 1);
TextDrawSetShadow(PublicTD[0], 0);
TextDrawAlignment(PublicTD[0], 2);
TextDrawColor(PublicTD[0], -1);
TextDrawBackgroundColor(PublicTD[0], 255);
TextDrawBoxColor(PublicTD[0], 200);
TextDrawUseBox(PublicTD[0], 1);
TextDrawSetProportional(PublicTD[0], 1);
TextDrawSetSelectable(PublicTD[0], 1);


//Player Textdraws
PlayerTD[playerid][0] = CreatePlayerTextDraw(playerid, 327.000000, 76.000000, "_");
PlayerTextDrawFont(playerid, PlayerTD[playerid][0], 1);
PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][0], 0.858332, 32.100006);
PlayerTextDrawTextSize(playerid, PlayerTD[playerid][0], 348.500000, 390.000000);
PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][0], 1);
PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][0], 0);
PlayerTextDrawAlignment(playerid, PlayerTD[playerid][0], 2);
PlayerTextDrawColor(playerid, PlayerTD[playerid][0], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][0], 255);
PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][0], 235);
PlayerTextDrawUseBox(playerid, PlayerTD[playerid][0], 1);
PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][0], 1);
PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][0], 0);

PlayerTD[playerid][1] = CreatePlayerTextDraw(playerid, 339.000000, 114.000000, "Preview_Model");
PlayerTextDrawFont(playerid, PlayerTD[playerid][1], 5);
PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][1], 0.600000, 2.000000);
PlayerTextDrawTextSize(playerid, PlayerTD[playerid][1], 172.500000, 205.000000);
PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][1], 0);
PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][1], 0);
PlayerTextDrawAlignment(playerid, PlayerTD[playerid][1], 1);
PlayerTextDrawColor(playerid, PlayerTD[playerid][1], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][1], -131);
PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][1], 255);
PlayerTextDrawUseBox(playerid, PlayerTD[playerid][1], 0);
PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][1], 1);
PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][1], 0);
PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][1], 18874);
PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][1], 0.000000, 0.000000, 0.000000, 1.000000);
PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][1], 1, 1);

PlayerTD[playerid][2] = CreatePlayerTextDraw(playerid, 146.000000, 83.000000, "My Info");
PlayerTextDrawFont(playerid, PlayerTD[playerid][2], 1);
PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][2], 0.600000, 2.000000);
PlayerTextDrawTextSize(playerid, PlayerTD[playerid][2], 400.000000, 17.000000);
PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][2], 1);
PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][2], 0);
PlayerTextDrawAlignment(playerid, PlayerTD[playerid][2], 1);
PlayerTextDrawColor(playerid, PlayerTD[playerid][2], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][2], 255);
PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][2], 50);
PlayerTextDrawUseBox(playerid, PlayerTD[playerid][2], 0);
PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][2], 1);
PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][2], 0);

PlayerTD[playerid][3] = CreatePlayerTextDraw(playerid, 144.000000, 120.000000, "Nama : tes");
PlayerTextDrawFont(playerid, PlayerTD[playerid][3], 1);
PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][3], 0.354166, 1.500000);
PlayerTextDrawTextSize(playerid, PlayerTD[playerid][3], 325.000000, 17.000000);
PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][3], 1);
PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][3], 0);
PlayerTextDrawAlignment(playerid, PlayerTD[playerid][3], 1);
PlayerTextDrawColor(playerid, PlayerTD[playerid][3], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][3], 255);
PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][3], 50);
PlayerTextDrawUseBox(playerid, PlayerTD[playerid][3], 1);
PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][3], 1);
PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][3], 0);

PlayerTD[playerid][4] = CreatePlayerTextDraw(playerid, 144.000000, 148.000000, "Jenis Kelamin : Laki Laki");
PlayerTextDrawFont(playerid, PlayerTD[playerid][4], 1);
PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][4], 0.354166, 1.500000);
PlayerTextDrawTextSize(playerid, PlayerTD[playerid][4], 325.000000, 17.000000);
PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][4], 1);
PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][4], 0);
PlayerTextDrawAlignment(playerid, PlayerTD[playerid][4], 1);
PlayerTextDrawColor(playerid, PlayerTD[playerid][4], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][4], 255);
PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][4], 50);
PlayerTextDrawUseBox(playerid, PlayerTD[playerid][4], 1);
PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][4], 1);
PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][4], 0);

PlayerTD[playerid][5] = CreatePlayerTextDraw(playerid, 144.000000, 164.000000, "Nomor HP : 62123456");
PlayerTextDrawFont(playerid, PlayerTD[playerid][5], 1);
PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][5], 0.354166, 1.500000);
PlayerTextDrawTextSize(playerid, PlayerTD[playerid][5], 325.000000, 17.000000);
PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][5], 1);
PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][5], 0);
PlayerTextDrawAlignment(playerid, PlayerTD[playerid][5], 1);
PlayerTextDrawColor(playerid, PlayerTD[playerid][5], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][5], 255);
PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][5], 50);
PlayerTextDrawUseBox(playerid, PlayerTD[playerid][5], 1);
PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][5], 1);
PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][5], 0);

PlayerTD[playerid][6] = CreatePlayerTextDraw(playerid, 144.000000, 180.000000, "Jenis HP : ePhone 4");
PlayerTextDrawFont(playerid, PlayerTD[playerid][6], 1);
PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][6], 0.354166, 1.500000);
PlayerTextDrawTextSize(playerid, PlayerTD[playerid][6], 325.000000, 17.000000);
PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][6], 1);
PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][6], 0);
PlayerTextDrawAlignment(playerid, PlayerTD[playerid][6], 1);
PlayerTextDrawColor(playerid, PlayerTD[playerid][6], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][6], 255);
PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][6], 50);
PlayerTextDrawUseBox(playerid, PlayerTD[playerid][6], 1);
PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][6], 1);
PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][6], 0);


/*Player Progress Bars
Requires "progress2" include by Southclaws
Download: https://github.com/Southclaws/progress2/releases */
