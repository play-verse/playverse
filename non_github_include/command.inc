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

    format(msg, sizeof(msg),  TAG_KICK" "WHITE"Anda telah di kick dari server dengan alasan : "YELLOW"%s "WHITE"!", pesan);
    SendClientMessage(target_id, COLOR_RED, msg);
    KickEx(target_id);

    format(msg, sizeof(msg), TAG_ADMIN" "RED"%s "WHITE"telah di kick dari server dengan alasan : "YELLOW"%s "WHITE"!", PlayerInfo[target_id][pPlayerName], pesan);
    SendClientMessageToAll(COLOR_ORANGE, msg);
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

CMD:giveitem(playerid, params[]){
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

CMD:givemoney(playerid, params[]){
    // Jika bukan admin level 2
    if(GetLevelAdminPlayer(playerid) < 2) return 0;

    new amount, target_id;
    if(sscanf(params, "ud", target_id, amount)) 
        return error_syntax(playerid, "/givemoney [id] [jumlah]");
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

    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
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

CMD:pecatmedic(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id;
    if(sscanf(params, "u", target_id)) 
        return error_syntax(playerid, "/pecatmedic [id]");

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

CMD:setpolisi(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id, text_temporary[10], masa_aktif, level, status_temp = 0;
    if(sscanf(params, "us[10]iI(1)", target_id, text_temporary, level, masa_aktif)) return error_syntax(playerid, "/setpolisi [id] [permanent/expired] [level] [masa aktif (hari)]");

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

CMD:pecatpolisi(playerid, params[]){
    // Jika bukan admin level 1 (bukan admin)
    if(GetLevelAdminPlayer(playerid) < 1) return 0;

    new target_id;
    if(sscanf(params, "u", target_id)) 
        return error_syntax(playerid, "/pecatpolisi [id]");

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
    ResetPlayerWeapons(target_id);
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

    pindahkanPemain(playerid, pos[0], pos[1] + 0.5, pos[2], pos[3], GetPlayerInterior(target_id), GetPlayerVirtualWorld(target_id), true);
    PlayerInfo[playerid][inHouse] = PlayerInfo[target_id][inHouse];
    sendPesan(playerid, COLOR_BLUE, TAG_ADMIN" "WHITE"Anda berhasil teleport ke posisi %s berada.", PlayerInfo[target_id][pPlayerName]);
    return 1;
}

CMD:tampilreport(playerid, params[]){
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

    pindahkanPemain(target_id, pos[0], pos[1] + 0.5, pos[2], pos[3], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), true);

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

CMD:masak(playerid, params[]){
    if(PlayerInfo[playerid][isBusy]) 
        return error_command(playerid, "Anda sedang melakukan hal lain sekarang.");

    if(!IsPlayerInRangeOfPoint(playerid, 2.5, -794.9869, 2425.4514, 158.1323))
        return error_command(playerid, "Anda harus berada dekat kompor material.");
    
    showDialogMasakTambang(playerid);
    return 1;
}

CMD:bc(playerid, params[]){
    new pesan[256];
    if(PlayerInfo[playerid][ePhone] == 0) return error_command(playerid, "Maaf anda harus menggunakan ponsel terlebih dahulu, untuk dpt menggunakan fitur ini.");
    if(!IsPemainPunyaNomorAktif(playerid)) return error_command(playerid, "Maaf anda harus memiliki nomor hp yang aktif untuk dapat menggunakan fitur ini.");
	if(sscanf(params, "s[256]", pesan)) return error_syntax(playerid, "/bc [pesan]");
    if(gettime() - PlayerInfo[playerid][lastGlobalChat] < (2 * 60)){
        format(msg, sizeof(msg), "Anda hanya dapat mengirim pesan broadcast 2 menit sekali, anda harus menunggu %d detik lagi!", 2 * 60 + PlayerInfo[playerid][lastGlobalChat] - gettime());
        return error_command(playerid, msg);
    }
    format(msg, sizeof(msg), "**[BROADCAST] ("BLUE"+%s"WHITE") : %s", PlayerInfo[playerid][nomorHP], pesan);
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

CMD:infosaya(playerid, params[]){
    ShowPlayerDialog(playerid, DIALOG_INFO_SAYA, DIALOG_STYLE_LIST, "Pilihan Info : ", "Skill\nInformasi Pribadi", "Pilih", "Batal");
    return 1;
}

CMD:skill(playerid, const params[]){
    if(PlayerInfo[playerid][isBusy]) return SendClientMessage(playerid, COLOR_RED, TAG_SIBUK" "WHITE"Tidak dapat menggunakan skill sekarang, anda sedang melakukan hal lain.");
    ShowPlayerDialog(playerid, DIALOG_MENU_SKILL, DIALOG_STYLE_LIST, "Skill", "Mekanik\nMedic\nBlacksmith", "Pilih", "Batal");
    return 1;
}

CMD:v(playerid, const params[]){
    if(!IsPlayerInAnyVehicle(playerid)) return error_command(playerid, "Anda tidak menggunakan perintah ini saat tidak di dalam kendaraan.");

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

CMD:bunuhdiri(playerid, params[]){
    SetPlayerHealth(playerid, 0.0);
    return 1;
}

CMD:rumah(playerid, params[]){
    if(GetPlayerInterior(playerid) == 0) return error_command(playerid, "Anda tidak di dalam rumah manapun.");
    if(houseInfo[PlayerInfo[playerid][inHouse]][hOwner] != PlayerInfo[playerid][pID]) return error_command(playerid, "Anda bukan pemilik rumah.");
    ShowPlayerDialog(playerid, DIALOG_MENU_RUMAH, DIALOG_STYLE_LIST, "Menu Rumah : ", "Inventory Rumah\nSemua Furniture", "Pilih", "Tutup");
    return 1;
}

CMD:inforumah(playerid, const params[]){
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
            new upgradeRate = getHousePrice(id, "upgrade");
            if(houseInfo[id][hJual] == 1){
                SetPVarString(playerid, "info_rumah", "batal_jual");
                if(houseInfo[id][hLevel] < MAX_HOUSES_LEVEL){
                    if(houseInfo[id][hKunci] == 1){
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (%d)\nBatal Kunci Rumah\nBatal Spawn Disini\nMasuk Rumah", upgradeRate);
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (%d)\nBatal Kunci Rumah\nSpawn Disini\nMasuk Rumah", upgradeRate);
                        }
                    }else{
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (%d)\nKunci Rumah\nBatal Spawn Disini\nMasuk Rumah", upgradeRate);
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (%d)\nKunci Rumah\nSpawn Disini\nMasuk Rumah", upgradeRate);
                        }
                    }
                }else{
                    if(houseInfo[id][hKunci] == 1){
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (Maksimal)\nBatal Kunci Rumah\nBatal Spawn Disini\nMasuk Rumah");
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (Maksimal)\nBatal Kunci Rumah\nSpawn Disini\nMasuk Rumah");
                        }
                    }else{
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (Maksimal)\nKunci Rumah\nBatal Spawn Disini\nMasuk Rumah");
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nBatal Jual Rumah\nUpgrade Rumah (Maksimal)\nKunci Rumah\nSpawn Disini\nMasuk Rumah");
                        }
                    }
                }
            }else{
                SetPVarString(playerid, "info_rumah", "jual_rumah");
                if(houseInfo[id][hLevel] < MAX_HOUSES_LEVEL){
                    if(houseInfo[id][hKunci] == 1){
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (%d)\nBatal Kunci Rumah\nBatal Spawn Disini\nMasuk Rumah", upgradeRate);
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (%d)\nBatal Kunci Rumah\nSpawn Disini\nMasuk Rumah", upgradeRate);
                        }
                    }else{
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (%d)\nKunci Rumah\nBatal Spawn Disini\nMasuk Rumah", upgradeRate);
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (%d)\nKunci Rumah\nSpawn Disini\nMasuk Rumah", upgradeRate);
                        }
                    }
                }else{
                    if(houseInfo[id][hKunci] == 1){
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (Maksimal)\nBatal Kunci Rumah\nBatal Spawn Disini\nMasuk Rumah");
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (Maksimal)\nBatal Kunci Rumah\nSpawn Disini\nMasuk Rumah");
                        }
                    }else{
                        if(PlayerInfo[playerid][sHouse] == id){
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (Maksimal)\nKunci Rumah\nBatal Spawn Disini\nMasuk Rumah");
                        }else{
                            format(string, sizeof(string), "Tentang Rumah\nJual Rumah\nUpgrade Rumah (Maksimal)\nKunci Rumah\nSpawn Disini\nMasuk Rumah");
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
    ShowPlayerDialog(playerid, DIALOG_JOB_TRASHMASTER_CMD, DIALOG_STYLE_LIST, WHITE"Trashmaster System :", "Angkut Sampah\nCek Muatan Sampah", "Pilih", "Batal");
    return 1;
}

CMD:pizzaboy(playerid, const params[]){
    if(pizza_Job[playerid] != 1) return error_command(playerid, "Anda bukan pengantar pizza dan tidak dapat menggunakan perintah ini.");
    ShowPlayerDialog(playerid, DIALOG_JOB_PIZZABOY_CMD, DIALOG_STYLE_LIST, WHITE"Pizzaboy System :", "Restok Pizza\nAmbil Pizza\nCek Muatan Pizza", "Pilih", "Batal");
    return 1;
}

CMD:gali(playerid, params[]){
    if(!IsPlayerInAnyDynamicArea(playerid) || !GetPVarType(playerid, "last_area"))
        return error_command(playerid, "Hanya dapat menggali/menambang pada area pertambangan.");

    if(PlayerInfo[playerid][sisaPalu] <= 0)
        return error_command(playerid, "Anda membutuhkan cangkul/palu tambang untuk menggali");

    if(PlayerInfo[playerid][isBusy]) 
        return error_command(playerid, "Anda sedang melakukan hal lain sekarang.");

    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        return error_command(playerid, "Anda harus berjalan kaki untuk dapat melakukan hal ini."); 

    if(getStatusMakanPemain(playerid) <= 15.0) return error_command(playerid, "Anda kehabisan energi, silahkan makan terlebih dahulu untuk dapat bekerja kembali.");

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
    ShowPlayerDialog(playerid, DIALOG_FARM, DIALOG_STYLE_LIST, WHITE"Farm System :", "Panen Tanaman\nTempat Beli Bibit", "Pilih", "Batal");
    return 1;
}

CMD:fishing(playerid, params[]){
    ShowPlayerDialog(playerid, DIALOG_FISHING, DIALOG_STYLE_LIST, WHITE"Fishing System :", "Mancing Ikan\nToko Peralatan Pancing", "Pilih", "Batal");
    return 1;
}

CMD:beriuang(playerid, params[]){
    new target_id, nominal;
    if(sscanf(params, "ii", target_id, nominal)) return error_syntax(playerid, "/beriuang [id pemain] [nominal]");
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
CMD:lepashelm(playerid, params[]){
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

CMD:lepastopeng(playerid, params[]){
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

CMD:panggil(playerid, params[])
{
	new number;
    if(sscanf(params, "i", number)) 
        return error_syntax(playerid, "/panggil [nomor]");
    // if(PlayerInfo[playerid][ePhone] == 0) return error_command(playerid, "Maaf anda harus menggunakan ponsel terlebih dahulu, untuk dpt menggunakan fitur ini.");
    // if(!IsPemainPunyaNomorAktif(playerid)) return error_command(playerid, "Maaf anda harus memiliki nomor hp yang aktif untuk dapat menggunakan fitur ini.");
	// if(number == PlayerInfo[playerid][nomorHP]) return error_command(playerid, "Tidak dapat melakukan panggilan ke nomor hp pribadi.");
    if(number == 123){
        format(pDialog[playerid], sizePDialog, WHITE"Nomor Resmi yang tersedia :\n123 - Pusat Bantuan Panggilan\n911 - Panggilan Darurat (Medis/Polisi)", PlayerInfo[playerid][pPlayerName]);
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
//     format(pesan, sizeof(pesan), TAG_MEDIC" "WHITE"%s(%d) sedang sekarat dan membutuhkan bantuan. Ketik /tampillokasipasien %d untuk menandai marker.", PlayerInfo[playerid][pPlayerName], playerid);
//     new online_medic = SendMessageToDutyMedic(COLOR_RED, pesan);

//     if(!online_medic)
//         return SendClientMessage(playerid, COLOR_RED, TAG_MEDIC" "WHITE"Tidak ada medis yang sedang bertugas saat ini.");

//     return SendClientMessage(playerid, COLOR_MEDIC, TAG_MEDIC" "WHITE"Berhasil mengirim pesan ke medis, tunggu beberapa saat..");
// }

CMD:tampillokasipasien(playerid, params[]){
    if(!IsPlayerOnDutyMedic(playerid)) 
        return error_command(playerid, "Anda tidak sedang bertugas sebagai medis.");
    
    new target_id;
    if(sscanf(params, "u", target_id)) 
        return error_syntax(playerid, "/tampillokasipasien [id pemain]");

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

CMD:tampillokasibantuan(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid)) 
        return error_command(playerid, "Anda tidak sedang bertugas sebagaipolisi.");
    
    new target_id;
    if(sscanf(params, "u", target_id)) 
        return error_syntax(playerid, "/tampillokasibantuan [id pemain]");

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

CMD:tutup(playerid, params[]){
    new text[50];
    if(sscanf(params, "s[50]", text)) 
        return error_syntax(playerid, "/tutup [objek]");

    if(sama(text, "pintupenjara") && IsPlayerOnDutyPolice(playerid)){
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 78.43640, 1001.26233)){
            tutupPintuPenjara(pintuPenjara[0]);
        }else if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 82.96240, 1001.26233)){
            tutupPintuPenjara(pintuPenjara[1]);
        }else if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 87.48840, 1001.26233)){
            tutupPintuPenjara(pintuPenjara[2]);
        }
    }else
        return 0;
    return 1;
}

CMD:buka(playerid, params[]){
    new text[50];
    if(sscanf(params, "s[50]", text))
        return error_syntax(playerid, "/buka [objek]");

    if(sama(text, "pintupenjara") && IsPlayerOnDutyPolice(playerid)){
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 78.43640, 1001.26233)){
            bukaPintuPenjara(pintuPenjara[0]);
        }else if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 82.96240, 1001.26233)){
            bukaPintuPenjara(pintuPenjara[1]);
        }else if(IsPlayerInRangeOfPoint(playerid, 2.0, 266.31070, 87.48840, 1001.26233)){
            bukaPintuPenjara(pintuPenjara[2]);
        }
    }else
        return error_command(playerid, "Aksi tidak ditemukan.");
    return 1;
}

