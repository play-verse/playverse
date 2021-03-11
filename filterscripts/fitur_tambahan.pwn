#include <a_samp>
#include <sampvoice>
#include <colors>
#include <sscanf2>
#include <zcmd>

#define publicFor:%0(%1) forward %0(%1); public %0(%1)

/* Android Check */
native SendClientCheck(playerid, type, arg, offset, size);

#define IsPlayerAndroid(%0) GetPVarInt(%0, "NotAndroid") == 0

/* Voice Chat */

#define Local_Distance 30.0

// Channel Voice
#define LOCAL_TO_LOCAL		0
#define ADMIN_TO_GLOBAL		1
#define ADMIN_TO_ADMIN		2
#define POLICE_TO_POLICE	3
#define MEDIC_TO_MEDIC		4
#define PUBLIC_TO_PUBLIC	5

enum vInfo
{
	toggle_mic,
    status_mic,
    last_mic[32]
}

new PlayerVoice[MAX_PLAYERS][vInfo],
	SV_LSTREAM:local_stream[MAX_PLAYERS] = { SV_NULL, ... }, // Untuk lokal ke lokal
	SV_GSTREAM:aglobal_stream = SV_NULL, // Untuk admin ke global
	SV_GSTREAM:alocal_stream = SV_NULL, // Untuk admin ke admin
	SV_GSTREAM:police_radio = SV_NULL, // Untuk polisi ke polisi
	SV_GSTREAM:medic_radio = SV_NULL, // Untuk medis ke medis
	SV_GSTREAM:public_radio = SV_NULL; // Untuk publik

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
    /* Voice Chat */
	/** Warna 
	 * Merah	= 0xff0000ff
	 * Biru		= 0xffff0000
	 */
	aglobal_stream = SvCreateGStream(0xff0000ff, "Global");
	alocal_stream = SvCreateGStream(0xffff0000, "Admin");
	police_radio = SvCreateGStream(0xffff0000, "Police");
	medic_radio = SvCreateGStream(0xffff0000, "Medic");
	public_radio = SvCreateGStream(0xffff0000, "Public");
	print("[Fitur Tambahan] Berhasil load sistem!");
	return 1;
}

public OnFilterScriptExit()
{
    /* Voice Chat */
	if(aglobal_stream) SvDeleteStream(aglobal_stream);
	if(alocal_stream) SvDeleteStream(alocal_stream);
	if(police_radio) SvDeleteStream(police_radio);
	if(medic_radio) SvDeleteStream(medic_radio);
	if(public_radio) SvDeleteStream(public_radio);
	print("[Fitur Tambahan] Berhasil unload sistem!");
    return 1;
}

public OnPlayerConnect(playerid)
{
	/* Android Check */
    SendClientCheck(playerid, 0x48, 0, 0, 2);
    /* Voice Chat */
	PlayerVoice[playerid][status_mic] = 0;
	PlayerVoice[playerid][last_mic] = 0;
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    /* Voice Chat */
    if(local_stream[playerid]){
        SvDeleteStream(local_stream[playerid]);
        local_stream[playerid] = SV_NULL;
    }
    PlayerVoice[playerid][status_mic] = 0;
	PlayerVoice[playerid][last_mic] = 0;
	return 1;
}

/* Android Check */
publicFor:OnClientCheckResponse(playerid, type, arg, response)
{
    switch(type){
        case 0x48:
        {
            SetPVarInt(playerid, "NotAndroid", 1);
        }
    }
    return 1;
}

/* Voice Chat */
/** Key
 * B 	= 0x42
 * Z 	= 0x5A
 * Caps	= 0x14
 */
