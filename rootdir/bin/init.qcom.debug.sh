#! /vendor/bin/sh

# Copyright (c) 2014-2017, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

HERE=/vendor/bin
source $HERE/init.qcom.debug-sdm660.sh
source $HERE/init.qcom.debug-sdm710.sh
source $HERE/init.qti.debug-msmnile.sh
source $HERE/init.qti.debug-talos.sh
source $HERE/init.qti.debug-trinket.sh

enable_tracing_events()
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
enable_ftrace_event_tracing()
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

    enable_tracing_events
}

# function to enable ftrace event transfer to CoreSight STM
enable_stm_events()
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
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/$sinkenable
    echo 1 > /sys/bus/coresight/devices/coresight-stm/$srcenable
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
    enable_tracing_events
}

enable_sdm632_stm_events()
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
    echo 4096 > /sys/kernel/debug/tracing/buffer_size_kb
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/$sinkenable
    echo 1 > /sys/bus/coresight/devices/coresight-stm/$srcenable
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable

    # clock
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_set_rate/enable
    # power
    echo 1 > /sys/kernel/debug/tracing/events/msm_low_power/enable
    #cpufreq
    echo 1 > /sys/kernel/debug/tracing/events/power/cpu_frequency_switch_start/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/cpu_frequency_switch_end/enable
    # regulator
    echo 1 > /sys/kernel/debug/tracing/events/regulator/enable

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
    #thermal
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_core_offline/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_core_offline/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_core_online/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_core_online/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_frequency_mit/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_frequency_mit/enable
}

