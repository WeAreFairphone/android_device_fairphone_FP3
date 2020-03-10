#
# vendor props for FP3
#

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.enable_hwc_vds=1 \
    debug.sf.hw=1 \
    debug.egl.hw=0 \
    dev.pm.dyn_samplingrate=1

#Disable SF Latch Buffer Signaled property
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.latch_unsignaled=1

#Enable libscalar for single DSI Usecases
PRODUCT_PROPERTY_OVERRIDES += \
    debug.enable.sglscale=1

#Enable UBWC aligned allocation for framebuffer
PRODUCT_PROPERTY_OVERRIDES += \
    debug.gralloc.enable_fb_ubwc=1

#Disable Skip Validate
PRODUCT_PROPERTY_OVERRIDES += \
    sdm.debug.disable_skip_validate=1

#Property to enable display default color mode
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.display.enable_default_color_mode=1

# Display Properties as per treble compliance
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.gralloc.enable_fb_ubwc=1 \
    vendor.display.disable_skip_validate=1

    # ro.sf.hwc_set_default_colormode=true \

# 196608 is decimal for 0x30000 to report major/minor versions as 3/0
# 196609 is decimal for 0x30001 to report major/minor versions as 3/1
# 196610 is decimal for 0x30002 to report major/minor versions as 3/2
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610

# System property for cabl
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qualcomm.cabl=2 \
    ro.vendor.display.cabl=2

#MM_GRAPHICS
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.vulkan=adreno \
    ro.hardware.egl=adreno