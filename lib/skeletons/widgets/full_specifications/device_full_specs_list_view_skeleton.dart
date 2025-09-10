import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/shimmer_colors_model.dart';
import '../../../providers/controllers/theme_state_controller.dart';

class DeviceFullSpecsListViewSkeleton extends ConsumerWidget {
  const DeviceFullSpecsListViewSkeleton({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDarkMode =
        ref.watch(themeStateControllerProvider).themeMode == ThemeMode.dark;

    // Simulate 4 feature tables, each with 4 rows
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(4, (featureIdx) {
        return _buildFeatureTableSkeleton(theme, isDarkMode);
      }),
    );
  }

  Widget _buildFeatureTableSkeleton(ThemeData theme, bool isDarkMode) {
    final shimmerColors = theme.extension<ShimmerColorsModel>()!;
    final baseColor = shimmerColors.baseColor;
    final highlightColor = shimmerColors.highlightColor;
    return Column(
      children: [
        // Feature title skeleton
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: double.infinity,
            color: isDarkMode
                ? theme.appBarTheme.backgroundColor
                : const Color(0xFFC5CAE9),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: Container(width: 120, height: 18, color: baseColor),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(color: theme.cardColor),
          child: Table(
            columnWidths: const {
              0: FractionColumnWidth(0.35),
              1: FractionColumnWidth(0.65),
            },
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey.shade400),
              verticalInside: BorderSide(color: Colors.grey.shade400),
            ),
            children: List.generate(4, (rowIdx) {
              return TableRow(
                children: [
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        color: baseColor,
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        color: baseColor,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
