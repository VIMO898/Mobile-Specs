import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoDataMessage extends ConsumerWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final EdgeInsets padding;
  // final Color? iconColor;
  final String? localImgSrc;
  final VoidCallback? onRefresh;
  const NoDataMessage({
    super.key,
    this.padding = const EdgeInsets.fromLTRB(20, 0, 20, 40),
    required this.title,
    required this.subtitle,
    this.icon,
    this.localImgSrc,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      alignment: Alignment.center,
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon != null
              ? Icon(icon, size: 120)
              : localImgSrc != null
              ? Image.asset(localImgSrc!, width: 120, fit: BoxFit.cover)
              : SizedBox.shrink(),
          if (icon != null || localImgSrc != null) const SizedBox(height: 12),
          Text(title, style: textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: textTheme.titleSmall,
          ),
          if (onRefresh != null)
            TextButton.icon(
              onPressed: onRefresh,
              icon: Icon(Icons.refresh),
              label: Text('Reload'),
            ),
        ],
      ),
    );
  }
}
