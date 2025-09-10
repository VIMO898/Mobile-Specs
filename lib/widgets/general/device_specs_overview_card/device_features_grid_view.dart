import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/device_list_overview_model.dart';
import 'device_highlight_feature.dart';

class DeviceFeaturesGridView extends StatelessWidget {
  const DeviceFeaturesGridView({super.key, required this.deviceOverviewInfo});

  final DeviceDetailedOverviewModel deviceOverviewInfo;

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 60,
        crossAxisSpacing: 4,
      ),
      children: [
        if (deviceOverviewInfo.processor != null)
          DeviceHighlightFeature(
            icon: FontAwesomeIcons.microchip,
            feature: deviceOverviewInfo.processor!,
          ),
        if (deviceOverviewInfo.ramStorage != null)
          DeviceHighlightFeature(
            icon: FontAwesomeIcons.memory,
            feature: deviceOverviewInfo.ramStorage!,
          ),
        if (deviceOverviewInfo.rearCam != null)
          DeviceHighlightFeature(
            icon: FontAwesomeIcons.camera,
            feature: deviceOverviewInfo.rearCam!,
          ),
        if (deviceOverviewInfo.battery != null)
          DeviceHighlightFeature(
            icon: FontAwesomeIcons.batteryHalf,
            feature: deviceOverviewInfo.battery!,
          ),
        if (deviceOverviewInfo.frontCam != null)
          DeviceHighlightFeature(
            icon: FontAwesomeIcons.imagePortrait,
            feature: deviceOverviewInfo.frontCam!,
          ),
        if (deviceOverviewInfo.software != null)
          DeviceHighlightFeature(
            icon: FontAwesomeIcons.android,
            feature: deviceOverviewInfo.software!,
          ),
        if (deviceOverviewInfo.display != null)
          DeviceHighlightFeature(
            icon: FontAwesomeIcons.mobile,
            feature: deviceOverviewInfo.display!,
          ),
        if (deviceOverviewInfo.hardware != null)
          DeviceHighlightFeature(
            icon: FontAwesomeIcons.satelliteDish,
            feature: deviceOverviewInfo.hardware!,
          ),
      ],
    );
  }
}