public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid)
{
    if(keyid == 0x42){
		// Switch mic sesuai toggle
		if(PlayerVoice[playerid][toggle_mic] == LOCAL_TO_LOCAL){
			if(local_stream[playerid]) SvAttachSpeakerToStream(local_stream[playerid], playerid);
		}else if(PlayerVoice[playerid][toggle_mic] == ADMIN_TO_GLOBAL){
			if(aglobal_stream) SvAttachSpeakerToStream(aglobal_stream, playerid);
		}else if(PlayerVoice[playerid][toggle_mic] == ADMIN_TO_ADMIN){
			if(alocal_stream) SvAttachSpeakerToStream(alocal_stream, playerid);
		}else if(PlayerVoice[playerid][toggle_mic] == POLICE_TO_POLICE){
			if(police_radio) SvAttachSpeakerToStream(police_radio, playerid);
		}else if(PlayerVoice[playerid][toggle_mic] == MEDIC_TO_MEDIC){
			if(medic_radio) SvAttachSpeakerToStream(medic_radio, playerid);
		}else if(PlayerVoice[playerid][toggle_mic] == PUBLIC_TO_PUBLIC){
			if(public_radio) SvAttachSpeakerToStream(public_radio, playerid);
		}
	}
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
    new temp_jam, temp_menit, temp_detik;
    if(keyid == 0x42){
		// Dapatkan histori terakhir mic
		gettime(temp_jam, temp_menit, temp_detik);
		format(PlayerVoice[playerid][last_mic], 32, "%s", FormatJam(temp_jam, temp_menit));
		if(PlayerVoice[playerid][toggle_mic] == LOCAL_TO_LOCAL){
			if(local_stream[playerid]) SvDetachSpeakerFromStream(local_stream[playerid], playerid);
		}else if(PlayerVoice[playerid][toggle_mic] == ADMIN_TO_GLOBAL){
			if(aglobal_stream) SvDetachSpeakerFromStream(aglobal_stream, playerid);
		}else if(PlayerVoice[playerid][toggle_mic] == ADMIN_TO_ADMIN){
			if(alocal_stream) SvDetachSpeakerFromStream(alocal_stream, playerid);
		}else if(PlayerVoice[playerid][toggle_mic] == POLICE_TO_POLICE){
			if(police_radio) SvDetachSpeakerFromStream(police_radio, playerid);
		}else if(PlayerVoice[playerid][toggle_mic] == MEDIC_TO_MEDIC){
			if(medic_radio) SvDetachSpeakerFromStream(medic_radio, playerid);
		}else if(PlayerVoice[playerid][toggle_mic] == PUBLIC_TO_PUBLIC){
			if(public_radio) SvDetachSpeakerFromStream(public_radio, playerid);
		}
	}
}

loadPlayerVoice(playerid, Float:distance){
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
    else if((local_stream[playerid] = SvCreateDLStreamAtPlayer(distance, SV_INFINITY, playerid, 0xff0000ff, "Local"))){
        PlayerVoice[playerid][status_mic] = 3;
        // Assign microphone activation keys to the player
        SvAddKey(playerid, 0x42);
		// Pasang lstener ke player
		SvAttachListenerToStream(aglobal_stream, playerid); // Admin > Global
    }
}

delayVoiceNotice(playerid){
    /* Voice Chat */
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
}

detachListenerGlobal(playerid){
	if(SvHasListenerInStream(alocal_stream, playerid)){
		SvDetachListenerFromStream(alocal_stream, playerid);
	}else if(SvHasListenerInStream(police_radio, playerid)){
		SvDetachListenerFromStream(police_radio, playerid);
	}else if(SvHasListenerInStream(medic_radio, playerid)){
		SvDetachListenerFromStream(medic_radio, playerid);
	}else if(SvHasListenerInStream(public_radio, playerid)){
		SvDetachListenerFromStream(public_radio, playerid);
	}
}

detachSpeakerGlobal(playerid){
	if(SvHasSpeakerInStream(aglobal_stream, playerid)){
		SvDetachSpeakerFromStream(aglobal_stream, playerid);
	}else if(SvHasSpeakerInStream(alocal_stream, playerid)){
		SvDetachSpeakerFromStream(alocal_stream, playerid);
	}else if(SvHasSpeakerInStream(police_radio, playerid)){
		SvDetachSpeakerFromStream(police_radio, playerid);
	}else if(SvHasSpeakerInStream(medic_radio, playerid)){
		SvDetachSpeakerFromStream(medic_radio, playerid);
	}else if(SvHasSpeakerInStream(public_radio, playerid)){
		SvDetachSpeakerFromStream(public_radio, playerid);
	}
}

