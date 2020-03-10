#!/vendor/bin/sh

#Copyright (c) 2018, The Linux Foundation. All rights reserved.
#
#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#    * Neither the name of The Linux Foundation nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
#THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
#WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
#ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
#BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
#BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
#IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

enable_talos_tracing_events()
{
    # timer
    echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_entry/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_exit/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_cancel/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_expire_entry/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_expire_exit/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_init/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_start/enable
    #enble FTRACE for softirq events
    echo 1 > /sys/kernel/debug/tracing/events/irq/enable
    #enble FTRACE for Workqueue events
    echo 1 > /sys/kernel/debug/tracing/events/workqueue/enable
    # schedular
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_cpu_hotplug/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_migrate_task/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_pi_setprio/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup_new/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_isolate/enable
    # sound
    echo 1 > /sys/kernel/debug/tracing/events/asoc/snd_soc_reg_read/enable
    echo 1 > /sys/kernel/debug/tracing/events/asoc/snd_soc_reg_write/enable
    # mdp
    echo 1 > /sys/kernel/debug/tracing/events/mdss/mdp_video_underrun_done/enable
    # video
    echo 1 > /sys/kernel/debug/tracing/events/msm_vidc/enable
    # clock
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_set_rate/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_enable/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_disable/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/cpu_frequency/enable
    # regulator
    echo 1 > /sys/kernel/debug/tracing/events/regulator/enable
    # power
    echo 1 > /sys/kernel/debug/tracing/events/msm_low_power/enable
    #thermal
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_core_offline/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_core_offline/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_core_online/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_core_online/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_frequency_mit/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_frequency_mit/enable

    #rmph_send_msg
    echo 1 > /sys/kernel/debug/tracing/events/rpmh/rpmh_send_msg/enable
    #SCM Tracing enabling
    echo 1 > /sys/kernel/debug/tracing/events/scm/enable

    echo 1 > /sys/kernel/debug/tracing/tracing_on
}

# function to enable ftrace events
enable_talos_ftrace_event_tracing()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi

    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/debug/tracing/events ]
    then
        return
    fi

    enable_talos_tracing_events
}

# function to enable ftrace event transfer to CoreSight STM
enable_talos_stm_events()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi
    # bail out if coresight isn't present
    if [ ! -d /sys/bus/coresight ]
    then
        return
    fi
    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/debug/tracing/events ]
    then
        return
    fi

    echo $etr_size > /sys/bus/coresight/devices/coresight-tmc-etr/mem_size
    echo sg > /sys/bus/coresight/devices/coresight-tmc-etr/mem_type
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/$sinkenable
    echo 1 > /sys/bus/coresight/devices/coresight-stm/$srcenable
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
    enable_talos_tracing_events
}

# function to enable ftrace event transfer to Coresight STM specific to Moorea
enable_moorea_stm_events()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi
    # bail out if coresight isn't present
    if [ ! -d /sys/bus/coresight ]
    then
        return
    fi
    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/debug/tracing/events ]
    then
        return
    fi

    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
    echo 0xff > /sys/bus/coresight/devices/coresight-stm/hwevent_enable

    echo 0x06001020 0xd > /sys/bus/coresight/devices/coresight-hwevent/setreg
    echo 48 0x7 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_msr
    echo 33 0x1b01 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_msr
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/mcmb_lanes_select
    echo 1 0 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_mode
    echo 1 > /sys/bus/coresight/devices/coresight-tgu-ipcb/reset_tgu
    echo 0 0 0 0x11111111 > /sys/bus/coresight/devices/coresight-tgu-ipcb/set_group
    echo 0 1 0 0x11111111 > /sys/bus/coresight/devices/coresight-tgu-ipcb/set_group
    echo 0 2 0 0x11111111 > /sys/bus/coresight/devices/coresight-tgu-ipcb/set_group
    echo 0 3 0 0x11113111 > /sys/bus/coresight/devices/coresight-tgu-ipcb/set_group
    echo 0 4 0 0x11111111 > /sys/bus/coresight/devices/coresight-tgu-ipcb/set_group
    echo 0 0 0x3 > /sys/bus/coresight/devices/coresight-tgu-ipcb/set_condition
    echo 0 1 0x40000 > /sys/bus/coresight/devices/coresight-tgu-ipcb/set_condition
    echo 0 2 0x20000 > /sys/bus/coresight/devices/coresight-tgu-ipcb/set_condition
    echo 0 0 0x2000 > /sys/bus/coresight/devices/coresight-tgu-ipcb/set_select
    echo 1 > /sys/bus/coresight/devices/coresight-tgu-ipcb/enable_tgu


    echo $etr_size > /sys/bus/coresight/devices/coresight-tmc-etr/mem_size
    echo contig > /sys/bus/coresight/devices/coresight-tmc-etr/mem_type
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/$sinkenable
    echo 1 > /sys/bus/coresight/devices/coresight-stm/$srcenable

    echo 1 > /sys/kernel/debug/tracing/events/rpmh/rpmh_send_msg/enable

    echo 1 > /sys/kernel/debug/tracing/tracing_on

    echo 64 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/enable_datasets
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/enable_source

    echo {class: aopetb, sink: CIRC} > /sys/kernel/debug/aop_send_message
    enable_talos_tracing_events
}

config_talos_dcc_gladiator()
{
    #Gladiator
    echo 0x9680000 > $DCC_PATH/config
    echo 0x9680004 > $DCC_PATH/config
    echo 8 > $DCC_PATH/loop
    echo 0x9681000 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    echo 0x9681004 > $DCC_PATH/config
    echo 0x9681008 > $DCC_PATH/config
    echo 0x968100c > $DCC_PATH/config
    echo 0x9681010 > $DCC_PATH/config
    echo 0x9681014 > $DCC_PATH/config
    echo 0x968101c > $DCC_PATH/config
    echo 0x9681020 > $DCC_PATH/config
    echo 0x9681024 > $DCC_PATH/config
    echo 0x9681028 > $DCC_PATH/config
    echo 0x968102c > $DCC_PATH/config
    echo 0x9681030 > $DCC_PATH/config
    echo 0x9681034 > $DCC_PATH/config
    echo 0x968103c > $DCC_PATH/config

    echo 0x9698100 > $DCC_PATH/config
    echo 0x9698104 > $DCC_PATH/config
    echo 0x9698108 > $DCC_PATH/config
    echo 0x9698110 > $DCC_PATH/config
    echo 0x9698120 > $DCC_PATH/config
    echo 0x9698124 > $DCC_PATH/config
    echo 0x9698128 > $DCC_PATH/config
    echo 0x969812c > $DCC_PATH/config
    echo 0x9698130 > $DCC_PATH/config
    echo 0x9698134 > $DCC_PATH/config
    echo 0x9698138 > $DCC_PATH/config
    echo 0x969813c > $DCC_PATH/config

    echo 0x9698500 > $DCC_PATH/config
    echo 0x9698504 > $DCC_PATH/config
    echo 0x9698508 > $DCC_PATH/config
    echo 0x969850c > $DCC_PATH/config
    echo 0x9698510 > $DCC_PATH/config
    echo 0x9698514 > $DCC_PATH/config
    echo 0x9698518 > $DCC_PATH/config
    echo 0x969851c > $DCC_PATH/config

    echo 0x9698700 > $DCC_PATH/config
    echo 0x9698704 > $DCC_PATH/config
    echo 0x9698708 > $DCC_PATH/config
    echo 0x969870c > $DCC_PATH/config
    echo 0x9698714 > $DCC_PATH/config
    echo 0x9698718 > $DCC_PATH/config
    echo 0x969871c > $DCC_PATH/config
}

