/*
 * Copyright (c) 2016 The CyanogenMod Project
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

public class LiftToSilence extends PhoneStateListener implements SensorEventListener, UpdatedStateNotifier {
    private static final String TAG = "LineageActions-LiftToSilence";

    private final LineageActionsSettings mLineageActionsSettings;
    private final SensorHelper mSensorHelper;
    private final Sensor mFlatUpSensor;
    private final Sensor mStowSensor;

    private final TelecomManager mTelecomManager;
    private final TelephonyManager mTelephonyManager;

    private boolean mIsRinging;
    private boolean mIsStowed;
    private boolean mLastFlatUp;

    public LiftToSilence(LineageActionsSettings lineageActionsSettings, Context context,
                SensorHelper sensorHelper) {
        mLineageActionsSettings = lineageActionsSettings;
        mSensorHelper = sensorHelper;
        mFlatUpSensor = sensorHelper.getFlatUpSensor();
        mStowSensor = sensorHelper.getStowSensor();
        mTelecomManager = (TelecomManager) context.getSystemService(Context.TELECOM_SERVICE);
        mTelephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
    }

    @Override
    public void updateState() {
        if (mLineageActionsSettings.isLiftToSilenceEnabled()) {
            mTelephonyManager.listen(this, LISTEN_CALL_STATE);
        } else {
            mTelephonyManager.listen(this, 0);
        }
    }

    @Override
    public synchronized void onCallStateChanged(int state, String incomingNumber) {
        if (state == TelephonyManager.CALL_STATE_RINGING && !mIsRinging) {
            Log.d(TAG, "Ringing started");
            mSensorHelper.registerListener(mFlatUpSensor, this);
            mSensorHelper.registerListener(mStowSensor, mStowListener);
            mIsRinging = true;
        } else if (state != TelephonyManager.CALL_STATE_RINGING && mIsRinging) {
            Log.d(TAG, "Ringing stopped");
            mSensorHelper.unregisterListener(this);
            mSensorHelper.unregisterListener(mStowListener);
            mIsRinging = false;
        }
    }


    @Override
    public synchronized void onSensorChanged(SensorEvent event) {
        boolean thisFlatUp = (event.values[0] != 0);

        Log.d(TAG, "event: " + thisFlatUp + " mLastFlatUp=" + mLastFlatUp + " mIsStowed=" +
            mIsStowed);

        if (mLastFlatUp && !thisFlatUp && !mIsStowed) {
            mTelecomManager.silenceRinger();
        }
        mLastFlatUp = thisFlatUp;
    }

    @Override
    public void onAccuracyChanged(Sensor mSensor, int accuracy) {
    }

    private SensorEventListener mStowListener = new SensorEventListener() {
        @Override
        public synchronized void onSensorChanged(SensorEvent event) {
            mIsStowed = (event.values[0] != 0);
        }

        @Override
        public void onAccuracyChanged(Sensor mSensor, int accuracy) {
        }
    };
}
