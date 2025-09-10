import 'dart:developer';

import 'package:app/exceptions/custom_exception.dart';
import 'package:app/providers/repositories/auth_repository_provider.dart';
import 'package:app/utils/dialog_helper.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:app/widgets/auth/auth_app_bar.dart';
import 'package:app/widgets/auth/login_content.dart';
import 'package:app/widgets/auth/signup_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  final bool isSignupMode;
  const AuthenticationScreen({
    super.key,
    required this.isSignupMode,
    // required bool isSignInMode,
  });

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  late bool _isSignUpMode;
  late GlobalKey<FormState> _formKey;
  bool? _agreeWithTerms;
  bool _isLoading = false;
  String _email = '';
  String _username = '';
  String _password = '';
  @override
  void initState() {
    super.initState();
    _isSignUpMode = widget.isSignupMode;
    _formKey = GlobalKey<FormState>();
  }

  void _handleFormSubmission() async {
    try {
      final isFormValid = _formKey.currentState!.validate();
      if (!isFormValid) return;
      if (_isSignUpMode && _agreeWithTerms != true) {
        setState(() => _agreeWithTerms = false);
        return;
      }
      final authRepo = ref.read(authRepositoryProvider);
      if (_isSignUpMode) {
        log(
          {
            'email': _email,
            'username': _username,
            'password': _password,
          }.toString(),
        );
        if (_email.isEmpty || _username.isEmpty || _password.isEmpty) return;
        setState(() => _isLoading = true);

        await authRepo.signup(
          email: _email,
          username: _username,
          password: _password,
        );
      } else {
        log({'email': _email, 'password': _password}.toString());
        if (_email.isEmpty || _password.isEmpty) return;
        setState(() => _isLoading = true);
        await authRepo.login(email: _email, password: _password);
      }
      NavHelper.pop(context);
    } on CustomException catch (e) {
      setState(() => _isLoading = false);
      DialogHelper.showErrorDialog(
        context,
        title: 'Error: ${e.code}',
        message: e.message,
      );
    }
  }

  void _handleAuthModeUpdate(bool isSignupMode) =>
      setState(() => _isSignUpMode = isSignupMode);

  void _handleUsernameChange(String? newValue) => _username = newValue ?? '';
  void _handleEmailChange(String? newValue) => _email = newValue ?? '';
  void _handlePasswordChange(String? newValue) => _password = newValue ?? '';

  void _handleAgreementWithTerms(bool? updatedValue) {
    _agreeWithTerms =
        updatedValue ?? (_agreeWithTerms != null ? !_agreeWithTerms! : false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AuthAppBar(isSignup: _isSignUpMode),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
                  child: _isSignUpMode
                      ? SignupContent(
                          isLoading: _isLoading,
                          onFullNameChange: _handleUsernameChange,
                          onEmailChange: _handleEmailChange,
                          onPasswordChange: _handlePasswordChange,
                          agreeWithTerms: _agreeWithTerms,
                          onAgreeWithTerms: _handleAgreementWithTerms,
                          onSignupSubmission: _handleFormSubmission,
                          onUpdateAuthModeToSignup: () =>
                              _handleAuthModeUpdate(false),
                        )
                      : LoginContent(
                          isLoading: _isLoading,
                          onChangeEmail: _handleEmailChange,
                          onChangePassword: _handlePasswordChange,
                          onUpdateAuthModeToSignup: () =>
                              _handleAuthModeUpdate(true),
                          onLoginSubmission: _handleFormSubmission,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
