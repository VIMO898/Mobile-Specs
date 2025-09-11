import 'dart:developer';
import 'package:app/providers/repositories/gsmarena_repo_provider.dart';
import 'package:app/skeletons/screens/comparison_screen_skeleton.dart';
import 'package:app/widgets/general/no_data_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device_overview_model.dart';
import '../models/devices_comparison_model.dart';
import '../widgets/comparison/compare_device_info.dart';
import '../widgets/comparison/compared_device_bottom_appbar.dart';
import '../widgets/comparison/device_info_panel.dart';

class ComparisonScreen extends ConsumerStatefulWidget {
  final List<String>? comparedDevices;
  const ComparisonScreen({super.key, this.comparedDevices});

  @override
  ConsumerState<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends ConsumerState<ComparisonScreen> {
  late ScrollController _scrollController;
  late Future<DevicesComparisonModel> _compareDevicesFuture;
  bool _showDeviceNamesAboveSpecs = false;
  List<DeviceOverviewModel> _deviceOverviews = [];
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScrollPosChange);
    // _deviceOverviews = ref.read(deviceComparisonControllerProvider);
    _setCompareDevicesFuture();
  }

  Future<void> _setCompareDevicesFuture([bool refresh = false]) async {
    final selectedDeviceIds = _deviceOverviews.map((d) => d.id).toList();
    _compareDevicesFuture = ref
        .read(gsmarenRepoProvider)
        .compareDevices(widget.comparedDevices ?? selectedDeviceIds);
    if (refresh) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_handleScrollPosChange);
    _scrollController.dispose();
  }

  void _handleScrollPosChange() {
    final posInPx = _scrollController.position.pixels;
    if (posInPx >= 275.0) {
      if (_showDeviceNamesAboveSpecs) return;
      _showDeviceNamesAboveSpecs = true;
      setState(() {});
    } else if (posInPx < 275.0) {
      if (!_showDeviceNamesAboveSpecs) return;
      _showDeviceNamesAboveSpecs = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparison'),
        actions: [_buildAddButton()],
        bottom: _deviceOverviews.isNotEmpty && _showDeviceNamesAboveSpecs
            ? ComparedDeviceBottomAppbar(_deviceOverviews)
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () => _setCompareDevicesFuture(true),
        child: FutureBuilder(
          future: _compareDevicesFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              log(snapshot.error.toString());
              return NoDataMessage(
                icon: Icons.error_outline,
                title: 'Unexpected Error',
                subtitle:
                    'Please make sure your internet is working properly before reloading',
                onRefresh: () => _setCompareDevicesFuture(true),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ComparisonScreenSkeleton(
                deviceCount: widget.comparedDevices?.length ?? 2,
              );
            }
            final comparison = snapshot.data!;
            _deviceOverviews = comparison.overviews;
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                DeviceInfoPanel(
                  overviews: comparison.overviews,
                  deviceCount: _deviceOverviews.length,
                ),
                CompareDeviceSpecs(
                  features: comparison.features,
                  deviceCount: _deviceOverviews.length,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white)),
        onPressed: () {},
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('ADD', style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