config_talos_dcc_noc_err_regs()
{
    #CNOC
    # echo 0x1500204 > $DCC_PATH/config
    # echo 0x1500240 > $DCC_PATH/config
    # echo 0x1500244 > $DCC_PATH/config
    # echo 0x1500248 > $DCC_PATH/config
    # echo 0x150024C > $DCC_PATH/config
    # echo 0x1500250 > $DCC_PATH/config
    # echo 0x1500258 > $DCC_PATH/config
    # echo 0x1500288 > $DCC_PATH/config
    # echo 0x150028C > $DCC_PATH/config
    # echo 0x1500290 > $DCC_PATH/config
    # echo 0x1500294 > $DCC_PATH/config
    # echo 0x15002A8 > $DCC_PATH/config
    # echo 0x15002AC > $DCC_PATH/config
    # echo 0x15002B0 > $DCC_PATH/config
    # echo 0x15002B4 > $DCC_PATH/config
    # echo 0x1500300 > $DCC_PATH/config
    # echo 0x1500304 > $DCC_PATH/config
    # echo 0x1500010 > $DCC_PATH/config
    # echo 0x1500020 > $DCC_PATH/config
    # echo 0x1500024 > $DCC_PATH/config
    # echo 0x1500028 > $DCC_PATH/config
    # echo 0x150002C > $DCC_PATH/config
    # echo 0x1500030 > $DCC_PATH/config
    # echo 0x1500034 > $DCC_PATH/config
    # echo 0x1500038 > $DCC_PATH/config
    # echo 0x150003C > $DCC_PATH/config
    #SNOC
    echo 0x1620204 > $DCC_PATH/config
    echo 0x1620240 > $DCC_PATH/config
    echo 0x1620248 > $DCC_PATH/config
    echo 0x1620288 > $DCC_PATH/config
    echo 0x162028C > $DCC_PATH/config
    echo 0x1620290 > $DCC_PATH/config
    echo 0x1620294 > $DCC_PATH/config
    echo 0x16202A8 > $DCC_PATH/config
    echo 0x16202AC > $DCC_PATH/config
    echo 0x16202B0 > $DCC_PATH/config
    echo 0x16202B4 > $DCC_PATH/config
    echo 0x1620300 > $DCC_PATH/config
    #AGGNOC
    echo 0x1700204 > $DCC_PATH/config
    echo 0x1700240 > $DCC_PATH/config
    echo 0x1700248 > $DCC_PATH/config
    echo 0x1700288 > $DCC_PATH/config
    echo 0x1700290 > $DCC_PATH/config
    echo 0x1700300 > $DCC_PATH/config
    echo 0x1700304 > $DCC_PATH/config
    echo 0x1700308 > $DCC_PATH/config
    echo 0x170030C > $DCC_PATH/config
    echo 0x1700310 > $DCC_PATH/config
    echo 0x1700314 > $DCC_PATH/config
    echo 0x1700C08 > $DCC_PATH/config
    echo 0x1700C10 > $DCC_PATH/config
    echo 0x1700C20 > $DCC_PATH/config
    echo 0x1700C24 > $DCC_PATH/config
    echo 0x1700C28 > $DCC_PATH/config
    echo 0x1700C2C > $DCC_PATH/config
    echo 0x1700C30 > $DCC_PATH/config
    echo 0x1700C34 > $DCC_PATH/config
    echo 0x1700C38 > $DCC_PATH/config
    echo 0x1700C3C > $DCC_PATH/config
    #MNOC
    echo 0x1740240 > $DCC_PATH/config
    echo 0x1740248 > $DCC_PATH/config
    echo 0x1740288 > $DCC_PATH/config
    echo 0x1740290 > $DCC_PATH/config
    echo 0x1740300 > $DCC_PATH/config
    echo 0x1740304 > $DCC_PATH/config
    echo 0x1740308 > $DCC_PATH/config
    echo 0x174030C > $DCC_PATH/config
    echo 0x1740310 > $DCC_PATH/config
    echo 0x1740314 > $DCC_PATH/config
    echo 0x1740004 > $DCC_PATH/config
    echo 0x1740008 > $DCC_PATH/config
    echo 0x1740010 > $DCC_PATH/config
    echo 0x1740020 > $DCC_PATH/config
    echo 0x1740024 > $DCC_PATH/config
    echo 0x1740028 > $DCC_PATH/config
    echo 0x174002C > $DCC_PATH/config
    echo 0x1740030 > $DCC_PATH/config
    echo 0x1740034 > $DCC_PATH/config
    echo 0x1740038 > $DCC_PATH/config
    echo 0x174003C > $DCC_PATH/config
    #GEM_NOC
    echo 0x9698204 > $DCC_PATH/config
    echo 0x9698240 > $DCC_PATH/config
    echo 0x9698244 > $DCC_PATH/config
    echo 0x9698248 > $DCC_PATH/config
    echo 0x969824C > $DCC_PATH/config
    echo 0x9681010 > $DCC_PATH/config
    echo 0x9681014 > $DCC_PATH/config
    echo 0x9681018 > $DCC_PATH/config
    echo 0x968101C > $DCC_PATH/config
    echo 0x9681020 > $DCC_PATH/config
    echo 0x9681024 > $DCC_PATH/config
    echo 0x9681028 > $DCC_PATH/config
    echo 0x968102C > $DCC_PATH/config
    echo 0x9681030 > $DCC_PATH/config
    echo 0x9681034 > $DCC_PATH/config
    echo 0x968103C > $DCC_PATH/config
    echo 0x9698100 > $DCC_PATH/config
    echo 0x9698104 > $DCC_PATH/config
    echo 0x9698108 > $DCC_PATH/config
    echo 0x9698110 > $DCC_PATH/config
    echo 0x9698120 > $DCC_PATH/config
    echo 0x9698124 > $DCC_PATH/config
    echo 0x9698128 > $DCC_PATH/config
    echo 0x969812C > $DCC_PATH/config
    echo 0x9698130 > $DCC_PATH/config
    echo 0x9698134 > $DCC_PATH/config
    echo 0x9698138 > $DCC_PATH/config
    echo 0x969813C > $DCC_PATH/config
    #SSC_NOC
    echo 0x62BE2004 > $DCC_PATH/config
    echo 0x62BE2040 > $DCC_PATH/config
    echo 0x62BE2048 > $DCC_PATH/config
    echo 0x62BE2088 > $DCC_PATH/config
    echo 0x62BE2090 > $DCC_PATH/config
    echo 0x62BE2100 > $DCC_PATH/config
    echo 0x62BE2104 > $DCC_PATH/config
    echo 0x62BE2108 > $DCC_PATH/config
    echo 0x62BE210C > $DCC_PATH/config
    echo 0x62BE2110 > $DCC_PATH/config
    echo 0x62BE2114 > $DCC_PATH/config
    echo 0x62BE2118 > $DCC_PATH/config
    echo 0x62BE0010 > $DCC_PATH/config
    echo 0x62BE0020 > $DCC_PATH/config
    echo 0x62BE0024 > $DCC_PATH/config
    echo 0x62BE0028 > $DCC_PATH/config
    echo 0x62BE002C > $DCC_PATH/config
    echo 0x62BE0030 > $DCC_PATH/config
    echo 0x62BE0034 > $DCC_PATH/config
    echo 0x62BE0038 > $DCC_PATH/config
    echo 0x62BE003C > $DCC_PATH/config
    #DC_NOC
    echo 0x9160204 > $DCC_PATH/config
    echo 0x9160240 > $DCC_PATH/config
    echo 0x9160248 > $DCC_PATH/config
    echo 0x9160288 > $DCC_PATH/config
    echo 0x9160290 > $DCC_PATH/config
    echo 0x9160300 > $DCC_PATH/config
    echo 0x9160304 > $DCC_PATH/config
    echo 0x9160308 > $DCC_PATH/config
    echo 0x916030C > $DCC_PATH/config
    echo 0x9160310 > $DCC_PATH/config
    echo 0x9160314 > $DCC_PATH/config
    echo 0x9160318 > $DCC_PATH/config
    echo 0x9160008 > $DCC_PATH/config
    echo 0x9160010 > $DCC_PATH/config
    echo 0x9160020 > $DCC_PATH/config
    echo 0x9160024 > $DCC_PATH/config
    echo 0x9160028 > $DCC_PATH/config
    echo 0x916002C > $DCC_PATH/config
    echo 0x9160030 > $DCC_PATH/config
    echo 0x9160034 > $DCC_PATH/config
    echo 0x9160038 > $DCC_PATH/config
    echo 0x916003C > $DCC_PATH/config

    #NOC sensin Registers
    #SNOC_CENTER_NIU_STATUS_SBM0_SENSEIN
    echo 0x1620500 4 > $DCC_PATH/config
    #SNOC_CENTER_NIU_STATUS_SBM1_SENSEIN
    echo 0x1620700 4 > $DCC_PATH/config
    #SNOC_CENTER_SBM_SENSEIN
    echo 0x1620300 > $DCC_PATH/config
    #SNOC_MONAQ_NIU_STATUS_SBM_SENSEIN
    echo 0x1620F00 2 > $DCC_PATH/config
    #SNOC_WEST_NIU_STATUS_SBM_SENSEIN
    echo 0x1620B00 2 > $DCC_PATH/config
    #A1NOC_MONAQ_SBM_SENSEIN
    echo 0x1700B00 2 > $DCC_PATH/config
    #A1NOC_WEST_SBM_SENSEIN
    echo 0x1700700 3 > $DCC_PATH/config
    #CNOC_CENTER_STATUS_SBM_SENSEIN
    # echo 0x1500500 7 > $DCC_PATH/config
    #CNOC_MMNOC_STATUS_SBM_SENSEIN
    # echo 0x1500D00 4 > $DCC_PATH/config
    #CNOC_WEST_STATUS_SBM_SENSEIN
    # echo 0x1501100 4 > $DCC_PATH/config
    #DC_NOC_DISABLE_SBM_SENSEIN
    echo 0x9163100 > $DCC_PATH/config
    #GEM_NOC_SBM_MDSP_SAFE_SHAPING_SENSEIN
    echo 0x96AA100 > $DCC_PATH/config

}

config_talos_dcc_shrm()
{
    #SHRM

    #SHRM CSR
    echo 0x9050008 > $DCC_PATH/config
    echo 0x9050068 > $DCC_PATH/config
    echo 0x9050078 > $DCC_PATH/config


}

config_talos_dcc_cprh()
{
    #CPRh
}

