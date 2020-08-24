loadAllArea(){
    // Keluar LS
    areaToll[0] = CreateDynamicCircle(56.4577, -1524.1259, 5.0);
    CreateDynamic3DTextLabel("Silahkan tekan "GREEN"Y "WHITE"untuk membayar toll.\n"YELLOW"Harga sekali lewat "GREEN"$2", COLOR_WHITE,56.4577,-1524.1259,4.7374, 20.0);

    // Masuk LS
    CreateDynamic3DTextLabel("Silahkan tekan "GREEN"Y "WHITE"untuk membayar toll.\n"YELLOW"Harga sekali lewat "GREEN"$2", COLOR_WHITE,51.5650,-1539.3867,4.8840, 20.0);
    areaToll[1] = CreateDynamicCircle(51.5650,-1539.3867, 5.0);

    // Masuk LS dari LV
    CreateDynamic3DTextLabel("Silahkan tekan "GREEN"Y "WHITE"untuk membayar toll.\n"YELLOW"Harga sekali lewat "GREEN"$2", COLOR_WHITE, 1743.1521, 556.5435, 25.5707, 20.0);
    areaToll_LSLV[0] = CreateDynamicCircle(1743.1521, 556.5435, 5.0);

    // Keluar LS ke LV
    CreateDynamic3DTextLabel("Silahkan tekan "GREEN"Y "WHITE"untuk membayar toll.\n"YELLOW"Harga sekali lewat "GREEN"$2", COLOR_WHITE,1755.4846, 551.4901, 25.6337, 20.0);
    areaToll_LSLV[1] = CreateDynamicCircle(1755.4846, 551.4901, 5.0);

    // Parkiran Pizzaboy LS
    CreateDynamic3DTextLabel("Silahkan tekan "GREEN"Y "WHITE"untuk membuka palang.", COLOR_WHITE, 2106.0315, -1827.5062, 12.5454, 20.0);
    pizza_PalangArea = CreateDynamicCircle(2106.0315, -1827.5062, 5.0);

    // Hint pada Kantor Pemerintah
    CreateDynamic3DTextLabel(\
        "Guide interaksi kantor pemerintah dan peraturan.\n\
        "WHITE"Silahkan tekan "GREEN"N "WHITE"untuk membaca guide.\n", COLOR_YELLOW, -486.3125, 294.6436, 2001.0859, 20.0);
    AREA_GuidePemerintah = CreateDynamicSphere(-486.3125, 294.6436, 2001.0859, 3.0);

    // Perabot
    foreach(new i : Range(0, sizeof(POSISI_BELI_PERABOT))){
        AREA_beliPerabot[i] = CreateDynamicSphere(POSISI_BELI_PERABOT[i][POSISI_X], POSISI_BELI_PERABOT[i][POSISI_Y], POSISI_BELI_PERABOT[i][POSISI_Z], 1.5, POSISI_BELI_PERABOT[i][POSISI_VW], POSISI_BELI_PERABOT[i][POSISI_INT]);
        CreateDynamic3DTextLabel("Silahkan tekan "GREEN"N "WHITE"untuk memilih perabot.\nPastikan anda menekan perabot yang dapat dibeli.", COLOR_WHITE, POSISI_BELI_PERABOT[i][POSISI_X], POSISI_BELI_PERABOT[i][POSISI_Y], POSISI_BELI_PERABOT[i][POSISI_Z], 8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, POSISI_BELI_PERABOT[i][POSISI_VW], POSISI_BELI_PERABOT[i][POSISI_INT]);
    }

    if(AREA_beliPerabot[0] + sizeof(POSISI_BELI_PERABOT) - 1 != AREA_beliPerabot[sizeof(POSISI_BELI_PERABOT) - 1]){
        printf("[ERROR] #05 Area beli perabot tidak memiliki ID yang simetris.");
        SendRconCommand("exit");
    }

    // Pom Bensin
    foreach(new i : Range(0, sizeof(POSISI_POM_BENSIN))){
        AREA_pomBensin[i] = CreateDynamicSphere(POSISI_POM_BENSIN[i][POSISI_X], POSISI_POM_BENSIN[i][POSISI_Y], POSISI_POM_BENSIN[i][POSISI_Z], 3.0, POSISI_POM_BENSIN[i][POSISI_VW], POSISI_POM_BENSIN[i][POSISI_INT]);
        CreateDynamicPickup(1650, 1,POSISI_POM_BENSIN[i][POSISI_X], POSISI_POM_BENSIN[i][POSISI_Y], POSISI_POM_BENSIN[i][POSISI_Z], 0, 0);
        CreateDynamic3DTextLabel("Silahkan tekan "GREEN"N "WHITE"untuk mengisi bensin.\n"YELLOW"Pastikan kendaraan anda berada didepan anda.", COLOR_WHITE, POSISI_POM_BENSIN[i][POSISI_X], POSISI_POM_BENSIN[i][POSISI_Y], POSISI_POM_BENSIN[i][POSISI_Z], 8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, POSISI_POM_BENSIN[i][POSISI_VW], POSISI_POM_BENSIN[i][POSISI_INT]);
    }

    if(AREA_pomBensin[0] + sizeof(POSISI_POM_BENSIN) - 1 != AREA_pomBensin[sizeof(POSISI_POM_BENSIN) - 1]){
        printf("[ERROR] #05 Area pom bensin tidak memiliki ID yang simetris.");
        SendRconCommand("exit");
    }

    // Pakai area karena pickup gak muncul
    AREA_keluarRumahSakit[0] = CreateDynamicSphere(159.4088, 1772.5681, 10000.0225, 1.5, 1, 1);
    CreateDynamic3DTextLabel("Rumah Sakit Los Santos\n"GREEN"Pintu Keluar", COLOR_WHITE, 159.4088, 1772.5681, 10000.0225, 5.0, .testlos = 1, .worldid = 1, .interiorid = 1, .streamdistance = 5.0);

    // Area untuk OnDuty/OffDuty Polisi
    AREA_onDutyPolisi = CreateDynamicSphere(257.0883, 77.1912, 1003.6406, 1.5);
    CreateDynamic3DTextLabel("Bekerja sebagai Polisi\n\
        "WHITE"Tekan "GREEN"N"WHITE" untuk mulai/selesai.", COLOR_LIGHT_BLUE, 257.0883, 77.1912, 1003.6406, 5.0, .testlos = 1);

    // Area untuk OnDuty/OffDuty Medic
    AREA_onDutyMedic = CreateDynamicSphere(175.8122, 1753.5443, 10003.3818, 1.5);
    CreateDynamic3DTextLabel("Bekerja sebagai Medic\n\
        "WHITE"Tekan "GREEN"N"WHITE" untuk mulai/selesai.", COLOR_PINK, 175.8122, 1753.5443, 10003.3818, 5.0, .testlos = 1);

    /**
        Actor Area 

        IMPORTANT: Jangan sampai areanya saling ngena atau dempet
     */
    ACT_resepsionisPemerintah_Area = CreateDynamicSphere(ACT_resepsionisPemerintah_Pos[0], ACT_resepsionisPemerintah_Pos[1], ACT_resepsionisPemerintah_Pos[2], 3.0);
}