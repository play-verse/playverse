// City Hall Dialog
showDialogResepsionis(playerid){
    return ShowPlayerDialog(playerid, DIALOG_RESPSIONIS_PEMERINTAH, DIALOG_STYLE_LIST, "Pilihan tindakan pengurusan data", "KTP\nPembuatan Nomor HP\nPerpanjang Masa Aktif Nomor HP", "Pilih", "Batal");
}

showDialogListItem(playerid){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT b.id_item, b.nama_item, b.keterangan, b.fungsi, b.model_id, a.kunci, a.id_user_item, a.jumlah FROM `user_item` a INNER JOIN `item` b ON a.id_item = b.id_item WHERE a.`id_user` = '%d' AND a.jumlah > 0 ORDER BY nama_item ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
    mysql_tquery(koneksi, pQuery[playerid], "tampilInventoryBarangPlayer", "i", playerid);    
}

showDialogListFurniturePemain(playerid){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT a.id, b.nama_furniture, b.id_object, a.id_furniture, a.jumlah, b.keterangan FROM user_furniture a INNER JOIN furniture b ON a.id_furniture = b.id WHERE a.id_user = '%d' AND a.jumlah > 0 ORDER BY b.nama_furniture ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
    mysql_tquery(koneksi, pQuery[playerid], "tampilInventoryFurniturePlayer", "i", playerid);
}

showDialogRespsionisKTP(playerid){
    return ShowPlayerDialog(playerid, DIALOG_RESPSIONIS_PILIH_KTP, DIALOG_STYLE_LIST, "Pilihan tindakan KTP", "Buat KTP\nAmbil KTP yang sudah selesai", "Pilih", "Kembali");
}

showDialogTellerBank(playerid){
    return ShowPlayerDialog(playerid, DIALOG_TELLER_BANK, DIALOG_STYLE_LIST, "Pilihan pengurusan administrasi Bank", "Buat Rekening ATM\nDeposit ke Tabungan\nGaji\nBayar Biaya Perbaiki Kendaraan Rusak", "Pilih", "Tutup");
}

showDialogPesan(playerid, const judul_pesan[], const isi_pesan[]){
	return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, judul_pesan, isi_pesan, "Ok", "");
}

/**
    ```
        Keterangan diisi dengan pesan error
    ```
 */
showDialogKesalahanSistem(playerid, const keterangan[]){
    format(pDialog[playerid], sizePDialog, ORANGE"Terdapat kesalah pada sistem.\n\n"WHITE"Silahkan hubungi administrator "GREEN"dengan cara mengirimkan screenshot ini.\n\n"WHITE"Keterangan error : "GREY"%s\n\n"WHITE"Silahkan screenshot sekarang dengan cara menekan "YELLOW"F8 "WHITE"dan segera hubungi administrator sertakan gambar juga. Terimakasih.", keterangan);
    ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, ORANGE"Kesalahan sistem", pDialog[playerid], "Tutup", "");
}

