import 'dart:developer';

import 'package:app/models/device_overview_model.dart';
import 'package:app/providers/controllers/device_controller_provider.dart';
import 'package:app/repositories/devices_repository.dart';
import 'package:app/screens/brands_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../exceptions/custom_exception.dart';
import '../../screens/device_full_specifications_screen.dart';
import '../../utils/nav_helper.dart';
import '../../utils/snack_bar_helper.dart';

class ComparedDeviceCard extends ConsumerStatefulWidget {
  final DeviceOverviewModel? deviceOverview;
  const ComparedDeviceCard({super.key, required this.deviceOverview});

  @override
  ConsumerState<ComparedDeviceCard> createState() => _ComparedDeviceCardState();
}

class _ComparedDeviceCardState extends ConsumerState<ComparedDeviceCard> {
  bool _isDeviceBeingRemoved = false;

  void _handleOnTap(BuildContext context) {
    if (widget.deviceOverview == null) {
      NavHelper.push(context, BrandsScreen(insertAppBar: true));
      return;
    }
    NavHelper.push(
      context,
      DeviceFullSpecificationsScreen(widget.deviceOverview!),
    );
  }

  Future<void> _handleRemoveDevice() async {
    log('remove button clicked');
    final deviceId = widget.deviceOverview!.id;
    setState(() => _isDeviceBeingRemoved = true);
    try {
      await ref
          .read(devicesControllerProvider.notifier)
          .removeDevice(DeviceType.comparedDevices, deviceId);
      setState(() => _isDeviceBeingRemoved = false);
    } on CustomException catch (e) {
      setState(() => _isDeviceBeingRemoved = false);
      SnackBarHelper.showError(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return InkWell(
      onTap: !_isDeviceBeingRemoved ? () => _handleOnTap(context) : null,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 4),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _isDeviceBeingRemoved
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      widget.deviceOverview != null
                          ? Image.network(
                              widget.deviceOverview!.imgUrl,
                              fit: BoxFit.fill,
                            )
                          : Expanded(child: Icon(Icons.add_circle, size: 80)),
                      const SizedBox(height: 6),
                      // const Spacer(),
                      Flexible(
                        child: Text(
                          widget.deviceOverview?.name ?? 'Add a Device',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: textTheme.titleSmall?.copyWith(height: 1.225),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
          if (widget.deviceOverview != null)
            Positioned(
              top: 0,
              left: 0,
              child: _buildCloseButton(widget.deviceOverview!.id),
            ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(String deviceId) {
    return SizedBox(
      width: 25,
      height: 25,
      child: InkWell(
        onTap: _handleRemoveDevice,
        child: Icon(Icons.close, size: 20, color: Colors.grey.shade700),
      ),
    );
  }
}