# Function SDM845 DCC configuration
enable_sdm845_dcc_config()
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
    echo 2 > $DCC_PATH/curr_list

    echo 0x00151004 1 > $DCC_PATH/config
    echo 0x1 0x1 > $DCC_PATH/rd_mod_wr
    echo 0x00151004 1 > $DCC_PATH/config
    echo 0x013E7E00 124 > $DCC_PATH/config

    #Use for address change between V1 vs V2
    if [ "$soc_version" -eq 20 ]
    then
        #V2
        echo 0x17D41920  > $DCC_PATH/config
        echo 0x17D43920  > $DCC_PATH/config
        echo 0x17D46120  > $DCC_PATH/config
    else
        #V1
        echo 0x17D41780 1 > $DCC_PATH/config
        echo 0x17D43780 1 > $DCC_PATH/config
        echo 0x17D45F80 1 > $DCC_PATH/config
    fi

    echo 0x01740300 6 > $DCC_PATH/config
    echo 0x01620500 4 > $DCC_PATH/config
    echo 0x01620700 5 > $DCC_PATH/config
    echo 0x7840000 1 > $DCC_PATH/config
    echo 0x7842500 1 > $DCC_PATH/config
    echo 0x7842504 1 > $DCC_PATH/config
    echo 0x7841010 12 > $DCC_PATH/config
    echo 0x7842000 16 > $DCC_PATH/config
    echo 7 > $DCC_PATH/loop
    echo 0x7841000 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    echo 165 > $DCC_PATH/loop
    echo 0x7841008 1 > $DCC_PATH/config
    echo 0x784100C 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop

    echo 0x17DC3A84 2 > $DCC_PATH/config
    echo 0x17DB3A84 1 > $DCC_PATH/config
    echo 0x17840C18 1 > $DCC_PATH/config
    echo 0x17830C18 1 > $DCC_PATH/config
    echo 0x17D20000 1 > $DCC_PATH/config
    echo 0x17D2000C 1 > $DCC_PATH/config
    echo 0x17D20018 1 > $DCC_PATH/config

    echo 0x17E00024 1 > $DCC_PATH/config
    echo 0x17E00040 1 > $DCC_PATH/config
    echo 0x17E10024 1 > $DCC_PATH/config
    echo 0x17E10040 1 > $DCC_PATH/config
    echo 0x17E20024 1 > $DCC_PATH/config
    echo 0x17E20040 1 > $DCC_PATH/config
    echo 0x17E30024 1 > $DCC_PATH/config
    echo 0x17E30040 1 > $DCC_PATH/config
    echo 0x17E40024 1 > $DCC_PATH/config
    echo 0x17E40040 1 > $DCC_PATH/config
    echo 0x17E50024 1 > $DCC_PATH/config
    echo 0x17E50040 1 > $DCC_PATH/config
    echo 0x17E60024 1 > $DCC_PATH/config
    echo 0x17E60040 1 > $DCC_PATH/config
    echo 0x17E70024 1 > $DCC_PATH/config
    echo 0x17E70040 1 > $DCC_PATH/config
    echo 0x17810024 1 > $DCC_PATH/config
    echo 0x17810040 1 > $DCC_PATH/config
    echo 0x17810104 1 > $DCC_PATH/config
    echo 0x17810118 1 > $DCC_PATH/config
    echo 0x17810128 1 > $DCC_PATH/config
    echo 0x178100F4 1 > $DCC_PATH/config
    echo 0x179C0400 1 > $DCC_PATH/config
    echo 0x179C0404 1 > $DCC_PATH/config
    echo 0x179C0408 1 > $DCC_PATH/config
    echo 0x179C0038 1 > $DCC_PATH/config
    echo 0x179C0040 1 > $DCC_PATH/config
    echo 0x179C0048 1 > $DCC_PATH/config
    echo 0x0B201020 1 > $DCC_PATH/config
    echo 0x0B201024 1 > $DCC_PATH/config
    echo 0x01301000 1 > $DCC_PATH/config
    echo 0x01301004 1 > $DCC_PATH/config

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

    echo 0x179E0D14 1 > $DCC_PATH/config
    echo 0x179E0D18 1 > $DCC_PATH/config
    echo 0x179E0D1C 1 > $DCC_PATH/config
    echo 0x179E0D30 1 > $DCC_PATH/config
    echo 0x179E0D34 1 > $DCC_PATH/config
    echo 0x179E0D38 1 > $DCC_PATH/config
    echo 0x179E0D3C 1 > $DCC_PATH/config
    echo 0x179E0D44 1 > $DCC_PATH/config
    echo 0x179E0D48 1 > $DCC_PATH/config
    echo 0x179E0D4C 1 > $DCC_PATH/config
    echo 0x179E0D50 1 > $DCC_PATH/config
    echo 0x179E0D58 1 > $DCC_PATH/config
    echo 0x179E0D5C 1 > $DCC_PATH/config
    echo 0x179E0D60 1 > $DCC_PATH/config
    echo 0x179E0D64 1 > $DCC_PATH/config
    echo 0x179E0FB4 1 > $DCC_PATH/config
    echo 0x179E0FB8 1 > $DCC_PATH/config
    echo 0x179E0FBC 1 > $DCC_PATH/config
    echo 0x179E0FD0 1 > $DCC_PATH/config
    echo 0x179E0FD4 1 > $DCC_PATH/config
    echo 0x179E0FD8 1 > $DCC_PATH/config
    echo 0x179E0FDC 1 > $DCC_PATH/config
    echo 0x179E0FE4 1 > $DCC_PATH/config
    echo 0x179E0FE8 1 > $DCC_PATH/config
    echo 0x179E0FEC 1 > $DCC_PATH/config
    echo 0x179E0FF0 1 > $DCC_PATH/config
    echo 0x179E0FF8 1 > $DCC_PATH/config
    echo 0x179E0FFC 1 > $DCC_PATH/config
    echo 0x179E1000 1 > $DCC_PATH/config
    echo 0x179E1004 1 > $DCC_PATH/config

    echo 0x179E1A5C 1 > $DCC_PATH/config
    echo 0x179E1A70 1 > $DCC_PATH/config
    echo 0x179E1A84 1 > $DCC_PATH/config
    echo 0x179E1A98 1 > $DCC_PATH/config
    echo 0x179E1AAC 1 > $DCC_PATH/config
    echo 0x179E1AC0 1 > $DCC_PATH/config
    echo 0x179E1AD4 1 > $DCC_PATH/config
    echo 0x179E1AE8 1 > $DCC_PATH/config
    echo 0x179E1AFC 1 > $DCC_PATH/config
    echo 0x179E1B10 1 > $DCC_PATH/config
    echo 0x179E1B24 1 > $DCC_PATH/config
    echo 0x179E1B38 1 > $DCC_PATH/config
    echo 0x179E1B4C 1 > $DCC_PATH/config
    echo 0x179E1B60 1 > $DCC_PATH/config
    echo 0x179E1B74 1 > $DCC_PATH/config
    echo 0x179E1B88 1 > $DCC_PATH/config

    echo 0x17D45F00 1 > $DCC_PATH/config
    echo 0x17D45F08 1 > $DCC_PATH/config
    echo 0x17D45F0C 1 > $DCC_PATH/config
    echo 0x17D45F10 1 > $DCC_PATH/config
    echo 0x17D45F14 1 > $DCC_PATH/config
    echo 0x17D45F18 1 > $DCC_PATH/config
    echo 0x17D45F1C 1 > $DCC_PATH/config
    echo 0x17D47414 1 > $DCC_PATH/config
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
    echo 0x17D44C14 1 > $DCC_PATH/config
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
    echo 0x17D42C14 1 > $DCC_PATH/config
    echo 0x17D42C18 1 > $DCC_PATH/config
    echo 0x17D42D70 1 > $DCC_PATH/config
    echo 0x17D42D88 1 > $DCC_PATH/config

   # core hang
    echo 0x17E0005C 1 > $DCC_PATH/config
    echo 0x17E1005C 1 > $DCC_PATH/config
    echo 0x17E2005C 1 > $DCC_PATH/config
    echo 0x17E3005C 1 > $DCC_PATH/config
    echo 0x17E4005C 1 > $DCC_PATH/config
    echo 0x17E5005C 1 > $DCC_PATH/config
    echo 0x17E6005C 1 > $DCC_PATH/config
    echo 0x17E7005C 1 > $DCC_PATH/config

   # DDR_SS
    echo 0x01132100 1 > $DCC_PATH/config
    echo 0x01136044 1 > $DCC_PATH/config
    echo 0x01136048 1 > $DCC_PATH/config
    echo 0x0113604C 1 > $DCC_PATH/config
    echo 0x01136050 1 > $DCC_PATH/config
    echo 0x011360B0 1 > $DCC_PATH/config
    echo 0x0113E030 1 > $DCC_PATH/config
    echo 0x0113E034 1 > $DCC_PATH/config
    echo 0x01141000 1 > $DCC_PATH/config
    echo 0x01148058 1 > $DCC_PATH/config
    echo 0x0114805C 1 > $DCC_PATH/config
    echo 0x01148060 1 > $DCC_PATH/config
    echo 0x01148064 1 > $DCC_PATH/config
    echo 0x01160410 1 > $DCC_PATH/config
    echo 0x01160414 1 > $DCC_PATH/config
    echo 0x01160418 1 > $DCC_PATH/config
    echo 0x01160420 1 > $DCC_PATH/config
    echo 0x01160424 1 > $DCC_PATH/config
    echo 0x01160430 1 > $DCC_PATH/config
    echo 0x01160440 1 > $DCC_PATH/config
    echo 0x01160448 1 > $DCC_PATH/config
    echo 0x011604A0 1 > $DCC_PATH/config
    echo 0x011B2100 1 > $DCC_PATH/config
    echo 0x011B6044 1 > $DCC_PATH/config
    echo 0x011B6048 1 > $DCC_PATH/config
    echo 0x011B604C 1 > $DCC_PATH/config
    echo 0x011B6050 1 > $DCC_PATH/config
    echo 0x011B60B0 1 > $DCC_PATH/config
    echo 0x011BE030 1 > $DCC_PATH/config
    echo 0x011BE034 1 > $DCC_PATH/config
    echo 0x011C1000 1 > $DCC_PATH/config
    echo 0x011C8058 1 > $DCC_PATH/config
    echo 0x011C805C 1 > $DCC_PATH/config
    echo 0x011C8060 1 > $DCC_PATH/config
    echo 0x011C8064 1 > $DCC_PATH/config
    echo 0x011E0410 1 > $DCC_PATH/config
    echo 0x011E0414 1 > $DCC_PATH/config
    echo 0x011E0418 1 > $DCC_PATH/config
    echo 0x011E0420 1 > $DCC_PATH/config
    echo 0x011E0424 1 > $DCC_PATH/config
    echo 0x011E0430 1 > $DCC_PATH/config
    echo 0x011E0440 1 > $DCC_PATH/config
    echo 0x011E0448 1 > $DCC_PATH/config
    echo 0x011E04A0 1 > $DCC_PATH/config
    echo 0x01232100 1 > $DCC_PATH/config
    echo 0x01236044 1 > $DCC_PATH/config
    echo 0x01236048 1 > $DCC_PATH/config
    echo 0x0123604C 1 > $DCC_PATH/config
    echo 0x01236050 1 > $DCC_PATH/config
    echo 0x012360B0 1 > $DCC_PATH/config
    echo 0x0123E030 1 > $DCC_PATH/config
    echo 0x0123E034 1 > $DCC_PATH/config
    echo 0x01241000 1 > $DCC_PATH/config
    echo 0x01248058 1 > $DCC_PATH/config
    echo 0x0124805C 1 > $DCC_PATH/config
    echo 0x01248060 1 > $DCC_PATH/config
    echo 0x01248064 1 > $DCC_PATH/config
    echo 0x01260410 1 > $DCC_PATH/config
    echo 0x01260414 1 > $DCC_PATH/config
    echo 0x01260418 1 > $DCC_PATH/config
    echo 0x01260420 1 > $DCC_PATH/config
    echo 0x01260424 1 > $DCC_PATH/config
    echo 0x01260430 1 > $DCC_PATH/config
    echo 0x01260440 1 > $DCC_PATH/config
    echo 0x01260448 1 > $DCC_PATH/config
    echo 0x012604A0 1 > $DCC_PATH/config
    echo 0x012B2100 1 > $DCC_PATH/config
    echo 0x012B6044 1 > $DCC_PATH/config
    echo 0x012B6048 1 > $DCC_PATH/config
    echo 0x012B604C 1 > $DCC_PATH/config
    echo 0x012B6050 1 > $DCC_PATH/config
    echo 0x012B60B0 1 > $DCC_PATH/config
    echo 0x012BE030 1 > $DCC_PATH/config
    echo 0x012BE034 1 > $DCC_PATH/config
    echo 0x012C1000 1 > $DCC_PATH/config
    echo 0x012C8058 1 > $DCC_PATH/config
    echo 0x012C805C 1 > $DCC_PATH/config
    echo 0x012C8060 1 > $DCC_PATH/config
    echo 0x012C8064 1 > $DCC_PATH/config
    echo 0x012E0410 1 > $DCC_PATH/config
    echo 0x012E0414 1 > $DCC_PATH/config
    echo 0x012E0418 1 > $DCC_PATH/config
    echo 0x012E0420 1 > $DCC_PATH/config
    echo 0x012E0424 1 > $DCC_PATH/config
    echo 0x012E0430 1 > $DCC_PATH/config
    echo 0x012E0440 1 > $DCC_PATH/config
    echo 0x012E0448 1 > $DCC_PATH/config
    echo 0x012E04A0 1 > $DCC_PATH/config
    echo 0x01380900 1 > $DCC_PATH/config
    echo 0x01380904 1 > $DCC_PATH/config
    echo 0x01380908 1 > $DCC_PATH/config
    echo 0x0138090c 1 > $DCC_PATH/config
    echo 0x01380910 1 > $DCC_PATH/config
    echo 0x01380914 1 > $DCC_PATH/config
    echo 0x01380918 1 > $DCC_PATH/config
    echo 0x0138091c 1 > $DCC_PATH/config
    echo 0x01380d00 1 > $DCC_PATH/config
    echo 0x01380d04 1 > $DCC_PATH/config
    echo 0x01380d08 1 > $DCC_PATH/config
    echo 0x01380d0c 1 > $DCC_PATH/config
    echo 0x01380d10 1 > $DCC_PATH/config
    echo 0x01430280 1 > $DCC_PATH/config
    echo 0x01430288 1 > $DCC_PATH/config
    echo 0x0143028c 1 > $DCC_PATH/config
    echo 0x01430290 1 > $DCC_PATH/config
    echo 0x01430294 1 > $DCC_PATH/config
    echo 0x01430298 1 > $DCC_PATH/config
    echo 0x0143029c 1 > $DCC_PATH/config
    echo 0x014302a0 1 > $DCC_PATH/config

    echo 0x01132100 1 > $DCC_PATH/config
    echo 0x01136044 1 > $DCC_PATH/config
    echo 0x01136048 1 > $DCC_PATH/config
    echo 0x0113604C 1 > $DCC_PATH/config
    echo 0x01136050 1 > $DCC_PATH/config
    echo 0x011360B0 1 > $DCC_PATH/config
    echo 0x0113E030 1 > $DCC_PATH/config
    echo 0x0113E034 1 > $DCC_PATH/config
    echo 0x01141000 1 > $DCC_PATH/config
    echo 0x01148058 1 > $DCC_PATH/config
    echo 0x0114805C 1 > $DCC_PATH/config
    echo 0x01148060 1 > $DCC_PATH/config
    echo 0x01148064 1 > $DCC_PATH/config
    echo 0x01160410 1 > $DCC_PATH/config
    echo 0x01160414 1 > $DCC_PATH/config
    echo 0x01160418 1 > $DCC_PATH/config
    echo 0x01160420 1 > $DCC_PATH/config
    echo 0x01160424 1 > $DCC_PATH/config
    echo 0x01160430 1 > $DCC_PATH/config
    echo 0x01160440 1 > $DCC_PATH/config
    echo 0x01160448 1 > $DCC_PATH/config
    echo 0x011604A0 1 > $DCC_PATH/config
    echo 0x011B2100 1 > $DCC_PATH/config
    echo 0x011B6044 1 > $DCC_PATH/config
    echo 0x011B6048 1 > $DCC_PATH/config
    echo 0x011B604C 1 > $DCC_PATH/config
    echo 0x011B6050 1 > $DCC_PATH/config
    echo 0x011B60B0 1 > $DCC_PATH/config
    echo 0x011BE030 1 > $DCC_PATH/config
    echo 0x011BE034 1 > $DCC_PATH/config
    echo 0x011C1000 1 > $DCC_PATH/config
    echo 0x011C8058 1 > $DCC_PATH/config
    echo 0x011C805C 1 > $DCC_PATH/config
    echo 0x011C8060 1 > $DCC_PATH/config
    echo 0x011C8064 1 > $DCC_PATH/config
    echo 0x011E0410 1 > $DCC_PATH/config
    echo 0x011E0414 1 > $DCC_PATH/config
    echo 0x011E0418 1 > $DCC_PATH/config
    echo 0x011E0420 1 > $DCC_PATH/config
    echo 0x011E0424 1 > $DCC_PATH/config
    echo 0x011E0430 1 > $DCC_PATH/config
    echo 0x011E0440 1 > $DCC_PATH/config
    echo 0x011E0448 1 > $DCC_PATH/config
    echo 0x011E04A0 1 > $DCC_PATH/config
    echo 0x01232100 1 > $DCC_PATH/config
    echo 0x01236044 1 > $DCC_PATH/config
    echo 0x01236048 1 > $DCC_PATH/config
    echo 0x0123604C 1 > $DCC_PATH/config
    echo 0x01236050 1 > $DCC_PATH/config
    echo 0x012360B0 1 > $DCC_PATH/config
    echo 0x0123E030 1 > $DCC_PATH/config
    echo 0x0123E034 1 > $DCC_PATH/config
    echo 0x01241000 1 > $DCC_PATH/config
    echo 0x01248058 1 > $DCC_PATH/config
    echo 0x0124805C 1 > $DCC_PATH/config
    echo 0x01248060 1 > $DCC_PATH/config
    echo 0x01248064 1 > $DCC_PATH/config
    echo 0x01260410 1 > $DCC_PATH/config
    echo 0x01260414 1 > $DCC_PATH/config
    echo 0x01260418 1 > $DCC_PATH/config
    echo 0x01260420 1 > $DCC_PATH/config
    echo 0x01260424 1 > $DCC_PATH/config
    echo 0x01260430 1 > $DCC_PATH/config
    echo 0x01260440 1 > $DCC_PATH/config
    echo 0x01260448 1 > $DCC_PATH/config
    echo 0x012604A0 1 > $DCC_PATH/config
    echo 0x012B2100 1 > $DCC_PATH/config
    echo 0x012B6044 1 > $DCC_PATH/config
    echo 0x012B6048 1 > $DCC_PATH/config
    echo 0x012B604C 1 > $DCC_PATH/config
    echo 0x012B6050 1 > $DCC_PATH/config
    echo 0x012B60B0 1 > $DCC_PATH/config
    echo 0x012BE030 1 > $DCC_PATH/config
    echo 0x012BE034 1 > $DCC_PATH/config
    echo 0x012C1000 1 > $DCC_PATH/config
    echo 0x012C8058 1 > $DCC_PATH/config
    echo 0x012C805C 1 > $DCC_PATH/config
    echo 0x012C8060 1 > $DCC_PATH/config
    echo 0x012C8064 1 > $DCC_PATH/config
    echo 0x012E0410 1 > $DCC_PATH/config
    echo 0x012E0414 1 > $DCC_PATH/config
    echo 0x012E0418 1 > $DCC_PATH/config
    echo 0x012E0420 1 > $DCC_PATH/config
    echo 0x012E0424 1 > $DCC_PATH/config
    echo 0x012E0430 1 > $DCC_PATH/config
    echo 0x012E0440 1 > $DCC_PATH/config
    echo 0x012E0448 1 > $DCC_PATH/config
    echo 0x012E04A0 1 > $DCC_PATH/config
    echo 0x01380900 1 > $DCC_PATH/config
    echo 0x01380904 1 > $DCC_PATH/config
    echo 0x01380908 1 > $DCC_PATH/config
    echo 0x0138090c 1 > $DCC_PATH/config
    echo 0x01380910 1 > $DCC_PATH/config
    echo 0x01380914 1 > $DCC_PATH/config
    echo 0x01380918 1 > $DCC_PATH/config
    echo 0x0138091c 1 > $DCC_PATH/config
    echo 0x01380d00 1 > $DCC_PATH/config
    echo 0x01380d04 1 > $DCC_PATH/config
    echo 0x01380d08 1 > $DCC_PATH/config
    echo 0x01380d0c 1 > $DCC_PATH/config
    echo 0x01380d10 1 > $DCC_PATH/config
    echo 0x01430280 1 > $DCC_PATH/config
    echo 0x01430288 1 > $DCC_PATH/config
    echo 0x0143028c 1 > $DCC_PATH/config
    echo 0x01430290 1 > $DCC_PATH/config
    echo 0x01430294 1 > $DCC_PATH/config
    echo 0x01430298 1 > $DCC_PATH/config
    echo 0x0143029c 1 > $DCC_PATH/config
    echo 0x014302a0 1 > $DCC_PATH/config

    echo 0x01301000 1 > $DCC_PATH/config
    echo 0x01301004 1 > $DCC_PATH/config
    echo 0x01302000 1 > $DCC_PATH/config
    echo 0x01302004 1 > $DCC_PATH/config
    echo 0x01303000 1 > $DCC_PATH/config
    echo 0x01303004 1 > $DCC_PATH/config
    echo 0x01304000 1 > $DCC_PATH/config
    echo 0x01304004 1 > $DCC_PATH/config
    echo 0x01305000 1 > $DCC_PATH/config
    echo 0x01305004 1 > $DCC_PATH/config
    echo 0x01306000 1 > $DCC_PATH/config
    echo 0x01306004 1 > $DCC_PATH/config
    echo 0x01307000 1 > $DCC_PATH/config
    echo 0x01307004 1 > $DCC_PATH/config
    echo 0x01308000 1 > $DCC_PATH/config
    echo 0x01308004 1 > $DCC_PATH/config
    echo 0x01309000 1 > $DCC_PATH/config
    echo 0x01309004 1 > $DCC_PATH/config
    echo 0x0130A000 1 > $DCC_PATH/config
    echo 0x0130A004 1 > $DCC_PATH/config
    echo 0x0130B000 1 > $DCC_PATH/config
    echo 0x0130B004 1 > $DCC_PATH/config
    echo 0x0130C000 1 > $DCC_PATH/config
    echo 0x0130C004 1 > $DCC_PATH/config
    echo 0x0130D000 1 > $DCC_PATH/config
    echo 0x0130D004 1 > $DCC_PATH/config
    echo 0x0130E000 1 > $DCC_PATH/config
    echo 0x0130E004 1 > $DCC_PATH/config
    echo 0x0130F000 1 > $DCC_PATH/config
    echo 0x0130F004 1 > $DCC_PATH/config
    echo 0x01310000 1 > $DCC_PATH/config
    echo 0x01310004 1 > $DCC_PATH/config
    echo 0x01311000 1 > $DCC_PATH/config
    echo 0x01311004 1 > $DCC_PATH/config
    echo 0x01312000 1 > $DCC_PATH/config
    echo 0x01312004 1 > $DCC_PATH/config
    echo 0x01313000 1 > $DCC_PATH/config
    echo 0x01313004 1 > $DCC_PATH/config
    echo 0x01314000 1 > $DCC_PATH/config
    echo 0x01314004 1 > $DCC_PATH/config
    echo 0x01315000 1 > $DCC_PATH/config
    echo 0x01315004 1 > $DCC_PATH/config
    echo 0x01316000 1 > $DCC_PATH/config
    echo 0x01316004 1 > $DCC_PATH/config
    echo 0x01317000 1 > $DCC_PATH/config
    echo 0x01317004 1 > $DCC_PATH/config
    echo 0x01318000 1 > $DCC_PATH/config
    echo 0x01318004 1 > $DCC_PATH/config
    echo 0x01319000 1 > $DCC_PATH/config
    echo 0x01319004 1 > $DCC_PATH/config
    echo 0x0131A000 1 > $DCC_PATH/config
    echo 0x0131A004 1 > $DCC_PATH/config
    echo 0x0131B000 1 > $DCC_PATH/config
    echo 0x0131B004 1 > $DCC_PATH/config
    echo 0x0131C000 1 > $DCC_PATH/config
    echo 0x0131C004 1 > $DCC_PATH/config
    echo 0x0131D000 1 > $DCC_PATH/config
    echo 0x0131D004 1 > $DCC_PATH/config
    echo 0x0131E000 1 > $DCC_PATH/config
    echo 0x0131E004 1 > $DCC_PATH/config
    echo 0x0131F000 1 > $DCC_PATH/config
    echo 0x0131F004 1 > $DCC_PATH/config
    echo 0x0C201244 1 > $DCC_PATH/config
    echo 0x0C202244 1 > $DCC_PATH/config
    echo 0x013D0008 1 > $DCC_PATH/config
    echo 0x013D0068 1 > $DCC_PATH/config
    echo 0x013D0078 1 > $DCC_PATH/config

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
    echo 0x069EA01C 0x0003e8a0 1 > $DCC_PATH/config_write
    echo 0x069EA01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x069EA014 1 1 > $DCC_PATH/config
    echo 0x069EA01C 0x0003eea0 1 > $DCC_PATH/config_write
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

    #Apply configuration and enable DCC
    echo  1 > $DCC_PATH/enable
}

