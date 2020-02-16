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

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.telephony.PhoneStateListener;
import android.telecom.TelecomManager;
import android.telephony.TelephonyManager;
import android.util.Log;

import org.lineageos.settings.device.LineageActionsSettings;
import org.lineageos.settings.device.SensorHelper;

import static android.telephony.TelephonyManager.*;

public class ProximitySilencer extends PhoneStateListener implements SensorEventListener, UpdatedStateNotifier {
    private static final String TAG = "LineageActions-ProximitySilencer";

    private static final int SILENCE_DELAY_MS = 500;

    private final TelecomManager mTelecomManager;
    private final TelephonyManager mTelephonyManager;
    private final LineageActionsSettings mLineageActionsSettings;
    private final SensorHelper mSensorHelper;
    private final Sensor mSensor;
    private boolean mIsRinging;
    private long mRingStartedMs;
    private boolean mCoveredRinging;

    public ProximitySilencer(LineageActionsSettings lineageActionsSettings, Context context,
                SensorHelper sensorHelper) {
        mTelecomManager = (TelecomManager) context.getSystemService(Context.TELECOM_SERVICE);
        mTelephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);

        mLineageActionsSettings = lineageActionsSettings;
        mSensorHelper = sensorHelper;
        mSensor = sensorHelper.getProximitySensor();
        mCoveredRinging = false;
        mIsRinging = false;
    }

    @Override
    public void updateState() {
        if (mLineageActionsSettings.isIrSilencerEnabled()) {
            mTelephonyManager.listen(this, LISTEN_CALL_STATE);
        } else {
            mTelephonyManager.listen(this, 0);
        }
    }

    @Override
    public synchronized void onSensorChanged(SensorEvent event) {
        boolean isNear = event.values[0] < mSensor.getMaximumRange();
        long now = System.currentTimeMillis();

        if (isNear){
            if (mIsRinging && (now - mRingStartedMs >= SILENCE_DELAY_MS)){
                mCoveredRinging = true;
            } else {
                mCoveredRinging = false;
            }
            return;
        }

        if (!isNear && mIsRinging) {
            Log.d(TAG, "event: " + event.values[0] + ", " + " covered " + Boolean.toString(mCoveredRinging));
            if (mCoveredRinging) {
                Log.d(TAG, "Silencing ringer");
                mTelecomManager.silenceRinger();
            } else {
                Log.d(TAG, "Ignoring silence gesture: " + now + " is too close to " +
                        mRingStartedMs + ", delay=" + SILENCE_DELAY_MS + " or covered " + Boolean.toString(mCoveredRinging));
            }
            mCoveredRinging = false;
        }
    }

    @Override
    public synchronized void onCallStateChanged(int state, String incomingNumber) {
        if (state == CALL_STATE_RINGING && !mIsRinging) {
            Log.d(TAG, "Ringing started");
            mSensorHelper.registerListener(mSensor, this);
            mIsRinging = true;
            mRingStartedMs = System.currentTimeMillis();
        } else if (state != CALL_STATE_RINGING && mIsRinging) {
            Log.d(TAG, "Ringing stopped");
            mSensorHelper.unregisterListener(this);
            mIsRinging = false;
        }
    }

    @Override
    public void onAccuracyChanged(Sensor mSensor, int accuracy) {
    }
}
