package com.artembark.multi_imei

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.TelephonyManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.util.*

/** MultiImeiPlugin */
class MultiImeiPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.RequestPermissionsResultListener {
    private lateinit var channel: MethodChannel
    private val IMEI_METHOD_CHANNEL_NAME = "multi_imei"
    private val phoneStatePermissionCode = 1000
    private var permissionGranted: Boolean = false
    private var activity: Activity? = null
    private var mResult: Result? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, IMEI_METHOD_CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    @SuppressLint("MissingPermission", "NewApi")
    override fun onMethodCall(call: MethodCall, result: Result) {
        mResult = result;
        val currentActivity: Activity? = activity;
        if (call.method == "getImeiList") {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M||Build.VERSION.SDK_INT > Build.VERSION_CODES.P) {
                result.error("4000", "IMEI not available for this Android version", null)
            } else if (currentActivity != null) {
                permissionGranted = ContextCompat.checkSelfPermission(
                    currentActivity, Manifest.permission.READ_PHONE_STATE
                ) == PackageManager.PERMISSION_GRANTED
                if (permissionGranted) {
                    getImeiMulti(currentActivity, mResult)
                } else {
                    currentActivity.requestPermissions(
                        arrayOf(Manifest.permission.READ_PHONE_STATE), phoneStatePermissionCode
                    )
                }
            }
        } else {
            result.notImplemented()
        }
    }

    @SuppressLint("MissingPermission", "HardwareIds")
    private fun getImeiMulti(activity: Activity?, result: Result?) {
        try {
            val telephonyManager =
                activity?.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            val imeiList: ArrayList<String> = ArrayList()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val phoneCount: Int = telephonyManager.phoneCount
                for (i in 0..phoneCount - 1) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        imeiList.add(telephonyManager.getImei(i))
                    } else imeiList.add(
                        telephonyManager.getDeviceId(i)
                    )
                }
                result?.success(imeiList)
            }
        } catch (ex: Exception) {
            result?.error("4001", "Error trying to get IMEI from TelephonyManager", null)
        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray
    ): Boolean {
        when (requestCode) {
            phoneStatePermissionCode -> {
                permissionGranted =
                    grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED
                if (permissionGranted) getImeiMulti(activity, mResult)
                else mResult?.error("4002", "Permission denied", null)
                return true
            }
        }
        return false
    }
}
