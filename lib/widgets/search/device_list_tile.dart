import 'package:app/skeletons/widgets/search/device_list_tile_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/device_overview_model.dart';
import '../../screens/device_full_specifications_screen.dart';
import '../../utils/nav_helper.dart';

class DeviceListTile extends ConsumerWidget {
  final bool isLoading;
  final DeviceOverviewModel? device;
  const DeviceListTile({
    super.key,
    this.isLoading = false,
    required this.device,
  });

  void _navigateToDeviceSpecsScreen(
    BuildContext context,
    DeviceOverviewModel deviceOverview,
  ) {
    NavHelper.push(context, DeviceFullSpecificationsScreen(deviceOverview));
  }

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return isLoading
        ? DeviceListTileSkeleton()
        : GestureDetector(
            onTap: () => _navigateToDeviceSpecsScreen(context, device!),
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border(
                  bottom: BorderSide(
                    width: theme.dividerTheme.thickness!,
                    color: theme.dividerColor,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Image.network(
                    device!.imgUrl,
                    fit: BoxFit.fill,
                    height: 55,
                    width: 45,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          device!.name,
                          style: textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(device!.subtitle ?? '', style: textTheme.bodySmall),
                    ],
                  ),
                  const Spacer(),
                  const FaIcon(FontAwesomeIcons.chevronRight, size: 15),
                ],
              ),
            ),
          );
  }
}