showDialogPilihWarnaKendaraan(playerid, id_dialog, const judul_dialog[]){
    if(sizeof(gVehicleColors) < BANYAK_DATA_PER_PAGE * 6 * GetPVarInt(playerid, "halaman")){
        SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
    }
    new longStringDialog[50 * BANYAK_DATA_PER_PAGE * 6];

    for (new colorid = BANYAK_DATA_PER_PAGE * 6 * GetPVarInt(playerid, "halaman"); colorid < sizeof(gVehicleColors) && colorid < BANYAK_DATA_PER_PAGE * 6 * (GetPVarInt(playerid, "halaman") + 1); colorid++)
    {
        if(colorid == BANYAK_DATA_PER_PAGE * 6 * GetPVarInt(playerid, "halaman"))
            format(longStringDialog, sizeof(longStringDialog), "{%06x}########## "WHITE"- %d\n", gVehicleColors[colorid] >>> 8, colorid);
        else
            format(longStringDialog, sizeof(longStringDialog), "%s{%06x}########## "WHITE"- %d\n", longStringDialog, gVehicleColors[colorid] >>> 8, colorid);
    }
    strcat(longStringDialog, ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

    return ShowPlayerDialog(playerid, id_dialog, DIALOG_STYLE_LIST, judul_dialog, longStringDialog, "Pilih", "Batal");    
}

showDialogAmbilMobilReparasi(playerid){
    new string[250 * BANYAK_DATA_PER_PAGE + 200];
    format(string, sizeof(string), "Kode\tNama\n");
    
    foreach(new i : PVehIterator){
        if(PVeh[i][pVehPemilik] == PlayerInfo[playerid][pID]){
            if(PVeh[i][pVehIsReparasi] == 2){ // Jika mobil sedang dalam reparasi (telah rusak)
                format(string, sizeof(string), "%s%d\t%s\n", string, i, GetVehicleModelName(PVeh[i][pVehModel]));
            }
        }
    }

    if(strcmp(string, "Kode\tNama\n") == 0){
        showDialogPesan(playerid, RED"Tidak terdapat kendaraan", WHITE"Tidak terdapat kendaraan apapun yang sudah diperbaiki.\nJika anda mencari kendaraan anda yang rusak, silahkan bayar terlebih dahulu di bank kemudian ambil disini.");
    }else
        ShowPlayerDialog(playerid, DIALOG_AMBIL_KENDARAAN_REPARASI, DIALOG_STYLE_TABLIST_HEADERS, "Kendaraan yang tersedia.", string, "Pilih", "Batal");
}

showDialogMenuInventory(playerid){
    inline responseQuery(){
        new total_item, string[500];
        cache_get_value_name_int(0, "total_item", total_item);
        if(total_item >= PlayerInfo[playerid][limitItem]){
            format(string, 500, WHITE"Item\t"RED"(%i/%i)\nSkin\nKendaraan\nFurniture\nRumah", total_item, PlayerInfo[playerid][limitItem]);
            ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "Inventory", string, "Pilih", "Batal");
        }else{
            format(string, 500, WHITE"Item\t"GREEN"(%i/%i)\nSkin\nKendaraan\nFurniture\nRumah", total_item, PlayerInfo[playerid][limitItem]);
            ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "Inventory", string, "Pilih", "Batal");
        }
    }
	MySQL_TQueryInline(koneksi, using inline responseQuery, "SELECT SUM(a.jumlah * b.kapasitas) as total_item FROM user_item a INNER JOIN item b ON a.id_item = b.id_item WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
}

