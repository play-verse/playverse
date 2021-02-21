#include <a_samp>
#include <sampvoice>
#include <colors>
#include <sscanf2>
#include <zcmd>
#include <samp-precise-timers>

/* Android Check */
native SendClientCheck(playerid, type, arg, offset, size);
forward OnClientCheckResponse(playerid, type, arg, response);

#define IsPlayerAndroid(%0)		GetPVarInt(%0, "NotAndroid") == 0

forward LoadPlayerVoice(playerid, Float:distance);
forward DelayVoiceNotice(playerid);
forward AksesPlayerData(playerid);

/* Voice Chat */
#define Local_Distance 30.0

enum vInfo
{
    status_mic,
    last_mic[32]
}

new PlayerVoice[MAX_PLAYERS][vInfo];
new SV_GSTREAM:gstream = SV_NULL;
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };

/* Stock */
stock FormatJam(temp_jam = 0, temp_menit = 0){
	new text[16], text_menit[8], text_jam[8];
	if(temp_menit > 60){
		temp_menit = temp_menit-60;
		temp_jam += 1;
		if(temp_jam > 24) temp_jam = 0;
	}
	if(temp_menit < 10){
		format(text_menit, sizeof(text_menit), "0%d", temp_menit);
	}else{
		format(text_menit, sizeof(text_menit), "%d", temp_menit);
	}
	if(temp_jam < 10){
		format(text_jam, sizeof(text_jam), "0%d", temp_jam);
	}else{
		format(text_jam, sizeof(text_jam), "%d", temp_jam);
	}
	format(text, sizeof(text), "%s:%s", text_jam, text_menit);
	return text;
}

public OnFilterScriptInit()
{
    print("[Fitur Tambahan] Berhasil load sistem!");
    // Voice Chat
    // Uncomment the line to enable debug mode
    // SvDebug(SV_TRUE);
    gstream = SvCreateGStream(0xffff0000, "Global");
	return 1;
}

public OnFilterScriptExit()
{
    // Voice Chat
    if(gstream) SvDeleteStream(gstream);
    print("[Fitur Tambahan] Berhasil unload sistem!");
    return 1;
}

public OnPlayerConnect(playerid)
{
	// Android Check
    SendClientCheck(playerid, 0x48, 0, 0, 2);
    // Voice Chat
    LoadPlayerVoice(playerid, Local_Distance);
    SetPreciseTimer("DelayVoiceNotice", 120000, false, "i", playerid);
    return 1;
}

public LoadPlayerVoice(playerid, Float:distance){
    // Checking for plugin availability
    if(SvGetVersion(playerid) == SV_NULL){
    	PlayerVoice[playerid][status_mic] = 1;
    }
    // Checking for a microphone
    else if(SvHasMicro(playerid) == SV_FALSE){
    	PlayerVoice[playerid][status_mic] = 2;
    }
    // Create a local stream with an audibility distance of distance value, an unlimited number of listeners
    // and the name 'Local' (the name 'Local' will be displayed in red in the players' speakerlist)
    else if((lstream[playerid] = SvCreateDLStreamAtPlayer(distance, SV_INFINITY, playerid, 0xff0000ff, "Local"))){
        PlayerVoice[playerid][status_mic] = 3;
        // Attach the player to the global stream as a listener
        if(gstream) SvAttachListenerToStream(gstream, playerid);
        // Assign microphone activation keys to the player
        SvAddKey(playerid, 0x42); // Key B (Local)
    }
	return 1;
}

public DelayVoiceNotice(playerid){
    	// Voice Chat
	if(PlayerVoice[playerid][status_mic] == 1){
		SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Tidak dapat menemukan plugin Voice Chat.");
	}else if(PlayerVoice[playerid][status_mic] == 2){
        SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Microphone tidak ditemukan, silahkan pasang atau beri akses pada perangkat anda.");
	}else if(PlayerVoice[playerid][status_mic] == 3){
        if(IsPlayerAndroid(playerid) == false){
			SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Tekan "GREEN"B"WHITE" untuk menggunakan Voice Chat.");
		}
	}
	SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Laporkan pemain jika menyalahgunakan Voice Chat ("GREEN"/report"WHITE").");
	return 1;
}

