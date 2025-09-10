import 'package:app/skeletons/widgets/comparison/compare_device_info_skeleton.dart';
import 'package:app/skeletons/widgets/comparison/device_info_panel_skeleton.dart';
import 'package:flutter/material.dart';

class ComparisonScreenSkeleton extends StatelessWidget {
  final int deviceCount;
  const ComparisonScreenSkeleton({super.key, required this.deviceCount});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        DeviceInfoPanelSkeleton(deviceCount: deviceCount),
        CompareDeviceSpecsSkeleton(deviceCount: deviceCount),
      ],
    );
  }
}