# Function MSMCOBALT DCC configuration
enable_msm8998_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/10b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo  1 > $DCC_PATH/config_reset

    #OSM WDOG
    echo 0x179C1C00 37 > $DCC_PATH/config
    echo 0x179C3C00 37 > $DCC_PATH/config
    #APM
    echo 0x179D0000 1 > $DCC_PATH/config
    echo 0x179D000C 1 > $DCC_PATH/config
    echo 0x179D0018 1 > $DCC_PATH/config
    #L2_SAW4_PMIC_STS
    echo 0x17912C18 1 > $DCC_PATH/config
    echo 0x17812C18 1 > $DCC_PATH/config
    #CPRH_STATUS
    echo 0x179CBAA4 1 > $DCC_PATH/config
    echo 0x179C7AA4 1 > $DCC_PATH/config

    # default configuration
    #SPM registers
    echo 0x17989000 > $DCC_PATH/config
    echo 0x17989C0C > $DCC_PATH/config
    echo 0x17988064 > $DCC_PATH/config
    echo 0x17999000 > $DCC_PATH/config
    echo 0x17999C0C > $DCC_PATH/config
    echo 0x17998064 > $DCC_PATH/config
    echo 0x179A9000 > $DCC_PATH/config
    echo 0x179A9C0C > $DCC_PATH/config
    echo 0x179A8064 > $DCC_PATH/config
    echo 0x179B9000 > $DCC_PATH/config
    echo 0x179B9C0C > $DCC_PATH/config
    echo 0x179B8064 > $DCC_PATH/config
    echo 0x17912000 > $DCC_PATH/config
    echo 0x17912C0C > $DCC_PATH/config
    echo 0x17911210 > $DCC_PATH/config
    echo 0x17911290 > $DCC_PATH/config
    echo 0x17911218 > $DCC_PATH/config
    echo 0x17889000 > $DCC_PATH/config
    echo 0x17889C0C > $DCC_PATH/config
    echo 0x17888064 > $DCC_PATH/config
    echo 0x17899000 > $DCC_PATH/config
    echo 0x17899C0C > $DCC_PATH/config
    echo 0x17898064 > $DCC_PATH/config
    echo 0x178A9000 > $DCC_PATH/config
    echo 0x178A9C0C > $DCC_PATH/config
    echo 0x178A8064 > $DCC_PATH/config
    echo 0x178B9000 > $DCC_PATH/config
    echo 0x178B9C0C > $DCC_PATH/config
    echo 0x178B8064 > $DCC_PATH/config
    echo 0x17812000 > $DCC_PATH/config
    echo 0x17812C0C > $DCC_PATH/config
    echo 0x17811210 > $DCC_PATH/config
    echo 0x17811290 > $DCC_PATH/config
    echo 0x17811218 > $DCC_PATH/config
    echo 0x179D2000 > $DCC_PATH/config
    echo 0x179D2C0C > $DCC_PATH/config
    echo 0x7ba4008 > $DCC_PATH/config
    echo 0x7ba400C > $DCC_PATH/config
    echo 0x7ba4010 > $DCC_PATH/config
    echo 0x7ba4014 > $DCC_PATH/config

    # CCI ACE / Stalled Transaction
    echo 0x7ba82B0 > $DCC_PATH/config

    # 8 times, same register
    echo 0x7ba1000 > $DCC_PATH/config
    echo 0x7ba1000 > $DCC_PATH/config
    echo 0x7ba1000 > $DCC_PATH/config
    echo 0x7ba1000 > $DCC_PATH/config
    echo 0x7ba1000 > $DCC_PATH/config
    echo 0x7ba1000 > $DCC_PATH/config
    echo 0x7ba1000 > $DCC_PATH/config
    echo 0x7ba1000 > $DCC_PATH/config

    #SCMO STATUS
    echo 0x01030560  1 > $DCC_PATH/config
    echo 0x010305A0  1 > $DCC_PATH/config
    echo 0x0103C560  1 > $DCC_PATH/config
    echo 0x0103C5A0  1 > $DCC_PATH/config

    #DPE STATUS
    echo 0x0103409C 1 > $DCC_PATH/config
    echo 0x0104009C 1 > $DCC_PATH/config

    # DDR registers Masterport status
    echo 0x01008400 38 > $DCC_PATH/config
    echo 0x0101C400 38 > $DCC_PATH/config
    echo 0x01014400 38 > $DCC_PATH/config
    echo 0x01010400 38 > $DCC_PATH/config
    echo 0x01018400 38 > $DCC_PATH/config

    #SWAY
    echo 0x01048400 16 > $DCC_PATH/config
    echo 0x01050400 16 > $DCC_PATH/config
    echo 0x01058400 16 > $DCC_PATH/config

    #ARB
    echo 0x01049800  1 > $DCC_PATH/config
    echo 0x01051800  1 > $DCC_PATH/config
    echo 0x01059800  1 > $DCC_PATH/config

    #DRAM Status
    echo 0x01035074 1 > $DCC_PATH/config
    echo 0x01041074 1 > $DCC_PATH/config
    echo 0x01030450 1 > $DCC_PATH/config
    echo 0x0103C450 1 > $DCC_PATH/config

    # APCS_ALIAS0_CPU_PWR_CTL
    echo 0x17988004 2 > $DCC_PATH/config
    echo 0x17998004 2 > $DCC_PATH/config
    echo 0x179A8004 2 > $DCC_PATH/config
    echo 0x179B8004 2 > $DCC_PATH/config
    echo 0x17888004 2 > $DCC_PATH/config
    echo 0x17898004 2 > $DCC_PATH/config
    echo 0x178A8004 2 > $DCC_PATH/config
    echo 0x178B8004 2 > $DCC_PATH/config
    echo 0x17911014 2 > $DCC_PATH/config
    echo 0x17811014 2 > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

