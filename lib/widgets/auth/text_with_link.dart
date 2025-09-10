import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextWithLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onLinkTap;
  const TextWithLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text),
          TextSpan(
            text: linkText,
            recognizer: TapGestureRecognizer()..onTap = onLinkTap,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
