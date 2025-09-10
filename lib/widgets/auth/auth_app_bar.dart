import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class AuthAppBar extends StatelessWidget {
  final bool isSignup;
  const AuthAppBar({super.key, required this.isSignup});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 24, 12, 100),
        // decoration: BoxDecoration(color: Color(0xFF0D47A1)),
        color: Color(0xFF0D47A1),
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Text(
            'Welcome to Device Specs\n${isSignup ? "Sign Up" : "Sign In"}',
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
