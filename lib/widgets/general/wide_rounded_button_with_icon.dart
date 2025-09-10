import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WideRoundedButtonWithIcon extends StatelessWidget {
  const WideRoundedButtonWithIcon({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme.dividerColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, color: iconColor, size: 22),
              const SizedBox(width: 8),
              Text(
                text,
                style: textTheme.bodyLarge?.copyWith(
                  // color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
