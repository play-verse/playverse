/**
    Admin Command
*/
CMD:kick(playerid, params[]){
    // Jika level admin < 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

	new target_id, pesan[256];
	if(sscanf(params, "us[256]", target_id, pesan)) return error_syntax(playerid, "/kick [playerid] [pesan]");
    if(!IsPlayerConnected(target_id)) return  error_command(playerid, "Player dengan id tersebut tidak ada!");
    if(target_id == playerid) return  error_command(playerid, "Tidak dapat mengusir diri sendiri!");

    foreach(new i : Player){
        // SendMessageToAllAdmin
        if(GetLevelAdminPlayer(i) > 0) {
            format(msg, sizeof(msg), "KICK %s(%d) > %s(%d) alasan : "SILVER"%s", PlayerInfo[playerid][pPlayerName], playerid, PlayerInfo[target_id][pPlayerName], target_id, pesan);
            SendClientMessage(i, COLOR_BLUE, msg);
        }
    }
    format(msg, sizeof(msg),  TAG_KICK" "WHITE"Anda telah di kick dari server dengan alasan : "YELLOW"%s "WHITE"!", pesan);
    SendClientMessage(target_id, COLOR_RED, msg);
    KickEx(target_id);

    format(msg, sizeof(msg), TAG_ADMIN" "RED"%s "WHITE"telah di kick dari server dengan alasan : "YELLOW"%s "WHITE"!", PlayerInfo[target_id][pPlayerName], pesan);
    SendClientMessageToAll(COLOR_ORANGE, msg);
	return 1;
}

CMD:kickall(playerid, params[]){
    // Jika level admin < 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

	new pesan[256];
	if(sscanf(params, "s[256]", pesan)) return error_syntax(playerid, "/kickall [pesan]");

    foreach(new i : Player){
        // SendMessageToAllAdmin
        if(GetLevelAdminPlayer(i) > 0) {
            format(msg, sizeof(msg), "KICK ALL %s(%d) > All: "SILVER"%s", PlayerInfo[playerid][pPlayerName], playerid, pesan);
            SendClientMessage(i, COLOR_BLUE, msg);
        }else{
            format(msg, sizeof(msg), TAG_ADMIN" "WHITE"Semua pemain telah di kick dari server dengan alasan : "YELLOW"%s "WHITE"!", pesan);
            SendClientMessage(i, COLOR_RED, msg);
            KickEx(i);
        }
    }
	return 1;
}

CMD:jetpack(playerid, params[]){    
    // Jika level admin < 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    SetPlayerSpecialAction(playerid, 2);
    return 1;
}

CMD:spawn(playerid, params[]){
    // Jika level admin < 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id;
	if(sscanf(params, "u", target_id)) return error_syntax(playerid, "/spawn [playerid]");
    SendClientMessage(target_id, COLOR_BLUE, TAG_ADMIN" "WHITE"Anda telah dispawn ulang oleh admin.");
    SpawnPlayer(target_id);
    return 1;
}

CMD:pindahpos(playerid, params[]){
    // Jika level admin < 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;
    
    new Float:x, Float:y, Float:z, Float:a, int, vw;
    if(sscanf(params, "ffffdd", x, y, z, a, int, vw)) return error_syntax(playerid, "/pindahpos [x] [y] [z] [a] [int] [vw]");

    pindahkanPemain(playerid, x, y, z, a, int, vw, true);	
    return 1;
}

CMD:padamkangardu(playerid, params[]){
    // Jika level admin < 2 
    if(GetLevelAdminPlayer(playerid) < 2) return 0;
    if(montirL_GarduStart != -1) 
        DeletePreciseTimer(montirL_GarduStart);
    GarduPadam();
    return 1;
}

CMD:aveh(playerid, params[]){
    // Jika level admin < 2
    if(GetLevelAdminPlayer(playerid) < 2) return 0;

    showDialogAdminVehicle(playerid);
    return 1;
}

CMD:ach(playerid, params[]){
    // Jika level admin < 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;    

    new pesan[144];
	if(sscanf(params, "s[144]", pesan)) return error_syntax(playerid, "/ach [text]");
    format(pesan, sizeof(pesan), "Achat "WHITE"%s(%d): %s", PlayerInfo[playerid][pPlayerName], playerid, pesan);

    foreach(new i : Player){
        if(GetLevelAdminPlayer(i) > 0) SendClientMessage(i, COLOR_RED, pesan);
    }
    return 1;
}

