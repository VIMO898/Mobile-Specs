import 'package:app/utils/form_validation_helper.dart';
import 'package:flutter/material.dart';

import '../../screens/terms_and_conditions_screen.dart';
import '../../utils/nav_helper.dart';
import 'auth_text_form_field.dart';
import 'expanded_rounded_button.dart';
import 'text_with_link.dart';

class SignupContent extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onUpdateAuthModeToSignup;
  final VoidCallback onSignupSubmission;
  final void Function(String?)? onFullNameChange;
  final void Function(String?)? onEmailChange;
  final void Function(String?)? onPasswordChange;
  final bool? agreeWithTerms;
  final void Function(bool? updatedValue) onAgreeWithTerms;
  const SignupContent({
    super.key,
    required this.isLoading,
    required this.onFullNameChange,
    required this.onEmailChange,
    required this.onPasswordChange,
    required this.onSignupSubmission,
    required this.onUpdateAuthModeToSignup,
    required this.agreeWithTerms,
    required this.onAgreeWithTerms,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AuthTextFormField(
          label: 'Full Name',
          icon: Icons.person_2_outlined,
          onChange: onFullNameChange,
          validator: FormValidationHelper.validateUsername,
        ),
        AuthTextFormField(
          label: 'Email',
          icon: Icons.mail_outline,
          onChange: onEmailChange,
          validator: FormValidationHelper.validateEmail,
        ),
        AuthTextFormField(
          label: 'Password',
          icon: Icons.lock_outlined,
          isPassword: true,
          onChange: onPasswordChange,
          validator: FormValidationHelper.validatePassword,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  Checkbox(
                    fillColor: WidgetStateProperty.fromMap({
                      WidgetState.selected:
                          theme.floatingActionButtonTheme.backgroundColor,
                      WidgetState.disabled: Colors.white,
                    }),
                    value: agreeWithTerms ?? false,
                    onChanged: onAgreeWithTerms,
                  ),
                  const SizedBox(width: 6),
                  TextWithLink(
                    text: 'I agree with ',
                    linkText: 'Privacy and Terms',
                    onLinkTap: () => NavHelper.push(
                      context,
                      const TermsAndConditionsScreen(),
                    ),
                  ),
                ],
              ),
              if (agreeWithTerms == false)
                const Positioned(
                  left: 50,
                  bottom: 0,
                  child: Text(
                    'Please click the checkbox to agree',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),

        ExpandedRoundedButton(
          isLoading: isLoading,
          label: 'CREATE AN ACCOUNT',
          onPressed: onSignupSubmission,
        ),
        const SizedBox(height: 26),
        TextWithLink(
          text: 'Already have an account? ',
          linkText: 'Go to Login',
          onLinkTap: onUpdateAuthModeToSignup,
        ),

        // const SizedBox(height: 14),
        // if (_isSignUpMode)
        //   _buildTextWithLink(theme,
        //       text: 'Forgot Password? ',
        //       linkText: 'Click here',
        //       onLinkTap: () {})
      ],
    );
  }
}
