import 'package:flutter/material.dart';

class SnackBarHelper {
  /// Show a Snackbar with a message
  static void show(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    int durationSeconds = 2,
    SnackBarAction? action,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final cardColor = Theme.of(context).cardColor;
    scaffoldMessenger.removeCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? cardColor,
        duration: Duration(seconds: durationSeconds),
        action: action,
      ),
    );
  }

  /// Show a success Snackbar
  static void showSuccess(
    BuildContext context,
    String message, [
    SnackBarAction? action,
  ]) {
    show(context, message, backgroundColor: Colors.green, action: action);
  }

  /// Show an error Snackbar
  static void showError(
    BuildContext context,
    String message, [
    SnackBarAction? action,
  ]) {
    show(context, message, backgroundColor: Colors.red, action: action);
  }

  /// Show an info Snackbar
  static void showInfo(
    BuildContext context,
    String message, [
    SnackBarAction? action,
  ]) {
    show(context, message, backgroundColor: Colors.blue, action: action);
  }
}
