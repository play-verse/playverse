/*******************************************************************************
*                SCRIPT NAME: ADMIN SYSTEM
*                SCRIPT VERSION: 1
*                SCRIPT DEVELOPER: SiaReyes
*                SCRIPT UPDATES v1:
*				 Improved some minor bugs.
*
*******************************************************************************/

//includes
#include <a_samp>
#include <sscanf2>
#include <a_mysql41>
#include <bcrypt.inc>
#include <zcmd>
#include <foreach>

#define DIALOG_REGISTER 800
#define DIALOG_LOGIN 8001
#define DIALOG_SUCCESS_1 8003
#define DIALOG_SUCCESS_2 8004
#define Grey 0xC0C0C0C8


//== Mysql Connection === //
#define HOST "127.0.0.1"
#define USER "root"
#define DB  "acctest"
#define PASS "server"
//====================== //

#define COL_WHITE "{FFFFFF}"
#define COL_RED "{F81414}"
#define COL_GREEN "{00FF22}"
#define COL_BLUE "{00CED1}"
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_BLUE 0x0000FFFF
#define COLOR_RED 0xFF0000FF
#define COLOR_GREEN 0x3BBD44FF
#define	BCRYPT_COST	15 // Limit 0-41
native gpci(playerid, serial[], maxlen);
new ServerTimer = -1;

new MySQL:SiaSql, String[500], query[400], Float:SpecX[MAX_PLAYERS], Float:SpecY[MAX_PLAYERS], Float:SpecZ[MAX_PLAYERS], vWorld[MAX_PLAYERS], Inter[MAX_PLAYERS];
new muted[MAX_PLAYERS], Jailed[MAX_PLAYERS], IsSpecing[MAX_PLAYERS], SpamCount[MAX_PLAYERS], Name[MAX_PLAYER_NAME], IsBeingSpeced[MAX_PLAYERS],spectatorid[MAX_PLAYERS];

enum pInfo
{
    pID,
    pCash,
    pAdmin,
    pKills,
    pDeaths,
    pActive,
    pScore,
    pWarns,
    pDuty,
    bool:pLogged,
    pPlayerName[MAX_PLAYER_NAME]
}

new PlayerInfo[MAX_PLAYERS][pInfo];

public OnFilterScriptInit()
{


	SiaSql = mysql_connect(HOST, USER, PASS, DB);
	if(SiaSql == MYSQL_INVALID_HANDLE)
	{
		print(" SiaReyes Account System: Connection to MySQL failed!");
		SendRconCommand("unloadfs account");
	}
	print("SiaReyes Account System: Connection Established!");


/* Tables
     CREATE TABLE IF NOT EXISTS `Users` (
	`ID` int(7) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Players Reg ID',
	`name` varchar(24) NOT NULL COMMENT 'Player''s Name',
	`playerip` varchar(17) NOT NULL COMMENT 'Players IP',
	`password` varchar(200) NOT NULL COMMENT 'Players Password',
	`kills` int(6) unsigned NOT NULL DEFAULT 0 COMMENT 'Player Kills',
	`deaths` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Player Deaths',
	`adminlevel` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Player Level',
	`money` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Player Money',
	`score` mediumint(6) unsigned NOT NULL DEFAULT 0 COMMENT 'Player Score',
	`active` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'Player Active',
	PRIMARY KEY (`ID`),
	KEY `name` (`name`)
	) ENGINE=MyISAM  AUTO_INCREMENT = 0 DEFAULT CHARSET=latin1 COMMENT='Player Data Storage';

	CREATE TABLE IF NOT EXISTS `ServerBans`
	(`BID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(24) NOT NULL,
	`adminbanned` VARCHAR(24) NOT NULL,
	`reason` VARCHAR(200) NOT NULL,
	`banIP` VARCHAR(17) NOT NULL,
	`BanDate` VARCHAR(40) NOT NULL,
	 PRIMARY KEY (`BID`)
	) ENGINE=MyISAM AUTO_INCREMENT= 0 DEFAULT CHARSET=latin1 COMMENT='Server Ban Storage';
*/

    ServerTimer = SetTimer("GlobalTimer", 1000, true);
	return 1;
}

public OnFilterScriptExit()
{
  mysql_close(SiaSql);
  KillTimer(ServerTimer);
  return 1;
}

public OnPlayerConnect(playerid)
{
	new pname[MAX_PLAYER_NAME], PlayerIP1[17], cString[200];

	GetPlayerIp(playerid, PlayerIP1, sizeof(PlayerIP1));
	GetPlayerName(playerid,pname, sizeof(pname));
        PlayerInfo[playerid][pPlayerName] = pname;

	format(cString, sizeof(cString), "proxy.mind-media.com/block/proxycheck.php?ip=%s", PlayerIP1);
	HTTP(playerid, HTTP_GET, cString, "", "CheckPlayerProxy");

    ResetVariables(playerid);
    mysql_format(SiaSql, query, sizeof(query), "SELECT * FROM `ServerBans` WHERE `name` = '%e';",PlayerInfo[playerid][pPlayerName]);
	mysql_tquery(SiaSql, query, "PlayerBanCheck", "d", playerid);
    return 1;
}

forward CheckPlayerProxy(playerid, response_code, data[]);
public CheckPlayerProxy(playerid, response_code, data[])
{
	new cpstring[200], ip[17];
	GetPlayerIp(playerid, ip, sizeof(ip));
	if(strcmp(ip, "127.0.0.1", true) == 0) return 1;
	if(response_code == 200)
	{
		if(data[0] == 'Y')
		{
			format(cpstring, sizeof(cpstring), "Proxy/VPN: %s(%d) has joined the server using a VPN/Proxy.", PlayerInfo[playerid][pPlayerName], playerid);
	    	SendClientMessageToAll(0xFF0000FF, cpstring);
		}
		if(data[0] == 'N')
		{
			return 1;
		}
		if(data[0] == 'X')
		{
			format(cpstring, sizeof(cpstring), "Proxy/VPN: %s(%d) has joined the server using an Invalid IP.", PlayerInfo[playerid][pPlayerName], playerid);
	    	SendClientMessageToAll(0xFF0000FF, cpstring);
	    	return 1;
		}
	}
	return 1;
}