CMD:agiveitem(playerid, params[]){
    // Jika bukan admin level 2
    if(GetLevelAdminPlayer(playerid) < 2) return 0;

    new subString[45];
    static string[MAX_SERVER_ITEM * 45];

    if(string[0] == EOS){
        format(string, sizeof(string), "Kode\tNama\n"WHITE);
        new rows, id_item, nama_item[256];

        inline responseQuery(){
            cache_get_row_count(rows);

            for(new i = 0; i < rows; i++){
                cache_get_value_name_int(i, "id_item", id_item);
                cache_get_value_name(i, "nama_item", nama_item);

                format(subString, sizeof(subString), "%i\t%s\n", id_item, nama_item);
                strcat(string, subString);
            }
            ShowPlayerDialog(playerid, DIALOG_ADMIN_GIVE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Pilih item yang ingin diberi :", string, "Pilih", "Keluar");
        }
        MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT * FROM `item`");
    }else
        ShowPlayerDialog(playerid, DIALOG_ADMIN_GIVE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Pilih item yang ingin diberi :", string, "Pilih", "Keluar");
    return 1;
}

CMD:agivemoney(playerid, params[]){
    // Jika bukan admin level 2
    if(GetLevelAdminPlayer(playerid) < 2) return 0;

    new amount, target_id;
    if(sscanf(params, "ud", target_id, amount)) 
        return error_syntax(playerid, "/agivemoney [id] [jumlah]");
    if(!IsPlayerConnected(target_id) || !PlayerInfo[target_id][sudahLogin])
        return error_command(playerid, "Player yang dimaksud tidak terkoneksi/belum login.");

    sendPesan(playerid, COLOR_BLUE, TAG_ADMIN" "WHITE"Berhasil memberi uang sebesar "GREEN"$%d "WHITE"kepada %s.", amount, PlayerInfo[target_id][pPlayerName]);
    
    sendPesan(target_id, COLOR_BLUE, TAG_ADMIN" "WHITE"Admin telah memberi anda uang sebesar "GREEN"$%d", amount);
    givePlayerUang(target_id, amount);
    return 1;
}

CMD:slap(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id;
    if(sscanf(params, "u", target_id)) return error_syntax(playerid, "/slap [playerid]");
    if(!IsPlayerConnected(target_id) || !PlayerInfo[target_id][sudahSpawn]) return error_command(playerid, "Player yang dituju tidak ada!");

    new Float:pos[3];
    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
    SetPlayerPos(target_id, pos[0], pos[1], pos[2] + 4);
    PlayerPlaySound(target_id, 1130, pos[0], pos[1], pos[2] + 4);

    if(IsPlayerInAnyVehicle(playerid)){
        new const vehicleid = GetPlayerVehicleID(playerid);
        GetVehiclePos(vehicleid, LastVehiclePos[vehicleid][0], LastVehiclePos[vehicleid][1], LastVehiclePos[vehicleid][2]);
        GetVehicleZAngle(vehicleid, LastVehiclePos[vehicleid][3]);
    }

    sendPesan(playerid, COLOR_BLUE, TAG_ADMIN" "WHITE"Anda telah men-slap %s.", PlayerInfo[target_id][pPlayerName]);
    SendClientMessage(target_id, COLOR_BLUE, TAG_ADMIN" "WHITE"Anda telah di slap oleh admin.");
    return 1;
}

CMD:apapan(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    showDialogAdminPapan(playerid);
    return 1;
}

CMD:arumah(playerid, params[]){
    // Jika bukan admin level 2
    if(GetLevelAdminPlayer(playerid) < 2) return 0;

    if(SS_GetPlayerInterior(playerid) != 0 || SS_GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
    ShowPlayerDialog(playerid, DIALOG_ADMIN_RUMAH, DIALOG_STYLE_LIST, WHITE"House Sytem :", "Buat Rumah\nReset Rumah\nHapus Rumah", "Pilih", "Batal");
    return 1;
}

CMD:alumber(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    ShowPlayerDialog(playerid, DIALOG_LUMBER_ADMIN, DIALOG_STYLE_LIST, WHITE"Lumberjack System :", "Buat Pohon\nEdit Pohon\nReset Pohon\nHapus Pohon", "Pilih", "Batal");
    return 1;
}

CMD:aatm(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    ShowPlayerDialog(playerid, DIALOG_ADMIN_ATM, DIALOG_STYLE_LIST, "Menu admin untuk ATM :", "Buat ATM\nEdit ATM\nHapus ATM", "Pilih", "Batal");    
    return 1;
}

CMD:aactor(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    ShowPlayerDialog(playerid, DIALOG_ADMIN_ACTOR, DIALOG_STYLE_LIST, "Menu admin untuk Actor :", "Respawn Actor", "Pilih", "Batal");    
    return 1;
}

CMD:arent(playerid, params[]){
    if(GetLevelAdminPlayer(playerid) < 2) return 0;

    ShowPlayerDialog(playerid, DIALOG_ADMIN_RENT, DIALOG_STYLE_LIST, "Rent System :", "Vehicle", "Pilih", "Batal");
    return 1;
}

CMD:atiang(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    ShowPlayerDialog(playerid, DIALOG_TIANG_ADMIN, DIALOG_STYLE_LIST, WHITE"Tiang System :", "Buat Tiang\nEdit Tiang\nHapus Tiang", "Pilih", "Batal");
    return 1;
}

CMD:setadmin(playerid, params[]){
    // Jika bukan admin level 2
    if(GetLevelAdminPlayer(playerid) < 2 && !IsPlayerAdmin(playerid)) return 0;

    new target_id, level_admin;
    if(sscanf(params, "ui", target_id, level_admin)) return error_syntax(playerid, "/setadmin [id pemain] [level]");
    if(!IsPlayerConnected(target_id) || !PlayerInfo[target_id][sudahLogin] || !PlayerInfo[target_id][sudahSpawn])
        return error_command(playerid, "Id pemain tidak valid.");

    if(level_admin < 0 || level_admin > 2)
        return error_command(playerid, "Invalid level admin, hanya bisa memasukan 0 - 2.");

    PlayerInfo[target_id][levelAdmin] = level_admin;
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET admin_level = %d WHERE id = %d", level_admin, PlayerInfo[target_id][pID]);
    mysql_tquery(koneksi, pQuery[playerid]);
    
    sendPesan(target_id, COLOR_BLUE, TAG_ADMIN" "WHITE"Level admin anda telah diset menjadi "ORANGE"%d "WHITE"oleh %s.", level_admin, PlayerInfo[playerid][pPlayerName]);
    sendPesan(playerid, COLOR_GREEN, TAG_ADMIN" "WHITE"Berhasil mengganti level admin %s menjadi "ORANGE"%d "WHITE".", PlayerInfo[target_id][pPlayerName], level_admin);
    return 1;
}

CMD:reloadsetup(playerid, params[]){
    // Jika bukan admin level 2
    if(GetLevelAdminPlayer(playerid) < 2 && !IsPlayerAdmin(playerid))
        return 0;

    mysql_format(koneksi, sQuery, sizeSQuery, "SELECT * FROM `setup`");
	mysql_tquery(koneksi, sQuery, "loadSetup");
    return 1;
}

CMD:unban(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new username_pemain[MAX_PLAYER_NAME + 1];
    if(sscanf(params, "s[25]", username_pemain)) 
        return error_syntax(playerid, "/unban [username]");

    mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE a FROM user_blocked a INNER JOIN `user` b ON b.id = a.id_user WHERE b.nama = '%e' AND a.jenis_block = 2", username_pemain);
    mysql_tquery(koneksi, pQuery[playerid], "selesaiCekUnban", "is", playerid, username_pemain);
    return 1;
}

CMD:ban(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id, text_temporary[10], lama_hari, status_temp = 0, alasan[50];
    if(sscanf(params, "us[10]is[50]", target_id, text_temporary, lama_hari, alasan)) return error_syntax(playerid, "/ban [id] [permanent/temporary] [banyak hari (jika permanent isi asal)] [alasan]");

    if(!IsPlayerConnected(target_id))
        return error_command(playerid, "Player tidak ada.");

    if(sama("permanent", text_temporary)) status_temp = -1;    
    else if(sama("temporary", text_temporary)) status_temp = 1;
    
    if(status_temp == 0)
        return error_command(playerid, "Pastikan untuk memilih option permanent/temporary.");

    if(status_temp == 1 && lama_hari <= 0)
        return error_command(playerid, "Pastikan untuk memasukan hari yang valid.");

    // Jenis Blocked = 2 (Adalah jenis Banned)
    if(status_temp == 1)
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO user_blocked(id_user, jenis_block, expired, keterangan,happen,id_admin) VALUES(%d, %d, NOW() + INTERVAL %d DAY, '%e', NOW(), %d)", PlayerInfo[target_id][pID], 2, lama_hari, alasan, PlayerInfo[playerid][pID]);
    else
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO user_blocked(id_user, jenis_block, expired, keterangan,happen,id_admin) VALUES(%d, %d, NULL, '%e', NOW(), %d)", PlayerInfo[target_id][pID], 2, alasan, PlayerInfo[playerid][pID]);
    mysql_tquery(koneksi, pQuery[playerid]);

    format(pDialog[playerid], sizePDialog, RED"Anda dibanned oleh admin.\n\n");
    strcatEx(pDialog[playerid], sizePDialog, YELLOW"Dengan keterangan sebagai berikut :\n\n");
    strcatEx(pDialog[playerid], sizePDialog, WHITE"->\tJenis Block \t: "ORANGE"Banned\n");
    
    if(status_temp == 1)
        strcatEx(pDialog[playerid], sizePDialog, WHITE"->\tBerakhir pada \t: "GREEN"%d hari dari sekarang.\n", lama_hari);
    else
        strcatEx(pDialog[playerid], sizePDialog, WHITE"->\tBerakhir pada \t: "ORANGE"Permanen.\n");

    strcatEx(pDialog[playerid], sizePDialog, WHITE"->\tKeterangan \t: "YELLOW"%s\n\n", alasan);
    strcatEx(pDialog[playerid], sizePDialog, YELLOW"Jika anda merasa tidak melakukan pelanggaran rules,\nsilahkan kirimkan "RED"Screenshot "YELLOW"ini ke forum, untuk meminta ban appeal.\n");
    ShowPlayerDialog(target_id, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Dibanned", pDialog[playerid], "Ok", "");	
    KickEx(target_id);

    sendPesan(playerid, COLOR_GREEN, TAG_ADMIN" "WHITE"Berhasil membanned "ORANGE"%s"WHITE", anda memiliki tanggung jawab untuk mengontrol lebih lanjut player ini.");

    new temp_msg[144];
    format(temp_msg, sizeof(temp_msg), TAG_ADMIN" "RED"%s "WHITE"telah "RED"dibanned "WHITE"dari server dengan alasan : "YELLOW"%s "WHITE"!", PlayerInfo[target_id][pPlayerName], alasan);
    SendClientMessageToAll(COLOR_ORANGE, temp_msg);
    return 1;
}

CMD:asay(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new pesan[144];
	if(sscanf(params, "s[144]", pesan)) return error_syntax(playerid, "/asay [text]");
    format(pesan, sizeof(pesan), "Admin: "WHITE"%s", pesan);
    foreach(new i : Player)
        SendClientMessage(i, COLOR_ORANGE, pesan);
    return 1;
}

CMD:setmedic(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id, text_temporary[10], masa_aktif, level, status_temp = 0;
    if(sscanf(params, "us[10]iI(1)", target_id, text_temporary, level, masa_aktif)) return error_syntax(playerid, "/setmedic [id] [permanent/expired] [level] [masa aktif (hari)]");

    if(!IsPlayerConnected(target_id))
        return error_command(playerid, "Player tidak ada");

    if(PlayerInfo[target_id][levelMedic] > 0){
        error_command(playerid, "Pemain sudah menjadi medic.");
        return note_message(playerid, "Jika anda berniat menambah masa aktif. silahkan pecat dahulu, lalu set kembali.");
    }

    if(sama("permanent", text_temporary)) status_temp = -1;    
    else if(sama("expired", text_temporary)) status_temp = 1;
    
    if(status_temp == 0)
        return error_command(playerid, "Pastikan untuk memilih option permanent/expired.");

    if(status_temp == 1 && masa_aktif <= 0)
        return error_command(playerid, "Pastikan untuk memasukan hari yang valid.");

    if(level < 1 || level > sizeof(MEDIC_LEVEL))
        return sendPesan(playerid, COLOR_RED, "* "WHITE"Level medic hanya berkisar antara 1 hingga %d.", sizeof(MEDIC_LEVEL));

    if(status_temp == 1)
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO user_faction(id_faction, id_user, level, expired) VALUES(%d, %d, %d, NOW() + INTERVAL %d DAY)", ID_FACTION_MEDIC, PlayerInfo[target_id][pID], level, masa_aktif);
    else
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO user_faction(id_faction, id_user, level) VALUES(%d, %d, %d)", ID_FACTION_MEDIC, PlayerInfo[target_id][pID], level);
    
    mysql_tquery(koneksi, pQuery[playerid]);
    PlayerInfo[target_id][levelMedic] = level;

    sendPesan(playerid, COLOR_GREEN, TAG_FACTION" "WHITE"Berhasil menjadikan %s(%d) sebagai medic.", PlayerInfo[target_id][pPlayerName], target_id);
    
    if(status_temp == 1)
        sendPesan(target_id, COLOR_GREEN, TAG_FACTION" "WHITE"Kamu telah diangkat menjadi medic dengan level %d selama %d hari kedepan.", level, masa_aktif);
    else
        sendPesan(target_id, COLOR_GREEN, TAG_FACTION" "WHITE"Kamu telah diangkat menjadi medic dengan level %d dengan jangka waktu permanen.", level);

    sendPesan(target_id, COLOR_YELLOW, TAG_NOTE" "WHITE"Anda sekarang dapat bekerja pada rumah sakit sebagai %s.", GetNamaLevelMedic(level));
    return 1;
}

CMD:removemedic(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id;
    if(sscanf(params, "u", target_id)) 
        return error_syntax(playerid, "/removemedic [id]");

    if(!IsPlayerConnected(target_id))
        return error_command(playerid, "Player tidak ada");

    if(PlayerInfo[target_id][levelMedic] == 0)
        return error_command(playerid, "Pemain bukan medic.");

    mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM user_faction WHERE id_user = %d AND id_faction = %d", PlayerInfo[target_id][pID], ID_FACTION_MEDIC);    
    mysql_tquery(koneksi, pQuery[playerid]);

    PlayerInfo[target_id][levelMedic] = 0;

    // Off Duty kan
    if(PlayerInfo[target_id][skinID] != GetPlayerSkin(target_id)){
        ClearAnimations(target_id);
        ubahSkinPemain(target_id, PlayerInfo[target_id][skinID]);
        PlayerInfo[target_id][skinDuty] = 0;
    }
    SetPlayerDutyMedic(target_id, 0);
    SetPlayerColor(target_id, COLOR_WHITE);        

    sendPesan(playerid, COLOR_GREEN, TAG_FACTION" "WHITE"Berhasil memecat medic %s(%d).", PlayerInfo[target_id][pPlayerName], target_id);

    sendPesan(target_id, COLOR_RED, TAG_FACTION" "WHITE"Kamu telah dipecat dari medic.");
    return 1;
}

CMD:setpolice(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id, text_temporary[10], masa_aktif, level, status_temp = 0;
    if(sscanf(params, "us[10]iI(1)", target_id, text_temporary, level, masa_aktif)) return error_syntax(playerid, "/setpolice [id] [permanent/expired] [level] [masa aktif (hari)]");

    if(!IsPlayerConnected(target_id))
        return error_command(playerid, "Player tidak ada");

    if(PlayerInfo[target_id][levelPolice] > 0){
        error_command(playerid, "Pemain sudah menjadi polisi.");
        return note_message(playerid, "Jika anda berniat menambah masa aktif. silahkan pecat dahulu, lalu set kembali.");
    }

    if(sama("permanent", text_temporary)) status_temp = -1;    
    else if(sama("expired", text_temporary)) status_temp = 1;
    
    if(status_temp == 0)
        return error_command(playerid, "Pastikan untuk memilih option permanent/expired.");

    if(status_temp == 1 && masa_aktif <= 0)
        return error_command(playerid, "Pastikan untuk memasukan hari yang valid.");

    if(level < 1 || level > sizeof(POLICE_LEVEL))
        return sendPesan(playerid, COLOR_RED, "* "WHITE"Level polisi hanya berkisar antara 1 hingga %d.", sizeof(POLICE_LEVEL));

    if(status_temp == 1)
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO user_faction(id_faction, id_user, level, expired) VALUES(%d, %d, %d, NOW() + INTERVAL %d DAY)", ID_FACTION_POLISI, PlayerInfo[target_id][pID], level, masa_aktif);
    else
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO user_faction(id_faction, id_user, level) VALUES(%d, %d, %d)", ID_FACTION_POLISI, PlayerInfo[target_id][pID], level);
    
    mysql_tquery(koneksi, pQuery[playerid]);
    PlayerInfo[target_id][levelPolice] = level;

    sendPesan(playerid, COLOR_GREEN, TAG_FACTION" "WHITE"Berhasil menjadikan %s(%d) sebagai polisi.", PlayerInfo[target_id][pPlayerName], target_id);
    
    if(status_temp == 1)
        sendPesan(target_id, COLOR_GREEN, TAG_FACTION" "WHITE"Kamu telah diangkat menjadi polisi dengan level %d selama %d hari kedepan.", level, masa_aktif);
    else
        sendPesan(target_id, COLOR_GREEN, TAG_FACTION" "WHITE"Kamu telah diangkat menjadi polisi dengan level %d dengan jangka waktu permanen.", level);

    sendPesan(target_id, COLOR_YELLOW, TAG_NOTE" "WHITE"Anda sekarang dapat bekerja pada kantor polisi dengan jabatan sebagai %s.", GetNamaLevelPolice(level));
    return 1;
}

CMD:removepolice(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id;
    if(sscanf(params, "u", target_id)) 
        return error_syntax(playerid, "/removepolice [id]");

    if(!IsPlayerConnected(target_id))
        return error_command(playerid, "Player tidak ada");

    if(PlayerInfo[target_id][levelPolice] == 0)
        return error_command(playerid, "Pemain bukan polisi.");

    mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM user_faction WHERE id_user = %d AND id_faction = %d", PlayerInfo[target_id][pID], ID_FACTION_POLISI);    
    mysql_tquery(koneksi, pQuery[playerid]);

    PlayerInfo[target_id][levelPolice] = 0;

    // Off Duty kan
    if(PlayerInfo[target_id][skinID] != GetPlayerSkin(target_id)){
        ClearAnimations(target_id);
        ubahSkinPemain(target_id, PlayerInfo[target_id][skinID]);
        PlayerInfo[target_id][skinDuty] = 0;
    }
    SetPlayerDutyPolice(target_id, 0);
    // ResetPlayerWeapons(target_id);
    SetPlayerColor(target_id, COLOR_WHITE);    

    sendPesan(playerid, COLOR_GREEN, TAG_FACTION" "WHITE"Berhasil memecat polisi %s(%d).", PlayerInfo[target_id][pPlayerName], target_id);

    sendPesan(target_id, COLOR_RED, TAG_FACTION" "WHITE"Kamu telah dipecat dari polisi.");
    return 1;
}

CMD:tele(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id;
    if(sscanf(params, "u", target_id)) 
        return error_syntax(playerid, "/tele [id pemain]");

    if(IsInvalidTargetId(target_id, playerid, TIPE_TARGET_ALLOW_SEKARAT))
        return error_command(playerid, "ID Pemain invalid.");

    new Float:pos[4];
    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);    
    GetPlayerFacingAngle(target_id, pos[3]);

    pindahkanPemain(playerid, pos[0], pos[1] + 0.5, pos[2], pos[3], SS_GetPlayerInterior(target_id), SS_GetPlayerVirtualWorld(target_id), true);
    PlayerInfo[playerid][inHouse] = PlayerInfo[target_id][inHouse];
    sendPesan(playerid, COLOR_BLUE, TAG_ADMIN" "WHITE"Anda berhasil teleport ke posisi %s berada.", PlayerInfo[target_id][pPlayerName]);
    return 1;
}

CMD:showreport(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    SetPVarInt(playerid, "halaman", 0);
    showReportPlayer(playerid);
    return 1;
}

CMD:get(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id;
    if(sscanf(params, "u", target_id)) 
        return error_syntax(playerid, "/get [id pemain]");

    if(IsInvalidTargetId(target_id, playerid, TIPE_TARGET_ALLOW_SEKARAT))
        return error_command(playerid, "ID Pemain invalid.");

    if(PlayerInfo[target_id][inDie])
        return error_command(playerid, "Pemain yang dimaksud sedang sekarat, memindahkannya dapat menyebabkan bug.");

    new Float:pos[4];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);    
    GetPlayerFacingAngle(playerid, pos[3]);

    pindahkanPemain(target_id, pos[0], pos[1] + 0.5, pos[2], pos[3], SS_GetPlayerInterior(playerid), SS_GetPlayerVirtualWorld(playerid), true);

    PlayerInfo[target_id][inHouse] = PlayerInfo[playerid][inHouse];
    
    sendPesan(playerid, COLOR_BLUE, TAG_ADMIN" "WHITE"Berhasil memindahkan %s keposisi anda sekarang.", PlayerInfo[target_id][pPlayerName]);
    
    sendPesan(target_id, COLOR_BLUE, TAG_ADMIN" "WHITE"Anda diteleportkan ke posisi admin %s berada.", PlayerInfo[playerid][pPlayerName]);
    return 1;
}

CMD:pma(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new text[200], targetid;
    if(sscanf(params, "us[144]", targetid, text))
        return error_syntax(playerid, "/pma [id pemain] [text]");

    if(!IsPlayerConnected(targetid) || playerid == targetid)
        return error_command(playerid, "Player tidak valid.");

    new text_to_admin[200];
    format(text_to_admin, 200, "PMA %s(%d) > %s(%d): "SILVER"%s", PlayerInfo[playerid][pPlayerName], playerid, PlayerInfo[targetid][pPlayerName], targetid, text);

    // SendMessageToAllAdmin
    foreach(new i : Player){
        if(GetLevelAdminPlayer(i) > 0) 
            SendClientMessage(i, COLOR_BLUE, text_to_admin);
    }

    format(text, sizeof(text), "PMA "TAG_ADMIN" "WHITE"%s", text);
    SendClientMessage(targetid, COLOR_BLUE, text);
    return 1;
}

CMD:pmall(playerid, params[]){
    // Jika level admin < 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new pesan[256], text[200];
    if(sscanf(params, "s[256]", pesan)) return error_syntax(playerid, "/pmall [pesan]");

    foreach(new i : Player){
        // SendMessageToAllAdmin
        if(GetLevelAdminPlayer(i) > 0) {
            format(text, sizeof(text), "PM ALL %s(%d) > All: "SILVER"%s", PlayerInfo[playerid][pPlayerName], playerid, pesan);
            SendClientMessage(i, COLOR_BLUE, text);
        }else{
            format(text, sizeof(text), "PM ALL "TAG_ADMIN" "WHITE"%s", pesan);
            SendClientMessage(i, COLOR_BLUE, text);
        }
    }
    return 1;
}

CMD:announce(playerid, params[]){
    // Jika level admin < 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new pesan[256], text[256], targetid;
    if(sscanf(params, "us[256]", targetid, text))
        return error_syntax(playerid, "/announce [id pemain] [text]");

    if(!IsPlayerConnected(targetid) || playerid == targetid)
        return error_command(playerid, "Player tidak valid.");

    foreach(new i : Player){
        // SendMessageToAllAdmin
        if(GetLevelAdminPlayer(i) > 0) {
            format(pesan, sizeof(pesan), "ANNOUNCE %s(%d) > %s(%d): "SILVER"%s", PlayerInfo[playerid][pPlayerName], playerid, PlayerInfo[targetid][pPlayerName], targetid, text);
            SendClientMessage(i, COLOR_BLUE, pesan);
        }
    }

    format(pesan, sizeof(pesan), "~b~[ANNOUNCEMENT]~n~~w~%s", text);
    GameTextForPlayer(targetid, pesan, 5000, 3);
    return 1;
}

CMD:announceall(playerid, params[]){
    // Jika level admin < 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new pesan[256], text[200];
    if(sscanf(params, "s[256]", pesan)) return error_syntax(playerid, "/announce [keterangan]");

    foreach(new i : Player){
        // SendMessageToAllAdmin
        if(GetLevelAdminPlayer(i) > 0) {
            format(text, sizeof(text), "ANNOUNCE ALL %s(%d) > All: "SILVER"%s", PlayerInfo[playerid][pPlayerName], playerid, pesan);
            SendClientMessage(i, COLOR_BLUE, text);
        }else{
            format(text, sizeof(text), "~b~[ANNOUNCEMENT]~n~~w~%s", pesan);
            GameTextForPlayer(i, text, 5000, 3);
        }
    }
    return 1;
}

CMD:spec(playerid, params[]) {
	new idtujuan;
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;
	
	if(sscanf(params, "u", idtujuan))
        return error_syntax(playerid, "/spec [id tujuan]");

	if(idtujuan == INVALID_PLAYER_ID || idtujuan == playerid || !IsPlayerConnected(idtujuan))
        return error_command(playerid, "Pemain tujuan tidak valid.");

	if(PlayerInfo[idtujuan][inSpectating] != INVALID_PLAYER_ID)
		return error_command(playerid, "Pemain ini sedang spectator orang lain.");

	if(GetPlayerState(idtujuan) == PLAYER_STATE_WASTED)
        return error_command(playerid, "Pemain tujuan tidak berada dalam kondisi bisa di spec.");

	if(PlayerInfo[playerid][inSpectating] == INVALID_PLAYER_ID){	
        GetPlayerHealth(playerid, PlayerInfo[playerid][lastHp]);
        GetPlayerArmour(playerid, PlayerInfo[playerid][lastArmour]);
        GetPlayerPos(playerid, PlayerInfo[playerid][last_x], PlayerInfo[playerid][last_y], PlayerInfo[playerid][last_z]);
        GetPlayerFacingAngle(playerid, PlayerInfo[playerid][last_a]);

        PlayerInfo[playerid][last_vw] = SS_GetPlayerVirtualWorld(playerid);
		PlayerInfo[playerid][last_int] = SS_GetPlayerInterior(playerid);
        
        TogglePlayerSpectating(playerid, 1);

		SpectatePlayer(playerid, idtujuan);
        sendPesan(playerid, COLOR_PINK, TAG_SPEC" "WHITE"Anda sekarang men-spectator %s.", PlayerInfo[idtujuan][pPlayerName]);

		PlayerInfo[playerid][inSpectating] = idtujuan;
        PlayerInfo[idtujuan][inSpectate] = true;
	} else {
        SpectatePlayer(playerid, idtujuan);
        sendPesan(playerid, COLOR_PINK, TAG_SPEC" "WHITE"Anda sekarang men-spectator %s.", PlayerInfo[idtujuan][pPlayerName]);

        new cnt = 0;
        foreach(new i : Player){
            if(PlayerInfo[i][inSpectating] == PlayerInfo[playerid][inSpectating])
                cnt++;
        }
        if(cnt <= 1)
            PlayerInfo[PlayerInfo[playerid][inSpectating]][inSpectate] = false;

		PlayerInfo[playerid][inSpectating] = idtujuan;
        PlayerInfo[idtujuan][inSpectate] = true;
	}
    return 1;
}

CMD:specoff(playerid, const params[]) {
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

	if(PlayerInfo[playerid][inSpectating] == INVALID_PLAYER_ID)
        return error_command(playerid, "Anda tidak sedang spektator siapapun.");

    new cnt = 0;
    foreach(new i : Player){
        if(PlayerInfo[i][inSpectating] == PlayerInfo[playerid][inSpectating])
            cnt++;
    }
    if(cnt <= 1)
        PlayerInfo[PlayerInfo[playerid][inSpectating]][inSpectate] = false;

    PlayerInfo[playerid][inSpectating] = INVALID_PLAYER_ID;
	TogglePlayerSpectating(playerid, 0);
    PlayerInfo[playerid][sudahSpawn] = false;
    spawnPemain(playerid);
	return 1;
}

/**
    End Admin Command
*/

CMD:report(playerid, params[]){
    new text[200];
    if(sscanf(params, "s[144]", text))
        return error_syntax(playerid, "/report [text]");

    // Jika perbedaan waktu antara last report dan waktu sekarang < 60 detik
    if(gettime() - PlayerInfo[playerid][lastReport] < 60){
        format(text, sizeof(text), "Anda hanya dapat mengirim report 1 menit sekali, anda harus menunggu %d detik lagi!", 60 + PlayerInfo[playerid][lastReport] - gettime());
        return error_command(playerid, text);
    }
    
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO report_log(id_user,text,tanggal) VALUES(%d,'%e',NOW())", PlayerInfo[playerid][pID],text);
    mysql_tquery(koneksi, pQuery[playerid]);

    format(text, sizeof(text), TAG_REPORT" "WHITE"%s(%d): %s", PlayerInfo[playerid][pPlayerName], playerid, text);

    // SendMessageToAllAdmin
    foreach(new i : Player){
        if(GetLevelAdminPlayer(i) > 0) 
            SendClientMessage(i, COLOR_RED, text);
    }

    PlayerInfo[playerid][lastReport] = gettime();
    sendPesan(playerid, COLOR_ORANGE, TAG_REPORT" "WHITE"Berhasil mensubmit report, report akan direview oleh admin.");
    return 1;
}

CMD:ask(playerid, params[]){
    new text[200];
    if(sscanf(params, "s[144]", text))
        return error_syntax(playerid, "/ask [text]");

    // Jika perbedaan waktu antara last report dan waktu sekarang < 5 detik
    if(gettime() - PlayerInfo[playerid][lastAsk] < 5){
        format(text, sizeof(text), "Anda hanya dapat mengirim report 5 detik sekali, anda harus menunggu %d detik lagi!", 5 + PlayerInfo[playerid][lastAsk] - gettime());
        return error_command(playerid, text);
    }
    
    format(text, sizeof(text), TAG_ASK" "WHITE"%s(%d): %s", PlayerInfo[playerid][pPlayerName], playerid, text);

    // SendMessageToAllAdmin
    foreach(new i : Player){
        if(GetLevelAdminPlayer(i) > 0) 
            SendClientMessage(i, COLOR_YELLOW, text);
    }

    PlayerInfo[playerid][lastAsk] = gettime();
    sendPesan(playerid, COLOR_ORANGE, TAG_ASK" "WHITE"Berhasil mensubmit pertanyaan, pertanyaan akan direview oleh admin.");
    return 1;
}

CMD:cook(playerid, params[]){
    if(PlayerInfo[playerid][isBusy]) 
        return error_command(playerid, "Anda sedang melakukan hal lain sekarang.");

    if(!IsPlayerInRangeOfPoint(playerid, 2.5, -794.9869, 2425.4514, 158.1323))
        return error_command(playerid, "Anda harus berada dekat kompor material.");
    
    showDialogMasakTambang(playerid);
    return 1;
}

CMD:bc(playerid, params[]){
    new pesan[256];
    if(PlayerInfo[playerid][ePhone] == 0) 
        return error_command(playerid, "Maaf anda harus menggunakan ponsel terlebih dahulu, untuk dpt menggunakan fitur ini.");
    if(!IsPemainPunyaNomorAktif(playerid)) 
        return error_command(playerid, "Maaf anda harus memiliki nomor hp yang aktif untuk dapat menggunakan fitur ini.");
	if(sscanf(params, "s[256]", pesan)) return error_syntax(playerid, "/bc [pesan]");
    if(gettime() - PlayerInfo[playerid][lastGlobalChat] < (2 * 60)){
        format(msg, sizeof(msg), "Anda hanya dapat mengirim pesan broadcast 2 menit sekali, anda harus menunggu %d detik lagi!", 2 * 60 + PlayerInfo[playerid][lastGlobalChat] - gettime());
        return error_command(playerid, msg);
    }
    format(msg, sizeof(msg), "BC "BLUE"(+%s)"WHITE": %s", PlayerInfo[playerid][nomorHP], pesan);
    SendClientMessageToAll(COLOR_WHITE, msg);
    PlayerInfo[playerid][lastGlobalChat] = gettime();
    return 1;
}

CMD:settings(playerid, params[]){
    format(pDialog[playerid], sizePDialog, "%s HUD Status\n", ((PlayerInfo[playerid][tampilHUDStats]) ? (RED"Sembunyikan") : (GREEN"Tampilkan")));
    strcatEx(pDialog[playerid], sizePDialog, "%s Speedo Kendaraan\n", ((PlayerInfo[playerid][tampilSpeedo]) ? (RED"Sembunyikan") : (GREEN"Tampilkan")));
    strcatEx(pDialog[playerid], sizePDialog, "%s Mode Foto\n", ((PlayerInfo[playerid][photoMode]) ? (RED"Matikan") : (GREEN"Aktifkan")));
    strcatEx(pDialog[playerid], sizePDialog, "%s Tanggal dan Waktu\n", ((PlayerInfo[playerid][tampilJam]) ? (RED"Sembunyikan") : (GREEN"Tampilkan")));    
    ShowPlayerDialog(playerid, DIALOG_PENGATURAN, DIALOG_STYLE_LIST, "Pilihan pengaturan : ", pDialog[playerid], "Pilih", "Batal");
    return 1;
}

CMD:clearchat(playerid, params[]){
    ClearChatEx(playerid);
    return 1;
}

CMD:inventory(playerid, const params[]){
    if(PlayerInfo[playerid][isBusy]) return SendClientMessage(playerid, COLOR_RED, TAG_SIBUK" "WHITE"Tidak dapat membuka inventory sekarang, anda sedang melakukan hal lain.");
    showDialogMenuInventory(playerid);
    return 1;
}

CMD:inv(playerid, params[]){
    return cmd_inventory(playerid, "");
}

CMD:stats(playerid, params[]){
    ShowPlayerDialog(playerid, DIALOG_INFO_SAYA, DIALOG_STYLE_LIST, "Pilihan Info : ", "Skill\nInformasi Pribadi", "Pilih", "Batal");
    return 1;
}

CMD:skill(playerid, const params[]){
    if(PlayerInfo[playerid][isBusy]) return SendClientMessage(playerid, COLOR_RED, TAG_SIBUK" "WHITE"Tidak dapat menggunakan skill sekarang, anda sedang melakukan hal lain.");
    ShowPlayerDialog(playerid, DIALOG_MENU_SKILL, DIALOG_STYLE_LIST, "Skill", "Mekanik\nMedic\nBlacksmith", "Pilih", "Batal");
    return 1;
}

CMD:v(playerid, const params[]){
    if(!IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda tidak dapat menggunakan perintah ini saat tidak di dalam kendaraan.");

    new vehid = GetPlayerVehicleID(playerid),
        string[300];

    if(Iter_Contains(IDVehToPVehIterator, vehid)){
        strcat(string, WHITE"Info kendaraan");
    }
    
    if(GetVehicleParams(vehid, VEHICLE_TYPE_BONNET))
        strcat(string, "\n"RED"Tutup kap depan");
    else
        strcat(string, "\n"GREEN"Buka kap depan");
    
    if(GetVehicleParams(vehid, VEHICLE_TYPE_BOOT))
        strcat(string, "\n"RED"Tutup bagasi belakang");
    else
        strcat(string, "\n"GREEN"Buka bagasi belakang");

    ShowPlayerDialog(playerid, DIALOG_MENU_DALAM_VEHICLE, DIALOG_STYLE_LIST, "Pilih aksi :", string, "Pilih", "Batal");
    return 1;
}

CMD:vehicle(playerid, params[]){
    return cmd_v(playerid, "");
}

CMD:pm(playerid, params[]){
    new string[256], pesan[200], target_id;
    if(PlayerInfo[playerid][ePhone] == 0) return error_command(playerid, "Maaf anda harus menggunakan ponsel terlebih dahulu, untuk dpt menggunakan fitur ini.");
    if(!IsPemainPunyaNomorAktif(playerid)) return error_command(playerid, "Maaf anda harus memiliki nomor hp yang aktif untuk dapat menggunakan fitur ini.");
    if(sscanf(params, "us[200]", target_id, pesan)) return error_syntax(playerid, "/pm [playerid] [pesan]");
    if(!IsPlayerConnected(target_id)) return error_command(playerid, "Maaf pemain dengan id tersebut tidak ada / tidak terkoneksi!");
    if(playerid == target_id) return error_command(playerid, "Maaf anda tidak dapat mengirim pesan kepada diri sendiri!");
    if(PlayerInfo[target_id][ePhone] == 0) return error_command(playerid, "Maaf pemain yang anda tuju harus menggunakan ponsel terlebih dahulu agar dapat menerima pm.");
    if(!IsPemainPunyaNomorAktif(target_id)) return error_command(playerid, "Maaf pemain yang anda tuju harus memiliki nomor HP yang aktif.");


    format(string, sizeof(string), "**[PM] (%d)%s : %s", playerid, PlayerInfo[playerid][pPlayerName], pesan);
    SendClientMessage(target_id, COLOR_YELLOW, string);
    if(PlayerInfo[target_id][reply] != playerid) PlayerInfo[target_id][reply] = playerid;

    format(string, sizeof(string), ">>[PM] (%d)%s : %s", target_id, PlayerInfo[target_id][pPlayerName], pesan);
    SendClientMessage(playerid, COLOR_ORANGE, string);
    return 1;
}

CMD:r(playerid, params[]){
    new string[256], pesan[200];
    if(PlayerInfo[playerid][ePhone] == 0) return error_command(playerid, "Maaf anda harus menggunakan ponsel terlebih dahulu, untuk dpt menggunakan fitur ini.");
    if(!IsPemainPunyaNomorAktif(playerid)) return error_command(playerid, "Maaf anda harus memiliki nomor hp yang aktif untuk dapat menggunakan fitur ini.");
    if(sscanf(params, "s[200]", pesan)) return error_syntax(playerid, "/r [pesan]");
    if(PlayerInfo[playerid][reply] == -1) return error_command(playerid, "Maaf anda tidak memiliki pm yang dapat dibalas!");

    new target_id = PlayerInfo[playerid][reply];

    if(!IsPlayerConnected(target_id)){
        PlayerInfo[playerid][reply] = -1;
        return error_command(playerid, "Maaf pemain yang ingin direply tersebut tidak ada / tidak terkoneksi!");
    }
    if(PlayerInfo[target_id][ePhone] == 0) return error_command(playerid, "Maaf pemain yang anda tuju harus menggunakan ponsel terlebih dahulu agar dapat menerima pm.");
    if(!IsPemainPunyaNomorAktif(target_id)) return error_command(playerid, "Maaf pemain yang anda tuju harus memiliki nomor HP yang aktif.");

    format(string, sizeof(string), "**[PM] (%d)%s : %s", playerid, PlayerInfo[playerid][pPlayerName], pesan);
    SendClientMessage(target_id, COLOR_YELLOW, string);
    if(PlayerInfo[target_id][reply] != playerid) PlayerInfo[target_id][reply] = playerid;

    format(string, sizeof(string), ">>[PM] (%d)%s : %s", target_id, PlayerInfo[target_id][pPlayerName], pesan);
    SendClientMessage(playerid, COLOR_ORANGE, string);
    return 1;
}

CMD:ephone(playerid, const params[]){
    if(PlayerInfo[playerid][ePhone] == 0) return error_command(playerid, "Maaf anda harus menggunakan ponsel terlebih dahulu, untuk dpt menggunakan fitur ini.");
    if(PlayerInfo[playerid][isBusy]) return SendClientMessage(playerid, COLOR_RED, TAG_SIBUK" "WHITE"Tidak dapat membuka HP sekarang, anda sedang melakukan hal lain.");
    showDialogEPhone(playerid);
    return 1;
}

CMD:suicide(playerid, params[]){
    SetPlayerHealth(playerid, 0.0);
    return 1;
}

CMD:house(playerid, params[]){
    if(SS_GetPlayerInterior(playerid) == 0 || PlayerInfo[playerid][inHouse] == 0) 
        return error_command(playerid, "Anda tidak di dalam rumah manapun.");
    if(houseInfo[PlayerInfo[playerid][inHouse]][hOwner] != PlayerInfo[playerid][pID]) 
        return error_command(playerid, "Anda bukan pemilik rumah.");
    ShowPlayerDialog(playerid, DIALOG_MENU_RUMAH, DIALOG_STYLE_LIST, "Menu Rumah : ", "Inventory Rumah\nSemua Furniture", "Pilih", "Tutup");
    return 1;
}

CMD:houseinfo(playerid, const params[]){
    if(lastHousePickup[playerid] == -1) return error_command(playerid, "Maaf anda tidak berada di ikon rumah!");
    new string[256], id, Float:x, Float:y, Float:z;
    id = houseId[lastHousePickup[playerid]];
    x = houseInfo[id][icon_x];
    y = houseInfo[id][icon_y];
    z = houseInfo[id][icon_z];
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return error_command(playerid, "Maaf anda tidak berada di ikon rumah!");
    if(trashM_Job[playerid] == 1 && trashM_House[playerid] == id){
        SetPVarString(playerid, "info_rumah", "trashM_rumah");
        format(string, sizeof(string), "Tentang Rumah\nAmbil Sampah");
    }else if(pizza_Job[playerid] == 1 && pizza_House[playerid] == id){
        SetPVarString(playerid, "info_rumah", "pizza_rumah");
        format(string, sizeof(string), "Tentang Rumah\nTaruh Pizza");
    }else{
        if(houseInfo[id][hOwner] == PlayerInfo[playerid][pID]){
            new upgradeRate = houseInfo[id][hLevel] * HARGA_UPGRADE_RUMAH_PER_LEVEL;
            if(houseInfo[id][hJual] == 1){
                SetPVarString(playerid, "info_rumah", "batal_jual");
                if(houseInfo[id][hLevel] < MAX_HOUSES_LEVEL){
                    if(houseInfo[id][hKunci] == 1){
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (%d)\nBatal Kunci Rumah\nMasuk Rumah", upgradeRate);
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (%d)\nBatal Kunci Rumah\nMasuk Rumah", upgradeRate);
                        }
                    }else{
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (%d)\nKunci Rumah\nMasuk Rumah", upgradeRate);
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (%d)\nKunci Rumah\nMasuk Rumah", upgradeRate);
                        }
                    }
                }else{
                    if(houseInfo[id][hKunci] == 1){
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (Maksimal)\nBatal Kunci Rumah\nMasuk Rumah");
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (Maksimal)\nBatal Kunci Rumah\nMasuk Rumah");
                        }
                    }else{
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (Maksimal)\nKunci Rumah\nMasuk Rumah");
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (Maksimal)\nKunci Rumah\nMasuk Rumah");
                        }
                    }
                }
            }else{
                SetPVarString(playerid, "info_rumah", "jual_rumah");
                if(houseInfo[id][hLevel] < MAX_HOUSES_LEVEL){
                    if(houseInfo[id][hKunci] == 1){
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (%d)\nBatal Kunci Rumah\nMasuk Rumah", upgradeRate);
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (%d)\nBatal Kunci Rumah\nMasuk Rumah", upgradeRate);
                        }
                    }else{
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (%d)\nKunci Rumah\nMasuk Rumah", upgradeRate);
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (%d)\nKunci Rumah\nMasuk Rumah", upgradeRate);
                        }
                    }
                }else{
                    if(houseInfo[id][hKunci] == 1){
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (Maksimal)\nBatal Kunci Rumah\nMasuk Rumah");
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (Maksimal)\nBatal Kunci Rumah\nMasuk Rumah");
                        }
                    }else{
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (Maksimal)\nKunci Rumah\nMasuk Rumah");
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (Maksimal)\nKunci Rumah\nMasuk Rumah");
                        }
                    }
                }
            }
        }else{
            if(houseInfo[id][hJual] == 1){
                SetPVarString(playerid, "info_rumah", "beli_rumah");
                format(string, sizeof(string), "Tentang Rumah\nBeli Rumah\nMasuk Rumah");
            }else{
                SetPVarString(playerid, "info_rumah", "masuk_rumah");
                format(string, sizeof(string), "Tentang Rumah\nMasuk Rumah");
            }
        }
    }
    ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_LIST, WHITE"Info Rumah :", string, "Pilih", "Batal");
    return 1;
}

