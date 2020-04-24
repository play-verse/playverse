	/*
	GAME MODE NATHAN
*/

#include <a_samp>
#include <pengaturan> // Pengaturan server disini letak pas dibawah a_samp
#include <colors> // https://forum.sa-mp.com/showthread.php?t=573049
#include <sscanf2>
#include <streamer>
#include <a_mysql>
#include <zcmd>
#include <foreach>
#include <moneyhax>
#include <core>
#include <float>
#include <PreviewModelDialog>
/*
	INCLUDE INCLUDE BUATAN DIBAWAH
*/
#include <global_variable> // variable disini
#include <fungsi_tambahan> // Fungsi tambahan disini - Tambahan dulu baru fungsi
#include <fungsi> // Fungsi disini

#include "../include/gl_common.inc"
#include "../include/gl_spawns.inc"

/**
	Unused params
 */
#pragma unused PlayerRainbowColors
#pragma unused gArmySpawns
#pragma unused gMedicalSpawns
#pragma unused gPoliceSpawns
#pragma unused gRandomSpawns_LasVenturas
#pragma unused gRandomSpawns_SanFierro

#pragma tabsize 0

public OnPlayerConnect(playerid)
{
/**MAPPING */

RemoveBuildingForPlayer(playerid, 620, 1541.4531, -1709.6406, 13.0469, 0.25);
RemoveBuildingForPlayer(playerid, 620, 1547.5703, -1689.9844, 13.0469, 0.25);
RemoveBuildingForPlayer(playerid, 646, 1545.5234, -1678.8438, 14.0000, 0.25);
RemoveBuildingForPlayer(playerid, 646, 1553.8672, -1677.7266, 16.4375, 0.25);
RemoveBuildingForPlayer(playerid, 646, 1553.8672, -1673.4609, 16.4375, 0.25);
RemoveBuildingForPlayer(playerid, 646, 1545.5625, -1672.2188, 14.0000, 0.25);
RemoveBuildingForPlayer(playerid, 620, 1547.5703, -1661.0313, 13.0469, 0.25);
RemoveBuildingForPlayer(playerid, 620, 1541.4531, -1642.0313, 13.0469, 0.25);
RemoveBuildingForPlayer(playerid, 17736, 2362.4609, -1541.8047, 25.1094, 0.25);
RemoveBuildingForPlayer(playerid, 1261, 2359.0938, -1540.0391, 31.2109, 0.25);
RemoveBuildingForPlayer(playerid, 1267, 2359.0938, -1540.0391, 31.2109, 0.25);
RemoveBuildingForPlayer(playerid, 17522, 2362.4609, -1541.8047, 25.1094, 0.25);
RemoveBuildingForPlayer(playerid, 17916, 2366.8125, -1537.5391, 39.4688, 0.25);
RemoveBuildingForPlayer(playerid, 3656, 2620.6406, -1068.9063, 71.3828, 0.25);
RemoveBuildingForPlayer(playerid, 3656, 2620.1875, -1086.1875, 71.3828, 0.25);
RemoveBuildingForPlayer(playerid, 3647, 2513.4688, -1111.8281, 57.8359, 0.25);
RemoveBuildingForPlayer(playerid, 3647, 2406.5469, -1112.5000, 41.5391, 0.25);
RemoveBuildingForPlayer(playerid, 3650, 2618.5625, -1113.7891, 69.6016, 0.25);
RemoveBuildingForPlayer(playerid, 3650, 2618.5547, -1099.9063, 70.9609, 0.25);
RemoveBuildingForPlayer(playerid, 3706, 2577.8984, -1095.5547, 68.0625, 0.25);
RemoveBuildingForPlayer(playerid, 3562, 2470.8359, -1109.8594, 45.5547, 0.25);
RemoveBuildingForPlayer(playerid, 3560, 2457.0625, -1105.6016, 44.8516, 0.25);
RemoveBuildingForPlayer(playerid, 1530, 2621.5078, -1092.2031, 69.7969, 0.25);
RemoveBuildingForPlayer(playerid, 1308, 2536.6719, -1079.9453, 60.7734, 0.25);
RemoveBuildingForPlayer(playerid, 3594, 2548.5859, -1106.3203, 62.2578, 0.25);
RemoveBuildingForPlayer(playerid, 1308, 2542.1016, -1099.4688, 59.9609, 0.25);
RemoveBuildingForPlayer(playerid, 17905, 2568.0234, -1098.3203, 59.5391, 0.25);
RemoveBuildingForPlayer(playerid, 1308, 2580.6484, -1058.7969, 68.5391, 0.25);
RemoveBuildingForPlayer(playerid, 1308, 2607.4297, -1058.6094, 68.5391, 0.25);
RemoveBuildingForPlayer(playerid, 1308, 2630.8047, -1129.9922, 63.9609, 0.25);
RemoveBuildingForPlayer(playerid, 3651, 2618.5625, -1113.7891, 69.6016, 0.25);
RemoveBuildingForPlayer(playerid, 3651, 2618.5547, -1099.9063, 70.9609, 0.25);
RemoveBuildingForPlayer(playerid, 1308, 2628.3672, -1093.9688, 68.5078, 0.25);
RemoveBuildingForPlayer(playerid, 3655, 2620.1875, -1086.1875, 71.3828, 0.25);
RemoveBuildingForPlayer(playerid, 3655, 2620.6406, -1068.9063, 71.3828, 0.25);
RemoveBuildingForPlayer(playerid, 3340, 2460.0000, -1057.6172, 58.7344, 0.25);
RemoveBuildingForPlayer(playerid, 3340, 2481.1719, -1067.4063, 65.7734, 0.25);
RemoveBuildingForPlayer(playerid, 3341, 2440.4063, -1059.4375, 53.2891, 0.25);
RemoveBuildingForPlayer(playerid, 3341, 2462.6328, -1009.0313, 58.6641, 0.25);
RemoveBuildingForPlayer(playerid, 3298, 2512.1797, -1023.9219, 69.5313, 0.25);
RemoveBuildingForPlayer(playerid, 3298, 2578.9531, -1029.9844, 69.0859, 0.25);
RemoveBuildingForPlayer(playerid, 3300, 2434.6094, -1009.0781, 55.2422, 0.25);
RemoveBuildingForPlayer(playerid, 3300, 2494.1797, -1017.1484, 66.2500, 0.25);
RemoveBuildingForPlayer(playerid, 3300, 2529.9531, -1028.8672, 70.4688, 0.25);
RemoveBuildingForPlayer(playerid, 3300, 2544.5469, -1029.1250, 70.4688, 0.25);
RemoveBuildingForPlayer(playerid, 3300, 2539.2656, -1066.3125, 70.5000, 0.25);
RemoveBuildingForPlayer(playerid, 3299, 2523.5078, -1066.9063, 69.1094, 0.25);
RemoveBuildingForPlayer(playerid, 3299, 2564.9609, -1028.2422, 69.0078, 0.25);
RemoveBuildingForPlayer(playerid, 3301, 2502.3281, -1068.2969, 71.0156, 0.25);
RemoveBuildingForPlayer(playerid, 3299, 2466.2891, -959.1953, 79.6641, 0.25);
RemoveBuildingForPlayer(playerid, 1409, 2426.7266, -1016.7500, 53.4453, 0.25);
RemoveBuildingForPlayer(playerid, 1368, 2430.9531, -1012.7656, 54.0156, 0.25);
RemoveBuildingForPlayer(playerid, 3285, 2434.6094, -1009.0781, 55.2422, 0.25);
RemoveBuildingForPlayer(playerid, 3170, 2440.4063, -1059.4375, 53.2891, 0.25);
RemoveBuildingForPlayer(playerid, 3167, 2460.0000, -1057.6172, 58.7344, 0.25);
RemoveBuildingForPlayer(playerid, 1409, 2459.4531, -1051.6094, 58.8438, 0.25);
RemoveBuildingForPlayer(playerid, 3170, 2462.6328, -1009.0313, 58.6641, 0.25);
RemoveBuildingForPlayer(playerid, 3167, 2481.1719, -1067.4063, 65.7734, 0.25);
RemoveBuildingForPlayer(playerid, 3285, 2494.1797, -1017.1484, 66.2500, 0.25);
RemoveBuildingForPlayer(playerid, 1368, 2488.6641, -1018.6328, 65.0625, 0.25);
RemoveBuildingForPlayer(playerid, 3284, 2502.3281, -1068.2969, 71.0156, 0.25);
RemoveBuildingForPlayer(playerid, 1409, 2505.0781, -1061.0781, 69.3125, 0.25);
RemoveBuildingForPlayer(playerid, 3283, 2523.5078, -1066.9063, 69.1094, 0.25);
RemoveBuildingForPlayer(playerid, 1409, 2527.9219, -1058.1406, 68.6875, 0.25);
RemoveBuildingForPlayer(playerid, 617, 2520.8984, -1031.3750, 67.9531, 0.25);
RemoveBuildingForPlayer(playerid, 3285, 2529.9531, -1028.8672, 70.4688, 0.25);
RemoveBuildingForPlayer(playerid, 1409, 2528.6719, -1034.9219, 68.6719, 0.25);
RemoveBuildingForPlayer(playerid, 3241, 2512.1797, -1023.9219, 69.5313, 0.25);
RemoveBuildingForPlayer(playerid, 3285, 2539.2656, -1066.3125, 70.5000, 0.25);
RemoveBuildingForPlayer(playerid, 1409, 2538.6484, -1058.6016, 68.6719, 0.25);
RemoveBuildingForPlayer(playerid, 1368, 2543.3672, -1063.8906, 69.2266, 0.25);
RemoveBuildingForPlayer(playerid, 1409, 2545.1563, -1034.8984, 68.6641, 0.25);
RemoveBuildingForPlayer(playerid, 3285, 2544.5469, -1029.1250, 70.4688, 0.25);
RemoveBuildingForPlayer(playerid, 1294, 2566.9922, -1038.9844, 72.9844, 0.25);
RemoveBuildingForPlayer(playerid, 1409, 2567.8203, -1035.2813, 68.6719, 0.25);
RemoveBuildingForPlayer(playerid, 3241, 2578.9531, -1029.9844, 69.0859, 0.25);
RemoveBuildingForPlayer(playerid, 1368, 2575.4141, -1033.3516, 69.2422, 0.25);
RemoveBuildingForPlayer(playerid, 3283, 2564.9609, -1028.2422, 69.0078, 0.25);
RemoveBuildingForPlayer(playerid, 4024, 1479.8672, -1790.3984, 56.0234, 0.25);
RemoveBuildingForPlayer(playerid, 4044, 1481.1875, -1785.0703, 22.3828, 0.25);
RemoveBuildingForPlayer(playerid, 4045, 1479.3359, -1802.2891, 12.5469, 0.25);
RemoveBuildingForPlayer(playerid, 4046, 1479.5234, -1852.6406, 24.5156, 0.25);
RemoveBuildingForPlayer(playerid, 4047, 1531.6328, -1852.6406, 24.5156, 0.25);
RemoveBuildingForPlayer(playerid, 1527, 1448.2344, -1755.8984, 14.5234, 0.25);
RemoveBuildingForPlayer(playerid, 4217, 1449.2500, -1852.5703, 22.3672, 0.25);
RemoveBuildingForPlayer(playerid, 713, 1407.1953, -1749.3125, 13.0938, 0.25);
RemoveBuildingForPlayer(playerid, 1266, 1482.0859, -1859.9688, 25.0391, 0.25);
RemoveBuildingForPlayer(playerid, 713, 1405.2344, -1821.1172, 13.1016, 0.25);
RemoveBuildingForPlayer(playerid, 620, 1417.9766, -1832.5313, 11.9844, 0.25);
RemoveBuildingForPlayer(playerid, 673, 1405.5781, -1831.6953, 12.3984, 0.25);
RemoveBuildingForPlayer(playerid, 1265, 1465.4766, -1848.2500, 12.9922, 0.25);
RemoveBuildingForPlayer(playerid, 1372, 1466.9453, -1847.8438, 12.6641, 0.25);
RemoveBuildingForPlayer(playerid, 1372, 1419.7344, -1846.5469, 12.6641, 0.25);
RemoveBuildingForPlayer(playerid, 1265, 1420.4297, -1845.3438, 12.9844, 0.25);
RemoveBuildingForPlayer(playerid, 1372, 1419.6953, -1844.2031, 12.6641, 0.25);
RemoveBuildingForPlayer(playerid, 1220, 1420.4922, -1842.4375, 12.9297, 0.25);
RemoveBuildingForPlayer(playerid, 1220, 1419.7266, -1842.8516, 12.9297, 0.25);
RemoveBuildingForPlayer(playerid, 1230, 1419.6719, -1842.0313, 12.9766, 0.25);
RemoveBuildingForPlayer(playerid, 4170, 1433.9531, -1844.4063, 21.4219, 0.25);
RemoveBuildingForPlayer(playerid, 700, 1447.1016, -1832.5000, 12.9141, 0.25);
RemoveBuildingForPlayer(playerid, 1231, 1432.3047, -1832.9141, 15.2891, 0.25);
RemoveBuildingForPlayer(playerid, 4174, 1435.7656, -1823.6641, 15.1797, 0.25);
RemoveBuildingForPlayer(playerid, 620, 1456.3984, -1832.5313, 11.9844, 0.25);
RemoveBuildingForPlayer(playerid, 673, 1464.0938, -1831.8828, 12.3984, 0.25);
RemoveBuildingForPlayer(playerid, 1260, 1482.0859, -1859.9688, 25.0391, 0.25);
RemoveBuildingForPlayer(playerid, 4004, 1479.5234, -1852.6406, 24.5156, 0.25);
RemoveBuildingForPlayer(playerid, 1357, 1487.6953, -1848.1094, 12.8125, 0.25);
RemoveBuildingForPlayer(playerid, 1372, 1486.2109, -1848.1250, 12.6641, 0.25);
RemoveBuildingForPlayer(playerid, 1372, 1468.0625, -1847.7891, 12.6641, 0.25);
RemoveBuildingForPlayer(playerid, 1230, 1488.9219, -1848.2734, 12.9766, 0.25);
RemoveBuildingForPlayer(playerid, 1231, 1480.0313, -1832.9141, 15.2891, 0.25);
RemoveBuildingForPlayer(playerid, 3997, 1479.3359, -1802.2891, 12.5469, 0.25);
RemoveBuildingForPlayer(playerid, 4171, 1503.3984, -1848.3359, 21.4609, 0.25);
RemoveBuildingForPlayer(playerid, 620, 1504.8438, -1832.5313, 11.9844, 0.25);
RemoveBuildingForPlayer(playerid, 673, 1499.0469, -1832.2734, 12.8828, 0.25);
RemoveBuildingForPlayer(playerid, 1265, 1515.3828, -1850.0547, 12.9844, 0.25);
RemoveBuildingForPlayer(playerid, 1265, 1514.4219, -1850.0391, 12.9922, 0.25);
RemoveBuildingForPlayer(playerid, 700, 1512.9453, -1832.3516, 13.4688, 0.25);
RemoveBuildingForPlayer(playerid, 1372, 1516.6875, -1850.0547, 12.6641, 0.25);
RemoveBuildingForPlayer(playerid, 700, 1404.9141, -1765.2656, 12.9141, 0.25);
RemoveBuildingForPlayer(playerid, 4173, 1427.2734, -1756.1797, 15.0000, 0.25);
RemoveBuildingForPlayer(playerid, 673, 1415.3125, -1748.5625, 12.3984, 0.25);
RemoveBuildingForPlayer(playerid, 620, 1429.5313, -1748.4219, 12.9063, 0.25);
RemoveBuildingForPlayer(playerid, 700, 1438.0313, -1747.9375, 13.4453, 0.25);
RemoveBuildingForPlayer(playerid, 620, 1447.9063, -1748.2266, 12.9063, 0.25);
RemoveBuildingForPlayer(playerid, 4002, 1479.8672, -1790.3984, 56.0234, 0.25);
RemoveBuildingForPlayer(playerid, 3980, 1481.1875, -1785.0703, 22.3828, 0.25);
RemoveBuildingForPlayer(playerid, 4003, 1481.0781, -1747.0313, 33.5234, 0.25);
RemoveBuildingForPlayer(playerid, 620, 1516.0000, -1748.6016, 13.0078, 0.25);
RemoveBuildingForPlayer(playerid, 4048, 1531.6328, -1852.6406, 24.5156, 0.25);
RemoveBuildingForPlayer(playerid, 1372, 1538.9453, -1849.2734, 12.6641, 0.25);
RemoveBuildingForPlayer(playerid, 1230, 1538.8359, -1847.6250, 13.6719, 0.25);
RemoveBuildingForPlayer(playerid, 1220, 1538.3906, -1847.9297, 12.9297, 0.25);
RemoveBuildingForPlayer(playerid, 1220, 1539.1016, -1847.2969, 12.9297, 0.25);
RemoveBuildingForPlayer(playerid, 1231, 1529.2891, -1832.9141, 15.2891, 0.25);
RemoveBuildingForPlayer(playerid, 620, 1549.5313, -1832.3125, 12.8828, 0.25);
RemoveBuildingForPlayer(playerid, 673, 1555.6641, -1830.5938, 13.0234, 0.25);
RemoveBuildingForPlayer(playerid, 4175, 1524.4141, -1823.8516, 15.1797, 0.25);
RemoveBuildingForPlayer(playerid, 700, 1554.8203, -1816.1563, 13.4766, 0.25);
RemoveBuildingForPlayer(playerid, 673, 1553.2578, -1764.8125, 12.7969, 0.25);
RemoveBuildingForPlayer(playerid, 4172, 1534.7656, -1756.1797, 15.0000, 0.25);
RemoveBuildingForPlayer(playerid, 620, 1533.2656, -1749.0234, 12.8047, 0.25);
RemoveBuildingForPlayer(playerid, 673, 1522.1641, -1748.5703, 13.0234, 0.25);
RemoveBuildingForPlayer(playerid, 700, 1553.7031, -1747.9375, 13.4063, 0.25);
RemoveBuildingForPlayer(playerid, 6075, 1003.4219, -1737.5000, 17.8438, 0.25);
RemoveBuildingForPlayer(playerid, 621, 1010.7266, -1779.5156, 12.1250, 0.25);
RemoveBuildingForPlayer(playerid, 760, 1012.2109, -1779.2813, 13.2031, 0.25);
RemoveBuildingForPlayer(playerid, 621, 1019.0156, -1781.1094, 11.5938, 0.25);
RemoveBuildingForPlayer(playerid, 748, 1019.7891, -1782.5000, 13.1719, 0.25);
RemoveBuildingForPlayer(playerid, 759, 1019.6563, -1778.2734, 12.9531, 0.25);
RemoveBuildingForPlayer(playerid, 759, 1016.0781, -1779.9531, 12.9531, 0.25);
RemoveBuildingForPlayer(playerid, 634, 1022.7656, -1780.0938, 12.8438, 0.25);
RemoveBuildingForPlayer(playerid, 759, 998.2266, -1775.9844, 12.9531, 0.25);
RemoveBuildingForPlayer(playerid, 748, 994.5547, -1775.3906, 13.1719, 0.25);
RemoveBuildingForPlayer(playerid, 759, 1007.1250, -1777.6953, 12.9531, 0.25);
RemoveBuildingForPlayer(playerid, 760, 1004.7031, -1776.7969, 13.2031, 0.25);
RemoveBuildingForPlayer(playerid, 748, 1001.9531, -1776.5938, 13.1719, 0.25);
RemoveBuildingForPlayer(playerid, 620, 994.9297, -1774.8672, 8.9219, 0.25);
RemoveBuildingForPlayer(playerid, 634, 999.9219, -1775.3359, 13.0313, 0.25);
RemoveBuildingForPlayer(playerid, 6037, 1003.4219, -1737.5000, 17.8438, 0.25);
RemoveBuildingForPlayer(playerid, 17594, 2314.8516, -1799.4219, 13.0703, 0.25);
RemoveBuildingForPlayer(playerid, 17759, 2314.8516, -1799.4219, 13.0703, 0.25);
RemoveBuildingForPlayer(playerid, 3695, 2239.9297, -1790.6953, 17.0078, 0.25);
RemoveBuildingForPlayer(playerid, 3695, 2282.9922, -1790.6953, 17.0078, 0.25);
RemoveBuildingForPlayer(playerid, 3695, 2314.8203, -1790.6953, 17.0078, 0.25);
RemoveBuildingForPlayer(playerid, 3695, 2352.7188, -1790.6953, 17.0078, 0.25);
RemoveBuildingForPlayer(playerid, 3695, 2387.8203, -1790.6953, 17.0078, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2229.0469, -1810.0313, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2226.1641, -1807.3281, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2226.1641, -1801.8672, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2230.4141, -1815.1484, 11.3438, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2234.4844, -1817.9297, 12.0938, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2226.1641, -1791.0000, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2226.1641, -1796.4531, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 3584, 2239.9297, -1790.6953, 17.0078, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2226.1641, -1775.5078, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2226.1641, -1780.9844, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2228.6719, -1767.2734, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2226.1641, -1770.0469, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1307, 2232.5156, -1766.0547, 12.7500, 0.25);
RemoveBuildingForPlayer(playerid, 1307, 2249.8672, -1815.4141, 12.7500, 0.25);
RemoveBuildingForPlayer(playerid, 669, 2254.7266, -1827.4375, 12.5625, 0.25);
RemoveBuildingForPlayer(playerid, 1226, 2259.9453, -1796.0703, 16.4219, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2258.3438, -1804.7422, 12.0938, 0.25);
RemoveBuildingForPlayer(playerid, 645, 2259.2656, -1773.2422, 11.1250, 0.25);
RemoveBuildingForPlayer(playerid, 17886, 2264.0391, -1789.2578, 20.7734, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2265.2969, -1791.0000, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2265.2969, -1796.4531, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2265.2969, -1807.3281, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2265.2969, -1801.8672, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2265.2969, -1770.0469, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2265.2969, -1775.5078, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2265.2969, -1780.9844, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2275.3906, -1820.7266, 12.0938, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2268.1875, -1810.0313, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2273.6953, -1810.0313, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 3584, 2282.9922, -1790.6953, 17.0078, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2267.8125, -1767.2734, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2273.3359, -1767.3438, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2271.6484, -1772.3984, 8.3516, 0.25);
RemoveBuildingForPlayer(playerid, 645, 2285.7578, -1762.1250, 12.2891, 0.25);
RemoveBuildingForPlayer(playerid, 1226, 2297.8984, -1793.8203, 16.4219, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2297.3828, -1798.5391, 8.3516, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2297.1484, -1775.8750, 8.3516, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2305.0625, -1810.0313, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1807.3281, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1801.8672, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1791.0000, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1796.4531, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 3584, 2314.8203, -1790.6953, 17.0078, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1775.5078, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1770.0469, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1780.9844, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2304.7813, -1767.3828, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1307, 2322.6484, -1815.4141, 12.7500, 0.25);
RemoveBuildingForPlayer(playerid, 645, 2332.8281, -1817.7109, 12.1172, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2341.7578, -1810.0313, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2338.8672, -1807.3281, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2341.7578, -1817.7266, 8.3594, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2338.8672, -1801.8672, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1226, 2335.6484, -1796.6328, 16.4219, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2338.8672, -1791.0000, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2338.8672, -1796.4531, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2334.7109, -1785.0625, 12.0938, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2338.8672, -1775.5078, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2338.8672, -1780.9844, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 17887, 2343.6094, -1784.5078, 20.3125, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2338.8672, -1770.0469, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2341.3828, -1767.2734, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 669, 2329.1875, -1765.5234, 12.4375, 0.25);
RemoveBuildingForPlayer(playerid, 673, 2349.6172, -1763.3438, 11.6328, 0.25);
RemoveBuildingForPlayer(playerid, 3584, 2352.7188, -1790.6953, 17.0078, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2367.6484, -1802.7969, 8.3594, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2367.6484, -1780.7734, 11.0469, 0.25);
RemoveBuildingForPlayer(playerid, 620, 2378.3359, -1818.7266, 8.3594, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1800.4688, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1805.9297, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2376.9922, -1813.9297, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1811.3828, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1780.9844, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1789.6016, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1795.0547, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2376.6172, -1767.2734, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1770.0469, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1775.5078, 13.1563, 0.25);
RemoveBuildingForPlayer(playerid, 645, 2399.9766, -1815.9922, 11.8906, 0.25);
RemoveBuildingForPlayer(playerid, 3584, 2387.8203, -1790.6953, 17.0078, 0.25);
RemoveBuildingForPlayer(playerid, 673, 2398.5781, -1782.7734, 10.7031, 0.25);
RemoveBuildingForPlayer(playerid, 645, 2387.0234, -1763.6406, 12.1797, 0.25);
RemoveBuildingForPlayer(playerid, 4504, 56.3828, -1531.4531, 6.7266, 0.25);
RemoveBuildingForPlayer(playerid, 4215, 1777.5547, -1775.0391, 36.7500, 0.25);
RemoveBuildingForPlayer(playerid, 5059, 1841.1094, -1856.0469, 14.9375, 0.25);
RemoveBuildingForPlayer(playerid, 1412, 1834.3125, -1879.5547, 13.6797, 0.25);
RemoveBuildingForPlayer(playerid, 1412, 1839.5859, -1879.5547, 13.6797, 0.25);
RemoveBuildingForPlayer(playerid, 1412, 1844.8672, -1879.5547, 13.6797, 0.25);
RemoveBuildingForPlayer(playerid, 1412, 1850.1406, -1879.5547, 13.6797, 0.25);
RemoveBuildingForPlayer(playerid, 1412, 1855.4141, -1879.5547, 13.6797, 0.25);
RemoveBuildingForPlayer(playerid, 5043, 1843.3672, -1856.3203, 13.8750, 0.25);
RemoveBuildingForPlayer(playerid, 5042, 1850.5703, -1855.6797, 14.3672, 0.25);
RemoveBuildingForPlayer(playerid, 1413, 1864.1797, -1879.6641, 13.6797, 0.25);
RemoveBuildingForPlayer(playerid, 4983, 1961.0313, -1871.4063, 23.7734, 0.25);



	/*
	Removes vending machines
	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
	*/
	SetPlayerColor(playerid, COLOR_WHITE);
	
	resetPlayerVariable(playerid);

	new nama[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nama, sizeof(nama));
	PlayerInfo[playerid][pPlayerName] = nama;
    mysql_format(koneksi, query, sizeof(query), "SELECT * FROM `user` WHERE `nama` = '%e'", PlayerInfo[playerid][pPlayerName]);
	mysql_tquery(koneksi, query, "isRegistered", "d", playerid);

	return 1;
}


//----------------------------------------------------------

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch( dialogid )
    {
        case DIALOG_REGISTER:
        {
            if(response)
            {
				if( strlen(inputtext) >= 8 && strlen(inputtext) <= 24 )
				{
					format(registerInfo[playerid][registerPassword], 25, "%s", inputtext);
			        return ShowPlayerDialog(playerid, DIALOG_REPEAT_PASSWORD, DIALOG_STYLE_PASSWORD,WHITE"SILAHKAN ULANGI PASSWORD",WHITE"{FFFFFF}Silahkan ulangi kembali password!","Konfirmasi","Keluar");
				} else {
			        return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""WHITE"SILAHKAN DAFTAR",RED"Password harus berisi 8 hingga 24 karakter!\n"WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
				}
            }
            else 
				Kick(playerid);
			// Selalu return 1 - wiki samp OnDialogResponse should 1 return 1 when handled
			return 1;
        }
		case DIALOG_REPEAT_PASSWORD:
		{
			if(response){
				if( sama(registerInfo[playerid][registerPassword], inputtext) )
				{
					dialogEmail(playerid);
					return 1;
				} else {
			        return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""WHITE"SILAHKAN DAFTAR",RED"Password konfirmasi salah! Silahkan ulangi kembali!\n"WHITE"{FFFFFF}Kamu {FF0000}belum {FFFFFF}terdaftar di server","Daftar","Keluar");
				}

			}
            else
				Kick(playerid);			
			return 1;
		}
        case DIALOG_LOGIN:
        {
            if( response )
            {
				new hash[65];
				// hashing the text that user entered and salt that was loaded
				SHA256_PassHash(inputtext, PlayerInfo[playerid][pPlayerName], hash, 64);
				if(sama(hash, PlayerInfo[playerid][pPassword]))
				{
					mysql_format(koneksi, query, sizeof(query), "UPDATE `user` SET `jumlah_login` = `jumlah_login` + 1 WHERE `id` = '%d'", PlayerInfo[playerid][pID]);
					mysql_tquery(koneksi, query, "spawnPemain", "d", playerid);

					PlayerInfo[playerid][loginKe]++;
					format(msg, sizeof(msg), "~r~Selamat ~y~datang ~g~kembali~w~!~n~Anda masuk yang ke - ~g~ %d ~w~!", PlayerInfo[playerid][loginKe]);
					GameTextForPlayer(playerid, msg, 4000, 3);

					GivePlayerMoney(playerid, strval(PlayerInfo[playerid][uang]));
					return 1;
				}
				else
				{
					return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, WHITE"Login",RED"Password salah silahkan coba lagi, perhatikan penggunaan capslock!\n"WHITE"Masukan Password untuk login ke akun!","Login","Keluar");
				}
			}
			else
				Kick ( playerid );
			return 1;
		}
		case DIALOG_INPUT_EMAIL: {
			if(response){
				if(!isnull(inputtext)){
					new format_gmail[15] = "@gmail.com", len = strlen(inputtext), len_format = strlen(format_gmail);
					if(len <= len_format || strfind(inputtext, format_gmail, true, len - len_format) == -1){
						ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", RED"Format email invalid!\n"WHITE"Masukan email anda, kami hanya mensupport email "RED"@gmail.com\n:", "Simpan", "Keluar");
					}else{
						format(registerInfo[playerid][email], 100, "%s", inputtext);

						ShowPlayerDialog(playerid, DIALOG_INPUT_JEKEL, DIALOG_STYLE_LIST, "Pilih Jenis Kelamin", WHITE"Laki-Laki\nPerempuan", "Simpan", "Keluar");
					}
				}else{
					ShowPlayerDialog(playerid, DIALOG_INPUT_EMAIL, DIALOG_STYLE_INPUT, "Input Email anda", RED"Anda harus memasukan email anda!\n"WHITE"Masukan email anda, kami hanya mensupport email "RED"@gmail.com\n:", "Simpan", "Keluar");
				}
			}else{
				Kick(playerid);
			}
			return 1;
		}
		case DIALOG_INPUT_JEKEL:
		{
			if(response){
				registerInfo[playerid][jenisKelamin] = listitem;

				new len;
				new subString[16];
				static string[500];
				len = registerInfo[playerid][jenisKelamin] == 0 ? sizeof(SKIN_MALE_GRATIS) : sizeof(SKIN_FEMALE_GRATIS);

				for (new i = 0; i < len; i++) {
					format(subString, sizeof(subString), "%i\n", registerInfo[playerid][jenisKelamin] == 0 ? SKIN_MALE_GRATIS[i] : SKIN_FEMALE_GRATIS[i]);
					strcat(string, subString);
				} 
				return ShowPlayerDialog(playerid, DIALOG_INPUT_SKIN_GRATIS, DIALOG_STYLE_PREVIEW_MODEL, "Pilih skin yang anda inginkan", string, "Pilih", "Keluar");
			}else{
				Kick(playerid);
			}
			return 1;
		}
		case DIALOG_INPUT_SKIN_GRATIS: 
		{
			if(response){
				registerInfo[playerid][freeSkinID] = (registerInfo[playerid][jenisKelamin] == 0) ? SKIN_MALE_GRATIS[listitem] : SKIN_FEMALE_GRATIS[listitem];
				registerUser(playerid);

				spawnPemain(playerid);
				return 1;
			}else{
				Kick(playerid);
			}
			return 1;
		}
		case DIALOG_INVENTORY:
		{
			if(response){
				switch(listitem){
					case 0:
					{
						mysql_format(koneksi, query, sizeof(query), "SELECT * FROM `user_skin` WHERE `id_user` = '%d'", PlayerInfo[playerid][pID]);
						mysql_tquery(koneksi, query, "tampilInventorySkinPlayer", "d", playerid);
					}
				}
			}
			return 1;
		}
		case DIALOG_PAKAI_SKIN:
		{
			if(response){
				new id_skin = strval(inputtext);
				updatePlayerCurrentSkin(playerid, id_skin);
				PlayerInfo[playerid][skinID] = id_skin;

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil", GREEN"Anda berhasil mengganti skin anda!\n"WHITE"Silahkan ke kamar ganti terdekat atau spawn ulang untuk mendapatkan efeknya.", "Ok", "");
			}
			return 1;
		}
		case DIALOG_BELI_SKIN:
		{
			if(response){
				new id_skin = (PlayerInfo[playerid][jenisKelamin] == 0) ? SKIN_MALE_GRATIS[listitem] : SKIN_FEMALE_GRATIS[listitem];

				tambahSkinPlayer(playerid, id_skin);

				ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, GREEN"Berhasil mendapatkan skin", GREEN"Anda berhasil mendapatkan skin!\n"WHITE"Silahkan buka inventory untuk melihatnya.", "Ok", "");
			}
			return 1;
		}
    }

	// Wiki-SAMP OnDialogResponse should return 0
    return 0;
}



public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;

	new randSpawn = 0;
	
	SetPlayerInterior(playerid,0);
	SetPlayerSkin(playerid, PlayerInfo[playerid][skinID]);
	randSpawn = random(sizeof(gRandomSpawns_LosSantos));
	SetPlayerPos(playerid,
		gRandomSpawns_LosSantos[randSpawn][0],
		gRandomSpawns_LosSantos[randSpawn][1],
		gRandomSpawns_LosSantos[randSpawn][2]);

	SetPlayerFacingAngle(playerid,gRandomSpawns_LosSantos[randSpawn][3]);
	return 1;
}

