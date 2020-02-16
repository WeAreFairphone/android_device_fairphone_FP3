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

import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.util.Log;

import org.lineageos.settings.device.LineageActionsSettings;
import org.lineageos.settings.device.SensorHelper;

public class FlipToMute implements UpdatedStateNotifier {
    private static final String TAG = "LineageActions-FlipToMute";

    private final NotificationManager mNotificationManager;
    private final LineageActionsSettings mLineageActionsSettings;
    private final SensorHelper mSensorHelper;
    private final Sensor mFlatDown;
    private final Sensor mStow;

    private boolean mIsEnabled;
    private boolean mIsFlatDown;
    private boolean mIsStowed;
    private int mFilter;
    private Context mContext;
    private Receiver mReceiver;

    public FlipToMute(LineageActionsSettings lineageActionsSettings, Context context,
                SensorHelper sensorHelper) {
        mLineageActionsSettings = lineageActionsSettings;
        mContext = context;
        mSensorHelper = sensorHelper;
        mFlatDown = sensorHelper.getFlatDownSensor();
        mStow = sensorHelper.getStowSensor();
        mNotificationManager =
            (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        mFilter = mNotificationManager.getCurrentInterruptionFilter();
        mReceiver = new Receiver();
    }

    @Override
    public void updateState() {
        if (mLineageActionsSettings.isFlipToMuteEnabled() && !mIsEnabled) {
            Log.d(TAG, "Enabling");
            mSensorHelper.registerListener(mFlatDown, mFlatDownListener);
            mSensorHelper.registerListener(mStow, mStowListener);
            mContext.registerReceiver(mReceiver,
                new IntentFilter(NotificationManager.ACTION_INTERRUPTION_FILTER_CHANGED));
            mIsEnabled = true;
        } else if (!mLineageActionsSettings.isFlipToMuteEnabled() && mIsEnabled) {
            Log.d(TAG, "Disabling");
            mSensorHelper.unregisterListener(mFlatDownListener);
            mSensorHelper.unregisterListener(mStowListener);
            mContext.unregisterReceiver(mReceiver);
            mIsEnabled = false;
        }
    }

    private SensorEventListener mFlatDownListener = new SensorEventListener() {
        @Override
        public synchronized void onSensorChanged(SensorEvent event) {
            mIsFlatDown = (event.values[0] != 0);
            sensorChange();
        }

        @Override
        public void onAccuracyChanged(Sensor mSensor, int accuracy) {
        }
    };

    private SensorEventListener mStowListener = new SensorEventListener() {
        @Override
        public synchronized void onSensorChanged(SensorEvent event) {
            mIsStowed = (event.values[0] != 0);
            sensorChange();
        }

        @Override
        public void onAccuracyChanged(Sensor mSensor, int accuracy) {
        }
    };

    private void sensorChange() {

        Log.d(TAG, "event: " + mIsFlatDown + " mIsStowed=" + mIsStowed);

        if (mIsFlatDown && mIsStowed) {
            mNotificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_PRIORITY);
            Log.d(TAG, "Interrupt filter: Allow priority");
        } else if (!mIsFlatDown) {
            mNotificationManager.setInterruptionFilter(mFilter);
            Log.d(TAG, "Interrupt filter: Restore");
        }
    }

    public class Receiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            if (!mIsFlatDown && !mIsStowed) {
                mFilter = mNotificationManager.getCurrentInterruptionFilter();
                Log.d(TAG, "Interrupt filter: Backup");
            }
        }
    }
}
