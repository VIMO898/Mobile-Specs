import 'dart:developer';

import 'package:app/exceptions/custom_exception.dart';
import 'package:app/providers/controllers/auth_controller_provider.dart';
import 'package:app/screens/authentication_screen.dart';
import 'package:app/utils/dialog_helper.dart';
import 'package:app/widgets/settings/general/categorized_settings.dart';
import 'package:app/widgets/settings/general/change_username_dialog.dart';
import 'package:app/widgets/settings/general/setting_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/nav_helper.dart';

class MyProfileSettings extends ConsumerStatefulWidget {
  const MyProfileSettings({super.key});

  @override
  ConsumerState<MyProfileSettings> createState() => _MyProfileSettingsState();
}

class _MyProfileSettingsState extends ConsumerState<MyProfileSettings> {
  String _username = '';
  @override
  void initState() {
    super.initState();
    _username = ref.read(authControllerProvider)?.displayName ?? '';
  }

  void _navigateToAuthScreen() {
    NavHelper.push(context, const AuthenticationScreen(isSignupMode: true));
  }

  void _handleUserLogout() {
    DialogHelper.showConfirmationDialog(
      context,
      title: 'Logout',
      message: 'Are you sure you want to log out of this account?',
      onConfirm: () async {
        try {
          await ref.read(authControllerProvider.notifier).logout();
        } on CustomException catch (e) {
          DialogHelper.showErrorDialog(
            context,
            title: 'Logout Error',
            message: e.message,
          );
        }
      },
    );
  }

  void _handleUsernameChange(String updatedUsername) =>
      setState(() => _username = updatedUsername);

  void _showChangeNameDialog() {
    showDialog(
      context: context,
      builder: (_) => ChangeUsernameDialog(
        currUsername: _username,
        onUsernameChanged: _handleUsernameChange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    log((user?.displayName ?? 'null').toString());
    return CategorizedSettings(
      title: 'MY PROFILE',
      settings: user == null
          ? [
              SettingListTile(
                includeBottomDivider: false,
                leadingIcon: Icons.accessibility_new_outlined,
                title: 'Login',
                onTap: _navigateToAuthScreen,
              ),
            ]
          : [
              SettingListTile(
                leadingIcon: Icons.person_outlined,
                title: _username.isEmpty ? 'Username' : _username,
                onTap: () {},
                tileType: TileType.None,
                // includeBottomDivider: false,
              ),
              SettingListTile(
                leadingIcon: Icons.email_outlined,
                title: user.email!,
                onTap: () {},
                tileType: TileType.None,
                // includeBottomDivider: false,
              ),
              SettingListTile(
                leadingIcon: Icons.badge_outlined,
                title: 'Update Name',
                onTap: _showChangeNameDialog,
                tileType: TileType.ForwardArrow,
                // includeBottomDivider: false,
              ),
              SettingListTile(
                leadingIcon: Icons.logout_outlined,
                title: 'Logout',
                onTap: _handleUserLogout,
                tileType: TileType.ForwardArrow,
                includeBottomDivider: false,
              ),
            ],
    );
  }
}