forward PlayerBanCheck(playerid);
public PlayerBanCheck(playerid)
{
	new rows = cache_num_rows();
	if(rows != 0)
	{
	    new playername[24], adminid[24], reasonban[200], bdate[50], pserial[64];
	    cache_get_value_name(0, "name", playername);
	    cache_get_value_name(0, "adminbanned", adminid);
	    cache_get_value_name(0, "BanDate", bdate);
	    cache_get_value_name(0, "reason", reasonban);
	    cache_get_value_name(0, "reason", reasonban);
		    new line [300];
		    SendClientMessage(playerid, -1, ""COL_RED"You are banned from this server. You can apply for unban in our server forum!");
			format(line, sizeof(line), ""COL_WHITE"You are banned.\n\n"COL_WHITE"Ban Information:\n"COL_WHITE"Name: "COL_WHITE"%s\n"COL_WHITE"Admin who banned you: "COL_WHITE"%s\n"COL_WHITE"Ban Reason: "COL_WHITE"%s\n"COL_WHITE"Ban Date: "COL_WHITE"%s\n", playername, adminid, reasonban, bdate);
			ShowPlayerDialog(playerid, 1227, DIALOG_STYLE_MSGBOX, ""COL_WHITE"Banned", line, "Exit", "");
		     SetTimerEx("KickPlayer", 2000, false, "d", playerid);
	}
	else
	{
		mysql_format(SiaSql, query, sizeof(query), "SELECT * FROM `Users` WHERE `name` = '%e'", PlayerInfo[playerid][pPlayerName]);
        mysql_tquery(SiaSql, query, "AccountExist", "d", playerid);
	}
	return 1;
}

forward AccountExist(playerid);
public AccountExist(playerid)
{
	if(cache_num_rows())
	{
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,""COL_WHITE"Login",""COL_WHITE"Type your password to login to acces your account","Login","Quit");
	}
	else
	{
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""COL_WHITE"Register",""COL_WHITE"{FFFFFF}You are {FF0000}not {FFFFFF}registered","Register","Quit");
	}
	return 1;
}

ResetVariables(playerid)
{
	PlayerInfo[playerid][pActive] = 0;
	PlayerInfo[playerid][pScore] = 0;
	PlayerInfo[playerid][pKills] = 0;
	PlayerInfo[playerid][pAdmin] = 0;
	PlayerInfo[playerid][pDeaths] = 0;
	PlayerInfo[playerid][pWarns] = 0;
	PlayerInfo[playerid][pDuty] = 1;
	Jailed[playerid] = 0;
	PlayerInfo[playerid][pKills] = 0;
	PlayerInfo[playerid][pCash] = 0;
	PlayerInfo[playerid][pLogged] = false;
	muted[playerid] = 0;
	IsSpecing[playerid] = 0;
	SpamCount[playerid] = 0;
	PlayerInfo[playerid][pID] = -1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
  if(Jailed[playerid] > 0)
  {
    SendClientMessage(playerid, COLOR_RED, "Server: You aren't allowed to use commands while you are in jail");
    return 0;
  }
  return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch( dialogid )
    {
        case DIALOG_REGISTER:
        {
            if(response)
            {
               bcrypt_hash(inputtext, BCRYPT_COST, "PlayerPasswordTyped", "d", playerid);
            }
            else Kick(playerid);
        }
        case DIALOG_LOGIN:
        {
            if( response )
            {
                new ppass[BCRYPT_HASH_LENGTH];
				mysql_format(SiaSql, query, sizeof(query), "SELECT `password` FROM `Users` WHERE `name` = '%e'", PlayerInfo[playerid][pPlayerName]);
				mysql_query(SiaSql, query);
			    cache_get_value_name(0, "password", ppass, BCRYPT_HASH_LENGTH);
				bcrypt_check(inputtext, ppass, "PasswordRight", "d", playerid);
            }
            else Kick ( playerid );
        }
    }
    return 1;
}

forward PlayerPasswordTyped(playerid);
public PlayerPasswordTyped(playerid)
{
	new bhash[BCRYPT_HASH_LENGTH];
	new PlayerIP[17];
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	bcrypt_get_hash(bhash);
	new Cache:result;
	mysql_format(SiaSql, query, sizeof(query), "INSERT INTO `Users` (`name`, `password`, `playerip`, `active`) VALUES ('%e', '%e', '%e', '1')", PlayerInfo[playerid][pPlayerName], bhash, PlayerIP);
	result = mysql_query(SiaSql, query);
	PlayerInfo[playerid][pActive] = 1;
	PlayerInfo[playerid][pLogged] = true;
	PlayerInfo[playerid][pID] =  cache_insert_id();
	format(String, sizeof(String), "Server: %s(%d) has registered and making total number of %s registered players",PlayerInfo[playerid][pPlayerName], playerid, GetCurrency(PlayerInfo[playerid][pID]));
	SendClientMessageToAll(COLOR_BLUE, String);
    cache_delete(result);
    //	SpawnPlayer(playerid); // Goes to Skin Selection
	return 1;
}


forward PasswordRight(playerid);
public PasswordRight(playerid)
{
	new bool:match = bcrypt_is_equal();
	if(!match) return printf("Password checked for %s: %s", PlayerInfo[playerid][pPlayerName], (match) ? ("Match") : ("No match")), ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,""COL_WHITE"Login",""COL_WHITE"Wrong Password! Please type the correct password.","Login","Quit");
    printf("Password checked for %s: %s", PlayerInfo[playerid][pPlayerName], (match) ? ("Match") : ("No match"));
	mysql_format(SiaSql, query, sizeof(query), "SELECT * FROM `Users` WHERE `name` = '%e'", PlayerInfo[playerid][pPlayerName]);
	mysql_tquery(SiaSql, query, "LoadPlayerData", "d", playerid);

	mysql_format(SiaSql, query, sizeof(query), "UPDATE `Users` SET `active` = '1' WHERE `ID` = '%i'", PlayerInfo[playerid][pID]);
	mysql_query(SiaSql, query);
	PlayerInfo[playerid][pActive] = 1;
	return 1;
}

