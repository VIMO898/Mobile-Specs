import 'package:flutter/material.dart';

class SnackBarHelper {
  /// Show a Snackbar with a message
  static void show(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    int durationSeconds = 2,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final cardColor = Theme.of(context).cardColor;
    scaffoldMessenger.removeCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? cardColor,
        duration: Duration(seconds: durationSeconds),
      ),
    );
  }

  /// Show a success Snackbar
  static void showSuccess(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.green);
  }

  /// Show an error Snackbar
  static void showError(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.red);
  }

  /// Show an info Snackbar
  static void showInfo(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.blue);
  }
}
