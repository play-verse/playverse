/*
														________________________________________
														
														Basic Roleplay :: Red County :: Aprezt
														________________________________________

	Map:
	>> Red County
	Scripter(s):
	>> Aprezt
	Script Version:
	>> U1
	
	Thanks to Kush'is. Y_INI Tutorial :)
*/

/* Server Includes */
#include <a_samp>
#include <foreach>
#include <streamer>
#include <zcmd>
#include <sscanf2>
#include <YSI\y_ini>

/* Server Colors */
#define COLOR_PURPLE    0xC2A2DAAA
#define COLOR_GRAD2  	0xBFC0C2FF
#define COLOR_GRAD1 	0xB4B5B7FF
#define COLOR_GRAD2 	0xBFC0C2FF
#define COLOR_GREY 		0xAFAFAFAA
#define COLOR_GRAD3 	0xCBCCCEFF
#define COLOR_LIGHTBLUE 0x006FDD96
#define COLOR_GRAD4 	0xD8D8D8FF
#define COLOR_FADE 		0xC8C8C8C8
#define COLOR_FADE2 	0xC8C8C8C8
#define COLOR_FADE3 	0xAAAAAAAA
#define COLOR_FADE4 	0x8C8C8C8C
#define COLOR_YELLOW 	0xDABB3E00
#define COLOR_FADE5 	0x6E6E6E6E
#define COLOR_GRAD5 	0xE3E3E3FF
#define COLOR_FADE1 	0xE6E6E6E6
#define COLOR_GRAD6 	0xF0F0F0FF
#define TEAM_HIT_COLOR 	0xFFFFFF00

/* Server Defines */
#define PATH "Accounts/%s.ini"
#define SECONDS(%1) ((%1)*(1000))
#define ALTCOMMAND:%1->%2;           \
COMMAND:%1(playerid, params[])   \
return cmd_%2(playerid, params);
#define function%0(%1) forward%0(%1); public%0(%1)

/* SERVER SIDE CASH */
#define GivePlayerCash(%0,%1) SetPVarInt(%0,"Money",GetPlayerCash(%0)+%1),GivePlayerMoney(%0,%1)
#define ResetPlayerCash(%0) SetPVarInt(%0,"Money",0), ResetPlayerMoney(%0)
#define GetPlayerCash(%0) GetPVarInt(%0,"Money")

/* DIALOGS */
#define DIALOG_REGISTER   1
#define DIALOG_LOGIN      2
#define	DIALOG_AGE        3
#define DIALOG_SEX        4

/* ENUMS */
enum pInfo
{
    pPass,
    pCash,
    pAdmin,
    pSex,
    pAge,
   	Float:pPos_x,
	Float:pPos_y,
	Float:pPos_z,
	pSkin,
	pTeam,
	pAccent
}
new PlayerInfo[MAX_PLAYERS][pInfo];
/* <--------------------------------------------> */

main()
{
    print(" ");
    print(" ");
    print("- Basic Roleplay GameMode Loaded -");
    print(" ");
    print(" Script: Aprezt");
}

new
	noooc = 0,
	Logged[ MAX_PLAYERS ],
	gOoc[ MAX_PLAYERS ]
;

public OnPlayerConnect(playerid)
{
    gOoc[ playerid ] = 0; Logged[ playerid ] = 0;
    // Reset stats!
    PlayerInfo[ playerid ][ pCash ] = 0;
    PlayerInfo[ playerid ][ pAdmin ] = 0;
    PlayerInfo[ playerid ][ pSex ] = 0;
    PlayerInfo[ playerid ][ pAge ] = 0;
    PlayerInfo[ playerid ][ pPos_x ] = 0.0;
    PlayerInfo[ playerid ][ pPos_y ] = 0.0;
    PlayerInfo[ playerid ][ pPos_z ] = 0.0;
    PlayerInfo[ playerid ][ pSkin ] = 0;
    PlayerInfo[ playerid ][ pTeam ] = 0;
    PlayerInfo[ playerid ][ pAccent ] = 0;

    if(fexist(UserPath(playerid)))
    {
        INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,"Eternity Legend","Ketikkan kata sandi Anda di bawah ini untuk masuk:","Masuk","Keluar");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,"Eternity Legend","Ketikkan kata sandi Anda di bawah ini untuk mendaftarkan akun baru:","Daftar","Keluar");
    }
    return 1;
}

