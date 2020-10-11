// City Hall Dialog
showDialogResepsionis(playerid){
    return ShowPlayerDialog(playerid, DIALOG_RESEPSIONIS_PEMERINTAH, DIALOG_STYLE_LIST, "Pilihan tindakan pengurusan data", "KTP\nPembuatan Nomor HP\nPerpanjang Masa Aktif Nomor HP", "Pilih", "Batal");
}

showDialogListItem(playerid, fromplayerid = INVALID_PLAYER_ID, dialogid = DIALOG_PILIH_ITEM){
    if(fromplayerid == INVALID_PLAYER_ID)
        fromplayerid = playerid;

	format(pDialog[playerid], sizePDialog, "Nama\tJumlah\tKapasitas per Item\tKapasitas Terpakai\n");
	
    new subString[64], 
        jumlah, 
        nama_item[100], 
        kapasitas, 
        idx_temp = 0
    ;
    
    LoopingItem(id_item){
        jumlah = GetJumlahItemPlayer(fromplayerid, id_item);
        if(jumlah < 1) continue;

        // Cek jika item yang sedang di looping adalah item yang ada pada halaman
        if(floatround(idx_temp / BANYAK_DATA_PER_PAGE, floatround_floor) == GetPVarInt(playerid, "halaman")){
            getNamaByIdItem(id_item, nama_item);
            kapasitas = getKapasitasByIdItem(id_item);

            strcatEx(pDialog[playerid], sizePDialog, "%s%s\t"WHITE"%i\t%i\t%i\n", GetColorRarity(getRarityByIdItem(id_item)), nama_item, jumlah, kapasitas, kapasitas * jumlah);

            // Gunakan konsep Antrian
            TempPlayerDialog[playerid][idx_temp % BANYAK_DATA_PER_PAGE] = id_item;
        }
        idx_temp++;

        // Cek jika item yang terlooping sudah melebihi halaman
        if(floatround(idx_temp / BANYAK_DATA_PER_PAGE, floatround_floor) > GetPVarInt(playerid, "halaman")) break;
    }

    if(idx_temp == 0){
        if(fromplayerid != playerid)
            return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Inventory item "RED"kosong", WHITE"Maaf saat ini inventory player tersebut tidak berisi apapun!", "Ok", "");

        return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Inventory item "RED"kosong", WHITE"Maaf saat ini inventory item anda tidak berisi apapun!\n"YELLOW"Anda bisa mendapatkan item dari bekerja, berbelanja, ataupun saling bertukar item kepada player lain!", "Ok", "");
    }else if(floatround(idx_temp / BANYAK_DATA_PER_PAGE, floatround_floor) < GetPVarInt(playerid, "halaman")){
        if(GetPVarInt(playerid, "halaman") < 1) return 0; // Keluar dari fungsi jika kondisi aneh?
        SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
        return showDialogListItem(playerid, fromplayerid, dialogid);
    }

    strcat(pDialog[playerid], ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

    if(fromplayerid != playerid)
        format(subString, 64, WHITE"List Inventory %s : "GREEN"(page : %d)", PlayerInfo[fromplayerid][pPlayerName], GetPVarInt(playerid, "halaman") + 1);
    else
        format(subString, 64, WHITE"Pilih barang anda : "GREEN"(page : %d)", GetPVarInt(playerid, "halaman") + 1);
    
    // Case ini saja
    if(dialogid == DIALOG_PERIKSA_INVENTORY)
        return ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, subString, pDialog[playerid], "Tutup", "");
    else
        return ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, subString, pDialog[playerid], "Pilih", "Kembali");
}

showDialogBeliItemMarketplace(playerid){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT a.*, b.nama FROM marketplace a INNER JOIN `user` b ON b.id = a.id_user WHERE a.status = 0 AND a.id_user != %d ORDER BY a.tanggal DESC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
    mysql_tquery(koneksi, pQuery[playerid], "tampilListMarketplace", "i", playerid);
}

showDialogDaganganMarketplace(playerid){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM marketplace WHERE id_user = %d", PlayerInfo[playerid][pID]);
    mysql_tquery(koneksi, pQuery[playerid], "tampilListDaganganMarketplace", "i", playerid);
}

showDialogListFurniturePemain(playerid){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT a.id, b.nama_furniture, b.id_object, a.id_furniture, a.jumlah, b.keterangan FROM user_furniture a INNER JOIN furniture b ON a.id_furniture = b.id WHERE a.id_user = '%d' AND a.jumlah > 0 ORDER BY b.nama_furniture ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
    mysql_tquery(koneksi, pQuery[playerid], "tampilInventoryFurniturePlayer", "i", playerid);
}

