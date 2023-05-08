package kr.dayugi.logger

import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class LoggerPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "logger.dayugi.kr")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "logcat") {
            val args = call.arguments as Map<String, *>
            val level = args["level"] as String
            val logMsg = args["logMsg"] as String

            when (level) {
                "v" -> Log.v("Flutter", logMsg)
                "d" -> Log.d("Flutter", logMsg)
                "i" -> Log.i("Flutter", logMsg)
                "w" -> Log.w("Flutter", logMsg)
                "e" -> Log.e("Flutter", logMsg)
                else -> throw IllegalArgumentException("정의되지 않은 Log Level 입니다. log level = $level")
            }

            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}