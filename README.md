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
This is the device tree to build LineageOS 16 for the Fairphone 3.

Originally it was started with the [base configuration of Motorola's SDM632 platform](https://github.com/LineageOS/android_device_motorola_sdm632-common)
and the [river configuration](https://github.com/LineageOS/android_device_motorola_river) was used as an example.
Some [settings](https://github.com/chaosmaster/android_device_fairphone_fp3) and the [kernel](https://github.com/chaosmaster/android_kernel_fairphone_sdm632)
originate from k4y0z's amazing work for porting TWRP to Fairphone 3.

Since the /e/ foundation published the [sources for FP3 support](https://gitlab.e.foundation/e/devices/android_device_fairphone_FP3) this was used as base.
Advantages are:
* We can easily sync between the repos.
* Nearly everything is working with it incl. AVB, SELinux etc.

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
  * Device encryption :heavy_check_mark:
  * Fingerprint sensor :heavy_check_mark:
  * LTE :heavy_check_mark:
  * GPS :heavy_check_mark:

### Known Issues
These things are untested or known not to work:
* Updater
* Playing videos in fullscreen causing some overlay issue in Chrome

### Kernel Source
Kernel is taken from /e/ project now.

It has added the qcom specific audio-kernel stuff in techpack/audio and the prima WLAN
drivers.

Kernel sources are here in the lineage-16.0 branch: 
<https://github.com/WeAreFairphone/android_kernel_fairphone_sdm632/tree/lineage-16.0>


### How to compile
* Follow the first steps for setting up the LineageOS build system as described e.g. [here](https://wiki.lineageos.org/devices/river/build).
* Before downloading the source code using repo sync, create a local manifest file in the
top of the source tree using
```sh
mkdir -p .repo/local_manifests
cat <<EOF > .repo/local_manifests/roomservice.xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="WeAreFairphone/android_device_fairphone_FP3" path="device/fairphone/FP3" revision="lineage-16.0" remote="github" />
  <project name="WeAreFairphone/android_kernel_fairphone_sdm632" path="kernel/fairphone/sdm632" revision="lineage-16.0" remote="github" />
  <project name="LineageOS/android_packages_resources_devicesettings" path="packages/resources/devicesettings" remote="github" />
  <project name="LineageOS/android_external_bson" path="external/bson" remote="github" />
  <project name="LineageOS/android_system_qcom" path="system/qcom" remote="github" />
</manifest>
EOF
```
This is a temporary hack while we are working outside of the LineageOS repositories.
* Do `repo sync -c` to download all needed project repositories.
* Extract proprietary files.
  * E.g. stock 110 release [firmware dump](https://androidfilehost.com/?fid=4349826312261714249) from k4y0z can be used.
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
mkdir tmp
sudo mount -o ro,loop system.img tmp
sudo mount -o ro,loop vendor.img tmp/vendor
cd device/fairphone/FP3
./extract-files.sh ../../../tmp
```
  * If file access permissions are missing change it before calling
	extract_files.sh, e.g. with chown (don't flash image files anymore after that):
```sh
sudo chown -R $(id -un):$(id -gn) tmp
```
* Then do
```sh
. build/envsetup.sh
brunch FP3 eng
```

### How to install
With generated vbmeta.img it shouldn't be required to have both slots in successful state anymore
([details here](https://forum.fairphone.com/t/how-to-flash-a-custom-rom-on-fp3-with-gsi/57074)).
However it makes sense to have a working fallback to ensure nothing gets
bricked.
As always backup is highly recommended anyway.

#### With TWRP
The generated update package can be flashed with TWRP. TWRP flashes it to the
currently inactive slots and activates it afterwards.
The built package can be found in `out/target/product/FP3` with the name like `lineage-16.0-20200505-UNOFFICIAL-FP3.zip`.
Alternatively the package can also be taken from an UNOFFICIAL release.

Boot TWRP from bootloader:
```sh
fastboot boot twrp_image.img
```

In TWRP you can sideload the package then. Go to Advanced -> ADB Sideload ->
Swipe
Run
```sh
adb sideload lineage-16.0-20200509-UNOFFICIAL-FP3.zip
```
Adapt the file name of course. This should flash it to the inactive slot and
activate it on success.

Alternatively you can push the package to sd-card and install it from TWRP:
```sh
adb push lineage-16.0-20200509-UNOFFICIAL-FP3.zip /sdcard
```

Optional when coming from stock firmware: Format data from TWRP.

If this is not done LineageOS will reboot and ask you for it.

Reboot and LineageOS should boot up.

#### With fastboot

The image files can also be flashed directly with fastboot.
```sh
fastboot flash system out/target/product/FP3/system.img
fastboot flash vendor out/target/product/FP3/vendor.img
fastboot flash product out/target/product/FP3/product.img
fastboot flash boot out/target/product/FP3/boot.img
fastboot flash dtbo out/target/product/FP3/dtbo.img
fastboot flash vbmeta out/target/product/FP3/vbmeta.img
```

If coming from stock firmware formating data is recommended to prevent LinageOS
from asking for it:
```sh
fastboot -w
```

Disabling verity should not be required anymore as long as the images are not
modified afterwards, e.g. something is intalled to system or boot partition.
In that case boot into TWRP and disable verity with adb:
```sh
adb disable-verity
```

### How to update
So far OTA update are not available and are untested as well.
That means updates need to be done manually. For that boot to recovery mode
and simply sideload the new package.

Alternatively TWRP can be booted and the new package can be installed from
there.

Of course flashing images directly with fastboot is possible too.