publicFor:checkPlayerVoice(playerid){
	loadPlayerVoice(playerid, Local_Distance);
	delayVoiceNotice(playerid);
	return 1;
}

resetGlobalVoice(playerid){
	PlayerVoice[playerid][toggle_mic] = LOCAL_TO_LOCAL;
	SvMutePlayerEnable(playerid);
	detachListenerGlobal(playerid);
	detachSpeakerGlobal(playerid);
	SvMutePlayerDisable(playerid);
}

publicFor:checkAccessVoice(playerid){
	// Cek akses voice
	if(PlayerVoice[playerid][toggle_mic] == ADMIN_TO_GLOBAL || PlayerVoice[playerid][toggle_mic] == ADMIN_TO_ADMIN){
		resetGlobalVoice(playerid);
	}else if(PlayerVoice[playerid][toggle_mic] == POLICE_TO_POLICE){
		resetGlobalVoice(playerid);
	}else if(PlayerVoice[playerid][toggle_mic] == MEDIC_TO_MEDIC){
		resetGlobalVoice(playerid);
	}
	return 1;
}

publicFor:checkStatusMic(playerid){
	new mic_status[16], last_voice[16];
	if(PlayerVoice[playerid][status_mic] == 3){
		format(mic_status, 16, "Tersedia");
	}else{
		format(mic_status, 16, "Tidak Tersedia");
	}
	if(isnull(PlayerVoice[playerid][last_mic])){
		format(last_voice, 16, "Tidak Terdata");
	}else{
		format(last_voice, 16, "Jam %s", PlayerVoice[playerid][last_mic]);
	}
	SetPVarString(playerid, "mic_status", mic_status);
	SetPVarString(playerid, "last_voice", last_voice);
	return 1;
}


publicFor:joinVoiceAdmin(playerid, type){
	switch(type){
		case 0:
		{
			if(local_stream[playerid]){
				if(PlayerVoice[playerid][toggle_mic] == LOCAL_TO_LOCAL){
					SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Anda tidak berada di channel admin manapun.");
				}else{
					PlayerVoice[playerid][toggle_mic] = LOCAL_TO_LOCAL;
					detachListenerGlobal(playerid);
					SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Anda telah berhasil menonaktifkan voice admin.");
				}
			}else{
				SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Terjadi kesalahan pada sistem voice chat.");
			}
		}
		case 1:
		{
			if(aglobal_stream){
				if(PlayerVoice[playerid][toggle_mic] == ADMIN_TO_GLOBAL){
					SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Anda sudah mengaktifkan voice admin (Publik).");
				}else{
					PlayerVoice[playerid][toggle_mic] = ADMIN_TO_GLOBAL;
					SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Anda telah berhasil mengaktifkan voice admin (Publik).");
				}
			}else{
				SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Terjadi kesalahan pada sistem voice chat.");
			}

		}
		case 2:
		{
			if(alocal_stream){
				if(PlayerVoice[playerid][toggle_mic] == ADMIN_TO_ADMIN){
					SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Anda sudah mengaktifkan voice admin (Khusus Admin).");
				}else{
					PlayerVoice[playerid][toggle_mic] = ADMIN_TO_ADMIN;
					SvAttachListenerToStream(alocal_stream, playerid);
					SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Anda telah berhasil mengaktifkan voice admin (Khusus Admin).");
				}
			}else{
				SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Terjadi kesalahan pada sistem voice chat.");
			}
		}
		default:
		{
			new msg[128];
			format(msg, sizeof(msg), GREY\
			"Usage "WHITE"/avoice [type 0-2]\n\n\
			List Type:\n\
			0 - Disable / Normal (Lokal)\n\
			1 - Semua pemain (Publik)\n\
			2 - Khusus admin");
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, WHITE"Voice Admin Channel", msg, "Ok", "");
		}
	}
	return 1;
}

