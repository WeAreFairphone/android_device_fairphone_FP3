LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_C_INCLUDES := hardware/qcom/power
LOCAL_CFLAGS := -Wall -Werror
LOCAL_SHARED_LIBRARIES := liblog
LOCAL_HEADER_LIBRARIES += libhardware_headers

ifeq ($(TARGET_USES_INTERACTION_BOOST),true)
    LOCAL_CFLAGS += -DINTERACTION_BOOST
endif

LOCAL_SRC_FILES := power-8953.c
LOCAL_MODULE := libpower_8953
LOCAL_VENDOR_MODULE := true
include $(BUILD_STATIC_LIBRARY)
