// Car tunning menu v2.1, by HeLiOn PrImE
// uncomment the line below if you want to write a filterscript
#include <a_samp>
#define FILTERSCRIPT
#if defined FILTERSCRIPT
//colors
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREY 0xAFAFAFAA// INFO text messages
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA// warning messages
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_LIGHTGREEN 0x7FFF00
#define COLOR_DARKGREEN 0x006400
#define COLOR_LIGHTBLUE 0x91C8FF//Server text messages
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_GROUPTALK 0x87CEEBAA  // SKYBLUE
#define COLOR_MENU 0xFFFFFFAA		// WHITE (FFFFFF) menu's (/help)
#define COLOR_SYSTEM_PM 0x66CC00AA	// LIGHT GREEN
#define COLOR_SYSTEM_PW 0xFFFF33AA	// YELLOW

//dialogs
#define DIALOG_TYPE_MAIN 144
#define DIALOG_TYPE_PAINTJOBS 145
#define DIALOG_TYPE_COLORS 146
#define DIALOG_TYPE_EXHAUSTS 147
#define DIALOG_TYPE_FBUMPS 148
#define DIALOG_TYPE_RBUMPS 149
#define DIALOG_TYPE_ROOFS 150
#define DIALOG_TYPE_SPOILERS 151
#define DIALOG_TYPE_SIDESKIRTS 152
#define DIALOG_TYPE_BULLBARS 153
#define DIALOG_TYPE_WHEELS 154
#define DIALOG_TYPE_CSTEREO 155
#define DIALOG_TYPE_HYDRAULICS 156
#define DIALOG_TYPE_NITRO 157
#define DIALOG_TYPE_LIGHTS 158
#define DIALOG_TYPE_HOODS 159
#define DIALOG_TYPE_VENTS 160

//menus

static pvehicleid[MAX_PLAYERS]; // array containing players vehicle id (loaded when player enters as driver)
static pmodelid[MAX_PLAYERS]; // array containing players vehicle MODEL id (loaded when player enters as driver)

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Car tunning menu v.2.1, by HeLiOn PrImE, Rsts[Lucas] and kaisersouse");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
}

#endif
public OnPlayerConnect(playerid)
{
    pvehicleid[playerid] = GetPlayerVehicleID(playerid);
	pvehicleid[playerid] = 0;
    pmodelid[playerid] = 0;
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate) {
	if(newstate == PLAYER_STATE_DRIVER) {
	    pvehicleid[playerid] = GetPlayerVehicleID(playerid);
	    pmodelid[playerid] = GetVehicleModel(pvehicleid[playerid]);
	}
	else {
	    pvehicleid[playerid] = 0;
	    pmodelid[playerid] = 0;
	}
	return 1;
}




GetVehicleWithinDistance( playerid, Float:x1, Float:y1, Float:z1, Float:dist, &vehic){
	for(new i = 1; i < MAX_VEHICLES; i++){
		if(GetVehicleModel(i) > 0){
			if(GetPlayerVehicleID(playerid) != i ){
	        	new Float:x, Float:y, Float:z;
	        	new Float:x2, Float:y2, Float:z2;
				GetVehiclePos(i, x, y, z);
				x2 = x1 - x; y2 = y1 - y; z2 = z1 - z;
				new Float:iDist = (x2*x2+y2*y2+z2*z2);
				printf("Vehicle %d is %f", i, iDist);

				if( iDist < dist){
					vehic = i;
				}
			}
		}
	}
}
#pragma unused GetVehicleWithinDistance
public OnPlayerCommandText(playerid, cmdtext[])
{
if(!strcmp(cmdtext, "/tune", true))
{
		new playerstate = GetPlayerState(playerid);
		if(playerstate == PLAYER_STATE_DRIVER)
		{
     	ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
		return 1;
		}
		else
		{
		   return SendClientMessage(playerid, COLOR_RED, "[ERROR] You cannot modify/tune a car unless you are the driver.");		}
		}
return 0;
}

