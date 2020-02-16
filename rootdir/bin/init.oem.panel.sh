#!/vendor/bin/sh

PATH=/sbin:/vendor/sbin:/vendor/bin:/vendor/xbin
export PATH

get_panel_supplier()
{
    supplier=""
    supplier=$(cat /sys/devices/virtual/graphics/fb0/panel_supplier 2> /dev/null)
    [ -z "$supplier" ] && return 1
    return 0
}

scriptname=${0##*/}

notice()
{
	echo "$*"
	echo "$scriptname: $*" > /dev/kmsg
}

get_panel_supplier
notice "panel supplier is [$supplier]"
case $supplier in
	boe | tianmah)
		insmod /vendor/lib/modules/himax_mmi.ko
		;;
	tianman)
		insmod /vendor/lib/modules/nova_mmi.ko
		;;
	tianma)
		insmod /vendor/lib/modules/synaptics_tcm_i2c.ko
		insmod /vendor/lib/modules/synaptics_tcm_core.ko
		insmod /vendor/lib/modules/synaptics_tcm_touch.ko
		insmod /vendor/lib/modules/synaptics_tcm_device.ko
		insmod /vendor/lib/modules/synaptics_tcm_reflash.ko
		insmod /vendor/lib/modules/synaptics_tcm_testing.ko
		insmod /vendor/lib/modules/ilitek_mmi.ko
		;;
	ofilm)
		insmod /vendor/lib/modules/focaltech_mmi.ko
		;;
	csot)
		insmod /vendor/lib/modules/nova_mmi.ko
		;;
	*)
		notice "$supplier not supported"
		return 1
		;;
esac

return 0
