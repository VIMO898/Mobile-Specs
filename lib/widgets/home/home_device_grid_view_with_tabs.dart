import 'package:app/widgets/general/device_grid_view.dart';
import 'package:app/widgets/home/home_device_grid_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/device_overview_model.dart';
import '../../providers/repositories/gsmarena_repo_provider.dart';

class HomeDeviceGridViewWithTabs extends ConsumerStatefulWidget {
  const HomeDeviceGridViewWithTabs({super.key});

  @override
  ConsumerState<HomeDeviceGridViewWithTabs> createState() =>
      _HomeDeviceGridViewState();
}

class _HomeDeviceGridViewState extends ConsumerState<HomeDeviceGridViewWithTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Future> _devicesFutures;
  @override
  void initState() {
    super.initState();
    final gsmArenaRepo = ref.read(gsmarenRepoProvider);
    _devicesFutures = [
      gsmArenaRepo.getLatestDevicesOverview(),
      gsmArenaRepo.getPopularDevicesOverview(),
      gsmArenaRepo.getRumouredDevicesOverview(),
    ];
    _tabController = TabController(length: _devicesFutures.length, vsync: this);
    _tabController.addListener(_handleUpdateWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.removeListener(_handleUpdateWidget);
    _tabController.dispose();
  }

  void _handleUpdateWidget() => setState(() {});

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
              children: List.generate(_devicesFutures.length, (index) {
                final currFuture = _devicesFutures[index];
                return FutureBuilder(
                  future: currFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 65),
                        child: Text(
                          'Couldn\'t load the data!',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    final devices = snapshot.data != null
                        ? List<DeviceOverviewModel>.from(snapshot.data)
                        : null;
                    return DeviceGridView(
                      physics: NeverScrollableScrollPhysics(),
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                      devices: devices,
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
