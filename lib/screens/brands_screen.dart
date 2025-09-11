import 'dart:developer';

import 'package:app/providers/repositories/gsmarena_repo_provider.dart';
import 'package:app/widgets/general/no_data_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/brand_model.dart';
import '../widgets/brands/brand_logo_card.dart';

class BrandsScreen extends ConsumerStatefulWidget {
  final bool insertAppBar;
  const BrandsScreen({super.key, this.insertAppBar = false});

  @override
  ConsumerState<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends ConsumerState<BrandsScreen> {
  late Future<List<BrandModel>> _myFuture;

  @override
  void initState() {
    super.initState();
    _setMyFuture();
  }

  Future<void> _setMyFuture([bool refresh = false]) async {
    _myFuture = ref.read(gsmarenRepoProvider).getAllBrandsList();
    if (refresh) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.insertAppBar ? AppBar(title: Text('Brands')) : null,
      body: RefreshIndicator(
        onRefresh: () => _setMyFuture(true),
        child: FutureBuilder(
          future: _myFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return NoDataMessage(
                icon: Icons.warning_outlined,
                title: 'Oops :(',
                subtitle:
                    'An error occurred; Please check your internet connection to continue',
                onRefresh: () => _setMyFuture(true),
              );
            }
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting;
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
      ),
    );
  }
}
