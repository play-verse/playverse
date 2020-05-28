/*		
	~ Features
	
	 * You can buy more than one vehicle.
	 * You can give your vehicle's keys to someone else.
	 * You can make your car visually disappear by putting it into the garage. 
	 * When you lost your vehicle, you can mark it on the map by choosing 'Where Is My Car?' option in the vehicle menu.
	 * By Quick Park feature, you can make your vehicle automatically park when you get off it.
	 * You can sell your vehicle to someone else or the dealer whenever you want.
	 * You can see your own vehicles and the vehicles that you have their keys by typing '/v'
	 
		For Detailed Introduction: http://xpdevil.com/2017/04/04/fs-xvehicle-v2-arac-sistemi-mysql
		For More: http://xpdevil.com
		
*/
																																	  
#include <a_samp>
#include <a_mysql>
#include <zcmd>
#include <sscanf2>
#include <YSI\y_iterate>

// MySQL Bilgileri:
#define		SQL_HOST			"localhost"
#define		SQL_USER			"root"
#define		SQL_PASSWORD		""
#define		SQL_DBNAME			"server_samp"
//-----------------

// Settings (You can change this setting as you want):
#define OYUNCU_MAX_ARAC	5	// Maximum car amount that one player can buy.
#define GARAJ_MAX_ARAC	3	// Maximum car amount that one player can put into the garage.
//-----------------

// Tan�mlamalar:
#define XV_DIALOGID 3500 // If dialogs make trouble, only change this ID.

enum xv_data
{
	xv_Veh,
	xv_ModelID,
	xv_Renk[2],
	Float:xv_Pos[4],
	xv_Paintjob,
	xv_Parca[14],
	xv_Sahip[24],
	xv_Plaka[8],
	xv_Garajda,
	Text3D:xv_Text,
	xv_Fiyat,
	xv_HizliPark
};

new 
	xVehicle[MAX_VEHICLES][xv_data],
	xVeh[MAX_VEHICLES],
	offerTimer[MAX_PLAYERS],
	Iterator:xVehicles<MAX_VEHICLES>,
	Iterator:xVehicleKeys<MAX_PLAYERS, MAX_VEHICLES>,	
	MySQL:mysqlB
;

new VehicleNames[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
	"Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
	"Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "BerkleysRCVan",
	"Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale",
	"Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
	"Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "NewsChopper",
	"Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"BlistaCompact", "PoliceMaverick", "Boxvillde", "Benson", "Mesa", "RCGoblin",
	"HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT",
	"Elegant", "Journey", "Bike", "MountainBike", "Beagle", "Cropduster", "Stunt",
 	"Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
 	"FCR-900", "NRG-500", "HPV1000", "CementTruck", "TowTruck", "Fortune",
 	"Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
 	"Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
    "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
	"Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
	"Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratium",
	"Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper",
	"Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
	"News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"FreightBox", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD",
 	"SFPD", "LVPD", "PoliceRanger", "Picador", "S.W.A.T", "Alpha",
 	"Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville",
 	"Tiller", "UtilityTrailer"
};

public OnFilterScriptInit()
{
	print("[xVeh MySql] Connecting to database...");

	mysqlB = mysql_connect(SQL_HOST, SQL_USER, SQL_PASSWORD, SQL_DBNAME); 
	mysql_log(ALL); 
	if (mysql_errno(mysqlB) == 0) print("[xVeh MySql] Connection successful!");
	else print("[xVeh MySql] The connection has failed!\n\n[!!! xVehicle v2 couldn't init !!!]\n\n");
	
	new query[1024];
	
	strcat(query, "CREATE TABLE IF NOT EXISTS `xVehicle` (\
	  `ID` int(11),\
	  `Sahip` varchar(48) default '',\
	  `Fiyat` int(11) default '0',\
	  `X` float default '0',\
	  `Y` float default '0',\
	  `Z` float default '0',\
	  `A` float default '0',\
	  `HizliPark` int(2) default '0',\
	  `Model` int(5) default '0',\
	  `Renk1` int(5) default '0',\
	  `Renk2` int(5) default '0',\
	  `Plaka` varchar(8),\
	  `Garajda` int(2) default '0',\
	  `PJ` int(5) default '-1',");
	  
	strcat(query, "`Parca1` int(8) default '0',\
	  `Parca2` int(8) default '0',\
	  `Parca3` int(8) default '0',\
	  `Parca4` int(8) default '0',\
	  `Parca5` int(8) default '0',\
	  `Parca6` int(8) default '0',\
	  `Parca7` int(8) default '0',\
	  `Parca8` int(8) default '0',");
	  
	  
	strcat(query, "`Parca9` int(8) default '0',\
	  `Parca10` int(8) default '0',\
	  `Parca11` int(8) default '0',\
	  `Parca12` int(8) default '0',\
	  `Parca13` int(8) default '0',\
	  `Parca14` int(8) default '0',\
	    PRIMARY KEY  (`ID`),\
		UNIQUE KEY `ID_2` (`ID`),\
		KEY `ID` (`ID`)\
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
		
	mysql_query(mysqlB, query);
	
	mysql_query(mysqlB, "CREATE TABLE IF NOT EXISTS `xVehicleKeys` (\
	  `AracID` int(11) NOT NULL,\
	  `Isim` varchar(24) NOT NULL\
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
	
	Iter_Add(xVehicles, 0);
	
	mysql_tquery(mysqlB, "SELECT * FROM `xVehicle`", "LoadxVehicles");
	return 1;
}

/* --[ Komutlar Ba�lang�� ]-- */

CMD:park(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}You have to be in a vehicle to use that command!");
	new xid = xVeh[GetPlayerVehicleID(playerid)];
	if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}You can't park this vehicle! This car is not in the vehicle system");
	if(xStrcmp(Isim(playerid), xVehicle[xid][xv_Sahip]) && !Iter_Contains(xVehicleKeys<playerid>, xid) && !IsPlayerAdmin(playerid)) return  SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}You can't park this vehicle because of you don't have this car's keys!");
	if(xVehicle[xid][xv_HizliPark]) SendClientMessage(playerid, -1, "{00BD00}[!] {00FF00}Your vehicle has parked! {FFFB93}Quick Park feature deactivated!");
	else SendClientMessage(playerid, -1, "{00BD00}[!] {00FF00}Your vehicle has parked!");
	xVehicle[xid][xv_HizliPark] = 0;
	GetVehiclePos(GetPlayerVehicleID(playerid), xVehicle[xid][xv_Pos][0], xVehicle[xid][xv_Pos][1], xVehicle[xid][xv_Pos][2]);
	GetVehicleZAngle(GetPlayerVehicleID(playerid), xVehicle[xid][xv_Pos][3]);
	SavexVehicle(xid);
	return 1;
}

CMD:v(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid) && xVeh[GetPlayerVehicleID(playerid)] != 0) ShowPlayerDialog(playerid, XV_DIALOGID+6, DIALOG_STYLE_LIST, "Vehicle Menu", "{DCDC22}� {FFFB93}This Vehicle\n{DCDC22}� {FFFB93}My Own Vehicles\n{DCDC22}� {FFFB93}Vehicles That I Have Keys", "Select", "Close");
	else ShowPlayerDialog(playerid, XV_DIALOGID+6, DIALOG_STYLE_LIST, "Vehicle Menu", "{DCDC22}� {FFFB93}My Own Vehicles\n{DCDC22}� {FFFB93}Vehicles That I Have Keys", "Select", "Close");
	return 1;
}

CMD:amenu(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Only admins can use that command!");
	ShowPlayerDialog(playerid, XV_DIALOGID+16, DIALOG_STYLE_LIST, "xVehicle Admin Menu", "{DCDC22}� {FFFB93}All Vehicles\n{DCDC22}� {FFFB93}Respawn All Vehicles\n{DCDC22}� {FFFB93}Create Vehicle", "Select", "Close");
	return 1;
}

/* --[Komutlar Biti�]-- */

