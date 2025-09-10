import 'package:app/widgets/general/no_data_message.dart';
import 'package:flutter/material.dart';

import '../../models/device_overview_model.dart';
import 'device_list_tile.dart';

class SearchedResults extends StatelessWidget {
  final List<DeviceOverviewModel>? devices;
  final bool isLoading;
  final String? error;
  final VoidCallback onViewMore;
  const SearchedResults({
    super.key,
    required this.isLoading,
    required this.error,
    required this.devices,
    required this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
      padding: const EdgeInsets.all(6),
      child: error != null
          ? NoDataMessage(
              title: 'Oops! Something went wrong :(',
              subtitle: error!,
            )
          : CustomScrollView(
              slivers: [
                if (!isLoading && error == null)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'We Found ${devices!.length} device${devices!.length > 1 ? "s" : ""}',
                        textAlign: TextAlign.start,
                        style: textTheme.titleMedium,
                      ),
                    ),
                  ),
                SliverList.builder(
                  itemCount: devices?.length ?? 10,
                  itemBuilder: (context, index) {
                    final device = devices?[index];
                    return DeviceListTile(isLoading: isLoading, device: device);
                  },
                ),
                if (!isLoading && error == null)
                  SliverToBoxAdapter(
                    child: TextButton(
                      onPressed: onViewMore,
                      child: Text('View More'),
                    ),
                  ),
              ],
            ),
    );
  }

  // GestureDetector _buildCloseButton() {
  //   return GestureDetector(
  //     onTap: onClose,
  //     child: const Padding(
  //       padding: EdgeInsets.all(4),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [Icon(Icons.close), SizedBox(width: 4), Text('CLOSE')],
  //       ),
  //     ),
  //   );
  // }
}
