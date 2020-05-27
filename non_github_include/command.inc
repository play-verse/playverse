CMD:kick(playerid, params[]){
	new target_id, pesan[256];
    if(!IsPlayerAdmin(playerid)) return error_command(playerid, "Anda tidak dapat menggunakan perintah ini!");
	if(sscanf(params, "us[256]", target_id, pesan)) return error_syntax(playerid, "/kick [playerid] [pesan]");
    if(!IsPlayerConnected(target_id)) return  error_command(playerid, "Player dengan id tersebut tidak ada!");
    if(target_id == playerid) return  error_command(playerid, "Tidak dapat mengusir diri sendiri!");

    format(msg, sizeof(msg),  RED"[KICK] "WHITE"Anda telah di kick dari server dengan alasan : "YELLOW"%s "WHITE"!", pesan);
    SendClientMessage(target_id, COLOR_WHITE, msg);
    KickEx(target_id);

    format(msg, sizeof(msg), ORANGE"[ADMIN] "RED"%s "WHITE"telah di kick dari server dengan alasan : "YELLOW"%s "WHITE"!", PlayerInfo[target_id][pPlayerName], pesan);
    SendClientMessageToAll(COLOR_WHITE, msg);
	return 1;
}

CMD:bc(playerid, params[]){
    new pesan[256];
    if(PlayerInfo[playerid][ePhone] == 0) return error_command(playerid, "Maaf anda harus menggunakan ponsel terlebih dahulu, untuk dpt menggunakan fitur ini.");
    if(isnull(PlayerInfo[playerid][nomorHP])) return error_command(playerid, "Maaf anda harus memiliki nomor hp yang sudah terdaftar untuk dpt menggunakan fitur ini.");
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
    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "Inventory", "Item\nSkin", "Pilih", "Batal");
    return 1;
}

CMD:beliskin(playerid, params[]){    
    if(!IsPlayerAdmin(playerid)) return 0;
    new subString[16];
    new len = ((PlayerInfo[playerid][jenisKelamin] == 0) ? sizeof(SKIN_MALE_GRATIS) : sizeof(SKIN_FEMALE_GRATIS));
    new string[500];

    for (new i = 0; i < len; i++) {
        format(subString, sizeof(subString), "%i\n", PlayerInfo[playerid][jenisKelamin] == 0 ? SKIN_MALE_GRATIS[i] : SKIN_FEMALE_GRATIS[i]);
        strcat(string, subString);
    } 

    ShowPlayerDialog(playerid, DIALOG_BELI_SKIN, DIALOG_STYLE_PREVIEW_MODEL, "Pilih skin yang anda inginkan", string, "Pilih", "Keluar");
    return 1;
}

CMD:daftarnomor(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return 0;
    if(!isnull(PlayerInfo[playerid][nomorHP])) return error_command(playerid, "Maaf anda telah memiliki nomor HP");
    ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP anda", WHITE"Masukan nomor HP yang anda inginkan :", "Simpan", "Keluar");
    return 1;
}

CMD:pindahpos(playerid, params[]){
    new Float:x, Float:y, Float:z, Float:a, int, vw;
    if(!IsPlayerAdmin(playerid)) return 0;
    if(sscanf(params, "ffffdd", x, y, z, a, int, vw)) return error_syntax(playerid, "/pindahpos [x] [y] [z] [a] [int] [vw]");

    pindahkanPemain(playerid, x, y, z, a, int, vw, true);	
    return 1;
}

