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
It starts building the sources, but couldn't complete building yet.

### Known Issues
It doesn't even build yet. :innocent:

At the moment it stops at a build error in kernel sources.

### Kernel Source
<https://github.com/chaosmaster/android_kernel_fairphone_sdm632>

### How to compile
* Setup LineageOS build system as described e.g. [here](https://wiki.lineageos.org/devices/river/build).
* Instead of "Prepare the device-specific code" clone this repo to
device/fairphone/fp3 and the kernel sources to kernel/fairphone/sdm632.
  * I guess this can be done more clean with .repo/local_manifests/roomservice.xml.
  Need to try first. Maybe someone can show me how to do this.
* Then do
```sh
. build/envsetup.sh
brunch fp3 eng
```