# Function MSMFALCON DCC configuration
enable_sdm660_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/10b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo  1 > $DCC_PATH/config_reset

    #OSM WDOG
    echo 0x179C1C00 37 > $DCC_PATH/config
    echo 0x179C3C00 37 > $DCC_PATH/config
    #APM
    echo 0x179D0000 1 > $DCC_PATH/config
    echo 0x179D000C 1 > $DCC_PATH/config
    echo 0x179D0018 1 > $DCC_PATH/config
    #L2_SAW4_PMIC_STS
    echo 0x17912C18 1 > $DCC_PATH/config
    echo 0x17812C18 1 > $DCC_PATH/config
    #CPRH_STATUS
    echo 0x179C4000 1 > $DCC_PATH/config
    echo 0x179C8000 1 > $DCC_PATH/config
    echo 0x179CBAA4 1 > $DCC_PATH/config
    echo 0x179C7AA4 1 > $DCC_PATH/config

    #APCS_ALIAS0_APSS_ACS
    echo 0x17988004 2 > $DCC_PATH/config    #CPU_PWR_CTL and APC_PWR_STATUS
    echo 0x17988064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS0_SAW4_1_1_SPM
    echo 0x17989000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS0_SAW4_1_1_STS
    echo 0x17989C0C 2 > $DCC_PATH/config    #SPM_STS
    echo 0x17989C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x17989C20 > $DCC_PATH/config    #SPM_STS3
    echo 0x17989C18 > $DCC_PATH/config    #PMIC_STS

    #APCS_ALIAS1_APSS_ACS
    echo 0x17998004 2 > $DCC_PATH/config    #CPU_PWR_CTL and #APC_PWR_STATUS
    echo 0x17998064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS1_SAW4_1_1_SPM
    echo 0x17999000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS1_SAW4_1_1_STS
    echo 0x17999C0C > $DCC_PATH/config    #SPM_STS
    echo 0x17999C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x17999C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS2_APSS_ACS
    echo 0x179A8004 2 > $DCC_PATH/config    #CPU_PWR_CTL and #APC_PWR_STATUS
    echo 0x179A8064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS2_SAW4_1_1_SPM
    echo 0x179A9000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS2_SAW4_1_1_STS
    echo 0x179A9C0C > $DCC_PATH/config    #SPM_STS
    echo 0x179A9C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x179A9C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS3_APSS_ACS
    echo 0x179B8004 2 > $DCC_PATH/config    #CPU_PWR_CTL and #APC_PWR_STATUS
    echo 0x179B8064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS3_SAW4_1_1_SPM
    echo 0x179B9000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS3_SAW4_1_1_STS
    echo 0x179B9C0C > $DCC_PATH/config    #SPM_STS
    echo 0x179B9C10 > $DCC_PATH/config    #SPM_STS2
    echo 0x179B9C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS0_APSS_GLB
    echo 0x17911014 2 > $DCC_PATH/config    #L2_PWR_CTL and #L2_PWR_STATUS
    echo 0x17911210 > $DCC_PATH/config    #L2_SPM_QCHANNEL_CFG
    echo 0x17911218 > $DCC_PATH/config    #L2_FLUSH_CTL
    echo 0x17911234 > $DCC_PATH/config    #L2_FLUSH_STS
    echo 0x17911290 > $DCC_PATH/config    #DX_FSM_STATUS
    #APCLUS0_L2_SAW4_1_1_SPM
    echo 0x17912000 2 > $DCC_PATH/config    #SPM_CTL and #SPM_DLY
    echo 0x1791200C > $DCC_PATH/config    #SPM_CFG
    #APCLUS0_L2_SAW4_1_1_STS
    echo 0x17912C0C 2 > $DCC_PATH/config    #SPM_STS and #SPM_STS2
    echo 0x17912C20 > $DCC_PATH/config    #SPM_STS3
    echo 0x17912C18 > $DCC_PATH/config    #PMIC_STS


    #APCS_ALIAS4_APSS_ACS
    echo 0x17888004 2 > $DCC_PATH/config    #CPU_PWR_CTL and #APC_PWR_STATUS
    echo 0x17888064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS4_SAW4_1_1_SPM
    echo 0x17889000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS4_SAW4_1_1_STS
    echo 0x17889C0C 2 > $DCC_PATH/config    #SPM_STS and #SPM_STS2
    echo 0x17889C20 > $DCC_PATH/config    #SPM_STS3
    echo 0x17889C18 > $DCC_PATH/config    #PMIC_STS

    #APCS_ALIAS5_APSS_ACS
    echo 0x17898004 2 > $DCC_PATH/config    #CPU_PWR_CTL and #APC_PWR_STATUS
    echo 0x17898064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS5_SAW4_1_1_SPM
    echo 0x17899000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS5_SAW4_1_1_STS
    echo 0x17899C0C 2 > $DCC_PATH/config    #SPM_STS and #SPM_STS2
    echo 0x17899C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS6_APSS_ACS
    echo 0x178A8004 2 > $DCC_PATH/config    #CPU_PWR_CTL and #APC_PWR_STATUS
    echo 0x178A8064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS6_SAW4_1_1_SPM
    echo 0x178A9000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS6_SAW4_1_1_STS
    echo 0x178A9C0C 2 > $DCC_PATH/config    #SPM_STS and #SPM_STS2
    echo 0x178A9C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS7_APSS_ACS
    echo 0x178B8004 2 > $DCC_PATH/config    #CPU_PWR_CTL and #APC_PWR_STATUS
    echo 0x178B8064 > $DCC_PATH/config    #SPM_QCHANNEL_CFG
    #APCS_ALIAS7_SAW4_1_1_SPM
    echo 0x178B9000 > $DCC_PATH/config    #SPM_CTL
    #APCS_ALIAS7_SAW4_1_1_STS
    echo 0x178B9C0C 2 > $DCC_PATH/config    #SPM_STS and #SPM_STS2
    echo 0x178B9C20 > $DCC_PATH/config    #SPM_STS3

    #APCS_ALIAS1_APSS_GLB
    echo 0x17811014 > $DCC_PATH/config    #L2_PWR_CTL
    echo 0x17811018 > $DCC_PATH/config    #L2_PWR_STATUS
    echo 0x17811210 > $DCC_PATH/config    #L2_SPM_QCHANNEL_CFG
    echo 0x17811218 > $DCC_PATH/config    #L2_FLUSH_CTL
    echo 0x17811234 > $DCC_PATH/config    #L2_FLUSH_STS
    echo 0x17811290 > $DCC_PATH/config    #DX_FSM_STATUS
    #APCLUS1_L2_SAW4_1_1_SPM
    echo 0x17812000 2 > $DCC_PATH/config    #SPM_CTL and #SPM_DLY
    echo 0x1781200C > $DCC_PATH/config    #SPM_CFG
    #APCLUS1_L2_SAW4_1_1_STS
    echo 0x17812C0C 2 > $DCC_PATH/config    #SPM_STS and #SPM_STS2
    echo 0x17812C20 > $DCC_PATH/config    #SPM_STS3
    echo 0x17812C18 > $DCC_PATH/config    #PMIC_STS

    #APCS_CCI_GLADIATOR
    echo 0x07BA0008 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_CFGIO
    echo 0x07BA0078 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_CFGDUT
    echo 0x07BA0080 3 > $DCC_PATH/config  #GNOC ACE0 Status
    echo 0x07BA00A0 3 > $DCC_PATH/config  #GNOC ACE1 Status
    echo 0x07BA1014 11 > $DCC_PATH/config    #APCS_CCI_GLADIATOR_MAIN_CRIXUS_MAIN ERRORS
    echo 0x07BA4008 4 > $DCC_PATH/config    #APCS_CCI_PD_GNOC_MAIN_PROGPOWERCONTROLLER_TARGET0
    echo 0x07BA800C 12 > $DCC_PATH/config #APCS_CCI_TRACE_MAIN ERRORS
    echo 0x07BA82B0 > $DCC_PATH/config    #APCS_CCI_PORT_STATUS
    echo 0x07BA1000 > $DCC_PATH/config    #GLADIATOR STALLED TRANSACTION READ 8 TIMES
    echo 0x07BA1000 > $DCC_PATH/config    #GLADIATOR STALLED TRANSACTION READ 8 TIMES
    echo 0x07BA1000 > $DCC_PATH/config    #GLADIATOR STALLED TRANSACTION READ 8 TIMES
    echo 0x07BA1000 > $DCC_PATH/config    #GLADIATOR STALLED TRANSACTION READ 8 TIMES
    echo 0x07BA1000 > $DCC_PATH/config    #GLADIATOR STALLED TRANSACTION READ 8 TIMES
    echo 0x07BA1000 > $DCC_PATH/config    #GLADIATOR STALLED TRANSACTION READ 8 TIMES
    echo 0x07BA1000 > $DCC_PATH/config    #GLADIATOR STALLED TRANSACTION READ 8 TIMES
    echo 0x07BA1000 4 > $DCC_PATH/config    #GLADIATOR STALLED TRANSACTION READ 8 TIMES
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config    #Read Same addresses 100 times
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config
    echo 0x07BA1008 2 > $DCC_PATH/config

    #SNOC Fault/Error registers
    echo 0x0162000C > $DCC_PATH/config   #SNOC_OBS_ERRVLD
    echo 0x01620014 6 > $DCC_PATH/config
    echo 0x01620108 4 > $DCC_PATH/config  # SNOC_SBM_FAULTSTATUS
    echo 0x016201B0 >  $DCC_PATH/config  # SNOC_SBM_SENSEIN0

    #CCI_SAW4_1_1_SPM
    echo 0x179D2000 > $DCC_PATH/config    #SPM_CTL
    #CCI_SAW4_1_1_STS
    echo 0x179D2C0C 2 > $DCC_PATH/config    #SPM_STS and #SPM_STS2
    echo 0x179D2C20 > $DCC_PATH/config    #SPM_STS3
    echo 0x179D2C18 > $DCC_PATH/config    #PMIC_STS

    #LMH_PERF
    echo 0x179CD0C0 > $DCC_PATH/config  #TSense0_Reg
    echo 0x179CD0C4 > $DCC_PATH/config  #Tsense1_Reg
    echo 0x179CD0CC > $DCC_PATH/config  #Tsense2_Reg
    echo 0x179CD0CD > $DCC_PATH/config  #Tsense3_Reg
    echo 0x179CD03C > $DCC_PATH/config  #TTL_WORD_REG
    echo 0x179CD300 > $DCC_PATH/config  #FIFO0
    echo 0x179CD310 > $DCC_PATH/config  #FIFO1
    echo 0x179CD320 > $DCC_PATH/config  #FIFO2
    echo 0x179CD330 > $DCC_PATH/config  #FIFO2
    echo 0x179CD810 > $DCC_PATH/config  #LMH_DCVS_CS_STATUS
    echo 0x179CD814 > $DCC_PATH/config  #LMH_DCVS_THERMAL_STATUS
    echo 0x179CD81C > $DCC_PATH/config  #LMH_DCVS_BCL_STATUS

    #LMH_PWR
    echo 0x179CF0C0 > $DCC_PATH/config  #TSense0_Reg
    echo 0x179CF0C4 > $DCC_PATH/config  #Tsense1_Reg
    echo 0x179CF03C > $DCC_PATH/config  #TTL_WORD_REG
    echo 0x179CF300 > $DCC_PATH/config  #FIFO0
    echo 0x179CF310 > $DCC_PATH/config  #FIFO1
    echo 0x179CF814 > $DCC_PATH/config  #LMH_DCVS_THERMAL_STATUS

    #ISENSE
    echo 0x179DC10C > $DCC_PATH/config  #Isense core01
    echo 0x179DC110 > $DCC_PATH/config  #Isense core23

    #BIMC_GLOBAL2
    echo 0x010021F0 4 > $DCC_PATH/config    #BIMC_BRIC_DEFAULT_SEGMENT

    #GCC_GPLL0
    echo 0x100000 10 > $DCC_PATH/config

    #GCC_GPLL1
    echo 0x101000 10 > $DCC_PATH/config

    #GCC_GPLL2
    echo 0x102000 10 > $DCC_PATH/config

    #GCC_GPLL3
    echo 0x103000 10  > $DCC_PATH/config

    #GCC_GPLL4
    echo 0x177000 10 > $DCC_PATH/config

    #GCC_GPLL5
    echo 0x174000 10 > $DCC_PATH/config

    echo 0x151000 > $DCC_PATH/config    #GCC_RPM_GPLL_ENA_VOTE

    echo 0x144004 > $DCC_PATH/config    #GCC_BIMC_GDSCR
    echo 0x146048 > $DCC_PATH/config    #GCC_DDR_DIM_WRAPPER_GDSCR
    echo 0x183004 > $DCC_PATH/config    #GCC_AGGRE2_NOC_GDSCR

    echo 0x104020 2 > $DCC_PATH/config
    echo 0x104040 2 > $DCC_PATH/config
    echo 0x105038 2 > $DCC_PATH/config
    echo 0x10A008 2 > $DCC_PATH/config

    #GCC_CNOC
    echo 0x105050 2 > $DCC_PATH/config

    #GCC_QDSS
    echo 0x10D000 2 > $DCC_PATH/config
    echo 0x10D018 2 > $DCC_PATH/config
    echo 0x10D030 2 > $DCC_PATH/config

    echo 0x10E000 2 > $DCC_PATH/config
    echo 0x10E018 2 > $DCC_PATH/config
    echo 0x10E030 2 > $DCC_PATH/config
    echo 0x10E048 2 > $DCC_PATH/config

    #GCC_RPM
    echo 0x13C018 2 > $DCC_PATH/config

    #GCC_CE1
    echo 0x141010 2 > $DCC_PATH/config

    #GCC_BIMC
    echo 0x145018 2 > $DCC_PATH/config

    #GCC_BIMC_DDR_CPLL0_ROOT
    echo 0x146010 2 > $DCC_PATH/config

    #GCC_BIMC_DDR_CPLL1_ROOT
    echo 0x146028 2 > $DCC_PATH/config

    #GCC_CDSP_BIMC
    echo 0x147030 2 > $DCC_PATH/config

    echo 0x148014 2 > $DCC_PATH/config

    echo 0x14802C 2 > $DCC_PATH/config

    echo 0x18A024 2 > $DCC_PATH/config

    echo 0x17101C 2 > $DCC_PATH/config

    echo 0x189018 2 > $DCC_PATH/config

    echo 0x17A014 2 > $DCC_PATH/config

    echo 0x17A02C 2 > $DCC_PATH/config
    echo 0x17A044 2 > $DCC_PATH/config
    echo 0x17A05C 2 > $DCC_PATH/config
    echo 0x17A074 2 > $DCC_PATH/config

    echo 0x146004 2 > $DCC_PATH/config

    echo 0xC8CC000 10 > $DCC_PATH/config

    echo 0xC8CC050 10 > $DCC_PATH/config

    echo 0xC8C00F0 10 > $DCC_PATH/config

    echo 0xC8C4000 > $DCC_PATH/config	 #MMSS_PLL_VOTE_RPM

    echo 0xC8CD000 2 > $DCC_PATH/config

    echo  0x1030560 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SCMO_RCH_STATUS
    echo  0x10305a0 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SCMO_WCH_STATUS
    echo  0x103c560 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SCMO_RCH_STATUS
    echo  0x103c5a0 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SCMO_WCH_STATUS
    echo  0x1030520 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SCMO_CMD_BUF_STATUS
    echo  0x103c520 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SCMO_CMD_BUF_STATUS
    echo  0x103408c 1 > $DCC_PATH/config 	##BIMC_S_DDR0_DPE_DRAM_STATUS_0
    echo  0x104008c 1 > $DCC_PATH/config 	##BIMC_S_DDR1_DPE_DRAM_STATUS_0
    echo  0x103409c 1 > $DCC_PATH/config 	##BIMC_S_DDR0_DPE_MEMC_STATUS_0
    echo  0x104009c 1 > $DCC_PATH/config 	##BIMC_S_DDR1_DPE_MEMC_STATUS_0
    echo  0xffd220  1 > $DCC_PATH/config 	##MCCC_MCCC_CLK_PERIOD
    echo  0x108f094 1 > $DCC_PATH/config 	##DDR_CC_MCCC_DDRCC_MCCC_TOP_STATUS
    echo  0xffd200  1 > $DCC_PATH/config 	##MCCC_MCCC_FREQ_SWITCH_UPDATE
    echo  0xffd02c  1 > $DCC_PATH/config 	##MCCC_MCCC_CH0_FSC_STATUS0
    echo  0xffd038  1 > $DCC_PATH/config 	##MCCC_MCCC_CH0_FSC_STATUS3
    echo  0xffd12c  1 > $DCC_PATH/config 	##MCCC_MCCC_CH1_FSC_STATUS0
    echo  0xffd138  1 > $DCC_PATH/config 	##MCCC_MCCC_CH1_FSC_STATUS3
    echo  0x1086020 1 > $DCC_PATH/config 	##CH0_DDRCC_PLLCTRL_GCC_CTRL
    echo  0x1086028 1 > $DCC_PATH/config 	##CH0_DDRCC_PLLCTRL_CLK_SWITCH_STATUS
    echo  0x1086030 1 > $DCC_PATH/config 	##CH0_DDRCC_PLLCTRL_STATUS
    echo  0x1086124 1 > $DCC_PATH/config 	##CH0_DDRCC_PLL0_STATUS
    echo  0x1086164 1 > $DCC_PATH/config 	##CH0_DDRCC_PLL1_STATUS
    echo  0x10861dc 1 > $DCC_PATH/config 	##CH0_DDRCC_DLL0_STATUS
    echo  0x10861ec 1 > $DCC_PATH/config 	##CH0_DDRCC_DLL1_STATUS
    echo  0x1035070 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SHKE_MREG_RDATA_STATUS
    echo  0x1041070 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SHKE_MREG_RDATA_STATUS
    echo  0x10340b8 1 > $DCC_PATH/config 	##BIMC_S_DDR0_DPE_INTERRUPT_STATUS
    echo  0x103408c 1 > $DCC_PATH/config 	##BIMC_S_DDR0_DPE_DRAM_STATUS_0
    echo  0x1035074 1 > $DCC_PATH/config 	##BIMC_S_DDR0_SHKE_DRAM_STATUS

    ##BIMC_S_DDR0_SHKE_PERIODIC_MRR_RDATA
    echo 0x10350b0 4 > $DCC_PATH/config

    echo  0x10400b8 1 > $DCC_PATH/config 	##BIMC_S_DDR1_DPE_INTERRUPT_STATUS
    echo  0x1041074 1 > $DCC_PATH/config 	##BIMC_S_DDR1_SHKE_DRAM_STATUS

    ##BIMC_S_DDR1_SHKE_PERIODIC_MRR_RDATA
    echo  0x10410b0 4 > $DCC_PATH/config

    echo  0x1008100 1 > $DCC_PATH/config 	##BIMC_M_APP_MPORT_INTERRUPT_STATUS
    echo  0x1020100 1 > $DCC_PATH/config 	##BIMC_M_CDSP_MPORT_INTERRUPT_STATUS
    echo  0x100c100 1 > $DCC_PATH/config 	##BIMC_M_GPU_MPORT_INTERRUPT_STATUS
    echo  0x101c100 1 > $DCC_PATH/config 	##BIMC_M_MDSP_MPORT_INTERRUPT_STATUS
    echo  0x1010100 1 > $DCC_PATH/config 	##BIMC_M_MMSS_MPORT_INTERRUPT_STATUS
    echo  0x1018100 1 > $DCC_PATH/config 	##BIMC_M_PIMEM_MPORT_INTERRUPT_STATUS
    echo  0x1014100 1 > $DCC_PATH/config 	##BIMC_M_SYS_MPORT_INTERRUPT_STATUS



    echo  0x1030100 1 > $DCC_PATH/config     ##BIMC_S_DDR0_SCMO_INTERRUPT_STATUS
    echo  0x1030124 1 > $DCC_PATH/config     ##BIMC_S_DDR0_SCMO_ESYN_ADDR1
    echo  0x103012c 1 > $DCC_PATH/config     ##BIMC_S_DDR0_SCMO_ESYN_APACKET_1
    echo  0x1030130 1 > $DCC_PATH/config     ##BIMC_S_DDR0_SCMO_ESYN_APACKET_2
    echo  0x103c100 1 > $DCC_PATH/config     ##BIMC_S_DDR1_SCMO_INTERRUPT_STATUS
    echo  0x103c124 1 > $DCC_PATH/config     ##BIMC_S_DDR1_SCMO_ESYN_ADDR1
    echo  0x103c12c 1 > $DCC_PATH/config     ##BIMC_S_DDR1_SCMO_ESYN_APACKET_1
    echo  0x103c130 1 > $DCC_PATH/config     ##BIMC_S_DDR1_SCMO_ESYN_APACKET_2

    echo 0x01FC0804 1 > $DCC_PATH/config
    echo 0x00149024 1 > $DCC_PATH/config

    echo 0x7ba0078  4 > $DCC_PATH/config
    echo 0x7ba00A0  3 > $DCC_PATH/config
    echo 0x7ba4150  3 > $DCC_PATH/config
    echo 0x7ba4250  3 > $DCC_PATH/config

    echo 0x1008260  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_PIPE0_GATHERING
    echo 0x1008264  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_PIPE1_GATHERING
    echo 0x1008268  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_PIPE2_GATHERING
    echo 0x1008400  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_0A
    echo 0x1008404  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_0B
    echo 0x1008410  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_1A
    echo 0x1008420  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_2A
    echo 0x1008424  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_2B
    echo 0x1008430  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_3A
    echo 0x1008434  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_3B
    echo 0x1008440  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_4A
    echo 0x1008444  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_4B
    echo 0x1008450  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_5A
    echo 0x1008454  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_5B
    echo 0x1008460  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_6A
    echo 0x1008464  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_6B
    echo 0x1008470  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_7A
    echo 0x1008474  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_7B
    echo 0x1008480  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_8A
    echo 0x1008484  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_8B
    echo 0x1008490  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_9A
    echo 0x1008494  1 > $DCC_PATH/config     ##BIMC_M_APP_MPORT_STATUS_9B

    echo 0x100c260  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_PIPE0_GATHERING
    echo 0x100c264  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_PIPE1_GATHERING
    echo 0x100c268  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_PIPE2_GATHERING
    echo 0x100c400  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_0A
    echo 0x100c404  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_0B
    echo 0x100c410  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_1A
    echo 0x100c420  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_2A
    echo 0x100c424  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_2B
    echo 0x100c430  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_3A
    echo 0x100c434  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_3B
    echo 0x100c440  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_4A
    echo 0x100c444  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_4B
    echo 0x100c450  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_5A
    echo 0x100c454  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_5B
    echo 0x100c460  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_6A
    echo 0x100c464  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_6B
    echo 0x100c470  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_7A
    echo 0x100c474  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_7B
    echo 0x100c480  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_8A
    echo 0x100c484  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_8B
    echo 0x100c490  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_9A
    echo 0x100c494  1 > $DCC_PATH/config     ##BIMC_M_GPU_MPORT_STATUS_9B

    echo 0x1010260  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_PIPE0_GATHERING
    echo 0x1010264  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_PIPE1_GATHERING
    echo 0x1010268  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_PIPE2_GATHERING
    echo 0x1010400  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_0A
    echo 0x1010404  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_0B
    echo 0x1010410  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_1A
    echo 0x1010420  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_2A
    echo 0x1010424  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_2B
    echo 0x1010430  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_3A
    echo 0x1010434  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_3B
    echo 0x1010440  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_4A
    echo 0x1010444  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_4B
    echo 0x1010450  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_5A
    echo 0x1010454  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_5B
    echo 0x1010460  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_6A
    echo 0x1010464  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_6B
    echo 0x1010470  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_7A
    echo 0x1010474  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_7B
    echo 0x1010480  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_8A
    echo 0x1010484  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_8B
    echo 0x1010490  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_9A
    echo 0x1010494  1 > $DCC_PATH/config     ##BIMC_M_MMSS_MPORT_STATUS_9B

    echo 0x1014260  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_PIPE0_GATHERING
    echo 0x1014264  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_PIPE1_GATHERING
    echo 0x1014268  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_PIPE2_GATHERING
    echo 0x1014400  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_0A
    echo 0x1014404  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_0B
    echo 0x1014410  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_1A
    echo 0x1014420  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_2A
    echo 0x1014424  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_2B
    echo 0x1014430  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_3A
    echo 0x1014434  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_3B
    echo 0x1014440  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_4A
    echo 0x1014444  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_4B
    echo 0x1014450  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_5A
    echo 0x1014454  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_5B
    echo 0x1014460  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_6A
    echo 0x1014464  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_6B
    echo 0x1014470  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_7A
    echo 0x1014474  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_7B
    echo 0x1014480  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_8A
    echo 0x1014484  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_8B
    echo 0x1014490  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_9A
    echo 0x1014494  1 > $DCC_PATH/config     ##BIMC_M_SYS_MPORT_STATUS_9B

    echo 0x1018260  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_PIPE0_GATHERING
    echo 0x1018264  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_PIPE1_GATHERING
    echo 0x1018268  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_PIPE2_GATHERING
    echo 0x1018400  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_0A
    echo 0x1018404  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_0B
    echo 0x1018410  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_1A
    echo 0x1018420  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_2A
    echo 0x1018424  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_2B
    echo 0x1018430  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_3A
    echo 0x1018434  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_3B
    echo 0x1018440  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_4A
    echo 0x1018444  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_4B
    echo 0x1018450  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_5A
    echo 0x1018454  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_5B
    echo 0x1018460  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_6A
    echo 0x1018464  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_6B
    echo 0x1018470  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_7A
    echo 0x1018474  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_7B
    echo 0x1018480  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_8A
    echo 0x1018484  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_8B
    echo 0x1018490  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_9A
    echo 0x1018494  1 > $DCC_PATH/config     ##BIMC_M_PIMEM_MPORT_STATUS_9B

    echo 0x101c260  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_PIPE0_GATHERING
    echo 0x101c264  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_PIPE1_GATHERING
    echo 0x101c268  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_PIPE2_GATHERING
    echo 0x101c400  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_0A
    echo 0x101c404  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_0B
    echo 0x101c410  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_1A
    echo 0x101c420  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_2A
    echo 0x101c424  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_2B
    echo 0x101c430  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_3A
    echo 0x101c434  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_3B
    echo 0x101c440  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_4A
    echo 0x101c444  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_4B
    echo 0x101c450  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_5A
    echo 0x101c454  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_5B
    echo 0x101c460  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_6A
    echo 0x101c464  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_6B
    echo 0x101c470  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_7A
    echo 0x101c474  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_7B
    echo 0x101c480  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_8A
    echo 0x101c484  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_8B
    echo 0x101c490  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_9A
    echo 0x101c494  1 > $DCC_PATH/config     ##BIMC_M_MDSP_MPORT_STATUS_9B

    echo 0x1020260  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_PIPE0_GATHERING
    echo 0x1020264  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_PIPE1_GATHERING
    echo 0x1020268  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_PIPE2_GATHERING
    echo 0x1020400  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_0A
    echo 0x1020404  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_0B
    echo 0x1020410  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_1A
    echo 0x1020420  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_2A
    echo 0x1020424  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_2B
    echo 0x1020430  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_3A
    echo 0x1020434  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_3B
    echo 0x1020440  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_4A
    echo 0x1020444  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_4B
    echo 0x1020450  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_5A
    echo 0x1020454  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_5B
    echo 0x1020460  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_6A
    echo 0x1020464  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_6B
    echo 0x1020470  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_7A
    echo 0x1020474  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_7B
    echo 0x1020480  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_8A
    echo 0x1020484  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_8B
    echo 0x1020490  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_9A
    echo 0x1020494  1 > $DCC_PATH/config     ##BIMC_M_CDSP_MPORT_STATUS_9B

    echo 0x1049800  1 > $DCC_PATH/config     ##BIMC_S_APP_ARB_STATUS_0A
    echo 0x1051800  1 > $DCC_PATH/config     ##BIMC_S_SYS0_ARB_STATUS_0A
    echo 0x1031800  1 > $DCC_PATH/config     ##BIMC_S_DDR0_ARB_STATUS_0A
    echo 0x103d800  1 > $DCC_PATH/config     ##BIMC_S_DDR1_ARB_STATUS_0A
    echo 0x1048400  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_0A
    echo 0x1050400  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_0A
    echo 0x1048404  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_0B
    echo 0x1048408  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_0C
    echo 0x104840c  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_0D
    echo 0x1048410  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_1A
    echo 0x1048414  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_1B
    echo 0x1048418  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_1C
    echo 0x1048420  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_2A
    echo 0x1048424  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_2B
    echo 0x1048428  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_2C
    echo 0x104842c  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_2D
    echo 0x1048430  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_3A
    echo 0x1048434  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_3B
    echo 0x1048438  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_3C
    echo 0x104843c  1 > $DCC_PATH/config     ##BIMC_S_APP_SWAY_STATUS_3D
    echo 0x1050404  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_0B
    echo 0x1050408  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_0C
    echo 0x105040c  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_0D
    echo 0x1050410  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_1A
    echo 0x1050414  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_1B
    echo 0x1050418  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_1C
    echo 0x1050420  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_2A
    echo 0x1050424  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_2B
    echo 0x1050428  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_2C
    echo 0x105042c  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_2D
    echo 0x1050430  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_3A
    echo 0x1050434  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_3B
    echo 0x1050438  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_3C
    echo 0x105043c  1 > $DCC_PATH/config     ##BIMC_S_SYS0_SWAY_STATUS_3D

    ##PIMEM registers
    echo 0x00610070 9 > $DCC_PATH/config
    echo 0x006100D0 2 > $DCC_PATH/config

    ##GIC registers
    echo 0x17A00100 20 > $DCC_PATH/config
    echo 0x17A00200 20 > $DCC_PATH/config
    echo 0x17B10100 > $DCC_PATH/config
    echo 0x17B10200 > $DCC_PATH/config
    echo 0x17B30100 > $DCC_PATH/config
    echo 0x17B30200 > $DCC_PATH/config
    echo 0x17B50100 > $DCC_PATH/config
    echo 0x17B50200 > $DCC_PATH/config
    echo 0x17B70100 > $DCC_PATH/config
    echo 0x17B70200 > $DCC_PATH/config
    echo 0x17B90100 > $DCC_PATH/config
    echo 0x17B90200 > $DCC_PATH/config
    echo 0x17B90100 > $DCC_PATH/config
    echo 0x17BB0200 > $DCC_PATH/config
    echo 0x17BB0100 > $DCC_PATH/config
    echo 0x17BD0200 > $DCC_PATH/config
    echo 0x17BD0100 > $DCC_PATH/config
    echo 0x17BF0200 > $DCC_PATH/config
    echo 0x17BF0100 > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

