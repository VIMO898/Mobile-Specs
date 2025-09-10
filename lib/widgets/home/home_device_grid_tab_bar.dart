import 'package:app/providers/controllers/theme_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeDeviceGridTabBar extends StatelessWidget {
  final TabController tabController;
  const HomeDeviceGridTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final appBarBg = Theme.of(context).appBarTheme.backgroundColor;
    return TabBar(
      controller: tabController,
      dividerColor: Colors.transparent,
      dividerHeight: 0,
      indicatorColor: Colors.yellow.shade800,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2.5,
      labelStyle: TextStyle(
        color: appBarBg,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      tabs: [
        Tab(
          child: CustomTabItem(icon: Icons.refresh, label: 'Latest'),
        ),
        Tab(
          child: CustomTabItem(
            icon: Icons.local_fire_department,
            label: 'Popular',
          ),
        ),
        Tab(
          child: CustomTabItem(icon: Icons.campaign, label: 'Rumored'),
        ),
      ],
    );
  }
}

class CustomTabItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  const CustomTabItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDarkMode =
        ref.watch(themeStateControllerProvider).themeMode == ThemeMode.dark;

    final color = isDarkMode ? Colors.white : theme.appBarTheme.backgroundColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 6),
        Text(label, style: textTheme.labelLarge?.copyWith(color: color)),
      ],
    );
  }
}