//------------------------All car that are allowed to mod------------------------------------------------------------
// Put here all car's id's yo want to be modable
// NOTE: DO NOT TRY TO ALLOW OR MOD BOATS ; PLANES OR OTHER NON CARS.THAT WIL CAUSE YOUR SERVER CRASH
forward ModCar(playerid);
public ModCar(playerid) { // changed to switch method to reduce processor load on server
//	new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); // this executes a fair amt of stuff, so running it once to populate variable (modelid),THEN checking variable, makes more sense
	switch(pmodelid[playerid]) {
        case 562,565,559,561,560,575,534,567,536,535,576,411,579,602,496,518,527,589,597,419,
		533,526,474,545,517,410,600,436,580,439,549,491,445,604,507,585,587,466,492,546,551,516,
		426, 547, 405, 409, 550, 566, 540, 421,	529,431,438,437,420,525,552,416,433,427,490,528,
		407,544,470,598,596,599,601,428,499,609,524,578,486,406,573,455,588,403,514,423,
		414,443,515,456,422,482,530,418,572,413,440,543,583,478,554,402,542,603,475,568,504,457,
        483,508,429,541,415,480,434,506,451,555,477,400,404,489,479,442,458,467,558,444: {
		    TogglePlayerControllable(playerid,0);
 			return SendClientMessage(playerid, COLOR_WHITE, "[INFO] Select an item and push the SPACEBAR to approve.");
		}
		default: return SendClientMessage(playerid,COLOR_RED,"[WARNING] You are not allowed to modify/tune this vehicle");
	}
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TYPE_MAIN)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:// Paintjobs
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
        	    }
        	    case 1: // colors
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
        	    }
        	    case 2: // Hoods
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
        	    }
        	    case 3: // Vents
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
        	    }
        	    case 4: // Lights
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
        	    }
        	    case 5: // Exhausts
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
        	    }
				case 6: // Front Bumpers
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
        	    }
				case 7: // Rear Bumpers
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
        	    }
				case 8: // Roofs
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
        	    }
				case 9: // Spoilers
        	    {
				ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
        	    }
				case 10: // Side Skirts
        	    {
				ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
        	    }
				case 11: // Bullbars
        	    {
				ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
        	    }
				case 12: // Wheels
        	    {
     			ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
        	    }
				case 13: // Car Stereo
        	    {
				ShowPlayerDialog(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
        	    }
				case 14: // Hydraulics
        	    {
 				ShowPlayerDialog(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
        	    }
				case 15: // Nitrous Oxide
        	    {
					ShowPlayerDialog(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
        	    }
				case 16: // Repair Car
        	    {
        	        new car = GetPlayerVehicleID(playerid);
					SetVehicleHealth(car,1000);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repaired car");
				 	ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
    				return 1;
        	    }
			}
		}
	}
	if(dialogid == DIALOG_TYPE_PAINTJOBS)
	{
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
	    if(response)
	    {
			switch(listitem)// Checking which list item was selected
			{
                case 0:// Paintjobs
        	    {
        	        if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 560 ||
				pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 || // Broadway
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 535 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 558)
		        {
					new car = GetPlayerVehicleID(playerid);
					ChangeVehiclePaintjob(car,0);
					SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added paintjob to car");
					ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
					PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
				}
					else
				{
				   SendClientMessage(playerid,COLOR_WHITE,"[INFO] Paintjob is only for Wheel Arch Angrls and Loco Low Co types of cars");
			       ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
				}
        	    }
        	    case 1: // Colors
        	    {
        	        if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 560 ||
				pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 || // Broadway
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 535 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 558)
			    {
	                new car = GetPlayerVehicleID(playerid);
					ChangeVehiclePaintjob(car,1);
					SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added paintjob to car");
					ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
					PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
				}
					else
				{
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Paintjob is only for Wheel Arch Angrls and Loco Low Co types of cars");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
				}
        	    }
        	    case 2: // Exhausts
        	    {
        	        if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 560 ||
				pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 || // Broadway
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 535 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 558)
			    {
	                new car = GetPlayerVehicleID(playerid);
					ChangeVehiclePaintjob(car,2);
					SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added paintjob to car");
					ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
					PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
				}
					else
				{
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Paintjob is only for Wheel Arch Angrls and Loco Low Co types of cars");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
				}
        	    }
				case 3: // Front Bumpers
        	    {
        	        if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 560 ||
				pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 || // Broadway
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 535 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 558)
			    {
	                new car = GetPlayerVehicleID(playerid);
					ChangeVehiclePaintjob(car,3);
					SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added paintjob to car");
					ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
					PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
				}
					else
				{
	       			SendClientMessage(playerid,COLOR_WHITE,"[INFO] Paintjob is only for Wheel Arch Angrls and Loco Low Co types of cars");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
				}
        	    }
				case 4: // Rear Bumpers
        	    {
        	        if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 560 ||
				pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 || // Broadway
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 535 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 558)
			    {
	                new car = GetPlayerVehicleID(playerid);
					ChangeVehiclePaintjob(car,4);
					SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added paintjob to car");
					ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
					PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
				}
					else
				{
	            	SendClientMessage(playerid,COLOR_WHITE,"[INFO] Paintjob is only for Wheel Arch Angrls and Loco Low Co types of cars");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
				}
        	    }
				case 5:
        	    {
        	        ShowPlayerDialog(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
        	    }
				case 6:
        	    {
                 ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
			}
		}
	}
	if(dialogid == DIALOG_TYPE_COLORS)
	{
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
	    if(response)
	    {
			switch(listitem)// Checking which list item was selected
			{
                case 0:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            ChangeVehicleColor(car,0,0);
		            //GivePlayerMoney(playerid,-150);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
		            ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
		            PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);

				}
					else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
       	    	case 1:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,1,1);
			    //    GivePlayerMoney(playerid,-150);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
				}
					else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
        	    case 2:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,3,3);
			      //  GivePlayerMoney(playerid,-150);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
				}
					else
				{
	      		 	SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
				case 3:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,79,79);
			     //   GivePlayerMoney(playerid,-150);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
				}
					else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
				case 4:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,86,86);
			     //   GivePlayerMoney(playerid,-150);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
				}
					else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
				case 5:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,6,6);
			      //  GivePlayerMoney(playerid,-150);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
				case 6:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,126,126);
			  //      GivePlayerMoney(playerid,-150);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
				case 7:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,66,66);
			    //    GivePlayerMoney(playerid,-150);
	          		SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
	          		PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
				case 8:
        	    {
					if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            ChangeVehicleColor(car,24,24);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
		            PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
		            ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
        	    case 9:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,123,123);
	          		SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
	          		PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
        	    case 10:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,53,53);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
        	    case 11:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,93,93);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
				case 12:
        	    {
        	         if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,83,83);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
						else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
				case 13:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,60,60);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
				case 14:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,161,161);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
				case 15:
        	    {
        	        if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        ChangeVehicleColor(car,153,153);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
			        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
				}
        	    }
        	    case 16:
        	    {
        	        ShowPlayerDialog(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
        	    }
        	    case 17:
        	    {
                 ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
			}
		}
	}
	if(dialogid == DIALOG_TYPE_EXHAUSTS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)
        	{
        	    case 0:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 560)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562)
		            {
		            	AddVehicleComponent(car,1034);
		            	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            	SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565)
					{
					    AddVehicleComponent(car,1046);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559)
					{
					    AddVehicleComponent(car,1065);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561)
					{
					    AddVehicleComponent(car,1064);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560)
					{
					    AddVehicleComponent(car,1028);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)
					{
					    AddVehicleComponent(car,1089);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
	    			}
					}
	  			 	else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562)
			        {
			            AddVehicleComponent(car,1037);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565)
					{
					    AddVehicleComponent(car,1045);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559)
					{
					    AddVehicleComponent(car,1066);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561)
					{
					    AddVehicleComponent(car,1059);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560)
					{
					    AddVehicleComponent(car,1029);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)
					{
					    AddVehicleComponent(car,1092);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 535)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1044);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		             	SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1126);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1129);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1104);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 535) // Slamvan
					{
 						AddVehicleComponent(car,1113);
 						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1136);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					   	SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 535)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1043);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1127);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1132);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1105);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}

					else if(pmodelid[playerid] == 535) // Slamvan
					{
					    AddVehicleComponent(car,1114);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}

					else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1135);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}

					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 4:// Large
        	    {
     				if(
					pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 527 ||//cadrona
					pmodelid[playerid] == 542 ||//clover
					pmodelid[playerid] == 589 ||//club
					pmodelid[playerid] == 400 ||//landstalker
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 580 ||//stafford
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549 ||//tampa
					pmodelid[playerid] == 477)//zr-350
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580) // stafford
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // zr-350
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1020);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    	}
        	    	else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
				}
        	    case 5: // Medium
        	    {
                        if(
					pmodelid[playerid] == 527 ||//cadrona
					pmodelid[playerid] == 542 ||//clover
					pmodelid[playerid] == 400 ||//landstalker
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 436 ||//previon
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 477)//zr-350
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // zr350
			        	{
			            AddVehicleComponent(car,1021);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 6: // Small
        	    {
                        if(
					pmodelid[playerid] == 436)//previon
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1022);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 7: // Twin
        	    {
                        if(
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 542 ||//clover
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 400 ||//landstalker
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 436 ||//previon
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549 ||//tampa
					pmodelid[playerid] == 477)//zr-350
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 415) // cheetah
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405 ) // sentinel
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // zr-350
			        	{
			            AddVehicleComponent(car,1019);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 8: // Upswept
        	    {
                        if(
                    pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 542 ||//clover
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 400 ||//landstalker
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549 ||//tampa
					pmodelid[playerid] == 477)//zr-350
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 415) // cheetah
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580) // stafford
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1018);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // zr-350
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1018);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
						}
        	    }
				case 9: // _
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
        	    }
        	    case 10: // Back
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
			}
		}
	}
	if(dialogid == DIALOG_TYPE_FBUMPS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
				{
		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562) // Elegy
		            {
		            	AddVehicleComponent(car,1171);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	              		SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1153);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jester
					{
					    AddVehicleComponent(car,1160);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1155);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1169);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558) // Uranus
					{
					    AddVehicleComponent(car,1166);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {

			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562) // Elegy
			        {
			            AddVehicleComponent(car,1172);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1152);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jetser
					{
					    AddVehicleComponent(car,1173);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1157);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1170);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)  // Uranus
					{
					    AddVehicleComponent(car,1165);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 535)
				{
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1174);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1179);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1189);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1182);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 535) // Slamvan
					{
					    AddVehicleComponent(car,1115);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1191);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 535 ||
				pmodelid[playerid] == 536 ||
	            pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 576)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1175);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1185);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1188);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1181);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}

				    else if(pmodelid[playerid] == 535) // Slamvan
					{
					    AddVehicleComponent(car,1116);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1190);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}

					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
             	ShowPlayerDialog(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
        	    }
				case 5:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
			}
		}
	}
	if(dialogid == DIALOG_TYPE_RBUMPS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {

		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562) // Elegy
		            {
		            	AddVehicleComponent(car,1149);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	              		SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1150);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jester
					{
					    AddVehicleComponent(car,1159);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1154);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1141);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558) // Uranus
					{
					    AddVehicleComponent(car,1168);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {


			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562) // Elegy
			        {
			            AddVehicleComponent(car,1148);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] YComponent successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1151);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jetser
					{
					    AddVehicleComponent(car,1161);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1156);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1140);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)  // Uranus
					{
					    AddVehicleComponent(car,1167);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 535)
		        {


              		new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1176);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1180);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1187);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1184);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 535) // Slamvan
					{
					    AddVehicleComponent(car,1109);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1192);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
     }
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                 if(pmodelid[playerid] == 575 ||
				pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536 ||
				pmodelid[playerid] == 576 ||
				pmodelid[playerid] == 535)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
			            AddVehicleComponent(car,1177);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 534)// Remington
					{
					    AddVehicleComponent(car,1178);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 567)// Savanna
					{
					    AddVehicleComponent(car,1186);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1183);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}

						else if(pmodelid[playerid] == 535) // Slamvan
					{
					    AddVehicleComponent(car,1110);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}

						else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1193);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}

					}
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
            	    ShowPlayerDialog(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
        	    }
				case 5:
        	    {
     				ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_ROOFS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {

		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562) // Elegy
		            {
		            	AddVehicleComponent(car,1038);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	              		SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1054);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 559) // Jester
					{
					    AddVehicleComponent(car,1067);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1055);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1032);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 558) // Uranus
					{
					    AddVehicleComponent(car,1088);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
					}
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                 if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {


			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562) // Elegy
			        {
			            AddVehicleComponent(car,1035);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1053);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 559) // Jetser
					{
					    AddVehicleComponent(car,1068);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1061);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1033);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
						else if(pmodelid[playerid] == 558)  // Uranus
					{
					    AddVehicleComponent(car,1091);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
					}
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                 if(pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 567) // Savanna
			        {
			            AddVehicleComponent(car,1130);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
	   					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1128);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
					}
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                 if(pmodelid[playerid] == 567 ||
				pmodelid[playerid] == 536)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 567) // Savanna
			        {
			            AddVehicleComponent(car,1131);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
	   					else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1103);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
					}
						else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
                 if(
					pmodelid[playerid] == 401 ||
					pmodelid[playerid] == 518 ||
					pmodelid[playerid] == 589 ||
					pmodelid[playerid] == 492 ||
					pmodelid[playerid] == 546 ||
					pmodelid[playerid] == 603 ||
					pmodelid[playerid] == 426 ||
					pmodelid[playerid] == 436 ||
					pmodelid[playerid] == 580 ||
					pmodelid[playerid] == 550||
					pmodelid[playerid] == 477)
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 492)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477)
			        	{
			            AddVehicleComponent(car,1006);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
						}
        	    }
				case 5:
        	    {
                 ShowPlayerDialog(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
        	    }
				case 6:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_SPOILERS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {

		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562) // Elegy
		            {
		            	AddVehicleComponent(car,1147);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	              		SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1049);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jester
					{
					    AddVehicleComponent(car,1162);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1158);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1138);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558) // Uranus
					{
					    AddVehicleComponent(car,1164);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {


			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562) // Elegy
			        {
			            AddVehicleComponent(car,1146);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1150);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jetser
					{
					    AddVehicleComponent(car,1158);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1060);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1139);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)  // Uranus
					{
					    AddVehicleComponent(car,1163);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:// Win
        	    {
                if(
                    pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 527 ||//cadrona
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 436 ||//previon
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 477 ||//stallion
					pmodelid[playerid] == 580 ||//stafford
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549)//tampa
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 415) // cheetah
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // stallion
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580) // stafford
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1001);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 3: // Fury
        	    {
                        if(
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 405 ||//sentinel
					pmodelid[playerid] == 477 ||//stallion
					pmodelid[playerid] == 580 ||//stafford
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549)//tampa
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 415) // cheetah
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // stallion
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580) // stafford
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1023);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 4: // Alpha
        	    {
                        if(
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 415 ||//cheetah
					pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 426 ||//premier
					pmodelid[playerid] == 436 ||//previon
					pmodelid[playerid] == 477 ||//stallion
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549)//tampa
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 415) // cheetah
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477) // stallion
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1003);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 5: // Pro
        	    {
                        if(
					pmodelid[playerid] == 589 ||//club
					pmodelid[playerid] == 492 ||//greenwood
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 405)//sentinel
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 518) // club
			        	{
			            AddVehicleComponent(car,1000);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 492) // greenwood
			        	{
			            AddVehicleComponent(car,1000);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1000);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
        				AddVehicleComponent(car,1000);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
				case 6: // Champ
        	    {
                        if(
					pmodelid[playerid] == 527 ||//cadrona
					pmodelid[playerid] == 542 ||//clover
					pmodelid[playerid] == 405)//sentinel
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1014);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1014);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 405) // sentinel
			        	{
        				AddVehicleComponent(car,1014);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 7: // Race
        	    {
                if(
					pmodelid[playerid] == 527 ||//cadrona
					pmodelid[playerid] == 542)//clover
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 527) // cadrona
			        	{
			            AddVehicleComponent(car,1014);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 542) // clover
			        	{
			            AddVehicleComponent(car,1014);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
				case 8: // Drag
        	    {
                if(
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 517)//majestic
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1002);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1002);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
						}
        	    }
        	    case 9:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
        	    }
				case 10:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_SIDESKIRTS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {

		            new car = GetPlayerVehicleID(playerid);
		            if(pmodelid[playerid] == 562) // Elegy
		            {
		            	AddVehicleComponent(car,1036);
		            	AddVehicleComponent(car,1040);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	              		SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
		            	ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1047);
					    AddVehicleComponent(car,1051);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jester
					{
					    AddVehicleComponent(car,1069);
					    AddVehicleComponent(car,1071);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] YComponent successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1056);
					    AddVehicleComponent(car,1062);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1026);
					    AddVehicleComponent(car,1027);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558) // Uranus
					{
					    AddVehicleComponent(car,1090);
					    AddVehicleComponent(car,1094);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1:
        	    {
                if(pmodelid[playerid] == 562 ||
				pmodelid[playerid] == 565 ||
				pmodelid[playerid] == 559 ||
				pmodelid[playerid] == 561 ||
				pmodelid[playerid] == 558 ||
				pmodelid[playerid] == 560)
		        {


			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 562) // Elegy
			        {
			            AddVehicleComponent(car,1039);
			            AddVehicleComponent(car,1041);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 565) // Flash
					{
					    AddVehicleComponent(car,1048);
					    AddVehicleComponent(car,1052);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 559) // Jetser
					{
					    AddVehicleComponent(car,1070);
					    AddVehicleComponent(car,1072);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 561) // Stratum
					{
					    AddVehicleComponent(car,1057);
					    AddVehicleComponent(car,1063);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 560) // Sultan
					{
					    AddVehicleComponent(car,1031);
					    AddVehicleComponent(car,1030);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					else if(pmodelid[playerid] == 558)  // Uranus
					{
					    AddVehicleComponent(car,1093);
					    AddVehicleComponent(car,1095);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
					    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                if(pmodelid[playerid] == 575 ||
	               pmodelid[playerid] == 536 ||
	               pmodelid[playerid] == 576 ||
		 	       pmodelid[playerid] == 567)
	               {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 575) // Brodway
			        {
	       		        AddVehicleComponent(car,1042);
	       		        AddVehicleComponent(car,1099);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
	   				else if(pmodelid[playerid] == 567) // Savanna
					{
					    AddVehicleComponent(car,1102);
					    AddVehicleComponent(car,1133);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
	    		        ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
	                }
	                else if(pmodelid[playerid] == 576) // Tornado
					{
					    AddVehicleComponent(car,1134);
					    AddVehicleComponent(car,1137);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
	    		        ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
	                }
	                else if(pmodelid[playerid] == 536) // Blade
					{
					    AddVehicleComponent(car,1108);
					    AddVehicleComponent(car,1107);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
	                    ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
	                }
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                if(pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 534)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 534) // Remington
			        {
			            AddVehicleComponent(car,1122);
			            AddVehicleComponent(car,1101);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
                if(pmodelid[playerid] == 534 ||
				pmodelid[playerid] == 534)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 534) // Remington
			        {
			            AddVehicleComponent(car,1106);
			            AddVehicleComponent(car,1124);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
				case 5:
        	    {
                if(pmodelid[playerid] == 535)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 535) // Slamvan
			        {
			            AddVehicleComponent(car,1118);
			            AddVehicleComponent(car,1120);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
				case 6:
        	    {
				if(pmodelid[playerid] == 535)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 535) // Slamvan
			        {
			            AddVehicleComponent(car,1119);
			            AddVehicleComponent(car,1121);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
					}
        	    }
				case 7:
        	    {
				if(
					pmodelid[playerid] == 401 ||
					pmodelid[playerid] == 518 ||
					pmodelid[playerid] == 527 ||
					pmodelid[playerid] == 415 ||
					pmodelid[playerid] == 589 ||
					pmodelid[playerid] == 546 ||
					pmodelid[playerid] == 517 ||
					pmodelid[playerid] == 603 ||
					pmodelid[playerid] == 436 ||
					pmodelid[playerid] == 439 ||
					pmodelid[playerid] == 580 ||
					pmodelid[playerid] == 549 ||
					pmodelid[playerid] == 477)
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 527)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 415)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 439)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 580)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 477)
			        	{
			            AddVehicleComponent(car,1007);
			            AddVehicleComponent(car,1017);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
        	    	}
        	    		else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
						}
        	    }
				case 8:
        	    {
				ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
        	    }
				case 9:
        	    {
    			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_BULLBARS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(pmodelid[playerid] == 534)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 534) // Remington
			        {
			            AddVehicleComponent(car,1100);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
			        }
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 1: 
        	    {
                if(pmodelid[playerid] == 534)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 534) // Remington
			        {
			            AddVehicleComponent(car,1123);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 2:
        	    {
                if(pmodelid[playerid] == 534)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 534) // Remington
			        {
			            AddVehicleComponent(car,1125);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
        	    }
				case 3:
        	    {
                if(pmodelid[playerid] == 535)

			    {
			        new car = GetPlayerVehicleID(playerid);
			        if(pmodelid[playerid] == 535) // Slamvan
			        {
			            AddVehicleComponent(car,1117);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
					}
					else
					{
				    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] ou cannot install this component to your car. ");
					ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
        	    }
				case 5:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_WHEELS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            AddVehicleComponent(car,1025);
		            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Offroad Wheels ");
		            ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
        	    case 1:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1074);
           			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Mega Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
        	    case 2:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
	                AddVehicleComponent(car,1076);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Wires Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 3:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1078);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Twist Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	      		 	SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 4:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1081);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Grove Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 5:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
	                AddVehicleComponent(car,1082);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Import Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 6:
        	    {
				if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1085);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Atomic Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 7:
        	    {
				if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1096);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	          		SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Ahab Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 8:
        	    {
				if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1097);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	          		SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Virtual Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 9:
        	    {
     			if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1098);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	          		SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Access Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 10:
        	    {
				if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            AddVehicleComponent(car,1084);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Trance Wheels ");
		            ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 11:
        	    {
 				if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1073);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Shadow Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 12:
        	    {
					if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
	                AddVehicleComponent(car,1075);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Rimshine Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
					else
				{
	      	 		SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 13:
        	    {
					if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1077);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Classic Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
					else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 14:
        	    {
					if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1079);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Cutter Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
					else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 15:
        	    {
					if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
	                AddVehicleComponent(car,1080);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Switch Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 16:
        	    {
					if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1083);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Dollar Wheels");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
					else
				{
				    SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
				}
        	    }
				case 17:
        	    {
					ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
        	    }
				case 18:
        	    {
     			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_CSTEREO)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            AddVehicleComponent(car,1086);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added. ");
		            ShowPlayerDialog(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
				}
				else
				{
	                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
			    }
        	    }
        	    case 1:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
        	    }
        	    case 2:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_HYDRAULICS)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            AddVehicleComponent(car,1087);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added. ");
		            ShowPlayerDialog(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
				}
				else
				{
	                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
			    }
        	    }
        	    case 1:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
        	    }
        	    case 2:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_NITRO)
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
		        {
		            new car = GetPlayerVehicleID(playerid);
		            AddVehicleComponent(car,1008);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added. ");
           			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
				}
				else
				{
	                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
        			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
			    }
        	    }
        	    case 1:
        	    {
                if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
			        AddVehicleComponent(car,1009);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
           			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
           			ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
				}
        	    }
        	    case 2:
        	    if(GetPlayerMoney(playerid) >= 0)
			    {
			        new car = GetPlayerVehicleID(playerid);
	                AddVehicleComponent(car,1010);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
			        ShowPlayerDialog(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
				}
				else
				{
	       			SendClientMessage(playerid,COLOR_RED,"Not enough money!");
				    ShowPlayerDialog(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
				}
        	    case 3:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
        	    }
        	    case 4:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
 			}
		}
	}
	if(dialogid == DIALOG_TYPE_HOODS)// HOODS
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:// fury
        	    {
                	if(
					pmodelid[playerid] == 401 ||
					pmodelid[playerid] == 518 ||
					pmodelid[playerid] == 589 ||
					pmodelid[playerid] == 492 ||
					pmodelid[playerid] == 426 ||
					pmodelid[playerid] == 550)
			    	{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 492) // greenwood
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1005);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
					}
					else
					{
					SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
					}
	    		}
        	    case 1: // Champ
        	    {
                if(
					pmodelid[playerid] == 401 ||
					pmodelid[playerid] == 492 ||
					pmodelid[playerid] == 546 ||
					pmodelid[playerid] == 426 ||
					pmodelid[playerid] == 550)
			    	{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1004);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1004);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 492) // greenwood
			        	{
			            AddVehicleComponent(car,1004);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 426) // premier
			        	{
			            AddVehicleComponent(car,1004);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1004);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
					}
					else
					{
					SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
					}
        	    }
				case 2: // Race
        	    {
                if(
					pmodelid[playerid] == 549)
			    	{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1011);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
					}
					else
					{
					SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
					}
        	    }
        	    case 3: // Worx
        	    {
                if(
					pmodelid[playerid] == 549)
			    	{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1012);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
						}
					}
					else
					{
					SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
					ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
					}
        	    }
				case 4:
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
        	    }
				case 5: // Back
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
			}
		}
	}
	////////////////////////////////////////end of hoods///////////
    if(dialogid == DIALOG_TYPE_VENTS)//////////////////VENTS//////////////////
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:// Oval
        	    {
     				if(
					pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 547 ||//primo
					pmodelid[playerid] == 439 ||//stallion
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549)//tampa
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 547) // primo
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 439) // stallion
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1142);
			            AddVehicleComponent(car,1143);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
        	    	}
        	    	else
						{
							SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
							ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
				}
        	    case 1: // Square
        	    {
                if(
					pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 589 ||//club
					pmodelid[playerid] == 546 ||//intruder
					pmodelid[playerid] == 517 ||//majestic
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 439 ||//stallion
					pmodelid[playerid] == 550 ||//sunrise
					pmodelid[playerid] == 549)//tampa
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 546) // intruder
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 517) // majestic
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 439) // stallion
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 550) // sunrise
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 549) // tampa
			        	{
			            AddVehicleComponent(car,1144);
			            AddVehicleComponent(car,1145);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
        	    	}
              			else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
        	    }
				case 2: // _
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
        	    }
        	    case 3: // Back
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
			}
		}
	}


	///////////END OF VENTS///////////
	if(dialogid == DIALOG_TYPE_LIGHTS)//////////////////LIGTS//////////////////
    {
        if(!response)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(response)
        {
           	switch(listitem)// Checking which list item was selected
        	{
        	    case 0:// round
        	    {
     				if(
					pmodelid[playerid] == 401 ||//bravura
					pmodelid[playerid] == 518 ||//buccaneer
					pmodelid[playerid] == 589 ||//club
					pmodelid[playerid] == 400 ||//landstalker
					pmodelid[playerid] == 436 ||//previon
					pmodelid[playerid] == 439)//stallion
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 401) // bravura
			        	{
               			AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
               			ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 518) // buccaneer
			        	{
			            AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
               			ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
           			 	ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 436) // previon
			        	{
			            AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 439) // stallion
			        	{
			            AddVehicleComponent(car,1013);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
        	    	}
                    else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
				}
        	    case 1: // Square
        	    {
                if(
					pmodelid[playerid] == 589 ||//club
					pmodelid[playerid] == 603 ||//phoenix
					pmodelid[playerid] == 400)//landstalker
					{
			        	new car = GetPlayerVehicleID(playerid);
			        	if(pmodelid[playerid] == 589) // club
			        	{
			            AddVehicleComponent(car,1024);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 603) // phoenix
			        	{
			            AddVehicleComponent(car,1024);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
			            ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
			        	if(pmodelid[playerid] == 400) // landstalker
			        	{
			            AddVehicleComponent(car,1024);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                        ShowPlayerDialog(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
						}
        	    	}
        	    	else
						{
						SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component on your car.");
						ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
						}
        	    }
				case 2: // _
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
        	    }
        	    case 3: // Back
        	    {
                ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
        	    }
			}
		}
	}
	return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
return 1;
}
