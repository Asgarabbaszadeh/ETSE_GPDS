/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ef4fb42 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "E:/valencia/ETSE_GDSP-master - Copy - Copy/Matrix_for_RBM/MATRIX_MUL_IP_CORE_S_INT/MATRIX_MUL_IP_CORE_S_INT.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1605435078_503743352(char *, unsigned char , unsigned char );
unsigned char ieee_p_2592010699_sub_1690584930_503743352(char *, unsigned char );
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_1804274199_3212880686_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    int t8;
    int t9;
    int t10;
    int t11;
    int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    unsigned char t17;
    unsigned char t18;
    int t19;
    int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    int t29;
    int t30;

LAB0:    xsi_set_current_line(105, ng0);
    t1 = (t0 + 1548U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 7704);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(106, ng0);
    t3 = (t0 + 7780);
    t4 = (t3 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)3;
    xsi_driver_first_trans_fast(t3);
    xsi_set_current_line(107, ng0);
    t1 = (t0 + 4792U);
    t3 = *((char **)t1);
    t1 = (t0 + 7816);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    memcpy(t7, t3, 9U);
    xsi_driver_first_trans_delta(t1, 0U, 9U, 0LL);
    xsi_set_current_line(109, ng0);
    t8 = (4 - 1);
    t1 = (t0 + 21796);
    *((int *)t1) = 0;
    t3 = (t0 + 21800);
    *((int *)t3) = t8;
    t9 = 0;
    t10 = t8;

LAB5:    if (t9 <= t10)
        goto LAB6;

LAB8:    xsi_set_current_line(112, ng0);
    t1 = (t0 + 5900U);
    t3 = *((char **)t1);
    t8 = *((int *)t3);
    t9 = (t8 - 1);
    t1 = (t0 + 21804);
    *((int *)t1) = 1;
    t4 = (t0 + 21808);
    *((int *)t4) = t9;
    t10 = 1;
    t11 = t9;

LAB10:    if (t10 <= t11)
        goto LAB11;

LAB13:    xsi_set_current_line(117, ng0);
    t1 = (t0 + 3780U);
    t3 = *((char **)t1);
    t1 = (t0 + 5900U);
    t4 = *((char **)t1);
    t8 = *((int *)t4);
    t9 = (t8 - 1);
    t10 = (t9 - 0);
    t13 = (t10 * 1);
    t14 = (9U * t13);
    t15 = (0 + t14);
    t1 = (t3 + t15);
    t5 = (t0 + 7924);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t16 = (t7 + 40U);
    t24 = *((char **)t16);
    memcpy(t24, t1, 9U);
    xsi_driver_first_trans_fast(t5);
    xsi_set_current_line(119, ng0);
    t1 = (t0 + 3596U);
    t3 = *((char **)t1);
    t1 = (t0 + 5900U);
    t4 = *((char **)t1);
    t8 = *((int *)t4);
    t9 = (t8 - 1);
    t10 = (t9 - 0);
    t13 = (t10 * 1);
    t14 = (4U * t13);
    t15 = (0 + t14);
    t1 = (t3 + t15);
    t5 = (t0 + 7960);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t16 = (t7 + 40U);
    t24 = *((char **)t16);
    memcpy(t24, t1, 4U);
    xsi_driver_first_trans_fast(t5);
    xsi_set_current_line(121, ng0);
    t1 = (t0 + 4332U);
    t3 = *((char **)t1);
    t1 = (t0 + 7996);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    memcpy(t7, t3, 3U);
    xsi_driver_first_trans_delta(t1, 0U, 3U, 0LL);
    xsi_set_current_line(124, ng0);
    t1 = (t0 + 5832U);
    t3 = *((char **)t1);
    t8 = *((int *)t3);
    t9 = (t8 - 1);
    t1 = (t0 + 21812);
    *((int *)t1) = 1;
    t4 = (t0 + 21816);
    *((int *)t4) = t9;
    t10 = 1;
    t11 = t9;

