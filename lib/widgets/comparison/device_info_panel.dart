import 'package:flutter/material.dart';

import '../../models/device_overview_model.dart';

class DeviceInfoPanel extends StatelessWidget {
  final int deviceCount;
  final List<DeviceOverviewModel> overviews;
  const DeviceInfoPanel({
    super.key,
    required this.deviceCount,
    required this.overviews,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return SliverToBoxAdapter(
      child: Row(
        children: List.generate(deviceCount, (index) {
          final deviceOverview = overviews[index];
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border(right: BorderSide(color: theme.dividerColor)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Column(
                      children: [
                        Image.network(
                          deviceOverview.imgUrl,
                          fit: BoxFit.contain,
                          width: 100,
                          height: 150,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          deviceOverview.name,
                          textAlign: TextAlign.center,
                          style: textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(deviceOverview.subtitle ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
