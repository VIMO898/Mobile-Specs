import 'package:app/providers/controllers/theme_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/device_specs_model.dart';

class DeviceFullSpecsListView extends ConsumerWidget {
  final DeviceSpecsModel deviceSpecs;
  const DeviceFullSpecsListView(this.deviceSpecs, {super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDarkMode =
        ref.watch(themeStateControllerProvider).themeMode == ThemeMode.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: deviceSpecs.features.map((feature) {
        return _buildFeatureTable(
          isDarkMode: isDarkMode,
          theme: theme,
          title: feature.name,
          children: feature.specs
              .map((spec) => {spec.name: spec.values[0]})
              .toList(),
        );
      }).toList(),
    );
  }

  Widget _buildFeatureTable({
    required bool isDarkMode,
    required ThemeData theme,
    required String title,
    required List<Map<String, String>> children,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: isDarkMode
              ? theme.appBarTheme.backgroundColor
              : const Color(0xFFC5CAE9),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(color: theme.cardColor),
          child: Table(
            columnWidths: const {
              0: FractionColumnWidth(0.35),
              1: FractionColumnWidth(0.65),
            },
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey.shade400),
              verticalInside: BorderSide(color: Colors.grey.shade400),
            ),
            children: children
                .map(
                  (c) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          c.keys.first,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          c.values.first,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