CMD:penjarakan(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid))
        return SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Anda tidak memiliki otoritas.");

    new target_id,
        lama_penjara,
        alasan[50],
        Float:pos[3];
    if(sscanf(params, "uis[50]", target_id, lama_penjara, alasan))
        return error_syntax(playerid, "/penjarakan [id target] [lama detik] [alasan]");
    
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

CMD:hapusmasapenjara(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid))
        return SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Anda tidak memiliki otoritas.");

    new target_id,
        alasan[50],
        Float:pos[3];
    if(sscanf(params, "us[50]", target_id, alasan))
        return error_syntax(playerid, "/hapusmasapenjara [id target] [alasan]");
    
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

CMD:keluar(playerid, params[]){
    new text[50];
    if(sscanf(params, "s[50]", text))
        return error_syntax(playerid, "/keluar [aksi]");
    if(sama(text, "penjara") && IsPlayerInAnyAreaPenjara(playerid) && !PlayerInfo[playerid][inPenjara]){
        pindahkanPemain(playerid, 256.1987, 84.2868, 1002.4453, 59.2438, 6, 1);
        SendClientMessage(playerid, COLOR_PINK, "* berhasil keluar penjara.");
    }else
        return error_command(playerid, "Aksi tidak ditemukan.");
    return 1;
}

