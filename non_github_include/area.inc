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

    foreach(new i : Range(0, sizeof(POSISI_BELI_PERABOT))){
        AREA_beliPerabot[i] = CreateDynamicSphere(POSISI_BELI_PERABOT[i][POSISI_X], POSISI_BELI_PERABOT[i][POSISI_Y], POSISI_BELI_PERABOT[i][POSISI_Z], 1.5, POSISI_BELI_PERABOT[i][POSISI_VW], POSISI_BELI_PERABOT[i][POSISI_INT]);
        CreateDynamic3DTextLabel("Silahkan tekan "GREEN"N "WHITE"untuk memilih perabot.\nPastikan anda menekan perabot yang dapat dibeli.", COLOR_WHITE, POSISI_BELI_PERABOT[i][POSISI_X], POSISI_BELI_PERABOT[i][POSISI_Y], POSISI_BELI_PERABOT[i][POSISI_Z], 8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, POSISI_BELI_PERABOT[i][POSISI_VW], POSISI_BELI_PERABOT[i][POSISI_INT]);
    }

    if(AREA_beliPerabot[0] + sizeof(POSISI_BELI_PERABOT) - 1 != AREA_beliPerabot[sizeof(POSISI_BELI_PERABOT) - 1]){
        printf("[ERROR] #05 Area beli perabot tidak memiliki ID yang simetris.");
        SendRconCommand("exit");
    }
}