import 'package:flutter/material.dart';

import '../../models/device_list_overview_model.dart';
import '../general/device_specs_overview_card.dart';

class BrandDeviceListView extends StatelessWidget {
  final bool isLoading;
  final bool isBackdropLoading;
  final List<DeviceDetailedOverviewModel>? devicesWithDetailedOverview;
  final void Function(String deviceName) onTap;
  const BrandDeviceListView({
    super.key,
    this.isLoading = false,
    required this.isBackdropLoading,
    required this.devicesWithDetailedOverview,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: devicesWithDetailedOverview?.length ?? 10,
          itemBuilder: (context, index) {
            final deviceOverviewSpecs = devicesWithDetailedOverview?[index];
            return DeviceSpecsOverviewCard(
              isLoading: isLoading,
              deviceOverviewInfo: deviceOverviewSpecs,
              onTap: onTap,
            );
          },
        ),
        if (isBackdropLoading)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black38,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
