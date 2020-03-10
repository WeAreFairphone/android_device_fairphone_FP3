#!/vendor/bin/sh

#Copyright (c) 2017, The Linux Foundation. All rights reserved.
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

# Function Enable stm events

enable_sdm710_tracing_events()
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
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup_new/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable
    # sound
    echo 1 > /sys/kernel/debug/tracing/events/asoc/snd_soc_reg_read/enable
    echo 1 > /sys/kernel/debug/tracing/events/asoc/snd_soc_reg_write/enable
    # mdp
    echo 1 > /sys/kernel/debug/tracing/events/mdss/mdp_video_underrun_done/enable
    # video
    echo 1 > /sys/kernel/debug/tracing/events/msm_vidc/enable
    # clock
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_set_rate/enable
    # regulator
    echo 1 > /sys/kernel/debug/tracing/events/regulator/enable
    #cpufreq
    echo 1 > /sys/kernel/debug/tracing/events/cpufreq_interactive/enable
    # power
    echo 1 > /sys/kernel/debug/tracing/events/msm_low_power/enable
    # Disable cluster entry/exit LPM events
    echo 0 > /sys/kernel/debug/tracing/events/msm_low_power/cluster_enter/enable
    echo 0 > /sys/kernel/debug/tracing/events/msm_low_power/cluster_exit/enable
    #thermal
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_core_offline/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_core_offline/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_core_online/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_core_online/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_frequency_mit/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_frequency_mit/enable
    #rmph_send_msg
    echo 1 > /sys/kernel/debug/tracing/events/rpmh/rpmh_send_msg/enable
    #enable aop with timestamps
    echo 33 0x680000 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_msr
    echo 48 0xC0 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_msr
    echo 0x4 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/mcmb_lanes_select
    echo 1 0 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_mode
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_trig_ts
    echo 1 >  /sys/bus/coresight/devices/coresight-tpdm-swao-0/enable_source
    echo 4 2 > /sys/bus/coresight/devices/coresight-cti-swao_cti0/map_trigin
    echo 4 2 > /sys/bus/coresight/devices/coresight-cti-swao_cti0/map_trigout

    echo 1 > /sys/kernel/debug/tracing/tracing_on
}

# function to enable ftrace events
enable_sdm710_ftrace()
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

    echo 0x2000000 > /sys/kernel/debug/tracing/buffer_size_kb
    enable_sdm710_tracing_events
}

# function to enable ftrace event transfer to CoreSight STM
enable_sdm710_stm()
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

    echo 0x2000000 > /sys/bus/coresight/devices/coresight-tmc-etr/mem_size
    echo mem > /sys/bus/coresight/devices/coresight-tmc-etr/out_mode
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/enable_sink
    echo 1 > /sys/bus/coresight/devices/coresight-stm/enable_source
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
    enable_sdm710_tracing_events
}

config_sdm710_dcc_gcc_regs()
{
    echo 0x100000   1 > $DCC_PATH/config
    echo 0x100004   1 > $DCC_PATH/config
    echo 0x100008   1 > $DCC_PATH/config
    echo 0x10000C   1 > $DCC_PATH/config
    echo 0x100010   1 > $DCC_PATH/config
    echo 0x100014   1 > $DCC_PATH/config
    echo 0x100018   1 > $DCC_PATH/config
    echo 0x10001C   1 > $DCC_PATH/config
    echo 0x100020   1 > $DCC_PATH/config
    echo 0x100024   1 > $DCC_PATH/config
    echo 0x100038   1 > $DCC_PATH/config
    echo 0x101000   1 > $DCC_PATH/config
    echo 0x101004   1 > $DCC_PATH/config
    echo 0x101008   1 > $DCC_PATH/config
    echo 0x10100C   1 > $DCC_PATH/config
    echo 0x101010   1 > $DCC_PATH/config
    echo 0x101014   1 > $DCC_PATH/config
    echo 0x101018   1 > $DCC_PATH/config
    echo 0x10101C   1 > $DCC_PATH/config
    echo 0x101020   1 > $DCC_PATH/config
    echo 0x101024   1 > $DCC_PATH/config
    echo 0x101038   1 > $DCC_PATH/config
    echo 0x102000   1 > $DCC_PATH/config
    echo 0x102004   1 > $DCC_PATH/config
    echo 0x102008   1 > $DCC_PATH/config
    echo 0x10200C   1 > $DCC_PATH/config
    echo 0x102010   1 > $DCC_PATH/config
    echo 0x102014   1 > $DCC_PATH/config
    echo 0x102018   1 > $DCC_PATH/config
    echo 0x10201C   1 > $DCC_PATH/config
    echo 0x102020   1 > $DCC_PATH/config
    echo 0x102024   1 > $DCC_PATH/config
    echo 0x102038   1 > $DCC_PATH/config
    echo 0x103000   1 > $DCC_PATH/config
    echo 0x103004   1 > $DCC_PATH/config
    echo 0x103008   1 > $DCC_PATH/config
    echo 0x10300C   1 > $DCC_PATH/config
    echo 0x103010   1 > $DCC_PATH/config
    echo 0x103014   1 > $DCC_PATH/config
    echo 0x103018   1 > $DCC_PATH/config
    echo 0x10301C   1 > $DCC_PATH/config
    echo 0x103020   1 > $DCC_PATH/config
    echo 0x103024   1 > $DCC_PATH/config
    echo 0x103038   1 > $DCC_PATH/config
    echo 0x176000   1 > $DCC_PATH/config
    echo 0x176004   1 > $DCC_PATH/config
    echo 0x176008   1 > $DCC_PATH/config
    echo 0x17600C   1 > $DCC_PATH/config
    echo 0x176010   1 > $DCC_PATH/config
    echo 0x176014   1 > $DCC_PATH/config
    echo 0x176018   1 > $DCC_PATH/config
    echo 0x17601C   1 > $DCC_PATH/config
    echo 0x176020   1 > $DCC_PATH/config
    echo 0x176024   1 > $DCC_PATH/config
    echo 0x176038   1 > $DCC_PATH/config
    echo 0x174000   1 > $DCC_PATH/config
    echo 0x174004   1 > $DCC_PATH/config
    echo 0x174008   1 > $DCC_PATH/config
    echo 0x17400C   1 > $DCC_PATH/config
    echo 0x174010   1 > $DCC_PATH/config
    echo 0x174014   1 > $DCC_PATH/config
    echo 0x174018   1 > $DCC_PATH/config
    echo 0x17401C   1 > $DCC_PATH/config
    echo 0x174020   1 > $DCC_PATH/config
    echo 0x174024   1 > $DCC_PATH/config
    echo 0x174038   1 > $DCC_PATH/config
    echo 0x113000   1 > $DCC_PATH/config
    echo 0x113004   1 > $DCC_PATH/config
    echo 0x113008   1 > $DCC_PATH/config
    echo 0x11300C   1 > $DCC_PATH/config
    echo 0x113010   1 > $DCC_PATH/config
    echo 0x113014   1 > $DCC_PATH/config
    echo 0x113018   1 > $DCC_PATH/config
    echo 0x11301C   1 > $DCC_PATH/config
    echo 0x113020   1 > $DCC_PATH/config
    echo 0x113024   1 > $DCC_PATH/config
    echo 0x113038   1 > $DCC_PATH/config
    echo 0x151000   1 > $DCC_PATH/config
    echo 0x152000   1 > $DCC_PATH/config
    echo 0x157000   1 > $DCC_PATH/config
    echo 0x151004   1 > $DCC_PATH/config
    echo 0x15100C   1 > $DCC_PATH/config
    echo 0x152004   1 > $DCC_PATH/config
    echo 0x15200C   1 > $DCC_PATH/config
    echo 0x1442A8   1 > $DCC_PATH/config
    echo 0x1442AC   1 > $DCC_PATH/config
    echo 0x106100   1 > $DCC_PATH/config
    echo 0x109004   1 > $DCC_PATH/config
    echo 0x109008   1 > $DCC_PATH/config
    echo 0x10F004   1 > $DCC_PATH/config
    echo 0x10F008   1 > $DCC_PATH/config
    echo 0x145148   1 > $DCC_PATH/config
    echo 0x14514C   1 > $DCC_PATH/config
    echo 0x177004   1 > $DCC_PATH/config
    echo 0x177008   1 > $DCC_PATH/config
    echo 0x189004   1 > $DCC_PATH/config
    echo 0x189008   1 > $DCC_PATH/config
    echo 0x190004   1 > $DCC_PATH/config
    echo 0x190008   1 > $DCC_PATH/config
    echo 0x10401C   1 > $DCC_PATH/config
    echo 0x105064   1 > $DCC_PATH/config
    echo 0x109048   1 > $DCC_PATH/config
    echo 0x1179B0   1 > $DCC_PATH/config
    echo 0x141024   1 > $DCC_PATH/config
    echo 0x14417C   1 > $DCC_PATH/config
    echo 0x1442C4   1 > $DCC_PATH/config
    echo 0x1443F0   1 > $DCC_PATH/config
    echo 0x183024   1 > $DCC_PATH/config
    echo 0x189034   1 > $DCC_PATH/config
    echo 0xC2A0000  1 > $DCC_PATH/config
    echo 0xC2A0004  1 > $DCC_PATH/config
    echo 0xC2A0008  1 > $DCC_PATH/config
    echo 0xC2A000C  1 > $DCC_PATH/config
    echo 0xC2A0010  1 > $DCC_PATH/config
    echo 0xC2A0014  1 > $DCC_PATH/config
    echo 0xC2A0018  1 > $DCC_PATH/config
    echo 0xC2A001C  1 > $DCC_PATH/config
    echo 0xC2A0020  1 > $DCC_PATH/config
    echo 0xC2A0024  1 > $DCC_PATH/config
    echo 0xC2A0038  1 > $DCC_PATH/config
    echo 0xC2A1000  1 > $DCC_PATH/config
    echo 0xC2A1004  1 > $DCC_PATH/config
    echo 0xC2A1008  1 > $DCC_PATH/config
    echo 0xC2A100C  1 > $DCC_PATH/config
    echo 0xC2A1010  1 > $DCC_PATH/config
    echo 0xC2A1014  1 > $DCC_PATH/config
    echo 0xC2A1018  1 > $DCC_PATH/config
    echo 0xC2A101C  1 > $DCC_PATH/config
    echo 0xC2A1020  1 > $DCC_PATH/config
    echo 0xC2A1024  1 > $DCC_PATH/config
    echo 0xC2A1028  1 > $DCC_PATH/config
    echo 0xC2A102C  1 > $DCC_PATH/config
    echo 0xC2A1030  1 > $DCC_PATH/config
    echo 0xC2A203C  1 > $DCC_PATH/config
    echo 0xC2A2150  1 > $DCC_PATH/config
    echo 0xC2A2154  1 > $DCC_PATH/config
}
config_sdm710_regs_no_ac()
{
    #CNOC Register
    echo 0x01500008 1 > $DCC_PATH/config
    echo 0x01500010 1 > $DCC_PATH/config
    echo 0x01500020 1 > $DCC_PATH/config
    echo 0x01500024 1 > $DCC_PATH/config
    echo 0x01500028 1 > $DCC_PATH/config
    echo 0x0150002c 1 > $DCC_PATH/config
    echo 0x01500030 1 > $DCC_PATH/config
    echo 0x01500034 1 > $DCC_PATH/config
    echo 0x01500038 1 > $DCC_PATH/config
    echo 0x0150003c 1 > $DCC_PATH/config
    echo 0x01500248 1 > $DCC_PATH/config
    echo 0x0150024c 1 > $DCC_PATH/config
    #AGGNOC1 registers
    echo 0x016e0240 1 > $DCC_PATH/config
    echo 0x016e0248 1 > $DCC_PATH/config
    echo 0x016e0288 1 > $DCC_PATH/config
    echo 0x016e0290 1 > $DCC_PATH/config
    echo 0x016e0300 1 > $DCC_PATH/config
    echo 0x016e0304 1 > $DCC_PATH/config
    echo 0x016e0308 1 > $DCC_PATH/config
    echo 0x016e030c 1 > $DCC_PATH/config
    echo 0x016e0408 1 > $DCC_PATH/config
    echo 0x016e0410 1 > $DCC_PATH/config
    echo 0x016e0420 1 > $DCC_PATH/config
    echo 0x016e0424 1 > $DCC_PATH/config
    echo 0x016e0428 1 > $DCC_PATH/config
    echo 0x016e042c 1 > $DCC_PATH/config
    echo 0x016e0430 1 > $DCC_PATH/config
    echo 0x016e0434 1 > $DCC_PATH/config
    echo 0x016e0438 1 > $DCC_PATH/config
    echo 0x016e043c 1 > $DCC_PATH/config
    #AGGNOC2 registers
    echo 0x01700240 1 > $DCC_PATH/config
    echo 0x01700248 1 > $DCC_PATH/config
    echo 0x01700288 1 > $DCC_PATH/config
    echo 0x01700290 1 > $DCC_PATH/config
    echo 0x01700300 1 > $DCC_PATH/config
    echo 0x01700304 1 > $DCC_PATH/config
    echo 0x01700308 1 > $DCC_PATH/config
    echo 0x0170030c 1 > $DCC_PATH/config
    echo 0x01700310 1 > $DCC_PATH/config
    echo 0x01700c08 1 > $DCC_PATH/config
    echo 0x01700c10 1 > $DCC_PATH/config
    echo 0x01700c20 1 > $DCC_PATH/config
    echo 0x01700c24 1 > $DCC_PATH/config
    echo 0x01700c28 1 > $DCC_PATH/config
    echo 0x01700c2c 1 > $DCC_PATH/config
    echo 0x01700c30 1 > $DCC_PATH/config
    echo 0x01700c34 1 > $DCC_PATH/config
    echo 0x01700c38 1 > $DCC_PATH/config
    echo 0x01700c3c 1 > $DCC_PATH/config
    #DC_NOC
    echo 0x014e0008 1 > $DCC_PATH/config
    echo 0x014e0010 1 > $DCC_PATH/config
    echo 0x014e0020 1 > $DCC_PATH/config
    echo 0x014e0024 1 > $DCC_PATH/config
    echo 0x014e0028 1 > $DCC_PATH/config
    echo 0x014e002c 1 > $DCC_PATH/config
    echo 0x014e0030 1 > $DCC_PATH/config
    echo 0x014e0034 1 > $DCC_PATH/config
    echo 0x014e0038 1 > $DCC_PATH/config
    echo 0x014e003c 1 > $DCC_PATH/config
    echo 0x014e0240 1 > $DCC_PATH/config
    echo 0x014e0248 1 > $DCC_PATH/config
    echo 0x014e0288 1 > $DCC_PATH/config
    echo 0x014e028c 1 > $DCC_PATH/config
    echo 0x014e0290 1 > $DCC_PATH/config
    echo 0x014e0294 1 > $DCC_PATH/config
    echo 0x014e0300 1 > $DCC_PATH/config
    echo 0x014e0304 1 > $DCC_PATH/config
    echo 0x014e0308 1 > $DCC_PATH/config
    echo 0x014e030c 1 > $DCC_PATH/config
    echo 0x014e0310 1 > $DCC_PATH/config
    echo 0x014e0314 1 > $DCC_PATH/config
    #MCCC_BROADCAST
    echo 0x01350110 1 > $DCC_PATH/config
    echo 0x01350114 1 > $DCC_PATH/config
    echo 0x01350118 1 > $DCC_PATH/config
    echo 0x0135011c 1 > $DCC_PATH/config
    #RAMBLUR_PIMEM_ESR
    echo 0x0061007c 1 > $DCC_PATH/config
    #LLCC_BEAC Registers
    echo 0x01148058 1 > $DCC_PATH/config
    echo 0x0114805c 1 > $DCC_PATH/config
    echo 0x01148060 1 > $DCC_PATH/config
    echo 0x01148064 1 > $DCC_PATH/config
    echo 0x011c2028 1 > $DCC_PATH/config
    echo 0x011c8058 1 > $DCC_PATH/config
    echo 0x011c805c 1 > $DCC_PATH/config
    echo 0x011c8060 1 > $DCC_PATH/config
    echo 0x011c8064 1 > $DCC_PATH/config
    echo 0x011e6418 1 > $DCC_PATH/config
    #CABO registers
    echo 0x01161410 1 > $DCC_PATH/config
    echo 0x01161414 1 > $DCC_PATH/config
    echo 0x01161418 1 > $DCC_PATH/config
    echo 0x01161424 1 > $DCC_PATH/config
    echo 0x01161430 1 > $DCC_PATH/config
    echo 0x01163410 1 > $DCC_PATH/config
    echo 0x01169180 1 > $DCC_PATH/config
    echo 0x01169184 1 > $DCC_PATH/config
    echo 0x011691a0 1 > $DCC_PATH/config
    echo 0x011691c0 1 > $DCC_PATH/config
    echo 0x011691e0 1 > $DCC_PATH/config
    echo 0x011e1410 1 > $DCC_PATH/config
    echo 0x011e1414 1 > $DCC_PATH/config
    echo 0x011e1418 1 > $DCC_PATH/config
    echo 0x011e1424 1 > $DCC_PATH/config
    echo 0x011e1430 1 > $DCC_PATH/config
    echo 0x011e3410 1 > $DCC_PATH/config
    echo 0x011e9180 1 > $DCC_PATH/config
    echo 0x011e9184 1 > $DCC_PATH/config
    echo 0x011e91a0 1 > $DCC_PATH/config
    echo 0x011e91c0 1 > $DCC_PATH/config
    echo 0x011e91e0 1 > $DCC_PATH/config
    #LLCC0_BERC Registers
    echo 0x01138004 1 > $DCC_PATH/config
    echo 0x01138010 1 > $DCC_PATH/config
    echo 0x01138014 1 > $DCC_PATH/config
    #LLCC0_DRP
    echo 0x0114201c 1 > $DCC_PATH/config
    #LLC1_BERC
    echo  0x011b8004 1 > $DCC_PATH/config
    echo  0x011b8010 1 > $DCC_PATH/config
    echo  0x011b8014 1 > $DCC_PATH/config
    # LLCC1_DRP
    echo  0x011c201c 1 > $DCC_PATH/config
    #DDRPHY_CH0_CA_DDRPHY Registers
    echo 0x01400740  1 > $DCC_PATH/config
    #DDRCC_CH01 Registers
    echo 0x01406048  1 > $DCC_PATH/config
    echo 0x01406054  1 > $DCC_PATH/config
    echo 0x01406164  1 > $DCC_PATH/config
    echo 0x01406170  1 > $DCC_PATH/config
    echo 0x01406270  1 > $DCC_PATH/config
    #SHRM_CSR_SHRM_SPROC_CTRL
    echo 0x013d1000  1 > $DCC_PATH/config
    #WCSS_HM_A_NOC
    echo 0x18980008  1 > $DCC_PATH/config
    echo 0x1898000C  1 > $DCC_PATH/config
    echo 0x18980014  1 > $DCC_PATH/config
    echo 0x18980018  1 > $DCC_PATH/config
    echo 0x18980020  1 > $DCC_PATH/config
    echo 0x18980024  1 > $DCC_PATH/config
    echo 0x18980028  1 > $DCC_PATH/config
    echo 0x18980038  1 > $DCC_PATH/config
    echo 0x18980208  1 > $DCC_PATH/config
    echo 0x1898020C  1 > $DCC_PATH/config
    echo 0x18980210  1 > $DCC_PATH/config
    echo 0x18980214  1 > $DCC_PATH/config
    echo 0x18980250  1 > $DCC_PATH/config
    echo 0x18980258  1 > $DCC_PATH/config
    #LPASS_AHBI_ABT
    echo 0x62CF600C  1 > $DCC_PATH/config
    echo 0x62CF6010  1 > $DCC_PATH/config
    echo 0x62CF6014  1 > $DCC_PATH/config
    echo 0x62CF601C  1 > $DCC_PATH/config
    echo 0x62CF6020  1 > $DCC_PATH/config
    echo 0x62CF6028  1 > $DCC_PATH/config
    echo 0x62CF602C  1 > $DCC_PATH/config
    echo 0x62CF6030  1 > $DCC_PATH/config
    echo 0x62CF6034  1 > $DCC_PATH/config
    echo 0x62D4300C  1 > $DCC_PATH/config
    echo 0x62D43010  1 > $DCC_PATH/config
    echo 0x62D43014  1 > $DCC_PATH/config
    echo 0x62D4301C  1 > $DCC_PATH/config
    echo 0x62D43020  1 > $DCC_PATH/config
    echo 0x62D43028  1 > $DCC_PATH/config
    echo 0x62D4302C  1 > $DCC_PATH/config
    echo 0x62D43030  1 > $DCC_PATH/config
    echo 0x62D43034  1 > $DCC_PATH/config
}

