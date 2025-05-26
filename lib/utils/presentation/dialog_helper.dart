import 'dart:async';

import 'package:byte_digital_test_case/main_app.dart';
import 'package:flutter/material.dart';

Future<T> showLoadingDialog<T>({
  required Future<T> Function() future,
  required Widget Function(BuildContext,) dialogBuilder,
  bool barrierDismissible = false,
}) async {
  unawaited(
    showDialog(
      context: navigatorKey.currentState!.context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return dialogBuilder(dialogContext);
      },
    ),
  );

  try {
    final result = await future();
    return result;
  } finally {
    navigatorKey.currentState!.pop();
  }
}
