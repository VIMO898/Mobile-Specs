import 'package:app/models/device_overview_model.dart';
import 'package:app/screens/reviews_and_ratings_screen.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../exceptions/custom_exception.dart';
import '../../models/device_feature_model.dart';
import '../../models/device_specs_model.dart';
import '../../providers/controllers/device_controller_provider.dart';
import '../../providers/controllers/device_wishlist_controller_provider.dart';
import '../../repositories/devices_repository.dart';
import '../../utils/snack_bar_helper.dart';

class DeviceSpecsCard extends ConsumerStatefulWidget {
  final DeviceOverviewModel deviceOverview;
  final DeviceSpecsModel deviceSpecs;
  const DeviceSpecsCard({
    super.key,
    required this.deviceOverview,
    required this.deviceSpecs,
  });

  @override
  ConsumerState<DeviceSpecsCard> createState() => _DeviceSpecsCardState();
}

class _DeviceSpecsCardState extends ConsumerState<DeviceSpecsCard> {
  bool _wishlistToggleLoading = false;
  bool _comparisonToggleLoading = false;

  void _handleComparisonToggle(
    bool isCompared,
    int comparedDevicesCount,
  ) async {
    final notifier = ref.read(devicesControllerProvider.notifier);
    try {
      // adding to or removing from the comparison
      final type = DeviceType.comparedDevices;
      final device = widget.deviceOverview;
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
      setState(() => _comparisonToggleLoading = false);
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
      final device = widget.deviceOverview;
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

  void _handleShareDeviceLink() {
    final deviceLink = 'https://www.gsmarena.com/${widget.deviceOverview.link}';
    final sharePlus = SharePlus.instance;
    sharePlus.share(
      ShareParams(
        subject: widget.deviceOverview.name,
        title: widget.deviceOverview.name,
        uri: Uri.parse(deviceLink),
      ),
    );
  }

  void _handleNavigationToReviewsScreen(BuildContext context) {
    NavHelper.push(
      context,
      ReviewsAndRatingsScreen(device: widget.deviceOverview),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userDeviceActivity = ref.watch(devicesControllerProvider);
    final isWishlisted =
        userDeviceActivity.wishlist?.any(
          (d) => d.id == widget.deviceOverview.id,
        ) ??
        false;
    final isCompared =
        userDeviceActivity.comparedDevices?.any(
          (d) => d.id == widget.deviceOverview.id,
        ) ??
        false;
    final comparedDevicesCount =
        userDeviceActivity.comparedDevices?.length ?? 0;
    return Column(
      children: [
        _buildHeader(isWishlisted),
        _buildDivider(),
        DecoratedBox(
          decoration: BoxDecoration(color: theme.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: Row(
                  children: [
                    _buildDeviceImage(),
                    _buildDivider(vertical: true),
                    _buildVerticalIconLabelButtons(
                      isCompared,
                      comparedDevicesCount,
                    ),
                  ],
                ),
              ),
              _buildDivider(),
              _buildDevicePriceText(),
            ],
          ),
        ),
      ],
    );
  }

  Padding _buildDevicePriceText() {
    final textTheme = Theme.of(context).textTheme;
    final price =
        findSpecValue(widget.deviceSpecs.features, 'Misc', 'Price') ??
        'UnConfirmed';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      child: Text(
        price,
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Expanded _buildDeviceImage() {
    return Expanded(
      child: Container(
        height: 280,
        padding: const EdgeInsets.symmetric(
          // vertical: 15,
          horizontal: 18,
        ),
        child: Image.network(
          widget.deviceSpecs.overview.imgUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  SizedBox _buildVerticalIconLabelButtons(
    bool isCompared,
    int comparedDevicesCount,
  ) {
    final primaryColor = Theme.of(context).primaryColor;
    return SizedBox(
      width: 105,
      child: Column(
        children: [
          _buildIVerticalIconLabelButton(
            isLoading: _comparisonToggleLoading,
            icon: isCompared ? Icons.compare_arrows : Icons.add,
            iconColor: isCompared ? primaryColor : null,
            label: _comparisonToggleLoading
                ? 'Loading'
                : isCompared
                ? 'Remove'
                : 'Compare',
            onTap: () =>
                _handleComparisonToggle(isCompared, comparedDevicesCount),
          ),
          _buildDivider(),
          _buildIVerticalIconLabelButton(
            icon: Icons.star_outline_outlined,
            label: 'Rating',
            onTap: () => _handleNavigationToReviewsScreen(context),
          ),
          _buildDivider(),
          _buildIVerticalIconLabelButton(
            icon: Icons.share,
            label: 'Share',
            onTap: _handleShareDeviceLink,
          ),
        ],
      ),
    );
  }

  Widget _buildIVerticalIconLabelButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    bool isLoading = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(icon, size: 30, color: iconColor),
            const SizedBox(height: 3),
            Text(label, style: textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider({bool vertical = false}) =>
      vertical ? const VerticalDivider(width: 0) : const Divider(height: 0);

  Widget _buildHeader(bool isWishlisted) {
    final mqs = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final deviceName = widget.deviceOverview.name;
    final status =
        findSpecValue(
          widget.deviceSpecs.features,
          'Launch',
          'Status',
        )?.split('.')[0] ??
        'N/A';
    return Container(
      color: theme.cardColor,
      height: 90,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // device name
              SizedBox(
                width: mqs.width * 0.7,
                child: Text(
                  deviceName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    height: 1.112,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // status
              Text(status, style: textTheme.labelLarge),
            ],
          ),
          // like/wishlist button
          IconButton(
            onPressed: () => _handleWishListToggle(isWishlisted),
            icon: _wishlistToggleLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 1.8),
                  )
                : Icon(
                    isWishlisted
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: isWishlisted ? Colors.red : null,
                    size: 27,
                  ),
          ),
        ],
      ),
    );
  }
}

String? findSpecValue(
  List<DeviceFeatureModel> features,
  String featureName,
  String specName,
) {
  String? value;
  for (final feature in features) {
    if (feature.name == featureName) {
      for (final spec in feature.specs) {
        if (spec.name == specName) {
          value = spec.values[0];
        }
      }
    }
  }
  return value;
}
