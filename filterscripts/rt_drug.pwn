#define 	FILTERSCRIPT
#include 	<a_samp>
#include    <izcmd>             // by Yashas - http://forum.sa-mp.com/showthread.php?t=576114
#include    <sqlitei>           // by Slice - http://forum.sa-mp.com/showthread.php?t=303682
#include    <sscanf2>           // by Y_Less - http://forum.sa-mp.com/showthread.php?t=602923
#include    <streamer>          // by Incognito - http://forum.sa-mp.com/showthread.php?t=102865
#include    <YSI\y_iterate>     // by Y_Less - http://forum.sa-mp.com/showthread.php?t=570884

#define     MAX_PLANTS      	(250)   // limit of drug plants
#define     MAX_DEALERS         (15)    // limit of drug dealers

#define     USE_DRUNKLEVEL              // remove this line if you don't want SetPlayerDrunkLevel to be used while on drugs
#define     PLAYER_LIMIT    	(5)     // a player can plant up to x drug plants (Default: 5)
#define     PLANT_MAX_GROWTH	(75)    // a plant will grow up to x grams of drugs (Default: 75)
#define     GROWTH_INTERVAL 	(45)    // a plant will grow up every x seconds (Default: 45)
#define     ROT_INTERVAL        (300)   // a plant will rot after x seconds of fully growing (Default: 300)
#define     CARRY_LIMIT         (150)   // a player can carry up to x grams of drugs (Default: 150)
#define     SEED_LIMIT         	(25)   	// a player can carry up to x drug plant seeds (Default: 25)
#define     SEED_PRICE      	(50)    // price players will pay for a drug plant seed (Default: 50)
#define     DRUG_BUY_PRICE      (20)    // price players will pay a dealer for a gram of drugs (Default: 20)
#define     DRUG_SELL_PRICE     (16)    // price dealers will pay a player for a gram of drugs (Default: 16)
#define     OFFER_COOLDOWN      (30)    // how many seconds does a player wait to send an another offer to someone (Default: 30)

enum    _:E_DIALOG
{
	DIALOG_DRUG_STATS = 8620,
	DIALOG_CONFIRM_RESET,
	DIALOG_DRUG_DEALER,
	DIALOG_DRUG_DEALER_BUY_SEEDS,
	DIALOG_DRUG_DEALER_BUY_DRUGS,
	DIALOG_DRUG_DEALER_SELL,
	DIALOG_DRUG_OFFER
}

enum    E_PLANT
{
	plantedBy[MAX_PLAYER_NAME],
	Float: plantX,
	Float: plantY,
	Float: plantZ,
	plantGrowth,
	plantObj,
	plantTimer,
	Text3D: plantLabel,
	bool: gotLeaves
}

enum    E_PLAYER
{
	// saved
	Drugs,
	Seeds,
	TotalUsed,
	TotalPlanted,
	TotalHarvestedPlants,
	TotalHarvestedGrams,
	TotalGiven,
	TotalReceived,
	TotalBought,
	TotalBoughtPrice,
	TotalSold,
	TotalSoldPrice,
	// temp
	DrugsCooldown,
	DealerID,
	DrugsOfferedBy,
	DrugsOfferedPrice,
	DrugsOfferCooldown
}

enum    E_DEALER
{
	// loaded from db
	dealerSkin,
	dealerDrugs,
	Float: dealerX,
	Float: dealerY,
	Float: dealerZ,
	Float: dealerA,
	// temp
	dealerActorID,
	Text3D: dealerLabel
}

new
	PlantData[MAX_PLANTS][E_PLANT],
	Iterator: Plants<MAX_PLANTS>;
	
new
	PlayerDrugData[MAX_PLAYERS][E_PLAYER],
	RegenTimer[MAX_PLAYERS] = {-1, ...},
	EffectTimer[MAX_PLAYERS] = {-1, ...};
	
new
	DealerData[MAX_DEALERS][E_DEALER],
	Iterator: Dealers<MAX_DEALERS>;
	
new
	DB: DrugDB;
	
new
	DBStatement: LoadPlayer,
	DBStatement: InsertPlayer,
	DBStatement: SavePlayer;
	
new
	DBStatement: LoadDealers,
	DBStatement: AddDealer,
	DBStatement: UpdateDealer,
	DBStatement: UpdateDealerDrugs,
	DBStatement: RemoveDealer;

RandomEx(min, max) //Y_Less
    return random(max - min) + min;

formatInt(intVariable, iThousandSeparator = ',', iCurrencyChar = '$')
{
    /*
		By Kar
		https://gist.github.com/Kar2k/bfb0eafb2caf71a1237b349684e091b9/8849dad7baa863afb1048f40badd103567c005a5#file-formatint-function
	*/
	static
		s_szReturn[ 32 ],
		s_szThousandSeparator[ 2 ] = { ' ', EOS },
		s_szCurrencyChar[ 2 ] = { ' ', EOS },
		s_iVariableLen,
		s_iChar,
		s_iSepPos,
		bool:s_isNegative
	;

	format( s_szReturn, sizeof( s_szReturn ), "%d", intVariable );

	if(s_szReturn[0] == '-')
		s_isNegative = true;
	else
		s_isNegative = false;

	s_iVariableLen = strlen( s_szReturn );

	if ( s_iVariableLen >= 4 && iThousandSeparator)
	{
		s_szThousandSeparator[ 0 ] = iThousandSeparator;

		s_iChar = s_iVariableLen;
		s_iSepPos = 0;

		while ( --s_iChar > _:s_isNegative )
		{
			if ( ++s_iSepPos == 3 )
			{
				strins( s_szReturn, s_szThousandSeparator, s_iChar );

				s_iSepPos = 0;
			}
		}
	}
	if(iCurrencyChar) {
		s_szCurrencyChar[ 0 ] = iCurrencyChar;
		strins( s_szReturn, s_szCurrencyChar, _:s_isNegative );
	}
	return s_szReturn;
}

Float: DistanceBetweenPlayers(player1, player2)
{
	new Float: x, Float: y, Float: z;
	GetPlayerPos(player2, x, y, z);
	return GetPlayerDistanceFromPoint(player1, x, y, z);
}

GetClosestPlant(playerid, Float: range = 1.5)
{
	new id = -1, Float: dist = range, Float: tempdist;
	foreach(new i : Plants)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, PlantData[i][plantX], PlantData[i][plantY], PlantData[i][plantZ]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}

	return id;
}

GetClosestDealer(playerid, Float: range = 2.0)
{
	new id = -1, Float: dist = range, Float: tempdist;
	foreach(new i : Dealers)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, DealerData[i][dealerX], DealerData[i][dealerY], DealerData[i][dealerZ]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}

	return id;
}

