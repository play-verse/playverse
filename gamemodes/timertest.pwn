#include <a_samp>
#include <pengaturan> // Pengaturan server disini letak pas dibawah a_samp
#include <streamer>
#include <progress2>

#include <zcmd>
#include <colors> // https://forum.sa-mp.com/showthread.php?t=573049
#include <YSI_Data\y_iterate>
#include <a_mysql>
#include <sscanf2>
#include <global_variable> // variable disini
#include <dialog> // Function Dialog Loader
#include <fungsi> // Fungsi disini
#include <fungsi_tambahan> // Fungsi tambahan disini - Tambahan dulu baru fungsi



#include <core>
#include <float>
#include <PreviewModelDialog>
/*
	INCLUDE INCLUDE BUATAN DIBAWAH
*/
#include <../include/gl_common.inc>
#include <mapping> // Mappingan loader
#include <textdraw> // Textdraw Function Loader
#include <pickup> // Pickup Function Loader
#include <map_icon> // Map Icon Function Loader
#include <checkpoint> // CP Function Loader

#include <YSI_Coding\y_timers>
#include <YSI_Coding\y_inline>
forward OneSecTimer();

new lasttick = 0;

main()
{
	print("\n----------------------------------");
	print("  This is a blank GameModeScript");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	// Set timer of 1 second.
	SetTimer("OneSecTimer", 1000, 1);
	print("GameModeInit()");
	SetGameModeText("Timer Test");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OneSecTimer() {

	if(lasttick == 0) {
     	lasttick = GetTickCount();
		return;
	}
	new sText[256];
	format(sText,sizeof(sText),"GetTickCountOffset = %d",GetTickCount() - lasttick);
	print(sText);
	SendClientMessageToAll(0xFF0000, sText);
	lasttick = GetTickCount();
}

