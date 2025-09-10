import 'package:app/models/brand_model.dart';
import 'package:app/skeletons/widgets/home/home_brand_card_skeleton.dart';
import 'package:flutter/material.dart';

class HomeBrandCard extends StatelessWidget {
  final bool isLoading;
  final BrandModel? brand;
  final VoidCallback onTap;
  const HomeBrandCard({
    super.key,
    this.isLoading = false,
    required this.brand,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return isLoading
        ? HomeBrandCardSkeleton()
        : InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  child: Text(
                    brand!.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
  }
}
