enum LoggerType { debug, info, warn, error, api }

extension LoggerTypeExt on LoggerType {
  String get prefix {
    switch (this) {
      case LoggerType.debug:
        return '[\u{2b1c} DEBUG]';
      case LoggerType.info:
        return '[\u{1f7e9} INFO]';
      case LoggerType.warn:
        return '[\u{1f7e7} WARN]';
      case LoggerType.error:
        return '[\u{1f7e5} ERROR]';
      case LoggerType.api:
        return '[\u{1f7e6} API]';
    }
  }

  static const resetColorAnsi = '\x1B[0m';

  String get colorAnsi {
    switch (this) {
      case LoggerType.debug:
        return '\x1B[37m';
      case LoggerType.info:
        return '\x1B[32m';
      case LoggerType.warn:
        return '\x1B[33m';
      case LoggerType.error:
        return '\x1B[31m';
      case LoggerType.api:
        return '\x1B[34m';
    }
  }

  /*
    Black:   \x1B[30m
    Red:     \x1B[31m
    Green:   \x1B[32m
    Yellow:  \x1B[33m
    Blue:    \x1B[34m
    Magenta: \x1B[35m
    Cyan:    \x1B[36m
    White:   \x1B[37m
    Reset:   \x1B[0m
  */

  String get level {
    switch (this) {
      case LoggerType.debug:
        return "v";
      case LoggerType.info:
        return "i";
      case LoggerType.warn:
        return "w";
      case LoggerType.error:
        return "e";
      case LoggerType.api:
        return "d";
    }
  }
}
