import 'package:app/models/device_overview_model.dart';
import 'package:flutter/material.dart';

import 'device_card.dart';

class DeviceGridView extends StatelessWidget {
  final EdgeInsets padding;
  final int crossAxisCount;
  final ScrollPhysics? physics;
  final bool isLoading;
  final List<DeviceOverviewModel>? devices;
  final bool shrinkWrap;
  const DeviceGridView({
    super.key,
    this.padding = const EdgeInsets.all(8),
    this.crossAxisCount = 2,
    this.physics,
    this.shrinkWrap = false,
    this.isLoading = false,
    required this.devices,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      padding: padding,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      itemCount: devices?.length ?? 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        mainAxisExtent: 230,
      ),
      itemBuilder: (context, index) {
        final device = devices?[index];
        return DeviceCard(isLoading: isLoading, deviceOverview: device);
      },
    );
  }
}