public OnPlayerConnect(playerid)
{
	SetPVarInt(playerid, "xv_teklif_id", INVALID_PLAYER_ID);
	SetPVarInt(playerid, "xv_teklif_gonderen", INVALID_PLAYER_ID);
	LoadxVehicleKeys(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(GetPVarInt(playerid, "xv_teklif_gonderen") != INVALID_PLAYER_ID)
	{
		new gonderen = GetPVarInt(playerid, "xv_teklif_gonderen");
		KillTimer(offerTimer[playerid]);
		SetPVarInt(gonderen, "xv_teklif_id", INVALID_PLAYER_ID);
		SendClientMessage(gonderen, -1, "{FF0000}[!] {DCDC22}Your vehicle offer has cancelled because of the player that you offered has disconnected.");
	}
	
	if(GetPVarInt(playerid, "xv_teklif_id") != INVALID_PLAYER_ID)
	{
		new alan = GetPVarInt(playerid, "xv_teklif_id");
		SetPVarInt(alan, "xv_teklif_gonderen", INVALID_PLAYER_ID);
		DeletePVar(alan, "xv_teklif_xid");
		DeletePVar(alan, "xv_teklif_fiyat");
		KillTimer(offerTimer[alan]);
		SendClientMessage(alan, -1, "{FF0000}[!] {DCDC22}The offer has cancelled because of the player that make the offer has disconnected.");
	}
	
	if(IsPlayerInAnyVehicle(playerid))
	{
		new xid = xVeh[GetPlayerVehicleID(playerid)], Float:xvHP;
		GetVehicleHealth(GetPlayerVehicleID(playerid), xvHP);
		if(xid != 0 && xVehicle[xid][xv_HizliPark] == 1 && !IsVehicleFlipped(GetPlayerVehicleID(playerid)) && xvHP > 300)
		{
			GetVehiclePos(GetPlayerVehicleID(playerid), xVehicle[xid][xv_Pos][0], xVehicle[xid][xv_Pos][1], xVehicle[xid][xv_Pos][2]);
			GetVehicleZAngle(GetPlayerVehicleID(playerid), xVehicle[xid][xv_Pos][3]);
			SavexVehicle(xid);
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		new xid = xVeh[GetPlayerVehicleID(playerid)];
		if(xid != 0)
		{
			if(!strlen(xVehicle[xid][xv_Sahip]))
			{
				new str[512];
				format(str, sizeof str, "{FFFFFF}---------------------------[Vehicle For Sale]---------------------------\n", str);
				format(str, sizeof str, "%s\n", str);
				format(str, sizeof str, "%s{00D700}This Vehicle Is For Sale!\n", str);
				format(str, sizeof str, "%s\n{0098FF}Vehicle Name: {FFFF00}%s\n", str, GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]));
				format(str, sizeof str, "%s{0098FF}Plate Number: {FFFF00}%s\n", str, xVehicle[xid][xv_Plaka]);
				format(str, sizeof str, "%s{0098FF}Price: {FFFF00}$%d\n", str, xVehicle[xid][xv_Fiyat]);
				format(str, sizeof str, "%s\n{FF8000}Do you want to buy this vehicle?{00D700}\n", str);
				format(str, sizeof str, "%s\n{FFFFFF}-------------------------------------------------------------------------", str);
				ShowPlayerDialog(playerid, XV_DIALOGID+5, DIALOG_STYLE_MSGBOX, "Vehicle For Sale", str, "Buy", "Close");
			}
			else if(xStrcmp(Isim(playerid), xVehicle[xid][xv_Sahip]) && !Iter_Contains(xVehicleKeys<playerid>, xid))
			{
				SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}You don't have this car's keys!");
				RemovePlayerFromVehicle(playerid);
			}
			else
			{
				SendClientMessage(playerid, -1, "{00FF00}[!] {DCDC22}Type {ECB021}/v {DCDC22}for the vehicle menu.");
			}
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	new xid = xVeh[vehicleid], Float:xvHP;
	GetVehicleHealth(vehicleid, xvHP);
	if(xid != 0 && xVehicle[xid][xv_HizliPark] == 1 && !IsVehicleFlipped(vehicleid) && xvHP > 300)
	{
		GetVehiclePos(vehicleid, xVehicle[xid][xv_Pos][0], xVehicle[xid][xv_Pos][1], xVehicle[xid][xv_Pos][2]);
		GetVehicleZAngle(vehicleid, xVehicle[xid][xv_Pos][3]);
		SavexVehicle(xid);
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	new xid = xVeh[vehicleid];
	if(xid != 0)
	{
		DestroyVehicle(xVehicle[xid][xv_Veh]);
		xVehicle[xid][xv_Veh] = CreateVehicle(xVehicle[xid][xv_ModelID], xVehicle[xid][xv_Pos][0], xVehicle[xid][xv_Pos][1], xVehicle[xid][xv_Pos][2], xVehicle[xid][xv_Pos][3], xVehicle[xid][xv_Renk][0], xVehicle[xid][xv_Renk][1], -1);
		xVeh[xVehicle[xid][xv_Veh]] = xid;
		SetVehicleNumberPlate(xVehicle[xid][xv_Veh], xVehicle[xid][xv_Plaka]);
		LoadVehicleMod(xid);
	}
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	new xid = xVeh[vehicleid];
	if(xid != 0)
    {
		xVehicle[xid][xv_Renk][0] = color1;
		xVehicle[xid][xv_Renk][1] = color2;
    }
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	new xid = xVeh[vehicleid];
	if(xid != 0) xVehicle[xid][xv_Paintjob] = paintjobid;
    return 1;
}

public OnVehicleMod(playerid,vehicleid,componentid)
{
	new xid = xVeh[vehicleid];
	if(xid != 0)
	{
		for(new i; i<14; i++)
		{
			xVehicle[xid][xv_Parca][i] = GetVehicleComponentInSlot(vehicleid, i);
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	DisablePlayerCheckpoint(playerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == XV_DIALOGID)
	{		
		if(response)
		{
			new tmp[8], xid;
			GetPVarString(playerid, "selected_veh_plate", tmp, 8);
			xid = GetVehiclexIDFromPlate(tmp);
			if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			
			switch(listitem)
			{
				case 0: // arac nerede?
				{
					if(xVehicle[xid][xv_Garajda])
					{
						if(!xStrcmp(xVehicle[xid][xv_Sahip], Isim(playerid))) ShowPlayerDialog(playerid, XV_DIALOGID+4, DIALOG_STYLE_MSGBOX, "Where Is My Car?", "{FFA500}This vehicle is in the garage. You can take it from the garage by choosing the option in the vehicle menu.", "Back", "");
						else ShowPlayerDialog(playerid, XV_DIALOGID+4, DIALOG_STYLE_MSGBOX, "Where Is My Car?", "{FFA500}This vehicle is in the garage. Only the vehicle owner can take it out from the garage.", "Back", "");
					}
					else
					{
						new Float:vpos[3];
						GetVehiclePos(xVehicle[xid][xv_Veh], vpos[0], vpos[1], vpos[2]);
						SetPlayerCheckpoint(playerid, vpos[0], vpos[1], vpos[2], 3);
						SendClientMessage(playerid, -1, "{00BD00}[!] {00FF00}Vehicle has marked on the map!");
					}
				}
				case 1: // garaj sok/��kar
				{
					if(xStrcmp(xVehicle[xid][xv_Sahip], Isim(playerid))) return ShowPlayerDialog(playerid, XV_DIALOGID+4, DIALOG_STYLE_MSGBOX, inputtext, "{FF0000}[ERROR] {FFA500}Only the vehicle owner can use this feature!", "Back", "");
					if(xVehicle[xid][xv_Garajda])
					{
						new str[128];
						GetPlayerPos(playerid, xVehicle[xid][xv_Pos][0], xVehicle[xid][xv_Pos][1], xVehicle[xid][xv_Pos][2]);
						GetPlayerFacingAngle(playerid, xVehicle[xid][xv_Pos][3]);
						xVehicle[xid][xv_Pos][3] += 90;
						GetXYInFrontOfPlayer(playerid, xVehicle[xid][xv_Pos][0], xVehicle[xid][xv_Pos][1], 3);
						xVehicle[xid][xv_Veh] = CreateVehicle(xVehicle[xid][xv_ModelID], xVehicle[xid][xv_Pos][0], xVehicle[xid][xv_Pos][1], xVehicle[xid][xv_Pos][2], xVehicle[xid][xv_Pos][3], xVehicle[xid][xv_Renk][0], xVehicle[xid][xv_Renk][1], -1);
						xVeh[xVehicle[xid][xv_Veh]] = xid;
						SetVehicleNumberPlate(xVehicle[xid][xv_Veh], xVehicle[xid][xv_Plaka]);
						SetVehicleToRespawn(xVehicle[xid][xv_Veh]);
						xVehicle[xid][xv_Garajda] = 0;
						SavexVehicle(xid);
						format(str, sizeof(str), "{ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number has taken from the garage!", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka]);
						SendClientMessage(playerid, -1, str);
					}
					else
					{
						if(GetPlayerInGarageVehicleCount(playerid) >= GARAJ_MAX_ARAC) return SendClientMessage(playerid, -1, "{FF0000}[!] {DCDC22}You have reached the limit! You can't put more vehicles into the garage.");
						new str[128];
						DestroyVehicle(xVehicle[xid][xv_Veh]);
						xVehicle[xid][xv_Garajda] = 1;
						SavexVehicle(xid);
						format(str, sizeof(str), "{ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number has put into the garage!", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka]);
						SendClientMessage(playerid, -1, str);
					}
				}
				case 2:
				{
					new str[288];
					format(str, sizeof(str), "{FFFB93}Quick Park is a system that parks your vehicle automatically when you get off the vehicle.\nWhen you get off the car, if the vehicle isn't upside down or the vehicle's health more than 300 your vehicle will be parked, otherwise not.\n\nQuick Park is currently %s", (xVehicle[xid][xv_HizliPark]) ? ("{00FF00}Active") : ("{FF0000}Deactive"));
					ShowPlayerDialog(playerid, XV_DIALOGID+1, DIALOG_STYLE_MSGBOX, "Quick Park", str, (xVehicle[xid][xv_HizliPark]) ? ("Deactivate") : ("Activate"), "Back");
				}
				case 3: 
				{
					if(xStrcmp(xVehicle[xid][xv_Sahip], Isim(playerid))) return ShowPlayerDialog(playerid, XV_DIALOGID+4, DIALOG_STYLE_MSGBOX, "Vehicle Keys", "{FF0000}[ERROR] {FFA500}Only the vehicle owner can use this feature!", "Back", "");
					ShowPlayerDialog(playerid, XV_DIALOGID+2, DIALOG_STYLE_LIST, "Vehicle Keys", "{DCDC22}� {FFFB93}View Key Owners\n{DCDC22}� {FFFB93}Give Someone Key\n{DCDC22}� {FFFB93}Change the Lock", "Select", "Back");
				}
				case 4:
				{
					if(xStrcmp(xVehicle[xid][xv_Sahip], Isim(playerid))) return ShowPlayerDialog(playerid, XV_DIALOGID+4, DIALOG_STYLE_MSGBOX, "Vehicle Sale", "{FF0000}[ERROR] {FFA500}Only the vehicle owner can use this feature!", "Back", "");
					ShowPlayerDialog(playerid, XV_DIALOGID+8, DIALOG_STYLE_LIST, "Sell The Vehicle", "{DCDC22}� {FFFB93}Sell To Car Dealer\n{DCDC22}� {FFFB93}Sell To Player", "Select", "Back");
				}
				case 5:
				{
					new str[256];
					format(str, sizeof(str), "{FFFFFF}----------[ Vehicle Information ]----------\n\n{F0AE0F}-� {ECE913}Owner: {FFFFFF}%s\n{F0AE0F}-� {ECE913}Vehicle Name: {FFFFFF}%s\n{F0AE0F}-� {ECE913}Plate Number: {FFFFFF}%s", xVehicle[xid][xv_Sahip], GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka]);
					ShowPlayerDialog(playerid, XV_DIALOGID+4, DIALOG_STYLE_MSGBOX, " Vehicle Information", str, "Back", "");
				}
			}
		}
		else
		{
			DeletePVar(playerid, "selected_veh_plate");
			cmd_v(playerid, "");
		}
	}
	
	if(dialogid == XV_DIALOGID+1)
	{
		new tmp[8], xid;
		GetPVarString(playerid, "selected_veh_plate", tmp, 8);
		xid = GetVehiclexIDFromPlate(tmp);
		if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
		
		if(response)
		{
			switch(xVehicle[xid][xv_HizliPark])
			{
				case 0:
				{
					SendClientMessage(playerid, -1, "{00BD00}[!] {00FF00}Quick Park has activated!");
					xVehicle[xid][xv_HizliPark] = 1;
					xvMenuGoster(playerid);
				}
				case 1:
				{
					SendClientMessage(playerid, -1, "{00BD00}[!] {00FF00}Quick Park has deactivated!");
					xVehicle[xid][xv_HizliPark] = 0;
					xvMenuGoster(playerid);
				}
			}
		} else xvMenuGoster(playerid);
	}
	
	if(dialogid == XV_DIALOGID+2)
	{
		if(response)
		{
			new tmp[8], xid;
			GetPVarString(playerid, "selected_veh_plate", tmp, 8);
			xid = GetVehiclexIDFromPlate(tmp);
			if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			
			switch(listitem)
			{
				case 0:
				{
					new query[128], Cache:keys;
					mysql_format(mysqlB, query, sizeof(query), "SELECT Isim FROM xVehicleKeys WHERE AracID=%d ORDER BY AracID DESC LIMIT %d, 15", xid, GetPVarInt(playerid, "xvKeysPage")*15);
					keys = mysql_query(mysqlB, query);
					new rows = cache_num_rows();
					if(rows) 
					{
						new list[512], o_isim[MAX_PLAYER_NAME];
						format(list, sizeof(list), "Player Name\n");
						for(new i; i < rows; ++i)
						{
							cache_get_value_name(i, "Isim", o_isim);
							format(list, sizeof(list), "%s%s\n", list, o_isim);
						}
						format(list, sizeof(list), "%s{F4D00B}<< Previous Page\n{F4D00B}>> Next Page", list);
						ShowPlayerDialog(playerid, XV_DIALOGID+3, DIALOG_STYLE_TABLIST_HEADERS, "Key Owners (Page 1)", list, "Select", "Back");
					}
					else
					{
						SendClientMessage(playerid, 0xE74C3CFF, "No one has your vehicle's keys!");
					}
					cache_delete(keys);
				}
				case 1:  ShowPlayerDialog(playerid, XV_DIALOGID+13, DIALOG_STYLE_INPUT, "Give Vehicle Key", "{FFFB93}Enter the player's ID or name that you want to give the key:", "Next", "Back");
				case 2: 
				{
					ShowPlayerDialog(playerid, XV_DIALOGID+15, DIALOG_STYLE_MSGBOX, "Change The Lock", "{FFFB93}Are you sure that you want to change the lock?\nAll keys will be removed from key owners.", "Confirm", "Back");
				}
			}
		} else xvMenuGoster(playerid);
	}
	
	if(dialogid == XV_DIALOGID+3)
	{
		if(response)
		{
			new tmp[8], xid;
			GetPVarString(playerid, "selected_veh_plate", tmp, 8);
			xid = GetVehiclexIDFromPlate(tmp);
			if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			
			if(!xStrcmp(inputtext, "<< Previous Page"))
			{
				SetPVarInt(playerid, "xvKeysPage", GetPVarInt(playerid, "xvKeysPage")-1);
				if(GetPVarInt(playerid, "xvKeysPage") < 0)
				{
					SetPVarInt(playerid, "xvKeysPage", 0);
					ShowPlayerDialog(playerid, XV_DIALOGID+2, DIALOG_STYLE_LIST, "Vehicle Keys", "{DCDC22}� {FFFB93}View Key Owners\n{DCDC22}� {FFFB93}Give Someone Key\n{DCDC22}� {FFFB93}Change the Lock", "Select", "Back");
					return 1;
				}
				
				new query[128], Cache:keys;
				mysql_format(mysqlB, query, sizeof(query), "SELECT Isim FROM xVehicleKeys WHERE AracID=%d ORDER BY AracID DESC LIMIT %d, 15", xid, GetPVarInt(playerid, "xvKeysPage")*15);
				keys = mysql_query(mysqlB, query);
				new rows = cache_num_rows();
				if(rows)
				{
					new list[512], o_isim[MAX_PLAYER_NAME];
					format(list, sizeof(list), "Player Name\n");
					for(new i; i < rows; ++i)
					{
						cache_get_value_name(i, "Isim", o_isim);
						format(list, sizeof(list), "%s%s\n", list, o_isim);
					}
					format(list, sizeof(list), "%s{F4D00B}<< Previous Page\n{F4D00B}>> Next Page", list);
					new head[32];
					format(head, sizeof(head), "Key Owners (Page %d)", GetPVarInt(playerid, "xvKeysPage")+1);
					ShowPlayerDialog(playerid, XV_DIALOGID+3, DIALOG_STYLE_TABLIST_HEADERS, head, list, "Select", "Back");
				}
				else
				{
					/*SetPVarInt(playerid, "xvKeysPage", 0);
					ShowPlayerDialog(playerid, XV_DIALOGID+2, DIALOG_STYLE_LIST, "Arac�n Anahtarlar�", "Anahtar� Olanlar� G�r\nBirine Anahtar Ver\nKilidi De�i�tir", "Select", "Back");
					*/
					SendClientMessage(playerid, 0xE74C3CFF, "There is no more key owners!");
				}
				cache_delete(keys);
			}
			else if(!xStrcmp(inputtext, ">> Next Page"))
			{
				SetPVarInt(playerid, "xvKeysPage", GetPVarInt(playerid, "xvKeysPage")+1);
			
				new query[128], Cache:keys;
				mysql_format(mysqlB, query, sizeof(query), "SELECT Isim FROM xVehicleKeys WHERE AracID=%d ORDER BY AracID DESC LIMIT %d, 15", xid, GetPVarInt(playerid, "xvKeysPage")*15);
				keys = mysql_query(mysqlB, query);
				new rows = cache_num_rows();
				if(rows)
				{
					new list[512], o_isim[MAX_PLAYER_NAME];
					format(list, sizeof(list), "Player Name\n");
					for(new i; i < rows; ++i)
					{
						cache_get_value_name(i, "Isim", o_isim);
						format(list, sizeof(list), "%s%s\n", list, o_isim);
					}
					format(list, sizeof(list), "%s{F4D00B}<< Previous Page\n{F4D00B}>> Next Page", list);
					new head[32];
					format(head, sizeof(head), "Key Owners (Sayfa %d)", GetPVarInt(playerid, "xvKeysPage")+1);
					ShowPlayerDialog(playerid, XV_DIALOGID+3, DIALOG_STYLE_TABLIST_HEADERS, head, list, "Select", "Back");
				}
				else
				{
					SetPVarInt(playerid, "xvKeysPage", GetPVarInt(playerid, "xvKeysPage") - 1);
					mysql_format(mysqlB, query, sizeof(query), "SELECT Isim FROM xVehicleKeys WHERE AracID=%d ORDER BY AracID DESC LIMIT %d, 15", xid, GetPVarInt(playerid, "xvKeysPage")*15);
					keys = mysql_query(mysqlB, query);
					rows = cache_num_rows();
					if(rows)
					{
						new list[512], o_isim[MAX_PLAYER_NAME];
						format(list, sizeof(list), "Player Name\n");
						for(new i; i < rows; ++i)
						{
							cache_get_value_name(i, "Isim", o_isim);
							format(list, sizeof(list), "%s%s\n", list, o_isim);
						}
						format(list, sizeof(list), "%s{F4D00B}<< Previous Page\n{F4D00B}>> Next Page", list);
						new head[32];
						format(head, sizeof(head), "Key Owners (Sayfa %d)", GetPVarInt(playerid, "xvKeysPage")+1);
						ShowPlayerDialog(playerid, XV_DIALOGID+3, DIALOG_STYLE_TABLIST_HEADERS, head, list, "Select", "Back");
					}
					SendClientMessage(playerid, 0xE74C3CFF, "There is no more key owners!");
				}
				cache_delete(keys);
			}
			else
			{
				SetPVarString(playerid, "tmp_keyname", inputtext);
				ShowPlayerDialog(playerid, XV_DIALOGID+14, DIALOG_STYLE_LIST, "Vehicle Key", "{DCDC22}� {FFFB93}Take The Key Back", "Apply", "Back");
			}
		}
	}
	
	if(dialogid == XV_DIALOGID+4) xvMenuGoster(playerid);
	
	if(dialogid == XV_DIALOGID+5)
	{
		if(response)
		{
			new xid = xVeh[GetPlayerVehicleID(playerid)];
			if(GetPlayerxVehicleCount(playerid) >= OYUNCU_MAX_ARAC) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}You have reached the limit! You can't buy more vehicle."), RemovePlayerFromVehicle(playerid);
			if(GetPlayerMoney(playerid) < xVehicle[xid][xv_Fiyat]) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}You don't have enough money!"), RemovePlayerFromVehicle(playerid);
			GivePlayerMoney(playerid, -xVehicle[xid][xv_Fiyat]);
			format(xVehicle[xid][xv_Sahip], 24, "%s", Isim(playerid));
			SavexVehicle(xid);
			Delete3DTextLabel(xVehicle[xid][xv_Text]);
			SendClientMessage(playerid, -1, "{00BD00}[!] {00FF00}You have succesfully bought this vehicle! You can manage your vehicles by typing {ECB021}/v");
		} 
		else
		{
		if(!IsPlayerAdmin(playerid)) RemovePlayerFromVehicle(playerid);
		}
	}
	
	if(dialogid == XV_DIALOGID+6)
	{
		if(response)
		{
			if(!xStrcmp(inputtext, "� This Vehicle"))
			{
				SetPVarString(playerid, "selected_veh_plate", xVehicle[xVeh[GetPlayerVehicleID(playerid)]][xv_Plaka]);
				xvMenuGoster(playerid);
			}
			else if(!xStrcmp(inputtext, "� My Own Vehicles"))
			{
				new str[256], cnt;
				format(str, sizeof(str), "Plate Number\tVehicle Name\tState");
				foreach(new i : xVehicles)
				{
					if(!xStrcmp(xVehicle[i][xv_Sahip], Isim(playerid))) format(str, sizeof(str), "%s\n%s\t%s\t%s", str, xVehicle[i][xv_Plaka], GetVehicleNameFromModel(xVehicle[i][xv_ModelID]), (xVehicle[i][xv_Garajda]) ? ("{F0CE0F}In the Garage") : ("{8FE01F}On the Map")), cnt++;
				}
				if(!cnt) ShowPlayerDialog(playerid, XV_DIALOGID-1, DIALOG_STYLE_MSGBOX, "My Own Vehicles", "{FF0000}[!] {F0AE0F}You don't have any vehicle!", "OK", "");
				else ShowPlayerDialog(playerid, XV_DIALOGID+7, DIALOG_STYLE_TABLIST_HEADERS, "My Own Vehicles", str, "Choose Car", "Back");
			}
			else if(!xStrcmp(inputtext, "� Vehicles That I Have Keys"))
			{
				new str[256], cnt;
				format(str, sizeof(str), "Plate Number\tVehicle Name\tState");
				foreach(new i : xVehicleKeys<playerid>)
				{
					format(str, sizeof(str), "%s\n%s\t%s\t%s", str, xVehicle[i][xv_Plaka], GetVehicleNameFromModel(xVehicle[i][xv_ModelID]), (xVehicle[i][xv_Garajda]) ? ("{F0CE0F}In the Garage") : ("{8FE01F}On the Map"));
					cnt++;
				}
				if(!cnt) ShowPlayerDialog(playerid, XV_DIALOGID-1, DIALOG_STYLE_MSGBOX, "Vehicles That I Have Keys", "{FFA500}You don't have any vehicle's keys!", "OK", "");
				else ShowPlayerDialog(playerid, XV_DIALOGID+7, DIALOG_STYLE_TABLIST_HEADERS, "Vehicles That I Have Keys", str, "Choose Car", "Back");
			}
		}
	}
	
	if(dialogid == XV_DIALOGID+7)
	{
		if(response)
		{
		    new tmp[2][8];
			split(inputtext, tmp, '\t');
			SetPVarString(playerid, "selected_veh_plate", tmp[0]);
			xvMenuGoster(playerid);
		} else cmd_v(playerid, "");
	}
	
	if(dialogid == XV_DIALOGID+8)
	{
		if(response)
		{
			new str[256], tmpp[8], xid;
			GetPVarString(playerid, "selected_veh_plate", tmpp, 8);
			xid = GetVehiclexIDFromPlate(tmpp);
			if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			
			switch(listitem)
			{
				case 0:
				{
					format(str, sizeof(str), "{ECCB13}Are you sure that you want to sell your vehicle to car dealer?\n{FFFB93}Amount of payment: {15EC13}$%d\n\n{AAAAAA}(Payment is %%70 of the price that you bought)", (xVehicle[xid][xv_Fiyat] / 100) * 70);
					ShowPlayerDialog(playerid, XV_DIALOGID+9, DIALOG_STYLE_MSGBOX, "Sell Vehicle To Car Dealer", str, "Confirm", "Back");
				}
				case 1:
				{
					if(GetPVarInt(playerid, "xv_teklif_id") != INVALID_PLAYER_ID) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}You already offered to a player! Wait for the response for that offer.");
					if(xVehicle[xid][xv_Garajda]) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Before you sell your vehicle, take it out from the garage!");
					ShowPlayerDialog(playerid, XV_DIALOGID+10, DIALOG_STYLE_INPUT, "Sell Vehicle to Player", "{FFFB93}Enter the name or ID of the player that you want to sell your vehicle:", "Next", "Back");
				}
			}
		} else xvMenuGoster(playerid);
	}
	
	if(dialogid == XV_DIALOGID+9)
	{
		if(response)
		{
			new query[128], tmpp[8], xid;
			GetPVarString(playerid, "selected_veh_plate", tmpp, 8);
			xid = GetVehiclexIDFromPlate(tmpp);
			if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			
			GivePlayerMoney(playerid, (xVehicle[xid][xv_Fiyat] / 100) * 70);
			if(IsValidVehicle(xVehicle[xid][xv_Veh])) DestroyVehicle(xVehicle[xid][xv_Veh]);
			Iter_Remove(xVehicles, xid);
			DeletePVar(playerid, "selected_veh_plate");
			foreach(new i : Player)
			{
				if(Iter_Contains(xVehicleKeys<i>, xid)) Iter_Remove(xVehicleKeys<i>, xid);
			}

			mysql_format(mysqlB, query, sizeof(query), "DELETE FROM xVehicleKeys WHERE AracID=%d", xid);
			mysql_query(mysqlB, query);
			mysql_format(mysqlB, query, sizeof(query), "DELETE FROM xVehicle WHERE ID=%d", xid);
			mysql_query(mysqlB, query);
			SendClientMessage(playerid, -1, "{00BD00}[!] {00FF00}You sold your vehicle!");
		} else ShowPlayerDialog(playerid, XV_DIALOGID+8, DIALOG_STYLE_LIST, "Sell The Vehicle", "{DCDC22}� {FFFB93}Sell To Car Dealer\n{DCDC22}� {FFFB93}Sell To Player", "Select", "Back");
	}
	
	if(dialogid == XV_DIALOGID+10)
	{
		if(response)
		{
			new pid;
			if(sscanf(inputtext, "u", pid)) return ShowPlayerDialog(playerid, XV_DIALOGID+10, DIALOG_STYLE_INPUT, "Sell Vehicle to Player", "{FF0000}[!] {F0AE0F}You wrote nothing!\n\n{FFFB93}Enter the name or ID of the player that you want to sell your vehicle:", "Next", "Back");
			if(!IsPlayerConnected(pid)) return ShowPlayerDialog(playerid, XV_DIALOGID+10, DIALOG_STYLE_INPUT, "Sell Vehicle to Player", "{FF0000}[!] {F0AE0F}Player is not connected!\n\n{FFFB93}Enter the name or ID of the player that you want to sell your vehicle:", "Next", "Back");
			if(GetPlayerxVehicleCount(playerid) >= OYUNCU_MAX_ARAC) return ShowPlayerDialog(playerid, XV_DIALOGID+10, DIALOG_STYLE_INPUT, "Sell Vehicle to Player", "{FF0000}[!] {F0AE0F}This player has reached the limit! Can't buy more vehicles.\n\n{FFFB93}Enter the name or ID of the player that you want to sell your vehicle:", "Next", "Back");
			if(GetPVarInt(pid, "xv_teklif_gonderen") != INVALID_PLAYER_ID) return ShowPlayerDialog(playerid, XV_DIALOGID+10, DIALOG_STYLE_INPUT, "Sell Vehicle to Player", "{FF0000}[!] {F0AE0F}Someone else has offed to this player! Wait for that offer first.\n\n{FFFB93}Enter the name or ID of the player that you want to sell your vehicle:", "Next", "Back");
			SetPVarInt(playerid, "xv_teklif_id", pid);
			new str[128];
			format(str, sizeof(str), "{FFFB93}Selected player: {ECEC13}%s {ECB021}(%d)\n\n{FFFB93}Enter the price you want:", Isim(pid), pid);
			ShowPlayerDialog(playerid, XV_DIALOGID+11, DIALOG_STYLE_INPUT, "Sell the Vehicle - Price", str, "Send Offer", "Back");
		} else SetPVarInt(playerid, "xv_teklif_id", INVALID_PLAYER_ID), ShowPlayerDialog(playerid, XV_DIALOGID+8, DIALOG_STYLE_LIST, "Sell The Vehicle", "{DCDC22}� {FFFB93}Sell To Car Dealer\n{DCDC22}� {FFFB93}Sell To Player", "Select", "Back");
	}
	
	if(dialogid == XV_DIALOGID+11)
	{
		if(response)
		{
			new tmpp[8], xid;
			GetPVarString(playerid, "selected_veh_plate", tmpp, 8);
			xid = GetVehiclexIDFromPlate(tmpp);
			if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			
			new pid = GetPVarInt(playerid, "xv_teklif_id");
			if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, -1, "{FF0000}[!] {DCDC22}Offer has cancelled because of the player has disconnected.");
			if(!isNumeric(inputtext)) return ShowPlayerDialog(playerid, XV_DIALOGID+11, DIALOG_STYLE_INPUT, "Sell the Vehicle - Price", "{FF0000}[!] {F0AE0F} Only enter numbers!\n\n{FFFB93}Enter the price you want:", "Send Offer", "Back");
			if(GetPlayerMoney(pid) < strval(inputtext)) return ShowPlayerDialog(playerid, XV_DIALOGID+11, DIALOG_STYLE_INPUT, "Sell the Vehicle - Price", "{FF0000}[!] {F0AE0F} This player doesn't have that much money!\n\n{FFFB93}Enter the price you want:", "Send Offer", "Back");
			SetPVarInt(pid, "xv_teklif_gonderen", playerid);
			SetPVarInt(pid, "xv_teklif_fiyat", strval(inputtext));
			SetPVarInt(pid, "xv_teklif_xid", xid);
			offerTimer[pid] = SetTimerEx("TeklifBitir", 30000, false, "uu", playerid, pid);
			new str[400];
			format(str, sizeof(str), "{00BD00}[!] {FFFB93}Offer has sent to {ECEC13}%s", Isim(pid));
			SendClientMessage(playerid, -1, str);
			format(str, sizeof(str), "{FFFFFF}--------------------[ Vehicle Sale Offer ]-------------------\n\n{ECEC13}%s {FFFB93}has offering to sell you a vehicle.\n\nVehicle Name: {ECB021}%s\n{FFFB93}Plate Number: {ECB021}%s\n{FFFB93}Price: {00E900}$%d\n\n{FFFB93}Do you want to buy this vehicle?\n\n{FFFFFF}----------------------------------------------------------------------------", Isim(playerid), GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka], strval(inputtext));
			ShowPlayerDialog(pid, XV_DIALOGID+12, DIALOG_STYLE_MSGBOX, "Vehicle Sale Offer", str, "Accept", "Reject");
		}
		else
		{
			ShowPlayerDialog(playerid, XV_DIALOGID+10, DIALOG_STYLE_INPUT, "Sell Vehicle to Player", "{FFFB93}Enter the name or ID of the player that you want to sell your vehicle:", "Next", "Back");
			SetPVarInt(playerid, "xv_teklif_id", INVALID_PLAYER_ID);
		}
	}
	
	if(dialogid == XV_DIALOGID+12)
	{
		if(response)
		{
			new pid = GetPVarInt(playerid, "xv_teklif_gonderen");
			new xid = GetPVarInt(playerid, "xv_teklif_xid");
			new price = GetPVarInt(playerid, "xv_teklif_fiyat");
			if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}This offers time is up.");
			if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, -1, "{FF0000}[!] {DCDC22}This offer has cancelled because of the player that offered has disconnected.");
			if(xStrcmp(Isim(pid), xVehicle[xid][xv_Sahip])) return SendClientMessage(playerid, -1, "{FF0000}[!] {DCDC22}This offer has cancelled because of the player that offered is not the owner of that vehicle.");
			if(GetPlayerMoney(playerid) < price)
			{
				SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}This offer has cancelled because of you don't have enough money!");
				SendClientMessage(pid, -1, "{FF0000}[!] {F0AE0F}This offer has cancelled because of that player doesn't have enough money!");
			}
			
			format(xVehicle[xid][xv_Sahip], 24, "%s", Isim(playerid));
			xVehicle[xid][xv_Fiyat] = price;
			SavexVehicle(xid);
			foreach(new i : Player)
			{
				if(IsValidVehicle(xVehicle[xid][xv_Veh]) && IsPlayerInVehicle(i, xVehicle[xid][xv_Veh]))
				{
					SendClientMessage(i, -1, "{FF0000}[!] {DCDC22}You have removed the vehicle because of this vehicle has been sold.");
					RemovePlayerFromVehicle(i);
				}
			}

			GivePlayerMoney(playerid, -price);
			GivePlayerMoney(pid, price);

			new query[256];
			format(query, sizeof(query), "{FFFB93}You sold your {ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number, to {ECEC13}%s{FFFB93}, for {00E900}$%d{FFFB93} succesfully!", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka], Isim(playerid), price);
			ShowPlayerDialog(pid, XV_DIALOGID-1, DIALOG_STYLE_MSGBOX, "Sell Vehicle", query, "OK", "");
			format(query, sizeof(query), "{FFFB93}You bought a {ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number, from {ECEC13}%s, for {00E900}$%d{FFFB93} succesfully!", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka], Isim(pid), price);
			ShowPlayerDialog(playerid, XV_DIALOGID-1, DIALOG_STYLE_MSGBOX, "Buy Vehicle", query, "OK", "");
			mysql_format(mysqlB, query, sizeof(query), "DELETE FROM xVehicleKeys WHERE AracID=%d", xid);
			mysql_query(mysqlB, query);
			mysql_format(mysqlB, query, sizeof(query), "UPDATE xVehicle SET Sahip='%s' WHERE ID=%d", Isim(playerid), xid);
			mysql_query(mysqlB, query);
		}
		else
		{
			SendClientMessage(playerid, -1, "{FF0000}[!] {DCDC22}You have rejected the offer.");
			if(IsPlayerConnected(GetPVarInt(playerid, "xv_teklif_gonderen"))) SendClientMessage(GetPVarInt(playerid, "xv_teklif_gonderen"), -1, "{FF0000}[!] {DCDC22}The player that you offered your vehicle to sell, has rejected your offer!");
		}
		KillTimer(offerTimer[playerid]);
		SetPVarInt(GetPVarInt(playerid, "xv_teklif_gonderen"), "xv_teklif_id", INVALID_PLAYER_ID);
		SetPVarInt(playerid, "xv_teklif_gonderen", INVALID_PLAYER_ID);
		DeletePVar(playerid, "xv_teklif_xid");
		DeletePVar(playerid, "xv_teklif_fiyat");
	}
	
	if(dialogid == XV_DIALOGID+13)
	{
		if(response)
		{
			new str[150], tmpp[8], xid, pid;
			GetPVarString(playerid, "selected_veh_plate", tmpp, 8);
			xid = GetVehiclexIDFromPlate(tmpp);
			if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			
			if(sscanf(inputtext, "u", pid)) return ShowPlayerDialog(playerid, XV_DIALOGID+13, DIALOG_STYLE_INPUT, "Give Vehicle Key", "{FF0000}[!] {F0AE0F}You wrote nothing!\n\n{FFFB93}Enter the player's ID or name that you want to give the key:", "Next", "Back");
			if(!IsPlayerConnected(pid)) return ShowPlayerDialog(playerid, XV_DIALOGID+13, DIALOG_STYLE_INPUT, "Give Vehicle Key", "{FF0000}[!] {F0AE0F}Player is not connected!\n{FFFB93}Enter the player's ID or name that you want to give the key:", "Next", "Back");
			if(pid == playerid) return ShowPlayerDialog(playerid, XV_DIALOGID+13, DIALOG_STYLE_INPUT, "Give Vehicle Key", "{FF0000}[!] {F0AE0F}You can't give the key to yourself!\n{FFFB93}Enter the player's ID or name that you want to give the key:", "Next", "Back");
			if(Iter_Contains(xVehicleKeys<pid>, xid)) return ShowPlayerDialog(playerid, XV_DIALOGID+4, DIALOG_STYLE_MSGBOX, "Give Vehicle Key", "{FF0000}[!] {F0AE0F}That player already have this vehicle's key!", "Back", "");
			Iter_Add(xVehicleKeys<pid>, xid);
			mysql_format(mysqlB, str, sizeof(str), "INSERT INTO xVehicleKeys SET AracID=%d, Isim='%e'", xid, Isim(pid));
			mysql_query(mysqlB, str);
			format(str, sizeof(str), "You gave the keys of the {ECEC13}%s {FFFB93} with {ECEC13}%s {FFFB93}plate number, to {ECEC13}%s {FFFB93}successfully!", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka], Isim(pid));
			SendClientMessage(playerid, -1, str);
			format(str, sizeof(str), "{ECEC13}%s {FFFB93}has gave you the keys of {ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number!", Isim(playerid), GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka]);
			SendClientMessage(pid, -1, str);
		} else ShowPlayerDialog(playerid, XV_DIALOGID+2, DIALOG_STYLE_LIST, "Vehicle Keys", "{DCDC22}� {FFFB93}View Key Owners\n{DCDC22}� {FFFB93}Give Someone Key\n{DCDC22}� {FFFB93}Change the Lock", "Select", "Back");
	}
	
	if(dialogid == XV_DIALOGID+14)
	{
		if(response)
		{
			new str[150], tmpp[8], xid, pid;
			GetPVarString(playerid, "selected_veh_plate", tmpp, 8);
			xid = GetVehiclexIDFromPlate(tmpp);
			if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			
			new p_is[24];
			GetPVarString(playerid, "tmp_keyname", p_is, 24);
			pid = GetPlayerIDFromName(p_is);
			if(IsPlayerConnected(pid))
			{
				Iter_Remove(xVehicleKeys<pid>, xid);
				format(str, sizeof(str), "{ECEC13}%s {FFFB93}has took the keys of {ECEC13}%s {FFFB93} with {ECEC13}%s {FFFB93}plate number, back!", Isim(playerid), GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka]);
				SendClientMessage(pid, -1, str);
			}
			mysql_format(mysqlB, str, sizeof(str), "DELETE FROM xVehicleKeys WHERE AracID=%d AND Isim='%e'", xid, p_is);
			mysql_query(mysqlB, str);
			format(str, sizeof(str), "You took the keys of {ECEC13}%s {FFFB93} with {ECEC13}%s {FFFB93}plate number, from {ECEC13}%s{FFFB93}", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka], p_is);
			SendClientMessage(playerid, -1, str);
		}
		else ShowPlayerDialog(playerid, XV_DIALOGID+2, DIALOG_STYLE_LIST, "Vehicle Keys", "{DCDC22}� {FFFB93}View Key Owners\n{DCDC22}� {FFFB93}Give Someone Key\n{DCDC22}� {FFFB93}Change the Lock", "Select", "Back");
	}
	
	if(dialogid == XV_DIALOGID+15)
	{
		if(response)
		{
			new str[128], tmpp[8], xid;
			GetPVarString(playerid, "selected_veh_plate", tmpp, 8);
			xid = GetVehiclexIDFromPlate(tmpp);
			if(xid == 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			
			foreach(new i : Player)
			{
				if(IsPlayerInVehicle(i, xVehicle[xid][xv_Veh]) && xStrcmp(xVehicle[xid][xv_Sahip], Isim(i))) 
				{
					SendClientMessage(i, -1, "{FF0000}[!] {DCDC22}You have removed from vehicle because of the owner of this vehicle has changed the lock.");
					RemovePlayerFromVehicle(i);
				}
				if(Iter_Contains(xVehicleKeys<i>, xid)) Iter_Remove(xVehicleKeys<i>, xid);
			}
			mysql_format(mysqlB, str, sizeof(str), "DELETE FROM xVehicleKeys WHERE AracID=%d", xid);
			mysql_query(mysqlB, str);
			SendClientMessage(playerid, -1, "{00BD00}[!] {00FF00}You have succesfully changed vehicle's lock!");
		} else ShowPlayerDialog(playerid, XV_DIALOGID+2, DIALOG_STYLE_LIST, "Vehicle Keys", "{DCDC22}� {FFFB93}View Key Owners\n{DCDC22}� {FFFB93}Give Someone Key\n{DCDC22}� {FFFB93}Change the Lock", "Select", "Back");
	}
	
	if(dialogid == XV_DIALOGID+16)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new query[128], Cache:vehs;
					SetPVarInt(playerid, "xvKeysPage", 0);
					mysql_format(mysqlB, query, sizeof(query), "SELECT ID FROM xVehicle ORDER BY ID ASC LIMIT %d, 15", GetPVarInt(playerid, "xvKeysPage")*15);
					vehs = mysql_query(mysqlB, query);
					new rows = cache_num_rows();
					if(rows) 
					{
						new list[512], v_id;
						format(list, sizeof(list), "Vehicle ID\tPlate Number\tVehicle Name\n");
						for(new i; i < rows; ++i)
						{
							cache_get_value_name_int(i, "ID", v_id);
							format(list, sizeof(list), "%s%d\t%s\t%s\n", list, v_id, xVehicle[v_id][xv_Plaka], GetVehicleNameFromModel(xVehicle[v_id][xv_ModelID]));
						}
						format(list, sizeof(list), "%s{F4D00B}<< Previous Page\n{F4D00B}>> Next Page", list);
						ShowPlayerDialog(playerid, XV_DIALOGID+17, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle List (Page 1)", list, "Select", "Back");
					}
					else
					{
						SendClientMessage(playerid, 0xE74C3CFF, "{FF0000}[!] {DCDC22}No vehicles has been created.");
					}
					cache_delete(vehs);	
				}
				case 1:
				{
					new str[128];
					foreach(new i : xVehicles) if(!xVehicle[i][xv_Garajda]) SetVehicleToRespawn(xVehicle[i][xv_Veh]);
					SendClientMessage(playerid, -1, "{00BD00}[!] {00FF00}All vehicles has respawned!");
					format(str, sizeof(str), "{00BD00}[!] Admin {ECEC13}%s {FFFB93}has respawned all vehicles!", Isim(playerid));
					SendClientMessageToAll(-1, str);
				}
				case 2:
				{
					ShowPlayerDialog(playerid, XV_DIALOGID+22, DIALOG_STYLE_INPUT, "Create Vehicle", "{FFFB93}Enter the model ID or the name of the vehicle:", "Next", "Back");
				}
			}
		}
	}
	
	if(dialogid == XV_DIALOGID+17)
	{
		if(response)
		{
			if(!xStrcmp(inputtext, "<< Previous Page"))
			{
				SetPVarInt(playerid, "xvKeysPage", GetPVarInt(playerid, "xvKeysPage")-1);
				if(GetPVarInt(playerid, "xvKeysPage") < 0)
				{
					SetPVarInt(playerid, "xvKeysPage", 0);
					cmd_amenu(playerid, "");
					return 1;
				}
				
				new query[128], Cache:vehs;
				mysql_format(mysqlB, query, sizeof(query), "SELECT ID FROM xVehicle ORDER BY ID ASC LIMIT %d, 15", GetPVarInt(playerid, "xvKeysPage")*15);
				vehs = mysql_query(mysqlB, query);
				new rows = cache_num_rows();
				if(rows)
				{
					new list[512], v_id;
					format(list, sizeof(list), "Vehicle ID\tPlate Number\tVehicle Name\n");
					for(new i; i < rows; ++i)
					{
						cache_get_value_name_int(i, "ID", v_id);
						format(list, sizeof(list), "%s%d\t%s\t%s\n", list, v_id, xVehicle[v_id][xv_Plaka], GetVehicleNameFromModel(xVehicle[v_id][xv_ModelID]));
					}
					format(list, sizeof(list), "%s{F4D00B}<< Previous Page\n{F4D00B}>> Next Page", list);
					new head[32];
					format(head, sizeof(head), "Vehicle List (Page %d)", GetPVarInt(playerid, "xvKeysPage")+1);
					ShowPlayerDialog(playerid, XV_DIALOGID+17, DIALOG_STYLE_TABLIST_HEADERS, head, list, "Select", "Back");
				}
				else
				{
					SetPVarInt(playerid, "xvKeysPage", 0);
				}
				cache_delete(vehs);
			}
			else if(!xStrcmp(inputtext, ">> Next Page"))
			{
				SetPVarInt(playerid, "xvKeysPage", GetPVarInt(playerid, "xvKeysPage")+1);
			
				new query[128], Cache:vehs;
				mysql_format(mysqlB, query, sizeof(query), "SELECT ID FROM xVehicle ORDER BY ID ASC LIMIT %d, 15", GetPVarInt(playerid, "xvKeysPage")*15);
				vehs = mysql_query(mysqlB, query);
				new rows = cache_num_rows();
				if(rows)
				{
					new list[512], v_id;
					format(list, sizeof(list), "Vehicle ID\tPlate Number\tVehicle Name\n");
					for(new i; i < rows; ++i)
					{
						cache_get_value_name_int(i, "ID", v_id);
						format(list, sizeof(list), "%s%d\t%s\t%s\n", list, v_id, xVehicle[v_id][xv_Plaka], GetVehicleNameFromModel(xVehicle[v_id][xv_ModelID]));
					}
					format(list, sizeof(list), "%s{F4D00B}<< Previous Page\n{F4D00B}>> Next Page", list);
					new head[32];
					format(head, sizeof(head), "Vehicle List (Page %d)", GetPVarInt(playerid, "xvKeysPage")+1);
					ShowPlayerDialog(playerid, XV_DIALOGID+17, DIALOG_STYLE_TABLIST_HEADERS, head, list, "Select", "Back");
				}
				else
				{
					SetPVarInt(playerid, "xvKeysPage", GetPVarInt(playerid, "xvKeysPage") - 1);
					mysql_format(mysqlB, query, sizeof(query), "SELECT ID FROM xVehicle ORDER BY ID ASC LIMIT %d, 15", GetPVarInt(playerid, "xvKeysPage")*15);
					vehs = mysql_query(mysqlB, query);
					rows = cache_num_rows();
					if(rows)
					{
						new list[512], v_id;
						format(list, sizeof(list), "Vehicle ID\tPlate Number\tVehicle Name\n");
						for(new i; i < rows; ++i)
						{
							cache_get_value_name_int(i, "ID", v_id);
							format(list, sizeof(list), "%s%d\t%s\t%s\n", list, v_id, xVehicle[v_id][xv_Plaka], GetVehicleNameFromModel(xVehicle[v_id][xv_ModelID]));
						}
						format(list, sizeof(list), "%s{F4D00B}<< Previous Page\n{F4D00B}>> Next Page", list);
						new head[32];
						format(head, sizeof(head), "Vehicle List (Page %d)", GetPVarInt(playerid, "xvKeysPage")+1);
						ShowPlayerDialog(playerid, XV_DIALOGID+17, DIALOG_STYLE_TABLIST_HEADERS, head, list, "Select", "Back");
					}
					SendClientMessage(playerid, 0xE74C3CFF, "There is no more vehicle! You are at the last page.");
				}
				cache_delete(vehs);
			}
			else
			{
				new tm[2][8];
				split(inputtext, tm, '\t');
				SetPVarInt(playerid, "adm_sl_id", strval(tm[0]));
				ShowPlayerDialog(playerid, XV_DIALOGID+18, DIALOG_STYLE_LIST, "xVehicle Admin Menu", "{ECCB13}� {FFFFFF}View Vehicle Info\n{ECCB13}� {FFFFFF}Get the Vehicle Here\n{ECCB13}� {FFFFFF}Respawn Vehicle\n{ECCB13}� {FFFFFF}Change Vehicle's Price\n{ECCB13}� {FFFFFF}Remove Vehicle Owner\n{ECCB13}� {FFFFFF}Remove Vehicle", "Select", "Back");
			}
		} else cmd_amenu(playerid, "");
	}
	
	if(dialogid == XV_DIALOGID+18)
	{
		if(response)
		{
			new xid = GetPVarInt(playerid, "adm_sl_id");
			if(xid == 0 || !Iter_Contains(xVehicles, xid)) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			switch(listitem)
			{
				case 0: // ara� bilgileri
				{
					new str[256], sahip[24];
					if(!strlen(xVehicle[xid][xv_Sahip])) format(sahip, sizeof(sahip), "-For Sale-");
					else format(sahip, sizeof(sahip), "%s", xVehicle[xid][xv_Sahip]);
					format(str, sizeof(str), "{FFFFFF}----------[ Vehicle Information ]----------\n\n{F0AE0F}-� {ECE913}Owner: {FFFFFF}%s\n{F0AE0F}-� {ECE913}Vehicle Name: {FFFFFF}%s\n{F0AE0F}-� {ECE913}Plate Number: {FFFFFF}%s\n{F0AE0F}-� {ECE913}State: %s", sahip, GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka], (xVehicle[xid][xv_Garajda]) ? ("{F0CE0F}In The Garage") : ("{8FE01F}On The Map"));
					ShowPlayerDialog(playerid, XV_DIALOGID+19, DIALOG_STYLE_MSGBOX, "Vehicle Info", str, "Back", "");
				}
				case 1: // arac� �ek
				{
					GetPlayerPos(playerid, xVehicle[xid][xv_Pos][0], xVehicle[xid][xv_Pos][1], xVehicle[xid][xv_Pos][2]);
					GetPlayerFacingAngle(playerid, xVehicle[xid][xv_Pos][3]);
					xVehicle[xid][xv_Pos][0] += 1;
					xVehicle[xid][xv_Pos][1] += 1;
					if(xVehicle[xid][xv_Garajda])
					{
						xVehicle[xid][xv_Veh] = CreateVehicle(xVehicle[xid][xv_ModelID], xVehicle[xid][xv_Pos][0], xVehicle[xid][xv_Pos][1], xVehicle[xid][xv_Pos][2], xVehicle[xid][xv_Pos][3], xVehicle[xid][xv_Renk][0], xVehicle[xid][xv_Renk][1], -1);
						xVeh[xVehicle[xid][xv_Veh]] = xid;
						SetVehicleNumberPlate(xVehicle[xid][xv_Veh], xVehicle[xid][xv_Plaka]);
						SetVehicleToRespawn(xVehicle[xid][xv_Veh]);
						xVehicle[xid][xv_Garajda] = 0;
					}
					else
					{
						SetVehiclePos(xVehicle[xid][xv_Veh], xVehicle[xid][xv_Pos][0], xVehicle[xid][xv_Pos][1], xVehicle[xid][xv_Pos][2]);
						SetVehicleZAngle(xVehicle[xid][xv_Veh], xVehicle[xid][xv_Pos][3]);
					}
					DeletePVar(playerid, "adm_sl_id");
					new str[128];
					format(str, sizeof(str), "You have teleported the {ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number, to you! {ECB021}(ID: %d)", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka], xid);
					SendClientMessage(playerid, -1, str);
				}
				case 2: // yenile
				{
					if(xVehicle[xid][xv_Garajda]) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}You can not respawn the vehicle in garage!");
					SetVehicleToRespawn(xVehicle[xid][xv_Veh]);
					SendClientMessage(playerid, -1, "{00BD00}[!] {00FF00}You have respawned the vehicle!");
				}
				case 3: // fiyat�n� de�i�tir
				{
					new str[128];
					format(str, sizeof(str), "{FFFB93}Vehicle's current price: {ECEC13}$%d\n\n{FFFB93}Enter the value you want to change:", xVehicle[xid][xv_Fiyat]);
					ShowPlayerDialog(playerid, XV_DIALOGID+26, DIALOG_STYLE_INPUT, "Change the Price", str, "OK", "Back");
				}
				case 4: // ara� sahibini sil
				{
					new str[256];
					format(str, sizeof(str), "{FFFB93}Are you sure that you want to remove the owner of {ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number? {ECB021}(ID: %d)\n{AAAAAA}(The vehicle will be put on sale and the vehicle's keys will be removed from the key owners.)", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka], xid);
					ShowPlayerDialog(playerid, XV_DIALOGID+20, DIALOG_STYLE_MSGBOX, "Remove Vehicle Owner", str, "Confirm", "Back");
				}
				case 5: // arac� sil
				{
					new str[256];
					format(str, sizeof(str), "{FFFB93}Are you sure that you want to remove the vehicle {ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number? {ECB021}(ID: %d)", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka], xid);
					ShowPlayerDialog(playerid, XV_DIALOGID+21, DIALOG_STYLE_MSGBOX, "Remove Vehicle", str, "Confirm", "Back");
				}
			}
		}
		else
		{
			DeletePVar(playerid, "adm_sl_id");
			cmd_amenu(playerid, "");
		}
	}
	
	if(dialogid == XV_DIALOGID+19) ShowPlayerDialog(playerid, XV_DIALOGID+18, DIALOG_STYLE_LIST, "xVehicle Admin Menu", "{ECCB13}� {FFFFFF}View Vehicle Info\n{ECCB13}� {FFFFFF}Get the Vehicle Here\n{ECCB13}� {FFFFFF}Respawn Vehicle\n{ECCB13}� {FFFFFF}Change Vehicle's Price\n{ECCB13}� {FFFFFF}Remove Vehicle Owner\n{ECCB13}� {FFFFFF}Remove Vehicle", "Select", "Back");
	
	if(dialogid == XV_DIALOGID+20)
	{
		if(response)
		{
			new xid = GetPVarInt(playerid, "adm_sl_id");
			if(xid == 0 || !Iter_Contains(xVehicles, xid)) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			if(!strlen(xVehicle[xid][xv_Sahip])) return ShowPlayerDialog(playerid, XV_DIALOGID+19, DIALOG_STYLE_MSGBOX, "Remove Vehicle Owner", "{FF0000}[!] {DCDC22}This vehicle has no owner!", "Back", "");
			format(xVehicle[xid][xv_Sahip], 24, "");
			foreach(new i : Player)
			{
				if(IsPlayerInVehicle(i, xVehicle[xid][xv_Veh]))
				{
					SendClientMessage(i, -1, "{FF0000}[!] {DCDC22}You have removed from the vehicle because of the admin has removed the owner of this vehicle.");
					RemovePlayerFromVehicle(i);
				}
				if(Iter_Contains(xVehicleKeys<i>, xid)) Iter_Remove(xVehicleKeys<i>, xid);
			}
			new str[150];
			mysql_format(mysqlB, str, sizeof(str), "DELETE FROM xVehicleKeys WHERE AracID=%d", xid);
			mysql_query(mysqlB, str);
			SavexVehicle(xid);
			format(str, sizeof(str), "{00FF00}This Vehicle Is For Sale!\n{FFA500}Vehicle Name: {FFFFFF}%s\n{FFA500}Plate Number: {FFFFFF}%s\n{FFA500}Price: {00FF00}$%d", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka], xVehicle[xid][xv_Fiyat]);
			xVehicle[xid][xv_Text] = Create3DTextLabel(str, 0x008080FF, 0.0, 0.0, 0.0, 50.0, 0);
			Attach3DTextLabelToVehicle(xVehicle[xid][xv_Text], xVehicle[xid][xv_Veh], 0.0, 0.0, 1.0);
			DeletePVar(playerid, "adm_sl_id");
			format(str, sizeof(str), "{FFFB93}You have removed the owner of the vehicle ID: {ECB021}%d", xid);
			SendClientMessage(playerid, -1, str);
		} else ShowPlayerDialog(playerid, XV_DIALOGID+18, DIALOG_STYLE_LIST, "xVehicle Admin Menu", "{ECCB13}� {FFFFFF}View Vehicle Info\n{ECCB13}� {FFFFFF}Get the Vehicle Here\n{ECCB13}� {FFFFFF}Respawn Vehicle\n{ECCB13}� {FFFFFF}Change Vehicle's Price\n{ECCB13}� {FFFFFF}Remove Vehicle Owner\n{ECCB13}� {FFFFFF}Remove Vehicle", "Select", "Back");
	}
	
	if(dialogid == XV_DIALOGID+21)
	{
		if(response)
		{
			new xid = GetPVarInt(playerid, "adm_sl_id");
			if(xid == 0 || !Iter_Contains(xVehicles, xid)) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			DestroyVehicle(xVehicle[xid][xv_Veh]);
			Iter_Remove(xVehicles, xid);
			DeletePVar(playerid, "adm_sl_id");
			foreach(new i : Player)
			{
				if(Iter_Contains(xVehicleKeys<i>, xid)) Iter_Remove(xVehicleKeys<i>, xid);
			}
			new query[128];
			mysql_format(mysqlB, query, sizeof(query), "DELETE FROM xVehicleKeys WHERE AracID=%d", xid);
			mysql_query(mysqlB, query);
			mysql_format(mysqlB, query, sizeof(query), "DELETE FROM xVehicle WHERE ID=%d", xid);
			mysql_query(mysqlB, query);
			format(query, sizeof(query), "{FFFB93}You have removed the vehicle ID:{ECB021}%d", xid);
			SendClientMessage(playerid, -1, query);
		} else ShowPlayerDialog(playerid, XV_DIALOGID+18, DIALOG_STYLE_LIST, "xVehicle Admin Menu", "{ECCB13}� {FFFFFF}View Vehicle Info\n{ECCB13}� {FFFFFF}Get the Vehicle Here\n{ECCB13}� {FFFFFF}Respawn Vehicle\n{ECCB13}� {FFFFFF}Change Vehicle's Price\n{ECCB13}� {FFFFFF}Remove Vehicle Owner\n{ECCB13}� {FFFFFF}Remove Vehicle", "Select", "Back");
	}
	
	if(dialogid == XV_DIALOGID+22)
	{
		if(response)
		{
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, XV_DIALOGID+22, DIALOG_STYLE_INPUT, "Create Vehicle", "{FF0000}[!] {F0AE0F}You wrote nothing!\n\n{FFFB93}Enter the model ID or the name of the vehicle:", "Next", "Back");
			new veh;
			if(!isNumeric(inputtext)) veh = GetVehicleModelIDFromName(inputtext); else veh = strval(inputtext);
			if(veh < 400 || veh > 611) return ShowPlayerDialog(playerid, XV_DIALOGID+22, DIALOG_STYLE_INPUT, "Create Vehicle", "{FF0000}[!] {F0AE0F}Invalid vehicle name or ID!\n\n{FFFB93}Enter the model ID or the name of the vehicle:", "Next", "Back");
			SetPVarInt(playerid, "xv_ao_model", veh);
			new str[192];
			format(str, sizeof(str), "{00BD00}[!] {00FF00}Selected model: {ECEC13}%s {ECB021}(%d)\n\n{FFFB93}Enter the color 1 of the vehicle:\n{AAAAAA}(Between 0-255)", GetVehicleNameFromModel(GetPVarInt(playerid, "xv_ao_model")), GetPVarInt(playerid, "xv_ao_model"));
			ShowPlayerDialog(playerid, XV_DIALOGID+23, DIALOG_STYLE_INPUT, "Create Vehicle - Color", str, "Next", "Back");
		} else cmd_amenu(playerid, "");
	}
	
	if(dialogid == XV_DIALOGID+23)
	{
		if(response)
		{
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, XV_DIALOGID+23, DIALOG_STYLE_INPUT, "Create Vehicle - Color", "{FF0000}[!] {F0AE0F}You wrote nothing!\n\n{FFFB93}Enter the color 1 of the vehicle:\n{AAAAAA}(Between 0-255)", "Next", "Back");
			if(!isNumeric(inputtext))return ShowPlayerDialog(playerid, XV_DIALOGID+23, DIALOG_STYLE_INPUT, "Create Vehicle - Color", "{FF0000}[!] {F0AE0F}Only use numbers!\n\n{FFFB93}Enter the color 1 of the vehicle:\n{AAAAAA}(Between 0-255)", "Next", "Back");
			if(strval(inputtext) < 0 || strval(inputtext) > 255) return ShowPlayerDialog(playerid, XV_DIALOGID+23, DIALOG_STYLE_INPUT, "Create Vehicle - Color", "{FF0000}[!] {F0AE0F}You must enter a value between 0 - 255!\n\n{FFFB93}Enter the color 1 of the vehicle:\n{AAAAAA}(Between 0-255)", "Next", "Back");
			SetPVarInt(playerid, "xv_ao_col1", strval(inputtext));
			new str[128];
			format(str, sizeof(str), "{00BD00}[!] {00FF00}Selected color 1: {ECEC13}%d\n\n{FFFB93}Enter the color 2 of the vehicle:\n{AAAAAA}(Between 0-255)", GetPVarInt(playerid, "xv_ao_col1"));
			ShowPlayerDialog(playerid, XV_DIALOGID+24, DIALOG_STYLE_INPUT, "Create Vehicle - Color", str, "Next", "Back");
		} else DeletePVar(playerid, "xv_ao_model"), ShowPlayerDialog(playerid, XV_DIALOGID+22, DIALOG_STYLE_INPUT, "Create Vehicle", "{FFFB93}Enter the model ID or the name of the vehicle:", "Next", "Back");
	}
	
	if(dialogid == XV_DIALOGID+24)
	{
		if(response)
		{
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, XV_DIALOGID+24, DIALOG_STYLE_INPUT, "Create Vehicle - Color", "{FF0000}[!] {F0AE0F}You wrote nothing!\n\n{FFFB93}Enter the color 2 of the vehicle:\n{AAAAAA}(Between 0-255)", "Next", "Back");
			if(!isNumeric(inputtext))return ShowPlayerDialog(playerid, XV_DIALOGID+24, DIALOG_STYLE_INPUT, "Create Vehicle - Color", "{FF0000}[!] {F0AE0F}Only use numbers!\n\n{FFFB93}Enter the color 2 of the vehicle:\n{AAAAAA}(Between 0-255)", "Next", "Back");
			if(strval(inputtext) < 0 || strval(inputtext) > 255) return ShowPlayerDialog(playerid, XV_DIALOGID+24, DIALOG_STYLE_INPUT, "Create Vehicle - Color", "{FF0000}[!] {F0AE0F}You must enter a value between 0 - 255!\n\n{FFFB93}Enter the color 2 of the vehicle:\n{AAAAAA}(Between 0-255)", "Next", "Back");
			SetPVarInt(playerid, "xv_ao_col2", strval(inputtext));
			new str[128];
			format(str, sizeof(str), "{00BD00}[!] {00FF00}Selected color 2: {ECEC13}%d\n\n{FFFB93}Enter the price of the vehicle:", GetPVarInt(playerid, "xv_ao_col2"));
			ShowPlayerDialog(playerid, XV_DIALOGID+25, DIALOG_STYLE_INPUT, "Create Vehicle - Price", str, "Create", "Back");
		}
		else
		{
			DeletePVar(playerid, "xv_ao_col1");
			new str[192];
			format(str, sizeof(str), "{00BD00}[!] {00FF00}Selected model: {ECEC13}%s {ECB021}(%d)\n\n{FFFB93}Enter the color 1 of the vehicle:\n{AAAAAA}(Between 0-255)", GetVehicleNameFromModel(GetPVarInt(playerid, "xv_ao_model")), GetPVarInt(playerid, "xv_ao_model"));
			ShowPlayerDialog(playerid, XV_DIALOGID+23, DIALOG_STYLE_INPUT, "Create Vehicle - Color", str, "Next", "Back");
		}
	}
	
	if(dialogid == XV_DIALOGID+25)
	{
		if(response)
		{
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, XV_DIALOGID+25, DIALOG_STYLE_INPUT, "Create Vehicle - Price", "{FF0000}[!] {F0AE0F}You wrote nothing!\n\n{FFFB93}Enter the price of the vehicle:", "Create", "Back");
			if(!isNumeric(inputtext))return ShowPlayerDialog(playerid, XV_DIALOGID+25, DIALOG_STYLE_INPUT, "Create Vehicle - Price", "{FF0000}[!] {F0AE0F}Only use numbers!\n\n{FFFB93}Enter the price of the vehicle:", "Create", "Back");
			if(strval(inputtext) < 0) return ShowPlayerDialog(playerid, XV_DIALOGID+25, DIALOG_STYLE_INPUT, "Create Vehicle - Price", "{FF0000}[!] {F0AE0F}Only use positive numbers!\n\n{FFFB93}Enter the price of the vehicle:", "Create", "Back");
			new tmp_var[3], Float:ppos[4], veh, xid;
			tmp_var[0] = GetPVarInt(playerid, "xv_ao_model");
			tmp_var[1] = GetPVarInt(playerid, "xv_ao_col1");
			tmp_var[2] = GetPVarInt(playerid, "xv_ao_col2");
			GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
			GetPlayerFacingAngle(playerid, ppos[3]);
			veh = CreatexVehicle(tmp_var[0], "", strval(inputtext), ppos[0], ppos[1], ppos[2], ppos[3], tmp_var[1], tmp_var[2]);
			xid = xVeh[veh];
			PutPlayerInVehicle(playerid, veh, 0);
			new str[256]; 
			SendClientMessage(playerid, -1, "------------------------------------------------------------------------------------------------------------");
			format(str, sizeof(str), "{00FF00}[!] Vehicle {ECEC13}%s {ECB021}(%d) {FFFB93}has been created with the colors {ECEC13}%d, %d", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_ModelID], xVehicle[xid][xv_Renk][0], xVehicle[xid][xv_Renk][1]);
			SendClientMessage(playerid, -1, str);
			format(str, sizeof(str), "{FFFB93}Plate number: {ECEC13}%s, {FFFB93}Vehicle ID: {ECB021}%d, {FFFB93}Price: {ECB021}$%d", xVehicle[xid][xv_Plaka], xid, xVehicle[xid][xv_Fiyat]);
			SendClientMessage(playerid, -1, str);
			SendClientMessage(playerid, -1, "{FFFB93}To change the location of the vehicle, get into vehicle, go wherever you want and type {ECEC13}/park");
			SendClientMessage(playerid, -1, "------------------------------------------------------------------------------------------------------------");
			DeletePVar(playerid, "xv_ao_model");
			DeletePVar(playerid, "xv_ao_col1");
			DeletePVar(playerid, "xv_ao_col2");
		}
		else
		{
			DeletePVar(playerid, "xv_ao_col2");
			new str[128];
			format(str, sizeof(str), "{00BD00}[!] {00FF00}Selected color 1: {ECEC13}%d\n\n{FFFB93}Enter the color 2 of the vehicle:\n{AAAAAA}(Between 0-255)", GetPVarInt(playerid, "xv_ao_col1"));
			ShowPlayerDialog(playerid, XV_DIALOGID+24, DIALOG_STYLE_INPUT, "Create Vehicle - Color", str, "Next", "Back");
		}
	}
	
	if(dialogid == XV_DIALOGID+26)
	{
		if(response)
		{
			new xid = GetPVarInt(playerid, "adm_sl_id");
			if(xid == 0 || !Iter_Contains(xVehicles, xid)) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, XV_DIALOGID+26, DIALOG_STYLE_INPUT, "Change the Price", "{FF0000}[!] {F0AE0F}HYou wrote nothing!\n\n{FFFB93}Enter the value you want to change:", "OK", "Back");
			if(!isNumeric(inputtext)) return ShowPlayerDialog(playerid, XV_DIALOGID+26, DIALOG_STYLE_INPUT, "Change the Price", "{FF0000}[!] {F0AE0F}Only use numbers!\n\n{FFFB93}Enter the value you want to change:", "OK", "Back");
			if(strval(inputtext) < 0) return ShowPlayerDialog(playerid, XV_DIALOGID+26, DIALOG_STYLE_INPUT, "Change the Price", "{FF0000}[!] {F0AE0F}Only use positive numbers!\n\n{FFFB93}Enter the value you want to change:", "OK", "Back");
			xVehicle[xid][xv_Fiyat] = strval(inputtext);
			new str[150];
			if(!strlen(xVehicle[xid][xv_Sahip]))
			{
				Delete3DTextLabel(xVehicle[xid][xv_Text]);
				format(str, sizeof(str), "{00FF00}This Vehicle Is For Sale!\n{FFA500}Vehicle Name: {FFFFFF}%s\n{FFA500}Plate Number: {FFFFFF}%s\n{FFA500}Price: {00FF00}$%d", GetVehicleNameFromModel(xVehicle[xid][xv_ModelID]), xVehicle[xid][xv_Plaka], xVehicle[xid][xv_Fiyat]);
				xVehicle[xid][xv_Text] = Create3DTextLabel(str, 0x008080FF, 0.0, 0.0, 0.0, 50.0, 0);
				Attach3DTextLabelToVehicle(xVehicle[xid][xv_Text], xVehicle[xid][xv_Veh], 0.0, 0.0, 1.0);
			}
			SavexVehicle(xid);
			format(str, sizeof(str), "{00BD00}[!] {00FF00}You have changed the price to {ECEC13}$%d!", xVehicle[xid][xv_Fiyat]);
			SendClientMessage(playerid, -1, str);
		} 
		ShowPlayerDialog(playerid, XV_DIALOGID+18, DIALOG_STYLE_LIST, "xVehicle Admin Menu", "{ECCB13}� {FFFFFF}View Vehicle Info\n{ECCB13}� {FFFFFF}Get the Vehicle Here\n{ECCB13}� {FFFFFF}Respawn Vehicle\n{ECCB13}� {FFFFFF}Change Vehicle's Price\n{ECCB13}� {FFFFFF}Remove Vehicle Owner\n{ECCB13}� {FFFFFF}Remove Vehicle", "Select", "Back");
	}
	return 1;
}

