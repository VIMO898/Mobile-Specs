import 'package:app/widgets/settings/general_settings.dart';
import 'package:app/widgets/settings/my_profile_settings.dart';
import 'package:app/widgets/settings/others_settings.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const settings = [MyProfileSettings(), GeneralSettings(), OthersSettings()];
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: settings.length,
        itemBuilder: (context, index) {
          return settings[index];
        },
      ),
    );
  }
}
