import 'package:app/exceptions/custom_exception.dart';
import 'package:app/widgets/general/no_data_message.dart';
import 'package:flutter/material.dart';

import '../../models/device_overview_model.dart';
import '../../skeletons/widgets/popular_comparisons/compared_device_card_skeleton.dart';
import 'compared_device_card.dart';

class DevicesInComparisonGrid extends StatelessWidget {
  const DevicesInComparisonGrid({
    super.key,
    required this.devicesBeingCompared,
    this.isLoading = false,
    this.exception,
  });
  final bool isLoading;
  final CustomException? exception;
  final List<DeviceOverviewModel>? devicesBeingCompared;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 210,
      child: exception != null
          ? NoDataMessage(title: 'Unable to load', subtitle: exception!.message)
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 210,
                crossAxisSpacing: 14,
              ),
              itemCount: 3,
              itemBuilder: (context, index) {
                if (isLoading) return ComparedDeviceCardSkeleton();
                final device = index <= devicesBeingCompared!.length - 1
                    ? devicesBeingCompared![index]
                    : null;
                return ComparedDeviceCard(deviceOverview: device);
              },
            ),
    );
  }
}
