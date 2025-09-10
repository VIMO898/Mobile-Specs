import 'package:app/providers/repositories/gsmarena_repo_provider.dart';
import 'package:app/widgets/general/no_data_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/brands/brand_logo_card.dart';

class BrandsScreen extends ConsumerWidget {
  final bool insertAppBar;
  const BrandsScreen({super.key, this.insertAppBar = false});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: insertAppBar ? AppBar(title: Text('Brands')) : null,
      body: FutureBuilder(
        future: ref.read(gsmarenRepoProvider).getAllBrandsList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return NoDataMessage(
              icon: Icons.warning_outlined,
              title: 'Oops :(',
              subtitle:
                  'An error occurred; Please check your internet connection to continue',
            );
          }
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final brands = snapshot.data;
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 26),
            itemCount: brands?.length ?? 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 11,
              mainAxisSpacing: 11,
              mainAxisExtent: 60,
            ),
            itemBuilder: (context, index) {
              final brand = brands?[index];
              // final brandImgUrl =
              //     'assets/images/brands_logos/${brand.name.toLowerCase()}.png';
              return BrandLogoCard(isLoading: isLoading, brand: brand);
            },
          );
        },
      ),
    );
  }
}
