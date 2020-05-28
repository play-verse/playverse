/**************************************************************************************************
	ETERNITY LEGEND SCRIPT

	MAJOR MINUS :
	- Setiap item harus memiliki model_id yang unique, jika ingin menggunakan DIALOG_PREVIEW_MODEL
***************************************************************************************************/

#include <a_samp>
#include <pengaturan> // Pengaturan server disini letak pas dibawah a_samp
#include <colors> // https://forum.sa-mp.com/showthread.php?t=573049
#include <sscanf2>
#include <streamer>
#include <progress2>

#include <a_mysql>
#include <zcmd>

#define YSI_NO_HEAP_MALLOC
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_timers>
#include <YSI_Coding\y_inline>

#include <core>
#include <float>
#include <PreviewModelDialog>
/*
	INCLUDE INCLUDE BUATAN DIBAWAH
*/
#include <global_variable> // variable disini
#include <mapping> // Mappingan loader
#include <textdraw> // Textdraw Function Loader
#include <pickup> // Pickup Function Loader
#include <map_icon> // Map Icon Function Loader
#include <checkpoint> // CP Function Loader
#include <dialog> // Function Dialog Loader
#include <fungsi_tambahan> // Fungsi tambahan disini - Tambahan dulu baru fungsi
#include <fungsi> // Fungsi disini

#include <../include/gl_common.inc>

/**
	Unused params is here
 */

/**
	End Unused Params
 */

public OnPlayerConnect(playerid)
{
	removeBangunanUntukMapping(playerid);
	loadTextDrawPemain(playerid);
	/*
	Removes vending machines
	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
	*/
	SetPlayerColor(playerid, COLOR_WHITE);
	
	resetPlayerVariable(playerid);
	ResetPlayerMoney(playerid);
	resetPlayerToDo(playerid);
	TextDrawShowForPlayer(playerid, TD_JamTanggal[0]);
	TextDrawShowForPlayer(playerid, TD_JamTanggal[1]);
	LoadSpeedoTextDraws(playerid);

	new nama[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nama, sizeof(nama));
	PlayerInfo[playerid][pPlayerName] = nama;

	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerConnect terpanggil (%d - %s)", playerid, nama);
	#endif

    mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `user` WHERE `nama` = '%e'", PlayerInfo[playerid][pPlayerName]);
	mysql_tquery(koneksi, pQuery[playerid], "isRegistered", "d", playerid);

	return 1;
}

