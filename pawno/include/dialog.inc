// City Hall Dialog
showDialogResepsionis(playerid){
    return ShowPlayerDialog(playerid, DIALOG_RESPSIONIS_PEMERINTAH, DIALOG_STYLE_LIST, "Pilihan tindakan pengurusan data", "KTP", "Pilih", "Batal");
}

showDialogRespsionisKTP(playerid){
    return ShowPlayerDialog(playerid, DIALOG_RESPSIONIS_PILIH_KTP, DIALOG_STYLE_LIST, "Pilihan tindakan KTP", "Buat KTP\nAmbil KTP yang sudah selesai", "Pilih", "Kembali");
}

showDialogTellerBank(playerid){
    return ShowPlayerDialog(playerid, DIALOG_TELLER_BANK, DIALOG_STYLE_LIST, "Pilihan pengurusan administrasi Bank", "Buat Rekening ATM\nDeposit ke Tabungan\nGaji", "Pilih", "Tutup");
}

showDialogPesan(playerid, judul_pesan[], isi_pesan[]){
	return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, judul_pesan, isi_pesan, "Ok", "");
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