forward LoadPlayerData(playerid);
public LoadPlayerData(playerid)
{
	cache_get_value_name_int(0, "ID", PlayerInfo[playerid][pID]);
	cache_get_value_name_int(0, "money", PlayerInfo[playerid][pCash]);
	cache_get_value_name_int(0, "kills", PlayerInfo[playerid][pKills]);
	cache_get_value_name_int(0, "deaths", PlayerInfo[playerid][pDeaths]);
	cache_get_value_name_int(0, "adminlevel", PlayerInfo[playerid][pAdmin]);
	cache_get_value_name_int(0, "score", PlayerInfo[playerid][pScore]);

	//Giving Player the Money and Score
	SetPlayerScore(playerid, PlayerInfo[playerid][pScore]);

	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);

	SendClientMessage(playerid, COLOR_GREEN, "Success: You have been successfully logged in");
	PlayerInfo[playerid][pLogged] = true;
//	SpawnPlayer(playerid); // Goes to Skin Selection
	return 1;
}


forward Wheel1(playerid);

public OnPlayerDisconnect(playerid,reason)
{
    if(PlayerInfo[playerid][pLogged]) SavePlayerData(playerid);
    return 1;
}

//- Anti money hack and Score ----
stock GiveMoneyPlayer(playerid, money)
{
	PlayerInfo[playerid][pCash] += money;
	GivePlayerMoney(playerid, money);
}
stock GiveScorePlayer(playerid, score)
{
	PlayerInfo[playerid][pScore] += score;
	SetPlayerScore(playerid, GetPlayerScore(playerid)+score);
}
//---

stock SavePlayerData(playerid)
{
    PlayerInfo[playerid][pActive] = 0;
    PlayerInfo[playerid][pLogged] = false;
	mysql_format(SiaSql, query, sizeof(query), "UPDATE `Users` SET `money` = '%i', `kills` = '%i', `deaths` = '%i', `adminlevel` = '%i', `score` = '%i', `active` = '0' WHERE `ID` = '%i'", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pKills], PlayerInfo[playerid][pDeaths], PlayerInfo[playerid][pAdmin],PlayerInfo[playerid][pScore], PlayerInfo[playerid][pID]);
	mysql_query(SiaSql, query);
}


public OnPlayerDeath(playerid,killerid,reason)
{
    if(IsBeingSpeced[playerid] == 1)
    {
        foreach(new i : Player)
        {
            if(spectatorid[i] == playerid)
            {
                TogglePlayerSpectating(i,false);
            }
        }
    }
	if(killerid != INVALID_PLAYER_ID)
	{
       PlayerInfo[killerid][pKills]++;
       SendClientMessage(killerid, COLOR_BLUE, "You have earned +$2000 cash and +5 score for killing a player");
       GiveScorePlayer(killerid, 5);
       GiveMoneyPlayer(killerid, 2000);
	}
	PlayerInfo[playerid][pDeaths]++;
	SendDeathMessage(killerid, playerid, reason);
    return 1;
}

public OnPlayerText(playerid,text[])
{
    if(muted[playerid] != 0)
    {
        SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B}You can not talk while your muted.");
        return 0;
    }
    if(text[0] == '@' && PlayerInfo[playerid][pAdmin] != 0)
    {
        cmd_achat(playerid, text[1]);
        return false;
    }
    SpamCount[playerid]++;
	SetTimerEx("ResetTextLines", 5000, false, "d", playerid);
	if(SpamCount[playerid] == 5)
	{
		format(String,sizeof(String),"%s(%d) has been kicked - Reason: SPAM", PlayerInfo[playerid][pPlayerName], playerid);
		SendClientMessageToAll(COLOR_WHITE, String);
		SetTimerEx("KickPlayer", 2000, false, "d", playerid);
	}
	else if(SpamCount[playerid] == 3 || SpamCount[playerid] == 4)
	{
		SendClientMessage(playerid,COLOR_RED, "STOP SPAMMING! or YOU WILL  BE KICKED [WAIT 5 SECS...]");
		return 0;
	}
    return 1;
}


forward ResetTextLines(playerid);
public ResetTextLines(playerid)
{
	SpamCount[playerid] = 0;
	return 1;
}

CMD:slap(playerid,params[])
{
	if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");
    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");

    new target,Float:x,Float:y,Float:z;
    if(sscanf(params,"u",target)) return SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B} Use /slap (playerid).");
    if(!IsPlayerConnected(target)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} Player is not connected.");
    format(String,sizeof(String),"{F83934}[System]:{8B8B8B} %s got slapped by an Staff Member.",PlayerInfo[target][pPlayerName]);
    SendClientMessageToAll(-1,String);
    GetPlayerPos(target,x,y,z);
    SetPlayerPos(target,x,y,z+15);
    return 1;
}

CMD:ask(playerid, params[])
{
	new text[128],count=0;
	if(sscanf(params, "s[128]", text)) return  SendClientMessage(playerid,-1,"{F83934}[Usage]: /ask [text]");
	foreach(new i : Player) if(PlayerInfo[i][pAdmin] != 0) count++;
	if(count == 0) return SendClientMessage(playerid, COLOR_RED, "System: There are no admins online");

	format(String, sizeof(String), "[ADMIN-ASK] %s(%d) : %s", PlayerInfo[playerid][pPlayerName], playerid, text);
    foreach(new ii : Player) if(PlayerInfo[ii][pAdmin] != 0)
	{
	   SendClientMessage(ii, COLOR_RED, String);
	}
    SendClientMessage(playerid, COLOR_GREEN, "Your query has been sent to online admins, please wait for the reply!");
	return 1;
}


CMD:get(playerid,params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");
    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");

    new targetid,Float:x,Float:y,Float:z;
    if(sscanf(params,"u",targetid)) return SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B} Use /getplayer( (playerid).");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} Player is not connected.");

    GetPlayerPos(playerid, x, y, z);
    SetPlayerPos(targetid, x, y+1.5, z);

	format(String, sizeof(String), "You have teleported %s(%d)'s to your position.", PlayerInfo[targetid][pPlayerName], targetid);
	SendClientMessage(playerid, COLOR_BLUE, String);
	format(String, sizeof(String), "%s(%d) has teleported you to their position.", PlayerInfo[playerid][pPlayerName], playerid);
	SendClientMessage(targetid, COLOR_BLUE, String);

    return 1;
}

