import 'package:flutter/material.dart';

import '../../models/device_overview_model.dart';

class ComparedDeviceBottomAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size(double.infinity, 70);
  final List<DeviceOverviewModel> deviceOverviews;
  const ComparedDeviceBottomAppbar(this.deviceOverviews, {super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: List.generate(deviceOverviews.length, (index) {
          final deviceOverview = deviceOverviews[index];
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      deviceOverview.imgUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    deviceOverview.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: textTheme.labelMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