config_sdm710_dcc_noc_err_regs()
{
    echo 0x80A9008  1 > $DCC_PATH/config
    echo 0x80A9010  1 > $DCC_PATH/config
    echo 0x80A9020  1 > $DCC_PATH/config
    echo 0x80A9024  1 > $DCC_PATH/config
    echo 0x80A9028  1 > $DCC_PATH/config
    echo 0x80A902C  1 > $DCC_PATH/config
    echo 0x80A9030  1 > $DCC_PATH/config
    echo 0x80A9034  1 > $DCC_PATH/config
    echo 0x80A9038  1 > $DCC_PATH/config
    echo 0x80A903C  1 > $DCC_PATH/config
    echo 0x80A9280  1 > $DCC_PATH/config
    echo 0x80A9288  1 > $DCC_PATH/config
    echo 0x80A9290  1 > $DCC_PATH/config
    echo 0x80A9300  1 > $DCC_PATH/config
    echo 0x80A9304  1 > $DCC_PATH/config
    echo 0x1380008  1 > $DCC_PATH/config
    echo 0x1380010  1 > $DCC_PATH/config
    echo 0x1380020  1 > $DCC_PATH/config
    echo 0x1380024  1 > $DCC_PATH/config
    echo 0x1380028  1 > $DCC_PATH/config
    echo 0x138002C  1 > $DCC_PATH/config
    echo 0x1380030  1 > $DCC_PATH/config
    echo 0x1380034  1 > $DCC_PATH/config
    echo 0x1380038  1 > $DCC_PATH/config
    echo 0x138003C  1 > $DCC_PATH/config
    echo 0x1380440  1 > $DCC_PATH/config
    echo 0x1380448  1 > $DCC_PATH/config
    echo 0x1740008  1 > $DCC_PATH/config
    echo 0x1740010  1 > $DCC_PATH/config
    echo 0x1740020  1 > $DCC_PATH/config
    echo 0x1740024  1 > $DCC_PATH/config
    echo 0x1740028  1 > $DCC_PATH/config
    echo 0x174002C  1 > $DCC_PATH/config
    echo 0x1740030  1 > $DCC_PATH/config
    echo 0x1740034  1 > $DCC_PATH/config
    echo 0x1740038  1 > $DCC_PATH/config
    echo 0x174003C  1 > $DCC_PATH/config
    echo 0x1740240  1 > $DCC_PATH/config
    echo 0x1740248  1 > $DCC_PATH/config
    echo 0x1740288  1 > $DCC_PATH/config
    echo 0x1740290  1 > $DCC_PATH/config
    echo 0x62BE0008 1 > $DCC_PATH/config
    echo 0x62BE0010 1 > $DCC_PATH/config
    echo 0x62BE0020 1 > $DCC_PATH/config
    echo 0x62BE0024 1 > $DCC_PATH/config
    echo 0x62BE0028 1 > $DCC_PATH/config
    echo 0x62BE002C 1 > $DCC_PATH/config
    echo 0x62BE0030 1 > $DCC_PATH/config
    echo 0x62BE0034 1 > $DCC_PATH/config
    echo 0x62BE0038 1 > $DCC_PATH/config
    echo 0x62BE003C 1 > $DCC_PATH/config
    echo 0x62BE2040 1 > $DCC_PATH/config
    echo 0x62BE2048 1 > $DCC_PATH/config
    echo 0x62BE2088 1 > $DCC_PATH/config
    echo 0x62BE2090 1 > $DCC_PATH/config
    echo 0x62BE2100 1 > $DCC_PATH/config
    echo 0x62BE2104 1 > $DCC_PATH/config
    echo 0x62BE2108 1 > $DCC_PATH/config
    echo 0x62BE210C 1 > $DCC_PATH/config
    echo 0x62BE2110 1 > $DCC_PATH/config
    echo 0x62BE2114 1 > $DCC_PATH/config
    echo 0x62BE2118 1 > $DCC_PATH/config
    echo 0x1620008  1 > $DCC_PATH/config
    echo 0x1620010  1 > $DCC_PATH/config
    echo 0x1620020  1 > $DCC_PATH/config
    echo 0x1620024  1 > $DCC_PATH/config
    echo 0x1620028  1 > $DCC_PATH/config
    echo 0x162002C  1 > $DCC_PATH/config
    echo 0x1620030  1 > $DCC_PATH/config
    echo 0x1620034  1 > $DCC_PATH/config
    echo 0x1620038  1 > $DCC_PATH/config
    echo 0x162003C  1 > $DCC_PATH/config
    echo 0x1620240  1 > $DCC_PATH/config
    echo 0x1620248  1 > $DCC_PATH/config
    echo 0x1620288  1 > $DCC_PATH/config
    echo 0x162028C  1 > $DCC_PATH/config
    echo 0x1620290  1 > $DCC_PATH/config
    echo 0x1620294  1 > $DCC_PATH/config
    echo 0x1620300  1 > $DCC_PATH/config
    echo 0x82D1008  1 > $DCC_PATH/config
    echo 0x82D1010  1 > $DCC_PATH/config
    echo 0x82D1020  1 > $DCC_PATH/config
    echo 0x82D1024  1 > $DCC_PATH/config
    echo 0x82D1028  1 > $DCC_PATH/config
    echo 0x82D102C  1 > $DCC_PATH/config
    echo 0x82D1030  1 > $DCC_PATH/config
    echo 0x82D1034  1 > $DCC_PATH/config
    echo 0x82D1038  1 > $DCC_PATH/config
    echo 0x82D103C  1 > $DCC_PATH/config
    echo 0x41B000C  1 > $DCC_PATH/config
    echo 0x41B0010  1 > $DCC_PATH/config
    echo 0x41B0014  1 > $DCC_PATH/config
    echo 0x41B001C  1 > $DCC_PATH/config
    echo 0x41B0020  1 > $DCC_PATH/config
    echo 0x41B0028  1 > $DCC_PATH/config
    echo 0x41B002C  1 > $DCC_PATH/config
    echo 0x41B0030  1 > $DCC_PATH/config
    echo 0x41B0034  1 > $DCC_PATH/config
    echo 0x80B700C  1 > $DCC_PATH/config
    echo 0x80B7010  1 > $DCC_PATH/config
    echo 0x80B7014  1 > $DCC_PATH/config
    echo 0x80B701C  1 > $DCC_PATH/config
    echo 0x80B7020  1 > $DCC_PATH/config
    echo 0x80B7028  1 > $DCC_PATH/config
    echo 0x80B702C  1 > $DCC_PATH/config
    echo 0x80B7030  1 > $DCC_PATH/config
    echo 0x80B7034  1 > $DCC_PATH/config
}