public OnGameModeInit()
{
	/* <-------------------------------------------> */
	AddPlayerClass(21,-2382.0168,-582.0441,132.1172,125.2504,0,0,0,0,0,0);
	AddPlayerClass(59,-2382.0168,-582.0441,132.1172,125.2504,0,0,0,0,0,0);
	/* <-------------------------------------------> */
	ShowPlayerMarkers(0);
	ShowNameTags(1);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	SetNameTagDrawDistance(10.0);
	// =========== TIMERS ===========
	SetTimer("MoneyUpdate",1000,1);
	SetTimer("SaveAccounts", SECONDS(13), 1);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
   	if(dialogid == DIALOG_AGE)
	{
	    if(!response)
       	{
         	Kick(playerid);
       	}
       	else
       	{
		    if(strlen(inputtext))
		    {
		        new age = strval(inputtext);
		        if(age > 100 || age < 16)
				{
                    ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "- Umur -","Berapakah umur Anda??\n{FF0000}(( 16 - 100 ))","Jawab","Keluar");
				}
				else
				{
					PlayerInfo[playerid][pAge] = age;
					new
						string[ 64 ]
					;
					format(string, sizeof(string), "INFO: Kamu {3BB9FF}%d tahun",age);
					SendClientMessage(playerid, -1, string);
     				GivePlayerCash(playerid, 600);
					SaveAccountStats(playerid);
					SpawnPlayer(playerid);
				}
			}
			else
			{
			    return 0;
			}
		}
	}
	if(dialogid == DIALOG_SEX)
	{
        if(response)
		{
  			PlayerInfo[playerid][pSex] = 1;
			SendClientMessage(playerid, -1, "INFO: Kamu {3BB9FF}pria.");
			SetPlayerSkin(playerid, 60);
			PlayerInfo[playerid][pSkin] = 60;
			ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "- Umur -","Berapakah umur Anda??\n{FF0000}(( 16 - 100 ))","Jawab","Keluar");
		}
		else
		{
			PlayerInfo[playerid][pSex] = 2;
			SendClientMessage(playerid, -1, "INFO: Kamu {3BB9FF}perempuan.");
			SetPlayerSkin(playerid, 233);
			PlayerInfo[playerid][pSkin] = 233;
			ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "- Age -","Berapakah umur Anda??\n{FF0000}(( 16 - 100 ))","Jawab","Keluar");
		}
	}
    switch( dialogid )
    {
        case DIALOG_REGISTER:
        {
            if (!response) return Kick(playerid);
            if(response)
            {
                if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Mendaftar...","Anda telah memasukkan kata sandi yang salah.\nKetikkan kata sandi Anda di bawah ini untuk mendaftarkan akun baru.","Daftar","Keluar");
                new INI:File = INI_Open(UserPath(playerid));
                INI_SetTag(File,"data");
                INI_WriteInt(File,"Password",udb_hash(inputtext));
                INI_WriteInt(File,"Cash",0);
                INI_WriteInt(File,"Admin",0);
                INI_WriteInt(File,"Sex",0);
                INI_WriteInt(File,"Age",0);
                INI_WriteFloat(File,"Pos_x",0);
    			INI_WriteFloat(File,"Pos_y",0);
    			INI_WriteFloat(File,"Pos_z",0);
   			 	INI_WriteInt(File,"Skin",0);
   			 	INI_WriteInt(File,"Team",0);
   			 	INI_WriteInt(File,"Accent",0);
                INI_Close(File);
                
                ShowPlayerDialog(playerid, DIALOG_SEX, DIALOG_STYLE_MSGBOX, "- Sex -","Silahkan pilih jenis kelamin","Pria","Perempuan");
            }
        }
        case DIALOG_LOGIN:
        {
            if ( !response ) return Kick ( playerid );
            if( response )
            {
                if(udb_hash(inputtext) == PlayerInfo[playerid][pPass])
                {
                    INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
                    new
                        tmp2[ 256 ],
                        playername2[ MAX_PLAYER_NAME ]
					;
	    			GetPlayerName(playerid, playername2, sizeof(playername2));
   					format(tmp2, sizeof(tmp2), "~w~Selamat datang ~n~~g~%s", playername2);
					GameTextForPlayer(playerid, tmp2, 5000, 1);
					SetTimerEx("UnsetFirstSpawn", 5000, false, "i", playerid);
                    GivePlayerCash(playerid, PlayerInfo[playerid][pCash]);
   					SetSpawnInfo(playerid, PlayerInfo[playerid][pTeam], PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z], 1.0, -1, -1, -1, -1, -1, -1);
				}
                else
                {
                    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,"Login","Anda memasukkan kata sandi yang salah.\nKetikkan kata sandi Anda di bawah ini untuk masuk.","Masuk","Keluar");
                }
                return 1;
            }
        }
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{
   	if(IsPlayerConnected(playerid))
	{
    	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    	SetPlayerToTeamColor(playerid);
    	Logged[playerid] = 1;
	}
	if(PlayerInfo[playerid][pPos_x] == 0 && PlayerInfo[playerid][pPos_y] == 0)
    {
        SetPlayerPos(playerid, 1271.3654,181.0756,19.4705);
        Logged[playerid] = 1;
    }
    else
	{
		SetPlayerPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z]);
		Logged[playerid] = 1;
 	}
    return 1;
}