CMD:hancurkan(playerid, params[]){
    new text[50], number;
    if(sscanf(params, "s[50]", text) || sscanf(params, "s[50]I(-1)", text, number))
        return error_syntax(playerid, "/hancurkan [aksi]");

    if(sama(text, "ganja", true) && IsPlayerOnDutyPolice(playerid)){
        // Hancurkan Ganja
        new plant_Id = GetClosestPlant(playerid);
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return error_command(playerid, "Tidak dapat menghancurkan dalam keadaan sekarang.");
        if(plant_Id == -1) 
            return error_command(playerid, "Anda tidak berada disekitar tanaman.");
        if(DFarm[plant_Id][plantItemID] != ID_GANJOS)
            return error_command(playerid, "Tanaman ini bukan, tanaman ganja.");

        ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
        DestroyTime(plant_Id);

        DFarm[plant_Id][plantItemID] = -1;
        SendClientMessage(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Berhasil menghancurkan tanaman ganja.");
        sendPesan(playerid, COLOR_POLISI, TAG_POLICE" "WHITE"Anda mendapatkan bonus pekerjaan sebesar "GREEN"$%d", BONUS_MENGHANCURKAN_GANJA);

        addGajiPemain(playerid, BONUS_MENGHANCURKAN_GANJA, "bonus menghancurkan ganja");
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

CMD:buat(playerid, params[]){
    new text[50], number;
    if(sscanf(params, "s[50]", text) || sscanf(params, "s[50]I(-1)", text, number))
        return error_syntax(playerid, "/buat [aksi]");

    if(sama(text, "ranjau", true) && IsPlayerOnDutyPolice(playerid)){
        new Float:pos[4], id = Iter_Free(ObjPoliceIterator);
        if(id != -1){
            if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
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
            if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
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
            if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
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
            if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
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
        if(number == -1) return error_syntax(playerid, "/buat speedcam [limit]");
        if(number >= MIN_SPEEDLIMIT && number <= MAX_SPEEDLIMIT){
            new Float:pos[4], id = Iter_Free(ObjPoliceIterator);
            if(id != -1){
                if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada di luar ruangan atau dunia sesungguhnya.");
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

CMD:ubah(playerid, params[]){
    new text[50], number;
    if(sscanf(params, "s[50]", text) || sscanf(params, "s[50]I(-1)", text, number))
        return error_syntax(playerid, "/ubah [aksi]");

    if(sama(text, "ranjau", true) && IsPlayerOnDutyPolice(playerid)){
        if(number == -1){
            return error_syntax(playerid, "/ubah ranjau [id]");
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
            return error_syntax(playerid, "/ubah barikade [id]");
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
            return error_syntax(playerid, "/ubah sign [id]");
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
            return error_syntax(playerid, "/ubah garis [id]");
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
            return error_syntax(playerid, "/ubah speedcam [id]");
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

CMD:borgol(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid))
        return SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Anda tidak memiliki otoritas.");

    new target_id,
        Float:pos[3];
    if(sscanf(params, "u", target_id))
        return error_syntax(playerid, "/borgol [id target]");
    
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

CMD:bukaborgol(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid))
        return SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Anda tidak memiliki otoritas.");

    new target_id,
        Float:pos[3];
    if(sscanf(params, "u", target_id))
        return error_syntax(playerid, "/bukaborgol [id target]");
    
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

CMD:cekmasatahanan(playerid, params[]){
    if(!IsPlayerOnDutyPolice(playerid))
        return SendClientMessage(playerid, COLOR_RED, TAG_POLICE" "WHITE"Anda tidak memiliki otoritas.");

    new target_id,
        Float:pos[3];
    if(sscanf(params, "u", target_id))
        return error_syntax(playerid, "/cekmasatahanan [id target]");
    
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

// Ini dapat dilakukan semua orang
CMD:periksainventory(playerid, params[]){

    new target_id,
        Float:pos[3];
    if(sscanf(params, "u", target_id))
        return error_syntax(playerid, "/periksainventory [id pemain]");
    
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

CMD:batalsewakendaraan(playerid, params[]){
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
CMD:duduk(playerid, params[]){
    if(PlayerInfo[playerid][isOnAnimation] || PlayerInfo[playerid][isBusy])
        return error_command(playerid, "Anda sedang tidak bisa melakukan hal ini sekarang.");
    ApplyAnimation(playerid, "PED", "SEAT_DOWN", 4.1, 0, 0, 0, 1, 0, 1);
    return 1;
}

CMD:berdiri(playerid, params[]){
    if(PlayerInfo[playerid][isOnAnimation] || PlayerInfo[playerid][isBusy])
        return error_command(playerid, "Anda sedang tidak bisa melakukan hal ini sekarang.");

    new temp[2][15];
    GetAnimationName(GetPlayerAnimationIndex(playerid), temp[0], 15, temp[1], 15);
    if(!sama(temp[0], "PED") || !sama(temp[1], "SEAT_DOWN"))
        return server_message(playerid, "Anda sedang tidak duduk.");
    ApplyAnimation(playerid, "PED", "SEAT_UP", 4.1, 0, 0, 0, 0, 0, 1);
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