CMD:warn(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");

	new targetid, reason[128], string[200];
	if(sscanf(params, "us[128]", targetid, reason)) return SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B} /warn [name/id] [reason]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B} That player is not connected.");

	format(string, sizeof(string), "Server:  %s(%d) has been warned by %s(%d), Reason: %s", PlayerInfo[targetid][pPlayerName], targetid,PlayerInfo[playerid][pPlayerName], playerid, reason);
	SendClientMessageToAll(COLOR_WHITE, string);
	PlayerInfo[targetid][pWarns]++;

	if(PlayerInfo[targetid][pWarns] <= 3)
	{
	    SetTimerEx("KickPlayer", 2000, false, "d", targetid);
	    format(string, sizeof(string), "Server: %s(%d) has been kicked from the server.", PlayerInfo[targetid][pPlayerName], targetid);
	    SendClientMessageToAll(COLOR_WHITE, string);
	}
	return 1;
}

CMD:jail(playerid,params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");

    new target, time, reason[120];
    if(sscanf(params,"uis[120]",target, time, reason)) return SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B} Use /jail (playerid) (time 10-600) (reason).");
    if(!IsPlayerConnected(target)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} Player is not connected.");
	if(Jailed[target] != 0) return SendClientMessage(playerid,-1,"{F83934} The player is already in jail!");
    if(reason[0] != '*' && strlen(reason) > 120)
	{
	 	SendClientMessage(playerid,-1,"{F83934} Reason too long! Must be smaller than 120 characters!");
	   	return true;
	}
	if(time < 10 || time > 600)
	{
			SendClientMessage(playerid,-1,"{F83934}Jail time must remain between 10 and 600 seconds");
	    	return true;
	}
	ResetPlayerWeapons(target);
	Jailed[target] = time;
	SetPlayerPos(target, 198.4245, 162.3897, 1003.0859);
	SetPlayerInterior(target, 3);
	SetPlayerVirtualWorld(target, 909);
    format(String,sizeof(String),"{F83934}[System]:{8B8B8B} %s has jailed %s for %d seconds - Reason: %s",PlayerInfo[playerid][pPlayerName], PlayerInfo[target][pPlayerName], time, reason);
    SendClientMessageToAll(-1,String);
    return 1;
}

CMD:unjail(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B} /unjail <ID/Name>");
	    return true;
	}

    if(otherid == INVALID_PLAYER_ID)
        return SendClientMessage(playerid,COLOR_RED, "Player not connected!");

	if(Jailed[otherid] == 0)
	    return SendClientMessage(playerid,COLOR_RED, "That player not in jail!");

	Jailed[otherid] = 0;
	SetPlayerInterior(otherid, 0);
	SetPlayerVirtualWorld(otherid, 0);
	SpawnPlayer(otherid);

    format(String,sizeof(String),"{F83934}[System]:{8B8B8B} %s has unjailed %s",PlayerInfo[playerid][pPlayerName], PlayerInfo[otherid][pPlayerName]);
    SendClientMessageToAll(-1,String);
    return true;
}

CMD:achat(playerid, params[])
{

    if(PlayerInfo[playerid][pAdmin] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
	if(isnull(params))
	{
	    SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B} /achat <text>");
	    return true;
	}

	format(String, sizeof(String), ""COL_RED"[Admin Chat] "COL_GREEN"%s(%i): "COL_WHITE"%s", PlayerInfo[playerid][pPlayerName], playerid, params);
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pAdmin] == 0)
			if(!IsPlayerAdmin(i)) continue;
    	SendClientMessage(i, -1, String);
	}
	return true;
}
CMD:freeze(playerid,params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    new target;
    if(sscanf(params,"u",target)) return SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B} Use /freeze (playerid).");
    if(!IsPlayerConnected(target)) return SendClientMessage(playerid,-1,"ERROR:Player not connected.");
    format(String,sizeof(String),"{F83934}[System]:{8B8B8B} %s got frozen by an Staff Member.",PlayerInfo[target][pPlayerName]);
    SendClientMessageToAll(-1,String);
    TogglePlayerControllable(target,0);
    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    return 1;
}

CMD:unfreeze(playerid,params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    new target;
    if(sscanf(params,"u",target)) return SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B} Use /unfreeze (playerid).");
    if(!IsPlayerConnected(target)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} Player is not connected .");
    format(String,sizeof(String),"{F83934}[System]:{8B8B8B} %s got unfrozen by an Staff Member.",PlayerInfo[target][pPlayerName]);
    SendClientMessageToAll(-1,String);
    TogglePlayerControllable(target,1);
    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    return 1;
}

CMD:agoto(playerid,params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    new target,Float:x,Float:y,Float:z;
    if(sscanf(params,"u",target)) return SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B} Use /agoto (playerid).");
    if(!IsPlayerConnected(target)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} Player is not connected");
    GetPlayerPos(target,x,y,z);
    SetPlayerPos(playerid,x,y,z);
    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    return 1;
}


CMD:mute(playerid,params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    new target, time;
    if(sscanf(params,"ui",target, time)) return SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B} Use /mute (playerid), (time).");
    if(!IsPlayerConnected(target)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} Player is not connected.");
    if(time < 10)
  	{
		SendClientMessage(playerid,-1,"{F83934}Mute  time must remain above 10 seconds");
    	return true;
	}
	format(String,sizeof(String),"{F83934}[System]:{8B8B8B} %s got muted by an staff member for %d seconds.",PlayerInfo[target][pPlayerName], time);
    SendClientMessageToAll(-1,String);
    muted[target] = time;
    PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
    return 1;
}

CMD:unmute(playerid,params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    new target;
    if(sscanf(params,"u",target)) return SendClientMessage(playerid,-1,"{FF0000}[Usage]: {FFFF00}/Unmute (PlayerID).");
    if(!IsPlayerConnected(target)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} Player is not connected.");
    format(String,sizeof(String),"{F83934}[System]:{8B8B8B} %s got unmuted by an Staff Member.",PlayerInfo[target][pPlayerName]);
    SendClientMessageToAll(-1,String);
    muted[target] = 0;
    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    return 1;
}

