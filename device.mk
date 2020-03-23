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
$(call inherit-product-if-exists, vendor/fairphone/FP3/FP3-vendor.mk)

# Properties
-include $(LOCAL_PATH)/vendor_prop.mk

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
	$(LOCAL_PATH)/overlay

# A/B related defines
AB_OTA_UPDATER := true
# Full A/B partiton update set
# AB_OTA_PARTITIONS := xbl rpm tz hyp pmic modem abl boot keymaster cmnlib cmnlib64 system bluetooth
# Baseline
# AB_OTA_PARTITIONS := aboot cmnlib64 cmnlib devcfg dsp dtbo keymaster lksecapp mdtp modem rpm sbl1 tz vbmeta boot system vendor product
# Subset A/B partitions for Android-only image update
# AB_OTA_PARTITIONS ?= boot system
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    system \
    vbmeta \
    vendor \
	product

# Default A/B configuration.
ENABLE_AB ?= true

ifeq ($(ENABLE_AB),true)
#A/B related packages
PRODUCT_PACKAGES += update_engine \
                   update_engine_client \
                   update_verifier \
                   bootctrl.msm8953 \
                   brillo_update_payload \
                   android.hardware.boot@1.0-impl \
                   android.hardware.boot@1.0-service
#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl
endif

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine_sideload

PRODUCT_STATIC_BOOT_CONTROL_HAL := \
    libcutils \
    bootctrl.msm8953 \
    libgptutils \
    libz

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := 560dpi
PRODUCT_AAPT_PREBUILT_DPI := xxxhdpi xxhdpi xhdpi hdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH := 1080

# Display
PRODUCT_PACKAGES += \
	gralloc.msm8953 \
	copybit.msm8953 \
	hwcomposer.msm8953 \
	memtrack.msm8953 \
	android.hardware.graphics.allocator@2.0-impl \
	android.hardware.graphics.allocator@2.0-service \
	android.hardware.graphics.composer@2.1-impl \
	android.hardware.graphics.composer@2.1-service \
	android.hardware.graphics.mapper@2.0-impl \
	android.hardware.memtrack@1.0-impl \
	android.hardware.memtrack@1.0-service \
	libdisplayconfig \
	libqdMetaData.system

#INIT
PRODUCT_PACKAGES += \
	init.target.rc \
	init.qcom.rc \
	init.recovery.qcom.rc \
	init.qcom.factory.rc \
	init.qcom.usb.rc \
	init.msm.usb.configfs.rc \
	ueventd.qcom.rc \
	init.carrier.rc \
	vold.fstab \
	fstab.qcom \
	init.qti.ims.sh \
	init.qcom.coex.sh \
	init.qcom.early_boot.sh \
	init.qcom.post_boot.sh \
	init.qcom.sdio.sh \
	init.qcom.sh \
	init.qcom.class_core.sh \
	init.class_main.sh \
	init.class_late.sh \
	init.qcom.usb.sh \
	init.qcom.efs.sync.sh \
	qca6234-service.sh \
	init.mdm.sh \
	init.qcom.sensors.sh \
	init.qcom.crashdata.sh \
	init.qti.can.sh \
	init.qti.charger.sh

# CRDA += init.crda.sh #TODO fix CRDA packages later

#Add init.qcom.test.rc to PRODUCT_PACKAGES_DEBUG list
PRODUCT_PACKAGES += \
	init.qcom.test.rc \
	init.qcom.debug.sh
