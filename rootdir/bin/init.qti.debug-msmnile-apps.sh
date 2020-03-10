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

# Function msmnile SLPI DCC configuration
enable_msmnile_dcc_config_apps()
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

    echo 0x18200204 4 > $DCC_PATH/config
    echo 0x18200224 4 > $DCC_PATH/config
    echo 0x18200244 4 > $DCC_PATH/config
    echo 0x18200264 4 > $DCC_PATH/config
    echo 0x18200284 4 > $DCC_PATH/config
    echo 0x182002A4 4 > $DCC_PATH/config
    echo 0x182002C4 4 > $DCC_PATH/config
    echo 0x18210204 4 > $DCC_PATH/config
    echo 0x18210224 4 > $DCC_PATH/config
    echo 0x18210244 4 > $DCC_PATH/config
    echo 0x18210264 4 > $DCC_PATH/config
    echo 0x18210284 4 > $DCC_PATH/config
    echo 0x182102A4 4 > $DCC_PATH/config
    echo 0x182102C4 4 > $DCC_PATH/config
    echo 0x18200404 2 > $DCC_PATH/config
    echo 0x18200D00 2 > $DCC_PATH/config
    echo 0x18200D10 4 > $DCC_PATH/config
    echo 0x18200FB0 4 > $DCC_PATH/config
    echo 0x18201250 4 > $DCC_PATH/config
    echo 0x18200D30 4 > $DCC_PATH/config
    echo 0x18200D44 4 > $DCC_PATH/config
    echo 0x18200D58 4 > $DCC_PATH/config
    echo 0x18200D6C 4 > $DCC_PATH/config
    echo 0x18200D80 4 > $DCC_PATH/config
    echo 0x18200D94 4 > $DCC_PATH/config
    echo 0x18200DA8 4 > $DCC_PATH/config
    echo 0x18200DBC 4 > $DCC_PATH/config
    echo 0x18200DD0 4 > $DCC_PATH/config
    echo 0x18200DE4 4 > $DCC_PATH/config
    echo 0x18200DF8 4 > $DCC_PATH/config
    echo 0x18200E0C 4 > $DCC_PATH/config
    echo 0x18200E20 4 > $DCC_PATH/config
    echo 0x18200E34 4 > $DCC_PATH/config
    echo 0x18200E48 4 > $DCC_PATH/config
    echo 0x18200FD0 4 > $DCC_PATH/config
    echo 0x18200FE4 4 > $DCC_PATH/config
    echo 0x18200FF8 4 > $DCC_PATH/config
    echo 0x1820100C 4 > $DCC_PATH/config
    echo 0x18201020 4 > $DCC_PATH/config
    echo 0x18201034 4 > $DCC_PATH/config
    echo 0x18201048 4 > $DCC_PATH/config
    echo 0x1820105C 4 > $DCC_PATH/config
    echo 0x18201070 4 > $DCC_PATH/config
    echo 0x18201084 4 > $DCC_PATH/config
    echo 0x18201098 4 > $DCC_PATH/config
    echo 0x182010AC 4 > $DCC_PATH/config
    echo 0x182010C0 4 > $DCC_PATH/config
    echo 0x182010D4 4 > $DCC_PATH/config
    echo 0x182010E8 4 > $DCC_PATH/config
    echo 0x18201270 4 > $DCC_PATH/config
    echo 0x18201284 4 > $DCC_PATH/config
    echo 0x18201298 4 > $DCC_PATH/config
    echo 0x182012AC 4 > $DCC_PATH/config
    echo 0x182012C0 4 > $DCC_PATH/config
    echo 0x182012D4 4 > $DCC_PATH/config
    echo 0x182012E8 4 > $DCC_PATH/config
    echo 0x182012FC 4 > $DCC_PATH/config
    echo 0x18201310 4 > $DCC_PATH/config
    echo 0x18201324 4 > $DCC_PATH/config
    echo 0x18201338 4 > $DCC_PATH/config
    echo 0x1820134C 4 > $DCC_PATH/config
    echo 0x18201360 4 > $DCC_PATH/config
    echo 0x18201374 4 > $DCC_PATH/config
    echo 0x18201388 4 > $DCC_PATH/config
    echo 0x18210D00 2 > $DCC_PATH/config
    echo 0x18220D00 2 > $DCC_PATH/config
    echo 0x18210D10 4 > $DCC_PATH/config
    echo 0x18210FB0 4 > $DCC_PATH/config
    echo 0x18211250 4 > $DCC_PATH/config
    echo 0x18210D30 4 > $DCC_PATH/config
    echo 0x18210D44 4 > $DCC_PATH/config
    echo 0x18210D58 4 > $DCC_PATH/config
    echo 0x18210D6C 4 > $DCC_PATH/config
    echo 0x18210D80 4 > $DCC_PATH/config
    echo 0x18210D94 4 > $DCC_PATH/config
    echo 0x18210DA8 4 > $DCC_PATH/config
    echo 0x18210DBC 4 > $DCC_PATH/config
    echo 0x18210DD0 4 > $DCC_PATH/config
    echo 0x18210DE4 4 > $DCC_PATH/config
    echo 0x18210DF8 4 > $DCC_PATH/config
    echo 0x18210E0C 4 > $DCC_PATH/config
    echo 0x18210E20 4 > $DCC_PATH/config
    echo 0x18210E34 4 > $DCC_PATH/config
    echo 0x18210E48 4 > $DCC_PATH/config
    echo 0x18210FD0 4 > $DCC_PATH/config
    echo 0x18210FE4 4 > $DCC_PATH/config
    echo 0x18210FF8 4 > $DCC_PATH/config
    echo 0x1821100C 4 > $DCC_PATH/config
    echo 0x18211020 4 > $DCC_PATH/config
    echo 0x18211034 4 > $DCC_PATH/config
    echo 0x18211048 4 > $DCC_PATH/config
    echo 0x1821105C 4 > $DCC_PATH/config
    echo 0x18211070 4 > $DCC_PATH/config
    echo 0x18211084 4 > $DCC_PATH/config
    echo 0x18211098 4 > $DCC_PATH/config
    echo 0x182110AC 4 > $DCC_PATH/config
    echo 0x182110C0 4 > $DCC_PATH/config
    echo 0x182110D4 4 > $DCC_PATH/config
    echo 0x182110E8 4 > $DCC_PATH/config
    echo 0x18211270 4 > $DCC_PATH/config
    echo 0x18211284 4 > $DCC_PATH/config
    echo 0x18211298 4 > $DCC_PATH/config
    echo 0x182112AC 4 > $DCC_PATH/config
    echo 0x182112C0 4 > $DCC_PATH/config
    echo 0x182112D4 4 > $DCC_PATH/config
    echo 0x182112E8 4 > $DCC_PATH/config
    echo 0x182112FC 4 > $DCC_PATH/config
    echo 0x18211310 4 > $DCC_PATH/config
    echo 0x18211324 4 > $DCC_PATH/config
    echo 0x18211338 4 > $DCC_PATH/config
    echo 0x1821134C 4 > $DCC_PATH/config
    echo 0x18211360 4 > $DCC_PATH/config
    echo 0x18211374 4 > $DCC_PATH/config
    echo 0x18211388 4 > $DCC_PATH/config
    echo 0x18220D10 4 > $DCC_PATH/config
    echo 0x18220FB0 4 > $DCC_PATH/config
    echo 0x18221250 4 > $DCC_PATH/config
    echo 0x182214F0 4 > $DCC_PATH/config
    echo 0x18221790 4 > $DCC_PATH/config
    echo 0x18221A30 4 > $DCC_PATH/config
    echo 0x18221CD0 4 > $DCC_PATH/config
    echo 0x18220D30 4 > $DCC_PATH/config
    echo 0x18220D44 4 > $DCC_PATH/config
    echo 0x18220D58 4 > $DCC_PATH/config
    echo 0x18220D6C 4 > $DCC_PATH/config
    echo 0x18220D80 4 > $DCC_PATH/config
    echo 0x18220D94 4 > $DCC_PATH/config
    echo 0x18220DA8 4 > $DCC_PATH/config
    echo 0x18220DBC 4 > $DCC_PATH/config
    echo 0x18220DD0 4 > $DCC_PATH/config
    echo 0x18220DE4 4 > $DCC_PATH/config
    echo 0x18220DF8 4 > $DCC_PATH/config
    echo 0x18220E0C 4 > $DCC_PATH/config
    echo 0x18220E20 4 > $DCC_PATH/config
    echo 0x18220E34 4 > $DCC_PATH/config
    echo 0x18220E48 4 > $DCC_PATH/config
    echo 0x18220FD0 4 > $DCC_PATH/config
    echo 0x18220FE4 4 > $DCC_PATH/config
    echo 0x18220FF8 4 > $DCC_PATH/config
    echo 0x1822100C 4 > $DCC_PATH/config
    echo 0x18221020 4 > $DCC_PATH/config
    echo 0x18221034 4 > $DCC_PATH/config
    echo 0x18221048 4 > $DCC_PATH/config
    echo 0x1822105C 4 > $DCC_PATH/config
    echo 0x18221070 4 > $DCC_PATH/config
    echo 0x18221084 4 > $DCC_PATH/config
    echo 0x18221098 4 > $DCC_PATH/config
    echo 0x182210AC 4 > $DCC_PATH/config
    echo 0x182210C0 4 > $DCC_PATH/config
    echo 0x182210D4 4 > $DCC_PATH/config
    echo 0x182210E8 4 > $DCC_PATH/config
    echo 0x18221270 4 > $DCC_PATH/config
    echo 0x18221284 4 > $DCC_PATH/config
    echo 0x18221298 4 > $DCC_PATH/config
    echo 0x182212AC 4 > $DCC_PATH/config
    echo 0x182212C0 4 > $DCC_PATH/config
    echo 0x182212D4 4 > $DCC_PATH/config
    echo 0x182212E8 4 > $DCC_PATH/config
    echo 0x182212FC 4 > $DCC_PATH/config
    echo 0x18221310 4 > $DCC_PATH/config
    echo 0x18221324 4 > $DCC_PATH/config
    echo 0x18221338 4 > $DCC_PATH/config
    echo 0x1822134C 4 > $DCC_PATH/config
    echo 0x18221360 4 > $DCC_PATH/config
    echo 0x18221374 4 > $DCC_PATH/config
    echo 0x18221388 4 > $DCC_PATH/config
    echo 0x18221510 4 > $DCC_PATH/config
    echo 0x18221524 4 > $DCC_PATH/config
    echo 0x18221538 4 > $DCC_PATH/config
    echo 0x1822154C 4 > $DCC_PATH/config
    echo 0x18221560 4 > $DCC_PATH/config
    echo 0x18221574 4 > $DCC_PATH/config
    echo 0x18221588 4 > $DCC_PATH/config
    echo 0x1822159C 4 > $DCC_PATH/config
    echo 0x182215B0 4 > $DCC_PATH/config
    echo 0x182215C4 4 > $DCC_PATH/config
    echo 0x182215D8 4 > $DCC_PATH/config
    echo 0x182215EC 4 > $DCC_PATH/config
    echo 0x18221600 4 > $DCC_PATH/config
    echo 0x18221614 4 > $DCC_PATH/config
    echo 0x18221628 4 > $DCC_PATH/config
    echo 0x182217B0 4 > $DCC_PATH/config
    echo 0x182217C4 4 > $DCC_PATH/config
    echo 0x182217D8 4 > $DCC_PATH/config
    echo 0x182217EC 4 > $DCC_PATH/config
    echo 0x18221800 4 > $DCC_PATH/config
    echo 0x18221814 4 > $DCC_PATH/config
    echo 0x18221828 4 > $DCC_PATH/config
    echo 0x1822183C 4 > $DCC_PATH/config
    echo 0x18221850 4 > $DCC_PATH/config
    echo 0x18221864 4 > $DCC_PATH/config
    echo 0x18221878 4 > $DCC_PATH/config
    echo 0x1822188C 4 > $DCC_PATH/config
    echo 0x182218A0 4 > $DCC_PATH/config
    echo 0x182218B4 4 > $DCC_PATH/config
    echo 0x182218C8 4 > $DCC_PATH/config
    echo 0x18221A50 4 > $DCC_PATH/config
    echo 0x18221A64 4 > $DCC_PATH/config
    echo 0x18221A78 4 > $DCC_PATH/config
    echo 0x18221A8C 4 > $DCC_PATH/config
    echo 0x18221AA0 4 > $DCC_PATH/config
    echo 0x18221AB4 4 > $DCC_PATH/config
    echo 0x18221AC8 4 > $DCC_PATH/config
    echo 0x18221ADC 4 > $DCC_PATH/config
    echo 0x18221AF0 4 > $DCC_PATH/config
    echo 0x18221B04 4 > $DCC_PATH/config
    echo 0x18221B18 4 > $DCC_PATH/config
    echo 0x18221B2C 4 > $DCC_PATH/config
    echo 0x18221B40 4 > $DCC_PATH/config
    echo 0x18221B54 4 > $DCC_PATH/config
    echo 0x18221B68 4 > $DCC_PATH/config
    echo 0x18221CF0 4 > $DCC_PATH/config
    echo 0x18221D04 4 > $DCC_PATH/config
    echo 0x18221D18 4 > $DCC_PATH/config
    echo 0x18221D2C 4 > $DCC_PATH/config
    echo 0x18221D40 4 > $DCC_PATH/config
    echo 0x18221D54 4 > $DCC_PATH/config
    echo 0x18221D68 4 > $DCC_PATH/config
    echo 0x18221D7C 4 > $DCC_PATH/config
    echo 0x18221D90 4 > $DCC_PATH/config
    echo 0x18221DA4 4 > $DCC_PATH/config
    echo 0x18221DB8 4 > $DCC_PATH/config
    echo 0x18221DCC 4 > $DCC_PATH/config
    echo 0x18221DE0 4 > $DCC_PATH/config
    echo 0x18221DF4 4 > $DCC_PATH/config
    echo 0x18221E08 4 > $DCC_PATH/config
    echo 0x04130404 2 > $DCC_PATH/config

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

enable_msmnile_dcc_config_apps
