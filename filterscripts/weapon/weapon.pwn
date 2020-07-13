#include <a_samp>
#include <sscanf2>
#include <a_mysql>

#define FILTERSCRIPT

#define function:%0(%1) forward %0(%1): public %0(%1)

#define COLOR_RED 0xFF0000FF
#define COLOR_YELLOW 0xFFF000FF
#define COLOR_BLUE 0x0023FFFF
#define COLOR_WHITE 0xFEFEFEFF
#define COLOR_BLUE_LIGHT 0x00FFE6FF

#define SQL_HOSTNAME "localhost"
#define SQL_USERNAME "root"
#define SQL_DATABASE "weapon_samp"
#define SQL_PASSWORD ""

main()
{
}

public OnPlayerRequestClass(playerid, classid)
{
    return 1;
}

public OnPlayerConnect(playerid)
{
    return 1;
}