publicFor:joinRadio(playerid, const freq[]){
	if(sama("off", freq)){
		// Nonaktifkan radio
		if(local_stream[playerid]){
			if(PlayerVoice[playerid][toggle_mic] == LOCAL_TO_LOCAL){
				SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Anda tidak berada di radio manapun.");
			}else{
				PlayerVoice[playerid][toggle_mic] = LOCAL_TO_LOCAL;
				detachListenerGlobal(playerid);
				SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Anda telah berhasil menonaktifkan radio.");
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Terjadi kesalahan pada sistem radio.");
		}
	}else if(sama("01.00", freq)){
		// Police
		if(police_radio){
			if(PlayerVoice[playerid][toggle_mic] == POLICE_TO_POLICE){
				SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Anda sudah terhubung ke radio polisi.");
			}else{
				PlayerVoice[playerid][toggle_mic] = POLICE_TO_POLICE;
				detachListenerGlobal(playerid);
				SvAttachListenerToStream(police_radio, playerid);
				SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Anda telah berhasil terhubung ke radio polisi.");
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Terjadi kesalahan pada sistem radio.");
		}
	}else if(sama("02.00", freq)){
		// Medis
		if(medic_radio){
			if(PlayerVoice[playerid][toggle_mic] == MEDIC_TO_MEDIC){
				SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Anda sudah terhubung ke radio medis.");
				SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Ketik "GREEN"/radio off "WHITE"untuk menonaktfikan radio.");
			}else{
				PlayerVoice[playerid][toggle_mic] = MEDIC_TO_MEDIC;
				detachListenerGlobal(playerid);
				SvAttachListenerToStream(medic_radio, playerid);
				SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Anda telah berhasil terhubung ke radio medis.");
				SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Ketik "GREEN"/radio off "WHITE"untuk menonaktfikan radio.");
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Terjadi kesalahan pada sistem radio.");
		}
	}else if(sama("101.00", freq)){
		// Test radio player
		if(public_radio){
			if(PlayerVoice[playerid][toggle_mic] == PUBLIC_TO_PUBLIC){
				SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Anda sudah terhubung ke radio publik.");
			}else{
				PlayerVoice[playerid][toggle_mic] = PUBLIC_TO_PUBLIC;
				detachListenerGlobal(playerid);
				SvAttachListenerToStream(public_radio, playerid);
				SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Anda telah berhasil terhubung ke radio publik.");
				SendClientMessage(playerid, COLOR_BLUE, "Info: "WHITE"Ketik "GREEN"/radio off "WHITE"untuk menonaktfikan radio.");
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, "Error: "WHITE"Terjadi kesalahan pada sistem radio.");
		}
	}else{
		new msg[165];
		format(msg, sizeof(msg), GREY\
        "Usage "WHITE"/radio [frekuensi]\n\n\
        List Frekuensi:\n\
		off - Menonaktifkan radio\n\
        00.00 s/d 99.99 - Non Publik\n\
		100.00 s/d 999.99 - Publik\n\n\
		Silahkan mengunjungi "GREEN"https://wiki.playverse.org/"WHITE" untuk lebih lengkap.");
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, WHITE"Radio Channel Frequency", msg, "Ok", "");
	}
	return 1;
}

publicFor:controlPlayerVoice(playerid, status){
	if(status == 1){
		// Bisukan player
		SvMutePlayerEnable(playerid);
	}else{
		// Batal biuskan player
		SvMutePlayerDisable(playerid);
	}
	return 1;
}
/* End Voice Chat */

sama(const kata1[], const kata2[], bool:ignorecase=false)
    return (!strcmp(kata1, kata2, ignorecase) && !isnull(kata1) && !isnull(kata2));