config_talos_dcc_rscc_apps()
{
    #RSC
    echo 0x18200400 > $DCC_PATH/config
    echo 0x18200404 > $DCC_PATH/config
    echo 0x18200408 > $DCC_PATH/config
    echo 0x18200038 > $DCC_PATH/config
    echo 0x18200040 > $DCC_PATH/config
    echo 0x18200048 > $DCC_PATH/config
    echo 0x18220038 > $DCC_PATH/config
    echo 0x18220040 > $DCC_PATH/config
    echo 0x182200D0 > $DCC_PATH/config
    echo 0x18200030 > $DCC_PATH/config
    echo 0x18200010 > $DCC_PATH/config

    #RSC-TCS
    echo 0x1822000c > $DCC_PATH/config
    echo 0x18220d14 > $DCC_PATH/config
    echo 0x18220fb4 > $DCC_PATH/config
    echo 0x18221254 > $DCC_PATH/config
    echo 0x182214f4 > $DCC_PATH/config
    echo 0x18221794 > $DCC_PATH/config
    echo 0x18221a34 > $DCC_PATH/config
    echo 0x18221cd4 > $DCC_PATH/config
    echo 0x18221f74 > $DCC_PATH/config
    echo 0x18220d18 > $DCC_PATH/config
    echo 0x18220fb8 > $DCC_PATH/config
    echo 0x18221258 > $DCC_PATH/config
    echo 0x182214f8 > $DCC_PATH/config
    echo 0x18221798 > $DCC_PATH/config
    echo 0x18221a38 > $DCC_PATH/config
    echo 0x18221cd8 > $DCC_PATH/config
    echo 0x18221f78 > $DCC_PATH/config
    echo 0x18220d00 > $DCC_PATH/config
    echo 0x18220d04 > $DCC_PATH/config
    echo 0x18220d1c > $DCC_PATH/config
    echo 0x18220fbc > $DCC_PATH/config
    echo 0x1822125c > $DCC_PATH/config
    echo 0x182214fc > $DCC_PATH/config
    echo 0x1822179c > $DCC_PATH/config
    echo 0x18221a3c > $DCC_PATH/config
    echo 0x18221cdc > $DCC_PATH/config
    echo 0x18221f7c > $DCC_PATH/config
    echo 0x18221274 > $DCC_PATH/config
    echo 0x18221288 > $DCC_PATH/config
    echo 0x1822129c > $DCC_PATH/config
    echo 0x182212b0 > $DCC_PATH/config
    echo 0x182212c4 > $DCC_PATH/config
    echo 0x182212d8 > $DCC_PATH/config
    echo 0x182212ec > $DCC_PATH/config
    echo 0x18221300 > $DCC_PATH/config
    echo 0x18221314 > $DCC_PATH/config
    echo 0x18221328 > $DCC_PATH/config
    echo 0x1822133c > $DCC_PATH/config
    echo 0x18221350 > $DCC_PATH/config
    echo 0x18221364 > $DCC_PATH/config
    echo 0x18221378 > $DCC_PATH/config
    echo 0x1822138c > $DCC_PATH/config
    echo 0x182213a0 > $DCC_PATH/config
    echo 0x18221514 > $DCC_PATH/config
    echo 0x18221528 > $DCC_PATH/config
    echo 0x1822153c > $DCC_PATH/config
    echo 0x18221550 > $DCC_PATH/config
    echo 0x18221564 > $DCC_PATH/config
    echo 0x18221578 > $DCC_PATH/config
    echo 0x1822158c > $DCC_PATH/config
    echo 0x182215a0 > $DCC_PATH/config
    echo 0x182215b4 > $DCC_PATH/config
    echo 0x182215c8 > $DCC_PATH/config
    echo 0x182215dc > $DCC_PATH/config
    echo 0x182215f0 > $DCC_PATH/config
    echo 0x18221604 > $DCC_PATH/config
    echo 0x18221618 > $DCC_PATH/config
    echo 0x1822162c > $DCC_PATH/config
    echo 0x18221640 > $DCC_PATH/config
    echo 0x182217b4 > $DCC_PATH/config
    echo 0x182217c8 > $DCC_PATH/config
    echo 0x182217dc > $DCC_PATH/config
    echo 0x182217f0 > $DCC_PATH/config
    echo 0x18221804 > $DCC_PATH/config
    echo 0x18221818 > $DCC_PATH/config
    echo 0x1822182c > $DCC_PATH/config
    echo 0x18221840 > $DCC_PATH/config
    echo 0x18221854 > $DCC_PATH/config
    echo 0x18221868 > $DCC_PATH/config
    echo 0x1822187c > $DCC_PATH/config
    echo 0x18221890 > $DCC_PATH/config
    echo 0x182218a4 > $DCC_PATH/config
    echo 0x182218b8 > $DCC_PATH/config
    echo 0x182218cc > $DCC_PATH/config
    echo 0x182218e0 > $DCC_PATH/config
    echo 0x18221a54 > $DCC_PATH/config
    echo 0x18221a68 > $DCC_PATH/config
    echo 0x18221a7c > $DCC_PATH/config
    echo 0x18221a90 > $DCC_PATH/config
    echo 0x18221aa4 > $DCC_PATH/config
    echo 0x18221ab8 > $DCC_PATH/config
    echo 0x18221acc > $DCC_PATH/config
    echo 0x18221ae0 > $DCC_PATH/config
    echo 0x18221af4 > $DCC_PATH/config
    echo 0x18221b08 > $DCC_PATH/config
    echo 0x18221b1c > $DCC_PATH/config
    echo 0x18221b30 > $DCC_PATH/config
    echo 0x18221b44 > $DCC_PATH/config
    echo 0x18221b58 > $DCC_PATH/config
    echo 0x18221b6c > $DCC_PATH/config
    echo 0x18221b80 > $DCC_PATH/config
    echo 0x18221cf4 > $DCC_PATH/config
    echo 0x18221d08 > $DCC_PATH/config
    echo 0x18221d1c > $DCC_PATH/config
    echo 0x18221d30 > $DCC_PATH/config
    echo 0x18221d44 > $DCC_PATH/config
    echo 0x18221d58 > $DCC_PATH/config
    echo 0x18221d6c > $DCC_PATH/config
    echo 0x18221d80 > $DCC_PATH/config
    echo 0x18221d94 > $DCC_PATH/config
    echo 0x18221da8 > $DCC_PATH/config
    echo 0x18221dbc > $DCC_PATH/config
    echo 0x18221dd0 > $DCC_PATH/config
    echo 0x18221de4 > $DCC_PATH/config
    echo 0x18221df8 > $DCC_PATH/config
    echo 0x18221e0c > $DCC_PATH/config
    echo 0x18221e20 > $DCC_PATH/config
    echo 0x18221f94 > $DCC_PATH/config
    echo 0x18221fa8 > $DCC_PATH/config
    echo 0x18221fbc > $DCC_PATH/config
    echo 0x18221fd0 > $DCC_PATH/config
    echo 0x18221fe4 > $DCC_PATH/config
    echo 0x18221ff8 > $DCC_PATH/config
    echo 0x1822200c > $DCC_PATH/config
    echo 0x18222020 > $DCC_PATH/config
    echo 0x18222034 > $DCC_PATH/config
    echo 0x18222048 > $DCC_PATH/config
    echo 0x1822205c > $DCC_PATH/config
    echo 0x18222070 > $DCC_PATH/config
    echo 0x18222084 > $DCC_PATH/config
    echo 0x18222098 > $DCC_PATH/config
    echo 0x182220ac > $DCC_PATH/config
    echo 0x182220c0 > $DCC_PATH/config
    echo 0x18221278 > $DCC_PATH/config
    echo 0x1822128c > $DCC_PATH/config
    echo 0x182212a0 > $DCC_PATH/config
    echo 0x182212b4 > $DCC_PATH/config
    echo 0x182212c8 > $DCC_PATH/config
    echo 0x182212dc > $DCC_PATH/config
    echo 0x182212f0 > $DCC_PATH/config
    echo 0x18221304 > $DCC_PATH/config
    echo 0x18221318 > $DCC_PATH/config
    echo 0x1822132c > $DCC_PATH/config
    echo 0x18221340 > $DCC_PATH/config
    echo 0x18221354 > $DCC_PATH/config
    echo 0x18221368 > $DCC_PATH/config
    echo 0x1822137c > $DCC_PATH/config
    echo 0x18221390 > $DCC_PATH/config
    echo 0x182213a4 > $DCC_PATH/config
    echo 0x18221518 > $DCC_PATH/config
    echo 0x1822152c > $DCC_PATH/config
    echo 0x18221540 > $DCC_PATH/config
    echo 0x18221554 > $DCC_PATH/config
    echo 0x18221568 > $DCC_PATH/config
    echo 0x1822157c > $DCC_PATH/config
    echo 0x18221590 > $DCC_PATH/config
    echo 0x182215a4 > $DCC_PATH/config
    echo 0x182215b8 > $DCC_PATH/config
    echo 0x182215cc > $DCC_PATH/config
    echo 0x182215e0 > $DCC_PATH/config
    echo 0x182215f4 > $DCC_PATH/config
    echo 0x18221608 > $DCC_PATH/config
    echo 0x1822161c > $DCC_PATH/config
    echo 0x18221630 > $DCC_PATH/config
    echo 0x18221644 > $DCC_PATH/config
    echo 0x182217b8 > $DCC_PATH/config
    echo 0x182217cc > $DCC_PATH/config
    echo 0x182217e0 > $DCC_PATH/config
    echo 0x182217f4 > $DCC_PATH/config
    echo 0x18221808 > $DCC_PATH/config
    echo 0x1822181c > $DCC_PATH/config
    echo 0x18221830 > $DCC_PATH/config
    echo 0x18221844 > $DCC_PATH/config
    echo 0x18221858 > $DCC_PATH/config
    echo 0x1822186c > $DCC_PATH/config
    echo 0x18221880 > $DCC_PATH/config
    echo 0x18221894 > $DCC_PATH/config
    echo 0x182218a8 > $DCC_PATH/config
    echo 0x182218bc > $DCC_PATH/config
    echo 0x182218d0 > $DCC_PATH/config
    echo 0x182218e4 > $DCC_PATH/config
    echo 0x18221a58 > $DCC_PATH/config
    echo 0x18221a6c > $DCC_PATH/config
    echo 0x18221a80 > $DCC_PATH/config
    echo 0x18221a94 > $DCC_PATH/config
    echo 0x18221aa8 > $DCC_PATH/config
    echo 0x18221abc > $DCC_PATH/config
    echo 0x18221ad0 > $DCC_PATH/config
    echo 0x18221ae4 > $DCC_PATH/config
    echo 0x18221af8 > $DCC_PATH/config
    echo 0x18221b0c > $DCC_PATH/config
    echo 0x18221b20 > $DCC_PATH/config
    echo 0x18221b34 > $DCC_PATH/config
    echo 0x18221b48 > $DCC_PATH/config
    echo 0x18221b5c > $DCC_PATH/config
    echo 0x18221b70 > $DCC_PATH/config
    echo 0x18221b84 > $DCC_PATH/config
    echo 0x18221cf8 > $DCC_PATH/config
    echo 0x18221d0c > $DCC_PATH/config
    echo 0x18221d20 > $DCC_PATH/config
    echo 0x18221d34 > $DCC_PATH/config
    echo 0x18221d48 > $DCC_PATH/config
    echo 0x18221d5c > $DCC_PATH/config
    echo 0x18221d70 > $DCC_PATH/config
    echo 0x18221d84 > $DCC_PATH/config
    echo 0x18221d98 > $DCC_PATH/config
    echo 0x18221dac > $DCC_PATH/config
    echo 0x18221dc0 > $DCC_PATH/config
    echo 0x18221dd4 > $DCC_PATH/config
    echo 0x18221de8 > $DCC_PATH/config
    echo 0x18221dfc > $DCC_PATH/config
    echo 0x18221e10 > $DCC_PATH/config
    echo 0x18221e24 > $DCC_PATH/config
    echo 0x18221f98 > $DCC_PATH/config
    echo 0x18221fac > $DCC_PATH/config
    echo 0x18221fc0 > $DCC_PATH/config
    echo 0x18221fd4 > $DCC_PATH/config
    echo 0x18221fe8 > $DCC_PATH/config
    echo 0x18221ffc > $DCC_PATH/config
    echo 0x18222010 > $DCC_PATH/config
    echo 0x18222024 > $DCC_PATH/config
    echo 0x18222038 > $DCC_PATH/config
    echo 0x1822204c > $DCC_PATH/config
    echo 0x18222060 > $DCC_PATH/config
    echo 0x18222074 > $DCC_PATH/config
    echo 0x18222088 > $DCC_PATH/config
    echo 0x1822209c > $DCC_PATH/config
    echo 0x182220b0 > $DCC_PATH/config
    echo 0x182220c4 > $DCC_PATH/config
}

config_talos_dcc_pdc_apps()
{
    #RSC_PCU
    echo 0x18000024 > $DCC_PATH/config
    echo 0x18000040 > $DCC_PATH/config
    echo 0x18010024 > $DCC_PATH/config
    echo 0x18010040 > $DCC_PATH/config
    echo 0x18020024 > $DCC_PATH/config
    echo 0x18020040 > $DCC_PATH/config
    echo 0x18030024 > $DCC_PATH/config
    echo 0x18030040 > $DCC_PATH/config
    echo 0x18040024 > $DCC_PATH/config
    echo 0x18040040 > $DCC_PATH/config
    echo 0x18050024 > $DCC_PATH/config
    echo 0x18050040 > $DCC_PATH/config
    echo 0x18060024 > $DCC_PATH/config
    echo 0x18060040 > $DCC_PATH/config
    echo 0x18070024 > $DCC_PATH/config
    echo 0x18070040 > $DCC_PATH/config
    echo 0x18080024 > $DCC_PATH/config
    echo 0x18080040 > $DCC_PATH/config
    echo 0x180800F8 > $DCC_PATH/config
    echo 0x18080104 > $DCC_PATH/config
    echo 0x1808011C > $DCC_PATH/config
    echo 0x18080128 > $DCC_PATH/config
}