xvMenuGoster(playerid)
{
	new str[256], tmp[8], xid;
	GetPVarString(playerid, "selected_veh_plate", tmp, 8);
	xid = GetVehiclexIDFromPlate(tmp);
	if(xid == 0) return 1;
	format(str, sizeof(str), "{FFA500}� {FFFFFF} Where Is My Car?\n%s\n{FFA500}� {FFFFFF} Quick Park\n{FFA500}� {%s} Vehicle Keys\n{FFA500}� {%s} Sell the Vehicle\n{FFA500}� {CACACA} Vehicle Info", 
	(xVehicle[xid][xv_Garajda]) ? (!xStrcmp(xVehicle[xid][xv_Sahip], Isim(playerid))) ? ("{FFA500}� {FFFFFF} Take Out Vehicle From Garage") : ("{FFA500}� {FF0000} Take Out Vehicle From Garage") : (!xStrcmp(xVehicle[xid][xv_Sahip], Isim(playerid))) ? ("{FFA500}� {FFFFFF} Put Vehicle In Garage") : ("{FFA500}� {FF0000} Put Vehicle In Garage"), (xStrcmp(xVehicle[xid][xv_Sahip], Isim(playerid))) ? ("FF0000") : ("FFFFFF"), (xStrcmp(xVehicle[xid][xv_Sahip], Isim(playerid))) ? ("FF0000") : ("FFFFFF"));
	ShowPlayerDialog(playerid, XV_DIALOGID, DIALOG_STYLE_LIST, "Vehicle Menu", str, "Select", "Back");
	return 1;
}

