#!/vendor/bin/sh
# Copyright (c) 2012, Code Aurora Forum. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of Code Aurora Forum, Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# Allow unique persistent serial numbers for devices connected via usb
# User needs to set unique usb serial number to persist.usb.serialno and
# if persistent serial number is not set then Update USB serial number if
# passed from command line
#

target=`getprop ro.board.platform`
usb_action=`getprop usb.mmi-usb-sh.action`
echo "mmi-usb-sh: action = \"$usb_action\""
sys_usb_config=`getprop vendor.usb.config`

tcmd_ctrl_adb ()
{
    ctrl_adb=`getprop vendor.tcmd.ctrl_adb`
    echo "mmi-usb-sh: vendor.tcmd.ctrl_adb = $ctrl_adb"
    case "$ctrl_adb" in
        "0")
            if [[ "$sys_usb_config" == *adb* ]]
            then
                # *** ALWAYS expecting adb at the end ***
                new_usb_config=${sys_usb_config/,adb/}
                echo "mmi-usb-sh: disabling adb ($new_usb_config)"
                setprop persist.vendor.usb.config $new_usb_config
                setprop vendor.usb.config $new_usb_config
                setprop persist.vendor.factory.allow_adb 0
            fi
        ;;
        "1")
            if [[ "$sys_usb_config" != *adb* ]]
            then
                # *** ALWAYS expecting adb at the end ***
                new_usb_config="$sys_usb_config,adb"
                echo "mmi-usb-sh: enabling adb ($new_usb_config)"
                setprop persist.vendor.usb.config $new_usb_config
                setprop vendor.usb.config $new_usb_config
                setprop persist.vendor.factory.allow_adb 1
            fi
        ;;
    esac

    exit 0
}

case "$usb_action" in
    "")
    ;;
    "vendor.tcmd.ctrl_adb")
        tcmd_ctrl_adb
    ;;
esac

# soc_ids for 8937
if [ -f /sys/devices/soc0/soc_id ]; then
	soc_id=`cat /sys/devices/soc0/soc_id`
else
	soc_id=`cat /sys/devices/system/soc/soc0/id`
fi

