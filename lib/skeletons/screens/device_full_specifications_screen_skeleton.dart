import 'package:app/skeletons/widgets/full_specifications/device_full_specs_list_view_skeleton.dart';
import 'package:app/skeletons/widgets/full_specifications/device_specs_card_skeleton.dart';
import 'package:flutter/material.dart';

class DeviceFullSpecificationsScreenSkeleton extends StatelessWidget {
  const DeviceFullSpecificationsScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Column(
        children: [
          DeviceSpecsCardSkeleton(),
          const SizedBox(height: 10),
          DeviceFullSpecsListViewSkeleton(),
        ],
      ),
    );
  }
}