forward TeklifBitir(gonderen, alan);
public TeklifBitir(gonderen, alan)
{
	SetPVarInt(alan, "xv_teklif_gonderen", INVALID_PLAYER_ID);
	DeletePVar(alan, "xv_teklif_xid");
	DeletePVar(alan, "xv_teklif_fiyat");
	if(IsPlayerConnected(gonderen)) SetPVarInt(gonderen, "xv_teklif_id", INVALID_PLAYER_ID), SendClientMessage(gonderen, -1, "{FF0000}[!] {DCDC22}The vehicle sale offer has cancelled because of the player didn't respond.");
	return 1;
}

CreatexVehicle(modelid, owner[], price, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2)
{
	new id = Iter_Free(xVehicles);
	
	xVehicle[id][xv_Veh] = CreateVehicle(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2, -1);
	
	xVeh[xVehicle[id][xv_Veh]] = id;
	xVehicle[id][xv_ModelID] = modelid;
	xVehicle[id][xv_Renk][0] = color1;
	xVehicle[id][xv_Renk][1] = color2;
	xVehicle[id][xv_Paintjob] = -1;
	xVehicle[id][xv_Pos][0] = spawn_x;
	xVehicle[id][xv_Pos][1] = spawn_y;
	xVehicle[id][xv_Pos][2] = spawn_z;
	xVehicle[id][xv_Pos][3] = z_angle;
	format(xVehicle[id][xv_Sahip], 24, "%s", owner);
	xVehicle[id][xv_Fiyat] = price;
	plate_check:
	format(xVehicle[id][xv_Plaka], 8, "%s", CreatePlate());
	foreach(new i : xVehicles) if(!xStrcmp(xVehicle[id][xv_Plaka], xVehicle[i][xv_Plaka])) goto plate_check;
	SetVehicleNumberPlate(xVehicle[id][xv_Veh], xVehicle[id][xv_Plaka]);
	SetVehicleToRespawn(xVehicle[id][xv_Veh]);
	Iter_Add(xVehicles, id);
	new query[256];
	format(query, sizeof(query),"INSERT INTO `xVehicle` (`ID`,`Sahip`,`Fiyat`,`X`,`Y`,`Z`,`A`,`Model`,`Renk1`,`Renk2`,`Plaka`) VALUES ('%d','%s','%d','%f','%f','%f','%f','%d','%d','%d','%s')",
	id, owner, price, spawn_x, spawn_y, spawn_z, z_angle, modelid, color1, color2, xVehicle[id][xv_Plaka]);
	mysql_query(mysqlB, query);
	
	if(!strlen(xVehicle[id][xv_Sahip]))
	{
		new str[150];
		format(str, sizeof(str), "{00FF00}This Vehicle Is For Sale!\n{FFA500}Vehicle Name: {FFFFFF}%s\n{FFA500}Plate Number: {FFFFFF}%s\n{FFA500}Price: {00FF00}$%d", GetVehicleNameFromModel(xVehicle[id][xv_ModelID]), xVehicle[id][xv_Plaka], xVehicle[id][xv_Fiyat]);
		xVehicle[id][xv_Text] = Create3DTextLabel(str, 0x008080FF, 0.0, 0.0, 0.0, 50.0, 0);
		Attach3DTextLabelToVehicle(xVehicle[id][xv_Text], xVehicle[id][xv_Veh], 0.0, 0.0, 1.0);
	}
	return xVehicle[id][xv_Veh];
}