case "$target" in
    "msm8937")
        setprop vendor.usb.rps_mask 0
        setprop vendor.rmnet_vnd.rps_mask 0
        case "$soc_id" in
	    "294" | "295")
		setprop vendor.usb.rps_mask 40
	    ;;
        esac

	case "$soc_id" in
            "313" | "320")
                 qcom_usb_config="diag,serial_smd,rmnet_ipa"
                 qcom_adb_usb_config="diag,serial_smd,rmnet_ipa,adb"
                 bpt_usb_config="diag,serial_smd,rmnet_bam_ipa"
                 bpt_adb_usb_config="diag,serial_smd,rmnet_bam_ipa,adb"
            ;;
            *)
                 qcom_usb_config="diag,serial_smd,rmnet_qti_bam"
                 qcom_adb_usb_config="diag,serial_smd,rmnet_qti_bam,adb"
                 bpt_usb_config="diag,serial_smd,rmnet"
                 bpt_adb_usb_config="diag,serial_smd,rmnet,adb"
           ;;
	esac
    ;;
    "msm8953")
        #Set RPS Mask for Tethering to CPU4
        setprop vendor.usb.rps_mask 10
        setprop vendor.rmnet_vnd.rps_mask 0
        if [ -d /config/usb_gadget/g1 ]; then
            qcom_usb_config="diag,serial_cdev,rmnet"
            qcom_adb_usb_config="diag,serial_cdev,rmnet,adb"
            bpt_usb_config="diag,serial,rmnet"
            bpt_adb_usb_config="diag,serial,rmnet,adb"
            setprop vendor.usb.rndis.func.name "rndis_bam"
            setprop vendor.usb.rmnet.func.name "rmnet_bam"
        else
            qcom_usb_config="diag,serial_smd,serial_tty,rmnet_bam,mass_storage"
            qcom_adb_usb_config="diag,serial_smd,serial_tty,rmnet_bam,mass_storage,adb"
            bpt_usb_config="diag,serial_smd,serial_tty,rmnet"
            bpt_adb_usb_config="diag,serial_smd,serial_tty,rmnet,adb"
        fi
        setprop vendor.usb.controller "7000000.dwc3"
    ;;
    "msm8996")
        #Set RPS Mask for Tethering to CPU2
        setprop vendor.usb.rps_mask 2
        setprop vendor.rmnet_vnd.rps_mask 0f
        qcom_usb_config="diag,serial_cdev,serial_tty,rmnet_bam,mass_storage"
        qcom_adb_usb_config="diag,serial_cdev,serial_tty,rmnet_bam,mass_storage,adb"
        bpt_usb_config="diag,serial_cdev,serial_tty,rmnet"
        bpt_adb_usb_config="diag,serial_cdev,serial_tty,rmnet,adb"
        setprop vendor.usb.controller "6a00000.dwc3"
    ;;
    "msm8998")
        #Set RPS Mask for Tethering to CPU2
        setprop vendor.usb.rps_mask 30
        setprop vendor.rmnet_vnd.rps_mask 0d
        qcom_usb_config="diag,serial_cdev,rmnet"
        qcom_adb_usb_config="diag,serial_cdev,rmnet,adb"
        bpt_usb_config="diag,serial,rmnet"
        bpt_adb_usb_config="diag,serial,rmnet,adb"
        setprop vendor.usb.controller "a800000.dwc3"
        setprop vendor.usb.rndis.func.name "gsi"
        setprop vendor.usb.rmnet.func.name "gsi"
    ;;
    "sdm660")
        #Set RPS Mask for Tethering to CPU2
        setprop vendor.usb.rps_mask 30
        setprop vendor.rmnet_vnd.rps_mask 4
        qcom_usb_config="diag,serial_cdev,rmnet"
        qcom_adb_usb_config="diag,serial_cdev,rmnet,adb"
        bpt_usb_config="diag,serial,rmnet"
        bpt_adb_usb_config="diag,serial,rmnet,adb"
        setprop vendor.usb.controller "a800000.dwc3"
        setprop vendor.usb.rndis.func.name "rndis_bam"
        setprop vendor.usb.rmnet.func.name "rmnet_bam"
    ;;
    "sdm845")
        qcom_usb_config="diag,serial_cdev,rmnet"
        qcom_adb_usb_config="diag,serial_cdev,rmnet,adb"
        bpt_usb_config="diag,serial,rmnet"
        bpt_adb_usb_config="diag,serial,rmnet,adb"
        setprop vendor.usb.controller "a600000.dwc3"
        setprop vendor.usb.rndis.func.name "gsi"
        setprop vendor.usb.rmnet.func.name "gsi"
    ;;
    "sdm710")
        qcom_usb_config="diag,serial_cdev,rmnet"
        qcom_adb_usb_config="diag,serial_cdev,rmnet,adb"
        bpt_usb_config="diag,serial,rmnet"
        bpt_adb_usb_config="diag,serial,rmnet,adb"
        setprop vendor.usb.controller "a600000.dwc3"
        setprop vendor.usb.rndis.func.name "gsi"
        setprop vendor.usb.rmnet.func.name "gsi"
    ;;
    "sm6150")
        qcom_usb_config="diag,serial_cdev,rmnet"
        qcom_adb_usb_config="diag,serial_cdev,rmnet,adb"
        bpt_usb_config="diag,serial,rmnet"
        bpt_adb_usb_config="diag,serial,rmnet,adb"
        setprop vendor.usb.controller "a600000.dwc3"
        setprop vendor.usb.rndis.func.name "gsi"
        setprop vendor.usb.rmnet.func.name "gsi"
    ;;
esac

## This is needed to switch to the qcom rndis driver.
diag_extra=`getprop persist.vendor.usb.config.extra`
if [ "$diag_extra" == "" ]; then
        setprop persist.vendor.usb.config.extra none
fi

#
# Allow USB enumeration with default PID/VID
#
usb_config=`getprop persist.vendor.usb.config`
mot_usb_config=`getprop persist.vendor.mot.usb.config`
bootmode=`getprop ro.bootmode`
buildtype=`getprop ro.build.type`
securehw=`getprop ro.boot.secure_hardware`
cid=`getprop ro.vendor.boot.cid`
diagmode=`getprop persist.vendor.radio.usbdiag`

echo "mmi-usb-sh: persist usb configs = \"$usb_config\", \"$mot_usb_config\", \"$diagmode\""


phonelock_type=`getprop persist.sys.phonelock.mode`
usb_restricted=`getprop persist.sys.usb.policylocked`
if [ "$securehw" == "1" ] && [ "$buildtype" == "user" ] && [ "$(($cid))" != 0 ]
then
    if [ "$usb_restricted" == "1" ]
    then
        echo 1 > /sys/class/android_usb/android0/secure
    else
        case "$phonelock_type" in
            "1" )
                echo 1 > /sys/class/android_usb/android0/secure
            ;;
            * )
                echo 0 > /sys/class/android_usb/android0/secure
            ;;
        esac
    fi
fi

# ##DIAG# mode option
case "$diagmode" in
    "1" )
        case "$usb_config" in
            "$bpt_usb_config" | "$bpt_adb_usb_config" )
            ;;
            * )
		case "$securehw" in
		    "1" )
			setprop persist.vendor.usb.config $bpt_usb_config
		    ;;
		    *)
			setprop persist.vendor.usb.config $bpt_adb_usb_config
                    ;;
                esac
            ;;
        esac
        exit 0
    ;;
    * )
        # Do nothing. USB enumeration will be set by bootmode
    ;;
