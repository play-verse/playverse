CMD:kick(playerid, params[]){
	new target_id, pesan[256];
    if(!IsPlayerAdmin(playerid)) return error_command(playerid, "Anda tidak dapat menggunakan perintah ini!");
	if(sscanf(params, "us[256]", target_id, pesan)) return error_syntax(playerid, "/kick [playerid] [pesan]");
    if(!IsPlayerConnected(target_id)) return  error_command(playerid, "Player dengan id tersebut tidak ada!");
    if(target_id == playerid) return  error_command(playerid, "Tidak dapat mengusir diri sendiri!");

    Kick(target_id);
	return 1;
}

CMD:a(playerid, params[]){
    new pesan[256];
	if(sscanf(params, "s[256]", pesan)) return error_syntax(playerid, "/a [pesan]");
    if(gettime() - PlayerInfo[playerid][lastGlobalChat] < (5 * 60)){
        format(msg, sizeof(msg), "Anda hanya dapat mengirim pesan global 5 menit sekali, anda harus menunggu %d detik lagi!", 5 * 60 + PlayerInfo[playerid][lastGlobalChat] - gettime());
        return error_command(playerid, msg);
    }
    format(msg, sizeof(msg), COL_WHITE"["COL_GREEN"GLOBAL"COL_WHITE"] ["COL_GRAY"%d"COL_WHITE"] {%06x}%s "COL_WHITE": %s", playerid, GetPlayerColor(playerid) >>> 8, PlayerInfo[playerid][pPlayerName], pesan);
    SendClientMessageToAll(COLOR_WHITE, msg);
    PlayerInfo[playerid][lastGlobalChat] = gettime();
    return 1;
}