config_sdm710_dcc_gladiator()
{
    echo 0x7840000 1 > $DCC_PATH/config
    echo 0x7842500 1 > $DCC_PATH/config
    echo 0x7842504 1 > $DCC_PATH/config
    echo 0x7841010 12 > $DCC_PATH/config
    echo 0x7842000 16 > $DCC_PATH/config
    echo 7 > $DCC_PATH/loop
    echo 0x7841000 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #echo 165 > $DCC_PATH/loop
    #echo 0x7841008 1 > $DCC_PATH/config
    #echo 0x784100C 1 > $DCC_PATH/config
    #echo 1 > $DCC_PATH/loop
}
config_sdm710_dcc_cprh()
{
    #CPRH
    echo 0x17DC3A84 2 > $DCC_PATH/config
    echo 0x17DB3A84 1 > $DCC_PATH/config
    echo 0x17840C18 1 > $DCC_PATH/config
    echo 0x17830C18 1 > $DCC_PATH/config
    echo 0x17D20000 1 > $DCC_PATH/config
    echo 0x17D2000C 1 > $DCC_PATH/config
    echo 0x17D20018 1 > $DCC_PATH/config
}
config_sdm710_dcc_pcu_rscc_apps()
{
    #PCU APPS
    echo 0x17E00024 1 > $DCC_PATH/config
    echo 0x17E00040 1 > $DCC_PATH/config
    echo 0x17E0004c 1 > $DCC_PATH/config
    echo 0x17E10024 1 > $DCC_PATH/config
    echo 0x17E10040 1 > $DCC_PATH/config
    echo 0x17E1004c 1 > $DCC_PATH/config
    echo 0x17E20024 1 > $DCC_PATH/config
    echo 0x17E20040 1 > $DCC_PATH/config
    echo 0x17E2004c 1 > $DCC_PATH/config
    echo 0x17E30024 1 > $DCC_PATH/config
    echo 0x17E30040 1 > $DCC_PATH/config
    echo 0x17E3004c 1 > $DCC_PATH/config
    echo 0x17E40024 1 > $DCC_PATH/config
    echo 0x17E40040 1 > $DCC_PATH/config
    echo 0x17E4004c 1 > $DCC_PATH/config
    echo 0x17E50024 1 > $DCC_PATH/config
    echo 0x17E50040 1 > $DCC_PATH/config
    echo 0x17E5004C 1 > $DCC_PATH/config
    echo 0x17E60024 1 > $DCC_PATH/config
    echo 0x17E60040 1 > $DCC_PATH/config
    echo 0x17E6004C 1 > $DCC_PATH/config
    echo 0x17E70024 1 > $DCC_PATH/config
    echo 0x17E70040 1 > $DCC_PATH/config
    echo 0x17E7004C 1 > $DCC_PATH/config
    echo 0x17810024 1 > $DCC_PATH/config
    echo 0x17810040 1 > $DCC_PATH/config
    echo 0x1781004C 1 > $DCC_PATH/config
    echo 0x17810104 1 > $DCC_PATH/config
    echo 0x17810118 1 > $DCC_PATH/config
    echo 0x17810128 1 > $DCC_PATH/config
    echo 0x178100F4 1 > $DCC_PATH/config
    #RSCC
    echo 0x179e000c 1 > $DCC_PATH/config
    echo 0x179e0d00 1 > $DCC_PATH/config
    echo 0x179e0d04 1 > $DCC_PATH/config
    echo 0x179e1254 1 > $DCC_PATH/config
    echo 0x179e1258 1 > $DCC_PATH/config
    echo 0x179e125c 1 > $DCC_PATH/config
    echo 0x179e1274 1 > $DCC_PATH/config
    echo 0x179e1278 1 > $DCC_PATH/config
    echo 0x179e1288 1 > $DCC_PATH/config
    echo 0x179e128c 1 > $DCC_PATH/config
    echo 0x179e129c 1 > $DCC_PATH/config
    echo 0x179e12a0 1 > $DCC_PATH/config
    echo 0x179e12b0 1 > $DCC_PATH/config
    echo 0x179e12b4 1 > $DCC_PATH/config
    echo 0x179e12c4 1 > $DCC_PATH/config
    echo 0x179e12c8 1 > $DCC_PATH/config
    echo 0x179e12d8 1 > $DCC_PATH/config
    echo 0x179e12dc 1 > $DCC_PATH/config
    echo 0x179e12ec 1 > $DCC_PATH/config
    echo 0x179e12f0 1 > $DCC_PATH/config
    echo 0x179e1300 1 > $DCC_PATH/config
    echo 0x179e1304 1 > $DCC_PATH/config
    echo 0x179e1314 1 > $DCC_PATH/config
    echo 0x179e1318 1 > $DCC_PATH/config
    echo 0x179e1328 1 > $DCC_PATH/config
    echo 0x179e132c 1 > $DCC_PATH/config
    echo 0x179e133c 1 > $DCC_PATH/config
    echo 0x179e1340 1 > $DCC_PATH/config
    echo 0x179e1350 1 > $DCC_PATH/config
    echo 0x179e1354 1 > $DCC_PATH/config
    echo 0x179e1364 1 > $DCC_PATH/config
    echo 0x179e1368 1 > $DCC_PATH/config
    echo 0x179e1378 1 > $DCC_PATH/config
    echo 0x179e137c 1 > $DCC_PATH/config
    echo 0x179e138c 1 > $DCC_PATH/config
    echo 0x179e1390 1 > $DCC_PATH/config
    echo 0x179e13a0 1 > $DCC_PATH/config
    echo 0x179e13a4 1 > $DCC_PATH/config
    echo 0x179e14f4 1 > $DCC_PATH/config
    echo 0x179e14f8 1 > $DCC_PATH/config
    echo 0x179e14fc 1 > $DCC_PATH/config
    echo 0x179e1514 1 > $DCC_PATH/config
    echo 0x179e1518 1 > $DCC_PATH/config
    echo 0x179e1528 1 > $DCC_PATH/config
    echo 0x179e152c 1 > $DCC_PATH/config
    echo 0x179e153c 1 > $DCC_PATH/config
    echo 0x179e1540 1 > $DCC_PATH/config
    echo 0x179e1550 1 > $DCC_PATH/config
    echo 0x179e1554 1 > $DCC_PATH/config
    echo 0x179e1564 1 > $DCC_PATH/config
    echo 0x179e1568 1 > $DCC_PATH/config
    echo 0x179e1578 1 > $DCC_PATH/config
    echo 0x179e157c 1 > $DCC_PATH/config
    echo 0x179e158c 1 > $DCC_PATH/config
    echo 0x179e1590 1 > $DCC_PATH/config
    echo 0x179e15a0 1 > $DCC_PATH/config
    echo 0x179e15a4 1 > $DCC_PATH/config
    echo 0x179e15b4 1 > $DCC_PATH/config
    echo 0x179e15b8 1 > $DCC_PATH/config
    echo 0x179e15c8 1 > $DCC_PATH/config
    echo 0x179e15cc 1 > $DCC_PATH/config
    echo 0x179e15dc 1 > $DCC_PATH/config
    echo 0x179e15e0 1 > $DCC_PATH/config
    echo 0x179e15f0 1 > $DCC_PATH/config
    echo 0x179e15f4 1 > $DCC_PATH/config
    echo 0x179e1604 1 > $DCC_PATH/config
    echo 0x179e1608 1 > $DCC_PATH/config
    echo 0x179e1618 1 > $DCC_PATH/config
    echo 0x179e161c 1 > $DCC_PATH/config
    echo 0x179e162c 1 > $DCC_PATH/config
    echo 0x179e1630 1 > $DCC_PATH/config
    echo 0x179e1640 1 > $DCC_PATH/config
    echo 0x179e1644 1 > $DCC_PATH/config
    echo 0x179e1794 1 > $DCC_PATH/config
    echo 0x179e1798 1 > $DCC_PATH/config
    echo 0x179e179c 1 > $DCC_PATH/config
    echo 0x179e17b4 1 > $DCC_PATH/config
    echo 0x179e17b8 1 > $DCC_PATH/config
    echo 0x179e17c8 1 > $DCC_PATH/config
    echo 0x179e17cc 1 > $DCC_PATH/config
    echo 0x179e17dc 1 > $DCC_PATH/config
    echo 0x179e17e0 1 > $DCC_PATH/config
    echo 0x179e17f0 1 > $DCC_PATH/config
    echo 0x179e17f4 1 > $DCC_PATH/config
    echo 0x179e1804 1 > $DCC_PATH/config
    echo 0x179e1808 1 > $DCC_PATH/config
    echo 0x179e1818 1 > $DCC_PATH/config
    echo 0x179e181c 1 > $DCC_PATH/config
    echo 0x179e182c 1 > $DCC_PATH/config
    echo 0x179e1830 1 > $DCC_PATH/config
    echo 0x179e1840 1 > $DCC_PATH/config
    echo 0x179e1844 1 > $DCC_PATH/config
    echo 0x179e1854 1 > $DCC_PATH/config
    echo 0x179e1858 1 > $DCC_PATH/config
    echo 0x179e1868 1 > $DCC_PATH/config
    echo 0x179e186c 1 > $DCC_PATH/config
    echo 0x179e187c 1 > $DCC_PATH/config
    echo 0x179e1880 1 > $DCC_PATH/config
    echo 0x179e1890 1 > $DCC_PATH/config
    echo 0x179e1894 1 > $DCC_PATH/config
    echo 0x179e18a4 1 > $DCC_PATH/config
    echo 0x179e18a8 1 > $DCC_PATH/config
    echo 0x179e18b8 1 > $DCC_PATH/config
    echo 0x179e18bc 1 > $DCC_PATH/config
    echo 0x179e18cc 1 > $DCC_PATH/config
    echo 0x179e18d0 1 > $DCC_PATH/config
    echo 0x179e18e0 1 > $DCC_PATH/config
    echo 0x179e18e4 1 > $DCC_PATH/config
    echo 0x179e1a34 1 > $DCC_PATH/config
    echo 0x179e1a38 1 > $DCC_PATH/config
    echo 0x179e1a3c 1 > $DCC_PATH/config
    echo 0x179e1a54 1 > $DCC_PATH/config
    echo 0x179e1a58 1 > $DCC_PATH/config
    echo 0x179e1a68 1 > $DCC_PATH/config
    echo 0x179e1a6c 1 > $DCC_PATH/config
    echo 0x179e1a7c 1 > $DCC_PATH/config
    echo 0x179e1a80 1 > $DCC_PATH/config
    echo 0x179e1a90 1 > $DCC_PATH/config
    echo 0x179e1a94 1 > $DCC_PATH/config
    echo 0x179e1aa4 1 > $DCC_PATH/config
    echo 0x179e1aa8 1 > $DCC_PATH/config
    echo 0x179e1ab8 1 > $DCC_PATH/config
    echo 0x179e1abc 1 > $DCC_PATH/config
    echo 0x179e1acc 1 > $DCC_PATH/config
    echo 0x179e1ad0 1 > $DCC_PATH/config
    echo 0x179e1ae0 1 > $DCC_PATH/config
    echo 0x179e1ae4 1 > $DCC_PATH/config
    echo 0x179e1af4 1 > $DCC_PATH/config
    echo 0x179e1af8 1 > $DCC_PATH/config
    echo 0x179e1b08 1 > $DCC_PATH/config
    echo 0x179e1b0c 1 > $DCC_PATH/config
    echo 0x179e1b1c 1 > $DCC_PATH/config
    echo 0x179e1b20 1 > $DCC_PATH/config
    echo 0x179e1b30 1 > $DCC_PATH/config
    echo 0x179e1b34 1 > $DCC_PATH/config
    echo 0x179e1b44 1 > $DCC_PATH/config
    echo 0x179e1b48 1 > $DCC_PATH/config
    echo 0x179e1b58 1 > $DCC_PATH/config
    echo 0x179e1b5c 1 > $DCC_PATH/config
    echo 0x179e1b6c 1 > $DCC_PATH/config
    echo 0x179e1b70 1 > $DCC_PATH/config
    echo 0x179e1b80 1 > $DCC_PATH/config
    echo 0x179e1b84 1 > $DCC_PATH/config
    echo 0x179e1cd4 1 > $DCC_PATH/config
    echo 0x179e1cd8 1 > $DCC_PATH/config
    echo 0x179e1cdc 1 > $DCC_PATH/config
    echo 0x179e1cf4 1 > $DCC_PATH/config
    echo 0x179e1cf8 1 > $DCC_PATH/config
    echo 0x179e1d08 1 > $DCC_PATH/config
    echo 0x179e1d0c 1 > $DCC_PATH/config
    echo 0x179e1d1c 1 > $DCC_PATH/config
    echo 0x179e1d20 1 > $DCC_PATH/config
    echo 0x179e1d30 1 > $DCC_PATH/config
    echo 0x179e1d34 1 > $DCC_PATH/config
    echo 0x179e1d44 1 > $DCC_PATH/config
    echo 0x179e1d48 1 > $DCC_PATH/config
    echo 0x179e1d58 1 > $DCC_PATH/config
    echo 0x179e1d5c 1 > $DCC_PATH/config
    echo 0x179e1d6c 1 > $DCC_PATH/config
    echo 0x179e1d70 1 > $DCC_PATH/config
    echo 0x179e1d80 1 > $DCC_PATH/config
    echo 0x179e1d84 1 > $DCC_PATH/config
    echo 0x179e1d94 1 > $DCC_PATH/config
    echo 0x179e1d98 1 > $DCC_PATH/config
    echo 0x179e1da8 1 > $DCC_PATH/config
    echo 0x179e1dac 1 > $DCC_PATH/config
    echo 0x179e1dbc 1 > $DCC_PATH/config
    echo 0x179e1dc0 1 > $DCC_PATH/config
    echo 0x179e1dd0 1 > $DCC_PATH/config
    echo 0x179e1dd4 1 > $DCC_PATH/config
    echo 0x179e1de4 1 > $DCC_PATH/config
    echo 0x179e1de8 1 > $DCC_PATH/config
    echo 0x179e1df8 1 > $DCC_PATH/config
    echo 0x179e1dfc 1 > $DCC_PATH/config
    echo 0x179e1e0c 1 > $DCC_PATH/config
    echo 0x179e1e10 1 > $DCC_PATH/config
    echo 0x179e1e20 1 > $DCC_PATH/config
    echo 0x179e1e24 1 > $DCC_PATH/config
    echo 0x179e1f74 1 > $DCC_PATH/config
    echo 0x179e1f78 1 > $DCC_PATH/config
    echo 0x179e1f7c 1 > $DCC_PATH/config
    echo 0x179e1f94 1 > $DCC_PATH/config
    echo 0x179e1f98 1 > $DCC_PATH/config
    echo 0x179e1fa8 1 > $DCC_PATH/config
    echo 0x179e1fac 1 > $DCC_PATH/config
    echo 0x179e1fbc 1 > $DCC_PATH/config
    echo 0x179e1fc0 1 > $DCC_PATH/config
    echo 0x179e1fd0 1 > $DCC_PATH/config
    echo 0x179e1fd4 1 > $DCC_PATH/config
    echo 0x179e1fe4 1 > $DCC_PATH/config
    echo 0x179e1fe8 1 > $DCC_PATH/config
    echo 0x179e1ff8 1 > $DCC_PATH/config
    echo 0x179e1ffc 1 > $DCC_PATH/config
    echo 0x179e200c 1 > $DCC_PATH/config
    echo 0x179e2010 1 > $DCC_PATH/config
    echo 0x179e2020 1 > $DCC_PATH/config
    echo 0x179e2024 1 > $DCC_PATH/config
    echo 0x179e2034 1 > $DCC_PATH/config
    echo 0x179e2038 1 > $DCC_PATH/config
    echo 0x179e2048 1 > $DCC_PATH/config
    echo 0x179e204c 1 > $DCC_PATH/config
    echo 0x179e205c 1 > $DCC_PATH/config
    echo 0x179e2060 1 > $DCC_PATH/config
    echo 0x179e2070 1 > $DCC_PATH/config
    echo 0x179e2074 1 > $DCC_PATH/config
    echo 0x179e2084 1 > $DCC_PATH/config
    echo 0x179e2088 1 > $DCC_PATH/config
    echo 0x179e2098 1 > $DCC_PATH/config
    echo 0x179e209c 1 > $DCC_PATH/config
    echo 0x179e20ac 1 > $DCC_PATH/config
    echo 0x179e20b0 1 > $DCC_PATH/config
    echo 0x179e20c0 1 > $DCC_PATH/config
    echo 0x179e20c4 1 > $DCC_PATH/config
    echo 0x179C0400 1 > $DCC_PATH/config
    #RSC registers
    echo 0x179C0404 1 > $DCC_PATH/config
    echo 0x179C0408 1 > $DCC_PATH/config
    echo 0x179D0400 1 > $DCC_PATH/config
    echo 0x179D0404 1 > $DCC_PATH/config
    echo 0x179D0408 1 > $DCC_PATH/config
    echo 0x179E0400 1 > $DCC_PATH/config
    echo 0x179E0404 1 > $DCC_PATH/config
    echo 0x179E0408 1 > $DCC_PATH/config
    echo 0x179C0038 1 > $DCC_PATH/config
    echo 0x179C0040 1 > $DCC_PATH/config
    echo 0x179C0048 1 > $DCC_PATH/config
    echo 0x179E0038 1 > $DCC_PATH/config
    echo 0x179E0040 1 > $DCC_PATH/config
    #clock to APSS
    echo 0x148010   1 > $DCC_PATH/config
    echo 0x148198   1 > $DCC_PATH/config
 }
 config_sdm710_dcc_pdc_apps()
 {
    #PDC APPS
    echo 0x0B201020 1 > $DCC_PATH/config
    echo 0x0B201024 1 > $DCC_PATH/config
    echo 0x0B200010 1 > $DCC_PATH/config
    echo 0x0B200014 1 > $DCC_PATH/config
    echo 0x0B200018 1 > $DCC_PATH/config
    echo 0x0B20001C 1 > $DCC_PATH/config
    echo 0x0B220010 1 > $DCC_PATH/config
    echo 0x0B220014 1 > $DCC_PATH/config
    echo 0x0B220018 1 > $DCC_PATH/config
    echo 0x0B22001C 1 > $DCC_PATH/config
    echo 0x0B200900 1 > $DCC_PATH/config
    echo 0x0B200904 1 > $DCC_PATH/config
    echo 0x0B200908 1 > $DCC_PATH/config
    echo 0x0B20090C 1 > $DCC_PATH/config
    echo 0x0B220900 1 > $DCC_PATH/config
    echo 0x0B220904 1 > $DCC_PATH/config
    echo 0x0B220908 1 > $DCC_PATH/config
    echo 0x0B22090C 1 > $DCC_PATH/config
    echo 0x0B201030 1 > $DCC_PATH/config
    echo 0x0B201204 1 > $DCC_PATH/config
    echo 0x0B201218 1 > $DCC_PATH/config
    echo 0x0B20122C 1 > $DCC_PATH/config
    echo 0x0B201240 1 > $DCC_PATH/config
    echo 0x0B201254 1 > $DCC_PATH/config
    echo 0x0B201208 1 > $DCC_PATH/config
    echo 0x0B20121C 1 > $DCC_PATH/config
    echo 0x0B201230 1 > $DCC_PATH/config
    echo 0x0B201244 1 > $DCC_PATH/config
    echo 0x0B201258 1 > $DCC_PATH/config
    echo 0x0B204510 1 > $DCC_PATH/config
    echo 0x0B204514 1 > $DCC_PATH/config
    echo 0x0B204520 1 > $DCC_PATH/config
    echo 0x0B2013CC 1 > $DCC_PATH/config
    echo 0x0B2013D4 1 > $DCC_PATH/config
    echo 0x0B2013DC 1 > $DCC_PATH/config
    echo 0x0B2013E4 1 > $DCC_PATH/config
    echo 0x0B20155C 1 > $DCC_PATH/config
    echo 0x0B201564 1 > $DCC_PATH/config
    echo 0x0B20156C 1 > $DCC_PATH/config
    echo 0x0B201574 1 > $DCC_PATH/config


 }
 config_sdm710_dcc_rscc_lpass()
 {
    #RSCC
    echo 0x62b9000c 1 > $DCC_PATH/config
    echo 0x62b90014 1 > $DCC_PATH/config
    echo 0x62b90018 1 > $DCC_PATH/config
    echo 0x62b90400 1 > $DCC_PATH/config
    echo 0x62b90404 1 > $DCC_PATH/config
    echo 0x62b90408 1 > $DCC_PATH/config
    echo 0x62b90c28 1 > $DCC_PATH/config
    echo 0x62b90c2c 1 > $DCC_PATH/config
    echo 0x62b91c00 1 > $DCC_PATH/config
    echo 0x62b91c04 1 > $DCC_PATH/config
    echo 0x62b92154 1 > $DCC_PATH/config
    echo 0x62b92158 1 > $DCC_PATH/config
    echo 0x62b9215c 1 > $DCC_PATH/config
    echo 0x62b92174 1 > $DCC_PATH/config
    echo 0x62b92178 1 > $DCC_PATH/config
    echo 0x62b92188 1 > $DCC_PATH/config
    echo 0x62b9218c 1 > $DCC_PATH/config
    echo 0x62b9219c 1 > $DCC_PATH/config
    echo 0x62b921a0 1 > $DCC_PATH/config
    echo 0x62b921b0 1 > $DCC_PATH/config
    echo 0x62b921b4 1 > $DCC_PATH/config
    echo 0x62b921c4 1 > $DCC_PATH/config
    echo 0x62b921c8 1 > $DCC_PATH/config
    echo 0x62b921d8 1 > $DCC_PATH/config
    echo 0x62b921dc 1 > $DCC_PATH/config
    echo 0x62b921ec 1 > $DCC_PATH/config
    echo 0x62b921f0 1 > $DCC_PATH/config
    echo 0x62b92200 1 > $DCC_PATH/config
    echo 0x62b92204 1 > $DCC_PATH/config
    echo 0x62b92214 1 > $DCC_PATH/config
    echo 0x62b92218 1 > $DCC_PATH/config
    echo 0x62b92228 1 > $DCC_PATH/config
    echo 0x62b9222c 1 > $DCC_PATH/config
    echo 0x62b9223c 1 > $DCC_PATH/config
    echo 0x62b92240 1 > $DCC_PATH/config
    echo 0x62b92250 1 > $DCC_PATH/config
    echo 0x62b92254 1 > $DCC_PATH/config
    echo 0x62b92264 1 > $DCC_PATH/config
    echo 0x62b92268 1 > $DCC_PATH/config
    echo 0x62b92278 1 > $DCC_PATH/config
    echo 0x62b9227c 1 > $DCC_PATH/config
    echo 0x62b9228c 1 > $DCC_PATH/config
    echo 0x62b92290 1 > $DCC_PATH/config
    echo 0x62b922a0 1 > $DCC_PATH/config
    echo 0x62b922a4 1 > $DCC_PATH/config
    echo 0x62b923f4 1 > $DCC_PATH/config
    echo 0x62b923f8 1 > $DCC_PATH/config
    echo 0x62b923fc 1 > $DCC_PATH/config
    echo 0x62b92414 1 > $DCC_PATH/config
    echo 0x62b92418 1 > $DCC_PATH/config
    echo 0x62b92428 1 > $DCC_PATH/config
    echo 0x62b9242c 1 > $DCC_PATH/config
    echo 0x62b9243c 1 > $DCC_PATH/config
    echo 0x62b92440 1 > $DCC_PATH/config
    echo 0x62b92450 1 > $DCC_PATH/config
    echo 0x62b92454 1 > $DCC_PATH/config
    echo 0x62b92464 1 > $DCC_PATH/config
    echo 0x62b92468 1 > $DCC_PATH/config
    echo 0x62b92478 1 > $DCC_PATH/config
    echo 0x62b9247c 1 > $DCC_PATH/config
    echo 0x62b9248c 1 > $DCC_PATH/config
    echo 0x62b92490 1 > $DCC_PATH/config
    echo 0x62b924a0 1 > $DCC_PATH/config
    echo 0x62b924a4 1 > $DCC_PATH/config
    echo 0x62b924b4 1 > $DCC_PATH/config
    echo 0x62b924b8 1 > $DCC_PATH/config
    echo 0x62b924c8 1 > $DCC_PATH/config
    echo 0x62b924cc 1 > $DCC_PATH/config
    echo 0x62b924dc 1 > $DCC_PATH/config
    echo 0x62b924e0 1 > $DCC_PATH/config
    echo 0x62b924f0 1 > $DCC_PATH/config
    echo 0x62b924f4 1 > $DCC_PATH/config
    echo 0x62b92504 1 > $DCC_PATH/config
    echo 0x62b92508 1 > $DCC_PATH/config
    echo 0x62b92518 1 > $DCC_PATH/config
    echo 0x62b9251c 1 > $DCC_PATH/config
    echo 0x62b9252c 1 > $DCC_PATH/config
    echo 0x62b92530 1 > $DCC_PATH/config
    echo 0x62b92540 1 > $DCC_PATH/config
    echo 0x62b92544 1 > $DCC_PATH/config
    echo 0x62b92694 1 > $DCC_PATH/config
    echo 0x62b92698 1 > $DCC_PATH/config
    echo 0x62b9269c 1 > $DCC_PATH/config
    echo 0x62b926b4 1 > $DCC_PATH/config
    echo 0x62b926b8 1 > $DCC_PATH/config
    echo 0x62b926c8 1 > $DCC_PATH/config
    echo 0x62b926cc 1 > $DCC_PATH/config
    echo 0x62b926dc 1 > $DCC_PATH/config
    echo 0x62b926e0 1 > $DCC_PATH/config
    echo 0x62b926f0 1 > $DCC_PATH/config
    echo 0x62b926f4 1 > $DCC_PATH/config
    echo 0x62b92704 1 > $DCC_PATH/config
    echo 0x62b92708 1 > $DCC_PATH/config
    echo 0x62b92718 1 > $DCC_PATH/config
    echo 0x62b9271c 1 > $DCC_PATH/config
    echo 0x62b9272c 1 > $DCC_PATH/config
    echo 0x62b92730 1 > $DCC_PATH/config
    echo 0x62b92740 1 > $DCC_PATH/config
    echo 0x62b92744 1 > $DCC_PATH/config
    echo 0x62b92754 1 > $DCC_PATH/config
    echo 0x62b92758 1 > $DCC_PATH/config
    echo 0x62b92768 1 > $DCC_PATH/config
    echo 0x62b9276c 1 > $DCC_PATH/config
    echo 0x62b9277c 1 > $DCC_PATH/config
    echo 0x62b92780 1 > $DCC_PATH/config
    echo 0x62b92790 1 > $DCC_PATH/config
    echo 0x62b92794 1 > $DCC_PATH/config
    echo 0x62b927a4 1 > $DCC_PATH/config
    echo 0x62b927a8 1 > $DCC_PATH/config
    echo 0x62b927b8 1 > $DCC_PATH/config
    echo 0x62b927bc 1 > $DCC_PATH/config
    echo 0x62b927cc 1 > $DCC_PATH/config
    echo 0x62b927d0 1 > $DCC_PATH/config
    echo 0x62b927e0 1 > $DCC_PATH/config
    echo 0x62b927e4 1 > $DCC_PATH/config
    echo 0x62b92934 1 > $DCC_PATH/config
    echo 0x62b92938 1 > $DCC_PATH/config
    echo 0x62b9293c 1 > $DCC_PATH/config
    echo 0x62b92954 1 > $DCC_PATH/config
    echo 0x62b92958 1 > $DCC_PATH/config
    echo 0x62b92968 1 > $DCC_PATH/config
    echo 0x62b9296c 1 > $DCC_PATH/config
    echo 0x62b9297c 1 > $DCC_PATH/config
    echo 0x62b92980 1 > $DCC_PATH/config
    echo 0x62b92990 1 > $DCC_PATH/config
    echo 0x62b92994 1 > $DCC_PATH/config
    echo 0x62b929a4 1 > $DCC_PATH/config
    echo 0x62b929a8 1 > $DCC_PATH/config
    echo 0x62b929b8 1 > $DCC_PATH/config
    echo 0x62b929bc 1 > $DCC_PATH/config
    echo 0x62b929cc 1 > $DCC_PATH/config
    echo 0x62b929d0 1 > $DCC_PATH/config
    echo 0x62b929e0 1 > $DCC_PATH/config
    echo 0x62b929e4 1 > $DCC_PATH/config
    echo 0x62b929f4 1 > $DCC_PATH/config
    echo 0x62b929f8 1 > $DCC_PATH/config
    echo 0x62b92a08 1 > $DCC_PATH/config
    echo 0x62b92a0c 1 > $DCC_PATH/config
    echo 0x62b92a1c 1 > $DCC_PATH/config
    echo 0x62b92a20 1 > $DCC_PATH/config
    echo 0x62b92a30 1 > $DCC_PATH/config
    echo 0x62b92a34 1 > $DCC_PATH/config
    echo 0x62b92a44 1 > $DCC_PATH/config
    echo 0x62b92a48 1 > $DCC_PATH/config
    echo 0x62b92a58 1 > $DCC_PATH/config
    echo 0x62b92a5c 1 > $DCC_PATH/config
    echo 0x62b92a6c 1 > $DCC_PATH/config
    echo 0x62b92a70 1 > $DCC_PATH/config
    echo 0x62b92a80 1 > $DCC_PATH/config
    echo 0x62b92a84 1 > $DCC_PATH/config

    #RSC CHILD
    echo 0x624b0208 1 > $DCC_PATH/config
    echo 0x624b020c 1 > $DCC_PATH/config
    echo 0x624b0210 1 > $DCC_PATH/config
    echo 0x624b0228 1 > $DCC_PATH/config
    echo 0x624b022c 1 > $DCC_PATH/config
    echo 0x624b0230 1 > $DCC_PATH/config
    echo 0x624b0248 1 > $DCC_PATH/config
    echo 0x624b024c 1 > $DCC_PATH/config
    echo 0x624b0250 1 > $DCC_PATH/config
    echo 0x624b0268 1 > $DCC_PATH/config
    echo 0x624b026c 1 > $DCC_PATH/config
    echo 0x624b0270 1 > $DCC_PATH/config
    echo 0X624b0400 1 > $DCC_PATH/config
    echo 0X624b0404 1 > $DCC_PATH/config
    echo 0x624b0408 1 > $DCC_PATH/config
    #RSC PARENT
    echo 0x62b90208 1 > $DCC_PATH/config
    echo 0x62b90228 1 > $DCC_PATH/config
    echo 0x62b90248 1 > $DCC_PATH/config
    echo 0x62b90268 1 > $DCC_PATH/config
    echo 0x62b9020c 1 > $DCC_PATH/config
    echo 0x62b9022c 1 > $DCC_PATH/config
    echo 0x62b9024c 1 > $DCC_PATH/config
    echo 0x62b9026c 1 > $DCC_PATH/config
    echo 0x62b90210 1 > $DCC_PATH/config
    echo 0x62b90230 1 > $DCC_PATH/config
    echo 0x62b90250 1 > $DCC_PATH/config
    echo 0x62b90270 1 > $DCC_PATH/config
    #PDC
    echo 0xb251020  1 > $DCC_PATH/config
    echo 0xb251024  1 > $DCC_PATH/config
    echo 0xb251030  1 > $DCC_PATH/config
    echo 0xb251200  1 > $DCC_PATH/config
    echo 0xb251214  1 > $DCC_PATH/config
    echo 0xb251228  1 > $DCC_PATH/config
    echo 0xb25123c  1 > $DCC_PATH/config
    echo 0xb251250  1 > $DCC_PATH/config
    echo 0xb251204  1 > $DCC_PATH/config
    echo 0xb251218  1 > $DCC_PATH/config
    echo 0xb25122c  1 > $DCC_PATH/config
    echo 0xb251240  1 > $DCC_PATH/config
    echo 0xb251254  1 > $DCC_PATH/config
    echo 0xb251208  1 > $DCC_PATH/config
    echo 0xb25121c  1 > $DCC_PATH/config
    echo 0xb251230  1 > $DCC_PATH/config
    echo 0xb251244  1 > $DCC_PATH/config
    echo 0xb251258  1 > $DCC_PATH/config
    echo 0xb254520  1 > $DCC_PATH/config
    echo 0xb254510  1 > $DCC_PATH/config
    echo 0xb254514  1 > $DCC_PATH/config

}
config_sdm710_dcc_rscc_modem()
{
    #RSCC
    echo 0x420000c 1 > $DCC_PATH/config
    echo 0x4200d00 1 > $DCC_PATH/config
    echo 0x4200d04 1 > $DCC_PATH/config
    echo 0x4201254 1 > $DCC_PATH/config
    echo 0x4201258 1 > $DCC_PATH/config
    echo 0x420125c 1 > $DCC_PATH/config
    echo 0x4201274 1 > $DCC_PATH/config
    echo 0x4201278 1 > $DCC_PATH/config
    echo 0x4201288 1 > $DCC_PATH/config
    echo 0x420128c 1 > $DCC_PATH/config
    echo 0x420129c 1 > $DCC_PATH/config
    echo 0x42012a0 1 > $DCC_PATH/config
    echo 0x42012b0 1 > $DCC_PATH/config
    echo 0x42012b4 1 > $DCC_PATH/config
    echo 0x42012c4 1 > $DCC_PATH/config
    echo 0x42012c8 1 > $DCC_PATH/config
    echo 0x42012d8 1 > $DCC_PATH/config
    echo 0x42012dc 1 > $DCC_PATH/config
    echo 0x42012ec 1 > $DCC_PATH/config
    echo 0x42012f0 1 > $DCC_PATH/config
    echo 0x4201300 1 > $DCC_PATH/config
    echo 0x4201304 1 > $DCC_PATH/config
    echo 0x4201314 1 > $DCC_PATH/config
    echo 0x4201318 1 > $DCC_PATH/config
    echo 0x4201328 1 > $DCC_PATH/config
    echo 0x420132c 1 > $DCC_PATH/config
    echo 0x420133c 1 > $DCC_PATH/config
    echo 0x4201340 1 > $DCC_PATH/config
    echo 0x4201350 1 > $DCC_PATH/config
    echo 0x4201354 1 > $DCC_PATH/config
    echo 0x4201364 1 > $DCC_PATH/config
    echo 0x4201368 1 > $DCC_PATH/config
    echo 0x4201378 1 > $DCC_PATH/config
    echo 0x420137c 1 > $DCC_PATH/config
    echo 0x420138c 1 > $DCC_PATH/config
    echo 0x4201390 1 > $DCC_PATH/config
    echo 0x42013a0 1 > $DCC_PATH/config
    echo 0x42013a4 1 > $DCC_PATH/config
    echo 0x42014f4 1 > $DCC_PATH/config
    echo 0x42014f8 1 > $DCC_PATH/config
    echo 0x42014fc 1 > $DCC_PATH/config
    echo 0x4201514 1 > $DCC_PATH/config
    echo 0x4201518 1 > $DCC_PATH/config
    echo 0x4201528 1 > $DCC_PATH/config
    echo 0x420152c 1 > $DCC_PATH/config
    echo 0x420153c 1 > $DCC_PATH/config
    echo 0x4201540 1 > $DCC_PATH/config
    echo 0x4201550 1 > $DCC_PATH/config
    echo 0x4201554 1 > $DCC_PATH/config
    echo 0x4201564 1 > $DCC_PATH/config
    echo 0x4201568 1 > $DCC_PATH/config
    echo 0x4201578 1 > $DCC_PATH/config
    echo 0x420157c 1 > $DCC_PATH/config
    echo 0x420158c 1 > $DCC_PATH/config
    echo 0x4201590 1 > $DCC_PATH/config
    echo 0x42015a0 1 > $DCC_PATH/config
    echo 0x42015a4 1 > $DCC_PATH/config
    echo 0x42015b4 1 > $DCC_PATH/config
    echo 0x42015b8 1 > $DCC_PATH/config
    echo 0x42015c8 1 > $DCC_PATH/config
    echo 0x42015cc 1 > $DCC_PATH/config
    echo 0x42015dc 1 > $DCC_PATH/config
    echo 0x42015e0 1 > $DCC_PATH/config
    echo 0x42015f0 1 > $DCC_PATH/config
    echo 0x42015f4 1 > $DCC_PATH/config
    echo 0x4201604 1 > $DCC_PATH/config
    echo 0x4201608 1 > $DCC_PATH/config
    echo 0x4201618 1 > $DCC_PATH/config
    echo 0x420161c 1 > $DCC_PATH/config
    echo 0x420162c 1 > $DCC_PATH/config
    echo 0x4201630 1 > $DCC_PATH/config
    echo 0x4201640 1 > $DCC_PATH/config
    echo 0x4201644 1 > $DCC_PATH/config
    echo 0x4201794 1 > $DCC_PATH/config
    echo 0x4201798 1 > $DCC_PATH/config
    echo 0x420179c 1 > $DCC_PATH/config
    echo 0x42017b4 1 > $DCC_PATH/config
    echo 0x42017b8 1 > $DCC_PATH/config
    echo 0x42017c8 1 > $DCC_PATH/config
    echo 0x42017cc 1 > $DCC_PATH/config
    echo 0x42017dc 1 > $DCC_PATH/config
    echo 0x42017e0 1 > $DCC_PATH/config
    echo 0x42017f0 1 > $DCC_PATH/config
    echo 0x42017f4 1 > $DCC_PATH/config
    echo 0x4201804 1 > $DCC_PATH/config
    echo 0x4201808 1 > $DCC_PATH/config
    echo 0x4201818 1 > $DCC_PATH/config
    echo 0x420181c 1 > $DCC_PATH/config
    echo 0x420182c 1 > $DCC_PATH/config
    echo 0x4201830 1 > $DCC_PATH/config
    echo 0x4201840 1 > $DCC_PATH/config
    echo 0x4201844 1 > $DCC_PATH/config
    echo 0x4201854 1 > $DCC_PATH/config
    echo 0x4201858 1 > $DCC_PATH/config
    echo 0x4201868 1 > $DCC_PATH/config
    echo 0x420186c 1 > $DCC_PATH/config
    echo 0x420187c 1 > $DCC_PATH/config
    echo 0x4201880 1 > $DCC_PATH/config
    echo 0x4201890 1 > $DCC_PATH/config
    echo 0x4201894 1 > $DCC_PATH/config
    echo 0x42018a4 1 > $DCC_PATH/config
    echo 0x42018a8 1 > $DCC_PATH/config
    echo 0x42018b8 1 > $DCC_PATH/config
    echo 0x42018bc 1 > $DCC_PATH/config
    echo 0x42018cc 1 > $DCC_PATH/config
    echo 0x42018d0 1 > $DCC_PATH/config
    echo 0x42018e0 1 > $DCC_PATH/config
    echo 0x42018e4 1 > $DCC_PATH/config
    echo 0x4201a34 1 > $DCC_PATH/config
    echo 0x4201a38 1 > $DCC_PATH/config
    echo 0x4201a3c 1 > $DCC_PATH/config
    echo 0x4201a54 1 > $DCC_PATH/config
    echo 0x4201a58 1 > $DCC_PATH/config
    echo 0x4201a68 1 > $DCC_PATH/config
    echo 0x4201a6c 1 > $DCC_PATH/config
    echo 0x4201a7c 1 > $DCC_PATH/config
    echo 0x4201a80 1 > $DCC_PATH/config
    echo 0x4201a90 1 > $DCC_PATH/config
    echo 0x4201a94 1 > $DCC_PATH/config
    echo 0x4201aa4 1 > $DCC_PATH/config
    echo 0x4201aa8 1 > $DCC_PATH/config
    echo 0x4201ab8 1 > $DCC_PATH/config
    echo 0x4201abc 1 > $DCC_PATH/config
    echo 0x4201acc 1 > $DCC_PATH/config
    echo 0x4201ad0 1 > $DCC_PATH/config
    echo 0x4201ae0 1 > $DCC_PATH/config
    echo 0x4201ae4 1 > $DCC_PATH/config
    echo 0x4201af4 1 > $DCC_PATH/config
    echo 0x4201af8 1 > $DCC_PATH/config
    echo 0x4201b08 1 > $DCC_PATH/config
    echo 0x4201b0c 1 > $DCC_PATH/config
    echo 0x4201b1c 1 > $DCC_PATH/config
    echo 0x4201b20 1 > $DCC_PATH/config
    echo 0x4201b30 1 > $DCC_PATH/config
    echo 0x4201b34 1 > $DCC_PATH/config
    echo 0x4201b44 1 > $DCC_PATH/config
    echo 0x4201b48 1 > $DCC_PATH/config
    echo 0x4201b58 1 > $DCC_PATH/config
    echo 0x4201b5c 1 > $DCC_PATH/config
    echo 0x4201b6c 1 > $DCC_PATH/config
    echo 0x4201b70 1 > $DCC_PATH/config
    echo 0x4201b80 1 > $DCC_PATH/config
    echo 0x4201b84 1 > $DCC_PATH/config
    #Modem registers debug
    echo 0x4130400  1 > $DCC_PATH/config
    echo 0x4130404  1 > $DCC_PATH/config
    echo 0x4130408  1 > $DCC_PATH/config
    echo 0x4200400  1 > $DCC_PATH/config
    echo 0x4200404  1 > $DCC_PATH/config
    echo 0x4200408  1 > $DCC_PATH/config
    echo 0x4200024  1 > $DCC_PATH/config
    echo 0x4200028  1 > $DCC_PATH/config
    echo 0xB2B4520  1 > $DCC_PATH/config
    echo 0xB2B4524  1 > $DCC_PATH/config
    echo 0xB2B4510  1 > $DCC_PATH/config
    echo 0xB2B4514  1 > $DCC_PATH/config
    echo 0xB2B1020  1 > $DCC_PATH/config
    echo 0xB2B1024  1 > $DCC_PATH/config
    echo 0xB2B1030  1 > $DCC_PATH/config

}
config_sdm710_dcc_rscc_cdsp()
{
    #RSCC
    echo 0x80a400c 1 > $DCC_PATH/config
    echo 0x80a4d00 1 > $DCC_PATH/config
    echo 0x80a4d04 1 > $DCC_PATH/config
    echo 0x80a5254 1 > $DCC_PATH/config
    echo 0x80a5258 1 > $DCC_PATH/config
    echo 0x80a525c 1 > $DCC_PATH/config
    echo 0x80a5274 1 > $DCC_PATH/config
    echo 0x80a5278 1 > $DCC_PATH/config
    echo 0x80a5288 1 > $DCC_PATH/config
    echo 0x80a528c 1 > $DCC_PATH/config
    echo 0x80a529c 1 > $DCC_PATH/config
    echo 0x80a52a0 1 > $DCC_PATH/config
    echo 0x80a52b0 1 > $DCC_PATH/config
    echo 0x80a52b4 1 > $DCC_PATH/config
    echo 0x80a52c4 1 > $DCC_PATH/config
    echo 0x80a52c8 1 > $DCC_PATH/config
    echo 0x80a52d8 1 > $DCC_PATH/config
    echo 0x80a52dc 1 > $DCC_PATH/config
    echo 0x80a52ec 1 > $DCC_PATH/config
    echo 0x80a52f0 1 > $DCC_PATH/config
    echo 0x80a5300 1 > $DCC_PATH/config
    echo 0x80a5304 1 > $DCC_PATH/config
    echo 0x80a5314 1 > $DCC_PATH/config
    echo 0x80a5318 1 > $DCC_PATH/config
    echo 0x80a5328 1 > $DCC_PATH/config
    echo 0x80a532c 1 > $DCC_PATH/config
    echo 0x80a533c 1 > $DCC_PATH/config
    echo 0x80a5340 1 > $DCC_PATH/config
    echo 0x80a5350 1 > $DCC_PATH/config
    echo 0x80a5354 1 > $DCC_PATH/config
    echo 0x80a54f4 1 > $DCC_PATH/config
    echo 0x80a54f8 1 > $DCC_PATH/config
    echo 0x80a54fc 1 > $DCC_PATH/config
    echo 0x80a5514 1 > $DCC_PATH/config
    echo 0x80a5518 1 > $DCC_PATH/config
    echo 0x80a5528 1 > $DCC_PATH/config
    echo 0x80a552c 1 > $DCC_PATH/config
    echo 0x80a553c 1 > $DCC_PATH/config
    echo 0x80a5540 1 > $DCC_PATH/config
    echo 0x80a5550 1 > $DCC_PATH/config
    echo 0x80a5554 1 > $DCC_PATH/config
    echo 0x80a5564 1 > $DCC_PATH/config
    echo 0x80a5568 1 > $DCC_PATH/config
    echo 0x80a5578 1 > $DCC_PATH/config
    echo 0x80a557c 1 > $DCC_PATH/config
    echo 0x80a558c 1 > $DCC_PATH/config
    echo 0x80a5590 1 > $DCC_PATH/config
    echo 0x80a55a0 1 > $DCC_PATH/config
    echo 0x80a55a4 1 > $DCC_PATH/config
    echo 0x80a55b4 1 > $DCC_PATH/config
    echo 0x80a55b8 1 > $DCC_PATH/config
    echo 0x80a55c8 1 > $DCC_PATH/config
    echo 0x80a55cc 1 > $DCC_PATH/config
    echo 0x80a55dc 1 > $DCC_PATH/config
    echo 0x80a55e0 1 > $DCC_PATH/config
    echo 0x80a55f0 1 > $DCC_PATH/config
    echo 0x80a55f4 1 > $DCC_PATH/config
}
config_sdm710_dcc_pdc_display()
{
    #PDC Display
    echo 0x0B291020 1 > $DCC_PATH/config
    echo 0x0B291024 1 > $DCC_PATH/config
    echo 0x0B254520 1 > $DCC_PATH/config
    echo 0x0B291030 1 > $DCC_PATH/config
    echo 0x0B291200 1 > $DCC_PATH/config
    echo 0x0B291214 1 > $DCC_PATH/config
    echo 0x0B291228 1 > $DCC_PATH/config
    echo 0x0B29123C 1 > $DCC_PATH/config
    echo 0x0B291250 1 > $DCC_PATH/config
    echo 0x0B291204 1 > $DCC_PATH/config
    echo 0x0B291218 1 > $DCC_PATH/config
    echo 0x0B29122C 1 > $DCC_PATH/config
    echo 0x0B291240 1 > $DCC_PATH/config
    echo 0x0B291254 1 > $DCC_PATH/config
    echo 0x0B291208 1 > $DCC_PATH/config
    echo 0x0B29121C 1 > $DCC_PATH/config
    echo 0x0B291230 1 > $DCC_PATH/config
    echo 0x0B291244 1 > $DCC_PATH/config
    echo 0x0B291258 1 > $DCC_PATH/config
    echo 0x0B294510 1 > $DCC_PATH/config
    echo 0x0B294514 1 > $DCC_PATH/config
}
config_sdm710_dcc_aop_rpmh()
{
    #PDC AOP
    echo 0x0B264520 1 > $DCC_PATH/config
    echo 0x0B261020 1 > $DCC_PATH/config
    echo 0x0B261024 1 > $DCC_PATH/config
    echo 0x0B261030 1 > $DCC_PATH/config
    echo 0x0B261200 1 > $DCC_PATH/config
    echo 0x0B261214 1 > $DCC_PATH/config
    echo 0x0B261228 1 > $DCC_PATH/config
    echo 0x0B26123C 1 > $DCC_PATH/config
    echo 0x0B261250 1 > $DCC_PATH/config
    echo 0x0B261204 1 > $DCC_PATH/config
    echo 0x0B261218 1 > $DCC_PATH/config
    echo 0x0B26122C 1 > $DCC_PATH/config
    echo 0x0B261240 1 > $DCC_PATH/config
    echo 0x0B261254 1 > $DCC_PATH/config
    echo 0x0B261208 1 > $DCC_PATH/config
    echo 0x0B26121C 1 > $DCC_PATH/config
    echo 0x0B261230 1 > $DCC_PATH/config
    echo 0x0B261244 1 > $DCC_PATH/config
    echo 0x0B261258 1 > $DCC_PATH/config
    echo 0x0B264510 1 > $DCC_PATH/config
    echo 0x0B264514 1 > $DCC_PATH/config
    echo 0x0B260900 1 > $DCC_PATH/config
    echo 0x0B260010 1 > $DCC_PATH/config
    #ARC RPMH
    echo 0x0B7E4500 1 > $DCC_PATH/config
    echo 0x0BBF0880 1 > $DCC_PATH/config
    echo 0x0B600008 1 > $DCC_PATH/config
    echo 0x0B7E0100 1 > $DCC_PATH/config
    echo 0x0B7E0140 1 > $DCC_PATH/config
    echo 0x0B7E0180 1 > $DCC_PATH/config
    echo 0x0B7E01C0 1 > $DCC_PATH/config
    echo 0x0B7EE040 1 > $DCC_PATH/config
    echo 0x0B7EE040 1 > $DCC_PATH/config
    #CRPF RPMH
    echo 0x0C201004 1 > $DCC_PATH/config
    echo 0x0C202004 1 > $DCC_PATH/config
    echo 0x0C203004 1 > $DCC_PATH/config
    echo 0x0C204004 1 > $DCC_PATH/config
    echo 0x0C205004 1 > $DCC_PATH/config
    echo 0x0C206004 1 > $DCC_PATH/config
    echo 0x0C207004 1 > $DCC_PATH/config
    echo 0x0C201118 1 > $DCC_PATH/config
    echo 0x0C202118 1 > $DCC_PATH/config
    echo 0x0C203118 1 > $DCC_PATH/config
    echo 0x0C204118 1 > $DCC_PATH/config
    echo 0x0C205118 1 > $DCC_PATH/config
    echo 0x0C206118 1 > $DCC_PATH/config
    echo 0x0C207118 1 > $DCC_PATH/config
    echo 0x0C201230 1 > $DCC_PATH/config
    echo 0x0C202230 1 > $DCC_PATH/config
    echo 0x0C203230 1 > $DCC_PATH/config
    echo 0x0C204230 1 > $DCC_PATH/config
    echo 0x0C205230 1 > $DCC_PATH/config
    echo 0x0C206230 1 > $DCC_PATH/config
    echo 0x0C207230 1 > $DCC_PATH/config
    echo 0x0C203244 1 > $DCC_PATH/config
    echo 0x0C204244 1 > $DCC_PATH/config
    echo 0x0C205244 1 > $DCC_PATH/config
    echo 0x0C206244 1 > $DCC_PATH/config
    echo 0x0C207244 1 > $DCC_PATH/config
    echo 0x0C20F000 1 > $DCC_PATH/config
}
config_sdm710_dcc_lmh()
{
    #LMH-Gold Thermal
    echo 0x17D91008 1 > $DCC_PATH/config
    echo 0x17D91018 1 > $DCC_PATH/config
    echo 0x17D91038 1 > $DCC_PATH/config
    echo 0x17D910C0 1 > $DCC_PATH/config
    echo 0x17D910C4 1 > $DCC_PATH/config
    echo 0x17D910C8 1 > $DCC_PATH/config
    echo 0x17D910CC 1 > $DCC_PATH/config
    echo 0x17D91810 1 > $DCC_PATH/config
    echo 0x17D91814 1 > $DCC_PATH/config
    echo 0x17D9181C 1 > $DCC_PATH/config
    echo 0x17D91820 1 > $DCC_PATH/config
    echo 0x17D91830 1 > $DCC_PATH/config
    echo 0x17D91900 1 > $DCC_PATH/config
    echo 0x17D9193C 1 > $DCC_PATH/config
    echo 0x17D91A00 1 > $DCC_PATH/config
    echo 0x17D91BC0 1 > $DCC_PATH/config
    #LMH-Silver Thermal
    echo 0x17D99008 1 > $DCC_PATH/config
    echo 0x17D99018 1 > $DCC_PATH/config
    echo 0x17D990C0 1 > $DCC_PATH/config
    echo 0x17D990C4 1 > $DCC_PATH/config
    echo 0x17D990C8 1 > $DCC_PATH/config
    echo 0x17D990CC 1 > $DCC_PATH/config
    echo 0x17D99814 1 > $DCC_PATH/config
    echo 0x17D9981C 1 > $DCC_PATH/config
    echo 0x17D99820 1 > $DCC_PATH/config
    echo 0x17D99900 1 > $DCC_PATH/config
    echo 0x17D9993C 1 > $DCC_PATH/config
    echo 0x17D99A00 1 > $DCC_PATH/config
    echo 0x17D99BC0 1 > $DCC_PATH/config
    #LMH-Isense
    echo 0x17870000 1 > $DCC_PATH/config
    echo 0x17870108 1 > $DCC_PATH/config
    echo 0x17870710 1 > $DCC_PATH/config
    echo 0x17870730 1 > $DCC_PATH/config
    echo 0x17871480 1 > $DCC_PATH/config
 }
 config_sdm710_dcc_ipm_apps()
 {
    #LLCC
    echo 0x01301000 1 > $DCC_PATH/config
    echo 0x01301004 1 > $DCC_PATH/config
    #IPM APPS
    echo 0x1781012C 4 > $DCC_PATH/config
    echo 0x17E00048 2 > $DCC_PATH/config
    echo 0x17E10048 2 > $DCC_PATH/config
    echo 0x17E20048 2 > $DCC_PATH/config
    echo 0x17E30048 2 > $DCC_PATH/config
    echo 0x17E40048 2 > $DCC_PATH/config
    echo 0x17E50048 2 > $DCC_PATH/config
    echo 0x17E60048 2 > $DCC_PATH/config
    echo 0x17E70048 2 > $DCC_PATH/config
    echo 0x17810048 2 > $DCC_PATH/config
    echo 0x17990044 1 > $DCC_PATH/config
}
config_sdm710_dcc_osm()
{
    #OSM
    echo 0x17D45F00 1 > $DCC_PATH/config
    echo 0x17D45F08 1 > $DCC_PATH/config
    echo 0x17D45F0C 1 > $DCC_PATH/config
    echo 0x17D45F10 1 > $DCC_PATH/config
    echo 0x17D45F14 1 > $DCC_PATH/config
    echo 0x17D45F18 1 > $DCC_PATH/config
    echo 0x17D45F1C 1 > $DCC_PATH/config
    echo 0x17D45F80 1 > $DCC_PATH/config
    echo 0x17D47418 1 > $DCC_PATH/config
    echo 0x17D47570 1 > $DCC_PATH/config
    echo 0x17D47588 1 > $DCC_PATH/config
    echo 0x17D43700 1 > $DCC_PATH/config
    echo 0x17D43708 1 > $DCC_PATH/config
    echo 0x17D4370C 1 > $DCC_PATH/config
    echo 0x17D43710 1 > $DCC_PATH/config
    echo 0x17D43714 1 > $DCC_PATH/config
    echo 0x17D43718 1 > $DCC_PATH/config
    echo 0x17D4371C 1 > $DCC_PATH/config
    echo 0x17D43780 1 > $DCC_PATH/config
    echo 0x17D44C18 1 > $DCC_PATH/config
    echo 0x17D44D70 1 > $DCC_PATH/config
    echo 0x17D44D88 1 > $DCC_PATH/config
    echo 0x17D41700 1 > $DCC_PATH/config
    echo 0x17D41708 1 > $DCC_PATH/config
    echo 0x17D4170C 1 > $DCC_PATH/config
    echo 0x17D41710 1 > $DCC_PATH/config
    echo 0x17D41714 1 > $DCC_PATH/config
    echo 0x17D41718 1 > $DCC_PATH/config
    echo 0x17D4171C 1 > $DCC_PATH/config
    echo 0x17D41780 1 > $DCC_PATH/config
    echo 0x17D42C18 1 > $DCC_PATH/config
    echo 0x17D42D70 1 > $DCC_PATH/config
    echo 0x17D42D88 1 > $DCC_PATH/config
}