public OnPlayerDisconnect(playerid, reason){
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerDisconnect terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif	
	DeletePVar(playerid, "sms_list_pesan");
	DeletePVar(playerid, "sms_id_pesan");
	
	// Delete PVar dialog SMS
	DeletePVar(playerid, "sms_id_penerima");

	// Regis Bank
	DeletePVar(playerid, "regis_rekening");	
	DeletePVar(playerid, "depo_nominal");

	// ATM
	DeletePVar(playerid, "tf_nama");
	DeletePVar(playerid, "tf_rekening");
	DeletePVar(playerid, "wd_nominal");

	resetPVarInventory(playerid);
	resetPlayerToDo(playerid);
	if(PlayerInfo[playerid][sudahLogin]) updateOnPlayerDisconnect(playerid);
	resetPlayerVariable(playerid);
	// hideTextDrawUang(playerid);
	ResetPlayerMoney(playerid);
	unloadTextDrawPemain(playerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch( dialogid )
    {
        case DIALOG_REGISTER:
        {
            if(response)
            {
				if( strlen(inputtext) >= 8 && strlen(inputtext) <= 24 )
				{
					format(registerInfo[playerid][registerPassword], 25, "%s", inputtext);
			        return ShowPlayerDialog(playerid, DIALOG_REPEAT_PASSWORD, DIALOG_STYLE_PASSWORD,WHITE"SILAHKAN ULANGI PASSWORD",WHITE"{FFFFFF}Silahkan ulangi kembali password!","Konfirmasi","Keluar");
				} else {
			        return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""WHITE"SILAHKAN DAFTAR",RED"Password harus berisi 8 hingga 24 karakter!\n"WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
				}
            }
            else 
				Kick(playerid);
			// Selalu return 1 - wiki samp OnDialogResponse should 1 return 1 when handled
			return 1;
        }
		case DIALOG_REPEAT_PASSWORD:
		{
			if(response){
				if( sama(registerInfo[playerid][registerPassword], inputtext) )
				{
					dialogEmail(playerid);
					return 1;
				} else {
			        return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""WHITE"SILAHKAN DAFTAR",RED"Password konfirmasi salah! Silahkan ulangi kembali!\n"WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
				}

			}
            else
				Kick(playerid);			
			return 1;
		}
        case DIALOG_LOGIN:
        {
            if( response )
            {
				new hash[65];
				// hashing the text that user entered and salt that was loaded
				SHA256_PassHash(inputtext, PlayerInfo[playerid][pPlayerName], hash, 64);
				if(sama(hash, PlayerInfo[playerid][pPassword]))
				{
					PlayerInfo[playerid][sudahLogin] = true;

					mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `jumlah_login` = `jumlah_login` + 1 WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
					mysql_tquery(koneksi, pQuery[playerid]);

					PlayerInfo[playerid][loginKe]++;
					format(msg, sizeof(msg), "~r~Selamat ~y~datang ~g~kembali~w~!~n~Anda masuk yang ke - ~g~ %d ~w~!", PlayerInfo[playerid][loginKe]);
					GameTextForPlayer(playerid, msg, 4000, 3);

					// tampilkanTextDrawUang(playerid);

					// Set player uang tanpa menambahkan di database - maka diset false untuk parameter terakhir
					setUangPlayer(playerid, PlayerInfo[playerid][uang], false);
					print("Spawn Called in Login Success");
					spawnPemain(playerid);
					return 1;
				}
				else
				{
					return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, WHITE"Login",RED"Password salah silahkan coba lagi, perhatikan penggunaan capslock!\n"WHITE"Masukan Password untuk login ke akun!","Login","Keluar");
				}
			}
			else
				Kick ( playerid );
			return 1;
		}
		case DIALOG_INPUT_EMAIL: {
			if(response){
				if(!isnull(inputtext)){
					new format_gmail[15] = "@gmail.com", len = strlen(inputtext), len_format = strlen(format_gmail);
					if(len <= len_format || strfind(inputtext, format_gmail, true, len - len_format) == -1){
						ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", RED"Format email invalid!\n"WHITE"Masukan email anda, kami hanya mensupport email "RED"@gmail.com\n:", "Simpan", "Keluar");
					}else{
						format(registerInfo[playerid][email], 100, "%s", inputtext);

						ShowPlayerDialog(playerid, DIALOG_INPUT_JEKEL, DIALOG_STYLE_LIST, "Pilih Jenis Kelamin", WHITE"Laki-Laki\nPerempuan", "Simpan", "Keluar");
					}
				}else{
					ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", RED"Anda harus memasukan email anda!\n"WHITE"Masukan email anda, kami hanya mensupport email "RED"@gmail.com\n:", "Simpan", "Keluar");
				}
			}else{
				Kick(playerid);
			}
			return 1;
		}
		case DIALOG_INPUT_JEKEL:
		{
			if(response){
				registerInfo[playerid][jenisKelamin] = listitem;

				new len;
				new subString[16];
				static string[500];
				len = registerInfo[playerid][jenisKelamin] == 0 ? sizeof(SKIN_MALE_GRATIS) : sizeof(SKIN_FEMALE_GRATIS);

				for (new i = 0; i < len; i++) {
					format(subString, sizeof(subString), "%i\n", registerInfo[playerid][jenisKelamin] == 0 ? SKIN_MALE_GRATIS[i] : SKIN_FEMALE_GRATIS[i]);
					strcat(string, subString);
				} 
				return ShowPlayerDialog(playerid, DIALOG_INPUT_SKIN_GRATIS, DIALOG_STYLE_PREVIEW_MODEL, "Pilih skin yang anda inginkan", string, "Pilih", "Keluar");
			}else{
				Kick(playerid);
			}
			return 1;
		}
		case DIALOG_INPUT_SKIN_GRATIS: 
		{
			if(response){
				registerInfo[playerid][freeSkinID] = (registerInfo[playerid][jenisKelamin] == 0) ? SKIN_MALE_GRATIS[listitem] : SKIN_FEMALE_GRATIS[listitem];
				registerUser(playerid);
				return 1;
			}else{
				Kick(playerid);
			}
			return 1;
		}
		case DIALOG_INVENTORY:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT b.id_item, b.nama_item, a.jumlah FROM `user_item` a LEFT JOIN `item` b ON a.id_item = b.id_item WHERE a.`id_user` = '%d' AND a.jumlah > 0", PlayerInfo[playerid][pID]);

						mysql_tquery(koneksi, pQuery[playerid], "tampilInventoryBarangPlayer", "d", playerid);
					}
					case 1:
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `user_skin` WHERE `id_user` = '%d' AND `jumlah` > 0", PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid], "tampilInventorySkinPlayer", "d", playerid);
					}
				}
			}
			return 1;
		}
		case DIALOG_PILIH_SKIN:
		{
			if(response){
				ShowPlayerDialog(playerid, DIALOG_OPTION_SKIN_INVENTORY, DIALOG_STYLE_LIST, WHITE"Pilih aksi", GREEN"Pakai Skin\n"LIGHT_BLUE"Beritahu Item\n"BLUE"Info Item", "Ok", "Keluar");

				new id_skin = strval(inputtext);
				SetPVarInt(playerid, "inv_model", id_skin);
				SetPVarString(playerid, "inv_keterangan", "Jenis skin biasa, yang dapat digunakan jika kamu memilikinya.");
			}
			return 1;
		}
		case DIALOG_BELI_SKIN:
		{
			if(response){
				new id_skin = (PlayerInfo[playerid][jenisKelamin] == 0) ? SKIN_MALE_GRATIS[listitem] : SKIN_FEMALE_GRATIS[listitem];

				SetPVarInt(playerid, "skinNormal_idx", id_skin);

				ShowPlayerDialog(playerid, DIALOG_CONFIRM_BELI_SKIN_NORMAL, DIALOG_STYLE_MSGBOX, "Konfirmasi pembelian", WHITE"Anda yakin ingin membeli skin ini?\nSkin normal memiliki harga "GREEN"2500"WHITE".", "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_CONFIRM_BELI_SKIN_NORMAL:
		{
			if(response){
				new id_skin = GetPVarInt(playerid, "skinNormal_idx");
				DeletePVar(playerid, "skinNormal_idx");
				if(getUangPlayer(playerid) < 2500) return dialogMsgUangTdkCukup(playerid);
				givePlayerUang(playerid, -2500);
				tambahSkinPlayer(playerid, id_skin, 1,false);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil ", GREEN"Anda berhasil mendapatkan skin!\n"WHITE"Silahkan buka inventory untuk melihatnya.", "Ok", "");
			}else{
				DeletePVar(playerid, "skinNormal_idx");
			}
			return 1;
		}
		case DIALOG_OPTION_SKIN_INVENTORY:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						new id_skin = GetPVarInt(playerid, "inv_model");
						if(PlayerInfo[playerid][skinID] == id_skin) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Skin sudah digunakan", WHITE"Anda tidak dapat menggunakan skin yang sedang digunakan,\nAnda harus memilih skin yang berbeda dengan yang anda gunakan skrng.", "Ok", "");
						
						updatePlayerCurrentSkin(playerid, id_skin);

						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", GREEN"Anda berhasil mengganti skin anda!\n"WHITE"Silahkan ke kamar ganti terdekat atau spawn ulang untuk mendapatkan efeknya.", "Ok", "");
					}
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");
					}
				}
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_SHOW_ITEM_FOR_PLAYER:
		{
			new target_id;
			if(response){
				if(sscanf(inputtext, "u", target_id)) return ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Invalid playerid, silahkan masukan kembali! "WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");

				if(!IsPlayerConnected(target_id)) return ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Player dengan id tersebut tidak ada, silahkan masukan kembali! "WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");
				
				if(target_id == playerid) return ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Anda tidak dapat memasukan ID anda sendiri, silahkan masukan kembali! "WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");

				new Float:me_x, Float:me_y, Float:me_z;
				GetPlayerPos(playerid, me_x, me_y, me_z);

				if(!IsPlayerInRangeOfPoint(target_id, 8.0, me_x, me_y, me_z)) return ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Player tersebut tidak berada di dekat anda, silahkan masukan kembali! "WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");

				// Tampilkan Textdraw
				new string[500];
				GetPVarString(playerid, "inv_keterangan", string, sizeof(string));
				tampilkanTextDrawShowItem(target_id, GetPVarInt(playerid, "inv_model"), 1, string, PlayerInfo[playerid][pPlayerName]);

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", WHITE"Anda "GREEN"berhasil "WHITE"menampilkan info item anda ke player tertuju!", "Ok", "");
				resetPVarInventory(playerid);
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_DAFTAR_NOMOR:
		{
			if(response){
				if(!(strlen(inputtext) == 4)) return ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP anda", RED"Kode harus terdiri dari 4 angka!\n"WHITE"Masukan nomor HP yang anda inginkan :", "Simpan", "Keluar");
				if(inputtext[0] == '-' || !isNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP anda", RED"Kode harus terdiri dari angka saja!\n"WHITE"Masukan nomor HP yang anda inginkan :", "Simpan", "Keluar");

				new nomor_hp[16] = "62";
				strcat(nomor_hp, inputtext);

				inline responseCekNomorHP(){
					if(!cache_num_rows()){
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET nomor_handphone = '%e' WHERE id = '%d'", nomor_hp, PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid]);

						format(PlayerInfo[playerid][nomorHP], 12, "%s", nomor_hp);

						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mendaftarkan nomor HP", WHITE"Anda "GREEN"berhasil "WHITE"mendaftarkan nomor HP!", "Ok", "");
					}else{
						return ShowPlayerDialog(playerid, DIALOG_DAFTAR_NOMOR, DIALOG_STYLE_INPUT, "Input nomor HP anda", RED"Nomor HP telah ada, silahkan input yang lain!\n"WHITE"Masukan nomor HP yang anda inginkan :", "Simpan", "Keluar");
					}
				}
				MySQL_TQueryInline(koneksi, using inline responseCekNomorHP, "SELECT * FROM `user` WHERE nomor_handphone = '%s'", nomor_hp);
			}
			return 1;
		}
		case DIALOG_ADMIN_GIVE_ITEM:
		{
			if(response){
				SetPVarInt(playerid, "inv_indexlist", strval(inputtext));

				ShowPlayerDialog(playerid, DIALOG_PILIH_PLAYER_FOR_ITEM, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",WHITE"Masukan ID player yang akan kamu beri item.","Beri","Keluar");
			}
			return 1;
		}
		case DIALOG_PILIH_PLAYER_FOR_ITEM:
		{
			if(response){
				new target_id;
				if(sscanf(inputtext, "u", target_id)) return ShowPlayerDialog(playerid, DIALOG_PILIH_PLAYER_FOR_ITEM, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Invalid playerid, silahkan masukan kembali!\n"WHITE"Masukan ID player yang akan kamu tampilkan item.","Beri","Keluar");
				if(!IsPlayerConnected(target_id)) return ShowPlayerDialog(playerid, DIALOG_PILIH_PLAYER_FOR_ITEM, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",RED"Player dengan id tersebut tidak ada, silahkan masukan kembali!\n"WHITE"Masukan ID player yang akan kamu tampilkan item.","Beri","Keluar");

				SetPVarInt(playerid, "inv_target_id", target_id);

				ShowPlayerDialog(playerid, DIALOG_PILIH_JUMLAH_ITEM, DIALOG_STYLE_INPUT,""WHITE"Jumlah barang",WHITE"Berapa banyak yang ingin kamu berikan :", "Beri", "Keluar");
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_PILIH_JUMLAH_ITEM:
		{
			if(response){
				new jumlah, item_id, nama_item[256];
				if(sscanf(inputtext, "i", jumlah)) return ShowPlayerDialog(playerid, DIALOG_PILIH_JUMLAH_ITEM, DIALOG_STYLE_INPUT,""WHITE"Jumlah barang", RED"Inputan tidak valid!\n"WHITE"Berapa banyak yang ingin kamu berikan :", "Beri", "Keluar");

				if(!IsPlayerConnected(GetPVarInt(playerid, "inv_target_id"))) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX,""WHITE"Invalid", RED"Player dengan id tertuju sudah meninggalkan server!\n","Ok", "");

				item_id = GetPVarInt(playerid, "inv_indexlist");
				tambahItemPlayer(GetPVarInt(playerid, "inv_target_id"), item_id, jumlah);
				getNamaByIdItem(item_id, nama_item);
				format(pDialog[playerid], sizePDialog, WHITE"Anda "GREEN"mendapatkan "WHITE"item "BLUE"%s "WHITE"dari admin!", nama_item);
				ShowPlayerDialog(GetPVarInt(playerid, "inv_target_id"), DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mendapatkan item", pDialog[playerid], "Ok", "");

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", WHITE"Anda "GREEN"berhasil "WHITE"memberikan item ke player tertuju!", "Ok", "");
				resetPVarInventory(playerid);
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_PILIH_ITEM:
		{
			if(response){
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT jumlah FROM `user_item` WHERE id_user = '%d' AND id_item = '%d'", PlayerInfo[playerid][pID], strval(inputtext));
				mysql_tquery(koneksi, pQuery[playerid], "cekJumlahItem", "dd", playerid, strval(inputtext));
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_OPTION_ITEM_INVENTORY:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						new id_item = GetPVarInt(playerid, "inv_indexlist");
						new fungsi[101];
						getFungsiByIdItem(id_item, fungsi);
						CallRemoteFunction(fungsi, "ii", playerid, id_item);
					}
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_SHOW_ITEM_FOR_PLAYER, DIALOG_STYLE_INPUT,""WHITE"ID player tujuan",WHITE"Masukan ID player yang akan kamu tampilkan item.","Show","Keluar");
					}
					case 2:
					{
						// Tampilkan Textdraw
						new string[500];
						GetPVarString(playerid, "inv_keterangan", string, sizeof(string));
						tampilkanTextDrawShowItem(playerid, GetPVarInt(playerid, "inv_model"), GetPVarInt(playerid, "inv_jumlah"), string, PlayerInfo[playerid][pPlayerName]);

						resetPVarInventory(playerid);
					}
				}
			}else{
				resetPVarInventory(playerid);
			}
			return 1;
		}
		case DIALOG_MENU_EPHONE:
		{
			if(response){
				switch(listitem){
					// Kirim Pesan
					case 0:
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT COUNT(*) AS banyak_pesan FROM `sms` WHERE `id_user_pengirim` = '%d' AND `id_pemilik_pesan` = '%d'", PlayerInfo[playerid][pID], PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid], "cekPesanTerkirim", "d", playerid);
						return 1;
					}
					// Kotak Masuk
					case 1:
					{
						tampilkanKotakMasuk(playerid);
					}
					// Kotak Terkirim
					case 2:
					{
						tampilkanKotakTerkirim(playerid);
					}
					case 3:
					{
						if(isnull(PlayerInfo[playerid][nomorRekening])) return showDialogPesan(playerid, RED"Anda tidak memiliki ATM", WHITE"Untuk dapat mengakses ATM Banking, anda harus mempunyai rekening bank terlebih dahulu.\n"YELLOW"Anda dapat pergi ke bank untuk mengurusnya.");

						showDialogEBank(playerid);
					}
					default:
						return 1;
				}
			}
			return 1;
		}
		case DIALOG_E_BANKING_MENU:
		{
			if(response){
				switch(listitem){
					case 0: // Info Saldo
					{
						inline responseDialog(){
							new saldo;
							if(cache_num_rows()){
								cache_get_value_name_int(0, "saldo", saldo);
								format(pDialog[playerid], sizePDialog, WHITE"Informasi saldo anda dan Rekening anda:\n\nNama : %s\nRekening : %s\nSaldo : %d\n\nInformasi saldo dapat berubah sewaktu-waktu sesuai dengan transaksi yang terjadi setiap saatnya.\nTerimakasih telah menggunakan Layanan dari kami.", PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][nomorRekening], saldo);
								ShowPlayerDialog(playerid, DIALOG_INFO_SALDO_HISTORY_EBANK, DIALOG_STYLE_MSGBOX, "Informasi saldo dan Akun Bank", pDialog[playerid], "Kembali", "Tutup");
							}
							else
								printf("[ERROR] #03 Error fungsi tampil saldo (%d)%s - ID user(%d)", playerid, PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][pID]);
						}

						MySQL_TQueryInline(koneksi, using inline responseDialog, "SELECT IFNULL(SUM(nominal), 0) as saldo FROM `trans_atm` WHERE id_user = '%d'", PlayerInfo[playerid][pID]);
						return 1;
					}
					case 1: // Transfer Uang
					{
						ShowPlayerDialog(playerid, DIALOG_INPUT_REKENING_TUJUAN, DIALOG_STYLE_INPUT, "Nomor rekening tujuan", "Silahkan masukan nomor rekening tujuan:\nNomor rekening harus terdiri dari 8 digit.\nPastikan anda memasukan rekening yang benar.", "Ok", "Batal");
						return 1;
					}
					case 2: // History
					{
						inline responseDialogHistoryATM(){
							new rows;
							cache_get_row_count(rows);
							if(rows){
								new idx = 0, subString[150], string[1700] = "Pengirim/Penerima\tNominal\tTanggal\tKeterangan\n", temp_tanggal[20], rekening_temp[10], keterangan[60], nominal_temp;
								while(idx < rows){
									cache_get_value_name(idx, "rekening", rekening_temp);
									cache_get_value_name(idx, "keterangan", keterangan);
									cache_get_value_name(idx, "tanggal", temp_tanggal);
									cache_get_value_name_int(idx, "nominal", nominal_temp);
									format(subString, sizeof(subString), "%s\t%d\t%s\t%s\n", rekening_temp, nominal_temp, temp_tanggal, keterangan);
									strcat(string, subString);
									idx++;
								}
								ShowPlayerDialog(playerid, DIALOG_INFO_SALDO_HISTORY_EBANK, DIALOG_STYLE_TABLIST_HEADERS, "Informasi History ATM Banking", string, "Kembali", "Tutup");
							}else{
								ShowPlayerDialog(playerid, DIALOG_INFO_SALDO_HISTORY_EBANK, DIALOG_STYLE_MSGBOX, "Informasi History ATM Banking", "Tidak ada history ATM untuk saat ini.", "Kembali", "Tutup");
							}							
						}

						MySQL_TQueryInline(koneksi, using inline responseDialogHistoryATM, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT 10", PlayerInfo[playerid][pID]);
						return 1;
					}
				}
			}else
				showDialogEPhone(playerid);
			return 1;
		}
		case DIALOG_INFO_SALDO_HISTORY_EBANK:
		{
			if(response){
				showDialogEBank(playerid);
			}			
			return 1;
		}
		case DIALOG_SMS_MASUKAN_NOMOR:
		{
			if(response){
				if(strlen(inputtext) == 6 && inputtext[0] == '6' && inputtext[1] == '2'){
					if(strcmp(inputtext, PlayerInfo[playerid][nomorHP]) == 0) return ShowPlayerDialog(playerid, DIALOG_SMS_MASUKAN_NOMOR, DIALOG_STYLE_INPUT, WHITE"Nomor HP penerima", RED"Tidak dapat memasukan nomor HP sendiri!\n"YELLOW"Pastikan nomor HP terdiri dari 6 angka dan diawali dengan 62.\n\n"WHITE"Masukan nomor HP penerima dengan lengkap :", "Ok", "Batal");

					mysql_format(koneksi, pQuery[playerid], sizePQuery, "select a.id, COUNT(b.pesan) AS banyak_pesan from `user` a left join sms b on b.id_user_penerima = a.id WHERE a.nomor_handphone = '%e' GROUP BY a.id", inputtext);		
					mysql_tquery(koneksi, pQuery[playerid], "cekNomorPenerima", "d", playerid);
				}else{
					ShowPlayerDialog(playerid, DIALOG_SMS_MASUKAN_NOMOR, DIALOG_STYLE_INPUT, WHITE"Nomor HP penerima", RED"Nomor HP yang anda masukan invalid!\n"YELLOW"Pastikan nomor HP terdiri dari 6 angka dan diawali dengan 62.\n\n"WHITE"Masukan nomor HP penerima dengan lengkap :", "Ok", "Batal");
				}
			}
			return 1;
		}
		case DIALOG_SMS_MASUKAN_PESAN:
		{
			if(response){
				if(isnull(inputtext)){
					ShowPlayerDialog(playerid, DIALOG_SMS_MASUKAN_PESAN, DIALOG_STYLE_INPUT, WHITE"Pesan yang akan dikirim", RED"Pesan tidak boleh kosong!\n"WHITE"Masukan pesan yang ingin anda kirimkan :", "Ok", "Batal");
				}else{
					new id_user_penerima = GetPVarInt(playerid, "sms_id_penerima");
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO `sms`(id_user_pengirim, id_user_penerima, pesan, tanggal_dikirim, id_pemilik_pesan) VALUES('%d', '%d', '%e', NOW(), '%d'), ('%d', '%d', '%e', NOW(), '%d')", PlayerInfo[playerid][pID], id_user_penerima, inputtext, PlayerInfo[playerid][pID], PlayerInfo[playerid][pID], id_user_penerima, inputtext, id_user_penerima);
					mysql_tquery(koneksi, pQuery[playerid]);

					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mengirimkan SMS", GREEN"Anda berhasil mengirimkan SMS!\n"WHITE"Silahkan buka "YELLOW"kotak terkirim "WHITE"untuk melihat kembali SMS yang anda kirim.", "Ok", "");

					// Notifikasi SMS
					foreach(new i : Player){
						if(PlayerInfo[i][pID] == id_user_penerima){
							format(msg, sizeof(msg), ORANGE"[SMS] "WHITE"Pesan baru masuk dari nomor "BLUE"+%s "WHITE"silahkan cek pada kotak masuk anda.", PlayerInfo[playerid][nomorHP]);
							SendClientMessage(i, -1, msg);
							break;
						}
					}
					DeletePVar(playerid, "sms_id_penerima");
				}
			}else{
				DeletePVar(playerid, "sms_id_penerima");
			}
			return 1;
		}
		case DIALOG_KOTAK_TERKIRIM:
		{
			if(response){
				SetPVarInt(playerid, "sms_id_list_pesan", listitem);
				SetPVarInt(playerid, "sms_id_pesan", strval(inputtext));
				ShowPlayerDialog(playerid, DIALOG_OPSI_KOTAK_TERKIRIM, DIALOG_STYLE_LIST, "Opsi kotak terkirim :","Baca Pesan\nHapus Pesan", "Pilih", "Keluar");
			}else{
				cache_delete(PlayerInfo[playerid][kotakPesan]);
				PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
			}
			return 1;
		}
		case DIALOG_OPSI_KOTAK_TERKIRIM:
		{
			if(response){
				new id_listpesan = GetPVarInt(playerid, "sms_id_list_pesan"), id_pesan = GetPVarInt(playerid, "sms_id_pesan");
				switch(listitem){
					case 0:
					{
						new string[1000], nomor_penerima[16], pesan[500];
						cache_set_active(PlayerInfo[playerid][kotakPesan]);

						cache_get_value_name(id_listpesan, "pesan", pesan);
						cache_get_value_name(id_listpesan, "nomor_handphone", nomor_penerima);

						format(string, sizeof(string), WHITE"Penerima : "YELLOW"%s"WHITE"\n\nPesan : \n%s", nomor_penerima, pesan);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Pesan terkirim", string, "Tutup", "");

						DeletePVar(playerid, "sms_list_pesan");
						DeletePVar(playerid, "sms_id_pesan");
						cache_delete(PlayerInfo[playerid][kotakPesan]);
						PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
					}
					case 1:
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `sms` WHERE `id_sms` = '%d' AND `id_user_pengirim` = '%d' AND `id_pemilik_pesan` = '%d'", id_pesan, PlayerInfo[playerid][pID], PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid]);

						SendClientMessage(playerid, COLOR_GREEN, "[SMS] "YELLOW"Pesan pada kotak terkirim berhasil dihapus!");

						DeletePVar(playerid, "sms_list_pesan");
						DeletePVar(playerid, "sms_id_pesan");
						cache_delete(PlayerInfo[playerid][kotakPesan]);
						PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;	

						tampilkanKotakTerkirim(playerid);		
					}
				}
			}else{
				DeletePVar(playerid, "sms_list_pesan");
				DeletePVar(playerid, "sms_id_pesan");
				cache_delete(PlayerInfo[playerid][kotakPesan]);
				PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
			}
			return 1;
		}
		case DIALOG_KOTAK_MASUK:
		{
			if(response){
				SetPVarInt(playerid, "sms_id_list_pesan", listitem);
				SetPVarInt(playerid, "sms_id_pesan", strval(inputtext));
				ShowPlayerDialog(playerid, DIALOG_OPSI_KOTAK_MASUK, DIALOG_STYLE_LIST, "Opsi kotak masuk :","Baca Pesan\nHapus Pesan", "Pilih", "Keluar");
			}else{
				cache_delete(PlayerInfo[playerid][kotakPesan]);
				PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
			}
			return 1;
		}
		case DIALOG_OPSI_KOTAK_MASUK:
		{
			if(response){
				new id_listpesan = GetPVarInt(playerid, "sms_id_list_pesan"), id_pesan = GetPVarInt(playerid, "sms_id_pesan");
				switch(listitem){
					case 0:
					{
						new string[1000], nomor_penerima[16], pesan[500];
						cache_set_active(PlayerInfo[playerid][kotakPesan]);

						cache_get_value_name(id_listpesan, "pesan", pesan);
						cache_get_value_name(id_listpesan, "nomor_handphone", nomor_penerima);

						format(string, sizeof(string), WHITE"Pengirim : "YELLOW"%s"WHITE"\n\nPesan : \n%s", nomor_penerima, pesan);
						ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, WHITE"Pesan masuk", string, "Tutup", "");

						DeletePVar(playerid, "sms_list_pesan");
						DeletePVar(playerid, "sms_id_pesan");
						cache_delete(PlayerInfo[playerid][kotakPesan]);
						PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
					}
					case 1:
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `sms` WHERE `id_sms` = '%d' AND `id_user_penerima` = '%d' AND `id_pemilik_pesan` = '%d'", id_pesan, PlayerInfo[playerid][pID], PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid]);

						SendClientMessage(playerid, COLOR_GREEN, "[SMS] "YELLOW"Pesan pada kotak masuk berhasil dihapus!");

						DeletePVar(playerid, "sms_list_pesan");
						DeletePVar(playerid, "sms_id_pesan");
						cache_delete(PlayerInfo[playerid][kotakPesan]);
						PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;	

						tampilkanKotakMasuk(playerid);	
					}
				}
			}else{
				DeletePVar(playerid, "sms_list_pesan");
				DeletePVar(playerid, "sms_id_pesan");
				cache_delete(PlayerInfo[playerid][kotakPesan]);
				PlayerInfo[playerid][kotakPesan] = MYSQL_INVALID_CACHE;
			}
			return 1;
		}
		case DIALOG_ADMIN_RUMAH:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						ShowPlayerDialog(playerid, DIALOG_LEVEL_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", WHITE"Silahkan input Level Rumah yang ingin dibuat [1-3].", "Lanjut", "Batal");
					}
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_RESET_RUMAH, DIALOG_STYLE_INPUT, "Reset Rumah", WHITE"Apakah anda yakin ingin mereset semua rumah?\nKetik "GREEN"RESET"WHITE" jika setuju.", "Lanjut", "Batal");
					}
					case 2:
					{
						ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH, DIALOG_STYLE_LIST, WHITE"Hapus Rumah", "Hapus ID Rumah\nHapus Semua Rumah", "Pilih", "Batal");
					}
				}
			}
			return 1;
		}
		case DIALOG_LEVEL_RUMAH:
		{
			if(response){
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LEVEL_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Level tidak boleh kosong!\n"WHITE"Anda harus menginput level berupa angka.", "Lanjut", "Batal");

				if(!isnumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LEVEL_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Level tidak valid!\n"WHITE"Anda harus menginput level berupa angka.", "Lanjut", "Batal");

				if(strval(inputtext) >= 1 && strval(inputtext) <= MAX_HOUSES_LEVEL){
					new level_rumah = strval(inputtext);
					SetPVarInt(playerid, "level_rumah", level_rumah);
					ShowPlayerDialog(playerid, DIALOG_HARGA_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", WHITE"Silahkan input harga rumah yang ingin dibuat.", "Lanjut", "Batal");
				}else{
					format(pDialog[playerid], sizePDialog, RED"Level tidak valid!\n"WHITE"Anda harus menginput level minimal 1 dan maksimal %d.\n", MAX_HOUSES_LEVEL);
					ShowPlayerDialog(playerid, DIALOG_LEVEL_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", pDialog[playerid], "Lanjut", "Batal");
				}
			}
			return 1;
		}
		case DIALOG_HARGA_RUMAH:
		{
			if(response){
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_HARGA_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Harga tidak boleh kosong!\n"WHITE"Anda harus menginput harga berupa angka.", "Lanjut", "Batal");

				if(!isnumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_HARGA_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Harga tidak valid!\n"WHITE"Anda harus menginput harga berupa angka.", "Lanjut", "Batal");

				if(strval(inputtext) <= 1) return ShowPlayerDialog(playerid, DIALOG_HARGA_RUMAH, DIALOG_STYLE_INPUT, "Buat Rumah", RED"Harga tidak valid!\n"WHITE"Anda harus menginput harga lebih dari 1.", "Lanjut", "Batal");

				new Cache:result, Float:me_x, Float:me_y, Float:me_z;
				new level_rumah = GetPVarInt(playerid, "level_rumah");
				GetPlayerPos(playerid, me_x, me_y, me_z);

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "INSERT INTO `house` (level, harga, icon_x, icon_y, icon_z) VALUES ('%d', '%d', '%f', '%f', '%f')", level_rumah, strval(inputtext), me_x, me_y, me_z);
				result = mysql_query(koneksi, pQuery[playerid]);
				new id = cache_insert_id();

				createHouse(id, -1, level_rumah, strval(inputtext), 0, 1, 1, me_x, me_y, me_z);
				SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil membuat rumah!");
			    
			    DeletePVar(playerid, "level_rumah");
			    cache_delete(result);
			}else{
				DeletePVar(playerid, "level_rumah");
			}
			return 1;
		}
		case DIALOG_RESET_RUMAH:
		{
			if(response){
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_RESET_RUMAH, DIALOG_STYLE_INPUT, "Reset Rumah", RED"Input tidak boleh kosong!\n"WHITE"Silahkan ketik "GREEN"RESET"WHITE" untuk setuju.", "Lanjut", "Batal");

				if(!sama("RESET", inputtext)) return ShowPlayerDialog(playerid, DIALOG_RESET_RUMAH, DIALOG_STYLE_INPUT, "Reset Rumah", RED"Input tidak valid!\n"WHITE"Anda harus mengetik "GREEN"RESET"WHITE" untuk setuju.", "Lanjut", "Batal");
				
				for(new i = 0; i < MAX_HOUSES; i++){
					if(housePickup[i] != -1){
						new ownerName[256], beliRate = getHousePrice(i, "beli");
						format(ownerName, 256, "%s", getOwnerHouse(houseInfo[i][hOwner]));
						new ownerId = GetPlayerIdFromName(ownerName);
						if(ownerId != INVALID_PLAYER_ID){
							givePlayerUang(ownerId, beliRate);
						}else{
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, houseInfo[i][hOwner]);
		   			 		mysql_tquery(koneksi, pQuery[playerid]);
						}

						DestroyDynamicPickup(housePickup[i]);
						DestroyDynamic3DTextLabel(houseTextInfo[i]);
						houseInfo[i][hID] = -1;
						houseInfo[i][hOwner] = -1;
						houseInfo[i][hLevel] = 1;
						houseInfo[i][hKunci] = 1;
						houseInfo[i][hJual] = 0;
						houseId[housePickup[i]] = -1;
						housePickup[i] = -1;
					}
				}

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `id_user` = -1, `level` = 1, `kunci` = 1, `jual` = 1");
				mysql_query(koneksi, pQuery[playerid]);
				mysql_query(koneksi, "UPDATE `user` SET `save_house` = 0");

				loadAllHouse();

				SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil mereset semua rumah!");
			}
			return 1;
		}
		case DIALOG_HAPUS_RUMAH:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ID, DIALOG_STYLE_INPUT, "Hapus Rumah", WHITE"Silahkan input ID rumah yang ingin dihapus.", "Lanjut", "Batal");
					}
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ALL, DIALOG_STYLE_INPUT, "Hapus Rumah", WHITE"Apakah anda yakin ingin menghapus semua rumah? Ketik "GREEN"HAPUS"WHITE" untuk setuju.", "Lanjut", "Batal");
					}
				}
			}
			return 1;
		}
		case DIALOG_HAPUS_RUMAH_ID:
		{
			if(response){
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ID, DIALOG_STYLE_INPUT, "Hapus Rumah", RED"ID tidak boleh kosong!\n"WHITE"Silahkan input ID berupa angka.", "Lanjut", "Batal");

				if(!isnumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ID, DIALOG_STYLE_INPUT, "Hapus Rumah", RED"ID tidak valid!\n"WHITE"Anda harus menginput ID berupa angka.", "Lanjut", "Batal");

				new Cache:result, pmsg[256], userId, id = strval(inputtext);
				mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT * FROM `house` WHERE `id_house` = '%d'", id);
				result = mysql_query(koneksi, pQuery[playerid]);
				if(cache_num_rows()){
				 	new beliRate = getHousePrice(id, "beli");
					cache_get_value_name_int(0, "id_user", userId);
					
					mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, userId);
					mysql_query(koneksi, pQuery[playerid]);
					
					if(houseInfo[id][hOwner] != -1){
						new ownerName[256];
						format(ownerName, 256, "%s", getOwnerHouse(houseInfo[id][hOwner]));
						new ownerId = GetPlayerIdFromName(ownerName);
						if(ownerId != INVALID_PLAYER_ID){
							givePlayerUang(ownerId, beliRate);
						}else{
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, houseInfo[id][hOwner]);
		   			 		mysql_tquery(koneksi, pQuery[playerid]);

		   			 		mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `save_house` = 0 WHERE `save_house` = '%d'", id);
							mysql_query(koneksi, pQuery[playerid]);
						}
					}

					DestroyDynamicPickup(housePickup[id]);
					DestroyDynamic3DTextLabel(houseTextInfo[id]);
					houseId[housePickup[id]] = -1;
					housePickup[id] = -1;
					houseInfo[id][hID] = -1;
					houseInfo[id][hOwner] = -1;
					houseInfo[id][hLevel] = 0;
					houseInfo[id][hHarga] = 0;
					houseInfo[id][hKunci] = 1;
					houseInfo[id][hJual] = 0;
					houseInfo[id][icon_x] = 0;
					houseInfo[id][icon_y] = 0;
					houseInfo[id][icon_z] = 0;

					mysql_format(koneksi, pQuery[playerid], sizePQuery, "DELETE FROM `house` WHERE `id_house` = '%d'", id);
					mysql_query(koneksi, pQuery[playerid]);
					format(pmsg, sizeof(pmsg),  GREEN"[RUMAH] "WHITE"Anda berhasil menghapus rumah (id:"YELLOW"%d"WHITE")!", id);
				    SendClientMessage(playerid, COLOR_WHITE, pmsg);
				}else{
					SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "RED"Maaf ID Rumah tidak ada!");
				}
				cache_delete(result);
			}
			return 1;
		}
		case DIALOG_HAPUS_RUMAH_ALL:
		{
			if(response){
				if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ALL, DIALOG_STYLE_INPUT, "Hapus Rumah", RED"Input tidak boleh kosong!\n"WHITE"Silahkan ketik "GREEN"HAPUS"WHITE" untuk setuju.", "Lanjut", "Batal");

				if(!sama("HAPUS", inputtext)) return ShowPlayerDialog(playerid, DIALOG_HAPUS_RUMAH_ALL, DIALOG_STYLE_INPUT, "Hapus Rumah", RED"Input tidak valid!\n"WHITE"Anda harus mengetik "GREEN"HAPUS"WHITE" untuk setuju.", "Lanjut", "Batal");

				for(new i = 0; i < MAX_HOUSES; i++){
					if(housePickup[i] != -1){
						new ownerName[256], beliRate = getHousePrice(i, "beli");
						format(ownerName, 256, "%s", getOwnerHouse(houseInfo[i][hOwner]));
						new ownerId = GetPlayerIdFromName(ownerName);
						if(ownerId != INVALID_PLAYER_ID){
							givePlayerUang(ownerId, beliRate);
						}else{
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, houseInfo[i][hOwner]);
		   			 		mysql_tquery(koneksi, pQuery[playerid]);
						}

						DestroyDynamicPickup(housePickup[i]);
						DestroyDynamic3DTextLabel(houseTextInfo[i]);
						houseInfo[i][hID] = -1;
						houseInfo[i][hOwner] = -1;
						houseInfo[i][hLevel] = 0;
						houseInfo[i][hHarga] = 0;
						houseInfo[i][hKunci] = 1;
						houseInfo[i][hJual] = 0;
						houseInfo[i][icon_x] = 0;
						houseInfo[i][icon_y] = 0;
						houseInfo[i][icon_z] = 0;
						houseId[housePickup[i]] = -1;
						housePickup[i] = -1;
					}
				}

				mysql_query(koneksi, "UPDATE `user` SET `save_house` = 0");
				mysql_query(koneksi, "TRUNCATE TABLE `house`");
				SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil menghapus semua rumah!");
			}
			return 1;
		}
		case DIALOG_INFO_RUMAH:
		{
			if(response){
				new infoRumah[128], id, ownerName[256], houseLevel, beliRate;
				GetPVarString(playerid, "info_rumah", infoRumah, 128);
				id = houseId[lastHousePickup[playerid]];
				houseLevel = houseInfo[id][hLevel];
				beliRate = getHousePrice(id, "beli");
				if(houseInfo[id][hOwner] != -1){
					format(ownerName, 256, "%s", getOwnerHouse(houseInfo[id][hOwner]));
				}else{
					format(ownerName, 256, "Tidak Ada");
				}
				if(sama("set_harga_rumah", infoRumah)){
					if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_INPUT, "Ubah Harga Rumah", RED"Harga tidak boleh kosong!\n"WHITE"Silahkan input harga berupa angka.", "Jual", "Batal");
					if(!isnumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_INPUT, "Ubah Harga Rumah", RED"Harga tidak valid!\n"WHITE"Anda harus menginput harga berupa angka.", "Jual", "Batal");
					if(strval(inputtext) < 0 || strval(inputtext) > 99999999) return ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_INPUT, "Ubah Harga Rumah", RED"Harga tidak valid!\n"WHITE"Silahkan input harga minimal 0 dan maksimal 99999999.\nJika anda mengisi 0 harga akan default, sesuai level dan harga beli.", "Jual", "Batal");
					goto label_set_harga_rumah;
				}
				if(sama("batal_jual", infoRumah)){
					switch(listitem){
						case 0:
						{
							goto label_tentang_rumah;
						}
						case 1:
						{
							houseInfo[id][hJual] = 0;
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `jual` = 0 WHERE `id_house` = '%d'", id);
							mysql_query(koneksi, pQuery[playerid]);
						 	reloadHouseLabel(id);
							SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Rumah anda batal untuk dijual!");
							DeletePVar(playerid, "info_rumah");
						}
						case 2:
						{
							goto label_upgrade_rumah;
						}
						case 3:
						{
							goto label_kunci_rumah;
						}
						case 4:
						{
							goto label_spawn_rumah;
						}
						case 5:
						{
							goto label_masuk_rumah;
						}
					}
				}else if(sama("jual_rumah", infoRumah)){
					switch(listitem){
						case 0:
						{
							goto label_tentang_rumah;
						}
						case 1:
						{
							SetPVarString(playerid, "info_rumah", "set_harga_rumah");
							if(sama("jual_rumah", infoRumah)) return ShowPlayerDialog(playerid, DIALOG_INFO_RUMAH, DIALOG_STYLE_INPUT, "Ubah Harga Rumah", WHITE"Silahkan input harga rumah yang diinginkan.\nJika anda mengisi 0 harga akan default, sesuai level dan harga beli.", "Jual", "Batal");
							label_set_harga_rumah:
							new setHarga = strval(inputtext);
							houseInfo[id][hJual] = 1;
							houseInfo[id][hSetHarga] = setHarga;
							if(setHarga == 0){
								setHarga = beliRate;
							}
							mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `jual` = 1, `setharga` = '%d' WHERE `id_house` = '%d'", setHarga, id);
							mysql_query(koneksi, pQuery[playerid]);
						 	reloadHouseLabel(id);
							format(msg, sizeof(msg),  "[RUMAH] "YELLOW"Rumah anda berhasil untuk dijual dengan harga ("GREEN"%d"YELLOW")!", setHarga);
							SendClientMessage(playerid, COLOR_GREEN, msg);
							DeletePVar(playerid, "info_rumah");
						}
						case 2:
						{
							label_upgrade_rumah:							    
							if(houseLevel < MAX_HOUSES_LEVEL){
								new upgradeRate = getHousePrice(id, "upgrade");
								if(getUangPlayer(playerid) < upgradeRate) return SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "RED"Maaf uang anda tidak mencukupi!");
								givePlayerUang(playerid, -upgradeRate);
							    houseInfo[id][hLevel] = houseLevel+1;
							    mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `level` = '%d'", houseInfo[id][hLevel]);
							    mysql_tquery(koneksi, pQuery[playerid]);
							    reloadHouseLabel(id);
							    format(msg, sizeof(msg),  GREEN"[RUMAH] "WHITE"Anda telah berhasil upgrade rumah ke level ("YELLOW"%d"WHITE"), dengan harga ("YELLOW"%d"WHITE")!", houseInfo[id][hLevel], upgradeRate);
							    SendClientMessage(playerid, COLOR_WHITE, msg);
							}else{
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "RED"Maaf level rumah anda sudah maksimal!");
							}
							DeletePVar(playerid, "info_rumah");
						}
						case 3:
						{
							label_kunci_rumah:
							if(houseInfo[id][hKunci] == 1){
								houseInfo[id][hKunci] = 0;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `kunci` = '%d'", houseInfo[id][hKunci]);
							    mysql_tquery(koneksi, pQuery[playerid]);
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil membuka kunci rumah!");
							}else{
								houseInfo[id][hKunci] = 1;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `kunci` = '%d'", houseInfo[id][hKunci]);
							    mysql_tquery(koneksi, pQuery[playerid]);
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil mengunci rumah!");
							}
							DeletePVar(playerid, "info_rumah");
						}
						case 4:
						{
							label_spawn_rumah:
							new saveId = PlayerInfo[playerid][sHouse];
							if(saveId == id){
								PlayerInfo[playerid][sHouse] = 0;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `save_house` = 0 WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
							    mysql_tquery(koneksi, pQuery[playerid]);
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil membatalkan spawn disini!");
							}else{
								PlayerInfo[playerid][sHouse] = id;
								mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `save_house` = '%d' WHERE `id` = '%d'", id, PlayerInfo[playerid][pID]);
							    mysql_tquery(koneksi, pQuery[playerid]);
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil menyimpan spawn disini!");
							}
							DeletePVar(playerid, "info_rumah");
						}
						case 5:
						{
							goto label_masuk_rumah;
						}
					}
				}else if(sama("beli_rumah", infoRumah)){
					switch(listitem){
						case 0:
						{
							goto label_tentang_rumah;
						}
						case 1:
						{
							if(houseInfo[id][hSetHarga] != 0){
								beliRate = houseInfo[id][hSetHarga];
							}
							if(PlayerInfo[playerid][uang] < beliRate) return SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "RED"Maaf uang anda tidak mencukupi!");
							if(houseInfo[id][hOwner] != -1){
								new ownerId = GetPlayerIdFromName(ownerName);
								if(ownerId != INVALID_PLAYER_ID){
									givePlayerUang(ownerId, beliRate);
								}else{
									mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `uang` = `uang` + '%d' WHERE `id` = '%d'", beliRate, houseInfo[id][hOwner]);
				   			 		mysql_tquery(koneksi, pQuery[playerid]);

				   			 		mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `user` SET `save_house` = 0 WHERE `save_house` = '%d'", id);
									mysql_query(koneksi, pQuery[playerid]);
								}
							}
							givePlayerUang(playerid, -beliRate);

						    houseInfo[id][hOwner] = PlayerInfo[playerid][pID];
						    houseInfo[id][hJual] = 0;
						    mysql_format(koneksi, pQuery[playerid], sizePQuery, "UPDATE `house` SET `id_user` = '%d', `jual` = 0 WHERE `id_house` = '%d'", PlayerInfo[playerid][pID], id);
						    mysql_tquery(koneksi, pQuery[playerid]);
						    reloadHouseLabel(id);
						    format(msg, sizeof(msg),  GREEN"[RUMAH] "WHITE"Anda telah berhasil membeli rumah (id:"YELLOW"%d"WHITE"), dengan harga ("YELLOW"%d"WHITE")!", houseInfo[id][hID], beliRate);
						    SendClientMessage(playerid, COLOR_WHITE, msg);
							DeletePVar(playerid, "info_rumah");
						}
						case 2:
						{
							goto label_masuk_rumah;
						}
					}
				}else if(sama("masuk_rumah", infoRumah)){
					switch(listitem){
						case 0:
						{
							label_tentang_rumah:
							new houseKunci[8], houseJual[16];
							if(houseInfo[id][hKunci] == 1){
								format(houseKunci, 8, "Iya");
							}else{
								format(houseKunci, 8, "Tidak");
							}
							if(houseInfo[id][hJual] == 1){
								format(houseJual, 16, "Dijual");
							}else{
								format(houseJual, 16, "Tidak Dijual");
							}
							format(pDialog[playerid], sizePDialog, "No : %d\nLevel : %d\nHarga : %d\nStatus : %s\nPemilik : %s\nTerkunci : %s", id, houseLevel, beliRate, houseJual, ownerName, houseKunci);
							ShowPlayerDialog(playerid, DIALOG_TENTANG_RUMAH, DIALOG_STYLE_MSGBOX, "Tentang Rumah", pDialog[playerid], "Kembali", "Batal");
							DeletePVar(playerid, "info_rumah");
						}
						case 1:
						{
							label_masuk_rumah:
							if(houseInfo[id][hKunci] != 1){
								SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil masuk rumah!");
							}else{
								if(houseInfo[id][hOwner] == PlayerInfo[playerid][pID]){
									SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "YELLOW"Anda berhasil masuk rumah!");
								}else{
									SendClientMessage(playerid, COLOR_GREEN, "[RUMAH] "RED"Maaf rumah terkunci dan tidak dapat masuk!");
								}
							}
							DeletePVar(playerid, "info_rumah");
						}
					}
				}
			}else{
				DeletePVar(playerid, "info_rumah");
			}
			return 1;
		}
		case DIALOG_TENTANG_RUMAH:
		{
			if(response){
				cmd_inforumah(playerid, "");
			}
			return 1;
		}
		case DIALOG_BELI_BARANG_MARKET:
		{
			if(response){
				SetPVarInt(playerid, "bBarang_index", listitem);
				ShowPlayerDialog(playerid, DIALOG_JUMLAH_BARANG_MARKET, DIALOG_STYLE_INPUT, "Jumlah barang yang ingin dibeli", "Silahkan input jumlah barang yang ingin dibeli.", "Beli", "Batal");
			}
			return 1;
		}
		case DIALOG_JUMLAH_BARANG_MARKET:
		{
			if(response){
				new banyak_barang;
				if(sscanf(inputtext, "i", banyak_barang)) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_BARANG_MARKET, DIALOG_STYLE_INPUT, "Jumlah barang yang ingin dibeli", RED"Inputan anda tidak valid.\n"WHITE"Silahkan input jumlah barang yang ingin dibeli.", "Beli", "Batal");

				if(banyak_barang < 1 || banyak_barang > 1000) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_BARANG_MARKET, DIALOG_STYLE_INPUT, "Jumlah barang yang ingin dibeli", RED"Inputan anda tidak valid.\nMinimal pembelian 1 dan maksimal pembelian 999.\n"WHITE"Silahkan input jumlah barang yang ingin dibeli.", "Beli", "Batal");

				new index_barang = GetPVarInt(playerid, "bBarang_index");
				SetPVarInt(playerid, "bBarang_jumlah", banyak_barang);
				
				format(pDialog[playerid], sizePDialog, "Anda akan membeli barang "YELLOW"%s "WHITE"sebanyak "YELLOW"%d "WHITE"dengan total harga "GREEN"%d"WHITE".\nApakah anda yakin?", BARANG_MARKET[index_barang][namaBarang], banyak_barang, BARANG_MARKET[index_barang][hargaBarang] * banyak_barang);
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BARANG_MARKET, DIALOG_STYLE_MSGBOX, "Konfirmasi pembelian", pDialog[playerid], "Beli", "Batal");
			}
			else{
				DeletePVar(playerid, "bBarang_index");
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_BARANG_MARKET:
		{
			if(response){
				new index_barang = GetPVarInt(playerid, "bBarang_index");
				new jumlah = GetPVarInt(playerid, "bBarang_jumlah"); 
				new harga = jumlah * BARANG_MARKET[index_barang][hargaBarang];
				if(getUangPlayer(playerid) < harga) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Uang anda tidak mencukupi.", WHITE"Maaf uang anda tidak mencukupi!", "Ok", "");

				tambahItemPlayer(playerid, getIDbyModelItem(BARANG_MARKET[index_barang][idModelBarang]), jumlah);
				givePlayerUang(playerid, -harga);

				format(pDialog[playerid], sizePDialog, "Anda berhasil membeli "YELLOW"%s"WHITE".\nSebanyak "YELLOW"%d"WHITE" dengan harga "GREEN"%d", BARANG_MARKET[index_barang][namaBarang], jumlah, harga);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli barang", pDialog[playerid], "Ok", "");

				DeletePVar(playerid, "bBarang_index");
				DeletePVar(playerid, "bBarang_jumlah");
			}
			else{
				DeletePVar(playerid, "bBarang_index");
				DeletePVar(playerid, "bBarang_jumlah");
			}
			return 1;
		}
		case DIALOG_TEMPAT_FOTO:
		{
			if(response){
				new banyak_foto;
				if(sscanf(inputtext, "i", banyak_foto)) return ShowPlayerDialog(playerid, DIALOG_TEMPAT_FOTO, DIALOG_STYLE_INPUT, "Foto dan Cetak", RED"Inputan anda tidak valid, harap input bilangan bulat!\n"WHITE"Berapa banyak foto yang ingin anda cetak ?", "Cetak", "Batal");

				new harga = (GetPlayerVirtualWorld(playerid) == VW_tempatFoto_2) ? 10 : 20;

				if(banyak_foto < 1 || banyak_foto > 1000) return ShowPlayerDialog(playerid, DIALOG_TEMPAT_FOTO, DIALOG_STYLE_INPUT, "Foto dan Cetak", RED"Inputan anda tidak valid, harap input bilangan bulat!\n"WHITE"Berapa banyak foto yang ingin anda cetak ?", "Cetak", "Batal");

				SetPVarInt(playerid, "foto_jumlahFoto", banyak_foto);
				format(pDialog[playerid], sizePDialog, "Anda akan mencetak foto sebanyak "GREEN"%d "WHITE"dengan harga "YELLOW"%d.\nApakah anda yakin?", banyak_foto, banyak_foto * harga);
				ShowPlayerDialog(playerid, DIALOG_BAYAR_FOTO, DIALOG_STYLE_MSGBOX, "Bayar dan cetak", pDialog[playerid], "Bayar", "Batal");
				return 1;
			}
			return 1;
		}
		case DIALOG_BAYAR_FOTO:
		{
			if(response){
				new jumlah = GetPVarInt(playerid, "foto_jumlahFoto"); 
				new harga = (GetPlayerVirtualWorld(playerid) == VW_tempatFoto_2) ? 10 : 20;
				harga = jumlah * harga;
				if(getUangPlayer(playerid) < harga) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Uang anda tidak mencukupi", WHITE"Maaf uang anda tidak mencukupi!", "Ok", "");

				// 5 adalah id item untuk pas foto
				tambahItemPlayer(playerid, 5, jumlah);
				givePlayerUang(playerid, -harga);

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil membeli foto", WHITE"Anda berhasil membeli foto, foto anda sudah masuk inventory.\nSilahkan cek pada inventory anda.", "Ok", "");
				DeletePVar(playerid, "foto_jumlahFoto");
				return 1;
			}else{
				DeletePVar(playerid, "foto_jumlahFoto");
			}
			return 1;
		}
		case DIALOG_REFRESH_SKIN:
		{
			if(response){
				if(GetPlayerSkin(playerid) == PlayerInfo[playerid][skinID]) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Skin sudah terpakai", WHITE"Maaf anda sudah menggunakan skin yang tertuju, silahkan pilih skin lain untuk mendapatkan perubahan!", "Ok", "");

				ClearAnimations(playerid);
				TogglePlayerControllable(playerid, 0);
				ubahSkinPemain(playerid, PlayerInfo[playerid][skinID]);
				TogglePlayerControllable(playerid, 1);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mengganti skin!", WHITE"Anda berhasil mengganti skin anda!", "Ok", "");
			}
			return 1;
		}
		case DIALOG_TANYA_INGIN_BELI_SKIN:
		{
			if(response){
				new subString[16];
				new len = ((PlayerInfo[playerid][jenisKelamin] == 0) ? sizeof(SKIN_MALE_GRATIS) : sizeof(SKIN_FEMALE_GRATIS));
				static stringMale[500], stringFemale[500];

				// Laki-laki
				if(PlayerInfo[playerid][jenisKelamin] == 0){
					if(stringMale[0] == EOS){
						for (new i = 0; i < len; i++) {
							format(subString, sizeof(subString), "%i\n", SKIN_MALE_GRATIS[i]);
							strcat(stringMale, subString);
						} 
					}
					ShowPlayerDialog(playerid, DIALOG_BELI_SKIN, DIALOG_STYLE_PREVIEW_MODEL, "Pilih skin yang anda inginkan", stringMale, "Pilih", "Keluar");
				}
				// Perempuan
				else{
					if(stringFemale[0] == EOS){
						for (new i = 0; i < len; i++) {
							format(subString, sizeof(subString), "%i\n", SKIN_FEMALE_GRATIS[i]);
							strcat(stringFemale, subString);
						} 
					}
					ShowPlayerDialog(playerid, DIALOG_BELI_SKIN, DIALOG_STYLE_PREVIEW_MODEL, "Pilih skin yang anda inginkan", stringFemale, "Pilih", "Keluar");
				}
			}
			return 1;
		}
		case DIALOG_RESPSIONIS_PEMERINTAH:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						showDialogRespsionisKTP(playerid);
						return 1;
					}
				}
			}
			return 1;
		}
		case DIALOG_RESPSIONIS_PILIH_KTP:
		{
			if(response){
				switch(listitem){
					// Buat KTP
					case 0:
					{
						// Eksekusi fungsi pengecekan, 
						// yang akan langsung mengeksekusi pembuatan jika memungkinkan
						getSudahBuatKTP(playerid, "cekSudahPunyaKTP");
					}
					// Ambil KTP yang sudah selesai
					case 1:
					{
						getSudahBuatKTP(playerid, "cekSudahBisaAmbilKTP", false);						
					}
				}
			}else
				showDialogResepsionis(playerid);
			return 1;
		}
		case DIALOG_CONFIRM_BUAT_KTP:
		{
			if(response){
				if(getUangPlayer(playerid) < 100) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Gagal membuat KTP", WHITE"Maaf uang yang diperlukan tidak mencukupi.", "Ok", "");

				new barang_barang[2][2] = {
					{5, 4},
					{6, 2}
				};
				cekKetersediaanMassiveItem(playerid, barang_barang, "cekKetersediaanItemBuatKTP");
			}
			return 1;
		}
		case DIALOG_TELLER_BANK:
		{
			if(response){
				switch(listitem){
					// Buat Rekening ATM
					case 0:
					{
						if(!isnull(PlayerInfo[playerid][nomorRekening])) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Rekening telah ada", WHITE"Maaf anda telah memiliki rekening dan tidak dapat membuatnya lagi.", "Ok", ""); 

						cekKetersediaanItem(playerid, 7, 1, "inputNomorRekeningATMBaru");
						return 1;
					}
					case 1:
					{
						if(isnull(PlayerInfo[playerid][nomorRekening])) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Anda tidak memiliki rekening", WHITE"Maaf anda tidak memiliki rekening dan tidak dapat menggunakan menu ini.\nSilahkan buat rekening anda terlebih dahulu untuk dapat menabung.", "Ok", ""); 
						
						ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk kedalam akun bank anda.", "Deposit", "Kembali");
						return 1;
					}
					case 2:
					{
						ShowPlayerDialog(playerid, DIALOG_MENU_GAJI, DIALOG_STYLE_LIST, WHITE"Pilihan gaji :", WHITE"Ambil Gaji\nLihat Gaji", "Pilih", "Kembali");
						return 1;
					}
				}
			}
			return 1;
		}
		case DIALOG_DAFTAR_REKENING_INPUT_NOMOR:
		{
			if(response){
				new inputan;
				if(strlen(inputtext) != 8) return ShowPlayerDialog(playerid, DIALOG_DAFTAR_REKENING_INPUT_NOMOR, DIALOG_STYLE_INPUT, "Input nomor rekening ATM baru", RED"Nomor rekening harus terdiri dari 8 digit angka 0 - 9!\n\n"WHITE"Input nomor rekening ATM yang baru:\n"WHITE"- Nomor rekening harus terdiri dari 8 karakter\n- Nomor rekening belum digunakan oleh orang lain sebelumnya", "Ok", "Kembali");

				if(sscanf(inputtext, "i", inputan) || inputtext[0] == '-') return ShowPlayerDialog(playerid, DIALOG_DAFTAR_REKENING_INPUT_NOMOR, DIALOG_STYLE_INPUT, "Input nomor rekening ATM baru", RED"Nomor rekening harus terdiri dari 8 digit angka 0 - 9!\n\n"WHITE"Input nomor rekening ATM yang baru:\n"WHITE"- Nomor rekening harus terdiri dari 8 karakter\n- Nomor rekening belum digunakan oleh orang lain sebelumnya", "Ok", "Kembali");

				SetPVarString(playerid, "regis_rekening", inputtext);

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT COUNT(*) AS hasil FROM `user` WHERE rekening = '%e'", inputtext);
				mysql_tquery(koneksi, pQuery[playerid], "isRekeningAda", "i", playerid);
			}else{
				showDialogTellerBank(playerid);
			}
			return 1;
		}
		case DIALOG_DAFTAR_REKENING_KONFIRMASI:
		{
			if(response){
				if(getUangPlayer(playerid) < 100) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Uang tidak mencukupi", "Anda tidak memiliki cukup uang untuk mendaftarkan rekening baru.", "Ok", "");

				new barang_barang_atm[2][2] = {
					{5, 4},
					{6, 2}
				};
				cekKetersediaanMassiveItem(playerid, barang_barang_atm, "konfirmasiPembuatanRekening");
			}else{
				DeletePVar(playerid, "regis_rekening");
			}
			return 1;
		}
		case DIALOG_DEPOSIT_UANG_TABUNGAN:
		{
			if(response){
				new nominal;
				if(sscanf(inputtext, "i", nominal)) return ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", RED"Anda harus memasukan nominal dengan benar!\n"WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk kedalam akun bank anda.", "Deposit", "Kembali");

				if(nominal < 10) return ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", RED"Anda harus memasukan nominal dengan benar, minimal penabungan adalah $10.\n"WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk kedalam akun bank anda.", "Deposit", "Kembali");

				if(getUangPlayer(playerid) < nominal) return ShowPlayerDialog(playerid, DIALOG_DEPOSIT_UANG_TABUNGAN, DIALOG_STYLE_INPUT, "Nominal yang ingin ditabung", RED"Anda harus memasukan nominal dengan benar, nominal yang anda masukan melebihi uang anda.\n"WHITE"Silahkan memasukan nominal yang ingin anda tabung.\n\n"YELLOW"Pastikan anda memiliki uang sesuai dengan nominal yang anda masukan.\nUang akan langsung masuk kedalam akun bank anda.", "Deposit", "Kembali");

				SetPVarInt(playerid, "depo_nominal", nominal);
				
				format(pDialog[playerid], sizePDialog, WHITE"Anda akan menyimpan uang sebesar "GREEN"$%d "WHITE"pada tabungan anda.\nApakah anda yakin?\n\n"YELLOW"Pada saat uang disimpan anda dapat melihat nominalnya pada tabungan anda atau pada website.", nominal);
				ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_DEPOSIT, DIALOG_STYLE_MSGBOX, YELLOW"Konfirmasi penyimpanan", pDialog[playerid], "Simpan", "Batal");
			}else
				showDialogTellerBank(playerid);
			return 1;
		}
		case DIALOG_KONFIRMASI_DEPOSIT:
		{
			if(response){
				new nominal = GetPVarInt(playerid, "depo_nominal");
				DeletePVar(playerid, "depo_nominal");
				
				givePlayerUang(playerid, -nominal);
				addTransaksiTabungan(PlayerInfo[playerid][nomorRekening], nominal, "Deposit tabungan");
				
				format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil menyimpan uang sebesar "GREEN"$%d "WHITE"pada tabungan anda.\nSilahkan cek tabungan anda.\n"YELLOW"Note : Setiap transaksi yang dilakukan akan otomatis tercatat pada history rekening anda.", nominal);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil menyimpan ke tabungan", pDialog[playerid], "Ok", "");
			}else
				DeletePVar(playerid, "depo_nominal");
			return 1;
		}
		case DIALOG_ATM:
		{
			if(response){
				switch(listitem){
					case 0: // Transfer Uang
					{
						ShowPlayerDialog(playerid, DIALOG_INPUT_REKENING_TUJUAN, DIALOG_STYLE_INPUT, "Nomor rekening tujuan", "Silahkan masukan nomor rekening tujuan:\nNomor rekening harus terdiri dari 8 digit.\nPastikan anda memasukan rekening yang benar.", "Ok", "Batal");
						return 1;
					}
					case 1: // Penarikan Uang
					{
						ShowPlayerDialog(playerid, DIALOG_TARIK_UANG_NOMINAL, DIALOG_STYLE_INPUT, "Nominal penarikan uang", "Silahkan masukan nominal yang ingin anda ambil :\n"YELLOW"Pastikan anda memiliki cukup saldo untuk mengambilnya.", "Tarik", "Kembali");
						return 1;
					}
					case 2: // Cek Saldo ATM
					{
						getSaldoPlayer(playerid, "tampilSaldoPlayer");
						return 1;
					}
					case 3: // History ATM
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(b.rekening, \"Bank Adm\") as rekening, a.nominal, a.tanggal, a.keterangan FROM `trans_atm` a LEFT JOIN `user` b ON a.id_pengirim_penerima = b.id WHERE id_user = '%d' ORDER BY tanggal DESC LIMIT 10", PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid], "historyATMPemain", "i", playerid);
						return 1;
					}
				}
			}
			return 1;
		}
		case DIALOG_INPUT_REKENING_TUJUAN:
		{
			if(response){
				new inputan;
				if(strlen(inputtext) != 8 || sscanf(inputtext, "i", inputan) || inputtext[0] == '-') return ShowPlayerDialog(playerid, DIALOG_INPUT_REKENING_TUJUAN, DIALOG_STYLE_INPUT, "Nomor rekening tujuan", RED"Nomor rekening harus terdiri dari 8 digit angka.\n"WHITE"Silahkan masukan nomor rekening tujuan:\nNomor rekening harus terdiri dari 8 digit.\nPastikan anda memasukan rekening yang benar.", "Ok", "Kembali");

				if(strcmp(inputtext, PlayerInfo[playerid][nomorRekening]) == 0) return ShowPlayerDialog(playerid, DIALOG_INPUT_REKENING_TUJUAN, DIALOG_STYLE_INPUT, "Nomor rekening tujuan", RED"Tidak dapat mengirim ke nomor rekening sendiri.\n"WHITE"Silahkan masukan nomor rekening tujuan:\nNomor rekening harus terdiri dari 8 digit.\nPastikan anda memasukan rekening yang benar.", "Ok", "Kembali");

				mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT nama FROM `user` WHERE rekening = '%e'", inputtext);
				mysql_tquery(koneksi, pQuery[playerid], "isRekeningTujuanAda", "is", playerid, inputtext);
			}
			return 1;
		}
		case DIALOG_TRANSFER_NOMINAL:
		{
			if(response){
				new nominal;
				if(sscanf(inputtext, "i", nominal)) return ShowPlayerDialog(playerid, DIALOG_TRANSFER_NOMINAL, DIALOG_STYLE_INPUT, "Nominal yang ingin ditransfer", RED"Nominal salah, silahkan memasukan jumlah yang benar.\n"WHITE"Masukan nominal yang ingin ditransfer:\n"YELLOW"Pastikan bahwa nominal yang ingin anda transfer tidak melebihi saldo tabungan anda.", "Ok", "Batal");
				if(nominal < 10) return ShowPlayerDialog(playerid, DIALOG_TRANSFER_NOMINAL, DIALOG_STYLE_INPUT, "Nominal yang ingin ditransfer", RED"Minimal nominal adalah $10.\n"WHITE"Masukan nominal yang ingin ditransfer:\n"YELLOW"Pastikan bahwa nominal yang ingin anda transfer tidak melebihi saldo tabungan anda.", "Ok", "Batal");

				SetPVarInt(playerid, "tf_nominal", nominal);

				getSaldoPlayer(playerid, "isMencukupiTransfer");
			}else{
				DeletePVar(playerid, "tf_nama");
				DeletePVar(playerid, "tf_rekening");
			}				
			return 1;
		}
		case DIALOG_TRANSFER_KONFIRMASI:
		{
			if(response){
				new nama_penerima[50], rekening_penerima[10], nominal = GetPVarInt(playerid, "tf_nominal");
				GetPVarString(playerid, "tf_nama", nama_penerima, sizeof(nama_penerima));
				GetPVarString(playerid, "tf_rekening", rekening_penerima, sizeof(rekening_penerima));
				if(strlen(inputtext) > 50){

					format(pDialog[playerid], sizePDialog, RED"Tidak dapat memasukan lebih dari 50 karakter.\n"WHITE"Anda akan melakukan transfer dengan data berikut :\n\n"YELLOW"Nama Penerima : %s\nNo. Rek : %s\nNominal : %d\n\n"WHITE"Anda yakin ingin mengirimnya? Silahkan isi keterangan pengiriman menandakan anda setuju.", nama_penerima, rekening_penerima, nominal);
					return ShowPlayerDialog(playerid, DIALOG_TRANSFER_KONFIRMASI, DIALOG_STYLE_INPUT, "Konfirmasi Transfer", pDialog[playerid], "Kirim", "Batal");					
				}

				addTransaksiTabungan(PlayerInfo[playerid][nomorRekening], -nominal, inputtext, rekening_penerima);
				addTransaksiTabungan(rekening_penerima, nominal, inputtext, PlayerInfo[playerid][nomorRekening]);

				DeletePVar(playerid, "tf_nama");
				DeletePVar(playerid, "tf_rekening");
				DeletePVar(playerid, "tf_nominal");
				
				new tahun, bulan, hari, jam, menit, detik;
				gettime(jam, menit, detik);
				getdate(tahun, bulan, hari);
				format(pDialog[playerid], sizePDialog, GREEN"PENGIRIMAN SUKSES!\n\n"WHITE"Informasi transfer.\nNama Penerima\t\t: %s\nRekening Penerima\t\t: %s\nNominal\t\t\t: %d\n\nNama Pengirim\t\t: %s\nRekening Pengirim\t\t: %s\nTanggal Waktu : %d/%d/%d %02d:%02d:%02d", nama_penerima, rekening_penerima, nominal, PlayerInfo[playerid][pPlayerName], PlayerInfo[playerid][nomorRekening], hari, bulan, tahun, jam, menit, detik);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Berhasil transfer duit", pDialog[playerid], "Ok", "");
			}else{
				DeletePVar(playerid, "tf_nama");
				DeletePVar(playerid, "tf_rekening");
				DeletePVar(playerid, "tf_nominal");
			}
			return 1;
		}
		case DIALOG_TARIK_UANG_NOMINAL:
		{
			if(response){
				new nominal;
				if(sscanf(inputtext, "i", nominal)) return ShowPlayerDialog(playerid, DIALOG_TARIK_UANG_NOMINAL, DIALOG_STYLE_INPUT, "Nominal penarikan uang", RED"Silahkan masukan nominal yang benar.\n"WHITE"Silahkan masukan nominal yang ingin anda ambil :\n"YELLOW"Pastikan anda memiliki cukup saldo untuk mengambilnya.", "Tarik", "Kembali");

				if(nominal < 10) return ShowPlayerDialog(playerid, DIALOG_TARIK_UANG_NOMINAL, DIALOG_STYLE_INPUT, "Nominal penarikan uang", RED"Nominal penarikan minimal adalah $10.\n"WHITE"Silahkan masukan nominal yang ingin anda ambil :\n"YELLOW"Pastikan anda memiliki cukup saldo untuk mengambilnya.", "Tarik", "Kembali");

				SetPVarInt(playerid, "wd_nominal", nominal);
				
				getSaldoPlayer(playerid, "isMencukupiTarik");
			}else{
				DeletePVar(playerid, "wd_nominal");
				showDialogATM(playerid);
			}
			return 1;
		}
		case DIALOG_TARIK_UANG_KONFIRMASI:
		{
			if(response){
				new nominal = GetPVarInt(playerid, "wd_nominal");

				addTransaksiTabungan(PlayerInfo[playerid][nomorRekening], -nominal, "Penarikan uang");
				givePlayerUang(playerid, nominal);

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Berhasil melakukan penarikan", GREEN"Berhasil melakukan penarikan uang!\n"WHITE"Penarikan uang akan langsung menambahkan uang tunai anda, dan mengurangi saldo ATM anda.\nSemua transaksi pada ATM akan tercatat secara otomatis dan permanen.", "Ok", "");

				DeletePVar(playerid, "wd_nominal");
			}else
				DeletePVar(playerid, "wd_nominal");
			return 1;
		}
		case DIALOG_INFO_SALDO_HISTORY:
		{
			if(response){
				showDialogATM(playerid);
			}
			return 1;
		}
		case DIALOG_TANYA_TAMBANG:
		{
			if(response){
				if(PlayerAction[playerid][sedangNambang]) return error_command(playerid, "Anda sedang menambang, tunggu beberapa saat.");
				if(getStatusMakanPemain(playerid) <= 10) return error_command(playerid, "Anda kehabisan energi, silahkan makan terlebih dahulu untuk dapat bekerja kembali.");
				PlayerAction[playerid][timerNambang] = SetTimerEx("selesaiNambang", 3000, 0, "i", playerid);
				PlayerAction[playerid][sedangNambang] = true;
				GameTextForPlayer(playerid, "~w~Sedang ~y~menambang...", 3000, 3);

				SetPlayerAttachedObject(playerid, MINING_ATTACH_INDEX, 19631, 6, 0.048, 0.029, 0.103, -80.0, 80.0, 0.0);
				TogglePlayerControllable(playerid, 0);
				SetPlayerArmedWeapon(playerid, 0);
				ApplyAnimation(playerid, "CHAINSAW", "CSAW_1", 4.1, 1, 0, 0, 1, 0, 1);
			}
			return 1;
		}
		case DIALOG_MENU_GAJI:
		{
			if(response){
				switch(listitem){
					case 0: // Ambil gaji
					{
						ShowPlayerDialog(playerid, DIALOG_PILIHAN_AMBIL_GAJI, DIALOG_STYLE_LIST, WHITE"Pilihan ambil gaji :", WHITE"Masukin ke saldo Bank\nAmbil uang cash", "Pilih", "Batal");
						return 1;
					}
					case 1: // Lihat gaji
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT nominal, tanggal, keterangan FROM `gaji` WHERE id_user = '%d' AND status = '0' ORDER BY tanggal ASC", PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid], "showHistoryGajiPemain", "i", playerid);
						return 1;
					}
				}
			}else
				ShowPlayerDialog(playerid, DIALOG_MENU_GAJI, DIALOG_STYLE_LIST, WHITE"Pilihan gaji :", WHITE"Ambil Gaji\nLihat Gaji", "Pilih", "Kembali");
			return 1;
		}
		case DIALOG_PILIHAN_AMBIL_GAJI:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						if(isnull(PlayerInfo[playerid][nomorRekening])) return showDialogPesan(playerid, RED"Tidak memiliki akun bank", WHITE"Anda tidak memiliki akun bank untuk menampung gaji anda.\nSilahkan buat akun bank anda terlebih dahulu, atau gunakan "YELLOW"metode pengambilan gaji lain.");

						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(SUM(nominal), 0) AS nominal FROM `gaji` WHERE id_user = '%d' AND status = '0'", PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid], "hitungGaji", "ii", playerid, 0);
					}
					case 1:
					{
						mysql_format(koneksi, pQuery[playerid], sizePQuery, "SELECT IFNULL(SUM(nominal), 0) AS nominal FROM `gaji` WHERE id_user = '%d' AND status = '0'", PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, pQuery[playerid], "hitungGaji", "ii", playerid, 1);
					}
				}
			}
			return 1;
		}
		case DIALOG_MENU_BELI_MAKAN:
		{
			if(response){
				SetPVarInt(playerid, "bmakan_index", listitem);
				ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_MAKANAN, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");
			}else{
				DeletePVar(playerid, "bmakan_index");
				DeletePVar(playerid, "bmakan_jumlah");
			}
			return 1;
		}
		case DIALOG_JUMLAH_PEMBELIAN_MAKANAN:
		{
			if(response){
				new jumlah;
				if(sscanf(inputtext, "i", jumlah)) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_MAKANAN, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");

				if(jumlah < 1 || jumlah > 100) return ShowPlayerDialog(playerid, DIALOG_JUMLAH_PEMBELIAN_MAKANAN, DIALOG_STYLE_INPUT, WHITE"Jumlah yang diinginkan", RED"Pastikan anda memasukan angka yang benar dan anda hanya dapat membeli 100 dalam sekali pembelian.\n"WHITE"Berapa banyak jumlah yang ingin anda beli:\nPastikan uang anda mencukupi.", "Bayar", "Kembali");

				SetPVarInt(playerid, "bmakan_jumlah", jumlah);

				ShowPlayerDialog(playerid, DIALOG_METODE_BAYAR_MAKAN, DIALOG_STYLE_LIST, "Pilih Metode Pembayaran:", "Uang Cash\nVia E-Banking", "Beli", "Kembali");
			}else{
				DeletePVar(playerid, "bmakan_index");
				DeletePVar(playerid, "bmakan_jumlah");

				showDialogTempatMakan(playerid);
			}
			return 1;
		}
		case DIALOG_METODE_BAYAR_MAKAN:
		{
			if(response){
				switch(listitem){
					case 0: // Bayar cash
					{
						new idx = GetPVarInt(playerid, "bmakan_index"), jumlah = GetPVarInt(playerid, "bmakan_jumlah");
						new harga = jumlah * MENU_MAKANAN[idx][hargaMakanan];
						DeletePVar(playerid, "bmakan_index");
						DeletePVar(playerid, "bmakan_jumlah");
						if(harga > getUangPlayer(playerid)) return showDialogPesan(playerid, RED"Uang tidak mencukupi", WHITE"Uang anda tidak mencukupi untuk melakukan pembelian ini.");

						givePlayerUang(playerid, -harga);
						tambahItemPlayer(playerid, MENU_MAKANAN[idx][idItemMakanan], jumlah);

						format(pDialog[playerid], sizePDialog, WHITE"Anda berhasil membeli "YELLOW"%s "WHITE" sebanyak "YELLOW"%d "WHITE"dengan harga total "GREEN"$%d\n"WHITE"Item langsung dikirimkan pada inventory anda, silahkan buka inventory untuk mengeceknya.", MENU_MAKANAN[idx][namaMakanan], jumlah, harga);
						showDialogPesan(playerid, GREEN"Berhasil membeli makanan", pDialog[playerid]);
						return 1;
					}
					case 1: // Via E-Banking
					{
						if(isnull(PlayerInfo[playerid][nomorRekening])) {
							DeletePVar(playerid, "bmakan_index");
							DeletePVar(playerid, "bmakan_jumlah");
							return showDialogPesan(playerid, RED"Tidak memiliki ATM", WHITE"Anda tidak memiliki ATM.\nSilahkan buat ATM terlebih dahulu untuk menggunakan metode ini.");
						}
						if(PlayerInfo[playerid][ePhone] == 0) {
							DeletePVar(playerid, "bmakan_index");
							DeletePVar(playerid, "bmakan_jumlah");
							return showDialogPesan(playerid, RED"Tidak memiliki ePhone", WHITE"Anda tidak memiliki ePhone.\nSilahkan beli dan gunakan ePhone terlebih dahulu (minimal ePhone 2) untuk menggunakan metode ini.");
						}
						new idx = GetPVarInt(playerid, "bmakan_index"), jumlah = GetPVarInt(playerid, "bmakan_jumlah");
						new harga = jumlah * MENU_MAKANAN[idx][hargaMakanan];

						format(pDialog[playerid], sizePDialog, WHITE"Silahkan konfirmasi pembayaran Via E-Banking.\n\nHarga yang akan dikenakan adalah "GREEN"$%d.\n"YELLOW"Untuk mengkonfirmasi pembayaran silahkan ketikan nomor rekening anda.", harga);
						ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BAYAR_MAKANAN_VIA_ATM, DIALOG_STYLE_INPUT, YELLOW"Konfirmasi pembayaran", pDialog[playerid], "Bayar", "Batal");
						return 1;
					}
				}
			}else{
				DeletePVar(playerid, "bmakan_index");
				DeletePVar(playerid, "bmakan_jumlah");				
			}
			return 1;
		}
		case DIALOG_KONFIRMASI_BAYAR_MAKANAN_VIA_ATM:
		{
			if(response){
				new idx = GetPVarInt(playerid, "bmakan_index"), jumlah = GetPVarInt(playerid, "bmakan_jumlah");
				new harga = jumlah * MENU_MAKANAN[idx][hargaMakanan];
				if(strlen(inputtext) != 8 || strcmp(PlayerInfo[playerid][nomorRekening], inputtext) != 0) {
					format(pDialog[playerid], sizePDialog, RED"Nomor rekening yang anda masukan tidak benar."WHITE"\n\nHarga yang akan dikenakan adalah "GREEN"$%d.\n"YELLOW"Untuk mengkonfirmasi pembayaran silahkan ketikan nomor rekening anda.", harga);
					return ShowPlayerDialog(playerid, DIALOG_KONFIRMASI_BAYAR_MAKANAN_VIA_ATM, DIALOG_STYLE_INPUT, YELLOW"Konfirmasi pembayaran", pDialog[playerid], "Bayar", "Batal");	
				}
				getSaldoPlayer(playerid, "pembayaranMakananATM");
			}else{
				DeletePVar(playerid, "bmakan_index");
				DeletePVar(playerid, "bmakan_jumlah");				
			}
		}
		case DIALOG_JOB_SWEEPER:
		{
			if(response){
				if(todoActive(playerid) == 1){
					RemovePlayerFromVehicle(playerid);
					return 1;
				}
				sweeperJob[playerid] = 1;
				SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper1, CP_sweeper2, 3.0);
				SendClientMessage(playerid, COLOR_GREEN, "[JOB] "YELLOW"Anda berhasil bekerja sebagai "GREEN"Sweeper"YELLOW"!");
			}else{
				sweeperJob[playerid] = 0;
				sweeperId[playerid] = -1;
				RemovePlayerFromVehicle(playerid);
			}
			return 1;
		}
		case DIALOG_SIM_REGIS_MENU:
		{
			if(response){
				switch(listitem){
					// Buat SIM
					case 0:
					{
						// Eksekusi fungsi pengecekan, 
						// yang akan langsung mengeksekusi pembuatan jika memungkinkan
						if(todoActive(playerid) == 1){
							return 1;
						}
						getSudahBuatSIM(playerid, "cekSudahPunyaSIM");
					}
					// Ambil SIM yang sudah selesai
					case 1:
					{
						if(todoActive(playerid) == 1){
							return 1;
						}
						getSudahBuatSIM(playerid, "cekSudahBisaAmbilSIM", false);
					}
				}
			}else{
				showDialogSimRegis(playerid);
			}
			return 1;
		}
		case DIALOG_DAFTAR_SIM_KONFIRMASI:
		{
			if(response){
				if(getUangPlayer(playerid) < 100){
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Uang tidak mencukupi", "Anda tidak memiliki cukup uang untuk mendaftarkan SIM baru.", "Ok", "");
				}else{
					cekKetersediaanItem(playerid, 7, 1, "cekPembuatanSIM");
				}
			}
			return 1;
		}
    }
	// Wiki-SAMP OnDialogResponse should return 0
    return 0;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid){
	if(clickedid == Text:INVALID_TEXT_DRAW){
		hideTextDrawMyInfo(playerid);
		hideTextDrawShowItem(playerid);
		if(PlayerInfo[playerid][onSelectedTextdraw]) CancelSelectTextDraw(playerid);
		PlayerInfo[playerid][onSelectedTextdraw] = false;
	}
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(playertextid == PlayerText:INVALID_TEXT_DRAW){
		hideTextDrawMyInfo(playerid);
		hideTextDrawShowItem(playerid);
		if(PlayerInfo[playerid][onSelectedTextdraw]) CancelSelectTextDraw(playerid);
		PlayerInfo[playerid][onSelectedTextdraw] = false;
		return 1;
	}
    else if(playertextid == showItem[playerid][4])
    {
		if(PlayerInfo[playerid][onSelectedTextdraw]) CancelSelectTextDraw(playerid);
		hideTextDrawShowItem(playerid);
		PlayerInfo[playerid][onSelectedTextdraw] = false;
        return 1;
    }else if(playertextid == myInfo[playerid][7]){
		if(PlayerInfo[playerid][onSelectedTextdraw]) CancelSelectTextDraw(playerid);
		hideTextDrawMyInfo(playerid);
		PlayerInfo[playerid][onSelectedTextdraw] = false;
		return 1;
	}
    return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_JUMP) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT){
		new Float:pos[3];
		if(getStatusMinumPemain(playerid) < 5){
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			ClearAnimations(playerid);
			server_message(playerid, "Anda tidak memiliki cukup energi untuk melompat.");
		}else{
			setStatusMinumPemain(playerid, getStatusMinumPemain(playerid) - 0.5);
		}
	}
    return 1;
}

