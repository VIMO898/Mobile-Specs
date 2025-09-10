import 'package:app/providers/controllers/theme_state_controller.dart';
import 'package:app/screens/news_screen.dart';
import 'package:app/screens/popular_comparisons_screen.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:app/widgets/settings/general/categorized_settings.dart';
import 'package:app/widgets/settings/general/setting_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/general/curr_tab_index_provider.dart';

class GeneralSettings extends ConsumerWidget {
  const GeneralSettings({super.key});

  void _handleThemeModeChange(WidgetRef ref, bool isDarkMode) {
    ref
        .read(themeStateControllerProvider.notifier)
        .setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context, ref) {
    final isDarkMode =
        ref.watch(themeStateControllerProvider).themeMode == ThemeMode.dark;
    return CategorizedSettings(
      title: 'GENERAL SETTINGS',
      settings: [
        SettingListTile(
          leadingIcon: FontAwesomeIcons.heart,
          title: 'My Wishlist',
          onTap: () {
            ref.read(currTabIndexProvider.notifier).state = 2;
          },
        ),
        SettingListTile(
          leadingIcon: FontAwesomeIcons.bell,
          title: 'Get Notification',
          tileType: TileType.Switch,
          switchValue: false,
          onSwitchChanged: (newValue) {},
          onTap: () {},
        ),
        SettingListTile(
          leadingIcon: Icons.compare_arrows_outlined,
          title: 'Devices In Comparison',
          onTap: () {
            NavHelper.push(context, PopularComparisonsScreen());
          },
        ),
        SettingListTile(
          leadingIcon: FontAwesomeIcons.newspaper,
          title: 'Saved News Articles',
          onTap: () {
            NavHelper.push(context, NewsScreen(displaySavedNews: true));
          },
        ),
        SettingListTile(
          includeBottomDivider: false,
          leadingIcon: FontAwesomeIcons.moon,
          title: 'Dark Theme',
          tileType: TileType.Switch,
          switchValue: isDarkMode,
          onSwitchChanged: (_) => _handleThemeModeChange(ref, isDarkMode),
          onTap: () => _handleThemeModeChange(ref, isDarkMode),
        ),
      ],
    );
  }
}
