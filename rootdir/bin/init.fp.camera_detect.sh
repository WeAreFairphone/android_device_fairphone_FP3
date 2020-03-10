#!/vendor/bin/sh

##********************************************************************
## Copyright 2017-2018 Fairphone B.V.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##********************************************************************

set -e
set -u
set -x

readonly PERSIST_PATH="persist"
readonly PROP_PATH="fp3.cam"

readonly ANY_FRAGMENT="any"
readonly SENSOR_FRAGMENT="sensor"
readonly VENDOR_FRAGMENT="vendor"
readonly CHANGED_FRAGMENT="changed"
readonly DETECTED_FRAGMENT="detected"
readonly POSITIONS="back front"

readonly BACK_SENSORS_PATTERN="(IMX486)"

readonly FRONT_SENSORS_PATTERN="(S5K4H7YX)"
readonly FRONT_VENDORS_PATTERN="(HOLITECH)"

##********************************************************************
##
##********************************************************************
function _detect_back_sensor() {
    local sensor_prop="${PROP_PATH}.back.${SENSOR_FRAGMENT}"
    local sensor_name="$(getprop "${sensor_prop}")"
    local sensor_get=0

    if [[ -n "${sensor_name}" ]] ; then
      sensor_get=1
    fi
}

##********************************************************************
##
##********************************************************************
function _detect_front_sensor() {
    local sensor_prop="${PROP_PATH}.front.${SENSOR_FRAGMENT}"
    local sensor_name="$(getprop "${sensor_prop}")"
    local sensor_get=0

    if [[ -n "${sensor_name}" ]] ; then
      sensor_get=1
    fi
}

##********************************************************************
##
##********************************************************************
function _detect_sensor_runned() {
    local detect_prop="${PROP_PATH}.${DETECTED_FRAGMENT}"
    local detect_runned="$(getprop "${detect_prop}")"
    local detect_get=0

    if [[ -n "${detect_runned}" ]] && [[ "${detect_runned}" == "1" ]] ; then
      detect_get=1
    fi

    echo "${detect_get}"
}

##********************************************************************
# Compare persist.* property with new property to detect if the front
# Sensor has changed.
#
# Sets *.changed property to 1 for any sensor that has changed.
#
# Overwrites persist.* property with new sensor name.
##********************************************************************
function _detect_and_persist_sensor_change() {
    local any_sensor_changed=0

    for pos in ${POSITIONS}; do
      local sensor_checked=8

      local property="${PROP_PATH}.${pos}.${SENSOR_FRAGMENT}"

      local new_sensor="$(getprop "${property}")"
      local old_sensor="$(getprop "${PERSIST_PATH}.${property}")"

      #===========================================================
      # advocate change if:
      # a sensor is detected in the current position
      # AND a persist value is set (a camera was previously installed)
      # AND a different sensor is detected than stored in the persist value
      #===========================================================
      if [[ -n "${new_sensor}" ]] ; then
        if [[ -n "${old_sensor}" ]] ; then
          if [[ "${old_sensor}" == "${new_sensor}" ]] ; then
            sensor_checked=0
          else
            sensor_checked=1
            any_sensor_changed=1
          fi
        else
          sensor_checked=3
          any_sensor_changed=1
        fi
      else
        sensor_checked=4
      fi

      setprop "${PROP_PATH}.${pos}.${CHANGED_FRAGMENT}" "${sensor_checked}"

      #===========================================================
      # Set new persist value with the new sensor name if it's non-empty
      #===========================================================
      if [[ -n "${new_sensor}" ]]; then
        setprop "${PERSIST_PATH}.${property}" "${new_sensor}"
      fi

    done

    echo "${any_sensor_changed}"
}

function _camera_detect() {
    local camera_detect_runned="$(_detect_sensor_runned)"

    if [[ "${camera_detect_runned}" == "0" ]] ; then
      _detect_back_sensor
      _detect_front_sensor

      local any_sensor_changed="$(_detect_and_persist_sensor_change)"

      setprop "${PROP_PATH}.${ANY_FRAGMENT}.${CHANGED_FRAGMENT}" "${any_sensor_changed}"

      setprop "${PROP_PATH}.${DETECTED_FRAGMENT}" "1"
    fi
}

_camera_detect