CMD:giveitem(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return 0;

    new subString[45];
    static string[MAX_SERVER_ITEM * 45];

    if(string[0] == EOS){
        format(string, sizeof(string), "Kode\tNama\n"WHITE);
        new Cache:result, rows, id_item, nama_item[256];
        result = mysql_query(koneksi, "SELECT * FROM `item`");
        cache_get_row_count(rows);

        for(new i = 0; i < rows; i++){
            cache_get_value_name_int(i, "id_item", id_item);
            cache_get_value_name(i, "nama_item", nama_item);

            format(subString, sizeof(subString), "%i\t%s\n", id_item, nama_item);
            strcat(string, subString);
        }
        cache_delete(result);
    }
	ShowPlayerDialog(playerid, DIALOG_ADMIN_GIVE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Pilih item yang ingin diberi :", string, "Pilih", "Keluar");
    return 1;
}

CMD:givemoney(playerid, params[]){
    new amount, target_id;
    if(!IsPlayerAdmin(playerid)) return 0;
    if(sscanf(params, "ud", target_id, amount)) return error_syntax(playerid, "/givemoney [id] [jumlah]");
    givePlayerUang(target_id, amount);
    return 1;
}

CMD:infosaya(playerid, params[]){
    tampilkanTextDrawMyInfo(playerid);
    return 1;
}

CMD:pm(playerid, params[]){
    new string[256], pesan[200], target_id;
    if(PlayerInfo[playerid][ePhone] == 0) return error_command(playerid, "Maaf anda harus menggunakan ponsel terlebih dahulu, untuk dpt menggunakan fitur ini.");
    if(isnull(PlayerInfo[playerid][nomorHP])) return error_command(playerid, "Maaf anda harus memiliki nomor hp yang sudah terdaftar untuk dpt menggunakan fitur ini.");
    if(sscanf(params, "us[200]", target_id, pesan)) return error_syntax(playerid, "/pm [playerid] [pesan]");
    if(!IsPlayerConnected(target_id)) return error_command(playerid, "Maaf pemain dengan id tersebut tidak ada / tidak terkoneksi!");
    if(playerid == target_id) return error_command(playerid, "Maaf anda tidak dapat mengirim pesan kepada diri sendiri!");
    if(PlayerInfo[target_id][ePhone] == 0) return error_command(playerid, "Maaf pemain yang anda tuju harus menggunakan ponsel terlebih dahulu agar dapat menerima pm.");
    if(isnull(PlayerInfo[target_id][nomorHP])) return error_command(playerid, "Maaf pemain yang anda tuju harus memiliki nomor HP yang sudah terdaftar.");


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
    if(isnull(PlayerInfo[playerid][nomorHP])) return error_command(playerid, "Maaf anda harus memiliki nomor hp yang sudah terdaftar untuk dpt menggunakan fitur ini.");
    if(sscanf(params, "s[200]", pesan)) return error_syntax(playerid, "/r [pesan]");
    if(PlayerInfo[playerid][reply] == -1) return error_command(playerid, "Maaf anda tidak memiliki pm yang dapat dibalas!");

    new target_id = PlayerInfo[playerid][reply];

    if(!IsPlayerConnected(target_id)){
        PlayerInfo[playerid][reply] = -1;
        return error_command(playerid, "Maaf pemain yang ingin direply tersebut tidak ada / tidak terkoneksi!");
    }
    if(PlayerInfo[target_id][ePhone] == 0) return error_command(playerid, "Maaf pemain yang anda tuju harus menggunakan ponsel terlebih dahulu agar dapat menerima pm.");
    if(isnull(PlayerInfo[target_id][nomorHP])) return error_command(playerid, "Maaf pemain yang anda tuju harus memiliki nomor HP yang sudah terdaftar.");

    format(string, sizeof(string), "**[PM] (%d)%s : %s", playerid, PlayerInfo[playerid][pPlayerName], pesan);
    SendClientMessage(target_id, COLOR_YELLOW, string);
    if(PlayerInfo[target_id][reply] != playerid) PlayerInfo[target_id][reply] = playerid;

    format(string, sizeof(string), ">>[PM] (%d)%s : %s", target_id, PlayerInfo[target_id][pPlayerName], pesan);
    SendClientMessage(playerid, COLOR_ORANGE, string);
    return 1;
}

CMD:ephone(playerid, params[]){
    if(PlayerInfo[playerid][ePhone] == 0) return error_command(playerid, "Maaf anda harus menggunakan ponsel terlebih dahulu, untuk dpt menggunakan fitur ini.");
    showDialogEPhone(playerid);
    return 1;
}

CMD:killme(playerid, params[]){
    SetPlayerHealth(playerid, 0.0);
    return 1;
}

CMD:slap(playerid, params[]){
    new target_id;
    if(!IsPlayerAdmin(playerid)) return 0;
    if(sscanf(params, "u", target_id)) return error_syntax(playerid, "/slap [playerid]");
    if(!IsPlayerConnected(target_id)) return error_command(playerid, "Player yang dituju tidak ada!");

    new Float:pos[3];
    GetPlayerPos(target_id, pos[0], pos[1], pos[2]);
    SetPlayerPos(target_id, pos[0], pos[1], pos[2] + 4);
    PlayerPlaySound(target_id, 1130, pos[0], pos[1], pos[2] + 4);

    SendClientMessage(target_id, COLOR_LIGHT_BLUE, "Admin: anda telah di slap oleh admin.");
    return 1;
}

CMD:apapan(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return 0;
    showDialogAdminPapan(playerid);
    return 1;
}

CMD:arumah(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return 0;
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return error_command(playerid, "Maaf anda harus berada diluar Interior atau Virtual World 0!");
    ShowPlayerDialog(playerid, DIALOG_ADMIN_RUMAH, DIALOG_STYLE_LIST, WHITE"House Sytem :", "Buat Rumah\nReset Rumah\nHapus Rumah", "Pilih", "Batal");
    return 1;
}
CMD:inforumah(playerid, const params[]){
    if(lastHousePickup[playerid] == -1) return error_command(playerid, "Maaf anda tidak berada di ikon rumah!");
    new string[256],
    id,
    Float:x,
    Float:y,
    Float:z;
    id = houseId[lastHousePickup[playerid]];
    x = houseInfo[id][icon_x];
    y = houseInfo[id][icon_y];
    z = houseInfo[id][icon_z];
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return error_command(playerid, "Maaf anda tidak berada di ikon rumah!");
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
    ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_LIST, WHITE"Info Rumah :", string, "Pilih", "Batal");
    return 1;
}