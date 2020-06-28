loadAllCP(){
    CP_tempatFoto = buatCPDanLabel(-201.7664,-25.4403,1002.2734, "Silahkan cetak foto\n"GREEN"Disini!", 1.0);
    
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

    // Beli Makanan
    CP_beliMakanCepatSaji = buatCPDanLabel(369.9234,-6.0165,1001.8589, GREEN"Beli Makan disini!", 1.0, -1, 9);

    // CP Beli Barang Market - Spot pembelian di dalam market
    foreach(new i : Range(0, sizeof(POSISI_BELI_BARANG_MARKET))){
      CP_spotBarangMarket[i] = buatCPDanLabel(POSISI_BELI_BARANG_MARKET[i][POSISI_X], POSISI_BELI_BARANG_MARKET[i][POSISI_Y], POSISI_BELI_BARANG_MARKET[i][POSISI_Z], ORANGE"Barang-barang\n"WHITE"Beli disini!", 1.0, POSISI_BELI_BARANG_MARKET[i][POSISI_VW], POSISI_BELI_BARANG_MARKET[i][POSISI_INT]);
    }
    if(CP_spotBarangMarket[0] + sizeof(POSISI_BELI_BARANG_MARKET) - 1 != CP_spotBarangMarket[sizeof(POSISI_BELI_BARANG_MARKET) - 1]){
        printf("[ERROR] #05 Checkpoint Beli Barang Market tidak memiliki ID yang simetris.");
        SendRconCommand("exit");
    }

    foreach(new i : Range(0, sizeof(POSISI_SPAWN_REPARASI_MOBIL))){
      CP_spawnReparasi[i] = buatCPDanLabel(POSISI_SPAWN_REPARASI_MOBIL[i][SPAWN_POINT_X], POSISI_SPAWN_REPARASI_MOBIL[i][SPAWN_POINT_Y], POSISI_SPAWN_REPARASI_MOBIL[i][SPAWN_POINT_Z], YELLOW"Ambil kendaraan disini.\n"RED"Setelah mengambil kendaraan segera pindahkan\nagar tidak menghalangi yang lain.", 3.0, POSISI_SPAWN_REPARASI_MOBIL[i][SPAWN_POINT_VW], POSISI_SPAWN_REPARASI_MOBIL[i][SPAWN_POINT_INTERIOR]);
    }
    if(CP_spawnReparasi[0] + sizeof(POSISI_SPAWN_REPARASI_MOBIL) - 1 != CP_spawnReparasi[sizeof(POSISI_SPAWN_REPARASI_MOBIL) - 1]){
        printf("[ERROR] #05 Checkpoint Spawn Reparasi tidak memiliki ID yang simetris.");
        SendRconCommand("exit");
    }

    // CP Tambang
    foreach(new i : Range(0, sizeof(POSISI_NAMBANG))){
      CP_Tambang[i] = buatCPDanLabel(POSISI_NAMBANG[i][POSISI_X], POSISI_NAMBANG[i][POSISI_Y], POSISI_NAMBANG[i][POSISI_Z], GREEN"Tambang tersedia", 1.5, POSISI_NAMBANG[i][POSISI_VW], POSISI_NAMBANG[i][POSISI_INT]);
    }
    if(CP_Tambang[0] + sizeof(POSISI_NAMBANG) - 1 != CP_Tambang[sizeof(POSISI_NAMBANG) - 1]){
        printf("[ERROR] #05 Checkpoint tambang tidak memiliki ID yang simetris.");
        SendRconCommand("exit");
    }

     // Buat SIM
    CP_simRegis[0] = buatCPDanLabel(253.9280,69.7131,1003.6406, "Polisi Metro Los Santos\nPelayanan SIM\n"GREEN"Registrasi", 1.0);
    CP_simPraktik[0] = buatCPDanLabel(1580.3300,-1635.5547,13.5601, "Polisi Metro Los Santos\nPelayanan SIM\n"GREEN"Praktik", 1.0);

    CP_pusatProperti[0] = buatCPDanLabel(1087.9688,-1529.9100,22.7421, "Pusat Properti cabang LS Mall\n"GREEN"Hubungi disini.", 1.0);
}