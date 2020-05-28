#include <a_samp>
#include <YSI\y_iterate>

#define DIALOG_MSG 0
#define DIALOG_REGISTER 1
#define DIALOG_REPEAT_PASSWORD 2
#define DIALOG_LOGIN 3
#define DIALOG_SUCCESS_1 4
#define DIALOG_SUCCESS_2 5
#define DIALOG_INPUT_EMAIL 6
#define DIALOG_INPUT_JEKEL 7
#define DIALOG_INPUT_SKIN_GRATIS 8
#define DIALOG_INVENTORY 9
#define DIALOG_PILIH_SKIN 10
#define DIALOG_BELI_SKIN 11
#define DIALOG_OPTION_SKIN_INVENTORY 12
#define DIALOG_SHOW_ITEM_FOR_PLAYER 13
#define DIALOG_DAFTAR_NOMOR 14
#define DIALOG_PILIH_PLAYER_FOR_ITEM 15
#define DIALOG_PILIH_ITEM 16
#define DIALOG_OPTION_ITEM_INVENTORY 17
#define DIALOG_ADMIN_GIVE_ITEM 18
#define DIALOG_PILIH_JUMLAH_ITEM 19
#define DIALOG_MENU_EPHONE 20
#define DIALOG_SMS_MASUKAN_NOMOR 21
#define DIALOG_SMS_MASUKAN_PESAN 22
#define DIALOG_KOTAK_MASUK 23
#define DIALOG_KOTAK_TERKIRIM 24
#define DIALOG_OPSI_KOTAK_MASUK 25
#define DIALOG_OPSI_KOTAK_TERKIRIM 26
#define DIALOG_TEMPAT_FOTO 27
#define DIALOG_BAYAR_FOTO 28
#define DIALOG_ADMIN_RUMAH 29
#define DIALOG_LEVEL_RUMAH 30
#define DIALOG_HARGA_RUMAH 31
#define DIALOG_RESET_RUMAH 32
#define DIALOG_HAPUS_RUMAH 33
#define DIALOG_HAPUS_RUMAH_ID 34
#define DIALOG_HAPUS_RUMAH_ALL 35
#define DIALOG_INFO_RUMAH 36
#define DIALOG_TENTANG_RUMAH 37
#define DIALOG_BELI_BARANG_MARKET 38
#define DIALOG_JUMLAH_BARANG_MARKET 39
#define DIALOG_KONFIRMASI_BARANG_MARKET 40
#define DIALOG_REFRESH_SKIN 41
#define DIALOG_CONFIRM_BELI_SKIN_NORMAL 42
#define DIALOG_TANYA_INGIN_BELI_SKIN 43
#define DIALOG_RESPSIONIS_PEMERINTAH 44
#define DIALOG_RESPSIONIS_PILIH_KTP 45
#define DIALOG_CONFIRM_BUAT_KTP 46
#define DIALOG_TELLER_BANK 47
#define DIALOG_DAFTAR_REKENING_INPUT_NOMOR 48
#define DIALOG_DAFTAR_REKENING_KONFIRMASI 49
#define DIALOG_DEPOSIT_UANG_TABUNGAN 50
#define DIALOG_KONFIRMASI_DEPOSIT 51
#define DIALOG_ATM 52
#define DIALOG_TRANSFER_NOMINAL 53
#define DIALOG_INPUT_REKENING_TUJUAN 54
#define DIALOG_TRANSFER_KONFIRMASI 55
#define DIALOG_TARIK_UANG_NOMINAL 56
#define DIALOG_TARIK_UANG_KONFIRMASI 57
#define DIALOG_INFO_SALDO_HISTORY 58
#define DIALOG_TANYA_TAMBANG 59
#define DIALOG_MENU_GAJI 60
#define DIALOG_PILIHAN_AMBIL_GAJI 61
#define DIALOG_E_BANKING_MENU 62
#define DIALOG_INFO_SALDO_HISTORY_EBANK 63
#define DIALOG_MENU_BELI_MAKAN 64
#define DIALOG_JUMLAH_PEMBELIAN_MAKANAN 65
#define DIALOG_METODE_BAYAR_MAKAN 66
#define DIALOG_KONFIRMASI_BAYAR_MAKANAN_VIA_ATM 67
#define DIALOG_JOB_SWEEPER 68
#define DIALOG_SIM_REGIS_MENU 69
#define DIALOG_DAFTAR_SIM_KONFIRMASI 70
#define D_ADMINLIST 5
#define q "{FFFFFF}"

main()
{
    ShowPlayerDialog(1, D_ADMINLIST, DIALOG_STYLE_TABLIST_HEADERS, "??????????????", "ASdasdasdasdsda", "Ok", "asasdd");
}

public OnGameModeInit(){
    ShowPlayerDialog(0, 1, DIALOG_STYLE_MSGBOX, "ASDASD", "asDASDASD", "ASD", "");
}

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