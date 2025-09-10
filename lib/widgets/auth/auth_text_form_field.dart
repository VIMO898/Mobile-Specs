import 'package:app/providers/controllers/theme_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthTextFormField extends ConsumerStatefulWidget {
  final String label;
  final String? initialValue;
  final void Function(String? newValue)? onChange;
  final IconData icon;
  final bool isPassword;
  final String? Function(String? value) validator;
  const AuthTextFormField({
    super.key,
    required this.label,
    required this.icon,
    required this.validator,
    this.isPassword = false,
    this.initialValue,
    this.onChange,
  });

  @override
  ConsumerState<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends ConsumerState<AuthTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        ref.watch(themeStateControllerProvider).themeMode == ThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: widget.initialValue,
        autocorrect: false,
        enableSuggestions: false,
        maxLines: 1,
        obscureText: _obscureText,
        onChanged: widget.onChange,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.label,
          filled: true,
          fillColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade300,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: OutlineInputBorder(
            gapPadding: 18,
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(40),
          ),
          prefixIcon: Icon(widget.icon, size: 30, color: Colors.grey.shade600),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
