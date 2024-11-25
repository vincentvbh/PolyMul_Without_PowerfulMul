
#include <assert.h>

#include <stdint.h>
#include <stdio.h>

#include "hal.h"

// #include "params.h"
#include "NTT_params.h"
#include "ring.h"

#include "tools.h"
#include "naive_mult.h"
#include "gen_table.h"
#include "ntt_c.h"

struct compress_profile profile;

int32_t const_buff[8] = {
Qprime, Q, RmodQ, RmodQhi
};

static int32_t gethi(int32_t a){

    int32_t t;
    t = RmodQ;

    coeff_ring.mulZ(&t, &a, &t);
    return t * Qprime;

}

char out[128];

#define ITERATIONS 10000

extern void __asm_NTT(int32_t*, int32_t*, int32_t*);
extern void __asm_iNTT(int32_t*, int32_t*, int32_t*);
extern void __asm_point_mul_pre(int32_t*, int32_t*, int32_t*, int32_t*);
extern void __asm_extend(int32_t*, int32_t*, int32_t*);
extern void __asm_point_montmul(int32_t*, int32_t*, int32_t*, int32_t*);


extern void __asm_NTT_fast(int32_t*, int32_t*, int32_t*);
extern void __asm_iNTT_fast(int32_t*, int32_t*, int32_t*);
extern void __asm_point_mul_pre_fast(int32_t*, int32_t*, int32_t*, int32_t*);
extern void __asm_point_montmul_fast(int32_t*, int32_t*, int32_t*, int32_t*);

extern void __asm_iNTT_negacyclic(int32_t*, int32_t*, int32_t*);

// ================

// common buffer
int32_t streamlined_twiddle_table[N << 1];

// ================

