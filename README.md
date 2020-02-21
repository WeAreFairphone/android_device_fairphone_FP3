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
Display | 2270 x 1080 pixels, 5.65-inch IPS LCD
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
It builds successful. But init scripts etc. definitely needs to be checked.

However I'll try to run it as soon as I've created a safe backup :wink:

### Known Issues
It finally builds but didn't try it on the device yet.

### Kernel Source
Based on repository from k4y0z:
<https://github.com/chaosmaster/android_kernel_fairphone_sdm632>

However I needed to add some qcom specific audio stuff in techpack/audio. Seems
little bit like this is missing in the sources from FP. Or it's not required.
Not sure about that yet.

Also I read the kernel config from the stock firmware.

Find my fork here: 
<https://github.com/mstaz/android_kernel_fairphone_sdm632>

### How to compile
* Setup LineageOS build system as described e.g. [here](https://wiki.lineageos.org/devices/river/build).
* Instead of "Prepare the device-specific code" clone this repo to
device/fairphone/fp3 and the kernel sources to kernel/fairphone/sdm632.
  * I guess this can be done more clean with .repo/local_manifests/roomservice.xml.
  Need to try first. Maybe someone can show me how to do this.
* Extract proprietary files.
  * I used stock [firmware dump](https://www.androidfilehost.com/?fid=4349826312261719146) from k4y0z.
  * Mount system and vendor image and run the script on the folder:
```sh
sudo mount -o loop system.img tmp
sudo mount -o loop vendor.img tmp/vendor
cd .../lineageos/device/fairphone/fp3
./extract-files.sh .../tmp
```
* Then do
```sh
. build/envsetup.sh
brunch fp3 eng
```