public OnPlayerSpawn(playerid)
{
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerSpawn terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif	
	if(IsPlayerNPC(playerid)) return 1;
	houseNotif[playerid] = -1;

	// Tambang
	if(IsPlayerAttachedObjectSlotUsed(playerid, MINING_ATTACH_INDEX)) RemovePlayerAttachedObject(playerid, MINING_ATTACH_INDEX);
	KillTimer(PlayerAction[playerid][timerNambang]);
	PlayerAction[playerid][sedangNambang] = false;

	PlayerInfo[playerid][onSelectedTextdraw] = false;

	spawnPemain(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerDeath terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif

	PlayerInfo[playerid][sudahSpawn] = false;
	hideHUDStats(playerid);
	
	PlayerInfo[playerid][onSelectedTextdraw] = false;

	resetPlayerToDo(playerid);

	new random_spawn = random(sizeof(SPAWN_POINT));
	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skinID], SPAWN_POINT[random_spawn][SPAWN_POINT_X], SPAWN_POINT[random_spawn][SPAWN_POINT_Y], SPAWN_POINT[random_spawn][SPAWN_POINT_Z], SPAWN_POINT[random_spawn][SPAWN_POINT_A], 0, 0, 0, 0, 0, 0);

	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerRequestClass terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif

	if(IsPlayerNPC(playerid)) return 1;
	print("Request Class Fungsi");
	if(PlayerInfo[playerid][sudahLogin]) {
		print("Request Class Called");
		spawnPemain(playerid);
		return 1;
	}
	// Interpolate Camera untuk login
	// Spawn di request class dihilangin
	// SetSpawnInfo(playerid, NO_TEAM, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	// SpawnPlayer(playerid);
	return 0;
}

