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
static const char *ng0 = "E:/valencia/ETSE_GDSP-modified3/SharedLibraries/STANDARD_RAM.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_1242562249;

int ieee_p_1242562249_sub_1657552908_1035706684(char *, char *, char *);
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_0202134078_3212880686_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    int t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    char *t15;
    int t16;
    int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;

LAB0:    xsi_set_current_line(34, ng0);
    t1 = (t0 + 568U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 2480);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(35, ng0);
    t3 = (t0 + 1052U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:
LAB6:    xsi_set_current_line(38, ng0);
    t1 = (t0 + 1144U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(42, ng0);
    t1 = xsi_get_transient_memory(18U);
    memset(t1, 0, 18U);
    t3 = t1;
    memset(t3, (unsigned char)2, 18U);
    t4 = (t0 + 2560);
    t7 = (t4 + 32U);
    t8 = *((char **)t7);
    t14 = (t8 + 40U);
    t15 = *((char **)t14);
    memcpy(t15, t1, 18U);
    xsi_driver_first_trans_fast(t4);

LAB9:    xsi_set_current_line(44, ng0);
    t1 = (t0 + 1328U);
    t3 = *((char **)t1);
    t1 = (t0 + 2596);
    t4 = (t1 + 32U);
    t7 = *((char **)t4);
    t8 = (t7 + 40U);
    t14 = *((char **)t8);
    memcpy(t14, t3, 18U);
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(45, ng0);
    t1 = (t0 + 1328U);
    t3 = *((char **)t1);
    t1 = (t0 + 2632);
    t4 = (t1 + 32U);
    t7 = *((char **)t4);
    t8 = (t7 + 40U);
    t14 = *((char **)t8);
    memcpy(t14, t3, 18U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(46, ng0);
    t1 = (t0 + 1420U);
    t3 = *((char **)t1);
    t1 = (t0 + 2596);
    t4 = (t1 + 32U);
    t7 = *((char **)t4);
    t8 = (t7 + 40U);
    t14 = *((char **)t8);
    memcpy(t14, t3, 18U);
    xsi_driver_first_trans_fast_port(t1);
    goto LAB3;

LAB5:    xsi_set_current_line(36, ng0);
    t3 = (t0 + 868U);
    t7 = *((char **)t3);
    t3 = (t0 + 776U);
    t8 = *((char **)t3);
    t3 = (t0 + 4964U);
    t9 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t8, t3);
    t10 = (t9 - 0);
    t11 = (t10 * 1);
    t12 = (72U * t11);
    t13 = (0U + t12);
    t14 = (t0 + 684U);
    t15 = *((char **)t14);
    t14 = (t0 + 4948U);
    t16 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t15, t14);
    t17 = (t16 - 0);
    t18 = (t17 * 1);
    t19 = (18U * t18);
    t20 = (t13 + t19);
    t21 = (t0 + 2524);
    t22 = (t21 + 32U);
    t23 = *((char **)t22);
    t24 = (t23 + 40U);
    t25 = *((char **)t24);
    memcpy(t25, t7, 18U);
    xsi_driver_first_trans_delta(t21, t20, 18U, 0LL);
    goto LAB6;

LAB8:    xsi_set_current_line(40, ng0);
    t1 = (t0 + 1236U);
    t4 = *((char **)t1);
    t1 = (t0 + 776U);
    t7 = *((char **)t1);
    t1 = (t0 + 4964U);
    t9 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t7, t1);
    t10 = (t9 - 0);
    t11 = (t10 * 1);
    xsi_vhdl_check_range_of_index(0, 3, 1, t9);
    t12 = (18U * t11);
    t8 = (t0 + 684U);
    t14 = *((char **)t8);
    t8 = (t0 + 4948U);
    t16 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t14, t8);
    t17 = (t16 - 0);
    t13 = (t17 * 1);
    xsi_vhdl_check_range_of_index(0, 3, 1, t16);
    t18 = (72U * t13);
    t19 = (0 + t18);
    t20 = (t19 + t12);
    t15 = (t4 + t20);
    t21 = (t0 + 2560);
    t22 = (t21 + 32U);
    t23 = *((char **)t22);
    t24 = (t23 + 40U);
    t25 = *((char **)t24);
    memcpy(t25, t15, 18U);
    xsi_driver_first_trans_fast(t21);
    goto LAB9;

}


extern void work_a_0202134078_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0202134078_3212880686_p_0};
	xsi_register_didat("work_a_0202134078_3212880686", "isim/TB_MATRIX_MUL_IP_CORE_S_INT_isim_beh.exe.sim/work/a_0202134078_3212880686.didat");
	xsi_register_executes(pe);
}