# Function MSM8996 DCC configuration
enable_msm8996_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/4b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo  1 > $DCC_PATH/config_reset

    #SPM Registers
    # CPU0
    echo  0x998000C > $DCC_PATH/config
    echo  0x9980030 > $DCC_PATH/config
    echo  0x998003C > $DCC_PATH/config
    # CPU1
    echo  0x999000C > $DCC_PATH/config
    echo  0x9990030 > $DCC_PATH/config
    echo  0x999003C > $DCC_PATH/config
    # CPU2
    echo  0x99B000C > $DCC_PATH/config
    echo  0x99B0030 > $DCC_PATH/config
    echo  0x99B003C > $DCC_PATH/config
    # CPU3
    echo  0x99C000C > $DCC_PATH/config
    echo  0x99C0030 > $DCC_PATH/config
    echo  0x99C003C > $DCC_PATH/config
    # PWRL2
    echo  0x99A000C > $DCC_PATH/config
    echo  0x99A0030 > $DCC_PATH/config
    echo  0x99A003C > $DCC_PATH/config
    # PERFL2
    echo  0x99D000C > $DCC_PATH/config
    echo  0x99D0030 > $DCC_PATH/config
    echo  0x99D003C > $DCC_PATH/config
    # L3
    echo  0x9A0000C > $DCC_PATH/config
    echo  0x9A00030 > $DCC_PATH/config
    echo  0x9A0003C > $DCC_PATH/config
    # CBF
    echo  0x9A1000C > $DCC_PATH/config
    echo  0x9A10030 > $DCC_PATH/config
    echo  0x9A1003C > $DCC_PATH/config
    # PWR L2 HW-FLUSH
    echo  0x99A1060 > $DCC_PATH/config
    # PERF L2 HW-FLUSH
    echo  0x99D1060 > $DCC_PATH/config
    # APCS_APC0_SLEEP_EN_VOTE
    echo  0x99A2030 > $DCC_PATH/config
    # APCS_APCC_SW_EN_VOTE
    echo  0x99E0020 > $DCC_PATH/config
    # pIMEM
    echo  0x0038070 > $DCC_PATH/config
    echo  0x0038074 > $DCC_PATH/config
    echo  0x0038078 > $DCC_PATH/config
    echo  0x003807C > $DCC_PATH/config
    echo  0x0038080 > $DCC_PATH/config
    echo  0x0038084 > $DCC_PATH/config
    echo  0x0038088 > $DCC_PATH/config
    echo  0x003808C > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

