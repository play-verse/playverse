loadAllActor(){
    /***************************************************************************
        PASTIKAN UNTUK MEN-SPAWN ACTOR DIATAS OBJECT YANG BUKAN DYNAMIC OBJECT
        AGAR ACTOR TIDAK JATUH KEBAWAH.
    *****************************************************************************/

    // Toko Peralatan Pancing
    CreateDynamicActor(65, 1021.7375,-1892.3024,12.7341,264.4317);
    // Toko Bibit
    CreateDynamicActor(130, 1494.2061,-1659.1025,13.2922,358.1933);

    // Actor di pusat keahlian
    CreateDynamic3DTextLabel("Ahli Mekanik\n"YELLOW"Ketik /bicara untuk berbicara.", COLOR_WHITE, ACT_skillMekanik_Pos[0], ACT_skillMekanik_Pos[1], ACT_skillMekanik_Pos[2] + 1.0, 10.0, .testlos = 1);
    ACT_skillMekanik = CreateDynamicActor(50, ACT_skillMekanik_Pos[0], ACT_skillMekanik_Pos[1], ACT_skillMekanik_Pos[2], ACT_skillMekanik_Pos[3], .worldid = 1, .interiorid = 18);

    // Actor di pusat pemerintahan
    CreateDynamicActor(76, -500.8233, 296.5014, 2001.0950, 170.3979, .worldid = 1, .interiorid = 1);
}