import 'package:app/utils/form_validation_helper.dart';
import 'package:flutter/material.dart';

import 'auth_text_form_field.dart';
import 'expanded_rounded_button.dart';
import 'text_with_link.dart';

class LoginContent extends StatelessWidget {
  final bool isLoading;
  final void Function(String?)? onChangeEmail;
  final void Function(String?)? onChangePassword;
  final VoidCallback onUpdateAuthModeToSignup;
  final VoidCallback onLoginSubmission;
  const LoginContent({
    super.key,
    required this.isLoading,
    required this.onChangeEmail,
    required this.onChangePassword,
    required this.onLoginSubmission,
    required this.onUpdateAuthModeToSignup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextFormField(
          label: 'Email',
          icon: Icons.mail_outline,
          onChange: onChangeEmail,
          validator: FormValidationHelper.validateEmail,
        ),
        AuthTextFormField(
          label: 'Password',
          icon: Icons.lock_outlined,
          onChange: onChangePassword,
          isPassword: true,
          validator: FormValidationHelper.validatePassword,
        ),
        const SizedBox(height: 37),
        ExpandedRoundedButton(
          isLoading: isLoading,
          label: 'SIGN IN',
          onPressed: onLoginSubmission,
        ),
        const SizedBox(height: 26),
        TextWithLink(
          text: 'Don\'t have an account? ',
          linkText: 'Sign up',
          onLinkTap: onUpdateAuthModeToSignup,
        ),
      ],
    );
  }
}