ShowDrugStats(playerid)
{
	new dialog[350];
	format(
		dialog,
		sizeof(dialog),
		"Drugs\t%s grams\n\
		Seeds\t%s\n\
		Used Drugs\t%s grams\n\
		Planted Drugs\t%s\n\
		Harvested Plants\t%s (%s grams)\n\
		Drugs Given\t%s grams\n\
		Drugs Received\t%s grams\n\
		Drugs Bought\t%s grams {2ECC71}(%s)\n\
		Drugs Sold\t%s grams {2ECC71}(%s)\n\
		{FF0000}Reset Stats",
		formatInt(PlayerDrugData[playerid][Drugs], .iCurrencyChar = '\0'),
		formatInt(PlayerDrugData[playerid][Seeds], .iCurrencyChar = '\0'),
		formatInt(PlayerDrugData[playerid][TotalUsed], .iCurrencyChar = '\0'),
		formatInt(PlayerDrugData[playerid][TotalPlanted], .iCurrencyChar = '\0'),
		formatInt(PlayerDrugData[playerid][TotalHarvestedPlants], .iCurrencyChar = '\0'), formatInt(PlayerDrugData[playerid][TotalHarvestedGrams], .iCurrencyChar = '\0'),
		formatInt(PlayerDrugData[playerid][TotalGiven], .iCurrencyChar = '\0'),
		formatInt(PlayerDrugData[playerid][TotalReceived], .iCurrencyChar = '\0'),
		formatInt(PlayerDrugData[playerid][TotalBought], .iCurrencyChar = '\0'), formatInt(PlayerDrugData[playerid][TotalBoughtPrice]),
		formatInt(PlayerDrugData[playerid][TotalSold], .iCurrencyChar = '\0'), formatInt(PlayerDrugData[playerid][TotalSoldPrice])
	);
	
	ShowPlayerDialog(playerid, DIALOG_DRUG_STATS, DIALOG_STYLE_TABLIST, "Drug Stats", dialog, "Choose", "Close");
	return 1;
}

ShowDealerMenu(playerid)
{
	new dialog[300], id = PlayerDrugData[playerid][DealerID];
	format(
		dialog,
		sizeof(dialog),
		"Option\tPrice\tYou Have\n\
		{%06x}Buy Drug Plant Seed\t{2ECC71}%s\t%s\n\
		{%06x}Buy Drugs (%s grams on dealer)\t{2ECC71}%s x gram\t%s grams\n\
		{%06x}Sell Drugs\t{2ECC71}%s x gram\t%s grams",
		(PlayerDrugData[playerid][Seeds] < SEED_LIMIT) ? 0xFFFFFFFF >>> 8 : 0xE74C3CFF >>> 8, formatInt(SEED_PRICE), formatInt(PlayerDrugData[playerid][Seeds], .iCurrencyChar = '\0'),
		(PlayerDrugData[playerid][Drugs] >= CARRY_LIMIT || DealerData[id][dealerDrugs] < 1) ? 0xE74C3CFF >>> 8 : 0xFFFFFFFF >>> 8, formatInt(DealerData[id][dealerDrugs], .iCurrencyChar = '\0'), formatInt(DRUG_BUY_PRICE), formatInt(PlayerDrugData[playerid][Drugs], .iCurrencyChar = '\0'),
		(PlayerDrugData[playerid][Drugs] > 0) ? 0xFFFFFFFF >>> 8 : 0xE74C3CFF >>> 8, formatInt(DRUG_SELL_PRICE), formatInt(PlayerDrugData[playerid][Drugs], .iCurrencyChar = '\0')
	);
	
	ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER, DIALOG_STYLE_TABLIST_HEADERS, "Drug Dealer", dialog, "Choose", "Close");
	return 1;
}

Player_GetName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	return name;
}

Player_PlantCount(playerid)
{
	new count = 0, name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	foreach(new i : Plants) if(!strcmp(PlantData[i][plantedBy], name, true)) count++;
	return count;
}

Player_Init(playerid)
{
	new emptydata[E_PLAYER];
	PlayerDrugData[playerid] = emptydata;
	PlayerDrugData[playerid][DrugsOfferedBy] = INVALID_PLAYER_ID;
	RegenTimer[playerid] = EffectTimer[playerid] = -1;
	
	// load player
	new drugs, seeds, totalused, totalplanted, harvested[2], given, received, bought[2], sold[2];
	stmt_bind_value(LoadPlayer, 0, DB::TYPE_STRING, Player_GetName(playerid));
	stmt_bind_result_field(LoadPlayer, 0, DB::TYPE_INTEGER, drugs);
	stmt_bind_result_field(LoadPlayer, 1, DB::TYPE_INTEGER, seeds);
	stmt_bind_result_field(LoadPlayer, 2, DB::TYPE_INTEGER, totalused);
	stmt_bind_result_field(LoadPlayer, 3, DB::TYPE_INTEGER, totalplanted);
	stmt_bind_result_field(LoadPlayer, 4, DB::TYPE_INTEGER, harvested[0]);
    stmt_bind_result_field(LoadPlayer, 5, DB::TYPE_INTEGER, harvested[1]);
    stmt_bind_result_field(LoadPlayer, 6, DB::TYPE_INTEGER, given);
    stmt_bind_result_field(LoadPlayer, 7, DB::TYPE_INTEGER, received);
    stmt_bind_result_field(LoadPlayer, 8, DB::TYPE_INTEGER, bought[0]);
    stmt_bind_result_field(LoadPlayer, 9, DB::TYPE_INTEGER, bought[1]);
    stmt_bind_result_field(LoadPlayer, 10, DB::TYPE_INTEGER, sold[0]);
    stmt_bind_result_field(LoadPlayer, 11, DB::TYPE_INTEGER, sold[1]);
    
	if(stmt_execute(LoadPlayer))
	{
	    if(stmt_rows_left(LoadPlayer) > 0) {
	        stmt_fetch_row(LoadPlayer);

	        PlayerDrugData[playerid][Drugs] = drugs;
	        PlayerDrugData[playerid][Seeds] = seeds;
	        PlayerDrugData[playerid][TotalUsed] = totalused;
	        PlayerDrugData[playerid][TotalPlanted] = totalplanted;
	        PlayerDrugData[playerid][TotalHarvestedPlants] = harvested[0];
	        PlayerDrugData[playerid][TotalHarvestedGrams] = harvested[1];
	        PlayerDrugData[playerid][TotalGiven] = given;
	        PlayerDrugData[playerid][TotalReceived] = received;
	        PlayerDrugData[playerid][TotalBought] = bought[0];
	        PlayerDrugData[playerid][TotalBoughtPrice] = bought[1];
	        PlayerDrugData[playerid][TotalSold] = sold[0];
	        PlayerDrugData[playerid][TotalSoldPrice] = sold[1];
	    }else{
	        stmt_bind_value(InsertPlayer, 0, DB::TYPE_STRING, Player_GetName(playerid));
	        stmt_execute(InsertPlayer);
	    }
	}
	
	return 1;
}