public OnPlayerText(playerid, text[])
{
	new
		realchat = 1,
		string[ 128 ]
	;
	if(IsPlayerConnected(playerid))
	{
		if(realchat)
		{
			if(PlayerInfo[playerid][pAccent] == 0)
			{
				format(string, sizeof(string), "%s says: %s", RPName(playerid), text);
				ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
			}
			else
			{
				new
					accent[20]
				;
				switch(PlayerInfo[playerid][pAccent])
				{
					case 1: accent = "Russian";
					case 2: accent = "Italian";
					case 3: accent = "Germany";
					case 4: accent = "Japanese";
					case 5: accent = "French";
					case 6: accent = "Spain";
					case 7: accent = "China";
					case 8: accent = "British";
				}
				format(string, sizeof(string), "%s says: [%s Accent] %s", RPName(playerid), accent, text);
				ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
			}
			return 0;
		}
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SaveAccountStats(playerid);
    return 1;
}

function SetPlayerToTeamColor(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    SetPlayerColor(playerid,TEAM_HIT_COLOR);
	}
}

function OOCOff(color,const string[])
{
	foreach (Player,i)
	{
		if(!gOoc{i})
		{
			SendClientMessage(i, color, string);
		}
	}
}

function SaveAccountStats(playerid)
{
	if(Logged[playerid] == 1)
	{
	new
		INI:File = INI_Open(UserPath(playerid))
	;
    INI_SetTag(File,"data");
    
   	PlayerInfo[playerid][pSkin] = GetPlayerSkin(playerid);
    PlayerInfo[playerid][pCash] = GetPlayerCash(playerid);
   	new
	   	Float:x,
	    Float:y,
		Float:z
	;
	GetPlayerPos(playerid,x,y,z);
	PlayerInfo[playerid][pPos_x] = x;
	PlayerInfo[playerid][pPos_y] = y;
	PlayerInfo[playerid][pPos_z] = z;
	
    INI_WriteInt(File,"Cash",PlayerInfo[playerid][pCash]);
    INI_WriteInt(File,"Admin",PlayerInfo[playerid][pAdmin]);
    INI_WriteInt(File,"Sex",PlayerInfo[playerid][pSex]);
    INI_WriteInt(File,"Age",PlayerInfo[playerid][pAge]);
    INI_WriteFloat(File,"Pos_x",PlayerInfo[playerid][pPos_x]);
    INI_WriteFloat(File,"Pos_y",PlayerInfo[playerid][pPos_y]);
    INI_WriteFloat(File,"Pos_z",PlayerInfo[playerid][pPos_z]);
    INI_WriteInt(File,"Skin",PlayerInfo[playerid][pSkin]);
    INI_WriteInt(File,"Team",PlayerInfo[playerid][pTeam]);
    INI_WriteInt(File,"Accent",PlayerInfo[playerid][pAccent]);
    
    INI_Close(File);
    }
    return 1;
}

function SaveAccounts()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			SaveAccountStats(i);
  		}
	}
}

function GameModeExitFunc()
{
 	GameModeExit();
	return 1;
}

function LoadUser_data(playerid,name[],value[])
{
    INI_Int("Password",PlayerInfo[playerid][pPass]);
    INI_Int("Cash",PlayerInfo[playerid][pCash]);
    INI_Int("Admin",PlayerInfo[playerid][pAdmin]);
    INI_Int("Sex",PlayerInfo[playerid][pSex]);
    INI_Int("Age",PlayerInfo[playerid][pAge]);
    INI_Float("Pos_x",PlayerInfo[playerid][pPos_x]);
    INI_Float("Pos_y",PlayerInfo[playerid][pPos_y]);
    INI_Float("Pos_z",PlayerInfo[playerid][pPos_z]);
    INI_Int("Skin",PlayerInfo[playerid][pSkin]);
    INI_Int("Team",PlayerInfo[playerid][pTeam]);
    INI_Int("Accent",PlayerInfo[playerid][pAccent]);
    return 1;
}

