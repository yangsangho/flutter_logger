import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'logger_type.dart';

class MethodChannelLogger {
  static MethodChannel get methodChannel =>
      _methodChannel ??= const MethodChannel('logger.dayugi.kr');
  static MethodChannel? _methodChannel;

  static Future<void> logcat({
    required LoggerType type,
    required String functionName,
    required String msg,
    required String? tag,
  }) async {
    try {
      final logMsg = "${tag == null ? '' : '[$tag]'}[$functionName] $msg";
      await methodChannel.invokeMethod<void>(
          'logcat', {'level': type.level, 'logMsg': logMsg});
    } catch (e) {
      debugPrint('[LoggerChannel] logcat error = $e'); // 여긴 변경 없이 그대로
    }
  }

  static Future<void> sendLog(List<String> logList) async {
    try {
      await methodChannel.invokeMethod<void>('logMsg', logList);
    } catch (e) {
      debugPrint('[LoggerChannel] sendLog error = $e'); // 여긴 변경 없이 그대로
    }
  }
}
