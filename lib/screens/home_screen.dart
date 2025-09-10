import 'package:app/providers/controllers/theme_state_controller.dart';
import 'package:app/screens/popular_comparisons_screen.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:app/widgets/general/outlined_expanded_button.dart';
import 'package:app/widgets/home/home_device_grid_view_with_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/home/home_brands.dart';
import '../widgets/home/latest_news_list_view_builder.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _navigateToPopularComparisonScreen(BuildContext context) {
    NavHelper.push(context, PopularComparisonsScreen());
  }

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDarkMode =
        ref.watch(themeStateControllerProvider).themeMode == ThemeMode.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeBrands(),
            const LatestNewsListViewBuilder(),
            _buildPopularComparisonButton(
              theme,
              isDarkMode,
              onPressed: () => _navigateToPopularComparisonScreen(context),
            ),
            HomeDeviceGridViewWithTabs(),
          ],
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
