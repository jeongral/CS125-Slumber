package com.example.slumber;

import java.lang.reflect.Method;

import android.os.Bundle;
import androidx.annotation.NonNull;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;

import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/slumber";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    public void onMethodCall(MethodCall call, Result result) {
                        if (call.method.equals("getGyroscopeData")) {
                            int g = getGyroscopeData();
                        }
                        else
                            result.notImplemented();
                    }
                }
        );
    }

    private int getGyroscopeData() {
        return 0;
    }
}
