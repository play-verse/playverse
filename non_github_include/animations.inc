CMD:animlist(playerid, params[]){
    new str_guide[2000];
    format(str_guide, sizeof(str_guide), \
    WHITE"/dance[1-4], /strip[1-7], /sexy[1-8], /bj[1-4], /gsign[1-5], /celebrate[1-2], /win[1-2], /injured[1-2]\n"\
    "/deal[1-2], /invite[1-2], /crossarms[1-3], /lay[1-2], /gang[1-7], /bed[1-4], /carsit[1-2], /aim[1-2], /cry[1-2]\n"\
    "/crack[1-2], /bat[1-5], /kiss[1-7], /basket[1-6], /bar[1-4], /die[1-2], /ghand[1-5], /rap[1-3], /gwalk[1-2]\n"\
    "/handsup, /wankoff, /wank, /cellin, /cellout, /lean, /piss, /follow, /greet, /hitch, /bitchslap, /cpr, /gift\n"\
    "/chairsit, /slapped, /slapass, /drunk, /mwalk, /fwalk, /yes, /thankyou, /scratch, /bomb, /getarrested\n"\
    "/relax, /nod, /laugh, /lookout, /robman, /cover, /vomit, /eat, /smokem, /smokef, /msit, /fsit, /chat, /fucku\n"\
    "/taichi, /chant, /carsmoke, /stretch, /angry, /exhausted, /fkick, /box, /cockgun, /liftup, /putdown, /joint\n"\
    "/benddown, /checkout, /wave\n\n"\
    YELLOW"Spesial Animation\n"\
    WHITE"/sit, /stand, /sleep, /getup\n\n"\
    RED"Stop Animation\n"\
    WHITE"/clearanim");
    ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Animation List:", str_guide, "Ok", "");
    return 1;
}
CMD:dance(playerid, params[])  return SetPlayerSpecialActionEx(playerid, SPECIAL_ACTION_DANCE1);
CMD:dance2(playerid, params[])  return SetPlayerSpecialActionEx(playerid, SPECIAL_ACTION_DANCE2);
CMD:dance3(playerid, params[])  return SetPlayerSpecialActionEx(playerid, SPECIAL_ACTION_DANCE3);
CMD:dance4(playerid, params[])  return SetPlayerSpecialActionEx(playerid, SPECIAL_ACTION_DANCE4);

CMD:rap(playerid, params[])  return ApplyAnimationEx(playerid, "RAPPING", "RAP_A_Loop", 4.0, 1, 1, 1, 1, 0);
CMD:rap2(playerid, params[])  return ApplyAnimationEx(playerid, "RAPPING", "RAP_B_Loop", 4.0, 1, 1, 1, 1, 0);
CMD:rap3(playerid, params[])  return ApplyAnimationEx(playerid, "RAPPING", "RAP_C_Loop", 4.0, 1, 1, 1, 1, 0);

CMD:strip(playerid, params[])  return ApplyAnimationEx(playerid, "STRIP", "strip_A", 4.0, 1, 1, 1, 1, 0);
CMD:strip2(playerid, params[])  return ApplyAnimationEx(playerid, "STRIP", "strip_B", 4.0, 1, 1, 1, 1, 0);
CMD:strip3(playerid, params[])  return ApplyAnimationEx(playerid, "STRIP", "strip_C", 4.0, 1, 1, 1, 1, 0);
CMD:strip4(playerid, params[])  return ApplyAnimationEx(playerid, "STRIP", "strip_D", 4.0, 1, 1, 1, 1, 0);
CMD:strip5(playerid, params[])  return ApplyAnimationEx(playerid, "STRIP", "strip_E", 4.0, 1, 1, 1, 1, 0);
CMD:strip6(playerid, params[])  return ApplyAnimationEx(playerid, "STRIP", "strip_F", 4.0, 1, 1, 1, 1, 0);
CMD:strip7(playerid, params[])  return ApplyAnimationEx(playerid, "STRIP", "strip_G", 4.0, 1, 1, 1, 1, 0);

