/*
This file was generated by Nickk's TextDraw editor script
Nickk888 is the author of the NTD script
*/

//Variables

//Textdraws

SpeedoTD[3] = TextDrawCreate(375.000000, 372.000000, "~g~Km~w~/~r~Jam");
PlayerTextDrawFont(playerid, SpeedoTD[3], 3);
PlayerTextDrawLetterSize(playerid, SpeedoTD[3], 0.316666, 1.700000);
PlayerTextDrawTextSize(playerid, SpeedoTD[3], 400.000000, 17.000000);
PlayerTextDrawSetOutline(playerid, SpeedoTD[3], 1);
PlayerTextDrawSetShadow(playerid, SpeedoTD[3], 0);
PlayerTextDrawAlignment(playerid, SpeedoTD[3], 3);
PlayerTextDrawColor(playerid, SpeedoTD[3], -1);
PlayerTextDrawBackgroundColor(playerid, SpeedoTD[3], 255);
PlayerTextDrawBoxColor(playerid, SpeedoTD[3], 50);
PlayerTextDrawUseBox(playerid, SpeedoTD[3], 0);
PlayerTextDrawSetProportional(playerid, SpeedoTD[3], 1);
PlayerTextDrawSetSelectable(playerid, SpeedoTD[3], 0);

//Player Textdraws
SpeedoTD_VehInfo[playerid][0] = CreatePlayerTextDraw(playerid, 241.000000, 354.000000, "Police Car (LSPD)");
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

SpeedoTD_VehInfo[playerid][1] = CreatePlayerTextDraw(playerid, 328.000000, 372.000000, "100");
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


/*Player Progress Bars
Requires "progress2" include by Southclaws
Download: https://github.com/Southclaws/progress2/releases */
SpeedoTD_VehBar[playerid][0] = CreatePlayerProgressBar(playerid, 282.000000, 398.000000, 94.500000, 9.500000, -2686721, 100.000000, 0);
SetPlayerProgressBarValue(playerid, SpeedoTD_VehBar[playerid][0], 50.000000);

SpeedoTD_VehBar[playerid][1] = CreatePlayerProgressBar(playerid, 282.000000, 425.000000, 94.500000, 9.500000, -1962934017, 100.000000, 0);
SetPlayerProgressBarValue(playerid, SpeedoTD_VehBar[playerid][1], 50.000000);

