// City Hall Dialog
showDialogResepsionis(playerid){
    return ShowPlayerDialog(playerid, DIALOG_RESPSIONIS_PEMERINTAH, DIALOG_STYLE_LIST, "Pilihan tindakan pengurusan data", "KTP", "Pilih", "Batal");
}

showDialogRespsionisKTP(playerid){
    return ShowPlayerDialog(playerid, DIALOG_RESPSIONIS_PILIH_KTP, DIALOG_STYLE_LIST, "Pilihan tindakan KTP", "Buat KTP\nAmbil KTP yang sudah selesai", "Pilih", "Kembali");
}

showDialogTellerBank(playerid){
    return ShowPlayerDialog(playerid, DIALOG_TELLER_BANK, DIALOG_STYLE_LIST, "Pilihan pengurusan administrasi Bank", "Buat Rekening ATM", "Pilih", "Tutup");
}