/* Android Check */
public OnClientCheckResponse(playerid, type, arg, response)
{
    switch(type){
        case 0x48:
        {
            SetPVarInt(playerid, "NotAndroid", 1);
        }
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    // Voice Chat
    // Removing the player's local stream after disconnecting
    if(lstream[playerid]){
        SvDeleteStream(lstream[playerid]);
        lstream[playerid] = SV_NULL;
    }
    PlayerVoice[playerid][status_mic] = 0;
    return 1;
}

/* Voice Chat */
public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid)
{
    // Attach player to local stream as speaker if 'B' key is pressed
    if(keyid == 0x42 && lstream[playerid]) SvAttachSpeakerToStream(lstream[playerid], playerid);
	// Attach the player to the global stream as a speaker if the 'Z' key is pressed
    if(keyid == 0x5A && gstream) SvAttachSpeakerToStream(gstream, playerid);
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
    new temp_jam, temp_menit, temp_detik;
    // Detach the player from the local stream if the 'B' key is released
    if (keyid == 0x42 && lstream[playerid]){
		SvDetachSpeakerFromStream(lstream[playerid], playerid);
		gettime(temp_jam, temp_menit, temp_detik);
		format(PlayerVoice[playerid][last_mic], 32, "%s", FormatJam(temp_jam, temp_menit));
	}
	// Detach the player from the global stream if the 'Z' key is released
    if (keyid == 0x5A && gstream){
		SvDetachSpeakerFromStream(gstream, playerid);
		gettime(temp_jam, temp_menit, temp_detik);
		format(PlayerVoice[playerid][last_mic], 32, "%s", FormatJam(temp_jam, temp_menit));
	}
}

CMD:avoice(playerid, params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	SvAddKey(playerid, 0x5A); // Key Z (Global)
	SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Tekan "GREEN"Z"WHITE" untuk menggunakan Voice Chat (Global).");
	return 1;
}

CMD:checkdevice(playerid, params[]){
	if(IsPlayerAdmin(playerid)){
		new idtujuan;

		if(sscanf(params, "u", idtujuan))
	        return SendClientMessage(playerid, COLOR_RED, "Invalid: "GREY"Gunakan "WHITE"/checkdevice [id tujuan]");

		if(idtujuan == INVALID_PLAYER_ID || !IsPlayerConnected(idtujuan))
	        return SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Pemain tujuan tidak valid.");

	    new msg[156], device_info[16], mic_status[16], nama_tujuan[MAX_PLAYER_NAME];
		GetPlayerName(idtujuan, nama_tujuan, sizeof(nama_tujuan));
	    // Check Device
	    if(IsPlayerAndroid(idtujuan)){
	        format(device_info, sizeof(device_info), "Android");
	    }else{
	        format(device_info, sizeof(device_info), "PC");
	    }
	    // Check Microphone
	    if(PlayerVoice[idtujuan][status_mic] == 3){
	        format(mic_status, sizeof(mic_status), "Tersedia");
	    }else{
	        format(mic_status, sizeof(mic_status), "Tidak Tersedia");
	    }
	    // Check Last Voice
		if(isnull(PlayerVoice[idtujuan][last_mic])) format(PlayerVoice[idtujuan][last_mic], 32, "Tidak Terdata");
		else format(PlayerVoice[idtujuan][last_mic], 32, "Jam %s", PlayerVoice[idtujuan][last_mic]);
		// Print
	    format(msg, sizeof(msg), WHITE\
	    "Nama: "GREEN"%s"WHITE"\n\
	    Device: "GREEN"%s"WHITE"\n\
	    Microphone: "GREEN"%s"WHITE"\n\
		Last Voice: "GREEN"%s", nama_tujuan, device_info, mic_status, PlayerVoice[idtujuan][last_mic]);
	    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, WHITE"Player Status Device", msg, "Ok", "");
	    return 1;
	}
	return 0;
}