SavexVehicle(xvehid)
{
	if(xvehid == 0) return 0;
	new query[512];
	
	mysql_format(mysqlB, query, sizeof(query), "UPDATE `xVehicle` SET Sahip='%e', Fiyat=%d, X=%f, Y=%f, Z=%f, A=%f, HizliPark=%d, Model=%d, Renk1=%d, Renk2=%d, Plaka='%s', PJ=%d, Garajda=%d, Parca1=%d, Parca2=%d, Parca3=%d, Parca4=%d, Parca5=%d, Parca6=%d, Parca7=%d, Parca8=%d, Parca9=%d, Parca10=%d, Parca11=%d, Parca12=%d, Parca13=%d, Parca14=%d WHERE ID=%d",
	xVehicle[xvehid][xv_Sahip], xVehicle[xvehid][xv_Fiyat], xVehicle[xvehid][xv_Pos][0], xVehicle[xvehid][xv_Pos][1], xVehicle[xvehid][xv_Pos][2], xVehicle[xvehid][xv_Pos][3], xVehicle[xvehid][xv_HizliPark], xVehicle[xvehid][xv_ModelID], xVehicle[xvehid][xv_Renk][0], xVehicle[xvehid][xv_Renk][1], xVehicle[xvehid][xv_Plaka], xVehicle[xvehid][xv_Paintjob], xVehicle[xvehid][xv_Garajda],
	xVehicle[xvehid][xv_Parca][0],
	xVehicle[xvehid][xv_Parca][1],
	xVehicle[xvehid][xv_Parca][2],
	xVehicle[xvehid][xv_Parca][3],
	xVehicle[xvehid][xv_Parca][4],
	xVehicle[xvehid][xv_Parca][5],
	xVehicle[xvehid][xv_Parca][6],
	xVehicle[xvehid][xv_Parca][7],
	xVehicle[xvehid][xv_Parca][8],
	xVehicle[xvehid][xv_Parca][9],
	xVehicle[xvehid][xv_Parca][10],
	xVehicle[xvehid][xv_Parca][11],
	xVehicle[xvehid][xv_Parca][12],
	xVehicle[xvehid][xv_Parca][13],
	xvehid);
	mysql_query(mysqlB, query);
	return 1;
}

