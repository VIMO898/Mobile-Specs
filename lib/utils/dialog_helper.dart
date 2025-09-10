import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DialogHelper {
  static void showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onConfirm,
  }) {
    _showAlert(
      context,
      title: title,
      message: message,
      alertType: AlertType.success,
      onConfirm: onConfirm,
    );
  }

  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onConfirm,
  }) {
    _showAlert(
      context,
      title: title,

      message: message,
      alertType: AlertType.error,
      onConfirm: onConfirm,
    );
  }

  static void showWarningDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onConfirm,
  }) {
    _showAlert(
      context,
      title: title,
      message: message,
      alertType: AlertType.warning,
      onConfirm: onConfirm,
    );
  }

  static void showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    Alert(
      context: context,
      type: AlertType.warning,
      title: title,
      style: AlertStyle(
        titleStyle: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
        descStyle: textTheme.bodyLarge!,
      ),
      desc: message,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.grey,
          child: Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          color: Colors.green,
          child: const Text("Confirm", style: TextStyle(color: Colors.white)),
        ),
      ],
    ).show();
  }

  static void _showAlert(
    BuildContext context, {
    required String title,
    required String message,
    required AlertType alertType,
    VoidCallback? onConfirm,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    Alert(
      // alertAnimation: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: ),
      context: context,
      type: alertType,
      title: title,

      desc: message,
      style: AlertStyle(
        titleStyle: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
        descStyle: textTheme.bodyLarge!,
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
            if (onConfirm != null) onConfirm();
          },
          color: Colors.blue,
          child: Text("OK", style: TextStyle(color: Colors.white)),
        ),
      ],
    ).show();
  }
}
