import 'package:app/skeletons/widgets/brands/brand_logo_card_skeleton.dart';
import 'package:flutter/material.dart';

import '../../models/brand_model.dart';
import '../../screens/brand_devices_screen.dart';
import '../../utils/nav_helper.dart';

class BrandLogoCard extends StatelessWidget {
  final bool isLoading;
  final BrandModel? brand;
  const BrandLogoCard({super.key, this.isLoading = false, required this.brand});

  void _navigateToBrandProductsScreen(
    BuildContext context, {
    required String brandName,
    required String link,
  }) {
    NavHelper.push(
      context,
      BrandDevicesScreen(brandName: brandName, link: link),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return isLoading
        ? BrandLogoCardSkeleton()
        : InkWell(
            onTap: () => _navigateToBrandProductsScreen(
              context,
              brandName: brand!.name,
              link: brand!.link,
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    brand!.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
