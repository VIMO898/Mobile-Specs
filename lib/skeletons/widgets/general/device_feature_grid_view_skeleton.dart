import 'package:app/skeletons/widgets/general/device_highlight_feature_skeleton.dart';
import 'package:flutter/material.dart';

class DeviceFeaturesGridViewSkeleton extends StatelessWidget {
  const DeviceFeaturesGridViewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 60,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) => DeviceHighlightFeatureSkeleton(),
    );
  }
}
