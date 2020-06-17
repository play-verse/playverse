#include <a_samp>
#include <a_mysql>
#include <YSI_Coding\y_inline>

main()
{
	print("\n----------------------------------");
	print("  This is a blank GameModeScript");
	print("----------------------------------\n");
}

new MySQL:koneksi;

public OnGameModeInit()
{
	koneksi = mysql_connect_file();
	return 1;
}

public OnPlayerConnect(playerid){
		
	return 1;
}