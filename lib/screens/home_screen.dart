import 'package:app/exceptions/custom_exception.dart';
import 'package:app/providers/controllers/theme_state_controller.dart';
import 'package:app/screens/popular_comparisons_screen.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:app/widgets/general/no_data_message.dart';
import 'package:app/widgets/general/outlined_expanded_button.dart';
import 'package:app/widgets/home/home_device_grid_view_with_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/brand_model.dart';
import '../models/device_overview_model.dart';
import '../models/news_overview_model.dart';
import '../providers/repositories/gsmarena_repo_provider.dart';
import '../widgets/home/home_brands.dart';
import '../widgets/home/latest_news_list_view_builder.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = false;
  CustomException? _exception;
  List<BrandModel>? _brands;
  List<NewsOverviewModel>? _techNews;
  // Remember the order: latest, popular & rumored
  List<List<DeviceOverviewModel>>? _categorizedDevices;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _exception = null;
      setState(() => _isLoading = true);
      final repo = ref.read(gsmarenRepoProvider);
      final allFutures = [
        // brand
        repo.getBrandsList(),
        // news
        repo.getTechNews(),
        // tabs
        repo.getLatestDevicesOverview(),
        repo.getPopularDevicesOverview(),
        repo.getRumouredDevicesOverview(),
      ];
      final allFuturesData = await Future.wait(allFutures);
      _brands = List<BrandModel>.from(allFuturesData[0]);
      _techNews = List<NewsOverviewModel>.from(allFuturesData[1]);
      _categorizedDevices = [
        List<DeviceOverviewModel>.from(allFuturesData[2]),
        List<DeviceOverviewModel>.from(allFuturesData[3]),
        List<DeviceOverviewModel>.from(allFuturesData[4]),
      ];
      setState(() => _isLoading = false);
    } on CustomException catch (e) {
      _isLoading = false;
      _exception = e;
      setState(() {});
    }
  }

  void _navigateToPopularComparisonScreen(BuildContext context) {
    NavHelper.push(context, PopularComparisonsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode =
        ref.watch(themeStateControllerProvider).themeMode == ThemeMode.dark;
    return Scaffold(
      body: _exception != null
          ? NoDataMessage(
              title: 'Error',
              subtitle: _exception!.message,
              onRefresh: _loadData,
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HomeBrands(isLoading: _isLoading, brands: _brands),
                    LatestNewsListViewBuilder(
                      isLoading: _isLoading,
                      news: _techNews,
                    ),
                    _buildPopularComparisonButton(
                      theme,
                      isDarkMode,
                      onPressed: () =>
                          _navigateToPopularComparisonScreen(context),
                    ),
                    HomeDeviceGridViewWithTabs(
                      isLoading: _isLoading,
                      categorizedDevices: _categorizedDevices,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPopularComparisonButton(
    ThemeData theme,
    bool isDarkMode, {
    required VoidCallback onPressed,
  }) {
    return OutlinedExpandedButton(
      margin: const EdgeInsets.fromLTRB(6, 10, 8, 20),
      color: isDarkMode
          ? Colors.white
          : theme.appBarTheme.backgroundColor ?? Colors.blue.shade900,
      label: 'Popular Comparisons',
      icon: Icons.compare_arrows,

      onPressed: onPressed,
    );
  }
}