CMD:kick(playerid,params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    new target,reason[66];
    if(sscanf(params,"us[66]",target,reason)) return SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B}/kick (PlayerID) (Reason).");
    if(!IsPlayerConnected(target)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} Player is not connected.");
    format(String,sizeof(String),"{F83934}[System]:{8B8B8B} %s got kicked by an Staff Member.[ Reason: %s ]",PlayerInfo[target][pPlayerName],reason);
    SendClientMessageToAll(-1,String);
    Kick(target);
    PlayerPlaySound(playerid, 1009, 0.0, 0.0, 0.0);
    return 1;
}

CMD:ban(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");

	new ip[17];
    new otherid, reason[200];

	if(sscanf(params, "us[200]", otherid, reason)) return SendClientMessage(playerid, -1, "Usage: /ban [playerid] [reason]");
	if(!IsPlayerConnected(otherid)) return SendClientMessage(playerid, -1, "Player not Found!");

	new line2[300], datestr[200];
	new month, day, year;
	new hour, minute, second;
	gettime(hour, minute, second);
	getdate(year, month, day);
	GetPlayerIp(otherid, ip, sizeof(ip));

	format(datestr, 200, "%02d:%02d (%02d/%02d/%d)", hour, minute, month, day, year);

	SendClientMessage(otherid, COLOR_RED, "You have been banned.");

	format(line2, sizeof(line2), ""COL_WHITE"You are banned.\n\n"COL_WHITE"Ban Information:\n"COL_WHITE"Name: "COL_WHITE"%s\n"COL_WHITE"IP: "COL_WHITE"%s\n"COL_WHITE"Admin who banned you: "COL_WHITE"%s\n"COL_WHITE"Ban Reason: "COL_WHITE"%s\n"COL_WHITE"Ban Date: "COL_WHITE"%s\n",
	PlayerInfo[otherid][pPlayerName], ip, PlayerInfo[playerid][pPlayerName], reason, datestr);
	ShowPlayerDialog(otherid, 1227, DIALOG_STYLE_MSGBOX, ""COL_WHITE"Banned", line2, "Exit", "");


	mysql_format(SiaSql, query, sizeof(query), "INSERT INTO `ServerBans` (`name`, `adminbanned`, `reason`, `banIP`, `BanDate`) VALUES ('%e', '%e', '%e', '%e', '%e')", PlayerInfo[otherid][pPlayerName], PlayerInfo[playerid][pPlayerName], reason, ip,datestr);
	mysql_query(SiaSql, query);

	format(String, sizeof(String), "{9ACD32}** "COL_RED"%s(%i) has banned %s(%i) [Reason: %s]", PlayerInfo[playerid][pPlayerName], playerid, PlayerInfo[otherid][pPlayerName], otherid, reason);
    SendClientMessageToAll(-1, String);
    SetTimerEx("KickPlayer", 2000, false, "d", otherid);
	return 1;
}

forward KickPlayer(playerid);
public KickPlayer(playerid)
{
   Kick(playerid);
   return 1;
}

CMD:unban(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");

	new name[MAX_PLAYER_NAME] ,rows;
	if(sscanf(params, "s[200]", name)) return SendClientMessage(playerid, -1, "USAGE: /unban [name]");
	mysql_format(SiaSql, query, sizeof(query), "SELECT * FROM `ServerBans` WHERE `name` = '%e'", name);
	new Cache:result = mysql_query(SiaSql, query);
	cache_get_row_count(rows);
    if(!rows) return SendClientMessage(playerid, -1, "[INFO] Name doesn't exist in the ban database, Please re-check!");
    mysql_format(SiaSql, query, sizeof(query), "DELETE FROM `Serverbans` WHERE `name` = '%e'", name);
    mysql_tquery(SiaSql, query);
    format(String, sizeof(String), "{9ACD32}** "COL_RED"%s(%i) has unbanned %s", PlayerInfo[playerid][pPlayerName], playerid, name);
    SendClientMessageToAll(-1, String);
	cache_delete(result);
	return 1;
}

CMD:checkban(playerid, params[]) return cmd_baninfo(playerid, params);
CMD:baninfo(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, -1, "SERVER: You are not authorized to use that command.");
	new name[MAX_PLAYER_NAME], rows, line3[500];
	if(sscanf(params, "s[24]", name)) return SendClientMessage(playerid, -1, "USAGE: /baninfo [username]");
	mysql_format(SiaSql, query, sizeof(query), "SELECT * FROM `Serverbans` where `name` = '%e'", name);
	new Cache:result = mysql_query(SiaSql, query);
	cache_get_row_count(rows);
    if(!rows) return SendClientMessage(playerid, -1, "[INFO] Name doesn't exist in the ban database, Please re-check!");

	for (new i = 0; i < rows; i ++)
	{
		new Username[24], BannedBy[24], BanReason[24], BanID, Date[30], oip[17];
		cache_get_value_name(0, "name", Username);
		cache_get_value_name(0, "adminbanned", BannedBy);
		cache_get_value_name(0, "reason", BanReason);
		cache_get_value_name(0, "BanDate", Date);
		cache_get_value_name(0, "banIP", oip);
		cache_get_value_name_int(0, "BID", BanID);

		format(line3, sizeof(line3), ""COL_WHITE"Ban Information: Ban ID: %d\n"COL_WHITE"Name: "COL_WHITE"%s\n"COL_WHITE"IP: "COL_WHITE"%s\n"COL_WHITE"Admin who banned: "COL_WHITE"%s\n"COL_WHITE"Ban Reason: "COL_WHITE"%s\n"COL_WHITE"Ban Date: "COL_WHITE"%s\n",
		BanID, Username, oip,BannedBy, BanReason, Date);
		ShowPlayerDialog(playerid, 1227, DIALOG_STYLE_MSGBOX, ""COL_WHITE"Banned Info", line3, "Exit", "");
	}
	cache_delete(result);
	return 1;
}
CMD:ip(playerid,params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    new target,pIP[34];
    if(sscanf(params,"u",target)) return SendClientMessage(playerid,-1,"{F83934}[Usage]:{8B8B8B}/IP (PlayerID)");
    if(!IsPlayerConnected(target)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} Player is not connected.");
    GetPlayerIp(target,pIP,34);
    format(String,sizeof(String),"{FFFF00}%s's IP is %s",PlayerInfo[target][pPlayerName],pIP);
    SendClientMessage(playerid,-1,String);
    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    return 1;
}