static
int32_t streamlined_CT_table[N << 1] = {
-3572223, -1830765815, 3765607, 1929875198, 3761513, 1927777021, -3201494, -1640767044, -2883726, -1477910808, -3145678, -1612161320, -3201430, -1640734244, -601683, -308362795, 3542485, 1815525077, 2682288, 1374673747, 2129892, 1091570561, 3764867, 1929495947, -1005239, -515185417, 557458, 285697463, -1221177, -625853735, -3370349, -1727305304, -4063053, -2082316400, 2663378, 1364982364, -1674615, -858240904, -3524442, -1806278032, -434125, -222489248, 676590, 346752664, -1335936, -684667771, -3227876, -1654287830, 1714295, 878576921, 2453983, 1257667337, 1460718, 748618600, -642628, -329347125, -3585098, -1837364258, 2815639, 1443016191, 2283733, 1170414139, 3602218, 1846138265, 3182878, 1631226336, 2740543, 1404529459, -3586446, -1838055109, -3110818, -1594295555, 2101410, 1076973524, 3704823, 1898723372, 1159875, 594436433, 394148, 202001019, 928749, 475984260, 1095468, 561427818, -3506380, -1797021249, 2071829, 1061813248, -4018989, -2059733581, 3241972, 1661512036, 2156050, 1104976547, 3415069, 1750224323, 1759347, 901666090, -817536, -418987550, -3574466, -1831915353, 3756790, 1925356481, -1935799, -992097815, -1716988, -879957084, -3950053, -2024403852, -2897314, -1484874664, 3192354, 1636082790, 556856, 285388938, 3870317, 1983539117, 2917338, 1495136972, 1853806, 950076368, 3345963, 1714807468, 1858416, 952438995, 3073009, 1574918427, 1277625, 654783359, -2635473, -1350681039, 3852015, 1974159335, 4183372, 2143979939, -3222807, -1651689966, -3121440, -1599739335, -274060, -140455867, 2508980, 1285853323, 2028118, 1039411342, 1937570, 993005454, -3815725, -1955560694, 2811291, 1440787840, -2983781, -1529189038, -1109516, -568627424, 4158088, 2131021878, 1528066, 783134478, 482649, 247357819, 1148858, 588790216, -2962264, -1518161567, -565603, -289871779, 169688, 86965173, 2462444, 1262003603, -3334383, -1708872713, -4166425, -2135294594, -3488383, -1787797779, 1987814, 1018755525, -3197248, -1638590967, 1736313, 889861155, 235407, 120646188, -3250154, -1665705315, 3258457, 1669960606, -2579253, -1321868265, 1787943, 916321552, -2391089, -1225434135, -2254727, -1155548552, 3482206, 1784632064, -4182915, -2143745726, -1300016, -666258756, -2362063, -1210558298, -1317678, -675310538, 2461387, 1261461890, 3035980, 1555941048, 621164, 318346816, 3901472, 1999506068, -1226661, -628664287, 2925816, 1499481951, 3374250, 1729304568, 1356448, 695180180, -2775755, -1422575624, 2683270, 1375177022, -2778788, -1424130038, -3467665, -1777179795, 2312838, 1185330464, -653275, -334803717, -459163, -235321234, 348812, 178766299, -327848, -168022240, 1011223, 518252220, -2354215, -1206536194, -3818627, -1957047970, -1922253, -985155484, -2236726, -1146323031, 1744507, 894060583, 1753, 898413, -1935420, -991903578, -2659525, -1363007700, -1455890, -746144248, 2660408, 1363460238, -1780227, -912367099, -59148, -30313375, 2772600, 1420958686, 1182243, 605900043, 87208, 44694137, 636927, 326425360, -3965306, -2032221021, -3956745, -2027833504, -2296397, -1176904444, -3284915, -1683520342, -3716946, -1904936414, -27812, -14253662, 822541, 421552614, 1009365, 517299994, -2454145, -1257750362, -1979497, -1014493059, 1596822, 818371958, -3956944, -2027935492, -3759465, -1926727420, -1685153, -863641633, -3410568, -1747917558, 2678278, 1372618620, -3768948, -1931587462, -3551006, -1819892093, 635956, 325927722, -250446, -128353682, -2455377, -1258381762, -4146264, -2124962073, -1772588, -908452108, 2192938, 1123881663, -1727088, -885133339, 2387513, 1223601433, -3611750, -1851023419, -268456, -137583815, -3180456, -1629985060, 3747250, 1920467227, 2296099, 1176751719, 1239911, 635454918, -3838479, -1967222129, 3195676, 1637785316, 2642980, 1354528380, 1254190, 642772911, -12417, -6363718, 2998219, 1536588520, 141835, 72690498, -89301, -45766801, 2513018, 1287922800, -1354892, -694382729, 613238, 314284737, -1310261, -671509323, -2218467, -1136965286, -458740, -235104446, -1921994, -985022747, 4040196, 2070602178, -3472069, -1779436847, 2039144, 1045062172, -1879878, -963438279, -818761, -419615363, -2178965, -1116720494, -1623354, -831969619, 2105286, 1078959975, -2374402, -1216882040, -2033807, -1042326957, 586241, 300448763, -1179613, -604552167, 527981, 270590488, -2743411, -1405999311, -1476985, -756955444, 1994046, 1021949428, 2491325, 1276805128, -1393159, -713994583, 507927, 260312805, -1187885, -608791570, -724804, -371462360, -1834526, -940195359, -3033742, -1554794072, -338420, -173440395, 2647994, 1357098057, 3009748, 1542497137, -2612853, -1339088280, 4148469, 2126092136, 749577, 384158533, -4022750, -2061661095, 3980599, 2040058690, 2569011, 1316619236, -1615530, -827959816, 1723229, 883155599, 1665318, 853476187, 2028038, 1039370342, 1163598, 596344473, -3369273, -1726753853, 3994671, 2047270596, -11879, -6087993, -1370517, -702390549, 3020393, 1547952704, 3363542, 1723816713, 214880, 110126092, 545376, 279505433, -770441, -394851342, 3105558, 1591599803, -1103344, -565464272, 508145, 260424530, -553718, -283780712, 860144, 440824168, 3430436, 1758099917, 140244, 71875110, -1514152, -776003547, -2185084, -1119856484, 3123762, 1600929361, 2358373, 1208667171, -2193087, -1123958025, -3014420, -1544891539, -1716814, -879867909, 2926054, 1499603926, -392707, -201262505, -303005, -155290192, 3531229, 1809756372, -3974485, -2036925262, -3773731, -1934038751, 1900052, 973777462, -781875, -400711272, 1054478, 540420426, -731434, -374860238
};

// ================

