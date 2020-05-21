loadAllCP(){
    CP_tempatFoto = buatCPDanLabel(-201.7664,-25.4403,1002.2734, "Silahkan cetak foto\n"GREEN"Disini!", 1.0);
    
    // Spot pembelian di dalam market
    CP_spotBarangMarket[0] = buatCPDanLabel(-4.2324, -176.4322, 1003.5469, "Barang-barang\nBeli disini!", 1.0);
    CP_spotBarangMarket[1] = buatCPDanLabel(-9.7521, -169.9181, 1003.5469, "Barang-barang\nBeli disini!", 1.0);
    CP_spotBarangMarket[2] = buatCPDanLabel(-34.2435, -182.2766, 1003.5469, "Barang-barang\nBeli disini!", 1.0);
    CP_spotBarangMarket[3] = buatCPDanLabel(-34.2461, -172.7712, 1003.5469, "Barang-barang\nBeli disini!", 1.0);

    // Spot beli skin di toko baju
    CP_spotBeliSkin[0] = buatCPDanLabel(152.3235,-83.6493,1001.8047, "Skin normal\n"GREEN"Beli skin disini!", 1.0);
    CP_spotBeliSkin[1] = buatCPDanLabel(167.2928,-89.5232,1001.8047, "Skin normal\n"GREEN"Beli skin disini!", 1.0);
    CP_spotBeliSkin[2] = buatCPDanLabel(175.2670,-83.3361,1001.8047, "Skin normal\n"GREEN"Beli skin disini!", 1.0);

    // Spot ganti skin
    CP_spotGantiSkin = buatCPDanLabel(181.0340,-91.6368,1002.0234, "Ganti skin\n"YELLOW"Refresh skin anda disini.", 1.0);

    // City Hall Respsionis
    CP_resepsionisCityHall = buatCPDanLabel(-501.1717,294.3522,2001.0950, "Resepsionis Pemerintah Los Santos\n"BLUE"Silahkan kesini untuk melakukan pengurusan data!", 1.0);

    // Teller Bank LS
    CP_tellerBankLS[0] = buatCPDanLabel(1421.4474,-988.9171,-55.2764, "Teller Bank Los Santos\n"GREEN"Pengurusan Administrasi disini.", 1.0, 1, 1);
    CP_tellerBankLS[1] = buatCPDanLabel(1417.4258,-988.8285,-55.2764, "Teller Bank Los Santos\n"GREEN"Pengurusan Administrasi disini.", 1.0, 1, 1);

    // CP ATM
    CP_ATM[0] = buatCPDanLabel(1412.3097,-987.6777,-55.2764, GREEN"ATM tersedia", 1.0, 1, 1);

    // CP Tambang
    for(new i = 0; i < sizeof(POSISI_NAMBANG); i++){
		CP_Tambang[i] = buatCPDanLabel(POSISI_NAMBANG[i][POSISI_X], POSISI_NAMBANG[i][POSISI_Y], POSISI_NAMBANG[i][POSISI_Z], GREEN"Tambang tersedia", 1.5, POSISI_NAMBANG[i][POSISI_VW], POSISI_NAMBANG[i][POSISI_INT]);
    }
    if(CP_Tambang[0] + sizeof(POSISI_NAMBANG) - 1 != CP_Tambang[sizeof(POSISI_NAMBANG) - 1]){
        printf("[ERROR] #05 Checkpoint tambang tidak memiliki ID yang simetris.");
        SendRconCommand("exit");
    }
}