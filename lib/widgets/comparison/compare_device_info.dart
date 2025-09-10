import 'package:flutter/material.dart';

import '../../models/device_feature_model.dart';

class CompareDeviceSpecs extends StatelessWidget {
  const CompareDeviceSpecs({
    super.key,
    required this.features,
    required this.deviceCount,
  });

  final List<DeviceFeatureModel> features;
  final int deviceCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return SliverList.builder(
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                feature.name,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...List.generate(feature.specs.length, (index) {
              final spec = feature.specs[index];
              return Container(
                color: theme.cardColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        spec.name,
                        style: textTheme.titleMedium?.copyWith(
                          // color: Colors.grey.shade900,
                          // fontSize: 18,
                        ),
                      ),
                    ),
                    Table(
                      border: TableBorder(
                        top: BorderSide(color: theme.dividerColor),
                        bottom: BorderSide(color: theme.dividerColor),
                        verticalInside: BorderSide(color: theme.dividerColor),
                      ),
                      children: [
                        TableRow(
                          children: spec.values
                              .sublist(0, deviceCount)
                              .map(
                                (value) => Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    value,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