public OnPlayerRequestSpawn(playerid){
	#if DEBUG_MODE_FOR_PLAYER == true
		printf("OnPlayerRequestSpawn terpanggil (%d - %s)", playerid, PlayerInfo[playerid][pPlayerName]);
	#endif	
	if(PlayerInfo[playerid][sudahLogin]) return 1;
	return 0;
}

/*
	UNTUK HILANGKAN INVALID INDEX PARAMETER (BAD ENTRY POINT) BIARKAN SAJA FUNGSI MAIN
*/
main( ) { }

public OnGameModeInit()
{
	koneksi = mysql_connect_file();
	errno = mysql_errno(koneksi);
	if(errno != 0){
		new error[100];
	
		mysql_error(error, sizeof (error), koneksi);
		printf("[ERROR] #%d '%s'", errno, error);
	}else{
		printf("[SUCCESS] Berhasil Koneksi ke database!");
	}

	printf("[MAPPING] Load semua mappingan...");
	loadAllMapingan();
	printf("[MAPPING] Sukses load mapping!");

	printf("[ITEM] Load semua item...");
	loadAllItem();
	printf("[ITEM] Sukses load item!");

	printf("[PICKUP] Load semua pickup...");
	loadAllPickup();
	printf("[PICKUP] Sukses load pickup!");

	printf("[CHECKPOINT] Load semua checkpoint...");
	loadAllCP();
	printf("[CHECKPOINT] Sukses load checkpoint!");

	printf("[MAP ICON] Load semua map icon...");
	loadAllMapIcon();
	printf("[MAP ICON] Sukses load map icon!");

	printf("[HOUSE] Load semua house...");
	resetAllHouse();
	printf("[HOUSE] Sukses load house!");

	SetGameModeText("EL v1.0");
	// ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	ShowNameTags(1);
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	
	printf("[TEXTDRAW] Load textdraw global..");
	loadTextdrawGlobal();
	printf("[TEXTDRAW] Sukses load textdraw!");

	// SPECIAL
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/trains.txt");
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/pilots.txt");
    
    // LOS SANTOS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_inner.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_outer.txt");
    
    // OTHER AREAS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/whetstone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/bone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/flint.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/tierra.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/red_county.txt");

    printf("Total vehicles from files: %d",total_vehicles_from_files);

    // Sweeper Vehicle
    vehicleSweeper[0] = CreateVehicle(574, 708.4822, -1193.1827, 15.0324, 0.0000, -1, -1, 60);
	vehicleSweeper[1] = CreateVehicle(574, 706.6257, -1196.5216, 14.9840, 0.0000, -1, -1, 60);
	vehicleSweeper[2] = CreateVehicle(574, 704.5869, -1199.6705, 14.9557, 0.0000, -1, -1, 60);

	vehicleSIM[0] = CreateVehicle(596, 1584.9463, -1606.8075, 13.1038, 180.6711, -1, -1, 60);
	vehicleSIM[1] = CreateVehicle(596, 1580.1217, -1607.0674, 13.1037, 179.7378, -1, -1, 60);
	vehicleSIM[2] = CreateVehicle(596, 1575.1067, -1606.8228, 13.1040, 179.4362, -1, -1, 60);
	return 1;
}

