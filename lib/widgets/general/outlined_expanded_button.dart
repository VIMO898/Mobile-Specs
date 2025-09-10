import 'package:flutter/material.dart';

class OutlinedExpandedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final Color? bgColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  const OutlinedExpandedButton({
    super.key,
    this.margin,
    this.padding,
    this.bgColor,
    required this.color,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: margin,
        padding: padding ?? const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.transparent,
          border: Border.all(color: color, width: 1.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: textTheme.labelLarge?.copyWith(
                color: color,
                wordSpacing: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