forward LoadxVehicles();
public LoadxVehicles()
{
	new rows = cache_num_rows();
	new id, loaded;
 	if(rows)
  	{
		while(loaded < rows)
		{
  			cache_get_value_name_int(loaded, "ID", id);
	    	cache_get_value_name(loaded, "Sahip", xVehicle[id][xv_Sahip], MAX_PLAYER_NAME);
		    cache_get_value_name_int(loaded, "Fiyat", xVehicle[id][xv_Fiyat]);
		    cache_get_value_name_float(loaded, "X", xVehicle[id][xv_Pos][0]);
		    cache_get_value_name_float(loaded, "Y", xVehicle[id][xv_Pos][1]);
		    cache_get_value_name_float(loaded, "Z", xVehicle[id][xv_Pos][2]);
		    cache_get_value_name_float(loaded, "A", xVehicle[id][xv_Pos][3]);
		    cache_get_value_name_int(loaded, "HizliPark", xVehicle[id][xv_HizliPark]);
		    cache_get_value_name_int(loaded, "Model", xVehicle[id][xv_ModelID]);
		    cache_get_value_name_int(loaded, "Renk1", xVehicle[id][xv_Renk][0]);
		    cache_get_value_name_int(loaded, "Renk2", xVehicle[id][xv_Renk][1]);
			cache_get_value_name(loaded, "Plaka", xVehicle[id][xv_Plaka], 8);
			cache_get_value_name_int(loaded, "Garajda", xVehicle[id][xv_Garajda]);
		    cache_get_value_name_int(loaded, "PJ", xVehicle[id][xv_Paintjob]);
		    cache_get_value_name_int(loaded, "Parca1", xVehicle[id][xv_Parca][0]);
		    cache_get_value_name_int(loaded, "Parca2", xVehicle[id][xv_Parca][1]);
		    cache_get_value_name_int(loaded, "Parca3", xVehicle[id][xv_Parca][2]);
		    cache_get_value_name_int(loaded, "Parca4", xVehicle[id][xv_Parca][3]);
		    cache_get_value_name_int(loaded, "Parca5", xVehicle[id][xv_Parca][4]);
		    cache_get_value_name_int(loaded, "Parca6", xVehicle[id][xv_Parca][5]);
		    cache_get_value_name_int(loaded, "Parca7", xVehicle[id][xv_Parca][6]);
		    cache_get_value_name_int(loaded, "Parca8", xVehicle[id][xv_Parca][7]);
		    cache_get_value_name_int(loaded, "Parca9", xVehicle[id][xv_Parca][8]);
		    cache_get_value_name_int(loaded, "Parca10", xVehicle[id][xv_Parca][9]);
		    cache_get_value_name_int(loaded, "Parca11", xVehicle[id][xv_Parca][10]);
		    cache_get_value_name_int(loaded, "Parca12", xVehicle[id][xv_Parca][11]);
		    cache_get_value_name_int(loaded, "Parca13", xVehicle[id][xv_Parca][12]);
		    cache_get_value_name_int(loaded, "Parca14", xVehicle[id][xv_Parca][13]);
			
			if(!xVehicle[id][xv_Garajda])
			{
				xVehicle[id][xv_Veh] = CreateVehicle(xVehicle[id][xv_ModelID], xVehicle[id][xv_Pos][0], xVehicle[id][xv_Pos][1], xVehicle[id][xv_Pos][2], xVehicle[id][xv_Pos][3], xVehicle[id][xv_Renk][0], xVehicle[id][xv_Renk][1], -1);
				xVeh[xVehicle[id][xv_Veh]] = id;
				SetVehicleNumberPlate(xVehicle[id][xv_Veh], xVehicle[id][xv_Plaka]);
				SetVehicleToRespawn(xVehicle[id][xv_Veh]);
			}
			Iter_Add(xVehicles, id);
			loaded++;

			if(!strlen(xVehicle[id][xv_Sahip]))
			{
				new str[150];
				format(str, sizeof(str), "{00FF00}This Vehicle Is For Sale!\n{FFA500}Vehicle Name: {FFFFFF}%s\n{FFA500}Plate Number: {FFFFFF}%s\n{FFA500}Price: {00FF00}$%d", GetVehicleNameFromModel(xVehicle[id][xv_ModelID]), xVehicle[id][xv_Plaka], xVehicle[id][xv_Fiyat]);
				xVehicle[id][xv_Text] = Create3DTextLabel(str, 0x008080FF, 0.0, 0.0, 0.0, 50.0, 0);
				Attach3DTextLabelToVehicle(xVehicle[id][xv_Text], xVehicle[id][xv_Veh], 0.0, 0.0, 1.0);
			}
	    }
	}
	printf("[xVehicle] %d vehicle loaded.", loaded);
	return 1;
}

