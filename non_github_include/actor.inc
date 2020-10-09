loadAllActor(){
    for(new i = 0; i < sizeof(ACT_NPC); i++){
        ACT_NPC[i][actConst] = ACT_POSITION[i][ACT__Id];

        // Harus satu-satu tidak bisa sekali semua
        for(new j = 0; j < 4; j++)
            ACT_NPC[i][actPos][j] = ACT_POSITION[i][ACT__Pos][j];

        ACT_NPC[i][actID] = CreateDynamicActor(ACT_POSITION[i][ACT__Skin], ACT_NPC[i][actPos][0], ACT_NPC[i][actPos][1], ACT_NPC[i][actPos][2], ACT_NPC[i][actPos][3], .interiorid = ACT_POSITION[i][ACT__Int], .worldid = ACT_POSITION[i][ACT__Vw]);
        ACT_NPC[i][actText] = CreateDynamic3DTextLabel("", COLOR_WHITE, ACT_NPC[i][actPos][0], ACT_NPC[i][actPos][1], ACT_NPC[i][actPos][2] + 1.25, 10.0);
        ACT_NPC[i][actUser] = INVALID_PLAYER_ID;
        ACT_NPC[i][actRes] = 0;
        ACT_NPC[i][actTimer] = -1;
        ACT_NPC[i][actArea] = CreateDynamicSphere(ACT_NPC[i][actPos][0], ACT_NPC[i][actPos][1], ACT_NPC[i][actPos][2], 3.0);
    }
}

re_loadAllActor(){
    if(ACT__reload == 1){
        for(new i = 0; i < sizeof(ACT_NPC); i++){
            if(ACT_NPC[i][actConst] == ACTOR_PEMBELI_TAMBANG_1 && curr_weather_id == ID_WEATHER_RAIN) 
                continue;

            if(IsValidDynamicActor(ACT_NPC[i][actID]))
                DestroyDynamicActor(ACT_NPC[i][actID]);
            ACT_NPC[i][actID] = CreateDynamicActor(ACT_POSITION[i][ACT__Skin], ACT_NPC[i][actPos][0], ACT_NPC[i][actPos][1], ACT_NPC[i][actPos][2], ACT_NPC[i][actPos][3], .interiorid = ACT_POSITION[i][ACT__Int], .worldid = ACT_POSITION[i][ACT__Vw]);
        }
    }
}