config_talos_dcc_rscc_lpass()
{
    #RSCp
    echo 0x62B90010 > $DCC_PATH/config
    echo 0x62B90014 > $DCC_PATH/config
    echo 0x62B90018 > $DCC_PATH/config
    echo 0x62B90030 > $DCC_PATH/config
    echo 0x62B90038 > $DCC_PATH/config
    echo 0x62B90040 > $DCC_PATH/config
    echo 0x62B90048 > $DCC_PATH/config
    echo 0x62B900D0 > $DCC_PATH/config
    echo 0x62B90210 > $DCC_PATH/config
    echo 0x62B90230 > $DCC_PATH/config
    echo 0x62B90250 > $DCC_PATH/config
    echo 0x62B90270 > $DCC_PATH/config
    echo 0x62B90290 > $DCC_PATH/config
    echo 0x62B902B0 > $DCC_PATH/config
    echo 0x62B90208 > $DCC_PATH/config
    echo 0x62B90228 > $DCC_PATH/config
    echo 0x62B90248 > $DCC_PATH/config
    echo 0x62B90268 > $DCC_PATH/config
    echo 0x62B90288 > $DCC_PATH/config
    echo 0x62B902A8 > $DCC_PATH/config
    echo 0x62B9020C > $DCC_PATH/config
    echo 0x62B9022C > $DCC_PATH/config
    echo 0x62B9024C > $DCC_PATH/config
    echo 0x62B9026C > $DCC_PATH/config
    echo 0x62B9028C > $DCC_PATH/config
    echo 0x62B902AC > $DCC_PATH/config
    echo 0x62B90404 > $DCC_PATH/config
    echo 0x62B90408 > $DCC_PATH/config
    echo 0x62B90400 > $DCC_PATH/config
    echo 0x62B90D04 > $DCC_PATH/config

    #RSCc
    echo 0x624B0010 > $DCC_PATH/config
    echo 0x624B0014 > $DCC_PATH/config
    echo 0x624B0018 > $DCC_PATH/config
    echo 0x624B0210 > $DCC_PATH/config
    echo 0x624B0230 > $DCC_PATH/config
    echo 0x624B0250 > $DCC_PATH/config
    echo 0x624B0270 > $DCC_PATH/config
    echo 0x624B0290 > $DCC_PATH/config
    echo 0x624B02B0 > $DCC_PATH/config
    echo 0x624B0208 > $DCC_PATH/config
    echo 0x624B0228 > $DCC_PATH/config
    echo 0x624B0248 > $DCC_PATH/config
    echo 0x624B0268 > $DCC_PATH/config
    echo 0x624B0288 > $DCC_PATH/config
    echo 0x624B02A8 > $DCC_PATH/config
    echo 0x624B020C > $DCC_PATH/config
    echo 0x624B022C > $DCC_PATH/config
    echo 0x624B024C > $DCC_PATH/config
    echo 0x624B026C > $DCC_PATH/config
    echo 0x624B028C > $DCC_PATH/config
    echo 0x624B02AC > $DCC_PATH/config
    echo 0x624B0400 > $DCC_PATH/config
    echo 0x624B0404 > $DCC_PATH/config
    echo 0x624B0408 > $DCC_PATH/config

    #Q6_Status
    echo 0x62402028 > $DCC_PATH/config

    #RSC-TCS
    echo 0x62b9000c > $DCC_PATH/config
    echo 0x62b91c14 > $DCC_PATH/config
    echo 0x62b91eb4 > $DCC_PATH/config
    echo 0x62b92154 > $DCC_PATH/config
    echo 0x62b923f4 > $DCC_PATH/config
    echo 0x62b92694 > $DCC_PATH/config
    echo 0x62b92934 > $DCC_PATH/config
    echo 0x62b91c18 > $DCC_PATH/config
    echo 0x62b91eb8 > $DCC_PATH/config
    echo 0x62b92158 > $DCC_PATH/config
    echo 0x62b923f8 > $DCC_PATH/config
    echo 0x62b92698 > $DCC_PATH/config
    echo 0x62b92938 > $DCC_PATH/config
    echo 0x62b91c00 > $DCC_PATH/config
    echo 0x62b91c04 > $DCC_PATH/config
    echo 0x62b91c1c > $DCC_PATH/config
    echo 0x62b91ebc > $DCC_PATH/config
    echo 0x62b9215c > $DCC_PATH/config
    echo 0x62b923fc > $DCC_PATH/config
    echo 0x62b9269c > $DCC_PATH/config
    echo 0x62b9293c > $DCC_PATH/config
    echo 0x62b92174 > $DCC_PATH/config
    echo 0x62b92188 > $DCC_PATH/config
    echo 0x62b9219c > $DCC_PATH/config
    echo 0x62b921b0 > $DCC_PATH/config
    echo 0x62b921c4 > $DCC_PATH/config
    echo 0x62b921d8 > $DCC_PATH/config
    echo 0x62b921ec > $DCC_PATH/config
    echo 0x62b92200 > $DCC_PATH/config
    echo 0x62b92214 > $DCC_PATH/config
    echo 0x62b92228 > $DCC_PATH/config
    echo 0x62b9223c > $DCC_PATH/config
    echo 0x62b92250 > $DCC_PATH/config
    echo 0x62b92264 > $DCC_PATH/config
    echo 0x62b92278 > $DCC_PATH/config
    echo 0x62b9228c > $DCC_PATH/config
    echo 0x62b922a0 > $DCC_PATH/config
    echo 0x62b92414 > $DCC_PATH/config
    echo 0x62b92428 > $DCC_PATH/config
    echo 0x62b9243c > $DCC_PATH/config
    echo 0x62b92450 > $DCC_PATH/config
    echo 0x62b92464 > $DCC_PATH/config
    echo 0x62b92478 > $DCC_PATH/config
    echo 0x62b9248c > $DCC_PATH/config
    echo 0x62b924a0 > $DCC_PATH/config
    echo 0x62b924b4 > $DCC_PATH/config
    echo 0x62b924c8 > $DCC_PATH/config
    echo 0x62b924dc > $DCC_PATH/config
    echo 0x62b924f0 > $DCC_PATH/config
    echo 0x62b92504 > $DCC_PATH/config
    echo 0x62b92518 > $DCC_PATH/config
    echo 0x62b9252c > $DCC_PATH/config
    echo 0x62b92540 > $DCC_PATH/config
    echo 0x62b926b4 > $DCC_PATH/config
    echo 0x62b926c8 > $DCC_PATH/config
    echo 0x62b926dc > $DCC_PATH/config
    echo 0x62b926f0 > $DCC_PATH/config
    echo 0x62b92704 > $DCC_PATH/config
    echo 0x62b92718 > $DCC_PATH/config
    echo 0x62b9272c > $DCC_PATH/config
    echo 0x62b92740 > $DCC_PATH/config
    echo 0x62b92754 > $DCC_PATH/config
    echo 0x62b92768 > $DCC_PATH/config
    echo 0x62b9277c > $DCC_PATH/config
    echo 0x62b92790 > $DCC_PATH/config
    echo 0x62b927a4 > $DCC_PATH/config
    echo 0x62b927b8 > $DCC_PATH/config
    echo 0x62b927cc > $DCC_PATH/config
    echo 0x62b927e0 > $DCC_PATH/config
    echo 0x62b92954 > $DCC_PATH/config
    echo 0x62b92968 > $DCC_PATH/config
    echo 0x62b9297c > $DCC_PATH/config
    echo 0x62b92990 > $DCC_PATH/config
    echo 0x62b929a4 > $DCC_PATH/config
    echo 0x62b929b8 > $DCC_PATH/config
    echo 0x62b929cc > $DCC_PATH/config
    echo 0x62b929e0 > $DCC_PATH/config
    echo 0x62b929f4 > $DCC_PATH/config
    echo 0x62b92a08 > $DCC_PATH/config
    echo 0x62b92a1c > $DCC_PATH/config
    echo 0x62b92a30 > $DCC_PATH/config
    echo 0x62b92a44 > $DCC_PATH/config
    echo 0x62b92a58 > $DCC_PATH/config
    echo 0x62b92a6c > $DCC_PATH/config
    echo 0x62b92a80 > $DCC_PATH/config
    echo 0x62b92178 > $DCC_PATH/config
    echo 0x62b9218c > $DCC_PATH/config
    echo 0x62b921a0 > $DCC_PATH/config
    echo 0x62b921b4 > $DCC_PATH/config
    echo 0x62b921c8 > $DCC_PATH/config
    echo 0x62b921dc > $DCC_PATH/config
    echo 0x62b921f0 > $DCC_PATH/config
    echo 0x62b92204 > $DCC_PATH/config
    echo 0x62b92218 > $DCC_PATH/config
    echo 0x62b9222c > $DCC_PATH/config
    echo 0x62b92240 > $DCC_PATH/config
    echo 0x62b92254 > $DCC_PATH/config
    echo 0x62b92268 > $DCC_PATH/config
    echo 0x62b9227c > $DCC_PATH/config
    echo 0x62b92290 > $DCC_PATH/config
    echo 0x62b922a4 > $DCC_PATH/config
    echo 0x62b92418 > $DCC_PATH/config
    echo 0x62b9242c > $DCC_PATH/config
    echo 0x62b92440 > $DCC_PATH/config
    echo 0x62b92454 > $DCC_PATH/config
    echo 0x62b92468 > $DCC_PATH/config
    echo 0x62b9247c > $DCC_PATH/config
    echo 0x62b92490 > $DCC_PATH/config
    echo 0x62b924a4 > $DCC_PATH/config
    echo 0x62b924b8 > $DCC_PATH/config
    echo 0x62b924cc > $DCC_PATH/config
    echo 0x62b924e0 > $DCC_PATH/config
    echo 0x62b924f4 > $DCC_PATH/config
    echo 0x62b92508 > $DCC_PATH/config
    echo 0x62b9251c > $DCC_PATH/config
    echo 0x62b92530 > $DCC_PATH/config
    echo 0x62b92544 > $DCC_PATH/config
    echo 0x62b926b8 > $DCC_PATH/config
    echo 0x62b926cc > $DCC_PATH/config
    echo 0x62b926e0 > $DCC_PATH/config
    echo 0x62b926f4 > $DCC_PATH/config
    echo 0x62b92708 > $DCC_PATH/config
    echo 0x62b9271c > $DCC_PATH/config
    echo 0x62b92730 > $DCC_PATH/config
    echo 0x62b92744 > $DCC_PATH/config
    echo 0x62b92758 > $DCC_PATH/config
    echo 0x62b9276c > $DCC_PATH/config
    echo 0x62b92780 > $DCC_PATH/config
    echo 0x62b92794 > $DCC_PATH/config
    echo 0x62b927a8 > $DCC_PATH/config
    echo 0x62b927bc > $DCC_PATH/config
    echo 0x62b927d0 > $DCC_PATH/config
    echo 0x62b927e4 > $DCC_PATH/config
    echo 0x62b92958 > $DCC_PATH/config
    echo 0x62b9296c > $DCC_PATH/config
    echo 0x62b92980 > $DCC_PATH/config
    echo 0x62b92994 > $DCC_PATH/config
    echo 0x62b929a8 > $DCC_PATH/config
    echo 0x62b929bc > $DCC_PATH/config
    echo 0x62b929d0 > $DCC_PATH/config
    echo 0x62b929e4 > $DCC_PATH/config
    echo 0x62b929f8 > $DCC_PATH/config
    echo 0x62b92a0c > $DCC_PATH/config
    echo 0x62b92a20 > $DCC_PATH/config
    echo 0x62b92a34 > $DCC_PATH/config
    echo 0x62b92a48 > $DCC_PATH/config
    echo 0x62b92a5c > $DCC_PATH/config
    echo 0x62b92a70 > $DCC_PATH/config
    echo 0x62b92a84 > $DCC_PATH/config

}

