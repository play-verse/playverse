loadAllPickup(){
    PU_tempatFoto_in[0] = buatPickupDanLabel(1318, 1111.9841, -1370.0327, 13.9844, "Tempat Cetak foto "nama_A"\n"GREEN"Pintu Masuk");
    PU_tempatFoto_in[1] = buatPickupDanLabel(1318, 1553.9622,-1450.5079,13.5469, "Tempat Cetak foto "nama_B"\n"GREEN"Pintu Masuk");
    PU_tempatFoto_out = buatPickupDanLabel(1318, -204.3725, -27.3480, 1002.2734, "Tempat Cetak foto\n"GREEN"Pintu Keluar");

    // minimarket yang ada mappingan
    PU_miniMarket[0][ENTER_PICKUP] = buatPickupDanLabel(1318, 1352.3239, -1759.2528, 13.5078, "Minimarket "nama_A"\n"GREEN"Pintu Masuk");
    PU_miniMarket[0][EXIT_PICKUP] = buatPickupDanLabel(1318, -25.8201, -188.2510, 1003.5469, "Minimarket "nama_A"\n"GREEN"Pintu Keluar");

    PU_tempatBaju[0][ENTER_PICKUP] = buatPickupDanLabel(1318, 499.5623, -1360.6381, 16.3685, "Tempat baju "nama_A"\n"GREEN"Pintu Masuk");
    PU_tempatBaju[0][EXIT_PICKUP] = buatPickupDanLabel(1318, 161.3459,-97.1099,1001.8047, "Tempat baju "nama_A"\n"GREEN"Pintu Keluar");

    // City Hall
    PU_cityHallMasuk[0] = buatPickupDanLabel(1318, 1479.5580,-1786.4991,15.4566, "Kantor Pemerintah Los Santos\n"GREEN"Pintu Masuk");
    PU_cityHallMasuk[1] = buatPickupDanLabel(1318, 1486.2665,-1786.4990,15.4566, "Kantor Pemerintah Los Santos\n"GREEN"Pintu Masuk");
    PU_cityHallMasuk[2] = buatPickupDanLabel(1318, 1472.9707,-1786.4982,15.4566, "Kantor Pemerintah Los Santos\n"GREEN"Pintu Masuk");

    PU_cityHallKeluar = buatPickupDanLabel(1318, -501.1548,286.2194,2001.0950, "Kantor Pemerintah Los Santos\n"GREEN"Pintu Keluar");

    PU_bankLS[ENTER_PICKUP][0] = buatPickupDanLabel(1318, 1464.5782,-1009.9889,26.8438, "Bank Los Santos\n"GREEN"Pintu Masuk");
    PU_bankLS[EXIT_PICKUP][0] = buatPickupDanLabel(1318, 1402.3160, -37.6471, 1000.8950, "Bank Los Santos\n"GREEN"Pintu Keluar "nama_A);
    PU_bankLS[EXIT_PICKUP][1] = buatPickupDanLabel(1318, 1402.5073, -36.1273, 1000.8950, "Bank Los Santos\n"GREEN"Pintu Keluar "nama_B);

    // Tempat Makan
    PU_tempatMakan_in[0] = buatPickupDanLabel(1318, 928.9155,-1352.9557,13.3438, "Restoran Makanan "nama_A"\n"GREEN"Pintu Masuk");
    PU_tempatMakan_in[1] = buatPickupDanLabel(1318, 810.4855,-1616.1713,13.5469, "Restoran Makanan "nama_B"\n"GREEN"Pintu Masuk");
    PU_tempatMakan_out = buatPickupDanLabel(1318, 364.9624,-11.8307,1001.8516, "Restoran Makanan\n"GREEN"Pintu Keluar");

    // Police Dept
    PU_policeDept_in[0] = buatPickupDanLabel(1318, 1555.4991,-1675.5791,16.1953, "Polisi Metro Los Santos\n"GREEN"Pintu Masuk");
    PU_policeDept_out[0] = buatPickupDanLabel(1318, 246.8544,62.3242,1003.6406, "Polisi Metro Los Santos\n"GREEN"Pintu Keluar");

    // Marketplace
    PU_marketPlace[ENTER_PICKUP] = buatPickupDanLabel(1318, 1477.3682, -1638.5536, 14.1786, "Marketplace\n"GREEN"Pintu Masuk");
    PU_marketPlace[EXIT_PICKUP] = buatPickupDanLabel(1318, -2635.8884, 1402.4646, 906.4609, "Marketplace\n"GREEN"Pintu Keluar");

    // Lumberjack
    new tempLabel[128];
    for(new i = 0; i < sizeof(POSISI_PEMOTONGAN_KAYU); i++){
        format(tempLabel, 128, "Lumberjack "ORANGE"%s\n"GREEN"Tempat Pemotongan Kayu #%d", GetZoneName(POSISI_PEMOTONGAN_KAYU[i][POSISI_X], POSISI_PEMOTONGAN_KAYU[i][POSISI_Y], POSISI_PEMOTONGAN_KAYU[i][POSISI_Z]), i + 1);
        buatPickupDanLabel(1239, POSISI_PEMOTONGAN_KAYU[i][POSISI_X], POSISI_PEMOTONGAN_KAYU[i][POSISI_Y], POSISI_PEMOTONGAN_KAYU[i][POSISI_Z], tempLabel);
    }

    // Rumah Sakit
    PU_rumahSakit[0] = buatPickupDanLabel(1318, 1172.2648, -1323.4558, 15.4032, "Rumah Sakit Los Santos\n"GREEN"Pintu Masuk");

    // Toko Gadget
    PU_tokoGadget[0][ENTER_PICKUP] = buatPickupDanLabel(1318, 1097.6610, -1370.0361, 13.9844, "Toko Gadget "nama_A"\n"GREEN"Pintu Masuk");
    PU_tokoGadget[0][EXIT_PICKUP] = buatPickupDanLabel(1318, 438.7690, 1243.2151, 1081.9045, "Toko Gadget "nama_A"\n"GREEN"Pintu Keluar");

    PU_tambangBesi[ENTER_PICKUP] = buatPickupDanLabel(1318, -685.2260, 2372.3379, 129.8383, "Pusat Tambang\n"GREEN"Pintu Masuk");
    PU_tambangBesi[EXIT_PICKUP] = buatPickupDanLabel(1318, 2395.7302, -1506.7921, 1402.2000, "Pusat Tambang\n"GREEN"Pintu Keluar");

    // Blacksmith (pandai besi)
    PU_tempatBlacksmith[ENTER_PICKUP] = buatPickupDanLabel(1318, 1720.2994, -1741.1611, 13.5469, "Pusat Blacksmith\n"GREEN"Pintu Masuk");
    PU_tempatBlacksmith[EXIT_PICKUP] = buatPickupDanLabel(1318, 699.4554, -445.3720, -25.6097, "Pusat Blacksmith\n"GREEN"Pintu Keluar");
}