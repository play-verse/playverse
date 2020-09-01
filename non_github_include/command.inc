CMD:kick(playerid, params[]){
	new target_id, pesan[256];
    if(!IsPlayerAdmin(playerid)) return error_command(playerid, "Anda tidak dapat menggunakan perintah ini!");
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
    format(pDialog[playerid], sizePDialog, "%s HUD Status\n", ((PlayerInfo[playerid][tampilHUDStats] == true) ? (RED"Sembunyikan") : (GREEN"Tampilkan")));
    strcatEx(pDialog[playerid], sizePDialog, "%s Speedo Kendaraan\n", ((PlayerInfo[playerid][tampilSpeedo] == true) ? (RED"Sembunyikan") : (GREEN"Tampilkan")));
    ShowPlayerDialog(playerid, DIALOG_PENGATURAN, DIALOG_STYLE_LIST, "Pilihan pengaturan : ", pDialog[playerid], "Pilih", "Batal");
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

CMD:inventory(playerid, const params[]){
    if(PlayerInfo[playerid][isBusy]) return SendClientMessage(playerid, COLOR_RED, TAG_SIBUK" "WHITE"Tidak dapat membuka inventory sekarang, anda sedang melakukan hal lain.");
    showDialogMenuInventory(playerid);
    return 1;
}

CMD:inv(playerid, params[]){
    cmd_inventory(playerid, "");
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

CMD:pindahpos(playerid, params[]){
    new Float:x, Float:y, Float:z, Float:a, int, vw;
    if(!IsPlayerAdmin(playerid)) return 0;
    if(sscanf(params, "ffffdd", x, y, z, a, int, vw)) return error_syntax(playerid, "/pindahpos [x] [y] [z] [a] [int] [vw]");

    pindahkanPemain(playerid, x, y, z, a, int, vw, true);	
    return 1;
}

CMD:aveh(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return 0;
    showDialogAdminVehicle(playerid);
    return 1;
}

CMD:giveitem(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return 0;

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
    new amount, target_id;
    if(!IsPlayerAdmin(playerid)) return 0;
    if(sscanf(params, "ud", target_id, amount)) return error_syntax(playerid, "/givemoney [id] [jumlah]");
    givePlayerUang(target_id, amount);
    return 1;
}

CMD:infosaya(playerid, params[]){
    ShowPlayerDialog(playerid, DIALOG_INFO_SAYA, DIALOG_STYLE_LIST, "Pilihan Info : ", "Skill\nInformasi Pribadi", "Pilih", "Batal");
    return 1;
}

CMD:skill(playerid, const params[]){
    if(PlayerInfo[playerid][isBusy]) return SendClientMessage(playerid, COLOR_RED, TAG_SIBUK" "WHITE"Tidak dapat menggunakan skill sekarang, anda sedang melakukan hal lain.");
    ShowPlayerDialog(playerid, DIALOG_MENU_SKILL, DIALOG_STYLE_LIST, "Skill", "Mekanik\nMedic", "Pilih", "Batal");
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
    cmd_v(playerid, "");
    return 1;
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

CMD:rumah(playerid, params[]){
    if(GetPlayerInterior(playerid) == 0) return error_command(playerid, "Anda tidak di dalam rumah manapun.");
    if(houseInfo[PlayerInfo[playerid][inHouse]][hOwner] != PlayerInfo[playerid][pID]) return error_command(playerid, "Anda bukan pemilik rumah.");
    ShowPlayerDialog(playerid, DIALOG_MENU_RUMAH, DIALOG_STYLE_LIST, "Menu Rumah : ", "Inventory Rumah\nSemua Furniture", "Pilih", "Tutup");
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

CMD:alumber(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return 0;
    ShowPlayerDialog(playerid, DIALOG_LUMBER_ADMIN, DIALOG_STYLE_LIST, WHITE"Lumberjack System :", "Buat Pohon\nEdit Pohon\nReset Pohon\nHapus Pohon", "Pilih", "Batal");
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

CMD:aatm(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return 0;
    ShowPlayerDialog(playerid, DIALOG_ADMIN_ATM, DIALOG_STYLE_LIST, "Menu admin untuk ATM :", "Buat ATM\nEdit ATM\nHapus ATM", "Pilih", "Batal");    
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

CMD:bicara(playerid, params[]){
    if(IsPlayerInRangeOfPoint(playerid, 3.0, ACT_skillMekanik_Pos[0], ACT_skillMekanik_Pos[1], ACT_skillMekanik_Pos[2])){
        ActorTalking(ACT_skillMekanik);
        format(pDialog[playerid], sizePDialog, GREEN"Hai %s,\n\
            "WHITE"Saya adalah ahli mekanik. Saya dapat membantu kamu dalam mendapatkan skill mekanik.\n\
            Untuk dapat membuka skill kamu harus memiliki "LIGHT_BLUE"1 item Segel Skill.\n\
            "WHITE"Apakah kamu memilikinya ?", PlayerInfo[playerid][pPlayerName]);
        ShowPlayerDialog(playerid, DIALOG_TALK_TO_AHLI_MEKANIK, DIALOG_STYLE_MSGBOX, "Ahli Mekanik berkata :", pDialog[playerid], "Ada", "Tidak ada");
    }
    // Actor Dealer
    else if(IsPlayerInRangeOfPoint(playerid, 3.0, ACT_penjualDealer_Pos[0], ACT_penjualDealer_Pos[1], ACT_penjualDealer_Pos[2])){
        ActorTalking(ACT_penjualDealer);
        format(pDialog[playerid], sizePDialog, GREEN"Hai %s,\n\
            "WHITE"Saya adalah manager dealer. \n\
            Kamu dapat mengurus beberapa hal yang berkaitan dengan dealer.\n\
            Adakah yang bisa saya bantu ?", PlayerInfo[playerid][pPlayerName]);
        ShowPlayerDialog(playerid, DIALOG_TALK_TO_DEALER_MANAGER, DIALOG_STYLE_MSGBOX, "Dealer Manager berkata :", pDialog[playerid], "Jawab", "Batal");
    }
    // Actor Toko Peralatan Pancing
    else if(IsPlayerInRangeOfPoint(playerid, 3.0, ACT_peralatanPancing_Pos[0], ACT_peralatanPancing_Pos[1], ACT_peralatanPancing_Pos[2])){
        ActorTalking(ACT_peralatanPancing);
        format(pDialog[playerid], sizePDialog, GREEN"Hai %s,\n\
            "WHITE"Saya adalah penjual peralatan pancing. \n\
            Kamu dapat mengurus beberapa hal yang berkaitan dengan peralatan pancing.\n\
            Adakah yang bisa saya bantu ?", PlayerInfo[playerid][pPlayerName]);
        ShowPlayerDialog(playerid, DIALOG_TALK_TO_PENJUAL_PANCING, DIALOG_STYLE_MSGBOX, "Penjual Peralatan Pancing berkata :", pDialog[playerid], "Jawab", "Batal");
    }
    // Actor Toko Bibit
    else if(IsPlayerInRangeOfPoint(playerid, 3.0, ACT_tokoBibit_Pos[0], ACT_tokoBibit_Pos[1], ACT_tokoBibit_Pos[2])){
        ActorTalking(ACT_tokoBibit);
        format(pDialog[playerid], sizePDialog, GREEN"Hai %s,\n\
            "WHITE"Saya adalah penjual bibit. \n\
            Kamu dapat mengurus beberapa hal yang berkaitan dengan bibit.\n\
            Adakah yang bisa saya bantu ?", PlayerInfo[playerid][pPlayerName]);
        ShowPlayerDialog(playerid, DIALOG_TALK_TO_PENJUAL_BIBIT, DIALOG_STYLE_MSGBOX, "Penjual Bibit berkata :", pDialog[playerid], "Jawab", "Batal");
    }
    // Actor Toko Bibit Narko
    else if(IsPlayerInRangeOfPoint(playerid, 3.0, POINT_NARKO[MrPuyengRand][NARKO_X], POINT_NARKO[MrPuyengRand][NARKO_Y], POINT_NARKO[MrPuyengRand][NARKO_Z])){
        ActorTalking(ACT_tokoNarko);
        format(pDialog[playerid], sizePDialog, GREEN"Hai %s,\n\
            "WHITE"Saya adalah penjual bibit ilegal. \n\
            Kamu dapat mengurus beberapa hal yang berkaitan dengan bibit ilegal.\n\
            Adakah yang bisa saya bantu ?", PlayerInfo[playerid][pPlayerName]);
        ShowPlayerDialog(playerid, DIALOG_TALK_TO_PENJUAL_BIBIT_NARKO, DIALOG_STYLE_MSGBOX, "Penjual Bibit Ilegal berkata :", pDialog[playerid], "Jawab", "Batal");
    }
    // Actor Toko Gadget
    else if(IsPlayerInRangeOfPoint(playerid, 3.0, ACT_tokoGadget_Pos[0], ACT_tokoGadget_Pos[1], ACT_tokoGadget_Pos[2])){
        ActorTalking(ACT_tokoGadget);
        format(pDialog[playerid], sizePDialog, GREEN"Hai %s,\n\
            "WHITE"Saya adalah penjual gadget. \n\
            Kamu dapat mengurus beberapa hal yang berkaitan dengan gadget.\n\
            Adakah yang bisa saya bantu ?", PlayerInfo[playerid][pPlayerName]);
        ShowPlayerDialog(playerid, DIALOG_TALK_TO_PENJUAL_GADGET, DIALOG_STYLE_MSGBOX, "Penjual Gadget berkata :", pDialog[playerid], "Jawab", "Batal");
    }

    // Lakukan cara yang sama seperti diatas jika menambah untuk yang lain
    // GetDynamicActor... IsPlayerInRange .. return

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

/**
    Admin Faction
 */
CMD:setmedic(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return 0;

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
    if(!IsPlayerAdmin(playerid)) return 0;

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
    if(!IsPlayerAdmin(playerid)) return 0;

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
    if(!IsPlayerAdmin(playerid)) return 0;

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


CMD:aactor(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return 0;
    ShowPlayerDialog(playerid, DIALOG_ADMIN_ACTOR, DIALOG_STYLE_LIST, "Menu admin untuk Actor :", "Respawn Actor", "Pilih", "Batal");    
    return 1;
}

CMD:panggilmedis(playerid, params[]){
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
    new text[50];
    if(sscanf(params, "s[50]", text))
        return error_syntax(playerid, "/hancurkan [aksi]");

    if(sama(text, "ganja") && IsPlayerOnDutyPolice(playerid)){
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

/**
    Animations
 */
CMD:duduk(playerid, params[]){
    if(PlayerInfo[playerid][isOnAnimation] || PlayerInfo[playerid][isBusy])
        return error_command(playerid, "Anda sedang tidak bisa melakukan hal ini sekarang.");
    PlayerInfo[playerid][isOnAnimation] = true;
    ApplyAnimation(playerid, "PED", "SEAT_DOWN", 4.1, 0, 0, 0, 1, 0, 1);
    return 1;
}

CMD:berdiri(playerid, params[]){
    new temp[2][15];
    GetAnimationName(GetPlayerAnimationIndex(playerid), temp[0], 15, temp[1], 15);
    if(!sama(temp[0], "PED") || !sama(temp[1], "SEAT_DOWN"))
        return server_message(playerid, "Anda sedang tidak duduk.");
    PlayerInfo[playerid][isOnAnimation] = false;
    ApplyAnimation(playerid, "PED", "SEAT_UP", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}
/**
    End Animations
 */