config_talos_dcc_rscc_modem()
{
    #RSCp
    echo 0x4200010 > $DCC_PATH/config
    echo 0x4200014 > $DCC_PATH/config
    echo 0x4200018 > $DCC_PATH/config
    echo 0x4200030 > $DCC_PATH/config
    echo 0x4200038 > $DCC_PATH/config
    echo 0x4200040 > $DCC_PATH/config
    echo 0x4200048 > $DCC_PATH/config
    echo 0x42000D0 > $DCC_PATH/config
    echo 0x4200210 > $DCC_PATH/config
    echo 0x4200230 > $DCC_PATH/config
    echo 0x4200250 > $DCC_PATH/config
    echo 0x4200270 > $DCC_PATH/config
    echo 0x4200290 > $DCC_PATH/config
    echo 0x42002B0 > $DCC_PATH/config
    echo 0x4200208 > $DCC_PATH/config
    echo 0x4200228 > $DCC_PATH/config
    echo 0x4200248 > $DCC_PATH/config
    echo 0x4200268 > $DCC_PATH/config
    echo 0x4200288 > $DCC_PATH/config
    echo 0x42002A8 > $DCC_PATH/config
    echo 0x420020C > $DCC_PATH/config
    echo 0x420022C > $DCC_PATH/config
    echo 0x420024C > $DCC_PATH/config
    echo 0x420026C > $DCC_PATH/config
    echo 0x420028C > $DCC_PATH/config
    echo 0x42002AC > $DCC_PATH/config
    echo 0x4200404 > $DCC_PATH/config
    echo 0x4200408 > $DCC_PATH/config
    echo 0x4200400 > $DCC_PATH/config
    echo 0x4200D04 > $DCC_PATH/config

    #RSCc
    echo 0x4130010 > $DCC_PATH/config
    echo 0x4130014 > $DCC_PATH/config
    echo 0x4130018 > $DCC_PATH/config
    echo 0x4130210 > $DCC_PATH/config
    echo 0x4130230 > $DCC_PATH/config
    echo 0x4130250 > $DCC_PATH/config
    echo 0x4130270 > $DCC_PATH/config
    echo 0x4130290 > $DCC_PATH/config
    echo 0x41302B0 > $DCC_PATH/config
    echo 0x4130208 > $DCC_PATH/config
    echo 0x4130228 > $DCC_PATH/config
    echo 0x4130248 > $DCC_PATH/config
    echo 0x4130268 > $DCC_PATH/config
    echo 0x4130288 > $DCC_PATH/config
    echo 0x41302A8 > $DCC_PATH/config
    echo 0x413020C > $DCC_PATH/config
    echo 0x413022C > $DCC_PATH/config
    echo 0x413024C > $DCC_PATH/config
    echo 0x413026C > $DCC_PATH/config
    echo 0x413028C > $DCC_PATH/config
    echo 0x41302AC > $DCC_PATH/config
    echo 0x4130400 > $DCC_PATH/config
    echo 0x4130404 > $DCC_PATH/config
    echo 0x4130408 > $DCC_PATH/config

    #Q6 status
    echo 0x4082028  > $DCC_PATH/config
    echo 0x0018A00C > $DCC_PATH/config

    #RSC-TCS
    echo 0x420000c > $DCC_PATH/config
    echo 0x4200d14 > $DCC_PATH/config
    echo 0x4200fb4 > $DCC_PATH/config
    echo 0x4201254 > $DCC_PATH/config
    echo 0x42014f4 > $DCC_PATH/config
    echo 0x4201794 > $DCC_PATH/config
    echo 0x4201a34 > $DCC_PATH/config
    echo 0x4201cd4 > $DCC_PATH/config
    echo 0x4201f74 > $DCC_PATH/config
    echo 0x4200d18 > $DCC_PATH/config
    echo 0x4200fb8 > $DCC_PATH/config
    echo 0x4201258 > $DCC_PATH/config
    echo 0x42014f8 > $DCC_PATH/config
    echo 0x4201798 > $DCC_PATH/config
    echo 0x4201a38 > $DCC_PATH/config
    echo 0x4201cd8 > $DCC_PATH/config
    echo 0x4201f78 > $DCC_PATH/config
    echo 0x4200d00 > $DCC_PATH/config
    echo 0x4200d04 > $DCC_PATH/config
    echo 0x4200d1c > $DCC_PATH/config
    echo 0x4200fbc > $DCC_PATH/config
    echo 0x420125c > $DCC_PATH/config
    echo 0x42014fc > $DCC_PATH/config
    echo 0x420179c > $DCC_PATH/config
    echo 0x4201a3c > $DCC_PATH/config
    echo 0x4201cdc > $DCC_PATH/config
    echo 0x4201f7c > $DCC_PATH/config
    echo 0x4201274 > $DCC_PATH/config
    echo 0x4201288 > $DCC_PATH/config
    echo 0x420129c > $DCC_PATH/config
    echo 0x42012b0 > $DCC_PATH/config
    echo 0x42012c4 > $DCC_PATH/config
    echo 0x42012d8 > $DCC_PATH/config
    echo 0x42012ec > $DCC_PATH/config
    echo 0x4201300 > $DCC_PATH/config
    echo 0x4201314 > $DCC_PATH/config
    echo 0x4201328 > $DCC_PATH/config
    echo 0x420133c > $DCC_PATH/config
    echo 0x4201350 > $DCC_PATH/config
    echo 0x4201364 > $DCC_PATH/config
    echo 0x4201378 > $DCC_PATH/config
    echo 0x420138c > $DCC_PATH/config
    echo 0x42013a0 > $DCC_PATH/config
    echo 0x4201514 > $DCC_PATH/config
    echo 0x4201528 > $DCC_PATH/config
    echo 0x420153c > $DCC_PATH/config
    echo 0x4201550 > $DCC_PATH/config
    echo 0x4201564 > $DCC_PATH/config
    echo 0x4201578 > $DCC_PATH/config
    echo 0x420158c > $DCC_PATH/config
    echo 0x42015a0 > $DCC_PATH/config
    echo 0x42015b4 > $DCC_PATH/config
    echo 0x42015c8 > $DCC_PATH/config
    echo 0x42015dc > $DCC_PATH/config
    echo 0x42015f0 > $DCC_PATH/config
    echo 0x4201604 > $DCC_PATH/config
    echo 0x4201618 > $DCC_PATH/config
    echo 0x420162c > $DCC_PATH/config
    echo 0x4201640 > $DCC_PATH/config
    echo 0x42017b4 > $DCC_PATH/config
    echo 0x42017c8 > $DCC_PATH/config
    echo 0x42017dc > $DCC_PATH/config
    echo 0x42017f0 > $DCC_PATH/config
    echo 0x4201804 > $DCC_PATH/config
    echo 0x4201818 > $DCC_PATH/config
    echo 0x420182c > $DCC_PATH/config
    echo 0x4201840 > $DCC_PATH/config
    echo 0x4201854 > $DCC_PATH/config
    echo 0x4201868 > $DCC_PATH/config
    echo 0x420187c > $DCC_PATH/config
    echo 0x4201890 > $DCC_PATH/config
    echo 0x42018a4 > $DCC_PATH/config
    echo 0x42018b8 > $DCC_PATH/config
    echo 0x42018cc > $DCC_PATH/config
    echo 0x42018e0 > $DCC_PATH/config
    echo 0x4201a54 > $DCC_PATH/config
    echo 0x4201a68 > $DCC_PATH/config
    echo 0x4201a7c > $DCC_PATH/config
    echo 0x4201a90 > $DCC_PATH/config
    echo 0x4201aa4 > $DCC_PATH/config
    echo 0x4201ab8 > $DCC_PATH/config
    echo 0x4201acc > $DCC_PATH/config
    echo 0x4201ae0 > $DCC_PATH/config
    echo 0x4201af4 > $DCC_PATH/config
    echo 0x4201b08 > $DCC_PATH/config
    echo 0x4201b1c > $DCC_PATH/config
    echo 0x4201b30 > $DCC_PATH/config
    echo 0x4201b44 > $DCC_PATH/config
    echo 0x4201b58 > $DCC_PATH/config
    echo 0x4201b6c > $DCC_PATH/config
    echo 0x4201b80 > $DCC_PATH/config
    echo 0x4201cf4 > $DCC_PATH/config
    echo 0x4201d08 > $DCC_PATH/config
    echo 0x4201d1c > $DCC_PATH/config
    echo 0x4201d30 > $DCC_PATH/config
    echo 0x4201d44 > $DCC_PATH/config
    echo 0x4201d58 > $DCC_PATH/config
    echo 0x4201d6c > $DCC_PATH/config
    echo 0x4201d80 > $DCC_PATH/config
    echo 0x4201d94 > $DCC_PATH/config
    echo 0x4201da8 > $DCC_PATH/config
    echo 0x4201dbc > $DCC_PATH/config
    echo 0x4201dd0 > $DCC_PATH/config
    echo 0x4201de4 > $DCC_PATH/config
    echo 0x4201df8 > $DCC_PATH/config
    echo 0x4201e0c > $DCC_PATH/config
    echo 0x4201e20 > $DCC_PATH/config
    echo 0x4201f94 > $DCC_PATH/config
    echo 0x4201fa8 > $DCC_PATH/config
    echo 0x4201fbc > $DCC_PATH/config
    echo 0x4201fd0 > $DCC_PATH/config
    echo 0x4201fe4 > $DCC_PATH/config
    echo 0x4201ff8 > $DCC_PATH/config
    echo 0x420200c > $DCC_PATH/config
    echo 0x4202020 > $DCC_PATH/config
    echo 0x4202034 > $DCC_PATH/config
    echo 0x4202048 > $DCC_PATH/config
    echo 0x420205c > $DCC_PATH/config
    echo 0x4202070 > $DCC_PATH/config
    echo 0x4202084 > $DCC_PATH/config
    echo 0x4202098 > $DCC_PATH/config
    echo 0x42020ac > $DCC_PATH/config
    echo 0x42020c0 > $DCC_PATH/config
    echo 0x4201278 > $DCC_PATH/config
    echo 0x420128c > $DCC_PATH/config
    echo 0x42012a0 > $DCC_PATH/config
    echo 0x42012b4 > $DCC_PATH/config
    echo 0x42012c8 > $DCC_PATH/config
    echo 0x42012dc > $DCC_PATH/config
    echo 0x42012f0 > $DCC_PATH/config
    echo 0x4201304 > $DCC_PATH/config
    echo 0x4201318 > $DCC_PATH/config
    echo 0x420132c > $DCC_PATH/config
    echo 0x4201340 > $DCC_PATH/config
    echo 0x4201354 > $DCC_PATH/config
    echo 0x4201368 > $DCC_PATH/config
    echo 0x420137c > $DCC_PATH/config
    echo 0x4201390 > $DCC_PATH/config
    echo 0x42013a4 > $DCC_PATH/config
    echo 0x4201518 > $DCC_PATH/config
    echo 0x420152c > $DCC_PATH/config
    echo 0x4201540 > $DCC_PATH/config
    echo 0x4201554 > $DCC_PATH/config
    echo 0x4201568 > $DCC_PATH/config
    echo 0x420157c > $DCC_PATH/config
    echo 0x4201590 > $DCC_PATH/config
    echo 0x42015a4 > $DCC_PATH/config
    echo 0x42015b8 > $DCC_PATH/config
    echo 0x42015cc > $DCC_PATH/config
    echo 0x42015e0 > $DCC_PATH/config
    echo 0x42015f4 > $DCC_PATH/config
    echo 0x4201608 > $DCC_PATH/config
    echo 0x420161c > $DCC_PATH/config
    echo 0x4201630 > $DCC_PATH/config
    echo 0x4201644 > $DCC_PATH/config
    echo 0x42017b8 > $DCC_PATH/config
    echo 0x42017cc > $DCC_PATH/config
    echo 0x42017e0 > $DCC_PATH/config
    echo 0x42017f4 > $DCC_PATH/config
    echo 0x4201808 > $DCC_PATH/config
    echo 0x420181c > $DCC_PATH/config
    echo 0x4201830 > $DCC_PATH/config
    echo 0x4201844 > $DCC_PATH/config
    echo 0x4201858 > $DCC_PATH/config
    echo 0x420186c > $DCC_PATH/config
    echo 0x4201880 > $DCC_PATH/config
    echo 0x4201894 > $DCC_PATH/config
    echo 0x42018a8 > $DCC_PATH/config
    echo 0x42018bc > $DCC_PATH/config
    echo 0x42018d0 > $DCC_PATH/config
    echo 0x42018e4 > $DCC_PATH/config
    echo 0x4201a58 > $DCC_PATH/config
    echo 0x4201a6c > $DCC_PATH/config
    echo 0x4201a80 > $DCC_PATH/config
    echo 0x4201a94 > $DCC_PATH/config
    echo 0x4201aa8 > $DCC_PATH/config
    echo 0x4201abc > $DCC_PATH/config
    echo 0x4201ad0 > $DCC_PATH/config
    echo 0x4201ae4 > $DCC_PATH/config
    echo 0x4201af8 > $DCC_PATH/config
    echo 0x4201b0c > $DCC_PATH/config
    echo 0x4201b20 > $DCC_PATH/config
    echo 0x4201b34 > $DCC_PATH/config
    echo 0x4201b48 > $DCC_PATH/config
    echo 0x4201b5c > $DCC_PATH/config
    echo 0x4201b70 > $DCC_PATH/config
    echo 0x4201b84 > $DCC_PATH/config
    echo 0x4201cf8 > $DCC_PATH/config
    echo 0x4201d0c > $DCC_PATH/config
    echo 0x4201d20 > $DCC_PATH/config
    echo 0x4201d34 > $DCC_PATH/config
    echo 0x4201d48 > $DCC_PATH/config
    echo 0x4201d5c > $DCC_PATH/config
    echo 0x4201d70 > $DCC_PATH/config
    echo 0x4201d84 > $DCC_PATH/config
    echo 0x4201d98 > $DCC_PATH/config
    echo 0x4201dac > $DCC_PATH/config
    echo 0x4201dc0 > $DCC_PATH/config
    echo 0x4201dd4 > $DCC_PATH/config
    echo 0x4201de8 > $DCC_PATH/config
    echo 0x4201dfc > $DCC_PATH/config
    echo 0x4201e10 > $DCC_PATH/config
    echo 0x4201e24 > $DCC_PATH/config
    echo 0x4201f98 > $DCC_PATH/config
    echo 0x4201fac > $DCC_PATH/config
    echo 0x4201fc0 > $DCC_PATH/config
    echo 0x4201fd4 > $DCC_PATH/config
    echo 0x4201fe8 > $DCC_PATH/config
    echo 0x4201ffc > $DCC_PATH/config
    echo 0x4202010 > $DCC_PATH/config
    echo 0x4202024 > $DCC_PATH/config
    echo 0x4202038 > $DCC_PATH/config
    echo 0x420204c > $DCC_PATH/config
    echo 0x4202060 > $DCC_PATH/config
    echo 0x4202074 > $DCC_PATH/config
    echo 0x4202088 > $DCC_PATH/config
    echo 0x420209c > $DCC_PATH/config
    echo 0x42020b0 > $DCC_PATH/config
    echo 0x42020c4 > $DCC_PATH/config
}

