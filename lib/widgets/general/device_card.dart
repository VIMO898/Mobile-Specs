import 'package:app/exceptions/custom_exception.dart';
import 'package:app/models/device_overview_model.dart';
import 'package:app/providers/controllers/device_controller_provider.dart';
import 'package:app/providers/controllers/device_wishlist_controller_provider.dart';
import 'package:app/repositories/devices_repository.dart';
import 'package:app/skeletons/widgets/general/device_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../screens/device_full_specifications_screen.dart';
import '../../utils/nav_helper.dart';
import '../../utils/snack_bar_helper.dart';

class DeviceCard extends ConsumerStatefulWidget {
  final DeviceOverviewModel? deviceOverview;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final bool isStaggeredHeight;
  final bool isLoading;
  const DeviceCard({
    super.key,
    required this.deviceOverview,
    this.isLoading = false,
    this.onTap,
    this.isStaggeredHeight = false,
    this.width,
    this.height,
    this.margin,
  });

  @override
  ConsumerState<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends ConsumerState<DeviceCard> {
  bool _wishlistToggleLoading = false;
  bool _comparisonToggleLoading = false;

  void _navigateToFullSpecsScreen() {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    NavHelper.push(
      context,
      DeviceFullSpecificationsScreen(widget.deviceOverview!),
    );
  }

  void _handleComparisonToggle(
    bool isCompared,
    int comparedDevicesCount,
  ) async {
    final notifier = ref.read(devicesControllerProvider.notifier);
    try {
      // adding to or removing from the comparison
      final type = DeviceType.comparedDevices;
      final device = widget.deviceOverview!;
      if (!isCompared && comparedDevicesCount >= 3) {
        SnackBarHelper.show(
          context,
          '3 Devices are already being compared.\nRemove one of those to add this.',
        );
        return;
      }
      setState(() => _comparisonToggleLoading = true);
      !isCompared
          ? await notifier.addDevice(type, device)
          : await notifier.removeDevice(type, device.id);
      if (mounted) setState(() => _comparisonToggleLoading = false);
    } on CustomException catch (_) {
      setState(() => _comparisonToggleLoading = false);
      final errorMsg =
          "Unable to ${isCompared ? 'add' : 'remove'} the device ${isCompared ? 'to' : 'from'} the comparison";
      SnackBarHelper.show(context, errorMsg);
    }
  }

  void _handleWishListToggle(bool isWishlisted) async {
    try {
      setState(() => _wishlistToggleLoading = true);
      final wishlistNotifier = ref.read(
        deviceWishlistControllerProvider.notifier,
      );
      // adding to or removing from the wishlist
      final device = widget.deviceOverview!;
      if (isWishlisted) {
        final wishlist = ref.read(devicesControllerProvider).wishlist!;
        final deviceEntryIndex = wishlist.indexWhere((d) => d.id == device.id);
        if (deviceEntryIndex == -1) return;
        final deviceEntry = wishlist[deviceEntryIndex];
        await wishlistNotifier.removeDevice(deviceEntry);
      } else {
        await wishlistNotifier.addDevice(device);
      }
      if (mounted) setState(() => _wishlistToggleLoading = false);
    } on CustomException catch (_) {
      setState(() => _wishlistToggleLoading = false);
      final errorMsg =
          "Unable to ${isWishlisted ? 'add' : 'remove'} the device ${isWishlisted ? 'to' : 'from'} the wishlist";
      SnackBarHelper.show(context, errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final userDeviceActivity = ref.watch(devicesControllerProvider);
    final isWishlisted =
        userDeviceActivity.wishlist?.any(
          (d) => d.id == widget.deviceOverview?.id,
        ) ??
        false;
    final isCompared =
        userDeviceActivity.comparedDevices?.any(
          (d) => d.id == widget.deviceOverview?.id,
        ) ??
        false;
    final comparedDevicesCount =
        userDeviceActivity.comparedDevices?.length ?? 0;
    return widget.isLoading
        ? DeviceCardSkeleton(
            width: widget.width,
            height: widget.height,
            isStaggeredHeight: widget.isStaggeredHeight,
            margin: widget.margin,
          )
        : InkWell(
            onTap: _navigateToFullSpecsScreen,
            child: Container(
              margin: widget.margin,
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: theme.cardColor,
                // border: Border.all(color: Colors.grey.shade400),
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 16),
                    child: Image.network(
                      widget.deviceOverview!.imgUrl,
                      width: 112,
                      height: widget.isStaggeredHeight ? null : 112,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.deviceOverview!.name,
                      style: textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 38,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // compare button
                          Expanded(
                            child: InkWell(
                              onTap: () => _handleComparisonToggle(
                                isCompared,
                                comparedDevicesCount,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                color: theme.dividerColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _comparisonToggleLoading
                                        ? SizedBox(
                                            width: 14,
                                            height: 14,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : isCompared
                                        ? Icon(
                                            Icons.compare_arrows,
                                            color: Colors.red,
                                            size: 20,
                                          )
                                        : const Icon(
                                            FontAwesomeIcons.plus,
                                            color: Colors.blue,
                                            size: 16,
                                          ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        _comparisonToggleLoading
                                            ? 'Loading'
                                            : isCompared
                                            ? 'Remove'
                                            : 'Compare',
                                        maxLines: 1,
                                        style: textTheme.labelMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // fav button
                          InkWell(
                            onTap: () => _handleWishListToggle(isWishlisted),
                            child: Container(
                              width: 40,
                              height: double.infinity,
                              alignment: Alignment.center,
                              // color: Colors.grey.shade50,
                              child: _wishlistToggleLoading
                                  ? SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : isWishlisted
                                  ? FaIcon(
                                      FontAwesomeIcons.solidHeart,
                                      color: Colors.red.shade600,
                                      size: 22,
                                    )
                                  : FaIcon(
                                      FontAwesomeIcons.heart,
                                      color: Colors.red.shade200,
                                      size: 22,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
