import 'package:app/theming/app_themes.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:flutter/material.dart';

class DialogButtons extends StatelessWidget {
  final VoidCallback onSubmit;
  const DialogButtons({super.key, required this.onSubmit});

  void _handleGoBack(BuildContext context) {
    NavHelper.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDialogSubmitButton(theme),
        TextButton(
          onPressed: () => _handleGoBack(context),
          child: Text('No, Thanks!', style: textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildDialogSubmitButton(ThemeData theme) {
    final textTheme = theme.textTheme;
    final primaryColor = AppColors.primary;
    return Container(
      width: double.infinity,
      height: 55.0,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton(
        onPressed: onSubmit,
        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
        child: Text(
          'Submit',
          style: textTheme.titleSmall!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
