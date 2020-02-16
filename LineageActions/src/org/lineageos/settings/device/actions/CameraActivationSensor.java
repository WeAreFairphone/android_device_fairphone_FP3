/*
 * Copyright (c) 2015 The CyanogenMod Project
 * Copyright (c) 2017 The LineageOS Project
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

package org.lineageos.settings.device.actions;

import java.util.List;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;

import org.lineageos.settings.device.LineageActionsSettings;
import org.lineageos.settings.device.SensorHelper;

public class CameraActivationSensor implements SensorEventListener, UpdatedStateNotifier {
    private static final String TAG = "LineageActions-CameraSensor";

    private static final int TURN_SCREEN_ON_WAKE_LOCK_MS = 500;

    private final LineageActionsSettings mLineageActionsSettings;
    private final SensorHelper mSensorHelper;

    private final Sensor mSensor;

    private boolean mIsEnabled;

    public CameraActivationSensor(LineageActionsSettings lineageActionsSettings, SensorHelper sensorHelper) {
        mLineageActionsSettings = lineageActionsSettings;
        mSensorHelper = sensorHelper;
        mSensor = sensorHelper.getCameraActivationSensor();
        mSensorHelper.registerListener(mSensor, this);
    }

    @Override
    public synchronized void updateState() {
        if (mLineageActionsSettings.isCameraGestureEnabled() && !mIsEnabled) {
            Log.d(TAG, "Enabling");
            mIsEnabled = true;
        } else if (! mLineageActionsSettings.isCameraGestureEnabled() && mIsEnabled) {
            Log.d(TAG, "Disabling");
            mIsEnabled = false;
        }
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        Log.d(TAG, "activate camera");
        if (mIsEnabled) mLineageActionsSettings.cameraAction();
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }
}
