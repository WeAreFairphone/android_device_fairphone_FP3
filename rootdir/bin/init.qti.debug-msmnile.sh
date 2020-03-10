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

enable_tracing_events_msmnile()
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

    echo 1 > /sys/kernel/debug/tracing/tracing_on
}

# function to enable ftrace events
enable_ftrace_event_tracing_msmnile()
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

    enable_tracing_events_msmnile
}

# function to enable ftrace event transfer to CoreSight STM
enable_stm_events_msmnile()
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
    enable_tracing_events_msmnile
}

# Function msmnile DCC configuration
enable_msmnile_dcc_config()
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


    #TCS
    echo 0x18220D14 3 > $DCC_PATH/config
    echo 0x18220D30 4 > $DCC_PATH/config
    echo 0x18220D44 4 > $DCC_PATH/config
    echo 0x18220D58 4 > $DCC_PATH/config
    echo 0x18220FB4 3 > $DCC_PATH/config
    echo 0x18220FD0 4 > $DCC_PATH/config
    echo 0x18220FE4 4 > $DCC_PATH/config
    echo 0x18220FF8 4 > $DCC_PATH/config
    echo 0x18220D04 1 > $DCC_PATH/config
    echo 0x18220D00 1 > $DCC_PATH/config

    #RSC_PDC_PCU
    echo 0x18000024 1 > $DCC_PATH/config
    echo 0x18000040 3 > $DCC_PATH/config
    echo 0x18010024 1 > $DCC_PATH/config
    echo 0x18010040 3 > $DCC_PATH/config
    echo 0x18020024 1 > $DCC_PATH/config
    echo 0x18020040 3 > $DCC_PATH/config
    echo 0x18030024 1 > $DCC_PATH/config
    echo 0x18030040 3 > $DCC_PATH/config
    echo 0x18040024 1 > $DCC_PATH/config
    echo 0x18040040 3 > $DCC_PATH/config
    echo 0x18050024 1 > $DCC_PATH/config
    echo 0x18050040 3 > $DCC_PATH/config
    echo 0x18060024 1 > $DCC_PATH/config
    echo 0x18060040 3 > $DCC_PATH/config
    echo 0x18070024 1 > $DCC_PATH/config
    echo 0x18070040 3 > $DCC_PATH/config
    echo 0x18080104 1 > $DCC_PATH/config
    echo 0x18080168 1 > $DCC_PATH/config
    echo 0x18080198 1 > $DCC_PATH/config
    echo 0x18080128 1 > $DCC_PATH/config
    echo 0x18080024 1 > $DCC_PATH/config
    echo 0x18080040 3 > $DCC_PATH/config
    echo 0x18200400 3 > $DCC_PATH/config
    echo 0x0B201020 2 > $DCC_PATH/config

    #CPRh
    echo 0x18101908 1 > $DCC_PATH/config
    echo 0x18101C18 1 > $DCC_PATH/config
    echo 0x18390810 1 > $DCC_PATH/config
    echo 0x18390C50 1 > $DCC_PATH/config
    echo 0x18390814 1 > $DCC_PATH/config
    echo 0x18390C54 1 > $DCC_PATH/config
    echo 0x18390818 1 > $DCC_PATH/config
    echo 0x18390C58 1 > $DCC_PATH/config
    echo 0x18393A84 2 > $DCC_PATH/config
    echo 0x18100908 1 > $DCC_PATH/config
    echo 0x18100C18 1 > $DCC_PATH/config
    echo 0x183A0810 1 > $DCC_PATH/config
    echo 0x183A0C50 1 > $DCC_PATH/config
    echo 0x183A0814 1 > $DCC_PATH/config
    echo 0x183A0C54 1 > $DCC_PATH/config
    echo 0x183A0818 1 > $DCC_PATH/config
    echo 0x183A0C58 1 > $DCC_PATH/config
    echo 0x183A3A84 2 > $DCC_PATH/config
    echo 0x18393500 1 > $DCC_PATH/config
    echo 0x18393580 1 > $DCC_PATH/config
    echo 0x183A3500 1 > $DCC_PATH/config
    echo 0x183A3580 1 > $DCC_PATH/config

    #APSS_OSM
    echo 0x18321700 13 > $DCC_PATH/config
    echo 0x18321744    > $DCC_PATH/config
    echo 0x18321780    > $DCC_PATH/config
    echo 0x18321804 16 > $DCC_PATH/config
    echo 0x18321920    > $DCC_PATH/config
    echo 0x18322c14 2  > $DCC_PATH/config
    echo 0x18322d70    > $DCC_PATH/config
    echo 0x18322d88    > $DCC_PATH/config
    echo 0x18323700 13 > $DCC_PATH/config
    echo 0x18323744    > $DCC_PATH/config
    echo 0x18323780    > $DCC_PATH/config
    echo 0x18323804 16 > $DCC_PATH/config
    echo 0x18323920    > $DCC_PATH/config
    echo 0x18324c14 2  > $DCC_PATH/config
    echo 0x18324d70    > $DCC_PATH/config
    echo 0x18324d88    > $DCC_PATH/config
    echo 0x18325f00 13 > $DCC_PATH/config
    echo 0x18325f44    > $DCC_PATH/config
    echo 0x18325f80    > $DCC_PATH/config
    echo 0x18326004 16 > $DCC_PATH/config
    echo 0x18326120    > $DCC_PATH/config
    echo 0x18327414 2  > $DCC_PATH/config
    echo 0x18327570    > $DCC_PATH/config
    echo 0x18327588    > $DCC_PATH/config
    echo 0x18327f00 13 > $DCC_PATH/config
    echo 0x18327f44    > $DCC_PATH/config
    echo 0x18327f80    > $DCC_PATH/config
    echo 0x18328004 16 > $DCC_PATH/config
    echo 0x18328120    > $DCC_PATH/config
    echo 0x18329414 2  > $DCC_PATH/config
    echo 0x18329570    > $DCC_PATH/config
    echo 0x18329588    > $DCC_PATH/config

    #Gladiator
    echo 0x09680008    > $DCC_PATH/config
    echo 0x09680078 6   > $DCC_PATH/config
    echo 8 > $DCC_PATH/loop
    echo 0x09681000    > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    echo 0x09681014 9  > $DCC_PATH/config
    echo 0x0968103C   > $DCC_PATH/config

    echo 0x09688008   > $DCC_PATH/config
    echo 0x09688078 6  > $DCC_PATH/config
    echo 8 > $DCC_PATH/loop
    echo 0x09689000   > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    echo 0x09689014 9  > $DCC_PATH/config
    echo 0x0968903C  > $DCC_PATH/config

    echo 0x09698110   > $DCC_PATH/config
    echo 0x09698120 8  > $DCC_PATH/config
    echo 0x096AA090   > $DCC_PATH/config
    echo 0x096AA100   > $DCC_PATH/config
    echo 0x096B8090   > $DCC_PATH/config
    echo 0x096B8100   > $DCC_PATH/config
    echo 0x096BD090   > $DCC_PATH/config
    echo 0x096BD100   > $DCC_PATH/config

    echo 0x18282000 4 > $DCC_PATH/config
    echo 0x18282028 1 > $DCC_PATH/config
    echo 0x18282038 1 > $DCC_PATH/config
    echo 0x18282080 5 > $DCC_PATH/config
    echo 0x18286000 4 > $DCC_PATH/config
    echo 0x18286028 1 > $DCC_PATH/config
    echo 0x18286038 1 > $DCC_PATH/config
    echo 0x18286080 5 > $DCC_PATH/config

    echo 0x0C201244 1 > $DCC_PATH/config
    echo 0x0C202244 1 > $DCC_PATH/config
    echo 0x18300000 1 > $DCC_PATH/config
    #SNOC
    echo 0x1620500 4 > $DCC_PATH/config
    echo 0x1620700 4 > $DCC_PATH/config
    echo 0x1620900 1 > $DCC_PATH/config
    echo 0x1620D00 2 > $DCC_PATH/config
    echo 0x1620F00 1 > $DCC_PATH/config
    echo 0x1638100 1 > $DCC_PATH/config

    #GOLD
    echo 0x1829208C 1 > $DCC_PATH/config
    echo 0x1829209C 0x78 > $DCC_PATH/config_write
    echo 0x1829209C 0x0  > $DCC_PATH/config_write
    echo 0x18292048 0x1  > $DCC_PATH/config_write
    echo 0x18292090 0x0  > $DCC_PATH/config_write
    echo 0x18292090 0x25 > $DCC_PATH/config_write
    echo 0x18292098 1 > $DCC_PATH/config
    echo 0x18292048 0x1D > $DCC_PATH/config_write
    echo 0x18292090 0x0  > $DCC_PATH/config_write
    echo 0x18292090 0x25 > $DCC_PATH/config_write
    echo 0x18292098 1 > $DCC_PATH/config

    #GOLD+
    echo 0x1829608C 1 > $DCC_PATH/config
    echo 0x1829609C 0x78 > $DCC_PATH/config_write
    echo 0x1829609C 0x0  > $DCC_PATH/config_write
    echo 0x18296048 0x1  > $DCC_PATH/config_write
    echo 0x18296090 0x0  > $DCC_PATH/config_write
    echo 0x18296090 0x25 > $DCC_PATH/config_write
    echo 0x18296098 1 > $DCC_PATH/config
    echo 0x18296048 0x1D > $DCC_PATH/config_write
    echo 0x18296090 0x0  > $DCC_PATH/config_write
    echo 0x18296090 0x25 > $DCC_PATH/config_write
    echo 0x18296098 1 > $DCC_PATH/config

    # core hang
    echo 0x1800005C 1 > $DCC_PATH/config
    echo 0x1801005C 1 > $DCC_PATH/config
    echo 0x1802005C 1 > $DCC_PATH/config
    echo 0x1803005C 1 > $DCC_PATH/config
    echo 0x1804005C 1 > $DCC_PATH/config
    echo 0x1805005C 1 > $DCC_PATH/config
    echo 0x1806005C 1 > $DCC_PATH/config
    echo 0x1807005C 1 > $DCC_PATH/config

    #DDRSS
    #GEMNOC
    echo 0x09698500 8 > $DCC_PATH/config
    echo 0x09698700 8 > $DCC_PATH/config

    #SHRM CSR
    echo 0x09050008 1 > $DCC_PATH/config
    echo 0x09050078 1 > $DCC_PATH/config
    echo 0x09051000 1 > $DCC_PATH/config
    #MCCC
    echo 0x090B0280 1 > $DCC_PATH/config
    echo 0x090B0288 7 > $DCC_PATH/config

    #LLCC/CABO
    echo 0x09601000 2 > $DCC_PATH/config
    echo 0x09232100 1 > $DCC_PATH/config
    echo 0x092360B0 1 > $DCC_PATH/config
    echo 0x09236044 4 > $DCC_PATH/config
    echo 0x0923E030 2 > $DCC_PATH/config
    echo 0x09241000 1 > $DCC_PATH/config
    echo 0x09242028 1 > $DCC_PATH/config
    echo 0x09248058 4 > $DCC_PATH/config
    echo 0x09260410 3 > $DCC_PATH/config
    echo 0x09260420 2 > $DCC_PATH/config
    echo 0x09260430 1 > $DCC_PATH/config
    echo 0x09260440 1 > $DCC_PATH/config
    echo 0x09260448 1 > $DCC_PATH/config
    echo 0x092604A0 1 > $DCC_PATH/config
    echo 0x092B2100 1 > $DCC_PATH/config
    echo 0x092B60B0 1 > $DCC_PATH/config
    echo 0x092B6044 4 > $DCC_PATH/config
    echo 0x092BE030 2 > $DCC_PATH/config
    echo 0x092C1000 1 > $DCC_PATH/config
    echo 0x092C2028 1 > $DCC_PATH/config
    echo 0x092C8058 4 > $DCC_PATH/config
    echo 0x092E0410 3 > $DCC_PATH/config
    echo 0x092E0420 2 > $DCC_PATH/config
    echo 0x092E0430 1 > $DCC_PATH/config
    echo 0x092E0440 1 > $DCC_PATH/config
    echo 0x092E0448 1 > $DCC_PATH/config
    echo 0x092E04A0 1 > $DCC_PATH/config
    echo 0x09332100 1 > $DCC_PATH/config
    echo 0x093360B0 1 > $DCC_PATH/config
    echo 0x09336044 4 > $DCC_PATH/config
    echo 0x0933E030 2 > $DCC_PATH/config
    echo 0x09341000 1 > $DCC_PATH/config
    echo 0x09342028 1 > $DCC_PATH/config
    echo 0x09348058 4 > $DCC_PATH/config
    echo 0x09360410 3 > $DCC_PATH/config
    echo 0x09360420 2 > $DCC_PATH/config
    echo 0x09360430 1 > $DCC_PATH/config
    echo 0x09360440 2 > $DCC_PATH/config
    echo 0x09360448 1 > $DCC_PATH/config
    echo 0x093604A0 1 > $DCC_PATH/config
    echo 0x093B2100 1 > $DCC_PATH/config
    echo 0x093B60B0 1 > $DCC_PATH/config
    echo 0x093B6044 4 > $DCC_PATH/config
    echo 0x093BE030 2 > $DCC_PATH/config
    echo 0x093C1000 1 > $DCC_PATH/config
    echo 0x093C2028 1 > $DCC_PATH/config
    echo 0x093C8058 4 > $DCC_PATH/config
    echo 0x093E0410 3 > $DCC_PATH/config
    echo 0x093E0420 2 > $DCC_PATH/config
    echo 0x093E0430 1 > $DCC_PATH/config
    echo 0x093E0440 1 > $DCC_PATH/config
    echo 0x093E0448 1 > $DCC_PATH/config
    echo 0x093E04A0 1 > $DCC_PATH/config
    echo 0x09601000 1 > $DCC_PATH/config
    echo 0x09601004 1 > $DCC_PATH/config
    echo 0x09602000 1 > $DCC_PATH/config
    echo 0x09602004 1 > $DCC_PATH/config
    echo 0x09603000 1 > $DCC_PATH/config
    echo 0x09603004 1 > $DCC_PATH/config
    echo 0x09604000 1 > $DCC_PATH/config
    echo 0x09604004 1 > $DCC_PATH/config
    echo 0x09605000 1 > $DCC_PATH/config
    echo 0x09605004 1 > $DCC_PATH/config
    echo 0x09606000 1 > $DCC_PATH/config
    echo 0x09606004 1 > $DCC_PATH/config
    echo 0x09607000 1 > $DCC_PATH/config
    echo 0x09607004 1 > $DCC_PATH/config
    echo 0x09608000 1 > $DCC_PATH/config
    echo 0x09608004 1 > $DCC_PATH/config
    echo 0x09609000 1 > $DCC_PATH/config
    echo 0x09609004 1 > $DCC_PATH/config
    echo 0x0960a000 1 > $DCC_PATH/config
    echo 0x0960a004 1 > $DCC_PATH/config
    echo 0x0960b000 1 > $DCC_PATH/config
    echo 0x0960b004 1 > $DCC_PATH/config
    echo 0x0960c000 1 > $DCC_PATH/config
    echo 0x0960c004 1 > $DCC_PATH/config
    echo 0x0960d000 1 > $DCC_PATH/config
    echo 0x0960d004 1 > $DCC_PATH/config
    echo 0x0960e000 1 > $DCC_PATH/config
    echo 0x0960e004 1 > $DCC_PATH/config
    echo 0x0960f000 1 > $DCC_PATH/config
    echo 0x0960f004 1 > $DCC_PATH/config
    echo 0x09610000 1 > $DCC_PATH/config
    echo 0x09610004 1 > $DCC_PATH/config
    echo 0x09611000 1 > $DCC_PATH/config
    echo 0x09611004 1 > $DCC_PATH/config
    echo 0x09612000 1 > $DCC_PATH/config
    echo 0x09612004 1 > $DCC_PATH/config
    echo 0x09613000 1 > $DCC_PATH/config
    echo 0x09613004 1 > $DCC_PATH/config
    echo 0x09614000 1 > $DCC_PATH/config
    echo 0x09614004 1 > $DCC_PATH/config
    echo 0x09615000 1 > $DCC_PATH/config
    echo 0x09615004 1 > $DCC_PATH/config
    echo 0x09616000 1 > $DCC_PATH/config
    echo 0x09616004 1 > $DCC_PATH/config
    echo 0x09617000 1 > $DCC_PATH/config
    echo 0x09617004 1 > $DCC_PATH/config
    echo 0x09618000 1 > $DCC_PATH/config
    echo 0x09618004 1 > $DCC_PATH/config
    echo 0x09619000 1 > $DCC_PATH/config
    echo 0x09619004 1 > $DCC_PATH/config
    echo 0x0961a000 1 > $DCC_PATH/config
    echo 0x0961a004 1 > $DCC_PATH/config
    echo 0x0961b000 1 > $DCC_PATH/config
    echo 0x0961b004 1 > $DCC_PATH/config
    echo 0x0961c000 1 > $DCC_PATH/config
    echo 0x0961c004 1 > $DCC_PATH/config
    echo 0x0961d000 1 > $DCC_PATH/config
    echo 0x0961d004 1 > $DCC_PATH/config
    echo 0x0961e000 1 > $DCC_PATH/config
    echo 0x0961e004 1 > $DCC_PATH/config
    echo 0x0961f000 1 > $DCC_PATH/config
    echo 0x0961f004 1 > $DCC_PATH/config
    echo 0x09266418 1 > $DCC_PATH/config
    echo 0x092e6418 1 > $DCC_PATH/config
    echo 0x09366418 1 > $DCC_PATH/config
    echo 0x093e6418 1 > $DCC_PATH/config
    echo 0x09265804 1 > $DCC_PATH/config
    echo 0x092e5804 1 > $DCC_PATH/config
    echo 0x09365804 1 > $DCC_PATH/config
    echo 0x093e5804 1 > $DCC_PATH/config
    echo 0x092604b8 1 > $DCC_PATH/config
    echo 0x092e04b8 1 > $DCC_PATH/config
    echo 0x093604b8 1 > $DCC_PATH/config
    echo 0x093e04b8 1 > $DCC_PATH/config

    #PHY
    echo 0x090C80F8 0x00000001 1 > $DCC_PATH/config_write
    echo 0x091800C8 1 > $DCC_PATH/config
    echo 0x09180740 1 > $DCC_PATH/config
    echo 0x09183740 1 > $DCC_PATH/config
    echo 0x091900C8 1 > $DCC_PATH/config
    echo 0x09190740 1 > $DCC_PATH/config
    echo 0x09193740 1 > $DCC_PATH/config
    echo 0x09181254 2 > $DCC_PATH/config
    echo 0x09181624 1 > $DCC_PATH/config
    echo 0x09181740 1 > $DCC_PATH/config
    echo 0x09181768 1 > $DCC_PATH/config
    echo 0x0918182C 1 > $DCC_PATH/config
    echo 0x09182254 2 > $DCC_PATH/config
    echo 0x09182624 1 > $DCC_PATH/config
    echo 0x09182740 1 > $DCC_PATH/config
    echo 0x09182768 1 > $DCC_PATH/config
    echo 0x0918282C 1 > $DCC_PATH/config
    echo 0x09184254 2 > $DCC_PATH/config
    echo 0x09184624 1 > $DCC_PATH/config
    echo 0x09184740 1 > $DCC_PATH/config
    echo 0x09184768 1 > $DCC_PATH/config
    echo 0x0918482C 1 > $DCC_PATH/config
    echo 0x09185254 2 > $DCC_PATH/config
    echo 0x09185624 1 > $DCC_PATH/config
    echo 0x09185740 1 > $DCC_PATH/config
    echo 0x09185768 1 > $DCC_PATH/config
    echo 0x0918582C 1 > $DCC_PATH/config
    echo 0x09191254 2 > $DCC_PATH/config
    echo 0x09191624 1 > $DCC_PATH/config
    echo 0x09191740 1 > $DCC_PATH/config
    echo 0x09191768 1 > $DCC_PATH/config
    echo 0x0919182C 1 > $DCC_PATH/config
    echo 0x09192254 2 > $DCC_PATH/config
    echo 0x09192624 1 > $DCC_PATH/config
    echo 0x09192740 1 > $DCC_PATH/config
    echo 0x09192768 1 > $DCC_PATH/config
    echo 0x0919282C 1 > $DCC_PATH/config
    echo 0x09194254 2 > $DCC_PATH/config
    echo 0x09194624 1 > $DCC_PATH/config
    echo 0x09194740 1 > $DCC_PATH/config
    echo 0x09194768 1 > $DCC_PATH/config
    echo 0x0919482C 1 > $DCC_PATH/config
    echo 0x09195254 2 > $DCC_PATH/config
    echo 0x09195624 1 > $DCC_PATH/config
    echo 0x09195740 1 > $DCC_PATH/config
    echo 0x09195768 1 > $DCC_PATH/config
    echo 0x0919582C 1 > $DCC_PATH/config
    echo 0x09186048 1 > $DCC_PATH/config
    echo 0x09186054 1 > $DCC_PATH/config
    echo 0x09186164 1 > $DCC_PATH/config
    echo 0x09186170 1 > $DCC_PATH/config
    echo 0x09186410 1 > $DCC_PATH/config
    echo 0x09186618 4 > $DCC_PATH/config
    echo 0x091866E0 1 > $DCC_PATH/config
    echo 0x09186700 2 > $DCC_PATH/config
    echo 0x09196048 1 > $DCC_PATH/config
    echo 0x09196054 1 > $DCC_PATH/config
    echo 0x09196164 1 > $DCC_PATH/config
    echo 0x09196170 1 > $DCC_PATH/config
    echo 0x09196410 1 > $DCC_PATH/config
    echo 0x09196618 4 > $DCC_PATH/config
    echo 0x091966E0 1 > $DCC_PATH/config
    echo 0x09196700 2 > $DCC_PATH/config