# Function MSM8937 DCC configuration
enable_msm8937_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo  1 > $DCC_PATH/config_reset


    #Cpu Debugging registers
    #echo 0x61C0038  > $DCC_PATH/config
    #echo 0x61C0038  > $DCC_PATH/config
    #echo 0x61C0038  > $DCC_PATH/config
    #echo 0x61C0038  > $DCC_PATH/config
    #echo 0x61C0038  > $DCC_PATH/config
    #echo 0x61C0038  > $DCC_PATH/config
    #echo 0x61C0038  > $DCC_PATH/config
    #echo 0x61C0038  > $DCC_PATH/config
    #echo 0x61C2CB0 > $DCC_PATH/config
    #echo 0x61C004C > $DCC_PATH/config
    #echo 0x61C0054 7 > $DCC_PATH/config
    #echo 0x61C0074 > $DCC_PATH/config
    #echo 0x61C100C > $DCC_PATH/config
    #echo 0x61C1014 2 > $DCC_PATH/config
    #echo 0x61C1020 3 > $DCC_PATH/config
    #echo 0x61C1030 > $DCC_PATH/config
    #echo 0x61C0858 > $DCC_PATH/config
    #echo 0x61C08B0 > $DCC_PATH/config
    #echo 0x61C200C > $DCC_PATH/config
    #echo 0x61C2014 > $DCC_PATH/config
    #echo 0x61C2458 > $DCC_PATH/config
    #echo 0x61C0080 2 > $DCC_PATH/config
    #echo 0x61C00A0 2 > $DCC_PATH/config
    #echo 0x61C0078 > $DCC_PATH/config
    #echo 0x61C0008 > $DCC_PATH/config
    #echo 0x61C1038 > $DCC_PATH/config

    #APCS_ALIAS0_APSS_ACS
    echo 0xB188004 2 > $DCC_PATH/config
    echo 0xB189030 1 > $DCC_PATH/config
    echo 0xB18900C 1 > $DCC_PATH/config
    echo 0xB189014 1 > $DCC_PATH/config

    #APCS_ALIAS1_APSS_ACS
    echo 0xB198004 2 > $DCC_PATH/config
    echo 0xB199030 1 > $DCC_PATH/config
    echo 0xB19900C 1 > $DCC_PATH/config
    echo 0xB199014 1 > $DCC_PATH/config

    #APCS_ALIAS2_APSS_ACS
    echo 0xB1A8004 2 > $DCC_PATH/config
    echo 0xB1A9030 1 > $DCC_PATH/config
    echo 0xB1A900C 1 > $DCC_PATH/config
    echo 0xB1A9014 1 > $DCC_PATH/config

    #APCS_ALIAS3_APSS_ACS
    echo 0xB1B8004 2 > $DCC_PATH/config
    echo 0xB1B9030 1 > $DCC_PATH/config
    echo 0xB1B900C 1 > $DCC_PATH/config
    echo 0xB1B9014 1 > $DCC_PATH/config

    #APCLUS0_L2_SAW4_1_1_SPM
    echo 0xB111014 > $DCC_PATH/config
    echo 0xB111218 > $DCC_PATH/config
    echo 0xB111234 > $DCC_PATH/config
    echo 0xB112030 > $DCC_PATH/config
    echo 0xB112008 2 > $DCC_PATH/config
    echo 0xB112014 > $DCC_PATH/config

    #APCS_ALIAS4_APSS_ACS
    echo 0xB088004 2 > $DCC_PATH/config
    #APCS_ALIAS4_SAW2_1_1_SPM
    echo 0xB089030 > $DCC_PATH/config
    #APCS_ALIAS4_SAW2_1_1_STS
    echo 0xB08900C > $DCC_PATH/config
    echo 0xB089014 > $DCC_PATH/config

    #APCS_ALIAS5_APSS_ACS
    echo 0xB098004 2 > $DCC_PATH/config
    #APCS_ALIAS5_SAW2_1_1_SPM
    echo 0xB099030 > $DCC_PATH/config
    #APCS_ALIAS5_SAW2_1_1_STS
    echo 0xB09900C > $DCC_PATH/config
    echo 0xB099014 > $DCC_PATH/config

    #APCS_ALIAS6_APSS_ACS
    echo 0xB0A8004 2 > $DCC_PATH/config
    #APCS_ALIAS6_SAW2_1_1_SPM
    echo 0xB0A9030 > $DCC_PATH/config
    #APCS_ALIAS6_SAW2_1_1_STS
    echo 0xB0A900C > $DCC_PATH/config
    echo 0xB0A9014 > $DCC_PATH/config

    #APCS_ALIAS7_APSS_ACS
    echo 0xB0B8004 2 > $DCC_PATH/config
    #APCS_ALIAS7_SAW2_1_1_SPM
    echo 0xB0B9030 > $DCC_PATH/config
    #APCS_ALIAS7_SAW2_1_1_STS
    echo 0xB0B900C > $DCC_PATH/config
    echo 0xB0B9014 > $DCC_PATH/config

    #APCS_ALIAS1_APSS_GLB
    echo 0xB011014 2 > $DCC_PATH/config
    echo 0xB011218 > $DCC_PATH/config
    echo 0xB011234 > $DCC_PATH/config

    #APCLUS1_L2_SAW2_1_1_SPM
    echo 0xB012030 > $DCC_PATH/config
    echo 0xB012008 > $DCC_PATH/config

    #APCLUS1_L2_SAW2_1_1_STS
    echo 0xB01200C > $DCC_PATH/config
    echo 0xB012014 > $DCC_PATH/config

    #DDR
    echo 0x448560 1 > $DCC_PATH/config
    echo 0x4485A0 1 > $DCC_PATH/config
    echo 0x448520 1 > $DCC_PATH/config
    echo 0x448450 1 > $DCC_PATH/config
    echo 0x44C08C 1 > $DCC_PATH/config
    echo 0x44C09C 1 > $DCC_PATH/config
    echo 0x408420 1 > $DCC_PATH/config
    echo 0x408424 1 > $DCC_PATH/config
    echo 0x408430 1 > $DCC_PATH/config
    echo 0x408434 1 > $DCC_PATH/config
    echo 0x414100 1 > $DCC_PATH/config
    echo 0x414420 1 > $DCC_PATH/config
    echo 0x414424 1 > $DCC_PATH/config
    echo 0x414430 1 > $DCC_PATH/config
    echo 0x414434 1 > $DCC_PATH/config
    echo 0x41C420 1 > $DCC_PATH/config
    echo 0x41C424 1 > $DCC_PATH/config
    echo 0x41C430 1 > $DCC_PATH/config
    echo 0x41C434 1 > $DCC_PATH/config
    echo 0x410420 1 > $DCC_PATH/config
    echo 0x410424 1 > $DCC_PATH/config
    echo 0x410430 1 > $DCC_PATH/config
    echo 0x410434 1 > $DCC_PATH/config
    echo 0x420420 1 > $DCC_PATH/config
    echo 0x420424 1 > $DCC_PATH/config
    echo 0x420430 1 > $DCC_PATH/config
    echo 0x420434 1 > $DCC_PATH/config
    echo 0x40C420 1 > $DCC_PATH/config
    echo 0x40C424 1 > $DCC_PATH/config
    echo 0x40C430 1 > $DCC_PATH/config
    echo 0x40C434 1 > $DCC_PATH/config

    #PCNOC
    #echo 0x500004 6 > $DCC_PATH/config
    #echo 0x500020 3 > $DCC_PATH/config
    #echo 0x500038 1 > $DCC_PATH/config

    #SNOC
    #echo 0x580004 6 > $DCC_PATH/config
    #echo 0x580020 3 > $DCC_PATH/config
    #echo 0x580038 1 > $DCC_PATH/config

    #BIMC
    #echo 0x458000 1 > $DCC_PATH/config
    #echo 0x458020 1 > $DCC_PATH/config
    #echo 0x458030 1 > $DCC_PATH/config
    #echo 0x458100 1 > $DCC_PATH/config
    #echo 0x458108 2 > $DCC_PATH/config
    #echo 0x458400 1 > $DCC_PATH/config
    #echo 0x458410 1 > $DCC_PATH/config
    #echo 0x458420 1 > $DCC_PATH/config
    #echo 0x448010 1 > $DCC_PATH/config
    #echo 0x448100 1 > $DCC_PATH/config
    #echo 0x44810C 1 > $DCC_PATH/config
    #echo 0x448120 1 > $DCC_PATH/config
    #echo 0x448128 2 > $DCC_PATH/config
    #echo 0x448130 1 > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

# Function MSM8953 DCC configuration
enable_msm8953_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink

    #GCC_GPLL0
    echo 0x1821000 0x9 > $DCC_PATH/config

    #GCC_GPLL2
    echo 0x184A000 0x1 > $DCC_PATH/config
    echo 0x184A010 0x5 > $DCC_PATH/config

    #GCC_GPLL4
    echo 0x1824000 0x1 > $DCC_PATH/config
    echo 0x1824010 0x5 > $DCC_PATH/config

    #GCC_GPLL5
    echo 0x1825000 0x2 > $DCC_PATH/config
    echo 0x1825010 0x1 > $DCC_PATH/config
    echo 0x1825018 0x2 > $DCC_PATH/config
    echo 0x1825024 0x1 > $DCC_PATH/config

    #GCC_BIMC
    echo 0x1823000 0x2 > $DCC_PATH/config
    echo 0x1823010 0x1 > $DCC_PATH/config
    echo 0x1823018 0x2 > $DCC_PATH/config
    echo 0x1823024 0x1 > $DCC_PATH/config

    #GCC_GPLL6
    echo 0x1837000 0x1 > $DCC_PATH/config
    echo 0x1837010 0x1 > $DCC_PATH/config
    echo 0x1837018 0x2 > $DCC_PATH/config
    echo 0x1837024 0x1 > $DCC_PATH/config

    #GCC_SYSTEM_NOC
    echo 0x1826004 0x2 > $DCC_PATH/config

    #GCC_PCNOC
    echo 0x1827000 0x2 > $DCC_PATH/config

    #GCC_SYSTEM_MMNOC
    echo 0x183D000 0x2 > $DCC_PATH/config

    #GCC_DDR
    echo 0x1832024 0x2 > $DCC_PATH/config

    #GCC_BIMC
    echo 0x1831018 0x1 > $DCC_PATH/config
    echo 0x1831004 0x1 > $DCC_PATH/config
    echo 0x1831024 0x3 > $DCC_PATH/config

    #GCC_Q6
    echo 0x1838030 0x2 > $DCC_PATH/config

    #GCC_APSS_TCU
    echo 0x1838000 0x2 > $DCC_PATH/config

    #GCC_APSS_AXI
    echo 0x1838048 0x2 > $DCC_PATH/config

    # OCIMEM START  #MARK the start
    echo 0x00448560 1 > $DCC_PATH/config
    echo 0x004485A0 1 > $DCC_PATH/config
    echo 0x00448520 1 > $DCC_PATH/config
    echo 0x00448450 1 > $DCC_PATH/config
    echo 0x0044C08C 1 > $DCC_PATH/config
    echo 0x0044C09C 1 > $DCC_PATH/config
    echo 0x00408420 1 > $DCC_PATH/config
    echo 0x00408424 1 > $DCC_PATH/config
    echo 0x00408430 1 > $DCC_PATH/config
    echo 0x00408434 1 > $DCC_PATH/config
    echo 0x0041c100 1 > $DCC_PATH/config
    echo 0x0041c420 1 > $DCC_PATH/config
    echo 0x0041c424 1 > $DCC_PATH/config
    echo 0x0041c430 1 > $DCC_PATH/config
    echo 0x0041c434 1 > $DCC_PATH/config

    echo 0x0040C420 1 > $DCC_PATH/config
    echo 0x0040C424 1 > $DCC_PATH/config
    echo 0x0040C430 1 > $DCC_PATH/config
    echo 0x0040C434 1 > $DCC_PATH/config

    echo 0x00414100 1 > $DCC_PATH/config
    echo 0x00414420 1 > $DCC_PATH/config
    echo 0x00414424 1 > $DCC_PATH/config
    echo 0x00414430 1 > $DCC_PATH/config
    echo 0x00414434 1 > $DCC_PATH/config
    echo 0x00418420 1 > $DCC_PATH/config
    echo 0x00418424 1 > $DCC_PATH/config
    echo 0x00418430 1 > $DCC_PATH/config
    echo 0x00418434 1 > $DCC_PATH/config

    echo 0x00410420 1 > $DCC_PATH/config
    echo 0x00410424 1 > $DCC_PATH/config
    echo 0x00410430 1 > $DCC_PATH/config
    echo 0x00410434 1 > $DCC_PATH/config

    echo 0x00420420 1 > $DCC_PATH/config
    echo 0x00420424 1 > $DCC_PATH/config
    echo 0x00420430 1 > $DCC_PATH/config
    echo 0x00420434 1 > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