showDialogResepsionisKTP(playerid){
    return ShowPlayerDialog(playerid, DIALOG_RESEPSIONIS_PILIH_KTP, DIALOG_STYLE_LIST, "Pilihan tindakan KTP", "Buat KTP\nAmbil KTP yang sudah selesai", "Pilih", "Kembali");
}

// showDialogTellerBank(playerid){
//     return ShowPlayerDialog(playerid, DIALOG_TELLER_BANK, DIALOG_STYLE_LIST, "Pilihan pengurusan administrasi Bank", "Buat Rekening ATM\nDeposit ke Tabungan\nGaji\nBayar Biaya Perbaiki Kendaraan Rusak", "Pilih", "Tutup");
// }

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
    if(GetSlotInventoryPlayer(playerid) >= PlayerInfo[playerid][limitItem]){
        format(pDialog[playerid], 200, WHITE"Item\t"RED"(%i/%i)\nSkin\nKendaraan\nFurniture\nRumah", GetSlotInventoryPlayer(playerid), PlayerInfo[playerid][limitItem]);
        ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "Inventory", pDialog[playerid], "Pilih", "Batal");
    }else{
        format(pDialog[playerid], 200, WHITE"Item\t"GREEN"(%i/%i)\nSkin\nKendaraan\nFurniture\nRumah", GetSlotInventoryPlayer(playerid), PlayerInfo[playerid][limitItem]);
        ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "Inventory", pDialog[playerid], "Pilih", "Batal");
    }
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
	new subString[100], 
        id_model,
        nama_item[50];
    static string[sizeof(BARANG_MARKET) * 100];

    if(string[0] == EOS){
		for(new i = 0; i < sizeof(BARANG_MARKET); i++){
            id_model = getModelByIdItem(BARANG_MARKET[i][idItemMarket]);
            getNamaByIdItem(BARANG_MARKET[i][idItemMarket], nama_item);
			format(subString, sizeof(subString), "%i\t%s~n~~g~$%d\n", id_model, nama_item, BARANG_MARKET[i][hargaItemMarket]);
            strcat(string, subString);
		}
	}
	ShowPlayerDialog(playerid, DIALOG_BELI_BARANG_MARKET, DIALOG_STYLE_PREVIEW_MODEL, "Beli Barang", string, "Beli", "Batal");
	return 1;
}

