loadAllActor(){
    // Actor di toko peraltan pancing
    CreateDynamic3DTextLabel("Penjual Peralatan Pancing\n"YELLOW"Ketik /bicara untuk berbicara.", COLOR_WHITE, ACT_peralatanPancing_Pos[0], ACT_peralatanPancing_Pos[1], ACT_peralatanPancing_Pos[2] + 1.0, 10.0, .testlos = 1);
    ACT_peralatanPancing = CreateDynamicActor(65, ACT_peralatanPancing_Pos[0], ACT_peralatanPancing_Pos[1], ACT_peralatanPancing_Pos[2], ACT_peralatanPancing_Pos[3], .worldid = 0, .interiorid = 0);

    // Actor di toko bibit
    CreateDynamic3DTextLabel("Penjual Bibit\n"YELLOW"Ketik /bicara untuk berbicara.", COLOR_WHITE, ACT_tokoBibit_Pos[0], ACT_tokoBibit_Pos[1], ACT_tokoBibit_Pos[2] + 1.0, 10.0, .testlos = 1);
    ACT_tokoBibit = CreateDynamicActor(130, ACT_tokoBibit_Pos[0], ACT_tokoBibit_Pos[1], ACT_tokoBibit_Pos[2], ACT_tokoBibit_Pos[3], .worldid = 0, .interiorid = 0);

    // Actor di pusat keahlian
    CreateDynamic3DTextLabel("Ahli Mekanik\n"YELLOW"Ketik /bicara untuk berbicara.", COLOR_WHITE, ACT_skillMekanik_Pos[0], ACT_skillMekanik_Pos[1], ACT_skillMekanik_Pos[2] + 1.0, 10.0, .testlos = 1);
    ACT_skillMekanik = CreateDynamicActor(50, ACT_skillMekanik_Pos[0], ACT_skillMekanik_Pos[1], ACT_skillMekanik_Pos[2], ACT_skillMekanik_Pos[3], .worldid = 0, .interiorid = 0);

    // Actor di dealer
    CreateDynamic3DTextLabel("Manager Dealer\n"YELLOW"Ketik /bicara untuk berbicara.", COLOR_LIGHT_BLUE, ACT_penjualDealer_Pos[0], ACT_penjualDealer_Pos[1], ACT_penjualDealer_Pos[2] + 1.0, 10.0, .testlos = 1);
    ACT_penjualDealer = CreateDynamicActor(17, ACT_penjualDealer_Pos[0], ACT_penjualDealer_Pos[1], ACT_penjualDealer_Pos[2], ACT_penjualDealer_Pos[3], .worldid = 0, .interiorid = 0);

    // Actor di pusat pemerintahan
    ACT_resepsionisPemerintah = CreateDynamicActor(76, ACT_resepsionisPemerintah_Pos[0], ACT_resepsionisPemerintah_Pos[1], ACT_resepsionisPemerintah_Pos[2], ACT_resepsionisPemerintah_Pos[3], .worldid = 1, .interiorid = 1);
    // Bubble Chat Actor
    ACT_resepsionisPemerintah_Text = CreateDynamic3DTextLabel("", COLOR_WHITE, ACT_resepsionisPemerintah_Pos[0], ACT_resepsionisPemerintah_Pos[1], ACT_resepsionisPemerintah_Pos[2] + 1.25, 10.0, .testlos = 1);

    // Actor di toko gadget
    CreateDynamic3DTextLabel("Penjual Gadget\n"YELLOW"Ketik /bicara untuk berbicara.", COLOR_WHITE, ACT_tokoGadget_Pos[0], ACT_tokoGadget_Pos[1], ACT_tokoGadget_Pos[2] + 1.0, 10.0, .testlos = 1);
    ACT_tokoGadget = CreateDynamicActor(141, ACT_tokoGadget_Pos[0], ACT_tokoGadget_Pos[1], ACT_tokoGadget_Pos[2], ACT_tokoGadget_Pos[3], .worldid = 1, .interiorid = 1);
}

re_loadAllActor(){
    if(ACT__reload == 1){
        // Hapus actor
        if(IsValidDynamicActor(ACT_skillMekanik)) DestroyDynamicActor(ACT_skillMekanik);
        if(IsValidDynamicActor(ACT_penjualDealer)) DestroyDynamicActor(ACT_penjualDealer);
        if(IsValidDynamicActor(ACT_peralatanPancing)) DestroyDynamicActor(ACT_peralatanPancing);
        if(IsValidDynamicActor(ACT_tokoBibit)) DestroyDynamicActor(ACT_tokoBibit);
        if(IsValidDynamicActor(ACT_tokoNarko)) DestroyDynamicActor(ACT_tokoNarko);
        if(IsValidDynamicActor(ACT_tokoGadget)) DestroyDynamicActor(ACT_tokoGadget);
        if(IsValidDynamicActor(ACT_resepsionisPemerintah)) DestroyDynamicActor(ACT_resepsionisPemerintah);

        ACT__reload = 0;
        // Actor di toko peraltan pancing
        ACT_peralatanPancing = CreateDynamicActor(65, ACT_peralatanPancing_Pos[0], ACT_peralatanPancing_Pos[1], ACT_peralatanPancing_Pos[2], ACT_peralatanPancing_Pos[3], .worldid = 0, .interiorid = 0);

        // Actor di toko bibit
        ACT_tokoBibit = CreateDynamicActor(130, ACT_tokoBibit_Pos[0], ACT_tokoBibit_Pos[1], ACT_tokoBibit_Pos[2], ACT_tokoBibit_Pos[3], .worldid = 0, .interiorid = 0);

        //Actor di toko bibit narko
        ACT_tokoNarko = CreateDynamicActor(272, POINT_NARKO_ACTOR[MrPuyengRand][NARKO_X], POINT_NARKO_ACTOR[MrPuyengRand][NARKO_Y], POINT_NARKO_ACTOR[MrPuyengRand][NARKO_Z], POINT_NARKO_ACTOR[MrPuyengRand][NARKO_A], .worldid = 0, .interiorid = 0);

        // Actor di pusat keahlian
        ACT_skillMekanik = CreateDynamicActor(50, ACT_skillMekanik_Pos[0], ACT_skillMekanik_Pos[1], ACT_skillMekanik_Pos[2], ACT_skillMekanik_Pos[3], .worldid = 0, .interiorid = 0);

        // Actor di dealer
        ACT_penjualDealer = CreateDynamicActor(17, ACT_penjualDealer_Pos[0], ACT_penjualDealer_Pos[1], ACT_penjualDealer_Pos[2], ACT_penjualDealer_Pos[3], .worldid = 0, .interiorid = 0);

        // Actor di pusat pemerintahan
        ACT_resepsionisPemerintah = CreateDynamicActor(76, ACT_resepsionisPemerintah_Pos[0], ACT_resepsionisPemerintah_Pos[1], ACT_resepsionisPemerintah_Pos[2], ACT_resepsionisPemerintah_Pos[3], .worldid = 1, .interiorid = 1);

        // Actor di toko gadget
        ACT_tokoGadget = CreateDynamicActor(141, ACT_tokoGadget_Pos[0], ACT_tokoGadget_Pos[1], ACT_tokoGadget_Pos[2], ACT_tokoGadget_Pos[3], .worldid = 1, .interiorid = 1);
    }
}