Player_SaveDrugs(playerid)
{
    stmt_bind_value(SavePlayer, 0, DB::TYPE_INTEGER, PlayerDrugData[playerid][Drugs]);
	stmt_bind_value(SavePlayer, 1, DB::TYPE_INTEGER, PlayerDrugData[playerid][Seeds]);
	stmt_bind_value(SavePlayer, 2, DB::TYPE_INTEGER, PlayerDrugData[playerid][TotalUsed]);
	stmt_bind_value(SavePlayer, 3, DB::TYPE_INTEGER, PlayerDrugData[playerid][TotalPlanted]);
	stmt_bind_value(SavePlayer, 4, DB::TYPE_INTEGER, PlayerDrugData[playerid][TotalHarvestedPlants]);
	stmt_bind_value(SavePlayer, 5, DB::TYPE_INTEGER, PlayerDrugData[playerid][TotalHarvestedGrams]);
	stmt_bind_value(SavePlayer, 6, DB::TYPE_INTEGER, PlayerDrugData[playerid][TotalGiven]);
	stmt_bind_value(SavePlayer, 7, DB::TYPE_INTEGER, PlayerDrugData[playerid][TotalReceived]);
	stmt_bind_value(SavePlayer, 8, DB::TYPE_INTEGER, PlayerDrugData[playerid][TotalBought]);
	stmt_bind_value(SavePlayer, 9, DB::TYPE_INTEGER, PlayerDrugData[playerid][TotalBoughtPrice]);
	stmt_bind_value(SavePlayer, 10, DB::TYPE_INTEGER, PlayerDrugData[playerid][TotalSold]);
	stmt_bind_value(SavePlayer, 11, DB::TYPE_INTEGER, PlayerDrugData[playerid][TotalSoldPrice]);
	stmt_bind_value(SavePlayer, 12, DB::TYPE_STRING, Player_GetName(playerid));
	return stmt_execute(SavePlayer);
}

Plant_GrowthPercentage(id)
{
	if(!Iter_Contains(Plants, id)) return 0;
	return (PlantData[id][plantGrowth] * 100) / PLANT_MAX_GROWTH;
}

Plant_GetOwnerID(id)
{
    if(!Iter_Contains(Plants, id)) return INVALID_PLAYER_ID;
	foreach(new i : Player) if(!strcmp(PlantData[id][plantedBy], Player_GetName(i), true)) return i;
	return INVALID_PLAYER_ID;
}

Plant_Destroy(id)
{
	if(!Iter_Contains(Plants, id)) return 0;
	KillTimer(PlantData[id][plantTimer]);
	DestroyDynamicObject(PlantData[id][plantObj]);
	DestroyDynamic3DTextLabel(PlantData[id][plantLabel]);
	
	PlantData[id][plantObj] = PlantData[id][plantTimer] = -1;
	PlantData[id][plantLabel] = Text3D: -1;
	PlantData[id][gotLeaves] = false;

	Iter_Remove(Plants, id);
	return 1;
}

public OnFilterScriptInit()
{
	for(new i; i < MAX_PLANTS; i++)
	{
		PlantData[i][plantObj] = PlantData[i][plantTimer] = -1;
		PlantData[i][plantLabel] = Text3D: -1;
	}
	
	for(new i; i < MAX_DEALERS; i++)
	{
	    DealerData[i][dealerActorID] = -1;
	    DealerData[i][dealerLabel] = Text3D: -1;
	}
	
	// database
	DrugDB = db_open("drugs.db");
	db_query(DrugDB, "CREATE TABLE IF NOT EXISTS playerdrugs (Name TEXT, Drugs INTEGER, Seeds INTEGER, TotalUsed INTEGER, TotalPlanted INTEGER, TotalHarvestedPlants INTEGER, TotalHarvestedGrams INTEGER, TotalGiven INTEGER, TotalReceived INTEGER, TotalBought INTEGER, TotalBoughtPrice INTEGER, TotalSold INTEGER, TotalSoldPrice INTEGER)");
	db_query(DrugDB, "CREATE TABLE IF NOT EXISTS dealers (ID INTEGER, Skin INTEGER, Drugs INTEGER, PosX FLOAT, PosY FLOAT, PosZ FLOAT, PosA FLOAT)");
	
	// prepare player queries
	LoadPlayer = db_prepare(DrugDB, "SELECT Drugs, Seeds, TotalUsed, TotalPlanted, TotalHarvestedPlants, TotalHarvestedGrams, TotalGiven, TotalReceived, TotalBought, TotalBoughtPrice, TotalSold, TotalSoldPrice FROM playerdrugs WHERE Name=?");
	InsertPlayer = db_prepare(DrugDB, "INSERT INTO playerdrugs (Name) VALUES (?)");
	SavePlayer = db_prepare(DrugDB, "UPDATE playerdrugs SET Drugs=?, Seeds=?, TotalUsed=?, TotalPlanted=?, TotalHarvestedPlants=?, TotalHarvestedGrams=?, TotalGiven=?, TotalReceived=?, TotalBought=?, TotalBoughtPrice=?, TotalSold=?, TotalSoldPrice=? WHERE Name=?");
	
	// prepare dealer queries
	LoadDealers = db_prepare(DrugDB, "SELECT * FROM dealers");
	AddDealer = db_prepare(DrugDB, "INSERT INTO dealers (ID, Skin, PosX, PosY, PosZ, PosA) VALUES (?, ?, ?, ?, ?, ?)");
    UpdateDealer = db_prepare(DrugDB, "UPDATE dealers SET Skin=?, PosX=?, PosY=?, PosZ=?, PosA=? WHERE ID=?");
    UpdateDealerDrugs = db_prepare(DrugDB, "UPDATE dealers SET Drugs=? WHERE ID=?");
	RemoveDealer = db_prepare(DrugDB, "DELETE FROM dealers WHERE ID=?");
	
	// initialize connected players
	foreach(new i : Player) Player_Init(i);
	
	// load dealers
	new id, skin, drugs, Float: pos[4];
	stmt_bind_result_field(LoadDealers, 0, DB::TYPE_INTEGER, id);
	stmt_bind_result_field(LoadDealers, 1, DB::TYPE_INTEGER, skin);
	stmt_bind_result_field(LoadDealers, 2, DB::TYPE_INTEGER, drugs);
	stmt_bind_result_field(LoadDealers, 3, DB::TYPE_FLOAT, pos[0]);
	stmt_bind_result_field(LoadDealers, 4, DB::TYPE_FLOAT, pos[1]);
	stmt_bind_result_field(LoadDealers, 5, DB::TYPE_FLOAT, pos[2]);
	stmt_bind_result_field(LoadDealers, 6, DB::TYPE_FLOAT, pos[3]);

	if(stmt_execute(LoadDealers))
	{
	    new label[128];
	    while(stmt_fetch_row(LoadDealers))
	    {
            DealerData[id][dealerSkin] = skin;
            DealerData[id][dealerDrugs] = drugs;
		 	DealerData[id][dealerX] = pos[0];
		  	DealerData[id][dealerY] = pos[1];
	        DealerData[id][dealerZ] = pos[2];
		 	DealerData[id][dealerA] = pos[3];

		    DealerData[id][dealerActorID] = CreateActor(DealerData[id][dealerSkin], DealerData[id][dealerX], DealerData[id][dealerY], DealerData[id][dealerZ], DealerData[id][dealerA]);
            SetActorInvulnerable(DealerData[id][dealerActorID], 1);

			format(label, sizeof(label), "Drug Dealer (%d)\n\n{FFFFFF}Use {F1C40F}/dealer {FFFFFF}to open dealer menu.", id);
			DealerData[id][dealerLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, DealerData[id][dealerX], DealerData[id][dealerY], DealerData[id][dealerZ] + 0.25, 5.0, .testlos = 1);

			Iter_Add(Dealers, id);
		}
	}
	
	return 1;
}