config_sdm710_dcc_shrm()
{
    #SHRM DDR
    echo 0x069EA00C 0x00600007 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x00136800 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x00136810 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x00136820 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x00136830 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x00136840 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x00136850 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x00136860 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x00136870 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003e9a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003c0a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003d1a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003d2a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003d5a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003d6a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003b1a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003b2a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003b5a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003b6a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003c2a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003c5a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003c6a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x00f1e000 1 > $DCC_PATH/config_write
    echo 0x069EA008 0x00000007 1 > $DCC_PATH/config_write
    echo 0x013E7E00 31 > $DCC_PATH/config
}
config_sdm710_dcc_ddr()
{
   # DDR_SS
    echo 0x01132100 1 > $DCC_PATH/config
    echo 0x01136044 1 > $DCC_PATH/config
    echo 0x01136048 1 > $DCC_PATH/config
    echo 0x0113604C 1 > $DCC_PATH/config
    echo 0x01136050 1 > $DCC_PATH/config
    echo 0x011360B0 1 > $DCC_PATH/config
    echo 0x0113e030 1 > $DCC_PATH/config
    echo 0x0113e034 1 > $DCC_PATH/config
    echo 0x01141000 1 > $DCC_PATH/config
    echo 0x01160410 1 > $DCC_PATH/config
    echo 0x01160414 1 > $DCC_PATH/config
    echo 0x01160418 1 > $DCC_PATH/config
    echo 0x011604A0 1 > $DCC_PATH/config
    echo 0x011604B8 1 > $DCC_PATH/config
    echo 0x011B2100 1 > $DCC_PATH/config
    echo 0x011B6044 1 > $DCC_PATH/config
    echo 0x011B6048 1 > $DCC_PATH/config
    echo 0x011B604C 1 > $DCC_PATH/config
    echo 0x011B6050 1 > $DCC_PATH/config
    echo 0x011B60B0 1 > $DCC_PATH/config
    echo 0x011be030 1 > $DCC_PATH/config
    echo 0x011be034 1 > $DCC_PATH/config
    echo 0x011C1000 1 > $DCC_PATH/config
    echo 0x011E0410 1 > $DCC_PATH/config
    echo 0x011E0414 1 > $DCC_PATH/config
    echo 0x011E0418 1 > $DCC_PATH/config
    echo 0x011E04A0 1 > $DCC_PATH/config
    echo 0x011E04B8 1 > $DCC_PATH/config
    echo 0x011e5804 1 > $DCC_PATH/config
    # DDR_SS Repeat
    echo 0x01132100 1 > $DCC_PATH/config
    echo 0x01136044 1 > $DCC_PATH/config
    echo 0x01136048 1 > $DCC_PATH/config
    echo 0x0113604C 1 > $DCC_PATH/config
    echo 0x01136050 1 > $DCC_PATH/config
    echo 0x011360B0 1 > $DCC_PATH/config
    echo 0x0113e030 1 > $DCC_PATH/config
    echo 0x0113e034 1 > $DCC_PATH/config
    echo 0x01141000 1 > $DCC_PATH/config
    echo 0x01160410 1 > $DCC_PATH/config
    echo 0x01160414 1 > $DCC_PATH/config
    echo 0x01160418 1 > $DCC_PATH/config
    echo 0x011604A0 1 > $DCC_PATH/config
    echo 0x011604B8 1 > $DCC_PATH/config
    echo 0x011B2100 1 > $DCC_PATH/config
    echo 0x011B6044 1 > $DCC_PATH/config
    echo 0x011B6048 1 > $DCC_PATH/config
    echo 0x011B604C 1 > $DCC_PATH/config
    echo 0x011B6050 1 > $DCC_PATH/config
    echo 0x011B60B0 1 > $DCC_PATH/config
    echo 0x011be030 1 > $DCC_PATH/config
    echo 0x011be034 1 > $DCC_PATH/config
    echo 0x011C1000 1 > $DCC_PATH/config
    echo 0x011E0410 1 > $DCC_PATH/config
    echo 0x011E0414 1 > $DCC_PATH/config
    echo 0x011E0418 1 > $DCC_PATH/config
    echo 0x011E04A0 1 > $DCC_PATH/config
    echo 0x011E04B8 1 > $DCC_PATH/config
    echo 0x011e5804 1 > $DCC_PATH/config
}

