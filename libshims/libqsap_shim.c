#include "qsap_api.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include <sys/socket.h>
#include <sys/ioctl.h>
#include <linux/wireless.h>

#include "log/log.h"

// Keep in sync with system/qcom/softap/sdk/qsap_api.c
struct Command qsap_str[eSTR_LAST] = {
    { "wpa",                     NULL           },
    { "accept_mac_file",         NULL           },
    { "deny_mac_file",           NULL           },
    { "gAPMacAddr",              "00deadbeef04" },/** AP MAC address */
    { "gEnableApProt",           "1"            },/** protection flag in ini file */
    { "gFixedRate",              "0"            },/** Fixed rate in ini */
    { "gTxPowerCap",             "27"           },/** Tx power in ini */
    { "gFragmentationThreshold", "2346"         },/** Fragmentation threshold in ini */
    { "RTSThreshold",            "2347"         },/** RTS threshold in ini */
    { "gAPCntryCode",            "USI"          },/** Country code in ini */
    { "gDisableIntraBssFwd",     "0"            },/** Intra-bss forward in ini */
    { "WmmIsEnabled",            "0"            },/** WMM */
    { "g11dSupportEnabled",      "1"            },/** 802.11d support */
    { "ieee80211n",              NULL           },
    { "ctrl_interface",          NULL           },
    { "interface",               NULL           },
    { "eap_server",              NULL           },
    { "gAPAutoShutOff",          "0"            },
    { "gEnablePhyAgcListenMode",  "128"          },
};

// system/qcom/softap/sdk/qsap_api.h
#define eERR_SET_TX_POWER (eERR_GET_AUTO_CHAN + 1)

s32 wifi_qsap_set_tx_power(s32 tx_power)
{
#define QCSAP_IOCTL_SET_MAX_TX_POWER   (SIOCIWFIRSTPRIV + 22)
    s32 sock;
    s32 ret = eERR_SET_TX_POWER;
    s8  interface[128];
    s8  *iface;
    s32 len = 128;
    struct iwreq wrq;

    if(NULL == (iface = qsap_get_config_value(CONFIG_FILE, &qsap_str[STR_INTERFACE], interface, (u32*)&len))) {
        ALOGE("%s :interface error \n", __func__);
        return ret;
    }

    /* Issue QCSAP_IOCTL_SET_MAX_TX_POWER ioctl */
    sock = socket(AF_INET, SOCK_DGRAM, 0);

    if (sock < 0) {
        ALOGE("%s :socket error \n", __func__);
        return eERR_SET_TX_POWER;
    }

    strlcpy(wrq.ifr_name, iface, sizeof(wrq.ifr_name));
    wrq.u.data.length = sizeof(s32);
    wrq.u.data.pointer = &tx_power;
    wrq.u.data.flags = 0;

    ret = ioctl(sock, QCSAP_IOCTL_SET_MAX_TX_POWER, &wrq);
    close(sock);

    if (ret) {
        ALOGE("%s :IOCTL set tx power failed: %ld\n", __func__, ret);
        ret = eERR_SET_TX_POWER;
    } else {
        ALOGD("%s :IOCTL set tx power issued\n", __func__);
        ret = eSUCCESS;
    }

    return ret;
}