public OnFilterScriptExit()
{
	foreach(new i : Player) Player_SaveDrugs(i);
	foreach(new i : Dealers) DestroyActor(DealerData[i][dealerActorID]);

	db_close(DrugDB);
	return 1;
}

public OnPlayerConnect(playerid)
{
	Player_Init(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    PlayerDrugData[playerid][DrugsCooldown] = 0;
    
    if(RegenTimer[playerid] != -1)
	{
	    KillTimer(RegenTimer[playerid]);
	    RegenTimer[playerid] = -1;
	}

	if(EffectTimer[playerid] != -1)
	{
	    KillTimer(EffectTimer[playerid]);
	    EffectTimer[playerid] = -1;
	}
	
	foreach(new i : Player)
	{
	    if(PlayerDrugData[i][DrugsOfferedBy] == playerid)
	    {
	        PlayerDrugData[i][DrugsOfferedBy] = INVALID_PLAYER_ID;
	        ShowPlayerDialog(i, -1, DIALOG_STYLE_MSGBOX, "Title", "Content", "Button1", "Button2");
	        
            SendClientMessage(i, 0x3498DBFF, "DRUGS: {FFFFFF}The player who sent you an offer died.");
	    }
	}

    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    ////////////////////////////////////////////////////////////////
	    case DIALOG_DRUG_STATS:
	    {
	        if(!response) return 1;
	        if(listitem < 9) {
	            ShowDrugStats(playerid);
	        }else{
	            ShowPlayerDialog(playerid, DIALOG_CONFIRM_RESET, DIALOG_STYLE_MSGBOX, "Drug Stats: Reset", "Do you want to reset your drug stats?", "Yes", "No");
	        }
	        
	        return 1;
	    }
	    ////////////////////////////////////////////////////////////////
	    case DIALOG_CONFIRM_RESET:
	    {
			if(!response) return ShowDrugStats(playerid);
			PlayerDrugData[playerid][TotalUsed] = PlayerDrugData[playerid][TotalPlanted] = PlayerDrugData[playerid][TotalHarvestedPlants] = PlayerDrugData[playerid][TotalHarvestedGrams] =
			PlayerDrugData[playerid][TotalGiven] = PlayerDrugData[playerid][TotalReceived] = PlayerDrugData[playerid][TotalBought] = PlayerDrugData[playerid][TotalBoughtPrice] =
			PlayerDrugData[playerid][TotalSold] = PlayerDrugData[playerid][TotalSoldPrice] = 0;
			
			Player_SaveDrugs(playerid);
			ShowDrugStats(playerid);
			return 1;
		}
	    ////////////////////////////////////////////////////////////////
	    case DIALOG_DRUG_DEALER:
	    {
         	if(response)
	        {
				if(listitem == 0)
				{
				    if(PlayerDrugData[playerid][Seeds] >= SEED_LIMIT)
				    {
				        SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't buy any more seeds.");
				        return ShowDealerMenu(playerid);
				    }
				    
					ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_BUY_SEEDS, DIALOG_STYLE_INPUT, "Drug Dealer: Buying Seeds", "How many seeds would you like to buy?", "Buy", "Back");
				}
				
                if(listitem == 1)
				{
				    if(PlayerDrugData[playerid][Drugs] >= CARRY_LIMIT)
				    {
				        SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't buy any more drugs.");
				        return ShowDealerMenu(playerid);
				    }
				    
				    if(DealerData[ PlayerDrugData[playerid][DealerID] ][dealerDrugs] < 1)
				    {
				        SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}This dealer has no drugs.");
				        return ShowDealerMenu(playerid);
				    }

					ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_BUY_DRUGS, DIALOG_STYLE_INPUT, "Drug Dealer: Buying Drugs", "How many grams would you like to buy?", "Buy", "Back");
				}
				
				if(listitem == 2)
				{
                    if(PlayerDrugData[playerid][Drugs] < 1)
				    {
				        SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You don't have any drugs.");
				        return ShowDealerMenu(playerid);
				    }

					ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_SELL, DIALOG_STYLE_INPUT, "Drug Dealer: Selling Drugs", "How many grams would you like to sell?", "Sell", "Back");
				}
			}
	        
	        return 1;
	    }
	    ////////////////////////////////////////////////////////////////
	    case DIALOG_DRUG_DEALER_BUY_SEEDS:
	    {
	        if(!response) return ShowDealerMenu(playerid);
	        if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_BUY_SEEDS, DIALOG_STYLE_INPUT, "Drug Dealer: Buying Seeds", "{E74C3C}Input can't be empty.\n\n{FFFFFF}How many seeds would you like to buy?", "Buy", "Back");
			new amount = strval(inputtext);
			if(!(0 < amount <= SEED_LIMIT)) return ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_BUY_SEEDS, DIALOG_STYLE_INPUT, "Drug Dealer: Buying Seeds", "{E74C3C}Invalid amount.\n\n{FFFFFF}How many seeds would you like to buy?", "Buy", "Back");
			if(PlayerDrugData[playerid][Seeds] + amount > SEED_LIMIT) amount = SEED_LIMIT - PlayerDrugData[playerid][Seeds];
			new price = amount * SEED_PRICE;
			if(price > GetPlayerMoney(playerid)) return ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_BUY_SEEDS, DIALOG_STYLE_INPUT, "Drug Dealer: Buying Seeds", "{E74C3C}You don't have enough money.\n\n{FFFFFF}How many seeds would you like to buy?", "Buy", "Back");
            PlayerDrugData[playerid][Seeds] += amount;
            GivePlayerMoney(playerid, -price);
            
            new string[96];
            format(string, sizeof(string), "DRUG DEALER: {FFFFFF}Bought %s seeds for {2ECC71}%s.", formatInt(amount, .iCurrencyChar = '\0'), formatInt(price));
            SendClientMessage(playerid, 0x3498DBFF, string);
			return 1;
	    }
	    ////////////////////////////////////////////////////////////////
	    case DIALOG_DRUG_DEALER_BUY_DRUGS:
	    {
	        if(!response) return ShowDealerMenu(playerid);
	        if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_BUY_DRUGS, DIALOG_STYLE_INPUT, "Drug Dealer: Buying Drugs", "{E74C3C}Input can't be empty.\n\n{FFFFFF}How many grams would you like to buy?", "Buy", "Back");
			new amount = strval(inputtext), id = PlayerDrugData[playerid][DealerID];
			if(!(0 < amount <= CARRY_LIMIT)) return ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_BUY_DRUGS, DIALOG_STYLE_INPUT, "Drug Dealer: Buying Drugs", "{E74C3C}Invalid amount.\n\n{FFFFFF}How many grams would you like to buy?", "Buy", "Back");
			if(amount > DealerData[id][dealerDrugs])
			{
			    SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Dealer doesn't have that much drugs.");
			    return ShowDealerMenu(playerid);
			}
			
			if(PlayerDrugData[playerid][Drugs] + amount > CARRY_LIMIT) amount = CARRY_LIMIT - PlayerDrugData[playerid][Drugs];
			new price = amount * DRUG_BUY_PRICE;
			if(price > GetPlayerMoney(playerid)) return ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_BUY_DRUGS, DIALOG_STYLE_INPUT, "Drug Dealer: Buying Drugs", "{E74C3C}You don't have enough money.\n\n{FFFFFF}How many grams would you like to buy?", "Buy", "Back");
			DealerData[id][dealerDrugs] -= amount;
			PlayerDrugData[playerid][Drugs] += amount;
			PlayerDrugData[playerid][TotalBought] += amount;
			PlayerDrugData[playerid][TotalBoughtPrice] += price;
            GivePlayerMoney(playerid, -price);

            new string[96];
            format(string, sizeof(string), "DRUG DEALER: {FFFFFF}Bought %s grams of drugs for {2ECC71}%s.", formatInt(amount, .iCurrencyChar = '\0'), formatInt(price));
            SendClientMessage(playerid, 0x3498DBFF, string);
            
            stmt_bind_value(UpdateDealerDrugs, 0, DB::TYPE_INTEGER, DealerData[id][dealerDrugs]);
            stmt_bind_value(UpdateDealerDrugs, 1, DB::TYPE_INTEGER, id);
            stmt_execute(UpdateDealerDrugs);
			return 1;
	    }
	    ////////////////////////////////////////////////////////////////
	    case DIALOG_DRUG_DEALER_SELL:
	    {
	        if(!response) return ShowDealerMenu(playerid);
	        if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_SELL, DIALOG_STYLE_INPUT, "Drug Dealer: Selling Drugs", "{E74C3C}Input can't be empty.\n\n{FFFFFF}How many grams would you like to sell?", "Sell", "Back");
            new amount = strval(inputtext), id = PlayerDrugData[playerid][DealerID];
			if(!(0 < amount <= CARRY_LIMIT)) return ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_SELL, DIALOG_STYLE_INPUT, "Drug Dealer: Selling Drugs", "{E74C3C}Invalid amount.\n\n{FFFFFF}How many grams would you like to sell?", "Sell", "Back");
			if(amount > PlayerDrugData[playerid][Drugs]) return ShowPlayerDialog(playerid, DIALOG_DRUG_DEALER_SELL, DIALOG_STYLE_INPUT, "Drug Dealer: Selling Drugs", "{E74C3C}You don't have that much drugs.\n\n{FFFFFF}How many grams would you like to sell?", "Sell", "Back");
			new price = amount * DRUG_SELL_PRICE;
			DealerData[id][dealerDrugs] += amount;
			PlayerDrugData[playerid][Drugs] -= amount;
			PlayerDrugData[playerid][TotalSold] += amount;
			PlayerDrugData[playerid][TotalSoldPrice] += price;
            GivePlayerMoney(playerid, price);

            new string[96];
            format(string, sizeof(string), "DRUG DEALER: {FFFFFF}Sold %s grams of drugs for {2ECC71}%s.", formatInt(amount, .iCurrencyChar = '\0'), formatInt(price));
            SendClientMessage(playerid, 0x3498DBFF, string);
            
            stmt_bind_value(UpdateDealerDrugs, 0, DB::TYPE_INTEGER, DealerData[id][dealerDrugs]);
            stmt_bind_value(UpdateDealerDrugs, 1, DB::TYPE_INTEGER, id);
            stmt_execute(UpdateDealerDrugs);
			return 1;
		}
	    ////////////////////////////////////////////////////////////////
	    case DIALOG_DRUG_OFFER:
	    {
	        if(!response)
			{
				new string[96];
				format(string, sizeof(string), "DRUGS: {FFFFFF}Your offer got rejected by %s(%d).", Player_GetName(playerid), playerid);
				SendClientMessage(PlayerDrugData[playerid][DrugsOfferedBy], 0x3498DBFF, string);

                PlayerDrugData[playerid][DrugsOfferedBy] = INVALID_PLAYER_ID;
				return 1;
			}
			
	        new id = PlayerDrugData[playerid][DrugsOfferedBy], offeredp = PlayerDrugData[playerid][DrugsOfferedPrice], amount = strval(inputtext);
	        PlayerDrugData[playerid][DrugsOfferedBy] = INVALID_PLAYER_ID;
	        if(!IsPlayerConnected(id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Dealer is offline.");
	        if(DistanceBetweenPlayers(playerid, id) > 5.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You must be near to the dealer you want to buy drugs from.");
			if(!(0 < amount <= CARRY_LIMIT)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Invalid amount.");
 	 	 	if(amount > PlayerDrugData[id][Drugs]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Dealer doesn't have that much drugs.");
 	 	 	if(PlayerDrugData[playerid][Drugs] + amount > CARRY_LIMIT) amount = CARRY_LIMIT - PlayerDrugData[playerid][Drugs];
			new price = amount * offeredp;
			if(price > GetPlayerMoney(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You don't have enough money.");
			PlayerDrugData[playerid][Drugs] += amount;
			PlayerDrugData[id][Drugs] -= amount;
            GivePlayerMoney(playerid, -price);
            GivePlayerMoney(id, price);

            new string[128];
            format(string, sizeof(string), "DRUGS: {FFFFFF}Sold %s grams of drugs to %s(%d) for {2ECC71}%s.", formatInt(amount, .iCurrencyChar = '\0'), Player_GetName(playerid), playerid, formatInt(price));
            SendClientMessage(id, 0x3498DBFF, string);
            
            format(string, sizeof(string), "DRUGS: {FFFFFF}Bought %s grams of drugs from %s(%d) for {2ECC71}%s.", formatInt(amount, .iCurrencyChar = '\0'), Player_GetName(id), id, formatInt(price));
            SendClientMessage(playerid, 0x3498DBFF, string);
			return 1;
		}
	    ////////////////////////////////////////////////////////////////
	}
	
	return 0;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(RegenTimer[playerid] != -1)
	{
	    KillTimer(RegenTimer[playerid]);
	    RegenTimer[playerid] = -1;
	}
	
	foreach(new i : Player)
	{
	    if(PlayerDrugData[i][DrugsOfferedBy] == playerid)
	    {
	        PlayerDrugData[i][DrugsOfferedBy] = INVALID_PLAYER_ID;
	        ShowPlayerDialog(i, -1, DIALOG_STYLE_MSGBOX, "Title", "Content", "Button1", "Button2");
	        
            SendClientMessage(i, 0x3498DBFF, "DRUGS: {FFFFFF}The player who sent you an offer disconnected.");
	    }
	}
	
	RemoveEffects(playerid);
	Player_SaveDrugs(playerid);
	return 1;
}

forward PlantGrowth(id);
public PlantGrowth(id)
{
    new label_string[128];
    PlantData[id][plantGrowth] += RandomEx(3, 7);
    
	if(PlantData[id][plantGrowth] >= PLANT_MAX_GROWTH) {
	    PlantData[id][plantGrowth] = PLANT_MAX_GROWTH;
	    KillTimer(PlantData[id][plantTimer]);
	    PlantData[id][plantTimer] = SetTimerEx("PlantRot", ROT_INTERVAL * 1000, false, "i", id);
	    
	    new percentage = Plant_GrowthPercentage(id);
        format(label_string, sizeof(label_string), "Rotting Drug Plant (%d)\n\n{FFFFFF}Placed by %s\nGrowth: {%06x}%d%%\n\n{FFFFFF}/plant harvest", id, PlantData[id][plantedBy], (percentage < 25) ? 0xE74C3CFF >>> 8 : 0x2ECC71FF >>> 8, percentage);
		UpdateDynamic3DTextLabelText(PlantData[id][plantLabel], 0xF1C40FFF, label_string);
		
		SetDynamicObjectMaterial(PlantData[id][plantObj], 2, 2, "plants_TABLETOP", "CJ_PLANT", 0xFFD35400);
		
		new owner_id = Plant_GetOwnerID(id);
    	if(IsPlayerConnected(owner_id)) SendClientMessage(owner_id, 0x3498DBFF, "DRUG PLANT: {FFFFFF}One of your drug plants growed, harvest it before it rots!");
	}else{
	    new percentage = Plant_GrowthPercentage(id);
	    if(!PlantData[id][gotLeaves] && percentage >= 25)
	    {
	        SetDynamicObjectMaterial(PlantData[id][plantObj], 2, 2, "plants_TABLETOP", "CJ_PLANT", 0xFF2ECC71);
	        PlantData[id][gotLeaves] = true;
		}
		
	    format(label_string, sizeof(label_string), "Drug Plant (%d)\n\n{FFFFFF}Placed by %s\nGrowth: {%06x}%d%%\n\n{FFFFFF}/plant harvest", id, PlantData[id][plantedBy], (percentage < 25) ? 0xE74C3CFF >>> 8 : 0x2ECC71FF >>> 8, percentage);
		UpdateDynamic3DTextLabelText(PlantData[id][plantLabel], 0xF1C40FFF, label_string);
	}
	
	return 1;
}

forward PlantRot(id);
public PlantRot(id)
{
    new owner_id = Plant_GetOwnerID(id);
    if(IsPlayerConnected(owner_id)) SendClientMessage(owner_id, 0x3498DBFF, "DRUG PLANT: {FFFFFF}One of your drug plants rotted!");
    
    Plant_Destroy(id);
	return 1;
}

forward RegenHealth(playerid, amount);
public RegenHealth(playerid, amount)
{
	amount--;
	
	new Float: health;
	GetPlayerHealth(playerid, health);
	
	if(health + 2.5 < 95.0) SetPlayerHealth(playerid, health + 2.5);
	if(amount > 0) {
		#if defined USE_DRUNKLEVEL
	    SetPlayerDrunkLevel(playerid, 4999);
		#endif
		
		RegenTimer[playerid] = SetTimerEx("RegenHealth", 500, false, "ii", playerid, amount);
	}else{
	    #if defined USE_DRUNKLEVEL
	    SetPlayerDrunkLevel(playerid, 0);
		#endif
		
	    if(RegenTimer[playerid] != -1)
		{
		    KillTimer(RegenTimer[playerid]);
		    RegenTimer[playerid] = -1;
		}
	}
	
	return 1;
}

forward RemoveEffects(playerid);
public RemoveEffects(playerid)
{
	#if defined USE_DRUNKLEVEL
	SetPlayerDrunkLevel(playerid, 0);
	#endif
	
	SetPlayerWeather(playerid, 10);
	
	if(EffectTimer[playerid] != -1)
	{
	    KillTimer(EffectTimer[playerid]);
	    EffectTimer[playerid] = -1;
	}
	
	return 1;
}

// Player Commands
CMD:usedrugs(playerid, params[])
{
	if(PlayerDrugData[playerid][DrugsCooldown] > gettime()) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't use drugs right now.");
	new amount;
	if(sscanf(params, "i", amount)) return SendClientMessage(playerid, 0xE88732FF, "SYNTAX: {FFFFFF}/usedrugs [grams]");
	if(!(0 < amount <= 10)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't use less than 1 or more than 10 grams at once.");
	if(amount > PlayerDrugData[playerid][Drugs]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You don't have enough drugs.");
	PlayerDrugData[playerid][DrugsCooldown] = gettime() + (10 * amount);
	PlayerDrugData[playerid][Drugs] -= amount;
	PlayerDrugData[playerid][TotalUsed] += amount;
	
	SetPlayerWeather(playerid, 234);
	RegenTimer[playerid] = SetTimerEx("RegenHealth", 500, false, "ii", playerid, (3 * amount));
	EffectTimer[playerid] = SetTimerEx("RemoveEffects", (2 * amount) * 1000, false, "i", playerid);
	
	new string[48];
    format(string, sizeof(string), "DRUGS: {FFFFFF}Used %d grams of drugs.", amount);
	SendClientMessage(playerid, 0x3498DBFF, string);
	return 1;
}

CMD:givedrugs(playerid, params[])
{
	new id, amount;
    if(sscanf(params, "ui", id, amount)) return SendClientMessage(playerid, 0xE88732FF, "SYNTAX: {FFFFFF}/givedrugs [player id] [grams]");
    if(id == playerid) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Um... why? You can't just give yourself drugs!");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Invalid ID.");
	if(DistanceBetweenPlayers(playerid, id) > 5.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You must be near to the player you want to give drugs.");
    if(!(0 < amount <= 50)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't give than 1 or more than 50 grams at once.");
    if(amount > PlayerDrugData[playerid][Drugs]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You don't have enough drugs.");
    if(PlayerDrugData[id][Drugs] + amount > CARRY_LIMIT) amount = CARRY_LIMIT - PlayerDrugData[id][Drugs];
    PlayerDrugData[playerid][Drugs] -= amount;
    PlayerDrugData[playerid][TotalGiven] += amount;
    
	PlayerDrugData[id][Drugs] += amount;
    PlayerDrugData[id][TotalReceived] += amount;
    
    new string[96];
    format(string, sizeof(string), "DRUGS: {FFFFFF}%s(%d) gave you %d grams of drugs.", Player_GetName(playerid), playerid, amount);
	SendClientMessage(id, 0x3498DBFF, string);
	format(string, sizeof(string), "DRUGS: {FFFFFF}%d grams of drugs given to %s(%d).", amount, Player_GetName(id), id);
	SendClientMessage(playerid, 0x3498DBFF, string);
	return 1;
}

CMD:selldrugs(playerid, params[])
{
    if(PlayerDrugData[playerid][Drugs] < 1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You don't have drugs.");
	new id, price;
    if(sscanf(params, "ui", id, price)) return SendClientMessage(playerid, 0xE88732FF, "SYNTAX: {FFFFFF}/selldrugs [player id] [price per gram]");
    if(id == playerid) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Um... why? You can't just sell yourself drugs!");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Invalid ID.");
    if(DistanceBetweenPlayers(playerid, id) > 5.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You must be near to the player you want to offer drugs.");
	if(IsPlayerConnected(PlayerDrugData[id][DrugsOfferedBy])) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't sell drugs to this player right now.");
    if(!(0 < price <= 5000)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Price can't be less than $1 and more than $5,000.");
    if(PlayerDrugData[id][Drugs] >= CARRY_LIMIT) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}The player you want to sell drugs can't carry any more drugs.");
    if(PlayerDrugData[id][DrugsOfferCooldown] > gettime()) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Wait before offering drugs again to this player.");
    PlayerDrugData[id][DrugsOfferedBy] = playerid;
    PlayerDrugData[id][DrugsOfferedPrice] = price;
	PlayerDrugData[id][DrugsOfferCooldown] = gettime() + OFFER_COOLDOWN;
    
    new string[172];
    format(string, sizeof(string), "{FFFFFF}%s(%d) offered you some drugs.\nPrice: {2ECC71}%s per gram {FFFFFF}(has %s grams)\n\nHow many grams would you like to buy?", Player_GetName(playerid), playerid, formatInt(price), formatInt(PlayerDrugData[playerid][Drugs], .iCurrencyChar = '\0'));
    ShowPlayerDialog(id, DIALOG_DRUG_OFFER, DIALOG_STYLE_INPUT, "Drug Offer", string, "Buy", "Close");
    
    format(string, sizeof(string), "DRUGS: {FFFFFF}Offer sent to %s(%d).", Player_GetName(id), id);
	SendClientMessage(playerid, 0x3498DBFF, string);
	return 1;
}

CMD:drugstats(playerid, params[])
{
    ShowDrugStats(playerid);
	return 1;
}

CMD:dealer(playerid, params[])
{
	new id = GetClosestDealer(playerid);
	if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a drug dealer.");
	PlayerDrugData[playerid][DealerID] = id;
	ShowDealerMenu(playerid);
	return 1;
}

CMD:plant(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't use this command in a vehicle.");
    if(isnull(params)) return SendClientMessage(playerid, 0xE88732FF, "SYNTAX: {FFFFFF}/plant [place/harvest]");
    
    if(!strcmp(params, "place", true)) {
        /* -- planting -- */
        if(PlayerDrugData[playerid][Seeds] < 1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You don't have a drug seed.");
        if(Player_PlantCount(playerid) >= PLAYER_LIMIT) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't plant any more drug plants.");
        if(GetClosestPlant(playerid) != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't place a drug plant here because there is one nearby.");
        new id = Iter_Free(Plants);
        if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Server drug plant limit reached.");
        GetPlayerName(playerid, PlantData[id][plantedBy], MAX_PLAYER_NAME);
        GetPlayerPos(playerid, PlantData[id][plantX], PlantData[id][plantY], PlantData[id][plantZ]);
        
        PlantData[id][plantGrowth] = 0;
        PlantData[id][plantObj] = CreateDynamicObject(2244, PlantData[id][plantX], PlantData[id][plantY], PlantData[id][plantZ] - 0.70, 0.0, 0.0, 0.0);
        SetDynamicObjectMaterial(PlantData[id][plantObj], 2, 19478, "signsurf", "sign", 0xFFFFFFFF);
        
        new label_string[128];
        format(label_string, sizeof(label_string), "Drug Plant (%d)\n\n{FFFFFF}Placed by %s\nGrowth: {E74C3C}0%%\n\n{FFFFFF}/plant harvest", id, PlantData[id][plantedBy]);
        PlantData[id][plantLabel] = CreateDynamic3DTextLabel(label_string, 0xF1C40FFF, PlantData[id][plantX], PlantData[id][plantY], PlantData[id][plantZ], 5.0);
        
        PlantData[id][plantTimer] = SetTimerEx("PlantGrowth", GROWTH_INTERVAL * 1000, true, "i", id);
        Iter_Add(Plants, id);
        
        PlayerDrugData[playerid][Seeds]--;
        PlayerDrugData[playerid][TotalPlanted]++;
        /* -- planting -- */
    }else if(!strcmp(params, "harvest")) {
        /* -- harvesting -- */
        if(PlayerDrugData[playerid][Drugs] >= CARRY_LIMIT) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't carry any more drugs.");
        new id = GetClosestPlant(playerid);
        if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a drug plant.");
        if(!PlantData[id][gotLeaves]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't harvest this plant because it's not ready.");
        new harvested = PlantData[id][plantGrowth], string[96];
        if(PlayerDrugData[playerid][Drugs] + harvested > CARRY_LIMIT) harvested = CARRY_LIMIT - PlayerDrugData[playerid][Drugs];
        format(string, sizeof(string), "DRUG PLANT: {FFFFFF}You harvested a drug plant and got %d grams of drugs.", harvested);
		SendClientMessage(playerid, 0x3498DBFF, string);
		
        PlayerDrugData[playerid][Drugs] += harvested;
        PlayerDrugData[playerid][TotalHarvestedPlants]++;
        PlayerDrugData[playerid][TotalHarvestedGrams] += harvested;
        
        new owner_id = Plant_GetOwnerID(id);
        if(strcmp(PlantData[id][plantedBy], Player_GetName(playerid), true) && IsPlayerConnected(owner_id)) SendClientMessage(owner_id, 0x3498DBFF, "DRUG PLANT: {FFFFFF}Somebody harvested one of your drug plants!");

        Plant_Destroy(id);
		/* -- harvesting -- */
	}else{
        SendClientMessage(playerid, 0xE88732FF, "SYNTAX: {FFFFFF}/plant [place/harvest]");
    }

	return 1;
}

// Admin Commands - Dealers
CMD:createdealer(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Only RCON admins can use this command.");
	new skin;
	if(sscanf(params, "i", skin)) return SendClientMessage(playerid, 0xE88732FF, "SYNTAX: {FFFFFF}/createdealer [skin id]");
	if(!(0 <= skin <= 311)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Invalid skin ID.");
	new id = Iter_Free(Dealers);
	if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Can't add any more dealers.");
	GetPlayerPos(playerid, DealerData[id][dealerX], DealerData[id][dealerY], DealerData[id][dealerZ]);
	GetPlayerFacingAngle(playerid, DealerData[id][dealerA]);

    DealerData[id][dealerSkin] = skin;
    DealerData[id][dealerDrugs] = 0;
	DealerData[id][dealerActorID] = CreateActor(skin, DealerData[id][dealerX], DealerData[id][dealerY], DealerData[id][dealerZ], DealerData[id][dealerA]);
	SetActorInvulnerable(DealerData[id][dealerActorID], 1);

	new label[128];
	format(label, sizeof(label), "Drug Dealer (%d)\n\n{FFFFFF}Use {F1C40F}/dealer {FFFFFF}to open dealer menu.", id);
	DealerData[id][dealerLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, DealerData[id][dealerX], DealerData[id][dealerY], DealerData[id][dealerZ] + 0.25, 5.0, .testlos = 1);
	Iter_Add(Dealers, id);

	stmt_bind_value(AddDealer, 0, DB::TYPE_INTEGER, id);
	stmt_bind_value(AddDealer, 1, DB::TYPE_INTEGER, skin);
    stmt_bind_value(AddDealer, 2, DB::TYPE_FLOAT, DealerData[id][dealerX]);
    stmt_bind_value(AddDealer, 3, DB::TYPE_FLOAT, DealerData[id][dealerY]);
    stmt_bind_value(AddDealer, 4, DB::TYPE_FLOAT, DealerData[id][dealerZ]);
    stmt_bind_value(AddDealer, 5, DB::TYPE_FLOAT, DealerData[id][dealerA]);

    if(stmt_execute(AddDealer))
	{
		SendClientMessage(playerid, 0x3498DBFF, "DRUG DEALER: {FFFFFF}Dealer created.");
		SetPlayerPos(playerid, DealerData[id][dealerX] + (1.5 * floatsin(-DealerData[id][dealerA], degrees)), DealerData[id][dealerY] + (1.5 * floatcos(-DealerData[id][dealerA], degrees)), DealerData[id][dealerZ]);
	}

	return 1;
}

CMD:setdealerskin(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Only RCON admins can use this command.");
	if(isnull(params)) return SendClientMessage(playerid, 0xE88732FF, "SYNTAX: {FFFFFF}/setdealerskin [dealer id] [skin id]");
	new id, skin;
	if(sscanf(params, "ii", id, skin)) return SendClientMessage(playerid, 0xE88732FF, "SYNTAX: {FFFFFF}/setdealerskin [dealer id] [skin id]");
	if(!Iter_Contains(Dealers, id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Invalid ID.");
	if(!(0 <= skin <= 311)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Invalid skin ID.");
	DealerData[id][dealerSkin] = skin;

	DestroyActor(DealerData[id][dealerActorID]);
	DealerData[id][dealerActorID] = CreateActor(skin, DealerData[id][dealerX], DealerData[id][dealerY], DealerData[id][dealerZ], DealerData[id][dealerA]);
	SetActorInvulnerable(DealerData[id][dealerActorID], 1);

	stmt_bind_value(UpdateDealer, 0, DB::TYPE_INTEGER, skin);
    stmt_bind_value(UpdateDealer, 1, DB::TYPE_FLOAT, DealerData[id][dealerX]);
    stmt_bind_value(UpdateDealer, 2, DB::TYPE_FLOAT, DealerData[id][dealerY]);
    stmt_bind_value(UpdateDealer, 3, DB::TYPE_FLOAT, DealerData[id][dealerZ]);
    stmt_bind_value(UpdateDealer, 4, DB::TYPE_FLOAT, DealerData[id][dealerA]);
    stmt_bind_value(UpdateDealer, 5, DB::TYPE_INTEGER, id);

    if(stmt_execute(UpdateDealer)) SendClientMessage(playerid, 0x3498DBFF, "DRUG DEALER: {FFFFFF}Dealer updated.");
	return 1;
}

CMD:setdealerpos(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Only RCON admins can use this command.");
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, 0xE88732FF, "SYNTAX: {FFFFFF}/setdealerpos [dealer id]");
	if(!Iter_Contains(Dealers, id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Invalid ID.");
	GetPlayerPos(playerid, DealerData[id][dealerX], DealerData[id][dealerY], DealerData[id][dealerZ]);
	GetPlayerFacingAngle(playerid, DealerData[id][dealerA]);

	DestroyActor(DealerData[id][dealerActorID]);
	DealerData[id][dealerActorID] = CreateActor(DealerData[id][dealerSkin], DealerData[id][dealerX], DealerData[id][dealerY], DealerData[id][dealerZ], DealerData[id][dealerA]);
	SetActorInvulnerable(DealerData[id][dealerActorID], 1);

    Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, DealerData[id][dealerLabel], E_STREAMER_X, DealerData[id][dealerX]);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, DealerData[id][dealerLabel], E_STREAMER_Y, DealerData[id][dealerY]);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, DealerData[id][dealerLabel], E_STREAMER_Z, DealerData[id][dealerZ] + 0.25);

	stmt_bind_value(UpdateDealer, 0, DB::TYPE_INTEGER, DealerData[id][dealerSkin]);
    stmt_bind_value(UpdateDealer, 1, DB::TYPE_FLOAT, DealerData[id][dealerX]);
    stmt_bind_value(UpdateDealer, 2, DB::TYPE_FLOAT, DealerData[id][dealerY]);
    stmt_bind_value(UpdateDealer, 3, DB::TYPE_FLOAT, DealerData[id][dealerZ]);
    stmt_bind_value(UpdateDealer, 4, DB::TYPE_FLOAT, DealerData[id][dealerA]);
    stmt_bind_value(UpdateDealer, 5, DB::TYPE_INTEGER, id);

    if(stmt_execute(UpdateDealer))
	{
		SendClientMessage(playerid, 0x3498DBFF, "DRUG DEALER: {FFFFFF}Dealer updated.");
        SetPlayerPos(playerid, DealerData[id][dealerX] + (1.5 * floatsin(-DealerData[id][dealerA], degrees)), DealerData[id][dealerY] + (1.5 * floatcos(-DealerData[id][dealerA], degrees)), DealerData[id][dealerZ]);
	}

	return 1;
}

CMD:removedealer(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Only RCON admins can use this command.");
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, 0xE88732FF, "SYNTAX: {FFFFFF}/removedealer [dealer id]");
	if(!Iter_Contains(Dealers, id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Invalid ID.");
	DestroyActor(DealerData[id][dealerActorID]);
	DestroyDynamic3DTextLabel(DealerData[id][dealerLabel]);

	DealerData[id][dealerDrugs] = 0;
	DealerData[id][dealerActorID] = -1;
	DealerData[id][dealerLabel] = Text3D: -1;
	Iter_Remove(Dealers, id);

	stmt_bind_value(RemoveDealer, 0, DB::TYPE_INTEGER, id);
    if(stmt_execute(RemoveDealer)) SendClientMessage(playerid, 0x3498DBFF, "DRUG DEALER: {FFFFFF}Dealer removed.");
	return 1;
}