config_sdm710_dcc_ecc_llc()
{
    #LLC
    echo 0x1120344 1 > $DCC_PATH/config
    echo 0x1120348 1 > $DCC_PATH/config
    echo 0x112034C 1 > $DCC_PATH/config
    echo 0x1120350 1 > $DCC_PATH/config
    echo 0x1120354 1 > $DCC_PATH/config
    echo 0x1120358 1 > $DCC_PATH/config
    echo 0x112035C 1 > $DCC_PATH/config
    echo 0x1120360 1 > $DCC_PATH/config
    echo 0x1120370 1 > $DCC_PATH/config
    echo 0x1120374 1 > $DCC_PATH/config
    echo 0x1120378 1 > $DCC_PATH/config
    echo 0x112037C 1 > $DCC_PATH/config
    echo 0x1120380 1 > $DCC_PATH/config
    echo 0x1120384 1 > $DCC_PATH/config
    echo 0x1120480 1 > $DCC_PATH/config
    echo 0x1142044 1 > $DCC_PATH/config
    echo 0x1142048 1 > $DCC_PATH/config
    echo 0x114204C 1 > $DCC_PATH/config
    echo 0x1142050 1 > $DCC_PATH/config
    echo 0x1142054 1 > $DCC_PATH/config
    echo 0x1142058 1 > $DCC_PATH/config
    echo 0x114205C 1 > $DCC_PATH/config
    echo 0x1142060 1 > $DCC_PATH/config
    echo 0x1142064 1 > $DCC_PATH/config
    echo 0x1142068 1 > $DCC_PATH/config
    echo 0x1142070 1 > $DCC_PATH/config
    echo 0x1142074 1 > $DCC_PATH/config
    echo 0x1142078 1 > $DCC_PATH/config
    echo 0x114207C 1 > $DCC_PATH/config
    echo 0x1142080 1 > $DCC_PATH/config
    echo 0x1142084 1 > $DCC_PATH/config
    echo 0x1142088 1 > $DCC_PATH/config
    echo 0x114208C 1 > $DCC_PATH/config
    echo 0x11A0344 1 > $DCC_PATH/config
    echo 0x11A0348 1 > $DCC_PATH/config
    echo 0x11A034C 1 > $DCC_PATH/config
    echo 0x11A0350 1 > $DCC_PATH/config
    echo 0x11A0354 1 > $DCC_PATH/config
    echo 0x11A0358 1 > $DCC_PATH/config
    echo 0x11A035C 1 > $DCC_PATH/config
    echo 0x11A0360 1 > $DCC_PATH/config
    echo 0x11A0370 1 > $DCC_PATH/config
    echo 0x11A0374 1 > $DCC_PATH/config
    echo 0x11A0378 1 > $DCC_PATH/config
    echo 0x11A037C 1 > $DCC_PATH/config
    echo 0x11A0380 1 > $DCC_PATH/config
    echo 0x11A0384 1 > $DCC_PATH/config
    echo 0x11A0480 1 > $DCC_PATH/config
    echo 0x11C2044 1 > $DCC_PATH/config
    echo 0x11C2048 1 > $DCC_PATH/config
    echo 0x11C204C 1 > $DCC_PATH/config
    echo 0x11C2050 1 > $DCC_PATH/config
    echo 0x11C2054 1 > $DCC_PATH/config
    echo 0x11C2058 1 > $DCC_PATH/config
    echo 0x11C205C 1 > $DCC_PATH/config
    echo 0x11C2060 1 > $DCC_PATH/config
    echo 0x11C2064 1 > $DCC_PATH/config
    echo 0x11C2068 1 > $DCC_PATH/config
    echo 0x11C2070 1 > $DCC_PATH/config
    echo 0x11C2074 1 > $DCC_PATH/config
    echo 0x11C2078 1 > $DCC_PATH/config
    echo 0x11C207C 1 > $DCC_PATH/config
    echo 0x11C2080 1 > $DCC_PATH/config
    echo 0x11C2084 1 > $DCC_PATH/config
    echo 0x11C2088 1 > $DCC_PATH/config
    echo 0x11C208C 1 > $DCC_PATH/config
    echo 0x1220344 1 > $DCC_PATH/config
    echo 0x1220348 1 > $DCC_PATH/config
    echo 0x122034C 1 > $DCC_PATH/config
    echo 0x1220350 1 > $DCC_PATH/config
    echo 0x1220354 1 > $DCC_PATH/config
    echo 0x1220358 1 > $DCC_PATH/config
    echo 0x122035C 1 > $DCC_PATH/config
    echo 0x1220360 1 > $DCC_PATH/config
    echo 0x1220370 1 > $DCC_PATH/config
    echo 0x1220374 1 > $DCC_PATH/config
    echo 0x1220378 1 > $DCC_PATH/config
    echo 0x122037C 1 > $DCC_PATH/config
    echo 0x1220380 1 > $DCC_PATH/config
    echo 0x1220384 1 > $DCC_PATH/config
    echo 0x1220480 1 > $DCC_PATH/config
    echo 0x1242044 1 > $DCC_PATH/config
    echo 0x1242048 1 > $DCC_PATH/config
    echo 0x124204C 1 > $DCC_PATH/config
    echo 0x1242050 1 > $DCC_PATH/config
    echo 0x1242054 1 > $DCC_PATH/config
    echo 0x1242058 1 > $DCC_PATH/config
    echo 0x124205C 1 > $DCC_PATH/config
    echo 0x1242060 1 > $DCC_PATH/config
    echo 0x1242064 1 > $DCC_PATH/config
    echo 0x1242068 1 > $DCC_PATH/config
    echo 0x1242070 1 > $DCC_PATH/config
    echo 0x1242074 1 > $DCC_PATH/config
    echo 0x1242078 1 > $DCC_PATH/config
    echo 0x124207C 1 > $DCC_PATH/config
    echo 0x1242080 1 > $DCC_PATH/config
    echo 0x1242084 1 > $DCC_PATH/config
    echo 0x1242088 1 > $DCC_PATH/config
    echo 0x124208C 1 > $DCC_PATH/config
    echo 0x12A0344 1 > $DCC_PATH/config
    echo 0x12A0348 1 > $DCC_PATH/config
    echo 0x12A034C 1 > $DCC_PATH/config
    echo 0x12A0350 1 > $DCC_PATH/config
    echo 0x12A0354 1 > $DCC_PATH/config
    echo 0x12A0358 1 > $DCC_PATH/config
    echo 0x12A035C 1 > $DCC_PATH/config
    echo 0x12A0360 1 > $DCC_PATH/config
    echo 0x12A0370 1 > $DCC_PATH/config
    echo 0x12A0374 1 > $DCC_PATH/config
    echo 0x12A0378 1 > $DCC_PATH/config
    echo 0x12A037C 1 > $DCC_PATH/config
    echo 0x12A0380 1 > $DCC_PATH/config
    echo 0x12A0384 1 > $DCC_PATH/config
    echo 0x12A0480 1 > $DCC_PATH/config
    echo 0x12C2044 1 > $DCC_PATH/config
    echo 0x12C2048 1 > $DCC_PATH/config
    echo 0x12C204C 1 > $DCC_PATH/config
    echo 0x12C2050 1 > $DCC_PATH/config
    echo 0x12C2054 1 > $DCC_PATH/config
    echo 0x12C2058 1 > $DCC_PATH/config
    echo 0x12C205C 1 > $DCC_PATH/config
    echo 0x12C2060 1 > $DCC_PATH/config
    echo 0x12C2064 1 > $DCC_PATH/config
    echo 0x12C2068 1 > $DCC_PATH/config
    echo 0x12C2070 1 > $DCC_PATH/config
    echo 0x12C2074 1 > $DCC_PATH/config
    echo 0x12C2078 1 > $DCC_PATH/config
    echo 0x12C207C 1 > $DCC_PATH/config
    echo 0x12C2080 1 > $DCC_PATH/config
    echo 0x12C2084 1 > $DCC_PATH/config
    echo 0x12C2088 1 > $DCC_PATH/config
    echo 0x12C208C 1 > $DCC_PATH/config
}