stock LoadVehicleMod(xid)
{
	for(new c; c<14; c++) AddVehicleComponent(xVehicle[xid][xv_Veh], xVehicle[xid][xv_Parca][c]);
	ChangeVehiclePaintjob(xVehicle[xid][xv_Veh], xVehicle[xid][xv_Paintjob]);
	return 1;
}

stock LoadxVehicleKeys(playerid)
{
    Iter_Clear(xVehicleKeys<playerid>);
    
    new query[72];
    mysql_format(mysqlB, query, sizeof(query), "SELECT * FROM xVehicleKeys WHERE Isim='%e'", Isim(playerid));
	mysql_tquery(mysqlB, query, "LoadCarKeys", "i", playerid);
	return 1;
}


forward LoadCarKeys(playerid);
public LoadCarKeys(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows = cache_num_rows();
 	if(rows)
  	{
   		new loaded, vehid;
     	while(loaded < rows)
      	{
      	    cache_get_value_name_int(loaded, "AracID", vehid);
       		Iter_Add(xVehicleKeys<playerid>, vehid);
   			loaded++;
 		}
   	}

	return 1;
}

stock GetVehiclexIDFromPlate(plate[])
{
	foreach(new i : xVehicles) if(!xStrcmp(plate, xVehicle[i][xv_Plaka])) return i;
	return 0;
}