LAB15:    if (t10 <= t11)
        goto LAB16;

LAB18:    xsi_set_current_line(127, ng0);
    t1 = (t0 + 3412U);
    t3 = *((char **)t1);
    t1 = (t0 + 5832U);
    t4 = *((char **)t1);
    t8 = *((int *)t4);
    t9 = (t8 - 1);
    t10 = (t9 - 0);
    t13 = (t10 * 1);
    t14 = (3U * t13);
    t15 = (0 + t14);
    t1 = (t3 + t15);
    t5 = (t0 + 8032);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t16 = (t7 + 40U);
    t24 = *((char **)t16);
    memcpy(t24, t1, 3U);
    xsi_driver_first_trans_fast(t5);
    goto LAB3;

LAB6:    xsi_set_current_line(110, ng0);
    t4 = (t0 + 4056U);
    t5 = *((char **)t4);
    t4 = (t0 + 21796);
    t11 = *((int *)t4);
    t12 = (t11 - 3);
    t13 = (t12 * -1);
    xsi_vhdl_check_range_of_index(3, 0, -1, *((int *)t4));
    t14 = (1U * t13);
    t15 = (0 + t14);
    t6 = (t5 + t15);
    t2 = *((unsigned char *)t6);
    t7 = (t0 + 4424U);
    t16 = *((char **)t7);
    t17 = *((unsigned char *)t16);
    t18 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t2, t17);
    t7 = (t0 + 21796);
    t19 = *((int *)t7);
    t20 = (t19 - 0);
    t21 = (t20 * 1);
    t22 = (1 * t21);
    t23 = (0U + t22);
    t24 = (t0 + 7852);
    t25 = (t24 + 32U);
    t26 = *((char **)t25);
    t27 = (t26 + 40U);
    t28 = *((char **)t27);
    *((unsigned char *)t28) = t18;
    xsi_driver_first_trans_delta(t24, t23, 1, 0LL);

LAB7:    t1 = (t0 + 21796);
    t9 = *((int *)t1);
    t3 = (t0 + 21800);
    t10 = *((int *)t3);
    if (t9 == t10)
        goto LAB8;

LAB9:    t8 = (t9 + 1);
    t9 = t8;
    t4 = (t0 + 21796);
    *((int *)t4) = t9;
    goto LAB5;

LAB11:    xsi_set_current_line(113, ng0);
    t5 = (t0 + 3596U);
    t6 = *((char **)t5);
    t5 = (t0 + 21804);
    t12 = *((int *)t5);
    t19 = (t12 - 1);
    t20 = (t19 - 0);
    t13 = (t20 * 1);
    xsi_vhdl_check_range_of_index(0, 7, 1, t19);
    t14 = (4U * t13);
    t15 = (0 + t14);
    t7 = (t6 + t15);
    t16 = (t0 + 21804);
    t29 = *((int *)t16);
    t30 = (t29 - 0);
    t21 = (t30 * 1);
    t22 = (4U * t21);
    t23 = (0U + t22);
    t24 = (t0 + 7852);
    t25 = (t24 + 32U);
    t26 = *((char **)t25);
    t27 = (t26 + 40U);
    t28 = *((char **)t27);
    memcpy(t28, t7, 4U);
    xsi_driver_first_trans_delta(t24, t23, 4U, 0LL);
    xsi_set_current_line(114, ng0);
    t1 = (t0 + 3780U);
    t3 = *((char **)t1);
    t1 = (t0 + 21804);
    t8 = *((int *)t1);
    t9 = (t8 - 1);
    t12 = (t9 - 0);
    t13 = (t12 * 1);
    xsi_vhdl_check_range_of_index(0, 7, 1, t9);
    t14 = (9U * t13);
    t15 = (0 + t14);
    t4 = (t3 + t15);
    t5 = (t0 + 21804);
    t19 = *((int *)t5);
    t20 = (t19 - 0);
    t21 = (t20 * 1);
    t22 = (9U * t21);
    t23 = (0U + t22);
    t6 = (t0 + 7816);
    t7 = (t6 + 32U);
    t16 = *((char **)t7);
    t24 = (t16 + 40U);
    t25 = *((char **)t24);
    memcpy(t25, t4, 9U);
    xsi_driver_first_trans_delta(t6, t23, 9U, 0LL);
    xsi_set_current_line(115, ng0);
    t1 = (t0 + 3872U);
    t3 = *((char **)t1);
    t1 = (t0 + 21804);
    t8 = *((int *)t1);
    t9 = (t8 - 1);
    t12 = (t9 - 0);
    t13 = (t12 * 1);
    xsi_vhdl_check_range_of_index(0, 7, 1, t9);
    t14 = (9U * t13);
    t15 = (0 + t14);
    t4 = (t3 + t15);
    t5 = (t0 + 21804);
    t19 = *((int *)t5);
    t20 = (t19 - 0);
    t21 = (t20 * 1);
    t22 = (9U * t21);
    t23 = (0U + t22);
    t6 = (t0 + 7888);
    t7 = (t6 + 32U);
    t16 = *((char **)t7);
    t24 = (t16 + 40U);
    t25 = *((char **)t24);
    memcpy(t25, t4, 9U);
    xsi_driver_first_trans_delta(t6, t23, 9U, 0LL);