#AGG_NOC
    echo 0x016e0300 3 > $DCC_PATH/config
    echo 0x01700300 2 > $DCC_PATH/config
    echo 0x01700500 3 > $DCC_PATH/config
    echo 0x01700700 1 > $DCC_PATH/config
    echo 0x01700900 5 > $DCC_PATH/config
    echo 0x01700b00 2 > $DCC_PATH/config
    echo 0x01700d00 1 > $DCC_PATH/config

#APM
    echo 0x0C267000 9 > $DCC_PATH/config
    echo 0x0C26705C 2 > $DCC_PATH/config
    echo 0x0C267024 3 > $DCC_PATH/config
    echo 0x0C267054 2 > $DCC_PATH/config
    echo 0x0C267030 1 > $DCC_PATH/config
    echo 0x0C267040 5 > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

enable_msmnile_stm_hw_events()
{
   #TODO: Add HW events
}

enable_msmnile_core_hang_config()
{
    CORE_PATH_SILVER="/sys/devices/system/cpu/hang_detect_silver"
    CORE_PATH_GOLD="/sys/devices/system/cpu/hang_detect_gold"
    if [ ! -d $CORE_PATH ]; then
        echo "CORE hang does not exist on this build."
        return
    fi

    #set the threshold to max
    echo 0xffffffff > $CORE_PATH_SILVER/threshold
    echo 0xffffffff > $CORE_PATH_GOLD/threshold

    #To the enable core hang detection
    echo 0x1 > $CORE_PATH_SILVER/enable
    echo 0x1 > $CORE_PATH_GOLD/enable
}

ftrace_disable=`getprop persist.debug.ftrace_events_disable`
srcenable="enable"
sinkenable="curr_sink"
enable_msmnile_debug()
{
    echo "msmnile debug"
    srcenable="enable_source"
    sinkenable="enable_sink"
    echo "Enabling STM events on msmnile."
    enable_stm_events_msmnile
    if [ "$ftrace_disable" != "Yes" ]; then
        enable_ftrace_event_tracing_msmnile
    fi
    enable_msmnile_dcc_config
    enable_msmnile_stm_hw_events
}