config_talos_dcc_rscc_cdsp()
{
    #RSCp
    echo 0x80A4010 > $DCC_PATH/config
    echo 0x80A4014 > $DCC_PATH/config
    echo 0x80A4018 > $DCC_PATH/config
    echo 0x80A4030 > $DCC_PATH/config
    echo 0x80A4038 > $DCC_PATH/config
    echo 0x80A4040 > $DCC_PATH/config
    echo 0x80A4048 > $DCC_PATH/config
    echo 0x80A40D0 > $DCC_PATH/config
    echo 0x80A4210 > $DCC_PATH/config
    echo 0x80A4230 > $DCC_PATH/config
    echo 0x80A4250 > $DCC_PATH/config
    echo 0x80A4270 > $DCC_PATH/config
    echo 0x80A4290 > $DCC_PATH/config
    echo 0x80A42B0 > $DCC_PATH/config
    echo 0x80A4208 > $DCC_PATH/config
    echo 0x80A4228 > $DCC_PATH/config
    echo 0x80A4248 > $DCC_PATH/config
    echo 0x80A4268 > $DCC_PATH/config
    echo 0x80A4288 > $DCC_PATH/config
    echo 0x80A42A8 > $DCC_PATH/config
    echo 0x80A420C > $DCC_PATH/config
    echo 0x80A422C > $DCC_PATH/config
    echo 0x80A424C > $DCC_PATH/config
    echo 0x80A426C > $DCC_PATH/config
    echo 0x80A428C > $DCC_PATH/config
    echo 0x80A42AC > $DCC_PATH/config
    echo 0x80A4404 > $DCC_PATH/config
    echo 0x80A4408 > $DCC_PATH/config
    echo 0x80A4400 > $DCC_PATH/config
    echo 0x80A4D04 > $DCC_PATH/config

    #RSCc_CDSP
    echo 0x83B0010 > $DCC_PATH/config
    echo 0x83B0014 > $DCC_PATH/config
    echo 0x83B0018 > $DCC_PATH/config
    echo 0x83B0210 > $DCC_PATH/config
    echo 0x83B0230 > $DCC_PATH/config
    echo 0x83B0250 > $DCC_PATH/config
    echo 0x83B0270 > $DCC_PATH/config
    echo 0x83B0290 > $DCC_PATH/config
    echo 0x83B02B0 > $DCC_PATH/config
    echo 0x83B0208 > $DCC_PATH/config
    echo 0x83B0228 > $DCC_PATH/config
    echo 0x83B0248 > $DCC_PATH/config
    echo 0x83B0268 > $DCC_PATH/config
    echo 0x83B0288 > $DCC_PATH/config
    echo 0x83B02A8 > $DCC_PATH/config
    echo 0x83B020C > $DCC_PATH/config
    echo 0x83B022C > $DCC_PATH/config
    echo 0x83B024C > $DCC_PATH/config
    echo 0x83B026C > $DCC_PATH/config
    echo 0x83B028C > $DCC_PATH/config
    echo 0x83B02AC > $DCC_PATH/config
    echo 0x83B0400 > $DCC_PATH/config
    echo 0x83B0404 > $DCC_PATH/config
    echo 0x83B0408 > $DCC_PATH/config

    #Q6 Status
    echo 0x8302028 > $DCC_PATH/config

    #RSC_TCS
    echo 0x80a400c > $DCC_PATH/config
    echo 0x80a4d14 > $DCC_PATH/config
    echo 0x80a4fb4 > $DCC_PATH/config
    echo 0x80a5254 > $DCC_PATH/config
    echo 0x80a54f4 > $DCC_PATH/config
    echo 0x80a4d18 > $DCC_PATH/config
    echo 0x80a4fb8 > $DCC_PATH/config
    echo 0x80a5258 > $DCC_PATH/config
    echo 0x80a54f8 > $DCC_PATH/config
    echo 0x80a4d00 > $DCC_PATH/config
    echo 0x80a4d04 > $DCC_PATH/config
    echo 0x80a4d1c > $DCC_PATH/config
    echo 0x80a4fbc > $DCC_PATH/config
    echo 0x80a525c > $DCC_PATH/config
    echo 0x80a54fc > $DCC_PATH/config
    echo 0x80a5274 > $DCC_PATH/config
    echo 0x80a5288 > $DCC_PATH/config
    echo 0x80a529c > $DCC_PATH/config
    echo 0x80a52b0 > $DCC_PATH/config
    echo 0x80a52c4 > $DCC_PATH/config
    echo 0x80a52d8 > $DCC_PATH/config
    echo 0x80a52ec > $DCC_PATH/config
    echo 0x80a5300 > $DCC_PATH/config
    echo 0x80a5314 > $DCC_PATH/config
    echo 0x80a5328 > $DCC_PATH/config
    echo 0x80a533c > $DCC_PATH/config
    echo 0x80a5350 > $DCC_PATH/config
    echo 0x80a5514 > $DCC_PATH/config
    echo 0x80a5528 > $DCC_PATH/config
    echo 0x80a553c > $DCC_PATH/config
    echo 0x80a5550 > $DCC_PATH/config
    echo 0x80a5564 > $DCC_PATH/config
    echo 0x80a5578 > $DCC_PATH/config
    echo 0x80a558c > $DCC_PATH/config
    echo 0x80a55a0 > $DCC_PATH/config
    echo 0x80a55b4 > $DCC_PATH/config
    echo 0x80a55c8 > $DCC_PATH/config
    echo 0x80a55dc > $DCC_PATH/config
    echo 0x80a55f0 > $DCC_PATH/config
    echo 0x80a5278 > $DCC_PATH/config
    echo 0x80a528c > $DCC_PATH/config
    echo 0x80a52a0 > $DCC_PATH/config
    echo 0x80a52b4 > $DCC_PATH/config
    echo 0x80a52c8 > $DCC_PATH/config
    echo 0x80a52dc > $DCC_PATH/config
    echo 0x80a52f0 > $DCC_PATH/config
    echo 0x80a5304 > $DCC_PATH/config
    echo 0x80a5318 > $DCC_PATH/config
    echo 0x80a532c > $DCC_PATH/config
    echo 0x80a5340 > $DCC_PATH/config
    echo 0x80a5354 > $DCC_PATH/config
    echo 0x80a5518 > $DCC_PATH/config
    echo 0x80a552c > $DCC_PATH/config
    echo 0x80a5540 > $DCC_PATH/config
    echo 0x80a5554 > $DCC_PATH/config
    echo 0x80a5568 > $DCC_PATH/config
    echo 0x80a557c > $DCC_PATH/config
    echo 0x80a5590 > $DCC_PATH/config
    echo 0x80a55a4 > $DCC_PATH/config
    echo 0x80a55b8 > $DCC_PATH/config
    echo 0x80a55cc > $DCC_PATH/config
    echo 0x80a55e0 > $DCC_PATH/config
    echo 0x80a55f4 > $DCC_PATH/config
}

config_talos_dcc_axi_pc()
{
    #AXI_PC
}

config_talos_dcc_apb_pc()
{
    #APB_PC
}

config_talos_dcc_memnoc_mccc()
{
    #MCCC
    echo 0x90b0280 > $DCC_PATH/config
    echo 0x90b0288 > $DCC_PATH/config
    echo 0x90b028c > $DCC_PATH/config
    echo 0x90b0290 > $DCC_PATH/config
    echo 0x90b0294 > $DCC_PATH/config
    echo 0x90b0298 > $DCC_PATH/config
    echo 0x90b029c > $DCC_PATH/config
    echo 0x90b02a0 > $DCC_PATH/config

}

config_talos_dcc_gpu()
{
    #GCC
    echo 0x105050 > $DCC_PATH/config
    echo 0x171004 > $DCC_PATH/config
    echo 0x171154 > $DCC_PATH/config
    echo 0x17100C > $DCC_PATH/config
    echo 0x171018 > $DCC_PATH/config

    #GPUCC
    echo 0x5091004 > $DCC_PATH/config
    echo 0x509100c > $DCC_PATH/config
    echo 0x5091010 > $DCC_PATH/config
    echo 0x5091014 > $DCC_PATH/config
    echo 0x5091054 > $DCC_PATH/config
    echo 0x5091060 > $DCC_PATH/config
    echo 0x509106c > $DCC_PATH/config
    echo 0x5091070 > $DCC_PATH/config
    echo 0x5091074 > $DCC_PATH/config
    echo 0x5091078 > $DCC_PATH/config
    echo 0x509107c > $DCC_PATH/config
    echo 0x509108c > $DCC_PATH/config
    echo 0x5091098 > $DCC_PATH/config
    echo 0x509109c > $DCC_PATH/config
}

config_talos_dcc_pdc_display()
{
    #PDC_DISPLAY
}

config_talos_dcc_aop_rpmh()
{
    #AOP_RPMH &  TCS

}

config_talos_dcc_lmh()
{
    #LMH
}

config_talos_dcc_ipm_apps()
{
    #IPM_APPS
}

config_talos_dcc_osm()
{
    #APSS_OSM
    echo 0x18321700 > $DCC_PATH/config
    echo 0x18322C18 > $DCC_PATH/config
    echo 0x18323700 > $DCC_PATH/config
    echo 0x18324C18 > $DCC_PATH/config
    echo 0x18325F00 > $DCC_PATH/config
    echo 0x18327418 > $DCC_PATH/config
}

config_talos_dcc_ddr_phy()
{
    #PHY
}

config_talos_dcc_ecc_llc()
{
    #ECC_LLC
}