# Function SDM632 DCC configuration
enable_sdm632_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo  1 > $DCC_PATH/config_reset
    #GCC_GPLL0
    # echo 0x1821000 9 > $DCC_PATH/config

    #GCC_GPLL2
    # echo 0x184A000 1 > $DCC_PATH/config
    # echo 0x184A010 5 > $DCC_PATH/config

    #GCC_GPLL4
    # echo 0x1824000 1 > $DCC_PATH/config
    # echo 0x1824010 5 > $DCC_PATH/config

    #GCC_GPLL5
    # echo 0x1825000 2 > $DCC_PATH/config
    # echo 0x1825010 1 > $DCC_PATH/config
    # echo 0x1825018 2 > $DCC_PATH/config
    # echo 0x1825024 1 > $DCC_PATH/config

    #GCC_BIMC
    # echo 0x1823000 2 > $DCC_PATH/config
    # echo 0x1823010 1 > $DCC_PATH/config
    # echo 0x1823018 2 > $DCC_PATH/config
    # echo 0x1823024 1 > $DCC_PATH/config

    #GCC_GPLL6
    # echo 0x1837000 1 > $DCC_PATH/config
    # echo 0x1837010 1 > $DCC_PATH/config
    # echo 0x1837018 2 > $DCC_PATH/config
    # echo 0x1837024 1 > $DCC_PATH/config

    #GCC_SYSTEM_NOC
    # echo 0x1826004 2 > $DCC_PATH/config

    #GCC_PCNOC
    # echo 0x1827000 2 > $DCC_PATH/config

    #GCC_SYSTEM_MMNOC
    # echo 0x183D000 2 > $DCC_PATH/config

    #GCC_DDR
    # echo 0x1832024 2 > $DCC_PATH/config

    #GCC_BIMC
    # echo 0x1831018 1 > $DCC_PATH/config
    # echo 0x1831004 1 > $DCC_PATH/config
    # echo 0x1831024 3 > $DCC_PATH/config
    # echo 0x1831024 3 > $DCC_PATH/config
    #GCC_Q6
    # echo 0x1838030 2 > $DCC_PATH/config

    #GCC_APSS_TCU
    # echo 0x1838000 2 > $DCC_PATH/config

    #GCC_APSS_AXI
    # echo 0x1838048 2 > $DCC_PATH/config

    #APCS_ALIAS0_APSS_ACS
    echo 0xB188004 2 > $DCC_PATH/config
    echo 0xB188064 1 > $DCC_PATH/config
    echo 0xB189000 1 > $DCC_PATH/config
    echo 0xB189C0C 1 > $DCC_PATH/config
    echo 0xB189C18 1 > $DCC_PATH/config

    #APCS_ALIAS1_APSS_ACS
    echo 0xB198004 2 > $DCC_PATH/config
    echo 0xB198064 1 > $DCC_PATH/config
    echo 0xB199000 1 > $DCC_PATH/config
    echo 0xB199C0C 1 > $DCC_PATH/config
    echo 0xB199C18 1 > $DCC_PATH/config

    #APCS_ALIAS2_APSS_ACS
    echo 0xB1A8004 2 > $DCC_PATH/config
    echo 0xB1A8064 1 > $DCC_PATH/config
    echo 0xB1A9000 1 > $DCC_PATH/config
    echo 0xB1A9C0C 1 > $DCC_PATH/config
    echo 0xB1A9C18 1 > $DCC_PATH/config

    #APCS_ALIAS3_APSS_ACS
    echo 0xB1B8004 2 > $DCC_PATH/config
    echo 0xB1B8064 1 > $DCC_PATH/config
    echo 0xB1B9000 1 > $DCC_PATH/config
    echo 0xB1B9C0C 1 > $DCC_PATH/config
    echo 0xB1B9C18 1 > $DCC_PATH/config

    #APCLUS0_L2_SAW4_1_1_SPM
    # echo 0xB111014 > $DCC_PATH/config
    # echo 0xB111210 > $DCC_PATH/config
    # echo 0xB111218 > $DCC_PATH/config
    # echo 0xB111234 > $DCC_PATH/config
    # echo 0xB1112B4 > $DCC_PATH/config
    echo 0xB112000 2 > $DCC_PATH/config
    echo 0xB11200C > $DCC_PATH/config
    echo 0xB112C0C > $DCC_PATH/config
    echo 0xB112C18 > $DCC_PATH/config

    #APCS_ALIAS4_APSS_ACS
    echo 0xB088004 2 > $DCC_PATH/config
    echo 0xB088064 > $DCC_PATH/config
    #APCS_ALIAS4_SAW4_1_1_SPM
    echo 0xB089000 > $DCC_PATH/config
    #APCS_ALIAS4_SAW4_1_1_STS
    echo 0xB089C0C > $DCC_PATH/config
    echo 0xB089C18 > $DCC_PATH/config

    #APCS_ALIAS5_APSS_ACS
    echo 0xB098004 2 > $DCC_PATH/config
    echo 0xB098064 > $DCC_PATH/config
    #APCS_ALIAS5_SAW4_1_1_SPM
    echo 0xB099000 > $DCC_PATH/config
    #APCS_ALIAS5_SAW4_1_1_STS
    echo 0xB099C0C > $DCC_PATH/config
    echo 0xB099C18 > $DCC_PATH/config

    #APCS_ALIAS6_APSS_ACS
    echo 0xB0A8004 2 > $DCC_PATH/config
    echo 0xB0A8064 > $DCC_PATH/config
    #APCS_ALIAS6_SAW4_1_1_SPM
    echo 0xB0A9000 > $DCC_PATH/config
    #APCS_ALIAS6_SAW4_1_1_STS
    echo 0xB0A9C0C > $DCC_PATH/config
    echo 0xB0A9C18 > $DCC_PATH/config

    #APCS_ALIAS7_APSS_ACS
    echo 0xB0B8004 2 > $DCC_PATH/config
    echo 0xB0B8064 > $DCC_PATH/config
    #APCS_ALIAS7_SAW4_1_1_SPM
    echo 0xB0B9000 > $DCC_PATH/config
    #APCS_ALIAS7_SAW4_1_1_STS
    echo 0xB0B9C0C > $DCC_PATH/config
    echo 0xB0B9C18 > $DCC_PATH/config

    #APCS_ALIAS1_APSS_GLB
    # echo 0xB011014 > $DCC_PATH/config
    # echo 0xB011018 > $DCC_PATH/config
    # echo 0xB011210 > $DCC_PATH/config
    # echo 0xB011218 > $DCC_PATH/config
    # echo 0xB011234 > $DCC_PATH/config
    # echo 0xB0112B4 > $DCC_PATH/config

    #APCLUS1_L2_SAW4_SPM
    echo 0xB012000 2 > $DCC_PATH/config
    echo 0xB01200C > $DCC_PATH/config
    #APCLUS1_L2_SAW4_STS
    echo 0xB012C0C  > $DCC_PATH/config
    echo 0xB012C18 > $DCC_PATH/config
    #APCLUS0_L2_SAW4_SPM
    echo 0xB112000 2 > $DCC_PATH/config
    echo 0xB11200C > $DCC_PATH/config
    #APCLUS0_L2_SAW4_STS
    echo 0xB112C0C > $DCC_PATH/config
    echo 0xB112C18 > $DCC_PATH/config

    #CCI_SAW4_SPM
    echo 0xB1D2000 > $DCC_PATH/config
    echo 0xB1D200C > $DCC_PATH/config
    #CCI_SAW4_STS
    echo 0xB1D2C0C > $DCC_PATH/config
    echo 0xB1D2C18 > $DCC_PATH/config

    #Cpu Debugging registers
    echo 0x61C0038  > $DCC_PATH/config
    echo 0x61C0038  > $DCC_PATH/config
    echo 0x61C0038  > $DCC_PATH/config
    echo 0x61C0038  > $DCC_PATH/config
    echo 0x61C0038  > $DCC_PATH/config
    echo 0x61C0038  > $DCC_PATH/config
    echo 0x61C0038  > $DCC_PATH/config
    echo 0x61C0038  > $DCC_PATH/config
    echo 0x61C0008 > $DCC_PATH/config
    echo 0x61C004C > $DCC_PATH/config
    echo 0x61C0054 7 > $DCC_PATH/config
    echo 0x61C0078 > $DCC_PATH/config
    echo 0x61C0080 2 > $DCC_PATH/config
    echo 0x61C00A0 2 > $DCC_PATH/config
    echo 0x61C0858 > $DCC_PATH/config
    echo 0x61C08B0 > $DCC_PATH/config
    echo 0x61C100C > $DCC_PATH/config
    echo 0x61C1014 2 > $DCC_PATH/config
    echo 0x61C1020 3 > $DCC_PATH/config
    echo 0x61C1030 > $DCC_PATH/config
    echo 0x61C1038 > $DCC_PATH/config
    echo 0x61C200C > $DCC_PATH/config
    echo 0x61C2014 > $DCC_PATH/config
    echo 0x61C2458 > $DCC_PATH/config
    echo 0x61C2CB0 > $DCC_PATH/config

    # OCIMEM START  #MARK the start
    # echo 0x00448560 1 > $DCC_PATH/config
    # echo 0x004485A0 1 > $DCC_PATH/config
    # echo 0x00448520 1 > $DCC_PATH/config
    # echo 0x00448450 1 > $DCC_PATH/config
    # echo 0x0044C08C 1 > $DCC_PATH/config
    # echo 0x0044C09C 1 > $DCC_PATH/config
    # echo 0x00408420 1 > $DCC_PATH/config
    # echo 0x00408424 1 > $DCC_PATH/config
    # echo 0x00408430 1 > $DCC_PATH/config
    # echo 0x00408434 1 > $DCC_PATH/config
    # echo 0x0041c100 1 > $DCC_PATH/config
    # echo 0x0041c420 1 > $DCC_PATH/config
    # echo 0x0041c424 1 > $DCC_PATH/config
    # echo 0x0041c430 1 > $DCC_PATH/config
    # echo 0x0041c434 1 > $DCC_PATH/config

    # echo 0x0040C420 1 > $DCC_PATH/config
    # echo 0x0040C424 1 > $DCC_PATH/config
    # echo 0x0040C430 1 > $DCC_PATH/config
    # echo 0x0040C434 1 > $DCC_PATH/config

    # echo 0x00414100 1 > $DCC_PATH/config
    # echo 0x00414420 1 > $DCC_PATH/config
    # echo 0x00414424 1 > $DCC_PATH/config
    # echo 0x00414430 1 > $DCC_PATH/config
    # echo 0x00414434 1 > $DCC_PATH/config
    # echo 0x00418420 1 > $DCC_PATH/config
    # echo 0x00418424 1 > $DCC_PATH/config
    # echo 0x00418430 1 > $DCC_PATH/config
    # echo 0x00418434 1 > $DCC_PATH/config

    # echo 0x00410420 1 > $DCC_PATH/config
    # echo 0x00410424 1 > $DCC_PATH/config
    # echo 0x00410430 1 > $DCC_PATH/config
    # echo 0x00410434 1 > $DCC_PATH/config

    # echo 0x00420420 1 > $DCC_PATH/config
    # echo 0x00420424 1 > $DCC_PATH/config
    # echo 0x00420430 1 > $DCC_PATH/config
    # echo 0x00420434 1 > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

