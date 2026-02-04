import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

// Print Logs in console
void printLog(Object? message, {String name = '', StackTrace? stackTrace}) {
  if (kDebugMode) {
    developer.log(
      message.toString(),
      name: name,
      stackTrace: stackTrace,
    );
    // print({'name': name, 'message': message.toString()});
  } else {
    // print({'name': name, 'message': message.toString()});
    // We can send log somewhere so can understand exceptions
  }
}
