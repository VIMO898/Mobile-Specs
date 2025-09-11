import 'package:app/widgets/general/device_grid_view.dart';
import 'package:app/widgets/home/home_device_grid_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/device_overview_model.dart';

class HomeDeviceGridViewWithTabs extends ConsumerStatefulWidget {
  final bool isLoading;
  final List<List<DeviceOverviewModel>>? categorizedDevices;
  const HomeDeviceGridViewWithTabs({
    super.key,
    this.isLoading = false,
    required this.categorizedDevices,
  });

  @override
  ConsumerState<HomeDeviceGridViewWithTabs> createState() =>
      _HomeDeviceGridViewState();
}

class _HomeDeviceGridViewState extends ConsumerState<HomeDeviceGridViewWithTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // _tabController.addListener(_handleUpdateWidget);
  }

  @override
  void dispose() {
    super.dispose();
    // _tabController.removeListener(_handleUpdateWidget);
    _tabController.dispose();
  }

  // void _handleUpdateWidget() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final heightForTabs = const [1750.0, 1270.0, 1995.0];
    return SizedBox(
      height: heightForTabs[_tabController.index],
      child: Column(
        children: [
          HomeDeviceGridTabBar(tabController: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(3, (index) {
                final currDevices = widget.categorizedDevices?[index];
                return DeviceGridView(
                  physics: NeverScrollableScrollPhysics(),
                  isLoading: widget.isLoading,
                  devices: currDevices,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
