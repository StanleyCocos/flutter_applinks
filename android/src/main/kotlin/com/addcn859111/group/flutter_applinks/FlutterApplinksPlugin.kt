package com.addcn859111.group.flutter_applinks

import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FlutterApplinksPlugin */
public class FlutterApplinksPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.NewIntentListener {

  private var channel: MethodChannel? = null
  private var mainActivity: Activity? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    onAttachedToEngine(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val instance = FlutterApplinksPlugin()
      instance.setActivity(registrar.activity())
      instance.addNewIntentListener(registrar)
      instance.onAttachedToEngine(registrar.context(), registrar.messenger())
    }
  }

  private fun setActivity(flutterActivity: Activity) {
    mainActivity = flutterActivity
  }

  private fun addNewIntentListener(registrar: Registrar) {
    registrar.addNewIntentListener(this)
  }

  private fun onAttachedToEngine(context: Context, binaryMessenger: BinaryMessenger) {
    channel = MethodChannel(binaryMessenger, "flutter_applinks")
    channel?.setMethodCallHandler(this)
    (context as Application).registerActivityLifecycleCallbacks(object : Application.ActivityLifecycleCallbacks {
      override fun onActivityPaused(activity: Activity) {
      }

      override fun onActivityStarted(activity: Activity) {
      }

      override fun onActivityDestroyed(activity: Activity) {
      }

      override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
      }

      override fun onActivityStopped(activity: Activity) {
      }

      override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        channel?.invokeMethod("openApplinks", mapOf("url" to activity.intent.data.toString()))
      }

      override fun onActivityResumed(activity: Activity) {
      }
    })
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      val appLinkData = mainActivity?.intent?.data
      if (null != appLinkData) {
        result.success("Android $appLinkData")
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel?.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    this.mainActivity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.mainActivity = binding.activity
    binding.addOnNewIntentListener(this)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.mainActivity = binding.activity
    binding.addOnNewIntentListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    this.mainActivity = null
  }

  override fun onNewIntent(intent: Intent?): Boolean {
    channel?.invokeMethod("openApplinks", mapOf("url" to intent?.data.toString()))
    return false
  }
}
