package com.sunstone.admin

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.sunstone.admin"
    private val enableBluetooth = "enable_bluetooth"
    private lateinit var result: MethodChannel.Result

    companion object {
        private const val RC_BLUETOOTH: Int = 1001;
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->  when (call.method!!) {
            enableBluetooth -> enableBluetooth(call, result)
            else -> result.notImplemented()
        }
        }
    }
    private var enableBluetoothResult: MethodChannel.Result? = null
    //enables the bluetooth programmatically

    private fun enableBluetooth(call: MethodCall, result: MethodChannel.Result) {
        this.enableBluetoothResult = result
        val bluetoothManager: BluetoothManager =
            getSystemService(BluetoothManager::class.java)
        val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
        if (bluetoothAdapter == null) {
            result.notImplemented()
            return
        }
        if (bluetoothAdapter.isEnabled) {
            result.success(true)
        } else {
            val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            startActivityForResult(enableBtIntent, RC_BLUETOOTH)
        }

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {

        super.onActivityResult(requestCode, resultCode, data)
         if (requestCode == RC_BLUETOOTH) {
            try {
                if (enableBluetoothResult == null) {
                    Log.d(
                        "enableBluetoothResult",
                        "onActivityResult: problem: pendingResult is null"
                    )
                } else {
                    if (resultCode == RESULT_OK) {
                        enableBluetoothResult?.success(true)
                    } else {
                        enableBluetoothResult?.success(false)
                    }
                }
            } catch (e: Exception) {
                Log.e("exception", "onActivityResult REQUEST_ENABLE_BLUETOOTH")
            }
        }

    }
}