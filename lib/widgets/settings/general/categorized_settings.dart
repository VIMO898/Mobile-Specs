import 'package:app/widgets/settings/general/setting_list_tile.dart';
import 'package:flutter/material.dart';

class CategorizedSettings extends StatelessWidget {
  final String title;
  final List<SettingListTile> settings;
  const CategorizedSettings(
      {super.key, required this.title, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...settings,
        const SizedBox(height: 20),
      ],
    );
  }
}
