import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MethodChannelLogger {
  static MethodChannel get methodChannel =>
      _methodChannel ??= const MethodChannel('logger.dayugi.kr');
  static MethodChannel? _methodChannel;

  static Future<void> sendLog(List<String> logList) async {
    try {
      await methodChannel.invokeMethod<void>('logMsg', logList);
    } catch (e) {
      debugPrint('[LoggerChannel] sendLog error = $e'); // 여긴 변경 없이 그대로
    }
  }
}