stock CreatePlate() // Owner: 'KoczkaHUN'
{
	const len = 7, hyphenpos = 4;
	new plate[len+1];
	for (new i = 0; i < len; i++)
	{
		if (i + 1 == hyphenpos)
		{
			plate[i] = '-';
			continue;
		}
		if (random(2)) plate[i] = 'A' + random(26);
		else plate[i] = '0' + random(10);
	}
	return plate;
}

stock IsVehicleFlipped(vehicleid)
{
    new Float:Quat[2];
    GetVehicleRotationQuat(vehicleid, Quat[0], Quat[1], Quat[0], Quat[0]);
    return (Quat[1] >= 0.60 || Quat[1] <= -0.60);
}

stock GetPlayerxVehicleCount(playerid)
{
	new count;
	foreach(new i : xVehicles)
	{
		if(!xStrcmp(xVehicle[i][xv_Sahip], Isim(playerid))) count++;
	}
	return count;
}

stock GetPlayerInGarageVehicleCount(playerid)
{
	new count;
	foreach(new i : xVehicles)
	{
		if(!xStrcmp(xVehicle[i][xv_Sahip], Isim(playerid)) && xVehicle[i][xv_Garajda]) count++;
	}
	return count;
}

stock GetVehicleNameFromModel(modelid)
{
	new String[64];
    format(String,sizeof(String),"%s",VehicleNames[modelid - 400]);
    return String;
}

stock GetVehicleModelIDFromName(vname[])
{
	for(new i = 0; i < 211; i++)
	{
		if ( strfind(VehicleNames[i], vname, true) != -1 )
			return i + 400;
	}
	return -1;
}

stock GetPlayerIDFromName(name[])
{
	foreach(new i : Player) if(!xStrcmp(Isim(i), name)) return i;
	return INVALID_PLAYER_ID;
}

stock xStrcmp(str1[], str2[])
{
    if(strlen(str1) == strlen(str2) && strcmp(str1, str2) == 0) return 0;
	return 1;
}

stock split(const src[], dest[][], const delimiter) // From: wiki.samp [Owner: Kaliber|Kaliber]
{
    new n_pos,num,old,str[1];
    str[0] = delimiter;
    while(n_pos != -1)
    {
        n_pos = strfind(src,str,false,n_pos+1);
        strmid(dest[num++], src, (!num)?0:old+1,(n_pos==-1)?strlen(src):n_pos,256);
        old=n_pos;
    }
    return 1;
}

stock Isim(playerid)
{
	new ism[24];
	GetPlayerName(playerid, ism, 24);
	return ism;
}

stock isNumeric(const string[]) {
	new length=strlen(string);
	if (length==0) return false;
	for (new i = 0; i < length; i++) {
		if (
		(string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') // Not a number,'+' or '-'
		|| (string[i]=='-' && i!=0)                                             // A '-' but not at first.
		|| (string[i]=='+' && i!=0)                                             // A '+' but not at first.
		) return false;
	}
	if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
	return true;
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	// Created by Y_Less

	new Float:a;

	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);

	if (GetPlayerVehicleID(playerid)) {
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}

	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}