static
int32_t streamlined_CT_fast_table[N << 1] = {
-3572223, -1830765815, 3765607, 1929875198, 3761513, 1927777021, -3201494, -1640767044, -601683, -308362795, 3542485, 1815525077, -2883726, -1477910808, 2682288, 1374673747, 2129892, 1091570561, -3145678, -1612161320, 3764867, 1929495947, -1005239, -515185417, -3201430, -1640734244, 557458, 285697463, -1221177, -625853735, -3370349, -1727305304, 3602218, 1846138265, 3182878, 1631226336, -4063053, -2082316400, 2740543, 1404529459, -3586446, -1838055109, 2663378, 1364982364, -3110818, -1594295555, 2101410, 1076973524, -1674615, -858240904, 3704823, 1898723372, 1159875, 594436433, -3524442, -1806278032, 394148, 202001019, 928749, 475984260, -434125, -222489248, 1095468, 561427818, -3506380, -1797021249, 676590, 346752664, 2071829, 1061813248, -4018989, -2059733581, -1335936, -684667771, 3241972, 1661512036, 2156050, 1104976547, -3227876, -1654287830, 3415069, 1750224323, 1759347, 901666090, 1714295, 878576921, -817536, -418987550, -3574466, -1831915353, 2453983, 1257667337, 3756790, 1925356481, -1935799, -992097815, 1460718, 748618600, -1716988, -879957084, -3950053, -2024403852, -642628, -329347125, -2897314, -1484874664, 3192354, 1636082790, -3585098, -1837364258, 556856, 285388938, 3870317, 1983539117, 2815639, 1443016191, 2917338, 1495136972, 1853806, 950076368, 2283733, 1170414139, 3345963, 1714807468, 1858416, 952438995, 3073009, 1574918427, 1753, 898413, -1935420, -991903578, 1277625, 654783359, -2659525, -1363007700, -1455890, -746144248, -2635473, -1350681039, 2660408, 1363460238, -1780227, -912367099, 3852015, 1974159335, -59148, -30313375, 2772600, 1420958686, 4183372, 2143979939, 1182243, 605900043, 87208, 44694137, -3222807, -1651689966, 636927, 326425360, -3965306, -2032221021, -3121440, -1599739335, -3956745, -2027833504, -2296397, -1176904444, -274060, -140455867, -3284915, -1683520342, -3716946, -1904936414, 2508980, 1285853323, -27812, -14253662, 822541, 421552614, 2028118, 1039411342, 1009365, 517299994, -2454145, -1257750362, 1937570, 993005454, -1979497, -1014493059, 1596822, 818371958, -3815725, -1955560694, -3956944, -2027935492, -3759465, -1926727420, 2811291, 1440787840, -1685153, -863641633, -3410568, -1747917558, -2983781, -1529189038, 2678278, 1372618620, -3768948, -1931587462, -1109516, -568627424, -3551006, -1819892093, 635956, 325927722, 4158088, 2131021878, -250446, -128353682, -2455377, -1258381762, 1528066, 783134478, -4146264, -2124962073, -1772588, -908452108, 482649, 247357819, 2192938, 1123881663, -1727088, -885133339, 1148858, 588790216, 2387513, 1223601433, -3611750, -1851023419, -2962264, -1518161567, -268456, -137583815, -3180456, -1629985060, -565603, -289871779, 3747250, 1920467227, 2296099, 1176751719, 169688, 86965173, 1239911, 635454918, -3838479, -1967222129, 2462444, 1262003603, 3195676, 1637785316, 2642980, 1354528380, -3334383, -1708872713, 1254190, 642772911, -12417, -6363718, -4166425, -2135294594, 2998219, 1536588520, 141835, 72690498, -3488383, -1787797779, -89301, -45766801, 2513018, 1287922800, 1987814, 1018755525, -1354892, -694382729, 613238, 314284737, -3197248, -1638590967, -1310261, -671509323, -2218467, -1136965286, 1736313, 889861155, -458740, -235104446, -1921994, -985022747, 235407, 120646188, 4040196, 2070602178, -3472069, -1779436847, -3250154, -1665705315, 2039144, 1045062172, -1879878, -963438279, 3258457, 1669960606, -818761, -419615363, -2178965, -1116720494, -2579253, -1321868265, -1623354, -831969619, 2105286, 1078959975, 1787943, 916321552, -2374402, -1216882040, -2033807, -1042326957, -2391089, -1225434135, 586241, 300448763, -1179613, -604552167, -2254727, -1155548552, 527981, 270590488, -2743411, -1405999311, 3482206, 1784632064, -1476985, -756955444, 1994046, 1021949428, -4182915, -2143745726, 2491325, 1276805128, -1393159, -713994583, -1300016, -666258756, 507927, 260312805, -1187885, -608791570, -2362063, -1210558298, -724804, -371462360, -1834526, -940195359, -1317678, -675310538, -3033742, -1554794072, -338420, -173440395, 2461387, 1261461890, 2647994, 1357098057, 3009748, 1542497137, 3035980, 1555941048, -2612853, -1339088280, 4148469, 2126092136, 621164, 318346816, 749577, 384158533, -4022750, -2061661095, 3901472, 1999506068, 3980599, 2040058690, 2569011, 1316619236, -1226661, -628664287, -1615530, -827959816, 1723229, 883155599, 2925816, 1499481951, 1665318, 853476187, 2028038, 1039370342, 3374250, 1729304568, 1163598, 596344473, -3369273, -1726753853, 1356448, 695180180, 3994671, 2047270596, -11879, -6087993, -2775755, -1422575624, -1370517, -702390549, 3020393, 1547952704, 2683270, 1375177022, 3363542, 1723816713, 214880, 110126092, -2778788, -1424130038, 545376, 279505433, -770441, -394851342, -3467665, -1777179795, 3105558, 1591599803, -1103344, -565464272, 2312838, 1185330464, 508145, 260424530, -553718, -283780712, -653275, -334803717, 860144, 440824168, 3430436, 1758099917, -459163, -235321234, 140244, 71875110, -1514152, -776003547, 348812, 178766299, -2185084, -1119856484, 3123762, 1600929361, -327848, -168022240, 2358373, 1208667171, -2193087, -1123958025, 1011223, 518252220, -3014420, -1544891539, -1716814, -879867909, -2354215, -1206536194, 2926054, 1499603926, -392707, -201262505, -3818627, -1957047970, -303005, -155290192, 3531229, 1809756372, -1922253, -985155484, -3974485, -2036925262, -3773731, -1934038751, -2236726, -1146323031, 1900052, 973777462, -781875, -400711272, 1744507, 894060583, 1054478, 540420426, -731434, -374860238, -3576395, -1832903967
};

