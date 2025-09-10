import 'package:app/models/device_overview_model.dart';
import 'package:app/widgets/general/no_data_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/repositories/gsmarena_repo_provider.dart';
import '../widgets/general/device_grid_view.dart';

class SearchResultsScreen extends ConsumerWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Results For '$query'")),
      body: FutureBuilder(
        future: ref
            .read(gsmarenRepoProvider)
            .getAllSearchedDevicesOverview(query),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return NoDataMessage(
              title: 'Unable to load',
              subtitle:
                  'Something went wrong! Please check your internet connection & try again.',
            );
          }
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final searchedDevices = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: [
                if (!isLoading && searchedDevices != null)
                  _buildFoundNumberText(context, searchedDevices),
                DeviceGridView(
                  isLoading: isLoading,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  devices: searchedDevices,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoundNumberText(
    BuildContext context,
    List<DeviceOverviewModel> searchedDevices,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
      child: Text(
        'We Found ${searchedDevices.length} device${searchedDevices.length > 1 ? "s" : ""}',
        textAlign: TextAlign.start,
        style: textTheme.titleMedium,
      ),
    );
  }
}
