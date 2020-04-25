forward sama(const kata1[], const kata2[]);
public sama(const kata1[], const kata2[]){
    return (!strcmp(kata1, kata2) && !isnull(kata1) && !isnull(kata2)) ? 1 : 0;
}

error_syntax(playerid, const syntax[]){
    new pesan[256] = "[{FF0000}Invalid{FFFFFF}] {FF0000}Gunakan {FFFFFF}: ";

    strcat(pesan, syntax);
    return SendClientMessage(playerid, COLOR_WHITE, pesan);
}

error_command(playerid, const message[]){
    new pesan[256] = "[{FF0000}Error{FFFFFF}] : ";
    strcat(pesan, message);
    return SendClientMessage(playerid, COLOR_WHITE, pesan);
}

stock ProxDetector(Float:radi, playerid, string[], color)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, radi, x, y, z))
        {
            SendClientMessage(i, color, string);
        }
    }
}