CMD:setadminlevel(playerid,params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 3)
	  if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    new target,level;
    if(sscanf(params,"ud",target,level)) return SendClientMessage(playerid,-1,"{FF0000}[Usage]: {FFFF00}/setadminlevel (PlayerID) (Level)");
    if(!IsPlayerConnected(target)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} Player is not connected.");
    if(level < 0 || level > 3) return SendClientMessage(playerid,-1,"{F83934}[Error]:Invalid level. (1 - 3)");
    PlayerInfo[target][pAdmin] = level;
    return 1;
}

CMD:spec(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    new id;
    if(PlayerInfo[playerid][pAdmin] < 1) return 0;
    if(sscanf(params,"u", id))return SendClientMessage(playerid, Grey, "{F83934}[Usage]:{8B8B8B}/Spec (ID)");
    if(id == playerid)return SendClientMessage(playerid,Grey,"{F83934}[Error]:{8B8B8B} You Cannot Spectate Yourself");
    if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, Grey, "{F83934}[Error]:Player Not Found");
    if(IsSpecing[playerid] == 1)return SendClientMessage(playerid,Grey,"{F83934}[Error]:You Are Already Spectating Somebody");
    GetPlayerPos(playerid,SpecX[playerid],SpecY[playerid],SpecZ[playerid]);
    Inter[playerid] = GetPlayerInterior(playerid);
    vWorld[playerid] = GetPlayerVirtualWorld(playerid);
    TogglePlayerSpectating(playerid, true);
    if(IsPlayerInAnyVehicle(id))

        if(GetPlayerInterior(id) > 0)
        {
            SetPlayerInterior(playerid,GetPlayerInterior(id));
        }
        else  if(GetPlayerVirtualWorld(id) > 0)
        {
            SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
        }
    PlayerSpectateVehicle(playerid,GetPlayerVehicleID(id));

    {
        if(GetPlayerInterior(id) > 0)
        {
            SetPlayerInterior(playerid,GetPlayerInterior(id));
        }
        if(GetPlayerVirtualWorld(id) > 0)
        {
            SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
        }
        PlayerSpectatePlayer(playerid,id);
    }
    GetPlayerName(id, Name, sizeof(Name));
    format(String, sizeof(String),"{F83934}[System]:{8B8B8B} You're now Spectating %s.",Name);
    SendClientMessage(playerid,0x0080C0FF,String);
    IsSpecing[playerid] = 1;
    IsBeingSpeced[id] = 1;
    spectatorid[playerid] = id;
    return 1;
}