LAB12:    t1 = (t0 + 21804);
    t10 = *((int *)t1);
    t3 = (t0 + 21808);
    t11 = *((int *)t3);
    if (t10 == t11)
        goto LAB13;

LAB14:    t8 = (t10 + 1);
    t10 = t8;
    t4 = (t0 + 21804);
    *((int *)t4) = t10;
    goto LAB10;

LAB16:    xsi_set_current_line(125, ng0);
    t5 = (t0 + 3412U);
    t6 = *((char **)t5);
    t5 = (t0 + 21812);
    t12 = *((int *)t5);
    t19 = (t12 - 1);
    t20 = (t19 - 0);
    t13 = (t20 * 1);
    xsi_vhdl_check_range_of_index(0, 1, 1, t19);
    t14 = (3U * t13);
    t15 = (0 + t14);
    t7 = (t6 + t15);
    t16 = (t0 + 21812);
    t29 = *((int *)t16);
    t30 = (t29 - 0);
    t21 = (t30 * 1);
    t22 = (3U * t21);
    t23 = (0U + t22);
    t24 = (t0 + 7996);
    t25 = (t24 + 32U);
    t26 = *((char **)t25);
    t27 = (t26 + 40U);
    t28 = *((char **)t27);
    memcpy(t28, t7, 3U);
    xsi_driver_first_trans_delta(t24, t23, 3U, 0LL);

LAB17:    t1 = (t0 + 21812);
    t10 = *((int *)t1);
    t3 = (t0 + 21816);
    t11 = *((int *)t3);
    if (t10 == t11)
        goto LAB18;

LAB19:    t8 = (t10 + 1);
    t10 = t8;
    t4 = (t0 + 21812);
    *((int *)t4) = t10;
    goto LAB15;

}

static void work_a_1804274199_3212880686_p_1(char *t0)
{
    char t5[16];
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;

LAB0:    xsi_set_current_line(175, ng0);

LAB3:    t1 = (t0 + 2216U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 3964U);
    t4 = *((char **)t1);
    t6 = ((IEEE_P_2592010699) + 2332);
    t7 = (t0 + 21044U);
    t1 = xsi_base_array_concat(t1, t5, t6, (char)99, t3, (char)97, t4, t7, (char)101);
    t8 = (1U + 9U);
    t9 = (10U != t8);
    if (t9 == 1)
        goto LAB5;

LAB6:    t10 = (t0 + 8068);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    memcpy(t14, t1, 10U);
    xsi_driver_first_trans_fast(t10);

LAB2:    t15 = (t0 + 7712);
    *((int *)t15) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(10U, t8, 0);
    goto LAB6;

}