CMD:lumberjack(playerid, const params[]){
    ShowPlayerDialog(playerid, DIALOG_LUMBER, DIALOG_STYLE_LIST, WHITE"Lumberjack System :", "Cari Pohon\nPotong Pohon\nPindahkan Pohon\nTurunkan Pohon\nCek Muatan Pohon\nTempat Pemotongan Pohon", "Pilih", "Batal");
    return 1;
}

CMD:trashmaster(playerid, const params[]){
    if(trashM_Job[playerid] != 1) return error_command(playerid, "Anda bukan pengangkut sampah dan tidak dapat menggunakan perintah ini.");
    ShowPlayerDialog(playerid, DIALOG_JOB_TRASHMASTER_CMD, DIALOG_STYLE_LIST, WHITE"Trashmaster Job :", "Angkut Sampah\nCek Muatan Sampah\nSelesai Bekerja", "Pilih", "Batal");
    return 1;
}

CMD:pizzaboy(playerid, const params[]){
    if(pizza_Job[playerid] != 1) return error_command(playerid, "Anda bukan pengantar pizza dan tidak dapat menggunakan perintah ini.");
    ShowPlayerDialog(playerid, DIALOG_JOB_PIZZABOY_CMD, DIALOG_STYLE_LIST, WHITE"Pizzaboy Job :", "Restok Pizza\nAmbil Pizza\nCek Muatan Pizza\nSelesai Bekerja", "Pilih", "Batal");
    return 1;
}

