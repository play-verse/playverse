// City Hall Dialog
showDialogResepsionis(playerid){
    return ShowPlayerDialog(playerid, DIALOG_RESPSIONIS_PEMERINTAH, DIALOG_STYLE_LIST, "Pilihan tindakan pengurusan data", "KTP", "Pilih", "Batal");
}

showDialogListItem(playerid){
    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT b.id_item, b.nama_item, b.keterangan, b.fungsi, b.model_id, a.kunci, a.id_user_item, a.jumlah FROM `user_item` a LEFT JOIN `item` b ON a.id_item = b.id_item WHERE a.`id_user` = '%d' AND a.jumlah > 0 ORDER BY nama_item ASC LIMIT %i, %i", PlayerInfo[playerid][pID], BANYAK_DATA_PER_PAGE * GetPVarInt(playerid, "halaman"), BANYAK_DATA_PER_PAGE);
    mysql_tquery(koneksi, pQuery[playerid], "tampilInventoryBarangPlayer", "i", playerid);    
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

showDialogKesalahanSistem(playerid, const keterangan[]){
    format(pDialog[playerid], sizePDialog, ORANGE"Terdapat kesalah pada sistem.\n\n"WHITE"Silahkan hubungi administrator "GREEN"dengan cara mengirimkan screenshot ini.\n\n"WHITE"Keterangan error : "GREY"%s\n\n"WHITE"Silahkan screenshot sekarang dengan cara menekan "YELLOW"F8 "WHITE"dan segera hubungi administrator sertakan gambar juga. Terimakasih.", keterangan);
    ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, ORANGE"Kesalahan sistem", pDialog[playerid], "Tutup", "");
}

showDialogAmbilMobilReparasi(playerid){
    new string[250 * BANYAK_DATA_PER_PAGE + 200];
    format(string, sizeof(string), "Kode\tNama\n");
    
    foreach(new i : PVehIterator){
        if(PVeh[i][pVehPemilik] == PlayerInfo[playerid][pID]){
            if(PVeh[i][pVehIsReparasi] == 2){ // Jika mobil sedang dalam reparasi (telah rusak)
                format(string, sizeof(string), "%s%d\t%s\n", string, i, GetVehicleNameFromModel(PVeh[i][pVehModel]));
            }
        }
    }

    if(strcmp(string, "Kode\tNama\n") == 0){
        showDialogPesan(playerid, RED"Tidak terdapat kendaraan", WHITE"Tidak terdapat kendaraan apapun yang sudah diperbaiki.\nJika anda mencari kendaraan anda yang rusak, silahkan bayar terlebih dahulu di bank kemudian ambil disini.");
    }else
        ShowPlayerDialog(playerid, DIALOG_AMBIL_KENDARAAN_REPARASI, DIALOG_STYLE_TABLIST_HEADERS, "Kendaraan yang tersedia.", string, "Pilih", "Batal");
}

showDialogMenuInventory(playerid){
    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "Inventory", "Item\nSkin\nKendaraan", "Pilih", "Batal");
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
	new subString[45];
    static string[sizeof(BARANG_MARKET) * 45];

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

showDialogAdminPapan(playerid){
    return ShowPlayerDialog(playerid, DIALOG_ADMIN_PAPAN, DIALOG_STYLE_LIST, ORANGE"Admin Menu untuk Papan", "Get ID Papan Sekitar\nTeleport ke Papan\nBuat Papan\nEdit Posisi Papan\nEdit Text\nEdit Ukuran Text\nHapus Papan", "Pilih", "Batal");
}

showDialogAdminVehicle(playerid){
    return ShowPlayerDialog(playerid, DIALOG_ADMIN_VEHICLE, DIALOG_STYLE_LIST, ORANGE"Admin Menu untuk kendaraan", "Buat Kendaraan\nParkir Kendaraan Dealer\nRespawn Semua kendaraan Dealer\nHapus Kendaraan Dealer ini", "Pilih", "Batal");
}