# Function MSM8976 DCC configuration
enable_msm8976_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/b3000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC don't exist on this build."
        return
    fi

    echo  0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo  1 > $DCC_PATH/config_reset

    #BIMC_S_DDR0
    echo 0x00448500 41 > $DCC_PATH/config
    echo 0x0044D070 2 > $DCC_PATH/config
    #BIMC_S_DDR1
    echo 0x00450500 41 > $DCC_PATH/config
    echo 0x00455070 2 > $DCC_PATH/config
    #BMIC_M_XXX_MPORT
    echo 0x00408400 30 > $DCC_PATH/config
    echo 0x0040C400 30 > $DCC_PATH/config
    echo 0x00410400 30 > $DCC_PATH/config
    echo 0x00414400 30 > $DCC_PATH/config
    echo 0x00418400 30 > $DCC_PATH/config
    #APCS_ALIAS_APSS_GLB
    echo 0x0B011014 2  > $DCC_PATH/config
    echo 0x0B011210 1  > $DCC_PATH/config
    echo 0x0B011218 1  > $DCC_PATH/config
    #APCLUS1_L2_SAW2
    echo 0x0B01200C 1  > $DCC_PATH/config
    echo 0x0B012030 1  > $DCC_PATH/config
    #APCS_ALIAS4_APSS_ACS
    echo 0x0B088004 2  > $DCC_PATH/config
    echo 0x0B088064 1  > $DCC_PATH/config
    echo 0x0B088090 1  > $DCC_PATH/config
    #APCS_ALIAS4_SAW2
    echo 0x0B08900C 1  > $DCC_PATH/config
    echo 0x0B089030 1  > $DCC_PATH/config
    #APCS_ALIAS5_APSS_ACS
    echo 0x0B098004 2  > $DCC_PATH/config
    echo 0x0B098064 1  > $DCC_PATH/config
    echo 0x0B098090 1  > $DCC_PATH/config
    #APCS_ALIAS5_SAW2
    echo 0x0B09900C 1  > $DCC_PATH/config
    echo 0x0B099030 1  > $DCC_PATH/config
    #APCS_ALIAS6_APSS_ACS
    echo 0x0B0A8004 2  > $DCC_PATH/config
    echo 0x0B0A8064 1  > $DCC_PATH/config
    echo 0x0B0A8090 1  > $DCC_PATH/config
    #APCS_ALIAS6_SAW2
    echo 0x0B0A900C 1  > $DCC_PATH/config
    echo 0x0B0A9030 1  > $DCC_PATH/config
    #APCS_ALIAS7_APSS_ACS
    echo 0x0B0B8004 2  > $DCC_PATH/config
    echo 0x0B0B8064 1  > $DCC_PATH/config
    echo 0x0B0B8090 1  > $DCC_PATH/config
    #APCS_ALIAS7_SAW2
    echo 0x0B0B900C 1  > $DCC_PATH/config
    echo 0x0B0B9030 1  > $DCC_PATH/config
    #APCS_ALIAS0_APSS_GLB
    echo 0x0B111014 2  > $DCC_PATH/config
    echo 0x0B111210 1  > $DCC_PATH/config
    echo 0x0B111218 1  > $DCC_PATH/config
    #APCLUS0_L2_SAW2
    echo 0x0B11200C 1  > $DCC_PATH/config
    echo 0x0B112030 1  > $DCC_PATH/config
    #APCS_ALIAS0_APSS_ACS
    echo 0x0B188004 2  > $DCC_PATH/config
    echo 0x0B188064 1  > $DCC_PATH/config
    #APCS_ALIAS0_SAW2
    echo 0x0B18900C 1  > $DCC_PATH/config
    echo 0x0B189030 1  > $DCC_PATH/config
    #APCS_ALIAS1_APSS_ACS
    echo 0x0B198004 2  > $DCC_PATH/config
    echo 0x0B198064 1  > $DCC_PATH/config
    #APCS_ALIAS1_SAW2
    echo 0x0B19900C 1  > $DCC_PATH/config
    echo 0x0B199030 1  > $DCC_PATH/config
    #APCS_ALIAS2_APSS_ACS
    echo 0x0B1A8004 2  > $DCC_PATH/config
    echo 0x0B1A8064 1  > $DCC_PATH/config
    #APCS_ALIAS2_SAW2
    echo 0x0B1A900C 1  > $DCC_PATH/config
    echo 0x0B1A9030 1  > $DCC_PATH/config
    #APCS_ALIAS3_APSS_ACS
    echo 0x0B1B8004 2  > $DCC_PATH/config
    echo 0x0B1B8064 1  > $DCC_PATH/config
    #APCS_ALIAS3_SAW2
    echo 0x0B1B900C 1  > $DCC_PATH/config
    echo 0x0B1B9030 1  > $DCC_PATH/config
    #APCS_COMMON_APSS_SHARED
    echo 0x0B1D1058 2  > $DCC_PATH/config
    echo 0x0B1D200C 1  > $DCC_PATH/config
    echo 0x0B1D2030 1  > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

# Function DCC configuration
enable_dcc_config()
{
    target=`getprop ro.board.platform`

    if [ -f /sys/devices/soc0/soc_id ]; then
        soc_id=`cat /sys/devices/soc0/soc_id`
    else
        soc_id=`cat /sys/devices/system/soc/soc0/id`
    fi

    case "$target" in
        "msm8996")
            echo "Enabling DCC config for 8996."
            enable_msm8996_dcc_config
            ;;

	"msm8998")
	    echo "Enabling DCC config for msm8998."
	    enable_msm8998_dcc_config
	    ;;

        "sdm660")
            echo "Enabling DCC config for sdm660."
            enable_sdm660_dcc_config
            ;;

        "apq8098_latv")
            echo "Enabling DCC config for apq8098_latv."
            enable_msm8998_dcc_config
            ;;

        "msm8953")
            case "$soc_id" in
                "349" | "450" | "632" | "439"| "338")
                    echo "Enabling DCC config for sdm632."
                    enable_sdm632_dcc_config
                    srcenable="enable_source"
                    sinkenable="enable_sink"
                    enable_sdm632_stm_events
                     ;;
                "*")
                    echo "Enabling DCC config for 8953."
                    enable_msm8953_dcc_config
                ;;
            esac
            ;;

        "msm8952")
            case "$soc_id" in
                "266" | "274" | "277" | "278")
                     echo "Enabling DCC config for 8976."
                     enable_msm8976_dcc_config
                     ;;
            esac
            ;;
        "msm8937")
            echo "Enabling DCC config for 8937."
            enable_msm8937_dcc_config
            case "$soc_id" in
                "353" | "354" | "363" | "364")
                     echo "Enabling DCC config for 439"
                     srcenable="enable_source"
                     sinkenable="enable_sink"
                     enable_sdm632_stm_events
                     ;;
            esac
            ;;

        "sdm845")
            echo "Enabling DCC config for sdm845."
            enable_sdm845_dcc_config
            ;;

    esac
}

enable_sdm845_core_hang_config()
{
    CORE_PATH_SILVER="/sys/devices/system/cpu/hang_detect_silver"
    CORE_PATH_GOLD="/sys/devices/system/cpu/hang_detect_gold"
    if [ ! -d $CORE_PATH ]; then
        echo "CORE hang does not exist on this build."
        return
    fi

    #set the threshold to around 100 milli-second
    echo 0xffffffff > $CORE_PATH_SILVER/threshold
    echo 0xffffffff > $CORE_PATH_GOLD/threshold

    #To the enable core hang detection
    echo 0x1 > $CORE_PATH_SILVER/enable
    echo 0x1 > $CORE_PATH_GOLD/enable
}

enable_msm8998_core_hang_config()
{
    CORE_PATH_SILVER="/sys/devices/system/cpu/hang_detect_silver"
    CORE_PATH_GOLD="/sys/devices/system/cpu/hang_detect_gold"
    if [ ! -d $CORE_PATH ]; then
        echo "CORE hang does not exist on this build."
        return
    fi

    #select instruction retire as the pmu event
    echo 0x7 > $CORE_PATH_SILVER/pmu_event_sel
    echo 0xA > $CORE_PATH_GOLD/pmu_event_sel

    #set the threshold to around 9 milli-second
    echo 0x2a300 > $CORE_PATH_SILVER/threshold
    echo 0x2a300 > $CORE_PATH_GOLD/threshold

    #To the enable core hang detection
    #echo 0x1 > /sys/devices/system/cpu/hang_detect_silver/enable
    #echo 0x1 > /sys/devices/system/cpu/hang_detect_gold/enable
}

enable_msm8998_osm_wdog_status_config()
{
    echo 1 > /sys/kernel/debug/osm/pwrcl_clk/wdog_trace_enable
    echo 1 > /sys/kernel/debug/osm/perfcl_clk/wdog_trace_enable
}

enable_msm8998_gladiator_hang_config()
{
    GLADIATOR_PATH="/sys/devices/system/cpu/gladiator_hang_detect"
    if [ ! -d $GLADIATOR_PATH ]; then
        echo "Gladiator hang does not exist on this build."
        return
    fi

    #set the threshold to around 9 milli-second
    echo 0x0002a300 > $GLADIATOR_PATH/ace_threshold
    echo 0x0002a300 > $GLADIATOR_PATH/io_threshold
    echo 0x0002a300 > $GLADIATOR_PATH/m1_threshold
    echo 0x0002a300 > $GLADIATOR_PATH/m2_threshold
    echo 0x0002a300 > $GLADIATOR_PATH/pcio_threshold

    #To enable gladiator hang detection
    #echo 0x1 > /sys/devices/system/cpu/gladiator_hang_detect/enable
}

enable_osm_wdog_status_config()
{
    target=`getprop ro.board.platform`

    case "$target" in
        "msm8998")
            echo "Enabling OSM WDOG status registers for msm8998"
            enable_msm8998_osm_wdog_status_config
        ;;
        "apq8098_latv")
            echo "Enabling OSM WDOG status registers for apq8098_latv"
            enable_msm8998_osm_wdog_status_config
        ;;
    esac
}

enable_core_gladiator_hang_config()
{
    target=`getprop ro.board.platform`

    case "$target" in
        "msmnile")
            echo "Enabling core & gladiator config for msmnile"
            enable_msmnile_core_hang_config
        ;;
        "sdm845")
            echo "Enabling core & gladiator config for sdm845"
            enable_sdm845_core_hang_config
        ;;
        "msm8998")
            echo "Enabling core & gladiator config for msm8998"
            enable_msm8998_core_hang_config
            enable_msm8998_gladiator_hang_config
        ;;
        "apq8098_latv")
            echo "Enabling core & gladiator config for apq8098_latv"
            enable_msm8998_core_hang_config
            enable_msm8998_gladiator_hang_config
        ;;
    esac
}

enable_schedstats()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi

    if [ -f /proc/sys/kernel/sched_schedstats ]
    then
        echo 1 > /proc/sys/kernel/sched_schedstats
    fi
}

coresight_config=`getprop persist.debug.coresight.config`
coresight_stm_cfg_done=`getprop ro.dbg.coresight.stm_cfg_done`
ftrace_disable=`getprop persist.debug.ftrace_events_disable`
srcenable="enable"
sinkenable="curr_sink"
etr_size="0x2000000"

#Android turns off tracing by default. Make sure tracing is turned on after boot is done
if [ ! -z $coresight_stm_cfg_done ]
then
    #echo 1 > /sys/kernel/debug/tracing/tracing_on
    exit
fi

#add permission for block_size, mem_type, mem_size nodes to collect diag over QDSS by ODL
#application by "oem_2902" group
chown -h root.oem_2902 /sys/devices/platform/soc/6048000.tmc/coresight-tmc-etr/block_size
chmod 660 /sys/devices/platform/soc/6048000.tmc/coresight-tmc-etr/block_size
chown -h root.oem_2902 /sys/devices/platform/soc/6048000.tmc/coresight-tmc-etr/mem_type
chmod 660 /sys/devices/platform/soc/6048000.tmc/coresight-tmc-etr/mem_type
chown -h root.oem_2902 /sys/devices/platform/soc/6048000.tmc/coresight-tmc-etr/mem_size
chmod 660 /sys/devices/platform/soc/6048000.tmc/coresight-tmc-etr/mem_size

enable_dcc_config
enable_core_gladiator_hang_config
enable_osm_wdog_status_config

case "$coresight_config" in
    "stm-events")
        case "$target" in
            "sdm660")
                echo "Enabling STM/Debug events for SDM660"
                enable_sdm660_debug
            ;;
            "sdm710" | "qcs605")
                echo "Enabling DCC/STM/Debug events for sdm710 and qcs605"
                enable_sdm710_debug
                setprop ro.vendor.dbg.coresight.stm_cfg_done 1
            ;;
            "sdm845")
                srcenable="enable_source"
                sinkenable="enable_sink"
                echo "Enabling STM events."
                enable_stm_events
                if [ "$ftrace_disable" != "Yes" ]; then
                    enable_ftrace_event_tracing
                fi
                setprop ro.vendor.dbg.coresight.stm_cfg_done 1
            ;;
            "sm6150")
                echo "Enabling DCC/STM/Debug events for talos"
                enable_talos_debug
                setprop ro.vendor.dbg.coresight.stm_cfg_done 1
            ;;
            "trinket")
                echo "Enabling DCC/STM/Debug events for trinket"
                enable_trinket_debug
                setprop ro.dbg.coresight.stm_cfg_done 1
            ;;
            "msmnile")
                echo "Enabling DCC/STM/Debug events for msmnile"
                enable_msmnile_debug
                setprop ro.vendor.dbg.coresight.stm_cfg_done 1
            ;;
            *)
                echo "Invalid target"
            ;;
        esac
        ;;
    *)
        echo "Skipping coresight configuration."
        exit
        ;;
esac

enable_schedstats
