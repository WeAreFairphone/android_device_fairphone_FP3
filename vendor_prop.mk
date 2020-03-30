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

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.btstack.enable.splita2dp=false \
    bluetooth.hfp.client=1 \
    persist.bluetooth.avrcpversion=avrcp16 \
    bt.pts.certification=true \
    vendor.bt.pts.pbap=true \
    ro.qualcomm.bluetooth.ftp=false
    # This requires com.qualcomm.qti.bluetooth_audio@1.0
    # ro.bluetooth.library_name=libbluetooth_qti.so \

# system props for the cne module
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.cne.feature=1

# AUDIO
##fluencetype can be "fluence" or "fluencepro" or "none"
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.audio.sdk.fluencetype=fluence

# Reduce client buffer size for fast audio output tracks
PRODUCT_PROPERTY_OVERRIDES += \
    af.fast_track_multiplier=1

#Low latency audio buffer size in frames
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio_hal.period_size=192

PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.audio.fluence.voicecall=true \
    persist.vendor.audio.fluence.voicerec=false \
    persist.vendor.audio.fluence.speaker=true

#disable tunnel encoding
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.tunnel.encode=false

#Buffer size in kbytes for compress offload playback
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.offload.buffer.size.kb=64

#Minimum duration for offload playback in secs
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.min.duration.secs=30

#Enable offload audio video playback by default
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.video=true

#Enable audio track offload by default
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.offload.track.enable=true

#Enable music through deep buffer
PRODUCT_PROPERTY_OVERRIDES += \
    audio.deep_buffer.media=true

#enable voice path for PCM VoIP by default
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.voice.path.for.pcm.voip=true

#Enable multi channel aac through offload
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.offload.multiaac.enable=true

#Enable DS2, Hardbypass feature for Dolby
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.dolby.ds2.enabled=false \
    vendor.audio.dolby.ds2.hardbypass=false

#Disable Multiple offload sesison
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.offload.multiple.enabled=false

#Disable Compress passthrough playback
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.offload.passthrough=false

#Disable surround sound recording
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.audio.sdk.ssr=false

#enable dsp gapless mode by default
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.offload.gapless.enabled=true

#enable pbe effects
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.safx.pbe.enabled=true

#parser input buffer size(256kb) in byte stream mode
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.parser.ip.buffer.size=262144

#enable downsampling for multi-channel content > 48Khz
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.playback.mch.downsample=true

#enable software decoders for ALAC and APE.
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.use.sw.alac.decoder=true \
    vendor.audio.use.sw.ape.decoder=true

#property for AudioSphere Post processing
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.pp.asphere.enabled=false

#Audio voice concurrency related flags
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.voice.playback.conc.disabled=true \
    vendor.voice.record.conc.disabled=false \
    vendor.voice.voip.conc.disabled=true

#Decides the audio fallback path during voice call,
#deep-buffer and fast are the two allowed fallback paths now.
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.voice.conc.fallbackpath=deep-buffer

#Disable speaker protection by default
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.audio.speaker.prot.enable=false

#Enable HW AAC Encoder by default
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.hw.aac.encoder=true

#flac sw decoder 24 bit decode capability
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.flac.sw.decoder.24bit=true

#Set AudioFlinger client heap size
PRODUCT_PROPERTY_OVERRIDES += \
    ro.af.client_heap_size_kbyte=7168

PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.audio.hw.binder.size_kbyte=1024

#minimum duration for offload playback in secs
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.min.duration.secs=30

#enable offload audio video playback by default
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.video=true

#enable music through deep buffer
PRODUCT_PROPERTY_OVERRIDES += \
    audio.deep_buffer.media=true

#set AudioFlinger client heap size
PRODUCT_PROPERTY_OVERRIDES += \
    ro.af.client_heap_size_kbyte=7168

# Reduce client buffer size for fast audio output tracks
PRODUCT_PROPERTY_OVERRIDES += \
    af.fast_track_multiplier=1

# vendor library
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.camera.camera2=true \
    persist.vendor.camera.lib2d.rotation=on \
    persist.vendor.camera.isp.clock.optmz=0 \
    vendor.camera.hal1.packagelist=com.skype.raider,com.google.android.talk \
    vendor.camera.lowpower.record.enable=1 \
    persist.vendor.camera.display.umax=1920x1080 \
    persist.vendor.camera.display.lmax=1280x720

#expose aux camera for below packages
# vendor.camera.aux.packagelist=org.codeaurora.snapcam

PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.multisim.config=dsds \
    keyguard.no_require_sim=true \
    persist.vendor.radio.apm_sim_not_pwdn=1 \
    persist.vendor.radio.sib16_support=1 \
    persist.vendor.radio.custom_ecc=1 \
    persist.vendor.radio.rat_on=combine \
    persist.backup.ntpServer=0.pool.ntp.org

PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/vendor/lib64/libril-qc-qmi-1.so \
    vendor.rild.libpath=/vendor/lib64/libril-qc-qmi-1.so \
    rild.libargs=-d /dev/smd0 \
    persist.rild.nitz_plmn="" \
    persist.rild.nitz_long_ons_0="" \
    persist.rild.nitz_long_ons_1="" \
    persist.rild.nitz_long_ons_2="" \
    persist.rild.nitz_long_ons_3="" \
    persist.rild.nitz_short_ons_0="" \
    persist.rild.nitz_short_ons_1="" \
    persist.rild.nitz_short_ons_2="" \
    persist.rild.nitz_short_ons_3="" \
    ril.subscription.types=NV,RUIM \
    DEVICE_PROVISIONED=1

# Set network mode to (T/L/G/W/1X/EVDO, T/G/W/L) for 7+5 mode device on DSDS mode
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.default_network=20,20

# Enable IMS VoLTE&WFC properties
PRODUCT_PROPERTY_OVERRIDES += \
    persist.ims.enableADBLogs=1 \
    persist.ims.enableDebugLogs=1 \
    persist.radio.calls.on.ims=true \
    persist.radio.jbims=1 \
    persist.radio.vrte_logic=1 \
    persist.radio.domain.ps=false \
    persist.rcs.supported=0 \
    persist.dbg.ims_volte_enable=1 \
    persist.dbg.volte_avail_ovr=1 \
    persist.data.iwlan.enable=true \
    persist.dbg.wfc_avail_ovr=1

#HWUI properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hwui.texture_cache_size=72 \
    ro.hwui.layer_cache_size=48 \
    ro.hwui.r_buffer_cache_size=8 \
    ro.hwui.path_cache_size=32 \
    ro.hwui.gradient_cache_size=1 \
    ro.hwui.drop_shadow_cache_size=6 \
    ro.hwui.texture_cache_flushrate=0.4 \
    ro.hwui.text_small_cache_width=1024 \
    ro.hwui.text_small_cache_height=1024 \
    ro.hwui.text_large_cache_width=2048 \
    ro.hwui.text_large_cache_height=1024