CMD:sexy(playerid, params[])  return ApplyAnimationEx(playerid, "SNM", "SPANKING_IDLEW", 4.1, 0, 1, 1, 1, 1);
CMD:sexy2(playerid, params[])  return ApplyAnimationEx(playerid, "SNM", "SPANKING_IDLEP", 4.1, 0, 1, 1, 1, 1);
CMD:sexy3(playerid, params[])  return ApplyAnimationEx(playerid, "SNM", "SPANKINGW", 4.1, 0, 1, 1, 1, 1);
CMD:sexy4(playerid, params[])  return ApplyAnimationEx(playerid, "SNM", "SPANKINGP", 4.1, 0, 1, 1, 1, 1);
CMD:sexy5(playerid, params[])  return ApplyAnimationEx(playerid, "SNM", "SPANKEDW", 4.1, 0, 1, 1, 1, 1);
CMD:sexy6(playerid, params[])  return ApplyAnimationEx(playerid, "SNM", "SPANKEDP", 4.1, 0, 1, 1, 1, 1);
CMD:sexy7(playerid, params[])  return ApplyAnimationEx(playerid, "SNM", "SPANKING_ENDW", 4.1, 0, 1, 1, 1, 1);
CMD:sexy8(playerid, params[])  return ApplyAnimationEx(playerid, "SNM", "SPANKING_ENDP", 4.1, 0, 1, 1, 1, 1);

CMD:bj(playerid, params[])  return ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_START_P", 4.1, 0, 1, 1, 1, 1);
CMD:bj2(playerid, params[])  return ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_START_W", 4.1, 0, 1, 1, 1, 1);
CMD:bj3(playerid, params[])  return ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 0, 1, 1, 1, 1);
CMD:bj4(playerid, params[])  return ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 0, 1, 1, 1, 1);

CMD:wankoff(playerid, params[])  return ApplyAnimationEx(playerid, "PAULNMAC", "wank_in", 4.0, 1, 1, 1, 1, 0);
CMD:wank(playerid, params[])  return ApplyAnimationEx(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 1, 1, 1, 0);

CMD:gsign(playerid, params[])  return ApplyAnimationEx(playerid, "GHANDS", "gsign1", 4.0, 0, 1, 1, 1, 1);
CMD:gsign2(playerid, params[])  return ApplyAnimationEx(playerid, "GHANDS", "gsign2", 4.0, 0, 1, 1, 1, 1);
CMD:gsign3(playerid, params[])  return ApplyAnimationEx(playerid, "GHANDS", "gsign3", 4.0, 0, 1, 1, 1, 1);
CMD:gsign4(playerid, params[])  return ApplyAnimationEx(playerid, "GHANDS", "gsign4", 4.0, 0, 1, 1, 1, 1);
CMD:gsign5(playerid, params[])  return ApplyAnimationEx(playerid, "GHANDS", "gsign5", 4.0, 0, 1, 1, 1, 1);