CMD:electrician(playerid, const params[]){
    if(montirL_Job[playerid] == 0) 
        return error_command(playerid, "Anda bukan Electrician dan tidak dapat menggunakan perintah ini.");

    if(PlayerInfo[playerid][isBusy])
        return error_command(playerid, "Anda tidak dapat menggunakan perintah ini sekarang.");
        
    if(montirL_GarduPadamEvent){
        ShowPlayerDialog(playerid, 
            DIALOG_JOB_MONTIR_LISTRIK_CMD, 
            DIALOG_STYLE_LIST, 
            WHITE"Electrician Job :", 
            WHITE"Ambil Alat\n\
            "WHITE"Perbaiki\n\
            "WHITE"Taruh Alat\n\
            "GREEN"Join Tim Gardu\n\
            "WHITE"Selesai Bekerja", 
            "Pilih", 
            "Batal"
        );
    }else{
        ShowPlayerDialog(playerid, 
            DIALOG_JOB_MONTIR_LISTRIK_CMD, 
            DIALOG_STYLE_LIST, 
            WHITE"Electrician Job :", 
            WHITE"Ambil Alat\n\
            "WHITE"Perbaiki\n\
            "WHITE"Taruh Alat\n\
            "RED"Join Tim Gardu\n\
            "WHITE"Selesai Bekerja", 
            "Pilih", 
            "Batal"
        );
    }
    return 1;
}

CMD:cancelfix(playerid, const params[]){
    if(montirL_Job[playerid] != 3)
        return error_command(playerid, "Anda tidak sedang dalam keadaan memperbaiki.");
    
	SetPlayerAttachedObject(playerid, ALAT_ATTACH_INDEX, 11745, 6, 0.222, 0.024, 0.128, 1.90, -90.0, 0.0, 0.8, 0.8, 0.8);
    SendClientMessage(playerid, COLOR_GREEN, TAG_JOB" "WHITE"Anda membatalkan keadaan bersiap.");

    montirL_Job[playerid] = 2;
    PlayerInfo[playerid][isOnAnimation] = true;
    PlayerInfo[playerid][isBusy] = true;
    ClearAnimations(playerid);
    return 1;
}

CMD:dig(playerid, params[]){
    if(!IsPlayerInAnyDynamicArea(playerid) || !GetPVarType(playerid, "last_area"))
        return error_command(playerid, "Hanya dapat menggali/menambang pada area pertambangan.");

    if(PlayerInfo[playerid][sisaPalu] <= 0)
        return error_command(playerid, "Anda membutuhkan cangkul/palu tambang untuk menggali");

    if(PlayerInfo[playerid][isBusy]) 
        return error_command(playerid, "Anda sedang melakukan hal lain sekarang.");

    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        return error_command(playerid, "Anda harus berjalan kaki untuk dapat melakukan hal ini."); 

    if(getStatusMakanPemain(playerid) <= 15.0) 
        return error_command(playerid, "Anda kelaparan, silahkan makan terlebih dahulu untuk dapat bekerja kembali.");

    if(getStatusEnergiPemain(playerid) < STATUS_ENERGI_BERKURANG_SAAT_NAMBANG) 
        return error_command(playerid, "Anda kehabisan energi, silahkan istirahat untuk mengisinya.");

    static const kapasitas_unpredict = 5; // Asumsikan dia mendapatkan item dengan kapasitas terbesar yang bisa didapat pada tambang yaitu 5 (berlian)
    if(GetSlotInventoryPlayer(playerid) + kapasitas_unpredict > PlayerInfo[playerid][limitItem]){	
        return server_message(playerid, "Anda tidak memiliki cukup ruang pada inventory, kosongkan minimal 5 slot.");
    }

    new dari_tambang;
    if(GetPVarInt(playerid, "last_area") == AREA_bisaNambang){
        dari_tambang = 1;
    }else if(GetPVarInt(playerid, "last_area") >= AREA_Tambang[0] && GetPVarInt(playerid, "last_area") <= AREA_Tambang[sizeof(AREA_Tambang) - 1]){
        dari_tambang = 0;
    }else{
        return error_command(playerid, "Hanya dapat menggali/menambang pada area pertambangan.");
    }

    // Pinjam timer perbaiki
    if(PerbaikiTimer[playerid] != -1)
        DeletePreciseTimer(PerbaikiTimer[playerid]);
    PerbaikiTimer[playerid] = SetPreciseTimer("progressNambang", 1000, true, "ii", playerid, dari_tambang);

    PlayerInfo[playerid][ach_Bertambang]++;

    // Pinjam progress bar dari potong pohon
    SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
    ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
    TogglePlayerControllable(playerid, 0);
    GameTextForPlayer(playerid, "~w~Sedang ~y~menambang...", 3000, 3);
    SetPlayerArmedWeapon(playerid, 0);
    SetPlayerAttachedObject(playerid, MINING_ATTACH_INDEX, 19631, 6, 0.048, 0.029, 0.103, -80.0, 80.0, 0.0);
    ApplyAnimation(playerid, "CHAINSAW", "CSAW_1", 4.1, 1, 0, 0, 1, 0, 1);
    PlayerInfo[playerid][isOnAnimation] = true;	
    PlayerInfo[playerid][isBusy] = true;
    return 1;
}