static void work_a_1804274199_3212880686_p_2(char *t0)
{
    char t6[16];
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(180, ng0);

LAB3:    t1 = (t0 + 2216U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t3);
    t1 = (t0 + 4148U);
    t5 = *((char **)t1);
    t7 = ((IEEE_P_2592010699) + 2332);
    t8 = (t0 + 21076U);
    t1 = xsi_base_array_concat(t1, t6, t7, (char)99, t4, (char)97, t5, t8, (char)101);
    t9 = (1U + 9U);
    t10 = (10U != t9);
    if (t10 == 1)
        goto LAB5;

LAB6:    t11 = (t0 + 8104);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    memcpy(t15, t1, 10U);
    xsi_driver_first_trans_fast(t11);

LAB2:    t16 = (t0 + 7720);
    *((int *)t16) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(10U, t9, 0);
    goto LAB6;

}

static void work_a_1804274199_3212880686_p_3(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    int t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;

LAB0:    xsi_set_current_line(182, ng0);
    t1 = (t0 + 4976U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)2);
    if (t4 != 0)
        goto LAB3;

LAB4:
LAB5:    t15 = xsi_get_transient_memory(18U);
    memset(t15, 0, 18U);
    t16 = t15;
    memset(t16, (unsigned char)2, 18U);
    t17 = (0 - 17);
    t18 = (t17 * -1);
    t19 = (1U * t18);
    t20 = (t16 + t19);
    *((unsigned char *)t20) = (unsigned char)3;
    t21 = (t0 + 8140);
    t22 = (t21 + 32U);
    t23 = *((char **)t22);
    t24 = (t23 + 40U);
    t25 = *((char **)t24);
    memcpy(t25, t15, 18U);
    xsi_driver_first_trans_fast(t21);

LAB2:    t26 = (t0 + 7728);
    *((int *)t26) = 1;

LAB1:    return;
LAB3:    t1 = (t0 + 2308U);
    t5 = *((char **)t1);
    t6 = (18 - 1);
    t7 = (17 - t6);
    t8 = (t7 * 1U);
    t9 = (0 + t8);
    t1 = (t5 + t9);
    t10 = (t0 + 8140);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    memcpy(t14, t1, 18U);
    xsi_driver_first_trans_fast(t10);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_1804274199_3212880686_p_4(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    int t4;
    unsigned int t5;
    unsigned int t6;
    int t7;
    int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(229, ng0);

LAB3:    t1 = (t0 + 3320U);
    t2 = *((char **)t1);
    t3 = (48 - 1);
    t4 = (18 - 1);
    t5 = (t3 - t4);
    t6 = (t5 * 1U);
    t7 = (4 - 1);
    t8 = (t7 - 0);
    t9 = (t8 * 1);
    t10 = (48U * t9);
    t11 = (0 + t10);
    t12 = (t11 + t6);
    t1 = (t2 + t12);
    t13 = (t0 + 8176);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    memcpy(t17, t1, 18U);
    xsi_driver_first_trans_fast_port(t13);

LAB2:    t18 = (t0 + 7736);
    *((int *)t18) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_1804274199_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1804274199_3212880686_p_0,(void *)work_a_1804274199_3212880686_p_1,(void *)work_a_1804274199_3212880686_p_2,(void *)work_a_1804274199_3212880686_p_3,(void *)work_a_1804274199_3212880686_p_4};
	xsi_register_didat("work_a_1804274199_3212880686", "isim/TB_MATRIX_MUL_IP_CORE_S_INT_isim_beh.exe.sim/work/a_1804274199_3212880686.didat");
	xsi_register_executes(pe);
}