showDialogEPhone(playerid){
	new string[500];
    // Switch berdasarkan id item
    switch(PlayerInfo[playerid][ePhone])
    {
        case 1:
        {
            format(string, sizeof(string), "Kirim Pesan\nPesan Masuk\nPesan Terkirim");
        }
        case 2: 
        {
            format(string, sizeof(string), "Kirim Pesan\nPesan Masuk\nPesan Terkirim\nATM M-Banking");
        }
        case 3:
        {
            format(string, sizeof(string), "Kirim Pesan\nPesan Masuk\nPesan Terkirim\nATM M-Banking\nSharelock");
        }
        case 4:
        {            
            format(string, sizeof(string), "Kirim Pesan\nPesan Masuk\nPesan Terkirim\nATM M-Banking\nSharelock\nOnline Marketplace");
        }
        default:
        {
            // Worst case
            return error_command(playerid, "Maaf terjadi kesalahan pada akun anda, silahkan mengirimkan report ke pada administrator. "ORANGE"(Error Kode #007 EPhone)");
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_MENU_EPHONE, DIALOG_STYLE_LIST, WHITE"ePhone menu :", string, "Pilih", "Batal");
}

showDialogBeliBarang(playerid){
	new subString[100];
    static string[sizeof(BARANG_MARKET) * 100];

    if(string[0] == EOS){
		for(new i = 0; i < sizeof(BARANG_MARKET); i++){
			format(subString, sizeof(subString), "%i\t%s~n~~g~$%d\n", BARANG_MARKET[i][idModelBarang], BARANG_MARKET[i][namaBarang], BARANG_MARKET[i][hargaBarang]);
            strcat(string, subString);
		}
	}
	ShowPlayerDialog(playerid, DIALOG_BELI_BARANG_MARKET, DIALOG_STYLE_PREVIEW_MODEL, "Beli Barang", string, "Beli", "Batal");
	return 1;
}

showDialogATM(playerid){
	return ShowPlayerDialog(playerid, DIALOG_ATM, DIALOG_STYLE_LIST, "Menu ATM", "Transfer Uang\nPenarikan Uang\nInfo Saldo\nHistory Rekening", "Ok", "Batal");
}

showDialogEBank(playerid){
	return ShowPlayerDialog(playerid, DIALOG_E_BANKING_MENU, DIALOG_STYLE_LIST, WHITE"Menu E-Banking", WHITE"Info Saldo\nTransfer Uang\nHistory Rekening", "Pilih", "Batal");
}

showDialogBeliBibit(playerid){
    static str_daftar_bibit[sizeof(MENU_BIBIT) * 100 + 100], subString[100];
    if(str_daftar_bibit[0] == EOS){
        strcat(str_daftar_bibit, WHITE"Nama\tHarga\n");
        for(new i = 0; i < sizeof(MENU_BIBIT); i++){
            format(subString, 100, WHITE"%s\t"GREEN"$%d\n", MENU_BIBIT[i][namaBibit], MENU_BIBIT[i][hargaBibit]);
            strcat(str_daftar_bibit, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_MENU_BELI_BIBIT, DIALOG_STYLE_TABLIST_HEADERS, "Menu Bibit", str_daftar_bibit, "Pilih", "Batal");
}

showDialogBeliBibitNarko(playerid){
    static str_daftar_bibit[sizeof(MENU_BIBIT_NARKO) * 100 + 100], subString[100];
    if(str_daftar_bibit[0] == EOS){
        strcat(str_daftar_bibit, WHITE"Nama\tHarga\n");
        for(new i = 0; i < sizeof(MENU_BIBIT_NARKO); i++){
            format(subString, 100, WHITE"%s\t"GREEN"$%d\n", MENU_BIBIT_NARKO[i][namaBibit], MENU_BIBIT_NARKO[i][hargaBibit]);
            strcat(str_daftar_bibit, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_MENU_BELI_BIBIT_NARKO, DIALOG_STYLE_TABLIST_HEADERS, "Menu Bibit", str_daftar_bibit, "Pilih", "Batal");
}

showDialogBeliAlatPancing(playerid){
    static str_daftar_bibit[sizeof(MENU_ALAT_PANCING) * 100 + 100], subString[100];
    if(str_daftar_bibit[0] == EOS){
        strcat(str_daftar_bibit, WHITE"Nama\tHarga\n");
        for(new i = 0; i < sizeof(MENU_ALAT_PANCING); i++){
            format(subString, 100, WHITE"%s\t"GREEN"$%d\n", MENU_ALAT_PANCING[i][namaItem], MENU_ALAT_PANCING[i][hargaItem]);
            strcat(str_daftar_bibit, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_MENU_BELI_ALAT_PANCING, DIALOG_STYLE_TABLIST_HEADERS, "Menu Peralatan Pancing", str_daftar_bibit, "Pilih", "Batal");
}

showDialogTempatMakan(playerid){
    static str_daftar_makanan[sizeof(MENU_MAKANAN) * 100 + 100], subString[100];
    if(str_daftar_makanan[0] == EOS){
        strcat(str_daftar_makanan, WHITE"Nama\tHarga\n");
        for(new i = 0; i < sizeof(MENU_MAKANAN); i++){
            format(subString, 100, WHITE"%s\t"GREEN"$%d\n", MENU_MAKANAN[i][namaMakanan], MENU_MAKANAN[i][hargaMakanan]);
            strcat(str_daftar_makanan, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_MENU_BELI_MAKAN, DIALOG_STYLE_TABLIST_HEADERS, "Menu hidangan.", str_daftar_makanan, "Pilih", "Batal");
}

showDialogSimRegis(playerid){
    return ShowPlayerDialog(playerid, DIALOG_SIM_REGIS_MENU, DIALOG_STYLE_LIST, WHITE"Pilihan tindakan SIM", "Buat SIM\nAmbil SIM yang sudah selesai", "Pilih", "Kembali");
}

showDialogSimPraktik(playerid){
    return ShowPlayerDialog(playerid, DIALOG_SIM_PRAKTIK_MENU, DIALOG_STYLE_LIST, WHITE"Pilihan tindakan SIM", "Mulai Praktik", "Pilih", "Kembali");
}

showDialogAdminPapan(playerid){
    return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN, DIALOG_STYLE_LIST, ORANGE"Admin Menu untuk Papan", "Get ID Papan Sekitar\nTeleport ke Papan\nBuat Papan\nEdit Posisi Papan\nEdit Text\nEdit Ukuran Text\nHapus Papan", "Pilih", "Batal");
}

showDialogAdminVehicle(playerid){
    return ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE, DIALOG_STYLE_LIST, ORANGE"Admin Menu untuk kendaraan", "Buat Kendaraan\nParkir Kendaraan Dealer\nRespawn Semua kendaraan Dealer\nHapus Kendaraan Dealer ini", "Pilih", "Batal");
}

showDialogBeliPerabot(playerid){
    static str_daftar_perabot[sizeof(PERABOT_DIJUAL) * 100 + 100];
    if(str_daftar_perabot[0] == EOS){
        strcat(str_daftar_perabot, WHITE"Nama\tHarga\n");
        for(new i = 0; i < sizeof(PERABOT_DIJUAL); i++){
            strcatEx(str_daftar_perabot, sizeof(str_daftar_perabot), "%s\t$%d\n", PERABOT_DIJUAL[i][NamaPerabotDijual], PERABOT_DIJUAL[i][HargaPerabotDijual]);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_MENU_BELI_PERABOT, DIALOG_STYLE_TABLIST_HEADERS, "Furniture tersedia.", str_daftar_perabot, "Pilih", "Batal");
}

dialogInventoryItemTidakMuat(playerid, jumlah_yang_ingin_dimasukan, total_didalam_tas, id_item = -1, kapasitas_unpredict = 1){
    if(id_item == -1) {
        format(pDialog[playerid], sizePDialog, WHITE"Maaf inventory item anda tidak memiliki cukup ruang,\n\
        Anda harus menyisihkan setidaknya "ORANGE"%i "WHITE" slot item.\n\
        Ruang inventory item anda sekarang adalah "ORANGE"(%i/%i).", jumlah_yang_ingin_dimasukan * kapasitas_unpredict, total_didalam_tas, PlayerInfo[playerid][limitItem]);
    }
    else {
        format(pDialog[playerid], sizePDialog, WHITE"Maaf inventory item anda tidak memiliki cukup ruang,\n\
        Untuk menyimpan sebanyak "ORANGE"%i "WHITE"yang membutuhkan kapasitas "ORANGE"%i per itemnya.\n", jumlah_yang_ingin_dimasukan, getKapasitasByIdItem(id_item));
        
        format(pDialog[playerid], sizePDialog, "%s\
        Anda harus menyisihkan "ORANGE"%i slot item "WHITE"untuk dapat menyimpan item ini.\n\
        Ruang inventory item anda sekarang adalah "ORANGE"(%i/%i).\n", pDialog[playerid], getKapasitasByIdItem(id_item) * jumlah_yang_ingin_dimasukan, total_didalam_tas, PlayerInfo[playerid][limitItem]);
    }
    return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Inventory tidak cukup", pDialog[playerid], "Ok", "");
}

showDialogDealerManager(playerid){
    return ShowPlayerDialog(playerid, DIALOG_TALK_TO_DEALER_MANAGER_LIST, DIALOG_STYLE_LIST, "Pilih jawaban : ", "\
        Saya ingin menjual mobil", "Pilih", "Batal");
}