config_talos_dcc_cabo_llcc_shrm()
{
    #LLCC/CABO
    echo 0x9236028 > $DCC_PATH/config
    echo 0x923602C > $DCC_PATH/config
    echo 0x9236030 > $DCC_PATH/config
    echo 0x9236034 > $DCC_PATH/config
    echo 0x9236038 > $DCC_PATH/config
    echo 0x9232100 > $DCC_PATH/config
    echo 0x92360b0 > $DCC_PATH/config
    echo 0x9236044 > $DCC_PATH/config
    echo 0x9236048 > $DCC_PATH/config
    echo 0x923604c > $DCC_PATH/config
    echo 0x9236050 > $DCC_PATH/config
    echo 0x923e030 > $DCC_PATH/config
    echo 0x923e034 > $DCC_PATH/config
    echo 0x9241000 > $DCC_PATH/config
    echo 0x9248058 > $DCC_PATH/config
    echo 0x924805c > $DCC_PATH/config
    echo 0x9248060 > $DCC_PATH/config
    echo 0x9248064 > $DCC_PATH/config

    echo 0x9260410 > $DCC_PATH/config
    echo 0x92e0410 > $DCC_PATH/config
    echo 0x9260414 > $DCC_PATH/config
    echo 0x92e0414 > $DCC_PATH/config
    echo 0x9260418 > $DCC_PATH/config
    echo 0x92e0418 > $DCC_PATH/config
    echo 0x9260420 > $DCC_PATH/config
    echo 0x9260424 > $DCC_PATH/config
    echo 0x9260430 > $DCC_PATH/config
    echo 0x9260440 > $DCC_PATH/config
    echo 0x9260448 > $DCC_PATH/config
    echo 0x92604a0 > $DCC_PATH/config
    echo 0x92e0420 > $DCC_PATH/config
    echo 0x92e0424 > $DCC_PATH/config
    echo 0x92e0430 > $DCC_PATH/config
    echo 0x92e0440 > $DCC_PATH/config
    echo 0x92e0448 > $DCC_PATH/config
    echo 0x92e04a0 > $DCC_PATH/config

    echo 0x9600000 > $DCC_PATH/config
    echo 0x9601000 > $DCC_PATH/config
    echo 0x9602000 > $DCC_PATH/config
    echo 0x9603000 > $DCC_PATH/config
    echo 0x9604000 > $DCC_PATH/config
    echo 0x9605000 > $DCC_PATH/config
    echo 0x9606000 > $DCC_PATH/config
    echo 0x9607000 > $DCC_PATH/config
    echo 0x9608000 > $DCC_PATH/config
    echo 0x9609000 > $DCC_PATH/config
    echo 0x960a000 > $DCC_PATH/config
    echo 0x960b000 > $DCC_PATH/config
    echo 0x960c000 > $DCC_PATH/config
    echo 0x960d000 > $DCC_PATH/config
    echo 0x960e000 > $DCC_PATH/config
    echo 0x960f000 > $DCC_PATH/config
    echo 0x9610000 > $DCC_PATH/config
    echo 0x9611000 > $DCC_PATH/config
    echo 0x9612000 > $DCC_PATH/config
    echo 0x9613000 > $DCC_PATH/config
    echo 0x9614000 > $DCC_PATH/config
    echo 0x9615000 > $DCC_PATH/config
    echo 0x9616000 > $DCC_PATH/config
    echo 0x9617000 > $DCC_PATH/config
    echo 0x9618000 > $DCC_PATH/config
    echo 0x9619000 > $DCC_PATH/config
    echo 0x961a000 > $DCC_PATH/config
    echo 0x961b000 > $DCC_PATH/config
    echo 0x961c000 > $DCC_PATH/config
    echo 0x961d000 > $DCC_PATH/config
    echo 0x961e000 > $DCC_PATH/config
    echo 0x961f000 > $DCC_PATH/config
    echo 0x9600004 > $DCC_PATH/config
    echo 0x9601004 > $DCC_PATH/config
    echo 0x9602004 > $DCC_PATH/config
    echo 0x9603004 > $DCC_PATH/config
    echo 0x9604004 > $DCC_PATH/config
    echo 0x9605004 > $DCC_PATH/config
    echo 0x9606004 > $DCC_PATH/config
    echo 0x9607004 > $DCC_PATH/config
    echo 0x9608004 > $DCC_PATH/config
    echo 0x9609004 > $DCC_PATH/config
    echo 0x960a004 > $DCC_PATH/config
    echo 0x960b004 > $DCC_PATH/config
    echo 0x960c004 > $DCC_PATH/config
    echo 0x960d004 > $DCC_PATH/config
    echo 0x960e004 > $DCC_PATH/config
    echo 0x960f004 > $DCC_PATH/config
    echo 0x9610004 > $DCC_PATH/config
    echo 0x9611004 > $DCC_PATH/config
    echo 0x9612004 > $DCC_PATH/config
    echo 0x9613004 > $DCC_PATH/config
    echo 0x9614004 > $DCC_PATH/config
    echo 0x9615004 > $DCC_PATH/config
    echo 0x9616004 > $DCC_PATH/config
    echo 0x9617004 > $DCC_PATH/config
    echo 0x9618004 > $DCC_PATH/config
    echo 0x9619004 > $DCC_PATH/config
    echo 0x961a004 > $DCC_PATH/config
    echo 0x961b004 > $DCC_PATH/config
    echo 0x961c004 > $DCC_PATH/config
    echo 0x961d004 > $DCC_PATH/config
    echo 0x961e004 > $DCC_PATH/config
    echo 0x961f004 > $DCC_PATH/config

    echo 0x9266418 > $DCC_PATH/config
    echo 0x92e6418 > $DCC_PATH/config
    echo 0x9265804 > $DCC_PATH/config
    echo 0x92e5804 > $DCC_PATH/config

    echo 0x92604b8 > $DCC_PATH/config
    echo 0x92e04b8 > $DCC_PATH/config

}

config_talos_dcc_cx_mx()
{
    #CX_MX
    echo 0x0C201244 1 > $DCC_PATH/config
    echo 0x0C202244 1 > $DCC_PATH/config
    #APC Voltage
    echo 0x18100C18 1 > $DCC_PATH/config
    echo 0x18101C18 1 > $DCC_PATH/config
    #APC / MX CORNER
    echo 0x18300000 1 > $DCC_PATH/config
    #CPRH
    echo 0x183A3A84 2 > $DCC_PATH/config
    echo 0x18393A84 1 > $DCC_PATH/config
}

config_talos_dcc_gcc_regs()
{
    #GCC
    echo 0x00100000 > $DCC_PATH/config
    echo 0x00100004 > $DCC_PATH/config
    echo 0x00100008 > $DCC_PATH/config
    echo 0x0010000C > $DCC_PATH/config
    echo 0x00100010 > $DCC_PATH/config
    echo 0x00100014 > $DCC_PATH/config
    echo 0x00100018 > $DCC_PATH/config
    echo 0x0010001C > $DCC_PATH/config
    echo 0x00100020 > $DCC_PATH/config
    echo 0x00100024 > $DCC_PATH/config
    echo 0x00100028 > $DCC_PATH/config
    echo 0x0010002C > $DCC_PATH/config
    echo 0x00100030 > $DCC_PATH/config
    echo 0x00100034 > $DCC_PATH/config
    echo 0x00100100 > $DCC_PATH/config
    echo 0x00100104 > $DCC_PATH/config
    echo 0x00100108 > $DCC_PATH/config
    echo 0x0010010C > $DCC_PATH/config
    echo 0x00101000 > $DCC_PATH/config
    echo 0x00101004 > $DCC_PATH/config
    echo 0x00101008 > $DCC_PATH/config
    echo 0x0010100C > $DCC_PATH/config
    echo 0x00101010 > $DCC_PATH/config
    echo 0x00101014 > $DCC_PATH/config
    echo 0x00101018 > $DCC_PATH/config
    echo 0x0010101C > $DCC_PATH/config
    echo 0x00101020 > $DCC_PATH/config
    echo 0x00101024 > $DCC_PATH/config
    echo 0x00101028 > $DCC_PATH/config
    echo 0x0010102C > $DCC_PATH/config
    echo 0x00101030 > $DCC_PATH/config
    echo 0x00101034 > $DCC_PATH/config
    echo 0x00102000 > $DCC_PATH/config
    echo 0x00102004 > $DCC_PATH/config
    echo 0x00102008 > $DCC_PATH/config
    echo 0x0010200C > $DCC_PATH/config
    echo 0x00102010 > $DCC_PATH/config
    echo 0x00102014 > $DCC_PATH/config
    echo 0x00102018 > $DCC_PATH/config
    echo 0x0010201C > $DCC_PATH/config
    echo 0x00102020 > $DCC_PATH/config
    echo 0x00102024 > $DCC_PATH/config
    echo 0x00102028 > $DCC_PATH/config
    echo 0x0010202C > $DCC_PATH/config
    echo 0x00102030 > $DCC_PATH/config
    echo 0x00102034 > $DCC_PATH/config
    echo 0x00103000 > $DCC_PATH/config
    echo 0x00103004 > $DCC_PATH/config
    echo 0x00103008 > $DCC_PATH/config
    echo 0x0010300C > $DCC_PATH/config
    echo 0x00103010 > $DCC_PATH/config
    echo 0x00103014 > $DCC_PATH/config
    echo 0x00103018 > $DCC_PATH/config
    echo 0x0010301C > $DCC_PATH/config
    echo 0x00103020 > $DCC_PATH/config
    echo 0x00103024 > $DCC_PATH/config
    echo 0x00103028 > $DCC_PATH/config
    echo 0x0010302C > $DCC_PATH/config
    echo 0x00103030 > $DCC_PATH/config
    echo 0x00103034 > $DCC_PATH/config
    echo 0x00113000 > $DCC_PATH/config
    echo 0x00113004 > $DCC_PATH/config
    echo 0x00113008 > $DCC_PATH/config
    echo 0x0011300C > $DCC_PATH/config
    echo 0x00113010 > $DCC_PATH/config
    echo 0x00113014 > $DCC_PATH/config
    echo 0x00113018 > $DCC_PATH/config
    echo 0x0011301C > $DCC_PATH/config
    echo 0x00113020 > $DCC_PATH/config
    echo 0x00113024 > $DCC_PATH/config
    echo 0x00113028 > $DCC_PATH/config
    echo 0x0011302C > $DCC_PATH/config
    echo 0x00113030 > $DCC_PATH/config
    echo 0x00113034 > $DCC_PATH/config
    echo 0x0011A000 > $DCC_PATH/config
    echo 0x0011A004 > $DCC_PATH/config
    echo 0x0011A008 > $DCC_PATH/config
    echo 0x0011A00C > $DCC_PATH/config
    echo 0x0011A010 > $DCC_PATH/config
    echo 0x0011A014 > $DCC_PATH/config
    echo 0x0011A018 > $DCC_PATH/config
    echo 0x0011A01C > $DCC_PATH/config
    echo 0x0011A020 > $DCC_PATH/config
    echo 0x0011A024 > $DCC_PATH/config
    echo 0x0011A028 > $DCC_PATH/config
    echo 0x0011A02C > $DCC_PATH/config
    echo 0x0011A030 > $DCC_PATH/config
    echo 0x0011A034 > $DCC_PATH/config
    echo 0x0011B000 > $DCC_PATH/config
    echo 0x0011B004 > $DCC_PATH/config
    echo 0x0011B008 > $DCC_PATH/config
    echo 0x0011B00C > $DCC_PATH/config
    echo 0x0011B010 > $DCC_PATH/config
    echo 0x0011B014 > $DCC_PATH/config
    echo 0x0011B018 > $DCC_PATH/config
    echo 0x0011B01C > $DCC_PATH/config
    echo 0x0011B020 > $DCC_PATH/config
    echo 0x0011B024 > $DCC_PATH/config
    echo 0x0011B028 > $DCC_PATH/config
    echo 0x0011B02C > $DCC_PATH/config
    echo 0x0011B030 > $DCC_PATH/config
    echo 0x0011B034 > $DCC_PATH/config
    echo 0x00174000 > $DCC_PATH/config
    echo 0x00174004 > $DCC_PATH/config
    echo 0x00174008 > $DCC_PATH/config
    echo 0x0017400C > $DCC_PATH/config
    echo 0x00174010 > $DCC_PATH/config
    echo 0x00174014 > $DCC_PATH/config
    echo 0x00174018 > $DCC_PATH/config
    echo 0x0017401C > $DCC_PATH/config
    echo 0x00174020 > $DCC_PATH/config
    echo 0x00174024 > $DCC_PATH/config
    echo 0x00174028 > $DCC_PATH/config
    echo 0x0017402C > $DCC_PATH/config
    echo 0x00174030 > $DCC_PATH/config
    echo 0x00174034 > $DCC_PATH/config
    echo 0x00176000 > $DCC_PATH/config
    echo 0x00176004 > $DCC_PATH/config
    echo 0x00176008 > $DCC_PATH/config
    echo 0x0017600C > $DCC_PATH/config
    echo 0x00176010 > $DCC_PATH/config
    echo 0x00176014 > $DCC_PATH/config
    echo 0x00176018 > $DCC_PATH/config
    echo 0x0017601C > $DCC_PATH/config
    echo 0x00176020 > $DCC_PATH/config
    echo 0x00176024 > $DCC_PATH/config
    echo 0x00176028 > $DCC_PATH/config
    echo 0x0017602C > $DCC_PATH/config
    echo 0x00176030 > $DCC_PATH/config
    echo 0x00176034 > $DCC_PATH/config
    echo 0x0010401C > $DCC_PATH/config
    echo 0x00183024 > $DCC_PATH/config
    echo 0x00144168 > $DCC_PATH/config
    echo 0x0011702C > $DCC_PATH/config
    echo 0x0010904C > $DCC_PATH/config
    echo 0x00189038 > $DCC_PATH/config
    echo 0x001443E8 > $DCC_PATH/config
    echo 0x001442B8 > $DCC_PATH/config
    echo 0x00105060 > $DCC_PATH/config
    echo 0x00141024 > $DCC_PATH/config
    echo 0x00145038 > $DCC_PATH/config
    echo 0x00109004 > $DCC_PATH/config
    echo 0x00189004 > $DCC_PATH/config
    echo 0x00190004 > $DCC_PATH/config
    #AOSS_CC
    echo 0x0C2A0000 > $DCC_PATH/config
    echo 0x0C2A0004 > $DCC_PATH/config
    echo 0x0C2A0008 > $DCC_PATH/config
    echo 0x0C2A000C > $DCC_PATH/config
    echo 0x0C2A0010 > $DCC_PATH/config
    echo 0x0C2A0014 > $DCC_PATH/config
    echo 0x0C2A0018 > $DCC_PATH/config
    echo 0x0C2A001C > $DCC_PATH/config
    echo 0x0C2A0020 > $DCC_PATH/config
    echo 0x0C2A0024 > $DCC_PATH/config
    echo 0x0C2A0028 > $DCC_PATH/config
    echo 0x0C2A002C > $DCC_PATH/config
    echo 0x0C2A0030 > $DCC_PATH/config
    echo 0x0C2A0034 > $DCC_PATH/config
    echo 0x0C2A1000 > $DCC_PATH/config
    echo 0x0C2A1004 > $DCC_PATH/config
    echo 0x0C2A1008 > $DCC_PATH/config
    echo 0x0C2A100C > $DCC_PATH/config
    echo 0x0C2A1010 > $DCC_PATH/config
    echo 0x0C2A1014 > $DCC_PATH/config
    echo 0x0C2A1018 > $DCC_PATH/config
    echo 0x0C2A101C > $DCC_PATH/config
    echo 0x0C2A1020 > $DCC_PATH/config
    echo 0x0C2A1024 > $DCC_PATH/config
    echo 0x0C2A1028 > $DCC_PATH/config
    echo 0x0C2A102C > $DCC_PATH/config
    echo 0x0C2A1030 > $DCC_PATH/config
    echo 0x0C2A2260 > $DCC_PATH/config
    echo 0x0C2A2264 > $DCC_PATH/config
    echo 0x0C2A3008 > $DCC_PATH/config
    echo 0x0C2A300C > $DCC_PATH/config
    echo 0x0C2A3010 > $DCC_PATH/config
    echo 0x0C2A3014 > $DCC_PATH/config
    echo 0x0C2A3024 > $DCC_PATH/config
    echo 0x0C2A2034 > $DCC_PATH/config
    echo 0x0C2A214C > $DCC_PATH/config
    echo 0x0C2A2150 > $DCC_PATH/config
    echo 0x0C2A2154 > $DCC_PATH/config
}

