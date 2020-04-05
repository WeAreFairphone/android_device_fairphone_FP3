Device configuration for Fairphone 3
==================================
## Device specifications

Basic   | Spec Sheet
-------:|:-------------------------
CPU     | Octa-core 1.8 GHz Cortex-A53
CHIPSET | Qualcomm SDM632 Snapdragon 632
GPU     | Adreno 506
Memory  | 4GB
Shipped Android Version | 9.0 (Pie)
Internal Storage | 64GB
microSD | Up to 400GB (dedicated slot)
Battery | 3000 mAh
Dimensions | 158 x 71.8 x 9.89 mm
Display | 2160 x 1080 pixels, 5.65-inch IPS LCD
Rear Camera  | 12 MP (f/1.8, 1/2.55", PDAF)
Front Camera | 8 MP (f/2.0, 1/4", HDR)

### Introduction
This is my first draft to build LineageOS 16 for the Fairphone 3.
It's also my first time building LineageOS and it's been a while I last worked on
Android platform development. So please forgive me any major mistakes :blush:

I started with the [base configuration of Motorola's SDM632 platform](https://github.com/LineageOS/android_device_motorola_sdm632-common)
and used the [river configuration](https://github.com/LineageOS/android_device_motorola_river) as an example.
Not sure if that makes sense but at least it's the same chipset.

Also I took some settings and the kernel from k4y0z's amazing work for porting TWRP to Fairphone 3:
* <https://github.com/chaosmaster/android_device_fairphone_fp3>
* <https://github.com/chaosmaster/android_kernel_fairphone_sdm632>


### Current Status
* It builds successfully. :heavy_check_mark:
* Device boots and adb can be accessed. :heavy_check_mark:
* Bootanimation is shown. :heavy_check_mark:
* LineageOS is booting completely. :heavy_check_mark:
* Working things after quick test:
  * Display / Touchscreen :heavy_check_mark:
  * Sound :heavy_check_mark:
  * Bluetooth :heavy_check_mark:
  * Camera :heavy_check_mark:
  * Wi-Fi :heavy_check_mark:
  * NFC :heavy_check_mark:

### Known Issues
These things are untested or known not to work:
* LTE
* GPS
* Device encryption
* Updater
* Playing videos in fullscreen causing some overlay issue

### Kernel Source
Based on repository from k4y0z:
<https://github.com/chaosmaster/android_kernel_fairphone_sdm632>

Added the qcom specific audio-kernel stuff in techpack/audio.

Also I read the kernel config from the stock firmware as base.

Find my fork here: 
<https://github.com/mstaz/android_kernel_fairphone_sdm632>


### How to compile
* Follow the first steps for setting up the LineageOS build system as described e.g. [here](https://wiki.lineageos.org/devices/river/build).
* Before downloading the source code using repo sync, create a local manifest file in the
top of the source tree using
```sh
mkdir -p .../lineageos/.repo/local_manifests
cat <<EOF > .../lineageos/.repo/local_manifests/roomservice.xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="mstaz/android_device_fairphone_fp3" path="device/fairphone/fp3" remote="github" />
  <project name="mstaz/android_kernel_fairphone_sdm632" path="kernel/fairphone/sdm632" remote="github" />
  <project name="LineageOS/android_packages_resources_devicesettings" path="packages/resources/devicesettings" remote="github" />
  <project name="LineageOS/android_external_bson" path="external/bson" remote="github" />
  <project name="LineageOS/android_system_qcom" path="system/qcom" remote="github" />
</manifest>
EOF
```
This is a temporary hack while we are working outside of the LineageOS repositories.
* Do `repo sync -c` to download all needed project repositories.
* Extract proprietary files.
  * I used stock 110 release [firmware dump](https://androidfilehost.com/?fid=4349826312261714249) from k4y0z.
  * The files are compressed with brotli.
    * Install it if necessary, e.g. with `sudo apt-get install brotli`
    * Extract *.br files with: `brotli -d *.br`
    * The *.dat files then need to be converted to *.img files with sdat2img tool which comes with LOS.
```sh
vendor/lineage/build/tools/sdat2img.py system.transfer.list system.new.dat system.img
vendor/lineage/build/tools/sdat2img.py vendor.transfer.list vendor.new.dat vendor.img
vendor/lineage/build/tools/sdat2img.py product.transfer.list product.new.dat product.img
```
  * Mount system and vendor image and run the script on the folder:
```sh
sudo mount -o ro,loop system.img tmp
sudo mount -o ro,loop vendor.img tmp/vendor
cd .../lineageos/device/fairphone/fp3
./extract-files.sh .../tmp
```
* Then do
```sh
. build/envsetup.sh
brunch fp3 eng
```

### How to flash
First both slots need to have success state. See [HOW TO](https://forum.fairphone.com/t/how-to-flash-a-custom-rom-on-fp3-with-gsi/57074)
for flashing GSI images for that.

Flashing the package with TWRP seems to cause some problems yet.

So far I flash the images with fastboot. system.img is not copied to output root
folder so I take it from the packaging subfolder.
```sh
fastboot flash system out/target/product/fp3/obj/PACKAGING/target_files_intermediates/lineage_fp3-target_files-eng.ms/IMAGES/system.img
fastboot flash vendor out/target/product/fp3/vendor.img
fastboot flash product out/target/product/fp3/product.img
fastboot flash boot out/target/product/fp3/boot.img
fastboot flash dtbo out/target/product/fp3/dtbo.img
```

Boot into TWRP and disable verity:
```sh
adb disable-verity
```

Unfortunately sometimes for some reason [AVB](https://android.googlesource.com/platform/external/avb/)
immediately switches back to the other slot and prevents it from booting. Booting any image (even TWRP)
failes with following message:
```sh
Downloading 'boot.img'
OKAY [  1.006s]
booting
FAILED (status read failed (No such device))
Finished. Total time: 7.387s
```
Slot is switched to the other one then. Maybe it's connected to rollback protection.
However I'm not sure yet how this can be solved. Sometimes re-flashing vbmeta
images worked. Sometimes I needed to completely flash stock back to both slots
and get them successfully booted first. Sometimes even that doesn't work
immediately.