config_sdm710_dcc_cabo_llcc_shrm()
{
    #CABO,LLCC,SHRM CSR & MEMNOC
    echo 0x1160080 1 > $DCC_PATH/config
    echo 0x1160404 1 > $DCC_PATH/config
    echo 0x1160424 1 > $DCC_PATH/config
    echo 0x1160430 1 > $DCC_PATH/config
    echo 0x11604b0 1 > $DCC_PATH/config
    echo 0x11604d4 1 > $DCC_PATH/config
    echo 0x1165920 1 > $DCC_PATH/config
    echo 0x1165924 1 > $DCC_PATH/config
    echo 0x1165928 1 > $DCC_PATH/config
    echo 0x116592c 1 > $DCC_PATH/config
    echo 0x1165b08 1 > $DCC_PATH/config
    echo 0x11e0080 1 > $DCC_PATH/config
    echo 0x11e0404 1 > $DCC_PATH/config
    echo 0x11e0424 1 > $DCC_PATH/config
    echo 0x11e0430 1 > $DCC_PATH/config
    echo 0x11e04b0 1 > $DCC_PATH/config
    echo 0x11e04d4 1 > $DCC_PATH/config
    echo 0x11e5920 1 > $DCC_PATH/config
    echo 0x11e5924 1 > $DCC_PATH/config
    echo 0x11e5928 1 > $DCC_PATH/config
    echo 0x11e592c 1 > $DCC_PATH/config
    echo 0x11e5b08 1 > $DCC_PATH/config
    echo 0x1122408 1 > $DCC_PATH/config
    echo 0x1136028 1 > $DCC_PATH/config
    echo 0x113602c 1 > $DCC_PATH/config
    echo 0x1136030 1 > $DCC_PATH/config
    echo 0x1136034 1 > $DCC_PATH/config
    echo 0x1136038 1 > $DCC_PATH/config
    echo 0x1141000 1 > $DCC_PATH/config
    echo 0x114a000 1 > $DCC_PATH/config
    echo 0x114b000 1 > $DCC_PATH/config
    echo 0x113201c 1 > $DCC_PATH/config
    echo 0x1132020 1 > $DCC_PATH/config
    echo 0x1132024 1 > $DCC_PATH/config
    echo 0x1132028 1 > $DCC_PATH/config
    echo 0x113202c 1 > $DCC_PATH/config
    echo 0x11a2408 1 > $DCC_PATH/config
    echo 0x11b6028 1 > $DCC_PATH/config
    echo 0x11b602c 1 > $DCC_PATH/config
    echo 0x11b6030 1 > $DCC_PATH/config
    echo 0x11b6034 1 > $DCC_PATH/config
    echo 0x11b6038 1 > $DCC_PATH/config
    echo 0x11c1000 1 > $DCC_PATH/config
    echo 0x11ca000 1 > $DCC_PATH/config
    echo 0x11cb000 1 > $DCC_PATH/config
    echo 0x11b201c 1 > $DCC_PATH/config
    echo 0x11b2020 1 > $DCC_PATH/config
    echo 0x11b2024 1 > $DCC_PATH/config
    echo 0x11b2028 1 > $DCC_PATH/config
    echo 0x11b202c 1 > $DCC_PATH/config
    echo 0x1430000 1 > $DCC_PATH/config
    echo 0x1430050 1 > $DCC_PATH/config
    echo 0xbc00208 1 > $DCC_PATH/config
    echo 0xbc00730 1 > $DCC_PATH/config
    echo 0x1380020 1 > $DCC_PATH/config
    echo 0x1380024 1 > $DCC_PATH/config
    echo 0x1380028 1 > $DCC_PATH/config
    echo 0x138002c 1 > $DCC_PATH/config
    echo 0x1380030 1 > $DCC_PATH/config
    echo 0x1380034 1 > $DCC_PATH/config
    echo 0x1380038 1 > $DCC_PATH/config
    echo 0x138003c 1 > $DCC_PATH/config
    echo 0x1380448 1 > $DCC_PATH/config
    echo 0x1390010 1 > $DCC_PATH/config
    echo 0x1392010 1 > $DCC_PATH/config
    echo 0x1393010 1 > $DCC_PATH/config
    echo 0x1394010 1 > $DCC_PATH/config
}
config_sdm710_shrm()
{
    echo 0x13d0008 > $DCC_PATH/config
    echo 0x13d0100 > $DCC_PATH/config
    echo 0x13d0104 > $DCC_PATH/config
    echo 0x13d0078 > $DCC_PATH/config
}
config_sdm710_memnoc_mccc()
{
   echo 0x1380900  1 > $DCC_PATH/config
   echo 0x1380904  1 > $DCC_PATH/config
   echo 0x1380908  1 > $DCC_PATH/config
   echo 0x138090c  1 > $DCC_PATH/config
   echo 0x1380910  1 > $DCC_PATH/config
   echo 0x1380914  1 > $DCC_PATH/config
   echo 0x1380918  1 > $DCC_PATH/config
   echo 0x138091c  1 > $DCC_PATH/config
   echo 0x1380d00  1 > $DCC_PATH/config
   echo 0x1380d04  1 > $DCC_PATH/config
   echo 0x1380d08  1 > $DCC_PATH/config
   echo 0x1380d0c  1 > $DCC_PATH/config
   echo 0x1380d10  1 > $DCC_PATH/config
   echo 0x1430280  1 > $DCC_PATH/config
   echo 0x1430288  1 > $DCC_PATH/config
   echo 0x143028c  1 > $DCC_PATH/config
   echo 0x1430290  1 > $DCC_PATH/config
   echo 0x1430294  1 > $DCC_PATH/config
   echo 0x1430298  1 > $DCC_PATH/config
   echo 0x143029c  1 > $DCC_PATH/config
   echo 0x14302a0  1 > $DCC_PATH/config

}
config_sdm710_dcc_cx_mx()
{
    #CX and MX voltage
    echo 0x0C201244 1 > $DCC_PATH/config
    echo 0x0C202244 1 > $DCC_PATH/config
}

