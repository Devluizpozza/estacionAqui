// ignore_for_file: avoid_print

import 'package:estacionaqui/app/consts/const.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static void infow({String? message = ''}) {
    if (Consts.is_development) {
      debugPrint(message);
    }
  }

  static void info(dynamic message) {
    if (Consts.is_development) {
      if (message is String) {
        debugPrint(message.toString());
      }
    }
  }
}