//----------------------------------------------------------

public OnPlayerDeath(playerid, killerid, reason)
{
    new playercash;
        
	if(killerid == INVALID_PLAYER_ID) {
        ResetPlayerMoney(playerid);
	} else {
		playercash = GetPlayerMoney(playerid);
		if(playercash > 0)  {
			GivePlayerMoney(killerid, playercash);
			ResetPlayerMoney(playerid);
		}
	}
   	return 1;
}

//----------------------------------------------------------

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;
	return 1;
}

public OnPlayerRequestSpawn(playerid){
	if(PlayerInfo[playerid][loginKe] == 1){
		PlayerInfo[playerid][skinID] = GetPlayerSkin(playerid);
		format(msg, sizeof(msg), "PID : %d\nSkin ID : %d", PlayerInfo[playerid][pID], PlayerInfo[playerid][skinID]);
		print(msg);
		tambahSkinPlayer(playerid, PlayerInfo[playerid][skinID]);
		updatePlayerCurrentSkin(playerid, PlayerInfo[playerid][skinID]);
		return 1;
	}
	return 1;
}

/*
	UNTUK HILANGKAN INVALID INDEX PARAMETER (BAD ENTRY POINT) BIARKAN SAJA FUNGSI MAIN
*/
main( ) { }

public OnGameModeInit()
{
	koneksi = mysql_connect(HOST, USER, PASS, DB);
	errno = mysql_errno(koneksi);
	if(errno != 0){
		new error[100];
	
		mysql_error(error, sizeof (error), koneksi);
		printf("[ERROR] #%d '%s'", errno, error);
	}else{
		printf("[SUCCESS] Berhasil Koneksi ke database!");
	}

	// Mapping
	//Mapping

//Pelabuhan santa maria
CreateDynamicObject(3406, 143.40076, -1894.43054, 1.30641,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 134.59898, -1894.41980, 1.32748,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 125.79716, -1894.40881, 1.34875,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 116.99435, -1894.39795, 1.37024,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 143.54320, -1930.29114, 1.22571,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 134.74281, -1930.26514, 1.24597,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 125.94250, -1930.23914, 1.26643,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 117.14113, -1930.21216, 1.28705,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 133.31250, -1948.64014, 1.32390,   0.00000, 0.00000, 336.94791);
CreateDynamicObject(3406, 125.36720, -1945.27576, 1.32960,   0.00000, 0.00000, 337.17581);
CreateDynamicObject(3406, 117.30330, -1941.75745, 1.36260,   0.00000, 0.00000, 336.50851);
CreateDynamicObject(3406, 143.52350, -1912.81995, 1.09245,   0.00000, 0.00000, 0.70601);
CreateDynamicObject(3406, 134.72444, -1912.82861, 1.07371,   0.00000, 0.00000, 0.69902);
CreateDynamicObject(3406, 125.92538, -1912.83716, 1.05516,   0.00000, 0.00000, 0.69209);
CreateDynamicObject(3406, 117.12535, -1912.84570, 1.03679,   0.00000, 0.00000, 0.68524);
CreateDynamicObject(3406, 167.11334, -1932.70959, 1.40415,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 175.70282, -1932.71338, 1.42064,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 184.30846, -1932.71143, 1.44284,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 177.43921, -1951.66492, 1.32524,   0.00000, 0.00000, 0.76694);
CreateDynamicObject(3406, 186.06223, -1951.69128, 1.34650,   0.00000, 0.00000, 0.77461);
CreateDynamicObject(3406, 193.11850, -1932.64758, 1.46720,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 194.88455, -1951.71887, 1.36796,   0.00000, 0.00000, 0.78236);
CreateDynamicObject(3406, 135.27341, -1968.95300, 1.52270,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 126.47437, -1968.97290, 1.53932,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 117.66889, -1968.97412, 1.51616,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 144.06502, -1968.97510, 1.49323,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 152.86041, -1968.97620, 1.47052,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 161.65587, -1968.97742, 1.44804,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 170.45134, -1968.97864, 1.42579,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 179.23360, -1968.96729, 1.43430,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 188.02390, -1968.97009, 1.42630,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3406, 196.80870, -1968.96863, 1.43020,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(17068, 298.94409, -1906.98254, 0.21000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(11495, 298.94769, -1928.95337, 0.21000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(11495, 298.95505, -1950.93262, 0.21000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(11495, 298.95340, -1972.90833, 0.21000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(11495, 298.94949, -1994.86536, 0.21000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(11495, 298.95163, -2016.83911, 0.21000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(902, 277.25409, -1953.21484, -5.95567,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(902, 292.80246, -1985.57458, -10.04900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(902, 251.31607, -1982.30542, -9.52222,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(902, 212.42267, -1956.17224, -6.04742,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(903, 285.69382, -2048.37915, -19.12108,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(903, 232.59537, -2041.60840, -17.10624,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(903, 256.46277, -2050.50928, -19.75496,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(903, 259.18945, -2035.43066, -15.26787,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(953, 198.40141, -1978.04712, -8.56034,   0.00000, 358.00000, 150.00000);
CreateDynamicObject(903, 199.52405, -2034.15784, -14.88911,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(953, 256.65845, -2031.80334, -19.69681,   0.00000, 354.00000, 149.99997);
CreateDynamicObject(953, 184.05380, -2035.98633, -20.94158,   0.00000, 4.00000, 199.99997);
CreateDynamicObject(1461, 309.05185, -1866.69250, 2.66888,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(1461, 244.83580, -1876.21753, 1.70729,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1461, 197.24249, -1874.41467, 2.24303,   0.00000, 0.00000, 276.00000);
CreateDynamicObject(1461, 336.72296, -1877.27991, 2.28274,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1598, 271.63412, -1841.87756, 2.78819,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1610, 277.75430, -1888.96863, 0.65809,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1611, 279.18369, -1888.24731, 0.69808,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1610, 281.47754, -1889.24683, 0.65350,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1610, 281.39182, -1886.22412, 0.80381,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1610, 277.84570, -1886.53857, 0.78013,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1611, 280.39868, -1887.67053, 0.72632,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1611, 278.42163, -1887.44519, 0.73624,   0.00000, 0.00000, 42.00000);
CreateDynamicObject(1637, 270.21680, -1841.30859, 3.77844,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1637, 177.68387, -1860.86804, 3.49534,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1337, 360.93750, -1835.88867, 5.99670,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2404, 179.48502, -1858.71851, 3.53361,   0.00000, 0.00000, 139.99994);
CreateDynamicObject(2405, 179.44902, -1858.02844, 3.52566,   0.00000, 0.00000, 126.00000);
CreateDynamicObject(2406, 179.38278, -1857.29907, 3.55677,   0.00000, 0.00000, 135.99994);
CreateDynamicObject(2410, 296.00937, -1896.48901, 0.46391,   0.00000, 4.00000, 298.00000);
CreateDynamicObject(2782, 286.40411, -2034.44495, -20.48359,   0.00000, 4.00000, 185.99998);
CreateDynamicObject(9958, 273.09381, -2103.54150, -22.00805,   0.00000, 332.00000, 80.00000);
CreateDynamicObject(903, 210.28685, -2055.22583, -21.15851,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1598, 204.03809, -1961.29980, -6.04568,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(620, 300.58594, -1854.31738, 2.19188,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(620, 300.99121, -1840.29004, 2.59822,   0.00000, 0.00000, 12.00000);
CreateDynamicObject(620, 300.80991, -1820.52625, 3.17276,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(621, 181.53174, -1799.00635, 3.04768,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(621, 207.83398, -1798.81445, 3.35377,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(621, 237.79883, -1797.75488, 3.39051,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(621, 275.12500, -1798.71875, 3.41226,   0.00000, 0.00000, 14.00000);
CreateDynamicObject(624, 217.53125, -1854.43286, 2.21550,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(624, 252.21118, -1842.61401, 2.40755,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(624, 229.33096, -1828.62512, 1.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(624, 261.77441, -1814.22070, 3.22982,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(624, 276.38498, -1868.96570, 1.65699,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(645, 173.65317, -1858.75964, 2.27659,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(6050, 162.99374, -1819.38879, 5.09121,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1639, 208.01370, -1835.62500, 2.62343,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1639, 208.00238, -1841.72900, 2.62200,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1255, 216.30331, -1869.26868, 2.27095,   0.00000, 0.00000, 284.00000);
CreateDynamicObject(1255, 218.69023, -1869.50488, 2.22548,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 221.16325, -1869.67468, 2.18445,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 223.21213, -1870.05481, 2.13104,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 225.47844, -1870.15295, 2.09810,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 227.85808, -1870.27808, 2.06172,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 230.15601, -1870.32080, 2.03292,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 232.62173, -1870.64807, 1.98723,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 179.58612, -1873.13977, 2.30932,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 181.94229, -1873.42358, 2.25938,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 184.52609, -1873.27063, 2.24662,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 187.11731, -1873.40857, 2.20746,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 189.52698, -1873.37256, 2.18590,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 260.61469, -1873.78174, 1.81220,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 265.81738, -1874.91394, 1.90433,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 268.41635, -1875.23242, 1.89536,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 271.04156, -1875.75671, 1.87614,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(1255, 258.25821, -1873.17529, 1.75799,   0.00000, 0.00000, 283.99658);
CreateDynamicObject(643, 313.14746, -1860.14795, 2.53519,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(643, 317.05057, -1855.49585, 2.67848,   0.00000, 0.00000, 42.00000);
CreateDynamicObject(643, 312.99942, -1849.92432, 2.81387,   0.00000, 0.00000, 339.99524);
CreateDynamicObject(643, 319.14014, -1845.89087, 2.91052,   0.00000, 0.00000, 193.99390);
CreateDynamicObject(643, 322.00269, -1852.37354, 2.74426,   0.00000, 0.00000, 121.99109);
CreateDynamicObject(643, 323.60083, -1860.71558, 2.54298,   0.00000, 0.00000, 333.98676);
CreateDynamicObject(1281, 330.71442, -1843.36340, 3.31475,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1281, 334.71503, -1839.18140, 3.44887,   0.00000, 0.00000, 44.00000);
CreateDynamicObject(1281, 336.59058, -1845.01318, 3.25615,   0.00000, 0.00000, 319.99475);
CreateDynamicObject(1281, 333.03787, -1849.52271, 3.15408,   0.00000, 0.00000, 265.99329);
CreateDynamicObject(1281, 339.15344, -1851.34302, 3.22394,   0.00000, 0.00000, 25.99002);
CreateDynamicObject(1432, 318.69238, -1862.93420, 2.00540,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1432, 312.81781, -1855.34131, 2.20258,   0.00000, 0.00000, 300.00000);
CreateDynamicObject(1432, 322.33878, -1856.62170, 2.17405,   0.00000, 0.00000, 11.99817);
CreateDynamicObject(1432, 318.61282, -1849.86096, 2.34374,   0.00000, 0.00000, 11.99707);
CreateDynamicObject(1368, 302.67419, -1846.52148, 3.10510,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1368, 302.70279, -1838.83899, 3.32974,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1368, 302.99017, -1830.61145, 3.56882,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1368, 302.89288, -1821.74780, 3.82648,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1368, 303.03046, -1857.55859, 2.80132,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1594, 318.92310, -1858.61646, 2.60649,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1594, 316.30048, -1852.01746, 2.76926,   0.00000, 0.00000, 306.00000);
CreateDynamicObject(1594, 323.67426, -1847.84180, 2.86922,   0.00000, 0.00000, 259.99670);
CreateDynamicObject(1594, 314.16141, -1846.56079, 2.90255,   0.00000, 0.00000, 295.99146);
CreateDynamicObject(1670, 318.59836, -1849.87000, 2.95908,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1670, 319.06146, -1858.77051, 3.08411,   0.00000, 0.00000, 318.00000);
CreateDynamicObject(2801, 318.71445, -1862.89673, 2.29174,   0.00000, 0.00000, 22.00000);
CreateDynamicObject(2800, 312.90466, -1850.05371, 3.21395,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2216, 314.12247, -1846.77637, 3.38017,   335.00000, 26.00000, 0.00000);
CreateDynamicObject(2222, 322.49179, -1856.74365, 2.85775,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2221, 322.03555, -1852.44739, 3.21368,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2342, 323.59167, -1847.95923, 3.45569,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2647, 315.90222, -1851.96655, 3.40342,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2663, 316.19489, -1852.14612, 3.50170,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2683, 312.66089, -1855.25708, 2.94402,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2768, 312.74619, -1855.94702, 2.86023,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2769, 313.31308, -1855.17725, 2.83731,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2814, 313.12009, -1860.16443, 2.93527,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2823, 317.12134, -1855.62817, 3.07856,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2839, 319.27133, -1845.94556, 3.31060,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2858, 323.54474, -1860.70081, 2.94306,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(955, 316.95044, -1828.19336, 2.99329,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1209, 315.80038, -1828.28479, 2.61647,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1486, 312.78406, -1860.58032, 3.08022,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1487, 313.18796, -1855.43567, 3.01537,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1510, 312.85907, -1855.39917, 2.81791,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1512, 323.62018, -1848.31873, 3.54429,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1520, 321.75751, -1852.36987, 3.14434,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1544, 316.63623, -1852.07861, 3.24688,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1546, 319.16174, -1846.13721, 3.39973,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1664, 314.55991, -1846.66870, 3.54687,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1665, 322.04129, -1856.58130, 2.79984,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1667, 314.53531, -1846.48816, 3.46874,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1668, 323.43143, -1860.47546, 2.94306,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1951, 316.78949, -1855.53210, 3.26673,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(11413, 208.75415, -1799.20947, 5.90649,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(9153, 273.82755, -1795.67395, 7.90711,   0.00000, 0.00000, 40.00000);
CreateDynamicObject(14449, 243.13658, -1823.66724, 4.12552,   0.00000, 0.00000, 318.00000);
CreateDynamicObject(14537, 328.24805, -1831.94238, 4.83228,   0.00000, 358.24768, 91.99951);
CreateDynamicObject(1598, 211.17261, -1838.13916, 2.97992,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1243, 252.29790, -2097.06982, -3.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1243, 303.53192, -2098.32300, -3.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1243, 203.94955, -2096.76831, -3.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1243, -160.66998, -2129.53589, -3.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3472, 302.66370, -1850.70422, 2.29784,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3472, 302.18890, -1833.85889, 2.78488,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3472, 302.78967, -1814.97583, 3.33361,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2228, 279.57834, -1886.40576, 1.14520,   0.00000, 18.50000, 246.25000);
CreateDynamicObject(2600, 360.68387, -2019.92505, 7.60821,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2600, 360.48364, -2015.31494, 7.60821,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2600, 360.45551, -2017.71667, 7.60236,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2600, 360.74493, -2022.36926, 7.60236,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2600, 360.51563, -2012.05127, 7.60821,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1342, 236.04755, -1844.41479, 3.42576,   0.00000, 0.00000, 290.00000);
CreateDynamicObject(1341, 185.56458, -1841.55762, 3.69598,   0.00000, 0.00000, 306.00000);
CreateDynamicObject(1340, 291.48700, -1820.44324, 4.27342,   0.00000, 0.00000, 287.99997);
CreateDynamicObject(642, 259.32596, -1872.45837, 2.71238,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(642, 212.84662, -1875.85986, 2.62392,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(642, 224.84909, -1866.74695, 3.23055,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(642, 182.95026, -1872.59009, 3.17374,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(642, 289.44757, -1886.56580, 2.25333,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1841, 250.30223, -1855.91675, 2.57362,   0.00000, 0.00000, 312.00000);
CreateDynamicObject(1839, 251.12642, -1855.92261, 2.57362,   0.00000, 0.00000, 267.75000);
CreateDynamicObject(2226, 324.96436, -1836.50830, 3.86564,   0.00000, 0.00000, 322.00000);
CreateDynamicObject(1640, 221.83641, -1880.21338, 0.84858,   4.00000, 0.00000, 38.00000);
CreateDynamicObject(1641, 223.95786, -1879.35718, 0.89462,   4.00000, 0.00000, 0.00000);
CreateDynamicObject(1642, 233.12889, -1880.29846, 0.72869,   4.00000, 0.00000, 0.00000);
CreateDynamicObject(1643, 184.58752, -1882.10876, 0.97256,   4.00000, 0.00000, 322.00000);
CreateDynamicObject(14820, 251.13637, -1855.32410, 2.68334,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2126, 251.19850, -1856.13269, 2.06403,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2126, 250.25029, -1856.12280, 2.06613,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1841, 250.28719, -1855.91406, 3.04362,   0.00000, 0.00000, 311.99524);
CreateDynamicObject(1841, 252.07129, -1855.91199, 2.57151,   0.00000, 0.00000, 233.99518);
CreateDynamicObject(1841, 252.08723, -1855.90784, 3.04151,   0.00000, 0.00000, 233.99231);
CreateDynamicObject(1962, 250.42508, -1855.32251, 2.75362,   90.00000, 358.00000, 0.00000);
CreateDynamicObject(1960, 251.73839, -1855.32678, 2.75351,   90.00000, 0.00000, 0.00000);
CreateDynamicObject(1709, 248.92937, -1853.94812, 2.12555,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3461, 248.40559, -1851.47742, 3.76616,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3461, 248.92995, -1855.95728, 3.64805,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3461, 255.32962, -1852.38916, 3.72880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3461, 253.06546, -1857.34607, 3.60367,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1243, 150.86107, -2094.56738, -3.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1243, 78.53864, -2103.37671, -3.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1243, 10.29030, -2112.34912, -3.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1243, -73.81628, -2119.24268, -3.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(5167, 2838.03125, -2371.95313, 7.29688,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(5160, 2829.95313, -2479.57031, 5.26563,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(5166, 2829.95313, -2479.57031, 5.67451,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(5157, 2838.03906, -2532.77344, 17.02344,   356.85840, 0.00000, -1.57080);


//Toko deket bale kota
CreateDynamicObject(3578, 1346.25012, -1756.61780, 11.63690,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1341.48218, -1749.11169, 13.19820,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(9131, 1341.48865, -1742.61414, 12.54547,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(9131, 1351.56592, -1742.48669, 12.54547,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(717, 1339.99768, -1744.47449, 12.64375,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(717, 1339.98254, -1754.15417, 12.64375,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1346.26306, -1753.95618, 12.93950,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(10401, 1351.24292, -1753.91248, 14.42380,   0.00000, 0.00000, 44.49470);
CreateDynamicObject(3578, 1351.25293, -1756.66003, 11.63690,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(970, 1351.22815, -1753.98096, 12.93950,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(3578, 1356.26819, -1756.70752, 11.63690,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(970, 1356.23303, -1754.01868, 12.93950,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1468, 1361.07434, -1753.61938, 13.73720,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1468, 1361.07483, -1749.88550, 13.73720,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1468, 1358.51489, -1747.26331, 13.73720,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1209, 1363.76953, -1745.19543, 12.53730,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1349, 1343.36572, -1759.01807, 13.08940,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1349, 1343.79492, -1759.01025, 13.08940,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1349, 1344.23486, -1759.01025, 13.08940,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1349, 1344.83667, -1758.99597, 13.08940,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1335.98853, -1759.64856, 13.13820,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(970, 1343.41565, -1756.18201, 12.95950,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1361, 1340.96997, -1755.90283, 13.23690,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1348.32666, -1756.16113, 12.95950,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1353.30737, -1756.15710, 12.95950,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1358.28845, -1756.15942, 12.95950,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1361.20776, -1756.31738, 13.02251,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1360.19275, -1756.37585, 13.02251,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1356.29321, -1756.33508, 13.02251,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1355.25342, -1756.35486, 13.02251,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1351.29358, -1756.28699, 13.02251,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1350.25378, -1756.33167, 13.02251,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1346.35071, -1756.31689, 13.02251,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1345.34961, -1756.31604, 13.02251,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(9131, 1356.68237, -1742.49133, 12.54547,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(19121, 1341.43054, -1742.63464, 14.08019,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1351.55762, -1742.50452, 14.08019,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1356.66113, -1742.46899, 14.08019,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1468, 1359.37964, -1742.45081, 13.73720,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1468, 1364.54651, -1742.42786, 13.73720,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1351.74890, -1743.85181, 12.94020,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1415, 1341.72131, -1761.78601, 12.53230,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1372, 1341.47327, -1766.66333, 12.66406,   356.85840, 0.00000, -0.08727);
CreateDynamicObject(1265, 1341.70496, -1765.17383, 13.00000,   356.85840, 0.00000, 3.14159);
CreateDynamicObject(1265, 1340.78821, -1765.83704, 13.00000,   356.85840, 0.00000, 3.14159);
CreateDynamicObject(1265, 1341.56677, -1763.42310, 13.00000,   356.85840, 0.00000, 3.14159);
CreateDynamicObject(19121, 1352.37219, -1745.02051, 12.94020,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1353.13489, -1746.03052, 12.94020,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1354.26294, -1746.79199, 12.94020,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19121, 1355.67480, -1747.26990, 12.94020,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 1358.59644, -1741.97449, 12.92910,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 1362.35303, -1741.99951, 12.92910,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(638, 1358.65015, -1746.82446, 13.26700,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(638, 1341.01379, -1748.19714, 13.26700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19425, 1349.07556, -1742.31616, 12.37390,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19425, 1344.11401, -1742.29346, 12.37390,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(8843, 1051.34692, -1824.08093, 12.54960,   0.00000, 0.00000, 21.86880);
CreateDynamicObject(8843, 991.02222, -1787.65991, 13.10040,   0.00000, 0.00000, 76.70230);
CreateDynamicObject(8843, 955.36401, -1794.44446, 13.12040,   0.00000, 0.00000, 256.29739);
CreateDynamicObject(8843, 872.24213, -1770.64441, 12.39020,   0.00000, 0.00000, 87.99910);
CreateDynamicObject(8843, 825.68536, -1784.03638, 12.75720,   0.00000, 0.00000, 270.29291);
CreateDynamicObject(8843, 674.82770, -1741.06445, 12.45320,   0.50000, 0.00000, 75.00000);
CreateDynamicObject(8843, 627.42725, -1745.40125, 12.31970,   -0.50000, 0.00000, 259.53201);
CreateDynamicObject(8843, 482.86401, -1709.56775, 10.49300,   -1.50000, 0.00000, 82.00000);
CreateDynamicObject(8843, 430.13644, -1718.05688, 8.62910,   2.00000, 0.00000, 265.23990);
CreateDynamicObject(8843, 246.85925, -1668.66174, 9.28460,   4.50000, 0.00000, 51.00000);

//Pombensin idlewood
CreateDynamicObject(640, 1929.29980, -1785.20020, 16.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(640, 1929.30005, -1780.00000, 16.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(640, 1929.30005, -1774.69995, 16.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(640, 1929.30005, -1769.40002, 16.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(640, 1929.30005, -1767.50000, 16.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(640, 1926.40002, -1765.19995, 16.60000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(640, 1925.40002, -1765.19995, 16.60000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(640, 1923.09998, -1767.59998, 16.60000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(640, 1926.40002, -1787.50000, 16.60000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(640, 1925.40002, -1787.50000, 16.60000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(827, 1949.30005, -1800.90002, 16.30000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(618, 1942.00000, -1810.19995, 12.50000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(669, 1932.70020, -1803.00000, 12.50000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(672, 1922.40039, -1810.79980, 12.50000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 1941.90039, -1808.70020, 12.90000,   0.00000, 0.00000, 265.99500);
CreateDynamicObject(984, 1942.50000, -1771.80005, 13.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(984, 1942.50000, -1773.80005, 13.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(984, 1940.80005, -1773.80005, 13.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(984, 1940.80005, -1771.90002, 13.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2395, 1928.30005, -1785.90002, 12.50000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1928.30005, -1782.19995, 12.50000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1928.30005, -1781.40002, 12.50000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1928.30005, -1774.00000, 12.50000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1928.30005, -1770.30005, 12.50000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1928.30005, -1769.50000, 12.50000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1928.30005, -1785.90002, 13.70000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1928.30005, -1782.19995, 13.70000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1928.30005, -1781.40002, 13.70000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1928.30005, -1774.00000, 13.70000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1928.30005, -1770.30005, 13.70000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1928.30005, -1769.50000, 13.70000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2395, 1925.00000, -1786.50000, 12.50000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2395, 1923.09998, -1786.50000, 12.50000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2395, 1925.00000, -1786.50000, 13.70000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2395, 1923.09998, -1786.50000, 13.70000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2395, 1927.80005, -1766.09998, 12.50000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2395, 1925.90002, -1766.09998, 12.50000,   0.00000, 0.00000, 179.99500);
CreateDynamicObject(2395, 1927.69995, -1766.09998, 13.70000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2395, 1925.90002, -1766.09998, 13.70000,   0.00000, 0.00000, 179.99500);
CreateDynamicObject(1280, 1928.50000, -1780.59998, 12.90000,   0.00000, 0.00000, 179.99500);
CreateDynamicObject(14468, 1942.40002, -1810.59998, 13.40000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3660, 1952.09998, -1767.69995, 15.20000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(3660, 1952.19995, -1771.80005, 15.20000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(1280, 1950.69995, -1777.30005, 12.90000,   0.00000, 0.00000, 1.99500);
CreateDynamicObject(1280, 1950.30005, -1764.30005, 12.90000,   0.00000, 0.00000, 1.99400);
CreateDynamicObject(3802, 1928.19995, -1777.69995, 15.30000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3802, 1928.30005, -1774.90002, 15.30000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1951.09998, -1779.59998, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(970, 1951.00000, -1775.50000, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(970, 1950.90002, -1771.40002, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(970, 1950.69995, -1767.30005, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(970, 1950.59998, -1763.19995, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(970, 1950.50000, -1760.09998, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(970, 1952.59998, -1760.00000, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(970, 1952.80005, -1764.09998, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(970, 1952.90002, -1768.19995, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(970, 1953.00000, -1772.40002, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(970, 1953.19995, -1776.50000, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(970, 1953.19995, -1779.50000, 13.10000,   0.00000, 0.00000, 272.00000);
CreateDynamicObject(3660, 1941.80005, -1796.09998, 15.20000,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(970, 1949.50000, -1795.30005, 13.10000,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(970, 1945.40002, -1795.30005, 13.10000,   0.00000, 0.00000, 359.99500);
CreateDynamicObject(970, 1941.30005, -1795.30005, 13.10000,   0.00000, 0.00000, 359.99500);
CreateDynamicObject(970, 1937.30005, -1795.30005, 13.10000,   0.00000, 0.00000, 359.99500);
CreateDynamicObject(970, 1934.09998, -1795.30005, 13.10000,   0.00000, 0.00000, 359.99500);
CreateDynamicObject(1280, 1948.50000, -1795.00000, 12.90000,   0.00000, 0.00000, 271.99399);
CreateDynamicObject(1280, 1935.40002, -1795.00000, 12.90000,   0.00000, 0.00000, 271.98901);
CreateDynamicObject(669, 1943.59998, -1821.90002, 12.50000,   0.00000, 0.00000, 347.99701);
CreateDynamicObject(669, 1924.59998, -1818.90002, 12.50000,   0.00000, 0.00000, 23.99200);
CreateDynamicObject(669, 1912.90002, -1807.80005, 12.50000,   0.00000, 0.00000, 41.98900);
CreateDynamicObject(669, 1945.80005, -1801.59998, 12.50000,   0.00000, 0.00000, 72.00000);
CreateDynamicObject(669, 1921.09998, -1800.80005, 12.50000,   0.00000, 0.00000, 199.99899);
CreateDynamicObject(669, 1928.19995, -1810.59998, 12.50000,   0.00000, 0.00000, 199.99500);
CreateDynamicObject(669, 1909.59998, -1800.40002, 12.50000,   0.00000, 0.00000, 255.99500);
CreateDynamicObject(672, 1926.90002, -1801.69995, 12.50000,   0.00000, 0.00000, 60.00000);
CreateDynamicObject(672, 1938.40002, -1802.59998, 12.50000,   0.00000, 0.00000, 59.99600);

//interior rumah sakit
CreateDynamicObject(19552, 220.93773, 1768.81152, 9999.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 158.89638, 1772.09656, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 175.02864, 1765.73450, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 163.72429, 1776.82214, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 168.46629, 1781.56677, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 167.46881, 1780.40576, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19388, 173.83467, 1780.40698, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 180.18202, 1780.41174, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 168.46561, 1791.19397, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 171.99921, 1781.95825, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 175.56700, 1782.01855, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 171.99879, 1784.55188, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 175.56480, 1784.55188, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 167.26102, 1786.10266, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 179.16554, 1785.21863, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 180.28775, 1786.07825, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 179.16461, 1794.75818, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 171.99840, 1787.75012, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 175.55901, 1787.72461, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 171.99800, 1790.37805, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 175.55730, 1790.31104, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 167.26941, 1792.00684, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 180.28510, 1791.94031, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 168.45981, 1800.78796, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 171.99730, 1793.67578, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 175.55791, 1793.60608, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 171.99330, 1796.25757, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 175.55780, 1796.22656, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 173.13380, 1797.76563, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 182.71680, 1797.76526, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19466, 175.52730, 1782.00842, 10000.61621,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19466, 172.04755, 1781.72949, 10000.61621,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19466, 172.04416, 1787.58887, 10000.61621,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19466, 171.99274, 1793.60217, 10000.61621,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19466, 175.52724, 1793.68298, 10000.61621,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19466, 175.54980, 1787.81482, 10000.61621,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1523, 175.52850, 1785.34290, 9998.90332,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1523, 171.94881, 1785.34900, 9998.90332,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1523, 175.53249, 1791.09619, 9998.90332,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1523, 171.97336, 1791.17969, 9998.90332,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1523, 175.52455, 1797.01587, 9998.90332,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1523, 171.94279, 1797.08020, 9998.90332,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(19388, 168.63901, 1765.73926, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 179.78571, 1783.66467, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 179.78664, 1777.28613, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 179.78766, 1774.13306, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 179.78928, 1771.01013, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 158.88652, 1762.63867, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 162.30701, 1765.74133, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 161.72995, 1761.01880, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 175.10831, 1761.00220, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 170.47772, 1764.08582, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 166.65050, 1764.14832, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 170.47940, 1760.93970, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 166.65060, 1760.99658, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 175.20641, 1759.36536, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 161.92281, 1759.42383, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 161.72762, 1751.41858, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 170.47971, 1757.75073, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19404, 166.64841, 1757.75757, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 170.48140, 1754.60352, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 166.64940, 1754.59412, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 166.57169, 1753.07617, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 176.17233, 1753.07129, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 175.10860, 1751.64368, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19466, 170.42500, 1757.81116, 10000.90625,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19466, 166.63625, 1757.67883, 10000.90625,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19466, 166.64716, 1764.10364, 10000.90625,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19466, 170.42838, 1764.13953, 10000.90625,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1523, 170.18410, 1759.23535, 10002.18457,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1523, 166.67059, 1760.24561, 9998.90332,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1523, 170.49651, 1753.85315, 9998.90332,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1523, 166.69020, 1753.84338, 9998.90332,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 179.78729, 1764.64258, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 184.91655, 1780.47217, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 184.91862, 1774.08716, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19358, 183.39854, 1772.56128, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19358, 181.36050, 1772.55933, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19325, 179.76030, 1776.26343, 10002.31250,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19358, 183.21844, 1769.01257, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19358, 181.37160, 1769.01135, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 184.81680, 1764.20422, 10000.62695,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 186.43060, 1769.01367, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 189.68629, 1775.55261, 10000.63086,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 188.04550, 1770.83289, 10003.95215,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 188.03880, 1761.37036, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19379, 170.97574, 1793.15894, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 181.46780, 1793.14917, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 170.96260, 1783.53613, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 181.46181, 1783.53113, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 170.96637, 1773.91321, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 181.44304, 1773.89343, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 160.46230, 1773.91431, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 170.97032, 1764.29260, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 181.46370, 1764.26892, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 160.47340, 1764.28979, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 170.39818, 1754.67932, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 191.95757, 1764.27490, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 191.94099, 1773.89624, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 159.89740, 1754.67944, 9998.93652,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 180.70110, 1783.37769, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 170.20630, 1783.37927, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 170.20708, 1792.99426, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 180.70216, 1792.98828, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 170.25729, 1773.74976, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 180.72795, 1773.74878, 10002.29785,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 179.62680, 1764.15332, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 191.21330, 1773.74585, 10002.29785,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 169.13800, 1764.15564, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 158.64160, 1764.15259, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 171.88918, 1754.58118, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 161.39101, 1754.57410, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19378, 159.81030, 1773.74634, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(14411, 186.51300, 1764.65100, 9999.18555,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19378, 182.31520, 1754.57910, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19450, 188.04152, 1770.83289, 10000.63086,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 188.04610, 1761.19531, 10003.95215,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 177.31360, 1759.28821, 10003.95801,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 185.95166, 1768.97375, 10003.95215,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 181.06889, 1770.12390, 10003.96191,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 176.36340, 1770.37354, 10003.95996,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19388, 179.55188, 1765.26794, 10003.95215,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19358, 176.94510, 1765.26953, 10003.95215,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 175.42780, 1770.03467, 10003.96191,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 166.74370, 1770.37341, 10003.95996,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19388, 173.75060, 1765.27075, 10003.95801,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19358, 170.92059, 1765.27502, 10003.95801,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 169.40480, 1770.06763, 10003.96191,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19450, 169.41890, 1760.49219, 10003.96191,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19388, 170.97720, 1759.28613, 10003.95801,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19450, 186.94659, 1759.28821, 10003.95215,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19457, 177.29480, 1759.25403, 10003.95801,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19457, 186.90651, 1759.24658, 10003.95215,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19457, 181.40849, 1754.55664, 10003.95215,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19378, 182.32301, 1744.93091, 10002.29590,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19457, 169.43600, 1754.38403, 10003.96973,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19457, 173.63071, 1752.62183, 10003.96973,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19457, 182.37740, 1752.57312, 10003.96973,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19457, 187.53416, 1745.62231, 10003.95215,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19457, 191.32990, 1742.70203, 10003.95215,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19394, 170.97639, 1759.25305, 10003.95801,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19379, 182.36580, 1745.15430, 10005.65625,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 182.35980, 1754.77136, 10005.65625,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 171.88260, 1754.74805, 10005.65625,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 192.83514, 1764.07690, 10005.65625,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 182.36659, 1764.08887, 10005.65234,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 171.89786, 1764.08862, 10005.65234,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 171.90579, 1773.71643, 10005.65234,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 182.36920, 1773.71399, 10005.65234,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(14842, 179.77126, 1758.28149, 10004.29297,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(14842, 171.10890, 1753.59082, 10004.29297,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19457, 175.86317, 1756.19653, 9998.82031,   90.00000, 0.00000, 90.00000);
CreateDynamicObject(11729, 176.84888, 1752.91125, 10002.35059,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(11729, 176.18764, 1752.90930, 10002.35059,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(11729, 175.56305, 1752.90198, 10002.35059,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(11729, 174.89539, 1752.89575, 10002.35059,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(11730, 174.19376, 1752.91589, 10002.35059,   0.00000, 0.00000, 173.37796);
CreateDynamicObject(3850, 184.78299, 1764.55029, 10002.92090,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3850, 184.78300, 1768.02332, 10002.92090,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1536, 159.02490, 1770.27539, 9999.03516,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1536, 158.98511, 1773.27759, 9999.03516,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(3657, 161.30316, 1766.23682, 9999.51367,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(3657, 165.10608, 1766.23425, 9999.51367,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(3657, 161.00087, 1776.35413, 9999.51367,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3657, 164.74089, 1776.37744, 9999.51367,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(932, 179.02380, 1766.46790, 9998.98730,   0.00000, 0.00000, 256.32556);
CreateDynamicObject(932, 179.07419, 1767.51013, 9998.98730,   0.00000, 0.00000, 217.22360);
CreateDynamicObject(1997, 170.36082, 1779.65662, 9999.02246,   0.00000, 0.00000, 70.38852);
CreateDynamicObject(1997, 169.02345, 1778.60059, 9999.02246,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1997, 178.09734, 1780.99622, 9998.96680,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(2606, 177.36050, 1785.77014, 10001.71973,   10.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, 176.07343, 1783.34961, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, 176.02943, 1785.53613, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1721, 164.03426, 1786.19568, 9999.02441,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1721, 164.07849, 1785.52454, 9999.02441,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1997, 178.18178, 1786.65161, 9998.96680,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(2606, 177.27371, 1791.67151, 10001.71973,   10.00000, 0.00000, 0.00000);
CreateDynamicObject(1721, 178.97189, 1783.29907, 9999.02441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1721, 178.95538, 1782.47327, 9999.02441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2001, 176.02742, 1789.08142, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, 176.05518, 1791.40820, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1997, 178.20544, 1792.45618, 9998.96680,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(2606, 177.37811, 1797.56604, 10001.71973,   10.00000, 0.00000, 0.00000);
CreateDynamicObject(14604, 178.50046, 1803.10657, 9999.95410,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1721, 178.94231, 1788.90894, 9999.02441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1721, 178.96748, 1789.78894, 9999.02441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2001, 175.97057, 1795.04761, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, 175.96477, 1797.23755, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1997, 169.29735, 1780.94287, 9998.96680,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1997, 169.34819, 1786.64783, 9998.96680,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1997, 169.41322, 1792.53394, 9998.96680,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2606, 170.17967, 1797.66614, 10001.71973,   10.00000, 0.00000, 0.00000);
CreateDynamicObject(2606, 170.33647, 1791.74805, 10001.71973,   10.00000, 0.00000, 0.00000);
CreateDynamicObject(2606, 170.41714, 1785.78027, 10001.71973,   10.00000, 0.00000, 0.00000);
CreateDynamicObject(1721, 178.93242, 1795.62402, 9999.02441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1721, 178.96910, 1794.68945, 9999.02441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1721, 170.31227, 1797.55481, 9999.02441,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1721, 168.67622, 1795.16650, 9999.02441,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1721, 168.67784, 1795.93445, 9999.02441,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1721, 168.70370, 1788.15759, 9999.02441,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1721, 168.67361, 1788.97522, 9999.02441,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1721, 170.44415, 1791.80994, 9999.02441,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1721, 168.69772, 1782.90186, 9999.02441,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1721, 168.66991, 1783.77747, 9999.02441,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1721, 170.46886, 1785.88611, 9999.02441,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1721, 177.06503, 1785.83398, 9999.02441,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1721, 177.17860, 1791.71606, 9999.02441,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1721, 177.04105, 1797.54248, 9999.02441,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2001, 171.53816, 1797.20557, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, 171.64708, 1795.20349, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, 171.55545, 1791.54919, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, 171.67474, 1789.35828, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, 171.49040, 1785.62085, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, 171.53343, 1783.40955, 9998.98730,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2262, 173.77431, 1797.18848, 10001.02637,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1997, 173.75194, 1797.24854, 9998.96680,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(932, 177.24020, 1766.09900, 9998.98730,   0.00000, 0.00000, 269.28244);
CreateDynamicObject(2011, 159.32066, 1773.80017, 9998.97070,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 159.30431, 1769.63745, 9998.97070,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2165, 180.35786, 1773.61536, 9999.02441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2165, 180.34250, 1776.63660, 9999.02441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2773, 178.52403, 1775.67322, 9999.52441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2773, 176.61354, 1775.66345, 9999.52441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2773, 178.47102, 1772.92615, 9999.52441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2773, 176.56731, 1772.91614, 9999.52441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2773, 178.51817, 1778.43848, 9999.52441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2773, 176.59303, 1778.43420, 9999.52441,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2186, 180.32043, 1778.82751, 9999.02344,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2181, 184.34045, 1778.96570, 9998.99316,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(2181, 182.45450, 1779.80273, 9998.99316,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19610, 180.51241, 1777.75977, 9999.87988,   45.00000, 0.00000, 253.21710);
CreateDynamicObject(19610, 180.66756, 1774.71240, 9999.87988,   45.00000, 0.00000, 229.21317);
CreateDynamicObject(19807, 184.75674, 1776.11914, 10000.75293,   90.00000, 0.00000, -90.00000);
CreateDynamicObject(2265, 182.37677, 1773.16553, 10000.94141,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1997, 173.06329, 1763.47266, 9999.02344,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(19903, 174.29041, 1764.82275, 9999.02344,   0.00000, 0.00000, 216.94319);
CreateDynamicObject(16377, 171.04187, 1765.33289, 9999.91602,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(16377, 166.25542, 1756.14856, 9999.91602,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1806, 173.71786, 1762.77661, 9999.02539,   0.00000, 0.00000, 44.47575);
CreateDynamicObject(1806, 172.60034, 1764.26282, 9999.02539,   0.00000, 0.00000, 214.44235);
CreateDynamicObject(2725, 172.86929, 1762.65601, 9999.11426,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(11716, 173.06740, 1762.79260, 9999.54980,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2606, 164.25769, 1753.55127, 10001.19141,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19787, 161.75418, 1755.85266, 10001.34473,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1722, 164.81937, 1753.23865, 9999.02344,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, 163.92911, 1753.22937, 9999.02344,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, 161.88910, 1755.75488, 9999.02344,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(2001, 166.33302, 1753.48914, 9999.02441,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1997, 164.13228, 1763.70935, 9999.02344,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1806, 164.11812, 1764.59399, 9999.02539,   0.00000, 0.00000, 149.41692);
CreateDynamicObject(1806, 164.77379, 1762.84058, 9999.02539,   0.00000, 0.00000, 44.47575);
CreateDynamicObject(2725, 163.93358, 1762.77795, 9999.11426,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(11716, 164.14517, 1762.85791, 9999.54980,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19903, 162.78029, 1764.37280, 9999.02344,   0.00000, 0.00000, 308.83682);
CreateDynamicObject(16377, 166.12692, 1765.30798, 9999.91602,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(16377, 166.26230, 1762.39697, 9999.91602,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19787, 161.75163, 1762.64392, 10001.34473,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1722, 161.90410, 1761.54712, 9999.02344,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1722, 163.82249, 1759.59167, 9999.02344,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, 164.56926, 1759.59583, 9999.02344,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2606, 163.99063, 1759.69641, 10001.19141,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2001, 166.22650, 1759.93616, 9999.02441,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1715, 181.20110, 1774.56909, 9998.98633,   0.00000, 0.00000, 285.29565);
CreateDynamicObject(1715, 181.30269, 1776.90393, 9998.98633,   0.00000, 0.00000, 238.81241);
CreateDynamicObject(1715, 183.35435, 1778.32068, 9998.98633,   0.00000, 0.00000, 98.34927);
CreateDynamicObject(1715, 182.18449, 1779.03516, 9998.98633,   0.00000, 0.00000, 122.35320);
CreateDynamicObject(1997, 164.34924, 1757.81311, 9999.02344,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1806, 164.39745, 1758.70874, 9999.02539,   0.00000, 0.00000, 149.41692);
CreateDynamicObject(1806, 165.09206, 1756.91333, 9999.02539,   0.00000, 0.00000, 44.47575);
CreateDynamicObject(2725, 164.12894, 1756.89587, 9999.11426,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(11716, 164.14311, 1756.99426, 9999.54980,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19903, 162.66513, 1758.58069, 9999.02344,   0.00000, 0.00000, 308.83682);
CreateDynamicObject(16377, 166.15549, 1759.01282, 9999.91602,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(16377, 170.87305, 1762.47180, 9999.91602,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(19787, 175.10100, 1762.82642, 10001.03613,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(2606, 172.55287, 1759.68140, 10001.21191,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1722, 173.29803, 1759.56116, 9999.02344,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, 172.43071, 1759.52991, 9999.02344,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, 174.95816, 1761.49670, 9999.02344,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1722, 174.96655, 1754.84045, 9999.02344,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(16377, 170.84721, 1756.19690, 9999.91602,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(16377, 171.02608, 1758.82336, 9999.91602,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1997, 172.90533, 1757.22986, 9999.02344,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1806, 172.69518, 1758.02075, 9999.02539,   0.00000, 0.00000, 214.44235);
CreateDynamicObject(2725, 172.67737, 1756.42603, 9999.11426,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(11716, 172.87369, 1756.50110, 9999.54980,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1806, 173.63368, 1756.40698, 9999.02539,   0.00000, 0.00000, 44.47575);
CreateDynamicObject(19903, 174.34073, 1758.68933, 9999.02344,   0.00000, 0.00000, 216.94319);
CreateDynamicObject(19787, 175.05249, 1756.21960, 10001.03613,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1722, 173.17181, 1753.25195, 9999.02344,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, 172.42873, 1753.24292, 9999.02344,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2606, 172.88120, 1753.38538, 10001.21191,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2001, 170.93643, 1759.86621, 9999.02441,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, 170.98486, 1753.49939, 9999.02441,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1997, 168.46625, 1753.59705, 9999.02344,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2265, 168.46552, 1753.65588, 10000.70898,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(932, 177.96114, 1766.40088, 9998.98730,   0.00000, 0.00000, 209.27750);
CreateDynamicObject(932, 176.28352, 1766.12952, 9998.98730,   0.00000, 0.00000, 269.28244);
CreateDynamicObject(932, 175.33301, 1766.10559, 9998.98730,   0.00000, 0.00000, 269.28244);
CreateDynamicObject(2263, 179.17856, 1768.17529, 10000.76270,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(2261, 162.62897, 1776.21826, 10000.79785,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2260, 163.64856, 1766.30383, 10000.74121,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2010, 179.09367, 1779.79675, 9999.02246,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, 172.53477, 1765.92200, 9999.01855,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, 171.78770, 1765.93213, 9999.01855,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, 171.04858, 1765.89844, 9999.01855,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1726, 182.33215, 1768.45337, 10002.38281,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1726, 181.72528, 1765.58118, 10002.38281,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2207, 171.88133, 1766.89294, 10002.38379,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(14455, 169.47365, 1770.32776, 10004.04785,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(2608, 173.91666, 1770.04407, 10002.99121,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2608, 175.14314, 1769.03015, 10002.99121,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1742, 175.45232, 1767.22827, 10002.39258,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1714, 170.26900, 1768.11438, 10002.38379,   0.00000, 0.00000, 55.13352);
CreateDynamicObject(1715, 172.58376, 1766.67468, 10002.38379,   0.00000, 0.00000, 231.18715);
CreateDynamicObject(1715, 172.54028, 1768.81714, 10002.38379,   0.00000, 0.00000, 302.00153);
CreateDynamicObject(2190, 171.83490, 1768.31055, 10003.16016,   0.00000, 0.00000, 283.87393);
CreateDynamicObject(1742, 181.12776, 1767.28882, 10002.39258,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(2608, 180.90739, 1768.95837, 10002.99121,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(2608, 179.74445, 1770.08777, 10002.99121,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1715, 178.46980, 1768.99475, 10002.38379,   0.00000, 0.00000, 302.00153);
CreateDynamicObject(1715, 178.45097, 1766.88477, 10002.38379,   0.00000, 0.00000, 231.18715);
CreateDynamicObject(2207, 177.72112, 1767.02563, 10002.38379,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2190, 177.68021, 1768.51807, 10003.16016,   0.00000, 0.00000, 283.87393);
CreateDynamicObject(1714, 176.19855, 1768.18457, 10002.38379,   0.00000, 0.00000, 84.62448);
CreateDynamicObject(14455, 175.53770, 1770.37146, 10004.04785,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1502, 174.49809, 1765.29846, 10002.21680,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1502, 180.30710, 1765.29114, 10002.21680,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1368, 175.79430, 1756.61914, 10002.89453,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1368, 175.87027, 1755.78259, 10002.89453,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 175.50006, 1791.83130, 10000.71875,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 175.64714, 1786.13220, 10000.71875,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 175.61801, 1780.40417, 10000.71875,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 179.01154, 1780.80225, 10000.71875,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 179.21591, 1786.33862, 10000.71875,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 179.10454, 1792.12146, 10000.71875,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 172.20828, 1792.47302, 10000.71875,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 172.09987, 1786.54309, 10000.71875,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 172.11479, 1780.48096, 10000.71875,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 170.32182, 1760.52698, 10000.74512,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 170.34384, 1755.96289, 10000.74512,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 170.40569, 1751.31421, 10000.74512,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 166.23711, 1753.90247, 10000.74512,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 166.00868, 1760.08728, 10000.74512,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 174.43230, 1760.01221, 10000.68555,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 174.49010, 1753.53137, 10000.70508,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 170.59070, 1765.58923, 10000.79785,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 170.77887, 1772.55493, 10000.79785,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 164.40399, 1772.63428, 10000.79785,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 164.35107, 1765.59009, 10000.79785,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 176.14024, 1772.61804, 10000.79785,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 177.44130, 1765.59558, 10000.79785,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 183.81310, 1773.61340, 10000.79785,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14680, 184.66219, 1768.29761, 10000.79785,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1523, 167.85490, 1765.72046, 9998.90332,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1523, 173.04170, 1780.38733, 9998.90332,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1892, 159.38431, 1772.05103, 9999.00977,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1892, 159.37608, 1770.44189, 9999.00977,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1495, 179.80510, 1768.97302, 9998.93848,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1495, 184.30600, 1769.00659, 9998.93848,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1495, 184.89940, 1776.21082, 9998.93848,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1523, 170.49699, 1760.18860, 9998.90332,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2196, 176.82295, 1767.44836, 10003.16113,   0.00000, 0.00000, 109.13029);
CreateDynamicObject(2196, 170.92107, 1767.23840, 10003.16113,   0.00000, 0.00000, 118.80252);
CreateDynamicObject(16377, 178.63550, 1785.63782, 9999.94727,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(16377, 176.08224, 1780.91492, 9999.94727,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(16377, 171.49739, 1780.81458, 9999.94727,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(16377, 168.97672, 1785.69067, 9999.94727,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(16377, 178.63824, 1791.48975, 9999.94727,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(16377, 176.11061, 1786.53174, 9999.94727,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(16377, 178.67429, 1797.34814, 9999.94727,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(16377, 176.10841, 1792.42334, 9999.94727,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(16377, 171.49535, 1786.48132, 9999.94727,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(16377, 168.96011, 1791.62231, 9999.94727,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(16377, 171.50264, 1792.41516, 9999.94727,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(16377, 168.99710, 1797.31726, 9999.94727,   0.00000, 0.00000, 180.00000);

//Parkiran LSPD








CreateDynamicObject(968, 1544.69995, -1631.00000, 13.07000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(970, 1544.68994, -1621.77002, 13.01000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(0, 1545.16003, -1619.16003, 12.95000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(717, 1547.62000, -1620.27002, 12.76000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(717, 1577.42004, -1620.27002, 12.76000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(717, 1555.00000, 6828.00000, -1620.27002,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(717, 1555.05005, -1620.27002, 12.76000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(717, 1562.52002, -1620.25000, 12.76000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(717, 1569.96997, -1620.27002, 12.76000,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(970, 1551.26001, -1620.31995, 13.10000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1558.79004, -1620.31995, 13.10000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1566.23999, -1620.31995, 13.10000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(0, 1573.69995, -1620.31995, 13.10000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(10183, 1603.65002, -1623.12000, 12.56000,   0.00000, 0.00000, -45.00000);
CreateDynamicObject(10183, 1567.42004, -1606.62000, 12.41000,   0.00000, 0.00000, 45.00000);
CreateDynamicObject(700, 1541.03003, -1643.55005, 12.97000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(700, 1546.84998, -1661.65002, 13.34000,   0.00000, 0.00000, 62.00000);
CreateDynamicObject(700, 1547.03003, -1691.06006, 13.34000,   0.00000, 0.00000, 62.00000);
CreateDynamicObject(700, 1540.77002, -1707.27002, 13.61000,   0.00000, 0.00000, 62.00000);
CreateDynamicObject(910, 1565.37000, -1637.21997, 13.79000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(970, 1573.69995, -1620.31995, 13.10000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1544.68994, -1619.67004, 13.01000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(970, 1545.42004, -1634.91003, 13.08000,   0.00000, 0.00000, 100.00000);
CreateDynamicObject(970, 1545.78003, -1639.03003, 13.08000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(970, 1544.68994, -1621.77002, 11.91000,   180.00000, 0.00000, 90.00000);

//Pombensin East Los Santos





CreateDynamicObject(18232, 2365.27002, -1551.31006, 22.99000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(18452, 2360.37012, -1538.02002, 25.85000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3465, 2360.42993, -1535.18005, 24.37000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(3465, 2360.42993, -1540.80005, 24.37000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(910, 2357.75000, -1553.42004, 24.18000,   0.00000, 0.00000, 175.00000);
CreateDynamicObject(760, 2353.91992, -1552.07996, 23.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1338, 2359.48999, -1553.39001, 23.63000,   0.00000, 0.00000, 95.00000);
CreateDynamicObject(1617, 2360.25000, -1550.44995, 25.51000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(955, 2374.75000, -1539.02002, 23.39000,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2374.90991, -1542.50000, 23.33000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1223, 2363.54004, -1548.45996, 21.44000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1223, 2357.82007, -1540.80005, 22.72000,   0.00000, 0.00000, 25.00000);
CreateDynamicObject(1223, 2362.95996, -1535.23999, 22.72000,   0.00000, 0.00000, 225.00000);
CreateDynamicObject(1223, 2375.53003, -1536.77002, 21.12000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1223, 2375.38989, -1543.55005, 21.12000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(782, 2373.27002, -1553.63000, 23.03000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 2360.42334, -1541.18274, 23.56030,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 2360.37622, -1534.77332, 23.56030,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 2360.43530, -1535.56921, 23.56030,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 2360.40430, -1540.40894, 23.56030,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18232, 2365.27002, -1551.31006, 22.99000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(18452, 2360.37012, -1538.02002, 25.85000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3465, 2360.42993, -1535.18005, 24.37000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(3465, 2360.42993, -1540.80005, 24.37000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(910, 2357.75000, -1553.42004, 24.18000,   0.00000, 0.00000, 175.00000);
CreateDynamicObject(760, 2353.91992, -1552.07996, 23.00000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1338, 2359.48999, -1553.39001, 23.63000,   0.00000, 0.00000, 95.00000);
CreateDynamicObject(1617, 2360.25000, -1550.44995, 25.51000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(955, 2374.75000, -1539.02002, 23.39000,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2374.90991, -1542.50000, 23.33000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1223, 2363.54004, -1548.45996, 21.44000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1223, 2357.82007, -1540.80005, 22.72000,   0.00000, 0.00000, 25.00000);
CreateDynamicObject(1223, 2362.95996, -1535.23999, 22.72000,   0.00000, 0.00000, 225.00000);
CreateDynamicObject(1223, 2375.53003, -1536.77002, 21.12000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1223, 2375.38989, -1543.55005, 21.12000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(782, 2373.27002, -1553.63000, 23.03000,   0.00000, 0.00000, 0.00000);

//Rich Houses (Upgrade) Las Colinas - Los Flores

































































CreateDynamicObject(9325, 2619.32715, -1068.64233, 74.97400,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(9324, 2616.13525, -1094.26453, 74.60425,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2619.39331, -1106.00122, 67.77260,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2616.19043, -1105.97314, 67.77260,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2613.00879, -1105.94495, 67.77260,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2610.60815, -1105.92517, 67.77260,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2609.11816, -1104.40759, 67.77260,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2609.14844, -1101.20435, 67.77260,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2609.17822, -1098.02527, 67.77260,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2609.20264, -1094.92993, 67.77260,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2609.23462, -1091.72522, 67.77260,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2609.26050, -1088.55396, 67.77260,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2609.29395, -1085.47388, 67.77260,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2609.30566, -1083.62524, 67.77260,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2610.97314, -1082.13586, 67.77260,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2614.12866, -1082.16455, 67.77260,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2617.23877, -1082.20471, 67.77260,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2620.90015, -1104.50818, 67.77260,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2620.91943, -1101.37341, 67.77260,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2622.43018, -1099.76685, 67.77260,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2623.83423, -1099.75854, 67.60060,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2625.34058, -1098.18396, 66.82260,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(9325, 2620.69800, -1114.92114, 73.22260,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19355, 2629.82910, -1114.81348, 65.53530,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2628.29834, -1116.33813, 65.53530,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2627.33008, -1117.82080, 65.53530,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2625.75439, -1119.33936, 65.53530,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2622.62231, -1119.33643, 65.53530,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2616.31641, -1119.34473, 65.53530,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2619.44849, -1119.34229, 65.53530,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2614.04077, -1119.34399, 65.53530,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2612.51904, -1117.82080, 65.53530,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2612.51440, -1114.65210, 65.53530,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2612.52637, -1113.21997, 65.53530,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19355, 2614.08057, -1111.71252, 65.53530,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2617.19238, -1111.71533, 65.53530,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 2616.42090, -1110.08997, 65.53530,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1294, 2566.25488, -1039.05396, 72.98438,   3.14159, 0.00000, 1.58179);
CreateDynamicObject(3820, 2532.37598, -1063.99695, 73.11878,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3821, 2500.65405, -1066.63916, 74.01670,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1409, 2505.14844, -1059.73767, 69.31250,   3.14159, 0.00000, 0.00000);
CreateDynamicObject(3822, 2477.22168, -1062.76111, 70.37990,   0.00000, 0.00000, 256.61191);
CreateDynamicObject(3828, 2455.22437, -1053.44983, 61.66700,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(3827, 2434.73901, -1054.13354, 57.60370,   0.00000, 0.00000, 91.82620);
CreateDynamicObject(3830, 2430.40527, -1012.98981, 57.91110,   0.00000, 0.00000, 105.29092);
CreateDynamicObject(3829, 2457.04419, -1012.73138, 62.31690,   0.00000, 0.00000, 87.96570);
CreateDynamicObject(3828, 2487.16113, -1016.76971, 66.99805,   0.00000, 0.00000, 60.67220);
CreateDynamicObject(3845, 2506.18994, -1027.53381, 74.74180,   0.00000, 0.00000, 86.12754);
CreateDynamicObject(3824, 2539.49146, -1029.77905, 71.17370,   0.00000, 0.00000, 358.95377);
CreateDynamicObject(617, 2525.50659, -1033.81738, 67.95313,   3.14159, 0.00000, 1.67552);
CreateDynamicObject(3827, 2567.28467, -1029.22192, 72.95930,   0.00000, 0.00000, 90.66950);
CreateDynamicObject(3821, 2579.93091, -1030.84460, 73.38240,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1409, 2435.68628, -1023.73877, 54.21861,   3.03128, 0.00000, 3.14159);
CreateDynamicObject(1409, 2438.74341, -1043.55505, 54.57660,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1409, 2455.57788, -1047.09656, 58.64241,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3497, 2459.83813, -1018.32532, 61.71574,   0.00000, 0.00000, 176.96536);
CreateDynamicObject(1409, 2571.91870, -1034.97485, 68.69040,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1409, 2576.01563, -1042.47095, 68.68240,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1409, 2538.48511, -1035.16626, 68.69740,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(671, 2514.79126, -1025.66516, 68.89590,   356.85840, 0.00000, 0.00000);
CreateDynamicObject(671, 2495.60376, -1018.97510, 64.59901,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(671, 2438.41772, -1009.58856, 53.49680,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(671, 2465.94922, -1011.05450, 58.76979,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1481, 2440.13452, -1057.82019, 54.04671,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1265, 2438.21777, -1043.64490, 54.65347,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1211, 2517.70386, -1055.09839, 68.98692,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2545.52563, -1068.99011, 68.72701,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2521.29541, -1069.85510, 68.34375,   356.85840, 0.00000, -3.08051);
CreateDynamicObject(671, 2509.89355, -1070.43945, 69.44804,   356.85840, 0.00000, -1.04720);
CreateDynamicObject(669, 2484.69604, -1066.82080, 65.83433,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2462.20337, -1059.05005, 58.58395,   356.85840, 0.00000, -0.91630);
CreateDynamicObject(671, 2464.84277, -1055.94141, 58.73071,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2550.49951, -1027.20435, 68.27344,   3.14159, 0.00000, 1.94604);
CreateDynamicObject(759, 2525.42114, -1024.52454, 68.27344,   3.14159, 0.00000, 1.94604);
CreateDynamicObject(759, 2586.81567, -1027.08215, 68.56916,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(671, 2620.66846, -1076.99902, 68.60114,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2630.12842, -1060.11340, 68.59934,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2629.95630, -1078.18896, 68.61177,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2623.25049, -1086.27271, 68.60085,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2630.84229, -1103.29004, 67.79347,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2630.77197, -1107.45361, 67.43356,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2630.07422, -1120.61987, 65.62069,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2608.33130, -1112.71729, 66.05019,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2575.21313, -1060.49548, 68.52177,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2571.48120, -1076.40405, 68.14550,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(759, 2582.87402, -1060.64832, 68.58372,   0.00000, 0.00000, 0.00000);

//Eksterior city hall


































































CreateDynamicObject(19531, 1460.99414, -1800.76025, 12.42315,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(10377, 1480.47888, -1792.53467, 30.18291,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(10381, 1477.17371, -1847.36304, 24.41316,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(1250, 1495.23157, -1743.36182, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(1250, 1492.98096, -1743.33826, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(1250, 1490.80090, -1743.31543, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(1250, 1488.69092, -1743.29333, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(1250, 1486.35156, -1743.26880, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(8649, 1446.81494, -1742.48401, 13.19791,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8649, 1446.81494, -1756.97461, 13.19791,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8649, 1513.18457, -1742.48401, 13.20791,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(8649, 1542.76440, -1742.48401, 13.20791,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(8649, 1513.19458, -1756.97461, 13.19791,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(8649, 1417.37524, -1742.48401, 13.19791,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8649, 1542.83411, -1756.97461, 13.19791,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2773, 1483.49548, -1766.83752, 12.91687,   0.00001, 0.00001, -0.00007);
CreateDynamicObject(8649, 1399.34509, -1757.12402, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(8649, 1399.34509, -1786.75452, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(8649, 1399.34509, -1816.36426, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(8649, 1413.87500, -1862.08398, 13.19791,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(8649, 1428.35474, -1757.05469, 13.24791,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8649, 1413.84509, -1771.59326, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(8649, 1443.51392, -1862.08398, 13.19791,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(8649, 1443.51392, -1847.47449, 13.19791,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(19453, 1404.31958, -1819.43506, 10.84315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(8649, 1413.84509, -1801.04260, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(8649, 1559.34644, -1757.12402, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(8649, 1559.34644, -1786.72302, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(8649, 1559.34644, -1816.39270, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(8649, 1544.83459, -1862.08398, 13.19791,   0.00000, 0.00000, 810.00000);
CreateDynamicObject(8649, 1509.45483, -1862.08398, 13.19791,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(8649, 1538.95435, -1862.08398, 13.19791,   0.00000, 0.00000, 810.00000);
CreateDynamicObject(8132, 1480.81189, -1751.91406, 14.94303,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1250, 1484.18103, -1743.24597, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(1250, 1481.96106, -1743.22266, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(1250, 1479.62122, -1743.19836, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(1250, 1477.09167, -1743.17236, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(3810, 1477.22046, -1772.93384, 17.30150,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(3810, 1483.87146, -1772.93384, 17.27150,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2773, 1477.63513, -1766.83752, 12.91687,   0.00001, 0.00001, -0.00007);
CreateDynamicObject(964, 1462.60059, -1745.54846, 11.57039,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(984, 1505.01709, -1742.52124, 13.85687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1517.83704, -1742.52124, 13.85687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1530.66699, -1742.52124, 13.85687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1543.45740, -1742.52124, 13.85687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1553.05811, -1742.52124, 13.85687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1454.96704, -1742.52124, 13.85687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1442.16724, -1742.52124, 13.85687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1429.35693, -1742.52124, 13.85687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, 1498.55676, -1745.14673, 10.04315,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, 1498.55676, -1751.04626, 10.04315,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, 1498.55676, -1754.28650, 10.03315,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, 1461.48621, -1754.28650, 10.06315,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, 1461.48621, -1748.42651, 10.08315,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, 1461.48621, -1745.19592, 10.06315,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19426, 1461.88782, -1745.52197, 10.94315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1462.60852, -1746.23218, 10.95315,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(19426, 1463.32898, -1745.51221, 10.96315,   0.00000, -0.00001, 179.99995);
CreateDynamicObject(19426, 1462.60852, -1744.80188, 10.95315,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(964, 1462.60059, -1753.69812, 11.57039,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1461.88782, -1753.67163, 10.94315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1462.60852, -1754.38184, 10.95315,   0.00001, 0.00000, 89.99995);
CreateDynamicObject(19426, 1463.32898, -1753.66187, 10.96315,   0.00000, -0.00001, 179.99991);
CreateDynamicObject(19426, 1462.60852, -1752.95154, 10.95315,   0.00001, 0.00000, 89.99995);
CreateDynamicObject(640, 1509.64331, -1757.69702, 13.09315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(640, 1526.33411, -1757.69702, 13.05315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(8397, 1517.31689, -1766.62488, -25.54687,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(964, 1502.33032, -1779.11047, 11.50038,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1501.61755, -1779.08398, 10.87314,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1502.33826, -1779.79419, 10.88314,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(19426, 1503.05872, -1779.07422, 10.89314,   0.00000, -0.00001, 179.99995);
CreateDynamicObject(19426, 1502.33826, -1778.36389, 10.88314,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(964, 1508.83069, -1779.11047, 11.50038,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1508.11792, -1779.08398, 10.87314,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1508.83862, -1779.79419, 10.88314,   0.00001, 0.00000, 89.99995);
CreateDynamicObject(19426, 1509.55908, -1779.07422, 10.89314,   0.00000, -0.00001, 179.99991);
CreateDynamicObject(19426, 1508.83862, -1778.36389, 10.88314,   0.00001, 0.00000, 89.99995);
CreateDynamicObject(964, 1514.98157, -1779.11047, 11.50038,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(19426, 1514.26880, -1779.08398, 10.87314,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(19426, 1514.98950, -1779.79419, 10.88314,   0.00002, 0.00000, 89.99993);
CreateDynamicObject(19426, 1515.70996, -1779.07422, 10.89314,   0.00000, -0.00002, 179.99986);
CreateDynamicObject(19426, 1514.98950, -1778.36389, 10.88314,   0.00002, 0.00000, 89.99993);
CreateDynamicObject(964, 1458.25085, -1779.11047, 11.50038,   0.00000, 0.00003, 0.00000);
CreateDynamicObject(19426, 1457.53809, -1779.08398, 10.87314,   0.00000, 0.00003, 0.00000);
CreateDynamicObject(19426, 1458.25879, -1779.79419, 10.88314,   0.00003, 0.00000, 89.99991);
CreateDynamicObject(19426, 1458.97925, -1779.07422, 10.89314,   0.00000, -0.00003, 179.99982);
CreateDynamicObject(19426, 1458.25879, -1778.36389, 10.88314,   0.00003, 0.00000, 89.99991);
CreateDynamicObject(964, 1452.03064, -1779.11047, 11.50038,   0.00000, 0.00004, 0.00000);
CreateDynamicObject(19426, 1451.31787, -1779.08398, 10.87314,   0.00000, 0.00004, 0.00000);
CreateDynamicObject(19426, 1452.03857, -1779.79419, 10.88314,   0.00004, 0.00000, 89.99989);
CreateDynamicObject(19426, 1452.75903, -1779.07422, 10.89314,   0.00000, -0.00004, 179.99977);
CreateDynamicObject(19426, 1452.03857, -1778.36389, 10.88314,   0.00004, 0.00000, 89.99989);
CreateDynamicObject(964, 1445.93933, -1779.11047, 11.50038,   0.00000, 0.00005, 0.00000);
CreateDynamicObject(19426, 1445.22656, -1779.08398, 10.87314,   0.00000, 0.00005, 0.00000);
CreateDynamicObject(19426, 1445.94727, -1779.79419, 10.88314,   0.00005, 0.00000, 89.99986);
CreateDynamicObject(19426, 1446.66772, -1779.07422, 10.89314,   0.00000, -0.00005, 179.99973);
CreateDynamicObject(19426, 1445.94727, -1778.36389, 10.88314,   0.00005, 0.00000, 89.99986);
CreateDynamicObject(964, 1497.39063, -1745.60449, 11.52039,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1496.67786, -1745.57800, 10.89315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1497.39856, -1746.28821, 10.90315,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(19426, 1498.11902, -1745.56824, 10.91315,   0.00000, -0.00001, 179.99995);
CreateDynamicObject(19426, 1497.39856, -1744.85791, 10.90315,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(964, 1497.39063, -1753.53479, 11.52039,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1496.67786, -1753.50830, 10.89315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1497.39856, -1754.21851, 10.90315,   0.00001, 0.00000, 89.99995);
CreateDynamicObject(19426, 1498.11902, -1753.49854, 10.91315,   0.00000, -0.00001, 179.99991);
CreateDynamicObject(19426, 1497.39856, -1752.78821, 10.90315,   0.00001, 0.00000, 89.99995);
CreateDynamicObject(964, 1496.69055, -1774.08447, 11.52039,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(19426, 1495.97778, -1774.05798, 10.89315,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(19426, 1496.69849, -1774.76819, 10.90315,   0.00002, 0.00000, 89.99993);
CreateDynamicObject(19426, 1497.41895, -1774.04822, 10.91315,   0.00000, -0.00002, 179.99986);
CreateDynamicObject(19426, 1496.69849, -1773.33789, 10.90315,   0.00002, 0.00000, 89.99993);
CreateDynamicObject(964, 1464.64929, -1774.08447, 11.52039,   0.00000, 0.00003, 0.00000);
CreateDynamicObject(19426, 1463.93652, -1774.05798, 10.89315,   0.00000, 0.00003, 0.00000);
CreateDynamicObject(19426, 1464.65723, -1774.76819, 10.90315,   0.00003, 0.00000, 89.99991);
CreateDynamicObject(19426, 1465.37769, -1774.04822, 10.91315,   0.00000, -0.00003, 179.99982);
CreateDynamicObject(19426, 1464.65723, -1773.33789, 10.90315,   0.00003, 0.00000, 89.99991);
CreateDynamicObject(8649, 1544.72388, -1847.18420, 13.19791,   0.00000, 0.00000, 810.00000);
CreateDynamicObject(8649, 1515.20337, -1847.18420, 13.19791,   0.00000, 0.00000, 810.00000);
CreateDynamicObject(984, 1405.41602, -1742.52124, 12.61687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8397, 1440.18628, -1766.62488, -25.54687,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19538, 1549.56641, -1808.10242, 12.35659,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(964, 1403.51770, -1820.93005, 11.57039,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1402.80493, -1820.90356, 10.94315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1403.52563, -1821.61377, 10.95315,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(19426, 1404.24609, -1820.89380, 10.96315,   0.00000, -0.00001, 179.99995);
CreateDynamicObject(19426, 1403.52563, -1820.18347, 10.95315,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(984, 1416.54626, -1742.52124, 13.85687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1405.43604, -1742.52124, 13.85687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(966, 1398.65796, -1857.83557, 12.60315,   -0.00001, 0.00000, -90.89999);
CreateDynamicObject(968, 1398.65955, -1857.82080, 13.37224,   1.99999, 710.00000, -90.80000);
CreateDynamicObject(3498, 1398.78113, -1850.26538, 8.98316,   0.00000, 0.00001, -6.10000);
CreateDynamicObject(3498, 1398.77905, -1849.34875, 8.98315,   0.00000, 0.00001, -0.99999);
CreateDynamicObject(19797, 1398.70667, -1857.86206, 13.60316,   0.10001, 270.00000, 90.89995);
CreateDynamicObject(19797, 1398.70508, -1857.76245, 13.60316,   0.10001, 270.00000, 90.89995);
CreateDynamicObject(19797, 1398.65515, -1857.76294, 13.60307,   0.09999, 270.00000, -89.10001);
CreateDynamicObject(19797, 1398.65649, -1857.85278, 13.60307,   0.09999, 270.00000, -89.10001);
CreateDynamicObject(19620, 1398.72412, -1850.26953, 13.26315,   0.00000, 270.00000, -171.69997);
CreateDynamicObject(19620, 1398.76221, -1849.35327, 13.28316,   0.00000, 270.00000, -171.69997);
CreateDynamicObject(8649, 1399.34497, -1834.46448, 13.21791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19377, 1404.28711, -1854.12207, 11.86903,   0.00000, 83.19998, 180.00000);
CreateDynamicObject(964, 1410.03687, -1820.97400, 11.54038,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1409.32410, -1820.94751, 10.91314,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1410.04480, -1821.65771, 10.92314,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(19426, 1410.76526, -1820.93774, 10.93314,   0.00000, -0.00001, 179.99995);
CreateDynamicObject(19426, 1410.04480, -1820.22742, 10.92314,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(964, 1416.66736, -1820.97400, 11.54038,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1415.95459, -1820.94751, 10.91314,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1416.67529, -1821.65771, 10.92314,   0.00001, 0.00000, 89.99995);
CreateDynamicObject(19426, 1417.39575, -1820.93774, 10.93314,   0.00000, -0.00001, 179.99991);
CreateDynamicObject(19426, 1416.67529, -1820.22742, 10.92314,   0.00001, 0.00000, 89.99995);
CreateDynamicObject(964, 1423.31726, -1820.97400, 11.54038,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(19426, 1422.60449, -1820.94751, 10.91314,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(19426, 1423.32520, -1821.65771, 10.92314,   0.00002, 0.00000, 89.99993);
CreateDynamicObject(19426, 1424.04565, -1820.93774, 10.93314,   0.00000, -0.00002, 179.99986);
CreateDynamicObject(19426, 1423.32520, -1820.22742, 10.92314,   0.00002, 0.00000, 89.99993);
CreateDynamicObject(964, 1400.65588, -1829.89392, 11.54038,   0.00000, 0.00003, 0.00000);
CreateDynamicObject(19426, 1399.94312, -1829.86743, 10.91314,   0.00000, 0.00003, 0.00000);
CreateDynamicObject(19426, 1400.66382, -1830.57764, 10.92314,   0.00003, 0.00000, 89.99991);
CreateDynamicObject(19426, 1401.38428, -1829.85767, 10.93314,   0.00000, -0.00003, 179.99982);
CreateDynamicObject(19426, 1400.66382, -1829.14734, 10.92314,   0.00003, 0.00000, 89.99991);
CreateDynamicObject(964, 1400.65588, -1836.99451, 11.54038,   0.00000, 0.00004, 0.00000);
CreateDynamicObject(19426, 1399.94312, -1836.96802, 10.91314,   0.00000, 0.00004, 0.00000);
CreateDynamicObject(19426, 1400.66382, -1837.67822, 10.92314,   0.00004, 0.00000, 89.99989);
CreateDynamicObject(19426, 1401.38428, -1836.95825, 10.93314,   0.00000, -0.00004, 179.99977);
CreateDynamicObject(19426, 1400.66382, -1836.24792, 10.92314,   0.00004, 0.00000, 89.99989);
CreateDynamicObject(964, 1400.65588, -1843.96497, 11.54038,   0.00000, 0.00005, 0.00000);
CreateDynamicObject(19426, 1399.94312, -1843.93848, 10.91314,   0.00000, 0.00005, 0.00000);
CreateDynamicObject(19426, 1400.66382, -1844.64868, 10.92314,   0.00005, 0.00000, 89.99986);
CreateDynamicObject(19426, 1401.38428, -1843.92871, 10.93314,   0.00000, -0.00005, 179.99973);
CreateDynamicObject(19426, 1400.66382, -1843.21838, 10.92314,   0.00005, 0.00000, 89.99986);
CreateDynamicObject(964, 1405.80627, -1860.49670, 11.54038,   0.00000, 0.00006, 0.00000);
CreateDynamicObject(19426, 1405.09351, -1860.47021, 10.91314,   0.00000, 0.00006, 0.00000);
CreateDynamicObject(19426, 1405.81421, -1861.18042, 10.92314,   0.00006, 0.00000, 89.99982);
CreateDynamicObject(19426, 1406.53467, -1860.46045, 10.93314,   0.00000, -0.00006, 179.99963);
CreateDynamicObject(19426, 1405.81421, -1859.75012, 10.92314,   0.00006, 0.00000, 89.99982);
CreateDynamicObject(4641, 1401.07349, -1860.08826, 14.07687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(964, 1413.47681, -1860.49670, 11.54038,   0.00000, 0.00007, 0.00000);
CreateDynamicObject(19426, 1412.76404, -1860.47021, 10.91314,   0.00000, 0.00007, 0.00000);
CreateDynamicObject(19426, 1413.48474, -1861.18042, 10.92314,   0.00007, 0.00000, 89.99979);
CreateDynamicObject(19426, 1414.20520, -1860.46045, 10.93314,   0.00000, -0.00007, 179.99959);
CreateDynamicObject(19426, 1413.48474, -1859.75012, 10.92314,   0.00007, 0.00000, 89.99979);
CreateDynamicObject(964, 1421.59705, -1860.49670, 11.54038,   0.00000, 0.00008, 0.00000);
CreateDynamicObject(19426, 1420.88428, -1860.47021, 10.91314,   0.00000, 0.00008, 0.00000);
CreateDynamicObject(19426, 1421.60498, -1861.18042, 10.92314,   0.00008, 0.00000, 89.99977);
CreateDynamicObject(19426, 1422.32544, -1860.46045, 10.93314,   0.00000, -0.00008, 179.99954);
CreateDynamicObject(19426, 1421.60498, -1859.75012, 10.92314,   0.00008, 0.00000, 89.99977);
CreateDynamicObject(640, 1524.94373, -1778.09827, 13.09315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(640, 1530.79382, -1778.09827, 13.09315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(8649, 1544.69604, -1771.59326, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(8649, 1544.69604, -1801.15320, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(8649, 1544.69604, -1804.67358, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(640, 1450.17322, -1757.69702, 13.09315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(640, 1435.30261, -1757.69702, 13.09315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(640, 1421.06262, -1757.69702, 13.09315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(8649, 1443.51392, -1817.79541, 13.19791,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(19381, 1523.48157, -1842.21179, 7.22104,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(964, 1429.67114, -1860.49597, 11.53039,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1428.95837, -1860.46948, 10.90314,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1429.67908, -1861.17969, 10.91315,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(19426, 1430.39954, -1860.45972, 10.92315,   0.00000, -0.00001, 179.99995);
CreateDynamicObject(19426, 1429.67908, -1859.74939, 10.91315,   0.00001, 0.00000, 89.99998);
CreateDynamicObject(964, 1438.15173, -1860.49597, 11.53039,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1437.43896, -1860.46948, 10.90314,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19426, 1438.15967, -1861.17969, 10.91315,   0.00001, 0.00000, 89.99995);
CreateDynamicObject(19426, 1438.88013, -1860.45972, 10.92315,   0.00000, -0.00001, 179.99991);
CreateDynamicObject(19426, 1438.15967, -1859.74939, 10.91315,   0.00001, 0.00000, 89.99995);
CreateDynamicObject(964, 1438.15173, -1820.41577, 11.53039,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(19426, 1437.43896, -1820.38928, 10.90314,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(19426, 1438.15967, -1821.09949, 10.91315,   0.00002, 0.00000, 89.99993);
CreateDynamicObject(19426, 1438.88013, -1820.37952, 10.92315,   0.00000, -0.00002, 179.99986);
CreateDynamicObject(19426, 1438.15967, -1819.66919, 10.91315,   0.00002, 0.00000, 89.99993);
CreateDynamicObject(19426, 1413.86633, -1817.51880, 11.74314,   90.00000, 0.00000, 0.00000);
CreateDynamicObject(640, 1539.49365, -1757.69702, 13.09315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1250, 1474.80212, -1743.14844, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(1250, 1472.53149, -1743.12427, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(1250, 1470.19116, -1743.09998, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(1250, 1467.88171, -1743.07593, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(640, 1544.02405, -1768.23657, 13.04315,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(640, 1538.03357, -1785.03625, 13.04315,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(640, 1538.03357, -1791.07703, 13.04315,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(640, 1429.74329, -1778.09827, 13.09315,   -0.00001, 0.00000, -89.99998);
CreateDynamicObject(640, 1435.59338, -1778.09827, 13.09315,   -0.00001, 0.00000, -89.99998);
CreateDynamicObject(984, 1461.56128, -1748.64917, 13.19315,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(984, 1461.56128, -1750.23938, 13.19315,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(984, 1498.53137, -1748.64917, 13.19315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(984, 1498.53137, -1750.23938, 13.19315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(984, 1454.96704, -1756.96191, 13.16687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1442.19763, -1756.96191, 13.16687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1429.43713, -1756.96191, 13.16687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1420.52881, -1756.96191, 13.16687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1413.83899, -1763.55188, 13.16687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1413.83899, -1776.30225, 13.16687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1413.83899, -1789.06201, 13.16687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1413.83899, -1801.81201, 13.16687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1413.83899, -1813.06177, 13.16687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1399.36621, -1748.72144, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1399.36621, -1761.48083, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1399.36621, -1774.25073, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1399.36621, -1787.01013, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1399.36621, -1799.78040, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1399.36621, -1812.51990, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1399.36621, -1825.26990, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1399.36621, -1838.02002, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1399.36621, -1843.01965, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1559.43811, -1748.89099, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1559.43811, -1761.67078, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1559.43811, -1774.42041, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1559.43811, -1787.13074, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1559.43811, -1799.89063, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1505.18652, -1756.96191, 13.16687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1517.93665, -1756.96191, 13.16687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1530.68652, -1756.96191, 13.16687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1543.45557, -1756.96191, 13.16687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1553.02563, -1756.96191, 13.16687,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, 1547.84717, -1819.36658, 10.04315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, 1553.74658, -1819.36658, 10.04315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, 1556.13708, -1819.36658, 10.05315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, 1559.43677, -1850.38721, 10.05315,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19464, 1559.43677, -1859.41772, 10.05315,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19464, 1559.43677, -1855.09741, 10.06315,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1559.43811, -1812.63098, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1559.43811, -1824.81006, 13.85687,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1544.70776, -1763.56067, 13.19686,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1544.70776, -1776.32092, 13.19686,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1544.70776, -1789.09058, 13.19686,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1544.70776, -1801.84082, 13.19686,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(984, 1544.70776, -1813.03931, 13.19686,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(7091, 1487.28748, -1774.82971, 22.39696,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(7091, 1473.83826, -1774.82971, 22.41004,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(11245, 1486.44458, -1750.74951, 15.01081,   -1.10000, -68.89999, 37.50000);
CreateDynamicObject(8168, 1554.26367, -1822.20288, 14.19345,   0.00000, 0.00000, 377.00000);
CreateDynamicObject(19381, 1523.48157, -1832.59216, 7.22104,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19381, 1523.48157, -1822.97217, 7.22104,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19381, 1523.48157, -1813.34192, 7.22104,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19381, 1523.48157, -1772.97266, 7.22104,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19381, 1523.48157, -1763.43262, 7.22104,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19381, 1523.48157, -1753.84204, 7.22104,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(640, 1544.02405, -1810.09619, 13.03315,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(640, 1547.46460, -1820.08606, 13.09315,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(640, 1531.21472, -1817.94592, 13.09315,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(640, 1525.39575, -1817.94592, 13.09315,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(640, 1529.59607, -1846.41663, 13.09315,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(640, 1538.64526, -1846.41663, 13.09315,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(640, 1547.67542, -1846.41663, 13.09315,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(8649, 1544.82617, -1742.47351, 13.20791,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(8649, 1413.83398, -1742.48401, 13.19791,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19453, 1466.48010, -1742.21619, 10.80315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19453, 1476.08032, -1742.21619, 10.80315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19453, 1485.68018, -1742.21619, 10.80315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19453, 1495.27991, -1742.21619, 10.80315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1552.85791, -1862.07117, 13.85687,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1540.08777, -1862.07117, 13.85687,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1527.32788, -1862.07117, 13.85687,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1514.56763, -1862.07117, 13.85687,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1501.79773, -1862.07117, 13.85687,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1451.93701, -1862.07117, 13.85687,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1439.17761, -1862.07117, 13.85687,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1426.44763, -1862.07117, 13.85687,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1413.68738, -1862.07117, 13.85687,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1559.43225, -1855.99023, 13.19315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(1250, 1558.49927, -1845.19800, 12.50726,   0.00000, 0.00001, 269.39999);
CreateDynamicObject(984, 1559.43225, -1853.79028, 13.19315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(1250, 1558.51953, -1843.28809, 12.50726,   0.00000, 0.00001, 269.39999);
CreateDynamicObject(1250, 1558.54126, -1841.30774, 12.50726,   0.00000, 0.00001, 269.39999);
CreateDynamicObject(1250, 1558.56396, -1839.11804, 12.50726,   0.00000, 0.00001, 269.39999);
CreateDynamicObject(1250, 1558.58777, -1836.89795, 12.50726,   0.00000, 0.00001, 269.39999);
CreateDynamicObject(1250, 1558.60913, -1834.84814, 12.50726,   0.00000, 0.00001, 269.39999);
CreateDynamicObject(1250, 1558.63208, -1832.62842, 12.50726,   0.00000, 0.00001, 269.39999);
CreateDynamicObject(19453, 1559.53088, -1836.05627, 10.80315,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19453, 1559.53088, -1845.67627, 10.80315,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1250, 1465.44153, -1743.05054, 12.50726,   0.00000, 0.00001, -0.60000);
CreateDynamicObject(984, 1553.16833, -1847.15967, 13.19686,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1540.40759, -1847.15967, 13.19686,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1527.64722, -1847.15967, 13.19686,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1514.87756, -1847.15967, 13.19686,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1502.12793, -1847.15967, 13.19686,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19377, 1491.92529, -1857.55042, 12.45687,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, 1462.47546, -1857.55042, 12.45687,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19453, 1399.17004, -1863.73486, 10.79315,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(8649, 1413.84509, -1804.79395, 13.19791,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19355, 1410.72034, -1819.43689, 10.84315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19355, 1412.41992, -1819.44690, 10.84315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(984, 1405.75659, -1819.47046, 13.16687,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(984, 1407.35681, -1819.47046, 13.16687,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1942, 1456.70483, -1766.30115, 15.08688,   0.00000, 0.00002, 89.99997);
CreateDynamicObject(18655, 1456.76208, -1766.31812, 12.41687,   0.00000, 0.00001, 89.99997);
CreateDynamicObject(1942, 1456.82495, -1766.30115, 15.08688,   0.00000, 0.00002, 89.99997);
CreateDynamicObject(19825, 1456.64880, -1766.29834, 15.09687,   0.00000, -0.00002, -90.00008);
CreateDynamicObject(19825, 1456.85901, -1766.29834, 15.09687,   0.00000, 0.00002, 89.99997);
CreateDynamicObject(19812, 1456.75928, -1766.32605, 11.92687,   0.00000, 0.00001, 89.99997);
CreateDynamicObject(1942, 1427.39331, -1766.30115, 15.08688,   0.00001, 0.00002, 89.99995);
CreateDynamicObject(18655, 1427.45056, -1766.31812, 12.41687,   0.00001, 0.00001, 89.99995);
CreateDynamicObject(1942, 1427.51343, -1766.30115, 15.08688,   0.00001, 0.00002, 89.99995);
CreateDynamicObject(19825, 1427.33728, -1766.29834, 15.09687,   -0.00001, -0.00002, -90.00005);
CreateDynamicObject(19825, 1427.54749, -1766.29834, 15.09687,   0.00001, 0.00002, 89.99995);
CreateDynamicObject(19812, 1427.44775, -1766.32605, 11.92687,   0.00001, 0.00001, 89.99995);
CreateDynamicObject(1942, 1505.30249, -1766.30115, 15.08688,   0.00001, 0.00002, 89.99992);
CreateDynamicObject(18655, 1505.35974, -1766.31812, 12.41687,   0.00001, 0.00001, 89.99992);
CreateDynamicObject(1942, 1505.42261, -1766.30115, 15.08688,   0.00001, 0.00002, 89.99992);
CreateDynamicObject(19825, 1505.24646, -1766.29834, 15.09687,   -0.00001, -0.00002, -90.00003);
CreateDynamicObject(19825, 1505.45667, -1766.29834, 15.09687,   0.00001, 0.00002, 89.99992);
CreateDynamicObject(19812, 1505.35693, -1766.32605, 11.92687,   0.00001, 0.00001, 89.99992);
CreateDynamicObject(1942, 1531.69226, -1766.30115, 15.03688,   0.00003, 0.00002, 89.99988);
CreateDynamicObject(18655, 1531.74951, -1766.31812, 12.36687,   0.00003, 0.00001, 89.99988);
CreateDynamicObject(1942, 1531.81238, -1766.30115, 15.03688,   0.00003, 0.00002, 89.99988);
CreateDynamicObject(19825, 1531.63623, -1766.29834, 15.04687,   -0.00003, -0.00002, -89.99998);
CreateDynamicObject(19825, 1531.84644, -1766.29834, 15.04687,   0.00003, 0.00002, 89.99988);
CreateDynamicObject(19812, 1531.74670, -1766.32605, 11.87687,   0.00003, 0.00001, 89.99988);
CreateDynamicObject(640, 1422.79297, -1787.93713, 13.09315,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(19543, 1430.36438, -1749.64502, 12.54045,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19543, 1529.68628, -1749.64502, 12.54045,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19543, 1406.37488, -1788.18469, 12.54045,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19543, 1552.09607, -1788.18469, 12.54045,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(16061, 1436.67285, -1749.56445, 12.59324,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(16061, 1529.90356, -1749.56445, 12.59324,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(16061, 1406.70264, -1782.17456, 12.59324,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(16061, 1552.58228, -1782.17456, 12.59324,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(638, 1493.80127, -1773.98511, 14.16254,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(638, 1467.34045, -1773.98511, 14.16254,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1256, 1501.43945, -1757.90479, 13.07315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1256, 1517.92017, -1757.90479, 13.07315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1346, 1499.60535, -1741.40686, 13.85446,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1346, 1501.97559, -1741.40686, 13.85446,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1332, 1520.73901, -1780.01001, 13.42998,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1256, 1462.13477, -1749.28931, 13.04424,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(792, 1462.57422, -1745.50867, 12.48315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(792, 1462.57422, -1753.65833, 12.48315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(792, 1502.30396, -1779.07068, 12.41314,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(792, 1508.80432, -1779.07068, 12.41314,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(792, 1514.95520, -1779.07068, 12.41314,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(792, 1458.22449, -1779.07068, 12.41314,   0.00000, 0.00003, 0.00000);
CreateDynamicObject(792, 1452.00427, -1779.07068, 12.41314,   0.00000, 0.00004, 0.00000);
CreateDynamicObject(792, 1445.91296, -1779.07068, 12.41314,   0.00000, 0.00005, 0.00000);
CreateDynamicObject(2671, 1491.22083, -1739.58997, 12.55766,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2671, 1479.26111, -1739.58997, 12.55766,   0.00000, 0.00000, -156.30000);
CreateDynamicObject(1359, 1497.87170, -1742.79517, 13.10365,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1256, 1497.90601, -1749.28931, 13.04424,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(792, 1497.36426, -1745.56470, 12.43315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(792, 1497.36426, -1753.49500, 12.43315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(792, 1496.66418, -1774.04468, 12.43315,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(792, 1464.62292, -1774.04468, 12.43315,   0.00000, 0.00003, 0.00000);
CreateDynamicObject(16061, 1525.73267, -1852.71460, 12.59324,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1359, 1520.83582, -1757.76440, 13.09442,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1340, 1494.84424, -1757.48486, 13.55315,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(792, 1403.49133, -1820.89026, 12.48315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(792, 1410.01050, -1820.93420, 12.45315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(792, 1416.64099, -1820.93420, 12.45315,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(792, 1423.29089, -1820.93420, 12.45315,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(792, 1400.62952, -1829.85413, 12.45315,   0.00000, 0.00003, 0.00000);
CreateDynamicObject(792, 1400.62952, -1836.95471, 12.45315,   0.00000, 0.00004, 0.00000);
CreateDynamicObject(792, 1400.62952, -1843.92517, 12.45315,   0.00000, 0.00005, 0.00000);
CreateDynamicObject(792, 1405.77991, -1860.45691, 12.45315,   0.00000, 0.00006, 0.00000);
CreateDynamicObject(792, 1413.45044, -1860.45691, 12.45315,   0.00000, 0.00007, 0.00000);
CreateDynamicObject(792, 1421.57068, -1860.45691, 12.45315,   0.00000, 0.00008, 0.00000);
CreateDynamicObject(1332, 1440.03870, -1780.15015, 13.42998,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1256, 1532.75110, -1757.90479, 13.07315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1256, 1517.92017, -1777.20544, 13.07315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1256, 1506.10034, -1777.20544, 13.07315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1231, 1461.89368, -1743.47559, 13.31316,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1231, 1461.89368, -1755.83630, 13.31316,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19543, 1528.45667, -1854.87476, 12.53045,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1256, 1457.81946, -1757.90479, 13.07315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1256, 1442.66919, -1757.90479, 13.07315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1256, 1428.38879, -1757.90479, 13.07315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1256, 1454.87048, -1777.20544, 13.07315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1256, 1444.44080, -1777.20544, 13.07315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1359, 1534.80554, -1781.31494, 13.02442,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1687, 1517.63379, -1816.42114, 13.19411,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1687, 1517.48425, -1819.10132, 13.19411,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(792, 1429.64478, -1860.45618, 12.44314,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(19381, 1477.32141, -1826.54004, 8.41105,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(792, 1438.12537, -1860.45618, 12.44314,   0.00000, 0.00001, 0.00000);
CreateDynamicObject(792, 1438.12537, -1820.37598, 12.44314,   0.00000, 0.00002, 0.00000);
CreateDynamicObject(1342, 1431.72876, -1773.83374, 13.44315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1346, 1414.90149, -1761.45068, 13.75315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1346, 1414.90149, -1763.44092, 13.75315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1231, 1450.27344, -1757.67639, 13.31316,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1231, 1435.33301, -1757.67639, 13.31316,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1231, 1421.21252, -1757.67639, 13.31316,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1231, 1509.74231, -1757.67639, 13.31316,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1231, 1525.06250, -1757.67639, 13.31316,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1231, 1539.60278, -1757.67639, 13.31316,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1231, 1450.27344, -1777.40625, 13.31316,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1231, 1511.97375, -1777.40625, 13.31316,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1231, 1524.03357, -1777.40625, 13.31316,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1256, 1527.84009, -1777.20544, 13.07315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1211, 1488.47046, -1737.76221, 12.96821,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19279, 1480.82239, -1749.12744, 12.64849,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19279, 1480.82239, -1754.87720, 12.64849,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(18878, 1527.13977, -1832.23560, 27.39828,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(878, 1553.30042, -1774.81787, 13.13300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(878, 1553.30042, -1749.11743, 13.13300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(878, 1539.86023, -1749.11743, 13.13300,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(878, 1526.86060, -1749.11743, 13.13300,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(878, 1510.40039, -1749.11743, 13.13300,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(878, 1456.68994, -1749.11743, 13.13300,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(878, 1439.44971, -1749.11743, 13.13300,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(878, 1418.25940, -1749.11743, 13.13300,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(878, 1404.80957, -1749.11743, 13.13300,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(1256, 1543.92188, -1762.13452, 13.01315,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(1256, 1543.92188, -1776.14429, 12.98315,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(1341, 1463.47327, -1759.21875, 13.43316,   0.00000, 0.00000, -88.59998);
CreateDynamicObject(1257, 1465.70544, -1738.67639, 13.53688,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1483, 1441.58069, -1850.84558, 14.17292,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1483, 1441.58069, -1843.69482, 14.17292,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1483, 1441.58069, -1836.60498, 14.17292,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1286, 1478.02417, -1773.21265, 14.47805,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1287, 1477.26514, -1773.22546, 14.46031,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1223, 1478.02014, -1773.73962, 11.94692,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1223, 1482.96082, -1773.73962, 11.94692,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1216, 1484.54358, -1773.34485, 14.59138,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1216, 1483.50281, -1773.34485, 14.59138,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(18877, 1527.16516, -1832.30872, 27.30009,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1256, 1543.92188, -1817.23401, 13.00315,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(1256, 1531.48181, -1818.71362, 12.98315,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(1256, 1525.00159, -1818.71362, 12.98315,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(1256, 1525.00159, -1846.40430, 12.98315,   0.00000, 0.00000, 630.00000);
CreateDynamicObject(1256, 1534.11182, -1846.40430, 12.98315,   0.00000, 0.00000, 630.00000);
CreateDynamicObject(1256, 1543.16272, -1846.40430, 12.98315,   0.00000, 0.00000, 630.00000);
CreateDynamicObject(19543, 1475.31665, -1854.87476, 12.45045,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1359, 1543.91565, -1757.76440, 13.04442,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1359, 1544.22595, -1819.97546, 13.00442,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19316, 1536.68811, -1832.14624, 20.42659,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1538.29895, -1832.14624, 23.60659,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1538.86926, -1832.14624, 27.27659,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1538.34888, -1832.14624, 30.91659,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1536.71912, -1832.14624, 34.18657,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1534.11890, -1832.14624, 36.75657,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1530.76855, -1832.14624, 38.49655,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1527.13855, -1832.14624, 39.04654,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1523.60791, -1832.14624, 38.51653,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1520.26794, -1832.14624, 36.80653,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1517.68701, -1832.14624, 34.32655,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1516.02673, -1832.14624, 30.87655,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1515.43628, -1832.14624, 27.21655,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1516.06677, -1832.14624, 23.52654,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1520.27710, -1832.14624, 17.84653,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19316, 1523.62732, -1832.14624, 16.18653,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1340, 1543.50317, -1823.43091, 13.38659,   0.00000, 0.00000, -127.79998);
CreateDynamicObject(19316, 1530.79761, -1832.14624, 16.14653,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1688, 1533.88098, -1832.31836, 11.75957,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19868, 1514.78247, -1817.39978, 12.42315,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19868, 1517.38257, -1819.99036, 12.42315,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(19868, 1519.97241, -1817.39038, 12.42315,   0.00000, 0.00000, 450.00000);
CreateDynamicObject(927, 1518.45825, -1817.62219, 12.42315,   90.00000, 360.00000, 0.00000);
CreateDynamicObject(1635, 1509.58472, -1815.31055, 16.35315,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1231, 1498.14514, -1743.47559, 13.31316,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1231, 1498.18311, -1755.83630, 13.31316,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19978, 1394.39465, -1845.02576, 12.33687,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1359, 1398.71545, -1861.40552, 13.25688,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3660, 1420.20642, -1841.46130, 15.04315,   0.00000, 0.00000, 0.00000);

//Interior city hall
CreateDynamicObject(19377, -501.25000, 300.00000, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -511.74500, 299.99799, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19461, -505.16501, 306.32901, 1999.33899,   324.00000, 0.00000, 180.00000);
CreateDynamicObject(19397, -495.64600, 309.27100, 2001.83606,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19377, -490.75000, 300.00000, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19461, -489.23801, 309.26099, 2001.83606,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(19377, -501.25000, 314.01401, 2003.41101,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -490.75000, 314.01300, 2003.49902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -490.75000, 290.36499, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -501.25000, 290.36600, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -511.74600, 290.36499, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -511.74600, 314.01599, 2008.67102,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18762, -496.89301, 309.69000, 2006.08704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -505.57501, 309.69101, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19377, -511.74500, 309.62799, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19461, -497.30801, 306.32700, 1999.33997,   323.99200, 0.00000, 179.99400);
CreateDynamicObject(19461, -505.16699, 314.02200, 2001.83606,   0.00000, 0.00000, 359.98901);
CreateDynamicObject(19397, -506.83600, 309.27100, 2001.83606,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19377, -501.25000, 314.01099, 2003.50000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -511.74500, 314.01401, 2003.49902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -490.75000, 309.62799, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -501.25000, 309.62799, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19461, -513.24103, 309.27100, 2001.83606,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(18762, -521.36200, 309.68799, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -485.18301, 309.69601, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19461, -513.24103, 309.28101, 2010.33301,   0.00000, 179.99400, 89.99400);
CreateDynamicObject(19380, -501.24399, 314.01599, 2008.67102,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19461, -503.60999, 309.28400, 2010.33203,   0.00000, 179.99400, 89.99400);
CreateDynamicObject(19461, -493.97900, 309.28500, 2010.33203,   0.00000, 179.99400, 89.99400);
CreateDynamicObject(19461, -484.35199, 309.28500, 2010.33203,   0.00000, 179.99400, 89.99400);
CreateDynamicObject(19380, -511.74500, 299.99799, 2012.16797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -511.74600, 290.36499, 2012.16797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -511.74500, 309.62799, 2012.16797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -501.25000, 290.36499, 2012.16797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -501.25000, 299.99799, 2012.16797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -501.25000, 309.62799, 2012.16797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -490.75000, 299.99799, 2012.16797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -490.75000, 290.36499, 2012.16797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -490.75000, 309.62799, 2012.16797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, -516.90601, 290.36700, 2015.83398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19379, -516.90601, 299.99799, 2015.83398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19379, -516.90601, 309.62799, 2015.83398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19379, -485.58701, 300.00000, 2015.83398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19379, -485.58701, 290.36801, 2015.83398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19379, -485.58701, 309.62799, 2015.83398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19379, -512.17700, 285.63901, 2005.33704,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19379, -502.54700, 285.63800, 2005.33704,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19379, -492.91699, 285.63699, 2005.33704,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19379, -483.28500, 285.63599, 2005.33704,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19379, -512.17700, 285.63901, 2015.83398,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19379, -502.54700, 285.63800, 2015.83398,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19379, -492.91699, 285.63699, 2015.83398,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19379, -483.28500, 285.63599, 2015.83398,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19465, -501.25000, 331.91299, 2006.13904,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(18762, -521.36200, 313.77100, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -505.57501, 313.77100, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -505.57501, 313.77100, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -496.89401, 313.77100, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -485.18301, 313.77100, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -505.20499, 317.20499, 2006.13599,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19464, -497.26501, 317.20001, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -513.12201, 331.91299, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, -495.32401, 331.91699, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, -515.96899, 314.35699, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19377, -501.24399, 323.64001, 2003.50000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -511.74500, 323.64001, 2003.50000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -490.75000, 323.64001, 2003.50000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19465, -497.26501, 323.13501, 2006.13904,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19465, -505.20499, 323.13800, 2006.13904,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -497.26501, 329.07101, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -505.20401, 329.06201, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19377, -490.75000, 327.22000, 2003.49805,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -501.24399, 327.22000, 2003.49805,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -511.74500, 327.22000, 2003.49805,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19465, -501.25000, 314.35699, 2006.13904,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, -495.31299, 314.35699, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, -507.18600, 314.35800, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, -492.47101, 334.75699, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -510.02600, 334.75500, 2001.04102,   0.00000, 180.00000, 179.99400);
CreateDynamicObject(19464, -492.47000, 340.69000, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -510.02600, 334.75500, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -507.18600, 331.91299, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19380, -490.75000, 314.01599, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -490.75000, 323.64001, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -501.24399, 323.64001, 2008.67102,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -511.74500, 323.64001, 2008.67102,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -490.75000, 333.26501, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -501.24399, 333.26501, 2008.67102,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -511.74500, 333.26501, 2008.67102,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -511.74500, 342.89301, 2008.67102,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -501.24399, 342.89301, 2008.67102,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -490.75000, 342.89301, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19461, -516.89203, 314.17499, 2001.83606,   0.00000, 0.00000, 359.99399);
CreateDynamicObject(19377, -511.74500, 319.25900, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -501.25000, 319.26001, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -490.75000, 319.26001, 2000.00000,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19461, -512.16400, 318.90302, 2001.83606,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(19461, -502.53601, 318.90302, 2001.83606,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(19461, -492.90701, 318.90201, 2001.83606,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(19461, -483.27802, 318.90302, 2001.83606,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(19461, -497.29800, 314.18799, 2001.83606,   0.00000, 0.00000, 359.98901);
CreateDynamicObject(19461, -485.59601, 314.17999, 2001.83606,   0.00000, 0.00000, 359.98901);
CreateDynamicObject(19380, -510.50299, 314.17499, 2003.41101,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -520.99402, 314.02399, 2003.41101,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -491.96701, 314.17801, 2003.41101,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -481.47501, 314.17300, 2003.41101,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19464, -489.37701, 331.91299, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, -515.96899, 329.07101, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -486.53500, 329.07001, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -486.53500, 323.13501, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -486.53500, 317.20001, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -515.96899, 317.20001, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -489.37601, 314.35699, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, -515.96899, 323.13501, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -513.12201, 314.35800, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19446, -496.39801, 333.77899, 2003.49805,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -506.02802, 333.77802, 2003.49805,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -498.79001, 338.50601, 1999.41797,   325.50000, 0.00000, 0.00000);
CreateDynamicObject(19446, -503.68701, 338.50601, 1999.41797,   325.49701, 0.00000, 0.00000);
CreateDynamicObject(19446, -496.39700, 336.32901, 2002.82898,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -506.02802, 336.32901, 2002.82898,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -498.79001, 341.05899, 1998.74902,   325.49701, 0.00000, 0.00000);
CreateDynamicObject(19446, -503.69000, 341.05899, 1998.75000,   325.49701, 0.00000, 0.00000);
CreateDynamicObject(19446, -496.39801, 338.87701, 2002.16199,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -506.02802, 338.87601, 2002.16199,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -503.69000, 343.60501, 1998.08203,   325.49701, 0.00000, 0.00000);
CreateDynamicObject(19446, -498.78900, 343.60501, 1998.08203,   325.49701, 0.00000, 0.00000);
CreateDynamicObject(19446, -496.39801, 341.42899, 2001.49805,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -506.02802, 341.42899, 2001.49805,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -498.78900, 346.16199, 1997.42505,   325.49701, 0.00000, 0.00000);
CreateDynamicObject(19446, -503.69000, 346.16199, 1997.42505,   325.49701, 0.00000, 0.00000);
CreateDynamicObject(19446, -496.39801, 344.04001, 2000.83606,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -506.02802, 344.03900, 2000.83606,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -496.39999, 347.53699, 2000.83606,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -506.03299, 347.53799, 2000.83606,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -493.88400, 335.44101, 2001.83704,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19446, -508.58600, 335.44199, 2001.83704,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19446, -508.59201, 337.99301, 2001.16699,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19446, -493.88800, 337.99100, 2001.16699,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19446, -493.89099, 340.54001, 2000.50000,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19446, -508.59601, 340.54099, 2000.50000,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19446, -493.88501, 343.09201, 1999.83606,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19446, -508.59100, 343.09201, 1999.83606,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19446, -501.23499, 349.19601, 1999.83606,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19446, -506.03601, 351.03500, 2000.83606,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -496.40100, 351.03400, 2000.83606,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -501.23499, 350.86301, 2001.49805,   0.00000, 90.00000, 270.00000);
CreateDynamicObject(19446, -509.02802, 349.19601, 1997.42505,   325.49701, 0.00000, 90.00000);
CreateDynamicObject(19446, -493.43701, 349.19601, 1997.42505,   325.49100, 0.00000, 270.00000);
CreateDynamicObject(19464, -510.02600, 340.69000, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -492.47000, 340.68900, 2001.04102,   0.00000, 179.99400, 179.99400);
CreateDynamicObject(19464, -510.02499, 340.68900, 2001.04102,   0.00000, 179.99400, 179.99400);
CreateDynamicObject(19464, -492.47000, 334.75500, 2001.04102,   0.00000, 179.99400, 179.99400);
CreateDynamicObject(19464, -492.47000, 346.62201, 2001.04102,   0.00000, 179.99400, 179.99400);
CreateDynamicObject(19464, -510.02301, 346.62601, 2001.04102,   0.00000, 179.99400, 179.99400);
CreateDynamicObject(19464, -510.02301, 352.55899, 2001.04102,   0.00000, 179.99400, 179.99400);
CreateDynamicObject(19464, -492.46799, 352.55701, 2001.04102,   0.00000, 179.99400, 179.99400);
CreateDynamicObject(19464, -492.47000, 346.62201, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -492.47000, 352.55701, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -510.02301, 352.55600, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -510.02301, 346.62201, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -495.31299, 352.73801, 2001.04102,   0.00000, 179.99400, 269.99399);
CreateDynamicObject(19464, -501.25000, 352.73700, 2001.04102,   0.00000, 179.99400, 269.98901);
CreateDynamicObject(19464, -507.18600, 352.73700, 2001.04102,   0.00000, 179.99400, 269.98901);
CreateDynamicObject(19464, -507.18600, 352.73700, 2006.13599,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(19464, -501.25000, 352.73700, 2006.13599,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(19464, -495.31299, 352.73700, 2006.13599,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(19380, -490.74799, 352.52899, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -501.24399, 352.52899, 2008.67102,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -511.74500, 352.52899, 2008.67102,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18762, -510.92899, 299.99799, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -510.92899, 299.99799, 2001.08704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -510.92899, 299.99799, 2011.07800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -510.92899, 290.36700, 2001.08704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -510.92899, 290.36700, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -510.92899, 290.36700, 2011.07800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -491.43500, 299.99799, 2001.08704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -491.43500, 299.99799, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -491.43500, 299.99799, 2011.07800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -491.43500, 290.36700, 2001.08704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -491.43600, 290.36700, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -491.43500, 290.36700, 2011.07800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19359, -488.41000, 285.64200, 2002.60901,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -488.40900, 285.64200, 2006.10400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -488.40799, 285.64301, 2009.59802,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -494.39401, 285.64301, 2009.59802,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -494.39301, 285.64200, 2002.60901,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -494.39301, 285.64301, 2006.10400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -513.98401, 285.64301, 2009.59802,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -513.98297, 285.64301, 2002.60901,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -513.98297, 285.64301, 2006.10400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -507.85400, 285.64301, 2009.59802,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -507.85300, 285.64301, 2002.60901,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -507.85199, 285.64301, 2006.10400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -501.25101, 285.64301, 2006.10400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -501.25000, 285.64200, 2009.59802,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(18762, -504.36700, 295.65799, 2011.07800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -497.74701, 295.65799, 2001.08704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -504.36600, 295.65799, 2001.08704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -497.74701, 295.65799, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -497.74701, 295.65799, 2011.07800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -504.36600, 295.65799, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, -508.13501, 309.21301, 2004.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, -512.23401, 309.21600, 2004.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, -515.63000, 309.23099, 2004.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, -494.34799, 309.20901, 2004.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, -490.19000, 309.21201, 2004.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, -487.75900, 309.20901, 2004.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19461, -485.59500, 300.00000, 2001.83606,   0.00000, 0.00000, 359.98300);
CreateDynamicObject(19461, -485.59500, 290.36801, 2001.83606,   0.00000, 0.00000, 359.98300);
CreateDynamicObject(19461, -485.59500, 309.62799, 2010.33203,   0.00000, 179.99400, 359.98300);
CreateDynamicObject(19461, -485.59500, 290.36801, 2010.33203,   0.00000, 179.99400, 359.98300);
CreateDynamicObject(19461, -485.59500, 300.00000, 2010.33203,   0.00000, 179.99400, 359.97800);
CreateDynamicObject(19461, -485.59500, 309.62799, 2001.83606,   0.00000, 0.00000, 359.98300);
CreateDynamicObject(19461, -516.88800, 309.62799, 2001.83606,   0.00000, 0.00000, 359.98300);
CreateDynamicObject(19461, -516.88800, 300.00000, 2001.83606,   0.00000, 0.00000, 359.98901);
CreateDynamicObject(19461, -516.88800, 290.36801, 2001.83606,   0.00000, 0.00000, 359.98901);
CreateDynamicObject(19461, -516.88800, 290.36801, 2010.33203,   0.00000, 179.99400, 359.98300);
CreateDynamicObject(19461, -516.88800, 300.00000, 2010.33203,   0.00000, 179.99400, 359.98300);
CreateDynamicObject(19461, -516.88800, 309.62799, 2010.33203,   0.00000, 179.99400, 359.98300);
CreateDynamicObject(19377, -480.42899, 309.62799, 2003.49902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -480.42899, 300.00000, 2003.49902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -480.42899, 290.36801, 2003.49902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19464, -483.45001, 314.35800, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(18762, -485.18301, 299.99799, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -485.18201, 290.36700, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -480.98499, 313.73401, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -480.98499, 309.69501, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -480.98499, 299.99799, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -480.98499, 290.36700, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -521.98102, 301.20300, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19465, -521.98102, 295.26999, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -521.97998, 289.33701, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -521.98102, 283.40601, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19380, -480.42899, 309.62799, 2008.66699,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -480.42899, 300.00000, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -480.42899, 290.36801, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -469.92700, 290.36700, 2003.49902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19464, -521.98102, 307.13599, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -521.98102, 313.06201, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19377, -469.92700, 300.00000, 2003.49902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19464, -468.74399, 295.26999, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -468.74399, 289.33701, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -471.58099, 286.49701, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, -477.51901, 286.49701, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19380, -469.92700, 290.36801, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -469.92700, 300.00000, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(970, -516.81799, 307.12799, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(970, -516.81799, 302.95999, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(970, -516.81799, 298.78299, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(970, -516.81799, 294.60599, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(970, -516.81799, 290.42999, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(970, -516.81799, 286.25299, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19359, -471.09100, 286.54501, 2006.10400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -478.39001, 286.54199, 2006.10400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -474.74200, 286.53799, 2006.10400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19377, -522.05402, 309.62799, 2003.50305,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -522.05402, 300.00000, 2003.49902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -522.05402, 290.36801, 2003.49902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, -521.80402, 285.63800, 2005.33704,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19380, -522.05402, 309.62799, 2008.66699,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -522.05402, 300.00000, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -522.05402, 290.36801, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18762, -521.36200, 299.99799, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -521.36200, 290.36700, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -521.90302, 314.35800, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(18762, -517.29901, 313.77100, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -517.29901, 309.68799, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -517.29901, 299.99799, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -517.29901, 290.36700, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -480.61099, 313.06201, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -480.61099, 307.13599, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -480.61099, 301.20200, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19465, -480.60999, 295.26999, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -480.60999, 289.33701, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19464, -480.60999, 283.40500, 2006.13599,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19377, -532.55402, 300.00000, 2003.49902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, -532.55402, 290.36801, 2003.49902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19464, -525.07202, 286.49701, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, -531.00201, 297.16101, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, -533.84399, 289.33701, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -533.84399, 295.26999, 2006.13599,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19464, -525.07202, 297.16101, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19464, -531.00201, 286.49600, 2006.13599,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19380, -532.55402, 300.00000, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19380, -532.55402, 290.36801, 2008.66797,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19359, -524.17401, 286.54501, 2006.10400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -531.67902, 286.53699, 2006.10400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19359, -527.97101, 286.53601, 2006.10400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19395, -506.83701, 309.28400, 2001.83606,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(19459, -513.25403, 309.28400, 2001.83606,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19459, -513.54498, 314.02100, 2001.83606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19459, -505.17599, 314.18900, 2001.83606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19459, -510.07501, 318.89099, 2001.83606,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(970, -485.66299, 307.12799, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(970, -485.66501, 302.95999, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(970, -485.66501, 298.78299, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(970, -485.66501, 294.60599, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(970, -485.66400, 290.42999, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(970, -485.66400, 286.25299, 2004.13599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1502, -521.90503, 294.50500, 2003.57898,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1502, -480.64099, 294.50201, 2003.57800,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1502, -500.48401, 314.32501, 2003.58301,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1502, -506.04999, 309.28900, 2000.07898,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1502, -494.85999, 309.28601, 2000.07898,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19172, -513.94897, 314.22900, 2005.32898,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19172, -508.87799, 314.23901, 2005.32898,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19172, -493.69699, 314.23001, 2005.32898,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19172, -488.29501, 314.23199, 2005.32898,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19459, -506.85101, 318.29199, 2001.83606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1492, -506.77701, 313.79001, 2000.16199,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1492, -508.45001, 313.79001, 2000.16199,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19459, -508.52600, 318.29199, 2001.83606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1492, -510.12299, 313.79001, 2000.16199,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19459, -510.19901, 318.29199, 2001.83606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1492, -511.79501, 313.79001, 2000.16199,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19459, -511.86899, 318.29199, 2001.83606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1492, -513.46899, 313.79001, 2000.16199,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19452, -501.22198, 290.52701, 2000.00903,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19452, -501.22198, 300.16000, 2000.00903,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19452, -501.19000, 314.01999, 2003.50500,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19452, -501.19000, 323.64999, 2003.50500,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19452, -501.18399, 327.21701, 2003.50098,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(1492, -495.69199, 313.79001, 2000.16199,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19459, -497.28699, 314.18399, 2001.83606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19459, -492.38501, 318.89899, 2001.83606,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19459, -495.61899, 318.29199, 2001.83606,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1492, -494.01801, 313.79001, 2000.16199,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19459, -493.94400, 318.29199, 2001.83606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1492, -492.34601, 313.79001, 2000.16199,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19459, -492.26999, 318.29199, 2001.83606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1492, -490.67099, 313.79001, 2000.16199,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19459, -490.59601, 318.29199, 2001.83606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1492, -488.99701, 313.79001, 2000.16199,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19459, -488.92899, 314.17899, 2001.83606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19459, -489.22198, 309.28201, 2001.83606,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(19395, -495.64499, 309.28201, 2001.83606,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(18762, -505.82501, 319.37201, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -513.28400, 326.92200, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -505.83301, 326.92300, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, -513.28400, 319.43399, 2006.08398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1502, -505.12701, 322.36801, 2003.57800,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(19353, -491.76199, 331.87201, 2006.16797,   180.00000, -360.00000, 90.00000);
CreateDynamicObject(1502, -497.29501, 322.36899, 2003.57800,   0.00000, 0.00000, 89.99400);
CreateDynamicObject(1502, -500.48499, 331.87799, 2003.58301,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19445, -475.66901, 297.01599, 2002.68201,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19445, -466.03699, 297.01599, 2002.68201,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19445, -475.66901, 297.01599, 2009.53003,   0.00000, 180.00000, 90.00000);
CreateDynamicObject(19445, -466.04401, 297.01599, 2009.53003,   0.00000, 179.99400, 90.00000);
CreateDynamicObject(19445, -480.39700, 301.74200, 2005.33398,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19445, -480.39899, 301.73999, 2006.83704,   0.00000, 180.00000, 179.99400);
CreateDynamicObject(19445, -468.95999, 301.74301, 2005.33398,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(19445, -468.95700, 301.74301, 2006.83704,   0.00000, 179.99400, 179.99400);
CreateDynamicObject(19445, -475.69699, 301.89001, 2005.33398,   0.00000, 0.00000, 269.99399);
CreateDynamicObject(19445, -466.06900, 301.88901, 2005.33398,   0.00000, 0.00000, 269.98901);
CreateDynamicObject(19445, -475.48999, 301.89401, 2006.83704,   0.00000, 179.99400, 269.99399);
CreateDynamicObject(19445, -465.86499, 301.89401, 2006.83704,   0.00000, 179.99400, 269.98901);
CreateDynamicObject(19375, -475.28299, 301.74701, 2004.33997,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19375, -464.78601, 301.91699, 2004.33997,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19375, -464.78500, 301.91699, 2007.86902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19375, -475.28299, 301.74600, 2007.86902,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(953, -474.30399, 300.66501, 2005.32605,   8.00000, 0.00000, 0.00000);
CreateDynamicObject(19353, -531.63202, 297.12100, 2005.93604,   90.00000, 0.00000, 90.00000);
CreateDynamicObject(19353, -524.24701, 297.11700, 2005.93604,   90.00000, 0.00000, 90.00000);
CreateDynamicObject(14394, -501.25000, 305.92700, 2000.88904,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(14394, -501.25000, 308.15900, 2002.50903,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(14387, -501.23499, 336.64700, 2002.59302,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(14387, -501.23499, 339.19699, 2001.92603,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(14387, -501.23499, 341.74200, 2001.25598,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(14387, -501.23499, 344.31601, 2000.59302,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(14387, -507.17001, 351.62201, 2000.58704,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(14387, -495.29999, 351.64001, 2000.58704,   0.00000, 0.00000, 359.99399);
CreateDynamicObject(2173, -496.05499, 342.65799, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -509.42401, 342.66000, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -494.09500, 342.65799, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -509.42401, 334.95700, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -498.01901, 340.07800, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -498.01901, 337.52899, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -496.05499, 340.07800, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -496.05499, 337.52899, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -496.05499, 334.95599, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -494.09500, 340.07800, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -494.09500, 334.95599, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -498.01801, 342.65701, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -507.45999, 342.65799, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -505.49701, 342.65799, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -505.49701, 340.07800, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -505.49701, 337.52899, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -498.01801, 334.95599, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -507.45999, 340.07800, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -507.45999, 337.52899, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -505.49600, 334.95599, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -509.42401, 340.07800, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -509.42401, 337.52899, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -507.45999, 334.95599, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -502.89801, 349.69000, 2001.58301,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1722, -497.35001, 340.93399, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2205, -500.60101, 349.69601, 2001.58301,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(2173, -498.64700, 349.67899, 2001.58301,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(11245, -505.99301, 351.09601, 2006.91699,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(11245, -502.83301, 351.09601, 2006.91699,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(11245, -500.00500, 351.09601, 2006.91699,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(11245, -496.87201, 351.09601, 2006.91699,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1722, -495.65701, 340.89899, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -493.69101, 338.30801, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -493.66299, 341.01300, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2173, -494.09399, 337.52899, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -495.64700, 338.29501, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -497.57199, 338.32501, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -505.15799, 338.22601, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -506.96600, 338.21600, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -508.87601, 338.23801, 2002.24902,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -508.85800, 335.63199, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -507.04599, 335.57501, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -505.01099, 335.62299, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -504.94901, 332.98499, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -507.11801, 332.95801, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -497.50299, 332.85901, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -509.05701, 332.87601, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -497.50500, 335.62500, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -495.51801, 332.87100, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -493.61099, 332.89499, 2003.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -495.47900, 335.59698, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -493.69000, 335.58899, 2002.91602,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -507.07901, 340.73499, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -505.01401, 340.82599, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -508.92999, 340.77802, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1715, -503.51401, 351.14401, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1714, -501.34601, 351.18701, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1722, -501.29199, 296.92801, 2000.09399,   0.00000, 0.00000, 189.99699);
CreateDynamicObject(2008, -505.82101, 325.09698, 2003.58704,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(2207, -502.12799, 295.18799, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1239, -501.19000, 295.06201, 2000.47705,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1726, -509.89401, 291.38400, 2000.08606,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1726, -511.94400, 298.97900, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1726, -509.92401, 301.00900, 2000.08606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1726, -511.90201, 289.33200, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1726, -492.44901, 289.34601, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1726, -492.45401, 298.98401, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1726, -490.44000, 301.01901, 2000.08606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1726, -490.41599, 291.38101, 2000.08606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1808, -510.23199, 299.92700, 2000.08606,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1808, -510.25201, 290.33801, 2000.08606,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1808, -490.76901, 290.34100, 2000.08606,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1808, -490.75201, 299.97198, 2000.08606,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1808, -511.59799, 300.02899, 2000.08606,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1808, -511.59201, 290.36899, 2000.08606,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1808, -492.04901, 290.37201, 2000.08606,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1808, -492.13101, 300.02701, 2000.08606,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(11245, -505.48001, 308.69199, 2010.51599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(11245, -502.47601, 308.69199, 2010.51599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(11245, -499.63901, 308.69199, 2010.51599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(11245, -496.80200, 308.69199, 2010.51599,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2206, -475.51700, 288.81500, 2003.58398,   0.00000, 0.00000, 359.98901);
CreateDynamicObject(1714, -474.47501, 287.17099, 2003.58398,   0.00000, 0.00000, 200.00000);
CreateDynamicObject(14455, -469.06699, 287.29599, 2005.25598,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(14455, -533.55603, 291.63501, 2005.25598,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1763, -472.88800, 291.81100, 2003.58398,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1763, -475.95001, 290.53601, 2003.58398,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1763, -475.06699, 293.04901, 2003.58398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2614, -468.92001, 289.48300, 2007.76697,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2614, -480.44101, 289.44101, 2007.76697,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2206, -528.78601, 288.81601, 2003.58398,   0.00000, 0.00000, 359.98901);
CreateDynamicObject(2828, -475.32199, 288.97601, 2004.51904,   0.00000, 0.00000, 209.99800);
CreateDynamicObject(2357, -527.88300, 291.40799, 2003.97900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1714, -527.89502, 287.08499, 2003.58398,   0.00000, 0.00000, 199.99500);
CreateDynamicObject(14455, -480.34100, 291.64099, 2005.25598,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(14455, -522.25702, 287.29501, 2005.25598,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1715, -498.95401, 351.03601, 2001.58301,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1715, -526.07202, 289.98801, 2003.58398,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1715, -525.94000, 291.39801, 2003.58398,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1715, -526.01001, 292.66901, 2003.58398,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1715, -529.57703, 292.63800, 2003.58398,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1715, -529.58002, 291.35101, 2003.58398,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1715, -529.59100, 289.97501, 2003.58398,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1715, -527.81799, 294.71701, 2003.58398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14662, -510.12601, 311.13101, 2001.98401,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14662, -514.03302, 311.13000, 2001.98499,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14629, -509.61499, 302.82999, 2011.07898,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1999, -506.76300, 314.98901, 2003.58398,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2009, -507.82501, 317.86401, 2003.58398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2183, -510.89899, 328.45599, 2003.58704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2207, -492.80301, 326.63501, 2003.58704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2207, -490.94901, 328.56100, 2003.58704,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2608, -505.55801, 317.91400, 2004.29602,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2161, -515.35602, 331.79001, 2003.58704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2162, -512.24701, 331.79901, 2003.58704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2163, -510.47299, 331.78201, 2003.58704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2164, -514.02100, 331.77600, 2003.58704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2167, -513.37201, 314.40701, 2003.58398,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2197, -514.12701, 315.79901, 2003.58398,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1715, -493.54099, 325.93201, 2003.58704,   0.00000, 0.00000, 132.00000);
CreateDynamicObject(2008, -506.83801, 321.28101, 2003.58704,   0.00000, 0.00000, 359.99399);
CreateDynamicObject(3857, -509.07001, 319.35901, 2006.49902,   0.00000, 0.00000, 45.00000);
CreateDynamicObject(3857, -509.06900, 319.35800, 2006.49902,   0.00000, 0.00000, 44.99400);
CreateDynamicObject(3857, -516.77802, 319.44601, 2008.83704,   0.00000, 0.00000, 44.98900);
CreateDynamicObject(3857, -516.77802, 319.44601, 2008.83704,   0.00000, 0.00000, 44.98900);
CreateDynamicObject(3857, -509.06900, 319.35800, 2006.49902,   0.00000, 0.00000, 224.99400);
CreateDynamicObject(3857, -509.06900, 319.35800, 2006.49902,   0.00000, 0.00000, 224.98900);
CreateDynamicObject(1722, -506.52200, 317.74301, 2003.58398,   0.00000, 0.00000, 50.00000);
CreateDynamicObject(1722, -507.45901, 315.56900, 2003.58606,   0.00000, 0.00000, 159.99800);
CreateDynamicObject(2009, -510.09201, 317.86301, 2003.58398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2009, -512.29303, 317.86301, 2003.58398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1999, -509.03101, 314.99799, 2003.58398,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1999, -511.31699, 314.99701, 2003.58398,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1722, -509.27802, 318.41101, 2003.58398,   0.00000, 0.00000, 359.99799);
CreateDynamicObject(1722, -511.59201, 317.62701, 2003.58398,   0.00000, 0.00000, 349.99399);
CreateDynamicObject(2608, -505.55899, 316.03201, 2004.29602,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(3857, -509.22198, 326.92001, 2006.49902,   0.00000, 0.00000, 44.99400);
CreateDynamicObject(3857, -509.22198, 326.91901, 2006.49902,   0.00000, 0.00000, 44.99400);
CreateDynamicObject(3857, -509.22198, 326.91901, 2006.49902,   0.00000, 0.00000, 44.99400);
CreateDynamicObject(3857, -509.22198, 326.91901, 2006.49902,   0.00000, 0.00000, 224.99400);
CreateDynamicObject(3857, -509.22198, 326.91901, 2006.49902,   0.00000, 0.00000, 224.98900);
CreateDynamicObject(3857, -517.05402, 326.93301, 2008.83704,   0.00000, 0.00000, 44.99400);
CreateDynamicObject(3857, -517.05402, 326.93201, 2008.83704,   0.00000, 0.00000, 44.98900);
CreateDynamicObject(2197, -514.81500, 315.80301, 2003.58398,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(2197, -515.49500, 315.80301, 2003.58398,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1722, -510.37201, 327.77301, 2003.58398,   0.00000, 0.00000, 349.99100);
CreateDynamicObject(1722, -508.37299, 327.27399, 2003.58398,   0.00000, 0.00000, 19.99100);
CreateDynamicObject(1722, -508.25500, 330.31900, 2003.58398,   0.00000, 0.00000, 149.98900);
CreateDynamicObject(1722, -510.28500, 330.26001, 2003.58398,   0.00000, 0.00000, 189.98500);
CreateDynamicObject(2162, -508.69601, 331.79901, 2003.58704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2167, -506.92401, 331.78299, 2003.58398,   0.00000, 0.00000, 359.99399);
CreateDynamicObject(2167, -506.00500, 331.78201, 2003.58398,   0.00000, 0.00000, 359.98901);
CreateDynamicObject(2737, -505.36801, 328.76999, 2004.92200,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2008, -508.20001, 325.09799, 2003.58704,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(2008, -510.57501, 325.10101, 2003.58704,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1722, -506.58200, 326.19501, 2003.58398,   0.00000, 0.00000, 169.98900);
CreateDynamicObject(1722, -508.92499, 326.79501, 2003.58398,   0.00000, 0.00000, 179.98500);
CreateDynamicObject(1722, -510.85800, 325.77301, 2003.58398,   0.00000, 0.00000, 199.98300);
CreateDynamicObject(2008, -509.21600, 321.29001, 2003.58704,   0.00000, 0.00000, 359.98901);
CreateDynamicObject(2008, -511.65100, 321.29501, 2003.58704,   0.00000, 0.00000, 359.98901);
CreateDynamicObject(1722, -511.21701, 320.76501, 2003.58398,   0.00000, 0.00000, 349.97800);
CreateDynamicObject(1722, -508.54001, 320.78201, 2003.58398,   0.00000, 0.00000, 9.97400);
CreateDynamicObject(1722, -505.90799, 319.96600, 2003.58398,   0.00000, 0.00000, 9.97000);
CreateDynamicObject(1715, -491.82999, 325.17499, 2003.58704,   0.00000, 0.00000, 183.99699);
CreateDynamicObject(1715, -489.35999, 327.70001, 2003.58704,   0.00000, 0.00000, 273.98999);
CreateDynamicObject(1715, -490.33499, 329.45499, 2003.58704,   0.00000, 0.00000, 321.98801);
CreateDynamicObject(1715, -491.91501, 329.92499, 2003.58704,   0.00000, 0.00000, 1.98700);
CreateDynamicObject(1715, -493.56100, 329.11801, 2003.58704,   0.00000, 0.00000, 49.98300);
CreateDynamicObject(1715, -494.26801, 327.56900, 2003.58704,   0.00000, 0.00000, 91.98200);
CreateDynamicObject(14455, -486.83899, 326.76999, 2005.25598,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(14455, -497.00500, 331.11700, 2005.25598,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2332, -468.70300, 287.35001, 2004.04700,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2518, -507.91501, 309.86499, 2000.08606,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2518, -509.93701, 309.86801, 2000.08606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(2518, -511.81900, 309.86801, 2000.08606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(14662, -493.54800, 311.13101, 2001.98499,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14662, -489.58899, 311.13101, 2001.98499,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2518, -493.35101, 309.86801, 2000.08606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(2518, -491.32101, 309.86700, 2000.08606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(2518, -489.34201, 309.86801, 2000.08606,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(2528, -512.72302, 318.29901, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2528, -511.05701, 318.30301, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2528, -509.38199, 318.31500, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2528, -507.73599, 318.32901, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2528, -506.04401, 318.33801, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2528, -496.42999, 318.31601, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2528, -494.75101, 318.32401, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2528, -493.07901, 318.32001, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2528, -491.42099, 318.31299, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2528, -489.77701, 318.30701, 2000.08606,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18075, -501.15701, 323.42001, 2008.58398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18075, -497.57501, 341.56601, 2008.58398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18075, -504.62100, 341.55399, 2008.58398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18075, -492.02499, 323.22501, 2008.58398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18075, -512.10901, 323.08899, 2008.58398,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19171, -527.17902, 297.04999, 2005.13696,   90.00000, 0.00000, 0.00000);
CreateDynamicObject(19170, -528.67700, 297.04999, 2005.13599,   90.00000, 0.00000, 0.00000);
CreateDynamicObject(19169, -527.17902, 297.04999, 2006.63501,   90.00000, 0.00000, 0.00000);
CreateDynamicObject(19168, -528.67700, 297.04999, 2006.63501,   90.00000, 0.00000, 0.00000);
CreateDynamicObject(3858, -473.20401, 296.93701, 2007.25098,   0.00000, 0.00000, 225.00000);
CreateDynamicObject(3858, -473.20401, 296.93600, 2007.25098,   0.00000, 0.00000, 225.00000);
CreateDynamicObject(7616, -410.31900, 364.02200, 2003.69299,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(758, -477.95401, 300.29501, 2004.83997,   0.00000, 0.00000, 260.00000);
CreateDynamicObject(746, -470.44400, 300.42801, 2004.85498,   346.00000, 0.00000, 210.00000);
CreateDynamicObject(953, -472.63901, 300.77399, 2005.41101,   8.99800, 0.00000, 340.00000);
CreateDynamicObject(1600, -478.18799, 299.34500, 2006.06897,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1600, -470.19101, 298.83701, 2005.40100,   0.00000, 0.00000, 110.00000);
CreateDynamicObject(1599, -475.45999, 300.45001, 2005.85400,   0.00000, 0.00000, 280.00000);
CreateDynamicObject(1599, -471.35800, 301.21399, 2006.52197,   0.00000, 0.00000, 109.99700);
CreateDynamicObject(1601, -474.45801, 298.01099, 2005.20801,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1601, -477.45700, 299.38000, 2005.20801,   0.00000, 0.00000, 110.00000);
CreateDynamicObject(1605, -474.36801, 300.78201, 2006.09497,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1606, -475.85101, 298.33401, 2006.95105,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(10444, -473.06699, 301.69101, 2005.25000,   90.00000, 90.00000, 271.50000);
CreateDynamicObject(3858, -473.20401, 296.93600, 2007.25098,   0.00000, 0.00000, 225.00000);
CreateDynamicObject(19166, -468.87701, 294.63699, 2005.41199,   0.00000, 270.00000, 0.00000);
CreateDynamicObject(2894, -474.50800, 288.76901, 2004.52100,   0.00000, 0.00000, 209.99800);
CreateDynamicObject(14455, -533.55902, 296.35400, 2005.25598,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(14455, -496.96100, 320.56000, 2005.25598,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(14455, -494.10901, 314.68701, 2005.25598,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14455, -486.79901, 316.21701, 2005.25598,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19166, -486.66501, 323.61099, 2005.25598,   0.00000, 270.00000, 0.00000);
CreateDynamicObject(1704, -487.42099, 314.98499, 2003.58398,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1723, -492.85800, 317.16101, 2003.58398,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1704, -495.41000, 314.95001, 2003.58398,   0.00000, 0.00000, 179.99400);
CreateDynamicObject(1723, -490.82599, 318.12201, 2003.58398,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1723, -492.87100, 320.13400, 2003.58398,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(2001, -491.85001, 320.30301, 2003.58704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, -522.32001, 293.42899, 2003.58704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2010, -476.15701, 292.86700, 2003.57800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2001, -479.96799, 293.32501, 2003.58704,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2010, -472.82001, 292.95499, 2003.57800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1726, -504.54999, 317.26801, 2003.59204,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1726, -504.56601, 326.92099, 2003.59204,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1726, -497.91599, 328.83401, 2003.59204,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1726, -497.91000, 319.33401, 2003.59204,   0.00000, 0.00000, 270.00000);
CreateDynamicObject(1500, -501.95380, 285.72791, 2000.11646,   0.00000, 0.00000, 0.00000);

//Dealer mobil deket pantai
















CreateDynamicObject(19447, 1020.41925, -1783.75928, 13.17130,   0.00000, 90.00000, 71.28425);
CreateDynamicObject(19447, 1011.58673, -1780.73560, 13.17130,   0.00000, 90.00000, 71.28425);
CreateDynamicObject(19447, 1002.59729, -1777.98328, 13.17130,   0.00000, 90.00000, 75.36358);
CreateDynamicObject(19447, 993.25323, -1775.55371, 13.17130,   0.00000, 90.00000, 76.58881);
CreateDynamicObject(19373, 1024.94629, -1774.78735, 13.17134,   0.00000, 90.00000, 354.79739);
CreateDynamicObject(19373, 1024.69067, -1777.97583, 13.17134,   0.00000, 90.00000, 355.20346);
CreateDynamicObject(19373, 1024.38611, -1781.10535, 13.17134,   0.00000, 90.00000, 354.70352);
CreateDynamicObject(19373, 1024.01575, -1784.27856, 13.17134,   0.00000, 90.00000, 353.88016);
CreateDynamicObject(18762, 1015.83228, -1742.20715, 14.49313,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1015.83887, -1749.78784, 14.49313,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1015.77344, -1756.67615, 14.49313,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1015.48981, -1764.21191, 14.49313,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1007.81921, -1764.49036, 14.49313,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1006.83374, -1764.49854, 14.49310,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1005.99170, -1764.48877, 14.49310,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1005.06207, -1764.49487, 14.49310,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1001.36694, -1764.41443, 14.49310,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1000.37744, -1764.41833, 14.49310,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 999.40045, -1764.42432, 14.49310,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 991.77106, -1764.18103, 14.49310,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 991.31506, -1756.87976, 14.49310,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 991.26794, -1749.34326, 14.49310,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 991.18347, -1741.74048, 14.49310,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1026.84741, -1764.23120, 11.75750,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1026.62000, -1773.28882, 11.75750,   0.00000, 0.00000, 357.45953);
CreateDynamicObject(18762, 1025.19104, -1787.73474, 11.75750,   0.00000, 0.00000, 342.40811);
CreateDynamicObject(18762, 1011.95819, -1782.70972, 11.75750,   0.00000, 0.00000, 341.17764);
CreateDynamicObject(18762, 998.94965, -1779.10791, 11.75750,   0.00000, 0.00000, 344.86823);
CreateDynamicObject(18762, 988.53729, -1776.35583, 11.75750,   0.00000, 0.00000, 344.86823);
CreateDynamicObject(18762, 979.14380, -1774.33838, 11.75750,   0.00000, 0.00000, 344.86823);
CreateDynamicObject(18762, 1027.09277, -1742.22192, 11.75750,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1027.09229, -1730.27600, 11.75750,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1027.07178, -1718.07947, 11.75750,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18766, 1016.36774, -1784.29797, 11.21255,   0.00000, 0.00000, 338.99707);
CreateDynamicObject(18766, 1020.03448, -1785.68799, 11.21358,   0.00000, 0.00000, 338.99707);
CreateDynamicObject(18766, 1026.02393, -1778.20483, 11.21864,   0.00000, 0.00000, 264.48987);
CreateDynamicObject(18766, 1025.52930, -1783.03931, 11.21256,   0.00000, 0.00000, 264.48987);
CreateDynamicObject(18981, 1027.05847, -1730.38708, 1.22420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18981, 1027.05908, -1752.15173, 1.22420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18981, 1000.16229, -1779.43079, 1.22420,   0.00000, 0.00000, 74.98296);
CreateDynamicObject(18981, 979.65686, -1730.01831, 0.71410,   0.00000, 0.00000, 359.69696);
CreateDynamicObject(18981, 979.38702, -1753.80627, 0.71410,   0.00000, 0.00000, 359.18787);
CreateDynamicObject(18981, 979.24402, -1762.77698, 0.61107,   -4.00000, 0.00000, 359.49902);
CreateDynamicObject(19377, 1005.49359, -1734.79175, 14.02930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19377, 995.61237, -1739.64441, 14.02930,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19377, 1010.99628, -1729.94543, 14.02930,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19377, 1010.10211, -1729.96533, 14.02930,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19435, 1015.76337, -1740.96582, 14.01233,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19435, 1015.77429, -1730.68726, 17.24580,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19435, 1015.77429, -1730.68726, 14.01233,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19435, 990.91028, -1740.46741, 17.50832,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19435, 990.93024, -1740.46643, 14.01233,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19435, 1015.77307, -1731.82202, 14.03230,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19435, 1015.76337, -1740.96582, 17.25164,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19435, 1015.75189, -1739.82361, 14.01233,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19391, 1007.17383, -1739.52222, 13.74200,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19362, 1007.17273, -1739.52136, 17.11460,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19377, 995.58832, -1729.98621, 14.02930,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19454, 1000.63068, -1729.97058, 17.38064,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19377, 990.80493, -1734.81384, 14.02930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19363, 1024.99768, -1773.16248, 11.78050,   0.00000, 0.00000, 86.43437);
CreateDynamicObject(19363, 988.64954, -1774.24976, 11.78050,   0.00000, 0.00000, 165.98720);
CreateDynamicObject(19363, 988.46039, -1774.99268, 11.78251,   0.00000, 0.00000, 165.98720);
CreateDynamicObject(19453, 1022.99042, -1777.80725, 11.78050,   0.00000, 0.00000, 354.94391);
CreateDynamicObject(19453, 1018.03998, -1781.03357, 11.78050,   0.00000, 0.00000, 71.45248);
CreateDynamicObject(19453, 1008.89642, -1777.99536, 11.78050,   0.00000, 0.00000, 71.65752);
CreateDynamicObject(19453, 999.67737, -1775.33020, 11.78050,   0.00000, 0.00000, 76.16116);
CreateDynamicObject(19453, 993.66156, -1773.87329, 11.78050,   0.00000, 0.00000, 76.16116);
CreateDynamicObject(19454, 1015.76373, -1735.39063, 16.97456,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19454, 1015.76117, -1735.47070, 11.78049,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19454, 1013.94977, -1739.49902, 13.84240,   90.00000, 0.00000, 90.00000);
CreateDynamicObject(19454, 1010.47113, -1739.50964, 13.84445,   90.00000, 0.00000, 90.00000);
CreateDynamicObject(19454, 1000.70825, -1739.60840, 17.38064,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(18981, 1006.78668, -1756.30847, 16.87212,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18981, 999.38605, -1756.30408, 16.87212,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18981, 1003.63684, -1742.57971, 18.65765,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18981, 999.41571, -1742.46851, 16.87212,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18981, 1006.71558, -1742.48633, 16.87212,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18981, 1003.61987, -1742.56909, 17.71042,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, 1005.34192, -1734.71338, 14.02930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19538, 1000.94843, -1728.11157, 12.36150,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19452, 984.01190, -1773.89783, 12.63130,   0.06000, 108.00000, 76.59396);
CreateDynamicObject(19452, 1025.29492, -1769.37793, 12.22930,   0.00000, 98.00000, 179.00000);
CreateDynamicObject(19378, 1010.50616, -1734.70923, 12.39747,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(5779, 1002.88519, -1730.03467, 15.64933,   0.00000, 103.00000, 90.00000);
CreateDynamicObject(10183, 1025.31458, -1744.54736, 12.37280,   0.00000, 0.00000, 315.92850);
CreateDynamicObject(2008, 1012.38727, -1737.34924, 12.44882,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2008, 1012.42194, -1733.82141, 12.44984,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1721, 1013.64557, -1733.29297, 12.46490,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1721, 1013.59601, -1736.81299, 12.46490,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2163, 1006.53400, -1730.09534, 12.48273,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2164, 1008.50806, -1730.06702, 12.48270,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2167, 1010.56207, -1730.09790, 12.48270,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2164, 1011.82391, -1730.13770, 12.48270,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(11685, 1006.02734, -1736.36975, 12.46380,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(11685, 1006.01239, -1735.06787, 12.46380,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(11685, 1006.02325, -1733.76318, 12.46380,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(11685, 1006.01752, -1732.49377, 12.46380,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19872, 994.81982, -1736.82007, 11.56760,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19872, 994.85052, -1733.31335, 11.56760,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19872, 999.21002, -1733.29175, 10.74320,   21.00000, 0.00000, 90.00000);
CreateDynamicObject(19872, 999.19556, -1736.82214, 10.74320,   21.00000, 0.00000, 90.00000);
CreateDynamicObject(19872, 995.38202, -1747.42041, 10.94930,   8.00000, 0.00000, 54.00000);
CreateDynamicObject(19872, 995.85266, -1754.85132, 10.94930,   8.00000, 0.00000, 54.00000);
CreateDynamicObject(19872, 995.18903, -1761.75513, 10.94930,   8.00000, 0.00000, 54.00000);
CreateDynamicObject(19872, 1011.15540, -1745.50720, 10.94930,   8.00000, 0.00000, -54.00000);
CreateDynamicObject(19872, 1011.72455, -1753.82483, 10.94930,   8.00000, 0.00000, -54.00000);
CreateDynamicObject(19872, 1011.38940, -1761.06372, 10.94930,   8.00000, 0.00000, -54.00000);
CreateDynamicObject(1232, 979.25995, -1774.37646, 12.20031,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 988.47723, -1776.53064, 12.20031,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 998.82751, -1779.33472, 12.20031,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 1012.03455, -1782.89380, 12.20031,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 1025.22119, -1787.77478, 12.20031,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 1026.66809, -1773.33667, 12.20031,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 1026.88330, -1764.21497, 12.20031,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 1027.10242, -1742.22351, 12.20031,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 1027.13770, -1730.19922, 12.20031,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 1027.23853, -1718.21594, 12.20031,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(4594, 1003.38696, -1726.91785, -9.97058,   0.00000, 0.00000, 359.90100);
CreateDynamicObject(19379, 996.04602, -1734.79211, 12.32330,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19379, 1000.10797, -1734.78125, 12.32330,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(811, 990.37854, -1774.68372, 14.20047,   0.00000, 0.00000, -40.00000);
CreateDynamicObject(811, 994.89893, -1775.97339, 14.20047,   0.00000, 0.00000, -40.00000);
CreateDynamicObject(811, 999.81659, -1777.34143, 14.20047,   0.00000, 0.00000, -40.00000);
CreateDynamicObject(811, 1005.39563, -1778.51147, 14.20047,   0.00000, 0.00000, -40.00000);
CreateDynamicObject(811, 1010.40948, -1780.04236, 14.20047,   0.00000, 0.00000, -40.00000);
CreateDynamicObject(811, 1016.25238, -1782.19287, 14.20047,   0.00000, 0.00000, -40.00000);
CreateDynamicObject(811, 1023.86554, -1779.95007, 14.20047,   0.00000, 0.00000, -40.00000);
CreateDynamicObject(811, 1024.24658, -1775.27380, 14.20047,   0.00000, 0.00000, -40.00000);
CreateDynamicObject(19325, 1015.83093, -1745.96826, 14.39158,   0.00000, 0.00000, 0.10509);
CreateDynamicObject(19325, 1015.83655, -1753.43262, 14.39158,   0.00000, 0.00000, 0.10509);
CreateDynamicObject(19325, 1015.81964, -1760.42078, 14.39158,   0.00000, 0.00000, 0.10509);
CreateDynamicObject(19325, 1011.63812, -1764.53381, 14.39160,   0.00000, 0.00000, 89.89899);
CreateDynamicObject(19325, 995.61859, -1764.49536, 14.39160,   0.00000, 0.00000, 89.89899);
CreateDynamicObject(19325, 991.27454, -1760.48035, 14.39158,   0.00000, 0.00000, 0.10509);
CreateDynamicObject(19325, 991.22485, -1753.14758, 14.39158,   0.00000, 0.00000, 359.80206);
CreateDynamicObject(19325, 991.27979, -1745.53430, 14.39158,   0.00000, 0.00000, 359.80206);
CreateDynamicObject(2186, 1014.02319, -1730.63086, 12.48270,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2186, 1010.34784, -1738.96484, 12.48270,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19325, 1015.78241, -1735.89978, 14.39158,   0.00000, 0.00000, 0.00609);
CreateDynamicObject(6054, 1036.41406, -1689.17969, 12.60938,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18766, 1026.86316, -1756.08960, 17.87530,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(18762, 1026.95325, -1751.55054, 12.96753,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1026.88916, -1743.69092, 12.96753,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18762, 1026.87109, -1760.70117, 12.96753,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18766, 1026.84497, -1748.21362, 17.87530,   0.00000, 0.00000, 90.00000);

//Eksterior bank LS
CreateDynamicObject(1649, 1443.74915, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1502, 1441.55615, -1021.69531, 22.90300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1502, 1444.57776, -1021.67542, 22.90300,   0.00000, 0.00000, 179.69991);
CreateDynamicObject(1649, 1443.74915, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1443.76941, -1021.70532, 30.17770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19378, 1449.34583, -1021.67352, 25.77120,   0.00000, 0.00000, -89.99990);
CreateDynamicObject(19378, 1436.79675, -1021.67352, 25.77120,   0.00000, 0.00000, -89.99990);
CreateDynamicObject(1649, 1443.32813, -1021.65491, 30.19770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1456.25085, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1502, 1454.13574, -1021.69531, 22.90300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1502, 1457.12915, -1021.67072, 22.90300,   0.00000, 0.00000, 179.69991);
CreateDynamicObject(19378, 1461.88525, -1021.67352, 25.77120,   0.00000, 0.00000, -89.99990);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1455.58923, -1021.67682, 30.19770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1456.25085, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1455.58923, -1021.67682, 26.92770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1468.81946, -1021.69952, 24.53770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1468.81946, -1021.69952, 27.76770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1468.81946, -1021.72961, 29.36770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1468.80933, -1021.70532, 24.55780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1468.80933, -1021.70532, 27.83770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1468.80933, -1021.68530, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19378, 1475.76575, -1021.67352, 25.77120,   0.00000, 0.00000, -89.99990);
CreateDynamicObject(1649, 1482.65955, -1021.68530, 30.28770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1482.69824, -1021.70532, 27.04780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1502, 1480.52576, -1021.69531, 22.90300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1502, 1483.52881, -1021.65881, 22.90300,   0.00000, 0.00000, 179.69991);
CreateDynamicObject(1649, 1482.74146, -1021.75360, 27.00770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1482.74146, -1021.75360, 30.28770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(19378, 1488.30554, -1021.67352, 25.77120,   0.00000, 0.00000, -89.99990);
CreateDynamicObject(1367, 1484.09656, -1021.99487, 23.49620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19370, 1461.78015, -1020.36511, 32.17810,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19370, 1465.89026, -1020.36511, 32.17810,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19370, 1458.01965, -1020.36511, 32.17810,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1367, 1491.09692, -1021.99487, 23.49620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1258, 1485.75476, -1022.00732, 23.38620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1486.75293, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1479.13281, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1258, 1488.69666, -1022.00732, 23.38620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1489.18384, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1475.75244, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1472.82141, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1464.61914, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1461.56873, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1458.53845, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1452.68665, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1449.35632, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1446.03516, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1439.45166, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1436.15076, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1823, 1433.00012, -1022.72290, 22.78560,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1258, 1477.89624, -1022.12750, 23.38620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1258, 1471.86536, -1022.12750, 23.38620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1258, 1463.56335, -1022.12750, 23.38620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1258, 1460.59351, -1022.12750, 23.38620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1258, 1448.25354, -1022.12750, 23.38620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1258, 1432.42163, -1022.12750, 23.38620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1258, 1441.01135, -1022.12750, 23.38620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1367, 1474.78491, -1021.99487, 23.49620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1367, 1457.88354, -1021.99487, 23.49620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1367, 1451.60242, -1021.99487, 23.49620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1367, 1445.25195, -1021.99487, 23.49620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1367, 1438.38110, -1021.99487, 23.49620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1367, 1434.93091, -1021.99487, 23.49620,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1443.74915, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1443.74915, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1443.76941, -1021.70532, 30.17770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1443.76941, -1021.70532, 30.17770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1443.76941, -1021.70532, 30.17770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1443.76941, -1021.70532, 30.17770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1443.76941, -1021.70532, 30.17770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1443.32813, -1021.65491, 30.19770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1443.32813, -1021.65491, 30.19770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1443.32813, -1021.65491, 30.19770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1443.32813, -1021.65491, 30.19770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1443.32813, -1021.65491, 30.19770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1456.25085, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.25085, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.25085, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.25085, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.22986, -1021.67511, 29.36770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1455.58923, -1021.67682, 30.19770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1455.58923, -1021.67682, 30.19770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1455.58923, -1021.67682, 30.19770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1455.58923, -1021.67682, 30.19770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1456.25085, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.25085, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.25085, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.25085, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1456.25085, -1021.70532, 26.95770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1468.80933, -1021.70532, 24.55780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1468.80933, -1021.70532, 24.55780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1468.80933, -1021.70532, 24.55780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1468.80933, -1021.70532, 24.55780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1446.77734, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1450.90735, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1452.20715, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1459.34753, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1463.47815, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1464.66943, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1473.12976, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1477.28064, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1478.52161, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1485.65234, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1489.81335, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1439.48584, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1435.35571, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1434.09521, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1892, 1442.54456, -1024.06653, 22.81940,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1892, 1455.19604, -1024.06653, 22.81940,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1892, 1481.57800, -1024.06653, 22.81940,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1892, 1491.88086, -1023.42157, 22.81940,   0.00000, 0.00000, 89.79980);
CreateDynamicObject(1892, 1431.72791, -1023.72162, 22.81940,   0.00000, 0.00000, 89.79980);
CreateDynamicObject(970, 1468.88684, -1024.13501, 23.33930,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, 1484.82886, -1019.12402, 20.40670,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, 1483.31836, -1024.13464, 23.19660,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, 1480.80835, -1024.13464, 23.19660,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, 1456.92676, -1024.13464, 23.19660,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, 1454.53674, -1024.13464, 23.19660,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, 1444.32581, -1024.13464, 23.19660,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, 1441.78516, -1024.13464, 23.19660,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1649, 1443.32813, -1021.65491, 26.92770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1443.32813, -1021.65491, 26.92770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1443.32813, -1021.65491, 26.92770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(1649, 1443.32813, -1021.65491, 26.92770,   0.00000, 0.00000, 179.89990);
CreateDynamicObject(994, 1437.32922, -1014.19427, 25.63610,   -1.59990, 17.79990, -91.89990);
CreateDynamicObject(994, 1458.71021, -1014.41718, 25.19490,   -1.59990, 17.79990, -91.89990);
CreateDynamicObject(994, 1448.00916, -1014.54871, 25.33760,   -1.59990, 17.79990, -91.89990);
CreateDynamicObject(994, 1467.96594, -1014.40002, 25.04050,   -1.59990, 17.79990, -91.89990);
CreateDynamicObject(994, 1477.92407, -1014.29413, 25.27030,   -1.59990, 17.79990, -91.89990);
CreateDynamicObject(994, 1486.66724, -1014.61139, 25.11160,   -1.59990, 17.79990, -91.89990);
CreateDynamicObject(1569, 1463.14966, -1009.57898, 25.79340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1569, 1466.15454, -1009.56927, 25.79340,   0.00000, 0.00000, -179.89999);
CreateDynamicObject(1706, 1433.90686, -1010.03900, 25.62940,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1706, 1439.59692, -1010.03900, 25.62940,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1706, 1446.30920, -1010.03900, 25.62940,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1706, 1453.38025, -1010.03900, 25.62940,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1706, 1459.64111, -1010.03900, 25.62940,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1706, 1469.11267, -1010.03900, 25.62940,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1706, 1475.40344, -1010.03900, 25.62940,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1706, 1489.42456, -1010.04883, 25.62940,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1458.41577, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1455.70520, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1452.16443, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1448.41345, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1445.10254, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1441.72266, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1438.55237, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1436.08105, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1432.66064, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1462.93115, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1466.23120, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1468.20081, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1471.17114, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1474.52283, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1477.42236, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1481.31335, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1484.38342, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1488.32336, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2011, 1491.38391, -1010.44598, 25.78770,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1229, 1456.57202, -1028.60364, 24.25470,   0.00000, 0.00000, 93.20000);
CreateDynamicObject(1229, 1495.45911, -1028.88416, 24.19470,   0.00000, 0.00000, 93.20000);
CreateDynamicObject(1597, 1469.58374, -1033.75427, 25.03340,   0.00000, 0.00000, -89.79990);
CreateDynamicObject(1597, 1461.60254, -1033.73291, 25.03340,   0.00000, 0.00000, -89.79990);
CreateDynamicObject(3505, 1433.85974, -1033.87695, 21.30840,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3505, 1465.61975, -1033.86694, 21.04840,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1597, 1437.73254, -1033.81543, 25.03340,   0.00000, 0.00000, -89.79990);
CreateDynamicObject(1597, 1429.79150, -1033.63330, 25.03340,   0.00000, 0.00000, -89.79990);
CreateDynamicObject(3505, 1402.27112, -1034.52686, 22.51840,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2894, 1440.27551, -1022.32092, 23.28520,   0.00000, 0.00000, 55.40000);
CreateDynamicObject(1597, 1406.33667, -1034.20276, 25.39590,   -4.50000, 0.00000, -86.70000);
CreateDynamicObject(1597, 1398.47192, -1034.87524, 26.12850,   -4.50000, 0.00000, -82.60000);
CreateDynamicObject(2894, 1439.71484, -1022.23242, 23.28520,   0.00000, 0.00000, 102.70000);
CreateDynamicObject(2894, 1436.97632, -1023.32037, 22.84520,   0.00000, 0.00000, 129.80000);
CreateDynamicObject(2894, 1433.90576, -1023.14563, 22.84520,   0.00000, 0.00000, 67.30000);
CreateDynamicObject(2894, 1433.20313, -1023.29608, 22.84520,   0.00000, 0.00000, 150.10001);
CreateDynamicObject(2894, 1437.75195, -1023.27032, 22.84520,   0.00000, 0.00000, 28.90000);
CreateDynamicObject(2894, 1435.25964, -1023.41217, 22.84520,   0.00000, 0.00000, -82.49990);
CreateDynamicObject(2894, 1440.04236, -1023.34723, 22.84520,   0.00000, 0.00000, -26.69990);
CreateDynamicObject(2894, 1446.68604, -1022.15649, 23.28520,   0.00000, 0.00000, -26.69990);
CreateDynamicObject(2894, 1446.23792, -1022.48901, 23.28520,   0.00000, 0.00000, 97.60000);
CreateDynamicObject(2894, 1448.03955, -1023.13641, 22.84520,   0.00000, 0.00000, -20.99990);
CreateDynamicObject(2894, 1448.95435, -1023.06927, 22.84520,   0.00000, 0.00000, 88.00000);
CreateDynamicObject(2894, 1451.56274, -1023.16028, 22.84520,   0.00000, 0.00000, 10.70000);
CreateDynamicObject(2894, 1452.48962, -1023.21918, 22.84520,   0.00000, 0.00000, -39.49990);
CreateDynamicObject(2894, 1450.32825, -1023.18573, 22.84520,   0.00000, 0.00000, -96.69990);
CreateDynamicObject(2894, 1458.35510, -1023.17230, 22.84520,   0.00000, 0.00000, -18.19990);
CreateDynamicObject(2894, 1459.04846, -1023.40033, 22.84520,   0.00000, 0.00000, 58.40000);
CreateDynamicObject(2894, 1462.29688, -1022.35699, 23.28520,   0.00000, 0.00000, 58.40000);
CreateDynamicObject(2894, 1461.83691, -1022.07397, 23.28520,   0.00000, 0.00000, 120.59990);
CreateDynamicObject(2894, 1462.56531, -1023.30469, 22.84520,   0.00000, 0.00000, 120.59990);
CreateDynamicObject(2894, 1461.81494, -1023.25842, 22.82520,   0.00000, 0.00000, 53.40000);
CreateDynamicObject(2894, 1463.58630, -1023.18958, 22.82520,   0.00000, 0.00000, 85.79990);
CreateDynamicObject(2894, 1464.77295, -1023.27667, 22.82520,   0.59990, 0.00000, 85.79990);
CreateDynamicObject(2894, 1465.45776, -1023.17389, 22.81870,   0.59990, 0.00000, 125.09990);
CreateDynamicObject(2894, 1472.07825, -1023.11627, 22.82930,   0.59990, 0.00000, 90.49990);
CreateDynamicObject(2894, 1472.84766, -1023.23712, 22.82340,   0.59990, 0.00000, 123.99990);
CreateDynamicObject(2894, 1473.78784, -1023.20782, 22.81350,   0.59990, 0.00000, 91.79990);
CreateDynamicObject(2894, 1473.78784, -1023.20782, 22.81350,   0.59990, 0.00000, 91.79990);
CreateDynamicObject(2894, 1474.59790, -1023.18250, 22.83500,   0.59990, 0.00000, 128.49989);
CreateDynamicObject(2894, 1475.80664, -1023.13818, 22.82230,   0.59990, 0.00000, 54.29990);
CreateDynamicObject(2894, 1479.21106, -1022.37030, 23.31810,   0.59990, 0.00000, 54.29990);
CreateDynamicObject(2894, 1479.93042, -1022.18292, 23.31070,   0.59990, 0.00000, 121.79990);
CreateDynamicObject(2894, 1489.61035, -1022.47693, 23.28610,   0.59990, 0.00000, 121.79990);
CreateDynamicObject(2894, 1490.04114, -1022.21808, 23.28250,   0.59990, 0.00000, 73.59990);
CreateDynamicObject(2894, 1489.70581, -1023.33948, 22.79260,   0.59990, 0.00000, 73.59990);
CreateDynamicObject(2894, 1489.04346, -1023.14471, 22.79980,   0.59990, 0.00000, 111.19990);
CreateDynamicObject(2894, 1487.98315, -1023.34003, 22.81200,   0.59990, 0.00000, 57.79990);
CreateDynamicObject(2894, 1487.19202, -1023.28162, 22.81980,   0.59990, 0.00000, 104.89990);
CreateDynamicObject(2894, 1485.18726, -1023.03491, 22.84060,   0.59990, 0.00000, 110.69990);
CreateDynamicObject(2894, 1484.70984, -1023.21539, 22.84590,   0.59990, 0.00000, 65.79990);
CreateDynamicObject(1892, 1455.10596, -1021.16522, 23.05950,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1892, 1442.61462, -1021.16522, 23.05950,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1892, 1481.54578, -1021.16522, 23.05950,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1892, 1464.10510, -1010.04523, 25.79950,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19370, 1639.73254, -1685.73853, 22.51330,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19370, 1639.73254, -1682.68835, 22.51330,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19370, 1639.82263, -1686.11914, 21.44330,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19370, 1639.82263, -1682.89856, 21.45330,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19913, 1149.47424, -1401.86768, 8.63530,   0.00000, 0.00000, 0.09990);
CreateDynamicObject(19433, 1174.40125, -1401.03442, 12.37020,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19913, 1099.52795, -1399.60376, 8.63530,   0.00000, 0.00000, 0.09990);
CreateDynamicObject(19913, 1149.47107, -1399.50684, 8.63530,   0.00000, 0.00000, 0.09990);
CreateDynamicObject(19913, 1099.53271, -1401.95410, 8.63530,   0.00000, 0.00000, 0.09990);
CreateDynamicObject(3505, 1077.23865, -1400.59827, 12.21380,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19433, 1074.63123, -1401.23462, 12.37020,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19433, 1074.61121, -1400.48376, 12.37020,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19433, 1174.39136, -1400.22363, 12.37020,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3505, 1091.78064, -1400.59827, 12.21380,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3505, 1111.10034, -1400.43823, 12.21380,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3505, 1133.13074, -1400.36804, 12.21380,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3505, 1157.02185, -1400.36804, 12.21380,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(655, 1166.18286, -1400.23096, 12.49780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(655, 1143.49292, -1400.23096, 12.49780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(655, 1121.65247, -1400.23096, 12.49780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(655, 1101.25305, -1400.29114, 12.49780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(655, 1084.71167, -1400.29114, 12.49780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(738, 1171.84705, -1400.32556, 12.33110,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(738, 1160.82642, -1400.32556, 12.33110,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(738, 1150.18591, -1400.32556, 12.33110,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(738, 1137.92566, -1400.32556, 12.33110,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(738, 1128.02502, -1400.58594, 12.33110,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(738, 1116.94470, -1400.58594, 12.33110,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(738, 1106.33435, -1400.58594, 12.33110,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(738, 1095.98401, -1400.58594, 12.33110,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(738, 1088.76294, -1400.58594, 12.33110,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(738, 1080.11255, -1400.58594, 12.33110,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19441, 1168.02405, -1400.64856, 14.03350,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1172.65454, -1400.64856, 14.01730,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1163.95325, -1400.64856, 14.04770,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1160.46240, -1400.64856, 14.05980,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1156.73181, -1400.64856, 14.07290,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1152.99072, -1400.64856, 14.08590,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1149.48035, -1400.64856, 14.09820,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1146.52075, -1400.64856, 14.10850,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1143.50024, -1400.64856, 14.11900,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1139.28955, -1400.64856, 14.13370,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1134.76904, -1400.64856, 14.14950,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1130.60791, -1400.64856, 14.16400,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1126.12695, -1400.64856, 14.17960,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1121.70667, -1400.64856, 14.19510,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1116.65576, -1400.64856, 14.21270,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1110.81555, -1400.64856, 14.23310,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1105.93506, -1400.64856, 14.25010,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1100.98474, -1400.64856, 14.26740,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1096.61475, -1400.64856, 14.28260,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1090.20386, -1400.64856, 14.30500,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1084.23401, -1400.64856, 14.32580,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19441, 1079.09375, -1400.64856, 14.34380,   -0.99990, 90.19990, 0.00000);
CreateDynamicObject(19124, 1074.21875, -1401.86353, 12.93780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, 1074.21875, -1399.99194, 12.93780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, 1174.79993, -1399.71155, 12.70780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, 1174.79993, -1401.52234, 12.70780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19370, 1494.38794, -1021.70752, 21.56470,   0.00000, 0.00000, -90.09990);

//Park ganton

























































































CreateDynamicObject(18980, 2391.73901, -1759.88696, 11.97800,   19.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2391.76904, -1759.12195, 12.09800,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2403.99292, -1771.12305, 12.04400,   0.00000, 90.00000, 90.00000);
CreateDynamicObject(18980, 2403.99292, -1796.12305, 12.04400,   0.00000, 90.00000, 90.00000);
CreateDynamicObject(18762, 2403.99292, -1811.12097, 12.04400,   0.00000, 90.00000, 90.00000);
CreateDynamicObject(18762, 2403.99292, -1816.12097, 12.04400,   0.00000, 90.00000, 90.00000);
CreateDynamicObject(18762, 2403.99292, -1821.12097, 12.04400,   0.00000, 90.00000, 90.00000);
CreateDynamicObject(18980, 2391.26294, -1823.21802, 12.07400,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2366.26294, -1823.21802, 12.07400,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18762, 2351.41797, -1823.48206, 12.07600,   0.00000, 90.00000, 6.59900);
CreateDynamicObject(18980, 2244.09106, -1837.45703, 12.07400,   0.00000, 90.00000, 7.55900);
CreateDynamicObject(18762, 2229.30688, -1839.01501, 12.05200,   0.00000, 90.00000, -1.37900);
CreateDynamicObject(18980, 2268.87109, -1834.16895, 12.07400,   0.00000, 90.00000, 7.55900);
CreateDynamicObject(18980, 2293.65088, -1830.87903, 12.07400,   0.00000, 90.00000, 7.55900);
CreateDynamicObject(18980, 2318.42896, -1827.69104, 12.07400,   0.00000, 90.00000, 7.13900);
CreateDynamicObject(18762, 2346.45605, -1824.05798, 12.07600,   0.00000, 90.00000, 6.59900);
CreateDynamicObject(18762, 2333.30908, -1825.82996, 12.07600,   0.00000, 90.00000, 7.13900);
CreateDynamicObject(18762, 2338.26904, -1825.20801, 12.07600,   0.00000, 90.00000, 7.13900);
CreateDynamicObject(18762, 2343.18188, -1824.49500, 12.06200,   0.00000, 90.00000, 9.11900);
CreateDynamicObject(18980, 2228.28809, -1827.05896, 12.08800,   0.00000, 90.00000, 93.95900);
CreateDynamicObject(18980, 2226.63599, -1802.12305, 12.08200,   0.00000, 90.00000, 93.59900);
CreateDynamicObject(18980, 2225.94800, -1777.23706, 12.07000,   0.00000, 90.00000, 89.58000);
CreateDynamicObject(18762, 2226.06201, -1762.23706, 12.07000,   0.00000, 90.00000, 89.58000);
CreateDynamicObject(18980, 2238.07593, -1759.23804, 12.25900,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2263.07593, -1759.23804, 12.25900,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2288.07593, -1759.23804, 12.25900,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2313.07593, -1759.23804, 12.22300,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2338.07593, -1759.23804, 12.19300,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2363.07593, -1759.23804, 12.19300,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2269.98096, -1801.85999, 11.94500,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2367.44897, -1772.15100, 12.13700,   0.00000, 90.00000, 90.00000);
CreateDynamicObject(18980, 2367.20190, -1797.06702, 11.96900,   0.00000, 90.00000, 88.79900);
CreateDynamicObject(18762, 2366.91797, -1812.05701, 11.96900,   0.00000, 90.00000, 89.51900);
CreateDynamicObject(18762, 2326.71899, -1760.06897, 12.05000,   19.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2378.89600, -1816.55396, 11.96900,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2394.39600, -1816.53296, 11.94800,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(12814, 2270.41211, -1788.22095, 10.82700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18980, 2257.97998, -1788.86304, 11.94500,   0.00000, 90.00000, 90.00000);
CreateDynamicObject(18980, 2281.97998, -1788.86304, 11.94500,   0.00000, 90.00000, 90.00000);
CreateDynamicObject(18980, 2269.98096, -1775.85999, 11.94500,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2257.97998, -1788.86304, 10.94500,   0.00000, 90.00000, 90.00000);
CreateDynamicObject(18980, 2269.98096, -1801.85999, 10.94500,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18980, 2281.97998, -1788.86304, 10.94500,   0.00000, 90.00000, 90.00000);
CreateDynamicObject(18980, 2269.98096, -1775.85999, 10.94500,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(18762, 2331.71899, -1760.06897, 12.05000,   19.00000, 90.00000, 0.00000);
CreateDynamicObject(18762, 2326.71899, -1758.51904, 12.05000,   19.00000, 90.00000, 180.00000);
CreateDynamicObject(18762, 2331.71899, -1758.51904, 12.05000,   19.00000, 90.00000, 180.00000);
CreateDynamicObject(9915, 2307.04297, -1790.17896, 8.32300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(6959, 2308.26001, -1795.57397, 12.35300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(8661, 2268.35010, -1811.69897, 12.31400,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(13006, 2380.36890, -1789.37903, 12.43000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(669, 2389.63501, -1760.98804, 12.69900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2403.96094, -1763.35706, 12.19900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2403.96094, -1771.85706, 12.19900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2403.96094, -1781.35706, 12.19900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2403.96094, -1791.35706, 12.19900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2403.96094, -1801.85706, 12.19900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2403.96094, -1812.85706, 12.19900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(672, 2369.61304, -1759.60400, 12.90900,   0.00000, 0.00000, 103.50000);
CreateDynamicObject(4639, 2394.10693, -1760.80298, 13.89800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2390.68701, -1767.87097, 12.92700,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2390.68701, -1774.37097, 12.92700,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2390.68701, -1780.87097, 12.92700,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2390.68701, -1789.87097, 12.92700,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2390.68701, -1796.87097, 12.92700,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2390.68701, -1804.37097, 12.92700,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2390.68701, -1812.37097, 12.92700,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(19381, 2398.65698, -1818.91895, 12.23600,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2388.15894, -1818.91895, 12.23600,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2377.65894, -1818.91895, 12.23600,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2367.16089, -1818.91895, 12.23600,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(8674, 2372.30396, -1757.75806, 14.57800,   0.00000, 0.00000, -2.22000);
CreateDynamicObject(19381, 2231.33691, -1833.72900, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2231.33691, -1824.09595, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2231.33691, -1814.46399, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2231.33691, -1804.83203, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2231.33691, -1795.19897, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2231.33691, -1785.56799, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2231.33691, -1775.93701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2231.33691, -1766.30701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2231.33691, -1756.68201, 12.26700,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2241.83691, -1756.68201, 12.26700,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2241.83691, -1766.30701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2241.83691, -1775.93701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2241.83691, -1785.56799, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2241.83691, -1795.19897, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2241.83691, -1804.83203, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2241.83691, -1814.46399, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2241.83691, -1824.09595, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2241.83691, -1832.73901, 12.29700,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2234.83105, -1833.36401, 12.28200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2252.33691, -1756.68201, 12.26700,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2252.33691, -1766.30701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(1479, 2336.14795, -1773.07898, 13.70500,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(715, 2353.04712, -1762.92505, 19.79600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 2348.09790, -1765.28796, 15.04200,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19381, 2252.33691, -1775.93701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2252.33691, -1785.56799, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2252.33691, -1795.19897, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2252.33691, -1804.83203, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2252.33691, -1814.46399, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2252.33691, -1824.09595, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2252.33691, -1831.23901, 12.29700,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2249.33691, -1831.73901, 12.28200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(1280, 2369.70898, -1811.70300, 12.72700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2369.70898, -1805.70300, 12.72700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2369.70898, -1799.70300, 12.72700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2369.70898, -1776.20300, 12.82900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(6203, 2394.24390, -1788.28796, 12.58600,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19381, 2356.65894, -1818.91895, 12.23600,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2346.15894, -1818.91895, 12.23600,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2335.66089, -1818.91895, 12.23600,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2325.16089, -1818.91895, 12.23600,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2314.66089, -1818.91895, 12.23600,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(10444, 2261.83691, -1778.13306, 11.56800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2322.42700, -1811.95105, 12.27100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19381, 2304.16699, -1818.92102, 12.23600,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(8674, 2367.17505, -1762.71899, 14.57800,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8674, 2382.57397, -1758.18896, 14.57800,   0.00000, 0.00000, -2.22000);
CreateDynamicObject(8674, 2367.15308, -1767.88696, 14.57800,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(10444, 2261.83691, -1808.48901, 11.56800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(10444, 2276.29297, -1808.48901, 11.56800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(10444, 2276.29492, -1778.13501, 11.56800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19381, 2262.83691, -1761.30701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2262.83691, -1770.93701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2273.33691, -1770.93701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2273.33691, -1761.30701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2283.83691, -1770.93701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2283.83691, -1761.30701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2294.33691, -1761.30701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2294.33691, -1770.93701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2304.83691, -1761.30701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2304.83691, -1770.93701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2315.33691, -1761.30701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2315.33691, -1770.93701, 12.34200,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2262.16797, -1826.18896, 12.22800,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19377, 2293.68091, -1816.57202, 12.23600,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2272.66797, -1826.18896, 12.22800,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2283.16797, -1826.18896, 12.22800,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2293.66797, -1825.91602, 12.19400,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19373, 2289.46899, -1829.41602, 12.17000,   0.00000, 90.00000, 8.15900);
CreateDynamicObject(19373, 2286.00098, -1829.88696, 12.17000,   0.00000, 90.00000, 8.15900);
CreateDynamicObject(19373, 2282.56494, -1830.60303, 12.17000,   0.00000, 90.00000, 8.15900);
CreateDynamicObject(19381, 2275.13403, -1828.12695, 12.17000,   0.00000, 90.00000, 8.15900);
CreateDynamicObject(19381, 2264.72705, -1829.53003, 12.17000,   0.00000, 90.00000, 8.15900);
CreateDynamicObject(19381, 2254.30298, -1830.78894, 12.17000,   0.00000, 90.00000, 8.15900);
CreateDynamicObject(19381, 2287.65503, -1780.57202, 12.32800,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2287.65503, -1790.20703, 12.32800,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2287.65503, -1799.83801, 12.32800,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19381, 2303.50098, -1825.15601, 12.12600,   0.00000, 90.00000, 6.48000);
CreateDynamicObject(19381, 2313.86304, -1823.26904, 12.12600,   0.00000, 90.00000, 6.48000);
CreateDynamicObject(19381, 2324.25806, -1821.71802, 12.12600,   0.00000, 90.00000, 6.48000);
CreateDynamicObject(19381, 2334.66992, -1820.36597, 12.12600,   0.00000, 90.00000, 6.48000);
CreateDynamicObject(19381, 2345.02100, -1819.16101, 12.12600,   0.00000, 90.00000, 7.26000);
CreateDynamicObject(2960, 2324.58008, -1814.43701, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2330.98608, -1814.43701, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2330.98608, -1809.81702, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2330.98608, -1805.20105, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2330.98608, -1800.58496, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2330.98608, -1795.96802, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2322.42700, -1805.94397, 12.29100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2324.55688, -1803.45203, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2324.55688, -1798.83801, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2324.55591, -1794.22095, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2324.55591, -1789.60803, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2324.55591, -1785.98901, 12.26900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2333.45801, -1793.85400, 12.27100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2338.07788, -1793.85400, 12.27100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2342.67212, -1793.85400, 12.27100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2346.80396, -1796.08899, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2344.66309, -1793.85400, 12.26500,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2346.80396, -1800.58899, 12.26300,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2346.80396, -1805.08899, 12.27900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2346.80396, -1781.58899, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(3783, 2332.12207, -1762.44800, 10.06600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2336.87500, -1772.39294, 12.73500,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2762, 2336.82690, -1774.59399, 12.66900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2344.29004, -1783.71497, 12.27100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2322.04395, -1783.87195, 12.26900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2322.29102, -1777.85706, 12.26900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2324.80396, -1775.73096, 12.26900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2324.80396, -1771.23096, 12.26700,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2324.80396, -1766.73096, 12.26900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2321.51709, -1805.95105, 12.32300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(869, 2320.14111, -1791.33105, 12.66300,   0.00000, 0.00000, 70.98000);
CreateDynamicObject(869, 2322.01294, -1792.49304, 12.66300,   0.00000, 0.00000, 124.55900);
CreateDynamicObject(869, 2322.17505, -1789.23596, 12.66300,   0.00000, 0.00000, 207.17999);
CreateDynamicObject(1232, 2324.05908, -1784.45605, 14.66700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 2324.35303, -1777.32800, 14.66700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 2324.10107, -1805.50806, 14.66700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(869, 2316.11206, -1792.08606, 12.66300,   0.00000, 0.00000, 118.50000);
CreateDynamicObject(869, 2317.45410, -1790.06104, 12.66300,   0.00000, 0.00000, 12.42000);
CreateDynamicObject(2960, 2319.42603, -1785.97900, 12.26700,   0.00000, 0.00000, 85.49900);
CreateDynamicObject(2960, 2316.79102, -1788.09998, 12.26700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2312.17603, -1788.09998, 12.26700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2310.67603, -1788.09998, 12.26500,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2308.56909, -1790.58801, 12.26500,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2308.56909, -1792.44800, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2310.98706, -1794.56995, 12.26700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2315.58105, -1794.56995, 12.26500,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2317.08105, -1794.56995, 12.26900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2319.28711, -1796.65198, 12.27300,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2319.30493, -1801.25500, 12.26900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2319.30493, -1803.84900, 12.26900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2319.30493, -1803.84900, 12.28600,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2319.30493, -1803.84900, 12.30100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1307, 2323.75903, -1816.06604, 12.31500,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(869, 2321.28394, -1798.26294, 12.66300,   0.00000, 0.00000, 138.00000);
CreateDynamicObject(869, 2321.88892, -1795.53101, 12.66300,   0.00000, 0.00000, 175.67999);
CreateDynamicObject(869, 2321.84692, -1786.03003, 12.66300,   0.00000, 0.00000, 200.58000);
CreateDynamicObject(869, 2311.73096, -1790.62695, 12.66300,   0.00000, 0.00000, 195.89999);
CreateDynamicObject(869, 2313.38696, -1791.95801, 12.66300,   0.00000, 0.00000, 214.92000);
CreateDynamicObject(1232, 2323.98706, -1812.53198, 14.66700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2339.67090, -1783.71497, 12.27100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2335.05908, -1783.71497, 12.27100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2332.99902, -1783.71497, 12.26300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2330.88989, -1781.21594, 12.26300,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2330.80396, -1766.73096, 12.26900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2330.80396, -1771.23096, 12.26700,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2317.10693, -1775.88306, 12.26900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2319.25098, -1775.36804, 12.26900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2321.34106, -1777.85095, 12.26500,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2312.48901, -1775.88306, 12.26600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1479, 2336.12891, -1776.17798, 13.70500,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2336.83496, -1776.84497, 12.73500,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1308, 2331.38501, -1766.53601, 12.32600,   0.00000, -10.00000, 0.00000);
CreateDynamicObject(1308, 2346.90894, -1765.95996, 10.21400,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2346.80396, -1776.96899, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2346.80811, -1772.35205, 12.27100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2348.25391, -1768.42896, 12.26700,   0.00000, 0.00000, 50.27900);
CreateDynamicObject(2960, 2351.80200, -1766.25806, 12.26500,   0.00000, 0.00000, 12.42000);
CreateDynamicObject(2960, 2356.21411, -1765.83496, 12.26300,   0.00000, 0.00000, -0.89900);
CreateDynamicObject(2960, 2360.83105, -1765.90906, 12.26300,   0.00000, 0.00000, -0.89900);
CreateDynamicObject(2960, 2365.44409, -1765.98206, 12.26300,   0.00000, 0.00000, -0.89900);
CreateDynamicObject(2960, 2347.73804, -1809.28796, 12.27700,   0.00000, 0.00000, 114.72000);
CreateDynamicObject(2960, 2350.76904, -1811.98901, 12.27500,   0.00000, 0.00000, 161.70000);
CreateDynamicObject(2960, 2355.16406, -1812.68506, 12.27900,   0.00000, 0.00000, 179.69901);
CreateDynamicObject(2960, 2359.77197, -1812.67700, 12.27900,   0.00000, 0.00000, 180.53900);
CreateDynamicObject(2960, 2362.59302, -1812.64197, 12.27300,   0.00000, 0.00000, 180.53900);
CreateDynamicObject(2960, 2364.06909, -1812.64502, 12.27100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(869, 2333.23193, -1781.46399, 12.66300,   0.00000, 0.00000, 181.20000);
CreateDynamicObject(869, 2336.76611, -1781.55701, 12.66300,   0.00000, 0.00000, 194.88000);
CreateDynamicObject(869, 2339.70703, -1781.30505, 12.66300,   0.00000, 0.00000, 232.91901);
CreateDynamicObject(869, 2342.34497, -1781.47302, 12.66300,   0.00000, 0.00000, 260.75900);
CreateDynamicObject(870, 2323.29102, -1767.73596, 12.66300,   0.00000, 0.00000, 274.49899);
CreateDynamicObject(871, 2322.99902, -1791.18103, 12.66300,   0.00000, 0.00000, 274.49899);
CreateDynamicObject(871, 2323.12012, -1787.38306, 12.66300,   0.00000, 0.00000, 274.49899);
CreateDynamicObject(871, 2323.18994, -1795.40295, 12.66300,   0.00000, 0.00000, 274.49899);
CreateDynamicObject(871, 2323.25488, -1798.43005, 12.66300,   0.00000, 0.00000, 274.49899);
CreateDynamicObject(869, 2321.97510, -1801.08105, 12.66300,   0.00000, 0.00000, 169.97900);
CreateDynamicObject(871, 2323.10303, -1804.44495, 12.66300,   0.00000, 0.00000, 274.49899);
CreateDynamicObject(870, 2332.39307, -1767.72705, 12.66300,   0.00000, 0.00000, 274.49899);
CreateDynamicObject(2960, 2322.68896, -1765.94702, 12.30100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2320.77588, -1763.45203, 12.30100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2320.78101, -1758.83105, 12.30100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2332.90308, -1765.90906, 12.30100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2337.52197, -1765.91003, 12.30100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2341.94092, -1765.91003, 12.29500,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2344.08496, -1763.41296, 12.29500,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2344.08105, -1758.85095, 12.29500,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19381, 2349.35205, -1759.27295, 12.21400,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(1232, 2331.84497, -1766.41504, 14.66700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1232, 2323.54297, -1766.37000, 14.66700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1308, 2313.91504, -1766.81897, 9.27800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2307.98901, -1775.88306, 12.26900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2303.48901, -1775.88306, 12.26600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2298.98901, -1775.88306, 12.26900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2294.98901, -1775.88306, 12.26600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(669, 2317.02710, -1763.04297, 10.87200,   356.85800, 0.00000, -71.31800);
CreateDynamicObject(673, 2295.19702, -1771.87903, 12.28300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(672, 2288.48999, -1763.66296, 12.40600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2304.69702, -1771.87903, 12.28300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2313.19702, -1771.87903, 12.28300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1479, 2303.85791, -1764.43994, 13.70500,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(673, 2304.69702, -1761.37903, 12.28300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2303.86694, -1764.09204, 12.73500,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(762, 2313.58496, -1767.23596, 12.98400,   3.14100, 0.00000, 0.90900);
CreateDynamicObject(700, 2321.40308, -1786.16296, 12.30200,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(5711, 2305.53491, -1816.96106, 15.64100,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2344.24194, -1793.26501, 12.67900,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2338.74194, -1793.26501, 12.67900,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2333.24194, -1793.26501, 12.67900,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2333.24194, -1784.26501, 12.67900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1280, 2338.74194, -1784.26501, 12.67900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1280, 2344.24194, -1784.26501, 12.67900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(869, 2344.71802, -1780.59399, 12.66300,   0.00000, 0.00000, 286.01901);
CreateDynamicObject(869, 2344.85010, -1776.66602, 12.66300,   0.00000, 0.00000, 359.03900);
CreateDynamicObject(782, 2333.90210, -1797.44495, 12.29300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1294, 2345.69800, -1793.21204, 16.82300,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(617, 2289.02197, -1813.76001, 11.85100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(617, 2289.78589, -1826.51404, 11.85100,   0.00000, 0.00000, -70.43900);
CreateDynamicObject(782, 2343.26196, -1798.04895, 12.29300,   0.00000, 0.00000, -76.79900);
CreateDynamicObject(782, 2344.04492, -1780.94299, 12.29300,   0.00000, 0.00000, -103.01900);
CreateDynamicObject(782, 2334.66406, -1781.56995, 12.29300,   0.00000, 0.00000, -163.73900);
CreateDynamicObject(1294, 2331.88989, -1793.20496, 16.82300,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(869, 2340.86499, -1796.74194, 12.66300,   0.00000, 0.00000, 286.01901);
CreateDynamicObject(869, 2336.60791, -1796.30701, 12.66300,   0.00000, 0.00000, 264.11899);
CreateDynamicObject(869, 2338.80396, -1797.35706, 12.66300,   0.00000, 0.00000, 264.11899);
CreateDynamicObject(869, 2344.31592, -1796.30701, 12.66300,   0.00000, 0.00000, 321.47900);
CreateDynamicObject(869, 2333.54810, -1796.28406, 12.66300,   0.00000, 0.00000, 245.33900);
CreateDynamicObject(869, 2344.04297, -1799.33606, 12.66300,   0.00000, 0.00000, 286.01901);
CreateDynamicObject(1294, 2345.69800, -1784.21204, 16.82300,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1294, 2331.69800, -1784.21204, 16.82300,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(656, 2322.00806, -1773.42004, 12.22400,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(656, 2321.99902, -1815.00000, 12.22400,   0.00000, 0.00000, 75.17900);
CreateDynamicObject(700, 2322.13989, -1795.80396, 12.30200,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2226, 2336.94800, -1774.65295, 13.08500,   0.00000, 0.00000, 39.36000);
CreateDynamicObject(2901, 2341.30493, -1798.82495, 12.53100,   0.00000, 0.00000, -0.11900);
CreateDynamicObject(1643, 2338.64600, -1804.78699, 12.33200,   0.00000, 0.00000, -33.29900);
CreateDynamicObject(1641, 2342.10400, -1804.73804, 12.33200,   0.00000, 0.00000, -156.30000);
CreateDynamicObject(1640, 2298.02100, -1771.23804, 12.42800,   0.00000, 0.00000, 67.44000);
CreateDynamicObject(1642, 2301.44995, -1769.95398, 12.42800,   0.00000, 0.00000, -23.57900);
CreateDynamicObject(2103, 2340.32910, -1806.49500, 12.33100,   0.00000, 0.00000, -195.95900);
CreateDynamicObject(2960, 2293.09497, -1778.37305, 12.26600,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2293.09497, -1782.87305, 12.26300,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2293.09497, -1787.37305, 12.26600,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2293.09497, -1791.87305, 12.26300,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2293.09497, -1796.37305, 12.26600,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2293.09497, -1800.87305, 12.26300,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2293.09497, -1802.67505, 12.25700,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2290.59009, -1804.80701, 12.26600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(947, 2313.25610, -1795.82800, 14.48500,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(700, 2309.53589, -1791.39294, 12.30200,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(947, 2313.25610, -1810.82800, 14.48500,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(869, 2333.52295, -1806.02405, 12.66300,   0.00000, 0.00000, 245.33900);
CreateDynamicObject(869, 2333.60303, -1809.32300, 12.66300,   0.00000, 0.00000, 245.33900);
CreateDynamicObject(869, 2333.49194, -1812.54297, 12.66300,   0.00000, 0.00000, 249.23900);
CreateDynamicObject(869, 2333.52710, -1815.19702, 12.66300,   0.00000, 0.00000, 344.57901);
CreateDynamicObject(1280, 2316.24390, -1776.46802, 12.67900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1280, 2316.24390, -1787.46802, 12.67900,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2311.24390, -1787.46802, 12.67900,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2311.24390, -1776.46802, 12.67900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(5169, 2274.41797, -1739.18396, 13.72000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1281, 2295.52002, -1765.13501, 13.17900,   0.00000, 0.00000, 30.29900);
CreateDynamicObject(1281, 2289.57104, -1767.18506, 13.17900,   0.00000, 0.00000, 70.98000);
CreateDynamicObject(1281, 2337.15796, -1811.58301, 13.17900,   0.00000, 0.00000, 70.98000);
CreateDynamicObject(1281, 2343.40088, -1810.01196, 13.17900,   0.00000, 0.00000, -5.70000);
CreateDynamicObject(715, 2344.50000, -1814.91895, 19.50700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2297.08911, -1811.94800, 12.26600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(8650, 2351.25000, -1759.36304, 13.41000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8650, 2309.11108, -1759.36304, 13.41000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8650, 2278.61304, -1759.36304, 13.41000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8650, 2248.11694, -1759.36304, 13.41000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8650, 2241.11694, -1759.37695, 13.40600,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8650, 2226.26001, -1775.02502, 13.40600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(8650, 2227.17603, -1805.46301, 13.40600,   0.00000, 0.00000, 3.42000);
CreateDynamicObject(8650, 2228.31006, -1824.11804, 13.38500,   0.00000, 0.00000, 3.42000);
CreateDynamicObject(8650, 2244.65796, -1836.83704, 13.38500,   0.00000, 0.00000, 97.55900);
CreateDynamicObject(8650, 2274.88794, -1832.81995, 13.38500,   0.00000, 0.00000, 97.55900);
CreateDynamicObject(8650, 2305.12207, -1828.80701, 13.38500,   0.00000, 0.00000, 97.55900);
CreateDynamicObject(8650, 2335.35693, -1824.79504, 13.38500,   0.00000, 0.00000, 97.55900);
CreateDynamicObject(8650, 2365.18701, -1822.72498, 13.38100,   0.00000, 0.00000, 90.30000);
CreateDynamicObject(8650, 2389.18091, -1822.64001, 13.37100,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(673, 2384.21606, -1819.73596, 12.13800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2395.48901, -1819.61096, 12.13800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(8674, 2404.33691, -1817.18701, 12.83900,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(8658, 2351.42090, -1816.30005, 13.38100,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(2960, 2326.67603, -1816.93994, 12.27100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2328.87402, -1816.93994, 12.26700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2290.38501, -1811.92004, 12.26600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2288.28003, -1814.40601, 12.26600,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2288.28003, -1818.90601, 12.26200,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2290.39404, -1821.40503, 12.26200,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2285.98706, -1804.78296, 12.26600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2282.23096, -1802.67505, 12.26600,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2284.65601, -1804.79102, 12.26400,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2285.89404, -1821.40503, 12.26200,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2281.39404, -1821.40503, 12.25800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2276.89404, -1821.40503, 12.26200,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2272.39404, -1821.40503, 12.25800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2267.89404, -1821.40503, 12.26200,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2263.39404, -1821.40503, 12.25800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2259.89404, -1821.40503, 12.26200,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2960, 2257.80811, -1818.90198, 12.25800,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2257.80811, -1814.40198, 12.26200,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2257.80811, -1809.90198, 12.25800,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2257.80811, -1805.40198, 12.26200,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(2960, 2257.80811, -1804.40198, 12.25800,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(672, 2266.29395, -1764.09705, 12.40600,   0.00000, 0.00000, 90.66000);
CreateDynamicObject(2238, 2270.47900, -1797.93005, 11.24100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2238, 2270.47900, -1788.93005, 11.24100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2238, 2270.47900, -1780.93005, 11.24100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2238, 2276.47900, -1780.93005, 11.24100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2238, 2276.47900, -1788.93005, 11.24100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2238, 2276.47900, -1797.93005, 11.24100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2238, 2264.47900, -1797.93005, 11.24100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2238, 2263.97900, -1788.93005, 11.24100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2238, 2263.47900, -1780.93005, 11.24100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(617, 2287.05493, -1800.88794, 10.35100,   0.00000, 0.00000, -13.02000);
CreateDynamicObject(617, 2287.05493, -1789.38794, 10.35100,   0.00000, 0.00000, -62.70000);
CreateDynamicObject(617, 2287.05493, -1777.88794, 10.35100,   0.00000, 0.00000, -40.02000);
CreateDynamicObject(1280, 2293.88306, -1785.62903, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2293.88306, -1792.62903, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2293.88306, -1799.62903, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1340, 2296.45288, -1778.75806, 13.45400,   0.00000, 0.00000, -45.71900);
CreateDynamicObject(1341, 2328.98193, -1814.93896, 13.45400,   0.00000, 0.00000, -263.51901);
CreateDynamicObject(1344, 2320.14404, -1813.59998, 13.06400,   0.00000, 0.00000, -266.75900);
CreateDynamicObject(2121, 2330.02905, -1815.99597, 12.83800,   0.00000, 0.00000, 213.53900);
CreateDynamicObject(2121, 2294.70508, -1776.98999, 12.83800,   0.00000, 0.00000, 26.70000);
CreateDynamicObject(1280, 2330.39893, -1796.58606, 12.67900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2330.39893, -1801.58606, 12.67900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2330.39893, -1806.58606, 12.67900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18739, 2276.48901, -1797.90503, 11.61400,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18739, 2270.50000, -1797.91101, 11.60900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18739, 2264.50195, -1797.93396, 11.60400,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18739, 2263.95996, -1788.94495, 11.58300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18739, 2270.46802, -1788.89905, 11.58800,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18739, 2276.46704, -1788.93298, 11.62400,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18739, 2276.46606, -1780.93604, 11.61600,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18739, 2270.49292, -1780.94104, 11.61300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(18739, 2263.50000, -1780.91797, 11.61500,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2282.54810, -1820.90503, 12.67900,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1344, 2364.41504, -1815.17603, 13.06400,   0.00000, 0.00000, -170.27901);
CreateDynamicObject(1280, 2347.46997, -1796.14099, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2347.46997, -1801.14099, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2347.46997, -1781.64099, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2347.46997, -1776.64099, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2347.46997, -1771.64099, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2347.46997, -1805.64099, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1294, 2329.94092, -1815.41394, 16.76700,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(782, 2361.13989, -1813.50500, 12.23700,   0.00000, 0.00000, -33.47900);
CreateDynamicObject(782, 2362.01807, -1764.54102, 12.23700,   0.00000, 0.00000, -67.56000);
CreateDynamicObject(1280, 2261.54810, -1820.90503, 12.67900,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2258.38403, -1817.56299, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1294, 2285.38306, -1820.41199, 16.51200,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1294, 2259.03589, -1820.40198, 16.51200,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1294, 2258.92212, -1803.92700, 16.51200,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2258.38403, -1812.06299, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1280, 2258.38403, -1806.56299, 12.67900,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(1281, 2286.62012, -1783.34204, 13.17900,   0.00000, 0.00000, 39.48000);
CreateDynamicObject(1642, 2288.06592, -1797.98706, 12.42800,   0.00000, 0.00000, -70.07900);
CreateDynamicObject(1641, 2288.16602, -1795.54297, 12.42800,   0.00000, 0.00000, -151.25900);
CreateDynamicObject(2663, 2287.16797, -1797.29797, 12.63100,   0.00000, 0.00000, -30.54000);
CreateDynamicObject(2749, 2287.79810, -1797.18298, 12.40700,   0.00000, 0.00000, -434.04001);
CreateDynamicObject(2749, 2287.77808, -1797.03198, 12.40700,   0.00000, 0.00000, -434.04001);
CreateDynamicObject(2751, 2298.11011, -1770.30200, 12.47200,   0.00000, 0.00000, -93.11900);
CreateDynamicObject(2960, 2294.99512, -1821.41101, 12.26200,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2279.52100, -1822.36804, 10.78300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2272.02100, -1822.36804, 10.78300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2265.02100, -1822.36804, 10.78300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2256.72998, -1814.87695, 10.78300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(673, 2256.72998, -1808.87695, 10.78300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(617, 2275.68994, -1771.85901, 10.35100,   0.00000, 0.00000, -40.02000);
CreateDynamicObject(617, 2259.28711, -1773.11597, 10.35100,   0.00000, 0.00000, 38.75900);
CreateDynamicObject(617, 2253.14990, -1782.72095, 10.35100,   0.00000, 0.00000, -51.59900);
CreateDynamicObject(617, 2253.84790, -1794.62097, 10.35100,   0.00000, 0.00000, -122.33900);
CreateDynamicObject(617, 2249.78589, -1803.95105, 10.35100,   0.00000, 0.00000, -82.62000);
CreateDynamicObject(617, 2248.36401, -1814.69495, 10.35100,   0.00000, 0.00000, 29.81900);
CreateDynamicObject(617, 2253.31494, -1825.24194, 10.35100,   0.00000, 0.00000, -43.50000);
CreateDynamicObject(617, 2266.01392, -1829.05103, 10.35100,   0.00000, 0.00000, -89.75900);
CreateDynamicObject(617, 2278.48608, -1829.43896, 10.35100,   0.00000, 0.00000, -153.59900);
CreateDynamicObject(759, 2286.79395, -1826.38501, 11.81300,   0.00000, 0.00000, -79.50000);
CreateDynamicObject(763, 2229.14111, -1796.33105, 11.81300,   0.00000, 0.00000, -79.50000);
CreateDynamicObject(759, 2289.72510, -1802.81201, 11.81300,   0.00000, 0.00000, -64.14000);
CreateDynamicObject(759, 2282.12305, -1766.70203, 11.81300,   0.00000, 0.00000, -139.97900);
CreateDynamicObject(800, 2277.97803, -1827.64197, 12.30300,   0.00000, 0.00000, -35.52000);
CreateDynamicObject(800, 2269.99292, -1827.40295, 12.30300,   0.00000, 0.00000, -105.95900);
CreateDynamicObject(869, 2343.81201, -1772.86597, 12.66300,   0.00000, 0.00000, 385.19901);
CreateDynamicObject(869, 2336.88501, -1768.83496, 12.66300,   0.00000, 0.00000, 477.53900);
CreateDynamicObject(869, 2339.09399, -1768.48804, 12.66300,   0.00000, 0.00000, 510.41901);
CreateDynamicObject(869, 2342.58105, -1769.03003, 12.66300,   0.00000, 0.00000, 501.71899);
CreateDynamicObject(1342, 2285.98901, -1818.33997, 13.45400,   0.00000, 0.00000, -255.66000);
CreateDynamicObject(805, 2248.65308, -1813.88794, 12.80300,   0.00000, 0.00000, -121.26000);
CreateDynamicObject(3515, 2270.56104, -1788.86694, 10.30800,   0.00000, 0.00000, -56.58000);
CreateDynamicObject(1281, 2263.67505, -1825.53296, 13.00900,   0.00000, 0.00000, 19.44000);
CreateDynamicObject(1479, 2254.11597, -1802.51001, 13.70500,   0.00000, 0.00000, 272.94000);
CreateDynamicObject(1280, 2253.82397, -1802.59399, 12.74700,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2762, 2255.65210, -1802.61499, 12.77400,   0.00000, 0.00000, -80.63900);
CreateDynamicObject(947, 2269.39307, -1820.08301, 14.48500,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2277.04810, -1820.90503, 12.67900,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(617, 2246.72412, -1790.41003, 10.35100,   0.00000, 0.00000, -8.15900);
CreateDynamicObject(617, 2252.29297, -1767.30005, 10.35100,   0.00000, 0.00000, 67.01900);
CreateDynamicObject(617, 2245.34399, -1776.05103, 10.35100,   0.00000, 0.00000, -14.04000);
CreateDynamicObject(617, 2236.69312, -1782.91602, 10.35100,   0.00000, 0.00000, -61.38000);
CreateDynamicObject(800, 2248.95288, -1801.68005, 12.30300,   0.00000, 0.00000, -205.19901);
CreateDynamicObject(837, 2250.89795, -1789.02795, 12.80300,   0.00000, 0.00000, -468.12000);
CreateDynamicObject(800, 2252.57910, -1786.30200, 12.42100,   0.00000, 0.00000, -54.00000);
CreateDynamicObject(9153, 2242.64502, -1776.28198, 12.42100,   0.00000, 0.00000, 55.13900);
CreateDynamicObject(617, 2232.49512, -1776.19495, 10.35100,   0.00000, 0.00000, -61.38000);
CreateDynamicObject(617, 2240.91602, -1765.39404, 10.35100,   0.00000, 0.00000, -14.04000);
CreateDynamicObject(800, 2252.13208, -1824.70605, 12.30300,   0.00000, 0.00000, -105.95900);
CreateDynamicObject(617, 2258.36792, -1830.99805, 10.35100,   0.00000, 0.00000, -148.50000);
CreateDynamicObject(617, 2244.82300, -1830.20300, 10.35100,   0.00000, 0.00000, -250.25999);
CreateDynamicObject(617, 2254.03198, -1833.06995, 10.35100,   0.00000, 0.00000, -178.43900);
CreateDynamicObject(1479, 2230.31006, -1808.59497, 13.70500,   0.00000, 0.00000, 272.94000);
CreateDynamicObject(1479, 2230.92310, -1821.80200, 13.70500,   0.00000, 0.00000, 272.94000);
CreateDynamicObject(1481, 2304.14502, -1766.59802, 12.92500,   0.00000, 0.00000, -162.72000);
CreateDynamicObject(1481, 2333.27002, -1774.90295, 12.92500,   0.00000, 0.00000, -249.59900);
CreateDynamicObject(782, 2339.57910, -1767.61206, 12.29300,   0.00000, 0.00000, -163.73900);
CreateDynamicObject(617, 2237.26709, -1794.87805, 10.35100,   0.00000, 0.00000, -61.38000);
CreateDynamicObject(617, 2235.55005, -1824.08606, 10.35100,   0.00000, 0.00000, -108.12000);
CreateDynamicObject(2762, 2233.23511, -1820.68896, 12.77400,   0.00000, 0.00000, -80.63900);
CreateDynamicObject(2762, 2232.36694, -1808.60901, 12.77400,   0.00000, 0.00000, -106.68000);
CreateDynamicObject(1280, 2229.89502, -1808.03699, 12.74700,   0.00000, 0.00000, 165.66000);
CreateDynamicObject(1280, 2231.01196, -1821.82300, 12.74700,   0.00000, 0.00000, 188.87900);
CreateDynamicObject(617, 2234.02100, -1831.97803, 10.35100,   0.00000, 0.00000, -129.72000);
CreateDynamicObject(617, 2238.14600, -1814.68396, 10.35100,   0.00000, 0.00000, -50.70000);
CreateDynamicObject(617, 2235.61108, -1803.50305, 10.35100,   0.00000, 0.00000, -125.76000);
CreateDynamicObject(617, 2229.16699, -1768.96997, 10.35100,   0.00000, 0.00000, -125.76000);
CreateDynamicObject(620, 2200.03101, -1665.80603, 12.66100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(620, 2194.73999, -1688.36694, 12.66100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(620, 2192.21704, -1710.63000, 12.66100,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 2304.02588, -1742.03296, 12.89800,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2299.02588, -1742.03296, 12.89800,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2285.52588, -1742.03296, 12.89800,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2279.52588, -1742.03296, 12.89800,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2267.52588, -1742.03296, 12.89800,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2261.02588, -1742.03296, 12.89800,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2249.02588, -1742.03296, 12.89800,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(1280, 2243.02588, -1742.03296, 12.89800,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(617, 2276.40698, -1763.37305, 10.35100,   0.00000, 0.00000, -10.19900);
CreateDynamicObject(869, 2284.89307, -1792.24695, 12.66300,   0.00000, 0.00000, 246.89900);
CreateDynamicObject(869, 2284.60498, -1801.87305, 12.66300,   0.00000, 0.00000, 285.83899);
CreateDynamicObject(869, 2284.31299, -1797.27100, 12.66300,   0.00000, 0.00000, 246.48000);
CreateDynamicObject(1281, 2281.54102, -1771.80505, 13.17900,   0.00000, 0.00000, 113.76000);
CreateDynamicObject(1281, 2260.68506, -1767.68994, 13.17900,   0.00000, 0.00000, 47.28000);
CreateDynamicObject(1479, 2271.96509, -1770.49304, 13.70500,   0.00000, 0.00000, 173.46001);
CreateDynamicObject(1280, 2271.91211, -1770.70703, 12.67900,   0.00000, 0.00000, 82.74000);
CreateDynamicObject(970, 2336.05005, -1761.10303, 12.89500,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(970, 2338.05005, -1761.10303, 12.89500,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(970, 2340.05005, -1761.10303, 12.89500,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(970, 2342.05005, -1761.10303, 12.89500,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(970, 2343.86304, -1761.13000, 12.89500,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1481, 2231.23389, -1817.41199, 12.92700,   0.00000, 0.00000, 66.66000);
CreateDynamicObject(617, 2229.43799, -1815.17395, 10.49800,   0.00000, 0.00000, -125.76000);
CreateDynamicObject(617, 2230.39111, -1828.32104, 10.49800,   0.00000, 0.00000, -73.38000);
CreateDynamicObject(2674, 2245.71802, -1741.52002, 12.56300,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(869, 2282.65601, -1824.11206, 12.66300,   0.00000, 0.00000, 169.97900);
CreateDynamicObject(869, 2279.37012, -1824.11597, 12.66300,   0.00000, 0.00000, 169.97900);
CreateDynamicObject(869, 2257.40601, -1823.97803, 12.66300,   0.00000, 0.00000, 169.97900);
CreateDynamicObject(869, 2255.78101, -1821.49402, 12.66300,   0.00000, 0.00000, 104.33900);
CreateDynamicObject(869, 2255.81299, -1816.46997, 12.66300,   0.00000, 0.00000, 76.43900);
CreateDynamicObject(869, 2255.77710, -1811.25903, 12.66300,   0.00000, 0.00000, 76.43900);

//Pintu tol ls bawah

CreateDynamicObject(966, 48.00000, -1526.69995, 4.10000,   0.00000, 0.00000, 261.99695);
CreateDynamicObject(966, 59.03490, -1537.49719, 4.04000,   0.00000, 0.00000, 83.99600);
CreateDynamicObject(997, 43.42704, -1530.04956, 4.80502,   0.00000, 0.00000, 262.00000);
CreateDynamicObject(979, 71.40000, -1522.50000, 4.70000,   0.00000, 0.00000, 176.00000);
CreateDynamicObject(979, 53.19922, -1520.39941, 5.00000,   0.00000, 0.00000, 171.99646);
CreateDynamicObject(979, 62.29980, -1521.59961, 4.90000,   0.00000, 0.00000, 171.99646);
CreateDynamicObject(979, 80.10000, -1523.09998, 4.60000,   0.00000, 0.00000, 175.99646);
CreateDynamicObject(978, 52.70000, -1527.90002, 4.90000,   0.00000, 0.00000, 352.00000);
CreateDynamicObject(978, 60.40000, -1529.09998, 4.80000,   0.00000, 0.00000, 349.99646);
CreateDynamicObject(978, 68.90000, -1530.59998, 4.80000,   0.00000, 0.00000, 349.99146);
CreateDynamicObject(978, 77.80000, -1532.00000, 5.00000,   0.00000, 0.00000, 349.99146);
CreateDynamicObject(997, 61.70690, -1532.71924, 4.74690,   0.00000, 0.00000, 261.99649);
CreateDynamicObject(979, 52.50000, -1543.40002, 5.20000,   0.00000, 0.00000, 349.99646);
CreateDynamicObject(979, 43.40000, -1541.90002, 5.20000,   0.00000, 0.00000, 351.99146);
CreateDynamicObject(979, 34.50000, -1540.50000, 4.90000,   0.00000, 357.00000, 351.99097);
CreateDynamicObject(979, 25.70000, -1538.19995, 4.50000,   0.00000, 356.99524, 339.99097);
CreateDynamicObject(979, 17.50000, -1535.19995, 3.90000,   0.00000, 356.00000, 339.98840);


//Pintu tol ls-lv
CreateDynamicObject(19377, 1754.12976, 554.93787, 31.46818,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(19428, 1751.86292, 558.46729, 29.68682,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19377, 1763.69312, 551.82715, 31.46818,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(19377, 1762.28015, 547.47479, 32.63330,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1763.55908, 542.52130, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1739.18506, 553.56720, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(18762, 1755.40820, 549.98456, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1750.65552, 551.52881, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1758.23242, 552.20813, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(18762, 1759.35657, 555.67053, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(18762, 1757.12378, 558.49744, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1752.37134, 560.04047, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1765.36194, 555.83124, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1762.40173, 556.79218, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1758.08252, 549.95850, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(18762, 1757.03918, 546.74432, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(18762, 1759.26184, 543.91791, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(19377, 1762.28015, 547.47485, 31.46818,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(19377, 1754.12976, 554.93793, 32.63360,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(19377, 1763.69312, 551.82721, 32.63300,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(19377, 1744.67773, 558.00842, 32.63360,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1741.20349, 554.59930, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1745.95618, 553.05505, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(19377, 1744.67773, 558.00836, 31.46818,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1749.90454, 558.74103, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(18762, 1747.67175, 561.56793, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1767.63196, 555.09039, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(19377, 1735.08362, 556.29907, 32.63330,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1732.06531, 552.74219, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1729.84265, 555.56860, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(18762, 1736.36255, 551.34558, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(19377, 1735.08362, 556.29913, 31.46818,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1730.85022, 558.67444, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(19377, 1736.48560, 560.65552, 32.63300,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1732.39075, 563.42096, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(19377, 1763.33704, 549.29584, 24.84140,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(18762, 1738.16541, 564.65552, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1742.91931, 563.11096, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1735.20520, 565.61646, 32.05335,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(18762, 1766.38464, 544.74872, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(18762, 1767.91040, 549.44769, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(18762, 1768.62378, 551.65704, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(19428, 1752.31909, 557.56415, 29.67758,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19428, 1752.32043, 557.56531, 26.30630,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19428, 1752.76404, 558.92792, 29.67758,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19428, 1752.76404, 558.92792, 26.30630,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19428, 1753.22144, 558.02466, 26.30630,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19428, 1753.22144, 558.02466, 29.78660,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19428, 1751.86292, 558.46729, 26.30630,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19428, 1748.90198, 558.67285, 26.30630,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19428, 1748.90063, 558.67169, 29.67758,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19428, 1748.44446, 559.57483, 26.30630,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19428, 1748.44446, 559.57483, 29.68682,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19428, 1749.34558, 560.03546, 26.30630,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19428, 1749.34558, 560.03546, 29.67758,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19428, 1749.80298, 559.13220, 26.30630,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19428, 1749.80298, 559.13220, 29.78660,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19355, 1750.61816, 558.88336, 26.21967,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19377, 1736.48560, 560.65546, 31.46818,   0.00000, 90.00000, -18.00000);
CreateDynamicObject(19377, 1763.33704, 549.29590, 25.18540,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(19377, 1763.33704, 549.29584, 25.01740,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(19377, 1763.33704, 549.29584, 24.69340,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(19387, 1764.27454, 544.04669, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1761.22546, 545.03876, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1758.85999, 545.80811, 30.48639,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1757.90222, 547.77148, 24.28050,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1758.89258, 550.82300, 24.28050,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1759.88184, 553.86932, 24.28050,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1759.98987, 554.20441, 24.28050,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1767.48706, 553.36560, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1764.43677, 554.35742, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1761.90430, 555.17737, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1768.39941, 551.30347, 27.00640,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1767.42041, 548.24310, 27.00640,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1766.42407, 545.21094, 27.00640,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1766.34192, 544.96442, 27.00640,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19447, 1758.96973, 550.98755, 28.70412,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1758.85999, 545.80811, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1761.89380, 544.82245, 30.48639,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1757.90222, 547.77142, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1758.89258, 550.82294, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1759.88184, 553.86926, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1764.43677, 554.35742, 30.49350,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1767.48706, 553.36560, 30.49350,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1761.90430, 555.17737, 30.49350,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1768.39941, 551.30341, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1767.42041, 548.24310, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1766.34192, 544.96436, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1766.42407, 545.21094, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1764.39526, 544.00940, 30.48639,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1759.98987, 554.20447, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19377, 1735.07019, 558.38794, 25.18540,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(19377, 1735.07019, 558.38788, 25.01740,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(19377, 1735.07019, 558.38788, 24.84140,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(19377, 1735.07019, 558.38788, 24.69340,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(19367, 1738.59766, 553.95593, 24.28050,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1739.58801, 557.00745, 24.28050,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1740.57727, 560.05371, 24.28050,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1740.68530, 560.38885, 24.28050,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19447, 1739.62207, 557.18719, 28.70412,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1738.59766, 553.95587, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1739.58801, 557.00739, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1740.57727, 560.05371, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1740.68530, 560.38892, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1731.10889, 554.79724, 30.49350,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1734.09814, 553.82220, 30.49350,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1736.68579, 552.98230, 30.49350,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1736.68579, 552.98230, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1734.09814, 553.82220, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19387, 1731.10742, 554.79443, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1734.12646, 564.11407, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1736.65894, 563.29413, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1739.70923, 562.30231, 27.00640,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1739.70923, 562.30231, 30.49350,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1736.65894, 563.29413, 30.49350,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1734.12646, 564.11407, 30.49350,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19367, 1732.21118, 563.12903, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1731.23218, 560.06873, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1730.15369, 556.78998, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1730.23584, 557.03656, 30.49350,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1730.15369, 556.79004, 27.00640,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1731.23218, 560.06873, 27.00640,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1732.21118, 563.12909, 27.00640,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19367, 1730.23584, 557.03656, 27.00640,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1757.65588, 546.71088, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1757.96448, 547.65875, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1759.19617, 551.45746, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1759.50354, 552.40723, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1759.81250, 553.35669, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1758.27100, 548.60931, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1758.57837, 549.55908, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1758.88733, 550.50854, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1760.12036, 554.30743, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1760.31958, 554.92523, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1738.26392, 553.08270, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1738.57251, 554.03058, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1738.87903, 554.98114, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1739.18640, 555.93091, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1739.49536, 556.88037, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1739.80420, 557.82928, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1740.11157, 558.77905, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1740.42053, 559.72852, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1740.72839, 560.67926, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19939, 1740.92761, 561.29706, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19447, 1749.02332, 554.03711, 33.73288,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19939, 1760.40649, 555.19165, 26.01980,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(14397, 1737.34387, 553.24902, 16.81246,   0.50000, 90.40002, -17.60001);
CreateDynamicObject(14397, 1740.33655, 562.36938, 16.29663,   -0.10000, 90.70001, -17.60001);
CreateDynamicObject(14397, 1732.00586, 565.07605, 16.40352,   -0.10000, 90.70001, -17.60001);
CreateDynamicObject(14397, 1729.01611, 555.81677, 16.42112,   -0.10000, 90.70001, -17.60001);
CreateDynamicObject(14397, 1756.75671, 546.86951, 16.06524,   -0.10000, 90.70001, -17.60001);
CreateDynamicObject(14397, 1765.14392, 544.14612, 16.67017,   -0.10000, 89.90002, -17.60001);
CreateDynamicObject(14397, 1768.16809, 553.41614, 16.65329,   -0.10000, 89.90002, -17.60001);
CreateDynamicObject(14397, 1759.94238, 556.08966, 16.63811,   -0.10000, 89.90002, -17.60001);
CreateDynamicObject(19377, 1735.89966, 558.61035, 28.98146,   0.00000, 90.00000, -17.90001);
CreateDynamicObject(19377, 1735.78040, 558.23901, 28.98146,   0.00000, 90.00000, -17.90001);
CreateDynamicObject(19377, 1762.67761, 550.04706, 28.98146,   0.00000, 90.00000, -17.90001);
CreateDynamicObject(19377, 1762.51697, 549.55200, 28.98146,   0.00000, 90.00000, -17.90001);
CreateDynamicObject(7914, 1749.07678, 554.38000, 34.27032,   0.00000, 0.00000, -17.99999);
CreateDynamicObject(19447, 1749.07544, 554.19891, 33.73288,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(19482, 1733.94775, 564.29150, 25.22247,   11.60000, 0.00000, 71.49996);
CreateDynamicObject(19482, 1733.94995, 564.28015, 25.20087,   11.60000, 0.00000, 71.49996);
CreateDynamicObject(18762, 1759.62305, 554.70502, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(18762, 1748.78040, 555.27863, 32.05330,   0.00000, 90.00000, -108.00000);
CreateDynamicObject(968, 1748.26379, 559.67621, 25.40680,   0.00000, 270.00000, -18.00000);
CreateDynamicObject(966, 1748.06897, 559.73309, 24.55967,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(966, 1753.63940, 558.00244, 24.55970,   0.00000, 0.00000, -198.00000);
CreateDynamicObject(968, 1753.44653, 558.05688, 25.40680,   0.00000, 270.00000, -198.00000);
CreateDynamicObject(1566, 1763.51672, 544.25049, 26.38930,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(1566, 1730.32568, 555.00903, 26.38930,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(19377, 1737.18494, 557.97241, 26.79509,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(2161, 1761.09753, 549.47211, 25.27170,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(2161, 1762.27136, 553.00873, 25.27170,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(2191, 1759.87244, 547.37201, 25.27360,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(2161, 1762.67566, 554.26630, 25.27170,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(1714, 1758.91760, 546.80432, 25.25800,   0.00000, 0.00000, 247.69228);
CreateDynamicObject(2202, 1761.47803, 551.81226, 25.27030,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(1714, 1739.46924, 560.47205, 25.25800,   0.00000, 0.00000, 72.75354);
CreateDynamicObject(1714, 1738.10730, 557.08911, 25.25800,   0.00000, 0.00000, 72.75354);
CreateDynamicObject(2161, 1737.68823, 558.99707, 25.27170,   0.00000, 0.00000, -288.00000);
CreateDynamicObject(2161, 1738.09863, 560.27307, 25.27170,   0.00000, 0.00000, -288.00000);
CreateDynamicObject(2202, 1737.31372, 557.96692, 25.27030,   0.00000, 0.00000, -108.00000);
CreateDynamicObject(2191, 1736.90967, 554.97223, 25.27360,   0.00000, 0.00000, -288.00000);
CreateDynamicObject(2161, 1735.96606, 553.85046, 25.27170,   0.00000, 0.00000, -288.00000);
CreateDynamicObject(1714, 1737.27881, 554.34277, 25.25800,   0.00000, 0.00000, 64.22140);
CreateDynamicObject(19377, 1761.41870, 550.10730, 26.79509,   0.00000, 0.00000, -18.00000);
CreateDynamicObject(1714, 1760.22473, 549.97522, 25.25800,   0.00000, 0.00000, 254.46921);
CreateDynamicObject(1714, 1761.49634, 553.93671, 25.25800,   0.00000, 0.00000, 254.46921);
CreateDynamicObject(1215, 1749.40564, 554.33337, 25.28928,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1748.69739, 552.14380, 25.28928,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1747.98401, 549.99878, 25.28928,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1739.82642, 554.56323, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1738.43701, 550.33466, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1728.82239, 553.42261, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1733.10742, 566.62610, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1757.41711, 548.97217, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1756.00537, 544.63928, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1765.67224, 541.51685, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1769.89490, 554.67773, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1751.34497, 560.67249, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1761.18396, 557.48755, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1741.32983, 563.96033, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1768.00403, 548.65259, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1761.31299, 542.85895, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1751.66467, 550.81744, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1744.79663, 553.04651, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1733.94031, 551.76825, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1730.82544, 559.68164, 32.71880,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1290, 1758.87402, 584.12170, 28.81153,   3.14159, 0.00000, 0.17853);
CreateDynamicObject(1215, 1752.15149, 557.17120, 24.66891,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1748.71265, 558.20215, 24.67549,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1744.62646, 555.51672, 35.42878,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1753.44702, 552.63611, 35.42878,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1750.12537, 553.71661, 35.42878,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1215, 1747.23474, 554.66644, 35.42878,   0.00000, 0.00000, 0.00000);

//Supermarket di stasiun kereta ls











CreateDynamicObject(19461, 1838.39331, -1850.57227, 14.09229,   0.00000, 0.00000, -89.82000);
CreateDynamicObject(19461, 1841.63684, -1850.56921, 14.09229,   0.00000, 0.00000, -89.82000);
CreateDynamicObject(19461, 1843.25671, -1855.12793, 14.33000,   0.00000, 0.00000, 0.06000);
CreateDynamicObject(1569, 1834.03479, -1841.12512, 12.64400,   0.00000, 0.00000, -90.60000);
CreateDynamicObject(1569, 1834.01233, -1844.09692, 12.64400,   0.00000, 0.00000, 89.03990);
CreateDynamicObject(970, 1833.87878, -1850.38110, 13.05430,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1833.86853, -1844.88489, 13.05430,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1833.77124, -1840.60681, 13.05430,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1833.75818, -1834.47559, 13.05430,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1831.81079, -1848.35754, 13.05430,   0.00000, 0.00000, 90.41999);
CreateDynamicObject(970, 1831.69946, -1838.51990, 13.05430,   0.00000, 0.00000, 90.41999);
CreateDynamicObject(970, 1831.70483, -1836.51221, 13.05430,   0.00000, 0.00000, 90.41999);
CreateDynamicObject(970, 1831.82495, -1846.93030, 13.05430,   0.00000, 0.00000, 90.41999);
CreateDynamicObject(1280, 1831.53796, -1848.11304, 12.95550,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1280, 1831.41431, -1837.59314, 12.95550,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1833.14026, -1846.34399, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1833.17493, -1848.99438, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1832.51270, -1849.04883, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1832.56555, -1846.38354, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1832.18518, -1846.38586, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1832.20313, -1849.10620, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1833.22400, -1835.87207, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1833.23877, -1838.16956, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1833.25818, -1839.25500, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1832.73218, -1839.24243, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1832.74524, -1837.00134, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1832.72559, -1835.91589, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1832.12341, -1835.93359, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1832.18872, -1838.46594, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1832.18701, -1839.23169, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1216, 1831.51660, -1845.12158, 13.26040,   0.00000, 0.00000, -90.66000);
CreateDynamicObject(1231, 1832.76160, -1844.81042, 14.06642,   0.00000, 0.00000, 83.82003);
CreateDynamicObject(1231, 1833.04688, -1840.80005, 14.06642,   0.00000, 0.00000, 96.12001);
CreateDynamicObject(19456, 1833.73877, -1835.07422, 13.35923,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19437, 1833.02686, -1830.25781, 13.35920,   0.00000, 0.00000, 90.54002);
CreateDynamicObject(19442, 1844.22656, -1853.89063, 17.96320,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19442, 1844.24280, -1855.47168, 17.96320,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19442, 1844.24011, -1857.07385, 17.96320,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19442, 1844.24670, -1858.05481, 17.96320,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19461, 1845.85010, -1851.33093, 14.35000,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(19461, 1836.23706, -1851.33093, 14.35000,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(19415, 1831.47852, -1852.79395, 14.33000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19415, 1831.47852, -1858.41992, 14.33000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19397, 1831.47852, -1855.67163, 14.33000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19466, 1831.43030, -1852.76160, 14.24408,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19466, 1831.41882, -1858.38477, 14.24408,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19461, 1843.64368, -1855.11743, 15.90000,   0.00000, -90.00000, 0.00000);
CreateDynamicObject(19461, 1840.11719, -1855.11743, 15.90000,   0.00000, -90.00000, 0.00000);
CreateDynamicObject(19461, 1836.71814, -1855.11743, 15.90000,   0.00000, -90.00000, 0.00000);
CreateDynamicObject(19461, 1833.20752, -1855.11743, 15.90000,   0.00000, -90.00000, 0.00000);
CreateDynamicObject(19415, 1834.73059, -1859.91882, 14.33000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19466, 1839.69434, -1859.92676, 14.24408,   0.00000, 0.00000, 89.27998);
CreateDynamicObject(19415, 1839.49915, -1859.91882, 14.33000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19466, 1834.67151, -1859.96838, 14.24408,   0.00000, 0.00000, 90.11997);
CreateDynamicObject(19442, 1832.32019, -1859.91882, 14.33000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19442, 1837.10962, -1859.91882, 14.33000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1569, 1831.35034, -1854.91016, 12.60100,   0.00000, 0.00000, 269.85321);
CreateDynamicObject(2714, 1831.30164, -1855.48120, 15.50000,   0.00000, 0.00000, -88.74000);
CreateDynamicObject(19442, 1832.25061, -1850.33813, 14.33000,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(19461, 1844.63965, -1860.03357, 10.33000,   0.00000, 0.00000, -89.82000);
CreateDynamicObject(638, 1830.93481, -1851.61450, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(970, 1830.40723, -1852.30200, 13.05430,   0.00000, 0.00000, 90.41999);
CreateDynamicObject(970, 1832.36523, -1850.25830, 13.05430,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(638, 1830.90527, -1853.19531, 13.16425,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19379, 1847.05322, -1855.15430, 12.51550,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(2372, 1834.28455, -1853.18628, 12.56780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2394, 1834.07520, -1852.65002, 13.29370,   0.00000, 0.00000, -89.82000);
CreateDynamicObject(2372, 1835.42590, -1853.08105, 12.56780,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2394, 1835.19617, -1852.54480, 13.29370,   0.00000, 0.00000, -89.82000);
CreateDynamicObject(2390, 1833.36804, -1851.71814, 13.55135,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2385, 1839.02490, -1851.47290, 12.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2385, 1839.02490, -1851.47290, 13.90000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2385, 1841.18665, -1851.46033, 12.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2385, 1841.23291, -1851.42517, 13.90000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2371, 1837.08899, -1859.43555, 12.54980,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2394, 1836.75537, -1858.80750, 13.27570,   0.00000, 1.50000, -89.82000);
CreateDynamicObject(2381, 1837.47461, -1858.71741, 13.30000,   0.00000, 0.00000, 89.76000);
CreateDynamicObject(2371, 1834.38403, -1859.43079, 12.54980,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2394, 1834.81213, -1858.73340, 13.27570,   0.00000, 1.50000, -89.82000);
CreateDynamicObject(2394, 1834.13721, -1858.78479, 13.27570,   0.00000, 1.50000, -89.82000);
CreateDynamicObject(2387, 1832.14624, -1852.42627, 12.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2387, 1832.14624, -1853.63220, 12.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2387, 1832.14624, -1859.02148, 12.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2387, 1832.14624, -1857.78394, 12.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2846, 1836.35815, -1858.88647, 12.62007,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2846, 1833.89697, -1858.87585, 12.62007,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2390, 1833.36804, -1851.71814, 14.55130,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2390, 1834.29456, -1851.61462, 14.55130,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2390, 1834.27380, -1851.76526, 13.55130,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1838.92871, -1851.78674, 13.52515,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1839.57605, -1851.80811, 13.52515,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1840.27502, -1851.84424, 13.52515,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1841.01965, -1851.76282, 13.52515,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1841.71973, -1851.77881, 13.52515,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1842.53955, -1851.80054, 13.52515,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1842.53955, -1851.80054, 14.40000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1842.53955, -1851.80054, 13.52515,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1841.71973, -1851.77881, 14.40000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1841.01965, -1851.76282, 14.40000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1840.27502, -1851.84424, 14.40000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1839.57605, -1851.80811, 14.40000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19624, 1838.92871, -1851.78674, 14.40000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2374, 1836.01819, -1851.67310, 13.49160,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2374, 1836.01819, -1851.67310, 14.49160,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2390, 1837.31787, -1851.66138, 14.55130,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2374, 1837.29346, -1851.62891, 13.49160,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2390, 1836.66687, -1851.66553, 14.55130,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2374, 1836.66577, -1851.64917, 13.49160,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2387, 1842.28113, -1859.49426, 12.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1216, 1831.42175, -1840.34180, 13.26040,   0.00000, 0.00000, -90.66000);
CreateDynamicObject(19324, 1833.26270, -1830.88818, 13.26040,   0.00000, 0.00000, -88.13999);
CreateDynamicObject(19324, 1833.24304, -1831.93445, 13.26040,   0.00000, 0.00000, -88.13999);
CreateDynamicObject(19324, 1833.18225, -1832.98511, 13.26040,   0.00000, 0.00000, -88.13999);
CreateDynamicObject(19324, 1833.11975, -1834.01599, 13.26040,   0.00000, 0.00000, -88.13999);
CreateDynamicObject(3089, 1843.16003, -1853.96680, 13.94480,   0.00000, 0.00000, 90.54000);
CreateDynamicObject(2387, 1842.53040, -1858.31287, 12.60000,   0.00000, 0.00000, 89.52002);
CreateDynamicObject(2385, 1842.05530, -1855.28394, 12.24000,   0.00000, 0.00000, 271.07990);
CreateDynamicObject(2941, 1841.91223, -1855.34631, 13.92290,   0.00000, 0.00000, -87.90000);
CreateDynamicObject(19624, 1841.88184, -1856.58167, 13.58510,   0.00000, 0.00000, -89.22000);
CreateDynamicObject(19624, 1841.88184, -1855.87512, 13.58510,   0.00000, 0.00000, -89.22000);
CreateDynamicObject(2846, 1840.42102, -1859.64453, 12.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2846, 1839.88867, -1859.82800, 12.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2412, 1831.66309, -1856.22864, 12.58010,   0.00000, 0.00000, 88.44000);
CreateDynamicObject(2412, 1831.69604, -1854.44678, 12.58010,   0.00000, 0.00000, 88.44000);
CreateDynamicObject(19171, 1843.04407, -1855.58948, 14.50000,   -90.00000, -90.50000, 0.00000);
CreateDynamicObject(19006, 1841.85303, -1855.99707, 13.67700,   0.00000, 0.00000, -174.00000);
CreateDynamicObject(2485, 1841.93713, -1856.55603, 13.67390,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19442, 1833.78748, -1850.33813, 14.33000,   0.00000, 0.00000, -90.00000);
CreateDynamicObject(19442, 1831.47852, -1851.06653, 14.33000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19379, 1836.64587, -1855.15430, 12.51550,   0.00000, 90.00000, 0.00000);
CreateDynamicObject(19442, 1841.90710, -1859.91675, 14.33000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19442, 1843.51306, -1859.91882, 14.33000,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19442, 1843.51306, -1859.91882, 10.89400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19442, 1841.92712, -1859.91553, 10.89400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19415, 1839.49915, -1859.91882, 10.89400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19442, 1837.10962, -1859.91882, 10.89400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19415, 1834.73059, -1859.91882, 10.89400,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19442, 1832.32019, -1859.91882, 10.89400,   0.00000, 0.00000, 90.00000);



	SetGameModeText("EL v1.0");
	// ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	ShowNameTags(1);
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetWeather(2);
	SetWorldTime(11);
	
	// SPECIAL
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/trains.txt");
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/pilots.txt");
    
    // LOS SANTOS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_inner.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_outer.txt");
    
    // OTHER AREAS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/whetstone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/bone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/flint.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/tierra.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/red_county.txt");

    printf("Total vehicles from files: %d",total_vehicles_from_files);
	return 1;
}

public OnGameModeExit(){
	mysql_close(koneksi);
	return 1;
}

//----------------------------------------------------------

public OnPlayerUpdate(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(IsPlayerNPC(playerid)) return 1;
	
	// No weapons in interiors
	//if(GetPlayerInterior(playerid) != 0 && GetPlayerWeapon(playerid) != 0) {
	    //SetPlayerArmedWeapon(playerid,0); // fists
	    //return 0; // no syncing until they change their weapon
	//}
	
	// Don't allow minigun
	if(GetPlayerWeapon(playerid) == WEAPON_MINIGUN) {
	    Kick(playerid);
	    return 0;
	}

	return 1;
}

public OnPlayerText(playerid, text[]){
	format(msg,sizeof(msg), "[{%06x}%d{FFFFFF}] {%06x}%s {FFFFFF}: %s",GetPlayerColor(playerid) >>> 8, playerid,  GetPlayerColor(playerid) >>> 8, PlayerInfo[playerid][pPlayerName], text);
	ProxDetector(30.0, playerid, msg, COLOR_WHITE);
	format(msg,sizeof(msg), "berkata: %s", text);
	SetPlayerChatBubble(playerid, msg, -1, 40.0, 5000);
	ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1000);
}

//----------------------------------------------------------

#include <command>
