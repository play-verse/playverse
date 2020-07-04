//Include
#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <a_mysql>
#include <mSelection>

#define function:%0(%1) forward %0(%1): public %0(%1)

//Static
static stock g_arrVehicleNames[][] = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Cruiser", "SFPD Cruiser", "LVPD Cruiser",
    "Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

//Color
#define COLOR_RED 0xFF0000FF
#define COLOR_YELLOW 0xFFF000FF
#define COLOR_BLUE 0x0023FFFF
#define COLOR_WHITE 0xFEFEFEFF
#define COLOR_BLUE_LIGHT 0x00FFE6FF

//=======================Account Data===========================================
enum P_ACCOUNT_DATA
{
    pDBID,
    pAccName[60],
    pSkin,
    bool: pLogin
}

new AccountInfo[MAX_PLAYERS] [P_ACCOUNT_DATA];

//========================My SQL================================================
new ourConnection;

#define SQL_HOSTNAME "localhost"
#define SQL_USERNAME "joshong"
#define SQL_DATABASE "servertest1"
#define SQL_PASSWORD "jos12"
//==============================================================================


main()
{
    print("\n----------------------------------");
    print(" Developer of this server is Joshua!");
    print("----------------------------------\n");
}


public OnGameModeInit()
{

    ourConnection = mysql_connect(SQL_HOSTNAME, SQL_USERNAME, SQL_DATABASE, SQL_PASSWORD);
    
    if(mysql_errno() !=0)
        printf ("DATABASE: Connection failed to the MySQL");
    else printf("DATABASE: Connection succes MySQL");

    SetGameModeText("HRP||V0.0.1 Alpha");
    for(new skinid = 1; skinid < 299; skinid++)
    if (BannedSkins(skinid))
    {
        AddPlayerClass(skinid,1126.2233,-2036.9606,69.8837,272.5659,0,0,0,0,0,0);
    }
    return 1;
}

public OnGameModeExit()
{
    mysql_close(ourConnection);
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    if (AccountInfo[playerid][pLogin] == false);
    {
            SetSpawnInfo(playerid, 0, 0, 3902.9104, 1813.4032, 0, 37.1905, 0, 0, 0, 0, 0, 0);
            TogglePlayerSpectating(playerid, true);
            TogglePlayerSpectating(playerid, false);
            SetPlayerCamera(playerid);
    }
    return 1;
}

public OnPlayerConnect(playerid)
{
    new msg[228];
    format(msg,sizeof(msg), "Selamat datang di kota {0x0023FFFF}Harapan Roleplay ID %i Enjoy Roleplay!!", playerid);
    SendClientMessage(playerid, COLOR_WHITE,msg);
    
    format(msg,sizeof(msg),"ID %i Has joined our server",playerid);
    SendClientMessageToAll(COLOR_YELLOW,msg);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    return 1;
}

public OnPlayerSpawn(playerid)
{
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    return 1;
}

public OnPlayerText(playerid, text[])
{
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (strcmp("/mycommand", cmdtext, true, 10) == 0)
    {
        // Do something here
        return 1;
    }
    return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
    return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
    return 1;
}

public OnRconCommand(cmd[])
{
    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    return 1;
}

public OnObjectMoved(objectid)
{
    return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
    return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
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
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    return 1;
}

//Command Player
CMD:jetpack(playerid,params[])
{
    new msg[128];
    if (IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_RED, "You not Admin you can't do this action!");
    
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
    format(msg,sizeof(msg), "You get a jetpack to fly!");
    SendClientMessage(playerid, COLOR_BLUE_LIGHT, msg);
    return 1;
}

CMD:skin(playerid, params[])
{
    new skinid;
    if (sscanf(params, "i",skinid))
        return SendClientMessage(playerid, COLOR_RED, "Usage: /skin [skinid]");
    
    if (skinid < 1 || skinid > 299 || skinid == 0)
        return SendClientMessage(playerid, COLOR_RED, "You have specified a invalid skinid!");

    SetPlayerSkin(playerid,skinid);

    SendClientMessage(playerid, COLOR_WHITE, "You have a new skin to use in this server!");
    return 1;
}