esac



case "$bootmode" in
    "bp-tools" )
        case "$usb_config" in
            "$bpt_usb_config" | "$bpt_adb_usb_config" )
            ;;
            * )
		case "$securehw" in
		    "1" )
			setprop persist.vendor.usb.config $bpt_usb_config
			setprop persist.vendor.usb.bp-tools.config $bpt_usb_config
			setprop persist.vendor.usb.bp-tools.func $bpt_usb_config
		    ;;
		    *)
			setprop persist.vendor.usb.config $bpt_adb_usb_config
			setprop persist.vendor.usb.bp-tools.config $bpt_adb_usb_config
			setprop persist.vendor.usb.bp-tools.func $bpt_adb_usb_config
		    ;;
		esac
            ;;
        esac
    ;;
    "mot-factory" )
        allow_adb=`getprop persist.vendor.factory.allow_adb`
        case "$allow_adb" in
            "1")
                if [ "$usb_config" != "usbnet,adb" ]
                then
                    setprop persist.vendor.usb.config usbnet,adb
                    setprop persist.vendor.usb.mot-factory.config usbnet,adb
                    setprop persist.vendor.usb.mot-factory.func usbnet,adb
                fi
            ;;
            *)
                if [ "$usb_config" != "usbnet" ]
                then
                    setprop persist.vendor.usb.config usbnet
                    setprop persist.vendor.usb.mot-factory.config usbnet
                    setprop persist.vendor.usb.mot-factory.func usbnet
                fi
            ;;
        esac
	# Disable Host Mode LPM for Factory mode
	echo 1 > /sys/module/dwc3_msm/parameters/disable_host_mode_pm
    ;;
    "qcom" )
        case "$usb_config" in
            "$qcom_usb_config" | "$qcom_adb_usb_config" )
            ;;
            * )
		case "$securehw" in
		    "1" )
			setprop persist.vendor.usb.config $qcom_usb_config
			setprop persist.vendor.usb.qcom.config $qcom_usb_config
			setprop persist.vendor.usb.qcom.func $qcom_usb_config
		    ;;
		    *)
			setprop persist.vendor.usb.config $qcom_adb_usb_config
			setprop persist.vendor.usb.qcom.config $qcom_adb_usb_config
			setprop persist.vendor.usb.qcom.func $qcom_adb_usb_config
		    ;;
		esac
            ;;
        esac
    ;;
    * )
        if [ "$buildtype" == "user" ] && [ "$phonelock_type" != "1" ] && [ "$usb_restricted" != "1" ]
        then
            echo 1 > /sys/class/android_usb/android0/secure
            echo "Disabling enumeration until bootup!"
        fi

        case "$usb_config" in
            "mtp,adb" | "mtp" | "adb")
            ;;
            *)
                case "$mot_usb_config" in
                    "mtp,adb" | "mtp" | "adb")
                        setprop persist.vendor.usb.config $mot_usb_config
                    ;;
                    *)
                        case "$securehw" in
                            "1" )
                                setprop persist.vendor.usb.config mtp
                            ;;
                            *)
                                setprop persist.vendor.usb.config adb
                            ;;
                        esac
                    ;;
                esac
            ;;
        esac

        adb_early=`getprop ro.boot.adb_early`
        if [ "$adb_early" == "1" ]; then
            echo 0 > /sys/class/android_usb/android0/secure
            echo "Enabling enumeration after bootup, count =  $count !"
            new_persist_usb_config=`getprop persist.vendor.usb.config`
            if [ "$sys_usb_config" != "$new_persist_usb_config" ]; then
                setprop vendor.usb.config $new_persist_usb_config
            fi
            if [ "$new_persist_usb_config" == "" ]; then
                setprop vendor.usb.config "adb"
            fi
            exit 0
        fi

        if [ "$buildtype" == "user" ] && [ "$phonelock_type" != "1" ] && [ "$usb_restricted" != "1" ]
        then
            count=0
            bootcomplete=`getprop vendor.boot_completed`
            echo "mmi-usb-sh - bootcomplete = $booted"
            while [ "$bootcomplete" != "1" ]; do
                echo "Sleeping till bootup!"
                sleep 1
                count=$((count+1))
                if [ $count -gt 90 ]
                then
                    echo "mmi-usb-sh - Timed out waiting for bootup"
                    break
                fi
                bootcomplete=`getprop vendor.boot_completed`
            done
            echo 0 > /sys/class/android_usb/android0/secure
            echo "Enabling enumeration after bootup, count =  $count !"
            exit 0
        fi
    ;;
esac

new_persist_usb_config=`getprop persist.vendor.usb.config`
if [ "$sys_usb_config" != "$new_persist_usb_config" ]; then
	setprop vendor.usb.config $new_persist_usb_config
fi
