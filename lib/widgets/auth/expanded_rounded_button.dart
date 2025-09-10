import 'package:flutter/material.dart';

class ExpandedRoundedButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;
  const ExpandedRoundedButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.linear,
        height: 50,
        width: isLoading ? 50 : MediaQuery.of(context).size.width - 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: theme.appBarTheme.backgroundColor,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : FittedBox(
                child: Text(
                  label,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.015,
                  ),
                ),
              ),
      ),
    );
  }
}
