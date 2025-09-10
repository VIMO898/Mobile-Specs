import 'package:flutter/material.dart';

class DeviceHighlightFeature extends StatelessWidget {
  final String feature;
  final IconData icon;
  const DeviceHighlightFeature({
    super.key,
    required this.feature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 21),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            feature,
            maxLines: 4,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium?.copyWith(height: 1),
          ),
        ),
      ],
    );
  }
}