config_talos_dcc_apps_regs()
{
    #GOLD

}
config_talos_dcc_tsens_regs()
{
    echo 0x0C2630A0 4 > $DCC_PATH/config
    echo 0x0C2630B0 4 > $DCC_PATH/config
    echo 0x0C2630C0 4 > $DCC_PATH/config
    echo 0x0C2630D0 4 > $DCC_PATH/config
}
config_talos_dcc_core_hang()
{
    echo 0x1800005C 1 > $DCC_PATH/config
    echo 0x1801005C 1 > $DCC_PATH/config
    echo 0x1802005C 1 > $DCC_PATH/config
    echo 0x1803005C 1 > $DCC_PATH/config
    echo 0x1804005C 1 > $DCC_PATH/config
    echo 0x1805005C 1 > $DCC_PATH/config
    echo 0x1806005C 1 > $DCC_PATH/config
    echo 0x1807005C 1 > $DCC_PATH/config
}

config_talos_dcc_bcm_seq_hang()
{
    echo 0x00109468 1 > $DCC_PATH/config
}

config_talos_dcc_pll()
{
    echo 0x18282004 1 > $DCC_PATH/config
    echo 0x18325F6C 1 > $DCC_PATH/config
    echo 0x1808012C 1 > $DCC_PATH/config
    echo 0x1832582C 1 > $DCC_PATH/config
    echo 0x18280004 1 > $DCC_PATH/config
    echo 0x18284038 1 > $DCC_PATH/config
    echo 0x18284000 2 > $DCC_PATH/config
}

enable_moorea_specific_register()
{
    #LLCC1_LLCC_FEWC_FIFO_STATUS
    echo 0x92B2100 > $DCC_PATH/config

    #ADSP registers
    echo 0x62B90210 > $DCC_PATH/config
    echo 0x62B90230 > $DCC_PATH/config
    echo 0x62B90250 > $DCC_PATH/config
    echo 0x62B90270 > $DCC_PATH/config
    echo 0x62B90290 > $DCC_PATH/config
    echo 0x62B902B0 > $DCC_PATH/config
    echo 0x62B90208 > $DCC_PATH/config
    echo 0x62B90228 > $DCC_PATH/config
    echo 0x62B90248 > $DCC_PATH/config
    echo 0x62B90268 > $DCC_PATH/config
    echo 0x62B90288 > $DCC_PATH/config
    echo 0x62B902A8 > $DCC_PATH/config
    echo 0x62B9020C > $DCC_PATH/config
    echo 0x62B9022C > $DCC_PATH/config
    echo 0x62B9024C > $DCC_PATH/config
    echo 0x62B9026C > $DCC_PATH/config
    echo 0x62B9028C > $DCC_PATH/config
    echo 0x62B902AC > $DCC_PATH/config
    echo 0x62B90404 > $DCC_PATH/config
    echo 0x62B90408 > $DCC_PATH/config
    echo 0x62B90400 > $DCC_PATH/config
    echo 0x62402028 > $DCC_PATH/config
    echo 0x624B0210 > $DCC_PATH/config
    echo 0x624B0230 > $DCC_PATH/config
    echo 0x624B0250 > $DCC_PATH/config
    echo 0x624B0270 > $DCC_PATH/config
    echo 0x624B0290 > $DCC_PATH/config
    echo 0x624B02B0 > $DCC_PATH/config
    echo 0x624B0208 > $DCC_PATH/config
    echo 0x624B0228 > $DCC_PATH/config
    echo 0x624B0248 > $DCC_PATH/config
    echo 0x624B0268 > $DCC_PATH/config
    echo 0x624B0288 > $DCC_PATH/config
    echo 0x624B02A8 > $DCC_PATH/config
    echo 0x624B020C > $DCC_PATH/config
    echo 0x624B022C > $DCC_PATH/config
    echo 0x624B024C > $DCC_PATH/config
    echo 0x624B026C > $DCC_PATH/config
    echo 0x624B028C > $DCC_PATH/config
    echo 0x624B02AC > $DCC_PATH/config
    echo 0x624B0400 > $DCC_PATH/config
    echo 0x624B0404 > $DCC_PATH/config
    echo 0x624B0408 > $DCC_PATH/config
}

# Function talos DCC configuration
enable_talos_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/10a2000.dcc_v2"
    soc_version=`cat /sys/devices/soc0/revision`
    soc_version=${soc_version/./}

    if [ ! -d $DCC_PATH ]; then
        echo "DCC does not exist on this build."
        return
    fi

    echo 0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo 1 > $DCC_PATH/config_reset
    echo 3 > $DCC_PATH/curr_list

    config_talos_dcc_gladiator
    config_talos_dcc_noc_err_regs
    config_talos_dcc_shrm
    config_talos_dcc_cprh
    config_talos_dcc_rscc_apps
    config_talos_dcc_pdc_apps
    #config_talos_dcc_rscc_lpass
    #config_talos_dcc_rscc_modem
    #config_talos_dcc_rscc_cdsp
    #config_talos_dcc_axi_pc
    #config_talos_dcc_apb_pc
    config_talos_dcc_memnoc_mccc
    config_talos_dcc_gpu
    #config_talos_dcc_pdc_display
    #config_talos_dcc_aop_rpmh
    #config_talos_dcc_lmh
    #config_talos_dcc_ipm_apps
    config_talos_dcc_osm
    #config_talos_dcc_ddr_phy
    #config_talos_dcc_ecc_llc
    config_talos_dcc_cabo_llcc_shrm
    config_talos_dcc_cx_mx
    config_talos_dcc_gcc_regs
    #config_talos_dcc_apps_regs
    config_talos_dcc_tsens_regs
    config_talos_dcc_core_hang
    config_talos_dcc_bcm_seq_hang
    config_talos_dcc_pll
    #Enable below function with relaxed AC
    #config_talos_regs_no_ac
    #Apply configuration and enable DCC
    if [ -f /sys/devices/soc0/soc_id ]
    then
        soc_id=`cat /sys/devices/soc0/soc_id`
    else
        soc_id=`cat /sys/devices/system/soc/soc0/soc_id`
    fi
    if [ "$soc_id" = 365 ] || [ "$soc_id" = 366 ]
    then
        enable_moorea_specific_register
    fi
    echo  1 > $DCC_PATH/enable
}

enable_talos_stm_hw_events()
{
   #TODO: Add HW events
}

enable_talos_debug()
{
    echo "talos debug"
    srcenable="enable_source"
    sinkenable="enable_sink"
    if [ -f /sys/devices/soc0/soc_id ]
    then
        soc_id=`cat /sys/devices/soc0/soc_id`
    else
        soc_id=`cat /sys/devices/system/soc/soc0/soc_id`
    fi
    # Check for Moorea/ talos stm trace
    if [ "$soc_id" = 365 ] || [ "$soc_id" = 366 ]
    then
        echo "Enabling STM events on Moorea."
        enable_moorea_stm_events
    else
        echo "Enabling STM events on talos."
        enable_talos_stm_events
    fi

    if [ "$ftrace_disable" != "Yes" ]; then
        enable_talos_ftrace_event_tracing
    fi
    enable_talos_dcc_config
    enable_talos_stm_hw_events
}
