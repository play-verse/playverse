// City Hall Dialog
showDialogResepsionis(playerid){
    return ShowPlayerDialog(playerid, DIALOG_RESPSIONIS_PEMERINTAH, DIALOG_STYLE_LIST, "Pilihan tindakan pengurusan data", "KTP", "Pilih", "Batal");
}

showDialogRespsionisKTP(playerid){
    return ShowPlayerDialog(playerid, DIALOG_RESPSIONIS_PILIH_KTP, DIALOG_STYLE_LIST, "Pilihan tindakan KTP", "Buat KTP\nAmbil KTP yang sudah selesai", "Pilih", "Kembali");
}

showDialogTellerBank(playerid){
    return ShowPlayerDialog(playerid, DIALOG_TELLER_BANK, DIALOG_STYLE_LIST, "Pilihan pengurusan administrasi Bank", "Buat Rekening ATM\nDeposit ke Tabungan", "Pilih", "Tutup");
}

showDialogPesan(playerid, judul_pesan[], isi_pesan[]){
	return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, judul_pesan, isi_pesan, "Ok", "");
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