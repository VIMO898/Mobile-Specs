import 'package:app/models/device_overview_model.dart';
import 'package:app/screens/device_full_specifications_screen.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrendingSearches extends ConsumerWidget {
  final List<DeviceOverviewModel> devices;
  const TrendingSearches(this.devices, {super.key});

  void _navigateToFullSpecsScreen(
    BuildContext context,
    DeviceOverviewModel device,
  ) {
    NavHelper.push(context, DeviceFullSpecificationsScreen(device));
  }

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 0, 8),
          child: Text('Trending Searches', style: TextStyle(fontSize: 20)),
        ),
        ...devices
            .take(6)
            .map(
              (d) => GestureDetector(
                onTap: () => _navigateToFullSpecsScreen(context, d),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border(
                      bottom: BorderSide(
                        width: 0.45,
                        color: theme.dividerColor,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 14,
                  ),
                  child: Text(d.name),
                ),
              ),
            ),
      ],
    );
  }
}
