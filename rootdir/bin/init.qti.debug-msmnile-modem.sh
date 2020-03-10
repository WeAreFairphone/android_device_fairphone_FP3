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

# Function msmnile DCC configuration
enable_msmnile_dcc_config_modem()
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

    echo 0x4200204 4 > $DCC_PATH/config
    echo 0x4200224 4 > $DCC_PATH/config
    echo 0x4200244 4 > $DCC_PATH/config
    echo 0x4200264 4 > $DCC_PATH/config
    echo 0x4200284 4 > $DCC_PATH/config
    echo 0x4200404 2 > $DCC_PATH/config
    echo 0x4200D00 2 > $DCC_PATH/config
    echo 0x4200D10 4 > $DCC_PATH/config
    echo 0x4200FB0 4 > $DCC_PATH/config
    echo 0x4201250 4 > $DCC_PATH/config
    echo 0x42014F0 4 > $DCC_PATH/config
    echo 0x4201790 4 > $DCC_PATH/config
    echo 0x4201A30 4 > $DCC_PATH/config
    echo 0x4201CD0 4 > $DCC_PATH/config
    echo 0x4200D30 4 > $DCC_PATH/config
    echo 0x4200D44 4 > $DCC_PATH/config
    echo 0x4200D58 4 > $DCC_PATH/config
    echo 0x4200D6C 4 > $DCC_PATH/config
    echo 0x4200D80 4 > $DCC_PATH/config
    echo 0x4200D94 4 > $DCC_PATH/config
    echo 0x4200DA8 4 > $DCC_PATH/config
    echo 0x4200DBC 4 > $DCC_PATH/config
    echo 0x4200DD0 4 > $DCC_PATH/config
    echo 0x4200DE4 4 > $DCC_PATH/config
    echo 0x4200DF8 4 > $DCC_PATH/config
    echo 0x4200E0C 4 > $DCC_PATH/config
    echo 0x4200E20 4 > $DCC_PATH/config
    echo 0x4200E34 4 > $DCC_PATH/config
    echo 0x4200E48 4 > $DCC_PATH/config
    echo 0x4200FD0 4 > $DCC_PATH/config
    echo 0x4200FE4 4 > $DCC_PATH/config
    echo 0x4200FF8 4 > $DCC_PATH/config
    echo 0x420100C 4 > $DCC_PATH/config
    echo 0x4201020 4 > $DCC_PATH/config
    echo 0x4201034 4 > $DCC_PATH/config
    echo 0x4201048 4 > $DCC_PATH/config
    echo 0x420105C 4 > $DCC_PATH/config
    echo 0x4201070 4 > $DCC_PATH/config
    echo 0x4201084 4 > $DCC_PATH/config
    echo 0x4201098 4 > $DCC_PATH/config
    echo 0x42010AC 4 > $DCC_PATH/config
    echo 0x42010C0 4 > $DCC_PATH/config
    echo 0x42010D4 4 > $DCC_PATH/config
    echo 0x42010E8 4 > $DCC_PATH/config
    echo 0x4201270 4 > $DCC_PATH/config
    echo 0x4201284 4 > $DCC_PATH/config
    echo 0x4201298 4 > $DCC_PATH/config
    echo 0x42012AC 4 > $DCC_PATH/config
    echo 0x42012C0 4 > $DCC_PATH/config
    echo 0x42012D4 4 > $DCC_PATH/config
    echo 0x42012E8 4 > $DCC_PATH/config
    echo 0x42012FC 4 > $DCC_PATH/config
    echo 0x4201310 4 > $DCC_PATH/config
    echo 0x4201324 4 > $DCC_PATH/config
    echo 0x4201338 4 > $DCC_PATH/config
    echo 0x420134C 4 > $DCC_PATH/config
    echo 0x4201360 4 > $DCC_PATH/config
    echo 0x4201374 4 > $DCC_PATH/config
    echo 0x4201388 4 > $DCC_PATH/config
    echo 0x4201510 4 > $DCC_PATH/config
    echo 0x4201524 4 > $DCC_PATH/config
    echo 0x4201538 4 > $DCC_PATH/config
    echo 0x420154C 4 > $DCC_PATH/config
    echo 0x4201560 4 > $DCC_PATH/config
    echo 0x4201574 4 > $DCC_PATH/config
    echo 0x4201588 4 > $DCC_PATH/config
    echo 0x420159C 4 > $DCC_PATH/config
    echo 0x42015B0 4 > $DCC_PATH/config
    echo 0x42015C4 4 > $DCC_PATH/config
    echo 0x42015D8 4 > $DCC_PATH/config
    echo 0x42015EC 4 > $DCC_PATH/config
    echo 0x4201600 4 > $DCC_PATH/config
    echo 0x4201614 4 > $DCC_PATH/config
    echo 0x4201628 4 > $DCC_PATH/config
    echo 0x42017B0 4 > $DCC_PATH/config
    echo 0x42017C4 4 > $DCC_PATH/config
    echo 0x42017D8 4 > $DCC_PATH/config
    echo 0x42017EC 4 > $DCC_PATH/config
    echo 0x4201800 4 > $DCC_PATH/config
    echo 0x4201814 4 > $DCC_PATH/config
    echo 0x4201828 4 > $DCC_PATH/config
    echo 0x420183C 4 > $DCC_PATH/config
    echo 0x4201850 4 > $DCC_PATH/config
    echo 0x4201864 4 > $DCC_PATH/config
    echo 0x4201878 4 > $DCC_PATH/config
    echo 0x420188C 4 > $DCC_PATH/config
    echo 0x42018A0 4 > $DCC_PATH/config
    echo 0x42018B4 4 > $DCC_PATH/config
    echo 0x42018C8 4 > $DCC_PATH/config
    echo 0x4201A50 4 > $DCC_PATH/config
    echo 0x4201A64 4 > $DCC_PATH/config
    echo 0x4201A78 4 > $DCC_PATH/config
    echo 0x4201A8C 4 > $DCC_PATH/config
    echo 0x4201AA0 4 > $DCC_PATH/config
    echo 0x4201AB4 4 > $DCC_PATH/config
    echo 0x4201AC8 4 > $DCC_PATH/config
    echo 0x4201ADC 4 > $DCC_PATH/config
    echo 0x4201AF0 4 > $DCC_PATH/config
    echo 0x4201B04 4 > $DCC_PATH/config
    echo 0x4201B18 4 > $DCC_PATH/config
    echo 0x4201B2C 4 > $DCC_PATH/config
    echo 0x4201B40 4 > $DCC_PATH/config
    echo 0x4201B54 4 > $DCC_PATH/config
    echo 0x4201B68 4 > $DCC_PATH/config
    echo 0x4201CF0 4 > $DCC_PATH/config
    echo 0x4201D04 4 > $DCC_PATH/config
    echo 0x4201D18 4 > $DCC_PATH/config
    echo 0x4201D2C 4 > $DCC_PATH/config
    echo 0x4201D40 4 > $DCC_PATH/config
    echo 0x4201D54 4 > $DCC_PATH/config
    echo 0x4201D68 4 > $DCC_PATH/config
    echo 0x4201D7C 4 > $DCC_PATH/config
    echo 0x4201D90 4 > $DCC_PATH/config
    echo 0x4201DA4 4 > $DCC_PATH/config
    echo 0x4201DB8 4 > $DCC_PATH/config
    echo 0x4201DCC 4 > $DCC_PATH/config
    echo 0x4201DE0 4 > $DCC_PATH/config
    echo 0x4201DF4 4 > $DCC_PATH/config
    echo 0x4201E08 4 > $DCC_PATH/config
    echo 0x4210D00 2 > $DCC_PATH/config
    echo 0x4210D10 4 > $DCC_PATH/config
    echo 0x4210D30 4 > $DCC_PATH/config
    echo 0x4210D44 4 > $DCC_PATH/config
    echo 0x4210D58 4 > $DCC_PATH/config
    echo 0x4210D6C 4 > $DCC_PATH/config
    echo 0x4210D80 4 > $DCC_PATH/config
    echo 0x4210D94 4 > $DCC_PATH/config
    echo 0x4210DA8 4 > $DCC_PATH/config
    echo 0x4210DBC 4 > $DCC_PATH/config
    echo 0x4210DD0 4 > $DCC_PATH/config
    echo 0x4210DE4 4 > $DCC_PATH/config
    echo 0x4210DF8 4 > $DCC_PATH/config
    echo 0x4210E0C 4 > $DCC_PATH/config
    echo 0x4210E20 4 > $DCC_PATH/config
    echo 0x4210E34 4 > $DCC_PATH/config
    echo 0x4210E48 4 > $DCC_PATH/config
    echo 0x4210FD0 4 > $DCC_PATH/config
    echo 0x4210FE4 4 > $DCC_PATH/config
    echo 0x4210FF8 4 > $DCC_PATH/config
    echo 0x421100C 4 > $DCC_PATH/config
    echo 0x4211020 4 > $DCC_PATH/config
    echo 0x4211034 4 > $DCC_PATH/config
    echo 0x4211048 4 > $DCC_PATH/config
    echo 0x421105C 4 > $DCC_PATH/config
    echo 0x4211070 4 > $DCC_PATH/config
    echo 0x4211084 4 > $DCC_PATH/config
    echo 0x4211098 4 > $DCC_PATH/config
    echo 0x42110AC 4 > $DCC_PATH/config
    echo 0x42110C0 4 > $DCC_PATH/config
    echo 0x42110D4 4 > $DCC_PATH/config
    echo 0x42110E8 4 > $DCC_PATH/config
    echo 0x4211270 4 > $DCC_PATH/config
    echo 0x4211284 4 > $DCC_PATH/config
    echo 0x4211298 4 > $DCC_PATH/config
    echo 0x42112AC 4 > $DCC_PATH/config
    echo 0x42112C0 4 > $DCC_PATH/config
    echo 0x42112D4 4 > $DCC_PATH/config
    echo 0x42112E8 4 > $DCC_PATH/config
    echo 0x42112FC 4 > $DCC_PATH/config
    echo 0x4211310 4 > $DCC_PATH/config
    echo 0x4211324 4 > $DCC_PATH/config
    echo 0x4211338 4 > $DCC_PATH/config
    echo 0x421134C 4 > $DCC_PATH/config
    echo 0x4211360 4 > $DCC_PATH/config
    echo 0x4211374 4 > $DCC_PATH/config
    echo 0x4211388 4 > $DCC_PATH/config
    echo 0x4211510 4 > $DCC_PATH/config
    echo 0x4211524 4 > $DCC_PATH/config
    echo 0x4211538 4 > $DCC_PATH/config
    echo 0x421154C 4 > $DCC_PATH/config
    echo 0x4211560 4 > $DCC_PATH/config
    echo 0x4211574 4 > $DCC_PATH/config
    echo 0x4211588 4 > $DCC_PATH/config
    echo 0x421159C 4 > $DCC_PATH/config
    echo 0x42115B0 4 > $DCC_PATH/config
    echo 0x42115C4 4 > $DCC_PATH/config
    echo 0x42115D8 4 > $DCC_PATH/config
    echo 0x42115EC 4 > $DCC_PATH/config
    echo 0x4211600 4 > $DCC_PATH/config
    echo 0x4211614 4 > $DCC_PATH/config
    echo 0x4211628 4 > $DCC_PATH/config
    echo 0x42117B0 4 > $DCC_PATH/config
    echo 0x42117C4 4 > $DCC_PATH/config
    echo 0x42117D8 4 > $DCC_PATH/config
    echo 0x42117EC 4 > $DCC_PATH/config
    echo 0x4211800 4 > $DCC_PATH/config
    echo 0x4211814 4 > $DCC_PATH/config
    echo 0x4211828 4 > $DCC_PATH/config
    echo 0x421183C 4 > $DCC_PATH/config
    echo 0x4211850 4 > $DCC_PATH/config
    echo 0x4211864 4 > $DCC_PATH/config
    echo 0x4211878 4 > $DCC_PATH/config
    echo 0x421188C 4 > $DCC_PATH/config
    echo 0x42118A0 4 > $DCC_PATH/config
    echo 0x42118B4 4 > $DCC_PATH/config
    echo 0x42118C8 4 > $DCC_PATH/config
    echo 0x4211A50 4 > $DCC_PATH/config
    echo 0x4211A64 4 > $DCC_PATH/config
    echo 0x4211A78 4 > $DCC_PATH/config
    echo 0x4211A8C 4 > $DCC_PATH/config
    echo 0x4211AA0 4 > $DCC_PATH/config
    echo 0x4211AB4 4 > $DCC_PATH/config
    echo 0x4211AC8 4 > $DCC_PATH/config
    echo 0x4211ADC 4 > $DCC_PATH/config
    echo 0x4211AF0 4 > $DCC_PATH/config
    echo 0x4211B04 4 > $DCC_PATH/config
    echo 0x4211B18 4 > $DCC_PATH/config
    echo 0x4211B2C 4 > $DCC_PATH/config
    echo 0x4211B40 4 > $DCC_PATH/config
    echo 0x4211B54 4 > $DCC_PATH/config
    echo 0x4211B68 4 > $DCC_PATH/config
    echo 0x4211CF0 4 > $DCC_PATH/config
    echo 0x4211D04 4 > $DCC_PATH/config
    echo 0x4211D18 4 > $DCC_PATH/config
    echo 0x4211D2C 4 > $DCC_PATH/config
    echo 0x4211D40 4 > $DCC_PATH/config
    echo 0x4211D54 4 > $DCC_PATH/config
    echo 0x4211D68 4 > $DCC_PATH/config
    echo 0x4211D7C 4 > $DCC_PATH/config
    echo 0x4211D90 4 > $DCC_PATH/config
    echo 0x4211DA4 4 > $DCC_PATH/config
    echo 0x4211DB8 4 > $DCC_PATH/config
    echo 0x4211DCC 4 > $DCC_PATH/config
    echo 0x4211DE0 4 > $DCC_PATH/config
    echo 0x4211DF4 4 > $DCC_PATH/config
    echo 0x4211E08 4 > $DCC_PATH/config
    echo 0x4130404 2 > $DCC_PATH/config

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

enable_msmnile_dcc_config_modem