CMD:bat(playerid, params[])  return ApplyAnimationEx(playerid, "BASEBALL", "Bat_IDLE", 4.0, 1, 0, 0, 0, 0);
CMD:bat2(playerid, params[])  return ApplyAnimationEx(playerid, "BASEBALL", "Bat_M", 4.0, 1, 0, 0, 0, 0);
CMD:bat3(playerid, params[])  return ApplyAnimationEx(playerid, "BASEBALL", "BAT_PART", 4.0, 1, 0, 0, 0, 0);
CMD:bat4(playerid, params[])  return ApplyAnimationEx(playerid, "CRACK", "Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0);
CMD:bat5(playerid, params[])  return ApplyAnimationEx(playerid, "CRACK", "Bbalbat_Idle_02", 4.0, 1, 0, 0, 0, 0);

CMD:gang(playerid, params[])  return ApplyAnimationEx(playerid, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0);
CMD:gang2(playerid, params[])  return ApplyAnimationEx(playerid, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0);
CMD:gang3(playerid, params[])  return ApplyAnimationEx(playerid, "GANGS", "hndshkca", 4.0, 0, 0, 0, 0, 0);
CMD:gang4(playerid, params[])  return ApplyAnimationEx(playerid, "GANGS", "hndshkcb", 4.0, 0, 0, 0, 0, 0);
CMD:gang5(playerid, params[])  return ApplyAnimationEx(playerid, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0);
CMD:gang6(playerid, params[])  return ApplyAnimationEx(playerid, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0);
CMD:gang7(playerid, params[])  return ApplyAnimationEx(playerid, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0);

CMD:kiss(playerid, params[])  return ApplyAnimationEx(playerid, "BD_FIRE", "Grlfrd_Kiss_03", 4.0, 0, 0, 0, 0, 0);
CMD:kiss2(playerid, params[])  return ApplyAnimationEx(playerid, "KISSING", "Grlfrd_Kiss_01", 4.0, 0, 0, 0, 0, 0);
CMD:kiss3(playerid, params[])  return ApplyAnimationEx(playerid, "KISSING", "Grlfrd_Kiss_02", 4.0, 0, 0, 0, 0, 0);
CMD:kiss4(playerid, params[])  return ApplyAnimationEx(playerid, "KISSING", "Grlfrd_Kiss_03", 4.0, 0, 0, 0, 0, 0);
CMD:kiss5(playerid, params[])  return ApplyAnimationEx(playerid, "KISSING", "Playa_Kiss_01", 4.0, 0, 0, 0, 0, 0);
CMD:kiss6(playerid, params[])  return ApplyAnimationEx(playerid, "KISSING", "Playa_Kiss_02", 4.0, 0, 0, 0, 0, 0);
CMD:kiss7(playerid, params[])  return ApplyAnimationEx(playerid, "KISSING", "Playa_Kiss_03", 4.0, 0, 0, 0, 0, 0);

CMD:ghand(playerid, params[])  return ApplyAnimationEx(playerid, "GHANDS", "gsign1LH", 4.0, 0, 1, 1, 1, 1);
CMD:ghand2(playerid, params[])  return ApplyAnimationEx(playerid, "GHANDS", "gsign2LH", 4.0, 0, 1, 1, 1, 1);
CMD:ghand3(playerid, params[])  return ApplyAnimationEx(playerid, "GHANDS", "gsign3LH", 4.0, 0, 1, 1, 1, 1);
CMD:ghand4(playerid, params[])  return ApplyAnimationEx(playerid, "GHANDS", "gsign4LH", 4.0, 0, 1, 1, 1, 1);
CMD:ghand5(playerid, params[])  return ApplyAnimationEx(playerid, "GHANDS", "gsign5LH", 4.0, 0, 1, 1, 1, 1);

CMD:basket(playerid, params[])  return ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_def_loop", 4.0, 1, 0, 0, 0, 0);
CMD:basket2(playerid, params[])  return ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_idleloop", 4.0, 1, 0, 0, 0, 0);
CMD:basket3(playerid, params[])  return ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_pickup", 4.0, 0, 0, 0, 0, 0);
CMD:basket4(playerid, params[])  return ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_Jump_Shot", 4.0, 0, 0, 0, 0, 0);
CMD:basket5(playerid, params[])  return ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_Dnk", 4.1, 0, 1, 1, 1, 1);
CMD:basket6(playerid, params[])  return ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_run", 4.1, 1, 1, 1, 1, 1);

CMD:bed(playerid, params[])  return ApplyAnimationEx(playerid, "INT_HOUSE", "BED_In_L", 4.1, 0, 1, 1, 1, 1);
CMD:bed2(playerid, params[])  return ApplyAnimationEx(playerid, "INT_HOUSE", "BED_In_R", 4.1, 0, 1, 1, 1, 1);
CMD:bed3(playerid, params[])  return ApplyAnimationEx(playerid, "INT_HOUSE", "BED_Loop_L", 4.0, 1, 0, 0, 0, 0);
CMD:bed4(playerid, params[])  return ApplyAnimationEx(playerid, "INT_HOUSE", "BED_Loop_R", 4.0, 1, 0, 0, 0, 0);

CMD:bar(playerid, params[])  return ApplyAnimationEx(playerid, "BAR", "Barcustom_get", 3.0, 0, 0, 0, 0, 0);
CMD:bar2(playerid, params[])  return ApplyAnimationEx(playerid, "BAR", "Barcustom_order", 3.0, 0, 0, 0, 0, 0);
CMD:bar3(playerid, params[])  return ApplyAnimationEx(playerid, "BAR", "Barserve_give", 3.0, 0, 0, 0, 0, 0);
CMD:bar4(playerid, params[])  return ApplyAnimationEx(playerid, "BAR", "Barserve_glass", 3.0, 0, 0, 0, 0, 0);

CMD:gwalk(playerid, params[])   return ApplyAnimationEx(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1);
CMD:gwalk2(playerid, params[])  return ApplyAnimationEx(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1);

CMD:injured(playerid, params[])   return ApplyAnimationEx(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
CMD:injured2(playerid, params[])  return ApplyAnimationEx(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);

CMD:deal(playerid, params[])   return ApplyAnimationEx(playerid, "DEALER", "DEALER_DEAL", 3.0, 0, 0, 0, 0, 0);
CMD:deal2(playerid, params[])  return ApplyAnimationEx(playerid, "DEALER", "DRUGS_BUY", 4.0, 1, 0, 0, 0, 0);

CMD:win(playerid, params[])  return ApplyAnimationEx(playerid, "CASINO", "cards_win", 4.0, 1, 0, 0, 0, 0);
CMD:win2(playerid, params[])  return ApplyAnimationEx(playerid, "CASINO", "Roulette_win", 4.0, 1, 0, 0, 0, 0);

CMD:invite(playerid, params[])  return ApplyAnimationEx(playerid, "GANGS", "Invite_Yes", 4.1, 0, 1, 1, 1, 1);
CMD:invite2(playerid, params[])  return ApplyAnimationEx(playerid, "GANGS", "Invite_No", 4.1, 0, 1, 1, 1, 1);

CMD:celebrate(playerid, params[])  return ApplyAnimationEx(playerid, "benchpress", "gym_bp_celebrate", 4.0, 1, 0, 0, 0, 0);
CMD:celebrate2(playerid, params[])  return ApplyAnimationEx(playerid, "GYMNASIUM", "gym_tread_celebrate", 4.0, 1, 0, 0, 0, 0);

CMD:crossarms(playerid, params[])  return ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
CMD:crossarms2(playerid, params[])  return ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE", 4.0, 0, 1, 1, 1, -1);
CMD:crossarms3(playerid, params[])  return ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_01", 4.0, 0, 1, 1, 1, -1);

CMD:cry(playerid, params[])  return ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.0, 1, 0, 0, 0, 0);
CMD:cry2(playerid, params[])  return ApplyAnimationEx(playerid, "GRAVEYARD", "mrnM_loop", 4.0, 1, 0, 0, 0, 0);

CMD:carsit(playerid, params[])  return ApplyAnimationEx(playerid, "CAR", "Tap_hand", 4.0, 1, 0, 0, 0, 0);
CMD:carsit2(playerid, params[])  return ApplyAnimationEx(playerid, "LOWRIDER", "Sit_relaxed", 4.0, 1, 0, 0, 0, 0);

CMD:crack(playerid, params[])   return ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
CMD:crack2(playerid, params[])  return ApplyAnimationEx(playerid, "CRACK", "crckidle2", 4.0, 1, 0, 0, 0, 0);

CMD:lay(playerid, params[])  return ApplyAnimationEx(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
CMD:lay2(playerid, params[])  return ApplyAnimationEx(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0);

CMD:die(playerid, params[])  return ApplyAnimationEx(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, 0, 1, 1, 1, 1);
CMD:die2(playerid, params[])  return ApplyAnimationEx(playerid, "PARACHUTE", "FALL_skyDive_DIE", 4.0, 0, 1, 1, 1, -1);

CMD:aim(playerid, params[])  return ApplyAnimationEx(playerid, "PED", "gang_gunstand", 4.0, 1, 0, 0, 0, 0);
CMD:aim2(playerid, params[])  return ApplyAnimationEx(playerid, "SHOP", "SHP_Gun_Aim", 4.0, 0, 1, 1, 1, -1);

CMD:handsup(playerid, params[])  return SetPlayerSpecialActionEx(playerid, SPECIAL_ACTION_HANDSUP);
CMD:cellin(playerid, params[])  return SetPlayerSpecialActionEx(playerid, SPECIAL_ACTION_USECELLPHONE);
CMD:cellout(playerid, params[]) return SetPlayerSpecialActionEx(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
CMD:lean(playerid, params[])  return ApplyAnimationEx(playerid, "GANGS", "leanIDLE", 4.0, 1, 0, 0, 0, 0);
CMD:piss(playerid, params[])    return SetPlayerSpecialActionEx(playerid, 68);
CMD:follow(playerid, params[])  return ApplyAnimationEx(playerid, "WUZI", "Wuzi_follow", 4.0, 0, 0, 0, 0, 0);
CMD:greet(playerid, params[])  return ApplyAnimationEx(playerid, "WUZI", "Wuzi_Greet_Wuzi", 4.0, 0, 0, 0, 0, 0);
//CMD:stand(playerid, params[])  return ApplyAnimationEx(playerid, "WUZI", "Wuzi_stand_loop", 4.0, 1, 0, 0, 0, 0);
CMD:hitch(playerid, params[])  return ApplyAnimationEx(playerid, "MISC", "Hiker_Pose", 4.0, 1, 0, 0, 0, 0);
CMD:bitchslap(playerid, params[])  return ApplyAnimationEx(playerid, "MISC", "bitchslap", 4.0, 0, 0, 0, 0, 0);
CMD:cpr(playerid, params[])  return ApplyAnimationEx(playerid, "MEDIC", "CPR", 4.0, 1, 0, 0, 0, 0);
CMD:gift(playerid, params[])  return ApplyAnimationEx(playerid, "KISSING", "gift_give", 4.0, 0, 0, 0, 0, 0);
CMD:chairsit(playerid, params[])  return ApplyAnimationEx(playerid, "PED", "SEAT_idle", 4.0, 1, 0, 0, 0, 0);
CMD:slapped(playerid, params[])  return ApplyAnimationEx(playerid, "SWEET", "ho_ass_slapped", 4.0, 0, 0, 0, 0, 0);
CMD:slapass(playerid, params[])  return ApplyAnimationEx(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0);
CMD:drunk(playerid, params[])  return ApplyAnimationEx(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1);
CMD:skate(playerid, params[])  return ApplyAnimationEx(playerid, "SKATE", "skate_run", 4.1, 1, 1, 1, 1, 1);
CMD:limp(playerid, params[])  return ApplyAnimationEx(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1);
CMD:eatsit(playerid, params[])  return ApplyAnimationEx(playerid, "FOOD", "FF_Sit_Loop", 4.0, 1, 0, 0, 0, 0);
CMD:yes(playerid, params[])  return ApplyAnimationEx(playerid, "CLOTHES", "CLO_Buy", 4.0, 1, 0, 0, 0, 0);
CMD:thankyou(playerid, params[])  return ApplyAnimationEx(playerid, "FOOD", "SHP_Thank", 4.0, 1, 0, 0, 0, 0);
//CMD:sit(playerid, params[])  return ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Type_Loop", 4.0, 1, 0, 0, 0, 0);
CMD:scratch(playerid, params[])  return ApplyAnimationEx(playerid, "MISC", "Scratchballs_01", 4.0, 1, 0, 0, 0, 0);
CMD:bomb(playerid, params[])  return ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
CMD:getarrested(playerid, params[])  return ApplyAnimationEx(playerid, "ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1);
CMD:laugh(playerid, params[])  return ApplyAnimationEx(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);
CMD:lookout(playerid, params[])  return ApplyAnimationEx(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
CMD:robman(playerid, params[])  return ApplyAnimationEx(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
CMD:vomit(playerid, params[])  return ApplyAnimationEx(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
CMD:eat(playerid, params[])   return ApplyAnimationEx(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
//CMD:wave(playerid, params[])   return ApplyAnimationEx(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0);
CMD:smokem(playerid, params[])   return ApplyAnimationEx(playerid, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
CMD:smokef(playerid, params[])   return ApplyAnimationEx(playerid, "SMOKING", "F_smklean_loop", 4.0, 1, 0, 0, 0, 0);
CMD:msit(playerid, params[])   return ApplyAnimationEx(playerid, "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
CMD:fsit(playerid, params[])   return ApplyAnimationEx(playerid, "BEACH", "ParkSit_W_loop", 4.0, 1, 0, 0, 0, 0);
CMD:chat(playerid, params[])   return ApplyAnimationEx(playerid, "PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
CMD:fucku(playerid, params[])  return ApplyAnimationEx(playerid, "PED", "fucku", 4.0, 0, 0, 0, 0, 0);
CMD:taichi(playerid, params[])  return ApplyAnimationEx(playerid, "PARK", "Tai_Chi_Loop", 4.0, 1, 0, 0, 0, 0);
//CMD:chairsit(playerid, params[])  return ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0);
CMD:relax(playerid, params[])  return ApplyAnimationEx(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
CMD:nod(playerid, params[])  return ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_nod", 4.0, 0, 0, 0, 0, 0);
CMD:fwalk(playerid, params[])  return ApplyAnimationEx(playerid, "ped", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1);
CMD:mwalk(playerid, params[])  return ApplyAnimationEx(playerid, "ped", "WALK_player", 4.1, 1, 1, 1, 1, 1);
CMD:stretch(playerid, params[])  return ApplyAnimationEx(playerid, "PLAYIDLES", "stretch", 4.0, 0, 0, 0, 0, 0);
CMD:chant(playerid, params[])  return ApplyAnimationEx(playerid, "RIOT", "RIOT_CHANT", 4.0, 1, 0, 0, 0, 0);
CMD:angry(playerid, params[])  return ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY", 4.0, 0, 0, 0, 0, 0);
CMD:exhausted(playerid, params[])  return ApplyAnimationEx(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
CMD:carsmoke(playerid, params[])  return ApplyAnimationEx(playerid, "PED", "Smoke_in_car", 4.0, 1, 0, 0, 0, 0);
//CMD:getup(playerid, params[])  return ApplyAnimationEx(playerid, "PED", "getup", 4.0, 0, 0, 0, 0, 0);
CMD:fkick(playerid, params[])  return ApplyAnimationEx(playerid, "FIGHT_E", "FightKick", 4.0, 0, 0, 0, 0, 0);
CMD:box(playerid, params[])  return ApplyAnimationEx(playerid, "GYMNASIUM", "gym_shadowbox", 4.1, 1, 1, 1, 1, 1);
CMD:cockgun(playerid, params[])  return ApplyAnimationEx(playerid, "SILENCED", "Silence_reload", 3.0, 0, 0, 0, 0, 0);
CMD:liftup(playerid, params[])  return ApplyAnimationEx(playerid, "CARRY", "liftup", 3.0, 0, 0, 0, 0, 0);
CMD:putdown(playerid, params[])  return ApplyAnimationEx(playerid, "CARRY", "putdwn", 3.0, 0, 0, 0, 0, 0);
CMD:joint(playerid, params[])  return ApplyAnimationEx(playerid, "GANGS", "smkcig_prtl", 4.0, 0, 1, 1, 1, 1);
CMD:shakehead(playerid, params[])  return ApplyAnimationEx(playerid, "MISC", "plyr_shkhead", 3.0, 0, 0, 0, 0, 0);
CMD:benddown(playerid, params[])  return ApplyAnimationEx(playerid, "BAR", "Barserve_bottle", 4.0, 0, 0, 0, 0, 0);
CMD:checkout(playerid, params[])  return ApplyAnimationEx(playerid, "GRAFFITI", "graffiti_Chkout", 4.0, 0, 0, 0, 0, 0);