CMD:farm(playerid, params[]){
    ShowPlayerDialog(playerid, DIALOG_FARM, DIALOG_STYLE_LIST, WHITE"Farm System :", "Panen Tanaman", "Pilih", "Batal");
    return 1;
}

CMD:fishing(playerid, params[]){
    ShowPlayerDialog(playerid, DIALOG_FISHING, DIALOG_STYLE_LIST, WHITE"Fishing System :", "Mancing Ikan\nToko Peralatan Pancing", "Pilih", "Batal");
    return 1;
}

CMD:givemoney(playerid, params[]){
    new target_id, nominal;
    if(sscanf(params, "ii", target_id, nominal)) return error_syntax(playerid, "/givemoney [id pemain] [nominal]");
    if(!IsPlayerConnected(target_id) || target_id == INVALID_PLAYER_ID || target_id == playerid) return server_message(playerid, "ID pemain yang anda masukan tidak valid.");

    // Cek jarak pemain
    new Float:pos[3];
    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
    if(!IsPlayerInRangeOfPoint(playerid, 2.0, pos[0], pos[1], pos[2]))
        return server_message(playerid, "Pemain yang ingin diberi harus berada disekitar anda.");

    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || GetPlayerState(target_id) != PLAYER_STATE_ONFOOT)
        return server_message(playerid, "Anda ataupun pemain yang ingin diberi harus sedang berjalan kaki.");
    
    if(nominal <= 0 || nominal > MAXIMAL_MONEY_TRADE) 
        return server_message(playerid, "Minimal pemberian uang adalah 1 hingga 9999999.");
    
    if(getUangPlayer(playerid) < nominal)
        return server_message(playerid, "Uang anda tidak mencukupi dengan nominal yang dimasukan.");
    
    givePlayerUang(playerid, -nominal);
    givePlayerUang(target_id, nominal);

    PlayerGivesAnimation(playerid);
    PlayerTakesAnimation(target_id); 

    sendPesan(target_id, COLOR_GREEN, "Uang: "WHITE"Anda telah menerima uang dari "ORANGE"%s "WHITE"sebanyak "GREEN"$%d", PlayerInfo[playerid][pPlayerName], nominal);

    sendPesan(playerid, COLOR_ORANGE, "Uang: "WHITE"Berhasil memberi uang ke "ORANGE"%s "WHITE"sebanyak "GREEN"$%d", PlayerInfo[target_id][pPlayerName], nominal);
    return 1;
}

/*
 * Lepas Helm Dan Mask
 */
CMD:removehelmet(playerid, params[]){
    if(!PlayerInfo[playerid][isOnMask]) return server_message(playerid, "Anda tidak sedang menggunakan helm.");
    if(!IsMaskOrHelmet(PlayerInfo[playerid][isOnMask])){
        /* Reset Jika iditem tidak valid */
        PlayerInfo[playerid][isOnMask] = 0;
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET on_mask = 0 WHERE id = %d", PlayerInfo[playerid][pID]);
        mysql_tquery(koneksi, pQuery[playerid]);
        return server_message(playerid, "Anda tidak sedang menggunakan helm.");
    }
    tambahItemPlayer(playerid, PlayerInfo[playerid][isOnMask], 1);
    
    if(PlayerInfo[playerid][tidak_dikenali] != 0)
        Iter_Remove(TidakDikenali, PlayerInfo[playerid][tidak_dikenali]);
    PlayerInfo[playerid][tidak_dikenali] = 0;

    PlayerInfo[playerid][isOnMask] = 0;
    RemovePlayerAttachedObject(playerid, MASK_ATTACH_INDEX); // Lepas Object
    ShowPlayerMarker(playerid);

    mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET on_mask = 0 WHERE id = %d", PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid]);

    SendClientMessage(playerid, COLOR_PINK, "* Berhasil melepas helm");
    return 1;
}

CMD:removemask(playerid, params[]){
    if(!PlayerInfo[playerid][isOnMask]) return server_message(playerid, "Anda tidak sedang menggunakan topeng.");
    if(!IsMaskOrHelmet(PlayerInfo[playerid][isOnMask])){
        /* Reset Jika iditem tidak valid */
        PlayerInfo[playerid][isOnMask] = 0;
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET on_mask = 0 WHERE id = %d", PlayerInfo[playerid][pID]);
        mysql_tquery(koneksi, pQuery[playerid]);
        return server_message(playerid, "Anda tidak sedang menggunakan topeng.");
    }
    tambahItemPlayer(playerid, PlayerInfo[playerid][isOnMask], 1);

    if(PlayerInfo[playerid][tidak_dikenali] != 0)
        Iter_Remove(TidakDikenali, PlayerInfo[playerid][tidak_dikenali]);
    PlayerInfo[playerid][tidak_dikenali] = 0;

    PlayerInfo[playerid][isOnMask] = 0;
    RemovePlayerAttachedObject(playerid, MASK_ATTACH_INDEX); // Lepas Object
    ShowPlayerMarker(playerid);

    mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET on_mask = 0 WHERE id = %d", PlayerInfo[playerid][pID]);
	mysql_tquery(koneksi, pQuery[playerid]);

    SendClientMessage(playerid, COLOR_PINK, "* Berhasil melepas topeng");
    return 1;
}
/**
 * End Lepas Helm dan Mask
 */

CMD:removeweapon(playerid, params[]){
    if(PlayerInfo[playerid][usedWeapon] == 0)
        return error_command(playerid, "Anda tidak sedang menggunakan senjata.");
    
	new weaponid = getWeaponIdByItemId(PlayerInfo[playerid][usedWeapon]);
	if(weaponid == -1)
		return error_command(playerid, "Terjadi kesalahan saat proses. Silahkan coba lagi.");
	
	new ammoid = getAmmoIdByIdItemWeapon(PlayerInfo[playerid][usedWeapon]);
	if(ammoid == -1)
		return error_command(playerid, "Terjadi kesalahan saat proses. Silahkan coba lagi.");

	tambahItemPlayer(playerid, PlayerInfo[playerid][usedWeapon], 1);
    if(PlayerInfo[playerid][usedAmmo] > 0)
        tambahItemPlayer(playerid, ammoid, PlayerInfo[playerid][usedAmmo]);
    PlayerInfo[playerid][usedWeaponId] = 0;
    PlayerInfo[playerid][usedWeapon] = 0;
    PlayerInfo[playerid][usedAmmo] = 0;
    ResetPlayerWeapons(playerid);
    return 1;
}

CMD:call(playerid, params[])
{
	new number;
    if(sscanf(params, "i", number)) 
        return error_syntax(playerid, "/call [nomor]");
    // if(PlayerInfo[playerid][ePhone] == 0) return error_command(playerid, "Maaf anda harus menggunakan ponsel terlebih dahulu, untuk dpt menggunakan fitur ini.");
    // if(!IsPemainPunyaNomorAktif(playerid)) return error_command(playerid, "Maaf anda harus memiliki nomor hp yang aktif untuk dapat menggunakan fitur ini.");
	// if(number == PlayerInfo[playerid][nomorHP]) return error_command(playerid, "Tidak dapat melakukan panggilan ke nomor hp pribadi.");
    if(number == 123){
        format(pDialog[playerid], sizePDialog, WHITE"Nomor Resmi yang tersedia :\n123 - Pusat Bantuan Panggilan\n911 - Panggilan Darurat (Medis/Polisi)");
        ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Pusat Bantuan Panggilan", pDialog[playerid], "Ok", "");	
		return 1;
	}else if(number == 911){
        ShowPlayerDialog(playerid, DIALOG_PANGGIL_DARURAT, DIALOG_STYLE_LIST, WHITE"Panggilan Darurat :", "Medis\nPolisi", "Pilih", "Batal");
		return 1;
	}else{
        error_command(playerid, "Maaf nomor yang anda tuju tidak tersedia.");
    }
	return 1;
}

// CMD:panggilmedis(playerid, params[]){
//     if(!PlayerInfo[playerid][inDie])
//         return error_command(playerid, "Anda tidak sedang sekarat.");

//     new pesan[144];
//     format(pesan, sizeof(pesan), TAG_MEDIC" "WHITE"%s(%d) sedang sekarat dan membutuhkan bantuan. Ketik /showpatientlocation %d untuk menandai marker.", PlayerInfo[playerid][pPlayerName], playerid);
//     new online_medic = SendMessageToDutyMedic(COLOR_RED, pesan);

//     if(!online_medic)
//         return SendClientMessage(playerid, COLOR_RED, TAG_MEDIC" "WHITE"Tidak ada medis yang sedang bertugas saat ini.");

//     return SendClientMessage(playerid, COLOR_MEDIC, TAG_MEDIC" "WHITE"Berhasil mengirim pesan ke medis, tunggu beberapa saat..");
// }

CMD:showpatientlocation(playerid, params[]){
    if(!IsPlayerOnDutyMedic(playerid)) 
        return error_command(playerid, "Anda tidak sedang bertugas sebagai medis.");
    
    new target_id;
    if(sscanf(params, "u", target_id)) 
        return error_syntax(playerid, "/showpatientlocation [id pemain]");

    if(IsInvalidTargetId(target_id, playerid, TIPE_TARGET_ALLOW_SEKARAT))
        return error_command(playerid, "Id pemain tujuan tidak valid.");
    
    if(PlayerInfo[target_id][inDie] < 1)
        return error_command(playerid, "Pemain tidak sedang sekarat.");

    new Float:pos[3];
    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
    SetPlayerCheckpoint(playerid, pos[0], pos[1], pos[2], 3.0);
    PlayerInfo[playerid][activeMarker] = true;
    return 1;
}

CMD:showvictimlocation(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid)) 
        return error_command(playerid, "Anda tidak sedang bertugas sebagai polisi.");
    
    new target_id;
    if(sscanf(params, "u", target_id)) 
        return error_syntax(playerid, "/showvictimlocation [id pemain]");

    if(IsInvalidTargetId(target_id, playerid))
        return error_command(playerid, "Id pemain tujuan tidak valid.");
    
    if(PlayerInfo[target_id][inHelp] < 1)
        return error_command(playerid, "Pemain tidak sedang meminta bantuan.");

    new Float:pos[3];
    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
    SetPlayerCheckpoint(playerid, pos[0], pos[1], pos[2], 3.0);
    PlayerInfo[playerid][activeMarker] = true;
    return 1;
}

CMD:close(playerid, params[]){
    new text[50];
    if(sscanf(params, "s[50]", text)) 
        return error_syntax(playerid, "/close [object]");

    if(sama(text, "prison", true) && IsPlayerOnDutyPolice(playerid)){
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 78.43640, 1001.26233)){
            tutupPintuPenjara(pintuPenjara[0]);
        }else if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 82.96240, 1001.26233)){
            tutupPintuPenjara(pintuPenjara[1]);
        }else if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 87.48840, 1001.26233)){
            tutupPintuPenjara(pintuPenjara[2]);
        }
    }else if(sama(text, "trunk", true)){
        new vehid = INVALID_VEHICLE_ID;
        new Float:vpos[3];

        foreach(new vid : Vehicle){
            if(!IsValidVehicle(vid)) continue;
            if(GetVehicleBoot(vid, vpos[0], vpos[1], vpos[2])){
                if(IsPlayerInRangeOfPoint(playerid, 1.5, vpos[0], vpos[1], vpos[2])){
                    vehid = vid;
                    break;
                }
            }
        }
        
        if(vehid == INVALID_VEHICLE_ID) 
            return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Anda harus berada pada bagian belakang kendaraan yang ingin dibuka bagasinya.");
		
        if(!GetVehicleParams(vehid, VEHICLE_TYPE_BOOT)) 
            return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Bagasi tidak dalam keadaan terbuka.");
		
        SetVehicleParams(vehid, VEHICLE_TYPE_BOOT, 0);
        SendClientMessage(playerid, COLOR_LIGHT_BLUE, TAG_KENDARAAN" "WHITE"Berhasil menutup bagasi kendaraan ini.");
    }else
        return 0;
    return 1;
}

