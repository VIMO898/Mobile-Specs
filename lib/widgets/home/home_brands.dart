import 'package:app/providers/repositories/gsmarena_repo_provider.dart';
import 'package:app/screens/brand_devices_screen.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:app/widgets/home/home_brand_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/general/curr_tab_index_provider.dart';

class HomeBrands extends ConsumerWidget {
  static int itemCount = 10;
  const HomeBrands({super.key});

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
  Widget build(BuildContext context, ref) {
    return Container(
      alignment: Alignment.center,
      height: 132,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: FutureBuilder(
        future: ref.read(gsmarenRepoProvider).getBrandsList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An Error Occurred', style: TextStyle(fontSize: 24)),
            );
          }
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final brands = snapshot.data;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              mainAxisExtent: 50,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final brand = brands?[index];

              if (index + 1 == itemCount) {
                return _buildMoreButton(ref, context);
              }

              return HomeBrandCard(
                isLoading: isLoading,
                brand: brand,
                onTap: () => _navigateToBrandProductsScreen(
                  context,
                  brandName: brand!.name,
                  link: brand.link,
                ),
              );
            },
          );
        },
      ),
    );
  }

  GestureDetector _buildMoreButton(WidgetRef ref, BuildContext context) {
    return GestureDetector(
      onTap: () => ref.read(currTabIndexProvider.notifier).state = 1,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.borderAll, color: Colors.white, size: 18),
            SizedBox(width: 3),
            Text(
              'More',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