//Stock Value

stock ReturnName(playerid, underScore = 1)
{
    new playersName[MAX_PLAYER_NAME + 2];
    GetPlayerName(playerid, playersName, sizeof(playersName));

    if(!underScore)
    {
        {
            for(new i = 0, j = strlen(playersName); i < j; i ++)
            {
                if(playersName[i] == '_')
                {
                    playersName[i] = ' ';
                }
            }
        }
    }

    return playersName;
}

stock ReturnDate()
{
    new sendString[90], MonthStr[40], month, day, year;
    new hour, minute, second;

    gettime(hour, minute, second);
    getdate(year, month, day);
    switch(month)
    {
        case 1:  MonthStr = "January";
        case 2:  MonthStr = "February";
        case 3:  MonthStr = "March";
        case 4:  MonthStr = "April";
        case 5:  MonthStr = "May";
        case 6:  MonthStr = "June";
        case 7:  MonthStr = "July";
        case 8:  MonthStr = "August";
        case 9:  MonthStr = "September";
        case 10: MonthStr = "October";
        case 11: MonthStr = "November";
        case 12: MonthStr = "December";
    }

    format(sendString, 90, "%s %d, %d %02d:%02d:%02d", MonthStr, day, year, hour, minute, second);
    return sendString;
}

stock ReturnIP(playerid)
{
    new
        ipAddress[20];

    GetPlayerIp(playerid, ipAddress, sizeof(ipAddress));
    return ipAddress;
}

stock KickEx(playerid)
{
    return SetTimerEx("KickTimer", 100, false, "i", playerid);
}


stock SendClientMessageEx(playerid, color, const str[], {Float,_}:...)
{
    static
        args,
        start,
        end,
        string[156]
    ;
    #emit LOAD.S.pri 8
    #emit STOR.pri args

    if (args > 12)
    {
        #emit ADDR.pri str
        #emit STOR.pri start

        for (end = start + (args - 12); end > start; end -= 4)
        {
            #emit LREF.pri end
            #emit PUSH.pri
        }
        #emit PUSH.S str
        #emit PUSH.C 156
        #emit PUSH.C string
        #emit PUSH.C args
        #emit SYSREQ.C format

        SendClientMessage(playerid, color, string);

        #emit LCTRL 5
        #emit SCTRL 4
        #emit RETN
    }
    return SendClientMessage(playerid, color, str);
}

stock ReturnVehicleName(vehicleid)
{
    new
        model = GetVehicleModel(vehicleid),
        name[32] = "None";

    if (model < 400 || model > 611)
        return name;

    format(name, sizeof(name), g_arrVehicleNames[model - 400]);
    return name;
}

stock BannedSkins(skinid)
{
    if(skinid < 1 || skinid > 299) return 0;
    switch(skinid)
    {
        case 0: return 0;
    }
    return 1;
}
//Function

function:SetPlayerCamera(playerid)
{
    new rand = random(3);

    switch(rand)
    {
        case 0:
        {
            SetPlayerCameraPos(playerid, 2019.1145, 1202.9185, 42.3246);
            SetPlayerCameraLookAt(playerid, 2019.9889, 1202.4272, 42.2945);
        }
        case 1:
        {
            SetPlayerCameraPos(playerid, 1701.8396, -1572.9250, 26.6298);
            SetPlayerCameraLookAt(playerid, 1701.2588, -1572.1072, 27.1848);
        }
        case 2:
        {
            SetPlayerCameraPos(playerid, -2619.1006, 2202.6091, 49.9144);
            SetPlayerCameraLookAt(playerid, -2619.2512, 2201.6155, 50.1043);
        }
    }
    return 1;
} 