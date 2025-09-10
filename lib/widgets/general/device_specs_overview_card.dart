import 'dart:developer';

import 'package:app/providers/controllers/theme_state_controller.dart';
import 'package:app/skeletons/widgets/general/device_specs_overview_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/device_list_overview_model.dart';
import 'device_specs_overview_card/device_features_grid_view.dart';
import 'device_specs_overview_card/device_images.dart';
import 'wide_rounded_button_with_icon.dart';

class DeviceSpecsOverviewCard extends ConsumerWidget {
  final bool isLoading;
  final DeviceDetailedOverviewModel? deviceOverviewInfo;
  final void Function(String deviceName) onTap;
  const DeviceSpecsOverviewCard({
    super.key,
    this.isLoading = false,
    required this.deviceOverviewInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDarkMode =
        ref.watch(themeStateControllerProvider).themeMode == ThemeMode.dark;
    final mqs = MediaQuery.of(context).size;
    log({'isLoading': isLoading}.toString());
    return isLoading
        ? DeviceSpecsOverviewCardSkeleton()
        : GestureDetector(
            onTap: () => onTap(deviceOverviewInfo!.name),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: mqs.width * 0.62,
                            child: Text(
                              deviceOverviewInfo!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            'Launch Date: ${deviceOverviewInfo!.launchDate}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.labelMedium,
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            deviceOverviewInfo!.price,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 170,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DeviceImages(
                          width: 120,
                          height: 180,
                          productImgLinks: deviceOverviewInfo!.images,
                        ),
                        const SizedBox(width: 14),
                        // Expanded(
                        //   child: Row(
                        //     children: [
                        //       _buildDeviceHighlightFeatures(
                        //         leftSideDeviceHighlightFeatures,
                        //       ),
                        //       const SizedBox(width: 6),
                        //       _buildDeviceHighlightFeatures(
                        //         rightSideDeviceHighlightFeatures,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Expanded(
                          child: DeviceFeaturesGridView(
                            deviceOverviewInfo: deviceOverviewInfo!,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // action buttons
                  Row(
                    children: [
                      WideRoundedButtonWithIcon(
                        icon: FontAwesomeIcons.plus,
                        text: 'Compare',
                        iconColor: isDarkMode
                            ? Colors.blue.shade400
                            : Colors.blue.shade200,
                        onTap: () {},
                      ),
                      const SizedBox(width: 12),
                      WideRoundedButtonWithIcon(
                        icon: FontAwesomeIcons.solidHeart,
                        text: 'Remove',
                        iconColor: isDarkMode
                            ? Colors.red.shade400
                            : Colors.red.shade200,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