config_sdm710_axi_pc()
{
    echo 0x07030200 2 > $DCC_PATH/config
    echo 0x07130200 2 > $DCC_PATH/config
    echo 0x07230200 2 > $DCC_PATH/config
    echo 0x07330200 2 > $DCC_PATH/config
    echo 0x07430200 2 > $DCC_PATH/config
    echo 0x07530200 2 > $DCC_PATH/config
    echo 0x07630200 2 > $DCC_PATH/config
    echo 0x07730200 2 > $DCC_PATH/config
}

config_sdm710_apb_pc()
{
    echo 0x87030200 2 1 > $DCC_PATH/config
    echo 0x87130200 2 1 > $DCC_PATH/config
    echo 0x87230200 2 1 > $DCC_PATH/config
    echo 0x87330200 2 1 > $DCC_PATH/config
    echo 0x87430200 2 1 > $DCC_PATH/config
    echo 0x87530200 2 1 > $DCC_PATH/config
    echo 0x87630200 2 1 > $DCC_PATH/config
    echo 0x87730200 2 1 > $DCC_PATH/config

}

# Function sdm710 DCC configuration
enable_sdm710_dcc_config()
{
    echo "enabling DCC config for sdm710"
    DCC_PATH="/sys/bus/platform/devices/10a2000.dcc_v2"

    if [ ! -d $DCC_PATH ]; then
        echo "DCC does not exist on this build."
        return
    fi

    echo 0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo 1 > $DCC_PATH/config_reset
    echo 2 > $DCC_PATH/curr_list
    config_sdm710_dcc_gladiator
    config_sdm710_dcc_noc_err_regs
    config_sdm710_shrm
    config_sdm710_dcc_cprh
    config_sdm710_dcc_pcu_rscc_apps
    config_sdm710_dcc_pdc_apps
    config_sdm710_dcc_rscc_lpass
    config_sdm710_dcc_rscc_modem
    config_sdm710_dcc_rscc_cdsp
    #config_sdm710_axi_pc
    #config_sdm710_apb_pc
    config_sdm710_memnoc_mccc
    #config_sdm710_dcc_pdc_display
    #config_sdm710_dcc_aop_rpmh
    #config_sdm710_dcc_lmh
    config_sdm710_dcc_ipm_apps
    config_sdm710_dcc_osm
    #config_sdm710_dcc_shrm
    config_sdm710_dcc_ddr
    #config_sdm710_dcc_ecc_llc
    config_sdm710_dcc_cabo_llcc_shrm
    config_sdm710_dcc_cx_mx
    config_sdm710_dcc_gcc_regs
    ## Enable below function with relaxed AC
    #config_sdm710_regs_no_ac
    #Apply configuration and enable DCC
    echo  1 > $DCC_PATH/enable
}


