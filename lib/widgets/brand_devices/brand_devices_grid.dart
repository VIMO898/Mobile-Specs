import 'package:flutter/material.dart';

import '../../models/devices_overview_list_model.dart';
import '../../screens/brand_devices_screen.dart';
import '../general/device_card.dart';

class BrandDevicesGrid extends StatelessWidget {
  const BrandDevicesGrid({
    super.key,
    required this.scrollController,
    required this.devicesOverview,
    required this.currLayout,
    required this.isLoading,
    required this.isLoadingMore,
  });

  final ScrollController scrollController;
  final DevicesOverviewListModel? devicesOverview;
  final DevicesLayout currLayout;
  final bool isLoadingMore;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            controller: scrollController,
            itemCount: devicesOverview?.devices.length ?? 10,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: currLayout == DevicesLayout.smallGrid ? 3 : 2,
              mainAxisSpacing: 12,
              mainAxisExtent: 220,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final device = devicesOverview?.devices[index];
              return DeviceCard(
                height: 220,
                isLoading: isLoading,
                deviceOverview: device,
              );
            },
          ),
        ),
        if (isLoadingMore)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
