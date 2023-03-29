import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'logger_method_channel.dart';
import 'logger_type.dart';

typedef ErrorReportFunction = void Function(
  dynamic exception,
  StackTrace? stacktrace,
  dynamic reason,
  bool fatal,
);

class Logger {
  Logger._();

  static final _functionRegExp = RegExp(r'[A-Za-z0-9]');

  static bool? _isNotReleaseCache;

  static bool get _isNotRelease {
    _isNotReleaseCache ??= !kReleaseMode;
    return _isNotReleaseCache!;
  }

  static void setForceLog() => _isNotReleaseCache = true;

  static bool _isEnabledColorLog = true;

  static void disableColorLog() => _isEnabledColorLog = false;

  static ErrorReportFunction? reportToError;

  static void api(
    String msg, {
    String? tag,
    int upperStackCnt = 0,
    bool skipFunctionName = true,
    Object? e,
    StackTrace? s,
  }) async =>
      _showLog(
        LoggerType.api,
        msg,
        tag,
        upperStackCnt,
        skipFunctionName,
        e: e,
        s: s,
      );

  static void debug(
    String msg, {
    String? tag,
    int upperStackCnt = 0,
    bool skipFunctionName = false,
    Object? e,
    StackTrace? s,
  }) async =>
      _showLog(
        LoggerType.debug,
        msg,
        tag,
        upperStackCnt,
        skipFunctionName,
        e: e,
        s: s,
      );

  static void info(
    String msg, {
    String? tag,
    int upperStackCnt = 0,
    bool skipFunctionName = false,
    Object? e,
    StackTrace? s,
  }) async =>
      _showLog(
        LoggerType.info,
        msg,
        tag,
        upperStackCnt,
        skipFunctionName,
        e: e,
        s: s,
      );

  static void warn(
    String msg, {
    String? tag,
    int upperStackCnt = 0,
    bool skipFunctionName = false,
    Object? e,
    StackTrace? s,
  }) async =>
      _showLog(
        LoggerType.warn,
        msg,
        tag,
        upperStackCnt,
        skipFunctionName,
        e: e,
        s: s,
      );

  static void error(
    String msg, {
    String? tag,
    int upperStackCnt = 0,
    bool skipFunctionName = false,
    Object? e,
    StackTrace? s,
    dynamic errorType,
    bool fatal = true,
  }) async {
    _showLog(
      LoggerType.error,
      msg,
      tag,
      upperStackCnt,
      skipFunctionName,
      e: e,
      s: s,
    );
    reportToError?.call(e, s, msg, fatal);
  }

  static void _showLog(
    LoggerType type,
    String msg,
    String? tag,
    int upperStackCnt,
    bool skipFunctionName, {
    Object? e,
    StackTrace? s,
  }) {
    try {
      if (_isNotRelease) {
        var rawMsg =
            msg + (e == null ? '' : '\n$e') + (s == null ? '' : '\n$s');
        final tagStr = tag != null ? ' [$tag]' : '';
        final functionName = skipFunctionName
            ? ''
            : _getFunctionNameFromFrame(upperStackCnt: upperStackCnt);

        final formattedMsg = _makeFormattedMsg(
          type: type,
          functionName: functionName,
          msg: rawMsg,
          tagStr: tagStr,
        );
        final msgList = _splitMsg(formattedMsg);

        if (Platform.isAndroid) {
          _print(msgList: msgList, type: type);
        } else {
          _log(msg: formattedMsg, type: type);
          _nsLog(msgList: msgList);
        }
      }
    } catch (e, s) {
      log('logger error\ne = $e\ns = $s');
    }
  }

  static List<String> _splitMsg(String log) {
    List<String> logList = log.split('\n');
    List<String> result = [];
    for (String logMsg in logList) {
      result.addAll(_split(logMsg));
    }
    return result;
  }

  static List<String> _split(String log) {
    List<String> lineList = [];
    StringBuffer strBuf = StringBuffer();
    int bytesLength = 0;
    for (int i = 0; i < log.length; i++) {
      final char = log[i];
      final encodeCharLen = utf8.encode(char).length;

      if (bytesLength + encodeCharLen > 1000) {
        lineList.add(strBuf.toString());
        strBuf.clear();
        bytesLength = 0;
      }

      bytesLength += encodeCharLen;
      strBuf.write(char);
    }

    if (strBuf.length > 0) {
      lineList.add(strBuf.toString());
    }

    return lineList;
  }

  static String _getFunctionNameFromFrame({required int upperStackCnt}) {
    try {
      final currentTrace =
          StackTrace.current.toString().split('\n')[3 + upperStackCnt];
      var indexOfWhiteSpace = currentTrace.indexOf(' ');
      var subStr = currentTrace.substring(indexOfWhiteSpace);
      final indexOfFunction = subStr.indexOf(_functionRegExp);
      subStr = subStr.substring(indexOfFunction);
      indexOfWhiteSpace = subStr.indexOf(' ');
      subStr = subStr.substring(0, indexOfWhiteSpace);
      return '[$subStr()]';
    } catch (e, s) {
      log('[parsing function name failed..]\n$s');
      return '[unknown func]';
    }
  }

  static String _makeFormattedMsg({
    required LoggerType type,
    required String functionName,
    required String msg,
    required String tagStr,
  }) {
    return '${type.prefix}$tagStr [${DateTime.now()}] $functionName $msg';
  }

  static void _print(
      {required List<String> msgList, required LoggerType type}) {
    for (var i = 0; i < msgList.length; i++) {
      final message = '${i == 0 ? '' : '\t'}${msgList[i]}';
      debugPrint(
        _isEnabledColorLog
            ? '${type.colorAnsi}$message${LoggerTypeExt.resetColorAnsi}'
            : message,
      );
    }
  }

  static void _log({required String msg, required LoggerType type}) {
    final printList = msg.split('\n');
    for (var i = 0; i < printList.length; i++) {
      final message = '${i == 0 ? '' : '\t'}${printList[i]}';
      log(
        _isEnabledColorLog
            ? '${type.colorAnsi}$message${LoggerTypeExt.resetColorAnsi}'
            : message,
        name: 'logger',
      );
    }
  }

  static void _nsLog({required List<String> msgList}) {
    if (Platform.isIOS) {
      List<String> logList = [];
      for (var i = 0; i < msgList.length; i++) {
        logList.add('${i == 0 ? '' : '\t'}${msgList[i]}');
      }
      MethodChannelLogger.sendLog(logList);
    }
  }
}
