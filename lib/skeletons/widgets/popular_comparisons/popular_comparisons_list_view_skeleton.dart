import 'package:app/skeletons/widgets/popular_comparisons/popular_comparison_tile_skeleton.dart';
import 'package:flutter/material.dart';

class PopularComparisonsListViewSkeleton extends StatelessWidget {
  const PopularComparisonsListViewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) {
          return PopularComparisonTileSkeleton();
        },
      ),
    );
  }
}
