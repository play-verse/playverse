#include <a_samp>

native SendClientCheck(playerid, type, arg, offset, size);
forward OnClientCheckResponse(playerid, type, arg, response);

#define IsPlayerAndroid(%0)                 GetPVarInt(%0, "NotAndroid") == 0

public OnFilterScriptInit()
{
    print("[Check Android] Berhasil load sistem!");
}

public OnFilterScriptExit()
{
    print("[Check Android] Berhasil unload sistem!");
}

public OnPlayerConnect(playerid)
{
    SendClientCheck(playerid, 0x48, 0, 0, 2);
    return 1;
}

public OnClientCheckResponse(playerid, type, arg, response)
{
    switch(type)
    {
        case 0x48:
        {
            SetPVarInt(playerid, "NotAndroid", 1);
        }
    }
    return 1;
}