function MoneyUpdate(playerid)
{
	if(GetPlayerCash(playerid) < GetPlayerMoney(playerid))
	{
		foreach(Player, i)
		{
  			new const old_money = GetPlayerCash(playerid);
    		ResetPlayerCash(playerid), GivePlayerCash(playerid, old_money);
   		}
	}
 	return 1;
}

function ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new BigEar[MAX_PLAYERS];
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i) && (GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)))
			{
				if(!BigEar[i])
				{
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
					{
						SendClientMessage(i, col1, string);
					}
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
					{
						SendClientMessage(i, col2, string);
					}
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
					{
						SendClientMessage(i, col3, string);
					}
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
					{
						SendClientMessage(i, col4, string);
					}
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
					{
						SendClientMessage(i, col5, string);
					}
				}
				else
				{
					SendClientMessage(i, col1, string);
				}
			}
		}
	}
	return 1;
}

// ============ STOCKS ============
stock SendAdminMessage( color, string[] )
{
    foreach (Player,i)
    {
		if( PlayerInfo[ i] [ pAdmin ] > 1 )
		{
		    SendClientMessage( i, color, string );
		}
    }
}

stock UserPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),PATH,playername);
    return string;
}

/* Credits to Dracoblue */
stock udb_hash(buf[]) {
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

stock RPName(playerid)
{
    new string[24];
    GetPlayerName(playerid,string,24);
    new str[24];
    strmid(str,string,0,strlen(string),24);
    for(new i = 0; i < MAX_PLAYER_NAME; i++)
    {
        if (str[i] == '_') str[i] = ' ';
    }
    return str;
}
// =================================

/* LOGS */

function OOCLog(string[])
{
	new
		entry[ 128 ],
		year,
		month,
		day,
		hour,
		minute,
		second
	;
	getdate(year, month, day);
	gettime(hour, minute, second);

	format(entry, sizeof(entry), "%s | (%d-%d-%d) (%d:%d:%d)\n",string, day, month, year, hour, minute, second);
	new File:hFile;
	hFile = fopen("Basic/logs/OOCLog.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}

/* COMMANDS */

CMD:stats(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		new
			string[ 128 ],
			Age = PlayerInfo[ playerid ][ pAge ],
			Money = GetPlayerCash( playerid )
		;

		new Sex[20];
		if(PlayerInfo[ playerid ][ pSex ] == 1) { Sex = "Pria"; }
		else if(PlayerInfo[ playerid ][ pSex ] == 2) { Sex = "Perempuan"; }

		SendClientMessage(playerid, COLOR_LIGHTBLUE, "------------------------------------------------------------------------");
		format(string, sizeof(string), "Name: %s | Money: %d | Age: %d | Sex: %s", RPName(playerid), Money, Age, Sex);
		SendClientMessage(playerid, COLOR_GRAD2, string);
	}
	return 1;
}

CMD:ahelp(playerid, params[])
{
 	if(PlayerInfo[playerid][pAdmin] == 0) return SendClientMessage(playerid, -1,"You are not admin!");
 	SendClientMessage(playerid, -1, "____________________________________________________________________");
	if(PlayerInfo[playerid][pAdmin] >= 1)
	{
        SendClientMessage(playerid, COLOR_FADE, "Level 1: No commands yet!");
    }
   	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
        SendClientMessage(playerid, COLOR_FADE, "Level 2: No commands yet!");
    }
   	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
        SendClientMessage(playerid, COLOR_FADE, "Level 3: No commands yet!");
    }
   	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
        SendClientMessage(playerid, COLOR_FADE, "Level 4: No commands yet!");
    }
   	if(PlayerInfo[playerid][pAdmin] >= 5)
	{
        SendClientMessage(playerid, COLOR_FADE, "Level 5: No commands yet!");
    }
   	if(PlayerInfo[playerid][pAdmin] >= 6)
	{
        SendClientMessage(playerid, COLOR_FADE, "Level 6: No commands yet!");
    }
   	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
        SendClientMessage(playerid, COLOR_FADE, "Level 1337: /givemoney -");
    }
 	SendClientMessage(playerid, -1, "____________________________________________________________________");
 	return 1;
}

CMD:help(playerid, params[])
{
    SendClientMessage(playerid, COLOR_LIGHTBLUE,"------------------------------------------------------------");
    SendClientMessage(playerid, COLOR_GRAD2,"/do - /me - /accent - /ooc - /b");
    SendClientMessage(playerid, COLOR_LIGHTBLUE,"------------------------------------------------------------");
    return 1;
}

