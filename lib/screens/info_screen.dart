import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  final String screenName;
  final InlineSpan textSpan;
  const InfoScreen({
    super.key,
    required this.textSpan,
    required this.screenName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(screenName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text.rich(
          textSpan,
          style: textTheme.titleMedium?.copyWith(height: 1.45),
        ),
      ),
    );
  }
}
