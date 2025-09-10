import 'package:app/exceptions/custom_exception.dart';
import 'package:app/providers/controllers/auth_controller_provider.dart';
import 'package:app/utils/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeUsernameDialog extends ConsumerStatefulWidget {
  final String currUsername;
  final void Function(String updatedUsername) onUsernameChanged;
  const ChangeUsernameDialog({
    super.key,
    required this.currUsername,
    required this.onUsernameChanged,
  });

  @override
  ConsumerState<ChangeUsernameDialog> createState() =>
      _ChangeUsernameDialogState();
}

class _ChangeUsernameDialogState extends ConsumerState<ChangeUsernameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  bool _isUsernameBeingChanged = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.currUsername;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  Future<void> _handleSubmitChangedUsername() async {
    final isFormValid = _formKey.currentState!.validate();
    if (!isFormValid) return;
    try {
      setState(() => _isUsernameBeingChanged = true);
      await ref
          .read(authControllerProvider.notifier)
          .changeUsername(_controller.text);
      widget.onUsernameChanged(_controller.text);
      _handlePopDialog();
    } on CustomException catch (e) {
      setState(() => _isUsernameBeingChanged = false);
      SnackBarHelper.show(context, e.message);
    }
  }

  void _handlePopDialog() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, _controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 18),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Username',
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 21),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  validator: _validateUsername,
                ),
              ),
            ),
            _isUsernameBeingChanged
                ? Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _handlePopDialog,
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: _handleSubmitChangedUsername,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
