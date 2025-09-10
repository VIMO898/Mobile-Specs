import 'package:app/providers/controllers/device_controller_provider.dart';
import 'package:app/providers/general/curr_tab_index_provider.dart';
import 'package:app/screens/popular_comparisons_screen.dart';
import 'package:app/screens/search_screen.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/general/custom_bottom_navbar.dart';

class MyScreen extends ConsumerStatefulWidget {
  final List<Widget> screens;
  const MyScreen({required this.screens, super.key});

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  void _handleTabIndexChange(int index) {
    ref.read(currTabIndexProvider.notifier).state = index;
  }

  void _navigateToSearchScreen(BuildContext context) {
    NavHelper.push(context, SearchScreen());
  }

  void _navigateToPopularComparisonScreen(BuildContext context) {
    NavHelper.push(context, PopularComparisonsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final currIndex = ref.watch(currTabIndexProvider);
    final devicesBeingCompared =
        ref.watch(devicesControllerProvider).comparedDevices?.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              'https://play-lh.googleusercontent.com/9P98DMjFRFZq1zL1NNrD64dVgTtbsRso3S_GTAwqI4olRQO8DcCiFnjttNfo-5lEa4e-',
              fit: BoxFit.cover,
              width: 37,
            ),
            const SizedBox(width: 6),
            const Text('Mobile Specs'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _navigateToSearchScreen(context),
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20),
          ),
          Stack(
            children: [
              IconButton(
                padding: const EdgeInsets.only(top: 6),
                onPressed: () => _navigateToPopularComparisonScreen(context),
                icon: const Icon(Icons.compare_arrows_outlined, size: 30),
              ),
              Positioned(
                right: 4,
                top: 4,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.white,
                  child: Text(
                    devicesBeingCompared.toString(),
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      // padding: const EdgeInsets.fromLTRB(9, 9, 9, 50),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: IndexedStack(index: currIndex, children: widget.screens),
      ),
      bottomSheet: CustomBottomNavbar(
        selectedIndex: currIndex,
        onSelected: _handleTabIndexChange,
        items: [
          CustomBottomNavbarItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_filled,
            label: 'Home',
          ),
          CustomBottomNavbarItem(
            icon: Icons.grid_view_outlined,
            selectedIcon: Icons.grid_view_rounded,
            label: 'Brands',
          ),
          CustomBottomNavbarItem(
            icon: Icons.favorite_border,
            selectedIcon: Icons.favorite,
            label: 'Wishlist',
          ),
          CustomBottomNavbarItem(
            icon: Icons.newspaper_outlined,
            selectedIcon: Icons.newspaper,
            label: 'News',
          ),
          CustomBottomNavbarItem(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