CMD:specoff(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    TogglePlayerSpectating(playerid, 0);
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        if(IsBeingSpeced[playerid] == 1)
        {
            foreach(new i : Player)
            {
                if(spectatorid[i] == playerid)
                {
                    PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
                }
            }
        }
    }
    if(newstate == PLAYER_STATE_ONFOOT)
    {
        if(IsBeingSpeced[playerid] == 1)
        {
            foreach(new i : Player)
            {
                if(spectatorid[i] == playerid)
                {
                    PlayerSpectatePlayer(i, playerid);
                }
            }
        }
    }
    return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    if(IsBeingSpeced[playerid] == 1)
    {
        foreach(new i : Player)
        {
            if(spectatorid[i] == playerid)
            {
                SetPlayerInterior(i,GetPlayerInterior(playerid));
                SetPlayerVirtualWorld(i,GetPlayerVirtualWorld(playerid));
            }
        }
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{

    //Anti-Kill Protection
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerHealth(playerid, 99999);
    SetPlayerHealth(playerid, 999999);
    SendClientMessage(playerid, 0xFF0000FF, "{F83934}[System]:{8B8B8B} Anti-Spawn kill protection");
    SetTimerEx("EndAntiSpawnKill", 1000*5, false, "i", playerid); // 5 seconds
    //---------

	return 1;
}


forward EndAntiSpawnKill(playerid);
public EndAntiSpawnKill(playerid)
{

    SetPlayerHealth(playerid, 100);


    SendClientMessage(playerid, 0xFF0000FF, "{F83934}[System]:{8B8B8B} Anti-Spawn kill protection over");
    return 1;
}

CMD:report(playerid, params[])
{
    new tmp[256], idx;
    tmp = strrest(params, idx);
    if(!strlen(tmp)){
        SendClientMessage(playerid, 0x555252AA, "{F83934}[Usage]:{8B8B8B}/Report [PlayerID] [Reason]");
        return 1;
    }else{
        new pid = strval(tmp);
        tmp = strrest(params, idx);
        if(!IsPlayerConnected(pid)){
            SendClientMessage(playerid, 0x555252AA, "{F83934}[Error]:{8B8B8B} Invalid ID!");
            return 1;
        }else{
            if(!strlen(tmp)){
                SendClientMessage(playerid, 0x555252AA, "{F83934}[Usage]:{8B8B8B}/Report [PlayerID] [Reason]");
                return 1;
            }else{
                new name[MAX_PLAYER_NAME], name2[MAX_PLAYER_NAME];
                GetPlayerName(playerid, name, sizeof(name));
                GetPlayerName(pid, name2, sizeof(name2));
                format(String, sizeof(String), "{00FFFF}>> - %s(%d) Has Reported %s(%d) For '%s'", name, playerid, name2, pid, tmp);
                for(new i=0; i<GetMaxPlayers(); i++){
                    if(IsPlayerConnected(i)){
                        if(PlayerInfo[playerid][pAdmin] < 1) {
                            SendClientMessage(i, 0x555252AA, String);
                            PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
                        }
                    }
                }
            }
        }
    }
    return 1;
}

strrest(const sString[], &index)
{
    new length = strlen(sString);
    while ((index < length) && (sString[index] <= ' '))
    {
        index++;
    }

    new offset = index;
    new result[20];
    while ((index < length) && (sString[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
    {
        result[index - offset] = sString[index];
        index++;
    }
    result[index - offset] = EOS;
    return result;
}

CMD:announce(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    new text[64], time, style;
    if(PlayerInfo[playerid][pAdmin] < 2) return 0;
    else if (sscanf(params, "iis[64]", style, time, text)) return SendClientMessage(playerid,Grey,"{F83934}[Usage]:{8B8B8B}/Announce (Style[0-6]) (Time) (Text)");
    else if (strlen(text) > 64) return SendClientMessage(playerid,Grey,"{F83934}[Error]:{8B8B8B} Message is too long.");
    else if (style == 2) return SendClientMessage(playerid,Grey,"{F83934}[Usage]:{8B8B8B} Bug with style No.2 don't use it!");
    else if (style < 0 || style > 6) return SendClientMessage(playerid,0x854900FF,"{F83934}[Error]:{8B8B8B}");
    else if (time > 20*1000) return SendClientMessage(playerid, Grey,"{F83934}[Error]:{8B8B8B} Message can not be longer then 20 seconds!");
    else {
        GameTextForAll(text, time, style);
    }
    return 1;
}

CMD:giveall(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 2) return 0;

	new amount, tmp[20];
    if(sscanf(params, "sd", tmp, amount)) return
        SendClientMessage(playerid,Grey,"{F83934}[Usage]:{8B8B8B}/giveall (cash/score) amount");
    if(strcmp(tmp, "cash", true))
    {
	   foreach(new ii : Player)
	   {
	    	GiveMoneyPlayer(ii, amount);
	    	format(String, sizeof(String), "~y~~h~Cashfall");
	        GameTextForPlayer(ii, String, 3500, 4);
	   }
	}
	else if(strcmp(tmp, "score", true))
	{
       foreach(new ii : Player)
	   {
	    	GiveMoneyPlayer(ii, amount);
	    	format(String, sizeof(String), "~y~~h~Scorefall");
	        GameTextForPlayer(ii, String, 3500, 4);
	   }
    }
	return 1;
}
CMD:statistics(playerid, params[]) return cmd_stats(playerid, params);
CMD:stats(playerid, params[])
{

	if(PlayerInfo[playerid][pLogged] == false)
	{
       GameTextForPlayer(playerid, "~y~You need to be logged in", 3000, 3);
	   return true;
	}
	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    ShowStats(playerid, playerid);
 	}
	else
	{
	    if(otherid == INVALID_PLAYER_ID)
	    {
			GameTextForPlayer(playerid, "~r~Invalid Player", 3000, 3);
			return true;
		}
	    ShowStats(playerid, otherid);
	}
	return true;
}

stock ShowStats(playerid, otherplayerid)
{
  new stringstats[800], headline[80];

  format(headline, 80, "%s's Statistics",PlayerInfo[otherplayerid][pPlayerName]);

  format(stringstats, 800,""COL_WHITE"Account ID: "COL_BLUE"%d\n"COL_WHITE"Kills: "COL_BLUE"%d\n"COL_WHITE"Deaths: "COL_BLUE"%d\n\
  "COL_WHITE"Score: "COL_BLUE"%d\n"COL_WHITE"Cash: "COL_BLUE"%s\n"COL_WHITE"Admin Level: "COL_BLUE"%d",
  PlayerInfo[otherplayerid][pID],PlayerInfo[otherplayerid][pKills],PlayerInfo[otherplayerid][pDeaths],PlayerInfo[otherplayerid][pScore],
  GetCurrency(PlayerInfo[otherplayerid][pCash]),PlayerInfo[otherplayerid][pAdmin]);

  ShowPlayerDialog(playerid, 1227, DIALOG_STYLE_MSGBOX, headline, stringstats, "OK", "");
  return true;
}

GetCurrency(cCash)
{
    new szStr[16];
    format(szStr, sizeof(szStr), "%i", cCash);

    for(new iLen = strlen(szStr) - 3; iLen > 0; iLen -= 3)
    {
        strins(szStr, ",", iLen);
    }
    return szStr;
}

CMD:acmds(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    SendClientMessage(playerid, 0x0077BB00 , "{00FF00}(Level 1 |  Helper) ");
    SendClientMessage(playerid, 0x0077BB00 , "��{FFFF00}/slap, /report, /warn, /(un)jail , /(un)freeze, /achat (@) /freeze, /agoto,  /mute, /unmute, /ip, /spec, /god, /specoff ��");
    SendClientMessage(playerid, 0x0077BB00 , "{00FF00}(Level 2 | Server Administrator) ");
    SendClientMessage(playerid, 0x0077BB00 , "��{FFFF00}/kick, /vcolor, /giveall,  /get, /repair, /aduty, /healme, /ban, /unban, /announce, /aexplode, /asetskin, /asetweather, /aclearchat ��");
    SendClientMessage(playerid, 0x0077BB00 , "{00FF00}(Level 3 | Server Owner) ");
    SendClientMessage(playerid, 0x0077BB00 , "��{FFFF00}/setadminlevel, /gmx ��");
    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    return 1;
}

CMD:aduty(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");

	if(PlayerInfo[playerid][pDuty] == 0)
	{
	     PlayerInfo[playerid][pDuty] = 1;
		 format(String, sizeof(String), "%s(%d) is now onduty",PlayerInfo[playerid][pPlayerName], playerid);
    }
	else
	{
	    PlayerInfo[playerid][pDuty] = 0;
        format(String, sizeof(String), "%s(%d) is now offduty",PlayerInfo[playerid][pPlayerName], playerid);
	}
	SendClientMessageToAll(-1, String);
	return 1;
}

CMD:aexplode(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    new amount;
    new Float:boomx, Float:boomy, Float:boomz;
    if(sscanf(params, "i", amount)) return SendClientMessage(playerid,Grey,"{F83934}[Usage]:{8B8B8B} /Aexplode [PlayerID]");
    GetPlayerPos(playerid,boomx, boomy, boomz);
    CreateExplosion(boomx, boomy , boomz, amount, 10);
    return 1;
}



CMD:admins(playerid,params[])
{
    if(IsPlayerConnected(playerid))
    {
        SendClientMessage(playerid, COLOR_RED, " ");
        SendClientMessage(playerid, 0xFF0080C8, "[============Online Staff Members============] ");
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                if(PlayerInfo[i][pAdmin] > 1)
                {
                new admtext[64];
                new sendername[MAX_PLAYER_NAME];

                if(PlayerInfo[i][pAdmin] == 1) { admtext = "{80FF00}Level 1 Trial Moderator"; }
                else if(PlayerInfo[i][pAdmin] == 2) { admtext = "{80FF00}Level 2 Server Administrator"; }
                else if(PlayerInfo[i][pAdmin] == 3) { admtext = "{80FF00}Level 3 Server Owner"; }
                GetPlayerName(i, sendername, sizeof(sendername));
                format(String, 256, "{FF00FF}%s {80FF00}( %s )", sendername, admtext);
                SendClientMessage(playerid, 0xFFFF00C8, String);
                SendClientMessage(playerid, 0xFF0080C8, "[============Online Staff Members============]");
                }
            }
        }
    }
    return 1;
}