CMD:open(playerid, params[]){
    new text[50];
    if(sscanf(params, "s[50]", text))
        return error_syntax(playerid, "/open [object]");

    if(sama(text, "prison", true) && IsPlayerOnDutyPolice(playerid)){
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 78.43640, 1001.26233)){
            bukaPintuPenjara(pintuPenjara[0]);
        }else if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 82.96240, 1001.26233)){
            bukaPintuPenjara(pintuPenjara[1]);
        }else if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 87.48840, 1001.26233)){
            bukaPintuPenjara(pintuPenjara[2]);
        }
    }else if(sama(text, "trunk", true)){
        new vehid = INVALID_VEHICLE_ID;
        new Float:vpos[3];

        foreach(new vid : Vehicle){
            if(!IsValidVehicle(vid)) continue;
            if(GetVehicleBoot(vid, vpos[0], vpos[1], vpos[2])){
                if(IsPlayerInRangeOfPoint(playerid, 1.5, vpos[0], vpos[1], vpos[2])){
                    vehid = vid;
                    break;
                }
            }
        }
        
        if(vehid == INVALID_VEHICLE_ID) 
            return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Anda harus berada pada bagian belakang kendaraan yang ingin dibuka bagasinya.");

        if(GetVehicleLimitItemByModel(GetVehicleModel(vehid)) == 0)
            return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Kendaraan jenis ini tidak memiliki bagasi.");
		
        if(!Iter_Contains(IDVehToPVehIterator, vehid)) 
            return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Kendaraan tidak mempunyai bagasi, karena tidak berpemilik.");

        if(!GetVehicleParams(vehid, VEHICLE_TYPE_BOOT)) 
            return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Buka bagasi kendaraan terlebih dahulu.");
        
        SetPVarInt(playerid, "inventory_vehicle", vehid);
        new slot_terpakai = GetSlotInventoryVehicle(vehid),
            kapasitas = GetVehicleLimitItemByModel(GetVehicleModel(vehid));

        if(slot_terpakai >= kapasitas)
            format(pDialog[playerid], sizePDialog, WHITE"Ambil Item\n"WHITE"Simpan Item "RED"(%d/%d)", slot_terpakai, kapasitas);
        else
            format(pDialog[playerid], sizePDialog, WHITE"Ambil Item\n"WHITE"Simpan Item "GREEN"(%d/%d)", slot_terpakai, kapasitas);

        ShowPlayerDialog(playerid, DIALOG_OPTION_INVENTORY_VEHICLE, DIALOG_STYLE_LIST, "Option Inventory Vehicle.", pDialog[playerid], "Ok", "Batal");
    }else
        return error_command(playerid, "Aksi tidak ditemukan.");
    return 1;
}

CMD:jail(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid))
        return SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Anda tidak memiliki otoritas.");

    new target_id,
        lama_penjara,
        alasan[50],
        Float:pos[3];
    if(sscanf(params, "uis[50]", target_id, lama_penjara, alasan))
        return error_syntax(playerid, "/jail [id target] [lama detik] [alasan]");
    
    if(!IsPlayerConnected(target_id))
        return error_command(playerid, "Pemain yang dimaksud tidak ada.");
    if(lama_penjara < 1 || lama_penjara > 3600)
        return error_command(playerid, "Minimal waktu penjara adalah 1 detik dan maksimal 3600 detik (1 jam).");

    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
    if(!IsPlayerInRangeOfPoint(playerid, 2.0, pos[0], pos[1], pos[2]))
        return error_command(playerid, "Pemain yang di maksud tidak berada didekat anda.");
    
    PlayerInfo[target_id][inPenjara] = lama_penjara;
    sendPesan(target_id, COLOR_POLISI, TAG_POLICE" "WHITE"Anda ditetapkan sebagai tahanan oleh %s.", PlayerInfo[playerid][pPlayerName]);
    sendPesan(target_id, COLOR_POLISI, TAG_POLICE" "WHITE"Lama waktu penahanan "RED"%d "WHITE"detik dengan alasan %s.", lama_penjara, alasan);

    sendPesan(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil menahan %s dengan masa tahanan %d detik.", PlayerInfo[target_id][pPlayerName], lama_penjara);
    sendPesan(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Dan alasan penahanan %s.", alasan);
    return 1;
}

CMD:removejail(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid))
        return SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Anda tidak memiliki otoritas.");

    new target_id,
        alasan[50],
        Float:pos[3];
    if(sscanf(params, "us[50]", target_id, alasan))
        return error_syntax(playerid, "/removejail [id target] [alasan]");
    
    if(!IsPlayerConnected(target_id))
        return error_command(playerid, "Pemain yang dimaksud tidak ada.");

    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
    if(!IsPlayerInRangeOfPoint(playerid, 2.0, pos[0], pos[1], pos[2]))
        return error_command(playerid, "Pemain yang di maksud tidak berada didekat anda.");
    
    PlayerInfo[target_id][inPenjara] = 0;
    sendPesan(target_id, COLOR_POLISI, TAG_POLICE" "WHITE"Masa penjara anda telah dihilangkan oleh %s.", PlayerInfo[playerid][pPlayerName]);
    sendPesan(target_id, COLOR_POLISI, TAG_POLICE" "WHITE"dengan alasan %s.", alasan);

    sendPesan(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil menghapus masa penjara.", PlayerInfo[target_id][pPlayerName]);
    sendPesan(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"dengan alasan %s.", alasan);
    return 1;
}

CMD:exit(playerid, params[]){
    new text[50];
    if(sscanf(params, "s[50]", text))
        return error_syntax(playerid, "/exit [aksi]");
    if(sama(text, "prison") && IsPlayerInAnyAreaPenjara(playerid) && !PlayerInfo[playerid][inPenjara]){
        pindahkanPemain(playerid, 256.1987, 84.2868, 1002.4453, 59.2438, 6, 1);
        SendClientMessage(playerid, COLOR_PINK, "* berhasil keluar penjara.");
    }else
        return error_command(playerid, "Aksi tidak ditemukan.");
    return 1;
}

