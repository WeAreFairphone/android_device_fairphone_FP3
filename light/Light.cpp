/*
 * Copyright (C) 2017 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "LightService"

#include <log/log.h>

#include "Light.h"

#include <fstream>

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define LEDS            "/sys/class/leds/"

#define LCD_LED         LEDS "lcd-backlight/"
#define RED_LED         LEDS "red/"
#define GREEN_LED       LEDS "green/"
#define BLUE_LED        LEDS "blue/"

#define BRIGHTNESS      "brightness"
#define BREATH          "breath"
#define DELAY_OFF       "delay_off"
#define DELAY_ON        "delay_on"


static void set_breath(int redBrightness,int greenBrightness, int blueBrightness) {
	int red = open(RED_LED BREATH,O_WRONLY);
	int green = open(GREEN_LED BREATH,O_WRONLY);
	int blue = open(BLUE_LED BREATH,O_WRONLY);
	
    if(red == -1) {
		ALOGE("failed to open " RED_LED BREATH);
	}
	
    if(green == -1) {
		ALOGE("failed to open " GREEN_LED BREATH);
	}
	
    if(blue == -1) {
		ALOGE("failed to open " BLUE_LED BREATH);
	}
	
	int re,ge,be;
	if (redBrightness > 0) 
            re = write(red,"1",1);
    else
            re = write(red,"0",1);
    
    if (greenBrightness > 0)
           ge = write(green,"1",1);
    else
           ge = write(green,"0",1);
    
    if (blueBrightness > 0)
           be = write(blue,"1",1);
    else
           be = write(blue,"0",1);
        
    if(re != 1)
        	ALOGE("failed to write to " RED_LED BREATH " errorcode: %i",re);
    if(ge != 1)
        	ALOGE("failed to write to " GREEN_LED BREATH " errorcode: %i",ge);    
    if(be != 1)
        	ALOGE("failed to write to " BLUE_LED BREATH " errorcode: %i",be);    
    close(red);
    close(green);
    close(blue);
}

/*
 * Write value to path and close file.
 */
static void set(std::string path, std::string value) {
    std::ofstream file(path);

    if (!file.is_open()) {
        ALOGE("failed to write %s to %s", value.c_str(), path.c_str());
        return;
    }

    file << value;
}

static void set(std::string path, int value) {
    set(path, std::to_string(value));
}

static void handleBacklight(const LightState& state) {
    uint32_t brightness = state.color & 0xFF;
    set(LCD_LED BRIGHTNESS, brightness);
}

static void handleNotification(const LightState& state) {
    uint32_t redBrightness, greenBrightness, blueBrightness, brightness;

    /*
     * Extract brightness from AARRGGBB.
     */
    redBrightness = (state.color >> 16) & 0xFF;
    greenBrightness = (state.color >> 8) & 0xFF;
    blueBrightness = state.color & 0xFF;

    brightness = (state.color >> 24) & 0xFF;

    /*
     * Scale RGB brightness if the Alpha brightness is not 0xFF.
     */
    if (brightness != 0xFF) {
        redBrightness = (redBrightness * brightness) / 0xFF;
        greenBrightness = (greenBrightness * brightness) / 0xFF;
        blueBrightness = (blueBrightness * brightness) / 0xFF;
    }

    /* Disable blinking. */
    set_breath(0,0,0);

    if (state.flashMode == Flash::TIMED) {
        /* Enable blinking. */
        set_breath(redBrightness, greenBrightness, blueBrightness);
    } else {
        set(RED_LED BRIGHTNESS, redBrightness);
        set(GREEN_LED BRIGHTNESS, greenBrightness);
        set(BLUE_LED BRIGHTNESS, blueBrightness);
    }
}

static inline bool isLit(const LightState& state) {
    return state.color & 0x00ffffff;
}

/* Keep sorted in the order of importance. */
static std::vector<LightBackend> backends = {
    { Type::ATTENTION, handleNotification },
    { Type::NOTIFICATIONS, handleNotification },
    { Type::BATTERY, handleNotification },
    { Type::BACKLIGHT, handleBacklight }
};

namespace android {
namespace hardware {
namespace light {
namespace V2_0 {
namespace implementation {

Return<Status> Light::setLight(Type type, const LightState& state) {
    LightStateHandler handler = nullptr;
    bool handled = false;

    /* Lock global mutex until light state is updated. */
    std::lock_guard<std::mutex> lock(globalLock);

    /* Update the cached state value for the current type. */
    for (LightBackend& backend : backends) {
        if (backend.type == type) {
            backend.state = state;
            handler = backend.handler;
        }
    }

    /* If no handler has been found, then the type is not supported. */
    if (!handler) {
        return Status::LIGHT_NOT_SUPPORTED;
    }

    /* Light up the type with the highest priority that matches the current handler. */
    for (LightBackend& backend : backends) {
        if (handler == backend.handler && isLit(backend.state)) {
            handler(backend.state);
            handled = true;
            break;
        }
    }

    /* If no type has been lit up, then turn off the hardware. */
    if (!handled) {
        handler(state);
    }

    return Status::SUCCESS;
}

Return<void> Light::getSupportedTypes(getSupportedTypes_cb _hidl_cb) {
    std::vector<Type> types;

    for (const LightBackend& backend : backends) {
        types.push_back(backend.type);
    }

    _hidl_cb(types);

    return Void();
}

}  // namespace implementation
}  // namespace V2_0
}  // namespace light
}  // namespace hardware
}  // namespace android