static
int32_t streamlined_GS_table[N << 1] = {
};

// ================

static
void ntt(int32_t a[N]) {
    __asm_NTT(a, streamlined_CT_table, const_buff);
}

// ================

static
void ntt_fast(int32_t a[N]) {
    __asm_NTT_fast(a, streamlined_CT_fast_table, const_buff);
}

// ================

int main(void){

    int32_t poly1[N], poly2[N];
    int32_t ref[N], res[N];

    int32_t scale, twiddle, t, omega, zeta;

    hal_setup(CLOCK_FAST);
    hal_send_str("\n============ IGNORE OUTPUT BEFORE THIS LINE ============\n");

    for(size_t i = 0; i < N; i++){
        t = rand() % Q;
        coeff_ring.memberZ(poly1 + i, &t);
        t = rand() % Q;
        coeff_ring.memberZ(poly2 + i, &t);
    }

    twiddle = -1;
    naive_mulR(ref, poly1, poly2, N, &twiddle, coeff_ring);

    hal_send_str("\n============ test started ============\n");

// ================

    profile.array_n = N;
    profile.ntt_n = N;
    profile.log_ntt_n = LOGNTT_N;
    profile.compressed_layers = 4;

    for(size_t i = 0; i < profile.compressed_layers; i++){
        profile.merged_layers[i] = 2;
    }

    scale = 1;
    zeta = omegaQ;
    coeff_ring.expZ(&omega, &zeta, 2);
    gen_streamlined_DWT_table(streamlined_twiddle_table,
            &scale, &omega, &zeta,
            profile, 0,
            coeff_ring
        );

// ================

    ntt(poly1);

// ================

    ntt_fast(poly2);

// ================

    __asm_point_montmul_fast(res, poly1, poly2, const_buff);

// ================

    profile.array_n = N;
    profile.ntt_n = N;
    profile.log_ntt_n = LOGNTT_N;
    profile.compressed_layers = 8;

    for(size_t i = 0; i < profile.compressed_layers; i++){
        profile.merged_layers[i] = 1;
    }

    scale = 1;
    zeta = omegaQ;
    coeff_ring.expZ(&zeta, &zeta, Q - 2);
    coeff_ring.expZ(&omega, &zeta, 2);
    gen_streamlined_DWT_table(streamlined_twiddle_table,
            &scale, &omega, &zeta,
            profile, 0,
            coeff_ring
        );

    for(size_t i = 0; i < N; i++){
        streamlined_GS_table[2 * i + 0] = streamlined_twiddle_table[i];
        streamlined_GS_table[2 * i + 1] = gethi(streamlined_twiddle_table[i]);
    }

    __asm_iNTT_negacyclic(res, streamlined_GS_table, const_buff);

    scale = INV256;
    for(size_t i = 0; i < N; i++){
        coeff_ring.mulZ(res + i, res + i, &scale);
    }

    scale = RmodQ;
    for(size_t i = 0; i < N; i++){
        coeff_ring.mulZ(res + i, res + i, &scale);
    }

// ================

    scale = 1;
    for(size_t i = 0; i < N; i++){
        coeff_ring.mulZ(ref + i, ref + i, &scale);
    }

    scale = 1;
    for(size_t i = 0; i < N; i++){
        coeff_ring.mulZ(res + i, res + i, &scale);
    }

    for(size_t i = 0; i < N; i++){
        if(ref[i] != res[i]){
            sprintf(out, "%4zu: %12ld, %12ld", i, ref[i], res[i]);
            hal_send_str(out);
        }
    }

    hal_send_str("Test finished!\n");




}