showDialogATM(playerid){
    PlayerAtmAnimation(playerid); // Opening dialog while playing animation
	
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
    static str_daftar_pancing[sizeof(MENU_ALAT_PANCING) * 100 + 100], subString[100];
    if(str_daftar_pancing[0] == EOS){
        strcat(str_daftar_pancing, WHITE"Nama\tHarga\n");
        for(new i = 0; i < sizeof(MENU_ALAT_PANCING); i++){
            format(subString, 100, WHITE"%s\t"GREEN"$%d\n", MENU_ALAT_PANCING[i][namaItem], MENU_ALAT_PANCING[i][hargaItem]);
            strcat(str_daftar_pancing, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_MENU_BELI_ALAT_PANCING, DIALOG_STYLE_TABLIST_HEADERS, "Menu Peralatan Pancing", str_daftar_pancing, "Pilih", "Batal");
}

showDialogTempatMakan(playerid){
    static str_daftar_makanan[sizeof(MENU_MAKANAN) * 100 + 100], subString[100],
        nama_item[50];
    if(str_daftar_makanan[0] == EOS){
        strcat(str_daftar_makanan, WHITE"Nama\tHarga\n");
        for(new i = 0; i < sizeof(MENU_MAKANAN); i++){
            getNamaByIdItem(MENU_MAKANAN[i][idItemMakanan], nama_item);
            format(subString, 100, WHITE"%s\t"GREEN"$%d\n", nama_item, MENU_MAKANAN[i][hargaMakanan]);
            strcat(str_daftar_makanan, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_MENU_BELI_MAKAN, DIALOG_STYLE_TABLIST_HEADERS, "Menu hidangan.", str_daftar_makanan, "Pilih", "Batal");
}

showDialogBeliAlat(playerid){
    static str_beli[sizeof(MENU_ALAT_MEKANIK) * 50];
    if(str_beli[0] == '\0'){
        new nama_item[50];
        strcat(str_beli, "Nama\tHarga\n");
        for (new i = 0; i < sizeof(MENU_ALAT_MEKANIK); i++){
            getNamaByIdItem(MENU_ALAT_MEKANIK[i][idItemAlat], nama_item);
            strcatEx(str_beli, sizeof(str_beli), WHITE"%s\t"GREEN"$%d\n", nama_item, MENU_ALAT_MEKANIK[i][hargaAlat]);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_BELI_ALAT_MEKANIK, DIALOG_STYLE_TABLIST_HEADERS, "Silahkan pilih alat yang ingin dibeli", str_beli, "Beli", "Batal");
}

showDialogBeliItemMedis(playerid){
    static str_beli[sizeof(MENU_BELI_ITEM_MEDIS) * 50];
    if(str_beli[0] == '\0'){
        new nama_item[50];
        strcat(str_beli, "Nama\tHarga\n");
        for (new i = 0; i < sizeof(MENU_BELI_ITEM_MEDIS); i++){
            getNamaByIdItem(MENU_BELI_ITEM_MEDIS[i][idItemMarket], nama_item);
            strcatEx(str_beli, sizeof(str_beli), WHITE"%s\t"GREEN"$%d\n", nama_item, MENU_BELI_ITEM_MEDIS[i][hargaItemMarket]);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_MEDIS, DIALOG_STYLE_TABLIST_HEADERS, "Silahkan pilih alat yang ingin dibeli", str_beli, "Beli", "Batal");
}

showDialogBeliBlacksmith(playerid){
    static str_beli[sizeof(MENU_ALAT_BLACKSMITH) * 50];
    if(str_beli[0] == '\0'){
        new nama_item[50];
        strcat(str_beli, "Nama\tHarga\n");
        for (new i = 0; i < sizeof(MENU_ALAT_BLACKSMITH); i++){
            getNamaByIdItem(MENU_ALAT_BLACKSMITH[i][idItemAlat], nama_item);
            strcatEx(str_beli, sizeof(str_beli), WHITE"%s\t"GREEN"$%d\n", nama_item, MENU_ALAT_BLACKSMITH[i][hargaAlat]);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_BELI_ALAT_BLACKSMITH, DIALOG_STYLE_TABLIST_HEADERS, "Silahkan pilih alat yang ingin dibeli", str_beli, "Beli", "Batal");
}

showDialogBeliPhone(playerid){
    static str_daftar_phone[sizeof(MENU_PHONE) * 100 + 100], subString[100];
    if(str_daftar_phone[0] == EOS){
        new nama_item[50];
        strcat(str_daftar_phone, WHITE"Nama\tHarga\n");
        for(new i = 0; i < sizeof(MENU_PHONE); i++){
            getNamaByIdItem(MENU_PHONE[i][idItemMarket], nama_item);
            format(subString, 100, WHITE"%s\t"GREEN"$%d\n", nama_item, MENU_PHONE[i][hargaItemMarket]);
            strcat(str_daftar_phone, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_MENU_BELI_PHONE, DIALOG_STYLE_TABLIST_HEADERS, "Menu Gadget.", str_daftar_phone, "Pilih", "Batal");
}

showDialogSimRegis(playerid){
    return ShowPlayerDialog(playerid, DIALOG_SIM_REGIS_MENU, DIALOG_STYLE_LIST, WHITE"Pilihan tindakan SIM", "Buat SIM\nTentang SIM (Tipe Kendaraan)\nAmbil SIM yang sudah selesai", "Pilih", "Batal");
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

showDialogPenjualPancing(playerid){
    return ShowPlayerDialog(playerid, DIALOG_TALK_TO_PENJUAL_PANCING_LIST, DIALOG_STYLE_LIST, "Pilih jawaban : ", "\
        Saya ingin membeli peralatan pancing", "Pilih", "Batal");
}

showDialogPenjualBibit(playerid){
    return ShowPlayerDialog(playerid, DIALOG_TALK_TO_PENJUAL_BIBIT_LIST, DIALOG_STYLE_LIST, "Pilih jawaban : ", "\
        Saya ingin membeli bibit", "Pilih", "Batal");
}

showDialogPenjualBibitNarko(playerid){
    return ShowPlayerDialog(playerid, DIALOG_TALK_TO_PENJUAL_BIBIT_NARKO_LIST, DIALOG_STYLE_LIST, "Pilih jawaban : ", "\
        Saya ingin membeli bibit ilegal", "Pilih", "Batal");
}

showDialogPenjualGadget(playerid){
    return ShowPlayerDialog(playerid, DIALOG_TALK_TO_PENJUAL_GADGET_LIST, DIALOG_STYLE_LIST, "Pilih jawaban : ", "\
        Saya ingin membeli phone", "Pilih", "Batal");
}

showDialogPilihBensin(playerid){
    return ShowPlayerDialog(
        playerid, 
        DIALOG_PILIH_ISI_BENSIN, 
        DIALOG_STYLE_LIST, 
        "Pilih bensin yang ingin diisi.", 
        WHITE"Bensin 20 persen\t"GREEN"$5\n\
        "WHITE"Bensin 50 persen\t"GREEN"$10\n\
        "WHITE"Bensin 100 persen\t"GREEN"$17", 
        "Pilih", 
        "Batal"
    );
}

showDialogGuideKantorPemerintah(playerid){
    static str_guide[1500];
    if(str_guide[0] == '\0'){
        strcat(str_guide, YELLOW"Guide interaksi dengan resepsionis.\n\n");
        strcat(str_guide, WHITE"Anda perlu mengetahui nama resepsionis, nama resepsionis sekarang adalah "GREEN""NAMA_ACTOR_PEMERINTAH"\n\n");
        strcat(str_guide, WHITE"Jika anda lupa nama resepsionis silahkan tanya dengan "YELLOW"siapa nama kamu?\n\n");
        strcat(str_guide, WHITE"Untuk berbicara/mengawali percakapan dengan resepsionis anda dapat menggunakan "GREEN"Halo "NAMA_ACTOR_PEMERINTAH"\n");
        strcat(str_guide, WHITE"Perlu diketahui bahwa resepsionis hanya dapat merespon satu persatu orang.\n");
        strcat(str_guide, "Resepsionis tidak akan merespon jika ada orang lain yang sedang berinteraksi dengannya\n");
        strcat(str_guide, "Resepsionis juga tidak akan menjawab jika anda tidak berada didekatnya.\n");
        strcat(str_guide, YELLOW"Perlu diketahui bahwa saat berbicara dengannya anda tidak boleh menjauh dari resepsionis.\n");
        strcatEx(str_guide, 2000, "Anda hanya diberi waktu "RED"%d detik "YELLOW"untuk menjawab\n\n", LAMA_BATAS_RESPON_RESEPSIONIS);
        strcat(str_guide, WHITE"Beberapa hal yang dapat diurus disini melalui resepsionis\nPastikan anda mengawali percakapan seperti yang dijelaskan diatas.\n");
        strcat(str_guide, "1. Katakan "YELLOW"saya ingin buat ktp"WHITE" untuk membuat ktp.\n");
        strcat(str_guide, "2. Katakan "YELLOW"saya ingin ambil ktp yang sudah selesai"WHITE" untuk mengambil ktp yang telah anda urus sebelumnya.\n");
        strcat(str_guide, "3. Katakan "YELLOW"saya ingin buat nomor hp"WHITE" untuk membuat nomor hp baru jika anda belum punya.\n");
        strcat(str_guide, "4. Katakan "YELLOW"saya ingin perpanjang masa aktif nomor hp"WHITE" untuk memperpanjang masa aktif nomor yang ada.\n");
        strcat(str_guide, "\nJika anda menjawab tidak seperti keempat hal diatas,\nmaka resepsionis tidak akan mengerti maksud anda dan akan memberhentikan percakapan.\n\n");
        strcat(str_guide, YELLOW"Jika masih tidak mengerti dengan hal diatas silahkan tanyakan di forum. Terimakasih telah membaca.\n");
    }
    ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Guide Interaksi Resepsionis", str_guide, "Ok", "");
}

showDialogGuideAhliMekanik(playerid){
    static str_guide[1500];
    if(str_guide[0] == '\0'){
        strcat(str_guide, YELLOW"Guide interaksi dengan ahli mekanik.\n\n");
        strcat(str_guide, WHITE"Anda perlu mengetahui nama ahli mekanik, nama ahli mekanik sekarang adalah "GREEN""NAMA_ACTOR_SKILL_MEKANIK"\n\n");
        strcat(str_guide, WHITE"Jika anda lupa nama ahli mekanik silahkan tanya dengan "YELLOW"siapa nama kamu?\n\n");
        strcat(str_guide, WHITE"Untuk berbicara/mengawali percakapan dengan ahli mekanik anda dapat menggunakan "GREEN"Halo "NAMA_ACTOR_SKILL_MEKANIK"\n");
        strcat(str_guide, WHITE"Perlu diketahui bahwa ahli mekanik hanya dapat merespon satu persatu orang.\n");
        strcat(str_guide, "Ahli mekanik tidak akan merespon jika ada orang lain yang sedang berinteraksi dengannya\n");
        strcat(str_guide, "Ahli mekanik juga tidak akan menjawab jika anda tidak berada didekatnya.\n");
        strcat(str_guide, YELLOW"Perlu diketahui bahwa saat berbicara dengannya anda tidak boleh menjauh dari ahli mekanik.\n");
        strcatEx(str_guide, 2000, "Anda hanya diberi waktu "RED"%d detik "YELLOW"untuk menjawab\n\n", LAMA_BATAS_RESPON_RESEPSIONIS);
        strcat(str_guide, WHITE"Beberapa hal yang dapat di interaksikan disini melalui ahli mekanik\nPastikan anda mengawali percakapan seperti yang dijelaskan diatas.\n");
        strcat(str_guide, "1. Katakan "YELLOW"saya ingin mengaktifkan skill mekanik"WHITE" untuk mengaktifkan skill mekanik.\n");
        strcat(str_guide, "2. Katakan "YELLOW"saya ingin membeli item"WHITE" untuk membeli item-item yang berkaitan dengan mekanik.\n");
        strcat(str_guide, "\nJika anda menjawab tidak seperti hal diatas,\nmaka ahli mekanik tidak akan mengerti maksud anda dan akan memberhentikan percakapan.\n\n");
        strcat(str_guide, YELLOW"Jika masih tidak mengerti dengan hal diatas silahkan tanyakan di forum. Terimakasih telah membaca.\n");
    }
    ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Guide Interaksi Ahli mekanik", str_guide, "Ok", "");
}

showDialogGuideText(playerid){
    new str_guide[1500], str_judul[64], tipe_actor[16], nama_penjual[16], lama_respon_actor;
    if(GetPVarType(playerid, "last_area")){
        new areaid = GetPVarInt(playerid, "last_area");
        if(areaid == AREA_Guide_peralatanPancing){
            lama_respon_actor = LAMA_BATAS_RESPON_PENJUAL;
            format(tipe_actor, sizeof(tipe_actor), "Penjual");
            format(nama_penjual, sizeof(nama_penjual), "%s", NAMA_ACTOR_PENJUAL_PANCING);
        }else if(areaid == AREA_Guide_tokoBibit){
            lama_respon_actor = LAMA_BATAS_RESPON_PENJUAL;
            format(tipe_actor, sizeof(tipe_actor), "Penjual");
            format(nama_penjual, sizeof(nama_penjual), "%s", NAMA_ACTOR_PENJUAL_BIBIT);
        }else if(areaid == AREA_Guide_tokoGadget){
            lama_respon_actor = LAMA_BATAS_RESPON_PENJUAL;
            format(tipe_actor, sizeof(tipe_actor), "Penjual");
            format(nama_penjual, sizeof(nama_penjual), "%s", NAMA_ACTOR_PENJUAL_GADGET);
        }else if(areaid == AREA_Guide_penjualDealer){
            lama_respon_actor = LAMA_BATAS_RESPON_PENJUAL;
            format(tipe_actor, sizeof(tipe_actor), "Dealer");
            format(nama_penjual, sizeof(nama_penjual), "%s", NAMA_ACTOR_PENJUAL_DEALER);
        }else if(areaid == AREA_GuideAhliBlacksmith){
            lama_respon_actor = LAMA_BATAS_RESPON_AHLI;
            format(tipe_actor, sizeof(tipe_actor), "Ahli Perajin");
            format(nama_penjual, sizeof(nama_penjual), "%s", NAMA_ACTOR_SKILL_BLACKSMITH);
        }
        format(str_judul, sizeof(str_judul), GREEN"Guide Interaksi %s", tipe_actor);
        strcatEx(str_guide, 2000, YELLOW"Guide interaksi dengan %s.\n\n", tipe_actor);
        strcatEx(str_guide, 2000, WHITE "Anda perlu mengetahui nama %s, nama %s sekarang adalah "GREEN"%s\n", tipe_actor, tipe_actor, nama_penjual);
        strcatEx(str_guide, 2000, WHITE"Untuk berbicara/mengawali percakapan dengan %s anda dapat menggunakan "GREEN"Halo %s\n", tipe_actor, nama_penjual);
        strcatEx(str_guide, 2000, WHITE"Perlu diketahui bahwa %s hanya dapat merespon satu persatu orang.\n", tipe_actor);
        strcatEx(str_guide, 2000, "%s tidak akan merespon jika ada orang lain yang sedang berinteraksi dengannya\n", tipe_actor);
        strcatEx(str_guide, 2000, "%s juga tidak akan menjawab jika anda tidak berada didekatnya.\n", tipe_actor);
        strcatEx(str_guide, 2000, YELLOW"Perlu diketahui bahwa saat berbicara dengannya anda tidak boleh menjauh dari %s.\n", tipe_actor);
        strcatEx(str_guide, 2000, "Anda hanya diberi waktu "RED"%d detik "YELLOW"untuk menjawab\n\n", lama_respon_actor);
        strcatEx(str_guide, 2000, WHITE"Beberapa hal yang dapat diurus disini melalui %s\nPastikan anda mengawali percakapan seperti yang dijelaskan diatas.\n", tipe_actor);
        if(areaid == AREA_Guide_peralatanPancing){
            strcat(str_guide, "1. Katakan "YELLOW"saya ingin beli peralatan pancing"WHITE" untuk membeli peralatan pancing.\n");
        }else if(areaid == AREA_Guide_tokoBibit){
            strcat(str_guide, "1. Katakan "YELLOW"saya ingin beli bibit"WHITE" untuk membeli bibit tumbuhan.\n");
        }else if(areaid == AREA_Guide_tokoGadget){
            strcat(str_guide, "1. Katakan "YELLOW"saya ingin beli phone"WHITE" untuk membeli phone.\n");
        }else if(areaid == AREA_Guide_penjualDealer){
            strcat(str_guide, "1. Katakan "YELLOW"saya ingin jual mobil"WHITE" untuk menjual mobil.\n");
        }else if(areaid == AREA_GuideAhliBlacksmith){
            strcat(str_guide, "1. Katakan "YELLOW"saya ingin mengaktifkan skill blacksmith"WHITE" untuk mengaktifkan skill blacksmith.\n");
            strcat(str_guide, "2. Katakan "YELLOW"saya ingin membeli item"WHITE" untuk membeli item-item yang berkaitan dengan blacksmith.\n");
        }
        strcatEx(str_guide, 2000, "\nJika anda menjawab tidak seperti hal diatas,\nmaka %s tidak akan mengerti maksud anda dan akan memberhentikan percakapan.\n\n", tipe_actor);
        strcat(str_guide, YELLOW"Jika masih tidak mengerti dengan hal diatas silahkan tanyakan di forum. Terimakasih telah membaca.\n");
    }
    ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, str_judul, str_guide, "Ok", "");
}

showKonfirmasiAmbilGaji(playerid){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(SUM(nominal), 0) AS nominal FROM `gaji` WHERE id_user = '%d' AND status = '0'", PlayerInfo[playerid][pID]);
    mysql_tquery(koneksi, pQuery[playerid], "showTotalGaji", "i", playerid);    
}

dialogKonfirmasiBuatItemBs(playerid, const barang_barang[][], banyak_barang = sizeof(barang_barang)){
    new rate_sukses = getRateBerhasilSkill(PlayerInfo[playerid][expBlacksmith], GetPVarInt(playerid, "bs_buat_needed_level")),
        nama_item[50];
    getNamaByIdItem(GetPVarInt(playerid, "bs_buat_id_item"), nama_item);

    format(pDialog[playerid], sizePDialog, WHITE"Anda akan membuat "GREEN"%s"WHITE". Dengan bahan yang diperlukan:\n\n");
    for(new i=0;i<banyak_barang; i++){
        getNamaByIdItem(barang_barang[i][0], nama_item);
        strcatEx(pDialog[playerid], sizePDialog, "- %s sebanyak %dx\n", nama_item, barang_barang[i][1]);
    }
    strcatEx(pDialog[playerid], sizePDialog, WHITE"\n\
        Rate keberhasilan penggunaan skill ini adalah "YELLOW"%d persen"WHITE".\n\n\
        Apakah anda yakin ?", rate_sukses);
    ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BUAT_ITEM, DIALOG_STYLE_MSGBOX, "Konfirmasi pembuatan", pDialog[playerid], "Konfirmasi", "Batal");
    return 1;
}

dialogKonfirmasiMasakItem(playerid, const barang_barang[][], banyak_barang = sizeof(barang_barang)){
    new nama_item[50];
    getNamaByIdItem(GetPVarInt(playerid, "masak_buat_id_item"), nama_item);

    format(pDialog[playerid], sizePDialog, WHITE"Anda akan membuat "GREEN"%s"WHITE". Dengan bahan yang diperlukan:\n\n");
    for(new i=0;i<banyak_barang; i++){
        getNamaByIdItem(barang_barang[i][0], nama_item);
        strcatEx(pDialog[playerid], sizePDialog, "- %s sebanyak %dx\n", nama_item, barang_barang[i][1]);
    }
    strcatEx(pDialog[playerid], sizePDialog, WHITE"\n\
        Apakah anda yakin ?");
    ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_MASAK_ITEM_TAMBANG, DIALOG_STYLE_MSGBOX, "Konfirmasi pembuatan item", pDialog[playerid], "Konfirmasi", "Batal");
    return 1;
}

showDialogMasakTambang(playerid){
    ShowPlayerDialog(
        playerid, 
        DIALOG_PILIH_MASAK_TAMBANG, 
        DIALOG_STYLE_LIST, 
        "Pilih item yang akan dibuat", 
        // List item
        "Besi\n\
        Emas\n\
        Aluminium\n\
        Perak\n\
        Berlian", 
        // End List item
        "Pilih",
        "Batal"
    );
    return 1;
}

showDialogBuatRentVeh(playerid){
    static str_daftar_veh[sizeof(HARGA_VEHICLE_RENT) * 100 + 100], subString[100];
    if(str_daftar_veh[0] == EOS){
        strcat(str_daftar_veh, WHITE"Nama\tHarga\n");
        for(new i = 0; i < sizeof(HARGA_VEHICLE_RENT); i++){
            format(subString, 100, WHITE"%s\t"GREEN"$%d/jam\n", HARGA_VEHICLE_RENT[i][namaModel], HARGA_VEHICLE_RENT[i][hargaModel]);
            strcat(str_daftar_veh, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_ADMIN_RENT_VEHICLE_BUAT, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Rent System :", str_daftar_veh, "Pilih", "Kembali");
}

showReportPlayer(playerid){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT a.*,b.nama FROM report_log a INNER JOIN `user` b ON b.id = a.id_user ORDER BY a.id DESC LIMIT %i, %i", BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
    return mysql_tquery(koneksi, pQuery[playerid], "tampilReportPlayer", "i", playerid);
}

showDialogJualItemTambang(playerid){
    static str_daftar_jual_tambang[sizeof(list_barang_tampung_tambang) * 100 + 100], subString[100];
    if(str_daftar_jual_tambang[0] == EOS){
        new nama_item[50];
        strcat(str_daftar_jual_tambang, WHITE"Nama\tJumlah Per Stack\tHarga Jual\n");
        for(new i = 0; i < sizeof(list_barang_tampung_tambang); i++){
            getNamaByIdItem(list_barang_tampung_tambang[i][brgId], nama_item);

            format(subString, 100, 
                WHITE"%s\t"YELLOW"%d\t"GREEN"$%d\n", 
                nama_item, 
                list_barang_tampung_tambang[i][brgJumlah],
                list_barang_tampung_tambang[i][brgHarga] - floatround(float(list_barang_tampung_tambang[i][brgHarga]) * 0.1, floatround_floor)
            );
            strcat(str_daftar_jual_tambang, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_PENJUAL_TAMBANG_LIST_JUAL, DIALOG_STYLE_TABLIST_HEADERS, "Jual Hasil Tambang", str_daftar_jual_tambang, "Pilih", "Batal");
}

showDialogBeliItemTambang(playerid){
    static str_daftar_beli_tambang[sizeof(item_beli_tambang) * 100 + 100], subString[100];
    if(str_daftar_beli_tambang[0] == EOS){
        new nama_item[50];
        strcat(str_daftar_beli_tambang, WHITE"Nama\t"GREEN"Harga\n");
        for(new i = 0; i < sizeof(item_beli_tambang); i++){
            getNamaByIdItem(item_beli_tambang[i][idItemMarket], nama_item);

            format(subString, 100, 
                WHITE"%s\t"GREEN"$%d\n", 
                nama_item,
                item_beli_tambang[i][hargaItemMarket]
            );
            strcat(str_daftar_beli_tambang, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_TAMBANG_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Beli Item Tambang", str_daftar_beli_tambang, "Pilih", "Batal");
}

showDialogJualItemKayu(playerid){
    static str_daftar_jual_kayu[sizeof(list_barang_tampung_kayu) * 100 + 100], subString[100];
    if(str_daftar_jual_kayu[0] == EOS){
        new nama_item[50];
        strcat(str_daftar_jual_kayu, WHITE"Nama\tJumlah Per Stack\tHarga Jual\n");
        for(new i = 0; i < sizeof(list_barang_tampung_kayu); i++){
            getNamaByIdItem(list_barang_tampung_kayu[i][brgId], nama_item);

            format(subString, 100, 
                WHITE"%s\t"YELLOW"%d\t"GREEN"$%d\n", 
                nama_item, 
                list_barang_tampung_kayu[i][brgJumlah],
                list_barang_tampung_kayu[i][brgHarga] - floatround(float(list_barang_tampung_kayu[i][brgHarga]) * 0.1, floatround_floor)
            );
            strcat(str_daftar_jual_kayu, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_PENJUAL_KAYU_LIST_JUAL, DIALOG_STYLE_TABLIST_HEADERS, "Jual Kayu", str_daftar_jual_kayu, "Pilih", "Batal");
}

showDialogBeliItemKayu(playerid){
    static str_daftar_beli_kayu[sizeof(item_beli_kayu) * 100 + 100], subString[100];
    if(str_daftar_beli_kayu[0] == EOS){
        new nama_item[50];
        strcat(str_daftar_beli_kayu, WHITE"Nama\t"GREEN"Harga\n");
        for(new i = 0; i < sizeof(item_beli_kayu); i++){
            getNamaByIdItem(item_beli_kayu[i][idItemMarket], nama_item);

            format(subString, 100, 
                WHITE"%s\t"GREEN"$%d\n", 
                nama_item,
                item_beli_kayu[i][hargaItemMarket]
            );
            strcat(str_daftar_beli_kayu, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_BELI_ITEM_KAYU_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Beli Item Kayu", str_daftar_beli_kayu, "Pilih", "Batal");
}

showDialogListItemVehicle(playerid, vehicleid, dialogid = DIALOG_AMBIL_ITEM_VEHICLE){
	format(pDialog[playerid], sizePDialog, "Nama\tJumlah\tKapasitas per Item\tKapasitas Terpakai\n");
	
    new subString[64], 
        jumlah, 
        nama_item[100], 
        kapasitas, 
        idx_temp = 0
    ;
    
    LoopingItem(id_item){
        jumlah = GetJumlahItemVehicle(vehicleid, id_item);
        if(jumlah < 1) continue;

        // Cek jika item yang sedang di looping adalah item yang ada pada halaman
        if(floatround(idx_temp / BANYAK_DATA_PER_PAGE, floatround_floor) == GetPVarInt(playerid, "halaman")){
            getNamaByIdItem(id_item, nama_item);
            kapasitas = getKapasitasByIdItem(id_item);

            strcatEx(pDialog[playerid], sizePDialog, "%s%s\t"WHITE"%i\t%i\t%i\n", GetColorRarity(getRarityByIdItem(id_item)), nama_item, jumlah, kapasitas, kapasitas * jumlah);

            // Gunakan konsep Antrian
            TempPlayerDialog[playerid][idx_temp % BANYAK_DATA_PER_PAGE] = id_item;
        }
        idx_temp++;

        // Cek jika item yang terlooping sudah melebihi halaman
        if(floatround(idx_temp / BANYAK_DATA_PER_PAGE, floatround_floor) > GetPVarInt(playerid, "halaman")) break;
    }

    if(idx_temp == 0){
        return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Inventory item "RED"kosong", WHITE"Maaf saat ini inventory item kendaraan tidak berisi apapun!", "Ok", "");
    }else if(floatround(idx_temp / BANYAK_DATA_PER_PAGE, floatround_floor) < GetPVarInt(playerid, "halaman")){
        if(GetPVarInt(playerid, "halaman") < 1) return 0; // Keluar dari fungsi jika kondisi aneh?
        SetPVarInt(playerid, "halaman", GetPVarInt(playerid, "halaman") - 1);
        return showDialogListItem(playerid, vehicleid, dialogid);
    }

    strcat(pDialog[playerid], ORANGE""STRING_SEBELUMNYA"\n"GREEN""STRING_SELANJUTNYA"\n");

    format(subString, 64, WHITE"Item Bagasi %s : "GREEN"(page : %d)", GetVehicleModelName(GetVehicleModel(vehicleid)), GetPVarInt(playerid, "halaman") + 1);

    return ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, subString, pDialog[playerid], "Pilih", "Kembali");
}

showDialogJualItemIkan(playerid){
    static str_daftar_jual_ikan[sizeof(list_barang_tampung_ikan) * 100 + 100], subString[100];
    if(str_daftar_jual_ikan[0] == EOS){
        new nama_item[50];
        strcat(str_daftar_jual_ikan, WHITE"Nama\tJumlah Per Stack\tHarga Jual\n");
        for(new i = 0; i < sizeof(list_barang_tampung_ikan); i++){
            getNamaByIdItem(list_barang_tampung_ikan[i][brgId], nama_item);

            format(subString, 100, 
                WHITE"%s\t"YELLOW"%d\t"GREEN"$%d\n", 
                nama_item, 
                list_barang_tampung_ikan[i][brgJumlah],
                list_barang_tampung_ikan[i][brgHarga] - floatround(float(list_barang_tampung_ikan[i][brgHarga]) * 0.1, floatround_floor)
            );
            strcat(str_daftar_jual_ikan, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_PENJUAL_IKAN_LIST_JUAL, DIALOG_STYLE_TABLIST_HEADERS, "Jual Hasil Mancing", str_daftar_jual_ikan, "Pilih", "Batal");
}

showDialogJualItemBuah(playerid){
    static str_daftar_jual_buah[sizeof(list_barang_tampung_buah) * 100 + 100], subString[100];
    if(str_daftar_jual_buah[0] == EOS){
        new nama_item[50];
        strcat(str_daftar_jual_buah, WHITE"Nama\tJumlah Per Stack\tHarga Jual\n");
        for(new i = 0; i < sizeof(list_barang_tampung_buah); i++){
            getNamaByIdItem(list_barang_tampung_buah[i][brgId], nama_item);

            format(subString, 100, 
                WHITE"%s\t"YELLOW"%d\t"GREEN"$%d\n", 
                nama_item, 
                list_barang_tampung_buah[i][brgJumlah],
                list_barang_tampung_buah[i][brgHarga] - floatround(float(list_barang_tampung_buah[i][brgHarga]) * 0.1, floatround_floor)
            );
            strcat(str_daftar_jual_buah, subString);
        }
    }
    return ShowPlayerDialog(playerid, DIALOG_PENJUAL_BUAH_LIST_JUAL, DIALOG_STYLE_TABLIST_HEADERS, "Jual Hasil Panen", str_daftar_jual_buah, "Pilih", "Batal");
}