import 'package:flutter/material.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Dialog(
      backgroundColor: Colors.grey.shade300,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 22, left: 20),
            child: Row(
              children: [
                Icon(Icons.warning_sharp, size: 30, color: Colors.black),
                SizedBox(width: 6),
                Text(
                  'Internet issue',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 15),
            child: Text(
              'Please checking internet connection!',
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 14),
          Divider(height: 0, color: Colors.grey.shade700),
          Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              'Setting',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.09,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