public OnGameModeExit(){
	foreach(new i : Player){
		if(i != INVALID_PLAYER_ID)
			Kick(i);
	}
	unloadTextdrawGlobal();
	unloadAllHouse();
	mysql_close(koneksi);
	return 1;
}

//----------------------------------------------------------

public OnPlayerUpdate(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(IsPlayerNPC(playerid)) return 1;
	
	// No weapons in interiors
	//if(GetPlayerInterior(playerid) != 0 && GetPlayerWeapon(playerid) != 0) {
	    //SetPlayerArmedWeapon(playerid,0); // fists
	    //return 0; // no syncing until they change their weapon
	//}
	
	// Don't allow minigun
	if(GetPlayerWeapon(playerid) == WEAPON_MINIGUN) {
		Kick(playerid);
		return 0;
	}

	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate){
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER){
		ShowPlayerSpeedo(playerid);
	}
	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_ONFOOT){
		HidePlayerSpeedo(playerid);
	}
	for(new v = 0; v < 3; v++){
		if(vehicleSIM[v]){
			if(GetPlayerVehicleID(playerid) == vehicleSIM[v] && testSim[playerid] != 1 || GetPlayerVehicleID(playerid) != vehicleIdSIM[playerid] && testSim[playerid] == 1){
				RemovePlayerFromVehicle(playerid);
			}
			if(newstate == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == vehicleIdSIM[playerid] && testSim[playerid] == 1){
				KillTimer(todoTimer[playerid]);
			}
		}
		if(vehicleSweeper[v]){
			if(GetPlayerVehicleID(playerid) == vehicleSweeper[v] && sweeperJob[playerid] == 1 && sweeperId[playerid] != GetPlayerVehicleID(playerid)){
				RemovePlayerFromVehicle(playerid);
			}
			if(newstate == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == vehicleSweeper[v] && sweeperJob[playerid] == 1){
				KillTimer(todoTimer[playerid]);
			}else if(newstate == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == vehicleSweeper[v] && sweeperJob[playerid] == 0){
				sweeperId[playerid] = GetPlayerVehicleID(playerid);
				ShowPlayerDialog(playerid, DIALOG_JOB_SWEEPER, DIALOG_STYLE_MSGBOX, "Sweeper Job", WHITE"Apakah anda ingin bekerja sebagai "GREEN"Sweeper"WHITE"? Jika anda ingin bekerja klik "GREEN"Setuju"WHITE" untuk memulai.", "Setuju", "Batal");
			}
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(vehicleid == sweeperId[playerid] && sweeperJob[playerid] == 1){
		SendClientMessage(playerid, COLOR_GREEN, "[JOB] "RED"Anda keluar dari kendaraan, silahkan kembali bekerja! "WHITE"Sebelum 30 detik atau anda berhenti bekerja.");
		todoTimer[playerid] = SetTimerEx("todoExit", 30000, false, "ii", playerid, sweeperId[playerid]);
	}else if(vehicleid == vehicleIdSIM[playerid] && testSim[playerid] == 1){
		SendClientMessage(playerid, COLOR_GREEN, "[HALO Polisi] "RED"Anda keluar dari kendaraan, silahkan kembali praktik! "WHITE"Sebelum 30 detik atau anda gagal praktik pengujian SIM.");
		todoTimer[playerid] = SetTimerEx("todoExit", 30000, false, "ii", playerid, vehicleIdSIM[playerid]);
	}
    return 1;
}

public OnPlayerText(playerid, text[]){
	format(msg,sizeof(msg), "[%d] %s : %s", playerid,  PlayerInfo[playerid][pPlayerName], text);
	ProxDetector(30.0, playerid, msg, COLOR_WHITE);
	format(msg,sizeof(msg), "berkata: %s", text);
	SetPlayerChatBubble(playerid, msg, -1, 40.0, 5000);
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1000);
	// Wiki Samp - OnPlayerText
	// Return 1 - Mengirimkan pesan default
	// Return 0 - Mengirimkan pesan yang sudah dicustom saja, tanpa menjalankan perintah default pesan
	return 0; // ignore the default text and send the custom one
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid){
	if(pickupid == PU_tempatFoto_in[0]){
		pindahkanPemain(playerid, -203.9351, -25.4899, 1002.2734, 330.6535, 16, VW_tempatFoto_1, false);
		return 1;
	}else if(pickupid == PU_tempatFoto_in[1]){
		pindahkanPemain(playerid, -203.9351, -25.4899, 1002.2734, 330.6535, 16, VW_tempatFoto_2, false);
		return 1;
	}
	else if(pickupid == PU_tempatFoto_out){
		switch(GetPlayerVirtualWorld(playerid)){
			case VW_tempatFoto_1:
			{
				pindahkanPemain(playerid, 1112.2352, -1372.2939, 13.9844, 178.5421, 0, 0, true);
				return 1;
			}
			case VW_tempatFoto_2:
			{
				pindahkanPemain(playerid, 1553.7258, -1448.3143, 13.5469, 359.9397, 0, 0, false);
				return 1;
			}
		}
		return 1;
	}
	else if(pickupid == PU_tempatMakan_in[0]){
		pindahkanPemain(playerid, 365.5712,-8.7934,1001.8516,351.2707, 9, VW_tempatMakan_1, false);
		return 1;
	}
	else if(pickupid == PU_tempatMakan_in[1]){
		pindahkanPemain(playerid, 365.5712,-8.7934,1001.8516,351.2707, 9, VW_tempatMakan_2, false);
		return 1;
	}
	else if(pickupid == PU_tempatMakan_out){
		switch(GetPlayerVirtualWorld(playerid)){
			case VW_tempatMakan_1:
			{
				pindahkanPemain(playerid, 924.8441, -1353.0880, 13.3768, 89.3053, 0, 0, true);
				return 1;
			}
			case VW_tempatMakan_2:
			{
				pindahkanPemain(playerid, 814.8109,-1616.3394,13.6281, 245.7708, 0,0, true);
				return 1;	
			}
		}
		return 1;
	}
	else if(pickupid == PU_miniMarket[0][ENTER_PICKUP]){
		pindahkanPemain(playerid, -25.884498, -185.868988, 1003.546875, 0.0, 17, 1, false);
		return 1;
	}
	else if(pickupid == PU_miniMarket[0][EXIT_PICKUP]){
		pindahkanPemain(playerid, 1353.8392, -1757.3990, 13.5078, 269.0087, 0, 0, false);
		return 1;
	}
	else if(pickupid == PU_tempatBaju[0][ENTER_PICKUP]){
		pindahkanPemain(playerid, 161.3910, -93.1592, 1001.8047, 0.0, 18, 1, false);
		return 1;
	}
	else if(pickupid == PU_tempatBaju[0][EXIT_PICKUP]){
		pindahkanPemain(playerid, 500.7141, -1357.8710, 16.1328, 336.5217, 0, 0, false);
		return 1;
	}
	else if(pickupid == housePickup[houseId[pickupid]]){
		new id = houseId[pickupid];
		lastHousePickup[playerid] = pickupid;
		if(houseNotif[playerid] != id){
			houseNotif[playerid] = id;
			format(msg, 256, "[RUMAH]"WHITE" Ketik "GREEN"/inforumah"WHITE" untuk melihat info tentang rumah.");
	    	SendClientMessage(playerid, COLOR_GREEN, msg);
		}
	}else if(pickupid == PU_cityHallMasuk[0] || pickupid == PU_cityHallMasuk[1] || pickupid == PU_cityHallMasuk[2]){
		pindahkanPemain(playerid, -501.2855,289.1127,2001.0950, 357.5606, 1, 1, true);
		return 1;
	}else if(pickupid == PU_cityHallKeluar){
		new rand_idx = random(sizeof(SPAWN_POINT_OUT_CH));
		pindahkanPemain(playerid, SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_X],SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_Y],SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_Z],SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_A], SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_INTERIOR], SPAWN_POINT_OUT_CH[rand_idx][SPAWN_POINT_VW], true);
		return 1;
	}else if(pickupid == PU_bankLS[ENTER_PICKUP]){
		pindahkanPemain(playerid, 1417.1097,-982.6887,-55.2764,180.0692, 1, 1, true);
		return 1;
	}else if(pickupid == PU_bankLS[EXIT_PICKUP]){
		new rand_idx = random(sizeof(SP_OUT_BANK_LS));
		pindahkanPemain(playerid, SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_X],SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_Y],SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_Z],SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_A], SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_INTERIOR], SP_OUT_BANK_LS[rand_idx][SPAWN_POINT_VW], true);
		return 1;
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid){
	if(checkpointid == CP_tempatFoto){
		new jam, menit, detik;
		gettime(jam, menit, detik);
		if(GetPlayerVirtualWorld(playerid) == VW_tempatFoto_2 && !(jam >= 20 || jam <= 5)) return SendClientMessage(playerid, COLOR_RED, "Maaf Tempat foto "nama_B" saat ini tutup! Silahkan kembali antara jam 20.00 hingga 05.59.");

		new harga = (GetPlayerVirtualWorld(playerid) == VW_tempatFoto_2) ? 10 : 20;

		format(pDialog[playerid], sizePDialog, WHITE"Berapa banyak foto yang ingin anda cetak?\n"YELLOW"Harga 1 foto adalah "GREEN"%d", harga);

		ShowPlayerDialog(playerid, DIALOG_TEMPAT_FOTO, DIALOG_STYLE_INPUT, "Foto dan Cetak", pDialog[playerid], "Cetak", "Batal");
		return 1;
	}else if(checkpointid == CP_spotBarangMarket[0] || checkpointid == CP_spotBarangMarket[1] || checkpointid == CP_spotBarangMarket[2] || checkpointid == CP_spotBarangMarket[3]){
		showDialogBeliBarang(playerid);
		return 1;
	}else if(checkpointid == CP_spotGantiSkin){
		ShowPlayerDialog(playerid, DIALOG_REFRESH_SKIN, DIALOG_STYLE_MSGBOX, "Refresh skin anda", "Apakah anda yakin ingin mensinkronisasikan kembali skin anda?\n\n"YELLOW"** Skin yang akan direfresh adalah skin yang sudah anda use pada inventory anda.\nJika anda belum memilih skin yang ingin anda gunakan, anda dapat membuka inventory\nLalu pilih skin yang ingin anda gunakan.", "Ganti", "Batal");
		return 1;
	}else if(checkpointid == CP_spotBeliSkin[0] || checkpointid == CP_spotBeliSkin[1] || checkpointid == CP_spotBeliSkin[2]){
		ShowPlayerDialog(playerid, DIALOG_TANYA_INGIN_BELI_SKIN, DIALOG_STYLE_MSGBOX, WHITE"Ingin beli skin?", "Apakah anda ingin membeli "YELLOW"skin normal "WHITE"dengan harga "GREEN"2500 "WHITE"per skin?", "Beli", "Batal");
		return 1;
	}else if(checkpointid == CP_resepsionisCityHall){
		showDialogResepsionis(playerid);
		return 1;
	}else if(checkpointid == CP_tellerBankLS[0] || checkpointid == CP_tellerBankLS[1]){
		showDialogTellerBank(playerid);
		return 1;
	}else if(checkpointid == CP_ATM[0]){
		if(isnull(PlayerInfo[playerid][nomorRekening])) return SendClientMessage(playerid, COLOR_RED, "[ATM] "WHITE"Anda tidak dapat menggunakan ATM jika tidak memiliki rekening");
		showDialogATM(playerid);
		return 1;
	}else if(checkpointid >= CP_Tambang[0] && checkpointid <= CP_Tambang[sizeof(CP_Tambang) - 1]) {
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return error_command(playerid, "Anda harus berjalan kaki untuk dapat menambang!");
		if(PlayerInfo[playerid][sisaPalu] <= 0) return error_command(playerid, "Anda kehabisan kesempatan menambang, gunakan item Palu Tambang untuk menambah kesempatan anda.");
		ShowPlayerDialog(playerid, DIALOG_TANYA_TAMBANG, DIALOG_STYLE_MSGBOX, "Ingin menambang", "Apakah anda ingin menambang?\n"YELLOW"Note : Anda membutuhkan cangkul untuk menambang.", "Ya", "Tidak");
	}else if(checkpointid == CP_beliMakanCepatSaji){
		showDialogTempatMakan(playerid);
		return 1;
	}else if(checkpointid == CP_simPoliceRegis[0]){
		showDialogSimRegis(playerid);
		return 1;
	}
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid){
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 574 && sweeperJob[playerid] == 1){
		if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper1)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper2, CP_sweeper3, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper2)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper3, CP_sweeper4, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper3)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper4, CP_sweeper5, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper4)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper5, CP_sweeper6, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper5)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper6, CP_sweeper7, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper6)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper7, CP_sweeper8, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper7)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper8, CP_sweeper9, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper8)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper9, CP_sweeper10, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper9)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper10, CP_sweeper11, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper10)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper11, CP_sweeper12, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper11)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper12, CP_sweeper13, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper12)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper13, CP_sweeper14, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper13)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper14, CP_sweeper15, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper14)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper15, CP_sweeper16, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper15)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper16, CP_sweeper17, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper16)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper17, CP_sweeper18, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper17)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper18, CP_sweeper19, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper18)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper19, CP_sweeper20, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper19)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper20, CP_sweeper21, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper20)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper21, CP_sweeper22, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper21)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper22, CP_sweeper23, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper22)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper23, CP_sweeper24, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper23)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper24, CP_sweeper25, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper24)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper25, CP_sweeper26, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper25)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper26, CP_sweeper27, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper26)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper27, CP_sweeper28, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper27)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper28, CP_sweeper29, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper28)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper29, CP_sweeper30, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper29)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper30, CP_sweeper31, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper30)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper31, CP_sweeper32, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper31)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper32, CP_sweeper33, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper32)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper33, CP_sweeper34, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper33)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_sweeper34, CP_sweeper35, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper34)){
			SetPlayerRaceCheckpoint(playerid, 1, CP_sweeper35, 0.0, 0.0, 0.0, 3.0);
			GameTextForPlayer(playerid, "~y~Membersihkan...", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_sweeper35)){
			addGajiPemain(playerid, 100, "Pembersih jalan (sweeper)");
			GameTextForPlayer(playerid, "~g~Pekerjaan Selesai", 2000, 3);
			ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", GREEN"Anda telah berhasil menyelesaikan pekerjaan!\n"WHITE"Upah sudah terkirim ke rekening gaji anda sebesar "GREEN"$100\n"WHITE"Silahkan ambil gaji anda ke Bank terdekat.", "Ok", "");
			DisablePlayerRaceCheckpoint(playerid);
			SetVehicleToRespawn(sweeperId[playerid]);
			sweeperJob[playerid] = 0;
			sweeperId[playerid] = -1;
		}
	}
	if(GetPlayerVehicleID(playerid) == vehicleIdSIM[playerid] && testSim[playerid] == 1){
		if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS1)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS2, CP_simLS3, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS2)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS3, CP_simLS4, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS3)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS4, CP_simLS5, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS4)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS5, CP_simLS6, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS5)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS6, CP_simLS7, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS6)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS7, CP_simLS8, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS7)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS8, CP_simLS9, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS8)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS9, CP_simLS10, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS9)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS10, CP_simLS11, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS10)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS11, CP_simLS12, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS11)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS12, CP_simLS13, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS12)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS13, CP_simLS14, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS13)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS14, CP_simLS15, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS14)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS15, CP_simLS16, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS15)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS16, CP_simLS17, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS16)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS17, CP_simLS18, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS17)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS18, CP_simLS19, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS18)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS19, CP_simLS20, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS19)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS20, CP_simLS21, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS20)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS21, CP_simLS22, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS21)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS22, CP_simLS23, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS22)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS23, CP_simLS24, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS23)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS24, CP_simLS25, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS24)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS25, CP_simLS26, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS25)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS26, CP_simLS27, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS26)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS27, CP_simLS28, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS27)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS28, CP_simLS29, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS28)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS29, CP_simLS30, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS29)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS30, CP_simLS31, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS30)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS31, CP_simLS32, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS31)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS32, CP_simLS33, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS32)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS33, CP_simLS34, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS33)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS34, CP_simLS35, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS34)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS35, CP_simLS36, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS35)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS36, CP_simLS37, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS36)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS37, CP_simLS38, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS37)){
			SetPlayerRaceCheckpoint(playerid, 0, CP_simLS38, CP_simLS39, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS38)){
			SetPlayerRaceCheckpoint(playerid, 1, CP_simLS39, 0.0, 0.0, 0.0, 3.0);
			GameTextForPlayer(playerid, "~y~Terus Mengemudi", 2000, 3);
		}else if(IsPlayerInRangeOfPoint(playerid, 3.0, CP_simLS39)){
			if(poinSim[playerid] <= 80){
				givePlayerUang(playerid, -100);
				GameTextForPlayer(playerid, "~g~Praktik SIM Selesai", 2000, 3);
				format(pDialog[playerid], sizePDialog, WHITE"Anda mendapatkan poin sebesar "GREEN"%d"WHITE".\nSilahkan mencoba kembali ketika anda sudah siap.\n\nTerimakasih, Salam hangat "ORANGE"Kantor Polisi Lost Santos", poinSim[playerid]);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, RED"Gagal Praktik SIM", pDialog[playerid], "Ok", "");
				DisablePlayerRaceCheckpoint(playerid);
				SetVehicleToRespawn(vehicleIdSIM[playerid]);
				testSim[playerid] = 0;
				vehicleIdSIM[playerid] = -1;
				poinSim[playerid] = 0;
			}else{
				prosesPembuatanSIM(playerid, 30);
				givePlayerUang(playerid, -100);
				GameTextForPlayer(playerid, "~g~Praktik SIM Selesai", 2000, 3);
				format(pDialog[playerid], sizePDialog, WHITE"Anda mendapatkan poin sebesar "GREEN"%d"WHITE".\nSilahkan tunggu sekitar 30 menit real-time."WHITE"\nAnda dapat mengecek dan mengambilnya di tempat Registrasi sebelumnya, setelah sudah 30 menit berlalu.\n\nTerimakasih, Salam hangat "ORANGE"Kantor Polisi Lost Santos", poinSim[playerid]);
				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil Praktik SIM", pDialog[playerid], "Ok", "");
				DisablePlayerRaceCheckpoint(playerid);
				SetVehicleToRespawn(vehicleIdSIM[playerid]);
				testSim[playerid] = 0;
				vehicleIdSIM[playerid] = -1;
				poinSim[playerid] = 0;
			}
		}
	}
	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[]){
	if(PlayerInfo[playerid][sudahLogin] == false){
		error_command(playerid, "Anda harus login terlebih dahulu untuk dapat menggunakan command!");
		error_command(playerid, "Anda telah dikick dari server karena menggunakan command sebelum login.");
		KickEx(playerid);
		return 0;
	}
	return 1;
}

/**
	TIMER TASK
**/
task updateWorldTime[1000]()
{
	new temp_jam, temp_menit, temp_detik, str_waktu[32],
		temp_tahun, temp_bulan, temp_hari;
	gettime(temp_jam, temp_menit, temp_detik);
	SetWorldTime(temp_jam);

	format(str_waktu,32,"%02d:%02d:%02d", temp_jam, temp_menit, temp_detik);
	TextDrawSetString(TD_JamTanggal[0], str_waktu);

	getdate(temp_tahun, temp_bulan, temp_hari);
	if(temp_hari != last_hari){
		last_hari = temp_hari;
		mysql_tquery(koneksi, "SELECT DAYOFWEEK(CURRENT_DATE()) AS nama_hari", "responseUpdateHari");
	}

	foreach(new i : Player){
		SetPlayerTime(i, temp_jam, temp_menit);
	}
}

#include <command>