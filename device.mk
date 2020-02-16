#
# Copyright (C) 2019 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Vendor blobs
$(call inherit-product-if-exists, vendor/fairphone/fp3/fp3-vendor.mk)

# Properties
-include $(LOCAL_PATH)/vendor_prop.mk

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-lineage

#PRODUCT_PACKAGES += \
    #NoCutoutOverlay

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := 560dpi
PRODUCT_AAPT_PREBUILT_DPI := xxxhdpi xxhdpi xhdpi hdpi

# Audio
#PRODUCT_COPY_FILES += \
    #$(LOCAL_PATH)/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    #$(LOCAL_PATH)/audio/audio_ext_spkr.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_ext_spkr.conf \
    #$(LOCAL_PATH)/audio/mixer_paths_madera_epout.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_madera_epout.xml \
    #$(LOCAL_PATH)/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml

# Boot animation
TARGET_SCREEN_HEIGHT := 2270
TARGET_SCREEN_WIDTH := 1080

# Camera
#PRODUCT_COPY_FILES += \
    #$(LOCAL_PATH)/configs/camera/camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/camera/camera_config.xml \
    #$(LOCAL_PATH)/configs/camera/mot_ov12a10_chromatix.xml:$(TARGET_COPY_OUT_VENDOR)/etc/camera/mot_ov12a10_chromatix.xml \
    #$(LOCAL_PATH)/configs/camera/mot_s5k4h7_chromatix.xml:$(TARGET_COPY_OUT_VENDOR)/etc/camera/mot_s5k4h7_chromatix.xml \
    #$(LOCAL_PATH)/configs/camera/mot_s5k5e9_chromatix.xml:$(TARGET_COPY_OUT_VENDOR)/etc/camera/mot_s5k5e9_chromatix.xml

# Fingerprint
#PRODUCT_COPY_FILES += \
    #$(LOCAL_PATH)/keylayout/uinput-egis.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/uinput-egis.kl \
    #$(LOCAL_PATH)/idc/uinput-egis.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/uinput-egis.idc

# NFC
#PRODUCT_COPY_FILES += \
    #$(LOCAL_PATH)/nfc/libnfc-nci.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci.conf \
    #$(LOCAL_PATH)/nfc/libnfc-nxp.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nxp.conf \
    #$(LOCAL_PATH)/nfc/libnfc-nxp-gcf.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nxp-gcf.conf

# Sensors
#PRODUCT_COPY_FILES += \
    #$(LOCAL_PATH)/configs/sensors/sensor_def_qcomdev.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/sensor_def_qcomdev.conf \
    #$(LOCAL_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Thermal
#PRODUCT_COPY_FILES += \
    #$(LOCAL_PATH)/configs/thermal-engine.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine.conf

# Inherit from motorola sdm632-common
$(call inherit-product, $(LOCAL_PATH)/common.mk)