CMD:destroy(playerid, params[]){
    new text[50], number;
    if(sscanf(params, "s[50]", text) || sscanf(params, "s[50]I(-1)", text, number))
        return error_syntax(playerid, "/destroy [aksi]");

    if(sama(text, "kangkung ijo", true) && IsPlayerOnDutyPolice(playerid)){
        // Hancurkan Ganja
        new plant_Id = GetClosestPlant(playerid);
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return error_command(playerid, "Tidak dapat menghancurkan dalam keadaan sekarang.");
        if(plant_Id == -1) 
            return error_command(playerid, "Anda tidak berada disekitar tanaman.");
        if(DFarm[plant_Id][plantItemID] != ID_GANJOS)
            return error_command(playerid, "Tanaman ini bukan, tanaman kangkung ijo.");

        ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
        DestroyTime(plant_Id);

        DFarm[plant_Id][plantItemID] = -1;
        SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil menghancurkan tanaman Kangkung Ijo.");
        sendPesan(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Anda mendapatkan bonus pekerjaan sebesar "GREEN"$%d", BONUS_MENGHANCURKAN_GANJA);

        addGajiPemain(playerid, BONUS_MENGHANCURKAN_GANJA, "bonus menghancurkan Kangkung Ijo");
        // Exp Score
        TambahExpScore(playerid, EXP_TAMBAH_FRAKSI);
    }else if(sama(text, "ranjau", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1){
            new id = ClosestObjPolice(playerid);
            if(id != -1 && OBJECT_POLICE[id][objType] == OBJECT_TYPE_RANJAU){
                DeleteObjPolice(id);
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil menghancurkan ranjau paku.");
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Tidak terdapat ranjau paku di sekitar.");
            }
        }else{
            if(OBJECT_POLICE[number][objAktif] == 1 && OBJECT_POLICE[number][objType] == OBJECT_TYPE_RANJAU){
                DeleteObjPolice(number);
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Ranjau paku dengan ID tersebut tidak ada.");
            }
        }
    }else if(sama(text, "barikade", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1){
            new id = ClosestObjPolice(playerid);
            if(id != -1 && OBJECT_POLICE[id][objType] == OBJECT_TYPE_BARIKADE){
                DeleteObjPolice(id);
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil menghancurkan barikade.");
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Tidak terdapat barikade di sekitar.");
            }
        }else{
            if(OBJECT_POLICE[number][objAktif] == 1 && OBJECT_POLICE[number][objType] == OBJECT_TYPE_BARIKADE){
                DeleteObjPolice(number);
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Barikade dengan ID tersebut tidak ada.");
            }
        }
    }else if(sama(text, "sign", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1){
            new id = ClosestObjPolice(playerid);
            if(id != -1 && OBJECT_POLICE[id][objType] == OBJECT_TYPE_SIGN){
                DeleteObjPolice(id);
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil menghancurkan sign.");
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Tidak terdapat sign di sekitar.");
            }
        }else{
            if(OBJECT_POLICE[number][objAktif] == 1 && OBJECT_POLICE[number][objType] == OBJECT_TYPE_SIGN){
                DeleteObjPolice(number);
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Sign dengan ID tersebut tidak ada.");
            }
        }
    }else if(sama(text, "garis", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1){
            new id = ClosestObjPolice(playerid);
            if(id != -1 && OBJECT_POLICE[id][objType] == OBJECT_TYPE_GARIS){
                DeleteObjPolice(id);
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil menghancurkan garis polisi.");
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Tidak terdapat garis polisi di sekitar.");
            }
        }else{
            if(OBJECT_POLICE[number][objAktif] == 1 && OBJECT_POLICE[number][objType] == OBJECT_TYPE_GARIS){
                DeleteObjPolice(number);
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Garis polisi dengan ID tersebut tidak ada.");
            }
        }
    }else if(sama(text, "speedcam", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1){
            new id = ClosestObjPolice(playerid);
            if(id != -1 && OBJECT_POLICE[id][objType] == OBJECT_TYPE_SPEEDCAM){
                DeleteObjPolice(id);
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil menghancurkan speed cam.");
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Tidak terdapat speed cam di sekitar.");
            }
        }else{
            if(OBJECT_POLICE[number][objAktif] == 1 && OBJECT_POLICE[number][objType] == OBJECT_TYPE_SPEEDCAM){
                DeleteObjPolice(number);
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Speed cam dengan ID tersebut tidak ada.");
            }
        }
    }else
        return error_command(playerid, "Aksi tidak ditemukan.");
    return 1;
}

CMD:create(playerid, params[]){
    new text[50], number;
    if(sscanf(params, "s[50]", text) || sscanf(params, "s[50]I(-1)", text, number))
        return error_syntax(playerid, "/create [aksi]");

    if(sama(text, "ranjau", true) && IsPlayerOnDutyPolice(playerid)){
        new Float:pos[4], id = Iter_Free(ObjPoliceIterator);
        if(id != -1){
            if(SS_GetPlayerInterior(playerid) != 0 || SS_GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
            if(IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda harus keluar dari dalam kendaraan.");
	        if(CA_IsPlayerNearWater(playerid)) return error_command(playerid, "Tidak dapat melakukan ini di sekitar air.");
            GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
            GetPlayerFacingAngle(playerid, pos[3]);
            pos[0] += (3.0 * floatsin(-pos[3], degrees));
            pos[1] += (3.0 * floatcos(-pos[3], degrees));
            CreateObjPolice(id, "Ranjau Paku", -1, OBJECT_TYPE_RANJAU, pos[0], pos[1], pos[2], pos[3]);
            SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil membuat ranjau paku.");
        }else{
            SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Tidak dapat membuat ranjau lagi.");
        }
    }else if(sama(text, "barikade", true) && IsPlayerOnDutyPolice(playerid)){
        new Float:pos[4], id = Iter_Free(ObjPoliceIterator);
        if(id != -1){
            if(SS_GetPlayerInterior(playerid) != 0 || SS_GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
            if(IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda harus keluar dari dalam kendaraan.");
            if(CA_IsPlayerNearWater(playerid)) return error_command(playerid, "Tidak dapat melakukan ini di sekitar air.");
            GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
            GetPlayerFacingAngle(playerid, pos[3]);
            pos[0] += (3.0 * floatsin(-pos[3], degrees));
            pos[1] += (3.0 * floatcos(-pos[3], degrees));
            CreateObjPolice(id, "Barikade", -1, OBJECT_TYPE_BARIKADE, pos[0], pos[1], pos[2], pos[3]);
            SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil membuat barikade.");
        }else{
            SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Tidak dapat membuat barikade lagi.");
        }
    }else if(sama(text, "sign", true) && IsPlayerOnDutyPolice(playerid)){
        new Float:pos[4], id = Iter_Free(ObjPoliceIterator);
        if(id != -1){
            if(SS_GetPlayerInterior(playerid) != 0 || SS_GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
            if(IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda harus keluar dari dalam kendaraan.");
	        if(CA_IsPlayerNearWater(playerid)) return error_command(playerid, "Tidak dapat melakukan ini di sekitar air.");
            GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
            GetPlayerFacingAngle(playerid, pos[3]);
            pos[0] += (3.0 * floatsin(-pos[3], degrees));
            pos[1] += (3.0 * floatcos(-pos[3], degrees));
            CreateObjPolice(id, "Road Sign", -1, OBJECT_TYPE_SIGN, pos[0], pos[1], pos[2], pos[3]);
            SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil membuat kerucut.");
        }else{
            SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Tidak dapat membuat sign lagi.");
        }
    }else if(sama(text, "garis", true) && IsPlayerOnDutyPolice(playerid)){
        new Float:pos[4], id = Iter_Free(ObjPoliceIterator);
        if(id != -1){
            if(SS_GetPlayerInterior(playerid) != 0 || SS_GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
            if(IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda harus keluar dari dalam kendaraan.");
	        if(CA_IsPlayerNearWater(playerid)) return error_command(playerid, "Tidak dapat melakukan ini di sekitar air.");
            GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
            GetPlayerFacingAngle(playerid, pos[3]);
            pos[0] += (3.0 * floatsin(-pos[3], degrees));
            pos[1] += (3.0 * floatcos(-pos[3], degrees));
            CreateObjPolice(id, "Garis Polisi", -1, OBJECT_TYPE_GARIS, pos[0], pos[1], pos[2], pos[3]);
            SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil membuat garis polisi.");
        }else{
            SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Tidak dapat membuat garis polisi lagi.");
        }
    }else if(sama(text, "speedcam", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1) return error_syntax(playerid, "/create speedcam [limit]");
        if(number >= MIN_SPEEDLIMIT && number <= MAX_SPEEDLIMIT){
            new Float:pos[4], id = Iter_Free(ObjPoliceIterator);
            if(id != -1){
                if(SS_GetPlayerInterior(playerid) != 0 || SS_GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
                if(IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda harus keluar dari dalam kendaraan.");
	            if(CA_IsPlayerNearWater(playerid)) return error_command(playerid, "Tidak dapat melakukan ini di sekitar air.");
                GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
                GetPlayerFacingAngle(playerid, pos[3]);
                pos[0] += (3.0 * floatsin(-pos[3], degrees));
                pos[1] += (3.0 * floatcos(-pos[3], degrees));
                CreateObjPolice(id, "Speed Cam", number, OBJECT_TYPE_SPEEDCAM, pos[0], pos[1], pos[2], pos[3]);
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil membuat speed cam.");
            }else{
                SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Tidak dapat membuat speed cam lagi.");
            }
        }else
            return sendPesan(playerid, COLOR_RED, "* "WHITE"Limit hanya berkisar antara %d hingga %d.", MIN_SPEEDLIMIT, MAX_SPEEDLIMIT);
    }else
        return error_command(playerid, "Aksi tidak ditemukan.");
    return 1;
}

CMD:adjust(playerid, params[]){
    new text[50], number;
    if(sscanf(params, "s[50]", text) || sscanf(params, "s[50]I(-1)", text, number))
        return error_syntax(playerid, "/adjust [aksi]");

    if(sama(text, "ranjau", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1){
            return error_syntax(playerid, "/adjust ranjau [id]");
        }else{
            new id = ClosestObjPolice(playerid);
            if(id == number && OBJECT_POLICE[number][objType] == OBJECT_TYPE_RANJAU){
                EditingObjPolice[playerid] = number;
                EditDynamicObject(playerid, OBJECT_POLICE[number][objID]);
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Ranjau paku dengan ID tersebut tidak berada di sekitar anda.");
            }
        }
    }else if(sama(text, "barikade", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1){
            return error_syntax(playerid, "/adjust barikade [id]");
        }else{
            new id = ClosestObjPolice(playerid);
            if(id == number && OBJECT_POLICE[number][objType] == OBJECT_TYPE_BARIKADE){
                EditingObjPolice[playerid] = id;
                EditDynamicObject(playerid, OBJECT_POLICE[number][objID]);
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Barikade dengan ID tersebut tidak berada di sekitar anda.");
            }
        }
    }else if(sama(text, "sign", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1){
            return error_syntax(playerid, "/adjust sign [id]");
        }else{
            new id = ClosestObjPolice(playerid);
            if(id == number && OBJECT_POLICE[number][objType] == OBJECT_TYPE_SIGN){
                EditingObjPolice[playerid] = number;
                EditDynamicObject(playerid, OBJECT_POLICE[number][objID]);
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Sign dengan ID tersebut tidak berada di sekitar anda.");
            }
        }
    }else if(sama(text, "garis", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1){
            return error_syntax(playerid, "/adjust garis [id]");
        }else{
            new id = ClosestObjPolice(playerid);
            if(id == number && OBJECT_POLICE[number][objType] == OBJECT_TYPE_GARIS){
                EditingObjPolice[playerid] = number;
                EditDynamicObject(playerid, OBJECT_POLICE[number][objID]);
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Garis polisi dengan ID tersebut tidak berada di sekitar anda.");
            }
        }
    }else if(sama(text, "speedcam", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1){
            return error_syntax(playerid, "/adjust speedcam [id]");
        }else{
            new id = ClosestObjPolice(playerid);
            if(id == number && OBJECT_POLICE[number][objType] == OBJECT_TYPE_SPEEDCAM){
                EditingObjPolice[playerid] = number;
                EditDynamicObject(playerid, OBJECT_POLICE[number][objID]);
            }else{
                SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Speed cam dengan ID tersebut tidak berada di sekitar anda.");
            }
        }
    }else
        return error_command(playerid, "Aksi tidak ditemukan.");
    return 1;
}

CMD:cuff(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid))
        return SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Anda tidak memiliki otoritas.");

    new target_id,
        Float:pos[3];
    if(sscanf(params, "u", target_id))
        return error_syntax(playerid, "/cuff [id target]");
    
    if(!IsPlayerConnected(target_id))
        return error_command(playerid, "Pemain yang dimaksud tidak ada.");

    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
    if(!IsPlayerInRangeOfPoint(playerid, 2.0, pos[0], pos[1], pos[2]))
        return error_command(playerid, "Pemain yang di maksud tidak berada didekat anda.");

    if(GetPlayerSpecialAction(target_id) == SPECIAL_ACTION_CUFFED && IsPlayerAttachedObjectSlotUsed(target_id, BORGOL_ATTACH_INDEX))
        return error_command(playerid, "Pemain sudah terborgol.");

    sendPesan(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil memborgol %s.", PlayerInfo[target_id][pPlayerName]);
    sendPesan(target_id, COLOR_POLISI, TAG_POLICE" "WHITE"Anda telah diborgol oleh polisi %s.", PlayerInfo[playerid][pPlayerName]);

    if(IsPlayerAttachedObjectSlotUsed(target_id, BORGOL_ATTACH_INDEX))
        RemovePlayerAttachedObject(target_id, BORGOL_ATTACH_INDEX);
    SetPlayerAttachedObject(target_id, BORGOL_ATTACH_INDEX, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.0, 1.168);
    SetPlayerSpecialAction(target_id, SPECIAL_ACTION_CUFFED);
    return 1;
}

CMD:uncuff(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid))
        return SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Anda tidak memiliki otoritas.");

    new target_id,
        Float:pos[3];
    if(sscanf(params, "u", target_id))
        return error_syntax(playerid, "/uncuff [id target]");
    
    if(!IsPlayerConnected(target_id))
        return error_command(playerid, "Pemain yang dimaksud tidak ada.");

    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
    if(!IsPlayerInRangeOfPoint(playerid, 2.0, pos[0], pos[1], pos[2]))
        return error_command(playerid, "Pemain yang di maksud tidak berada didekat anda.");

    if(GetPlayerSpecialAction(target_id) != SPECIAL_ACTION_CUFFED && !IsPlayerAttachedObjectSlotUsed(target_id, BORGOL_ATTACH_INDEX))
        return error_command(playerid, "Pemain tidak dalam keadaan diborgol.");

    sendPesan(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil membuka borgol %s.", PlayerInfo[target_id][pPlayerName]);
    sendPesan(target_id, COLOR_POLISI, TAG_POLICE" "WHITE"Borgol anda telah dilepas oleh polisi %s.", PlayerInfo[playerid][pPlayerName]);

    if(IsPlayerAttachedObjectSlotUsed(target_id, BORGOL_ATTACH_INDEX))
        RemovePlayerAttachedObject(target_id, BORGOL_ATTACH_INDEX);
    SetPlayerSpecialAction(target_id, SPECIAL_ACTION_NONE);
    return 1;
}

CMD:checksuspect(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid))
        return SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Anda tidak memiliki otoritas.");

    new target_id,
        Float:pos[3];
    if(sscanf(params, "u", target_id))
        return error_syntax(playerid, "/checksuspect [id target]");
    
    if(!IsPlayerConnected(target_id))
        return error_command(playerid, "Pemain yang dimaksud tidak ada.");

    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, pos[0], pos[1], pos[2]))
        return error_command(playerid, "Pemain yang di maksud tidak berada didekat anda.");

    if(PlayerInfo[target_id][inPenjara] <= 0)
        sendPesan(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"%s tidak memiliki masa tahanan tersisa.", PlayerInfo[target_id][pPlayerName]);
    else
        sendPesan(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"%s memiliki masa tahanan tersisa yaitu "RED"%d "WHITE"detik.", PlayerInfo[target_id][pPlayerName], PlayerInfo[target_id][inPenjara]);
    return 1;
}

CMD:checkplat(playerid, params[]){
    new vehid = INVALID_VEHICLE_ID;
    new Float:vpos[3];

    foreach(new vid : Vehicle){
        if(!IsValidVehicle(vid)) continue;
        if(GetVehicleBoot(vid, vpos[0], vpos[1], vpos[2])){
            if(IsPlayerInRangeOfPoint(playerid, 1.5, vpos[0], vpos[1], vpos[2])){
                vehid = vid;
                break;
            }
        }
        if(vehid == INVALID_VEHICLE_ID){
            if(GetVehicleHood(vid, vpos[0], vpos[1], vpos[2])){
                if(IsPlayerInRangeOfPoint(playerid, 1.5, vpos[0], vpos[1], vpos[2])){
                    vehid = vid;
                    break;
                }
            }
        }
    }
    
    if(vehid == INVALID_VEHICLE_ID) 
        return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Anda harus berada di bagian depan atau belakang kendaraan pribadi.");

    if(Iter_Contains(IDVehToPVehIterator, vehid)){
        new idpv = IDVehToPVeh[vehid], tmp_exp[16], tmp_plat[16];
        if(sama("-", PVeh[IDVehToPVeh[vehid]][pVehPlatAlias]))
            format(tmp_plat, sizeof(tmp_plat), "None");
        else
            format(tmp_plat, sizeof(tmp_plat), "%s %s", PVeh[idpv][pVehPlatAlias], PVeh[idpv][pVehPlatNo]);
        
        if(PVeh[idpv][pVehPlatExp] == 0)
            format(tmp_exp, sizeof(tmp_exp), "None");
        else
            format(tmp_exp, sizeof(tmp_exp), "%s", PVeh[idpv][pVehPlatExp]);

        format(pDialog[playerid], sizePDialog,
            WHITE"Plat Nomor : "GREEN"%s\n\
            "WHITE"Berlaku hingga : "GREEN"%s", tmp_plat, tmp_exp);
        ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Plat Kendaraan", pDialog[playerid], "Tutup", "");
    }else{
        return SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Anda harus berada di dekat kendaraan pribadi.");
    }
    return 1;
}

// Ini dapat dilakukan semua orang
CMD:checkinventory(playerid, params[]){

    new target_id,
        Float:pos[3];
    if(sscanf(params, "u", target_id))
        return error_syntax(playerid, "/checkinventory [id pemain]");
    
    if(!IsPlayerConnected(target_id) || playerid == target_id)
        return error_command(playerid, "Pemain yang dimaksud tidak ada.");

    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, pos[0], pos[1], pos[2]))
        return error_command(playerid, "Pemain yang di maksud tidak berada didekat anda.");

    SendClientMessage(playerid, COLOR_YELLOW, TAG_NOTE" "WHITE"Anda akan mendapat pemberitahuan saat orang tersebut menerima/menolak.");
    SetPVarInt(target_id, "periksa_target_id", playerid);
    
    format(pDialog[playerid], sizePDialog, GREEN"%s "WHITE"ingin memeriksa inventory anda,\n"YELLOW"Apakah anda memperbolehkannya?", PlayerInfo[playerid][pPlayerName]);

    ShowPlayerDialog(target_id, DIALOG_KONFIRMASI_PERIKSA_INVENTORY, DIALOG_STYLE_MSGBOX, "Konfirmasi Periksa Inventory", pDialog[playerid], "Ya", "Tidak");
    return 1;
}

CMD:cancelrentvehicle(playerid, params[]){
    if(!IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda harus berada di dalam kendaraan sewa.");
    new vehid = GetPlayerVehicleID(playerid), rentid = RentPlayerVehID[vehid];
    if(!Iter_Contains(RentPlayerVehIter, rentid)) return error_command(playerid, "Kendaraan bukan kendaraan sewa, dnda harus berada di dalam kendaraan sewa.");
    new placeid = ClosestRentVehPlace(playerid);
    if(placeid != -1){
        if(placeid != RentPlayerVeh[rentid][rentPlayerVehPlaceID]) return error_command(playerid, "Anda harus di sekitar penyewaan kendaraan yang anda sewa pertama kali.");
        if(Iter_Contains(RentPlayerVehIter, rentid)){
			if(RentPlayerVehUser[playerid] == vehid){
                unloadRentPlayerVeh(playerid, 1);
            }
		}
        SendClientMessage(playerid, COLOR_WHITE, GREEN"[KENDARAAN SEWA] "WHITE"Anda telah berhasil membatalkan sewa kendaraan.");
    }else{
        error_command(playerid, "Anda harus di sekitar penyewaan kendaraan yang anda sewa pertama kali.");
    }
    return 1;
}

/**
    Animations
 */
CMD:sit(playerid, params[]){
    if(PlayerInfo[playerid][isOnAnimation] || PlayerInfo[playerid][isBusy] || CA_IsPlayerInWater(playerid, _unusedDepth[0], _unusedDepth[1]))
        return error_command(playerid, "Anda sedang tidak bisa melakukan hal ini sekarang.");
    ApplyAnimation(playerid, "PED", "SEAT_DOWN", 4.1, 0, 0, 0, 1, 0, 1);
    PlayerInfo[playerid][isOnAnimation] = true;
    return 1;
}

CMD:wave(playerid, params[]){
    if(PlayerInfo[playerid][isBusy] || CA_IsPlayerInWater(playerid, _unusedDepth[0], _unusedDepth[1]))
        return error_command(playerid, "Anda sedang tidak bisa melakukan hal ini sekarang.");
    ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0, 1);
    PlayerInfo[playerid][isOnAnimation] = true; // Wave adalah pereset animasi
	return 1;
}

CMD:sleep(playerid, params[]){
    new sleepid;
    if(PlayerInfo[playerid][isOnAnimation] || PlayerInfo[playerid][isBusy] || CA_IsPlayerInWater(playerid, _unusedDepth[0], _unusedDepth[1]))
        return error_command(playerid, "Anda sedang tidak bisa melakukan hal ini sekarang.");
    if(SS_GetPlayerInterior(playerid) == 0 || PlayerInfo[playerid][inHouse] == 0) 
        return error_command(playerid, "Anda tidak di dalam rumah manapun.");
        
    if(sscanf(params, "i", sleepid) || sleepid < 1 || sleepid > 2)
        return error_syntax(playerid, "/sleep [1-2]");
    new Float:castPos[6];
    GetPlayerPos(playerid, castPos[0], castPos[1], castPos[2]);

    new bool:colliate = false;
    new data[e_furniture];
    for(new i, maxval = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= maxval; ++i)
    {
        if(!IsValidDynamicObject(i)) 
            continue;
        Streamer_GetArrayData(STREAMER_TYPE_OBJECT, i, E_STREAMER_EXTRA_ID, data);
        if(data[fHouseID] == PlayerInfo[playerid][inHouse] && data[fFurnitureID] == 2) { // Semua ID kasur
            if(IsPlayerInRangeOfPoint(playerid, 2.5, data[fPosX], data[fPosY], data[fPosZ])){
                colliate = true;
                break;
            }
        }
    }

    if(!colliate)
        return server_message(playerid, "Anda harus berada diatas furniture kasur untuk dapat tidur.");

    switch(sleepid) {
        case 1: 
            ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0, 1);
        case 2: 
            ApplyAnimation(playerid, "CRACK", "crckidle2", 4.1, 0, 0, 0, 1, 0, 1);
        default: {
            return error_syntax(playerid, "/sleep [1-2]");
        }
    }
    PlayerInfo[playerid][isOnAnimation] = true;
    return 1;
}

CMD:getup(playerid, params[])
{
    if(PlayerInfo[playerid][isBusy] || CA_IsPlayerInWater(playerid, _unusedDepth[0], _unusedDepth[1]))
        return error_command(playerid, "Anda sedang tidak bisa melakukan hal ini sekarang.");

    new anim[1], animname[10];
    GetAnimationName(GetPlayerAnimationIndex(playerid), anim, 1, animname, 10);
    // Pakai Huruf Besar
    if(!sama(animname, "CRCKDETH4") && !sama(animname, "CRCKIDLE2"))
        return server_message(playerid, "Anda sedang tidak tidur.");

	ApplyAnimation(playerid, "PED", "getup", 4.1, 0, 0, 0, 0, 0, 1);
    PlayerInfo[playerid][isOnAnimation] = false; // Reset Animasi
	return 1;
}

CMD:stand(playerid, params[]){
    if(PlayerInfo[playerid][isBusy] || CA_IsPlayerInWater(playerid, _unusedDepth[0], _unusedDepth[1]))
        return error_command(playerid, "Anda sedang tidak bisa melakukan hal ini sekarang.");

    new temp[2][15];
    GetAnimationName(GetPlayerAnimationIndex(playerid), temp[0], 15, temp[1], 15);
    if(!sama(temp[0], "PED") || !sama(temp[1], "SEAT_DOWN"))
        return server_message(playerid, "Anda sedang tidak duduk.");
    ApplyAnimation(playerid, "PED", "SEAT_UP", 4.1, 0, 0, 0, 0, 0, 1);
    PlayerInfo[playerid][isOnAnimation] = false; // Reset Animasi
    return 1;
}

CMD:clearanim(playerid, const params[]){
    return cmd_clearanimation(playerid, "");
}

CMD:clearanimation(playerid, const params[]){
    if(PlayerInfo[playerid][isBusy] || CA_IsPlayerInWater(playerid, _unusedDepth[0], _unusedDepth[1]))
        return error_command(playerid, "Anda sedang tidak bisa melakukan hal ini sekarang.");
    ClearAnimations(playerid);
    PlayerInfo[playerid][isOnAnimation] = false;
    return 1;
}

/**
    End Animations
 */

CMD:help(playerid, params[]){
    if(GetLevelAdminPlayer(playerid) >= 0){
        ShowPlayerDialog(playerid, DIALOG_HELP_MENU, DIALOG_STYLE_LIST, "Perintah Bantuan :", "Umum\nPekerjaan\nAdmin\nFraksi", "Pilih", "Batal");
    }else{
        if(IsPlayerOnDutyMedic(playerid) || IsPlayerOnDutyPolice(playerid)){
            ShowPlayerDialog(playerid, DIALOG_HELP_MENU, DIALOG_STYLE_LIST, "Perintah Bantuan :", "Umum\nPekerjaan\nFraksi", "Pilih", "Batal");
        }else{
            ShowPlayerDialog(playerid, DIALOG_HELP_MENU, DIALOG_STYLE_LIST, "Perintah Bantuan :", "Umum\nPekerjaan", "Pilih", "Batal");
        }
    }
    return 1;
}

CMD:ooc(playerid, params[]){
    new pesan[144];
	if(sscanf(params, "s[144]", pesan)) 
        return error_syntax(playerid, "/ooc [text]");

    format(pesan, sizeof(pesan), "[OOC] "WHITE"%s: %s", PlayerInfo[playerid][pPlayerName], pesan);
    ProxDetector(30.0, playerid, pesan, COLOR_YELLOW);
    return 1;
}

CMD:refreshme(playerid, params[]){
    new intTemp = SS_GetPlayerInterior(playerid),
        intVw = SS_GetPlayerVirtualWorld(playerid);

    if(intTemp == 0 && intVw == 0){
        new Float:tempPos[3];
        GetPlayerPos(playerid, tempPos[0], tempPos[1], tempPos[2]);
        CA_FindZ_For2DCoord(tempPos[0], tempPos[1], tempPos[2]);
        SetPlayerPos(playerid, tempPos[0], tempPos[1], tempPos[2]);
    }
    return 1;
}

CMD:tutorial(playerid, params[]){
    // Ambil sebelum set camera
    new Float:temp_pos[4];
    GetPlayerPos(playerid, temp_pos[0], temp_pos[1], temp_pos[2]);
    GetPlayerFacingAngle(playerid, temp_pos[3]);
    PlayerInfo[playerid][last_x] = temp_pos[0];
    PlayerInfo[playerid][last_y] = temp_pos[1];
    PlayerInfo[playerid][last_z] = temp_pos[2];
    PlayerInfo[playerid][last_a] = temp_pos[3];
    SetPVarFloat(playerid, "panduan_bermain_x", temp_pos[0]);
    SetPVarFloat(playerid, "panduan_bermain_y", temp_pos[1]);
    SetPVarFloat(playerid, "panduan_bermain_z", temp_pos[2]);
    SetPVarFloat(playerid, "panduan_bermain_a", temp_pos[3]);
    aktifPanduanStream[playerid] = 1;
    // Set variabel panduan umum 1
    SetPVarString(playerid, "panduan_bermain", "panduan_bermain_1");
    format(pDialog[playerid], sizePDialog, 
    WHITE"Dalam sesi tutorial ini, kamu akan diberi panduan bermain secara singkat.\n\
    Ada beberapa fitur dan tempat dalam server ini yang perlu kamu ketahui.\n\
    Anda akan diberi beberapa penjelasan, jika anda ingin paham tentang server ini,\n\
    jangan tutup panduan ini atau anda harus mengulang sesi dari awal.");
    ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "Panduan Bermain (Awal) :", pDialog[playerid], "Lanjut", "Tutup");
    return 1;
}

CMD:lock(playerid, params[]){
    new vehid;
    if(IsPlayerInAnyVehicle(playerid)){
        vehid = GetPlayerVehicleID(playerid);
        if(PVeh[IDVehToPVeh[vehid]][pVehPemilik] == PlayerInfo[playerid][pID] || Iter_Contains(PVehKeys[playerid], IDVehToPVeh[vehid]) && PVehKeysTime[playerid][IDVehToPVeh[vehid]] > gettime()){
            goto label_lock_vehicle_player;
        }else{
            return error_command(playerid, "Anda tidak disekitar kendaraan yang anda miliki atau pinjaman.");
        }
    }else{
        vehid = ClosestVehiclePlayer(playerid);
        if(vehid != -1){ 
            if(PVeh[IDVehToPVeh[vehid]][pVehPemilik] == PlayerInfo[playerid][pID] || Iter_Contains(PVehKeys[playerid], IDVehToPVeh[vehid]) && PVehKeysTime[playerid][IDVehToPVeh[vehid]] > gettime()){
                goto label_lock_vehicle_player;
            }else{
                return error_command(playerid, "Anda tidak disekitar kendaraan yang anda miliki atau pinjaman.");
            }
        }else{
            return error_command(playerid, "Anda tidak disekitar kendaraan yang anda miliki atau pinjaman.");
        }
    }
    label_lock_vehicle_player:
    new idpv = IDVehToPVeh[vehid];
    if(Iter_Contains(IDVehToPVehIterator, vehid)){
        if(PVeh[idpv][pVehPemilik] != PlayerInfo[playerid][pID] && !( Iter_Contains(PVehKeys[playerid], idpv) && PVehKeysTime[playerid][idpv] > gettime() )){
            server_message(playerid, "Anda tidak memiliki kunci kendaraan ini.");
            return 1;
        }
    }
    new engine, lights, alarm,doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(doors == VEHICLE_PARAMS_ON){
        SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Kendaraan sudah dalam keadaan terkunci.");
    }else{
        SetVehicleParamsEx(vehid, engine, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
        SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Anda berhasil mengunci kendaraan.");
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE vehicle SET params_doors = '%d' WHERE id = '%d'", VEHICLE_PARAMS_ON, PVeh[idpv][pVehID]);
	    mysql_tquery(koneksi, pQuery[playerid]);
    }
    return 1;
}

CMD:unlock(playerid, params[]){
    new vehid;
    if(IsPlayerInAnyVehicle(playerid)){
        vehid = GetPlayerVehicleID(playerid);
        printf("InVehicle %d", vehid);
        if(PVeh[IDVehToPVeh[vehid]][pVehPemilik] == PlayerInfo[playerid][pID] || Iter_Contains(PVehKeys[playerid], IDVehToPVeh[vehid]) && PVehKeysTime[playerid][IDVehToPVeh[vehid]] > gettime()){
            goto label_unlock_vehicle_player;
        }else{
            return error_command(playerid, "Anda tidak disekitar kendaraan yang anda miliki atau pinjaman.");
        }
    }else{
        vehid = ClosestVehiclePlayer(playerid);
        if(vehid != -1){ 
            if(PVeh[IDVehToPVeh[vehid]][pVehPemilik] == PlayerInfo[playerid][pID] || Iter_Contains(PVehKeys[playerid], IDVehToPVeh[vehid]) && PVehKeysTime[playerid][IDVehToPVeh[vehid]] > gettime()){
                goto label_unlock_vehicle_player;
            }else{
                return error_command(playerid, "Anda tidak disekitar kendaraan yang anda miliki atau pinjaman.");
            }
        }else{
            return error_command(playerid, "Anda tidak disekitar kendaraan yang anda miliki atau pinjaman.");
        }
    }
    label_unlock_vehicle_player:
    new idpv = IDVehToPVeh[vehid];
    if(Iter_Contains(IDVehToPVehIterator, vehid)){
        if(PVeh[idpv][pVehPemilik] != PlayerInfo[playerid][pID] && !( Iter_Contains(PVehKeys[playerid], idpv) && PVehKeysTime[playerid][idpv] > gettime() )){
            server_message(playerid, "Anda tidak memiliki kunci kendaraan ini.");
            return 1;
        }
    }
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(doors == VEHICLE_PARAMS_ON){
        SetVehicleParamsEx(vehid, engine, lights, alarm, VEHICLE_PARAMS_OFF, bonnet, boot, objective);
        SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Anda berhasil membuka kunci kendaraan.");
        mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE vehicle SET params_doors = '%d' WHERE id = '%d'", VEHICLE_PARAMS_OFF, PVeh[idpv][pVehID]);
	    mysql_tquery(koneksi, pQuery[playerid]);
    }else{
        SendClientMessage(playerid, COLOR_RED, TAG_KENDARAAN" "WHITE"Kendaraan sudah dalam keadaan tidak terkunci.");
    }
    return 1;
}

CMD:cvoacvrp(playerid, params[]){
    // Check Android
    if(IsPlayerAndroid(playerid)){
        Android_Official[playerid] = 1;
    }else{
        Android_Official[playerid] = 0;
    }
    return 1;
}

// CMD:idmgs(playerid, params[]){
//     if(IsPlayerInAnyVehicle(playerid)){
//         new panels, doors, lights, tires;
//         GetVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, tires);
//         sendPesan(playerid, COLOR_WHITE, "panels %d doors %d lights %d tires %d", panels, doors, lights, tires);
//     }
//     return 1;
// }

// CMD:dbfx(playerid, params[]){
//     if(IsPlayerInAnyVehicle(playerid)){
//         RepairVehicle(GetPlayerVehicleID(playerid));
//     }
//     return 1;
// }

// CMD:dbdc(playerid, params[]){
//     if(!IsPlayerInAnyVehicle(playerid))
//         return 1;
//     new panels, doors, lights, tires;
//     new vehicleid = GetPlayerVehicleID(playerid);
//     if(sscanf(params, "iiii", panels, doors, lights, tires))
//         return error_syntax(playerid, "/dbdc [panels] [doors] [lights] [tires]");
//     UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
//     return 1;
// }