ALTCOMMAND:o->ooc;
CMD:ooc(playerid, params[])
{
	new
		string[ 186 ]
	;
	if((noooc) && PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_GRAD2, "OOC Chat closed by administrator!");
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAD2, "USAGE: {FFFFFF}(/o)oc [ooc chat]");

	format(string, sizeof(string), "(( OOC: %s: %s ))", RPName(playerid), params);
	OOCOff(0xCCFFFF00, string);
	OOCLog(string);
	printf("%s", string);
	return 1;
}

CMD:b(playerid, params[])
{
	new
		string[ 128 ]
	;
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAD2, "USAGE: {FFFFFF} /b [ooc chat]");
	format(string, sizeof(string), "(( OOC: %s[%i]: %s ))", RPName( playerid ), playerid, params);
	printf("%s", string);
	ProxDetector(30.0, playerid, string, COLOR_FADE,COLOR_FADE,COLOR_FADE,COLOR_FADE,COLOR_FADE);
	return 1;
}

CMD:do(playerid, params[])
{
	new
		result[ 128 ],
		string[ 128 ]
 	;
	if(sscanf(params, "s[128]", result)) return SendClientMessage(playerid, COLOR_GRAD2, "USAGE: {FFFFFF}/do [action]");
	format(string, sizeof(string), "* %s (( %s ))", result, RPName(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	printf("%s", string);
	return 1;
}

CMD:me(playerid, params[])
{
	new
		result[ 128 ],
		string[ 128 ]
 	;
	if(sscanf(params, "s[128]", result)) return SendClientMessage(playerid, COLOR_GRAD2, "USAGE: {FFFFFF}/do [action]");
	format(string, sizeof(string), "* %s %s", RPName(playerid), result);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	printf("%s", string);
	return 1;
}

CMD:accent(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GRAD1, "USAGE: {FFFFFF}/accent [russian | italian | germany | japanese | french | spain | china | british | none]");
	if(!strcmp(params,"russian",true))
	{
		PlayerInfo[playerid][pAccent] = 1;
		SendClientMessage(playerid, COLOR_GRAD1, "Your accent is now Russian!");
	}
	else if(!strcmp(params,"italian",true))
	{
		PlayerInfo[playerid][pAccent] = 2;
		SendClientMessage(playerid, COLOR_GRAD1, "Your accent is now Italian!");
	}
	else if(!strcmp(params,"germany",true))
	{
		PlayerInfo[playerid][pAccent] = 3;
		SendClientMessage(playerid, COLOR_GRAD1, "Your accent is now Germany!");
	}
	else if(!strcmp(params,"japanese",true))
	{
		PlayerInfo[playerid][pAccent] = 4;
		SendClientMessage(playerid, COLOR_GRAD1, "Your accent is now Japanese!");
	}
	else if(!strcmp(params,"french",true))
	{
		PlayerInfo[playerid][pAccent] = 5;
		SendClientMessage(playerid, COLOR_GRAD1, "Your accent is now French!");
	}
	else if(!strcmp(params,"spain",true))
	{
		PlayerInfo[playerid][pAccent] = 6;
		SendClientMessage(playerid, COLOR_GRAD1, "Your accent is now Spain!");
	}
	else if(!strcmp(params,"china",true))
	{
		PlayerInfo[playerid][pAccent] = 7;
		SendClientMessage(playerid, COLOR_GRAD1, "Your accent is now China!");
	}
	else if(!strcmp(params,"british", true))
	{
		PlayerInfo[playerid][pAccent] = 8;
		SendClientMessage(playerid, COLOR_GRAD1, "Your accent is now British!");
	}
	else if(!strcmp(params,"none",true))
	{
		PlayerInfo[playerid][pAccent] = 0;
		SendClientMessage(playerid, COLOR_GRAD1, "You removed the accent!");
	}
	else return SendClientMessage(playerid, COLOR_GREY, "Invalid name accent!");
	return 1;
}

CMD:givemoney(playerid, params[])
{
	new targetid,type,string[128];
	if(sscanf(params, "ui", targetid, type)) return SendClientMessage(playerid, COLOR_GRAD2, "USAGE: {FFFFFF}/givemoney [playerid] [amount]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "* This player is not in server..");
	if(type < 0 || type > 99999999) return SendClientMessage(playerid, COLOR_GREY, "* Cannot go under 0 or above 99999999.");
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_GRAD1, "You are not ADMIN!");

	GivePlayerCash(targetid, type);
	format(string, sizeof(string),"AdmCmd: %s give player %s %d SAK", RPName( playerid ), RPName( targetid ), type);
	SendAdminMessage(COLOR_YELLOW,string);
	return 1;
}
