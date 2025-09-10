import 'package:app/providers/repositories/gsmarena_repo_provider.dart';
import 'package:app/screens/comparison_screen.dart';
import 'package:app/skeletons/widgets/popular_comparisons/popular_comparisons_list_view_skeleton.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'popular_comparison_tile.dart';

class PopularComparisonListView extends ConsumerWidget {
  const PopularComparisonListView({super.key});

  void _compareDevices(BuildContext context, String first, String last) {
    NavHelper.push(context, ComparisonScreen(comparedDevices: [first, last]));
  }

  @override
  Widget build(BuildContext context, ref) {
    final gsmarenaRepo = ref.watch(gsmarenRepoProvider);

    return FutureBuilder(
      future: gsmarenaRepo.getPopularComparisons(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PopularComparisonsListViewSkeleton();
        }
        if (snapshot.hasError) {
          return Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 60),
            child: Text('An Error Occurred!', style: TextStyle(fontSize: 18)),
          );
        }
        final comparisons = snapshot.data!;
        return SizedBox(
          height: 800,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: comparisons.length,
            itemBuilder: (context, index) {
              final currComparison = comparisons[index];
              return PopularComparisonTile(
                nameA: currComparison.firstDeviceName,
                nameB: currComparison.lastDeviceName,
                onTap: () => _compareDevices(
                  context,
                  currComparison.firstDeviceId,
                  currComparison.lastDeviceId,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
