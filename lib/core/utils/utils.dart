import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/core/utils/debug_print.dart';

import 'package:todo/core/utils/extension.dart';
import 'package:todo/core/utils/keys.dart';
import 'package:todo/presentation/theme/app_theme.dart';
import 'package:todo/presentation/theme/text_theme.dart';
import 'package:todo/presentation/theme/theme_helper.dart';
import 'package:todo/presentation/widgets/loader.dart';
import 'package:device_trust/device_trust.dart';

void removeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

// Scaffold Message
void scaffoldMessage(
  String message, {
  Duration duration = const Duration(seconds: 3),
  bool isError = true,
  BuildContext? msgCtx,
}) {
  if (message.isEmpty) {
    return;
  }
  final color = isError ? AppTheme.redColor : AppTheme.greenColor;
  final snackBar = SnackBar(
    elevation: 0,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    backgroundColor: color,
    content: Text(message, style: const TextStyle(color: AppTheme.whiteColor)),
    shape: const RoundedRectangleBorder(),
  );
  if (msgCtx != null) {
    // printLog('Message on msgCtx');
    ScaffoldMessenger.of(msgCtx).hideCurrentSnackBar();
    ScaffoldMessenger.of(msgCtx).showSnackBar(snackBar);
  } else {
    // printLog('Message on messangerKey');
    Keys.messangerKey.currentState?.hideCurrentSnackBar();
    Keys.messangerKey.currentState?.showSnackBar(snackBar);
  }
}

Future<T?> showLoader<T>(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const PopScope(canPop: false, child: Loader()),
  );
}

// Call a method when scroll is about to end
bool onScrollNotification(Object? notification, VoidCallback callback) {
  if (notification is ScrollEndNotification) {
    // before means 0 to high
    final before = notification.metrics.extentBefore;
    final max = notification.metrics.maxScrollExtent * 0.8;
    if (before >= max && max != 0.0) {
      callback();
    }
  }
  return false;
}

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  String? title,
  String? subTitle,
  String? doneButton,
  Widget? subTitleWidget,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(
          title ?? 'Are you sure?',
          style: AppTextTheme.title.primary.semiBold,
        ),
        content: subTitleWidget ?? (subTitle == null ? null : Text(subTitle)),
        shape: rectShape,
        backgroundColor: AppTheme.whiteColor,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(doneButton ?? 'Yes'),
          ),
        ],
      );
    },
  );
}

Future<void> showPopUpMessage(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        shape: rectShape,
        backgroundColor: AppTheme.whiteColor,
        title: Text(
          message,
          style: AppTextTheme.subtitle,
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Back'),
          ),
        ],
      );
    },
  );
}

Future<bool> checkDeviceTrust() async {
  final report = await DeviceTrust.getReport();

  final compromised = kDebugMode
      ? false
      : report.rootedOrJailbroken ||
            report.fridaSuspected ||
            report.emulator ||
            report.debuggerAttached;

  if (compromised) {
    printLog('Device integrity compromised');
  } else {
    printLog('Device appears secure');
  }
  printLog('Details: ${report.details}');
  return !compromised;
}
