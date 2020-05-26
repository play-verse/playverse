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

    PU_bankLS[ENTER_PICKUP] = buatPickupDanLabel(1318, 1464.5782,-1009.9889,26.8438, "Bank Los Santos\n"GREEN"Pintu Masuk");
    PU_bankLS[EXIT_PICKUP] = buatPickupDanLabel(1318, 1417.0054,-979.5762,-55.2764, "Bank Los Santos\n"GREEN"Pintu Keluar");
}