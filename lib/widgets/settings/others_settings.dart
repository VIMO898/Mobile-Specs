import 'package:app/screens/about_us_screen.dart';
import 'package:app/screens/privacy_policy_screen.dart';
import 'package:app/screens/terms_and_conditions_screen.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:app/widgets/general/rating_dialog/rating_dialog.dart';
import 'package:app/widgets/settings/general/categorized_settings.dart';
import 'package:app/widgets/settings/general/setting_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OthersSettings extends StatelessWidget {
  const OthersSettings({super.key});

  void _navigateToAboutUsScreen(BuildContext context) {
    NavHelper.push(context, const AboutUsScreen());
  }

  void _navigateToPrivacyPolicyScreen(BuildContext context) {
    NavHelper.push(context, const PrivacyPolicyScreen());
  }

  void _navigateToTermsAndConditionsScreen(BuildContext context) {
    NavHelper.push(context, const TermsAndConditionsScreen());
  }

  void _rateTheApp(BuildContext context) {
    showDialog(context: context, builder: (context) => RatingDialog());
  }

  @override
  Widget build(BuildContext context) {
    return CategorizedSettings(
      title: 'Others',
      settings: [
        SettingListTile(
          leadingIcon: FontAwesomeIcons.star,
          title: 'Rate the app',
          onTap: () => _rateTheApp(context),
        ),
        SettingListTile(
          leadingIcon: Icons.error_outline,
          title: 'About Us',
          onTap: () => _navigateToAboutUsScreen(context),
        ),
        SettingListTile(
          leadingIcon: Icons.lock_outline,
          title: 'Privacy Policy',
          onTap: () => _navigateToPrivacyPolicyScreen(context),
        ),
        SettingListTile(
          includeBottomDivider: false,
          leadingIcon: Icons.menu_book_outlined,
          title: 'Terms & Conditions',
          onTap: () => _navigateToTermsAndConditionsScreen(context),
        ),
      ],
    );
  }
}