CMD:asetskin(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    new name[MAX_PLAYER_NAME], targetname[MAX_PLAYER_NAME], id, skinid;
    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    if(sscanf(params, "ui", id, skinid)) return SendClientMessage(playerid, -1, "{F83934}[Usage]:{8B8B8B}/Asetskin (PlayerID) (SkinID)");
    GetPlayerName(playerid, name, MAX_PLAYER_NAME);
    GetPlayerName(id, targetname, MAX_PLAYER_NAME);
    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, -1, "{F83934}[Error]:{8B8B8B} Player Not Connected!");
    SetPlayerSkin(id, skinid);
    format(String, 128, "{F83934}[System]:{8B8B8B} Staff Member %s(%d) has changed your skin To %i", name, playerid, skinid);
    SendClientMessage(id, 0xFFFF00C8, String);
    format(String, 128, "{F83934}[System]:{8B8B8B} You have successfully set his skin to %i", targetname, id, skinid);
    SendClientMessage(playerid, -1, String);
    return 1;
}

CMD:asetweather(playerid,params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    new sendername[MAX_PLAYER_NAME];
    new weather;
    if(sscanf(params, "d", weather))
    return SendClientMessage(playerid, Grey, "{F83934}[Usage]:{8B8B8B}/Asetweather (WeatherID)");
    if(PlayerInfo[playerid][pAdmin] < 2)    return SendClientMessage(playerid, Grey, "{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    SetWeather(weather);
    SendClientMessage(playerid, Grey, "[LOST:RP] The weather has been changed");
    GetPlayerName(playerid, sendername, sizeof(sendername));
    format(String, 256, "{F83934}[System]:{8B8B8B} Staff Member %s changed the weather to weather ID(%d)", sendername,weather);
    SendClientMessage(playerid, -1, String);
    return 1;
}

CMD:aclearchat(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    ClearChatboxAll(playerid);
    return 1;
}


ClearChatboxAll(playerid)
{
    for(new i = 0; i < 50; i++)
    {
        SendClientMessage(playerid, 0xFFFFFFC8, "");
    }
    return 1;
}

CMD:repair(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not in a vehicle.");
    SetVehicleHealth(GetPlayerVehicleID(playerid), 1000);
    return 1;
}

CMD:healme(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    SetPlayerHealth(playerid, 100);
    return 1;
}

CMD:god(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    SetPlayerHealth(playerid, 99999);
    return 1;
}
new CarColors[][1] =
{
    {1},
    {2},
    {3},
    {4},
    {5},
    {6},
    {7},
    {8},
    {9},
    {10},
    {11},
    {12},
    {13},
    {14},
    {15},
    {16},
    {17},
    {18},
    {19},
    {20},
    {21},
    {22},
    {23},
    {24},
    {25},
    {26},
    {27},
    {28},
    {29},
    {30},
    {31},
    {32},
    {33},
    {34},
    {35},
    {36},
    {37},
    {38},
    {39},
    {40},
    {41},
    {42},
    {43},
    {44},
    {45},
    {46},
    {47},
    {48},
    {49},
    {50},
    {51},
    {52},
    {53},
    {54},
    {55},
    {56},
    {57},
    {58},
    {59},
    {60},
    {61},
    {62},
    {63},
    {64},
    {65},
    {66},
    {67},
    {68},
    {69},
    {70},
    {71},
    {72},
    {73},
    {74},
    {75},
    {76},
    {77},
    {78},
    {79},
    {80},
    {81},
    {82},
    {83},
    {84},
    {85},
    {86},
    {87},
    {88},
    {89},
    {90},
    {91},
    {92},
    {93},
    {94},
    {95},
    {96},
    {97},
    {98},
    {99},
    {100},
    {101},
    {102},
    {103},
    {104},
    {105},
    {106},
    {107},
    {108},
    {109},
    {110},
    {111},
    {112},
    {113},
    {114},
    {115},
    {116},
    {117},
    {118},
    {119},
    {120},
    {121},
    {122},
    {123},
    {124},
    {125},
    {126}

};
CMD:vcolor(playerid, params[])
{
    if(PlayerInfo[playerid][pDuty] == 0) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command while offduty");

    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1,"{F83934}[Error]:{8B8B8B} You're not authorized to use this command.");
    new vehicleid = GetPlayerVehicleID(playerid);
    new colors = random(sizeof(CarColors));
    new colors2 = random(sizeof(CarColors));
    ChangeVehicleColor(vehicleid,CarColors[colors][0],CarColors[colors2][0]);
    return 1;
}


forward GlobalTimer();
public GlobalTimer()
{
	 foreach(new ii : Player)
	 {
		if(Jailed[ii] > 0)
		{
			Jailed[ii]--;
		    if(Jailed[ii] == 0)
		    {
		    	Jailed[ii] = 0;
				ResetPlayerWeapons(ii);
				SetPlayerInterior(ii, 0);
				SetPlayerVirtualWorld(ii, 0);
				SpawnPlayer(ii);
		    	SendClientMessage(ii, COLOR_GREEN, "{F83934}[System]:{8B8B8B} You have been un-jailed by the server. (times up)");
			}
		}
		if(muted[ii] > 0)
		{
	          muted[ii]--;
			  if(muted[ii] == 0)
			  {
	            muted[ii] = 0;
	            format(String,sizeof(String),"{F83934}[System]:{8B8B8B} %s got unmuted (times up)",PlayerInfo[ii][pPlayerName]);
	            SendClientMessageToAll(-1, String);
			  }
		}
	 }
	 return 1;
}

GetPlayerSerial(playerid)
{
	new tmp[64];
    gpci(playerid, tmp, sizeof(tmp));
    return tmp;
}