enable_sdm710_stm_hw_events()
{
   #TODO: Add HW events

}

enable_sdm710_core_hang_config()
{
    CORE_PATH_SILVER="/sys/devices/system/cpu/hang_detect_silver"
    CORE_PATH_GOLD="/sys/devices/system/cpu/hang_detect_gold"
    if [ ! -d $CORE_PATH ]; then
        echo "CORE hang does not exist on this build."
        return
    fi

    #set the threshold to around 100 milli-second
    echo 0x1d4c01 > $CORE_PATH_SILVER/threshold
    echo 0x1d4c01 > $CORE_PATH_GOLD/threshold

    #To the enable core hang detection
    echo 0x1 > $CORE_PATH_SILVER/enable
    echo 0x1 > $CORE_PATH_GOLD/enable
}

enable_sdm710_osm_wdog_status_config()
{
    echo 1 > /sys/kernel/debug/osm/pwrcl_clk/wdog_trace_enable
    echo 1 > /sys/kernel/debug/osm/perfcl_clk/wdog_trace_enable
}

enable_sdm710_gladiator_hang_config()
{
    GLADIATOR_PATH="/sys/devices/system/cpu/gladiator_hang_detect"
    if [ ! -d $GLADIATOR_PATH ]; then
        echo "Gladiator hang does not exist on this build."
        return
    fi

    #set the threshold to around 9 milli-second
    #echo 0x1d4c01 > $GLADIATOR_PATH/ace_threshold
    #echo 0x1d4c01 > $GLADIATOR_PATH/io_threshold
    #echo 0x1 > $GLADIATOR_PATH/ace_enable
    #echo 0x1 > $GLADIATOR_PATH/io_enable
    #echo 0x0002a300 > $GLADIATOR_PATH/m1_threshold
    #echo 0x0002a300 > $GLADIATOR_PATH/m2_threshold
    #echo 0x0002a300 > $GLADIATOR_PATH/pcio_threshold

    #To enable gladiator hang detection
    #echo 0x1 > /sys/devices/system/cpu/gladiator_hang_detect/enable
}

ftrace_disable=`getprop persist.debug.ftrace_events_disable`
srcenable="enable"
sinkenable="curr_sink"
enable_sdm710_debug()
{
    echo "sdm710 debug"
    enable_sdm710_dcc_config
    enable_sdm710_gladiator_hang_config
    enable_sdm710_osm_wdog_status_config
    enable_sdm710_core_hang_config
    enable_sdm710_stm
    if [ "$ftrace_disable" != "Yes" ]; then
        enable_sdm710_ftrace
    fi
    enable_sdm710_stm_hw_events
}
