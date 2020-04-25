CMD:kick(playerid, params[]){
	new target_id, pesan[256];
    if(!IsPlayerAdmin(playerid)) return error_command(playerid, "Anda tidak dapat menggunakan perintah ini!");
	if(sscanf(params, "us[256]", target_id, pesan)) return error_syntax(playerid, "/kick [playerid] [pesan]");
    if(!IsPlayerConnected(target_id)) return  error_command(playerid, "Player dengan id tersebut tidak ada!");
    if(target_id == playerid) return  error_command(playerid, "Tidak dapat mengusir diri sendiri!");

    format(msg, sizeof(msg),  RED"[KICK] "WHITE"Anda telah di kick dari server dengan alasan : "YELLOW"%s "WHITE"!", pesan);
    SendClientMessage(playerid, COLOR_WHITE, msg);
    Kick(target_id);

    format(msg, sizeof(msg), ORANGE"[ADMIN] "RED"%s "WHITE"telah di kick dari server dengan alasan : "YELLOW"%s "WHITE"!", PlayerInfo[target_id][pPlayerName], pesan);
    SendClientMessageToAll(COLOR_WHITE, msg);
	return 1;
}

CMD:bc(playerid, params[]){
    new pesan[256];
	if(sscanf(params, "s[256]", pesan)) return error_syntax(playerid, "/bc [pesan]");
    if(gettime() - PlayerInfo[playerid][lastGlobalChat] < (5 * 60)){
        format(msg, sizeof(msg), "Anda hanya dapat mengirim pesan broadcast 5 menit sekali, anda harus menunggu %d detik lagi!", 5 * 60 + PlayerInfo[playerid][lastGlobalChat] - gettime());
        return error_command(playerid, msg);
    }
    format(msg, sizeof(msg), WHITE"["BLUE"BC"WHITE"] ["GREY"%d"WHITE"] %s "WHITE": %s", playerid, PlayerInfo[playerid][pPlayerName], pesan);
    SendClientMessageToAll(COLOR_WHITE, msg);
    PlayerInfo[playerid][lastGlobalChat] = gettime();
    return 1;
}

CMD:jetpack(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return 0;
    SetPlayerSpecialAction(playerid, 2);
    return 1;
}

CMD:spawn(playerid, params[]){
    new target_id;
    if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "u", target_id)) return error_syntax(playerid, "/spawn [playerid]");
    SpawnPlayer(target_id);
    return 1;
}

CMD:inventory(playerid, params[]){
    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "Inventory", "Skin", "Pilih", "Batal");
    return 1;
}

CMD:beliskin(playerid, params[]){    
    if(!IsPlayerAdmin(playerid)) return 0;
    new len;
    new subString[16];
    static string[500];
    len = PlayerInfo[playerid][jenisKelamin] == 0 ? sizeof(SKIN_MALE_GRATIS) : sizeof(SKIN_FEMALE_GRATIS);

    for (new i = 0; i < len; i++) {
        format(subString, sizeof(subString), "%i\n", PlayerInfo[playerid][jenisKelamin] == 0 ? SKIN_MALE_GRATIS[i] : SKIN_FEMALE_GRATIS[i]);
        strcat(string, subString);
    } 

    ShowPlayerDialog(playerid, DIALOG_BELI_SKIN, DIALOG_STYLE_PREVIEW_MODEL, "Pilih skin yang anda inginkan", string, "Pilih", "Keluar");
    return 1;
}